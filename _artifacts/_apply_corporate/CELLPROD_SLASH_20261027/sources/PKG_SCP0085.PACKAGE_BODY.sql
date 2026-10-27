PACKAGE BODY PKG_SCP0085
IS
    /*
     * Program ID   : PKG_SCP0085
     * Description  : SCP0085 Ending Inventory 화면 - 기말재고 월별 / 일별 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.25   ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.06   AJS            [속도] P_SCP0085_GET_ENDING_INVENTORY · _DAILY 조회조건 쉼표 목록 비교를 INSTR 로 변경(STRING_SPLIT 하위질의 제거) · 품목 원장 조인을 해시 조인으로 고정 · 조회 사업부에 81 이 없으면 F 원장 읽기 생략 · 자재분류 적재를 조회 대상 품목으로 한정
     * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * 2026.10.07   AJS            [속도2차] 셀 환산계수 적재(GT_SCP0085_CELL_CF)를 그 달(그 날) 기말재고 품목과 그 기본 품목으로 한정(연결 재사용 시 임시 테이블 삭제량 축소)
 * 2026.10.27   AJS            조회조건 Item Type · Profit Center 의 ALL 을 조건 없음으로 처리(P_SCP0085_GET_ENDING_INVENTORY · _DAILY)
     *
     * [전환 공통 규칙]
     * - AS-IS #TEMP 중 두 번 이상 참조하는 것은 전역 임시 테이블로 옮겼다(00_DDL).
     *   한 번만 참조하는 WITH 절(W_ITEM_EE · W_CELL_ASSY_SI)은 인라인 뷰로 옮겼다.
     * - AS-IS IIF(조건, 참, 거짓) 은 CASE 로, TOP 1 은 ROWNUM 으로 옮겼다.
     * - 보고시점 칸의 앞 따옴표는 AS-IS 가 쓰는 특수 문자를 리터럴로 그대로 적었다.
     *   ★CHR(8216) 과 UNISTR('\2018') 은 이 데이터베이스에서 다른 문자가 되어 쓸 수 없다.
     * - ★정렬은 FN_ASIS_SORT_KEY 를 쓴다. AS-IS 정렬은 하이픈을 빼고 견주고
     *   구두점이 숫자·문자보다 앞이라 이 데이터베이스 기본 순서로는 줄 순서가 갈린다.
     * - ★환산계수 칸은 AS-IS 가 문자로 돌려준다(숫자로 바꾸지 않는다).
     *   환산수량 칸은 AS-IS 가 이진 부동소수로 곱하므로 BINARY_DOUBLE 로 맞췄다.
     * - ★월별과 일별은 형제이지만 갈리는 곳이 있다(재고사이트 룩업 사용 여부 · 활성화 코드 사용 여부 ·
     *   ERP 구분 칸 위치 · 환산계수 분기). 각각 원문대로 옮겼다.
     */

    C_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SCP0085_GET_ENDING_INVENTORY';

    /* ==============================================================================================
       내부 : 결과 커서 (정상)
       ============================================================================================== */
    PROCEDURE P_OPEN_SUCCESS
    (
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN O_RESULT_CURSOR FOR
            SELECT '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;
    END P_OPEN_SUCCESS;

    /* ==============================================================================================
       내부 : 결과 커서 (오류)
       ============================================================================================== */
    PROCEDURE P_OPEN_ERROR
    (
        P_MESSAGE           IN  VARCHAR2,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1'      AS CODE
                 , P_MESSAGE AS MSG
              FROM DUAL;
    END P_OPEN_ERROR;

    /* ==============================================================================================
       내부 : 오류 이력 기록
       ============================================================================================== */
    PROCEDURE P_WRITE_ERROR_LOG
    (
        P_PROGRAM_NAME      IN  VARCHAR2,
        P_MESSAGE           IN  VARCHAR2
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
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
        VALUES
        (
            P_PROGRAM_NAME
          , 'ERROR'
          , NULL
          , SUBSTR(P_MESSAGE, 1, 1000)
          , NULL
          , SYSDATE
          , SYSDATE
          , P_PROGRAM_NAME
          , SYSDATE
          , P_PROGRAM_NAME
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END P_WRITE_ERROR_LOG;

    /* ==============================================================================================
       내부 : 두 조회가 함께 쓰는 자료 적재
              P_SITE_VALID_YN = 'Y' 이면 재고사이트 룩업에서 사용 중인 것만 (월별 조회)
                              = NULL 이면 사용 여부를 가리지 않는다 (일별 조회)
       ============================================================================================== */
    -- 2026.10.06 AJS 자재분류 적재 대상 품목을 줄이기 위한 기준월·기준일 인자 추가 (START)
--    PROCEDURE P_LOAD_COMMON
--    (
--        P_SITE_VALID_YN     IN  VARCHAR2
--    )
    PROCEDURE P_LOAD_COMMON
    (
        P_SITE_VALID_YN     IN  VARCHAR2
      , P_YYYYMM            IN  VARCHAR2 DEFAULT NULL    /* 월별 조회 기준월 — 자재분류 적재 대상 품목을 줄인다 */
      , P_YYYYMMDD          IN  VARCHAR2 DEFAULT NULL    /* 일별 조회 기준일 */
    )
    -- 2026.10.06 AJS 자재분류 적재 대상 품목을 줄이기 위한 기준월·기준일 인자 추가 (END)
    IS
    BEGIN
        DELETE FROM GT_SCP0085_CELL_CF;
        DELETE FROM GT_SCP0085_CF_BOM;
        DELETE FROM GT_SCP0085_SI;
        DELETE FROM GT_SCP0085_SITE;

        /* 셀 환산계수 — 품목 하나에 한 줄 (20220428 GPLM IF 환산계수) */
        INSERT INTO GT_SCP0085_CELL_CF
        (
            TARGET_CELL
          , ITEM_ID
          , CELL_CF
          , RANK_NO
        )
        SELECT IA.TARGET_CELL
             , IA.ITEM_ID
             , IA.CELL_CF
             , IA.RANK_NO
          FROM (SELECT TARGET_CELL
                     , ITEM_ID
                     , CELL_CF                                        /* 20221208 Null 사용 */
                     , ROW_NUMBER() OVER (PARTITION BY ITEM_ID ORDER BY BOM_MODIFY_DATE DESC, ATTRIBUTE5 DESC) AS RANK_NO
--                  FROM SCP_MST_ITEM_CELL_CF) IA
                  FROM SCP_MST_ITEM_CELL_CF /* AJS 20261007 속도 */
                 WHERE ITEM_ID IN (SELECT CASE XB.SEQ_NO WHEN 1 THEN XA.ITEM_ID      /* 기말재고 품목 */ /* AJS 20261007 속도 */
                                                         WHEN 2 THEN SUBSTR(XA.ITEM_ID, 1, LENGTH(XA.ITEM_ID) - 2)    /* TYPE_A 기본 품목 */ /* AJS 20261007 속도 */
                                                         ELSE SUBSTR(XA.ITEM_ID, 1, LENGTH(XA.ITEM_ID) - 3)           /* TYPE_G 기본 품목 */ /* AJS 20261007 속도 */
                                          END /* AJS 20261007 속도 */
                                     FROM SCP_ANL_MONTH_END_STOCK_R XA /* AJS 20261007 속도 */
                                        , (SELECT 1 AS SEQ_NO FROM DUAL /* AJS 20261007 속도 */
                                           UNION ALL /* AJS 20261007 속도 */
                                           SELECT 2 FROM DUAL /* AJS 20261007 속도 */
                                           UNION ALL /* AJS 20261007 속도 */
                                           SELECT 3 FROM DUAL) XB /* AJS 20261007 속도 */
                                    WHERE XA.YYYYMM = P_YYYYMM /* AJS 20261007 속도 */
                                   UNION ALL /* AJS 20261007 속도 */
                                   SELECT XC.ITEM_ID /* AJS 20261007 속도 */
                                     FROM SCP_ANL_MONTH_END_STOCK_R_D XC /* AJS 20261007 속도 */
                                    WHERE XC.CUTOFF_DATE = P_YYYYMMDD)) IA /* AJS 20261007 속도 */
         WHERE IA.RANK_NO = 1;

        /* BOM 환산계수
           ★AS-IS 는 나눗셈을 이진 부동소수로 한다. 십진으로 계산하면 끝자리가 갈린다. */
        INSERT INTO GT_SCP0085_CF_BOM
        (
            COMPANY_ID
          , DIVISION_ID
          , SITE_ID
          , MODEL_ID
          , PLANT_ID
          , CHILD_ITEM_ID
          , ITEM_TYPE
          , ACCUMULATED_CHILD_QTY
          , CHILD_QTY
          , CELL_CF_BOM
        )
        SELECT IA.COMPANY_ID
             , MAX(IA.DIVISION_ID)                  AS DIVISION_ID
             , IA.SITE_ID
             , IA.MODEL_ID
             , IA.PLANT_ID
             , IA.CHILD_ITEM_ID
             , MAX(IA.ITEM_TYPE)                    AS ITEM_TYPE
             , SUM(IA.ACCUMULATED_CHILD_QTY)        AS ACCUMULATED_CHILD_QTY
             , MAX(IA.CHILD_QTY)                    AS CHILD_QTY
             , ROUND(CAST(1 AS BINARY_DOUBLE) / CAST(SUM(IA.ACCUMULATED_CHILD_QTY) AS BINARY_DOUBLE), 6) AS CELL_CF_BOM
          FROM (SELECT A.COMPANY_ID
                     , A.DIVISION_ID
                     , A.SITE_ID
                     , A.MODEL_ID
                     , A.PLANT_ID
                     , A.CHILD_ITEM_ID
                     , B.ITEM_TYPE
                     , A.ACCUMULATED_CHILD_QTY
                     , A.CHILD_QTY
                  FROM SCM_MODEL_COMP_TEMP_SN  A
                     , SCM_ITEM_M_SN           B
                     , SCM_MST_ITEM_CLASS_SN   C
                     , SCP_MST_ITEM_CELL_CF    D
                 WHERE A.CHILD_COMPANY_ID  = B.COMPANY_ID
                   AND A.CHILD_DIVISION_ID = B.DIVISION_ID
                   AND A.CHILD_SITE_ID     = B.SITE_ID
                   AND A.CHILD_ITEM_ID     = B.ITEM_ID
                   AND B.ITEM_CLASS        = C.CLASS_ID
                   AND D.ITEM_ID           = A.CHILD_ITEM_ID
                   AND D.TARGET_CELL       = A.MODEL_ID
                   AND C.USE_FLAG          = 'Y'
                   AND NVL(B.ITEM_TYPE, 'H') IN ('P', 'Q', 'H')
                   AND A.ALT_PRIORITY      = 'Y'
                   AND D.CELL_CF          IS NULL) IA
         GROUP BY IA.COMPANY_ID
                , IA.SITE_ID
                , IA.MODEL_ID
                , IA.PLANT_ID
                , IA.CHILD_ITEM_ID;

        /* 자재분류 — 품목 하나에 한 줄 */
        INSERT INTO GT_SCP0085_SI
        (
            ITEM_ID
          , ITEM_TYPE
          , PROCESS_GROUP
          , PROCESS_DETAIL
          , LEVEL_1_NAME
          , LEVEL_2_NAME
          , LEVEL_3_NAME
          , LEVEL_4_NAME
        )
        SELECT IA.ITEM_ID
             , IA.ITEM_TYPE
             , IA.PROCESS_GROUP
             , IA.PROCESS_DETAIL
             , IA.LEVEL_1_NAME
             , IA.LEVEL_2_NAME
             , IA.LEVEL_3_NAME
             , IA.LEVEL_4_NAME
          FROM (SELECT DISTINCT IB.ITEM_ID
                     , B.ITEM_TYPE
                     , B.PROCESS_GROUP
                     , B.PROCESS_DETAIL
                     , B.LEVEL_1_NAME
                     , B.LEVEL_2_NAME
                     , B.LEVEL_3_NAME
                     , B.LEVEL_4_NAME
                     , ROW_NUMBER() OVER (PARTITION BY IB.ITEM_ID ORDER BY IB.ITEM_CLASS DESC) AS RANK_NO
                  FROM (SELECT DISTINCT ITEM_ID
                             , ITEM_CLASS
                             , ROW_NUMBER() OVER (PARTITION BY ITEM_ID ORDER BY ITEM_CLASS DESC) AS RANK_NO
                         -- 2026.10.06 AJS 자재분류 적재를 조회 대상 품목으로 한정 (START)
--                          FROM SCM_MST_ITEM_SN) IB
                          FROM SCM_MST_ITEM_SN
                         WHERE ITEM_ID IN (SELECT XA.ITEM_ID          /* 이 조회에서 자재분류를 붙이는 품목만 — 품목별 순위는 품목 안에서만 매긴다 */
                                             FROM SCP_ANL_MONTH_END_STOCK_R   XA
                                            WHERE XA.YYYYMM      = P_YYYYMM
                                           UNION ALL
                                           SELECT XB.ITEM_ID
                                             FROM SCP_ANL_MONTH_END_STOCK_R_D XB
                                            WHERE XB.CUTOFF_DATE = P_YYYYMMDD
                                           UNION ALL
                                           SELECT XC.ITEM_ID_PROD
                                             FROM SCP_MST_CELL_PROD_ASSY_MAP  XC
                                            WHERE XC.DIVISION_ID IN ('40', '82'))) IB
                         -- 2026.10.06 AJS 자재분류 적재를 조회 대상 품목으로 한정 (END)
                     , SCM_MST_ITEM_CLASS_M B
                 WHERE B.CLASS_ID = IB.ITEM_CLASS) IA
         WHERE IA.RANK_NO = 1;

        /* 플랜트 이름 */
        INSERT INTO GT_SCP0085_SITE
        (
            PLANT_ID
          , PLANT_NAME
        )
        SELECT DISTINCT PLANT_ID
             , PLANT_NAME
          FROM SCM_PLANT_M_SN
         UNION
        SELECT SEGMENT1                             AS PLANT_ID
             , SEGMENT2                             AS PLANT_NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'INVENTORY_SITE'
           AND (P_SITE_VALID_YN IS NULL OR VALID_YN = P_SITE_VALID_YN);
    END P_LOAD_COMMON;

    /* ==============================================================================================
       SCP0085_GET_ENDING_INVENTORY — 월별
       ============================================================================================== */
    PROCEDURE P_SCP0085_GET_ENDING_INVENTORY
    (
        P_YYYYMM            IN  VARCHAR2
      , P_DIVISION_ID       IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_ITEM_TYPE         IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_PROFIT_CENTER     IN  CLOB
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        V_YYYYMM            VARCHAR2(6 CHAR)     := SUBSTR(TRIM(P_YYYYMM), 1, 6);
        V_DIVISION_ID       VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 32767));
        V_PLANT_ID          VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID, 1, 32767));
        V_ITEM_TYPE         VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_TYPE, 1, 32767));
        V_ITEM_ID           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID, 1, 32767));
        V_PROFIT_CENTER     VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_PROFIT_CENTER, 1, 32767));
        V_YYYYMM_DISP       VARCHAR2(24 CHAR);
    BEGIN
        /* AS-IS : 사업부를 전부 고른 것과 같은 조합이면 조건을 비운다 */
        IF V_DIVISION_ID IN ('81,40,82,81_GM', '81,40,82') THEN
            V_DIVISION_ID := NULL;
        END IF;

        /* 보고시점 표시 — 앞 문자는 AS-IS 가 쓰는 왼쪽 홑따옴표(U+2018)를 그대로 적은 것 */
        V_YYYYMM_DISP := '‘' || SUBSTR(V_YYYYMM, 3, 2) || '.' || SUBSTR(V_YYYYMM, -2);

