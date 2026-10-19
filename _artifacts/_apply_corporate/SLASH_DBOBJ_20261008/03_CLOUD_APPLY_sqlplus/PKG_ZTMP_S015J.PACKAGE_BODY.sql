-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_ZTMP_S015J — 사내 현재 원문(적용본, 사내 LAST_DDL 2026-10-08 16:52:39, 2672줄)
CREATE OR REPLACE PACKAGE BODY PKG_ZTMP_S015J
IS
    /* ============================================================
       P_SSP0015_GET_SHIPMENT_PSI_COMMENTS
       AS-IS SSP0015_GET_SHIPMENT_PSI_COMMENTS - 결과셋 2벌(NOTE · Prod Qty)
       ※ AS-IS 는 FN_GET_IN_STR 로 IN 리스트를 만들어 EXEC 로 돌린다.
          선택조건 조립뿐이라 정적 SQL 로 옮겼다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI_COMMENTS
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_COMMENTS
         * Description  : Shipment Plan Confrim COMMENTS LOAD
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2019/08/09   MCTHEJ		   [CSR ID:4061695] SSP 시스템 개선 요청건(Shipment Plan)
         * 2023/08/03   jilee          AS BEFORE_QTY, AS GAP 조건 변경
         * 2026.09.16   AJS            MSSQL -> Oracle 전환 (동적 SQL -> 정적 SQL)
         *
         ex) EXEC PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_COMMENTS('40','20190811','','','20190809','20191031', ...)
         */
    BEGIN

        /* Note Load */
        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.FROM_SITE                                                              AS SITE
             , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')        AS FROM_SITE_NM
             , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN B.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
             , A.ITEM_ID
             , SUBSTR(A.YYYYMMDD, 1, 4) || '-' || SUBSTR(A.YYYYMMDD, 5, 2) || '-' || SUBSTR(A.YYYYMMDD, 7, 2) AS YYYYMMDD
             , CEIL(NVL(SUM(A.USER_ADD_QTY), 0))                                        AS USER_ADD_QTY
             , NVL(SUM(B.QTY), 0)                                                       AS QTY
--             , CEIL(NVL(SUM(TO_NUMBER(A.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR)), 0)) AS BEFORE_QTY
             , CEIL(NVL(SUM(ROUND(TO_NUMBER(A.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR))), 0)) AS BEFORE_QTY   -- 2026.09.17 AJS
--             , NVL(SUM(B.QTY), 0) - CEIL(NVL(SUM(TO_NUMBER(A.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR)), 0)) AS GAP
             , NVL(SUM(B.QTY), 0) - CEIL(NVL(SUM(ROUND(TO_NUMBER(A.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR))), 0)) AS GAP   -- 2026.09.17 AJS
             , NVL(A.COMMENTS, '')                                                      AS COMMENTS
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM SSP_ANL_SHIP_PLAN_40_WH_IN_CMT A
             , SSP_ANL_SHIP_PLAN_40 B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.FROM_SITE   = B.FROM_SITE
           AND A.ITEM_ID     = B.ITEM_ID
           AND A.YYYYMMDD    = B.YYYYMMDD
           AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND B.MEASURE             = 'WH_IN'
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                 OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                 OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
         GROUP BY A.DIVISION_ID
             , B.ORIGIN_FROM_DIVISION_ID
             , A.FROM_SITE
             , A.ITEM_ID
             , A.YYYYMMDD
             , A.COMMENTS
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE;

        /* Prod Qty Load */
        OPEN O_RC2 FOR
        SELECT DIVISION_ID
             , FROM_SITE                                                                AS SITE
             , ITEM_ID
             , SUBSTR(YYYYMMDD, 1, 4) || '-' || SUBSTR(YYYYMMDD, 5, 2) || '-' || SUBSTR(YYYYMMDD, 7, 2) AS YYYYMMDD
             , NVL(ATTRIBUTE3, '')                                                      AS PRODUCT_QTY
          FROM SSP_ANL_SHIP_PLAN_40
         WHERE 1 = 1
           /* AS-IS : (ATTRIBUTE3 IS NOT NULL OR ATTRIBUTE3 != '') - 뒷항은 Oracle 에서 늘 거짓이라 앞항만 남긴다 */
           AND ATTRIBUTE3 IS NOT NULL
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND MEASURE             = 'PROD_PLAN'
           AND YYYYMMDD >= P_FROM_YYYYMMDD
           AND YYYYMMDD <= P_TO_YYYYMMDD
           AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                 OR DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                 OR ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
         GROUP BY DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , ATTRIBUTE3;

    END P_SSP0015_GET_SHIPMENT_PSI_COMMENTS;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_PSI
       AS-IS SSP0015_GET_SHIPMENT_PSI - 화면 본체
       ※ #Tmp_RowData -> GT_SSP0015_ROWDATA
       ※ #TblDynamicTitlest_SSP0015 는 SCM_MST_TITLESET_USER 를 같은 조건으로 다시 읽는 것과
          결과가 같아 GTT 를 두지 않고 원본 테이블을 직접 참조한다.
       ※ 마지막 피벗은 조회기간만큼 날짜 칸을 만들므로 정적 SQL 로 옮길 수 없다.
          AS-IS 는 SUM 피벗(수치)과 MAX 피벗(LOT 문자)을 UNION ALL 로 합친다. 형태를 유지한다.
       ※ NOTE · Prod Qty 는 AS-IS 가 SSP0015_GET_SHIPMENT_PSI_COMMENTS 를 호출해 결과셋 2벌을 덧붙인다.
          O_RC2 · O_RC3 로 같은 벌 수를 맞춘다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PROGRAM_ID            IN  VARCHAR2,
        P_SHEET_NAME            IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_SEQ                   IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI
         * Description  : Shipment PSI(Small)
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2019/03/05   AYJ            Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
         * 2019/05/16   AYJ            [CSR:] MST_MEASURE DEFAULT_FLAG='N', 유져 셋팅 없을 시 화면에 노출되지 않도록 수정
         * 2019/06/17   AYJ            조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
         * 2019/08/05   MCTHEJ         [CSR ID:4045693] measure 'LOT'의 문자값에 대한 PIVOT 처리 추가
         * 2019/08/09   MCTHEJ         [CSR ID:4061695] SSP 시스템 개선 요청건(Shipment Plan) - NOTE 추가
         * 2019/08/28   AYJ            조회 조건 추가(p_delegateeChk)
         * 2019/12/17   KIMYONGHO      BOH 조정 (이름 변경 및 추가) EX) TOTAL -> oWMS
         * 2020/09/23   KIMYONGHO      WH_STOCK BOH 수량에서 CHANGE_STATUS 'Delete' 제외 ('D')
         * 2020/10/22   KIMYONGHO      POUCH_WH_IN_DAY LOOKUP에 해당하는 내용은 L/T = LOOKUP의 SEGMENT2 값 적용
         * 2021/11/01   KIMYONGHO      @p_real_flag 구분 조회
         * 2022/11/14   jilee          DM_PLN_SHIPMENT_REQ -> SITE_TYPE ='SALES' 주석처리
         * 2023/09/21   jilee          G182-P (Group='P',OSP='N')조회 추가
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         */
        V_PLAN_VERSION_DATE     VARCHAR2(8 CHAR);
        V_REAL_FLAG             VARCHAR2(1 CHAR);
        V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR) := P_PLAN_START_YYYYMMDD;
        V_CNT_USR_MEASURE       PLS_INTEGER := 0;
        V_PLAN_TYPE             VARCHAR2(30 CHAR) := 'SP';
        V_SEQ                   PLS_INTEGER := 1;
        V_FROM_SITE             VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_DATA_START_YYYYMMDD   VARCHAR2(8 CHAR);
        V_DATA_END_YYYYMMDD     VARCHAR2(8 CHAR);
        V_MQUERY                CLOB := EMPTY_CLOB();   /* SUM 피벗 칸 */
        V_MQUERY1               CLOB := EMPTY_CLOB();   /* MAX 피벗 칸(LOT) */
        V_MEXEC                 CLOB;
        V_LT_SUB                VARCHAR2(4000 CHAR);
        V_YIELD_SUB             VARCHAR2(4000 CHAR);
        V_LTYN_SUB              VARCHAR2(4000 CHAR);
        V_FIGURE_EXP            VARCHAR2(4000 CHAR);
    BEGIN

        /* GTT 초기화 - TRUNCATE 금지 */
        DELETE FROM GT_SSP0015_ROWDATA;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        BEGIN
            SELECT PLAN_START_YYYYMMDD
              INTO V_PLAN_VERSION_DATE
              FROM (SELECT PLAN_START_YYYYMMDD
                      FROM SSP_PLAN_VERSION_V
                     WHERE DIVISION_ID = '40'
                     GROUP BY PLAN_START_YYYYMMDD
                     ORDER BY PLAN_START_YYYYMMDD DESC)
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_PLAN_VERSION_DATE := NULL;
        END;

        IF V_PLAN_VERSION_DATE = V_PLAN_START_YYYYMMDD THEN
            V_REAL_FLAG := 'Y';
        ELSE
            V_REAL_FLAG := 'N';
        END IF;

        V_DIVISION_ID := P_DIVISION_ID;
--        V_ITEM_ID     := P_ITEM_ID;
        /* AS-IS 는 대소문자 무시 · 뒤공백 무시 비교 */   -- 2026.09.17 AJS
        V_ITEM_ID     := UPPER(RTRIM(P_ITEM_ID));   -- 2026.09.17 AJS
        V_FROM_SITE   := P_FROM_SITE;

        /* AS-IS : IF LEN(@p_from_site) > 6 SET @p_from_site = ''; */
        IF LENGTH(RTRIM(NVL(V_FROM_SITE, ''))) > 6 THEN
            V_FROM_SITE := '';
        END IF;

        /* DATA 생성 시작 일자 (당일) · 마지막 일자 12주(84일) */
        V_DATA_START_YYYYMMDD := V_PLAN_START_YYYYMMDD;
        V_DATA_END_YYYYMMDD   := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 84, 'YYYYMMDD');

        /* -------------1------------ 기준 원장 적재 */
        INSERT INTO GT_SSP0015_ROWDATA
               (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
              , YYYYMMDD, BOD_ID, QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE, PROJECT_CODE
              , FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE, ETA_DATE, CONFIRM_ID
              , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID
              , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE10)
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TO_SITE
             , A.MEASURE
             , A.YYYYMMDD
             , A.BOD_ID
             , A.QTY
             , A.ROUTE_ID
             , A.INCOTERMS
             , A.TRANSPORT_MODE
             , A.BIZ_TYPE
             , A.PROJECT_CODE
             , A.FCST_TYPE
             , A.FCST_ETD_DATE
             , A.FCST_ETA_DATE
             , A.ETD_DATE
             , A.ETA_DATE
             , A.CONFIRM_ID
             , A.ORIGIN_FROM_DIVISION_ID
             , A.ORIGIN_TO_DIVISION_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE10
          FROM SSP_ANL_SHIP_PLAN_40 A
             , SSP_MST_MODEL_USER TT3
         WHERE TT3.DIVISION_ID(+) = A.DIVISION_ID
           AND TT3.FROM_SITE(+)   = A.FROM_SITE
           AND TT3.ITEM_ID(+)     = A.ITEM_ID
           AND TT3.VALID_YN(+)    = 'Y'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
--           AND A.SEQ                 = P_SEQ
           AND A.SEQ                 = TO_NUMBER(P_SEQ)   -- 2026.09.17 AJS
           AND (V_ITEM_ID IS NULL OR A.ITEM_ID = V_ITEM_ID)
           AND (V_FROM_SITE IS NULL
                 AND A.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI', 'A010A_G182A_G182P')))
                 OR A.FROM_SITE = V_FROM_SITE)
           AND ((V_REAL_FLAG = 'Y' AND A.MEASURE NOT IN ('SHIP_REQ', 'SHIP_CONFIRM', 'WH_STOCK', 'BALANCE'))
                 OR (V_REAL_FLAG = 'N' AND A.MEASURE IN ('BALANCE', 'INCO_WIP', 'INSP_WIP', 'LOT', 'MES_FCS_HOLD'
                                                       , 'MES_FCS_RELEASE', 'POSTP_PLAN', 'PROD_DATE', 'PROD_PLAN'
                                                       , 'SHIP_CONFIRM', 'SHIP_REQ', 'WH_IN', 'WH_STOCK')))
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND EXISTS (SELECT 1
                         FROM (SELECT Z.DIVISION_ID, Z.SEQ, Z.ITEM_ID, Z.FROM_SITE, SUM(Z.QTY) AS QTY
                                 FROM SSP_ANL_SHIP_PLAN_40 Z
                                WHERE Z.DIVISION_ID         = P_DIVISION_ID
                                  AND Z.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                                GROUP BY Z.DIVISION_ID, Z.SEQ, Z.ITEM_ID, Z.FROM_SITE) B
                        WHERE A.DIVISION_ID = B.DIVISION_ID
                          AND A.SEQ         = B.SEQ
                          AND A.ITEM_ID     = B.ITEM_ID
                          AND A.FROM_SITE   = B.FROM_SITE
                          AND B.QTY        <> 0)
           AND ((P_NONCHK = 'Y' AND 1 = 1)
--                 OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                 OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END FROM DUAL   -- 2026.09.17 AJS
                                     UNION
                                    SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                      FROM SSP_MST_DELEGATE
                                     WHERE VALID_YN = 'Y'
--                                       AND DELEGATEE_ID = P_USER_ID
                                       AND DELEGATEE_ID = LOWER(P_USER_ID)   -- 2026.09.17 AJS
                                     GROUP BY USER_ID)
--                 OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                 OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END   -- 2026.09.17 AJS
--                 OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END);
                 OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END);   -- 2026.09.17 AJS

        IF V_REAL_FLAG = 'Y' THEN

            /* -------------2------------ [S]SHIP_REQ : MKT 담당자가 출하요청한 수량 */
            INSERT INTO GT_SSP0015_ROWDATA
                   (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                  , YYYYMMDD, BOD_ID, QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE, PROJECT_CODE
                  , FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE, ETA_DATE, CONFIRM_ID
                  , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID
                  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE10)
            SELECT R.DIVISION_ID
                 , V_PLAN_START_YYYYMMDD
                 , V_PLAN_TYPE
                 , V_SEQ
                 , R.ITEM_ID
                 , R.FROM_SITE
                 , R.TO_SITE
                 , 'SHIP_REQ'
                 , R.YYYYMMDD
                 , R.BOD_ID
                 , SUM(R.QTY)
                   /* AS-IS ISNULL(S.ROUTE_ID,'-') - 적재 칸이 숫자라 '-' 는 넣을 수 없다. NULL 그대로 둔다. */
                 , S.ROUTE_ID
                 , NVL(S.SSP_INCOTERMS, R.INCOTERMS)
                 , R.TRANSPORT_MODE
                 , R.BIZ_TYPE
                 , R.PROJECT_CODE
                 , R.FCST_TYPE
                 , R.FCST_ETD_DATE
                 , R.FCST_ETA_DATE
                 , R.ETD_DATE
                 , R.ETA_DATE
                 , R.CONFIRM_ID
                 , R.DIVISION_ID
                 , R.DIVISION_ID
                 , NULL   /* ATTRIBUTE1 - PROD_DATE */
                 , R.CREATED_BY   /* ATTRIBUTE2 - REQUESTOR */
                 , NULL, NULL, NULL, NULL, NULL
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
                         , CASE WHEN INSTR(R.PLANT_SITE_ID, '-') = 0 THEN 'A'
                                ELSE SUBSTR(R.PLANT_SITE_ID, INSTR(R.PLANT_SITE_ID, '-') + 1, 1) END AS BIZ_TYPE
                         , R.PROJECT_CODE
                         , R.FCST_TYPE
                         , R.YYYYMMDD       AS FCST_ETD_DATE
                         , NULL             AS FCST_ETA_DATE
                         , R.YYYYMMDD       AS ETD_DATE
                         , NULL             AS ETA_DATE
                         , R.ATTRIBUTE10    AS CONFIRM_ID
                         , R.CREATED_BY
                      FROM DM_PLN_SHIPMENT_REQ R
                         , SSP_MST_MODEL_USER TT3
                     WHERE TT3.DIVISION_ID(+) = R.DIVISION_ID
                       AND TT3.FROM_SITE(+)   = R.PLANT_SITE_ID
                       AND TT3.ITEM_ID(+)     = R.ITEM_ID
                       AND TT3.VALID_YN(+)    = 'Y'
                       AND R.DIVISION_ID = V_DIVISION_ID
                       AND (V_ITEM_ID IS NULL OR R.ITEM_ID = V_ITEM_ID)
                       AND R.MEASURE     = 'SHIP_REQ'
                       AND (V_FROM_SITE IS NULL
                             AND R.PLANT_SITE_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI', 'A010A_G182A_G182P')))
                             OR R.PLANT_SITE_ID = V_FROM_SITE)
                       AND R.YYYYMMDD >= V_DATA_START_YYYYMMDD
                       AND R.YYYYMMDD <= P_TO_YYYYMMDD
                       AND R.QTY > 0
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
--                             OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                             OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END FROM DUAL   -- 2026.09.17 AJS
                                                 UNION
                                                SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                  FROM SSP_MST_DELEGATE
                                                 WHERE VALID_YN = 'Y'
--                                                   AND DELEGATEE_ID = P_USER_ID
                                                   AND DELEGATEE_ID = LOWER(P_USER_ID)   -- 2026.09.17 AJS
                                                 GROUP BY USER_ID)
