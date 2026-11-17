PACKAGE BODY PKG_SCP0101
IS
    /*
     * Program ID   : PKG_SCP0101
     * Description  : SCP0101 Inventory Trend 화면 - 장기재고 + 기말재고 추이 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.25   ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.06   AJS            [속도] P_SCP0101_GET_INVENTORY_TREND 기말재고 월별(GT_SCP0101_MES_MONTH) 적재를 장기재고 결과 품목으로 한정
     * 2026.10.07   AJS            [속도2차] 월별 장기재고 수량 6칸을 행별 하위질의(GT_SCP0101_LTS_MSUM) 대신 원장을 한 번 집계해 붙임 · 셀 환산계수 · BOM 환산계수 · 기말재고 적재를 장기재고 대상 품목으로 한정
     * 2026.10.22   AJS            빈 창고 Inventory Type 표시값을 AS-IS 와 같은 '-' 로 복원(두 자리)
     *
     * [전환 공통 규칙]
     * - AS-IS #TEMP 14개 중 두 번 이상 참조하는 9개는 전역 임시 테이블로 옮겼다(00_DDL).
     *   한 번만 참조하는 것(W_PLANT · W_EXTRA_SPEC · 최종품목 · 장기재고 집계)은 인라인 뷰로 옮겼다.
     * - AS-IS WITH 절(W_PLANT · W_EXTRA_SPEC · W_SI)은 인라인 뷰로 옮겼다.
     * - AS-IS IIF(조건, 참, 거짓) 은 CASE 로, EXCEPT 는 MINUS 로 옮겼다.
     * - 보고시점 칸의 앞 따옴표는 AS-IS 가 쓰는 특수 문자를 리터럴로 그대로 적었다.
     *   ★CHR(8216) 과 UNISTR('\2018') 은 이 데이터베이스에서 다른 문자가 되어 쓸 수 없다.
     * - 환산계수 칸(CELL_CF)은 원장이 문자라 숫자로 바꿔 쓴다. 숫자가 아닌 값은 빈 값으로 둔다.
     * - ★정렬·최대값은 FN_ASIS_SORT_KEY 를 쓴다. AS-IS 정렬은 하이픈을 빼고 견주고
     *   구두점이 숫자·문자보다 앞이라 이 데이터베이스 기본 순서로는 다른 값이 뽑힌다(00_PRE 참고).
     */

    C_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SCP0101_GET_INVENTORY_TREND';

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
            SELECT '0' AS CODE
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
            SELECT '-1' AS CODE
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
        INSERT
          INTO SCM_SYS_LOG_BATCH
             ( PROGRAM_NAME
             , LOG_TYPE
             , LOG_COUNT
             , LOG_MESSAGE
             , DESCRIPTION
             , EVENT_DATE
             , CREATION_DATE
             , CREATED_BY
             , LAST_UPDATE_DATE
             , LAST_UPDATED_BY)
        VALUES
             ( P_PROGRAM_NAME
             , 'ERROR'
             , NULL
             , SUBSTR(P_MESSAGE, 1, 1000)
             , NULL
             , SYSDATE
             , SYSDATE
             , P_PROGRAM_NAME
             , SYSDATE
             , P_PROGRAM_NAME);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END P_WRITE_ERROR_LOG;

    /* ==============================================================================================
       SCP0101_GET_INVENTORY_TREND
       ============================================================================================== */
    PROCEDURE P_SCP0101_GET_INVENTORY_TREND
    (
        P_YYYYMM            IN  VARCHAR2
      , P_DIVISION_ID       IN  CLOB
      , P_PLANT_ID          IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        /*
 * Program ID   : SCP0101_GET_INVENTORY_TREND
 * Description  : LONG TERM STOCK + Ending Inventory
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2023/09/21   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - 최초 생성
 * 2023/10/16   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 - Plant Name 개선
 * 2025.11.10   park.choyi		[E20250310-000014] 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기')
 ----------------------------------------------------------------------------------------------------
	
SCP0101_GET_INVENTORY_TREND
  @p_yyyymm			= '202308'		
, @p_division_id	= ''				
, @p_plant_id		= ''				
, @p_item_id		= ''	           
, @debug_mode		= 'T'	

 */
        V_DIVISION_ID       VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 32767));
        V_PLANT_ID          VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_PLANT_ID, 1, 32767));
        V_ITEM_ID           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID, 1, 32767));
        V_YYYYMM            VARCHAR2(24 CHAR)    := UPPER(TRIM(P_YYYYMM));
        V_YYYYMM_MONTH1     VARCHAR2(24 CHAR);
        V_YYYYMM_MONTH2     VARCHAR2(24 CHAR);
        V_YYYYMM_MONTH3     VARCHAR2(24 CHAR);
        V_YYYYMM_MONTH4     VARCHAR2(24 CHAR);
        V_YYYYMM_MONTH5     VARCHAR2(24 CHAR);
        V_YYYYMM_DISP       VARCHAR2(24 CHAR);
    BEGIN
        ------------------------------------------------------------------------
        -- LOG 용 변수 설정
        ------------------------------------------------------------------------
        -- START/END/ERROR/...
        ------------------------------------------------------------------------  
        ------------------------------------------------------------------------
        -- LOG 시작
        ------------------------------------------------------------------------
        ------------------------------------------------------------------------  
        V_YYYYMM_MONTH1 := TO_CHAR(ADD_MONTHS(TO_DATE(V_YYYYMM || '01', 'YYYYMMDD'), -5), 'YYYYMM');
        V_YYYYMM_MONTH2 := TO_CHAR(ADD_MONTHS(TO_DATE(V_YYYYMM || '01', 'YYYYMMDD'), -4), 'YYYYMM');
        V_YYYYMM_MONTH3 := TO_CHAR(ADD_MONTHS(TO_DATE(V_YYYYMM || '01', 'YYYYMMDD'), -3), 'YYYYMM');
        V_YYYYMM_MONTH4 := TO_CHAR(ADD_MONTHS(TO_DATE(V_YYYYMM || '01', 'YYYYMMDD'), -2), 'YYYYMM');
        V_YYYYMM_MONTH5 := TO_CHAR(ADD_MONTHS(TO_DATE(V_YYYYMM || '01', 'YYYYMMDD'), -1), 'YYYYMM');

        /* 보고시점 표시 — 앞 문자는 AS-IS 가 쓰는 왼쪽 홑따옴표(U+2018)를 그대로 적은 것 */
        V_YYYYMM_DISP := '‘' || SUBSTR(V_YYYYMM, 3, 2) || '.' || SUBSTR(V_YYYYMM, -2);

        DELETE
          FROM GT_SCP0101_LTS_FOCUS;
        DELETE
          FROM GT_SCP0101_LTS_MONTH;
        DELETE
          FROM GT_SCP0101_LTS_MSUM;
        DELETE
          FROM GT_SCP0101_CELL_CF;
        DELETE
          FROM GT_SCP0101_CF_BOM;
        DELETE
          FROM GT_SCP0101_LTS_FIN;
        DELETE
          FROM GT_SCP0101_MES;
        DELETE
          FROM GT_SCP0101_MES_MONTH;
        DELETE
          FROM GT_SCP0101_MES_JOIN;

        /* ==========================================================================================
           1. 조회 대상 FOCUS — 기준월
           ========================================================================================== */
        --PRINT '시작 시간 : ' + CONVERT(VARCHAR(100), @START_TIME, 121) 
        --SELECT @END_TIME = GETDATE()
        --PRINT 'IDX_TMP_MONTH_END_STOCK_MONTH BEFORE : ' + CONVERT(VARCHAR(100), @END_TIME-@START_TIME, 114)
        --#####################################################################################################################################
        -- 조회 대상 FOCUS : #TMP_SCP_ANL_LONG_TERM_STOCK_FOCUS
        --#####################################################################################################################################
        INSERT
          INTO GT_SCP0101_LTS_FOCUS
             ( YYYYMM
             , YYYYMM_ORG
             , DIVISION_ID
             , PLANT_ID
             , ITEM_ID
             , LONG_TERM_TYPE
             , LONG_TERM_TYPE_CODE
             , ITEM_NAME
             , ITEM_UOM
             , ITEM_TYPE
             , PROCESS_GROUP
             , PROCESS_DETAIL
             , GPLM_CELL_MODEL
             , MDM_NICK_NAME
             , GPLM_CELL_CONVERSION_FACTOR
             , VALUATION_CLASS
             , LONG_TERM_STOCK_QTY
             , LONG_TERM_STOCK_AMOUNT
             , AMOUNT_KRW
             , CURRENCY
             , AMOUNT
             , UNIT_PRICE
             , UNIT_PRICE_ORG
             , UNIT_PRICE_KRW_ORG
             , EX_TO_BAMT
             , WAERS
             , LPEIN)
        SELECT V_YYYYMM AS YYYYMM
             , MAX(YYYYMM) AS YYYYMM_ORG
             , DIVISION_ID
             , PLANT_ID
             , ITEM_ID
             , LONG_TERM_TYPE
             , LONG_TERM_TYPE_CODE /* [E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용 */
               /* ★AS-IS 정렬은 하이픈을 빼고 견주며 구두점이 숫자·문자보다 앞이다. FN_ASIS_SORT_KEY 가 그 순서를 낸다 */
             , MAX(ITEM_NAME) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(ITEM_NAME) NULLS FIRST) AS ITEM_NAME
             , MAX(ITEM_UOM) AS ITEM_UOM
             , MAX(ITEM_TYPE) AS ITEM_TYPE
             , MAX(PROCESS_GROUP) AS PROCESS_GROUP
             , MAX(PROCESS_DETAIL) AS PROCESS_DETAIL
             , MAX(GPLM_CELL_MODEL) AS GPLM_CELL_MODEL
             , MAX(MDM_NICK_NAME) AS MDM_NICK_NAME
             , MAX(GPLM_CELL_CONVERSION_FACTOR) AS GPLM_CELL_CONVERSION_FACTOR
             , MAX(VALUATION_CLASS) AS VALUATION_CLASS
               /* ------------------------------------------------------------------ */
             , SUM(LONG_TERM_STOCK_QTY) AS LONG_TERM_STOCK_QTY
             , SUM(LONG_TERM_STOCK_AMOUNT) AS LONG_TERM_STOCK_AMOUNT
             , MAX(AMOUNT_KRW) AS AMOUNT_KRW
             , MAX(CURRENCY) AS CURRENCY
             , SUM(AMOUNT) AS AMOUNT
             , MAX(UNIT_PRICE) AS UNIT_PRICE
             , MAX(UNIT_PRICE_ORG) AS UNIT_PRICE_ORG
             , MAX(UNIT_PRICE_KRW) AS UNIT_PRICE_KRW_ORG
             , MAX(EX_TO_BAMT) AS EX_TO_BAMT
             , MAX(WAERS) AS WAERS
             , MAX(LPEIN) AS LPEIN
          FROM SCP_ANL_LONG_TERM_STOCK
         WHERE YYYYMM = V_YYYYMM
           AND (TRIM(V_DIVISION_ID) IS NULL OR UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                        FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_PLANT_ID) IS NULL OR UPPER(V_PLANT_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                               FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL OR UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                            FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
         GROUP BY DIVISION_ID
                , PLANT_ID
                , ITEM_ID
                , LONG_TERM_TYPE
                , LONG_TERM_TYPE_CODE;

        /* ==========================================================================================
           2. 조회 대상 MONTH — 최근 5개월
           ========================================================================================== */
        INSERT INTO GT_SCP0101_LTS_MONTH
        (
            YYYYMM
          , YYYYMM_ORG
          , DIVISION_ID
          , PLANT_ID
          , ITEM_ID
          , LONG_TERM_TYPE
          , LONG_TERM_TYPE_CODE
          , ITEM_NAME
          , ITEM_UOM
          , ITEM_TYPE
          , PROCESS_GROUP
          , PROCESS_DETAIL
          , GPLM_CELL_MODEL
          , MDM_NICK_NAME
          , GPLM_CELL_CONVERSION_FACTOR
          , VALUATION_CLASS
          , LONG_TERM_STOCK_QTY
          , LONG_TERM_STOCK_AMOUNT
          , AMOUNT_KRW
          , CURRENCY
          , AMOUNT
          , UNIT_PRICE
          , UNIT_PRICE_ORG
          , UNIT_PRICE_KRW_ORG
          , EX_TO_BAMT
          , WAERS
          , LPEIN
        )
        --#####################################################################################################################################
        -- 조회 대상 MONTH : #TMP_SCP_ANL_LONG_TERM_STOCK_MONTH
        --#####################################################################################################################################
        SELECT V_YYYYMM                             AS YYYYMM
             , MAX(YYYYMM)                          AS YYYYMM_ORG
             , DIVISION_ID
             , PLANT_ID
             , ITEM_ID
             , LONG_TERM_TYPE
             , LONG_TERM_TYPE_CODE                                    /* [E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용 */
             /* ★AS-IS 정렬은 하이픈을 빼고 견주며 구두점이 숫자·문자보다 앞이다. FN_ASIS_SORT_KEY 가 그 순서를 낸다 */
             , MAX(ITEM_NAME) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(ITEM_NAME) NULLS FIRST) AS ITEM_NAME
             , MAX(ITEM_UOM)                        AS ITEM_UOM
             , MAX(ITEM_TYPE)                       AS ITEM_TYPE
             , MAX(PROCESS_GROUP)                   AS PROCESS_GROUP
             , MAX(PROCESS_DETAIL)                  AS PROCESS_DETAIL
             , MAX(GPLM_CELL_MODEL)                 AS GPLM_CELL_MODEL
             , MAX(MDM_NICK_NAME)                   AS MDM_NICK_NAME
             , MAX(GPLM_CELL_CONVERSION_FACTOR)     AS GPLM_CELL_CONVERSION_FACTOR
             , MAX(VALUATION_CLASS)                 AS VALUATION_CLASS
             /* ------------------------------------------------------------------ */
             , NULL                                 AS LONG_TERM_STOCK_QTY
             , NULL                                 AS LONG_TERM_STOCK_AMOUNT
             , NULL                                 AS AMOUNT_KRW
             , ' '                                  AS CURRENCY
             , NULL                                 AS AMOUNT
             , NULL                                 AS UNIT_PRICE
             , NULL                                 AS UNIT_PRICE_ORG
             , NULL                                 AS UNIT_PRICE_KRW_ORG
             , NULL                                 AS EX_TO_BAMT
             , ' '                                  AS WAERS
             , NULL                                 AS LPEIN
          FROM SCP_ANL_LONG_TERM_STOCK
         WHERE YYYYMM BETWEEN V_YYYYMM_MONTH1 AND V_YYYYMM_MONTH5
           AND (TRIM(V_DIVISION_ID) IS NULL
            OR  UPPER(V_DIVISION_ID) = 'ALL'          /* 조회조건 ALL 은 조건 없음 */
            OR  DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                         FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_PLANT_ID) IS NULL
            OR  UPPER(V_PLANT_ID) = 'ALL'             /* 조회조건 ALL 은 조건 없음 */
            OR  PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                      FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL
            OR  UPPER(V_ITEM_ID) = 'ALL'              /* 조회조건 ALL 은 조건 없음 */
            OR  ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                     FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
         GROUP BY DIVISION_ID
                , PLANT_ID
                , ITEM_ID
                , LONG_TERM_TYPE
                , LONG_TERM_TYPE_CODE;    --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용

        /* ==========================================================================================
           3. 장기재고 월별 합계 — 최근 5개월 + 기준월
           ========================================================================================== */