--        P_LOAD_COMMON('Y');    --  2026.10.06 AJS
        P_LOAD_COMMON('Y', V_YYYYMM, NULL);    --  2026.10.06 AJS

        DELETE FROM GT_SCP0085_ASSY_MAP;

        /* 활성화 코드 매핑 — 월별은 사용 여부를 가리지 않는다 */
        INSERT INTO GT_SCP0085_ASSY_MAP
        (
            DIVISION_ID
          , PLANT_ID
          , ITEM_ID_PROD
          , ITEM_ID_ASSY
          , CELL_TYPE
          , PROCESS_GROUP
          , PROCESS_DETAIL
          , RANK_NO
        )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.ITEM_ID_PROD
             , A.ITEM_ID_ASSY
             , A.CELL_TYPE
             , B.PROCESS_GROUP
             , B.PROCESS_DETAIL
             , RANK() OVER (PARTITION BY A.DIVISION_ID, A.PLANT_ID, A.ITEM_ID_ASSY ORDER BY A.ITEM_ID_PROD DESC) AS RANK_NO
          FROM SCP_MST_CELL_PROD_ASSY_MAP A
             , GT_SCP0085_SI             B
         WHERE B.ITEM_ID(+)   = A.ITEM_ID_PROD
           AND A.DIVISION_ID IN ('40', '82');

        OPEN O_RC1 FOR
            SELECT SA.YYYYMM
                 , SA.DIVISION_ID
                 , SA.COMPANY_ID
                 , SA.PLANT_ID
                 , SA.PLANT_NAME
                 , SA.ITEM_ID
                 , SA.ITEM_DESCRIPTION
                 , SA.ITEM_UOM
                 , SA.STORAGE_LOCATION
                 , SA.STORAGE_DESC
                 , SA.UNRESTRICTED_QTY
                 , SA.BLOCKED_STOCK
                 , SA.IN_TRANSIT
                 , SA.QUANTITY
                 , SA.AMOUNT
                 , SA.CURRENCY
                 , SA.AMOUNT_KRW
                 , SA.UNIT_PRICE
                 , SA.UNIT_PRICE_KRW
                 , SA.QUANTITY_XLS
                 , SA.AMOUNT_XLS
                 , SA.CURRENCY_XLS
                 , SA.AMOUNT_KRW_XLS
                 , SA.UNIT_PRICE_XLS
                 , SA.UNIT_PRICE_KRW_XLS
                 , SA.VALUATION_CLASS
                 , SA.PURCHASE_PO
                 , SA.SUPPLIER_CODE
                 , SA.SUPPLIER_NAME
                 , SA.ITEM_TYPE
                 , SA.ITEM_TYPE_CODE
                 , SA.PROCESS_GROUP
                 , SA.MATERIAL_GROUP
                 , SA.VALUATION_TYPE
                 , SA.PROCESS_GROUP_ORG
                 , SA.MATERIAL_GROUP_ORG
                 , SA.CELL_TYPE
                 , SA.CP_MODEL
                 , SA.CP_PROCESS_GROUP
                 , SA.CP_MATERIAL_GROUP
                 , SA.FORECAST_INFO_CELL_MODEL
                 , SA.ITEM_ID_BASE
                 , SA.ITEM_ID_EX
                 , SA.MDM_PROJECT_NICK_NAME
                 , SA.EXTRA_SPEC
                 , SA.ITEM_TYPE_DETAIL
                 , SA.ITEM_TYPE_GR
                 , SA.LEVEL_1_NAME
                 , SA.LEVEL_2_NAME
                 , SA.LEVEL_3_NAME
                 , SA.LEVEL_4_NAME
                 , SA.CELL_GROUP_ASIS
                 , SA.PACK_GROUP_ASIS
                 , SA.FLOW_ID
                 , SA.CELL_GROUP
                 , SA.PACK_GROUP
                 , SA.CELL_CONVER_FACTOR
                 , SA.CELL_CONVER_FACTOR_XLS
                 , SA.CELL_CONVER_QUANTITY
                 , SA.CELL_CONVER_QUANTITY_XLS
                 , SA.CELL_TYPE_GR
                 , SA.USE_CELL_CF_BOM
                 , SA.CELL_CF
                 , SA.CELL_CF_BOM
                 , SA.T1
                 , SA.T2
                 , SA.T3
                 , SA.T4
                 , SA.M1_QUANTITY
                 , SA.M1_AMOUNT
                 , SA.M1_AMOUNT_KRW
                 , SA.M2_QUANTITY
                 , SA.M3_QUANTITY
                 , SA.M4_QUANTITY
                 , SA.M5_QUANTITY
                 , SA.M6_QUANTITY
                 , SA.M7_QUANTITY
                 , SA.M8_QUANTITY
                 , SA.M9_QUANTITY
                 , SA.M10_QUANTITY
                 , SA.M11_QUANTITY
                 , SA.M12_QUANTITY
                 , SA.M13_QUANTITY
                 , SA.M2_AMOUNT
                 , SA.M3_AMOUNT
                 , SA.M4_AMOUNT
                 , SA.M5_AMOUNT
                 , SA.M6_AMOUNT
                 , SA.M7_AMOUNT
                 , SA.M8_AMOUNT
                 , SA.M9_AMOUNT
                 , SA.M10_AMOUNT
                 , SA.M11_AMOUNT
                 , SA.M12_AMOUNT
                 , SA.M13_AMOUNT
                 , SA.M2_AMOUNT_KRW
                 , SA.M3_AMOUNT_KRW
                 , SA.M4_AMOUNT_KRW
                 , SA.M5_AMOUNT_KRW
                 , SA.M6_AMOUNT_KRW
                 , SA.M7_AMOUNT_KRW
                 , SA.M8_AMOUNT_KRW
                 , SA.M9_AMOUNT_KRW
                 , SA.M10_AMOUNT_KRW
                 , SA.M11_AMOUNT_KRW
                 , SA.M12_AMOUNT_KRW
                 , SA.M13_AMOUNT_KRW
                 , SA.CURRENCY_KRW
                 , SA.TARGET_CELL
                 , SA.EX_TO_BAMT
                 , SA.ERP_DIV
                 , SA.PROFIT_CENTER_CODE
                 , SA.PROFIT_CENTER
                 /* 20231123 요청사항 */
                 , CASE WHEN UPPER(SA.PROCESS_GROUP) = 'CELL' AND SA.ITEM_TYPE  = '제품' THEN SA.ITEM_ID
                        WHEN UPPER(SA.PROCESS_GROUP) = 'CELL' AND SA.ITEM_TYPE <> '제품'
                             AND (SA.ITEM_TYPE_DETAIL = 'TYPE_A' OR SA.ITEM_TYPE_DETAIL = 'TYPE_G')
                        THEN (SELECT NVL(MAX(XA.ITEM_ID_PROD) || SA.ITEM_ID_EX
                                       , SUBSTR(SA.ITEM_DESCRIPTION, 1, INSTR(SA.ITEM_DESCRIPTION, ' ') - 1))
                                FROM GT_SCP0085_ASSY_MAP XA
                               WHERE XA.ITEM_ID_ASSY = SA.ITEM_ID_BASE
                                 AND XA.PLANT_ID     = SA.PLANT_ID
                                 AND XA.DIVISION_ID  = SA.DIVISION_ID)
                        WHEN UPPER(SA.PROCESS_GROUP) = 'CELL' AND SA.ITEM_TYPE <> '제품'
                        THEN (SELECT NVL(MAX(XA.ITEM_ID_PROD)
                                       , SUBSTR(SA.ITEM_DESCRIPTION, 1, INSTR(SA.ITEM_DESCRIPTION, ' ') - 1))
                                FROM GT_SCP0085_ASSY_MAP XA
                               WHERE XA.ITEM_ID_ASSY = SA.ITEM_ID
                                 AND XA.PLANT_ID     = SA.PLANT_ID
                                 AND XA.DIVISION_ID  = SA.DIVISION_ID)
                        WHEN SA.ITEM_TYPE = '반제품' AND SA.FORECAST_INFO_CELL_MODEL IS NULL
                        THEN (SELECT XB.APPLIED_MODEL
                                FROM (SELECT XC.APPLIED_MODEL
                                        FROM SCM_MST_ITEM_SN XC
                                       WHERE XC.ITEM_ID        = SA.ITEM_ID
                                         AND XC.APPLIED_MODEL  > ' ') XB
                               WHERE ROWNUM = 1)
                        ELSE SA.FORECAST_INFO_CELL_MODEL
                   END                              AS GPLM_CELL_MODEL
              FROM (SELECT IA.YYYYMM
                         , IA.DIVISION_ID
                         , IA.COMPANY_ID
                         , IA.PLANT_ID
                         , IA.PLANT_NAME
                         , IA.ITEM_ID
                         , IA.ITEM_DESCRIPTION
                         , IA.ITEM_UOM
                         , IA.STORAGE_LOCATION
                         , IA.STORAGE_DESC
                         , IA.UNRESTRICTED_QTY
                         , IA.BLOCKED_STOCK
                         , IA.IN_TRANSIT
                         , IA.QUANTITY
                         , IA.AMOUNT
                         , IA.CURRENCY
                         , IA.AMOUNT_KRW
                         , IA.UNIT_PRICE
                         , IA.UNIT_PRICE_KRW
                         /* ---------------------------------------------------------------- */
                         , IA.QUANTITY                  AS QUANTITY_XLS
                         , IA.AMOUNT                    AS AMOUNT_XLS
                         , IA.CURRENCY                  AS CURRENCY_XLS
                         , IA.AMOUNT_KRW                AS AMOUNT_KRW_XLS
                         , IA.UNIT_PRICE                AS UNIT_PRICE_XLS
                         , IA.UNIT_PRICE_KRW            AS UNIT_PRICE_KRW_XLS
                         /* ---------------------------------------------------------------- */
                         , IA.VALUATION_CLASS
                         , IA.PURCHASE_PO
                         , IA.SUPPLIER_CODE
                         , IA.SUPPLIER_NAME
                         , IA.ITEM_TYPE
                         , CASE WHEN IA.ITEM_TYPE = '기타'     THEN 'E'
                                WHEN IA.ITEM_TYPE = '반제품'   THEN 'H'
                                WHEN IA.ITEM_TYPE = '상품'     THEN 'P'
                                WHEN IA.ITEM_TYPE = '원부자재' THEN 'Q'
                                WHEN IA.ITEM_TYPE = '저장품'   THEN 'A'
                                WHEN IA.ITEM_TYPE = '제품'     THEN 'R'
                                ELSE '-'
                           END                          AS ITEM_TYPE_CODE    /* 원반제구분 */
                         /* ---------------------------------------------------------------- */
                         , CASE WHEN IA.CA_CELL_TYPE LIKE 'CA%'
                                THEN CASE WHEN IA.CA_ITEM_ID_PROD IS NOT NULL AND IA.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                          ELSE IA.CA_PROCESS_GROUP
                                     END
                                ELSE IA.PROCESS_GROUP
                           END                          AS PROCESS_GROUP
                         , CASE WHEN IA.CA_CELL_TYPE LIKE 'CA%'
                                THEN CASE WHEN IA.CA_ITEM_ID_PROD IS NOT NULL AND IA.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                          ELSE IA.CA_PROCESS_DETAIL
                                     END
                                ELSE IA.MATERIAL_GROUP
                           END                          AS MATERIAL_GROUP
                         , IA.VALUATION_TYPE                              /* ATTRIBUTE6정보(VALUATION TYPE) UI 내 표기 2025-03-04 (E20250214-001628) */
                         , IA.PROCESS_GROUP             AS PROCESS_GROUP_ORG     /* 자재구분 */
                         , IA.MATERIAL_GROUP            AS MATERIAL_GROUP_ORG    /* 자재구분상세 */
                         /* ---------------------------------------------------------------- */
                         , IA.CA_CELL_TYPE              AS CELL_TYPE
                         , IA.CA_ITEM_ID_PROD           AS CP_MODEL
                         , CASE WHEN IA.CA_ITEM_ID_PROD IS NOT NULL AND IA.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                ELSE IA.CA_PROCESS_GROUP
                           END                          AS CP_PROCESS_GROUP      /* 자재구분 */
                         , CASE WHEN IA.CA_ITEM_ID_PROD IS NOT NULL AND IA.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                ELSE IA.CA_PROCESS_DETAIL
                           END                          AS CP_MATERIAL_GROUP     /* 자재구분상세 */
                         /* ---------------------------------------------------------------- */
                         , IA.FORECAST_INFO_CELL_MODEL
                         , IA.ITEM_ID_BASE
                         , IA.ITEM_ID_EX
                         , IA.MDM_PROJECT_NICK_NAME
                         , IA.EXTRA_SPEC
                         , IA.ITEM_TYPE_DETAIL
                         , IA.ITEM_TYPE_GR
                         , IA.LEVEL_1_NAME
                         , IA.LEVEL_2_NAME
                         , IA.LEVEL_3_NAME
                         , IA.LEVEL_4_NAME
                         /* ---------------------------------------------------------------- */
                         , IA.CELL_GROUP                AS CELL_GROUP_ASIS
                         , IA.PACK_GROUP                AS PACK_GROUP_ASIS
                         , IA.EE_FLOW_ID                AS FLOW_ID
                         , CASE WHEN IA.ITEM_TYPE = '제품' AND IA.PROCESS_GROUP = '모듈/팩' AND IA.MATERIAL_GROUP = 'Module Assembly'
                                THEN IA.FIT_GROUP_CODE1
                                WHEN IA.CELL_GROUP IS NULL AND IA.ITEM_TYPE = '반제품' AND IA.EE_FLOW_ID IS NOT NULL
                                THEN IA.FIT_GROUP_CODE1
                                ELSE IA.CELL_GROUP
                           END                          AS CELL_GROUP
                         , CASE WHEN IA.ITEM_TYPE = '제품' AND IA.PROCESS_GROUP = '모듈/팩' AND IA.MATERIAL_GROUP = 'Module Assembly'
                                THEN IA.FIT_GROUP_CODE2
                                WHEN IA.CELL_GROUP IS NULL AND IA.ITEM_TYPE = '반제품' AND IA.EE_FLOW_ID IS NOT NULL
                                THEN IA.FIT_GROUP_CODE2
                                ELSE IA.PACK_GROUP
                           END                          AS PACK_GROUP
                         /* ★환산계수 칸은 AS-IS 가 문자로 돌려준다 */
                         , CASE WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_CELL'    THEN '1.000000'    /* 20220503 CELL 인 경우 환산계수 = 1 */
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_A'
                                THEN NVL((SELECT MAX(XA.CELL_CF)
                                            FROM GT_SCP0085_CELL_CF XA
                                           WHERE XA.ITEM_ID = SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 2)), '1.000000')
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_G'
                                THEN NVL((SELECT MAX(XA.CELL_CF)
                                            FROM GT_SCP0085_CELL_CF XA
                                           WHERE XA.ITEM_ID = SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 3)), '1.000000')
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_PRODUCT' THEN NVL(IA.CELL_CF, RTRIM(RTRIM(TO_CHAR(ROUND(CAST(IA.CELL_CF_BOM AS NUMBER)
                                                             , 5 - FLOOR(LOG(10, ABS(CAST(IA.CELL_CF_BOM AS NUMBER)))))
                                                       , 'FM99999999999990.999999999999'), '0'), '.'))    /* 20221208 환산계수 BOM */
                                ELSE IA.CELL_CF                                              /* 20221208 Default 1 -> CELL_CF (null 이면 그대로 표시) */
                           END                          AS CELL_CONVER_FACTOR
                         , CASE WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_CELL'    THEN '1.000000'
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_A'
                                THEN NVL((SELECT MAX(XA.CELL_CF)
                                            FROM GT_SCP0085_CELL_CF XA
                                           WHERE XA.ITEM_ID = SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 2)), '1.000000')
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_G'
                                THEN NVL((SELECT MAX(XA.CELL_CF)
                                            FROM GT_SCP0085_CELL_CF XA
                                           WHERE XA.ITEM_ID = SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 3)), '1.000000')
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_PRODUCT' THEN NVL(IA.CELL_CF, RTRIM(RTRIM(TO_CHAR(ROUND(CAST(IA.CELL_CF_BOM AS NUMBER)
                                                             , 5 - FLOOR(LOG(10, ABS(CAST(IA.CELL_CF_BOM AS NUMBER)))))
                                                       , 'FM99999999999990.999999999999'), '0'), '.'))
                                ELSE IA.CELL_CF
                           END                          AS CELL_CONVER_FACTOR_XLS
                         /* ★환산수량 칸은 AS-IS 가 이진 부동소수로 곱한다 */
                         , CASE WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_CELL'    THEN CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_A'
                                THEN (SELECT CAST(NVL(MAX(TO_NUMBER(XA.CELL_CF DEFAULT NULL ON CONVERSION ERROR)), 1) AS BINARY_DOUBLE)
                                           * CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                        FROM GT_SCP0085_CELL_CF XA
                                       WHERE XA.ITEM_ID = SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 2))
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_G'
                                THEN (SELECT CAST(NVL(MAX(TO_NUMBER(XA.CELL_CF DEFAULT NULL ON CONVERSION ERROR)), 1) AS BINARY_DOUBLE)
                                           * CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                        FROM GT_SCP0085_CELL_CF XA
                                       WHERE XA.ITEM_ID = SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 3))
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_PRODUCT' AND IA.CELL_CF IS NOT NULL
                                THEN CAST(TO_NUMBER(IA.CELL_CF DEFAULT NULL ON CONVERSION ERROR) AS BINARY_DOUBLE)
                                   * CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_PRODUCT' AND IA.CELL_CF_BOM IS NOT NULL
                                THEN CAST(IA.CELL_CF_BOM AS BINARY_DOUBLE) * CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_PRODUCT' THEN CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                ELSE CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                           END                          AS CELL_CONVER_QUANTITY      /* 셀 환산수량(GPLM 셀 환산계수 * 재고수량) */
                         , CASE WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_CELL'    THEN CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_A'
                                THEN (SELECT CAST(NVL(MAX(TO_NUMBER(XA.CELL_CF DEFAULT NULL ON CONVERSION ERROR)), 1) AS BINARY_DOUBLE)
                                           * CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                        FROM GT_SCP0085_CELL_CF XA
                                       WHERE XA.ITEM_ID = SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 2))
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_G'
                                THEN (SELECT CAST(NVL(MAX(TO_NUMBER(XA.CELL_CF DEFAULT NULL ON CONVERSION ERROR)), 1) AS BINARY_DOUBLE)
                                           * CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                        FROM GT_SCP0085_CELL_CF XA
                                       WHERE XA.ITEM_ID = SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 3))
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_PRODUCT' AND IA.CELL_CF IS NOT NULL
                                THEN CAST(TO_NUMBER(IA.CELL_CF DEFAULT NULL ON CONVERSION ERROR) AS BINARY_DOUBLE)
                                   * CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_PRODUCT' AND IA.CELL_CF_BOM IS NOT NULL
                                THEN CAST(IA.CELL_CF_BOM AS BINARY_DOUBLE) * CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE_DETAIL = 'TYPE_PRODUCT' THEN CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                ELSE CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                           END                          AS CELL_CONVER_QUANTITY_XLS
                         /* ---------------------------------------------------------------- */
                         , CASE WHEN IA.ITEM_TYPE_GR = 'TYPE_GR_A'
                                THEN (SELECT MAX(XA.GROUP_CODE3)
                                        FROM SCP_MST_FINAL_ITEM XA
                                       WHERE XA.OPERATION_GROUP IN ('A', 'P')
                                         AND XA.DIVISION_ID      = '40'
                                         AND XA.ITEM_ID          = SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 2))
                                WHEN IA.ITEM_TYPE_GR = 'TYPE_GR_G'
                                THEN (SELECT MAX(XA.GROUP_CODE3)
                                        FROM SCP_MST_FINAL_ITEM XA
                                       WHERE XA.OPERATION_GROUP IN ('A', 'P')
                                         AND XA.DIVISION_ID      = '40'
                                         AND XA.ITEM_ID          = SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 3))
                                WHEN IA.ITEM_TYPE_GR = 'TYPE_GR_PRODUCT'
                                THEN (SELECT MAX(XA.GROUP_CODE3)
                                        FROM SCP_MST_FINAL_ITEM XA
                                       WHERE XA.OPERATION_GROUP IN ('A', 'P')
                                         AND XA.DIVISION_ID      = '40'
                                         AND XA.ITEM_ID          = IA.ITEM_ID)
                                ELSE NULL
                           END                          AS CELL_TYPE_GR    /* 20221004 추가 */
                         /* ---------------------------------------------------------------- */
                         , CASE WHEN IA.CELL_CF IS NULL AND IA.CELL_CF_BOM > 0 THEN 'Y'
                                ELSE NULL
                           END                          AS USE_CELL_CF_BOM
                         , IA.CELL_CF
                         , IA.CELL_CF_BOM
                         /* 20251014 [CSR:E20251014-000599] 9.9E-05 컨버팅 오류 수정 */
                         , NVL(IA.CELL_CF, TO_CHAR(NVL(CAST(IA.CELL_CF_BOM AS NUMBER(20, 7)), 1), 'FM99999999999990.0000000')) AS T1
                         , NVL(IA.QUANTITY, 0)          AS T2
                         /* ★AS-IS 는 문자 환산계수를 소수 5자리로 맞춘 뒤 곱한다(상대 칸 자리수를 따른다) */
                         , ROUND(CAST(TO_NUMBER(NVL(IA.CELL_CF, TO_CHAR(NVL(CAST(IA.CELL_CF_BOM AS NUMBER(20, 7)), 1), 'FM99999999999990.0000000'))
                                                DEFAULT NULL ON CONVERSION ERROR) AS NUMBER(20, 5)) * NVL(IA.QUANTITY, 0), 7) AS T3
                         , NVL(CAST(IA.CELL_CF_BOM AS NUMBER(20, 7)), 1) * NVL(IA.QUANTITY, 0) AS T4
                         /* ---------------------------------------------------------------- */
                         , IA.M1_QUANTITY
                         , IA.M1_AMOUNT
                         , IA.M1_AMOUNT_KRW
                         , IA.M2_QUANTITY
                         , IA.M3_QUANTITY
                         , IA.M4_QUANTITY
                         , IA.M5_QUANTITY
                         , IA.M6_QUANTITY
                         , IA.M7_QUANTITY
                         , IA.M8_QUANTITY
                         , IA.M9_QUANTITY
                         , IA.M10_QUANTITY
                         , IA.M11_QUANTITY
                         , IA.M12_QUANTITY
                         , IA.M13_QUANTITY
                         , IA.M2_AMOUNT
                         , IA.M3_AMOUNT
                         , IA.M4_AMOUNT
                         , IA.M5_AMOUNT
                         , IA.M6_AMOUNT
                         , IA.M7_AMOUNT
                         , IA.M8_AMOUNT
                         , IA.M9_AMOUNT
                         , IA.M10_AMOUNT
                         , IA.M11_AMOUNT
                         , IA.M12_AMOUNT
                         , IA.M13_AMOUNT
                         , IA.M2_AMOUNT_KRW
                         , IA.M3_AMOUNT_KRW
                         , IA.M4_AMOUNT_KRW
                         , IA.M5_AMOUNT_KRW
                         , IA.M6_AMOUNT_KRW
                         , IA.M7_AMOUNT_KRW
                         , IA.M8_AMOUNT_KRW
                         , IA.M9_AMOUNT_KRW
                         , IA.M10_AMOUNT_KRW
                         , IA.M11_AMOUNT_KRW
                         , IA.M12_AMOUNT_KRW
                         , IA.M13_AMOUNT_KRW
                         , IA.CURRENCY_KRW
                         , IA.TARGET_CELL
                         , IA.EX_TO_BAMT
                         , IA.ERP_DIV                                     /* ATTRIBUTE10정보 [CSR:E20251114-001566] */
                         , IA.PROFIT_CENTER_CODE                          /* ATTRIBUTE3정보 E20260112-000418 */
                         , IA.PROFIT_CENTER                               /* ATTRIBUTE4정보 E20260112-000418 */