--                             OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END   -- 2026.09.17 AJS
--                             OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                             OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END)   -- 2026.09.17 AJS
                   ) R
                   /* AS-IS 의 ON S.INCOTERMS <> S.SSP_INCOTERMS 는 외부조인 대상 자체에 대한 조건이라
                      (+) 표기로는 ORA-01416 이 난다. 인라인 뷰로 먼저 걸러 같은 결과를 만든다. */
                 , (SELECT DIVISION_ID, FROM_SITE, BOD_ID, ROUTE_ID, SSP_INCOTERMS
                      FROM SCP_MST_BOD_N_V
                     WHERE INCOTERMS <> SSP_INCOTERMS) S
             WHERE S.DIVISION_ID(+)  = R.DIVISION_ID
               AND S.FROM_SITE(+)    = R.FROM_SITE
               AND S.BOD_ID(+)       = R.BOD_ID
               AND R.DIVISION_ID = V_DIVISION_ID
               AND R.MEASURE     = 'SHIP_REQ'
               AND (V_FROM_SITE IS NULL
                     AND R.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI', 'A010A_G182A_G182P')))
                     OR R.FROM_SITE = V_FROM_SITE)
               AND R.YYYYMMDD >= V_DATA_START_YYYYMMDD
               AND R.YYYYMMDD <= P_TO_YYYYMMDD
             GROUP BY R.DIVISION_ID
                 , R.ITEM_ID
                 , R.FROM_SITE
                 , R.TO_SITE
                 , R.YYYYMMDD
                 , R.BOD_ID
                   /* AS-IS ISNULL(S.ROUTE_ID,'-') - 적재 칸이 숫자라 '-' 는 넣을 수 없다. NULL 그대로 둔다. */
                 , S.ROUTE_ID
                 , NVL(S.SSP_INCOTERMS, R.INCOTERMS)
                 , R.TRANSPORT_MODE
                 , R.BIZ_TYPE
                 , R.PROJECT_CODE
                 , R.FCST_TYPE
                 , R.FCST_ETD_DATE
                 , R.FCST_ETA_DATE
                 , R.ETD_DATE
                 , R.ETA_DATE
                 , R.CONFIRM_ID
                 , R.CREATED_BY;

            /* -------------3------------ [S]SHIP_CONFIRM : 출하 확정 수량 */
            INSERT INTO GT_SSP0015_ROWDATA
                   (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                  , YYYYMMDD, BOD_ID, QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE, PROJECT_CODE
                  , FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE, ETA_DATE, CONFIRM_ID
                  , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID
                  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE10)
            SELECT A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.ITEM_ID
                 , A.FROM_SITE
                 , A.TO_SITE
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.BOD_ID
                 , SUM(A.QTY)
                 , A.ROUTE_ID
                 , A.INCOTERMS
                 , A.TRANSPORT_MODE
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.FCST_TYPE
                 , A.FCST_ETD_DATE
                 , MAX(A.FCST_ETA_DATE)
                 , A.ETD_DATE
                 , MAX(A.ETA_DATE)
                 , MAX(A.CONFIRM_ID)
                 , A.ORIGIN_FROM_DIVISION_ID
                 , A.ORIGIN_TO_DIVISION_ID
                 , NULL
                 , MAX(A.ATTRIBUTE2)
                 , NULL, NULL, NULL, NULL, NULL
              FROM (
                    SELECT C.DIVISION_ID                        AS DIVISION_ID
                         , V_PLAN_START_YYYYMMDD                AS PLAN_START_YYYYMMDD
                         , V_PLAN_TYPE                          AS PLAN_TYPE
                         , V_SEQ                                AS SEQ
                         , C.ITEM_ID                            AS ITEM_ID
                         , C.FROM_SITE                          AS FROM_SITE
                         , C.TO_SITE                            AS TO_SITE
                         , 'SHIP_CONFIRM'                       AS MEASURE
                         , C.YYYYMMDD                           AS YYYYMMDD
                         , C.BOD_ID                             AS BOD_ID
                         , C.QTY                                AS QTY
                         , C.ROUTE_ID                           AS ROUTE_ID
                         , NVL(S.SSP_INCOTERMS, C.INCOTERMS)    AS INCOTERMS
                         , C.TRANSPORT_MODE                     AS TRANSPORT_MODE
                         , C.BIZ_TYPE                           AS BIZ_TYPE
                         , C.PROJECT_CODE                       AS PROJECT_CODE
                         , C.FCST_TYPE                          AS FCST_TYPE
                         , C.FCST_ETD_DATE                      AS FCST_ETD_DATE
                         , C.FCST_ETA_DATE                      AS FCST_ETA_DATE
                         , C.ETD_DATE                           AS ETD_DATE
                         , C.ETA_DATE                           AS ETA_DATE
                         , C.CONFIRM_ID                         AS CONFIRM_ID
                         , C.DIVISION_ID                        AS ORIGIN_FROM_DIVISION_ID
                         , C.DIVISION_ID                        AS ORIGIN_TO_DIVISION_ID
                         , C.REQUESTOR                          AS ATTRIBUTE2
                      FROM SSP_ANL_SHIP_CONFIRM C
                         , (SELECT DIVISION_ID, FROM_SITE, BOD_ID, SSP_INCOTERMS
                              FROM SCP_MST_BOD_N_V
                             WHERE INCOTERMS <> SSP_INCOTERMS) S
                         , SSP_MST_MODEL_USER TT3
                     WHERE S.DIVISION_ID(+)  = C.DIVISION_ID
                       AND S.FROM_SITE(+)    = C.FROM_SITE
                       AND S.BOD_ID(+)       = C.BOD_ID
                       AND TT3.DIVISION_ID(+) = C.DIVISION_ID
                       AND TT3.FROM_SITE(+)   = C.FROM_SITE
                       AND TT3.ITEM_ID(+)     = C.ITEM_ID
                       AND TT3.VALID_YN(+)    = 'Y'
                       AND C.DIVISION_ID = V_DIVISION_ID
                       AND (V_FROM_SITE IS NULL
                             AND C.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI', 'A010A_G182A_G182P')))
                             OR C.FROM_SITE = V_FROM_SITE)
--                       AND (V_ITEM_ID IS NULL OR C.ITEM_ID = V_ITEM_ID)
                       AND (V_ITEM_ID IS NULL OR UPPER(C.ITEM_ID) = V_ITEM_ID)   -- 2026.09.17 AJS
                       AND C.CHANGE_TYPE = 'C'
                       AND C.BIZ_TYPE   <> 'E'   /* 전극제외 */
                       AND C.QTY > 0
                       AND C.YYYYMMDD >= V_DATA_START_YYYYMMDD
                       AND C.YYYYMMDD <= P_TO_YYYYMMDD
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
--                             OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                             OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END FROM DUAL   -- 2026.09.17 AJS
                                                 UNION
                                                SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                  FROM SSP_MST_DELEGATE
                                                 WHERE VALID_YN = 'Y'
--                                                   AND DELEGATEE_ID = P_USER_ID
                                                   AND DELEGATEE_ID = LOWER(P_USER_ID)   -- 2026.09.17 AJS
                                                 GROUP BY USER_ID)
--                             OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END   -- 2026.09.17 AJS
--                             OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                             OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END)   -- 2026.09.17 AJS
                    UNION ALL
                    SELECT R.DIVISION_ID
                         , V_PLAN_START_YYYYMMDD
                         , V_PLAN_TYPE
                         , V_SEQ
                         , R.ITEM_ID
                         , R.PLANT_SITE_ID
                         , R.SCM_SITE_ID
                         , 'SHIP_CONFIRM'
                         , R.YYYYMMDD
                         , R.BOD_ID
                         , R.QTY
                         , S.ROUTE_ID
                         , R.INCOTERMS
                         , R.TRANSPORT_MODE
                         , CASE WHEN INSTR(R.PLANT_SITE_ID, '-') = 0 THEN 'A'
                                ELSE SUBSTR(R.PLANT_SITE_ID, INSTR(R.PLANT_SITE_ID, '-') + 1, 1) END
                         , R.PROJECT_CODE
                         , R.FCST_TYPE
                         , R.YYYYMMDD
                         , NULL
                         , R.YYYYMMDD
                         , NULL
                         , R.ATTRIBUTE10
                         , R.DIVISION_ID
                         , R.DIVISION_ID
                         , NULL
                      FROM DM_PLN_SHIPMENT_REQ R
                         , SCP_MST_BOD_N_V S
                         , SSP_MST_MODEL_USER TT3
                     WHERE S.DIVISION_ID = R.DIVISION_ID
                       AND S.FROM_SITE   = R.PLANT_SITE_ID
                       AND S.BOD_ID      = R.BOD_ID
                       AND TT3.DIVISION_ID(+) = R.DIVISION_ID
                       AND TT3.FROM_SITE(+)   = R.PLANT_SITE_ID
                       AND TT3.ITEM_ID(+)     = R.ITEM_ID
                       AND TT3.VALID_YN(+)    = 'Y'
                       AND R.DIVISION_ID = V_DIVISION_ID
                       AND (V_ITEM_ID IS NULL OR R.ITEM_ID = V_ITEM_ID)
                       AND R.MEASURE     = 'SHIP_REQ'
                       AND (V_FROM_SITE IS NULL
                             AND R.PLANT_SITE_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI', 'A010A_G182A_G182P')))
                             OR R.PLANT_SITE_ID = V_FROM_SITE)
                       AND R.YYYYMMDD > (CASE WHEN NVL(FN_GET_SSP_ANL_SHIP_FROZEN(R.DIVISION_ID, R.PLANT_SITE_ID), 0) = 0
                                              THEN V_PLAN_START_YYYYMMDD
                                              ELSE TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                                           + FN_GET_SSP_ANL_SHIP_FROZEN(R.DIVISION_ID, R.PLANT_SITE_ID) - 1, 'YYYYMMDD') END)
                       AND R.YYYYMMDD <= P_TO_YYYYMMDD
                       AND R.QTY > 0
                       AND R.ATTRIBUTE10 IS NULL
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
--                             OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                             OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END FROM DUAL   -- 2026.09.17 AJS
                                                 UNION
                                                SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                  FROM SSP_MST_DELEGATE
                                                 WHERE VALID_YN = 'Y'
--                                                   AND DELEGATEE_ID = P_USER_ID
                                                   AND DELEGATEE_ID = LOWER(P_USER_ID)   -- 2026.09.17 AJS
                                                 GROUP BY USER_ID)