--        INSERT INTO GT_SCP0101_LTS_MSUM
--        (
--            YYYYMM
--          , DIVISION_ID
--          , PLANT_ID
--          , ITEM_ID
--          , LONG_TERM_TYPE
--          , LONG_TERM_TYPE_CODE
--          , LONG_TERM_STOCK_QTY
--        )
--        SELECT YYYYMM
--             , DIVISION_ID
--             , PLANT_ID
--             , ITEM_ID
--             , LONG_TERM_TYPE                                         /* [E20250310-000014] LONG_TERM_TYPE 는 Group 대상이므로 MAX 제외 */
--             , LONG_TERM_TYPE_CODE
--             , SUM(LONG_TERM_STOCK_QTY)             AS LONG_TERM_STOCK_QTY
--          FROM SCP_ANL_LONG_TERM_STOCK
--         WHERE YYYYMM BETWEEN V_YYYYMM_MONTH1 AND V_YYYYMM
--           AND (TRIM(V_DIVISION_ID) IS NULL
--            OR  UPPER(V_DIVISION_ID) = 'ALL'          /* 조회조건 ALL 은 조건 없음 */
--            OR  DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                         FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
--           AND (TRIM(V_PLANT_ID) IS NULL
--            OR  UPPER(V_PLANT_ID) = 'ALL'             /* 조회조건 ALL 은 조건 없음 */
--            OR  PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                      FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
--           AND (TRIM(V_ITEM_ID) IS NULL
--            OR  UPPER(V_ITEM_ID) = 'ALL'              /* 조회조건 ALL 은 조건 없음 */
--            OR  ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                     FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
--         GROUP BY YYYYMM
--                , DIVISION_ID
--                , PLANT_ID
--                , ITEM_ID
--                , LONG_TERM_TYPE
--                , LONG_TERM_TYPE_CODE;
        /* 월별 합계는 6. 장기재고 결과에서 원장을 바로 집계해 붙인다 */ /* AJS 20261007 속도 */

        /* ==========================================================================================
           4. 셀 환산계수
           ========================================================================================== */
        --#####################################################################################################################################
        -- 조회 대상 전채 : LONG TERM 6개월
        --#####################################################################################################################################
        --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
        --select * from #TMP_SCP_ANL_LONG_TERM_STOCK
        --#####################################################################################################################################
        -- 최근 5개월
        --#####################################################################################################################################
        --,MAX(LONG_TERM_TYPE				)  AS LONG_TERM_TYPE		--[E20250310-000014] LONG_TERM_TYPE 는 Group 대상이므로 MAX 제외
        --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
        INSERT INTO GT_SCP0101_CELL_CF
        (
            TARGET_CELL
          , ITEM_ID    --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
          , CELL_CF
          , RANK_NO
        )
        --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
        --#####################################################################################################################################
        --#W_CELL_CF
        --#W_CELL_CF_BOM
        --W_PLANT
        --W_EXTRA_SPEC
        --#SCP_MST_FINAL_ITEM
        --#TMP_ITEM_CLASS
        --#####################################################################################################################################
        SELECT TARGET_CELL
             , ITEM_ID
             , CELL_CF
             , ROW_NUMBER() OVER (PARTITION BY ITEM_ID ORDER BY BOM_MODIFY_DATE DESC, ATTRIBUTE5 DESC) AS RANK_NO
          FROM SCP_MST_ITEM_CELL_CF
--         WHERE (TRIM(V_ITEM_ID) IS NULL
         WHERE ITEM_ID IN (SELECT XA.ITEM_ID /* AJS 20261007 속도 */
                             FROM GT_SCP0101_LTS_FOCUS XA /* AJS 20261007 속도 */
                           UNION ALL /* AJS 20261007 속도 */
                           SELECT XB.ITEM_ID /* AJS 20261007 속도 */
                             FROM GT_SCP0101_LTS_MONTH XB) /* AJS 20261007 속도 */
           AND (TRIM(V_ITEM_ID) IS NULL /* AJS 20261007 속도 */
            OR  UPPER(V_ITEM_ID) = 'ALL'              /* 조회조건 ALL 은 조건 없음 */
            OR  ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                     FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))));

        /* ==========================================================================================
           5. BOM 환산계수
           ★AS-IS 는 나눗셈을 이진 부동소수(float)로 한다. 십진으로 계산하면 끝자리가 갈린다.
           ========================================================================================== */
        INSERT INTO GT_SCP0101_CF_BOM
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
        --#####################################################################################################################################
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
                   AND A.CHILD_ITEM_ID IN (SELECT XA.ITEM_ID /* AJS 20261007 속도 */
                                             FROM GT_SCP0101_LTS_FOCUS XA /* AJS 20261007 속도 */
                                           UNION ALL /* AJS 20261007 속도 */
                                           SELECT XB.ITEM_ID /* AJS 20261007 속도 */
                                             FROM GT_SCP0101_LTS_MONTH XB) /* AJS 20261007 속도 */
                   AND C.USE_FLAG          = 'Y'
                   AND NVL(B.ITEM_TYPE, 'H') IN ('P', 'Q', 'H')
                   AND A.ALT_PRIORITY      = 'Y'
                   --AND    CT.child_ITEM_ID = 'ANPCA1747B'
                   --and    CT.model_id = 'ACEN4065I-A1R001'
                   --and    CT.plant_id = 'G451'
                   AND D.CELL_CF          IS NULL) IA
         GROUP BY IA.COMPANY_ID
                , IA.SITE_ID
                , IA.MODEL_ID
                , IA.PLANT_ID
                , IA.CHILD_ITEM_ID;

        /* ==========================================================================================
           6. 장기재고 결과
           ========================================================================================== */
        --#####################################################################################################################################
        --#####################################################################################################################################
        --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
        --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
        --#####################################################################################################################################
        -- #TMP_LONG_TERM_STOCK_FINISH
        --#####################################################################################################################################
        ---------------------------------------------------------------------
        --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
        --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
        --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
        --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
        --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
        --AND S.LONG_TERM_TYPE= DATA.INVENTORY_TYPE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용
        -- 20220428 Gro
        ----------------------------------------------------------------------------------------------------------------------	
        INSERT
          INTO GT_SCP0101_LTS_FIN
             ( YYYYMM
             , DIVISION_ID
             , PLANT_DESCRIPTION
             , PLANT_ID
             , ITEM_ID
             , ITEM_NAME
             , ITEM_UOM --, STOCK_TYPE																			
             , LONG_TERM_TYPE
             , LONG_TERM_TYPE_CODE --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
             , ITEM_TYPE
             , PROCESS_GROUP
             , PROCESS_DETAIL
             , GPLM_CELL_MODEL
             , MDM_NICK_NAME
             , SCP_EXTRA_SPEC
             , GPLM_CELL_CONVERSION_FACTOR ----------------------------------------------------------------------------------------------------------------------
             , LEVEL_1_NAME
             , LEVEL_2_NAME
             , LEVEL_3_NAME
             , LEVEL_4_NAME
             , VALUATION_CLASS ----------------------------------------------------------------	
             , REPORT_TYPE
             , INVENTORY_TYPE
             , INVENTORY_TYPE_CODE
             , INVENTORY_TYPE_DESC
             , INVENTORY_TYPE_SORT
             , CELL_GROUP
             , PACK_GROUP
             , ITEM_TYPE_GR
             , LONG_TERM_STOCK_QTY
             , LONG_TERM_STOCK_AMOUNT
             , CURRENCY
             , EX_TO_BAMT
             , AMOUNT_KRW
             , AMOUNT
             , UNIT_PRICE
             , UNIT_PRICE_KRW
             , QTY_MONTH1
             , QTY_MONTH2
             , QTY_MONTH3
             , QTY_MONTH4
             , QTY_MONTH5
             , QTY_MONTH_FOCUS
             , CELL_TYPE_GR)
        SELECT SA.YYYYMM
             , SA.DIVISION_ID
             , SA.PLANT_DESCRIPTION
             , SA.PLANT_ID
             , SA.ITEM_ID
             , SA.ITEM_NAME
             , SA.ITEM_UOM
             , SA.LONG_TERM_TYPE
             , SA.LONG_TERM_TYPE_CODE
             , SA.ITEM_TYPE
             , SA.PROCESS_GROUP
             , SA.PROCESS_DETAIL
             , SA.GPLM_CELL_MODEL
             , SA.MDM_NICK_NAME
             , SA.SCP_EXTRA_SPEC
             , SA.GPLM_CELL_CONVERSION_FACTOR
             , SA.LEVEL_1_NAME
             , SA.LEVEL_2_NAME
             , SA.LEVEL_3_NAME
             , SA.LEVEL_4_NAME
             , SA.VALUATION_CLASS
             , SA.REPORT_TYPE
             , SA.INVENTORY_TYPE
             , SA.INVENTORY_TYPE_CODE
             , SA.INVENTORY_TYPE_DESC
             , SA.INVENTORY_TYPE_SORT
             , SA.CELL_GROUP
             , SA.PACK_GROUP
             , SA.ITEM_TYPE_GR
             , SA.LONG_TERM_STOCK_QTY
             , SA.LONG_TERM_STOCK_AMOUNT
             , SA.CURRENCY
             , SA.EX_TO_BAMT
             , SA.AMOUNT_KRW
             , SA.AMOUNT
             , SA.UNIT_PRICE
             , SA.UNIT_PRICE_KRW
               --             , (SELECT S.LONG_TERM_STOCK_QTY
               --                  FROM GT_SCP0101_LTS_MSUM S
               --                 WHERE S.YYYYMM              = V_YYYYMM_MONTH1
               --                   AND S.DIVISION_ID         = SA.DIVISION_ID
               --                   AND S.PLANT_ID            = SA.PLANT_ID
               --                   AND S.ITEM_ID             = SA.ITEM_ID
               --                   AND S.LONG_TERM_TYPE_CODE = SA.LONG_TERM_TYPE_CODE) AS QTY_MONTH1
               --             , (SELECT S.LONG_TERM_STOCK_QTY
               --                  FROM GT_SCP0101_LTS_MSUM S
               --                 WHERE S.YYYYMM              = V_YYYYMM_MONTH2
               --                   AND S.DIVISION_ID         = SA.DIVISION_ID
               --                   AND S.PLANT_ID            = SA.PLANT_ID
               --                   AND S.ITEM_ID             = SA.ITEM_ID
               --                   AND S.LONG_TERM_TYPE_CODE = SA.LONG_TERM_TYPE_CODE) AS QTY_MONTH2
               --             , (SELECT S.LONG_TERM_STOCK_QTY
               --                  FROM GT_SCP0101_LTS_MSUM S
               --                 WHERE S.YYYYMM              = V_YYYYMM_MONTH3
               --                   AND S.DIVISION_ID         = SA.DIVISION_ID
               --                   AND S.PLANT_ID            = SA.PLANT_ID
               --                   AND S.ITEM_ID             = SA.ITEM_ID
               --                   AND S.LONG_TERM_TYPE_CODE = SA.LONG_TERM_TYPE_CODE) AS QTY_MONTH3
               --             , (SELECT S.LONG_TERM_STOCK_QTY
               --                  FROM GT_SCP0101_LTS_MSUM S
               --                 WHERE S.YYYYMM              = V_YYYYMM_MONTH4
               --                   AND S.DIVISION_ID         = SA.DIVISION_ID
               --                   AND S.PLANT_ID            = SA.PLANT_ID
               --                   AND S.ITEM_ID             = SA.ITEM_ID
               --                   AND S.LONG_TERM_TYPE_CODE = SA.LONG_TERM_TYPE_CODE) AS QTY_MONTH4
               --             , (SELECT S.LONG_TERM_STOCK_QTY
               --                  FROM GT_SCP0101_LTS_MSUM S
               --                 WHERE S.YYYYMM              = V_YYYYMM_MONTH5
               --                   AND S.DIVISION_ID         = SA.DIVISION_ID
               --                   AND S.PLANT_ID            = SA.PLANT_ID
               --                   AND S.ITEM_ID             = SA.ITEM_ID
               --                   AND S.LONG_TERM_TYPE_CODE = SA.LONG_TERM_TYPE_CODE) AS QTY_MONTH5
               --             , (SELECT S.LONG_TERM_STOCK_QTY
               --                  FROM GT_SCP0101_LTS_MSUM S
               --                 WHERE S.YYYYMM              = V_YYYYMM
               --                   AND S.DIVISION_ID         = SA.DIVISION_ID
               --                   AND S.PLANT_ID            = SA.PLANT_ID
               --                   AND S.ITEM_ID             = SA.ITEM_ID
               --                   AND S.LONG_TERM_TYPE_CODE = SA.LONG_TERM_TYPE_CODE) AS QTY_MONTH_FOCUS
             , SC.QTY_MONTH1 /* AJS 20261007 속도 */
             , SC.QTY_MONTH2 /* AJS 20261007 속도 */
             , SC.QTY_MONTH3 /* AJS 20261007 속도 */
             , SC.QTY_MONTH4 /* AJS 20261007 속도 */
             , SC.QTY_MONTH5 /* AJS 20261007 속도 */
             , SC.QTY_MONTH_FOCUS /* AJS 20261007 속도 */
             , CASE WHEN SA.ITEM_TYPE_GR = 'TYPE_GR_A' THEN (SELECT MAX(F.GROUP_CODE3) FROM SCP_MST_FINAL_ITEM F WHERE F.OPERATION_GROUP IN ('A', 'P') AND F.DIVISION_ID = '40' AND F.ITEM_ID = SUBSTR(SA.ITEM_ID, 1, LENGTH(SA.ITEM_ID) - 2))
                    WHEN SA.ITEM_TYPE_GR = 'TYPE_GR_G' THEN (SELECT MAX(F.GROUP_CODE3) FROM SCP_MST_FINAL_ITEM F WHERE F.OPERATION_GROUP IN ('A', 'P') AND F.DIVISION_ID = '40' AND F.ITEM_ID = SUBSTR(SA.ITEM_ID, 1, LENGTH(SA.ITEM_ID) - 3))
                    WHEN SA.ITEM_TYPE_GR = 'TYPE_GR_PRODUCT' THEN (SELECT MAX(F.GROUP_CODE3) FROM SCP_MST_FINAL_ITEM F WHERE F.OPERATION_GROUP IN ('A', 'P') AND F.DIVISION_ID = '40' AND F.ITEM_ID = SA.ITEM_ID)
                    ELSE NULL
                END AS CELL_TYPE_GR /* 20221004 추가 */
          FROM (SELECT IA.YYYYMM
                     , IA.DIVISION_ID
                     , IA.PLANT_DESCRIPTION
                     , IA.PLANT_ID
                     , IA.ITEM_ID
                     , IA.ITEM_NAME
                     , IA.ITEM_UOM
                     , IA.LONG_TERM_TYPE
                     , IA.LONG_TERM_TYPE_CODE
                     , IA.ITEM_TYPE
                     , IA.PROCESS_GROUP
                     , IA.PROCESS_DETAIL
                     , IA.GPLM_CELL_MODEL
                     , IA.MDM_NICK_NAME
                     , IA.SCP_EXTRA_SPEC
                     , CASE WHEN IA.CELL_CF_TYPE = 'BOM' THEN IA.CELL_CF_BOM ELSE TO_NUMBER(IA.CELL_CF DEFAULT NULL ON CONVERSION ERROR) END AS GPLM_CELL_CONVERSION_FACTOR /* UI > 소수점 2자리까지 표시 */
                     , IA.LEVEL_1_NAME
                     , IA.LEVEL_2_NAME
                     , IA.LEVEL_3_NAME
                     , IA.LEVEL_4_NAME
                     , IA.VALUATION_CLASS
                     , IA.REPORT_TYPE
                     , IA.LONG_TERM_TYPE AS INVENTORY_TYPE
                       /* [E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용 Start */
                     , IA.LONG_TERM_TYPE_CODE AS INVENTORY_TYPE_CODE
                     , CASE WHEN IA.REPORT_TYPE = 'LongTerm' AND IA.LONG_TERM_TYPE_CODE = 'CODE_2' THEN 'GRM00 ~ GRM02'
                            WHEN IA.REPORT_TYPE = 'LongTerm' AND IA.LONG_TERM_TYPE_CODE = 'CODE_5' THEN 'GRM03 ~ GRM05'
                            WHEN IA.REPORT_TYPE = 'LongTerm' AND IA.LONG_TERM_TYPE_CODE = 'CODE_6' THEN 'GRM06 ~'
                            ELSE ''
                        END AS INVENTORY_TYPE_DESC
                     , CASE WHEN IA.REPORT_TYPE = 'LongTerm' AND IA.LONG_TERM_TYPE_CODE = 'CODE_2' THEN '1'
                            WHEN IA.REPORT_TYPE = 'LongTerm' AND IA.LONG_TERM_TYPE_CODE = 'CODE_5' THEN '2'
                            WHEN IA.REPORT_TYPE = 'LongTerm' AND IA.LONG_TERM_TYPE_CODE = 'CODE_6' THEN '3'
                            ELSE ''
                        END AS INVENTORY_TYPE_SORT
                       /* [E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 사용 End */
                       --, LONG_TERM_TYPE AS INVENTORY_TYPE
                       --,  CASE WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'비대상'   THEN 'GRM00 ~ GRM02' 
                       --		WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'부실 징후' THEN 'GRM03 ~ GRM05' 
                       --		WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'부실'     THEN 'GRM06 ~' 
                       --        ELSE ''
                       --	    END AS INVENTORY_TYPE_DESC
                       --,  CASE WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'비대상'   THEN '1'
                       --		WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'부실 징후'THEN '2'
                       --		WHEN REPORT_TYPE = 'LongTerm' AND LONG_TERM_TYPE = N'부실'     THEN '3'
                       --        ELSE ''
                       --	    END AS INVENTORY_TYPE_SORT
                       --, LONG_TERM_STOCK_QTY AS QTY_MONTH_FOCUS
                     , IA.CELL_GROUP
                     , IA.PACK_GROUP
                     , CASE WHEN IA.DIVISION_ID = '40' AND IA.ITEM_TYPE IN ('제품') AND SUBSTR(IA.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R') AND IA.CELL_CF IS NULL THEN 'TYPE_GR_A'
                            WHEN IA.DIVISION_ID = '40' AND IA.ITEM_TYPE IN ('제품') AND SUBSTR(IA.ITEM_ID, -3) IN ('-GG', '-GK') AND IA.CELL_CF IS NULL THEN 'TYPE_GR_G'
                            WHEN IA.DIVISION_ID = '40' AND IA.ITEM_TYPE IN ('제품') THEN 'TYPE_GR_PRODUCT'
                            ELSE 'TYPE_GR'
                        END AS ITEM_TYPE_GR
                     , IA.LONG_TERM_STOCK_QTY
                     , IA.LONG_TERM_STOCK_AMOUNT
                       ----------------------------------------------------------------	
                     , IA.CURRENCY
                     , CASE WHEN IA.CURRENCY = 'KRW' THEN 1 ELSE IA.EX_TO_BAMT END AS EX_TO_BAMT
                     , IA.AMOUNT_KRW
                     , CASE WHEN IA.CURRENCY = 'KRW' THEN IA.LONG_TERM_STOCK_AMOUNT
                            WHEN IA.AMOUNT IS NOT NULL THEN IA.AMOUNT
                            ELSE IA.UNIT_PRICE * IA.LONG_TERM_STOCK_QTY
                        END AS AMOUNT
                     , CASE WHEN IA.CURRENCY = 'KRW' THEN ROUND(IA.UNIT_PRICE, 0) ELSE IA.UNIT_PRICE END AS UNIT_PRICE
                     , CASE WHEN IA.CURRENCY = 'KRW' THEN ROUND(IA.UNIT_PRICE_KRW, 0) ELSE ROUND(IA.UNIT_PRICE_KRW, 2) END AS UNIT_PRICE_KRW
                  FROM (SELECT V_YYYYMM_DISP AS YYYYMM
                             , A.DIVISION_ID /* 사업부(소형전지) */
                             , B.PLANT_NAME AS PLANT_DESCRIPTION /* 플랜트지역(오창) */
                             , A.PLANT_ID /* 플랜트(A010) */
                             , A.ITEM_ID /* 자재 */
                             , A.ITEM_NAME /* 자재내역 */
                             , A.ITEM_UOM /* 단위 */
                               --단위																																	--장기진부화구분
                             , A.LONG_TERM_TYPE /* 장기진부화구분 */
                             , A.LONG_TERM_TYPE_CODE /* [E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용 */
                               --[E20250310-000014] 확장성을 고려하여 LONG_TERM_TYPE_CODE 활용
                             , CASE WHEN A.VALUATION_CLASS IN ('3020', '3030', '3040') THEN '저장품'
                                    WHEN A.VALUATION_CLASS IN ('3100', '3109') AND D.ITEM_TYPE = '원부자재' THEN '상품'
                                    ELSE D.ITEM_TYPE
                                END AS ITEM_TYPE /* 원반제구분 기말재고 방식 */
                             , D.PROCESS_GROUP /* 공정그룹 */
                             , D.PROCESS_DETAIL /* 자재그룹 */
                             , A.GPLM_CELL_MODEL /* GPLM대상셀 */
                             , A.MDM_NICK_NAME /* MDM프로젝트닉네임 */
                             , C.SCP_EXTRA_SPEC
                             , CASE WHEN D.PROCESS_GROUP = 'Cell' THEN '1.000000' /* 20220607 CELL 인 경우 환산계수 = 1 */
                                    WHEN D.ITEM_TYPE IN ('반제품', '제품') AND E.CELL_CF IS NOT NULL THEN E.CELL_CF /* 20220607 GPLM IF 환산계수 */
                                    ELSE NULL
                                END AS GPLM_CELL_CONVERSION_FACTOR_OLD
                             , CASE WHEN D.PROCESS_GROUP = 'Cell' THEN 'Cell'
                                    WHEN D.ITEM_TYPE IN ('반제품', '제품') AND E.CELL_CF IS NOT NULL THEN 'WCF'
                                    WHEN D.ITEM_TYPE IN ('반제품', '제품') AND E.CELL_CF IS NULL THEN 'BOM'
                                    ELSE NULL
                                END AS CELL_CF_TYPE
                             , (SELECT XB.CELL_CF_BOM
                                  FROM GT_SCP0101_CF_BOM XB
                                 WHERE XB.CHILD_ITEM_ID = A.ITEM_ID
                                   AND XB.PLANT_ID      = A.PLANT_ID
                                   AND XB.MODEL_ID      = E.TARGET_CELL) AS CELL_CF_BOM
                             , D.LEVEL_1_NAME /* MDM자재분류계층구조1 */
                             , D.LEVEL_2_NAME /* MDM자재분류계층구조2 */
                             , D.LEVEL_3_NAME /* MDM자재분류계층구조3 */
                             , D.LEVEL_4_NAME /* MDM자재분류계층구조4 */
                             , A.VALUATION_CLASS
                             , A.LONG_TERM_STOCK_QTY
                               /* ★AS-IS 는 곱셈 결과를 소수 6자리로 한 번 맞춘 뒤 결과 칸에서 5자리로 다시 맞춘다.
                                  한 번에 5자리로 맞추면 끝자리가 1 만큼 갈린다(두 번 반올림을 그대로 재현한다). */
                             , ROUND(ROUND(CASE WHEN A.WAERS = 'KRW' OR A.EX_TO_BAMT = 0 THEN A.LONG_TERM_STOCK_AMOUNT ELSE A.EX_TO_BAMT * A.LONG_TERM_STOCK_AMOUNT END, 6), 5) AS LONG_TERM_STOCK_AMOUNT
                             , A.CURRENCY
                             , A.AMOUNT
                             , A.AMOUNT_KRW
                             , A.UNIT_PRICE
                             , CASE WHEN A.LPEIN IS NOT NULL AND A.LPEIN <> 0 THEN CASE WHEN A.CURRENCY = 'KRW' THEN A.UNIT_PRICE_ORG / A.LPEIN ELSE A.UNIT_PRICE_ORG * A.EX_TO_BAMT / A.LPEIN END ELSE A.UNIT_PRICE_KRW END AS UNIT_PRICE_KRW
                             , CASE WHEN A.CURRENCY = 'KRW' THEN 1 ELSE A.EX_TO_BAMT END AS EX_TO_BAMT
                             , E.CELL_CF
                             , A.REPORT_TYPE
                             , A.LPEIN
                             , A.UNIT_PRICE_ORG
                             , F.GROUP_CODE1 AS CELL_GROUP
                             , F.GROUP_CODE2 AS PACK_GROUP
                          FROM (SELECT XA.YYYYMM
                                     , XA.DIVISION_ID
                                     , XA.PLANT_ID
                                     , XA.ITEM_ID
                                     , XA.LONG_TERM_TYPE
                                     , XA.LONG_TERM_TYPE_CODE
                                     , XA.ITEM_NAME
                                     , XA.ITEM_UOM
                                     , XA.VALUATION_CLASS
                                     , XA.GPLM_CELL_MODEL
                                     , XA.MDM_NICK_NAME
                                     , XA.LONG_TERM_STOCK_QTY
                                     , XA.LONG_TERM_STOCK_AMOUNT
                                     , XA.AMOUNT_KRW
                                     , XA.CURRENCY
                                     , XA.AMOUNT
                                     , XA.UNIT_PRICE
                                     , XA.UNIT_PRICE_ORG
                                     , XA.EX_TO_BAMT
                                     , XA.WAERS
                                     , XA.LPEIN
                                     , 'LongTerm' AS REPORT_TYPE
                                     , CASE WHEN XA.LPEIN IS NOT NULL AND XA.LPEIN <> 0 THEN CASE WHEN XA.CURRENCY = 'KRW' THEN XA.UNIT_PRICE_ORG / XA.LPEIN ELSE XA.UNIT_PRICE_ORG * XA.EX_TO_BAMT / XA.LPEIN END ELSE XA.UNIT_PRICE_KRW_ORG END AS UNIT_PRICE_KRW
                                  FROM (SELECT YYYYMM
                                             , DIVISION_ID
                                             , PLANT_ID
                                             , ITEM_ID
                                             , LONG_TERM_TYPE
                                             , LONG_TERM_TYPE_CODE
                                             , ITEM_NAME
                                             , ITEM_UOM
                                             , VALUATION_CLASS
                                             , GPLM_CELL_MODEL
                                             , MDM_NICK_NAME
                                             , LONG_TERM_STOCK_QTY
                                             , LONG_TERM_STOCK_AMOUNT
                                             , AMOUNT_KRW
                                             , CURRENCY
                                             , AMOUNT
                                             , UNIT_PRICE
                                             , UNIT_PRICE_ORG
                                             , UNIT_PRICE_KRW_ORG
                                             , EX_TO_BAMT
                                             , WAERS
                                             , LPEIN
                                          FROM GT_SCP0101_LTS_FOCUS
                                         UNION
                                        SELECT M.YYYYMM
                                             , M.DIVISION_ID
                                             , M.PLANT_ID
                                             , M.ITEM_ID
                                             , M.LONG_TERM_TYPE
                                             , M.LONG_TERM_TYPE_CODE
                                             , M.ITEM_NAME
                                             , M.ITEM_UOM
                                             , M.VALUATION_CLASS
                                             , M.GPLM_CELL_MODEL
                                             , M.MDM_NICK_NAME
                                             , M.LONG_TERM_STOCK_QTY
                                             , M.LONG_TERM_STOCK_AMOUNT
                                             , M.AMOUNT_KRW
                                             , M.CURRENCY
                                             , M.AMOUNT
                                             , M.UNIT_PRICE
                                             , M.UNIT_PRICE_ORG
                                             , M.UNIT_PRICE_KRW_ORG
                                             , M.EX_TO_BAMT
                                             , M.WAERS
                                             , M.LPEIN
                                          FROM GT_SCP0101_LTS_MONTH M
                                             , (SELECT DIVISION_ID
                                                     , PLANT_ID
                                                     , ITEM_ID
                                                     , LONG_TERM_TYPE
                                                     , LONG_TERM_TYPE_CODE
                                                  FROM GT_SCP0101_LTS_MONTH
                                                 MINUS
                                                SELECT DIVISION_ID
                                                     , PLANT_ID
                                                     , ITEM_ID
                                                     , LONG_TERM_TYPE
                                                     , LONG_TERM_TYPE_CODE
                                                  FROM GT_SCP0101_LTS_FOCUS) SB
                                         WHERE SB.DIVISION_ID    = M.DIVISION_ID
                                           AND SB.PLANT_ID       = M.PLANT_ID
                                           AND SB.ITEM_ID        = M.ITEM_ID
                                           AND SB.LONG_TERM_TYPE = M.LONG_TERM_TYPE) XA) A
                             , (SELECT DISTINCT PLANT_ID
                                     , PLANT_NAME
                                  FROM SCM_PLANT_M_SN
                                 UNION
                                SELECT SEGMENT1 AS PLANT_ID
                                     , SEGMENT2 AS PLANT_NAME
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                 WHERE LOOKUP_TYPE = 'INVENTORY_SITE'
                                   AND VALID_YN    = 'Y') B
                             , (SELECT ITEM_ID
                                     , MAX(SCP_EXTRA_SPEC) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(SCP_EXTRA_SPEC) NULLS FIRST) AS SCP_EXTRA_SPEC
                                     , MAX(ITEM_CLASS) AS ITEM_CLASS
                                  FROM SCM_MST_ITEM_SN
                                 WHERE (TRIM(V_DIVISION_ID) IS NULL OR UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                                                FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                                   AND (TRIM(V_ITEM_ID) IS NULL OR UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                                    FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
                                 GROUP BY ITEM_ID) C
                             , SCM_MST_ITEM_CLASS_M D
                             , GT_SCP0101_CELL_CF E
                             , SCP_MST_FINAL_ITEM F
                         WHERE B.PLANT_ID(+) = A.PLANT_ID
                           AND C.ITEM_ID(+) = A.ITEM_ID
                           AND D.CLASS_ID(+) = C.ITEM_CLASS
                           AND E.ITEM_ID(+) = A.ITEM_ID
                           AND E.RANK_NO(+) = 1
                           AND F.DIVISION_ID(+) = A.DIVISION_ID
                               --                           AND F.ITEM_ID(+)     = A.ITEM_ID) IA) SA;
                           AND F.ITEM_ID(+) = A.ITEM_ID) IA) SA /* AJS 20261007 속도 */
             , (SELECT DIVISION_ID /* AJS 20261007 속도 */
                     , PLANT_ID /* AJS 20261007 속도 */
                     , ITEM_ID /* AJS 20261007 속도 */
                     , LONG_TERM_TYPE_CODE /* AJS 20261007 속도 */
                     , MAX(CASE WHEN YYYYMM = V_YYYYMM_MONTH1 THEN LONG_TERM_STOCK_QTY END) AS QTY_MONTH1 /* AJS 20261007 속도 */
                     , MAX(CASE WHEN YYYYMM = V_YYYYMM_MONTH2 THEN LONG_TERM_STOCK_QTY END) AS QTY_MONTH2 /* AJS 20261007 속도 */
                     , MAX(CASE WHEN YYYYMM = V_YYYYMM_MONTH3 THEN LONG_TERM_STOCK_QTY END) AS QTY_MONTH3 /* AJS 20261007 속도 */
                     , MAX(CASE WHEN YYYYMM = V_YYYYMM_MONTH4 THEN LONG_TERM_STOCK_QTY END) AS QTY_MONTH4 /* AJS 20261007 속도 */
                     , MAX(CASE WHEN YYYYMM = V_YYYYMM_MONTH5 THEN LONG_TERM_STOCK_QTY END) AS QTY_MONTH5 /* AJS 20261007 속도 */
                     , MAX(CASE WHEN YYYYMM = V_YYYYMM THEN LONG_TERM_STOCK_QTY END) AS QTY_MONTH_FOCUS /* AJS 20261007 속도 */
                  FROM (SELECT YYYYMM /* AJS 20261007 속도 */
                             , DIVISION_ID /* AJS 20261007 속도 */
                             , PLANT_ID /* AJS 20261007 속도 */
                             , ITEM_ID /* AJS 20261007 속도 */
                             , LONG_TERM_TYPE /* AJS 20261007 속도 */
                             , LONG_TERM_TYPE_CODE /* AJS 20261007 속도 */
                             , SUM(LONG_TERM_STOCK_QTY) AS LONG_TERM_STOCK_QTY /* AJS 20261007 속도 */
                          FROM SCP_ANL_LONG_TERM_STOCK /* AJS 20261007 속도 */
                         WHERE YYYYMM BETWEEN V_YYYYMM_MONTH1 AND V_YYYYMM /* AJS 20261007 속도 */
                           AND (TRIM(V_DIVISION_ID) IS NULL /* AJS 20261007 속도 */ OR UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ /* AJS 20261007 속도 */ OR DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE) /* AJS 20261007 속도 */
                                                                                                                                                                                    FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ',')))) /* AJS 20261007 속도 */
                           AND (TRIM(V_PLANT_ID) IS NULL /* AJS 20261007 속도 */ OR UPPER(V_PLANT_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ /* AJS 20261007 속도 */ OR PLANT_ID IN (SELECT UPPER(COLUMN_VALUE) /* AJS 20261007 속도 */
                                                                                                                                                                           FROM TABLE(STRING_SPLIT(V_PLANT_ID, ',')))) /* AJS 20261007 속도 */
                           AND (TRIM(V_ITEM_ID) IS NULL /* AJS 20261007 속도 */ OR UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ /* AJS 20261007 속도 */ OR ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) /* AJS 20261007 속도 */
                                                                                                                                                                        FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')))) /* AJS 20261007 속도 */
                         GROUP BY YYYYMM /* AJS 20261007 속도 */
                                , DIVISION_ID /* AJS 20261007 속도 */
                                , PLANT_ID /* AJS 20261007 속도 */
                                , ITEM_ID /* AJS 20261007 속도 */
                                , LONG_TERM_TYPE /* AJS 20261007 속도 */
                                , LONG_TERM_TYPE_CODE) /* AJS 20261007 속도 */
                 GROUP BY DIVISION_ID /* AJS 20261007 속도 */
                        , PLANT_ID /* AJS 20261007 속도 */
                        , ITEM_ID /* AJS 20261007 속도 */
                        , LONG_TERM_TYPE_CODE) SC /* AJS 20261007 속도 */
         WHERE SC.DIVISION_ID(+) = SA.DIVISION_ID /* AJS 20261007 속도 */
           AND SC.PLANT_ID(+) = SA.PLANT_ID /* AJS 20261007 속도 */
           AND SC.ITEM_ID(+) = SA.ITEM_ID /* AJS 20261007 속도 */
           AND SC.LONG_TERM_TYPE_CODE(+) = SA.LONG_TERM_TYPE_CODE; /* AJS 20261007 속도 */

        /* ==========================================================================================
           7. 기말재고 집계 — 기준월
           ========================================================================================== */
        --#####################################################################################################################################
        -- #TMP_MONTH_END_STOCK
        --#####################################################################################################################################
        -- [COMPANY_ID] [varchar](4) NOT NULL,
        --ATTRIBUTE6 [nvarchar](100) NOT NULL,
        ---------------------------------------------------------------------
        INSERT
          INTO GT_SCP0101_MES
             ( YYYYMM
             , DIVISION_ID
             , PLANT_ID
             , ITEM_ID
             , STORAGE_LOCATION
             , STORAGE_DESC
             , VALUATION_CLASS
             , QUANTITY
             , AMOUNT
             , AMOUNT_KRW
             , UNIT_PRICE
             , UNIT_PRICE_KRW
             , CURRENCY
             , EX_TO_BAMT
             , UNRESTRICTED_QTY
             , QT_STOCK
             , BLOCKED_STOCK)
        SELECT V_YYYYMM_DISP AS YYYYMM
             , A.DIVISION_ID
               --,A.COMPANY_ID
             , A.PLANT_ID
             , A.ITEM_ID
               --             , CASE WHEN A.STORAGE_LOCATION IS NULL THEN '-'    --  2026.10.11 AJS
               --             , CASE WHEN A.STORAGE_LOCATION IS NULL THEN '/'    --  2026.10.11 AJS
             , CASE WHEN A.STORAGE_LOCATION IS NULL THEN '-' --  2026.10.22 AJS
                   ELSE A.STORAGE_LOCATION END AS STORAGE_LOCATION
             , MAX(A.STORAGE_DESC) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(A.STORAGE_DESC) NULLS FIRST) AS STORAGE_DESC
             , MAX(A.VALUATION_CLASS) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(A.VALUATION_CLASS) NULLS FIRST) AS VALUATION_CLASS
               --,A.ATTRIBUTE6
             , SUM(CASE WHEN A.YYYYMM = V_YYYYMM THEN A.QUANTITY END) AS QUANTITY
             , SUM(CASE WHEN A.YYYYMM = V_YYYYMM THEN A.AMOUNT END) AS AMOUNT
             , SUM(CASE WHEN A.YYYYMM = V_YYYYMM THEN A.AMOUNT_KRW END) AS AMOUNT_KRW
             , MAX(CASE WHEN A.YYYYMM = V_YYYYMM THEN A.UNIT_PRICE END) AS UNIT_PRICE
             , MAX(CASE WHEN A.YYYYMM = V_YYYYMM THEN A.UNIT_PRICE_KRW END) AS UNIT_PRICE_KRW
             , MAX(CASE WHEN A.YYYYMM = V_YYYYMM THEN A.CURRENCY END) AS CURRENCY
               /* ★AS-IS 는 문자 상태로 MAX 를 구한 뒤 숫자 칸에 넣는다(숫자 MAX 와 결과가 다르다) */
             , TO_NUMBER(MAX(CASE WHEN A.YYYYMM = V_YYYYMM THEN CASE WHEN A.CURRENCY = 'KRW' THEN '1' ELSE A.ATTRIBUTE9 END END) DEFAULT NULL ON CONVERSION ERROR) AS EX_TO_BAMT
             , SUM(CASE WHEN A.YYYYMM = V_YYYYMM THEN A.UNRESTRICTED_QTY END) AS UNRESTRICTED_QTY
             , SUM(CASE WHEN A.YYYYMM = V_YYYYMM THEN A.QT_STOCK END) AS QT_STOCK
             , SUM(CASE WHEN A.YYYYMM = V_YYYYMM THEN A.BLOCKED_STOCK END) AS BLOCKED_STOCK
          FROM SCP_ANL_MONTH_END_STOCK_R A
             , SCP_MST_FINAL_ITEM B
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.ITEM_ID(+) = A.ITEM_ID
           AND EXISTS (SELECT 1 /* AJS 20261007 속도 */
                         FROM GT_SCP0101_LTS_FIN SA /* AJS 20261007 속도 */
                        WHERE SA.DIVISION_ID = A.DIVISION_ID /* AJS 20261007 속도 */
                          AND SA.PLANT_ID    = A.PLANT_ID /* AJS 20261007 속도 */
                          AND SA.ITEM_ID     = A.ITEM_ID) /* AJS 20261007 속도 */
           AND A.DIVISION_ID IS NOT NULL
           AND A.YYYYMM BETWEEN V_YYYYMM_MONTH1 AND V_YYYYMM
               --           AND NVL(A.STORAGE_LOCATION, '-') <> '미착'    /* ★AS-IS 빈 값 1,093행이 이 조건을 통과한다(Oracle 은 NULL 이라 NVL 필요) */    --  2026.10.11 AJS
           AND NVL(A.STORAGE_LOCATION, '/') <> '미착' /* ★AS-IS 빈 값 1,093행이 이 조건을 통과한다(Oracle 은 NULL 이라 NVL 필요) */ --  2026.10.11 AJS
           AND A.VALUATION_CLASS NOT IN (SELECT SEGMENT1
                                           FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                          WHERE LOOKUP_TYPE = 'ERP_LONGTERM_EXCEPT_VALCALSS'
                                            AND VALID_YN    = 'Y')
           AND (TRIM(V_DIVISION_ID) IS NULL OR UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                          FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_PLANT_ID) IS NULL OR UPPER(V_PLANT_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                 FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL OR UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                              FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
               --A.YYYYMM
         GROUP BY A.DIVISION_ID
                  --,A.COMPANY_ID
                , A.PLANT_ID
                , A.ITEM_ID
                , A.STORAGE_LOCATION;

        /* ==========================================================================================
           8. 기말재고 월별 — 최근 5개월 + 기준월
           ========================================================================================== */
        INSERT INTO GT_SCP0101_MES_MONTH
        (
            YYYYMM
          , YYYYMM_ORG
          , DIVISION_ID
          , PLANT_ID
          , ITEM_ID
          , STORAGE_LOCATION
          , QUANTITY
          , UNRESTRICTED_QTY
          , QT_STOCK
          , BLOCKED_STOCK
        )
        --,A.VALUATION_CLASS
        --,A.ATTRIBUTE6
        --#####################################################################################################################################
        -- 최근5개월
        --#####################################################################################################################################
        SELECT '‘' || SUBSTR(A.YYYYMM, 3, 2) || '.' || SUBSTR(A.YYYYMM, -2) AS YYYYMM
             , A.YYYYMM                                              AS YYYYMM_ORG
             , A.DIVISION_ID
             , A.PLANT_ID
             , A.ITEM_ID
--             , CASE WHEN A.STORAGE_LOCATION IS NULL THEN '-'    --  2026.10.11 AJS
--             , CASE WHEN A.STORAGE_LOCATION IS NULL THEN '/'    --  2026.10.11 AJS
             , CASE WHEN A.STORAGE_LOCATION IS NULL THEN '-'    --  2026.10.22 AJS
                    ELSE A.STORAGE_LOCATION
               END                                                   AS STORAGE_LOCATION
             , SUM(A.QUANTITY)                                       AS QUANTITY
             , SUM(A.UNRESTRICTED_QTY)                               AS UNRESTRICTED_QTY
             , SUM(A.QT_STOCK)                                       AS QT_STOCK
             , SUM(A.BLOCKED_STOCK)                                  AS BLOCKED_STOCK
          FROM SCP_ANL_MONTH_END_STOCK_R A
             , SCP_MST_FINAL_ITEM        B
         WHERE B.DIVISION_ID(+)  = A.DIVISION_ID
           AND B.ITEM_ID(+)      = A.ITEM_ID
           -- 2026.10.06 AJS 결과에 쓰이는 품목만 적재 (START)
           AND EXISTS (SELECT 1                     /* 월별 수량은 장기재고 결과(LTS_FIN)의 사업부·플랜트·품목에만 붙는다 */
                         FROM GT_SCP0101_LTS_FIN SA
                        WHERE SA.DIVISION_ID = A.DIVISION_ID
                          AND SA.PLANT_ID    = A.PLANT_ID
                          AND SA.ITEM_ID     = A.ITEM_ID)
           -- 2026.10.06 AJS 결과에 쓰이는 품목만 적재 (END)
           AND A.DIVISION_ID    IS NOT NULL
           AND A.YYYYMM BETWEEN V_YYYYMM_MONTH1 AND V_YYYYMM
           AND (TRIM(V_DIVISION_ID) IS NULL
            OR  UPPER(V_DIVISION_ID) = 'ALL'          /* 조회조건 ALL 은 조건 없음 */
            OR  A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_PLANT_ID) IS NULL
            OR  UPPER(V_PLANT_ID) = 'ALL'             /* 조회조건 ALL 은 조건 없음 */
            OR  A.PLANT_ID IN (SELECT UPPER(COLUMN_VALUE)
                                        FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL
            OR  UPPER(V_ITEM_ID) = 'ALL'              /* 조회조건 ALL 은 조건 없음 */
            OR  A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                       FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
         GROUP BY A.YYYYMM
                , A.DIVISION_ID
                , A.PLANT_ID
                , A.ITEM_ID
                , A.STORAGE_LOCATION;

        /* ==========================================================================================
           9. 기말재고 결과
           ========================================================================================== */
        --#####################################################################################################################################
        -- #TMP_MONTH_END_STOCK_JOIN
        --#####################################################################################################################################
        --,E.QUANTITY AS QTY_MONTH_FOCUS
        --,(E.QUANTITY - (ISNULL(QT_STOCK,0) + ISNULL(BLOCKED_STOCK,0)))  AS INV_STATUS_AVAILABLE
        --,CASE WHEN QT_STOCK IS NULL AND BLOCKED_STOCK IS NULL THEN NULL
        --      ELSE (ISNULL(QT_STOCK,0) + ISNULL(BLOCKED_STOCK,0)) 
        --	  END AS INV_STATUS_HOLDING
        --#####################################################################################################################################
        -- #TMP_LONG_TERM_STOCK_FINISH
        --#####################################################################################################################################
        -- 20220428 Gro
        INSERT
          INTO GT_SCP0101_MES_JOIN
             ( YYYYMM
             , DIVISION_ID
             , PLANT_DESCRIPTION
             , PLANT_ID
             , ITEM_ID
             , ITEM_NAME
             , ITEM_UOM
             , ITEM_TYPE
             , PROCESS_GROUP
             , PROCESS_DETAIL
             , GPLM_CELL_MODEL
             , MDM_NICK_NAME
             , SCP_EXTRA_SPEC
             , GPLM_CELL_CONVERSION_FACTOR
             , LEVEL_1_NAME
             , LEVEL_2_NAME
             , LEVEL_3_NAME
             , LEVEL_4_NAME
             , VALUATION_CLASS
             , LONG_TERM_STOCK_QTY
             , LONG_TERM_STOCK_AMOUNT
             , CURRENCY
             , EX_TO_BAMT
             , AMOUNT_KRW
             , AMOUNT
             , UNIT_PRICE
             , UNIT_PRICE_KRW
             , REPORT_TYPE
             , INVENTORY_TYPE
             , INVENTORY_TYPE_DESC
             , INVENTORY_TYPE_SORT
             , INV_STATUS_AVAILABLE
             , INV_STATUS_HOLDING
             , INV_STATUS_QT
             , INV_STATUS_BLOCKED
             , CHK_QTY
             , ITEM_TYPE_GR
             , CELL_CF
             , CELL_GROUP
             , PACK_GROUP)
        SELECT A.YYYYMM
             , A.DIVISION_ID
             , A.PLANT_DESCRIPTION
             , A.PLANT_ID
             , A.ITEM_ID
             , A.ITEM_NAME
             , A.ITEM_UOM
             , A.ITEM_TYPE
             , A.PROCESS_GROUP
             , A.PROCESS_DETAIL
             , A.GPLM_CELL_MODEL
             , A.MDM_NICK_NAME
             , A.SCP_EXTRA_SPEC
             , A.GPLM_CELL_CONVERSION_FACTOR
             , A.LEVEL_1_NAME
             , A.LEVEL_2_NAME
             , A.LEVEL_3_NAME
             , A.LEVEL_4_NAME
             , B.VALUATION_CLASS
             , B.QUANTITY AS LONG_TERM_STOCK_QTY
             , B.AMOUNT_KRW AS LONG_TERM_STOCK_AMOUNT
             , B.CURRENCY
             , B.EX_TO_BAMT AS EX_TO_BAMT
             , B.AMOUNT_KRW
             , B.AMOUNT
             , B.UNIT_PRICE
             , B.UNIT_PRICE_KRW
             , 'Ending' AS REPORT_TYPE
             , B.STORAGE_LOCATION AS INVENTORY_TYPE
             , B.STORAGE_DESC AS INVENTORY_TYPE_DESC
             , '90_'||B.STORAGE_DESC AS INVENTORY_TYPE_SORT
             , B.UNRESTRICTED_QTY AS INV_STATUS_AVAILABLE
             , CASE WHEN B.UNRESTRICTED_QTY IS NULL AND B.QUANTITY IS NULL THEN NULL ELSE NVL(B.QUANTITY, 0) - NVL(B.UNRESTRICTED_QTY, 0) END AS INV_STATUS_HOLDING
             , B.QT_STOCK AS INV_STATUS_QT
             , B.BLOCKED_STOCK AS INV_STATUS_BLOCKED
             , CASE WHEN B.QUANTITY <> (B.UNRESTRICTED_QTY + B.QT_STOCK + B.BLOCKED_STOCK) THEN 40
                    WHEN B.QT_STOCK > 0 THEN 30
                    WHEN B.BLOCKED_STOCK > 0 THEN 20
                    WHEN B.QUANTITY <> B.UNRESTRICTED_QTY THEN 10
                    ELSE 0
                END AS CHK_QTY
             , CASE WHEN A.DIVISION_ID = '40' AND A.ITEM_TYPE IN ('제품') AND SUBSTR(A.ITEM_ID, -2) IN ('-A', '-B', '-C', '-D', '-E', '-F', '-G', '-H', '-I', '-J', '-K', '-R') AND C.CELL_CF IS NULL THEN 'TYPE_GR_A'
                    WHEN A.DIVISION_ID = '40' AND A.ITEM_TYPE IN ('제품') AND SUBSTR(A.ITEM_ID, -3) IN ('-GG', '-GK') AND C.CELL_CF IS NULL THEN 'TYPE_GR_G'
                    WHEN A.DIVISION_ID = '40' AND A.ITEM_TYPE IN ('제품') THEN 'TYPE_GR_PRODUCT'
                    ELSE 'TYPE_GR'
                END AS ITEM_TYPE_GR
             , C.CELL_CF
             , D.GROUP_CODE1 AS CELL_GROUP
             , D.GROUP_CODE2 AS PACK_GROUP
          FROM (SELECT YYYYMM
                     , DIVISION_ID
                     , PLANT_ID
                     , ITEM_ID
                     , MAX(PLANT_DESCRIPTION) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(PLANT_DESCRIPTION) NULLS FIRST) AS PLANT_DESCRIPTION
                     , MAX(ITEM_NAME) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(ITEM_NAME) NULLS FIRST) AS ITEM_NAME
                     , MAX(ITEM_UOM) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(ITEM_UOM) NULLS FIRST) AS ITEM_UOM
                     , MAX(ITEM_TYPE) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(ITEM_TYPE) NULLS FIRST) AS ITEM_TYPE
                     , MAX(PROCESS_GROUP) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(PROCESS_GROUP) NULLS FIRST) AS PROCESS_GROUP
                     , MAX(PROCESS_DETAIL) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(PROCESS_DETAIL) NULLS FIRST) AS PROCESS_DETAIL
                     , MAX(GPLM_CELL_MODEL) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(GPLM_CELL_MODEL) NULLS FIRST) AS GPLM_CELL_MODEL
                     , MAX(MDM_NICK_NAME) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(MDM_NICK_NAME) NULLS FIRST) AS MDM_NICK_NAME
                     , MAX(SCP_EXTRA_SPEC) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(SCP_EXTRA_SPEC) NULLS FIRST) AS SCP_EXTRA_SPEC
                     , MAX(GPLM_CELL_CONVERSION_FACTOR) AS GPLM_CELL_CONVERSION_FACTOR
                     , MAX(LEVEL_1_NAME) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(LEVEL_1_NAME) NULLS FIRST) AS LEVEL_1_NAME
                     , MAX(LEVEL_2_NAME) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(LEVEL_2_NAME) NULLS FIRST) AS LEVEL_2_NAME
                     , MAX(LEVEL_3_NAME) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(LEVEL_3_NAME) NULLS FIRST) AS LEVEL_3_NAME
                     , MAX(LEVEL_4_NAME) KEEP (DENSE_RANK LAST ORDER BY FN_ASIS_SORT_KEY(LEVEL_4_NAME) NULLS FIRST) AS LEVEL_4_NAME
                  FROM GT_SCP0101_LTS_FIN
                 GROUP BY YYYYMM
                        , DIVISION_ID
                        , PLANT_ID
                        , ITEM_ID) A
             , GT_SCP0101_MES B
             , GT_SCP0101_CELL_CF C
             , SCP_MST_FINAL_ITEM D
         WHERE B.YYYYMM      = A.YYYYMM
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.PLANT_ID    = A.PLANT_ID
           AND B.ITEM_ID     = A.ITEM_ID
           AND C.ITEM_ID(+) = A.ITEM_ID
           AND C.RANK_NO(+) = 1
           AND D.DIVISION_ID(+) = A.DIVISION_ID
           AND D.ITEM_ID(+) = A.ITEM_ID;

        /* ==========================================================================================
           10. 결과 — 장기재고 + 기말재고
           ========================================================================================== */
        OPEN O_RC1 FOR
            SELECT YYYYMM
                 , DIVISION_ID
                 , PLANT_ID
                 , PLANT_DESCRIPTION
                 , ITEM_ID
                 , ITEM_NAME
                 , ITEM_UOM
                 , ITEM_TYPE
                 , PROCESS_GROUP
                 , PROCESS_DETAIL
                 , GPLM_CELL_MODEL
                 , MDM_NICK_NAME
                 , SCP_EXTRA_SPEC
                 , GPLM_CELL_CONVERSION_FACTOR
                 , LEVEL_1_NAME
                 , LEVEL_2_NAME
                 , LEVEL_3_NAME
                 , LEVEL_4_NAME
                 , VALUATION_CLASS
                 , LONG_TERM_STOCK_QTY
                 , LONG_TERM_STOCK_AMOUNT
                 , CURRENCY
                 , EX_TO_BAMT
                 , AMOUNT_KRW
                 , AMOUNT
                 , UNIT_PRICE
                 , UNIT_PRICE_KRW
                 , REPORT_TYPE
                 , INVENTORY_TYPE
                 , INVENTORY_TYPE_DESC
                 , INVENTORY_TYPE_SORT
                 , QTY_MONTH_FOCUS
                 , QTY_MONTH1
                 , QTY_MONTH2
                 , QTY_MONTH3
                 , QTY_MONTH4
                 , QTY_MONTH5
                 , CELL_GROUP
                 , PACK_GROUP
                 , CELL_TYPE_GR
                 , INV_STATUS_AVAILABLE
                 , INV_STATUS_HOLDING
                 , INV_STATUS_QT
                 , INV_STATUS_BLOCKED
                 , CHK_QTY
              FROM (SELECT YYYYMM
                         , DIVISION_ID
                         , PLANT_ID
                         , PLANT_DESCRIPTION
                         , ITEM_ID
                         , ITEM_NAME
                         , ITEM_UOM
                         , ITEM_TYPE
                         , PROCESS_GROUP
                         , PROCESS_DETAIL
                         , GPLM_CELL_MODEL
                         , MDM_NICK_NAME
                         , SCP_EXTRA_SPEC
                         , GPLM_CELL_CONVERSION_FACTOR
                         , LEVEL_1_NAME
                         , LEVEL_2_NAME
                         , LEVEL_3_NAME
                         , LEVEL_4_NAME
                         , VALUATION_CLASS
                         , LONG_TERM_STOCK_QTY
                         , LONG_TERM_STOCK_AMOUNT
                         , CURRENCY
                         , EX_TO_BAMT
                         , AMOUNT_KRW
                         , AMOUNT
                         , UNIT_PRICE
                         , UNIT_PRICE_KRW
                         , REPORT_TYPE
                         , INVENTORY_TYPE
                         , INVENTORY_TYPE_DESC
                         , INVENTORY_TYPE_SORT
                         , QTY_MONTH_FOCUS
                         , QTY_MONTH1
                         , QTY_MONTH2
                         , QTY_MONTH3
                         , QTY_MONTH4
                         , QTY_MONTH5
                         , CELL_GROUP
                         , PACK_GROUP
                         , CELL_TYPE_GR
                         , CAST(NULL AS NUMBER) AS INV_STATUS_AVAILABLE
                         , CAST(NULL AS NUMBER) AS INV_STATUS_HOLDING
                         , CAST(NULL AS NUMBER) AS INV_STATUS_QT
                         , CAST(NULL AS NUMBER) AS INV_STATUS_BLOCKED
                         , CAST(NULL AS NUMBER) AS CHK_QTY
                      FROM GT_SCP0101_LTS_FIN
                     UNION
                    SELECT SA.YYYYMM
                         , SA.DIVISION_ID
                         , SA.PLANT_ID
                         , SA.PLANT_DESCRIPTION
                         , SA.ITEM_ID
                         , SA.ITEM_NAME
                         , SA.ITEM_UOM
                         , SA.ITEM_TYPE
                         , SA.PROCESS_GROUP
                         , SA.PROCESS_DETAIL
                         , SA.GPLM_CELL_MODEL
                         , SA.MDM_NICK_NAME
                         , SA.SCP_EXTRA_SPEC
                         , SA.GPLM_CELL_CONVERSION_FACTOR
                         , SA.LEVEL_1_NAME
                         , SA.LEVEL_2_NAME
                         , SA.LEVEL_3_NAME
                         , SA.LEVEL_4_NAME
                         , SA.VALUATION_CLASS
                         , SA.LONG_TERM_STOCK_QTY
                         , SA.LONG_TERM_STOCK_AMOUNT
                         , SA.CURRENCY
                         , SA.EX_TO_BAMT
                         , SA.AMOUNT_KRW
                         , SA.AMOUNT
                         , SA.UNIT_PRICE
                         , SA.UNIT_PRICE_KRW
                         , SA.REPORT_TYPE
                         , SA.INVENTORY_TYPE
                         , SA.INVENTORY_TYPE_DESC
                         , SA.INVENTORY_TYPE_SORT
                         , (SELECT MAX(S.QUANTITY)
                              FROM GT_SCP0101_MES_MONTH S
                             WHERE S.YYYYMM_ORG       = V_YYYYMM
                               AND S.DIVISION_ID      = SA.DIVISION_ID
                               AND S.PLANT_ID         = SA.PLANT_ID
                               AND S.ITEM_ID          = SA.ITEM_ID
                               AND S.STORAGE_LOCATION = SA.INVENTORY_TYPE) AS QTY_MONTH_FOCUS
                         , (SELECT MAX(S.QUANTITY)
                              FROM GT_SCP0101_MES_MONTH S
                             WHERE S.YYYYMM_ORG       = V_YYYYMM_MONTH1
                               AND S.DIVISION_ID      = SA.DIVISION_ID
                               AND S.PLANT_ID         = SA.PLANT_ID
                               AND S.ITEM_ID          = SA.ITEM_ID
                               AND S.STORAGE_LOCATION = SA.INVENTORY_TYPE) AS QTY_MONTH1
                         , (SELECT MAX(S.QUANTITY)
                              FROM GT_SCP0101_MES_MONTH S
                             WHERE S.YYYYMM_ORG       = V_YYYYMM_MONTH2
                               AND S.DIVISION_ID      = SA.DIVISION_ID
                               AND S.PLANT_ID         = SA.PLANT_ID
                               AND S.ITEM_ID          = SA.ITEM_ID
                               AND S.STORAGE_LOCATION = SA.INVENTORY_TYPE) AS QTY_MONTH2
                         , (SELECT MAX(S.QUANTITY)
                              FROM GT_SCP0101_MES_MONTH S
                             WHERE S.YYYYMM_ORG       = V_YYYYMM_MONTH3
                               AND S.DIVISION_ID      = SA.DIVISION_ID
                               AND S.PLANT_ID         = SA.PLANT_ID
                               AND S.ITEM_ID          = SA.ITEM_ID
                               AND S.STORAGE_LOCATION = SA.INVENTORY_TYPE) AS QTY_MONTH3
                         , (SELECT MAX(S.QUANTITY)
                              FROM GT_SCP0101_MES_MONTH S
                             WHERE S.YYYYMM_ORG       = V_YYYYMM_MONTH4
                               AND S.DIVISION_ID      = SA.DIVISION_ID
                               AND S.PLANT_ID         = SA.PLANT_ID
                               AND S.ITEM_ID          = SA.ITEM_ID
                               AND S.STORAGE_LOCATION = SA.INVENTORY_TYPE) AS QTY_MONTH4
                         , (SELECT MAX(S.QUANTITY)
                              FROM GT_SCP0101_MES_MONTH S
                             WHERE S.YYYYMM_ORG       = V_YYYYMM_MONTH5
                               AND S.DIVISION_ID      = SA.DIVISION_ID
                               AND S.PLANT_ID         = SA.PLANT_ID
                               AND S.ITEM_ID          = SA.ITEM_ID
                               AND S.STORAGE_LOCATION = SA.INVENTORY_TYPE) AS QTY_MONTH5
                         , SA.CELL_GROUP
                         , SA.PACK_GROUP
                         , CASE WHEN SA.ITEM_TYPE_GR = 'TYPE_GR_A' THEN (SELECT MAX(F.GROUP_CODE3) FROM SCP_MST_FINAL_ITEM F WHERE F.OPERATION_GROUP IN ('A', 'P') AND F.DIVISION_ID = '40' AND F.ITEM_ID = SUBSTR(SA.ITEM_ID, 1, LENGTH(SA.ITEM_ID) - 2))
                                WHEN SA.ITEM_TYPE_GR = 'TYPE_GR_G' THEN (SELECT MAX(F.GROUP_CODE3) FROM SCP_MST_FINAL_ITEM F WHERE F.OPERATION_GROUP IN ('A', 'P') AND F.DIVISION_ID = '40' AND F.ITEM_ID = SUBSTR(SA.ITEM_ID, 1, LENGTH(SA.ITEM_ID) - 3))
                                WHEN SA.ITEM_TYPE_GR = 'TYPE_GR_PRODUCT' THEN (SELECT MAX(F.GROUP_CODE3) FROM SCP_MST_FINAL_ITEM F WHERE F.OPERATION_GROUP IN ('A', 'P') AND F.DIVISION_ID = '40' AND F.ITEM_ID = SA.ITEM_ID)
                                ELSE NULL
                            END AS CELL_TYPE_GR /* 20221004 추가 */
                         , SA.INV_STATUS_AVAILABLE
                         , SA.INV_STATUS_HOLDING
                         , SA.INV_STATUS_QT
                         , SA.INV_STATUS_BLOCKED
                         , SA.CHK_QTY
                      FROM GT_SCP0101_MES_JOIN SA)
                   /* ★AS-IS 정렬 순서로 맞춘다(FN_ASIS_SORT_KEY) */
             ORDER BY FN_ASIS_SORT_KEY(DIVISION_ID)
                    , FN_ASIS_SORT_KEY(PLANT_ID)
                    , FN_ASIS_SORT_KEY(ITEM_ID)
                    , FN_ASIS_SORT_KEY(INVENTORY_TYPE_SORT);

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG(C_PROGRAM_NAME, SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    ------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    END P_SCP0101_GET_INVENTORY_TREND;

END PKG_SCP0101;