--                      FROM (SELECT IB.YYYYMM    --  2026.10.06 AJS
                      FROM (SELECT /*+ USE_HASH(E) USE_HASH(F) USE_HASH(G) */ IB.YYYYMM    --  2026.10.06 AJS
                                 , IB.DIVISION_ID
                                 , IB.COMPANY_ID
                                 , IB.PLANT_ID
                                 , IB.PLANT_NAME
                                 , IB.ITEM_ID
                                 , IB.ITEM_DESCRIPTION
                                 , IB.ITEM_UOM
                                 , IB.STORAGE_LOCATION
                                 , IB.STORAGE_DESC
                                 , IB.UNRESTRICTED_QTY
                                 , IB.BLOCKED_STOCK
                                 , IB.IN_TRANSIT
                                 , IB.QUANTITY
                                 , IB.AMOUNT
                                 , IB.CURRENCY
                                 , IB.AMOUNT_KRW
                                 , IB.UNIT_PRICE
                                 , IB.UNIT_PRICE_KRW
                                 , IB.VALUATION_CLASS
                                 , IB.PURCHASE_PO
                                 , IB.SUPPLIER_CODE
                                 , IB.SUPPLIER_NAME
                                 , IB.ITEM_TYPE
                                 , IB.PROCESS_GROUP
                                 , IB.MATERIAL_GROUP
                                 , IB.VALUATION_TYPE
                                 , IB.FORECAST_INFO_CELL_MODEL
                                 , IB.MDM_PROJECT_NICK_NAME
                                 , IB.EXTRA_SPEC
                                 , CASE WHEN UPPER(IB.PROCESS_GROUP) = 'CELL' THEN 'TYPE_CELL'
                                        WHEN IB.ITEM_TYPE IN ('반제품', '제품')
                                             AND SUBSTR(IB.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R')
                                             AND IB.CELL_CF IS NULL                     THEN 'TYPE_A'
                                        WHEN IB.ITEM_TYPE IN ('반제품', '제품')
                                             AND SUBSTR(IB.ITEM_ID, -3) IN ('-GG', '-GK')
                                             AND IB.CELL_CF IS NULL                     THEN 'TYPE_G'
                                        WHEN IB.ITEM_TYPE IN ('반제품', '제품')          THEN 'TYPE_PRODUCT'
                                        ELSE 'TYPE'
                                   END                  AS ITEM_TYPE_DETAIL
                                 , CASE WHEN IB.DIVISION_ID = '40' AND IB.ITEM_TYPE IN ('제품')
                                             AND SUBSTR(IB.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R')
                                             AND IB.CELL_CF IS NULL                     THEN 'TYPE_GR_A'
                                        WHEN IB.DIVISION_ID = '40' AND IB.ITEM_TYPE IN ('제품')
                                             AND SUBSTR(IB.ITEM_ID, -3) IN ('-GG', '-GK')
                                             AND IB.CELL_CF IS NULL                     THEN 'TYPE_GR_G'
                                        WHEN IB.DIVISION_ID = '40' AND IB.ITEM_TYPE IN ('제품') THEN 'TYPE_GR_PRODUCT'
                                        ELSE 'TYPE_GR'
                                   END                  AS ITEM_TYPE_GR
                                 , CASE WHEN SUBSTR(IB.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R')
                                        THEN SUBSTR(IB.ITEM_ID, 1, LENGTH(IB.ITEM_ID) - 3)
                                        WHEN SUBSTR(IB.ITEM_ID, -3) IN ('-GG', '-GK')
                                        THEN SUBSTR(IB.ITEM_ID, 1, LENGTH(IB.ITEM_ID) - 4)
                                   END                  AS ITEM_ID_BASE
                                 , CASE WHEN SUBSTR(IB.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R')
                                        THEN SUBSTR(IB.ITEM_ID, -2)
                                        WHEN SUBSTR(IB.ITEM_ID, -3) IN ('-GG', '-GK')
                                        THEN SUBSTR(IB.ITEM_ID, -3)
                                   END                  AS ITEM_ID_EX
                                 , IB.LEVEL_1_NAME
                                 , IB.LEVEL_2_NAME
                                 , IB.LEVEL_3_NAME
                                 , IB.LEVEL_4_NAME
                                 , IB.CELL_GROUP
                                 , IB.PACK_GROUP
                                 , IB.TARGET_CELL
                                 , IB.CELL_CF
                                 , (SELECT XB.CELL_CF_BOM
                                      FROM GT_SCP0085_CF_BOM XB
                                     WHERE XB.CHILD_ITEM_ID = IB.ITEM_ID
                                       AND XB.PLANT_ID      = IB.PLANT_ID
                                       AND XB.MODEL_ID      = IB.TARGET_CELL) AS CELL_CF_BOM
                                 , IB.M1_QUANTITY
                                 , IB.M1_AMOUNT
                                 , IB.M1_AMOUNT_KRW
                                 , IB.M2_QUANTITY
                                 , IB.M3_QUANTITY
                                 , IB.M4_QUANTITY
                                 , IB.M5_QUANTITY
                                 , IB.M6_QUANTITY
                                 , IB.M7_QUANTITY
                                 , IB.M8_QUANTITY
                                 , IB.M9_QUANTITY
                                 , IB.M10_QUANTITY
                                 , IB.M11_QUANTITY
                                 , IB.M12_QUANTITY
                                 , IB.M13_QUANTITY
                                 , IB.M2_AMOUNT
                                 , IB.M3_AMOUNT
                                 , IB.M4_AMOUNT
                                 , IB.M5_AMOUNT
                                 , IB.M6_AMOUNT
                                 , IB.M7_AMOUNT
                                 , IB.M8_AMOUNT
                                 , IB.M9_AMOUNT
                                 , IB.M10_AMOUNT
                                 , IB.M11_AMOUNT
                                 , IB.M12_AMOUNT
                                 , IB.M13_AMOUNT
                                 , IB.M2_AMOUNT_KRW
                                 , IB.M3_AMOUNT_KRW
                                 , IB.M4_AMOUNT_KRW
                                 , IB.M5_AMOUNT_KRW
                                 , IB.M6_AMOUNT_KRW
                                 , IB.M7_AMOUNT_KRW
                                 , IB.M8_AMOUNT_KRW
                                 , IB.M9_AMOUNT_KRW
                                 , IB.M10_AMOUNT_KRW
                                 , IB.M11_AMOUNT_KRW
                                 , IB.M12_AMOUNT_KRW
                                 , IB.M13_AMOUNT_KRW
                                 , IB.CURRENCY_KRW
                                 , IB.EX_TO_BAMT
                                 , IB.ERP_DIV
                                 , IB.PROFIT_CENTER_CODE
                                 , IB.PROFIT_CENTER
                                 , E.GROUP_CODE1        AS FIT_GROUP_CODE1
                                 , E.GROUP_CODE2        AS FIT_GROUP_CODE2
                                 , F.FLOW_ID            AS EE_FLOW_ID
                                 , G.CELL_TYPE          AS CA_CELL_TYPE
                                 , G.ITEM_ID_PROD       AS CA_ITEM_ID_PROD
                                 , G.PROCESS_GROUP      AS CA_PROCESS_GROUP
                                 , G.PROCESS_DETAIL     AS CA_PROCESS_DETAIL
--                              FROM (SELECT V_YYYYMM_DISP                  AS YYYYMM    /* 보고시점 */    --  2026.10.06 AJS
                              FROM (SELECT /*+ USE_HASH(B) USE_HASH(C) USE_HASH(D) USE_HASH(E) */ V_YYYYMM_DISP                  AS YYYYMM    /* 보고시점 */    --  2026.10.06 AJS
                                         , A.YYYYMM                       AS YYYYMM_DATA
                                         , A.DIVISION_ID
                                         , A.COMPANY_ID
                                         , A.PLANT_ID
                                         , (SELECT MAX(XA.PLANT_NAME)
                                              FROM GT_SCP0085_SITE XA
                                             WHERE XA.PLANT_ID = A.PLANT_ID) AS PLANT_NAME
                                         , A.ITEM_ID
                                         , A.ITEM_DESCRIPTION
                                         , A.ITEM_UOM
                                         , A.STORAGE_LOCATION
                                         , A.STORAGE_DESC
                                         , A.QUANTITY
                                         , A.AMOUNT
                                         , A.CURRENCY
                                         , A.AMOUNT_KRW
                                         , A.UNIT_PRICE
                                         , A.UNIT_PRICE_KRW
                                         , A.VALUATION_CLASS
                                         , A.PURCHASE_PO
                                         , A.SUPPLIER_CODE
                                         , A.SUPPLIER_NAME
                                         , CASE WHEN A.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                                WHEN A.VALUATION_CLASS IN ('3100', '3109') AND B.ITEM_TYPE = '원부자재' THEN '상품'
                                                ELSE B.ITEM_TYPE
                                           END                            AS ITEM_TYPE          /* 원반제구분 */
                                         , CASE WHEN A.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                                ELSE B.PROCESS_GROUP
                                           END                            AS PROCESS_GROUP      /* 자재구분 */
                                         , CASE WHEN A.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                                ELSE B.PROCESS_DETAIL
                                           END                            AS MATERIAL_GROUP     /* 자재구분상세 */
                                         , D.FORECAST_INFO_CELL_MODEL
                                         , D.NICK_NAME                    AS MDM_PROJECT_NICK_NAME
                                         , D.SCP_EXTRA_SPEC               AS EXTRA_SPEC
                                         , B.LEVEL_1_NAME
                                         , B.LEVEL_2_NAME
                                         , B.LEVEL_3_NAME
                                         , B.LEVEL_4_NAME
                                         , C.GROUP_CODE1                  AS CELL_GROUP
                                         , C.GROUP_CODE2                  AS PACK_GROUP
                                         , A.UNRESTRICTED_QTY                                   /* 20220811 추가 : 가용재고 */
                                         , A.BLOCKED_STOCK                                      /* 20220811 추가 : 보류재고 */
                                         , A.IN_TRANSIT                                         /* 20220811 추가 : In-Transit */
                                         , A.M1_QUANTITY
                                         , A.M1_AMOUNT
                                         , A.M1_AMOUNT_KRW
                                         , A.M2_QUANTITY
                                         , A.M3_QUANTITY
                                         , A.M4_QUANTITY
                                         , A.M5_QUANTITY
                                         , A.M6_QUANTITY
                                         , A.M7_QUANTITY
                                         , A.M8_QUANTITY
                                         , A.M9_QUANTITY
                                         , A.M10_QUANTITY
                                         , A.M11_QUANTITY
                                         , A.M12_QUANTITY
                                         , A.M13_QUANTITY
                                         , A.M2_AMOUNT
                                         , A.M3_AMOUNT
                                         , A.M4_AMOUNT
                                         , A.M5_AMOUNT
                                         , A.M6_AMOUNT
                                         , A.M7_AMOUNT
                                         , A.M8_AMOUNT
                                         , A.M9_AMOUNT
                                         , A.M10_AMOUNT
                                         , A.M11_AMOUNT
                                         , A.M12_AMOUNT
                                         , A.M13_AMOUNT
                                         , A.M2_AMOUNT_KRW
                                         , A.M3_AMOUNT_KRW
                                         , A.M4_AMOUNT_KRW
                                         , A.M5_AMOUNT_KRW
                                         , A.M6_AMOUNT_KRW
                                         , A.M7_AMOUNT_KRW
                                         , A.M8_AMOUNT_KRW
                                         , A.M9_AMOUNT_KRW
                                         , A.M10_AMOUNT_KRW
                                         , A.M11_AMOUNT_KRW
                                         , A.M12_AMOUNT_KRW
                                         , A.M13_AMOUNT_KRW
                                         , A.CURRENCY_KRW
                                         , CASE WHEN A.CURRENCY = 'KRW' THEN '1'
                                                ELSE A.ATTRIBUTE9
                                           END                            AS EX_TO_BAMT
                                         , A.ATTRIBUTE6                   AS VALUATION_TYPE
                                         , A.ATTRIBUTE10                  AS ERP_DIV
                                         , A.ATTRIBUTE3                   AS PROFIT_CENTER_CODE
                                         , A.ATTRIBUTE4                   AS PROFIT_CENTER
                                         , E.TARGET_CELL
                                         , E.CELL_CF
                                      FROM SCP_ANL_MONTH_END_STOCK_R A
                                         , GT_SCP0085_SI              B
                                         , SCP_MST_FINAL_ITEM         C
                                         , SCM_MST_ITEM_SN            D
                                         , GT_SCP0085_CELL_CF         E
                                     WHERE B.ITEM_ID(+)      = A.ITEM_ID
                                       AND C.DIVISION_ID(+)  = A.DIVISION_ID
                                       AND C.ITEM_ID(+)      = A.ITEM_ID
                                       AND D.COMPANY_ID(+)   = A.COMPANY_ID
                                       AND D.DIVISION_ID(+)  = A.DIVISION_ID
                                       AND D.ITEM_ID(+)      = A.ITEM_ID
                                       AND E.ITEM_ID(+)      = A.ITEM_ID
                                       AND E.RANK_NO(+)      = 1
                                       AND A.YYYYMM          = V_YYYYMM
                                       -- 2026.10.06 AJS 조회조건 쉼표 목록 비교를 INSTR 로 변경(STRING_SPLIT 하위질의 제거 · 사업부 조건을 원장 읽을 때 적용) (START)
--                                       AND (TRIM(V_DIVISION_ID) IS NULL
--                                        OR  UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                                        OR  A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                                                FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
--                                       AND (TRIM(V_PLANT_ID) IS NULL
--                                        OR  UPPER(V_PLANT_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                                        OR  A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                                             FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
--                                       AND (TRIM(V_ITEM_ID) IS NULL
--                                        OR  UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                                        OR  A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                                            FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
--                                       /* E20260112-000418 PROFIT CENTER DIV 추가 요청건 */
--                                       AND (TRIM(V_PROFIT_CENTER) IS NULL
--                                        OR  A.ATTRIBUTE3 IN (SELECT UPPER(COLUMN_VALUE)
--                                                               FROM TABLE(STRING_SPLIT(V_PROFIT_CENTER, ','))))) IB
                                       AND (TRIM(V_DIVISION_ID) IS NULL
                                        OR  UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                        OR  (A.DIVISION_ID IS NOT NULL AND INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_DIVISION_ID)), ' *, *', ',') || ',', ',' || A.DIVISION_ID || ',') > 0))
                                       AND (TRIM(V_PLANT_ID) IS NULL
                                        OR  UPPER(V_PLANT_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                        OR  (A.PLANT_ID IS NOT NULL AND INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_PLANT_ID)), ' *, *', ',') || ',', ',' || A.PLANT_ID || ',') > 0))
                                       AND (TRIM(V_ITEM_ID) IS NULL
                                        OR  UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                        /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                                        OR  (A.ITEM_ID IS NOT NULL AND INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_ITEM_ID)), ' *, *', ',') || ',', ',' || A.ITEM_ID || ',') > 0))
                                        OR  EXISTS (SELECT 1
                                                      FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) XS
                                                     WHERE TRIM(XS.COLUMN_VALUE) IS NOT NULL
                                                       AND (UPPER(A.ITEM_ID) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%'
                                                        OR  UPPER(NVL(D.NICK_NAME, C.NICK_NAME)) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                                        /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                                       /* E20260112-000418 PROFIT CENTER DIV 추가 요청건 */
                                       AND (TRIM(V_PROFIT_CENTER) IS NULL
                                        OR  UPPER(TRIM(V_PROFIT_CENTER)) = 'ALL' /* 조회조건 ALL 은 조건 없음 */    --  2026.10.27 AJS
                                        OR  (A.ATTRIBUTE3 IS NOT NULL AND INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_PROFIT_CENTER)), ' *, *', ',') || ',', ',' || A.ATTRIBUTE3 || ',') > 0))) IB
                                       -- 2026.10.06 AJS 조회조건 쉼표 목록 비교를 INSTR 로 변경(STRING_SPLIT 하위질의 제거 · 사업부 조건을 원장 읽을 때 적용) (END)
                                 , (SELECT DIVISION_ID
                                         , ITEM_ID
                                         , GROUP_CODE1
                                         , GROUP_CODE2
                                      FROM SCP_MST_FINAL_ITEM
                                     WHERE GROUP_CODE1 IS NOT NULL) E
                                 , (SELECT FLOW_ID
                                         , ITEM_ID
                                         , COMPANY_ID
                                         , DIVISION_ID
                                      FROM SCM_MST_ITEM_SN
                                     -- 2026.10.06 AJS 조회 사업부에 81 이 없으면 F 원장 읽기 생략 (START)
--                                     WHERE DIVISION_ID = '81'
--                                       AND (FLOW_ID LIKE '%A7000%'
--                                         OR FLOW_ID LIKE '%A8000%'
--                                         OR FLOW_ID LIKE '%A5000%'
--                                         OR FLOW_ID LIKE '%E2000%')) F
                                     WHERE DIVISION_ID = '81'
                                       AND (FLOW_ID LIKE '%A7000%'
                                         OR FLOW_ID LIKE '%A8000%'
                                         OR FLOW_ID LIKE '%A5000%'
                                         OR FLOW_ID LIKE '%E2000%')
                                       /* 81 이 조회 사업부에 없으면 F 는 이어질 줄이 없다 — 읽지 않는다 */
                                       AND (TRIM(V_DIVISION_ID) IS NULL
                                        OR  UPPER(V_DIVISION_ID) = 'ALL'
                                        OR  INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_DIVISION_ID)), ' *, *', ',') || ',', ',81,') > 0)) F
                                     -- 2026.10.06 AJS 조회 사업부에 81 이 없으면 F 원장 읽기 생략 (END)
                                 , GT_SCP0085_ASSY_MAP G
                             WHERE E.DIVISION_ID(+)  = IB.DIVISION_ID
                               AND E.ITEM_ID(+)      = IB.TARGET_CELL
                               AND F.DIVISION_ID(+)  = IB.DIVISION_ID
                               AND F.COMPANY_ID(+)   = IB.COMPANY_ID
                               AND F.ITEM_ID(+)      = IB.ITEM_ID
                               AND G.DIVISION_ID(+)  = IB.DIVISION_ID
                               AND G.PLANT_ID(+)     = IB.PLANT_ID
                               AND G.ITEM_ID_ASSY(+) = IB.ITEM_ID
                               AND G.RANK_NO(+)      = 1) IA
                     -- 2026.10.06 AJS 품목유형 조건 쉼표 목록 비교를 INSTR 로 변경 (START)