--                             OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END   -- 2026.09.17 AJS
--                             OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                             OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END)   -- 2026.09.17 AJS
                   ) A
             WHERE 1 = 1
             GROUP BY A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.ITEM_ID
                 , A.FROM_SITE
                 , A.TO_SITE
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.BOD_ID
                 , A.ROUTE_ID
                 , A.INCOTERMS
                 , A.TRANSPORT_MODE
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.FCST_TYPE
                 , A.FCST_ETD_DATE
                 , A.ETD_DATE
                 , A.ORIGIN_FROM_DIVISION_ID
                 , A.ORIGIN_TO_DIVISION_ID;

            /* -------------4------------ [I]WH_STOCK */
            INSERT INTO GT_SSP0015_ROWDATA
                   (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                  , YYYYMMDD, BOD_ID, QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE, CONFIRM_ID
                  , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID)
            SELECT Z.DIVISION_ID
                 , Z.PLAN_START_YYYYMMDD
                 , Z.PLAN_TYPE
                 , Z.SEQ
                 , Z.ITEM_ID
                 , Z.FROM_SITE
                 , '-'
                 , 'WH_STOCK'
                 , Z.YYYYMMDD
                 , '-'
                   /* 전일 WH_IN , 전일 SHIP_CONFIRM 누적 */
                 , (CASE WHEN V_PLAN_START_YYYYMMDD < Z.YYYYMMDD
                         THEN (SELECT NVL(SUM(CASE X.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * NVL(X.QTY, 0)
                                                             WHEN 'POSTP_PLAN'      THEN -1 * NVL(X.QTY, 0)
                                                             WHEN 'MES_FCS_HOLD'    THEN -1 * NVL(X.QTY, 0)
                                                             WHEN 'WH_IN'           THEN      NVL(X.QTY, 0)
                                                             WHEN 'MES_FCS_RELEASE' THEN      NVL(X.QTY, 0)
                                                        ELSE 0.0 END), 0)
                                 FROM GT_SSP0015_ROWDATA X
                                WHERE 1 = 1
                                  AND X.DIVISION_ID         = Z.DIVISION_ID
                                  AND X.PLAN_START_YYYYMMDD = Z.PLAN_START_YYYYMMDD
                                  AND X.PLAN_TYPE           = Z.PLAN_TYPE
                                  AND X.SEQ                 = Z.SEQ
                                  AND X.ITEM_ID             = Z.ITEM_ID
                                  AND X.FROM_SITE           = Z.FROM_SITE
                                  AND X.MEASURE IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
                                  AND X.YYYYMMDD >= V_DATA_START_YYYYMMDD
                                  AND X.YYYYMMDD  < Z.YYYYMMDD)
                         ELSE 0 END)
                   /* 당일 OWMS 재고 */
                   + NVL(BOH.QTY, 0)
                   /* 2020.09.09 KBK : POUCH_WH_IN_DAY 처리 */
                   - (CASE WHEN V_PLAN_START_YYYYMMDD <= Z.YYYYMMDD
                           THEN CASE WHEN NVL(B.SEGMENT3, '/') = 'P' THEN NVL(B.WH_IN_QTY2, 0) ELSE 0 END
                           ELSE 0 END)
                   /* HOLD 재고 제외 */
                   - NVL((SELECT SUM(H.HOLD_QTY)
                            FROM SSP_ANL_HOLD_STOCK H
                               , SCM_SYS_CALENDAR_M C
                           WHERE H.DIVISION_ID         = V_DIVISION_ID
                             AND H.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                             AND H.PLAN_TYPE           = V_PLAN_TYPE
                             AND H.SEQ                 = V_SEQ
                             AND C.BASIS_YYYYMMDD >= H.HOLD_YYYYMMDD
                             AND C.BASIS_YYYYMMDD <= H.RELEASE_YYYYMMDD
                             AND C.BASIS_YYYYMMDD >= V_DATA_START_YYYYMMDD
                             AND C.BASIS_YYYYMMDD  < V_DATA_END_YYYYMMDD
                             AND H.DIVISION_ID = Z.DIVISION_ID
                             AND H.FROM_SITE   = Z.FROM_SITE
                             AND H.ITEM_ID     = Z.ITEM_ID
                             AND C.BASIS_YYYYMMDD = Z.YYYYMMDD
                           GROUP BY H.DIVISION_ID, H.FROM_SITE, H.ITEM_ID, C.BASIS_YYYYMMDD), 0) AS QTY
                 , '/'
                 , '-'
                 , '/'
                 , '/'
                 , '-'
                 , Z.DIVISION_ID
                 , Z.DIVISION_ID
              FROM (
                    SELECT DISTINCT
                           P.DIVISION_ID
                         , P.PLAN_START_YYYYMMDD
                         , P.PLAN_TYPE
                         , P.SEQ
                         , P.ITEM_ID
                         , P.FROM_SITE
                         , P.YYYYMMDD
                      FROM GT_SSP0015_ROWDATA P
                     WHERE 1 = 1
                       AND P.DIVISION_ID         = V_DIVISION_ID
                       AND P.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND P.PLAN_TYPE           = V_PLAN_TYPE
                       AND P.SEQ                 = V_SEQ
                       AND P.MEASURE IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
                       AND P.YYYYMMDD >= V_DATA_START_YYYYMMDD
                       AND P.YYYYMMDD <= P_TO_YYYYMMDD
                   ) Z
                 , (SELECT XA.DIVISION_ID
                         , XA.PLAN_START_YYYYMMDD
                         , XA.PLAN_TYPE
                         , XA.SEQ
                         , XA.FROM_SITE
                         , XA.ITEM_ID
                         , SUM(XA.QTY) AS QTY
                      FROM (
                            SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.FROM_SITE, A.ITEM_ID
                                 , (CASE WHEN NVL(C.SEGMENT3, '/') = 'P' THEN SUM(A.LOT_QTY_MES) ELSE 0 END) AS QTY
                              FROM SSP_ANL_MES_FCS_STOCK_40_C A
                                 , SCP_MST_FINAL_ITEM B
                                 , SCM_ADM_LOOKUP_MASTER_DETAIL C
                             WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                               AND B.ITEM_ID(+)     = A.ITEM_ID
                               AND C.LOOKUP_TYPE(+) = 'CELL_TYPE_CODE'
                               AND C.VALID_YN(+)    = 'Y'
                               AND C.SEGMENT1(+)    = B.CELL_TYPE_GROUP_CODE
                               AND A.DIVISION_ID         = V_DIVISION_ID
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND A.PLAN_TYPE           = V_PLAN_TYPE
                               AND A.SEQ                 = V_SEQ
                               AND A.AVAILABLE_YN       <> 'N'
                               AND NVL(A.CHANGE_STATUS, '-') <> 'D'
                             GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.FROM_SITE, A.ITEM_ID, C.SEGMENT3
                            UNION ALL
                            SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.FROM_SITE, A.ITEM_ID
                                 , SUM(A.AVAILABLE_QTY) AS QTY
                              FROM SSP_ANL_OWMS_STOCK_C A
                             WHERE 1 = 1
                               AND A.DIVISION_ID         = V_DIVISION_ID
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND A.PLAN_TYPE           = V_PLAN_TYPE
                               AND A.SEQ                 = V_SEQ
                             GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.FROM_SITE, A.ITEM_ID
                            UNION ALL
                            /* STORAGE ID : B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 외주 재고 */
                            SELECT T.DIVISION_ID, T.PLAN_START_YYYYMMDD, T.PLAN_TYPE, T.SEQ, T.SCM_SITE_ID, T.ITEM_ID
                                 , ROUND(SUM(T.QTY), 0) AS QTY
                              FROM SSP_ANL_TCO_STOCK_C T
                             WHERE 1 = 1
                               AND T.DIVISION_ID         = V_DIVISION_ID
                               AND T.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND T.PLAN_TYPE           = V_PLAN_TYPE
                               AND T.SEQ                 = V_SEQ
                             GROUP BY T.DIVISION_ID, T.PLAN_START_YYYYMMDD, T.PLAN_TYPE, T.SEQ, T.ITEM_ID, T.SCM_SITE_ID
                           ) XA
                     GROUP BY XA.DIVISION_ID, XA.PLAN_START_YYYYMMDD, XA.PLAN_TYPE, XA.SEQ, XA.FROM_SITE, XA.ITEM_ID) BOH
                 , (SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.ITEM_ID, A.FROM_SITE
                         , SUM(A.QTY) AS WH_IN_QTY2, C.SEGMENT3
                      FROM GT_SSP0015_ROWDATA A
                         , SCP_MST_FINAL_ITEM B
                         , SCM_ADM_LOOKUP_MASTER_DETAIL C
                         , SCM_ADM_LOOKUP_MASTER_DETAIL D
                     WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                       AND B.ITEM_ID(+)     = A.ITEM_ID
                       AND C.LOOKUP_TYPE = 'CELL_TYPE_CODE'
                       AND C.VALID_YN    = 'Y'
                       AND C.SEGMENT3    = 'P'
                       AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
                       AND D.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
                       AND D.SEGMENT1    = SUBSTR(A.ITEM_ID, 1, 3)
                       AND D.VALID_YN    = 'Y'
                       AND A.DIVISION_ID         = V_DIVISION_ID
                       AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE           = V_PLAN_TYPE
                       AND A.SEQ                 = V_SEQ
                       AND A.MEASURE  = 'WH_IN'
                       AND A.YYYYMMDD > V_DATA_START_YYYYMMDD
                       AND A.YYYYMMDD <= TO_CHAR(TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                                                 + TO_NUMBER(D.SEGMENT2 DEFAULT NULL ON CONVERSION ERROR), 'YYYYMMDD')
                       AND V_REAL_FLAG = 'Y'
                     GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.ITEM_ID, A.FROM_SITE, C.SEGMENT3) B
             WHERE Z.DIVISION_ID         = BOH.DIVISION_ID(+)
               AND Z.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD(+)
               AND Z.PLAN_TYPE           = BOH.PLAN_TYPE(+)
               AND Z.SEQ                 = BOH.SEQ(+)
               AND Z.ITEM_ID             = BOH.ITEM_ID(+)
               AND Z.FROM_SITE           = BOH.FROM_SITE(+)
               AND Z.DIVISION_ID         = B.DIVISION_ID(+)
               AND Z.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD(+)
               AND Z.PLAN_TYPE           = B.PLAN_TYPE(+)
               AND Z.SEQ                 = B.SEQ(+)
               AND Z.ITEM_ID             = B.ITEM_ID(+)
               AND Z.FROM_SITE           = B.FROM_SITE(+);

            /* -------------5------------ [I]BALANCE : 당일 WH_STOCK - 당일 SHIP_CONFIRM - 당일 POSTP_PLAN */
            INSERT INTO GT_SSP0015_ROWDATA
                   (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                  , YYYYMMDD, BOD_ID, QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE, CONFIRM_ID
                  , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID)
            SELECT B.DIVISION_ID
                 , B.PLAN_START_YYYYMMDD
                 , B.PLAN_TYPE
                 , B.SEQ
                 , B.ITEM_ID
                 , B.FROM_SITE
                 , B.TO_SITE
                 , 'BALANCE'
                 , B.YYYYMMDD
                 , B.BOD_ID
                 , B.QTY - (SELECT SUM(C.QTY)
                              FROM GT_SSP0015_ROWDATA C
                             WHERE 1 = 1
                               AND B.DIVISION_ID         = C.DIVISION_ID
                               AND B.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD
                               AND B.PLAN_TYPE           = C.PLAN_TYPE
                               AND B.SEQ                 = C.SEQ
                               AND B.ITEM_ID             = C.ITEM_ID
                               AND B.FROM_SITE           = C.FROM_SITE
                               AND B.YYYYMMDD            = C.YYYYMMDD
                               AND C.MEASURE IN ('SHIP_CONFIRM', 'POSTP_PLAN')
                             GROUP BY C.DIVISION_ID, C.PLAN_START_YYYYMMDD, C.PLAN_TYPE, C.SEQ
                                    , C.ITEM_ID, C.FROM_SITE, C.YYYYMMDD) AS QTY
                 , B.INCOTERMS
                 , B.TRANSPORT_MODE
                 , B.PROJECT_CODE
                 , B.FCST_TYPE
                 , '-'
                 , B.DIVISION_ID
                 , B.DIVISION_ID
              FROM GT_SSP0015_ROWDATA B
             WHERE 1 = 1
               AND B.DIVISION_ID         = V_DIVISION_ID
               AND B.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND B.PLAN_TYPE           = V_PLAN_TYPE
               AND B.SEQ                 = V_SEQ
               AND B.MEASURE = 'WH_STOCK';

        END IF;

        /* 빈 칸(측정항목 x 날짜) 을 0 으로 채운다 */
        INSERT INTO GT_SSP0015_ROWDATA
               (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
              , YYYYMMDD, BOD_ID, QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE, CONFIRM_ID
              , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID)
        SELECT SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.ITEM_ID
             , SUB.FROM_SITE
             , SUB.TO_SITE
             , SUB.MEASURE
             , SUB.YYYYMMDD
             , SUB.BOD_ID
             , 0
             , SUB.INCOTERMS
             , SUB.TRANSPORT_MODE
             , SUB.PROJECT_CODE
             , SUB.FCST_TYPE
             , SUB.CONFIRM_ID
             , SUB.DIVISION_ID
             , SUB.DIVISION_ID
          FROM (
                SELECT B.DIVISION_ID
                     , B.PLAN_START_YYYYMMDD
                     , B.PLAN_TYPE
                     , B.SEQ
                     , B.ITEM_ID
                     , B.FROM_SITE
                     , '-'          AS TO_SITE
                     , C.MEASURE    AS MEASURE
                     , A.YYYYMMDD
                     , '-'          AS BOD_ID
                     , '-'          AS INCOTERMS
                     , '-'          AS TRANSPORT_MODE
                     , '-'          AS PROJECT_CODE
                     , '-'          AS FCST_TYPE
                     , '-'          AS CONFIRM_ID
                  FROM (SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                          FROM SCM_SYS_CALENDAR_M C
                         WHERE 1 = 1
                           AND C.BASIS_YYYYMMDD >= V_DATA_START_YYYYMMDD
                           AND C.BASIS_YYYYMMDD <= P_TO_YYYYMMDD) A
                     , (SELECT DISTINCT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE
                          FROM GT_SSP0015_ROWDATA) B
                     , (SELECT COLUMN_NAME AS MEASURE
                          FROM SCM_MST_SHEET_MEASURE
                         WHERE 1 = 1
                           AND PROGRAM_ID = P_PROGRAM_ID
                           AND SHEET_NAME = P_SHEET_NAME
                           AND VALID_YN   = 'Y') C
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM GT_SSP0015_ROWDATA Z
                            WHERE 1 = 1
                              AND Z.DIVISION_ID         = SUB.DIVISION_ID
                              AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD
                              AND Z.PLAN_TYPE           = SUB.PLAN_TYPE
                              AND Z.SEQ                 = SUB.SEQ
                              AND Z.ITEM_ID             = SUB.ITEM_ID
                              AND Z.FROM_SITE           = SUB.FROM_SITE
                              AND Z.MEASURE             = SUB.MEASURE
                              AND Z.YYYYMMDD            = SUB.YYYYMMDD);

        /* PIVOT 대상 날짜문자열 생성 (AS-IS 는 수치 SUM 피벗과 LOT 문자 MAX 피벗 두 벌을 UNION ALL 한다) */
        DBMS_LOB.CREATETEMPORARY(V_MQUERY, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_MQUERY1, TRUE);

        FOR C IN (
            SELECT IA.YYYYMMDD
              FROM (
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                         , A.BASIS_START_DATE || '21'           AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM                AS YYYYMMDD
                         , MIN(A.BASIS_START_DATE) || '01'       AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                    UNION ALL
                    SELECT 'D_' || A.BASIS_YYYYMMDD              AS YYYYMMDD
                         , A.BASIS_YYYYMMDD || '31'              AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMMDD
                   ) IA
             ORDER BY IA.SORT_ORDER_NO)
        LOOP
            /* 수치 SUM 피벗 - 결과는 문자로 돌려준다(AS-IS CONVERT(NVARCHAR(100), ...)) */
            DBMS_LOB.APPEND(V_MQUERY,
--                ', TO_CHAR(TRUNC(SUM(CASE WHEN A.PIVOT_KEY = ''' || C.YYYYMMDD || ''' THEN NVL(A.QTY_NUM, 0) ELSE 0 END))) AS ' || C.YYYYMMDD || CHR(10));
                ', TO_CHAR(SUM(CASE WHEN A.PIVOT_KEY = ''' || C.YYYYMMDD || ''' THEN TRUNC(A.QTY_NUM) END)) AS ' || C.YYYYMMDD || CHR(10));   -- 2026.09.17 AJS
            /* LOT 문자 MAX 피벗 */
            DBMS_LOB.APPEND(V_MQUERY1,
                ', MAX(CASE WHEN A.PIVOT_KEY = ''' || C.YYYYMMDD || ''' THEN A.QTY_STR END) AS ' || C.YYYYMMDD || CHR(10));
        END LOOP;

        /* LT_DAY · YEILD · LT_UPDATE_YN 스칼라 서브쿼리 */
--        V_LT_SUB := '(SELECT NVL(TO_CHAR(CASE WHEN XB.SEGMENT2 IS NULL THEN XA.LT_FORMATION + NVL(XA.ATTRIBUTE1, 0)'
        V_LT_SUB := 'NVL((SELECT TO_CHAR(CASE WHEN TRIM(XB.SEGMENT2) IS NULL THEN XA.LT_FORMATION + NVL(XA.ATTRIBUTE1, 0)'   -- 2026.09.17 AJS
--                 || ' ELSE TO_NUMBER(XB.SEGMENT2 DEFAULT NULL ON CONVERSION ERROR) END), '' '')'
                 || ' ELSE TRUNC(TO_NUMBER(XB.SEGMENT2 DEFAULT NULL ON CONVERSION ERROR)) END)'   -- 2026.09.17 AJS
                 || ' FROM SSP_ANL_FORMATION_C XA, SCM_ADM_LOOKUP_MASTER_DETAIL XB'
                 || ' WHERE XB.LOOKUP_TYPE(+) = ''POUCH_WH_IN_DAY'' AND XB.VALID_YN(+) = ''Y'''
                 || ' AND XB.SEGMENT1(+) = SUBSTR(XA.ITEM_ID, 1, 3) AND XB.SEGMENT3(+) = ''-'''
                 || ' AND XB.SEGMENT4(+) = ''-'' AND XB.SEGMENT5(+) = ''-'''
                 || ' AND XA.DIVISION_ID = A.DIVISION_ID AND XA.PLANT_SITE_ID = A.FROM_SITE AND XA.ITEM_ID = A.ITEM_ID'
                 || ' AND XA.PLAN_START_YYYYMMDD = ''' || P_PLAN_START_YYYYMMDD || ''''
--                 || ' AND XA.PLAN_TYPE = ''' || P_PLAN_TYPE || ''' AND XA.SEQ = ''' || P_SEQ || ''' AND ROWNUM = 1)';
                 || ' AND XA.PLAN_TYPE = ''' || P_PLAN_TYPE || ''' AND XA.SEQ = ''' || P_SEQ || ''' AND ROWNUM = 1), '' '')';   -- 2026.09.17 AJS

--        V_YIELD_SUB := '(SELECT NVL(TO_CHAR(ROUND(XA.SSP_MODIFY_YIELD * 100, 2)), '' '')'
        V_YIELD_SUB := 'NVL((SELECT TO_CHAR(ROUND(XA.SSP_MODIFY_YIELD * 100, 2), ''FM990.00'')'   -- 2026.09.17 AJS
                    || ' FROM SSP_ANL_FORMATION_C XA'
                    || ' WHERE XA.DIVISION_ID = A.DIVISION_ID AND XA.PLANT_SITE_ID = A.FROM_SITE AND XA.ITEM_ID = A.ITEM_ID'
                    || ' AND XA.PLAN_START_YYYYMMDD = ''' || P_PLAN_START_YYYYMMDD || ''''
--                    || ' AND XA.PLAN_TYPE = ''' || P_PLAN_TYPE || ''' AND XA.SEQ = ''' || P_SEQ || ''' AND ROWNUM = 1)';
                    || ' AND XA.PLAN_TYPE = ''' || P_PLAN_TYPE || ''' AND XA.SEQ = ''' || P_SEQ || ''' AND ROWNUM = 1), '' '')';   -- 2026.09.17 AJS

        V_LTYN_SUB := '(SELECT NVL(MIN(XA.ATTRIBUTE2), '' '')'
                   || ' FROM SSP_ANL_FORMATION_C XA'
                   || ' WHERE XA.DIVISION_ID = A.DIVISION_ID AND XA.PLANT_SITE_ID = A.FROM_SITE AND XA.ITEM_ID = A.ITEM_ID'
                   || ' AND XA.PLAN_START_YYYYMMDD = ''' || P_PLAN_START_YYYYMMDD || ''''
                   || ' AND XA.PLAN_TYPE = ''' || P_PLAN_TYPE || ''' AND XA.SEQ = ''' || P_SEQ || ''')';

--        V_FIGURE_EXP := 'TO_CHAR(CEIL(CASE WHEN A.MEASURE = ''MES_FCS_HOLD''    THEN NVL(W.TOTAL_QTY, 0)'
        /* AS-IS : 네 측정항목 외에는 0 -> REPLACE(...,0,' ') 로 공백 한 칸 */   -- 2026.09.17 AJS
        V_FIGURE_EXP := 'CASE WHEN A.MEASURE IN (''MES_FCS_HOLD'', ''MES_FCS_RELEASE'', ''WH_STOCK'', ''BALANCE'')'   -- 2026.09.17 AJS
                     || ' THEN TO_CHAR(CEIL(CASE WHEN A.MEASURE = ''MES_FCS_HOLD''    THEN NVL(W.TOTAL_QTY, 0)'   -- 2026.09.17 AJS
                     || ' WHEN A.MEASURE = ''MES_FCS_RELEASE'' THEN NVL(X.HOLD_QTY, 0)'
                     || ' WHEN A.MEASURE = ''WH_STOCK''        THEN NVL(Y.MES_QTY, 0)'
                     || ' WHEN A.MEASURE = ''BALANCE''         THEN NVL(Y.FCS_QTY, 0)'
--                     || ' ELSE 0 END), ''FM999,999,999,999,990'')';
                     || ' ELSE 0 END), ''FM999,999,999,999,990'') ELSE '' '' END';   -- 2026.09.17 AJS

        DECLARE
            V_SEL_HEAD  CLOB;
            V_FROM_PART CLOB;
            V_JOIN_PART CLOB;
            V_GRP_PART  CLOB;
        BEGIN

            V_SEL_HEAD := ' SELECT A.DIVISION_ID' || CHR(10)
                       || '      , A.FROM_SITE' || CHR(10)
                       || '      , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), ''-'') AS FROM_SITE_NM' || CHR(10)
                       || '      , A.PLAN_START_YYYYMMDD' || CHR(10)
                       || '      , A.PLAN_TYPE' || CHR(10)
                       || '      , A.ITEM_ID' || CHR(10)
                       || '      , NVL(A.SHIP_FROZEN, 0) AS SHIP_FROZEN' || CHR(10)
                       || '      , A.SEQ' || CHR(10)
                       || '      , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME' || CHR(10)
                       || '      , A.MEASURE' || CHR(10)
                       || '      , A.MEASURE_NAME' || CHR(10)
                       || '      , A.USER_SORT_ORDER_NO' || CHR(10)
                       || '      , A.PSI_NAME' || CHR(10)
                       || '      , A.FROM_YYYYMMDD' || CHR(10)
                       || '      , A.TO_YYYYMMDD' || CHR(10)
                       || '      , ' || V_LT_SUB || ' AS LT_DAY' || CHR(10)
                       || '      , ' || V_YIELD_SUB || ' AS YEILD' || CHR(10)
                       || '      , ' || V_LTYN_SUB || ' AS LT_UPDATE_YN' || CHR(10)
                       || '      , (CASE WHEN A.MEASURE = ''MES_FCS_HOLD'' THEN ''oWMS'' WHEN A.MEASURE = ''MES_FCS_RELEASE'' THEN ''Hold'''
                       || '              WHEN A.MEASURE = ''WH_STOCK'' THEN ''MES'' WHEN A.MEASURE = ''BALANCE'' THEN ''FCS'' ELSE '' '' END) AS TYPE' || CHR(10)
                       || '      , ' || V_FIGURE_EXP || ' AS FIGURE' || CHR(10);

            V_FROM_PART := '   FROM (SELECT T3.DIVISION_ID, T3.PLAN_START_YYYYMMDD, T3.PLAN_TYPE, T3.FROM_SITE' || CHR(10)
                        || '              , T3.ITEM_ID, T3.SEQ, T3.SHIP_FROZEN, T3.PIVOT_KEY' || CHR(10)
                        || '              , CASE WHEN T0.COLUMN_NAME = ''PROD_DATE''' || CHR(10)
                        || '                     THEN TO_NUMBER(T3.QTY_STR DEFAULT NULL ON CONVERSION ERROR)' || CHR(10)
                        || '                     ELSE T3.QTY_NUM END AS QTY_NUM' || CHR(10)
                        || '              , CASE WHEN T0.COLUMN_NAME = ''LOT'' THEN T3.QTY_STR' || CHR(10)
                        || '                     ELSE TO_CHAR(T3.QTY_NUM) END AS QTY_STR' || CHR(10)
                        || '              , T0.COLUMN_NAME       AS MEASURE' || CHR(10)
                        || '              , T0.COLUMN_LABEL_NAME AS MEASURE_NAME' || CHR(10)
                        || '              , T0.ATTRIBUTE1        AS PSI_NAME' || CHR(10)
                        || '              , NVL(T1.SORT_ORDER_NO, T0.SORT_ORDER_NO) AS USER_SORT_ORDER_NO' || CHR(10)
                        || '              , ''' || P_FROM_YYYYMMDD || ''' AS FROM_YYYYMMDD' || CHR(10)
                        || '              , ''' || P_TO_YYYYMMDD || ''' AS TO_YYYYMMDD' || CHR(10)
                        || '           FROM SCM_MST_SHEET_MEASURE T0' || CHR(10)
                        || '              , SCM_MST_TITLESET_USER T1' || CHR(10)
                        || '              , (SELECT TT0.DIVISION_ID, TT0.PLAN_START_YYYYMMDD, TT0.PLAN_TYPE, TT0.FROM_SITE' || CHR(10)
                        || '                      , TT0.ITEM_ID, ''D_'' || TT0.YYYYMMDD AS PIVOT_KEY, TT0.MEASURE AS MEASURE_KEY' || CHR(10)
                        || '                      , SUM(TT0.QTY) AS QTY_NUM, MAX(TT0.ATTRIBUTE1) AS QTY_STR' || CHR(10)
                        || '                      , MAX(TT0.SEQ) AS SEQ, TT2.SHIP_FROZEN' || CHR(10)
                        || '                   FROM GT_SSP0015_ROWDATA TT0, SCM_MST_SITE TT2' || CHR(10)
                        || '                  WHERE (CASE WHEN TT0.DIVISION_ID = ''EE'' THEN TT0.ORIGIN_FROM_DIVISION_ID ELSE TT0.DIVISION_ID END) = TT2.DIVISION_ID(+)' || CHR(10)
                        || '                    AND TT0.FROM_SITE = TT2.SCM_SITE_ID(+)' || CHR(10)
                        || '                    AND TT2.VALID_YN(+) = ''Y''' || CHR(10)
                        || '                    AND TT0.YYYYMMDD >= ''' || P_FROM_YYYYMMDD || '''' || CHR(10)
                        || '                    AND TT0.YYYYMMDD <= ''' || P_TO_YYYYMMDD || '''' || CHR(10)
                        || '                    AND EXISTS (SELECT 1 FROM (SELECT DIVISION_ID, MAX(PLAN_SEQ) AS PLAN_SEQ' || CHR(10)
                        || '                                                 FROM SSP_PLAN_VERSION_V' || CHR(10)
                        || '                                                WHERE PLAN_TYPE = ''' || P_PLAN_TYPE || '''' || CHR(10)
                        || '                                                  AND CONFIRM_FLAG = ''Y''' || CHR(10)
                        || '                                                  AND PLAN_START_YYYYMMDD = ''' || V_PLAN_START_YYYYMMDD || '''' || CHR(10)
                        || '                                                GROUP BY DIVISION_ID) SA' || CHR(10)
                        || '                                 WHERE SA.DIVISION_ID = TT0.DIVISION_ID AND SA.PLAN_SEQ = TT0.SEQ)' || CHR(10)
                        || '                  GROUP BY TT0.DIVISION_ID, TT0.PLAN_START_YYYYMMDD, TT0.PLAN_TYPE, TT0.FROM_SITE' || CHR(10)
                        || '                         , TT0.ITEM_ID, TT0.YYYYMMDD, TT2.SHIP_FROZEN, TT0.MEASURE) T3' || CHR(10)
                        || '          WHERE T1.PROGRAM_ID(+)  = T0.PROGRAM_ID' || CHR(10)
                        || '            AND T1.SHEET_NAME(+)  = T0.SHEET_NAME' || CHR(10)
                        || '            AND T1.COLUMN_NAME(+) = T0.COLUMN_NAME' || CHR(10)
                        || '            AND T1.USER_ID(+)     = ''' || P_USER_ID || '''' || CHR(10)
                        || '            AND T0.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                        || '            AND T0.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                        || '            AND T0.VALID_YN   = ''Y''' || CHR(10)
                        || '            AND (' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0' || CHR(10)
                        || '                  OR EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER SB' || CHR(10)
                        || '                              WHERE SB.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                        || '                                AND SB.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                        || '                                AND SB.USER_ID    = ''' || P_USER_ID || '''' || CHR(10)
                        || '                                AND SB.COLUMN_NAME = T0.COLUMN_NAME))' || CHR(10)
                        || '            AND ((' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0 AND T0.DEFAULT_FLAG = ''Y'')' || CHR(10)
                        || '                  OR (' || TO_CHAR(V_CNT_USR_MEASURE) || ' != 0))' || CHR(10)
                        || '            AND T0.COLUMN_NAME = T3.MEASURE_KEY' || CHR(10);

            V_JOIN_PART := '        ) A' || CHR(10)
                        || '      , (SELECT S.DIVISION_ID, S.PLAN_START_YYYYMMDD, S.PLAN_TYPE, S.SEQ, S.FROM_SITE, S.ITEM_ID, SUM(S.QTY) AS TOTAL_QTY' || CHR(10)
                        || '           FROM SSP_ANL_WH_STOCK_V S' || CHR(10)
                        || '          WHERE S.PLAN_START_YYYYMMDD = ''' || V_PLAN_START_YYYYMMDD || '''' || CHR(10)
                        || '            AND S.PLAN_TYPE = ''' || P_PLAN_TYPE || '''' || CHR(10)
                        || '            AND S.DIVISION_ID = ''' || V_DIVISION_ID || '''' || CHR(10)
                        || '            AND S.SEQ = ''' || P_SEQ || '''' || CHR(10)
                        || '          GROUP BY S.DIVISION_ID, S.PLAN_START_YYYYMMDD, S.PLAN_TYPE, S.SEQ, S.FROM_SITE, S.ITEM_ID) W' || CHR(10)
                        || '      , (SELECT K.DIVISION_ID, K.FROM_SITE, K.ITEM_ID, SUM(K.HOLD_QTY) AS HOLD_QTY' || CHR(10)
                        || '           FROM SSP_ANL_HOLD_STOCK K' || CHR(10)
                        || '          WHERE K.HOLD_YYYYMMDD <= ''' || TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD') || '''' || CHR(10)
                        || '            AND K.RELEASE_YYYYMMDD >= ''' || TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD') || '''' || CHR(10)
                        || '            AND K.PLAN_START_YYYYMMDD = ''' || V_PLAN_START_YYYYMMDD || '''' || CHR(10)
                        || '            AND K.PLAN_TYPE = ''' || P_PLAN_TYPE || '''' || CHR(10)
                        || '            AND K.SEQ = ''' || P_SEQ || '''' || CHR(10)
                        || '          GROUP BY K.DIVISION_ID, K.FROM_SITE, K.ITEM_ID) X' || CHR(10)
                        || '      , (SELECT M.DIVISION_ID, M.PLAN_START_YYYYMMDD, M.PLAN_TYPE, M.SEQ, M.FROM_SITE, M.ITEM_ID' || CHR(10)
                        || '              , SUM(M.LOT_QTY_MES) AS MES_QTY, SUM(M.LOT_QTY_FCS) AS FCS_QTY' || CHR(10)
                        || '           FROM SSP_ANL_MES_FCS_STOCK_40_C M' || CHR(10)
                        || '          WHERE M.PLAN_START_YYYYMMDD = ''' || V_PLAN_START_YYYYMMDD || '''' || CHR(10)
                        || '            AND M.PLAN_TYPE = ''' || P_PLAN_TYPE || '''' || CHR(10)
                        || '            AND M.DIVISION_ID = ''' || V_DIVISION_ID || '''' || CHR(10)
                        || '            AND M.AVAILABLE_YN <> ''N''' || CHR(10)
                        || '            AND M.CHANGE_STATUS <> ''D''' || CHR(10)
                        || '            AND M.SEQ = ''' || P_SEQ || '''' || CHR(10)
                        || '            AND M.AVAILABLE_YN = ''Y''' || CHR(10)
                        || '          GROUP BY M.DIVISION_ID, M.PLAN_START_YYYYMMDD, M.PLAN_TYPE, M.SEQ, M.FROM_SITE, M.ITEM_ID) Y' || CHR(10)
                        || '  WHERE A.DIVISION_ID = W.DIVISION_ID(+) AND A.PLAN_START_YYYYMMDD = W.PLAN_START_YYYYMMDD(+)' || CHR(10)
                        || '    AND A.FROM_SITE = W.FROM_SITE(+) AND A.ITEM_ID = W.ITEM_ID(+)' || CHR(10)
                        || '    AND A.DIVISION_ID = X.DIVISION_ID(+) AND A.FROM_SITE = X.FROM_SITE(+) AND A.ITEM_ID = X.ITEM_ID(+)' || CHR(10)
                        || '    AND A.DIVISION_ID = Y.DIVISION_ID(+) AND A.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD(+)' || CHR(10)
                        || '    AND A.FROM_SITE = Y.FROM_SITE(+) AND A.ITEM_ID = Y.ITEM_ID(+)' || CHR(10);

            V_GRP_PART := '  GROUP BY A.DIVISION_ID, A.FROM_SITE, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.ITEM_ID' || CHR(10)
                       || '         , A.SHIP_FROZEN, A.SEQ, A.MEASURE, A.MEASURE_NAME, A.USER_SORT_ORDER_NO, A.PSI_NAME' || CHR(10)
                       || '         , A.FROM_YYYYMMDD, A.TO_YYYYMMDD, W.TOTAL_QTY, X.HOLD_QTY, Y.MES_QTY, Y.FCS_QTY' || CHR(10);

            V_MEXEC := 'SELECT * FROM (' || CHR(10)
                    || V_SEL_HEAD || V_MQUERY || V_FROM_PART
                    || '            AND T3.MEASURE_KEY != ''LOT''' || CHR(10)
                    || V_JOIN_PART || V_GRP_PART
                    || ' UNION ALL' || CHR(10)
                    || V_SEL_HEAD || V_MQUERY1 || V_FROM_PART
                    || '            AND T3.MEASURE_KEY = ''LOT''' || CHR(10)
                    || V_JOIN_PART || V_GRP_PART
                    || ') TTTT ORDER BY DIVISION_ID, FROM_SITE, ITEM_ID, USER_SORT_ORDER_NO';

        END;

        OPEN O_RC1 FOR V_MEXEC;

        /* NOTE, Prod_Qty Load */
        P_SSP0015_GET_SHIPMENT_PSI_COMMENTS(V_DIVISION_ID, V_PLAN_START_YYYYMMDD, V_FROM_SITE, P_ITEM_ID
                                          , P_FROM_YYYYMMDD, P_TO_YYYYMMDD, O_RC2, O_RC3);

        DBMS_LOB.FREETEMPORARY(V_MQUERY);
        DBMS_LOB.FREETEMPORARY(V_MQUERY1);

    END P_SSP0015_GET_SHIPMENT_PSI;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_PSI_PACKER
       AS-IS SSP0015_GET_SHIPMENT_PSI_PACKER
       ※ #TEMP 9벌 -> GT_SSP0015_PK_* 9벌
       ※ 마지막 피벗은 조회기간만큼 날짜 칸을 만들므로 정적 SQL 로 옮길 수 없다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI_PACKER
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PROGRAM_ID            IN  VARCHAR2,
        P_SHEET_NAME            IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_SEQ                   IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_PACKER
         * Description  : Shipment PSI (Packer)
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2020/11/10   KIMYONGHO      SSP0015_GET_SHIPMENT_PSI 복사 신규추가
         * 2022/02/21   SMS            @v_confirm_date 일자 scm_mst_site(ship_frozen)로 설정
         * 2023/09/19   jilee          G182-P (Group='P',OSP='N')인 사이트 화면에서 제외
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         */
        V_CNT_USR_MEASURE       PLS_INTEGER := 0;
        V_CUTOFF_DATE           VARCHAR2(8 CHAR);
        V_BOH_YYYYMMDD          VARCHAR2(8 CHAR);
        V_PLAN_CUTOFF_DATE_TIME DATE;
        V_MQRY_SUM              CLOB := EMPTY_CLOB();
        V_MEXEC                 CLOB;
    BEGIN

        /* GTT 초기화 - TRUNCATE 금지 */
        DELETE FROM GT_SSP0015_PK_SHIP_REQ;
        DELETE FROM GT_SSP0015_PK_PACK_RTF;
        DELETE FROM GT_SSP0015_PK_SHIP_CONFIRM;
        DELETE FROM GT_SSP0015_PK_PROD_PLAN;
        DELETE FROM GT_SSP0015_PK_WH_STOCK;
        DELETE FROM GT_SSP0015_PK_ERP_STOCK;
        DELETE FROM GT_SSP0015_PK_ROWDATA;
        DELETE FROM GT_SSP0015_PK_RESULT;
        DELETE FROM GT_SSP0015_PK_RESULT_PIVOT;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        V_CUTOFF_DATE  := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 2, 'YYYYMMDD');
        V_BOH_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

        /* AS-IS : datepart(DW, ...) = 2 는 월요일. Oracle 은 NLS 에 좌우되지 않도록 TO_CHAR(,'D','NLS_DATE_LANGUAGE=AMERICAN') 대신
           고정 기준일과의 차로 요일을 구한다(1900-01-01 은 월요일). */
        IF MOD(TRUNC(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')) - TO_DATE('19000101', 'YYYYMMDD'), 7) = 0 THEN
            V_PLAN_CUTOFF_DATE_TIME := TO_DATE(P_PLAN_START_YYYYMMDD || ' 15:30:00', 'YYYYMMDD HH24:MI:SS');
        ELSE
            V_PLAN_CUTOFF_DATE_TIME := TO_DATE(P_PLAN_START_YYYYMMDD || ' 07:15:00', 'YYYYMMDD HH24:MI:SS');
        END IF;

        /* //SHIP_REQ Measure 추가 */
        INSERT INTO GT_SSP0015_PK_SHIP_REQ
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.FROM_SITE
             , 'SHIP_REQ'
             , A.YYYYMMDD
             , SUM(A.QTY)
          FROM SSP_ANL_SHIP_REQ_P A
             , SCP_MST_BOD_N_V B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.BOD_ID      = B.BOD_ID
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                 OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR B.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
         GROUP BY A.DIVISION_ID, A.ITEM_ID, B.FROM_SITE, A.YYYYMMDD;

        /* //PACK_RTF Measure 추가 */
        INSERT INTO GT_SSP0015_PK_PACK_RTF
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.FROM_SITE
             , 'PACK_RTF'
             , A.ATTRIBUTE3
--             , SUM(TO_NUMBER(A.ATTRIBUTE4 DEFAULT NULL ON CONVERSION ERROR))
             , SUM(ROUND(TO_NUMBER(A.ATTRIBUTE4 DEFAULT NULL ON CONVERSION ERROR)))   -- 2026.09.17 AJS
          FROM SSP_ANL_SHIP_REQ_P A
             , SCP_MST_BOD_N_V B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.BOD_ID      = B.BOD_ID
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.ATTRIBUTE2 <> 'N'
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                 OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR B.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
         GROUP BY A.DIVISION_ID, A.ITEM_ID, B.FROM_SITE, A.ATTRIBUTE3, A.ATTRIBUTE4;

        /* //SHIP_CONFIRM Measure 추가 */
        INSERT INTO GT_SSP0015_PK_SHIP_CONFIRM
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , 'SHIP_CONFIRM'
             , A.YYYYMMDD
             , SUM(A.QTY)
          FROM SSP_ANL_SHIP_CONFIRM A
             , SCM_MST_SITE S
         WHERE S.DIVISION_ID = A.DIVISION_ID
           AND S.SCM_SITE_ID = A.FROM_SITE
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.BIZ_TYPE  = 'P'
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                 OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           /* jilee 230919 */
           AND S.OSP_YN = 'Y'
         GROUP BY A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.YYYYMMDD
        UNION ALL
        /* 20220221 SMS @v_confirm_date 일자 scm_mst_site(ship_frozen)로 설정 */
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.FROM_SITE
             , 'SHIP_CONFIRM'
             , A.YYYYMMDD
             , SUM(A.QTY)
          FROM SSP_ANL_SHIP_REQ_P A
             , SCP_MST_BOD_N_V B
             , SCM_MST_SITE FS
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.BOD_ID      = B.BOD_ID
           AND A.DIVISION_ID = FS.DIVISION_ID
           AND B.FROM_SITE   = FS.SCM_SITE_ID
           AND FS.VALID_YN   = 'Y'
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(FS.SHIP_FROZEN, 0), 'YYYYMMDD')
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                 OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR B.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
         GROUP BY A.DIVISION_ID, A.ITEM_ID, B.FROM_SITE, A.YYYYMMDD;

        /* //PROD_PLAN Measure 추가 */
        INSERT INTO GT_SSP0015_PK_PROD_PLAN
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.PACK_MODEL_CODE
             , A.SCM_SITE_ID
             , 'PROD_PLAN'
             , A.PROD_DATE
             , NVL(A.PROD_QTY, 0)
          FROM SCM_DNM_SCS_PROD_PLAN A
             , (SELECT DIVISION_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE, PACK_MODEL_CODE, SCM_SITE_ID, PROD_DATE
                  FROM SCM_DNM_SCS_PROD_PLAN
                 GROUP BY DIVISION_ID, PACK_MODEL_CODE, SCM_SITE_ID, PROD_DATE) B
         WHERE A.DIVISION_ID     = B.DIVISION_ID
           AND A.CUTOFF_DATE     = B.CUTOFF_DATE
           AND A.PACK_MODEL_CODE = B.PACK_MODEL_CODE
           AND A.SCM_SITE_ID     = B.SCM_SITE_ID
           AND A.PROD_DATE       = B.PROD_DATE
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.PROD_DATE >= P_FROM_YYYYMMDD
           AND A.PROD_DATE <= P_TO_YYYYMMDD
           AND NVL(A.PROD_QTY, 0) > 0
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                 OR A.PACK_MODEL_CODE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR A.PACK_MODEL_CODE IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))));

        /* //WH_STOCK Measure 추가 */
        INSERT INTO GT_SSP0015_PK_WH_STOCK
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.SCM_SITE_ID
             , 'WH_STOCK'
             , A.STOCK_DATE
             , SUM(NVL(A.STOCK_QTY, 0))
          FROM SCM_DNM_SCS_STOCK A
         WHERE 1 = 1
           AND A.DIVISION_ID      = P_DIVISION_ID
           AND A.CUTOFF_DATE      = V_CUTOFF_DATE
           AND A.LAST_UPDATE_DATE <= V_PLAN_CUTOFF_DATE_TIME
           AND A.CELL_PACK        = 'P'
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                 OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
         GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.STOCK_DATE;

        /* //ERP 재고 데이터 */
        INSERT INTO GT_SSP0015_PK_ERP_STOCK
               (DIVISION_ID, PLANT_ID, ITEM_ID, BOH_TYPE, YYYYMMDD, QTY)
        SELECT IA.DIVISION_ID
             , IA.PLANT_ID
             , IA.ITEM_ID
             , 'ERP'
             , IA.CUTOFF_DATE
             , SUM(IA.SCM_QTY)
          FROM (
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.COMPANY_ID
                     , A.ITEM_ID
                     , A.SCM_QTY
                     , TO_CHAR(A.CUTOFF_DATE, 'YYYYMMDD') AS CUTOFF_DATE
                     , A.PLANT_ID
                     , A.STOCK_TYPE
                  FROM SCM_DNM_STOCK_V A
                 WHERE 1 = 1
                   AND A.DIVISION_ID = '40'
                   AND A.COMPANY_ID  = FN_GET_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI_PACKER', 'ESOC')   /* C100 */
                   AND A.CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD')
                   AND A.PLANT_ID    = FN_GET_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI_PACKER', 'A010')   /* A010 */
                   AND A.STOCK_TYPE  = 'INVENTORY'
               ) IA
         WHERE IA.STOCK_TYPE = 'INVENTORY'
         GROUP BY IA.DIVISION_ID, IA.COMPANY_ID, IA.ITEM_ID, IA.CUTOFF_DATE, IA.PLANT_ID, IA.STOCK_TYPE;

        /* //TMP_ROWDATA */
        INSERT INTO GT_SSP0015_PK_ROWDATA
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT T0.DIVISION_ID
             , T0.ITEM_ID
             , T0.FROM_SITE
             , T0.MEASURE
             , T0.YYYYMMDD
             , SUM(T0.QTY)
          FROM (
                SELECT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY FROM GT_SSP0015_PK_SHIP_REQ
                UNION
                SELECT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY FROM GT_SSP0015_PK_PACK_RTF
                UNION
                SELECT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY FROM GT_SSP0015_PK_SHIP_CONFIRM
                UNION
                SELECT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY FROM GT_SSP0015_PK_PROD_PLAN
               ) T0
         GROUP BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.MEASURE, T0.YYYYMMDD;

        /* //4. WH_STOCK - 전일 WH_STOCK + PROD_PLAN - SHIP_CONFIRM 누적 + SCS 재고 */
        INSERT INTO GT_SSP0015_PK_ROWDATA
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT T0.DIVISION_ID
             , T0.ITEM_ID
             , T0.FROM_SITE
             , 'WH_STOCK'
             , T0.YYYYMMDD
             , (SELECT NVL(SUM(CASE WHEN TT0.MEASURE = 'SHIP_CONFIRM' THEN -1 * NVL(TT0.QTY, 0)
                                    WHEN TT0.MEASURE = 'PROD_PLAN'    THEN      NVL(TT0.QTY, 0)
                                    ELSE 0 END), 0)
                  FROM GT_SSP0015_PK_ROWDATA TT0
                 WHERE 1 = 1
                   AND TT0.DIVISION_ID = T0.DIVISION_ID
                   AND TT0.FROM_SITE   = T0.FROM_SITE
                   AND TT0.ITEM_ID     = T0.ITEM_ID
                   AND TT0.MEASURE IN ('SHIP_CONFIRM', 'PROD_PLAN')
                   AND TT0.YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                   AND TT0.YYYYMMDD <= T0.YYYYMMDD)
               + NVL(T1.QTY, 0)
          FROM (
                /* Deduplication */
                SELECT R.DIVISION_ID
                     , R.FROM_SITE
                     , R.ITEM_ID
                     , C.YYYYMMDD
                  FROM GT_SSP0015_PK_ROWDATA R
                     , (SELECT BASIS_YYYYMMDD AS YYYYMMDD
                          FROM SCM_SYS_CALENDAR_M
                         WHERE BASIS_YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                           AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD) C
                 WHERE C.YYYYMMDD(+) >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                 GROUP BY R.DIVISION_ID, R.FROM_SITE, R.ITEM_ID, C.YYYYMMDD
               ) T0
             , (SELECT A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.QTY
                  FROM GT_SSP0015_PK_WH_STOCK A
                 WHERE A.DIVISION_ID = P_DIVISION_ID
                   AND A.YYYYMMDD    = V_CUTOFF_DATE
                   AND A.MEASURE     = 'WH_STOCK'
                   AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                         OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                         OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
                   AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                         OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))) T1
         WHERE T0.DIVISION_ID = T1.DIVISION_ID(+)
           AND T0.FROM_SITE   = T1.FROM_SITE(+)
           AND T0.ITEM_ID     = T1.ITEM_ID(+)
           AND T0.YYYYMMDD   <= P_TO_YYYYMMDD;

        /* //BALANCE Measure 추가 */
        INSERT INTO GT_SSP0015_PK_ROWDATA
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT DIVISION_ID
             , ITEM_ID
             , FROM_SITE
             , 'BALANCE'
             , YYYYMMDD
             , NVL(SUM(CASE WHEN MEASURE = 'SHIP_CONFIRM' THEN -1 * NVL(QTY, 0)
                            WHEN MEASURE = 'WH_STOCK'     THEN      NVL(QTY, 0)
                            ELSE 0 END), 0)
          FROM GT_SSP0015_PK_ROWDATA
         WHERE 1 = 1
           AND MEASURE IN ('SHIP_CONFIRM', 'WH_STOCK', 'PROD_PLAN')
           AND YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
         GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD;

        /* //TMP_RESULT_TABLE */
        INSERT INTO GT_SSP0015_PK_RESULT
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY, SEQ)
        SELECT DISTINCT
               X.DIVISION_ID
             , X.ITEM_ID
             , X.FROM_SITE
             , X.MEASURE
             , X.YYYYMMDD
             , NVL(R.QTY, 0)
             , X.SEQ
          FROM (
                SELECT T.DIVISION_ID
                     , T.ITEM_ID
                     , NVL(T.FROM_SITE, '/')    AS FROM_SITE
                     , T.QTY
                     , TT1.COLUMN_NAME          AS MEASURE
                     , TT1.COLUMN_LABEL_NAME    AS MEASURE_NAME
                     , TT1.ATTRIBUTE3           AS BACK_COLOR
                     , TT1.SORT_ORDER_NO        AS SEQ
                     , T.YYYYMMDD
                  FROM GT_SSP0015_PK_ROWDATA T
                     , SCM_MST_SHEET_MEASURE TT1
                     , SCM_MST_TITLESET_USER T3
                 WHERE TT1.PROGRAM_ID = P_PROGRAM_ID
                   AND TT1.SHEET_NAME = P_SHEET_NAME
                   AND T3.PROGRAM_ID(+)  = TT1.PROGRAM_ID
                   AND T3.SHEET_NAME(+)  = TT1.SHEET_NAME
                   AND T3.COLUMN_NAME(+) = TT1.COLUMN_NAME
                   AND T3.USER_ID(+)     = P_USER_ID
               ) X
             , GT_SSP0015_PK_ROWDATA R
         WHERE R.DIVISION_ID(+) = X.DIVISION_ID
           AND R.ITEM_ID(+)     = X.ITEM_ID
           AND R.MEASURE(+)     = X.MEASURE
           AND R.YYYYMMDD(+)    = X.YYYYMMDD
           AND R.FROM_SITE(+)   = X.FROM_SITE
           AND X.MEASURE IN ('SHIP_REQ', 'SHIP_CONFIRM', 'PACK_RTF', 'PROD_PLAN', 'WH_STOCK', 'BALANCE');

        /* //PIVOT 대상 */
        INSERT INTO GT_SSP0015_PK_RESULT_PIVOT
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ)
        SELECT DISTINCT
               T0.DIVISION_ID
             , T0.ITEM_ID
             , T0.FROM_SITE
             , T0.MEASURE
             , 'D_' || T0.YYYYMMDD
             , T1.BASIS_YYYYMM
             , SUBSTR(T1.BASIS_YYYYMM, -4) || T1.ISO_WEEK
             , T0.QTY
             , T0.SEQ
          FROM GT_SSP0015_PK_RESULT T0
             , SCM_SYS_CALENDAR_M T1
         WHERE T0.YYYYMMDD = T1.BASIS_YYYYMMDD(+);

        /* PIVOT 대상 날짜문자열 생성 */
        DBMS_LOB.CREATETEMPORARY(V_MQRY_SUM, TRUE);

        FOR C IN (
            SELECT IA.YYYYMMDD
              FROM (
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                         , A.BASIS_START_DATE || '21'           AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM                AS YYYYMMDD
                         , MIN(A.BASIS_START_DATE) || '01'       AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                    UNION ALL
                    SELECT 'D_' || A.BASIS_YYYYMMDD              AS YYYYMMDD
                         , A.BASIS_YYYYMMDD || '31'              AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMMDD
                   ) IA
             ORDER BY IA.SORT_ORDER_NO)
        LOOP
            IF SUBSTR(C.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.YYYYMM = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' THEN
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSE
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.YYYYMMDD = SUBSTR(''' || C.YYYYMMDD || ''', -10) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            END IF;
        END LOOP;

        V_MEXEC := 'SELECT DISTINCT TTT.* FROM ( ' || CHR(10)
                || '  SELECT T0.DIVISION_ID' || CHR(10)
                || '       , T0.ITEM_ID' || CHR(10)
                || '       , NVL(IT.NICK_NAME, ''-'')      AS NICK_NAME' || CHR(10)
                || '       , (CASE WHEN T0.MEASURE = ''WH_STOCK'' THEN ''SCS'' WHEN T0.MEASURE = ''BALANCE'' THEN ''ERP'' ELSE '' '' END) AS TYPE' || CHR(10)
                || '       , (CASE WHEN T0.MEASURE = ''WH_STOCK'' THEN NVL(T5.QTY, 0)' || CHR(10)
                || '               WHEN T0.MEASURE = ''BALANCE''  THEN NVL(T6.QTY, 0)' || CHR(10)
                || '          ELSE NULL END)               AS FIGURE' || CHR(10)
                || '       , NVL(T0.FROM_SITE, ''-'')      AS FROM_SITE' || CHR(10)
                || '       , NVL(T4.SITE_DESCRIPTION, ''/'') AS FROM_SITE_NM' || CHR(10)
                || '       , T0.MEASURE                    AS MEASURE' || CHR(10)
                || '       , T2.ATTRIBUTE1                 AS PSI_NAME' || CHR(10)
                || '       , T0.SEQ' || CHR(10)
                || '       , CASE WHEN NVL(T4.SHIP_FROZEN, 0) - 1 > 0 THEN T4.SHIP_FROZEN - 1 ELSE 0 END AS SHIP_FROZEN' || CHR(10)
                || V_MQRY_SUM
                || '    FROM GT_SSP0015_PK_RESULT_PIVOT T0' || CHR(10)
                || '       , SCM_MST_SHEET_MEASURE T2' || CHR(10)
                || '       , SCM_MST_TITLESET_USER T3' || CHR(10)
                || '       , SCM_MST_SITE T4' || CHR(10)
                || '       , GT_SSP0015_PK_WH_STOCK T5' || CHR(10)
                || '       , GT_SSP0015_PK_ERP_STOCK T6' || CHR(10)
                || '       , (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME FROM SCM_MST_ITEM_SN' || CHR(10)
                || '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || '''' || CHR(10)
                || '             AND ACTIVE_FLAG = ''Y''' || CHR(10)
                || '             AND SCP_OPERATION_GROUP = ''P'') IT' || CHR(10)
                || '       , SSP_MST_MODEL_USER TT3' || CHR(10)
                || '   WHERE T0.MEASURE = T2.COLUMN_NAME' || CHR(10)
                || '     AND T2.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                || '     AND T2.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                || '     AND T3.PROGRAM_ID(+)  = T2.PROGRAM_ID' || CHR(10)
                || '     AND T3.SHEET_NAME(+)  = T2.SHEET_NAME' || CHR(10)
                || '     AND T3.COLUMN_NAME(+) = T2.COLUMN_NAME' || CHR(10)
                || '     AND T3.USER_ID(+)     = ''' || P_USER_ID || '''' || CHR(10)
                || '     AND T0.DIVISION_ID = T4.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.FROM_SITE   = T4.SCM_SITE_ID(+)' || CHR(10)
                || '     AND T4.VALID_YN(+) = ''Y''' || CHR(10)
                || '     AND T0.DIVISION_ID = T5.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.FROM_SITE   = T5.FROM_SITE(+)' || CHR(10)
                || '     AND T0.ITEM_ID     = T5.ITEM_ID(+)' || CHR(10)
                || '     AND T5.YYYYMMDD(+) = ''' || V_CUTOFF_DATE || '''' || CHR(10)
                || '     AND T5.MEASURE(+)  = ''WH_STOCK''' || CHR(10)
                || '     AND T0.DIVISION_ID = T6.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.ITEM_ID     = T6.ITEM_ID(+)' || CHR(10)
                || '     AND T0.DIVISION_ID = IT.DIVISION_ID' || CHR(10)
                || '     AND T0.ITEM_ID     = IT.ITEM_ID' || CHR(10)
                || '     AND TT3.DIVISION_ID(+) = T0.DIVISION_ID' || CHR(10)
                || '     AND TT3.FROM_SITE(+)   = T0.FROM_SITE' || CHR(10)
                || '     AND TT3.ITEM_ID(+)     = T0.ITEM_ID' || CHR(10)
                || '     AND TT3.VALID_YN(+)    = ''Y''' || CHR(10)
                || '     AND T2.VALID_YN = ''Y''' || CHR(10)
                || '     AND ((''' || P_NONCHK || ''' = ''Y'' AND 1 = 1)' || CHR(10)
--                || '           OR TT3.USER_ID IN (SELECT CASE WHEN ''' || P_MYMODELCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END FROM DUAL' || CHR(10)
                || '           OR TT3.USER_ID IN (SELECT CASE WHEN ''' || P_MYMODELCHK || ''' = ''Y'' THEN ''' || LOWER(P_USER_ID) || ''' ELSE ''X'' END FROM DUAL' || CHR(10)   -- 2026.09.17 AJS
                || '                               UNION' || CHR(10)
                || '                              SELECT CASE WHEN ''' || P_DELEGATEECHK || ''' = ''Y'' THEN USER_ID ELSE ''X'' END' || CHR(10)
--                || '                                FROM SSP_MST_DELEGATE WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' || P_USER_ID || ''' GROUP BY USER_ID)' || CHR(10)
                || '                                FROM SSP_MST_DELEGATE WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' || LOWER(P_USER_ID) || ''' GROUP BY USER_ID)' || CHR(10)   -- 2026.09.17 AJS
--                || '           OR TT3.PART_LEADER = CASE WHEN ''' || P_PARTLEADERCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END' || CHR(10)
                || '           OR TT3.PART_LEADER = CASE WHEN ''' || P_PARTLEADERCHK || ''' = ''Y'' THEN ''' || LOWER(P_USER_ID) || ''' ELSE ''X'' END' || CHR(10)   -- 2026.09.17 AJS
--                || '           OR TT3.TEAM_LEADER = CASE WHEN ''' || P_TEAMLEADERCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END)' || CHR(10);
                || '           OR TT3.TEAM_LEADER = CASE WHEN ''' || P_TEAMLEADERCHK || ''' = ''Y'' THEN ''' || LOWER(P_USER_ID) || ''' ELSE ''X'' END)' || CHR(10);   -- 2026.09.17 AJS

        IF P_FROM_SITE IS NOT NULL THEN
            V_MEXEC := V_MEXEC
                || '     AND T0.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(''' || P_FROM_SITE || ''', '','')))' || CHR(10);
        END IF;

        V_MEXEC := V_MEXEC
                || '     AND (' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0' || CHR(10)
                || '           OR EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER SA' || CHR(10)
                || '                       WHERE SA.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                || '                         AND SA.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                || '                         AND SA.USER_ID    = ''' || P_USER_ID || '''' || CHR(10)
                || '                         AND SA.COLUMN_NAME = T2.COLUMN_NAME))' || CHR(10)
                || '     AND ((' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0 AND T2.DEFAULT_FLAG = ''Y'')' || CHR(10)
                || '           OR (' || TO_CHAR(V_CNT_USR_MEASURE) || ' != 0))' || CHR(10)
                || '   GROUP BY T0.DIVISION_ID, T0.ITEM_ID, IT.NICK_NAME, T0.FROM_SITE, T4.SITE_DESCRIPTION' || CHR(10)
                || '          , T0.MEASURE, T0.SEQ, T2.ATTRIBUTE1, T5.QTY, T6.QTY, T4.SHIP_FROZEN' || CHR(10)
                || ') TTT' || CHR(10)
                || ' ORDER BY TTT.DIVISION_ID, TTT.FROM_SITE DESC, TTT.ITEM_ID, TTT.SEQ ASC';

        OPEN O_RC1 FOR V_MEXEC;

        DBMS_LOB.FREETEMPORARY(V_MQRY_SUM);

    END P_SSP0015_GET_SHIPMENT_PSI_PACKER;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST
       AS-IS SSP0015_GET_SHIPMENT_PSI_PACKER_PAST
       ※ 과거 버전 조회라 계산하지 않고 SSP_ANL_SHIP_PLAN_P 스냅샷을 그대로 읽는다.
       ※ 마지막 피벗은 조회기간만큼 날짜 칸을 만들므로 정적 SQL 로 옮길 수 없다.
          OPEN 커서 FOR 문자열 로 두고 조립 문자열은 CLOB 로 둔다.
          (CNS 전환가이드 8항 Dynamic SQL 금지의 예외 - 2항 결과 동일성을 우선한 자리)
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PROGRAM_ID            IN  VARCHAR2,
        P_SHEET_NAME            IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_SEQ                   IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST
         * Description  : Shipment PSI (Packer) - 과거 버전
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2020/11/10   KIMYONGHO      SSP0015_GET_SHIPMENT_PSI 복사 신규추가
         * 2022/02/21   SMS            SHIP_FROZEN 추가 (scm_mst_site(ship_frozen))
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         */
        V_CNT_USR_MEASURE   PLS_INTEGER := 0;
        V_CUTOFF_DATE       VARCHAR2(8 CHAR);
        V_PLAN_CUTOFF_DATE_TIME DATE;   -- 2026.09.17 AJS
        V_MQRY_SUM          CLOB := EMPTY_CLOB();
        V_MEXEC             CLOB;
    BEGIN

        /* GTT 초기화 - TRUNCATE 금지 */
        DELETE FROM GT_SSP0015_PK_ROWDATA;
        DELETE FROM GT_SSP0015_PK_RESULT;
        DELETE FROM GT_SSP0015_PK_RESULT_PIVOT;
        DELETE FROM GT_SSP0015_PK_WH_STOCK;
        DELETE FROM GT_SSP0015_PK_ERP_STOCK;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        V_CUTOFF_DATE := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 2, 'YYYYMMDD');

        /* AS-IS : datepart(DW, 기준일) = 2(월요일, DATEFIRST 7) 이면 15:30, 아니면 07:15 - 1900-01-01 은 월요일 */   -- 2026.09.17 AJS
        IF MOD(TRUNC(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')) - TO_DATE('19000101', 'YYYYMMDD'), 7) = 0 THEN   -- 2026.09.17 AJS
            V_PLAN_CUTOFF_DATE_TIME := TO_DATE(P_PLAN_START_YYYYMMDD || ' 15:30:00', 'YYYYMMDD HH24:MI:SS');   -- 2026.09.17 AJS
        ELSE   -- 2026.09.17 AJS
            V_PLAN_CUTOFF_DATE_TIME := TO_DATE(P_PLAN_START_YYYYMMDD || ' 07:15:00', 'YYYYMMDD HH24:MI:SS');   -- 2026.09.17 AJS
        END IF;   -- 2026.09.17 AJS

        /* //4. WH_STOCK - SCS 재고 */
        INSERT INTO GT_SSP0015_PK_WH_STOCK
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.SCM_SITE_ID
             , 'WH_STOCK'
             , A.STOCK_DATE
             , SUM(NVL(A.STOCK_QTY, 0))
          FROM SCM_DNM_SCS_STOCK A
         WHERE 1 = 1
           AND A.DIVISION_ID = P_DIVISION_ID
--           AND A.CUTOFF_DATE = V_CUTOFF_DATE
           AND A.CUTOFF_DATE = V_CUTOFF_DATE   -- 2026.09.17 AJS
           AND A.LAST_UPDATE_DATE <= V_PLAN_CUTOFF_DATE_TIME   -- 2026.09.17 AJS
           AND A.CELL_PACK   = 'P'
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                 OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                 OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
         GROUP BY A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.STOCK_DATE;

        /* //ERP 재고 데이터 */
        INSERT INTO GT_SSP0015_PK_ERP_STOCK
               (DIVISION_ID, PLANT_ID, ITEM_ID, BOH_TYPE, YYYYMMDD, QTY)
        SELECT IA.DIVISION_ID
             , IA.PLANT_ID
             , IA.ITEM_ID
             , 'ERP'
             , IA.CUTOFF_DATE
             , SUM(IA.SCM_QTY)
          FROM (
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.COMPANY_ID
                     , A.ITEM_ID
                     , A.SCM_QTY
                     , TO_CHAR(A.CUTOFF_DATE, 'YYYYMMDD') AS CUTOFF_DATE
                     , A.PLANT_ID
                     , A.STOCK_TYPE
                  FROM SCM_DNM_STOCK_V A
                 WHERE 1 = 1
                   AND A.DIVISION_ID = '40'
                   AND A.COMPANY_ID  = FN_GET_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI_PACKER_PAST', 'ESOC')   /* C100 */
--                   AND A.CUTOFF_DATE = TO_DATE(TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD'), 'YYYYMMDD')
                   AND A.CUTOFF_DATE = TO_DATE(V_CUTOFF_DATE, 'YYYYMMDD')   -- 2026.09.17 AJS
                   AND A.PLANT_ID    = FN_GET_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI_PACKER_PAST', 'A010')   /* A010 */
                   AND A.STOCK_TYPE  = 'INVENTORY'
               ) IA
         WHERE IA.STOCK_TYPE = 'INVENTORY'
         GROUP BY IA.DIVISION_ID
             , IA.COMPANY_ID
             , IA.ITEM_ID
             , IA.CUTOFF_DATE
             , IA.PLANT_ID
             , IA.STOCK_TYPE;

        /* //TMP_ROWDATA - 과거 버전은 SSP_ANL_SHIP_PLAN_P 스냅샷을 그대로 읽는다 */
        INSERT INTO GT_SSP0015_PK_ROWDATA
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , A.MEASURE
             , A.YYYYMMDD
             , SUM(A.QTY)
          FROM SSP_ANL_SHIP_PLAN_P A
         WHERE A.DIVISION_ID         = P_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
--           AND A.MEASURE IN ('SHIP_REQ', 'SHIP_CONFIRM', 'PACK_RTF', 'PROD_PLAN', 'WH_STOCK', 'BALANCE')   /* PACK FP = PROD_PLAN */
           AND A.MEASURE IN ('SHIP_REQ', 'SHIP_CONFIRM', 'PACK_RTF', 'PROD_PLAN', 'WH_STOCK', 'BALANCE')   /* PACK FP = PROD_PLAN */   -- 2026.09.17 AJS
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')   -- 2026.09.17 AJS
                 OR A.ITEM_ID IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')   -- 2026.09.17 AJS
                 OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))   -- 2026.09.17 AJS
         GROUP BY A.DIVISION_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , A.MEASURE
             , A.YYYYMMDD;

        /* //TMP_RESULT_TABLE */
        INSERT INTO GT_SSP0015_PK_RESULT
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY, SEQ)
        SELECT DISTINCT
               X.DIVISION_ID
             , X.ITEM_ID
             , X.FROM_SITE
             , X.MEASURE
             , X.YYYYMMDD
             , NVL(R.QTY, 0)
             , X.SEQ
          FROM (
                SELECT T.DIVISION_ID
                     , T.ITEM_ID
                     , NVL(T.FROM_SITE, '/')    AS FROM_SITE
                     , T.QTY
                     , TT1.COLUMN_NAME          AS MEASURE
                     , TT1.COLUMN_LABEL_NAME    AS MEASURE_NAME
                     , TT1.ATTRIBUTE3           AS BACK_COLOR
                     , TT1.SORT_ORDER_NO        AS SEQ
                     , T.YYYYMMDD
                  FROM GT_SSP0015_PK_ROWDATA T
                     , SCM_MST_SHEET_MEASURE TT1
                     , SCM_MST_TITLESET_USER T3
                 WHERE TT1.PROGRAM_ID = P_PROGRAM_ID
                   AND TT1.SHEET_NAME = P_SHEET_NAME
                   AND T3.PROGRAM_ID(+)  = TT1.PROGRAM_ID
                   AND T3.SHEET_NAME(+)  = TT1.SHEET_NAME
                   AND T3.COLUMN_NAME(+) = TT1.COLUMN_NAME
                   AND T3.USER_ID(+)     = P_USER_ID
               ) X
             , GT_SSP0015_PK_ROWDATA R
         WHERE R.DIVISION_ID(+) = X.DIVISION_ID
           AND R.ITEM_ID(+)     = X.ITEM_ID
           AND R.MEASURE(+)     = X.MEASURE
           AND R.YYYYMMDD(+)    = X.YYYYMMDD
           AND R.FROM_SITE(+)   = X.FROM_SITE
           AND X.MEASURE IN ('SHIP_REQ', 'SHIP_CONFIRM', 'PACK_RTF', 'PROD_PLAN', 'WH_STOCK', 'BALANCE');   /* PACK FP = PROD_PLAN */

        /* //PIVOT 대상 */
        INSERT INTO GT_SSP0015_PK_RESULT_PIVOT
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ)
        SELECT DISTINCT
               T0.DIVISION_ID
             , T0.ITEM_ID
             , T0.FROM_SITE
             , T0.MEASURE
             , 'D_' || T0.YYYYMMDD
             , T1.BASIS_YYYYMM
             , SUBSTR(T1.BASIS_YYYYMM, -4) || T1.ISO_WEEK
             , T0.QTY
             , T0.SEQ
          FROM GT_SSP0015_PK_RESULT T0
             , SCM_SYS_CALENDAR_M T1
         WHERE T0.YYYYMMDD = T1.BASIS_YYYYMMDD(+);

        /* PIVOT 대상 날짜문자열 생성 */
        DBMS_LOB.CREATETEMPORARY(V_MQRY_SUM, TRUE);

        FOR C IN (
            SELECT IA.YYYYMMDD
              FROM (
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                         , A.BASIS_START_DATE || '21'           AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM                AS YYYYMMDD
                         , MIN(A.BASIS_START_DATE) || '01'       AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                    UNION ALL
                    SELECT 'D_' || A.BASIS_YYYYMMDD              AS YYYYMMDD
                         , A.BASIS_YYYYMMDD || '31'              AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMMDD
                   ) IA
             ORDER BY IA.SORT_ORDER_NO)
        LOOP
            IF SUBSTR(C.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.YYYYMM = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' THEN
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSE
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.YYYYMMDD = SUBSTR(''' || C.YYYYMMDD || ''', -10) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            END IF;
        END LOOP;

        V_MEXEC := 'SELECT DISTINCT TTT.* FROM ( ' || CHR(10)
                || '  SELECT T0.DIVISION_ID' || CHR(10)
                || '       , T0.ITEM_ID' || CHR(10)
                || '       , NVL(IT.NICK_NAME, ''-'')      AS NICK_NAME' || CHR(10)
                || '       , (CASE WHEN T0.MEASURE = ''WH_STOCK'' THEN ''SCS'' WHEN T0.MEASURE = ''BALANCE'' THEN ''ERP'' ELSE '' '' END) AS TYPE' || CHR(10)
                || '       , (CASE WHEN T0.MEASURE = ''WH_STOCK'' THEN NVL(T5.QTY, 0)' || CHR(10)
                || '               WHEN T0.MEASURE = ''BALANCE''  THEN NVL(T6.QTY, 0)' || CHR(10)
                || '          ELSE NULL END)               AS FIGURE' || CHR(10)
                || '       , NVL(T0.FROM_SITE, ''-'')      AS FROM_SITE' || CHR(10)
                || '       , NVL(T4.SITE_DESCRIPTION, ''/'') AS FROM_SITE_NM' || CHR(10)
                || '       , T0.MEASURE                    AS MEASURE' || CHR(10)
                || '       , T2.ATTRIBUTE1                 AS PSI_NAME' || CHR(10)
                || '       , T0.SEQ' || CHR(10)
                || '       , CASE WHEN NVL(T4.SHIP_FROZEN, 0) - 1 > 0 THEN T4.SHIP_FROZEN - 1 ELSE 0 END AS SHIP_FROZEN' || CHR(10)
                || V_MQRY_SUM
                || '    FROM GT_SSP0015_PK_RESULT_PIVOT T0' || CHR(10)
                || '       , SCM_MST_SHEET_MEASURE T2' || CHR(10)
                || '       , SCM_MST_TITLESET_USER T3' || CHR(10)
                || '       , SCM_MST_SITE T4' || CHR(10)
                || '       , GT_SSP0015_PK_WH_STOCK T5' || CHR(10)
                || '       , GT_SSP0015_PK_ERP_STOCK T6' || CHR(10)
                || '       , (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME FROM SCM_MST_ITEM_SN' || CHR(10)
                || '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || '''' || CHR(10)
                || '             AND ACTIVE_FLAG = ''Y''' || CHR(10)
                || '             AND SCP_OPERATION_GROUP = ''P'') IT' || CHR(10)