--                     WHERE (TRIM(V_ITEM_TYPE) IS NULL
--                        OR  CASE WHEN IA.ITEM_TYPE = '기타'     THEN 'E'
--                                 WHEN IA.ITEM_TYPE = '반제품'   THEN 'H'
--                                 WHEN IA.ITEM_TYPE = '상품'     THEN 'P'
--                                 WHEN IA.ITEM_TYPE = '원부자재' THEN 'Q'
--                                 WHEN IA.ITEM_TYPE = '저장품'   THEN 'A'
--                                 WHEN IA.ITEM_TYPE = '제품'     THEN 'R'
--                                 ELSE '-'
--                            END IN (SELECT UPPER(COLUMN_VALUE)
--                                      FROM TABLE(STRING_SPLIT(V_ITEM_TYPE, ','))))) SA
                     WHERE (TRIM(V_ITEM_TYPE) IS NULL
                        OR  UPPER(TRIM(V_ITEM_TYPE)) = 'ALL' /* 조회조건 ALL 은 조건 없음 */    --  2026.10.27 AJS
                        OR  INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_ITEM_TYPE)), ' *, *', ',') || ','
                                , ',' || CASE WHEN IA.ITEM_TYPE = '기타'     THEN 'E'
                                              WHEN IA.ITEM_TYPE = '반제품'   THEN 'H'
                                              WHEN IA.ITEM_TYPE = '상품'     THEN 'P'
                                              WHEN IA.ITEM_TYPE = '원부자재' THEN 'Q'
                                              WHEN IA.ITEM_TYPE = '저장품'   THEN 'A'
                                              WHEN IA.ITEM_TYPE = '제품'     THEN 'R'
                                              ELSE '-'
                                         END || ',') > 0)) SA
                     -- 2026.10.06 AJS 품목유형 조건 쉼표 목록 비교를 INSTR 로 변경 (END)
             /* ★AS-IS 정렬 순서로 맞춘다(FN_ASIS_SORT_KEY) */
             ORDER BY FN_ASIS_SORT_KEY(SA.DIVISION_ID)
                    , FN_ASIS_SORT_KEY(SA.PLANT_ID)
                    , FN_ASIS_SORT_KEY(SA.ITEM_ID);

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SCP0085_GET_ENDING_INVENTORY', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SCP0085_GET_ENDING_INVENTORY;

    /* ==============================================================================================
       SCP0085_GET_ENDING_INVENTORY_DAILY — 일별
       ★월별과 갈리는 곳 : 재고사이트 룩업 사용 여부를 가리지 않는다 · 활성화 코드는 사용 중인 것만 ·
         ERP 구분 칸이 ATTRIBUTE11 · 환산계수 분기가 단순하다 · 월령별과 평가유형 칸이 없다
       ============================================================================================== */
    PROCEDURE P_SCP0085_GET_ENDING_INVENTORY_DAILY
    (
        P_YYYYMMDD          IN  VARCHAR2
      , P_DIVISION_ID       IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_ITEM_TYPE         IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_PROFIT_CENTER     IN  CLOB
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        V_YYYYMMDD          VARCHAR2(8 CHAR)     := SUBSTR(TRIM(P_YYYYMMDD), 1, 8);
        V_DIVISION_ID       VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 32767));
        V_PLANT_ID          VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID, 1, 32767));
        V_ITEM_TYPE         VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_TYPE, 1, 32767));
        V_ITEM_ID           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID, 1, 32767));
        V_PROFIT_CENTER     VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_PROFIT_CENTER, 1, 32767));
    BEGIN
        /* AS-IS : 사업부를 전부 고른 것과 같은 조합이면 조건을 비운다 */
        IF V_DIVISION_ID IN ('81,40,82,81_GM', '81,40,82') THEN
            V_DIVISION_ID := NULL;
        END IF;

        /* ★일별은 재고사이트 룩업에서 사용 여부를 가리지 않는다 */
--        P_LOAD_COMMON(NULL);    --  2026.10.06 AJS
        P_LOAD_COMMON(NULL, NULL, V_YYYYMMDD);    --  2026.10.06 AJS

        DELETE FROM GT_SCP0085_ASSY_MAP;
        DELETE FROM GT_SCP0085_ASSY_MAP_D;

        /* 활성화 코드 매핑 — 자재구분 보정용 (사용 여부를 가리지 않는다) */
        INSERT INTO GT_SCP0085_ASSY_MAP
        (
            DIVISION_ID
          , PLANT_ID
          , ITEM_ID_PROD
          , ITEM_ID_ASSY
          , CELL_TYPE
          , PROCESS_GROUP
          , PROCESS_DETAIL
          , RANK_NO
        )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.ITEM_ID_PROD
             , A.ITEM_ID_ASSY
             , A.CELL_TYPE
             , B.PROCESS_GROUP
             , B.PROCESS_DETAIL
             , RANK() OVER (PARTITION BY A.DIVISION_ID, A.PLANT_ID, A.ITEM_ID_ASSY ORDER BY A.ITEM_ID_PROD DESC) AS RANK_NO
          FROM SCP_MST_CELL_PROD_ASSY_MAP A
             , GT_SCP0085_SI             B
         WHERE B.ITEM_ID(+)   = A.ITEM_ID_PROD
           AND A.DIVISION_ID IN ('40', '82');

        /* 활성화 코드 매핑 — 대표셀 계산용 (★사용 중인 것만) */
        INSERT INTO GT_SCP0085_ASSY_MAP_D
        (
            DIVISION_ID
          , PLANT_ID
          , ITEM_ID_ASSY
          , ITEM_ID_PROD
          , CELL_TYPE
        )
        SELECT DIVISION_ID
             , PLANT_ID
             , ITEM_ID_ASSY
             , ITEM_ID_PROD
             , MAX(CELL_TYPE)                       AS CELL_TYPE
          FROM SCP_MST_CELL_PROD_ASSY_MAP
         WHERE VALID_YN = 'Y'
         GROUP BY DIVISION_ID
                , PLANT_ID
                , ITEM_ID_ASSY
                , ITEM_ID_PROD;

        OPEN O_RC1 FOR
            SELECT SA.YYYYMM
                 , SA.YYYYMMDD
                 , SA.DIVISION_ID
                 , SA.COMPANY_ID
                 , SA.PLANT_ID
                 , SA.PLANT_NAME
                 , SA.ITEM_ID
                 , SA.ITEM_DESCRIPTION
                 , SA.ITEM_UOM
                 , SA.STORAGE_LOCATION
                 , SA.STORAGE_DESC
                 , SA.UNRESTRICTED_QTY
                 , SA.BLOCKED_STOCK
                 , SA.IN_TRANSIT
                 , SA.QUANTITY
                 , SA.AMOUNT
                 , SA.CURRENCY
                 , SA.AMOUNT_KRW
                 , SA.UNIT_PRICE
                 , SA.UNIT_PRICE_KRW
                 , SA.QUANTITY_XLS
                 , SA.AMOUNT_XLS
                 , SA.CURRENCY_XLS
                 , SA.AMOUNT_KRW_XLS
                 , SA.UNIT_PRICE_XLS
                 , SA.UNIT_PRICE_KRW_XLS
                 , SA.VALUATION_CLASS
                 , SA.PURCHASE_PO
                 , SA.SUPPLIER_CODE
                 , SA.SUPPLIER_NAME
                 , SA.ITEM_TYPE
                 , SA.ITEM_TYPE_CODE
                 , SA.PROCESS_GROUP
                 , SA.MATERIAL_GROUP
                 , SA.PROCESS_GROUP_ORG
                 , SA.MATERIAL_GROUP_ORG
                 , SA.CELL_TYPE
                 , SA.CP_MODEL
                 , SA.CP_PROCESS_GROUP
                 , SA.CP_MATERIAL_GROUP
                 , SA.FORECAST_INFO_CELL_MODEL
                 , SA.MDM_PROJECT_NICK_NAME
                 , SA.EXTRA_SPEC
                 , SA.ITEM_TYPE_DETAIL
                 , SA.ITEM_ID_BASE
                 , SA.ITEM_ID_EX
                 , SA.CELL_CONVER_FACTOR
                 , SA.CELL_CONVER_FACTOR_XLS
                 , SA.CELL_CONVER_QUANTITY
                 , SA.CELL_CONVER_QUANTITY_XLS
                 , SA.LEVEL_1_NAME
                 , SA.LEVEL_2_NAME
                 , SA.LEVEL_3_NAME
                 , SA.LEVEL_4_NAME
                 , SA.FLOW_ID
                 , SA.CELL_GROUP
                 , SA.PACK_GROUP
                 , SA.CELL_CF
                 , SA.CELL_CF_BOM
                 , SA.TARGET_CELL
                 , SA.USE_CELL_CF_BOM
                 , SA.EX_TO_BAMT
                 , SA.ERP_DIV
                 , SA.PROFIT_CENTER_CODE
                 , SA.PROFIT_CENTER
                 /* 20231123 요청사항 — ★일별은 사용 중인 활성화 코드만 본다 */
                 , CASE WHEN UPPER(SA.PROCESS_GROUP_ORG) = 'CELL' AND SA.ITEM_TYPE  = '제품' THEN SA.ITEM_ID
                        WHEN UPPER(SA.PROCESS_GROUP_ORG) = 'CELL' AND SA.ITEM_TYPE <> '제품'
                             AND (SA.ITEM_TYPE_DETAIL = 'TYPE_A' OR SA.ITEM_TYPE_DETAIL = 'TYPE_G')
                        THEN (SELECT NVL(MAX(XA.ITEM_ID_PROD) || SA.ITEM_ID_EX
                                       , SUBSTR(SA.ITEM_DESCRIPTION, 1, INSTR(SA.ITEM_DESCRIPTION, ' ') - 1))
                                FROM GT_SCP0085_ASSY_MAP_D XA
                               WHERE XA.ITEM_ID_ASSY = SA.ITEM_ID_BASE
                                 AND XA.PLANT_ID     = SA.PLANT_ID
                                 AND XA.DIVISION_ID  = SA.DIVISION_ID)
                        WHEN UPPER(SA.PROCESS_GROUP_ORG) = 'CELL' AND SA.ITEM_TYPE <> '제품'
                        THEN (SELECT NVL(MAX(XA.ITEM_ID_PROD)
                                       , SUBSTR(SA.ITEM_DESCRIPTION, 1, INSTR(SA.ITEM_DESCRIPTION, ' ') - 1))
                                FROM GT_SCP0085_ASSY_MAP_D XA
                               WHERE XA.ITEM_ID_ASSY = SA.ITEM_ID
                                 AND XA.PLANT_ID     = SA.PLANT_ID
                                 AND XA.DIVISION_ID  = SA.DIVISION_ID)
                        WHEN SA.ITEM_TYPE = '반제품' AND SA.FORECAST_INFO_CELL_MODEL IS NULL
                        THEN (SELECT XB.APPLIED_MODEL
                                FROM (SELECT XC.APPLIED_MODEL
                                        FROM SCM_MST_ITEM_SN XC
                                       WHERE XC.ITEM_ID       = SA.ITEM_ID
                                         AND XC.APPLIED_MODEL > ' ') XB
                               WHERE ROWNUM = 1)
                        ELSE SA.FORECAST_INFO_CELL_MODEL
                   END                              AS GPLM_CELL_MODEL
              FROM (SELECT IA.YYYYMM
                         , IA.CUTOFF_DATE               AS YYYYMMDD
                         , IA.DIVISION_ID
                         , IA.COMPANY_ID
                         , IA.PLANT_ID
                         , IA.PLANT_NAME
                         , IA.ITEM_ID
                         , IA.ITEM_DESCRIPTION
                         , IA.ITEM_UOM
                         , IA.STORAGE_LOCATION
                         , IA.STORAGE_DESC
                         , IA.UNRESTRICTED_QTY
                         , IA.BLOCKED_STOCK
                         , IA.IN_TRANSIT
                         , IA.QUANTITY
                         , IA.AMOUNT
                         , IA.CURRENCY
                         , IA.AMOUNT_KRW
                         , IA.UNIT_PRICE
                         , IA.UNIT_PRICE_KRW
                         /* ---------------------------------------------------------------- */
                         , IA.QUANTITY                  AS QUANTITY_XLS
                         , IA.AMOUNT                    AS AMOUNT_XLS
                         , IA.CURRENCY                  AS CURRENCY_XLS
                         , IA.AMOUNT_KRW                AS AMOUNT_KRW_XLS
                         , IA.UNIT_PRICE                AS UNIT_PRICE_XLS
                         , IA.UNIT_PRICE_KRW            AS UNIT_PRICE_KRW_XLS
                         /* ---------------------------------------------------------------- */
                         , IA.VALUATION_CLASS
                         , IA.PURCHASE_PO
                         , IA.SUPPLIER_CODE
                         , IA.SUPPLIER_NAME
                         , IA.ITEM_TYPE
                         , CASE WHEN IA.ITEM_TYPE = '기타'     THEN 'E'
                                WHEN IA.ITEM_TYPE = '반제품'   THEN 'H'
                                WHEN IA.ITEM_TYPE = '상품'     THEN 'P'
                                WHEN IA.ITEM_TYPE = '원부자재' THEN 'Q'
                                WHEN IA.ITEM_TYPE = '저장품'   THEN 'A'
                                WHEN IA.ITEM_TYPE = '제품'     THEN 'R'
                                ELSE '-'
                           END                          AS ITEM_TYPE_CODE    /* 원반제구분 */
                         /* ---------------------------------------------------------------- */
                         , CASE WHEN IA.CA_CELL_TYPE LIKE 'CA%'
                                THEN CASE WHEN IA.CA_ITEM_ID_PROD IS NOT NULL AND IA.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                          ELSE IA.CA_PROCESS_GROUP
                                     END
                                ELSE IA.PROCESS_GROUP
                           END                          AS PROCESS_GROUP
                         , CASE WHEN IA.CA_CELL_TYPE LIKE 'CA%'
                                THEN CASE WHEN IA.CA_ITEM_ID_PROD IS NOT NULL AND IA.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                          ELSE IA.CA_PROCESS_DETAIL
                                     END
                                ELSE IA.MATERIAL_GROUP
                           END                          AS MATERIAL_GROUP
                         , IA.PROCESS_GROUP             AS PROCESS_GROUP_ORG     /* 자재구분 */
                         , IA.MATERIAL_GROUP            AS MATERIAL_GROUP_ORG    /* 자재구분상세 */
                         /* ---------------------------------------------------------------- */
                         , IA.CA_CELL_TYPE              AS CELL_TYPE
                         , IA.CA_ITEM_ID_PROD           AS CP_MODEL
                         , CASE WHEN IA.CA_ITEM_ID_PROD IS NOT NULL AND IA.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                ELSE IA.CA_PROCESS_GROUP
                           END                          AS CP_PROCESS_GROUP      /* 자재구분 */
                         , CASE WHEN IA.CA_ITEM_ID_PROD IS NOT NULL AND IA.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                ELSE IA.CA_PROCESS_DETAIL
                           END                          AS CP_MATERIAL_GROUP     /* 자재구분상세 */
                         /* ---------------------------------------------------------------- */
                         , IA.FORECAST_INFO_CELL_MODEL
                         , IA.MDM_PROJECT_NICK_NAME
                         , IA.EXTRA_SPEC
                         , CASE WHEN UPPER(IA.PROCESS_GROUP) = 'CELL' THEN 'TYPE_CELL'
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품')
                                     AND SUBSTR(IA.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R')
                                     AND IA.CELL_CF IS NULL                     THEN 'TYPE_A'
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품')
                                     AND SUBSTR(IA.ITEM_ID, -3) IN ('-GG', '-GK')
                                     AND IA.CELL_CF IS NULL                     THEN 'TYPE_G'
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품')          THEN 'TYPE_PRODUCT'
                                ELSE 'TYPE'
                           END                          AS ITEM_TYPE_DETAIL
                         , CASE WHEN SUBSTR(IA.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R')
                                THEN SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 3)
                                WHEN SUBSTR(IA.ITEM_ID, -3) IN ('-GG', '-GK')
                                THEN SUBSTR(IA.ITEM_ID, 1, LENGTH(IA.ITEM_ID) - 4)
                           END                          AS ITEM_ID_BASE
                         , CASE WHEN SUBSTR(IA.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R')
                                THEN SUBSTR(IA.ITEM_ID, -2)
                                WHEN SUBSTR(IA.ITEM_ID, -3) IN ('-GG', '-GK')
                                THEN SUBSTR(IA.ITEM_ID, -3)
                           END                          AS ITEM_ID_EX
                         /* ★환산계수 칸은 AS-IS 가 문자로 돌려준다 */
                         /* ★일별 환산계수는 AS-IS 가 숫자로 돌려준다(갈래에 부동소수 칸이 섞인다) */
                         , CASE WHEN UPPER(IA.PROCESS_GROUP) = 'CELL' THEN CAST(1 AS BINARY_DOUBLE)   /* 20220503 CELL 인 경우 환산계수 = 1 */
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품') AND IA.CELL_CF     IS NOT NULL THEN CAST(TO_NUMBER(IA.CELL_CF DEFAULT NULL ON CONVERSION ERROR) AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품') AND IA.CELL_CF_BOM IS NOT NULL THEN CAST(IA.CELL_CF_BOM AS BINARY_DOUBLE)
                                ELSE NULL                                        /* 20221212 Null 로 변경 */
                           END                          AS CELL_CONVER_FACTOR
                         , CASE WHEN UPPER(IA.PROCESS_GROUP) = 'CELL' THEN CAST(1 AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품') AND IA.CELL_CF     IS NOT NULL THEN CAST(TO_NUMBER(IA.CELL_CF DEFAULT NULL ON CONVERSION ERROR) AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품') AND IA.CELL_CF_BOM IS NOT NULL THEN CAST(IA.CELL_CF_BOM AS BINARY_DOUBLE)
                                ELSE NULL
                           END                          AS CELL_CONVER_FACTOR_XLS
                         /* ★환산수량 칸은 AS-IS 가 이진 부동소수로 곱한다 */
                         , CASE WHEN UPPER(IA.PROCESS_GROUP) = 'CELL' THEN CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                /* ★월별과 달리 부동소수 명시 변환이 없어 소수 5자리로 맞춘 뒤 곱한다 */
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품') AND IA.CELL_CF IS NOT NULL
                                THEN CAST(ROUND(CAST(TO_NUMBER(IA.CELL_CF DEFAULT NULL ON CONVERSION ERROR) AS NUMBER(20, 5))
                                                * NVL(IA.QUANTITY, 0), 7) AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품') AND IA.CELL_CF_BOM IS NOT NULL
                                THEN CAST(IA.CELL_CF_BOM AS BINARY_DOUBLE) * CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                ELSE CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                           END                          AS CELL_CONVER_QUANTITY
                         , CASE WHEN UPPER(IA.PROCESS_GROUP) = 'CELL' THEN CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                /* ★월별과 달리 부동소수 명시 변환이 없어 소수 5자리로 맞춘 뒤 곱한다 */
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품') AND IA.CELL_CF IS NOT NULL
                                THEN CAST(ROUND(CAST(TO_NUMBER(IA.CELL_CF DEFAULT NULL ON CONVERSION ERROR) AS NUMBER(20, 5))
                                                * NVL(IA.QUANTITY, 0), 7) AS BINARY_DOUBLE)
                                WHEN IA.ITEM_TYPE IN ('반제품', '제품') AND IA.CELL_CF_BOM IS NOT NULL
                                THEN CAST(IA.CELL_CF_BOM AS BINARY_DOUBLE) * CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                                ELSE CAST(NVL(IA.QUANTITY, 0) AS BINARY_DOUBLE)
                           END                          AS CELL_CONVER_QUANTITY_XLS
                         /* ---------------------------------------------------------------- */
                         , IA.LEVEL_1_NAME
                         , IA.LEVEL_2_NAME
                         , IA.LEVEL_3_NAME
                         , IA.LEVEL_4_NAME
                         , IA.EE_FLOW_ID                AS FLOW_ID
                         , CASE WHEN IA.ITEM_TYPE = '제품' AND IA.PROCESS_GROUP = '모듈/팩' AND IA.MATERIAL_GROUP = 'Module Assembly'
                                THEN IA.FIT_GROUP_CODE1
                                WHEN IA.CELL_GROUP IS NULL AND IA.ITEM_TYPE = '반제품' AND IA.EE_FLOW_ID IS NOT NULL
                                THEN IA.FIT_GROUP_CODE1
                                ELSE IA.CELL_GROUP
                           END                          AS CELL_GROUP
                         , CASE WHEN IA.ITEM_TYPE = '제품' AND IA.PROCESS_GROUP = '모듈/팩' AND IA.MATERIAL_GROUP = 'Module Assembly'
                                THEN IA.FIT_GROUP_CODE2
                                WHEN IA.CELL_GROUP IS NULL AND IA.ITEM_TYPE = '반제품' AND IA.EE_FLOW_ID IS NOT NULL
                                THEN IA.FIT_GROUP_CODE2
                                ELSE IA.PACK_GROUP
                           END                          AS PACK_GROUP
                         , IA.CELL_CF
                         , IA.CELL_CF_BOM
                         , IA.TARGET_CELL
                         , CASE WHEN IA.CELL_CF IS NULL AND IA.CELL_CF_BOM > 0 THEN 'Y'
                                ELSE NULL
                           END                          AS USE_CELL_CF_BOM
                         , IA.EX_TO_BAMT
                         , IA.ERP_DIV                                     /* ★일별은 ATTRIBUTE11 */
                         , IA.PROFIT_CENTER_CODE
                         , IA.PROFIT_CENTER
--                      FROM (SELECT IB.YYYYMM    --  2026.10.06 AJS
                      FROM (SELECT /*+ USE_HASH(E) USE_HASH(F) USE_HASH(G) */ IB.YYYYMM    --  2026.10.06 AJS
                                 , IB.CUTOFF_DATE
                                 , IB.DIVISION_ID
                                 , IB.COMPANY_ID
                                 , IB.PLANT_ID
                                 , IB.PLANT_NAME
                                 , IB.ITEM_ID
                                 , IB.ITEM_DESCRIPTION
                                 , IB.ITEM_UOM
                                 , IB.STORAGE_LOCATION
                                 , IB.STORAGE_DESC
                                 , IB.QUANTITY
                                 , IB.AMOUNT
                                 , IB.CURRENCY
                                 , IB.AMOUNT_KRW
                                 , IB.UNIT_PRICE
                                 , IB.UNIT_PRICE_KRW
                                 , IB.VALUATION_CLASS
                                 , IB.PURCHASE_PO
                                 , IB.SUPPLIER_CODE
                                 , IB.SUPPLIER_NAME
                                 , IB.ITEM_TYPE
                                 , IB.PROCESS_GROUP
                                 , IB.MATERIAL_GROUP
                                 , IB.FORECAST_INFO_CELL_MODEL
                                 , IB.MDM_PROJECT_NICK_NAME
                                 , IB.EXTRA_SPEC
                                 , IB.LEVEL_1_NAME
                                 , IB.LEVEL_2_NAME
                                 , IB.LEVEL_3_NAME
                                 , IB.LEVEL_4_NAME
                                 , IB.CELL_GROUP
                                 , IB.PACK_GROUP
                                 , IB.UNRESTRICTED_QTY
                                 , IB.BLOCKED_STOCK
                                 , IB.IN_TRANSIT
                                 , IB.CELL_CF
                                 , IB.TARGET_CELL
                                 , IB.CELL_CF_BOM
                                 , IB.EX_TO_BAMT
                                 , IB.ERP_DIV
                                 , IB.PROFIT_CENTER_CODE
                                 , IB.PROFIT_CENTER
                                 , E.GROUP_CODE1        AS FIT_GROUP_CODE1
                                 , E.GROUP_CODE2        AS FIT_GROUP_CODE2
                                 , F.FLOW_ID            AS EE_FLOW_ID
                                 , G.CELL_TYPE          AS CA_CELL_TYPE
                                 , G.ITEM_ID_PROD       AS CA_ITEM_ID_PROD
                                 , G.PROCESS_GROUP      AS CA_PROCESS_GROUP
                                 , G.PROCESS_DETAIL     AS CA_PROCESS_DETAIL
--                              FROM (SELECT '‘' || SUBSTR(A.YYYYMM, 3, 2) || '.' || SUBSTR(A.YYYYMM, -2) AS YYYYMM    /* 보고시점 */    --  2026.10.06 AJS
                              FROM (SELECT /*+ USE_HASH(B) USE_HASH(C) USE_HASH(D) USE_HASH(E) */ '‘' || SUBSTR(A.YYYYMM, 3, 2) || '.' || SUBSTR(A.YYYYMM, -2) AS YYYYMM    /* 보고시점 */    --  2026.10.06 AJS
                                         , A.YYYYMM                       AS YYYYMM_DATA
                                         , SUBSTR(A.CUTOFF_DATE, 3, 2) || '.' || SUBSTR(A.CUTOFF_DATE, 5, 2) || '.' || SUBSTR(A.CUTOFF_DATE, -2) AS CUTOFF_DATE
                                         , A.DIVISION_ID
                                         , A.COMPANY_ID
                                         , A.PLANT_ID
                                         , (SELECT MAX(XA.PLANT_NAME)
                                              FROM GT_SCP0085_SITE XA
                                             WHERE XA.PLANT_ID = A.PLANT_ID) AS PLANT_NAME
                                         , A.ITEM_ID
                                         , A.ITEM_DESCRIPTION
                                         , A.ITEM_UOM
                                         , A.STORAGE_LOCATION
                                         , A.STORAGE_DESC
                                         , A.QUANTITY
                                         , A.AMOUNT
                                         , A.CURRENCY
                                         , A.AMOUNT_KRW
                                         , A.UNIT_PRICE
                                         , A.UNIT_PRICE_KRW
                                         , A.VALUATION_CLASS
                                         , A.PURCHASE_PO
                                         , A.SUPPLIER_CODE
                                         , A.SUPPLIER_NAME
                                         , CASE WHEN A.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                                WHEN A.VALUATION_CLASS IN ('3100', '3109') AND B.ITEM_TYPE = '원부자재' THEN '상품'
                                                ELSE B.ITEM_TYPE
                                           END                            AS ITEM_TYPE          /* 원반제구분 */
                                         , CASE WHEN A.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                                ELSE B.PROCESS_GROUP
                                           END                            AS PROCESS_GROUP      /* 자재구분 */
                                         , CASE WHEN A.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                                ELSE B.PROCESS_DETAIL
                                           END                            AS MATERIAL_GROUP     /* 자재구분상세 */
                                         , D.FORECAST_INFO_CELL_MODEL
                                         , D.NICK_NAME                    AS MDM_PROJECT_NICK_NAME
                                         , D.SCP_EXTRA_SPEC               AS EXTRA_SPEC
                                         , B.LEVEL_1_NAME
                                         , B.LEVEL_2_NAME
                                         , B.LEVEL_3_NAME
                                         , B.LEVEL_4_NAME
                                         , C.GROUP_CODE1                  AS CELL_GROUP
                                         , C.GROUP_CODE2                  AS PACK_GROUP
                                         , A.UNRESTRICTED_QTY                                   /* 20220811 추가 : 가용재고 */
                                         , A.BLOCKED_STOCK                                      /* 20220811 추가 : 보류재고 */
                                         , A.IN_TRANSIT                                         /* 20220811 추가 : In-Transit */
                                         , E.CELL_CF
                                         , E.TARGET_CELL
                                         , (SELECT XB.CELL_CF_BOM
                                              FROM GT_SCP0085_CF_BOM XB
                                             WHERE XB.CHILD_ITEM_ID = A.ITEM_ID
                                               AND XB.PLANT_ID      = A.PLANT_ID
                                               AND XB.MODEL_ID      = E.TARGET_CELL) AS CELL_CF_BOM
                                         , CASE WHEN A.CURRENCY = 'KRW' THEN '1'
                                                ELSE A.ATTRIBUTE9
                                           END                            AS EX_TO_BAMT
                                         , A.ATTRIBUTE11                  AS ERP_DIV             /* ★일별은 ATTRIBUTE11 */
                                         , A.ATTRIBUTE3                   AS PROFIT_CENTER_CODE
                                         , A.ATTRIBUTE4                   AS PROFIT_CENTER
                                      FROM SCP_ANL_MONTH_END_STOCK_R_D A
                                         , GT_SCP0085_SI                B
                                         , SCP_MST_FINAL_ITEM           C
                                         , SCM_MST_ITEM_SN              D
                                         , GT_SCP0085_CELL_CF           E
                                     WHERE B.ITEM_ID(+)      = A.ITEM_ID
                                       AND C.DIVISION_ID(+)  = A.DIVISION_ID
                                       AND C.ITEM_ID(+)      = A.ITEM_ID
                                       AND D.COMPANY_ID(+)   = A.COMPANY_ID
                                       AND D.DIVISION_ID(+)  = A.DIVISION_ID
                                       AND D.ITEM_ID(+)      = A.ITEM_ID
                                       AND E.ITEM_ID(+)      = A.ITEM_ID
                                       AND A.CUTOFF_DATE     = V_YYYYMMDD
                                       -- 2026.10.06 AJS 조회조건 쉼표 목록 비교를 INSTR 로 변경(STRING_SPLIT 하위질의 제거 · 사업부 조건을 원장 읽을 때 적용) (START)
--                                       AND (TRIM(V_DIVISION_ID) IS NULL
--                                        OR  UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                                        OR  A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                                                FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
--                                       AND (TRIM(V_PLANT_ID) IS NULL
--                                        OR  UPPER(V_PLANT_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                                        OR  A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                                             FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
--                                       AND (TRIM(V_ITEM_ID) IS NULL
--                                        OR  UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                                        OR  A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                                            FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
--                                       /* E20260112-000418 PROFIT CENTER DIV 추가 요청건 */
--                                       AND (TRIM(V_PROFIT_CENTER) IS NULL
--                                        OR  A.ATTRIBUTE3 IN (SELECT UPPER(COLUMN_VALUE)
--                                                               FROM TABLE(STRING_SPLIT(V_PROFIT_CENTER, ','))))) IB
                                       AND (TRIM(V_DIVISION_ID) IS NULL
                                        OR  UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                        OR  (A.DIVISION_ID IS NOT NULL AND INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_DIVISION_ID)), ' *, *', ',') || ',', ',' || A.DIVISION_ID || ',') > 0))
                                       AND (TRIM(V_PLANT_ID) IS NULL
                                        OR  UPPER(V_PLANT_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                        OR  (A.PLANT_ID IS NOT NULL AND INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_PLANT_ID)), ' *, *', ',') || ',', ',' || A.PLANT_ID || ',') > 0))
                                       AND (TRIM(V_ITEM_ID) IS NULL
                                        OR  UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                        /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                                        OR  (A.ITEM_ID IS NOT NULL AND INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_ITEM_ID)), ' *, *', ',') || ',', ',' || A.ITEM_ID || ',') > 0))
                                        OR  EXISTS (SELECT 1
                                                      FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) XS
                                                     WHERE TRIM(XS.COLUMN_VALUE) IS NOT NULL
                                                       AND (UPPER(A.ITEM_ID) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%'
                                                        OR  UPPER(NVL(D.NICK_NAME, C.NICK_NAME)) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                                        /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                                       /* E20260112-000418 PROFIT CENTER DIV 추가 요청건 */
                                       AND (TRIM(V_PROFIT_CENTER) IS NULL
                                        OR  UPPER(TRIM(V_PROFIT_CENTER)) = 'ALL' /* 조회조건 ALL 은 조건 없음 */    --  2026.10.27 AJS
                                        OR  (A.ATTRIBUTE3 IS NOT NULL AND INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_PROFIT_CENTER)), ' *, *', ',') || ',', ',' || A.ATTRIBUTE3 || ',') > 0))) IB
                                       -- 2026.10.06 AJS 조회조건 쉼표 목록 비교를 INSTR 로 변경(STRING_SPLIT 하위질의 제거 · 사업부 조건을 원장 읽을 때 적용) (END)
                                 /* ★일별은 대표 그룹 조건을 걸지 않는다 */
                                 , (SELECT DIVISION_ID
                                         , ITEM_ID
                                         , GROUP_CODE1
                                         , GROUP_CODE2
                                      FROM SCP_MST_FINAL_ITEM) E
                                 , (SELECT FLOW_ID
                                         , ITEM_ID
                                         , COMPANY_ID
                                         , DIVISION_ID
                                      FROM SCM_MST_ITEM_SN
                                     -- 2026.10.06 AJS 조회 사업부에 81 이 없으면 F 원장 읽기 생략 (START)
--                                     WHERE DIVISION_ID = '81'
--                                       AND (FLOW_ID LIKE '%A7000%'
--                                         OR FLOW_ID LIKE '%A8000%'
--                                         OR FLOW_ID LIKE '%A5000%'
--                                         OR FLOW_ID LIKE '%E2000%')) F
                                     WHERE DIVISION_ID = '81'
                                       AND (FLOW_ID LIKE '%A7000%'
                                         OR FLOW_ID LIKE '%A8000%'
                                         OR FLOW_ID LIKE '%A5000%'
                                         OR FLOW_ID LIKE '%E2000%')
                                       /* 81 이 조회 사업부에 없으면 F 는 이어질 줄이 없다 — 읽지 않는다 */
                                       AND (TRIM(V_DIVISION_ID) IS NULL
                                        OR  UPPER(V_DIVISION_ID) = 'ALL'
                                        OR  INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_DIVISION_ID)), ' *, *', ',') || ',', ',81,') > 0)) F
                                     -- 2026.10.06 AJS 조회 사업부에 81 이 없으면 F 원장 읽기 생략 (END)
                                 , GT_SCP0085_ASSY_MAP G
                             WHERE E.DIVISION_ID(+)  = IB.DIVISION_ID
                               AND E.ITEM_ID(+)      = IB.TARGET_CELL
                               AND F.DIVISION_ID(+)  = IB.DIVISION_ID
                               AND F.COMPANY_ID(+)   = IB.COMPANY_ID
                               AND F.ITEM_ID(+)      = IB.ITEM_ID
                               AND G.DIVISION_ID(+)  = IB.DIVISION_ID
                               AND G.PLANT_ID(+)     = IB.PLANT_ID
                               AND G.ITEM_ID_ASSY(+) = IB.ITEM_ID
                               AND G.RANK_NO(+)      = 1) IA
                     -- 2026.10.06 AJS 품목유형 조건 쉼표 목록 비교를 INSTR 로 변경 (START)