--                || '       , SSP_MST_MODEL_USER TT3' || CHR(10)
                || '   WHERE T0.MEASURE = T2.COLUMN_NAME' || CHR(10)
                || '     AND T2.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                || '     AND T2.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                || '     AND T3.PROGRAM_ID(+)  = T2.PROGRAM_ID' || CHR(10)
                || '     AND T3.SHEET_NAME(+)  = T2.SHEET_NAME' || CHR(10)
                || '     AND T3.COLUMN_NAME(+) = T2.COLUMN_NAME' || CHR(10)
                || '     AND T3.USER_ID(+)     = ''' || P_USER_ID || '''' || CHR(10)
                || '     AND T0.DIVISION_ID = T4.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.FROM_SITE   = T4.SCM_SITE_ID(+)' || CHR(10)
                || '     AND T4.VALID_YN(+) = ''Y''' || CHR(10)
                || '     AND T0.DIVISION_ID = T5.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.FROM_SITE   = T5.FROM_SITE(+)' || CHR(10)
                || '     AND T0.ITEM_ID     = T5.ITEM_ID(+)' || CHR(10)
                || '     AND T5.YYYYMMDD(+) = ''' || V_CUTOFF_DATE || '''' || CHR(10)
                || '     AND T5.MEASURE(+)  = ''WH_STOCK''' || CHR(10)
                || '     AND T0.DIVISION_ID = T6.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.ITEM_ID     = T6.ITEM_ID(+)' || CHR(10)
                || '     AND T0.DIVISION_ID = IT.DIVISION_ID' || CHR(10)
                || '     AND T0.ITEM_ID     = IT.ITEM_ID' || CHR(10)