--                     WHERE (TRIM(V_ITEM_TYPE) IS NULL
--                        OR  CASE WHEN IA.ITEM_TYPE = '기타'     THEN 'E'
--                                 WHEN IA.ITEM_TYPE = '반제품'   THEN 'H'
--                                 WHEN IA.ITEM_TYPE = '상품'     THEN 'P'
--                                 WHEN IA.ITEM_TYPE = '원부자재' THEN 'Q'
--                                 WHEN IA.ITEM_TYPE = '저장품'   THEN 'A'
--                                 WHEN IA.ITEM_TYPE = '제품'     THEN 'R'
--                                 ELSE '-'
--                            END IN (SELECT UPPER(COLUMN_VALUE)
--                                      FROM TABLE(STRING_SPLIT(V_ITEM_TYPE, ','))))) SA
                     WHERE (TRIM(V_ITEM_TYPE) IS NULL
                        OR  UPPER(TRIM(V_ITEM_TYPE)) = 'ALL' /* 조회조건 ALL 은 조건 없음 */    --  2026.10.27 AJS
                        OR  INSTR(',' || REGEXP_REPLACE(TRIM(UPPER(V_ITEM_TYPE)), ' *, *', ',') || ','
                                , ',' || CASE WHEN IA.ITEM_TYPE = '기타'     THEN 'E'
                                              WHEN IA.ITEM_TYPE = '반제품'   THEN 'H'
                                              WHEN IA.ITEM_TYPE = '상품'     THEN 'P'
                                              WHEN IA.ITEM_TYPE = '원부자재' THEN 'Q'
                                              WHEN IA.ITEM_TYPE = '저장품'   THEN 'A'
                                              WHEN IA.ITEM_TYPE = '제품'     THEN 'R'
                                              ELSE '-'
                                         END || ',') > 0)) SA
                     -- 2026.10.06 AJS 품목유형 조건 쉼표 목록 비교를 INSTR 로 변경 (END)
             /* ★AS-IS 정렬 순서로 맞춘다(FN_ASIS_SORT_KEY) */
             ORDER BY FN_ASIS_SORT_KEY(SA.DIVISION_ID)
                    , FN_ASIS_SORT_KEY(SA.PLANT_ID)
                    , FN_ASIS_SORT_KEY(SA.ITEM_ID);

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SCP0085_GET_ENDING_INVENTORY_DAILY', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SCP0085_GET_ENDING_INVENTORY_DAILY;

    /* ==============================================================================================
       SCP0085_GET_SEARCH_INFO — 조회조건 목록 자료
       ============================================================================================== */
    PROCEDURE P_SCP0085_GET_SEARCH_INFO
    (
        P_YYYYMMDD          IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        V_YYYYMMDD          VARCHAR2(32 CHAR) := TRIM(P_YYYYMMDD);
    BEGIN
        IF LENGTH(V_YYYYMMDD) = 6 THEN
            OPEN O_RC1 FOR
                SELECT DIVISION_ID
                     , PLANT_ID
                     , ATTRIBUTE3                      AS CODE
                     , ATTRIBUTE3 || ' ' || ATTRIBUTE4 AS NAME
                  FROM SCP_ANL_MONTH_END_STOCK_R
                 WHERE YYYYMM       = V_YYYYMMDD
                   AND DIVISION_ID IS NOT NULL
                 GROUP BY DIVISION_ID
                        , PLANT_ID
                        , ATTRIBUTE3
                        , ATTRIBUTE4;
        ELSE
            OPEN O_RC1 FOR
                SELECT DIVISION_ID
                     , PLANT_ID
                     , ATTRIBUTE3                      AS CODE
                     , ATTRIBUTE3 || ' ' || ATTRIBUTE4 AS NAME
                  FROM SCP_ANL_MONTH_END_STOCK_R_D
                 WHERE CUTOFF_DATE  = V_YYYYMMDD
                   AND DIVISION_ID IS NOT NULL
                 GROUP BY DIVISION_ID
                        , PLANT_ID
                        , ATTRIBUTE3
                        , ATTRIBUTE4;
        END IF;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SCP0085_GET_SEARCH_INFO', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SCP0085_GET_SEARCH_INFO;

END PKG_SCP0085;