--                || '     AND TT3.DIVISION_ID(+) = T0.DIVISION_ID' || CHR(10)
--                || '     AND TT3.FROM_SITE(+)   = T0.FROM_SITE' || CHR(10)
--                || '     AND TT3.ITEM_ID(+)     = T0.ITEM_ID' || CHR(10)
--                || '     AND TT3.VALID_YN(+)    = ''Y''' || CHR(10)
--                || '     AND T2.VALID_YN = ''Y''' || CHR(10)
                || '     AND T2.VALID_YN = ''Y''' || CHR(10);   -- 2026.09.17 AJS
--                /* 체크박스 체크 여부 조회 */
--                || '     AND ((''' || P_NONCHK || ''' = ''Y'' AND 1 = 1)' || CHR(10)
--                || '           OR TT3.USER_ID IN (SELECT CASE WHEN ''' || P_MYMODELCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END FROM DUAL' || CHR(10)
--                || '                               UNION' || CHR(10)
--                || '                              SELECT CASE WHEN ''' || P_DELEGATEECHK || ''' = ''Y'' THEN USER_ID ELSE ''X'' END' || CHR(10)
--                || '                                FROM SSP_MST_DELEGATE WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' || P_USER_ID || ''' GROUP BY USER_ID)' || CHR(10)
--                || '           OR TT3.PART_LEADER = CASE WHEN ''' || P_PARTLEADERCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END' || CHR(10)
--                || '           OR TT3.TEAM_LEADER = CASE WHEN ''' || P_TEAMLEADERCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END)' || CHR(10);

        IF P_FROM_SITE IS NOT NULL THEN
            V_MEXEC := V_MEXEC
                || '     AND T0.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(''' || P_FROM_SITE || ''', '','')))' || CHR(10);
        END IF;

        V_MEXEC := V_MEXEC
                || '     AND (' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0' || CHR(10)
                || '           OR EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER SA' || CHR(10)
                || '                       WHERE SA.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                || '                         AND SA.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                || '                         AND SA.USER_ID    = ''' || P_USER_ID || '''' || CHR(10)
                || '                         AND SA.COLUMN_NAME = T2.COLUMN_NAME))' || CHR(10)
                || '     AND ((' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0 AND T2.DEFAULT_FLAG = ''Y'')' || CHR(10)
                || '           OR (' || TO_CHAR(V_CNT_USR_MEASURE) || ' != 0))' || CHR(10)
                || '   GROUP BY T0.DIVISION_ID, T0.ITEM_ID, IT.NICK_NAME, T0.FROM_SITE, T4.SITE_DESCRIPTION' || CHR(10)
                || '          , T0.MEASURE, T0.SEQ, T2.ATTRIBUTE1, T5.QTY, T6.QTY, T4.SHIP_FROZEN' || CHR(10)
                || ') TTT' || CHR(10)
                || ' ORDER BY TTT.DIVISION_ID, TTT.ITEM_ID, TTT.FROM_SITE DESC, TTT.SEQ ASC';

        OPEN O_RC1 FOR V_MEXEC;

        DBMS_LOB.FREETEMPORARY(V_MQRY_SUM);

    END P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
       AS-IS SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
       ※ AS-IS 는 문자열을 조립해 EXEC 로 돌리지만 만드는 것은 선택조건뿐이다.
          날짜 칸을 만드는 피벗이 아니므로 정적 SQL 로 옮겼다.
       ※ P_REAL_FLAG 갈래에 따라 결과셋의 칸 구성이 다르다(AS-IS 동일).
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_REQUESTOR             IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_SEARCH_YN             IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2 DEFAULT 'N',
        P_REAL_FLAG             IN  VARCHAR2 DEFAULT 'N',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'T',
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
         * Description  : Shipment PSI(Small)
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2019/03/11   AYJ 			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
         * 2019/05/09   AYJ 			MyModel 체크여부에 따른 조회조건 분기처리
         * 2019/05/20	AYJ				[CSR ID:3994743] REQUESTOR 컬럼 추가
         * 2019/06/17	AYJ			    조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
         * 2019/08/28	AYJ			    조회 조건 추가(p_delegateeChk)
         * 2019/12/17	KIMYONGHO		[C20191216-000311] Expected Shipping Date 컬럼 추가
         * 2020/09/21   KIMYONHHO      SSP INCOTERMS 변경 작업
         * 2021/02/04   KIMYONGHO	    ETA_DATE 조회 시 항차를 고려한 LT 적용되도록 함수 적용 FN_GET_SSP_ETA_DATE
         * 2021/10/05   SHINMYUNGSU	    SSP_ANL_SHIP_CONFIRM 의 Attribute3,6 항목 추가
         * 2021/10/12   KIMYONGHO	    [C20211001-000241] Confirm 복사하여 신규 생성 기능 추가
         * 2023/09/21   jilee          G182-P (Group='P',OSP='N')조회 추가
         * 2024/09/03   SSP            Team 컬럼 추가
         * 2024/10/01   KHJ            NERP_SSP
         * 2026.09.16   AJS            MSSQL -> Oracle 전환 (동적 SQL -> 정적 SQL)
         */
    BEGIN

        IF P_REAL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
            SELECT AA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.ERP_SO_NO
                         , A.SHIPMENT_STATUS
                         , A.PROJECT_CODE
                         , FN_GET_PROJECT_NAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.PROJECT_CODE) AS PROJECT_NAME
                         , A.FCST_TYPE
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                         , CASE WHEN REGEXP_LIKE(A.YYYYMMDD, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                         , A.BEFORE_QTY                      AS BEFORE_QTY
                         , TRUNC(A.QTY)                      AS SHIPMENT_CONFIRM_QTY
                         , A.REMARKS
                         , A.REMARKS2
                         , A.REMARKS3
                         , A.FROM_SITE
                         , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                         , A.TO_SITE
                         , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE), '-')   AS TO_SITE_DESCRIPTION
                         , A.TO_SITE_SOLDTO_CODE
                         , A.TO_SITE_SHIPTO_CODE
                         , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                         , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                         , A.BOD_ID
                         , B.SSP_INCOTERMS                   AS INCOTERMS
                         , B.TRANSPORT_MODE
                         , B.LT_TOTAL                        AS LT_DAY
                         , CASE WHEN REGEXP_LIKE(A.ETD_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD
                         , CASE WHEN REGEXP_LIKE(A.ETA_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA
                         , CASE WHEN B.TRANSPORT_MODE = 'TRK' THEN '-'
                                ELSE (SELECT CASE WHEN REGEXP_LIKE(SA.V, '^[0-9]{8}$')
                                                  THEN TO_CHAR(TO_DATE(SA.V, 'YYYYMMDD'), 'YYYY-MM-DD') END
                                        FROM (SELECT FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD) AS V FROM DUAL) SA)
                           END                               AS EXPECTED_SHIPPING_DATE
                         , A.CONFIRM_ID
/* 2026.09.30 AJS 수정 (START) */
--                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
/* 2026.09.30 AJS 수정 (END) */
                           END                               AS UPDATED_BY
/* 2026.09.30 AJS 수정 (START) */
--                         , CASE WHEN U.USERNAME IS NOT NULL THEN A.LAST_UPDATE_DATE END AS UPDATED_DATE
                         , CASE WHEN U.USER_NM IS NOT NULL THEN A.LAST_UPDATE_DATE END AS UPDATED_DATE
/* 2026.09.30 AJS 수정 (END) */
                         , A.ERP_STATUS
                         , A.CHANGE_TYPE
                           /* AS-IS 는 UNION 반대편이 '-' 라 문자로 쓰인다. Oracle 은 NUMBER 라 문자로 맞춘다. */
                         , TO_CHAR(A.ROUTE_ID)               AS NEW_ROUTE_ID
                         , A.BOD_ID                          AS NEW_BOD_ID
                         , B.SSP_INCOTERMS                   AS NEW_INCOTERMS
                         , A.D_COUNTRY                       AS NEW_D_COUNTRY
                         , A.D_PORT_CODE                     AS NEW_D_PORT_CODE
                         , A.A_COUNTRY                       AS NEW_A_COUNTRY
                         , A.A_PORT_CODE                     AS NEW_A_PORT_CODE
                         , TO_CHAR(A.CUSTOMER_LT)            AS NEW_CUSTOMER_LT
                         , A.TO_COUNTRY                      AS NEW_TO_COUNTRY
                         , A.TO_CITY                         AS NEW_TO_CITY
                         , CASE WHEN REGEXP_LIKE(A.ETA_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS NEW_ETA
                         , CASE WHEN REGEXP_LIKE(A.ETD_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS NEW_ETD
                         , TO_CHAR(B.LT_TOTAL)               AS NEW_LT_DAY
                         , B.TRANSPORT_MODE                  AS NEW_TRANSPORT_MODE
                         , CASE WHEN REGEXP_LIKE(A.YYYYMMDD, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS NEW_SHIPMENT_DATE
                         , 'N'                               AS EDIT_REMARKS
                         , 'N'                               AS EDIT_MAIN
                         , NVL(A.CHECK_NEED_YN, 'N')         AS CHECK_NEED_YN
                         , NVL(CASE WHEN A.DIVISION_ID = '40'
                                    THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE != '-'
                                              THEN A.PROJECT_CODE ELSE G.PROJECT_CODE END
                                    WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40'
                                    THEN G.PROJECT_CODE
                                    ELSE F.END_CUSTOMER END, '/') AS END_CUSTOMER
                         , A.ELECTRODE_YN
                         , A.ELECTRODE_TYPE
                         , A.ORIGIN_FROM_DIVISION_ID
                         , A.ORIGIN_TO_DIVISION_ID
                         , H.CHANGE_REQ_NO
/* 2026.09.30 AJS 수정 (START) */
--                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END) IS NULL THEN NULL
--                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END) || '(' || MU.USER_ID || ')'
                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) IS NULL THEN NULL
                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) || '(' || MU.USER_ID || ')'
/* 2026.09.30 AJS 수정 (END) */
                           END                               AS MODEL_USER
                         , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, ',', P_LANGUAGE) AS MTK_OWNER
--                         , (SELECT NVL(MIN(SA.DEPT_NAME_KO), '-')
                         , (SELECT CASE WHEN COUNT(*) = 0 THEN NULL ELSE NVL(MIN(SA.DEPT_NAME_KO), '-') END   -- 2026.09.17 AJS
                              FROM SCM_MST_SSO_DEPT_INFO SA
/* 2026.09.30 AJS 수정 (START) */
--                                 , TB_FX_USER SB
                                 , SCM_ADM_USER_M SB
/* 2026.09.30 AJS 수정 (END) */
                             WHERE SA.DEPT_ID = SB.DEPT_ID(+)
--                               AND SB.USERID  = SI.OWNER)    AS TEAM
/* 2026.09.30 AJS 수정 (START) */
--                               AND UPPER(SB.USERID) = UPPER(SI.OWNER)) AS TEAM   -- 2026.09.17 AJS
--                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USERNAME ELSE U3.USERNAME_E END) IS NULL THEN NULL
--                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USERNAME ELSE U3.USERNAME_E END) || '(' || A.REQUESTOR || ')'
                               AND UPPER(SB.USER_ID) = UPPER(SI.OWNER)) AS TEAM  -- 2026.09.17 AJS
                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USER_NM ELSE U3.USER_ENG_NM END) IS NULL THEN NULL
                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USER_NM ELSE U3.USER_ENG_NM END) || '(' || A.REQUESTOR || ')'
/* 2026.09.30 AJS 수정 (END) */
                           END                               AS REQUESTOR
                         , '-'                               AS CHANGE_REASON_CODE
                         , ''                                AS CHANGE_REASON_DETAIL
                           /* [C20211001-000241] Confirm 복사하여 신규 생성 기능 추가 */
                         , NVL(A.ATTRIBUTE10, '-')           AS ATTRIBUTE10
                           /* 2021/10/05 SHINMYUNGSU 열람 항목추가 */
                         , NVL(A.ATTRIBUTE3, '-')            AS ATTRIBUTE3
                         , NVL(A.ATTRIBUTE6, '-')            AS ATTRIBUTE6
                      FROM SSP_ANL_SHIP_CONFIRM A
                         , SCM_MST_SITE MS
                         , SCP_MST_BOD_N_V B
/* 2026.09.30 AJS 수정 (START) */
--                         , TB_FX_USER U
                         , SCM_ADM_USER_M U
/* 2026.09.30 AJS 수정 (END) */
                         , SCM_MST_SITE F
                         , (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                              FROM (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                                         , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ORDER BY PROJECT_CODE) AS NUM
                                      FROM SCM_MST_SITE_ITEM)
                             WHERE NUM = 1) G
                         , (SELECT CONFIRM_ID, CHANGE_REQ_NO
                              FROM (SELECT CONFIRM_ID, CHANGE_REQ_NO
                                         , ROW_NUMBER() OVER (PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) AS NUM
                                      FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                     WHERE VALID_YN = 'Y')
                             WHERE NUM = 1) H
                         , SSP_MST_MODEL_USER MU
/* 2026.09.30 AJS 수정 (START) */
--                         , TB_FX_USER U2
--                         , TB_FX_USER U3
                         , SCM_ADM_USER_M U2
                         , SCM_ADM_USER_M U3
/* 2026.09.30 AJS 수정 (END) */
                         , SCM_MST_SITE_ITEM SI
                         , SSP_ANL_SHIP_CONFIRM_CHG_REQ T1
                     WHERE A.DIVISION_ID = MS.DIVISION_ID
                       AND A.FROM_SITE   = MS.SCM_SITE_ID
                       AND MS.SITE_TYPE  = 'PLANT'
                       AND A.DIVISION_ID = '40'
                       AND (MS.OPERATION_GROUP = 'A' OR MS.OSP_YN = 'N')
                       AND CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END = B.DIVISION_ID
                       AND A.BOD_ID      = B.BOD_ID
--                       AND A.LAST_UPDATED_BY = U.USERID(+)
/* 2026.09.30 AJS 수정 (START) */
--                       AND UPPER(A.LAST_UPDATED_BY) = UPPER(U.USERID(+))   -- 2026.09.17 AJS
--                       AND U.USEYN(+)        = 'Y'
                       AND UPPER(A.LAST_UPDATED_BY) = UPPER(U.USER_ID(+))  -- 2026.09.17 AJS
                       AND U.USE_YN(+)       = 'Y'
/* 2026.09.30 AJS 수정 (END) */
                       AND F.DIVISION_ID(+)  = A.ORIGIN_TO_DIVISION_ID
                       AND F.SCM_SITE_ID(+)  = A.TO_SITE
                       AND F.VALID_YN(+)     = 'Y'
                       AND G.DIVISION_ID(+)  = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND G.SCM_SITE_ID(+)  = A.TO_SITE
                       AND G.ITEM_ID(+)      = A.ITEM_ID
                       AND H.CONFIRM_ID(+)   = A.CONFIRM_ID
                       AND MU.DIVISION_ID(+) = A.ORIGIN_FROM_DIVISION_ID
                       AND MU.FROM_SITE(+)   = A.FROM_SITE
                       AND MU.ITEM_ID(+)     = A.ITEM_ID
                       AND MU.VALID_YN(+)    = 'Y'
--                       AND MU.USER_ID        = U2.USERID(+)
/* 2026.09.30 AJS 수정 (START) */
--                       AND UPPER(MU.USER_ID)  = UPPER(U2.USERID(+))   -- 2026.09.17 AJS
--                       AND U2.USEYN(+)       = 'Y'
                       AND UPPER(MU.USER_ID)  = UPPER(U2.USER_ID(+))  -- 2026.09.17 AJS
                       AND U2.USE_YN(+)      = 'Y'
/* 2026.09.30 AJS 수정 (END) */
--                       AND A.REQUESTOR       = U3.USERID(+)
/* 2026.09.30 AJS 수정 (START) */
--                       AND UPPER(A.REQUESTOR) = UPPER(U3.USERID(+))   -- 2026.09.17 AJS
--                       AND U3.USEYN(+)       = 'Y'
                       AND UPPER(A.REQUESTOR) = UPPER(U3.USER_ID(+))  -- 2026.09.17 AJS
                       AND U3.USE_YN(+)      = 'Y'
/* 2026.09.30 AJS 수정 (END) */
                       AND SI.DIVISION_ID(+)  = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND SI.SCM_SITE_ID(+)  = A.TO_SITE
                       AND SI.ITEM_ID(+)      = A.ITEM_ID
                       AND SI.PROJECT_CODE(+) = A.PROJECT_CODE
                       AND H.CHANGE_REQ_NO    = T1.CHANGE_REQ_NO(+)
                       /* Search 버튼으로 조회(체크박스 체크 여부에 따라 조회) */
--                       AND (P_SEARCH_YN != 'Y'
                       AND (NVL(P_SEARCH_YN, 'N') != 'Y'   -- 2026.09.17 AJS
                             OR ((P_NONCHK = 'Y' AND 1 = 1)
--                                  OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                  OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END FROM DUAL   -- 2026.09.17 AJS
                                                     UNION
                                                    SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                      FROM SSP_MST_DELEGATE
                                                     WHERE VALID_YN = 'Y'
--                                                       AND DELEGATEE_ID = P_USER_ID
                                                       AND DELEGATEE_ID = LOWER(P_USER_ID)   -- 2026.09.17 AJS
                                                     GROUP BY USER_ID)
--                                  OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                  OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END   -- 2026.09.17 AJS
--                                  OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END))
                                  OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END))   -- 2026.09.17 AJS
                       AND A.YYYYMMDD >= P_FROM_YYYYMMDD
                       AND A.YYYYMMDD <= P_TO_YYYYMMDD
                       AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                             OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
                       AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                             OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                             OR UPPER(A.ITEM_ID) IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
                       AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                             OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                       AND ((P_REQUESTOR IS NULL OR P_REQUESTOR = '')
--                             OR A.REQUESTOR IN (SELECT DISTINCT SA.USERID
/* 2026.09.30 AJS 수정 (START) */
--                             OR UPPER(A.REQUESTOR) IN (SELECT DISTINCT UPPER(SA.USERID)   -- 2026.09.17 AJS
--                                                  FROM TB_FX_USER SA
                             OR UPPER(A.REQUESTOR) IN (SELECT DISTINCT UPPER(SA.USER_ID)  -- 2026.09.17 AJS
                                                  FROM SCM_ADM_USER_M SA
/* 2026.09.30 AJS 수정 (END) */
--                                                 WHERE SA.USERNAME IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
/* 2026.09.30 AJS 수정 (START) */
--                                                 WHERE UPPER(SA.USERNAME) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))   -- 2026.09.17 AJS
                                                 WHERE UPPER(SA.USER_NM) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))    -- 2026.09.17 AJS
/* 2026.09.30 AJS 수정 (END) */
--                                                    OR SA.USERID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
/* 2026.09.30 AJS 수정 (START) */
--                                                    OR UPPER(SA.USERID) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))   -- 2026.09.17 AJS
                                                    OR UPPER(SA.USER_ID) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))  -- 2026.09.17 AJS
/* 2026.09.30 AJS 수정 (END) */
                       AND A.SHIPMENT_STATUS IS NOT NULL
                       AND A.QTY > 0
                       AND A.CHANGE_TYPE <> 'N'
                       AND A.BIZ_TYPE    <> 'E'
                    UNION ALL
                    SELECT T.DIVISION_ID
                         , T.ERP_SO_NO
                         , T.SHIPMENT_STATUS
                         , T.PROJECT_CODE
                         , T.PROJECT_NAME
                         , T.FCST_TYPE
                         , T.ITEM_ID
                         , T.NICK_NAME
                         , CASE WHEN REGEXP_LIKE(T.SHIPMENT_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(T.SHIPMENT_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                         , 0                                 AS BEFORE_QTY
                         , T.QTY                             AS SHIPMENT_CONFIRM_QTY
                         , T.REMARKS
                         , T.REMARKS2
                         , T.REMARKS3
                         , T.FROM_SITE
                         , T.FROM_SITE_DESCRIPTION
                         , T.TO_SITE
                         , T.TO_SITE_DESCRIPTION
                         , T.TO_SITE_SOLDTO_CODE
                         , T.TO_SITE_SHIPTO_CODE
                         , T.SOLDTO_DESCRIPTION
                         , T.SHIPTO_DESCRIPTION
                         , T.BOD_ID
                         , T.INCOTERMS
                         , T.TRANSPORT_MODE
                         , T.LT_TOTAL                        AS LT_DAY
                         , T.ETD
                         , T.ETA
                         , T.EXPECTED_SHIPPING_DATE
                         , T.CONFIRM_ID
                         , T.LAST_UPDATED_BY                 AS UPDATED_BY
                         , T.LAST_UPDATE_DATE                AS UPDATED_DATE
                         , '-'                               AS ERP_STATUS
                         , '-'                               AS CHANGE_TYPE
--                         , '-'                               AS NEW_ROUTE_ID
                         , '0'                               AS NEW_ROUTE_ID   -- 2026.09.17 AJS
                         , '-'                               AS NEW_BOD_ID
                         , '-'                               AS NEW_INCOTERMS
                         , '-'                               AS NEW_D_COUNTRY
                         , '-'                               AS NEW_D_PORT_CODE
                         , '-'                               AS NEW_A_COUNTRY
                         , '-'                               AS NEW_A_PORT_CODE
--                         , '-'                               AS NEW_CUSTOMER_LT
                         , '0'                               AS NEW_CUSTOMER_LT   -- 2026.09.17 AJS
                         , '-'                               AS NEW_TO_COUNTRY
                         , '-'                               AS NEW_TO_CITY
                         , '-'                               AS NEW_ETA
                         , '-'                               AS NEW_ETD
--                         , '-'                               AS NEW_LT_DAY
                         , '0'                               AS NEW_LT_DAY   -- 2026.09.17 AJS
                         , '-'                               AS NEW_TRANSPORT_MODE
                         , '-'                               AS NEW_SHIPMENT_DATE
                         , '-'                               AS EDIT_REMARKS
                         , '-'                               AS EDIT_MAIN
                         , '-'                               AS CHECK_NEED_YN
                         , '-'                               AS END_CUSTOMER
                         , '-'                               AS ELECTRODE_YN
                         , '-'                               AS ELECTRODE_TYPE
                         , '-'                               AS ORIGIN_FROM_DIVISION_ID
                         , '-'                               AS ORIGIN_TO_DIVISION_ID
                         , '-'                               AS CHANGE_REQ_NO
                         , '-'                               AS MODEL_USER
                         , TO_CLOB('-')                      AS MTK_OWNER
                         , '-'                               AS TEAM
                         , '-'                               AS REQUESTOR
                         , '-'                               AS CHANGE_REASON_CODE
                         , '-'                               AS CHANGE_REASON_DETAIL
                         , '-'                               AS ATTRIBUTE10
                         , '-'                               AS ATTRIBUTE3
                         , '-'                               AS ATTRIBUTE6
                      FROM (
                            SELECT TT0.DIVISION_ID
                                 , NULL                       AS ERP_SO_NO
                                 , 'P'                        AS SHIPMENT_STATUS
                                 , TT0.ITEM_ID
                                 , FN_GET_ITEM_NICKNAME(TT0.DIVISION_ID, TT0.ITEM_ID) AS NICK_NAME
                                 , TT0.DIVISION_ID            AS ORIGIN_FROM_DIVISION_ID
                                 , TT0.DIVISION_ID            AS ORIGIN_TO_DIVISION_ID
                                 , TT0.PLANT_SITE_ID          AS FROM_SITE
                                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(TT0.DIVISION_ID, TT0.PLANT_SITE_ID), '-') AS FROM_SITE_DESCRIPTION
                                 , TT0.SCM_SITE_ID            AS TO_SITE
                                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(TT0.DIVISION_ID, TT0.SCM_SITE_ID), '-')   AS TO_SITE_DESCRIPTION
                                 , TT0.PROJECT_CODE
                                 , FN_GET_PROJECT_NAME(TT0.DIVISION_ID, TT0.PROJECT_CODE) AS PROJECT_NAME
                                 , '-'                        AS REQUESTOR
                                 , TT0.QTY
                                 , TT0.YYYYMMDD               AS SHIPMENT_DATE
                                 , TT0.BOD_ID
                                 , TT0.INCOTERMS
                                 , TT0.TRANSPORT_MODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT0.SCM_SITE_ID, 'SOLDTO_CODE')        AS TO_SITE_SOLDTO_CODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT0.SCM_SITE_ID, 'SHIPTO_CODE')        AS TO_SITE_SHIPTO_CODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT0.SCM_SITE_ID, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT0.SCM_SITE_ID, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                                 , '-'                        AS REMARKS2
                                 , '-'                        AS REMARKS
                                 , '-'                        AS CHANGE_REQ_NO
                                 , '-'                        AS REMARKS3
                                 , CASE WHEN REGEXP_LIKE(TT0.YYYYMMDD, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD
                                 , (SELECT CASE WHEN REGEXP_LIKE(SA.V, '^[0-9]{8}$')
                                                THEN TO_CHAR(TO_DATE(SA.V, 'YYYYMMDD'), 'YYYY-MM-DD') END
                                      FROM (SELECT FN_GET_SSP_ETA_DATE(TT0.DIVISION_ID, TT0.BOD_ID, TT0.YYYYMMDD) AS V FROM DUAL) SA) AS ETA
                                 , CASE WHEN TT0.TRANSPORT_MODE = 'TRK' THEN '-'
                                        ELSE (SELECT CASE WHEN REGEXP_LIKE(SB.V, '^[0-9]{8}$')
                                                          THEN TO_CHAR(TO_DATE(SB.V, 'YYYYMMDD'), 'YYYY-MM-DD') END
                                                FROM (SELECT FN_GET_SSP_EXPECTED_SHIP_DATE(TT0.DIVISION_ID, TT0.BOD_ID, TT0.YYYYMMDD) AS V FROM DUAL) SB)
                                   END                        AS EXPECTED_SHIPPING_DATE
                                 , TT1.LT_TOTAL
                                 , TT0.LAST_UPDATED_BY
                                 , TT0.LAST_UPDATE_DATE
                                 , '-'                        AS CONFIRM_ID
                                 , TT0.FCST_TYPE
                                 , CASE WHEN NVL(TT2.SHIP_FROZEN, 0) > 0
                                        THEN TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(TT2.SHIP_FROZEN, 0), 'YYYYMMDD')
                                        ELSE P_PLAN_START_YYYYMMDD END AS FROZEN_YYYYMMDD
                              FROM DM_PLN_SHIPMENT_REQ TT0
                                 , SCP_MST_BOD_N_V TT1
                                 , SCM_MST_SITE TT2
                                 , SSP_MST_MODEL_USER MU
/* 2026.09.30 AJS 수정 (START) */
--                                 , TB_FX_USER U2
                                 , SCM_ADM_USER_M U2
/* 2026.09.30 AJS 수정 (END) */
                             WHERE TT0.DIVISION_ID = TT1.DIVISION_ID
                               AND TT0.BOD_ID      = TT1.BOD_ID
                               AND TT0.DIVISION_ID = TT2.DIVISION_ID
                               AND TT0.PLANT_SITE_ID = TT2.SCM_SITE_ID
                               AND TT2.SITE_TYPE   = 'PLANT'
                               AND TT2.VALID_YN    = 'Y'
                               AND MU.DIVISION_ID(+) = TT0.DIVISION_ID
                               AND MU.FROM_SITE(+)   = TT0.PLANT_SITE_ID
                               AND MU.ITEM_ID(+)     = TT0.ITEM_ID
                               AND MU.VALID_YN(+)    = 'Y'
--                               AND MU.USER_ID        = U2.USERID(+)
/* 2026.09.30 AJS 수정 (START) */
--                               AND UPPER(MU.USER_ID) = UPPER(U2.USERID(+))   -- 2026.09.17 AJS
--                               AND U2.USEYN(+)       = 'Y'
                               AND UPPER(MU.USER_ID) = UPPER(U2.USER_ID(+))  -- 2026.09.17 AJS
                               AND U2.USE_YN(+)      = 'Y'
/* 2026.09.30 AJS 수정 (END) */
                               AND TT0.DIVISION_ID   = P_DIVISION_ID
--                               AND (P_SEARCH_YN != 'Y'
                               AND (NVL(P_SEARCH_YN, 'N') != 'Y'   -- 2026.09.17 AJS
                                     OR ((P_NONCHK = 'Y' AND 1 = 1)
--                                          OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                          OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END FROM DUAL   -- 2026.09.17 AJS
                                                             UNION
                                                            SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                              FROM SSP_MST_DELEGATE
                                                             WHERE VALID_YN = 'Y'
--                                                               AND DELEGATEE_ID = P_USER_ID
                                                               AND DELEGATEE_ID = LOWER(P_USER_ID)   -- 2026.09.17 AJS
                                                             GROUP BY USER_ID)
--                                          OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                          OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END   -- 2026.09.17 AJS
--                                          OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END))
                                          OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END))   -- 2026.09.17 AJS
                           ) T
                     WHERE 1 = 1
                       AND T.SHIPMENT_DATE >= T.FROZEN_YYYYMMDD
                       AND T.SHIPMENT_DATE >= P_FROM_YYYYMMDD
                       AND T.SHIPMENT_DATE <= P_TO_YYYYMMDD
                       AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                             OR T.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                             OR UPPER(T.ITEM_ID) IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
                       AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                             OR T.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                       AND ((P_REQUESTOR IS NULL OR P_REQUESTOR = '')
--                             OR T.LAST_UPDATED_BY IN (SELECT DISTINCT SA.USERID
/* 2026.09.30 AJS 수정 (START) */
--                             OR UPPER(T.LAST_UPDATED_BY) IN (SELECT DISTINCT UPPER(SA.USERID)   -- 2026.09.17 AJS
--                                                        FROM TB_FX_USER SA
                             OR UPPER(T.LAST_UPDATED_BY) IN (SELECT DISTINCT UPPER(SA.USER_ID)  -- 2026.09.17 AJS
                                                        FROM SCM_ADM_USER_M SA
/* 2026.09.30 AJS 수정 (END) */
--                                                       WHERE SA.USERNAME IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
/* 2026.09.30 AJS 수정 (START) */
--                                                       WHERE UPPER(SA.USERNAME) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))   -- 2026.09.17 AJS
                                                       WHERE UPPER(SA.USER_NM) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))    -- 2026.09.17 AJS
/* 2026.09.30 AJS 수정 (END) */
--                                                          OR SA.USERID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
/* 2026.09.30 AJS 수정 (START) */
--                                                          OR UPPER(SA.USERID) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))   -- 2026.09.17 AJS
                                                          OR UPPER(SA.USER_ID) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))  -- 2026.09.17 AJS
/* 2026.09.30 AJS 수정 (END) */
                   ) AA
--             ORDER BY AA.DIVISION_ID
             ORDER BY AA.DIVISION_ID NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.SHIPMENT_STATUS
                 , AA.SHIPMENT_STATUS NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.SHIPMENT_DATE
                 , AA.SHIPMENT_DATE NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.ITEM_ID
                 , AA.ITEM_ID NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.ERP_SO_NO DESC
                 , AA.ERP_SO_NO DESC NULLS LAST   -- 2026.09.17 AJS
--                 , AA.FROM_SITE
                 , AA.FROM_SITE NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.TO_SITE
                 , AA.TO_SITE NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.PROJECT_CODE
                 , AA.PROJECT_CODE NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.FCST_TYPE;
                 , AA.FCST_TYPE NULLS FIRST;   -- 2026.09.17 AJS

        ELSE

            OPEN O_RC1 FOR
            SELECT AA.*
              FROM (
                    SELECT T0.DIVISION_ID
                         , T0.ERP_SO_NO
                         , T0.SHIPMENT_STATUS
                         , T0.PROJECT_CODE
                         , T0.PROJECT_NAME
                         , T0.FCST_TYPE
                         , T0.ITEM_ID
                         , T0.NICK_NAME
                         , T0.SHIPMENT_DATE
                         , T0.SHIPMENT_CONFIRM_QTY
                         , T0.REMARKS
                         , T0.REMARKS2
                         , T0.REMARKS3
                         , T0.FROM_SITE
                         , T0.FROM_SITE_DESCRIPTION
                         , T0.TO_SITE
                         , T0.TO_SITE_DESCRIPTION
                         , T0.TO_SITE_SOLDTO_CODE
                         , T0.TO_SITE_SHIPTO_CODE
                         , T0.SOLDTO_DESCRIPTION
                         , T0.SHIPTO_DESCRIPTION
                         , T0.BOD_ID
                         , T0.INCOTERMS
                         , T0.TRANSPORT_MODE
                         , T0.LT_DAY
                         , T0.ETD
                         , T0.ETA
                         , T0.EXPECTED_SHIPPING_DATE
                         , T0.CONFIRM_ID
                         , T0.UPDATED_BY
                         , T0.UPDATED_DATE
                         , '-'                               AS ERP_STATUS
                         , '-'                               AS CHANGE_TYPE
                         , '-'                               AS NEW_ROUTE_ID
                         , '-'                               AS NEW_BOD_ID
                         , '-'                               AS NEW_INCOTERMS
                         , '-'                               AS NEW_D_COUNTRY
                         , '-'                               AS NEW_D_PORT_CODE
                         , '-'                               AS NEW_A_COUNTRY
                         , '-'                               AS NEW_A_PORT_CODE
                         , '-'                               AS NEW_CUSTOMER_LT
                         , '-'                               AS NEW_TO_COUNTRY
                         , '-'                               AS NEW_TO_CITY
                         , '-'                               AS NEW_ETA
                         , '-'                               AS NEW_ETD
                         , '-'                               AS NEW_LT_DAY
                         , '-'                               AS NEW_TRANSPORT_MODE
                         , '-'                               AS NEW_SHIPMENT_DATE
                         , '-'                               AS EDIT_REMARKS
                         , '-'                               AS EDIT_MAIN
                         , '-'                               AS CHECK_NEED_YN
                         , T0.END_CUSTOMER                   AS END_CUSTOMER
                         , '-'                               AS ELECTRODE_YN
                         , '-'                               AS ELECTRODE_TYPE
                         , '-'                               AS ORIGIN_FROM_DIVISION_ID
                         , '-'                               AS ORIGIN_TO_DIVISION_ID
                         , T0.CHANGE_REQ_NO                  AS CHANGE_REQ_NO
                         , T0.MODEL_USER                     AS MODEL_USER
                         , T0.MTK_OWNER                      AS MTK_OWNER
                         , T0.REQUESTOR                      AS REQUESTOR
                         , '-'                               AS CHANGE_REASON_CODE
                         , '-'                               AS CHANGE_REASON_DETAIL
                         , '-'                               AS ATTRIBUTE10
                         , T0.ATTRIBUTE3
                         , T0.ATTRIBUTE6
                      FROM (
                            SELECT TT0.DIVISION_ID
                                 , TT0.ERP_SO_NO
                                 , TT0.SHIPMENT_STATUS
                                 , TT0.ITEM_ID
                                 , TT0.NICK_NAME
                                 , TT0.ORIGIN_FROM_DIVISION_ID
                                 , TT0.ORIGIN_TO_DIVISION_ID
                                 , TT0.FROM_SITE
                                 , TT0.FROM_SITE_DESCRIPTION
                                 , TT0.TO_SITE
                                 , TT0.TO_SITE_DESCRIPTION
                                 , TT0.PROJECT_CODE
                                 , TT0.PROJECT_NAME
                                 , TT0.REQUESTOR
                                 , TT0.SHIPMENT_CONFIRM_QTY
                                 , CASE WHEN REGEXP_LIKE(TT0.YYYYMMDD, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                                 , TT0.BOD_ID
                                 , TT0.INCOTERMS
                                 , TT0.TRANSPORT_MODE
                                 , TT0.TO_SITE_SOLDTO_CODE
                                 , TT0.TO_SITE_SHIPTO_CODE
                                 , TT0.SOLDTO_DESCRIPTION
                                 , TT0.SHIPTO_DESCRIPTION
                                 , TT0.REMARKS2
                                 , TT0.REMARKS
                                 , TT0.CHANGE_REQ_NO
                                 , TT0.REMARKS3
                                 , CASE WHEN REGEXP_LIKE(TT0.ETD, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.ETD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD
                                 , CASE WHEN REGEXP_LIKE(TT0.ETA, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.ETA, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA
                                 , TT0.EXPECTED_SHIPPING_DATE
                                 , TT0.LT_DAY                AS LT_DAY
                                 , TT0.UPDATED_BY            AS UPDATED_BY
                                 , TT0.UPDATED_DATE          AS UPDATED_DATE
                                 , TT0.CONFIRM_ID            AS CONFIRM_ID
                                 , TT0.FCST_TYPE
                                 , TT0.END_CUSTOMER
                                 , TT0.MTK_OWNER
                                 , TT0.MODEL_USER
                                   /* 2021/10/05 SHINMYUNGSU 열람 항목추가 */
                                 , '-'                       AS ATTRIBUTE3
                                 , '-'                       AS ATTRIBUTE6
                              FROM SSP_ANL_SHIP_PLAN_ALL TT0
                                 , SSP_MST_MODEL_USER MU
                             WHERE MU.DIVISION_ID(+) = TT0.ORIGIN_FROM_DIVISION_ID
                               AND MU.FROM_SITE(+)   = TT0.FROM_SITE
                               AND MU.ITEM_ID(+)     = TT0.ITEM_ID
                               AND MU.VALID_YN(+)    = 'Y'
                               AND TT0.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                               AND TT0.DIVISION_ID         = P_DIVISION_ID
                               AND TT0.SHIPMENT_CONFIRM_QTY > 0
                               AND TT0.OPERATION_GROUP     <> 'E'
                               AND TT0.YYYYMMDD >= P_FROM_YYYYMMDD
                               AND TT0.YYYYMMDD <= P_TO_YYYYMMDD
                               AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                                     OR TT0.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
                               AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
--                                     OR TT0.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))
                                     OR UPPER(TT0.ITEM_ID) IN (SELECT UPPER(TOKEN) FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   -- 2026.09.17 AJS
                               AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                                     OR TT0.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                               AND ((P_REQUESTOR IS NULL OR P_REQUESTOR = '')
--                                     OR TT0.REQUESTOR IN (SELECT DISTINCT SA.USERID
/* 2026.09.30 AJS 수정 (START) */
--                                     OR UPPER(TT0.REQUESTOR) IN (SELECT DISTINCT UPPER(SA.USERID)   -- 2026.09.17 AJS
--                                                            FROM TB_FX_USER SA
                                     OR UPPER(TT0.REQUESTOR) IN (SELECT DISTINCT UPPER(SA.USER_ID)  -- 2026.09.17 AJS
                                                            FROM SCM_ADM_USER_M SA
/* 2026.09.30 AJS 수정 (END) */
--                                                           WHERE SA.USERNAME IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
/* 2026.09.30 AJS 수정 (START) */
--                                                           WHERE UPPER(SA.USERNAME) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))   -- 2026.09.17 AJS
                                                           WHERE UPPER(SA.USER_NM) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))    -- 2026.09.17 AJS
/* 2026.09.30 AJS 수정 (END) */
--                                                              OR SA.USERID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
/* 2026.09.30 AJS 수정 (START) */
--                                                              OR UPPER(SA.USERID) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))   -- 2026.09.17 AJS
                                                              OR UPPER(SA.USER_ID) IN (SELECT UPPER(REGEXP_REPLACE(TOKEN, '^N?''(.*)''$', '')) FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))  -- 2026.09.17 AJS
/* 2026.09.30 AJS 수정 (END) */
--                               AND (P_SEARCH_YN != 'Y'
                               AND (NVL(P_SEARCH_YN, 'N') != 'Y'   -- 2026.09.17 AJS
                                     OR ((P_NONCHK = 'Y' AND 1 = 1)
--                                          OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                          OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END FROM DUAL   -- 2026.09.17 AJS
                                                             UNION
                                                            SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                              FROM SSP_MST_DELEGATE
                                                             WHERE VALID_YN = 'Y'
--                                                               AND DELEGATEE_ID = P_USER_ID
                                                               AND DELEGATEE_ID = LOWER(P_USER_ID)   -- 2026.09.17 AJS
                                                             GROUP BY USER_ID)
--                                          OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                          OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END   -- 2026.09.17 AJS
--                                          OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END))
                                          OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN LOWER(P_USER_ID) ELSE 'X' END))   -- 2026.09.17 AJS
                           ) T0
                   ) AA
--             ORDER BY AA.DIVISION_ID
             ORDER BY AA.DIVISION_ID NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.SHIPMENT_STATUS
                 , AA.SHIPMENT_STATUS NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.SHIPMENT_DATE
                 , AA.SHIPMENT_DATE NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.ITEM_ID
                 , AA.ITEM_ID NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.ERP_SO_NO DESC
                 , AA.ERP_SO_NO DESC NULLS LAST   -- 2026.09.17 AJS
--                 , AA.FROM_SITE
                 , AA.FROM_SITE NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.TO_SITE
                 , AA.TO_SITE NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.PROJECT_CODE
                 , AA.PROJECT_CODE NULLS FIRST   -- 2026.09.17 AJS
--                 , AA.FCST_TYPE;
                 , AA.FCST_TYPE NULLS FIRST;   -- 2026.09.17 AJS

        END IF;

    END P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL;

END PKG_ZTMP_S015J;
/
SHOW ERRORS PACKAGE BODY PKG_ZTMP_S015J
