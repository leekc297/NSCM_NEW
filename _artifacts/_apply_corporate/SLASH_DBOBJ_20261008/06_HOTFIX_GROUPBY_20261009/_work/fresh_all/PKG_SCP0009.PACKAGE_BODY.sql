PACKAGE BODY         PKG_SCP0009
IS

    /* ==============================================================================================
       [내부] 사업부가 EE 계열인지 판정
       AS-IS : @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE'))
               (2023.04.10 LWY : DIVISION_ID 공통화 작업 div_commonization)
       동적 SQL 조립과 아우터 조인 조건에서 여러 번 쓰이므로 먼저 한 번만 판정한다.
       ============================================================================================== */
    FUNCTION F_IS_EE_DIVISION
    (
        P_DIVISION_ID   IN VARCHAR2
    )
    RETURN VARCHAR2
    IS
        V_YN    VARCHAR2(1 CHAR);
    BEGIN

        SELECT NVL(MAX('Y'), 'N')
          INTO V_YN
          FROM TABLE(FN_GET_DIVISION_DIV('EE'))
         WHERE COLUMN_VALUE = P_DIVISION_ID;

        RETURN V_YN;

    END F_IS_EE_DIVISION;


    /* ==============================================================================================
       [내부] SHIPMENT PLAN FG FIX 이력 1건 기록
       AS-IS : PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST (미이관)
       ============================================================================================== */
    PROCEDURE P_FIX_HIST
    (
        P_FIX_ID                    IN VARCHAR2,
        P_DIVISION_ID               IN VARCHAR2,
        P_BIZ_TYPE                  IN VARCHAR2,
        P_ITEM_ID                   IN VARCHAR2,
        P_TO_SITE                   IN VARCHAR2,
        P_FROM_SITE                 IN VARCHAR2,
        P_PROJECT_CODE              IN VARCHAR2,
        P_INCOTERMS                 IN VARCHAR2,
        P_BOD_ID                    IN VARCHAR2,
        P_YYYYMMDD                  IN VARCHAR2,
        P_QTY                       IN VARCHAR2,
        P_ORIGIN_FROM_DIVISION_ID   IN VARCHAR2,
        P_ORIGIN_TO_DIVISION_ID     IN VARCHAR2,
        P_ELECTRODE_TYPE            IN VARCHAR2,
        P_FIX_REASON                IN VARCHAR2,
        P_CREATED_BY                IN VARCHAR2,
        P_CREATION_DATE             IN DATE,
        P_LAST_UPDATED_BY           IN VARCHAR2
    )
    IS
    /*
     * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST
     * Description  : SHIPMENT PLAN FG FIX History
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2018/05/24   KYH             Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/07/19	KYH				신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
        V_N_HISTORY_SEQ     NUMBER;
    BEGIN

        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
          INTO V_N_HISTORY_SEQ
          FROM DUAL;

        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
        (
            HISTORY_SEQ
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
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , FIX_REASON
          , CREATED_BY
          , CREATION_DATE
          , LAST_UPDATED_BY
          , LAST_UPDATE_DATE
          , HISTORY_CREATION_DATE
        )
        VALUES
        (
            V_N_HISTORY_SEQ
          , P_FIX_ID
          , P_DIVISION_ID
          , P_BIZ_TYPE
          , P_ITEM_ID
          , P_TO_SITE
          , P_FROM_SITE
          , P_PROJECT_CODE
          , P_INCOTERMS
          , P_BOD_ID
          , P_YYYYMMDD
          , TO_NUMBER(P_QTY DEFAULT NULL ON CONVERSION ERROR)
          , P_ORIGIN_FROM_DIVISION_ID
          , P_ORIGIN_TO_DIVISION_ID
          , P_ELECTRODE_TYPE
          , P_FIX_REASON
          , P_CREATED_BY
          , P_CREATION_DATE
          , P_LAST_UPDATED_BY
          , SYSDATE
          , SYSDATE
        );

    END P_FIX_HIST;


    /* ==============================================================================================
       [내부] SHIPMENT PLAN FG FIX 이력 묶음 기록
       AS-IS : PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST_DATASET (미이관)
       ============================================================================================== */
    PROCEDURE P_FIX_HIST_DATASET
    (
        P_SCP0009   IN T_SCP0009_TAB
    )
    IS
    /*
     * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_FG_FIX_HIST_DATASET
     * Description  : SHIPMENT PLAN FG FIX History
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019/06/07   HWYOON			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2019/07/22	HWYOON			[CSR ID:4053788] 자체개선 - Tact TIme Except 입력 날짜 Validation 추가 외 3건
     *                              -> 오류선조치 - qty INT 캐스팅 오류 수정
     * 2019.09.03	HWYOON			[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가 - I/M/D FLAG 추가
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
    BEGIN

        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
        (
            HISTORY_SEQ
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
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , FIX_REASON
          , CREATED_BY
          , CREATION_DATE
          , LAST_UPDATED_BY
          , LAST_UPDATE_DATE
          , HISTORY_CREATION_DATE
          , ATTRIBUTE1
        )
        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
             , A.FIX_ID
             , B.P_DIVISION_ID
             , B.P_BIZ_TYPE
             , B.P_ITEM_ID
             , B.P_TO_SITE
             , B.P_FROM_SITE
             , B.P_PROJECT_CODE
             , B.P_INCOTERMS
             , B.P_BOD_ID
             , B.P_YYYYMMDD
             /* ,cast(B.p_qty as int)
                cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int) - 3번째 인자 1 은 절삭이다 */
             , TRUNC(TO_NUMBER(B.P_QTY DEFAULT NULL ON CONVERSION ERROR), 0)
             , B.P_ORIGIN_FROM_DIVISION_ID
             , B.P_ORIGIN_TO_DIVISION_ID
             , B.P_ELECTRODE_TYPE
             , A.FIX_REASON
             , B.P_CREATED_BY
             , SYSDATE
             , B.P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE
             , NVL(B.P_ACTIVE_FLAG, '-')
          FROM SCP_ANL_SHIPMENT_PLAN_FIX A
             , TABLE(P_SCP0009) B
         WHERE A.DIVISION_ID             = B.P_DIVISION_ID
           AND A.BIZ_TYPE                = B.P_BIZ_TYPE
           AND A.ITEM_ID                 = B.P_ITEM_ID
           AND A.TO_SITE                 = B.P_TO_SITE
           AND A.FROM_SITE               = B.P_FROM_SITE
           AND A.PROJECT_CODE            = B.P_PROJECT_CODE
           AND A.INCOTERMS               = B.P_INCOTERMS
           AND A.BOD_ID                  = B.P_BOD_ID
           AND A.YYYYMMDD                = B.P_YYYYMMDD
           AND A.ORIGIN_FROM_DIVISION_ID = B.P_ORIGIN_FROM_DIVISION_ID
           AND A.ORIGIN_TO_DIVISION_ID   = B.P_ORIGIN_TO_DIVISION_ID
           AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-');

    END P_FIX_HIST_DATASET;


    /* ==============================================================================================
       [내부] SHIPMENT PLAN FG 이력 묶음 기록
       AS-IS : PR_SCP_ANL_SHIPMENT_PLAN_FG_HIST_DATASET (미이관)
       ============================================================================================== */
    PROCEDURE P_FG_HIST_DATASET
    (
        P_SCP0009   IN T_SCP0009_TAB
    )
    IS
    /*
     * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_FG_HIST_DATASET
     * Description  : Shipment Plan FG History
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019/05/20   HWYOON			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2019/07/22	HWYOON			오류선조치 - qty INT 캐스팅 오류 수정
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
    BEGIN

        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG_H
        (
            HISTORY_SEQ
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
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , CREATED_BY
          , CREATION_DATE
          , LAST_UPDATED_BY
          , LAST_UPDATE_DATE
          , HISTORY_CREATION_DATE
        )
        SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_FG_H.NEXTVAL
             , P_DIVISION_ID
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , TO_NUMBER(P_SEQ DEFAULT NULL ON CONVERSION ERROR)
             , P_BIZ_TYPE
             , P_PROJECT_CODE
             , P_ITEM_ID
             , P_TO_SITE
             , P_INCOTERMS
             , P_FROM_SITE
             , P_BOD_ID
             , P_MEASURE
             , P_YYYYMMDD
             /* cast(p_qty as int)
                cast(round (cast(p_qty as numeric(20,10)), 0 ,1) as int) - 3번째 인자 1 은 절삭이다 */
             , TRUNC(TO_NUMBER(P_QTY DEFAULT NULL ON CONVERSION ERROR), 0)
             , P_ORIGIN_FROM_DIVISION_ID
             , P_ORIGIN_TO_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_CREATED_BY
             , SYSDATE
             , P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE
          FROM TABLE(P_SCP0009);

    END P_FG_HIST_DATASET;


    /* ==============================================================================================
       [내부] 피벗 대상 날짜 문자열 조립
       AS-IS : SELECT @mQry_sum = @mQry_sum + ',' + CASE ... END + CHAR(10) FROM (...) ORDER BY sort_order_no
       P_TITLE_YN = 'Y' 이면 TITLE_PARAL 용(값 없이 빈 문자 컬럼만 만든다).
       ============================================================================================== */
    PROCEDURE P_MAKE_PIVOT_COLUMNS
    (
        P_FROM_YYYYMMDD IN  VARCHAR2,
        P_TO_YYYYMMDD   IN  VARCHAR2,
        P_BUCKET        IN  VARCHAR2,
        P_TITLE_YN      IN  VARCHAR2,
        O_QRY_SUM       OUT CLOB
    )
    IS
        V_DAY_QTY   VARCHAR2(10 CHAR) := 'QTY';
    BEGIN

        DBMS_LOB.CREATETEMPORARY(O_QRY_SUM, TRUE);

        FOR R IN
        (
            SELECT IA.YYYYMMDD
              FROM (SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK    AS YYYYMMDD
                         , A.BASIS_START_DATE || '21'              AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                       AND (P_BUCKET = 'DAILY' OR P_BUCKET = 'WEEKLY')   /* 2021/10/05 : UI 속도 개선 */
                     GROUP BY A.BASIS_YYYYMM
                            , A.ISO_WEEK
                            , A.BASIS_START_DATE
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM                  AS YYYYMMDD
                         , MIN(A.BASIS_START_DATE) || '01'         AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM
                            , A.MONTH_NAME
                    UNION ALL
                    SELECT 'D_' || A.BASIS_YYYYMMDD                AS YYYYMMDD
                         , A.BASIS_YYYYMMDD || '31'                AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                       AND P_BUCKET = 'DAILY'                           /* 2021/10/05 : UI 속도 개선 */
                     GROUP BY A.BASIS_YYYYMMDD
                   ) IA
             ORDER BY IA.SORT_ORDER_NO
        )
        LOOP

            IF P_TITLE_YN = 'Y' THEN

                /* AS-IS : SELECT @mQry_sum = @mQry_sum+', '''' '+yyyymmdd */
                DBMS_LOB.WRITEAPPEND(O_QRY_SUM
                                   , LENGTH(', '' '' AS ' || R.YYYYMMDD || CHR(10))
                                   , ', '' '' AS ' || R.YYYYMMDD || CHR(10));

            ELSIF SUBSTR(R.YYYYMMDD, 1, 2) = 'M_' THEN

                DBMS_LOB.APPEND(O_QRY_SUM
                              , TO_CLOB(', SUM(CASE WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE IN (''SHIP_PLAN_ENERGY'', ''SHIP_PLAN_AMEND_ENERGY'')'
                                     || ' THEN CAST(' || V_DAY_QTY || ' AS NUMBER(15,3))'
                                     || ' WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE NOT IN (''BALANCE'', ''WH_IN_BALANCE'')'
                                     || ' THEN CAST(' || V_DAY_QTY || ' AS NUMBER(15,2))'
                                     || ' WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE IN (''BALANCE'', ''WH_IN_BALANCE'') AND MONTH_YN = ''Y'''
                                     || ' THEN CAST(' || V_DAY_QTY || ' AS NUMBER(15,2))'
                                     || ' ELSE 0 END) AS ' || R.YYYYMMDD || CHR(10)));

            ELSIF SUBSTR(R.YYYYMMDD, 1, 2) = 'W_' THEN

                DBMS_LOB.APPEND(O_QRY_SUM
                              , TO_CLOB(', SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE IN (''SHIP_PLAN_ENERGY'', ''SHIP_PLAN_AMEND_ENERGY'')'
                                     || ' THEN CAST(' || V_DAY_QTY || ' AS NUMBER(15,3))'
                                     || ' WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE NOT IN (''BALANCE'', ''WH_IN_BALANCE'')'
                                     || ' THEN CAST(' || V_DAY_QTY || ' AS NUMBER(15,2))'
                                     || ' WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE IN (''BALANCE'', ''WH_IN_BALANCE'') AND WEEK_YN = ''Y'''
                                     || ' THEN CAST(' || V_DAY_QTY || ' AS NUMBER(15,2))'
                                     || ' ELSE 0 END) AS ' || R.YYYYMMDD || CHR(10)));

            ELSIF SUBSTR(R.YYYYMMDD, 1, 2) = 'D_' THEN

                DBMS_LOB.APPEND(O_QRY_SUM
                              , TO_CLOB(', SUM(CASE WHEN YYYYMMDD = ''' || R.YYYYMMDD || ''' AND MEASURE IN (''SHIP_PLAN_ENERGY'', ''SHIP_PLAN_AMEND_ENERGY'')'
                                     || ' THEN CAST(' || V_DAY_QTY || ' AS NUMBER(15,3))'
                                     || ' WHEN YYYYMMDD = ''' || R.YYYYMMDD || ''''
                                     || ' THEN CAST(' || V_DAY_QTY || ' AS NUMBER(15,2))'
                                     || ' ELSE 0 END) AS ' || R.YYYYMMDD || CHR(10)));

            END IF;

        END LOOP;

    END P_MAKE_PIVOT_COLUMNS;


    /* ==============================================================================================
       [내부] 실적 3벌(ERP CONFIRM 있음 · ERP CONFIRM 없음 · SSP 출하계획) 적재
       AS-IS : WITH RESULT_ERP_C_EXIST / RESULT_ERP_C_NON / PLAN_SSP
       P_TITLE_YN = 'Y' 이면 TITLE_PARAL 용이며 첫 갈래 수량을 0 으로 둔다(AS-IS 동일).
       ============================================================================================== */
    PROCEDURE P_LOAD_RESULT_SOURCE
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_BIZ_TYPE      IN VARCHAR2,
        P_FROM_YYYYMMDD IN VARCHAR2,
        P_TO_YYYYMMDD   IN VARCHAR2,
        P_FROM_RESULT   IN VARCHAR2,
        P_TO_RESULT     IN VARCHAR2,
        P_TITLE_YN      IN VARCHAR2
    )
    IS
    BEGIN

        /* ------------------------------------------------------------------------------------------
           RESULT_ERP_C_EXIST : ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상
           ------------------------------------------------------------------------------------------ */
        INSERT INTO GT_SCP0009_ERP_C_EXIST
        (
            DIVISION_ID
          , CONFIRM_ID
          , ERP_SO_NO
          , YYYYMMDD
          , TRANSPORT_MODE
          , INCOTERMS
          , ETA_DATE
          , ETD_DATE
          , PROJECT_CODE
          , RESULT_QTY
          , TO_SITE
          , ITEM_ID
        )
        SELECT A.DIVISION_ID                            AS DIVISION_ID
             , A.CONFIRM_ID                             AS CONFIRM_ID
             , A.ORDER_NO                               AS ERP_SO_NO
             , A.EXFACTORY_DATE                         AS YYYYMMDD
             , A.TRANSPORT_MODE                         AS TRANSPORT_MODE
             , A.INCOTERMS                              AS INCOTERMS
             , A.ETA_DATE                               AS ETA_DATE
             , A.ETD_DATE                               AS ETD_DATE
             , A.PROJECT_CODE                           AS PROJECT_CODE
             , CASE WHEN P_TITLE_YN = 'Y' THEN 0 ELSE SUM(A.EXFACTORY_QTY) END   AS RESULT_QTY
             , A.TO_SCM_SITE_ID                         AS TO_SITE  /* 20220316 수정 */
             , A.ITEM_ID                                AS ITEM_ID  /* 20240627 E20240612-001030 실제 Item ID 로 조회 */
          FROM SCM_DNM_EXFACTORY_RESULT A
             , SCM_ADM_LOOKUP_MASTER_DETAIL B
             , SCM_MST_SITE C
         WHERE B.SEGMENT1          = A.SSP_TYPE
           AND A.DIVISION_ID       = C.DIVISION_ID
           AND A.FROM_SCM_SITE_ID  = C.SCM_SITE_ID
           AND B.LOOKUP_TYPE       = 'ERP_SSP_TYPE'     /* LOOKUP에 등록된 공정만 */
           AND B.VALID_YN          = 'Y'
           AND C.OSP_YN            = 'N'
           AND NVL(A.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')     /* D90: DO삭제 , D10:DO생성 */
           AND A.CONFIRM_ID        LIKE 'C%'
           AND A.EXFACTORY_DATE    >= P_FROM_RESULT
           AND A.EXFACTORY_DATE    <  P_TO_RESULT
         GROUP BY A.DIVISION_ID
                , A.CONFIRM_ID
                , A.ORDER_NO
                , A.EXFACTORY_DATE
                , A.TRANSPORT_MODE
                , A.INCOTERMS
                , A.ETA_DATE
                , A.ETD_DATE
                , A.PROJECT_CODE
                , A.TO_SCM_SITE_ID      /* 20220316 수정 */
                , A.ITEM_ID             /* 20240627 E20240612-001030 실제 Item ID 로 조회 */
        /* 2022.06.09 */
        UNION ALL
        /* SCS (외주) 실적
           --------------------------------------------------------------------------
            1. PR_SSP_XIF_SCS_SHIP_RSLT_SUM_R  // SCM_DNM_SCS_SHIP_RESULT  i/f 테이블
              , ATTR_05		AS CNFM_ID   -- confirm_id
               , MAX(ATTR_04)  AS SHIP_TO
               , MAX(ATTR_08)  AS TRANS_MODE
               , MAX(ATTR_09)  AS INCOTERMS
           --------------------------------------------------------------------------- */
        SELECT A.DIVISION_ID                            AS DIVISION_ID
             , NVL(NULLIF(RTRIM(A.ATTRIBUTE5),''), '/')                   AS CONFIRM_ID
             , '-'                                      AS ERP_SO_NO
             , A.SHIP_DATE                              AS YYYYMMDD
             , NVL(NULLIF(RTRIM(D.TRANSPORT_MODE),''), '/')               AS TRANSPORT_MODE
             , NVL(NULLIF(RTRIM(D.INCOTERMS),''), '/')                    AS INCOTERMS
             , D.ETA_DATE                               AS ETA_DATE
             , D.ETD_DATE                               AS ETD_DATE
             , NVL(NULLIF(RTRIM(D.PROJECT_CODE),''), '/')                 AS PROJECT_CODE
             , SUM(A.SHIP_QTY)                          AS RESULT_QTY
             , A.TO_SITE                                AS TO_SITE
             , A.ITEM_ID                                AS ITEM_ID  /* 20240627 E20240612-001030 실제 Item ID 로 조회 */
          FROM SCM_DNM_SCS_SHIP_RESULT A
             , SCP_MST_FINAL_ITEM B
             , SCM_MST_SITE C
             , SSP_ANL_SHIP_CONFIRM D
         WHERE B.ITEM_ID         = A.ITEM_ID            /* SCP 대상 ITEM만 */
           AND B.DIVISION_ID     = A.DIVISION_ID
           AND C.SCM_SITE_ID     = A.SCM_SITE_ID
           AND C.DIVISION_ID     = A.DIVISION_ID
           /* JOIN SSP_ANL_SHIP_CONFIRM C  --2022-08-19 */
           AND A.DIVISION_ID     = D.DIVISION_ID(+)
           AND A.PACK_MODEL_CODE = D.ITEM_ID(+)
           AND A.SCM_SITE_ID     = D.FROM_SITE(+)
           AND A.TO_SITE         = D.TO_SITE(+)
           AND A.ATTRIBUTE5      = D.CONFIRM_ID(+)
           AND C.OSP_YN          = 'Y'
           AND A.ATTRIBUTE5      LIKE 'C%'              /* confirm_id */
           AND A.SHIP_DATE       >= P_FROM_RESULT
           AND A.SHIP_DATE       <  P_TO_RESULT
         GROUP BY A.DIVISION_ID
                , A.ATTRIBUTE5
                , A.SHIP_DATE
                , A.TO_SITE
                , D.TRANSPORT_MODE
                , D.INCOTERMS
                , D.PROJECT_CODE
                , D.ETA_DATE
                , D.ETD_DATE
                , A.ITEM_ID;        /* 20240627 E20240612-001030 실제 Item ID 로 조회 */

        /* ------------------------------------------------------------------------------------------
           RESULT_ERP_C_NON : ERP 출하실적에서 CONFIRM_ID 없는 실적
           ------------------------------------------------------------------------------------------ */
        INSERT INTO GT_SCP0009_ERP_C_NON
        (
            DIVISION_ID
          , CONFIRM_ID
          , ERP_SO_NO
          , FROM_SITE
          , TO_SITE
          , ITEM_ID
          , YYYYMMDD
          , TRANSPORT_MODE
          , INCOTERMS
          , ETA_DATE
          , ETD_DATE
          , PROJECT_CODE
          , QTY
        )
        SELECT A.DIVISION_ID                            AS DIVISION_ID
             , '-'                                      AS CONFIRM_ID
             , A.ORDER_NO                               AS ERP_SO_NO
             , A.FROM_SCM_SITE_ID                       AS FROM_SITE
             , NVL(D.SEGMENT4, A.TO_SCM_SITE_ID)        AS TO_SITE
             , A.ITEM_ID                                AS ITEM_ID
             , A.EXFACTORY_DATE                         AS YYYYMMDD
             , A.TRANSPORT_MODE                         AS TRANSPORT_MODE
             , A.INCOTERMS                              AS INCOTERMS
             , A.ETA_DATE                               AS ETA_DATE
             , A.ETD_DATE                               AS ETD_DATE
             , A.PROJECT_CODE                           AS PROJECT_CODE
             , CASE WHEN P_TITLE_YN = 'Y' THEN 0 ELSE SUM(A.EXFACTORY_QTY) END   AS QTY
          FROM SCM_DNM_EXFACTORY_RESULT A
             , SCP_MST_FINAL_ITEM B
             , SCM_MST_SITE C
             , SCM_ADM_LOOKUP_MASTER_DETAIL D
         WHERE B.ITEM_ID         = A.ITEM_ID            /* SCP 대상 ITEM만 */
           AND B.DIVISION_ID     = A.DIVISION_ID
           AND C.SCM_SITE_ID     = A.FROM_SCM_SITE_ID
           AND C.DIVISION_ID     = A.DIVISION_ID
           /* SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE */
           AND D.LOOKUP_TYPE(+)  = 'SHIP_RESULT_TO_SITE_MAPPING'
           AND D.SEGMENT1(+)     = A.DIVISION_ID
           AND D.SEGMENT2(+)     = A.SOLDTO_CODE
           AND D.SEGMENT3(+)     = A.SHIPTO_CODE
           /* 사외 창고 제외 LOOKUP 관리 */
           AND NOT EXISTS (SELECT 1
                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL IA
                            WHERE IA.SEGMENT1    = A.STORAGE_ID
                              AND IA.LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
                              AND IA.VALID_YN    = 'Y')
           /* ERP오더타입 제외 LOOKUP 관리 */
           AND NOT EXISTS (SELECT 1
                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                            WHERE XA.SEGMENT1    = A.ORDER_TYPE_CODE
                              AND XA.LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_ERP_ORDER_TYPE'
                              AND XA.VALID_YN    = 'Y')
           AND C.OSP_YN          = 'N'
           AND NVL(A.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')     /* D90: DO삭제 , D10:DO생성 */
           AND NVL(A.CONFIRM_ID, '-') NOT LIKE 'C%'
           AND A.STORAGE_ID      NOT IN ('6000', '799A')                /* 상품창고제외 */
           AND A.EXFACTORY_DATE  BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
           /* 추가 */
           AND A.EXFACTORY_DATE  >= P_FROM_RESULT
           AND A.EXFACTORY_DATE  <  P_TO_RESULT
         GROUP BY A.DIVISION_ID
                , A.ORDER_NO
                , A.FROM_SCM_SITE_ID
                , NVL(D.SEGMENT4, A.TO_SCM_SITE_ID)
                , A.ITEM_ID
                , A.EXFACTORY_DATE
                , A.TRANSPORT_MODE
                , A.INCOTERMS
                , A.ETA_DATE
                , A.ETD_DATE
                , A.PROJECT_CODE
        /* 2022.06.09 */
        UNION ALL
        SELECT A.DIVISION_ID                            AS DIVISION_ID
             , '-'                                      AS CONFIRM_ID
             , '-'                                      AS ERP_SO_NO
             , A.SCM_SITE_ID                            AS FROM_SITE
             , A.TO_SITE                                AS TO_SITE
             , A.ITEM_ID                                AS ITEM_ID
             , A.SHIP_DATE                              AS YYYYMMDD
             , NVL(NULLIF(RTRIM(D.TRANSPORT_MODE),''), '/')               AS TRANSPORT_MODE
             , NVL(NULLIF(RTRIM(D.INCOTERMS),''), '/')                    AS INCOTERMS
             , D.ETA_DATE                               AS ETA_DATE
             , D.ETD_DATE                               AS ETD_DATE
             , NVL(NULLIF(RTRIM(D.PROJECT_CODE),''), '/')                 AS PROJECT_CODE
             , SUM(A.SHIP_QTY)                          AS QTY
          FROM SCM_DNM_SCS_SHIP_RESULT A
             , SCP_MST_FINAL_ITEM B
             , SCM_MST_SITE C
             , SSP_ANL_SHIP_CONFIRM D
         WHERE B.ITEM_ID         = A.ITEM_ID            /* SCP 대상 ITEM만 */
           AND B.DIVISION_ID     = A.DIVISION_ID
           AND C.SCM_SITE_ID     = A.SCM_SITE_ID
           AND C.DIVISION_ID     = A.DIVISION_ID
           /* JOIN SSP_ANL_SHIP_CONFIRM C  --2022-08-19 */
           AND A.DIVISION_ID     = D.DIVISION_ID(+)
           AND A.PACK_MODEL_CODE = D.ITEM_ID(+)
           AND A.SCM_SITE_ID     = D.FROM_SITE(+)
           AND A.TO_SITE         = D.TO_SITE(+)
           AND A.ATTRIBUTE5      = D.CONFIRM_ID(+)
           AND C.OSP_YN          = 'Y'
           AND A.ATTRIBUTE5      NOT LIKE 'C%'          /* confirm_id */
           AND A.SHIP_DATE       >= P_FROM_RESULT
           AND A.SHIP_DATE       <  P_TO_RESULT
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.TO_SITE
                , A.ITEM_ID
                , A.SHIP_DATE
                , D.TRANSPORT_MODE
                , D.INCOTERMS
                , D.PROJECT_CODE
                , D.ETA_DATE
                , D.ETD_DATE;

        /* ------------------------------------------------------------------------------------------
           PLAN_SSP : SSP출하계획 ( confirm된 계획)
           20220106 PJ20209643 소형 OSP Pack Item 처리
           ------------------------------------------------------------------------------------------ */
        INSERT INTO GT_SCP0009_PLAN_SSP
        (
            DIVISION_ID
          , ERP_SO_NO
          , CONFIRM_ID
          , ITEM_ID
          , FROM_SITE
          , TO_SITE
          , END_CUSTOMER
          , QTY
          , YYYYMMDD
          , TRANSPORT_MODE
          , INCOTERMS
          , ETD_DATE
          , ETA_DATE
          , SHIP_TYPE
        )
        SELECT A.DIVISION_ID                            AS DIVISION_ID
             , A.ERP_SO_NO                              AS ERP_SO_NO
             , A.CONFIRM_ID                             AS CONFIRM_ID
             /* 20220106 PJ20209643 소형 OSP Pack Item 처리
                , c.item_id */
             , CASE WHEN D.PACKER_PLAN_ITEM_ID IS NULL
                      OR D.PACKER_PLAN_ITEM_ID = '-'
                    THEN A.ITEM_ID
                    ELSE D.PACKER_PLAN_ITEM_ID
                    END                                 AS ITEM_ID
             , A.FROM_SITE                              AS FROM_SITE
             , A.TO_SITE                                AS TO_SITE
             , CASE WHEN A.DIVISION_ID = '4O' THEN NVL(NULLIF(RTRIM(B.PROJECT_CODE),''), '/')
                    ELSE NVL(NULLIF(RTRIM(C.END_CUSTOMER),''), '/')
                    END                                 AS END_CUSTOMER
             , A.QTY                                    AS QTY
             , A.YYYYMMDD                               AS YYYYMMDD
             , A.TRANSPORT_MODE                         AS TRANSPORT_MODE
             , A.INCOTERMS                              AS INCOTERMS
             , A.ETD_DATE                               AS ETD_DATE
             , A.ETA_DATE                               AS ETA_DATE
             , NULL                                     AS SHIP_TYPE
          FROM SSP_ANL_SHIP_CONFIRM A
             , SCM_MST_SITE_ITEM B
             , SCM_MST_SITE C
             , SCP_MST_FINAL_ITEM D
         WHERE B.DIVISION_ID(+)  = A.DIVISION_ID
           AND B.ITEM_ID(+)      = A.ITEM_ID
           AND B.SCM_SITE_ID(+)  = A.TO_SITE
           AND B.PROJECT_CODE(+) = A.PROJECT_CODE
           AND C.DIVISION_ID(+)  = A.DIVISION_ID
           AND C.SCM_SITE_ID(+)  = A.TO_SITE
           /* 20220106 PJ20209643 소형 OSP Pack Item 처리 */
           AND A.DIVISION_ID     = D.DIVISION_ID(+)     /* 2018.06.29 */
           AND A.ITEM_ID         = D.ITEM_ID(+)
           AND D.DIVISION_ID(+)  = '40'
           AND A.CHANGE_TYPE     = 'C'
           /* AND   QTY > 0  -- 2022-08-11 */
           AND A.BIZ_TYPE        = P_BIZ_TYPE
           /* AS-IS 상 본문(SCP0009_GET_SHIPMENT_PLAN_FG)에만 사업부 조건이 있고
              타이틀(SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL)에는 없다. 원문대로 유지한다. */
           AND (P_TITLE_YN = 'Y' OR A.DIVISION_ID = P_DIVISION_ID);
           /* AND C.YYYYMMDD >=	@V_FROM_RESULT
              AND C.YYYYMMDD <	@V_TO_RESULT */

    END P_LOAD_RESULT_SOURCE;


    /* ==============================================================================================
       [내부] 최종 조회문의 바깥 SELECT 조립 (본체 · TITLE_PARAL 공통)
       AS-IS : SET @mEXEC = @mEXEC + '...' 구간
       ============================================================================================== */
    PROCEDURE P_MAKE_OUTER_SELECT
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_TEAM_ID               IN  VARCHAR2,
        P_EE_YN                 IN  VARCHAR2,
        P_SOURCE_TABLE          IN  VARCHAR2,
        P_QRY_SUM               IN  CLOB,
        O_SQL                   OUT CLOB
    )
    IS
        V_DIV_ENERGY    VARCHAR2(30 CHAR) := '82';
    BEGIN

        DBMS_LOB.CREATETEMPORARY(O_SQL, TRUE);

        /* 20230411 ENERGY (UI 셀병합 위해서 문자열 AND Null일 경우 공백으로 처리 필요) */
        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            'SELECT A.*' || CHR(10)
         || '     , NVL(B.PROJECT_NAME, ''-'')      AS PROJECT_NAME' || CHR(10)
         || '     , NVL(EG.ENERGY, '' '')           AS ENERGY' || CHR(10)));

        /* @p_division_id NOT IN ('EE','EE_UC')  --div_commonization */
        IF P_EE_YN = 'N' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '     , NVL(CASE WHEN A.DIVISION_ID <> ''40'' AND A.DIVISION_ID <> ''82'' THEN B.PROJECT_OWNER ELSE F.USER_NAME_EN END, ''-'') AS PROJECT_OWNER' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '     , NVL(CASE WHEN A.ORIGIN_TO_DIVISION_ID <> ''40'' AND A.DIVISION_ID <> ''82'' THEN B.PROJECT_OWNER ELSE F.USER_NAME_EN END, ''-'') AS PROJECT_OWNER' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
--          '     , CASE WHEN C.ITEM_TYPE IS NULL THEN ''-'' ELSE FN_GET_LOOKUP_CODE_DESC(''ITEM_TYPE_CODE'', C.ITEM_TYPE) END AS ITEM_TYPE' || CHR(10)
            '     , CASE WHEN C.ITEM_TYPE IS NULL THEN ''-'' ELSE (SELECT FN_GET_LOOKUP_CODE_DESC(''ITEM_TYPE_CODE'', C.ITEM_TYPE) FROM DUAL) END AS ITEM_TYPE' || CHR(10)   /* AJS 20261007 속도 */
         || '     , NVL(G.DEPT_NAME_KO, ''-'')      AS DEPT_NAME_KO' || CHR(10)));

        /* add start jahn1501 */
        IF P_DIVISION_ID = '40' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '     , NVL(C.CELL_TYPE, ''-'')                 AS PRODUCT_GROUP' || CHR(10)
         || '     , NVL(E.ATTRIBUTE5, ''-'')                AS CELL_MODEL' || CHR(10)
         || '     , CAST(NVL(K.CELL_PACK_COUNT, 0) AS NUMBER(10)) AS CELL_PACK_COUNT' || CHR(10)
         || '     , NVL(E.APPLICATION, ''-'')               AS APPLICATION' || CHR(10)
         || '     , NVL(K.MIN_CAPACITY, ''-'')              AS MIN_CAPACITY' || CHR(10)
         || '     , NVL(D.SOLDTO_CUSTOMER, ''-'')           AS SOLDTO_CUSTOMER' || CHR(10)
         || '     , NVL(K.FORECAST_INFO_SPEC, ''-'')        AS MODEL_SPEC' || CHR(10)
         || '     , NVL(K.FORECAST_INFOR_VERSION, ''-'')    AS MODEL_VERSION' || CHR(10)
         || '     , NVL(K.FORECAST_INFO_ALL, ''-'')         AS SPEC_VERSION' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '     , ''-''  AS PRODUCT_GROUP' || CHR(10)
         || '     , ''-''  AS CELL_MODEL' || CHR(10)
         || '     , 0      AS CELL_PACK_COUNT' || CHR(10)
         || '     , ''-''  AS APPLICATION' || CHR(10)
         || '     , ''-''  AS MIN_CAPACITY' || CHR(10)
         || '     , ''-''  AS SOLDTO_CUSTOMER' || CHR(10)
         || '     , ''-''  AS MODEL_SPEC' || CHR(10)
         || '     , ''-''  AS MODEL_VERSION' || CHR(10)
         || '     , ''-''  AS SPEC_VERSION' || CHR(10)));
        END IF;
        /* end */

        /* ---------- 안쪽 SELECT ---------- */
        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
--          '  FROM (SELECT IA.KEY_IDX' || CHR(10)
            '  FROM (SELECT /*+ NO_USE_HASH_AGGREGATION */ IA.KEY_IDX' || CHR(10)   /* AJS 20261007 속도 */
         || '             , IA.DIVISION_ID' || CHR(10)
         || '             , IA.BIZ_TYPE' || CHR(10)
--       || '             , FN_GET_LOOKUP_CODE_DESC(''BIZ_TYPE'', IA.BIZ_TYPE) AS BIZ_TYPE_NAME' || CHR(10)
         || '             , (SELECT FN_GET_LOOKUP_CODE_DESC(''BIZ_TYPE'', IA.BIZ_TYPE) FROM DUAL) AS BIZ_TYPE_NAME' || CHR(10)   /* AJS 20261007 속도 */
         || '             , IA.PROJECT_CODE' || CHR(10)
         || '             , IA.ITEM_ID' || CHR(10)
         || '             , (SELECT NVL(XA.NICK_NAME, ''-'') FROM SCM_MST_ITEM_SN XA WHERE XA.ITEM_ID = IA.ITEM_ID AND ROWNUM = 1) AS NICK_NAME' || CHR(10)
         || '             , (SELECT NVL(SA.SCP_EXTRA_SPEC, ''-'') FROM SCM_MST_ITEM_SN SA WHERE SA.DIVISION_ID = IA.DIVISION_ID AND SA.ITEM_ID = IA.ITEM_ID AND ROWNUM = 1) AS EXTRA_SPEC' || CHR(10)
         || '             , IA.TO_SITE' || CHR(10)
         || '             , IA.TO_SITE2' || CHR(10)));

        IF P_EE_YN = 'N' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '             , (SELECT SITE_DESCRIPTION FROM SCM_MST_SITE WHERE SCM_SITE_ID = IA.TO_SITE2 AND ROWNUM = 1) AS TO_SITE_NAME' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '             , IA.TO_SITE AS TO_SITE_NAME' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '             , IA.INCOTERMS' || CHR(10)
         || '             , IA.FROM_SITE' || CHR(10)
         || '             , NVL((SELECT SITE_DESCRIPTION FROM SCM_MST_SITE WHERE SCM_SITE_ID = IA.FROM_SITE AND ROWNUM = 1), ''/'') AS FROM_SITE_NAME' || CHR(10)
         || '             , IA.BOD_ID' || CHR(10)
         || '             , IA.BOD_FROM_YYYYMMDD' || CHR(10)     /* BOD 2단계 */
         || '             , IA.BOD_TO_YYYYMMDD' || CHR(10)       /* BOD 2단계 */
         || '             , NVL(IA.TRANSPORT_MODE, ''/'')  AS TRANSPORT_MODE' || CHR(10)
         || '             , NVL(IA.LT_DAY, 0)              AS LT_DAY' || CHR(10)
         || '             , IA.ORIGIN_FROM_DIVISION_ID' || CHR(10)
         || '             , IA.ORIGIN_TO_DIVISION_ID' || CHR(10)
         || '             , IA.ELECTRODE_TYPE' || CHR(10)
--       || '             , CAST(ROUND(FN_GET_SCP_ANL_BOH_QTY(IA.DIVISION_ID, IA.PLAN_START_YYYYMMDD, IA.PLAN_TYPE, TO_NUMBER(IA.SEQ), IA.TO_SITE, IA.ITEM_ID, IA.FROM_YYYYMMDD), 1) AS NUMBER(10)) AS BOH' || CHR(10)));
         || '             , CAST(ROUND((SELECT FN_GET_SCP_ANL_BOH_QTY(IA.DIVISION_ID, IA.PLAN_START_YYYYMMDD, IA.PLAN_TYPE, TO_NUMBER(IA.SEQ), IA.TO_SITE, IA.ITEM_ID, IA.FROM_YYYYMMDD) FROM DUAL), 1) AS NUMBER(10)) AS BOH' || CHR(10)));   /* AJS 20261007 속도 */

        /* SHIP FROZEN - AS-IS 서브쿼리의 DIVISION_ID 조건은 서브쿼리 테이블 컬럼끼리 비교되어
           사업부 조건이 걸리지 않는다. 원문 그대로 옮긴다. */
        IF P_EE_YN = 'N' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '             , TO_CHAR(TO_DATE(''' || P_PLAN_START_YYYYMMDD || ''', ''YYYYMMDD'') + (SELECT NVL(SHIP_FROZEN, 0) FROM SCM_MST_SITE WHERE DIVISION_ID = DIVISION_ID AND SCM_SITE_ID = IA.FROM_SITE), ''YYYY-MM-DD'') AS SHIP_FROZEN' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '             , TO_CHAR(TO_DATE(''' || P_PLAN_START_YYYYMMDD || ''', ''YYYYMMDD'') + (SELECT NVL(SHIP_FROZEN, 0) FROM SCM_MST_SITE WHERE DIVISION_ID = IA.ORIGIN_FROM_DIVISION_ID AND SCM_SITE_ID = IA.FROM_SITE), ''YYYY-MM-DD'') AS SHIP_FROZEN' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '             , IA.MEASURE' || CHR(10)
         || '             , IA.MEASURE_ORDER_NO' || CHR(10)
         || '             , IA.MEASURE_LABEL' || CHR(10)
         || '             , IA.PLAN_START_YYYYMMDD' || CHR(10)
         || '             , IA.PLAN_TYPE' || CHR(10)
         || '             , IA.SEQ' || CHR(10)
         || '             , IA.FROM_YYYYMMDD' || CHR(10)
         || '             , IA.TO_YYYYMMDD' || CHR(10)));

        DBMS_LOB.APPEND(O_SQL, P_QRY_SUM);

        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '          FROM ' || P_SOURCE_TABLE || ' IA' || CHR(10)
         /* BOD 2단계 개발 : FROM, TO 추가 */
         || '         GROUP BY IA.KEY_IDX' || CHR(10)
         || '                , IA.DIVISION_ID' || CHR(10)
         || '                , IA.BIZ_TYPE' || CHR(10)
         || '                , IA.PROJECT_CODE' || CHR(10)
         || '                , IA.ITEM_ID' || CHR(10)
         || '                , IA.TO_SITE' || CHR(10)
         || '                , IA.TO_SITE2' || CHR(10)
         || '                , IA.INCOTERMS' || CHR(10)
         || '                , IA.FROM_SITE' || CHR(10)
         || '                , IA.BOD_ID' || CHR(10)
         || '                , IA.TRANSPORT_MODE' || CHR(10)
         || '                , IA.LT_DAY' || CHR(10)
         || '                , IA.ORIGIN_FROM_DIVISION_ID' || CHR(10)
         || '                , IA.ORIGIN_TO_DIVISION_ID' || CHR(10)
         || '                , IA.ELECTRODE_TYPE' || CHR(10)
         || '                , IA.MEASURE' || CHR(10)
         || '                , IA.MEASURE_ORDER_NO' || CHR(10)
         || '                , IA.MEASURE_LABEL' || CHR(10)
         || '                , IA.PLAN_START_YYYYMMDD' || CHR(10)
         || '                , IA.PLAN_TYPE' || CHR(10)
         || '                , IA.SEQ' || CHR(10)
         || '                , IA.FROM_YYYYMMDD' || CHR(10)
         || '                , IA.TO_YYYYMMDD' || CHR(10)
         || '                , IA.BOD_FROM_YYYYMMDD' || CHR(10)
         || '                , IA.BOD_TO_YYYYMMDD' || CHR(10)
         || '       ) A' || CHR(10)));

        /* ---------- 바깥 조인 ---------- */
        /* 20230411 ENERGY / only div = 82 ess */
        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
--          '     , (SELECT ITEM_ID' || CHR(10)
--       || '             , TO_CHAR(CAST(TO_NUMBER(MAX(ENERGE) DEFAULT NULL ON CONVERSION ERROR) AS NUMBER(13,4))) AS ENERGY' || CHR(10)
--       || '          FROM SCM_ITEM_M_SN' || CHR(10)
--       || '         WHERE ENERGE IS NOT NULL' || CHR(10)
--       || '         GROUP BY ITEM_ID) EG' || CHR(10)
            '     , (SELECT /*+ LEADING(EG2 EG1) USE_NL(EG1) INDEX(EG1 PK_SCM_ITEM_M) */ EG1.ITEM_ID' || CHR(10)   /* AJS 20261007 속도 */
         || '             , TO_CHAR(CAST(TO_NUMBER(MAX(EG1.ENERGE) DEFAULT NULL ON CONVERSION ERROR) AS NUMBER(13,4))) AS ENERGY' || CHR(10)   /* AJS 20261007 속도 */
         || '          FROM (SELECT /*+ NO_MERGE */ DISTINCT EG3.ITEM_ID FROM ' || P_SOURCE_TABLE || ' EG3) EG2' || CHR(10)   /* AJS 20261007 속도 */
         || '             , SCM_ITEM_M_SN EG1' || CHR(10)   /* AJS 20261007 속도 */
         || '         WHERE EG1.ITEM_ID = EG2.ITEM_ID' || CHR(10)   /* AJS 20261007 속도 */
         || '           AND EG1.ENERGE IS NOT NULL' || CHR(10)   /* AJS 20261007 속도 */
         || '         GROUP BY EG1.ITEM_ID) EG' || CHR(10)   /* AJS 20261007 속도 */
         || '     , (SELECT DIVISION_ID' || CHR(10)
         || '             , PROJECT_CODE' || CHR(10)
         || '             , PROJECT_NAME' || CHR(10)
         || '             , PROJECT_OWNER' || CHR(10)
         || '             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE ORDER BY PROJECT_VER_SEQ ASC) AS NUMS' || CHR(10)
         || '          FROM SCM_MST_PROJECT) B' || CHR(10)
--       || '     , (SELECT C1.DIVISION_ID' || CHR(10)
         || '     , (SELECT /*+ LEADING(C3 C1) USE_NL(C1) INDEX(C1 PK_SCM_ITEM_M) */ C1.DIVISION_ID' || CHR(10)   /* AJS 20261007 속도 */
         || '             , C1.ITEM_ID' || CHR(10)
         || '             , C1.ITEM_NAME' || CHR(10)
         || '             , C1.NICK_NAME' || CHR(10)
         || '             , C1.ITEM_TYPE' || CHR(10)
         || '             , C2.SEGMENT2 AS CELL_TYPE' || CHR(10)
         || '             , ROW_NUMBER() OVER (PARTITION BY C1.DIVISION_ID, C1.ITEM_ID ORDER BY CASE C1.ITEM_TYPE WHEN ''P'' THEN 999 WHEN ''H'' THEN 888 WHEN ''R'' THEN 777 WHEN ''Q'' THEN 666 ELSE 0 END DESC) AS NUMS' || CHR(10)
--       || '          FROM SCM_MST_ITEM_SN C1' || CHR(10)
         || '          FROM (SELECT DISTINCT C4.ITEM_ID FROM ' || P_SOURCE_TABLE || ' C4) C3' || CHR(10)   /* AJS 20261007 속도 */
         || '             , SCM_MST_ITEM_SN C1' || CHR(10)   /* AJS 20261007 속도 */
         || '             , SCM_ADM_LOOKUP_MASTER_DETAIL C2' || CHR(10)
--       || '         WHERE C1.CELL_TYPE = C2.SEGMENT1(+)' || CHR(10)
         || '         WHERE C1.ITEM_ID = C3.ITEM_ID' || CHR(10)   /* AJS 20261007 속도 */
         || '           AND C1.CELL_TYPE = C2.SEGMENT1(+)' || CHR(10)   /* AJS 20261007 속도 */
         || '           AND C2.LOOKUP_TYPE(+) = ''CELL_TYPE'') C' || CHR(10)));

        /* add start jahn1501 */
        IF P_DIVISION_ID = '40' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '     , (SELECT DIVISION_ID' || CHR(10)
         || '             , ITEM_ID' || CHR(10)
         || '             , FORECAST_INFO_CELL_MODEL AS CELL_MODEL' || CHR(10)
         || '             , FORECAST_INFO_CELL_PACK_COUNT AS CELL_PACK_COUNT' || CHR(10)
         || '             , MIN_CAPACITY' || CHR(10)
         || '             , FORECAST_INFO_SPEC' || CHR(10)
         || '             , FORECAST_INFOR_VERSION' || CHR(10)
         || '             , FORECAST_INFO_SPEC || FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL' || CHR(10)
         || '          FROM DM_MST_ITEM_SINGLE_V) K' || CHR(10)));
        END IF;
        /* end */

        /* DEPT NAME START */
        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '     , SCM_MST_SITE D' || CHR(10)
         || '     , SCM_MST_SITE_ITEM E' || CHR(10)
         || '     , SCM_MST_SSO_USER_INFO F' || CHR(10)
         || '     , SCM_MST_SSO_DEPT_INFO G' || CHR(10)
         /* AS-IS : LEFT OUTER JOIN W_ENERGY EG ON a.ITEM_ID = EG.ITEM_ID AND A.DIVISION_ID = '82'
            사업부 조건이 아우터 조인의 ON 절에 있으므로 조인키 쪽에서 판정한다. */
         || ' WHERE CASE WHEN A.DIVISION_ID = ''' || V_DIV_ENERGY || ''' THEN A.ITEM_ID ELSE NULL END = EG.ITEM_ID(+)' || CHR(10)
         || '   AND A.PROJECT_CODE = B.PROJECT_CODE(+)' || CHR(10)));

        IF P_EE_YN = 'N' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB('   AND A.DIVISION_ID = B.DIVISION_ID(+)' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(O_SQL, TO_CLOB('   AND A.ORIGIN_TO_DIVISION_ID = B.DIVISION_ID(+)' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '   AND B.NUMS(+) = 1' || CHR(10)
         || '   AND A.ITEM_ID = C.ITEM_ID(+)' || CHR(10)));

        IF P_EE_YN = 'N' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB('   AND A.DIVISION_ID = C.DIVISION_ID(+)' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(O_SQL, TO_CLOB('   AND A.ORIGIN_TO_DIVISION_ID = C.DIVISION_ID(+)' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(O_SQL, TO_CLOB('   AND C.NUMS(+) = 1' || CHR(10)));

        IF P_DIVISION_ID = '40' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '   AND A.ITEM_ID     = K.ITEM_ID(+)' || CHR(10)
         || '   AND A.DIVISION_ID = K.DIVISION_ID(+)' || CHR(10)));
        END IF;

        IF P_EE_YN = 'N' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '   AND D.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
         || '   AND D.SCM_SITE_ID(+) = A.TO_SITE' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '   AND D.DIVISION_ID(+) = A.ORIGIN_TO_DIVISION_ID' || CHR(10)
         || '   AND D.SCM_SITE_ID(+) = A.TO_SITE2' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(O_SQL, TO_CLOB('   AND D.VALID_YN(+) = ''Y''' || CHR(10)));

        IF P_EE_YN = 'N' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '   AND E.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
         || '   AND E.SCM_SITE_ID(+) = A.TO_SITE' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '   AND E.DIVISION_ID(+) = A.ORIGIN_TO_DIVISION_ID' || CHR(10)
         || '   AND E.SCM_SITE_ID(+) = A.TO_SITE2' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            '   AND E.PROJECT_CODE(+) = A.PROJECT_CODE' || CHR(10)
         || '   AND E.ITEM_ID(+)      = A.ITEM_ID' || CHR(10)
         || '   AND E.VALID_YN(+)     = ''Y''' || CHR(10)
         || '   AND SUBSTR(E.OWNER, 1, CASE WHEN INSTR(E.OWNER, '','') = 0 THEN LENGTH(E.OWNER) ELSE INSTR(E.OWNER, '','') - 1 END) = F.USER_ID(+)' || CHR(10)
         /* 20241113 E20241105-000454 : 소형외 사업부도 소형과 동일하게 Site 의 부서 대신 Site Itme의 Owner 부서 기준으로 표시 */
         || '   AND F.DEPT_ID = G.DEPT_ID(+)' || CHR(10)));

        /* AS-IS : IF NOT(@p_team_id IS NULL OR @p_team_id = '') 뒤에 WHERE 1=1 과 조건 문자열을 덧붙인다.
           FN_SCM_GET_WHERE_SQL 은 ' AND <컬럼> IN (...)' 형태를 반환하므로 그대로 잇는다. */
        -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
        -- IF P_TEAM_ID IS NOT NULL THEN
        IF P_TEAM_ID IS NOT NULL AND UPPER(TRIM(P_TEAM_ID)) <> 'ALL' THEN
        -- 2026.10.06 AJS 조회조건 ALL 처리 (END)
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(FN_SCM_GET_WHERE_SQL('G.DEPT_ID', 'IN', P_TEAM_ID) || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(O_SQL, TO_CLOB(
            ' ORDER BY A.DIVISION_ID' || CHR(10)
         || '        , A.BIZ_TYPE' || CHR(10)
         || '        , A.ITEM_ID' || CHR(10)
         || '        , A.TO_SITE' || CHR(10)
         || '        , A.PROJECT_CODE' || CHR(10)
         || '        , A.INCOTERMS' || CHR(10)
         || '        , A.FROM_SITE' || CHR(10)
         || '        , A.BOD_ID' || CHR(10)
         || '        , A.MEASURE_ORDER_NO' || CHR(10)));
        /* AS-IS 의 OPTION (HASH GROUP) 은 MSSQL 전용 힌트라 옮기지 않는다. */

    END P_MAKE_OUTER_SELECT;


    /* ==============================================================================================
       SCP0009_GET_SHIPMENT_PLAN_FG
       ============================================================================================== */
    PROCEDURE P_SCP0009_GET_SHIPMENT_PLAN_FG
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_BIZ_TYPE              IN  VARCHAR2,
        P_PROJECT_CODE          IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_ELECTYPE              IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_FROMSITE              IN  VARCHAR2,
        P_TEAM_ID               IN  VARCHAR2,
        P_TOSITE                IN  VARCHAR2,
        P_BUCKET                IN  VARCHAR2,
        P_TO_PERIOD             IN  VARCHAR2,
        P_CHK_ALL               IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0009',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'Shipment Plan FG',
        P_USER_ID               IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0009_GET_SHIPMENT_PLAN_FG
     * Description  : Shipment Plan 조회
     * Program History
     *===================================================================================================
     * Date         In Charge                 Description
     *===================================================================================================
     * 2018/01/29   byunghunjung              Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/05/25   KYH                       FIX 조회 추가
     * 2018/07/09   KYH                       신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
     * 2021.07.22   lwy                       PJ20209643 - SCP_ANL_SHIPMENT_PLAN_FG / HIST_SCP_ANL_SHIPMENT_PLAN_FG 분리작업 / 계획구간 · 실적구간 조회 분리
     * 2021/10/05   khj79                     [PJ20209643] UI 속도 개선 (bucket 별 컬럼 설정 변경하여 조회되도록 수정 함)
     * 2021/11/24   khj79                     [PJ20209643] @p_chk_all 추가 ( 체크 시 bucket='daily' 조회)
     * 2022.06.09   LWY                       [PJ20209643] Packer의 경우(outsourcing :Y) 과거구간에 SCS 출하실적을 표시하도록 변경
     * 2022.06.28   jahn1501                  PJ20216994 - BOD L/T History 변경 (SCP_MST_BOD_N_V -> SCP_ANL_BOD_N_V_PLAN_H)
     * 2023.04.10   vadabi3                   PJ20230691R - E20230405-001043 [ESS영업관리팀] Shipment Plan FG창 Measure 추가 요청의 건 (DIV = 82 만 적용)
     * 2023.04.10   LWY                       PJ20230691R - DIVISION_ID 공통화 작업(div_commonization)
     * 2023.06.23   KJJ                       PJ20230691R - Like 검색기능
     * 2024.06.27   ksg                       E20240612-001030 Shipment plan FG 실적조회 시 confirm_id 참조하는 데이터 변경 (from_site, item_id →from_site only)
     * 2024.11.13   KSG                       E20241105-000454 Shipment plan FG 팀정보 기준 변경 요청
     * 2025.03.04   mrchois                   PJ20249548R - measure 세팅시 정렬한 순서가 화면에 보여지도록 수정 (E20250226-000749)
     * 2026.02-23   YMH						  20260223 YMH UI 조회 안되는 이슈로 긴급반영
     * 2026.09.11   [MSSQL -> Oracle 전환]
     * 2026.10.07   AJS                       조회 속도 개선 - 결과 조회의 BOH · 코드명 함수를 스칼라 하위질의 캐시로(정렬 집계) · 에너지 · 품목 하위질의를 결과 품목으로 한정 (결과 동일)
     */
        V_CNT_USR_MEASURE       PLS_INTEGER := 0;
        V_FROM_YYYYMMDD         VARCHAR2(8 CHAR);
        V_TO_YYYYMMDD           VARCHAR2(8 CHAR);
        V_FROM_RESULT           VARCHAR2(8 CHAR);
        V_TO_RESULT             VARCHAR2(8 CHAR);
        V_MIN_YYYYMMDD          VARCHAR2(8 CHAR);    /* 2021/07/21 */
        V_RSLT_FLAG             VARCHAR2(1 CHAR) := 'Y';   /* 2021/07/21 */
        V_DIV_ENERGY            VARCHAR2(30 CHAR) := '82';
        V_BUCKET                VARCHAR2(10 CHAR) := P_BUCKET;
        V_EE_YN                 VARCHAR2(1 CHAR);
        V_SHIP_PLAN_ORDER_NO    NUMBER;
        V_QRY_SUM               CLOB;
        V_SQL                   CLOB;
        V_PARA                  VARCHAR2(4000 CHAR);
    BEGIN

        /* AS-IS 의 @arr_project_code · @arr_item_id · @arr_electrode_type · @arr_fromsite · @arr_tosite
           5개는 값을 담기만 하고 어디에서도 쓰이지 않는다(죽은 코드). @v_data_cnt · @todayLimit 도 같다.
           옮기지 않는다. */

        V_PARA := 'P_FROM_YYYYMMDD=' || P_FROM_YYYYMMDD || ', P_TO_YYYYMMDD=' || P_TO_YYYYMMDD
               || ', P_DIVISION_ID=' || P_DIVISION_ID || ', P_BIZ_TYPE=' || P_BIZ_TYPE
               || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD || ', P_PLAN_TYPE=' || P_PLAN_TYPE
               || ', P_SEQ=' || P_SEQ || ', P_BUCKET=' || P_BUCKET || ', P_USER_ID=' || P_USER_ID;

        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0009_MEASURE;
        DELETE FROM GT_SCP0009_STD;
        DELETE FROM GT_SCP0009_BOD_PLAN_H;
        DELETE FROM GT_SCP0009_FG_VALUE;
        DELETE FROM GT_SCP0009_ADD_MEASURE;
        DELETE FROM GT_SCP0009_PLAN;
        DELETE FROM GT_SCP0009_ERP_C_EXIST;
        DELETE FROM GT_SCP0009_ERP_C_NON;
        DELETE FROM GT_SCP0009_PLAN_SSP;
        DELETE FROM GT_SCP0009_RSLT_TMP;
        DELETE FROM GT_SCP0009_RSLT;
        DELETE FROM GT_SCP0009_FNL_RSLT_PLAN;

        V_EE_YN := F_IS_EE_DIVISION(P_DIVISION_ID);

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        /* AS-IS 는 변수 초기값이 '' 이고 조회 행이 없으면 그대로 '' 로 남는다.
           Oracle 은 빈 문자가 NULL 이라 비교가 죽으므로 판정 자리에 NVL(x, ' ') 을 둔다. */
        SELECT MAX(BASIS_START_DATE)
          INTO V_FROM_YYYYMMDD
          FROM SCM_SYS_CALENDAR_M
         WHERE 1 = 1
           AND BASIS_YYYYMMDD = P_PLAN_START_YYYYMMDD;

        SELECT MAX(BASIS_START_DATE)
          INTO V_FROM_RESULT
          FROM SCM_SYS_CALENDAR_M
         WHERE 1 = 1
           AND BASIS_YYYYMMDD = P_FROM_YYYYMMDD;

        SELECT MAX(BASIS_START_DATE)
          INTO V_TO_RESULT
          FROM SCM_SYS_CALENDAR_M
         WHERE 1 = 1
           AND BASIS_YYYYMMDD = P_TO_YYYYMMDD;

        IF NVL(V_FROM_YYYYMMDD, ' ') > NVL(V_FROM_RESULT, ' ') THEN
            /* 실적 보여줌 */
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_TO_RESULT   := V_FROM_YYYYMMDD;
        ELSIF NVL(V_FROM_YYYYMMDD, ' ') <= NVL(V_FROM_RESULT, ' ') THEN
            /* 실적 없음 */
            V_RSLT_FLAG   := 'N';   /* 2021/07/21 // 계획만 조회 */
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_FROM_RESULT := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'),  6), 'YYYYMMDD');
            V_TO_RESULT   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
        ELSIF NVL(V_FROM_YYYYMMDD, ' ') > NVL(V_TO_RESULT, ' ') THEN
            V_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
            V_TO_YYYYMMDD   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
            V_FROM_RESULT   := P_FROM_YYYYMMDD;
            V_TO_RESULT     := P_TO_YYYYMMDD;
        ELSIF NVL(V_FROM_YYYYMMDD, ' ') = NVL(V_TO_RESULT, ' ') THEN
            V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
            V_FROM_RESULT := P_FROM_YYYYMMDD;
            V_TO_RESULT   := P_TO_YYYYMMDD;
        END IF;

        /* 2021.11.24 : 체크 시 bucket='daily' 조회 */
        IF P_CHK_ALL = 'Y' THEN
            V_BUCKET := 'DAILY';
        END IF;

        /********************************************************************************
        * 임시테이블만들기 - Header 부분
        ********************************************************************************/

        /* ##############################################################################
           MEASURE 정보 생성
           ############################################################################## */
        INSERT INTO GT_SCP0009_MEASURE
        (
            COLUMN_NAME
          , COLUMN_LABEL_NAME
          , MEASURE_ORDER_NO
        )
        SELECT A.COLUMN_NAME
             , A.COLUMN_LABEL_NAME
             , NVL(B.SORT_ORDER_NO, A.SORT_ORDER_NO)    AS MEASURE_ORDER_NO
          FROM SCM_MST_SHEET_MEASURE A
             , SCM_MST_TITLESET_USER B
         WHERE A.PROGRAM_ID    = B.PROGRAM_ID(+)
           AND A.SHEET_NAME    = B.SHEET_NAME(+)
           AND A.COLUMN_NAME   = B.COLUMN_NAME(+)
           AND B.PROGRAM_ID(+) = P_PROGRAM_ID
           AND B.SHEET_NAME(+) = P_SHEET_NAME
           AND B.USER_ID(+)    = P_USER_ID
           AND A.PROGRAM_ID    = P_PROGRAM_ID
           AND A.SHEET_NAME    = P_SHEET_NAME
           AND A.VALID_YN      = 'Y'
           AND (V_CNT_USR_MEASURE = 0 OR B.COLUMN_NAME IS NOT NULL);

        /* ##############################################################################
           기준 정보 생성 - 0 값 포함 조회 한다.
           ############################################################################## */
        /* 2023.01.02
           SELECT @v_min_yyyymmdd = MIN_YYYYMMDD FROM [dbo].[FN_GET_SCP_PLAN_MIN_DATE](...); */
        /* previous monday
           AS-IS : replace(convert(char(10), dateadd(d, datepart(dw, GETDATE()) * -1 - 5, GETDATE()), 120), '-', '')
           MSSQL 의 datepart(dw) 는 @@DATEFIRST=7(일요일이 1) 기준이라 TRUNC(SYSDATE,'IW') 와 다르다.
           일요일에 한 주가 어긋나므로(AS-IS 는 이번 주 월요일, ISO 는 지난주 월요일) 원문 식을 그대로 옮긴다.
           1900-01-07 은 일요일이므로 MOD(날짜-그날, 7)+1 이 MSSQL 의 datepart(dw) 와 같다. */
        V_MIN_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE) - (MOD(TRUNC(SYSDATE) - DATE '1900-01-07', 7) + 1) - 5, 'YYYYMMDD');

        /* 20260223 YMH UI 조회 안되는 이슈로 긴급반영 */
        INSERT INTO GT_SCP0009_BOD_PLAN_H
        (
            DIVISION_ID
          , PLAN_NAME
          , PLAN_TYPE
          , PLAN_SEQ
          , ORG_DIVISION_ID
          , BOD_ID
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , TRANSPORT_MODE
          , LT_TOTAL
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
        )
        SELECT DIVISION_ID
             , PLAN_NAME
             , PLAN_TYPE
             , PLAN_SEQ
             , ORG_DIVISION_ID
             , BOD_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , TRANSPORT_MODE
             , LT_TOTAL
             , FROM_YYYYMMDD
             , TO_YYYYMMDD
          FROM SCP_ANL_BOD_N_V_PLAN_H
         WHERE 1 = 1
           AND PLAN_NAME = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE = P_PLAN_TYPE
           AND PLAN_SEQ  = TO_NUMBER(P_SEQ);

        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SCP0009_BOD_PLAN_H', NO_INVALIDATE => FALSE);

        /* Dynamic Query 로 변경해 보았으나 속도 문제로 IF/ELSE 로 분기 */
        IF P_PLAN_START_YYYYMMDD >= V_MIN_YYYYMMDD THEN

            INSERT INTO GT_SCP0009_STD
            (
                DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , BOD_ID
              , MEASURE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , TRANSPORT_MODE
              , LT_DAY
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
            )
            SELECT DISTINCT
                   A.DIVISION_ID
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.BOD_ID
                 , A.MEASURE
                 , B.COLUMN_LABEL_NAME              AS MEASURE_LABEL
                 , B.MEASURE_ORDER_NO               AS MEASURE_ORDER_NO
                 , C.TRANSPORT_MODE
                 , C.LT_TOTAL                       AS LT_DAY
                 , NVL(NULLIF(RTRIM(A.ORIGIN_FROM_DIVISION_ID),''), '/')  AS ORIGIN_FROM_DIVISION_ID
                 , NVL(A.ORIGIN_TO_DIVISION_ID, '-')    AS ORIGIN_TO_DIVISION_ID
                 , NVL(NULLIF(RTRIM(A.ELECTRODE_TYPE),''), '/')           AS ELECTRODE_TYPE
                 , P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE                      AS PLAN_TYPE
                 , P_SEQ                            AS SEQ
              FROM (SELECT DISTINCT
                           IA.DIVISION_ID
                         , IA.BIZ_TYPE
                         , IA.PROJECT_CODE
                         , IA.ITEM_ID
                         , IA.TO_SITE
                         , IA.FROM_SITE
                         , IA.INCOTERMS
                         , IA.BOD_ID
                         , IA.MEASURE
                         , IA.ORIGIN_FROM_DIVISION_ID
                         , IA.ORIGIN_TO_DIVISION_ID
                         , IA.ELECTRODE_TYPE
                      FROM SCP_ANL_SHIPMENT_PLAN_FG IA
                     WHERE 1 = 1
                       /* BOD 2단계 개발 : FROM , TO 로 변경
                          AND A.YYYYMMDD = @p_plan_start_yyyymmdd */
                       AND IA.YYYYMMDD            >= V_FROM_YYYYMMDD
                       AND IA.YYYYMMDD            <= V_TO_YYYYMMDD
                       AND IA.DIVISION_ID          = P_DIVISION_ID
                       AND IA.BIZ_TYPE             = P_BIZ_TYPE
                       AND IA.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                       AND IA.PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
                       AND IA.PLAN_TYPE            = P_PLAN_TYPE
                       AND IA.SEQ                  = TO_NUMBER(P_SEQ)
                       -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
                       -- AND (P_PROJECT_CODE IS NULL OR IA.PROJECT_CODE   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_PROJECT_CODE, ','))))
                       -- AND (P_ITEM_ID      IS NULL OR IA.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
                       -- AND (P_FROMSITE     IS NULL OR IA.FROM_SITE      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
                       -- AND (P_TOSITE       IS NULL OR IA.TO_SITE        IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_TOSITE, ','))))
                       -- AND (P_ELECTYPE     IS NULL OR IA.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTYPE, ','))))
                       AND (P_PROJECT_CODE IS NULL OR UPPER(TRIM(P_PROJECT_CODE)) = 'ALL' OR IA.PROJECT_CODE   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_PROJECT_CODE, ','))))
                       AND (P_ITEM_ID      IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' OR IA.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
                       AND (P_FROMSITE     IS NULL OR UPPER(TRIM(P_FROMSITE)) = 'ALL' OR IA.FROM_SITE      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
                       AND (P_TOSITE       IS NULL OR UPPER(TRIM(P_TOSITE)) = 'ALL' OR IA.TO_SITE        IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_TOSITE, ','))))
                       AND (P_ELECTYPE     IS NULL OR UPPER(TRIM(P_ELECTYPE)) = 'ALL' OR IA.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTYPE, ','))))
                       -- 2026.10.06 AJS 조회조건 ALL 처리 (END)
                   ) A
                 , GT_SCP0009_MEASURE B
                 , GT_SCP0009_BOD_PLAN_H C
             WHERE A.MEASURE      = B.COLUMN_NAME
               /* BOD 2단계 개발 : VIEW 수정 */
               AND A.DIVISION_ID  = C.DIVISION_ID(+)
               AND A.BOD_ID       = C.BOD_ID(+)
               AND A.FROM_SITE    = C.FROM_SITE(+)
               AND C.PLAN_SEQ(+)  = TO_NUMBER(P_SEQ)
               AND C.PLAN_TYPE(+) = P_PLAN_TYPE
               AND C.PLAN_NAME(+) = P_PLAN_START_YYYYMMDD;

        ELSIF P_PLAN_START_YYYYMMDD < V_MIN_YYYYMMDD THEN

            INSERT INTO GT_SCP0009_STD
            (
                DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , BOD_ID
              , MEASURE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , TRANSPORT_MODE
              , LT_DAY
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
            )
            SELECT DISTINCT
                   A.DIVISION_ID
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.BOD_ID
                 , A.MEASURE
                 , B.COLUMN_LABEL_NAME              AS MEASURE_LABEL
                 , B.MEASURE_ORDER_NO               AS MEASURE_ORDER_NO
                 , C.TRANSPORT_MODE
                 , C.LT_TOTAL                       AS LT_DAY
                 , NVL(NULLIF(RTRIM(A.ORIGIN_FROM_DIVISION_ID),''), '/')  AS ORIGIN_FROM_DIVISION_ID
                 , NVL(A.ORIGIN_TO_DIVISION_ID, '-')    AS ORIGIN_TO_DIVISION_ID
                 , NVL(NULLIF(RTRIM(A.ELECTRODE_TYPE),''), '/')           AS ELECTRODE_TYPE
                 , P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE                      AS PLAN_TYPE
                 , P_SEQ                            AS SEQ
              FROM (SELECT DISTINCT
                           IA.DIVISION_ID
                         , IA.BIZ_TYPE
                         , IA.PROJECT_CODE
                         , IA.ITEM_ID
                         , IA.TO_SITE
                         , IA.FROM_SITE
                         , IA.INCOTERMS
                         , IA.BOD_ID
                         , IA.MEASURE
                         , IA.ORIGIN_FROM_DIVISION_ID
                         , IA.ORIGIN_TO_DIVISION_ID
                         , IA.ELECTRODE_TYPE
                      FROM HIST_SCP_ANL_SHIPMENT_PLAN_FG IA
                     WHERE 1 = 1
                       AND IA.YYYYMMDD             = P_PLAN_START_YYYYMMDD
                       AND IA.DIVISION_ID          = P_DIVISION_ID
                       AND IA.BIZ_TYPE             = P_BIZ_TYPE
                       AND IA.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                       AND IA.PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
                       AND IA.PLAN_TYPE            = P_PLAN_TYPE
                       AND IA.SEQ                  = TO_NUMBER(P_SEQ)
                       -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
                       -- AND (P_PROJECT_CODE IS NULL OR IA.PROJECT_CODE   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_PROJECT_CODE, ','))))
                       -- AND (P_ITEM_ID      IS NULL OR IA.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
                       -- AND (P_FROMSITE     IS NULL OR IA.FROM_SITE      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
                       -- AND (P_TOSITE       IS NULL OR IA.TO_SITE        IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_TOSITE, ','))))
                       -- AND (P_ELECTYPE     IS NULL OR IA.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTYPE, ','))))
                       AND (P_PROJECT_CODE IS NULL OR UPPER(TRIM(P_PROJECT_CODE)) = 'ALL' OR IA.PROJECT_CODE   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_PROJECT_CODE, ','))))
                       AND (P_ITEM_ID      IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' OR IA.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
                       AND (P_FROMSITE     IS NULL OR UPPER(TRIM(P_FROMSITE)) = 'ALL' OR IA.FROM_SITE      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
                       AND (P_TOSITE       IS NULL OR UPPER(TRIM(P_TOSITE)) = 'ALL' OR IA.TO_SITE        IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_TOSITE, ','))))
                       AND (P_ELECTYPE     IS NULL OR UPPER(TRIM(P_ELECTYPE)) = 'ALL' OR IA.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTYPE, ','))))
                       -- 2026.10.06 AJS 조회조건 ALL 처리 (END)
                   ) A
                 , GT_SCP0009_MEASURE B
                 , GT_SCP0009_BOD_PLAN_H C
             WHERE A.MEASURE      = B.COLUMN_NAME
               AND A.DIVISION_ID  = C.DIVISION_ID(+)
               AND A.BOD_ID       = C.BOD_ID(+)
               AND A.FROM_SITE    = C.FROM_SITE(+)
               AND C.PLAN_SEQ(+)  = TO_NUMBER(P_SEQ)
               AND C.PLAN_TYPE(+) = P_PLAN_TYPE
               AND C.PLAN_NAME(+) = P_PLAN_START_YYYYMMDD;

        END IF;

        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SCP0009_STD', NO_INVALIDATE => FALSE);

        /* ##############################################################################
           기준 정보를 기준으로 계획 구간 정보 조회 - 0 값 포함하지 않는다.
           ############################################################################## */
        IF P_PLAN_START_YYYYMMDD >= V_MIN_YYYYMMDD THEN

            INSERT INTO GT_SCP0009_FG_VALUE
            (
                YYYYMMDD
              , DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , BOD_ID
              , MEASURE
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , TRANSPORT_MODE
              , ITEM_VALUE
            )
            SELECT B.YYYYMMDD
                 , A.DIVISION_ID
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.BOD_ID
                 , A.MEASURE
                 , NVL(NULLIF(RTRIM(B.ORIGIN_FROM_DIVISION_ID),''), '/')  AS ORIGIN_FROM_DIVISION_ID
                 , NVL(B.ORIGIN_TO_DIVISION_ID, '-')    AS ORIGIN_TO_DIVISION_ID
                 , NVL(NULLIF(RTRIM(B.ELECTRODE_TYPE),''), '/')           AS ELECTRODE_TYPE
                 , A.TRANSPORT_MODE
                 , B.QTY                                AS ITEM_VALUE
              FROM GT_SCP0009_STD A
                 , (SELECT XA.YYYYMMDD
                         , XA.DIVISION_ID
                         , XA.PLAN_START_YYYYMMDD
                         , XA.PLAN_TYPE
                         , XA.SEQ
                         , XA.BIZ_TYPE
                         , XA.ITEM_ID
                         , XA.PROJECT_CODE
                         , XA.TO_SITE
                         , XA.INCOTERMS
                         , XA.FROM_SITE
                         , XA.BOD_ID
                         , XA.MEASURE
                         , XA.QTY
                         , XA.ORIGIN_FROM_DIVISION_ID
                         , XA.ORIGIN_TO_DIVISION_ID
                         , XA.ELECTRODE_TYPE
                         , SA.TRANSPORT_MODE          AS BOD_TRANSPORT_MODE
                      FROM SCP_ANL_SHIPMENT_PLAN_FG XA
                         , GT_SCP0009_BOD_PLAN_H SA
                     WHERE XA.DIVISION_ID  = SA.DIVISION_ID(+)
                       AND XA.BOD_ID       = SA.BOD_ID(+)
                       AND XA.FROM_SITE    = SA.FROM_SITE(+)
                       AND SA.PLAN_SEQ(+)  = TO_NUMBER(P_SEQ)
                       AND SA.PLAN_TYPE(+) = P_PLAN_TYPE
                       AND SA.PLAN_NAME(+) = P_PLAN_START_YYYYMMDD
                       AND XA.YYYYMMDD            >= P_FROM_YYYYMMDD
                       AND XA.YYYYMMDD            <= P_TO_YYYYMMDD
                       AND XA.DIVISION_ID          = P_DIVISION_ID
                       AND XA.BIZ_TYPE             = P_BIZ_TYPE
                       AND XA.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                       AND XA.PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
                       AND XA.PLAN_TYPE            = P_PLAN_TYPE
                       AND XA.SEQ                  = TO_NUMBER(P_SEQ)
                       AND XA.QTY                 <> 0
                   ) B
             WHERE A.DIVISION_ID         = B.DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = B.PLAN_TYPE
               AND TO_NUMBER(A.SEQ)      = B.SEQ
               AND A.BIZ_TYPE            = B.BIZ_TYPE
               AND A.ITEM_ID             = B.ITEM_ID
               AND A.PROJECT_CODE        = B.PROJECT_CODE
               AND A.TO_SITE             = B.TO_SITE
               AND A.INCOTERMS           = B.INCOTERMS
               AND A.FROM_SITE           = B.FROM_SITE
               AND A.BOD_ID              = B.BOD_ID
               AND A.MEASURE             = B.MEASURE
               AND NVL(A.TRANSPORT_MODE, '/') = NVL(B.BOD_TRANSPORT_MODE, '/');

        ELSIF P_PLAN_START_YYYYMMDD < V_MIN_YYYYMMDD THEN

            INSERT INTO GT_SCP0009_FG_VALUE
            (
                YYYYMMDD
              , DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , BOD_ID
              , MEASURE
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , TRANSPORT_MODE
              , ITEM_VALUE
            )
            SELECT B.YYYYMMDD
                 , A.DIVISION_ID
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.BOD_ID
                 , A.MEASURE
                 , NVL(NULLIF(RTRIM(B.ORIGIN_FROM_DIVISION_ID),''), '/')  AS ORIGIN_FROM_DIVISION_ID
                 , NVL(B.ORIGIN_TO_DIVISION_ID, '-')    AS ORIGIN_TO_DIVISION_ID
                 , NVL(NULLIF(RTRIM(B.ELECTRODE_TYPE),''), '/')           AS ELECTRODE_TYPE
                 , A.TRANSPORT_MODE
                 , B.QTY                                AS ITEM_VALUE
              FROM GT_SCP0009_STD A
                 , (SELECT XA.YYYYMMDD
                         , XA.DIVISION_ID
                         , XA.PLAN_START_YYYYMMDD
                         , XA.PLAN_TYPE
                         , XA.SEQ
                         , XA.BIZ_TYPE
                         , XA.ITEM_ID
                         , XA.PROJECT_CODE
                         , XA.TO_SITE
                         , XA.INCOTERMS
                         , XA.FROM_SITE
                         , XA.BOD_ID
                         , XA.MEASURE
                         , XA.QTY
                         , XA.ORIGIN_FROM_DIVISION_ID
                         , XA.ORIGIN_TO_DIVISION_ID
                         , XA.ELECTRODE_TYPE
                         , SA.TRANSPORT_MODE          AS BOD_TRANSPORT_MODE
                      FROM HIST_SCP_ANL_SHIPMENT_PLAN_FG XA
                         , GT_SCP0009_BOD_PLAN_H SA
                     WHERE XA.DIVISION_ID  = SA.DIVISION_ID(+)
                       AND XA.BOD_ID       = SA.BOD_ID(+)
                       AND XA.FROM_SITE    = SA.FROM_SITE(+)
                       AND SA.PLAN_SEQ(+)  = TO_NUMBER(P_SEQ)
                       AND SA.PLAN_TYPE(+) = P_PLAN_TYPE
                       AND SA.PLAN_NAME(+) = P_PLAN_START_YYYYMMDD
                       AND XA.YYYYMMDD            >= P_FROM_YYYYMMDD
                       AND XA.YYYYMMDD            <= P_TO_YYYYMMDD
                       AND XA.DIVISION_ID          = P_DIVISION_ID
                       AND XA.BIZ_TYPE             = P_BIZ_TYPE
                       AND XA.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                       AND XA.PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
                       AND XA.PLAN_TYPE            = P_PLAN_TYPE
                       AND XA.SEQ                  = TO_NUMBER(P_SEQ)
                       AND XA.QTY                 <> 0
                   ) B
             WHERE A.DIVISION_ID         = B.DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = B.PLAN_TYPE
               AND TO_NUMBER(A.SEQ)      = B.SEQ
               AND A.BIZ_TYPE            = B.BIZ_TYPE
               AND A.ITEM_ID             = B.ITEM_ID
               AND A.PROJECT_CODE        = B.PROJECT_CODE
               AND A.TO_SITE             = B.TO_SITE
               AND A.INCOTERMS           = B.INCOTERMS
               AND A.FROM_SITE           = B.FROM_SITE
               AND A.BOD_ID              = B.BOD_ID
               AND A.MEASURE             = B.MEASURE
               AND NVL(A.TRANSPORT_MODE, '/') = NVL(B.BOD_TRANSPORT_MODE, '/');

        END IF;

        /* ##############################################################################
           0값 데이터로 누락된 MEASURE 를 생성한다.
           ############################################################################## */
        INSERT INTO GT_SCP0009_ADD_MEASURE
        (
            YYYYMMDD
          , DIVISION_ID
          , BIZ_TYPE
          , PROJECT_CODE
          , ITEM_ID
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , MEASURE
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , BOD_ID
          , LT_DAY
          , TRANSPORT_MODE
          , MEASURE_LABEL
          , MEASURE_ORDER_NO
          , ITEM_VALUE
        )
        SELECT NVL(B.YYYYMMDD, V_FROM_YYYYMMDD)     AS YYYYMMDD
             , A.DIVISION_ID
             , A.BIZ_TYPE
             , A.PROJECT_CODE
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.MEASURE
             , A.ORIGIN_FROM_DIVISION_ID
             , A.ORIGIN_TO_DIVISION_ID
             , A.ELECTRODE_TYPE
             , A.BOD_ID
             , A.LT_DAY
             , A.TRANSPORT_MODE
             , A.MEASURE_LABEL
             , A.MEASURE_ORDER_NO
             , NVL(B.ITEM_VALUE, 0)                 AS ITEM_VALUE
          FROM GT_SCP0009_STD A
             , GT_SCP0009_FG_VALUE B
         WHERE A.DIVISION_ID             = B.DIVISION_ID(+)
           AND A.PROJECT_CODE            = B.PROJECT_CODE(+)
           AND A.ITEM_ID                 = B.ITEM_ID(+)
           AND A.FROM_SITE               = B.FROM_SITE(+)
           AND A.TO_SITE                 = B.TO_SITE(+)
           AND A.MEASURE                 = B.MEASURE(+)
           AND A.ORIGIN_FROM_DIVISION_ID = B.ORIGIN_FROM_DIVISION_ID(+)
           AND A.ORIGIN_TO_DIVISION_ID   = B.ORIGIN_TO_DIVISION_ID(+)
           AND A.ELECTRODE_TYPE          = B.ELECTRODE_TYPE(+)
           AND NVL(A.INCOTERMS, '/')      = NVL(B.INCOTERMS(+), '/')
           AND NVL(A.TRANSPORT_MODE, '/') = NVL(B.TRANSPORT_MODE(+), '/')
           AND NVL(A.BOD_ID, '/')         = NVL(B.BOD_ID(+), '/');   /* BOD 2단계 개발 : 조건 추가 */

        /* ##############################################################################
           최종 Plan Data 생성
           ############################################################################## */
        INSERT INTO GT_SCP0009_PLAN
        (
            KEY_IDX
          , DIVISION_ID
          , BIZ_TYPE
          , PROJECT_CODE
          , ITEM_ID
          , FROM_SITE
          , TO_SITE
          , TO_SITE2
          , INCOTERMS
          , MEASURE
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , QTY
          , BOD_ID
          , BOD_FROM_YYYYMMDD
          , BOD_TO_YYYYMMDD
          , LT_DAY
          , TRANSPORT_MODE
          , MEASURE_LABEL
          , MEASURE_ORDER_NO
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , YYYYMMDD
          , YYYYMM
          , ISO_WEEK
        )
        SELECT A.DIVISION_ID || A.BIZ_TYPE || A.PROJECT_CODE || A.ITEM_ID || A.TO_SITE || A.INCOTERMS  AS KEY_IDX
             , A.DIVISION_ID
             , A.BIZ_TYPE
             , A.PROJECT_CODE
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TO_SITE
             , CASE WHEN SUBSTR(A.TO_SITE, -2) = '-S' THEN SUBSTR(A.TO_SITE, 1, LENGTH(RTRIM(A.TO_SITE)) - 2) ELSE A.TO_SITE END  AS TO_SITE2
             , A.INCOTERMS
             , A.MEASURE
             , A.ORIGIN_FROM_DIVISION_ID
             , A.ORIGIN_TO_DIVISION_ID
             , A.ELECTRODE_TYPE
             , A.ITEM_VALUE                     AS QTY
             , A.BOD_ID
             , NVL(NULLIF(RTRIM(C.FROM_YYYYMMDD),''), '/')        AS BOD_FROM_YYYYMMDD
             , NVL(NULLIF(RTRIM(C.TO_YYYYMMDD),''), '/')          AS BOD_TO_YYYYMMDD
             , A.LT_DAY
             , A.TRANSPORT_MODE
             , A.MEASURE_LABEL
             , A.MEASURE_ORDER_NO
             , P_FROM_YYYYMMDD                  AS FROM_YYYYMMDD
             , P_TO_YYYYMMDD                    AS TO_YYYYMMDD
             , P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
             , P_PLAN_TYPE                      AS PLAN_TYPE
             , P_SEQ                            AS SEQ
             , 'D_' || A.YYYYMMDD               AS YYYYMMDD
             , B.BASIS_YYYYMM                   AS YYYYMM
             , SUBSTR(B.BASIS_YYYYMM, -4) || B.ISO_WEEK     AS ISO_WEEK
          FROM GT_SCP0009_ADD_MEASURE A
             , SCM_SYS_CALENDAR_M B
             , GT_SCP0009_BOD_PLAN_H C
         WHERE A.YYYYMMDD     = B.BASIS_YYYYMMDD
           /* BOD 2단계 개발 : VIEW 수정 */
           AND A.DIVISION_ID  = C.DIVISION_ID(+)
           AND A.BOD_ID       = C.BOD_ID(+)
           AND C.PLAN_SEQ(+)  = TO_NUMBER(P_SEQ)
           AND C.PLAN_TYPE(+) = P_PLAN_TYPE
           AND C.PLAN_NAME(+) = P_PLAN_START_YYYYMMDD;

        /* ##############################################################################
           최종 Plan Data 생성 :  SHIP_PLAN, SHIP_PLAN_AMEND
           ############################################################################## */
        IF P_DIVISION_ID = V_DIV_ENERGY THEN

            INSERT INTO GT_SCP0009_PLAN
            (
                KEY_IDX
              , DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , FROM_SITE
              , TO_SITE
              , TO_SITE2
              , INCOTERMS
              , MEASURE
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , QTY
              , BOD_ID
              , BOD_FROM_YYYYMMDD
              , BOD_TO_YYYYMMDD
              , LT_DAY
              , TRANSPORT_MODE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              , YYYYMMDD
              , YYYYMM
              , ISO_WEEK
            )
            SELECT A.KEY_IDX
                 , A.DIVISION_ID
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.FROM_SITE
                 , A.TO_SITE
                 , A.TO_SITE2
                 , A.INCOTERMS
                 , A.MEASURE
                 , A.ORIGIN_FROM_DIVISION_ID
                 , A.ORIGIN_TO_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , A.QTY
                 , A.BOD_ID
                 , A.BOD_FROM_YYYYMMDD
                 , A.BOD_TO_YYYYMMDD
                 , A.LT_DAY
                 , A.TRANSPORT_MODE
                 , B.COLUMN_LABEL_NAME
                 , B.MEASURE_ORDER_NO
                 , A.FROM_YYYYMMDD
                 , A.TO_YYYYMMDD
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.YYYYMMDD
                 , A.YYYYMM
                 , A.ISO_WEEK
              FROM (SELECT IA.KEY_IDX
                         , IA.DIVISION_ID
                         , IA.BIZ_TYPE
                         , IA.PROJECT_CODE
                         , IA.ITEM_ID
                         , IA.FROM_SITE
                         , IA.TO_SITE
                         , IA.TO_SITE2
                         , IA.INCOTERMS
                         , CASE WHEN IA.MEASURE = 'SHIP_PLAN'       THEN 'SHIP_PLAN_ENERGY'
                                WHEN IA.MEASURE = 'SHIP_PLAN_AMEND' THEN 'SHIP_PLAN_AMEND_ENERGY'
                                END                                 AS MEASURE
                         , IA.ORIGIN_FROM_DIVISION_ID
                         , IA.ORIGIN_TO_DIVISION_ID
                         , IA.ELECTRODE_TYPE
                         , CASE WHEN IA.QTY IS NOT NULL
                                 AND XA.ENERGY IS NOT NULL
                                THEN ROUND(IA.QTY * XA.ENERGY / 1000, 4)
                                ELSE 0
                                END                                 AS QTY
                         , IA.BOD_ID
                         , IA.BOD_FROM_YYYYMMDD
                         , IA.BOD_TO_YYYYMMDD
                         , IA.LT_DAY
                         , IA.TRANSPORT_MODE
                         , IA.MEASURE_LABEL
                         , IA.MEASURE_ORDER_NO
                         , IA.FROM_YYYYMMDD
                         , IA.TO_YYYYMMDD
                         , IA.PLAN_START_YYYYMMDD
                         , IA.PLAN_TYPE
                         , IA.SEQ
                         , IA.YYYYMMDD
                         , IA.YYYYMM
                         , IA.ISO_WEEK
                      FROM GT_SCP0009_PLAN IA
                         , (SELECT ITEM_ID
                                 , CAST(TO_NUMBER(MAX(ENERGE) DEFAULT NULL ON CONVERSION ERROR) AS NUMBER(13,4))  AS ENERGY
                              FROM SCM_ITEM_M_SN
                             WHERE ENERGE IS NOT NULL
                             GROUP BY ITEM_ID) XA
                     WHERE IA.ITEM_ID = XA.ITEM_ID(+)
                       AND IA.MEASURE IN ('SHIP_PLAN', 'SHIP_PLAN_AMEND')
                       AND IA.DIVISION_ID = V_DIV_ENERGY
                   ) A
                 , GT_SCP0009_MEASURE B
             WHERE A.MEASURE = B.COLUMN_NAME(+)
               AND B.COLUMN_NAME IN ('SHIP_PLAN_ENERGY', 'SHIP_PLAN_AMEND_ENERGY');

        END IF;

        /* ======================== Result Start =============================== */

        /* 실적 포함 시 */
        IF V_RSLT_FLAG = 'Y' THEN

            /* ##############################################################################
               Shipment Plan (Auto & Ess) 기준 실적 가져온다. by 고C, 장C
               ############################################################################## */
            P_LOAD_RESULT_SOURCE(P_DIVISION_ID   => P_DIVISION_ID
                               , P_BIZ_TYPE      => P_BIZ_TYPE
                               , P_FROM_YYYYMMDD => P_FROM_YYYYMMDD
                               , P_TO_YYYYMMDD   => P_TO_YYYYMMDD
                               , P_FROM_RESULT   => V_FROM_RESULT
                               , P_TO_RESULT     => V_TO_RESULT
                               , P_TITLE_YN      => 'N');

            INSERT INTO GT_SCP0009_RSLT_TMP
            (
                DIVISION_ID
              , COMPANY_ID
              , TYPE
              , ERP_SO_NO
              , CONFIRM_ID
              , ITEM_ID
              , NICK_NAME
              , FROM_SITE
              , TO_SITE
              , END_CUSTOMER
              , QTY
              , YYYYMMDD
              , TRANSPORT_MODE
              , INCOTERMS
              , ETD_DATE
              , ETA_DATE
              , SHIP_TYPE
              , PROJECT_CODE
            )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID                             AS COMPANY_ID
                 , C.SEGMENT2                               AS TYPE
                 , A.ERP_SO_NO
                 , A.CONFIRM_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID)   AS NICK_NAME
                 /* 2021.11.02   LWY
                    , ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.FROM_SITE),X.FROM_SITE) AS FROM_SITE
                    , ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.TO_SITE),X.TO_SITE)     AS TO_SITE */
                 , A.FROM_SITE                              AS FROM_SITE
                 , A.TO_SITE                                AS TO_SITE
                 , A.END_CUSTOMER
                 , A.QTY
                 /* , CONVERT(VARCHAR(10), CONVERT(DATETIME, X.YYYYMMDD,112), 23) AS YYYYMMDD */
                 , A.YYYYMMDD                               AS YYYYMMDD
                 , A.TRANSPORT_MODE
                 , A.INCOTERMS
                 , CASE WHEN REGEXP_LIKE(A.ETD_DATE, '^[0-9]{8}$') THEN TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END    AS ETD_DATE
                 , CASE WHEN REGEXP_LIKE(A.ETA_DATE, '^[0-9]{8}$') THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END    AS ETA_DATE
                 , A.SHIP_TYPE
                 , A.PROJECT_CODE
              FROM (
                    /* CONFIRM_ID ,날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계 */
                    SELECT IA.DIVISION_ID                   AS DIVISION_ID
                         , 'E'                              AS TYPE
                         , XA.ERP_SO_NO                     AS ERP_SO_NO
                         , XA.CONFIRM_ID                    AS CONFIRM_ID
                         /* 20240627 E20240612-001030 실제 Item ID 로 조회 */
                         , XA.ITEM_ID                       AS ITEM_ID
                         , IA.FROM_SITE                     AS FROM_SITE
                         , XA.TO_SITE                       AS TO_SITE      /* 20220316 수정 */
                         , NULL                             AS END_CUSTOMER
                         , SUM(XA.RESULT_QTY)               AS QTY
                         , XA.YYYYMMDD                      AS YYYYMMDD
                         , XA.TRANSPORT_MODE                AS TRANSPORT_MODE
                         , XA.INCOTERMS                     AS INCOTERMS
                         , XA.ETD_DATE                      AS ETD_DATE
                         , XA.ETA_DATE                      AS ETA_DATE
                         , NULL                             AS SHIP_TYPE
                         , XA.PROJECT_CODE                  AS PROJECT_CODE
                      FROM GT_SCP0009_PLAN_SSP IA
                         , GT_SCP0009_ERP_C_EXIST XA
                     WHERE XA.DIVISION_ID = IA.DIVISION_ID
                       AND XA.CONFIRM_ID  = IA.CONFIRM_ID
                       AND XA.YYYYMMDD    = IA.YYYYMMDD
                     GROUP BY IA.DIVISION_ID
                            , XA.ERP_SO_NO
                            , IA.FROM_SITE
                            , XA.TO_SITE        /* 20220316 수정 */
                            , XA.ITEM_ID        /* 20240627 E20240612-001030 실제 Item ID 로 조회 */
                            , XA.TRANSPORT_MODE
                            , XA.INCOTERMS
                            , XA.ETD_DATE
                            , XA.ETA_DATE
                            , XA.YYYYMMDD
                            , XA.CONFIRM_ID
                            , XA.PROJECT_CODE
                    UNION ALL
                    /* CONFIRM_ID ,기준으로 날짜가 다른 계획정보의 FROM, TO SITE기준으로 실적 집계 */
                    SELECT IA.DIVISION_ID                   AS DIVISION_ID
                         , 'E'                              AS TYPE
                         , XA.ERP_SO_NO                     AS ERP_SO_NO
                         , XA.CONFIRM_ID                    AS CONFIRM_ID
                         , XA.ITEM_ID                       AS ITEM_ID
                         , IA.FROM_SITE                     AS FROM_SITE
                         , XA.TO_SITE                       AS TO_SITE      /* 20220316 수정 */
                         , NULL                             AS END_CUSTOMER
                         , SUM(XA.RESULT_QTY)               AS QTY
                         , XA.YYYYMMDD                      AS YYYYMMDD
                         , XA.TRANSPORT_MODE                AS TRANSPORT_MODE
                         , XA.INCOTERMS                     AS INCOTERMS
                         , XA.ETD_DATE                      AS ETD_DATE
                         , XA.ETA_DATE                      AS ETA_DATE
                         , NULL                             AS SHIP_TYPE
                         , XA.PROJECT_CODE                  AS PROJECT_CODE
                      FROM GT_SCP0009_PLAN_SSP IA
                         , GT_SCP0009_ERP_C_EXIST XA
                     WHERE XA.DIVISION_ID = IA.DIVISION_ID
                       AND XA.CONFIRM_ID  = IA.CONFIRM_ID
                       AND XA.YYYYMMDD   <> IA.YYYYMMDD
                     GROUP BY IA.DIVISION_ID
                            , XA.ERP_SO_NO
                            , IA.FROM_SITE
                            , XA.TO_SITE        /* 20220316 수정 */
                            , XA.ITEM_ID
                            , XA.TRANSPORT_MODE
                            , XA.INCOTERMS
                            , XA.ETD_DATE
                            , XA.ETA_DATE
                            , XA.YYYYMMDD
                            , XA.CONFIRM_ID
                            , XA.PROJECT_CODE
                    UNION ALL
                    /* CONFIRM_ID 없는 실적 */
                    SELECT DIVISION_ID                      AS DIVISION_ID
                         , 'E'                              AS TYPE
                         , ERP_SO_NO                        AS ERP_SO_NO
                         , NULL                             AS CONFIRM_ID
                         , ITEM_ID                          AS ITEM_ID
                         , FROM_SITE                        AS FROM_SITE
                         , TO_SITE                          AS TO_SITE
                         , NULL                             AS END_CUSTOMER
                         , QTY                              AS QTY
                         , YYYYMMDD                         AS YYYYMMDD
                         , TRANSPORT_MODE                   AS TRANSPORT_MODE
                         , INCOTERMS                        AS INCOTERMS
                         , ETD_DATE                         AS ETD_DATE
                         , ETA_DATE                         AS ETA_DATE
                         , NULL                             AS SHIP_TYPE
                         , PROJECT_CODE                     AS PROJECT_CODE
                      FROM GT_SCP0009_ERP_C_NON
                    UNION ALL
                    SELECT DIVISION_ID                      AS DIVISION_ID
                         , 'P'                              AS TYPE
                         , ERP_SO_NO                        AS ERP_SO_NO
                         , CONFIRM_ID                       AS CONFIRM_ID
                         , ITEM_ID                          AS ITEM_ID
                         , FROM_SITE                        AS FROM_SITE
                         , TO_SITE                          AS TO_SITE
                         , END_CUSTOMER                     AS END_CUSTOMER
                         , QTY                              AS QTY
                         , YYYYMMDD                         AS YYYYMMDD
                         , TRANSPORT_MODE                   AS TRANSPORT_MODE
                         , INCOTERMS                        AS INCOTERMS
                         , ETD_DATE                         AS ETD_DATE
                         , ETA_DATE                         AS ETA_DATE
                         , NULL                             AS SHIP_TYPE
                         , NULL                             AS PROJECT_CODE
                      FROM GT_SCP0009_PLAN_SSP
                     WHERE 1 = 1
                       AND YYYYMMDD >= V_FROM_RESULT
                       AND YYYYMMDD <  V_TO_RESULT
                   ) A
                 , SCM_MST_SITE B
                 , SCM_ADM_LOOKUP_MASTER_DETAIL C
                 , SSP_MST_MODEL_USER D
             WHERE B.DIVISION_ID     = A.DIVISION_ID
               AND B.SCM_SITE_ID     = A.FROM_SITE
               AND C.SEGMENT1        = A.TYPE
               AND D.DIVISION_ID(+)  = A.DIVISION_ID
               AND D.FROM_SITE(+)    = A.FROM_SITE
               AND D.ITEM_ID(+)      = A.ITEM_ID
               AND D.VALID_YN(+)     = 'Y'
               AND B.OPERATION_GROUP <> 'E'
               AND C.LOOKUP_TYPE     = 'SSP_SHIPMENT_RESULT_TYPE'   /* LOOKUP에 등록된 공정만 */
               AND C.VALID_YN        = 'Y'
               AND A.DIVISION_ID     = P_DIVISION_ID
               AND A.TYPE            = 'E'                          /* Result(ERP) */
               -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
               -- AND (P_FROMSITE IS NULL OR A.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
               -- AND (P_ITEM_ID  IS NULL OR A.ITEM_ID   IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))));
               AND (P_FROMSITE IS NULL OR UPPER(TRIM(P_FROMSITE)) = 'ALL' OR A.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
               AND (P_ITEM_ID  IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' OR A.ITEM_ID   IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))));
               -- 2026.10.06 AJS 조회조건 ALL 처리 (END)

            /* ##############################################################################
               Final 실적정보 생성
               ############################################################################## */
            INSERT INTO GT_SCP0009_RSLT
            (
                KEY_IDX
              , DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , FROM_SITE
              , TO_SITE
              , TO_SITE2
              , INCOTERMS
              , MEASURE
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , QTY
              , BOD_ID
              , BOD_FROM_YYYYMMDD
              , BOD_TO_YYYYMMDD
              , LT_DAY
              , TRANSPORT_MODE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              , YYYYMMDD
              , YYYYMM
              , ISO_WEEK
            )
            SELECT A.DIVISION_ID || P_BIZ_TYPE || NVL(NULLIF(RTRIM(A.PROJECT_CODE),''), '/') || NVL(NULLIF(RTRIM(A.ITEM_ID),''), '/') || NVL(NULLIF(RTRIM(A.TO_SITE),''), '/') || NVL(NULLIF(RTRIM(A.INCOTERMS),''), '/')  AS KEY_IDX
                 , A.DIVISION_ID
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.FROM_SITE                      AS FROM_SITE
                 , A.TO_SITE                        AS TO_SITE
                 , CASE WHEN SUBSTR(A.TO_SITE, -2) = '-S' THEN SUBSTR(A.TO_SITE, 1, LENGTH(RTRIM(A.TO_SITE)) - 2) ELSE A.TO_SITE END  AS TO_SITE2
                 , A.INCOTERMS
                 , CAST(A.MEASURE AS VARCHAR2(400 CHAR))    AS MEASURE
                 , A.DIVISION_ID                    AS ORIGIN_FROM_DIVISION_ID
                 , A.DIVISION_ID                    AS ORIGIN_TO_DIVISION_ID
                 , NVL(NULLIF(RTRIM(D.ELECTRODE_TYPE),''), '/')       AS ELECTRODE_TYPE
                 , A.QTY
                 , NVL(NULLIF(RTRIM(A.BOD_ID),''), '/')               AS BOD_ID
                 , NVL(A.BOD_FROM_YYYYMMDD, '-')    AS BOD_FROM_YYYYMMDD
                 , NVL(A.BOD_TO_YYYYMMDD, '-')      AS BOD_TO_YYYYMMDD
                 , NVL(D.LT_DAY, '-')               AS LT_DAY
                 , A.TRANSPORT_MODE
                 , CAST(A.MEASURE_LABEL AS VARCHAR2(300 CHAR))  AS MEASURE_LABEL
                 /* ISNULL(NULLIF(M.MEASURE_ORDER_NO,''),'-') - MEASURE_ORDER_NO 는 NOT NULL 이라 대체값에 닿지 않는다 */
                 , B.MEASURE_ORDER_NO               AS MEASURE_ORDER_NO
                 , P_FROM_YYYYMMDD                  AS FROM_YYYYMMDD
                 , P_TO_YYYYMMDD                    AS TO_YYYYMMDD
                 , P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE                      AS PLAN_TYPE
                 , P_SEQ                            AS SEQ
                 , 'D_' || A.EXFACTORY_DATE         AS YYYYMMDD
                 , C.BASIS_YYYYMM                   AS YYYYMM
                 , SUBSTR(C.BASIS_YYYYMM, -4) || C.ISO_WEEK     AS ISO_WEEK
              FROM (SELECT IA.DIVISION_ID
                         , P_BIZ_TYPE                       AS BIZ_TYPE
                         , IA.PROJECT_CODE
                         , IA.ITEM_ID
                         , IA.FROM_SITE
                         , IA.TO_SITE
                         , IA.INCOTERMS
                         /* SHIP_PLAN_AMEND 가 SHIP_PLAN 보다 문자열 길어서 TEMP INSERT 시 오류 때문에 순서바꿈 */
                         , 'SHIP_PLAN_AMEND'                AS MEASURE
                         , IA.DIVISION_ID                   AS ORIGIN_FROM_DIVISION_ID
                         , IA.DIVISION_ID                   AS ORIGIN_TO_DIVISION_ID
                         , IA.TRANSPORT_MODE
                         , 'Ship Plan Amend'                AS MEASURE_LABEL
                         , IA.YYYYMMDD                      AS EXFACTORY_DATE   /* EXFACTORY_DATE */
                         , XA.BOD_ID                        AS BOD_ID
                         , XA.FROM_YYYYMMDD                 AS BOD_FROM_YYYYMMDD
                         , XA.TO_YYYYMMDD                   AS BOD_TO_YYYYMMDD
                         , SUM(IA.QTY)                      AS QTY              /* EXFACTORY_QTY */
                      FROM GT_SCP0009_RSLT_TMP IA
                         /* BOD 2단계 개발 : VIEW 수정 및 FROM , TO 조건 추가
                            --div_commonization : EE 계열이면 ORG_DIVISION_ID 로 붙는다 */
                         , (SELECT CASE WHEN V_EE_YN = 'Y' THEN SA.ORG_DIVISION_ID ELSE SA.DIVISION_ID END  AS JOIN_DIVISION_ID
                                 , SA.DIVISION_ID
                                 , SA.FROM_SITE
                                 , SA.TO_SITE
                                 , SA.TRANSPORT_MODE
                                 , SA.INCOTERMS
                                 , SA.FROM_YYYYMMDD
                                 , SA.TO_YYYYMMDD
                                 , SA.BOD_ID
                                 , SA.PLAN_TYPE
                                 , SA.PLAN_SEQ
                                 , SA.PLAN_NAME
                              FROM GT_SCP0009_BOD_PLAN_H SA) XA
                     WHERE IA.DIVISION_ID     = XA.JOIN_DIVISION_ID(+)
                       AND IA.FROM_SITE       = XA.FROM_SITE(+)
                       AND IA.TO_SITE         = XA.TO_SITE(+)
                       AND IA.TRANSPORT_MODE  = XA.TRANSPORT_MODE(+)
                       AND IA.INCOTERMS       = XA.INCOTERMS(+)
                       AND IA.YYYYMMDD       >= XA.FROM_YYYYMMDD(+)
                       AND IA.YYYYMMDD       <= XA.TO_YYYYMMDD(+)
                       AND XA.DIVISION_ID(+)  = P_DIVISION_ID
                       AND XA.PLAN_TYPE(+)    = P_PLAN_TYPE
                       AND XA.PLAN_SEQ(+)     = TO_NUMBER(P_SEQ)
                       AND XA.PLAN_NAME(+)    = P_PLAN_START_YYYYMMDD
                     GROUP BY IA.DIVISION_ID
                            , IA.PROJECT_CODE
                            , IA.ITEM_ID
                            , IA.FROM_SITE
                            , IA.TO_SITE
                            , IA.INCOTERMS
                            , IA.TRANSPORT_MODE
                            , IA.YYYYMMDD
                            , XA.BOD_ID
                            , XA.FROM_YYYYMMDD
                            , XA.TO_YYYYMMDD
                   ) A
                 , GT_SCP0009_MEASURE B
                 , SCM_SYS_CALENDAR_M C
                 , GT_SCP0009_STD D
             WHERE A.MEASURE          = B.COLUMN_NAME
               AND A.EXFACTORY_DATE   = C.BASIS_YYYYMMDD
               AND A.BOD_ID           = D.BOD_ID(+)
               AND A.ITEM_ID          = D.ITEM_ID(+)
               AND A.PROJECT_CODE     = D.PROJECT_CODE(+)
               /* AND 'SHIP_PLAN' = B.MEASURE */
               /* 2021.12.02   LWY */
               AND A.MEASURE          = D.MEASURE(+);

            /* ##############################################################################
               SHIP_PLAN_AMEND -> SHIP_PLAN  Copy.......
               AS-IS 는 CROSS APPLY 라 'SHIP_PLAN' MEASURE 가 없으면 한 건도 복사되지 않는다.
               ############################################################################## */
            SELECT MAX(MEASURE_ORDER_NO)
              INTO V_SHIP_PLAN_ORDER_NO
              FROM GT_SCP0009_MEASURE
             WHERE COLUMN_NAME = 'SHIP_PLAN';

            IF V_SHIP_PLAN_ORDER_NO IS NOT NULL THEN

                INSERT INTO GT_SCP0009_RSLT
                (
                    KEY_IDX
                  , DIVISION_ID
                  , BIZ_TYPE
                  , PROJECT_CODE
                  , ITEM_ID
                  , FROM_SITE
                  , TO_SITE
                  , TO_SITE2
                  , INCOTERMS
                  , MEASURE
                  , ORIGIN_FROM_DIVISION_ID
                  , ORIGIN_TO_DIVISION_ID
                  , ELECTRODE_TYPE
                  , QTY
                  , BOD_ID
                  , BOD_FROM_YYYYMMDD
                  , BOD_TO_YYYYMMDD
                  , LT_DAY
                  , TRANSPORT_MODE
                  , MEASURE_LABEL
                  , MEASURE_ORDER_NO
                  , FROM_YYYYMMDD
                  , TO_YYYYMMDD
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , YYYYMMDD
                  , YYYYMM
                  , ISO_WEEK
                )
                SELECT KEY_IDX
                     , DIVISION_ID
                     , BIZ_TYPE
                     , PROJECT_CODE
                     , ITEM_ID
                     , FROM_SITE
                     , TO_SITE
                     , TO_SITE2
                     , INCOTERMS
                     , 'SHIP_PLAN'                  /* MEASURE */
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , ELECTRODE_TYPE
                     , QTY
                     , BOD_ID
                     , BOD_FROM_YYYYMMDD            /* BOD 2단계 */
                     , BOD_TO_YYYYMMDD              /* BOD 2단계 */
                     , LT_DAY
                     , TRANSPORT_MODE
                     , 'Ship Plan'                  /* MEASURE LABEL */
                     , V_SHIP_PLAN_ORDER_NO
                     , FROM_YYYYMMDD
                     , TO_YYYYMMDD
                     , PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , SEQ
                     , YYYYMMDD
                     , YYYYMM
                     , ISO_WEEK
                  FROM GT_SCP0009_RSLT;

            END IF;

            IF P_DIVISION_ID = V_DIV_ENERGY THEN

                INSERT INTO GT_SCP0009_RSLT
                (
                    KEY_IDX
                  , DIVISION_ID
                  , BIZ_TYPE
                  , PROJECT_CODE
                  , ITEM_ID
                  , FROM_SITE
                  , TO_SITE
                  , TO_SITE2
                  , INCOTERMS
                  , MEASURE
                  , ORIGIN_FROM_DIVISION_ID
                  , ORIGIN_TO_DIVISION_ID
                  , ELECTRODE_TYPE
                  , QTY
                  , BOD_ID
                  , BOD_FROM_YYYYMMDD
                  , BOD_TO_YYYYMMDD
                  , LT_DAY
                  , TRANSPORT_MODE
                  , MEASURE_LABEL
                  , MEASURE_ORDER_NO
                  , FROM_YYYYMMDD
                  , TO_YYYYMMDD
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , YYYYMMDD
                  , YYYYMM
                  , ISO_WEEK
                )
                SELECT KEY_IDX
                     , DIVISION_ID
                     , BIZ_TYPE
                     , PROJECT_CODE
                     , ITEM_ID
                     , FROM_SITE
                     , TO_SITE
                     , TO_SITE2
                     , INCOTERMS
                     , 'SHIP_PLAN_AMEND_ENERGY'     AS MEASURE
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , ELECTRODE_TYPE
                     , NVL(QTY, 0) * 2
                     , BOD_ID
                     , BOD_FROM_YYYYMMDD
                     , BOD_TO_YYYYMMDD
                     , LT_DAY
                     , TRANSPORT_MODE
                     , 'Ship Plan Amend (MWh)'      AS MEASURE_LABEL
                     , MEASURE_ORDER_NO
                     , FROM_YYYYMMDD
                     , TO_YYYYMMDD
                     , PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , SEQ
                     , YYYYMMDD
                     , YYYYMM
                     , ISO_WEEK
                  FROM GT_SCP0009_RSLT
                 WHERE MEASURE     = 'SHIP_PLAN_AMEND'
                   AND DIVISION_ID = V_DIV_ENERGY;

            END IF;

        END IF;  /* IF(@v_RSLT_FLAG = 'Y') */

        /* ======================== Result END   =============================== */

        /* 2021/10/05 : UI 속도 개선 - RSLT + PLAN */
        INSERT INTO GT_SCP0009_FNL_RSLT_PLAN
        (
            KEY_IDX
          , DIVISION_ID
          , BIZ_TYPE
          , PROJECT_CODE
          , ITEM_ID
          , FROM_SITE
          , TO_SITE
          , TO_SITE2
          , INCOTERMS
          , MEASURE
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , QTY
          , BOD_ID
          , BOD_FROM_YYYYMMDD
          , BOD_TO_YYYYMMDD
          , LT_DAY
          , TRANSPORT_MODE
          , MEASURE_LABEL
          , MEASURE_ORDER_NO
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , YYYYMMDD
          , YYYYMM
          , ISO_WEEK
        )
        SELECT KEY_IDX
             , DIVISION_ID
             , BIZ_TYPE
             , PROJECT_CODE
             , ITEM_ID
             , FROM_SITE
             , TO_SITE
             , TO_SITE2
             , INCOTERMS
             , MEASURE
             , ORIGIN_FROM_DIVISION_ID
             , ORIGIN_TO_DIVISION_ID
             , ELECTRODE_TYPE
             , QTY
             , BOD_ID
             , BOD_FROM_YYYYMMDD
             , BOD_TO_YYYYMMDD
             , LT_DAY
             , TRANSPORT_MODE
             , MEASURE_LABEL
             , MEASURE_ORDER_NO
             , FROM_YYYYMMDD
             , TO_YYYYMMDD
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , SEQ
             , YYYYMMDD
             , YYYYMM
             , ISO_WEEK
          FROM GT_SCP0009_PLAN;

        IF V_RSLT_FLAG = 'Y' THEN

            INSERT INTO GT_SCP0009_FNL_RSLT_PLAN
            (
                KEY_IDX
              , DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , FROM_SITE
              , TO_SITE
              , TO_SITE2
              , INCOTERMS
              , MEASURE
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , QTY
              , BOD_ID
              , BOD_FROM_YYYYMMDD
              , BOD_TO_YYYYMMDD
              , LT_DAY
              , TRANSPORT_MODE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              , YYYYMMDD
              , YYYYMM
              , ISO_WEEK
            )
            SELECT KEY_IDX
                 , DIVISION_ID
                 , BIZ_TYPE
                 , PROJECT_CODE
                 , ITEM_ID
                 , FROM_SITE
                 , TO_SITE
                 , TO_SITE2
                 , INCOTERMS
                 , MEASURE
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , QTY
                 , BOD_ID
                 , BOD_FROM_YYYYMMDD
                 , BOD_TO_YYYYMMDD
                 , LT_DAY
                 , TRANSPORT_MODE
                 , MEASURE_LABEL
                 , MEASURE_ORDER_NO
                 , FROM_YYYYMMDD
                 , TO_YYYYMMDD
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , YYYYMMDD
                 , YYYYMM
                 , ISO_WEEK
              FROM GT_SCP0009_RSLT;

        END IF;

        /* 2021/10/05 : UI 속도 개선 ( SUM을 위한 컬럼 UPDATE) */
        UPDATE GT_SCP0009_FNL_RSLT_PLAN A
           SET A.WEEK_YN = 'Y'
         WHERE A.MEASURE IN ('BALANCE', 'WH_IN_BALANCE')
           AND EXISTS (SELECT 1
                         FROM (SELECT MAX(BASIS_YYYYMMDD) AS YYYYMMDD
                                 FROM SCM_SYS_CALENDAR_M
                                WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                                  AND BASIS_YYYYMMDD <= P_TO_PERIOD     /* 마지막 구간 오류 발생으로 1개월 더함 */
                                GROUP BY ISO_WEEK
                                       , PARTIAL_WEEK_NAME
                                       , CALENDAR_YYYY) IA
                        WHERE IA.YYYYMMDD = SUBSTR(A.YYYYMMDD, -8));

        UPDATE GT_SCP0009_FNL_RSLT_PLAN A
           SET A.MONTH_YN = 'Y'
         WHERE A.MEASURE IN ('BALANCE', 'WH_IN_BALANCE')
           AND EXISTS (SELECT 1
                         FROM (SELECT MAX(BASIS_YYYYMMDD) AS YYYYMMDD
                                 FROM SCM_SYS_CALENDAR_M
                                WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                                  AND BASIS_YYYYMMDD <= P_TO_PERIOD     /* 마지막 구간 오류 발생으로 1개월 더함 */
                                GROUP BY BASIS_YYYYMM) XA
                        WHERE XA.YYYYMMDD = SUBSTR(A.YYYYMMDD, -8));

        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SCP0009_FNL_RSLT_PLAN', NO_INVALIDATE => FALSE);

        /* PRESERVE ROWS GTT 에 DML 후 COMMIT (CNS 전환가이드 7항 필수 구현 2) */
        COMMIT;

        /********************************************************************************
        * PIVOIT처리
        ********************************************************************************/
        P_MAKE_PIVOT_COLUMNS(P_FROM_YYYYMMDD => P_FROM_YYYYMMDD
                           , P_TO_YYYYMMDD   => P_TO_YYYYMMDD
                           , P_BUCKET        => V_BUCKET
                           , P_TITLE_YN      => 'N'
                           , O_QRY_SUM       => V_QRY_SUM);

        P_MAKE_OUTER_SELECT(P_DIVISION_ID         => P_DIVISION_ID
                          , P_PLAN_START_YYYYMMDD => P_PLAN_START_YYYYMMDD
                          , P_TEAM_ID             => P_TEAM_ID
                          , P_EE_YN               => V_EE_YN
                          , P_SOURCE_TABLE        => 'GT_SCP0009_FNL_RSLT_PLAN'
                          , P_QRY_SUM             => V_QRY_SUM
                          , O_SQL                 => V_SQL);

        /* DEBUG QRY 출력 */
        IF P_DEBUG_MODE = 'T' THEN
            FOR I IN 0 .. TRUNC((DBMS_LOB.GETLENGTH(V_SQL) - 1) / 4000)
            LOOP
                DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(V_SQL, 4000, I * 4000 + 1));
            END LOOP;
        END IF;

        OPEN O_RC1 FOR V_SQL;

        /* ################################################################################################
           Return Data 2 - IsEditable, plan_Start_Date
           Daily 는 parallel 처리로 title 프로시저에서 수정구간, FIX 정보를 조회한다.
           WEEKLY, MONTHLY 는 parallel 처리하지 않아 여기에서 조회한다.
           AS-IS 는 그 밖의 bucket 이면 결과셋을 아예 반환하지 않으나,
           Oracle 은 OUT 커서 벌 수를 바꿀 수 없으므로 조건을 그대로 커서 안에 둔다(조건 밖이면 0 건).
           ################################################################################################ */
        OPEN O_RC2 FOR
            SELECT 'Y'                              AS IS_EDITABLE
                 , A.PLAN_NAME
                 , A.PLAN_SEQ
                 , A.PLAN_TYPE
                 , A.CONFIRM_FLAG
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_STATUS
                 , A.CONFIRM_YN
                 , A.PLAN_TYPE_SEQ
                 , B.BASIS_START_DATE
                 , TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   AS PLAN_START_DATE
              FROM (SELECT IA.PLAN_NAME
                         , XA.PLAN_SEQ
                         , XA.PLAN_TYPE
                         , SA.CONFIRM_FLAG
                         , IA.PLAN_NAME                         AS PLAN_START_YYYYMMDD
                         , XA.PLAN_STATUS
                         , NVL(XA.CONFIRM_FLAG, 'N')            AS CONFIRM_YN
                         , CASE XA.PLAN_TYPE WHEN 'PR' THEN 0 WHEN 'MA' THEN 1 WHEN 'SE' THEN 2 WHEN 'FN' THEN 3 END  AS PLAN_TYPE_SEQ
                      FROM SCM_MST_PLAN_DETAIL XA
                         , SCM_MST_MODELING YA
                         , SCM_MST_PLAN IA
                         , SCP_PLAN_VERSION_V SA
                     WHERE YA.MODELING_ID  = XA.MODELING_ID
                       AND YA.DIVISION_ID  = XA.DIVISION_ID
                       AND IA.DIVISION_ID  = XA.DIVISION_ID
                       AND IA.PLAN_CYCLE   = YA.PLAN_CYCLE
                       AND IA.PLAN_ID      = XA.PLAN_ID
                       AND XA.DIVISION_ID  = SA.DIVISION_ID
                       AND XA.PLAN_TYPE    = SA.PLAN_TYPE
                       AND XA.PLAN_SEQ     = SA.PLAN_SEQ
                       AND IA.PLAN_NAME    = SA.PLAN_START_YYYYMMDD
                       AND YA.PLAN_CYCLE   = 'WEEKLY'
                       AND XA.PLAN_TYPE    IN ('PR', 'MA', 'SE', 'FN', 'TE')
                       AND XA.DISPLAY_YN   = 'Y'
                       AND XA.DIVISION_ID  = P_DIVISION_ID
                       AND IA.PLAN_NAME    = P_PLAN_START_YYYYMMDD
                   ) A
                 , (SELECT BASIS_START_DATE
                      FROM SCM_SYS_CALENDAR_M
                     WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')) B
             WHERE P_BUCKET IN ('WEEKLY', 'MONTHLY');

        /* ################################################################################################
           Return Data 3 - Fix 컬럼 색상 설정
           ################################################################################################ */
        /* 05/25 FIX 추가관련 */
        OPEN O_RC3 FOR
            SELECT DIVISION_ID || BIZ_TYPE || PROJECT_CODE || ITEM_ID || TO_SITE || INCOTERMS    AS KEY_IDX
                 , FIX_ID
                 , FROM_SITE
                 , INCOTERMS
                 , BOD_ID
                 , 'D_' || YYYYMMDD                 AS YYYYMMDD
              FROM SCP_ANL_SHIPMENT_PLAN_FIX
             WHERE DIVISION_ID = P_DIVISION_ID
               AND BIZ_TYPE    = P_BIZ_TYPE
               AND YYYYMMDD   >= P_FROM_YYYYMMDD
               AND YYYYMMDD   <= P_TO_YYYYMMDD
               -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
               -- AND (P_ITEM_ID      IS NULL OR ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
               AND (P_ITEM_ID      IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' OR ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
               -- 2026.10.06 AJS 조회조건 ALL 처리 (END)
               /* AS-IS 두 번째 조건은 @p_project_code 를 검사하되 대상 컬럼·값이 모두 ITEM 이다. 원문 그대로 둔다. */
               -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
               -- AND (P_PROJECT_CODE IS NULL OR P_ITEM_ID IS NULL OR ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
               AND (P_PROJECT_CODE IS NULL OR UPPER(TRIM(P_PROJECT_CODE)) = 'ALL' OR P_ITEM_ID IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' OR ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
               -- 2026.10.06 AJS 조회조건 ALL 처리 (END)
--               AND P_BUCKET IN ('WEEKLY', 'MONTHLY')
             ORDER BY KEY_IDX
                    , DIVISION_ID
                    , BIZ_TYPE
                    , ITEM_ID
                    , TO_SITE
                    , PROJECT_CODE
                    , INCOTERMS
                    , FROM_SITE
                    , BOD_ID;

    EXCEPTION
        WHEN OTHERS THEN
            PR_SCM_SYS_LOG_BATCH(P_PROGRAM_NAME  => $$PLSQL_UNIT || '.P_SCP0009_GET_SHIPMENT_PLAN_FG'
                               , P_LOG_TYPE      => 'ERROR'
                               , P_LOG_COUNT     => NULL
                               , P_LOG_MESSAGE   => SQLERRM
                               , P_DESCRIPTION   => NULL
                               , P_EVENT_DATE    => SYSDATE
                               , P_IN_PARA_DATA  => V_PARA
                               , P_SQL_ERR_CODE  => TO_CHAR(SQLCODE)
                               , P_SQL_ERR_MSG   => SQLERRM
                               , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE;

    END P_SCP0009_GET_SHIPMENT_PLAN_FG;


    /* ==============================================================================================
       SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL
       ============================================================================================== */
    PROCEDURE P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_BIZ_TYPE              IN  VARCHAR2,
        P_PROJECT_CODE          IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_ELECTYPE              IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_FROMSITE              IN  VARCHAR2,
        P_TEAM_ID               IN  VARCHAR2,
        P_TOSITE                IN  VARCHAR2,
        P_BUCKET                IN  VARCHAR2,
        P_CHK_ALL               IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0009',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'Shipment Plan FG',
        P_USER_ID               IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL
     * Description  : Shipment Plan 조회 (타이틀 - 행 축만 만들고 수량은 0 으로 둔다)
     * Program History
     *===================================================================================================
     * Date         In Charge                 Description
     *===================================================================================================
     * 2018/01/29   byunghunjung              Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2021.10.05   khj79                     [PJ20209643] UI 속도 개선 (bucket 별 컬럼 설정 변경하여 조회되도록 수정 함)
     * 2021.11.24   khj79                     [PJ20209643] p_chk_all 추가 ( 체크 시 bucket='daily' 조회)
     * 2023.04.10   LWY                       PJ20230691R - DIVISION_ID 공통화 작업(div_commonization)
     * 2024.06.27   ksg                       E20240612-001030 Shipment plan FG 실적조회 시 confirm_id 참조하는 데이터 변경
     * 2024.11.13   KSG                       E20241105-000454 Shipment plan FG 팀정보 기준 변경 요청
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
        V_CNT_USR_MEASURE       PLS_INTEGER := 0;
        V_FROM_YYYYMMDD         VARCHAR2(8 CHAR);
        V_TO_YYYYMMDD           VARCHAR2(8 CHAR);
        V_FROM_RESULT           VARCHAR2(8 CHAR);
        V_TO_RESULT             VARCHAR2(8 CHAR);
        V_MIN_YYYYMMDD          VARCHAR2(8 CHAR);
        V_RSLT_FLAG             VARCHAR2(1 CHAR) := 'Y';
        V_DIV_ENERGY            VARCHAR2(30 CHAR) := '82';
        V_BUCKET                VARCHAR2(30 CHAR) := P_BUCKET;
        V_EE_YN                 VARCHAR2(1 CHAR);
        V_SHIP_PLAN_ORDER_NO    VARCHAR2(512 CHAR);
        V_SOURCE_TABLE          VARCHAR2(50 CHAR);
        V_QRY_SUM               CLOB;
        V_SQL                   CLOB;
        V_PARA                  VARCHAR2(4000 CHAR);
    BEGIN

        V_PARA := 'P_FROM_YYYYMMDD=' || P_FROM_YYYYMMDD || ', P_TO_YYYYMMDD=' || P_TO_YYYYMMDD
               || ', P_DIVISION_ID=' || P_DIVISION_ID || ', P_BIZ_TYPE=' || P_BIZ_TYPE
               || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD || ', P_PLAN_TYPE=' || P_PLAN_TYPE
               || ', P_SEQ=' || P_SEQ || ', P_BUCKET=' || P_BUCKET || ', P_USER_ID=' || P_USER_ID;

        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0009_TMP_MEASURE;
        DELETE FROM GT_SCP0009_TMP_STD;
        DELETE FROM GT_SCP0009_BOD_PLAN_H;
        DELETE FROM GT_SCP0009_BOD_PLAN_H0;
        DELETE FROM GT_SCP0009_TMP_ADD_MEASURE;
        DELETE FROM GT_SCP0009_ADD_CALENDAR;
        DELETE FROM GT_SCP0009_TMP_PLAN;
        DELETE FROM GT_SCP0009_ERP_C_EXIST;
        DELETE FROM GT_SCP0009_ERP_C_NON;
        DELETE FROM GT_SCP0009_PLAN_SSP;
        DELETE FROM GT_SCP0009_TMP_RSLT_TMP;
        DELETE FROM GT_SCP0009_RSLT_TMP2;
        DELETE FROM GT_SCP0009_TMP_RSLT;
        DELETE FROM GT_SCP0009_TMP_FNL_RSLT_PLAN;

        V_EE_YN := F_IS_EE_DIVISION(P_DIVISION_ID);

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        SELECT MAX(BASIS_START_DATE)
          INTO V_FROM_YYYYMMDD
          FROM SCM_SYS_CALENDAR_M
         WHERE 1 = 1
           AND BASIS_YYYYMMDD = P_PLAN_START_YYYYMMDD;

        SELECT MAX(BASIS_START_DATE)
          INTO V_FROM_RESULT
          FROM SCM_SYS_CALENDAR_M
         WHERE 1 = 1
           AND BASIS_YYYYMMDD = P_FROM_YYYYMMDD;

        SELECT MAX(BASIS_START_DATE)
          INTO V_TO_RESULT
          FROM SCM_SYS_CALENDAR_M
         WHERE 1 = 1
           AND BASIS_YYYYMMDD = P_TO_YYYYMMDD;

        IF NVL(V_FROM_YYYYMMDD, ' ') > NVL(V_FROM_RESULT, ' ') THEN
            /* 실적 보여줌 */
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_TO_RESULT   := V_FROM_YYYYMMDD;
        ELSIF NVL(V_FROM_YYYYMMDD, ' ') <= NVL(V_FROM_RESULT, ' ') THEN
            /* 실적 없음 */
            V_RSLT_FLAG   := 'N';
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_FROM_RESULT := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'),  6), 'YYYYMMDD');
            V_TO_RESULT   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
        ELSIF NVL(V_FROM_YYYYMMDD, ' ') > NVL(V_TO_RESULT, ' ') THEN
            V_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
            V_TO_YYYYMMDD   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
            V_FROM_RESULT   := P_FROM_YYYYMMDD;
            V_TO_RESULT     := P_TO_YYYYMMDD;
        ELSIF NVL(V_FROM_YYYYMMDD, ' ') = NVL(V_TO_RESULT, ' ') THEN
            V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
            V_FROM_RESULT := P_FROM_YYYYMMDD;
            V_TO_RESULT   := P_TO_YYYYMMDD;
        END IF;

        /* 2021.11.24 : 체크 시 bucket='daily' 조회
           AS-IS 는 본문이 'DAILY', 타이틀이 'Daily' 로 다르다. 원문 그대로 둔다. */
        IF P_CHK_ALL = 'Y' THEN
            V_BUCKET := 'Daily';
        END IF;

        /* MEASURE 정보 생성 */
        INSERT INTO GT_SCP0009_TMP_MEASURE
        (
            COLUMN_NAME
          , COLUMN_LABEL_NAME
          , MEASURE_ORDER_NO
        )
        SELECT A.COLUMN_NAME
             , A.COLUMN_LABEL_NAME
             , TO_CHAR(NVL(B.SORT_ORDER_NO, A.SORT_ORDER_NO))   AS MEASURE_ORDER_NO
          FROM SCM_MST_SHEET_MEASURE A
             , SCM_MST_TITLESET_USER B
         WHERE A.PROGRAM_ID    = B.PROGRAM_ID(+)
           AND A.SHEET_NAME    = B.SHEET_NAME(+)
           AND A.COLUMN_NAME   = B.COLUMN_NAME(+)
           AND B.PROGRAM_ID(+) = P_PROGRAM_ID
           AND B.SHEET_NAME(+) = P_SHEET_NAME
           AND B.USER_ID(+)    = P_USER_ID
           AND A.PROGRAM_ID    = P_PROGRAM_ID
           AND A.SHEET_NAME    = P_SHEET_NAME
           AND A.VALID_YN      = 'Y'
           AND (V_CNT_USR_MEASURE = 0 OR B.COLUMN_NAME IS NOT NULL);

        /* 기준 정보 생성 - 플랜 시작일자 하루만 조회 한다 */
        /* previous monday
           AS-IS : replace(convert(char(10), dateadd(d, datepart(dw, GETDATE()) * -1 - 5, GETDATE()), 120), '-', '')
           MSSQL 의 datepart(dw) 는 @@DATEFIRST=7(일요일이 1) 기준이라 TRUNC(SYSDATE,'IW') 와 다르다.
           일요일에 한 주가 어긋나므로(AS-IS 는 이번 주 월요일, ISO 는 지난주 월요일) 원문 식을 그대로 옮긴다.
           1900-01-07 은 일요일이므로 MOD(날짜-그날, 7)+1 이 MSSQL 의 datepart(dw) 와 같다. */
        V_MIN_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE) - (MOD(TRUNC(SYSDATE) - DATE '1900-01-07', 7) + 1) - 5, 'YYYYMMDD');

        INSERT INTO GT_SCP0009_BOD_PLAN_H
        (
            DIVISION_ID
          , PLAN_NAME
          , PLAN_TYPE
          , PLAN_SEQ
          , ORG_DIVISION_ID
          , BOD_ID
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , TRANSPORT_MODE
          , LT_TOTAL
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
        )
        SELECT DIVISION_ID
             , PLAN_NAME
             , PLAN_TYPE
             , PLAN_SEQ
             , ORG_DIVISION_ID
             , BOD_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , TRANSPORT_MODE
             , LT_TOTAL
             , FROM_YYYYMMDD
             , TO_YYYYMMDD
          FROM SCP_ANL_BOD_N_V_PLAN_H
         WHERE 1 = 1
           AND PLAN_NAME = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE = P_PLAN_TYPE
           AND PLAN_SEQ  = TO_NUMBER(P_SEQ);

        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SCP0009_BOD_PLAN_H', NO_INVALIDATE => FALSE);

        IF P_PLAN_START_YYYYMMDD >= V_MIN_YYYYMMDD THEN

            INSERT INTO GT_SCP0009_TMP_STD
            (
                DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , BOD_ID
              , MEASURE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , TRANSPORT_MODE
              , LT_DAY
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
            )
            SELECT DISTINCT
                   A.DIVISION_ID
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.BOD_ID
                 , A.MEASURE
                 , B.COLUMN_LABEL_NAME              AS MEASURE_LABEL
                 , B.MEASURE_ORDER_NO               AS MEASURE_ORDER_NO
                 , C.TRANSPORT_MODE
                 , C.LT_TOTAL                       AS LT_DAY
                 , NVL(NULLIF(RTRIM(A.ORIGIN_FROM_DIVISION_ID),''), '/')  AS ORIGIN_FROM_DIVISION_ID
                 , NVL(A.ORIGIN_TO_DIVISION_ID, '-')    AS ORIGIN_TO_DIVISION_ID
                 , NVL(NULLIF(RTRIM(A.ELECTRODE_TYPE),''), '/')           AS ELECTRODE_TYPE
                 , P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE                      AS PLAN_TYPE
                 , P_SEQ                            AS SEQ
              FROM (SELECT DISTINCT
                           IA.DIVISION_ID
                         , IA.BIZ_TYPE
                         , IA.PROJECT_CODE
                         , IA.ITEM_ID
                         , IA.TO_SITE
                         , IA.FROM_SITE
                         , IA.INCOTERMS
                         , IA.BOD_ID
                         , IA.MEASURE
                         , IA.ORIGIN_FROM_DIVISION_ID
                         , IA.ORIGIN_TO_DIVISION_ID
                         , IA.ELECTRODE_TYPE
                      FROM SCP_ANL_SHIPMENT_PLAN_FG IA
                     WHERE 1 = 1
                       /* BOD 2단계 개발 : FROM , TO 변경 */
                       AND IA.YYYYMMDD            >= P_FROM_YYYYMMDD
                       AND IA.YYYYMMDD            <= P_TO_YYYYMMDD
                       AND IA.DIVISION_ID          = P_DIVISION_ID
                       AND IA.BIZ_TYPE             = P_BIZ_TYPE
                       AND IA.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                       AND IA.PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
                       AND IA.PLAN_TYPE            = P_PLAN_TYPE
                       AND IA.SEQ                  = TO_NUMBER(P_SEQ)
                       -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
                       -- AND (P_PROJECT_CODE IS NULL OR IA.PROJECT_CODE   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_PROJECT_CODE, ','))))
                       -- AND (P_ITEM_ID      IS NULL OR IA.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
                       -- AND (P_FROMSITE     IS NULL OR IA.FROM_SITE      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
                       -- AND (P_TOSITE       IS NULL OR IA.TO_SITE        IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_TOSITE, ','))))
                       -- AND (P_ELECTYPE     IS NULL OR IA.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTYPE, ','))))
                       AND (P_PROJECT_CODE IS NULL OR UPPER(TRIM(P_PROJECT_CODE)) = 'ALL' OR IA.PROJECT_CODE   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_PROJECT_CODE, ','))))
                       AND (P_ITEM_ID      IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' OR IA.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
                       AND (P_FROMSITE     IS NULL OR UPPER(TRIM(P_FROMSITE)) = 'ALL' OR IA.FROM_SITE      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
                       AND (P_TOSITE       IS NULL OR UPPER(TRIM(P_TOSITE)) = 'ALL' OR IA.TO_SITE        IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_TOSITE, ','))))
                       AND (P_ELECTYPE     IS NULL OR UPPER(TRIM(P_ELECTYPE)) = 'ALL' OR IA.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTYPE, ','))))
                       -- 2026.10.06 AJS 조회조건 ALL 처리 (END)
                   ) A
                 , GT_SCP0009_TMP_MEASURE B
                 , GT_SCP0009_BOD_PLAN_H C
             WHERE A.MEASURE      = B.COLUMN_NAME
               AND A.DIVISION_ID  = C.DIVISION_ID(+)
               AND A.BOD_ID       = C.BOD_ID(+)
               AND A.FROM_SITE    = C.FROM_SITE(+)
               AND C.PLAN_SEQ(+)  = TO_NUMBER(P_SEQ)
               AND C.PLAN_TYPE(+) = P_PLAN_TYPE
               AND C.PLAN_NAME(+) = P_PLAN_START_YYYYMMDD;

        ELSIF P_PLAN_START_YYYYMMDD < V_MIN_YYYYMMDD THEN

            INSERT INTO GT_SCP0009_TMP_STD
            (
                DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , BOD_ID
              , MEASURE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , TRANSPORT_MODE
              , LT_DAY
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
            )
            SELECT DISTINCT
                   A.DIVISION_ID
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.BOD_ID
                 , A.MEASURE
                 , B.COLUMN_LABEL_NAME              AS MEASURE_LABEL
                 , B.MEASURE_ORDER_NO               AS MEASURE_ORDER_NO
                 , C.TRANSPORT_MODE
                 , C.LT_TOTAL                       AS LT_DAY
                 , NVL(NULLIF(RTRIM(A.ORIGIN_FROM_DIVISION_ID),''), '/')  AS ORIGIN_FROM_DIVISION_ID
                 , NVL(A.ORIGIN_TO_DIVISION_ID, '-')    AS ORIGIN_TO_DIVISION_ID
                 , NVL(NULLIF(RTRIM(A.ELECTRODE_TYPE),''), '/')           AS ELECTRODE_TYPE
                 , P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE                      AS PLAN_TYPE
                 , P_SEQ                            AS SEQ
              FROM (SELECT DISTINCT
                           IA.DIVISION_ID
                         , IA.BIZ_TYPE
                         , IA.PROJECT_CODE
                         , IA.ITEM_ID
                         , IA.TO_SITE
                         , IA.FROM_SITE
                         , IA.INCOTERMS
                         , IA.BOD_ID
                         , IA.MEASURE
                         , IA.ORIGIN_FROM_DIVISION_ID
                         , IA.ORIGIN_TO_DIVISION_ID
                         , IA.ELECTRODE_TYPE
                      FROM HIST_SCP_ANL_SHIPMENT_PLAN_FG IA
                     WHERE 1 = 1
                       AND IA.YYYYMMDD             = P_PLAN_START_YYYYMMDD
                       AND IA.DIVISION_ID          = P_DIVISION_ID
                       AND IA.BIZ_TYPE             = P_BIZ_TYPE
                       AND IA.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                       AND IA.PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
                       AND IA.PLAN_TYPE            = P_PLAN_TYPE
                       AND IA.SEQ                  = TO_NUMBER(P_SEQ)
                       -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
                       -- AND (P_PROJECT_CODE IS NULL OR IA.PROJECT_CODE   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_PROJECT_CODE, ','))))
                       -- AND (P_ITEM_ID      IS NULL OR IA.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
                       -- AND (P_FROMSITE     IS NULL OR IA.FROM_SITE      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
                       -- AND (P_TOSITE       IS NULL OR IA.TO_SITE        IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_TOSITE, ','))))
                       -- AND (P_ELECTYPE     IS NULL OR IA.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTYPE, ','))))
                       AND (P_PROJECT_CODE IS NULL OR UPPER(TRIM(P_PROJECT_CODE)) = 'ALL' OR IA.PROJECT_CODE   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_PROJECT_CODE, ','))))
                       AND (P_ITEM_ID      IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' OR IA.ITEM_ID        IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
                       AND (P_FROMSITE     IS NULL OR UPPER(TRIM(P_FROMSITE)) = 'ALL' OR IA.FROM_SITE      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
                       AND (P_TOSITE       IS NULL OR UPPER(TRIM(P_TOSITE)) = 'ALL' OR IA.TO_SITE        IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_TOSITE, ','))))
                       AND (P_ELECTYPE     IS NULL OR UPPER(TRIM(P_ELECTYPE)) = 'ALL' OR IA.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTYPE, ','))))
                       -- 2026.10.06 AJS 조회조건 ALL 처리 (END)
                   ) A
                 , GT_SCP0009_TMP_MEASURE B
                 , GT_SCP0009_BOD_PLAN_H C
             WHERE A.MEASURE      = B.COLUMN_NAME
               AND A.DIVISION_ID  = C.DIVISION_ID(+)
               AND A.BOD_ID       = C.BOD_ID(+)
               AND A.FROM_SITE    = C.FROM_SITE(+)
               AND C.PLAN_SEQ(+)  = TO_NUMBER(P_SEQ)
               AND C.PLAN_TYPE(+) = P_PLAN_TYPE
               AND C.PLAN_NAME(+) = P_PLAN_START_YYYYMMDD;

        END IF;

        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SCP0009_TMP_STD', NO_INVALIDATE => FALSE);

        /* 0값 데이터로 누락된 MEASURE 를 생성한다. (타이틀이라 수량은 0) */
        INSERT INTO GT_SCP0009_TMP_ADD_MEASURE
        (
            YYYYMMDD
          , DIVISION_ID
          , BIZ_TYPE
          , PROJECT_CODE
          , ITEM_ID
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , MEASURE
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , BOD_ID
          , LT_DAY
          , TRANSPORT_MODE
          , MEASURE_LABEL
          , MEASURE_ORDER_NO
          , ITEM_VALUE
        )
        SELECT NULL                                 AS YYYYMMDD
             , A.DIVISION_ID
             , A.BIZ_TYPE
             , A.PROJECT_CODE
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.MEASURE
             , A.ORIGIN_FROM_DIVISION_ID
             , A.ORIGIN_TO_DIVISION_ID
             , A.ELECTRODE_TYPE
             , A.BOD_ID
             , A.LT_DAY
             , A.TRANSPORT_MODE
             , A.MEASURE_LABEL
             , A.MEASURE_ORDER_NO
             , 0                                    AS ITEM_VALUE
          FROM GT_SCP0009_TMP_STD A
             , GT_SCP0009_TMP_STD B
         WHERE A.DIVISION_ID             = B.DIVISION_ID(+)
           AND A.PROJECT_CODE            = B.PROJECT_CODE(+)
           AND A.ITEM_ID                 = B.ITEM_ID(+)
           AND A.FROM_SITE               = B.FROM_SITE(+)
           AND A.TO_SITE                 = B.TO_SITE(+)
           AND A.MEASURE                 = B.MEASURE(+)
           AND A.ORIGIN_FROM_DIVISION_ID = B.ORIGIN_FROM_DIVISION_ID(+)
           AND A.ORIGIN_TO_DIVISION_ID   = B.ORIGIN_TO_DIVISION_ID(+)
           AND A.ELECTRODE_TYPE          = B.ELECTRODE_TYPE(+)
           AND NVL(A.INCOTERMS, '/')      = NVL(B.INCOTERMS(+), '/')
           AND NVL(A.TRANSPORT_MODE, '/') = NVL(B.TRANSPORT_MODE(+), '/')
           AND NVL(A.BOD_ID, '/')         = NVL(B.BOD_ID(+), '/');   /* BOD 2단계 개발 : 조건 추가 */

        /* ##############################################################################
           기준 날짜 정보 생성 - 조회 날짜 첫번째 일만 입력 한다
           ############################################################################## */
        INSERT INTO GT_SCP0009_ADD_CALENDAR
        (
            YYYYMMDD
          , DIVISION_ID
          , BIZ_TYPE
          , PROJECT_CODE
          , ITEM_ID
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , MEASURE
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , BOD_ID
          , LT_DAY
          , TRANSPORT_MODE
          , MEASURE_LABEL
          , MEASURE_ORDER_NO
          , ITEM_VALUE
        )
        SELECT V_FROM_YYYYMMDD                              AS YYYYMMDD
             , DIVISION_ID
             , BIZ_TYPE
             , PROJECT_CODE
             , ITEM_ID
             , FROM_SITE
             , TO_SITE
             , INCOTERMS
             , CAST(MEASURE AS VARCHAR2(400 CHAR))          AS MEASURE
             , ORIGIN_FROM_DIVISION_ID
             , ORIGIN_TO_DIVISION_ID
             , ELECTRODE_TYPE
             , BOD_ID
             , LT_DAY
             , TRANSPORT_MODE
             , CAST(MEASURE_LABEL AS VARCHAR2(300 CHAR))    AS MEASURE_LABEL
             , MEASURE_ORDER_NO
             , 0                                            AS ITEM_VALUE
          FROM GT_SCP0009_TMP_ADD_MEASURE;

        /* ##########################################################
           INSERT #TMP_SCP0009_STD SHIP_PLAN, SHIP_PLAN_AMEND
           ########################################################## */
        IF P_DIVISION_ID = V_DIV_ENERGY THEN

            INSERT INTO GT_SCP0009_ADD_CALENDAR
            (
                YYYYMMDD
              , DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , FROM_SITE
              , TO_SITE
              , INCOTERMS
              , MEASURE
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , BOD_ID
              , LT_DAY
              , TRANSPORT_MODE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , ITEM_VALUE
            )
            SELECT A.YYYYMMDD
                 , A.DIVISION_ID
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.FROM_SITE
                 , A.TO_SITE
                 , A.INCOTERMS
                 , A.MEASURE
                 , A.ORIGIN_FROM_DIVISION_ID
                 , A.ORIGIN_TO_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , A.BOD_ID
                 , A.LT_DAY
                 , A.TRANSPORT_MODE
                 , B.COLUMN_LABEL_NAME
                 , B.MEASURE_ORDER_NO
                 , A.ITEM_VALUE
              FROM (SELECT IA.YYYYMMDD
                         , IA.DIVISION_ID
                         , IA.BIZ_TYPE
                         , IA.PROJECT_CODE
                         , IA.ITEM_ID
                         , IA.FROM_SITE
                         , IA.TO_SITE
                         , IA.INCOTERMS
                         , CASE WHEN IA.MEASURE = 'SHIP_PLAN'       THEN 'SHIP_PLAN_ENERGY'
                                WHEN IA.MEASURE = 'SHIP_PLAN_AMEND' THEN 'SHIP_PLAN_AMEND_ENERGY'
                                END                                 AS MEASURE
                         , IA.ORIGIN_FROM_DIVISION_ID
                         , IA.ORIGIN_TO_DIVISION_ID
                         , IA.ELECTRODE_TYPE
                         , IA.BOD_ID
                         , IA.LT_DAY
                         , IA.TRANSPORT_MODE
                         , IA.MEASURE_LABEL
                         , IA.MEASURE_ORDER_NO
                         , IA.ITEM_VALUE
                      FROM GT_SCP0009_ADD_CALENDAR IA
                     WHERE IA.MEASURE IN ('SHIP_PLAN', 'SHIP_PLAN_AMEND')
                   ) A
                 , GT_SCP0009_TMP_MEASURE B
             WHERE A.MEASURE = B.COLUMN_NAME(+)
               AND B.COLUMN_NAME IN ('SHIP_PLAN_ENERGY', 'SHIP_PLAN_AMEND_ENERGY');

        END IF;

        /* 최종 Plan Data 생성 */
        INSERT INTO GT_SCP0009_TMP_PLAN
        (
            KEY_IDX
          , DIVISION_ID
          , BIZ_TYPE
          , PROJECT_CODE
          , ITEM_ID
          , FROM_SITE
          , TO_SITE
          , TO_SITE2
          , INCOTERMS
          , MEASURE
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , QTY
          , BOD_ID
          , BOD_FROM_YYYYMMDD
          , BOD_TO_YYYYMMDD
          , LT_DAY
          , TRANSPORT_MODE
          , MEASURE_LABEL
          , MEASURE_ORDER_NO
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , YYYYMMDD
          , YYYYMM
          , ISO_WEEK
        )
        SELECT A.DIVISION_ID || A.BIZ_TYPE || A.PROJECT_CODE || A.ITEM_ID || A.TO_SITE || A.INCOTERMS  AS KEY_IDX
             , A.DIVISION_ID
             , A.BIZ_TYPE
             , A.PROJECT_CODE
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TO_SITE
             , CASE WHEN SUBSTR(A.TO_SITE, -2) = '-S' THEN SUBSTR(A.TO_SITE, 1, LENGTH(RTRIM(A.TO_SITE)) - 2) ELSE A.TO_SITE END  AS TO_SITE2
             , A.INCOTERMS
             , A.MEASURE
             , A.ORIGIN_FROM_DIVISION_ID
             , A.ORIGIN_TO_DIVISION_ID
             , A.ELECTRODE_TYPE
             , A.ITEM_VALUE                     AS QTY
             , A.BOD_ID
             , NVL(NULLIF(RTRIM(C.FROM_YYYYMMDD),''), '/')        AS BOD_FROM_YYYYMMDD   /* BOD 2단계 */
             , NVL(NULLIF(RTRIM(C.TO_YYYYMMDD),''), '/')          AS BOD_TO_YYYYMMDD     /* BOD 2단계 */
             , A.LT_DAY
             , A.TRANSPORT_MODE
             , A.MEASURE_LABEL
             , A.MEASURE_ORDER_NO
             , P_FROM_YYYYMMDD                  AS FROM_YYYYMMDD
             , P_TO_YYYYMMDD                    AS TO_YYYYMMDD
             , P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
             , P_PLAN_TYPE                      AS PLAN_TYPE
             , P_SEQ                            AS SEQ
             , 'D_' || A.YYYYMMDD               AS YYYYMMDD
             , B.BASIS_YYYYMM                   AS YYYYMM
             , SUBSTR(B.BASIS_YYYYMM, -4) || B.ISO_WEEK     AS ISO_WEEK
          FROM GT_SCP0009_ADD_CALENDAR A
             , SCM_SYS_CALENDAR_M B
             , GT_SCP0009_BOD_PLAN_H C
         WHERE A.YYYYMMDD     = B.BASIS_YYYYMMDD
           /* BOD 2단계 : FROM , TO 추가 */
           AND A.BOD_ID       = C.BOD_ID(+)
           AND A.DIVISION_ID  = C.DIVISION_ID(+)
           AND C.PLAN_SEQ(+)  = TO_NUMBER(P_SEQ)
           AND C.PLAN_TYPE(+) = P_PLAN_TYPE
           AND C.PLAN_NAME(+) = P_PLAN_START_YYYYMMDD;

        /* ======================== Result Start =============================== */

        IF V_RSLT_FLAG = 'Y' THEN

            P_LOAD_RESULT_SOURCE(P_DIVISION_ID   => P_DIVISION_ID
                               , P_BIZ_TYPE      => P_BIZ_TYPE
                               , P_FROM_YYYYMMDD => P_FROM_YYYYMMDD
                               , P_TO_YYYYMMDD   => P_TO_YYYYMMDD
                               , P_FROM_RESULT   => V_FROM_RESULT
                               , P_TO_RESULT     => V_TO_RESULT
                               , P_TITLE_YN      => 'Y');

            INSERT INTO GT_SCP0009_TMP_RSLT_TMP
            (
                DIVISION_ID
              , COMPANY_ID
              , TYPE
              , ERP_SO_NO
              , CONFIRM_ID
              , ITEM_ID
              , NICK_NAME
              , FROM_SITE
              , TO_SITE
              , END_CUSTOMER
              , QTY
              , YYYYMMDD
              , TRANSPORT_MODE
              , INCOTERMS
              , ETD_DATE
              , ETA_DATE
              , SHIP_TYPE
              , PROJECT_CODE
            )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID                             AS COMPANY_ID
                 , C.SEGMENT2                               AS TYPE
                 , A.ERP_SO_NO
                 , A.CONFIRM_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID)   AS NICK_NAME
                 , A.FROM_SITE                              AS FROM_SITE
                 , A.TO_SITE                                AS TO_SITE
                 , A.END_CUSTOMER
                 , A.QTY
                 , A.YYYYMMDD                               AS YYYYMMDD
                 , A.TRANSPORT_MODE
                 , A.INCOTERMS
                 , CASE WHEN REGEXP_LIKE(A.ETD_DATE, '^[0-9]{8}$') THEN TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END    AS ETD_DATE
                 , CASE WHEN REGEXP_LIKE(A.ETA_DATE, '^[0-9]{8}$') THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END    AS ETA_DATE
                 , A.SHIP_TYPE
                 , A.PROJECT_CODE
              FROM (
                    SELECT IA.DIVISION_ID                   AS DIVISION_ID
                         , 'E'                              AS TYPE
                         , XA.ERP_SO_NO                     AS ERP_SO_NO
                         , XA.CONFIRM_ID                    AS CONFIRM_ID
                         , XA.ITEM_ID                       AS ITEM_ID
                         , IA.FROM_SITE                     AS FROM_SITE
                         , XA.TO_SITE                       AS TO_SITE
                         , NULL                             AS END_CUSTOMER
                         , SUM(XA.RESULT_QTY)               AS QTY
                         , XA.YYYYMMDD                      AS YYYYMMDD
                         , XA.TRANSPORT_MODE                AS TRANSPORT_MODE
                         , XA.INCOTERMS                     AS INCOTERMS
                         , XA.ETD_DATE                      AS ETD_DATE
                         , XA.ETA_DATE                      AS ETA_DATE
                         , NULL                             AS SHIP_TYPE
                         , XA.PROJECT_CODE                  AS PROJECT_CODE
                      FROM GT_SCP0009_PLAN_SSP IA
                         , GT_SCP0009_ERP_C_EXIST XA
                     WHERE XA.DIVISION_ID = IA.DIVISION_ID
                       AND XA.CONFIRM_ID  = IA.CONFIRM_ID
                       AND XA.YYYYMMDD    = IA.YYYYMMDD
                     GROUP BY IA.DIVISION_ID
                            , XA.ERP_SO_NO
                            , IA.FROM_SITE
                            , XA.TO_SITE
                            , XA.ITEM_ID
                            , XA.TRANSPORT_MODE
                            , XA.INCOTERMS
                            , XA.ETD_DATE
                            , XA.ETA_DATE
                            , XA.YYYYMMDD
                            , XA.CONFIRM_ID
                            , XA.PROJECT_CODE
                    UNION ALL
                    SELECT IA.DIVISION_ID                   AS DIVISION_ID
                         , 'E'                              AS TYPE
                         , XA.ERP_SO_NO                     AS ERP_SO_NO
                         , XA.CONFIRM_ID                    AS CONFIRM_ID
                         , XA.ITEM_ID                       AS ITEM_ID
                         , IA.FROM_SITE                     AS FROM_SITE
                         , XA.TO_SITE                       AS TO_SITE
                         , NULL                             AS END_CUSTOMER
                         , SUM(XA.RESULT_QTY)               AS QTY
                         , XA.YYYYMMDD                      AS YYYYMMDD
                         , XA.TRANSPORT_MODE                AS TRANSPORT_MODE
                         , XA.INCOTERMS                     AS INCOTERMS
                         , XA.ETD_DATE                      AS ETD_DATE
                         , XA.ETA_DATE                      AS ETA_DATE
                         , NULL                             AS SHIP_TYPE
                         , XA.PROJECT_CODE                  AS PROJECT_CODE
                      FROM GT_SCP0009_PLAN_SSP IA
                         , GT_SCP0009_ERP_C_EXIST XA
                     WHERE XA.DIVISION_ID = IA.DIVISION_ID
                       AND XA.CONFIRM_ID  = IA.CONFIRM_ID
                       AND XA.YYYYMMDD   <> IA.YYYYMMDD
                     GROUP BY IA.DIVISION_ID
                            , XA.ERP_SO_NO
                            , IA.FROM_SITE
                            , XA.TO_SITE
                            , XA.ITEM_ID
                            , XA.TRANSPORT_MODE
                            , XA.INCOTERMS
                            , XA.ETD_DATE
                            , XA.ETA_DATE
                            , XA.YYYYMMDD
                            , XA.CONFIRM_ID
                            , XA.PROJECT_CODE
                    UNION ALL
                    SELECT DIVISION_ID                      AS DIVISION_ID
                         , 'E'                              AS TYPE
                         , ERP_SO_NO                        AS ERP_SO_NO
                         , NULL                             AS CONFIRM_ID
                         , ITEM_ID                          AS ITEM_ID
                         , FROM_SITE                        AS FROM_SITE
                         , TO_SITE                          AS TO_SITE
                         , NULL                             AS END_CUSTOMER
                         , QTY                              AS QTY
                         , YYYYMMDD                         AS YYYYMMDD
                         , TRANSPORT_MODE                   AS TRANSPORT_MODE
                         , INCOTERMS                        AS INCOTERMS
                         , ETD_DATE                         AS ETD_DATE
                         , ETA_DATE                         AS ETA_DATE
                         , NULL                             AS SHIP_TYPE
                         , PROJECT_CODE                     AS PROJECT_CODE
                      FROM GT_SCP0009_ERP_C_NON
                    UNION ALL
                    SELECT DIVISION_ID                      AS DIVISION_ID
                         , 'P'                              AS TYPE
                         , ERP_SO_NO                        AS ERP_SO_NO
                         , CONFIRM_ID                       AS CONFIRM_ID
                         , ITEM_ID                          AS ITEM_ID
                         , FROM_SITE                        AS FROM_SITE
                         , TO_SITE                          AS TO_SITE
                         , END_CUSTOMER                     AS END_CUSTOMER
                         , QTY                              AS QTY
                         , YYYYMMDD                         AS YYYYMMDD
                         , TRANSPORT_MODE                   AS TRANSPORT_MODE
                         , INCOTERMS                        AS INCOTERMS
                         , ETD_DATE                         AS ETD_DATE
                         , ETA_DATE                         AS ETA_DATE
                         , NULL                             AS SHIP_TYPE
                         , NULL                             AS PROJECT_CODE
                      FROM GT_SCP0009_PLAN_SSP
                     WHERE 1 = 1
                       AND YYYYMMDD >= V_FROM_RESULT
                       AND YYYYMMDD <  V_TO_RESULT
                   ) A
                 , SCM_MST_SITE B
                 , SCM_ADM_LOOKUP_MASTER_DETAIL C
                 , SSP_MST_MODEL_USER D
             WHERE B.DIVISION_ID     = A.DIVISION_ID
               AND B.SCM_SITE_ID     = A.FROM_SITE
               AND C.SEGMENT1        = A.TYPE
               AND D.DIVISION_ID(+)  = A.DIVISION_ID
               AND D.FROM_SITE(+)    = A.FROM_SITE
               AND D.ITEM_ID(+)      = A.ITEM_ID
               AND D.VALID_YN(+)     = 'Y'
               AND B.OPERATION_GROUP <> 'E'
               AND C.LOOKUP_TYPE     = 'SSP_SHIPMENT_RESULT_TYPE'   /* LOOKUP에 등록된 공정만 */
               AND C.VALID_YN        = 'Y'
               AND A.DIVISION_ID     = P_DIVISION_ID
               AND A.TYPE            = 'E'                          /* Result(ERP) */
               -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
               -- AND (P_FROMSITE IS NULL OR A.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
               -- AND (P_ITEM_ID  IS NULL OR A.ITEM_ID   IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))));
               AND (P_FROMSITE IS NULL OR UPPER(TRIM(P_FROMSITE)) = 'ALL' OR A.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_FROMSITE, ','))))
               AND (P_ITEM_ID  IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' OR A.ITEM_ID   IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))));
               -- 2026.10.06 AJS 조회조건 ALL 처리 (END)

            /* 실적 키 조합만 추려 BOD 이력 사본을 좁힌다 */
            INSERT INTO GT_SCP0009_RSLT_TMP2
            (
                FROM_SITE
              , TO_SITE
              , TRANSPORT_MODE
              , INCOTERMS
              , YYYYMMDD
            )
            SELECT FROM_SITE
                 , TO_SITE
                 , TRANSPORT_MODE
                 , INCOTERMS
                 , YYYYMMDD
              FROM GT_SCP0009_TMP_RSLT_TMP
             GROUP BY FROM_SITE
                    , TO_SITE
                    , TRANSPORT_MODE
                    , INCOTERMS
                    , YYYYMMDD;

            INSERT INTO GT_SCP0009_BOD_PLAN_H0
            (
                DIVISION_ID
              , PLAN_NAME
              , PLAN_TYPE
              , PLAN_SEQ
              , ORG_DIVISION_ID
              , BOD_ID
              , FROM_SITE
              , TO_SITE
              , INCOTERMS
              , TRANSPORT_MODE
              , LT_TOTAL
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
            )
            SELECT A.DIVISION_ID
                 , A.PLAN_NAME
                 , A.PLAN_TYPE
                 , A.PLAN_SEQ
                 , A.ORG_DIVISION_ID
                 , A.BOD_ID
                 , A.FROM_SITE
                 , A.TO_SITE
                 , A.INCOTERMS
                 , A.TRANSPORT_MODE
                 , A.LT_TOTAL
                 , A.FROM_YYYYMMDD
                 , A.TO_YYYYMMDD
              FROM SCP_ANL_BOD_N_V_PLAN_H A
                 , GT_SCP0009_RSLT_TMP2 B
             WHERE A.FROM_SITE      = B.FROM_SITE
               AND A.TO_SITE        = B.TO_SITE
               AND A.TRANSPORT_MODE = B.TRANSPORT_MODE
               AND A.INCOTERMS      = B.INCOTERMS
               AND B.YYYYMMDD      >= A.FROM_YYYYMMDD
               AND B.YYYYMMDD      <= A.TO_YYYYMMDD;

            DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SCP0009_BOD_PLAN_H0', NO_INVALIDATE => FALSE);

            /* Final Result (타이틀이라 수량은 0) */
            INSERT INTO GT_SCP0009_TMP_RSLT
            (
                KEY_IDX
              , DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , FROM_SITE
              , TO_SITE
              , TO_SITE2
              , INCOTERMS
              , MEASURE
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , QTY
              , BOD_ID
              , BOD_FROM_YYYYMMDD
              , BOD_TO_YYYYMMDD
              , LT_DAY
              , TRANSPORT_MODE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              , YYYYMMDD
              , YYYYMM
              , ISO_WEEK
            )
            SELECT A.DIVISION_ID || P_BIZ_TYPE || NVL(NULLIF(RTRIM(A.PROJECT_CODE),''), '/') || NVL(NULLIF(RTRIM(A.ITEM_ID),''), '/') || NVL(NULLIF(RTRIM(A.TO_SITE),''), '/') || NVL(NULLIF(RTRIM(A.INCOTERMS),''), '/')  AS KEY_IDX
                 , A.DIVISION_ID
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.FROM_SITE                      AS FROM_SITE
                 , A.TO_SITE                        AS TO_SITE
                 , CASE WHEN SUBSTR(A.TO_SITE, -2) = '-S' THEN SUBSTR(A.TO_SITE, 1, LENGTH(RTRIM(A.TO_SITE)) - 2) ELSE A.TO_SITE END  AS TO_SITE2
                 , A.INCOTERMS
                 , A.MEASURE
                 , A.DIVISION_ID                    AS ORIGIN_FROM_DIVISION_ID
                 , A.DIVISION_ID                    AS ORIGIN_TO_DIVISION_ID
                 , NVL(NULLIF(RTRIM(D.ELECTRODE_TYPE),''), '/')       AS ELECTRODE_TYPE
                 , A.QTY
                 , NVL(NULLIF(RTRIM(A.BOD_ID),''), '/')               AS BOD_ID
                 , NVL(A.BOD_FROM_YYYYMMDD, '-')    AS BOD_FROM_YYYYMMDD
                 , NVL(A.BOD_TO_YYYYMMDD, '-')      AS BOD_TO_YYYYMMDD
                 , NVL(D.LT_DAY, '-')               AS LT_DAY
                 , A.TRANSPORT_MODE
                 , A.MEASURE_LABEL
                 , NVL(B.MEASURE_ORDER_NO, '-')     AS MEASURE_ORDER_NO
                 , P_FROM_YYYYMMDD                  AS FROM_YYYYMMDD
                 , P_TO_YYYYMMDD                    AS TO_YYYYMMDD
                 , P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE                      AS PLAN_TYPE
                 , P_SEQ                            AS SEQ
                 , 'D_' || A.EXFACTORY_DATE         AS YYYYMMDD
                 , C.BASIS_YYYYMM                   AS YYYYMM
                 , SUBSTR(C.BASIS_YYYYMM, -4) || C.ISO_WEEK     AS ISO_WEEK
              FROM (SELECT IA.DIVISION_ID
                         , P_BIZ_TYPE                       AS BIZ_TYPE
                         , IA.PROJECT_CODE
                         , IA.ITEM_ID
                         , IA.FROM_SITE
                         , IA.TO_SITE
                         , IA.INCOTERMS
                         /* SHIP_PLAN_AMEND 가 SHIP_PLAN 보다 문자열 길어서 TEMP INSERT 시 오류 때문에 순서바꿈 */
                         , 'SHIP_PLAN_AMEND'                AS MEASURE
                         , IA.DIVISION_ID                   AS ORIGIN_FROM_DIVISION_ID
                         , IA.DIVISION_ID                   AS ORIGIN_TO_DIVISION_ID
                         , IA.TRANSPORT_MODE
                         , 'Ship Plan Amend'                AS MEASURE_LABEL
                         , IA.YYYYMMDD                      AS EXFACTORY_DATE
                         , XA.BOD_ID                        AS BOD_ID
                         , XA.FROM_YYYYMMDD                 AS BOD_FROM_YYYYMMDD
                         , XA.TO_YYYYMMDD                   AS BOD_TO_YYYYMMDD
                         , 0                                AS QTY              /* EXFACTORY_QTY */
                      FROM GT_SCP0009_TMP_RSLT_TMP IA
                         , (SELECT CASE WHEN V_EE_YN = 'Y' THEN SA.ORG_DIVISION_ID ELSE SA.DIVISION_ID END  AS JOIN_DIVISION_ID
                                 , SA.FROM_SITE
                                 , SA.TO_SITE
                                 , SA.TRANSPORT_MODE
                                 , SA.INCOTERMS
                                 , SA.FROM_YYYYMMDD
                                 , SA.TO_YYYYMMDD
                                 , SA.BOD_ID
                              FROM GT_SCP0009_BOD_PLAN_H0 SA) XA
                     WHERE IA.DIVISION_ID     = XA.JOIN_DIVISION_ID(+)
                       AND IA.FROM_SITE       = XA.FROM_SITE(+)
                       AND IA.TO_SITE         = XA.TO_SITE(+)
                       AND IA.TRANSPORT_MODE  = XA.TRANSPORT_MODE(+)
                       AND IA.INCOTERMS       = XA.INCOTERMS(+)
                       AND IA.YYYYMMDD       >= XA.FROM_YYYYMMDD(+)
                       AND IA.YYYYMMDD       <= XA.TO_YYYYMMDD(+)
                     GROUP BY IA.DIVISION_ID
                            , IA.PROJECT_CODE
                            , IA.ITEM_ID
                            , IA.FROM_SITE
                            , IA.TO_SITE
                            , IA.INCOTERMS
                            , IA.TRANSPORT_MODE
                            , IA.YYYYMMDD
                            , XA.BOD_ID
                            , XA.FROM_YYYYMMDD
                            , XA.TO_YYYYMMDD
                   ) A
                 , GT_SCP0009_TMP_MEASURE B
                 , SCM_SYS_CALENDAR_M C
                 , GT_SCP0009_TMP_STD D
             WHERE A.MEASURE          = B.COLUMN_NAME
               AND A.EXFACTORY_DATE   = C.BASIS_YYYYMMDD
               AND A.BOD_ID           = D.BOD_ID(+)
               AND A.ITEM_ID          = D.ITEM_ID(+)
               AND A.PROJECT_CODE     = D.PROJECT_CODE(+)
               /* 2021.12.02   LWY */
               AND A.MEASURE          = D.MEASURE(+);

            /* SHIP_PLAN_AMEND -> SHIP_PLAN  Copy....... */
            SELECT MAX(MEASURE_ORDER_NO)
              INTO V_SHIP_PLAN_ORDER_NO
              FROM GT_SCP0009_TMP_MEASURE
             WHERE COLUMN_NAME = 'SHIP_PLAN';

            IF V_SHIP_PLAN_ORDER_NO IS NOT NULL THEN

                INSERT INTO GT_SCP0009_TMP_RSLT
                (
                    KEY_IDX
                  , DIVISION_ID
                  , BIZ_TYPE
                  , PROJECT_CODE
                  , ITEM_ID
                  , FROM_SITE
                  , TO_SITE
                  , TO_SITE2
                  , INCOTERMS
                  , MEASURE
                  , ORIGIN_FROM_DIVISION_ID
                  , ORIGIN_TO_DIVISION_ID
                  , ELECTRODE_TYPE
                  , QTY
                  , BOD_ID
                  , BOD_FROM_YYYYMMDD
                  , BOD_TO_YYYYMMDD
                  , LT_DAY
                  , TRANSPORT_MODE
                  , MEASURE_LABEL
                  , MEASURE_ORDER_NO
                  , FROM_YYYYMMDD
                  , TO_YYYYMMDD
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , YYYYMMDD
                  , YYYYMM
                  , ISO_WEEK
                )
                SELECT KEY_IDX
                     , DIVISION_ID
                     , BIZ_TYPE
                     , PROJECT_CODE
                     , ITEM_ID
                     , FROM_SITE
                     , TO_SITE
                     , TO_SITE2
                     , INCOTERMS
                     , 'SHIP_PLAN'                  /* MEASURE */
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , ELECTRODE_TYPE
                     , QTY
                     , BOD_ID
                     , BOD_FROM_YYYYMMDD
                     , BOD_TO_YYYYMMDD
                     , LT_DAY
                     , TRANSPORT_MODE
                     , 'Ship Plan'                  /* MEASURE LABEL */
                     , V_SHIP_PLAN_ORDER_NO
                     , FROM_YYYYMMDD
                     , TO_YYYYMMDD
                     , PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , SEQ
                     , YYYYMMDD
                     , YYYYMM
                     , ISO_WEEK
                  FROM GT_SCP0009_TMP_RSLT;

            END IF;

        END IF;  /* IF(@v_RSLT_FLAG = 'Y') */

        /* ======================== Result END   =============================== */

        /* RSLT + PLAN
           AS-IS 는 실적이 있을 때만 UNION 으로 합치고, 없으면 #TMP_SCP0009_PLAN 을 그대로 쓴다. */
        IF V_RSLT_FLAG = 'Y' THEN

            V_SOURCE_TABLE := 'GT_SCP0009_TMP_FNL_RSLT_PLAN';

            INSERT INTO GT_SCP0009_TMP_FNL_RSLT_PLAN
            (
                KEY_IDX
              , DIVISION_ID
              , BIZ_TYPE
              , PROJECT_CODE
              , ITEM_ID
              , FROM_SITE
              , TO_SITE
              , TO_SITE2
              , INCOTERMS
              , MEASURE
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , QTY
              , BOD_ID
              , BOD_FROM_YYYYMMDD
              , BOD_TO_YYYYMMDD
              , LT_DAY
              , TRANSPORT_MODE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              , YYYYMMDD
              , YYYYMM
              , ISO_WEEK
            )
            SELECT KEY_IDX
                 , DIVISION_ID
                 , BIZ_TYPE
                 , PROJECT_CODE
                 , ITEM_ID
                 , FROM_SITE
                 , TO_SITE
                 , TO_SITE2
                 , INCOTERMS
                 , MEASURE
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , QTY
                 , BOD_ID
                 , BOD_FROM_YYYYMMDD
                 , BOD_TO_YYYYMMDD
                 , LT_DAY
                 , TRANSPORT_MODE
                 , MEASURE_LABEL
                 , MEASURE_ORDER_NO
                 , FROM_YYYYMMDD
                 , TO_YYYYMMDD
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , YYYYMMDD
                 , YYYYMM
                 , ISO_WEEK
              FROM GT_SCP0009_TMP_PLAN
            UNION
            SELECT KEY_IDX
                 , DIVISION_ID
                 , BIZ_TYPE
                 , PROJECT_CODE
                 , ITEM_ID
                 , FROM_SITE
                 , TO_SITE
                 , TO_SITE2
                 , INCOTERMS
                 , MEASURE
                 , ORIGIN_FROM_DIVISION_ID
                 , ORIGIN_TO_DIVISION_ID
                 , ELECTRODE_TYPE
                 , QTY
                 , BOD_ID
                 , BOD_FROM_YYYYMMDD
                 , BOD_TO_YYYYMMDD
                 , LT_DAY
                 , TRANSPORT_MODE
                 , MEASURE_LABEL
                 , MEASURE_ORDER_NO
                 , FROM_YYYYMMDD
                 , TO_YYYYMMDD
                 , PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , SEQ
                 , YYYYMMDD
                 , YYYYMM
                 , ISO_WEEK
              FROM GT_SCP0009_TMP_RSLT;

            DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SCP0009_TMP_FNL_RSLT_PLAN', NO_INVALIDATE => FALSE);

        ELSE

            V_SOURCE_TABLE := 'GT_SCP0009_TMP_PLAN';

        END IF;

        COMMIT;

        /********************************************************************************
        * PIVOIT처리
        ********************************************************************************/
        P_MAKE_PIVOT_COLUMNS(P_FROM_YYYYMMDD => P_FROM_YYYYMMDD
                           , P_TO_YYYYMMDD   => P_TO_YYYYMMDD
                           , P_BUCKET        => UPPER(V_BUCKET)
                           , P_TITLE_YN      => 'Y'
                           , O_QRY_SUM       => V_QRY_SUM);

        P_MAKE_OUTER_SELECT(P_DIVISION_ID         => P_DIVISION_ID
                          , P_PLAN_START_YYYYMMDD => P_PLAN_START_YYYYMMDD
                          , P_TEAM_ID             => P_TEAM_ID
                          , P_EE_YN               => V_EE_YN
                          , P_SOURCE_TABLE        => V_SOURCE_TABLE
                          , P_QRY_SUM             => V_QRY_SUM
                          , O_SQL                 => V_SQL);

        IF P_DEBUG_MODE = 'T' THEN
            FOR I IN 0 .. TRUNC((DBMS_LOB.GETLENGTH(V_SQL) - 1) / 4000)
            LOOP
                DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(V_SQL, 4000, I * 4000 + 1));
            END LOOP;
        END IF;

        OPEN O_RC1 FOR V_SQL;

        /* 수정가능여부 구간 조회 */
        OPEN O_RC2 FOR
            SELECT 'Y'                              AS IS_EDITABLE
                 , A.PLAN_NAME
                 , A.PLAN_SEQ
                 , A.PLAN_TYPE
                 , A.CONFIRM_FLAG
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_STATUS
                 , A.CONFIRM_YN
                 , A.PLAN_TYPE_SEQ
                 , B.BASIS_START_DATE
                 , TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   AS PLAN_START_DATE
              FROM (SELECT IA.PLAN_NAME
                         , XA.PLAN_SEQ
                         , XA.PLAN_TYPE
                         , SA.CONFIRM_FLAG
                         , IA.PLAN_NAME                         AS PLAN_START_YYYYMMDD
                         , XA.PLAN_STATUS
                         , NVL(XA.CONFIRM_FLAG, 'N')            AS CONFIRM_YN
                         , CASE XA.PLAN_TYPE WHEN 'PR' THEN 0 WHEN 'MA' THEN 1 WHEN 'SE' THEN 2 WHEN 'FN' THEN 3 END  AS PLAN_TYPE_SEQ
                      FROM SCM_MST_PLAN_DETAIL XA
                         , SCM_MST_MODELING YA
                         , SCM_MST_PLAN IA
                         , SCP_PLAN_VERSION_V SA
                     WHERE YA.MODELING_ID  = XA.MODELING_ID
                       AND YA.DIVISION_ID  = XA.DIVISION_ID
                       AND IA.DIVISION_ID  = XA.DIVISION_ID
                       AND IA.PLAN_CYCLE   = YA.PLAN_CYCLE
                       AND IA.PLAN_ID      = XA.PLAN_ID
                       AND XA.DIVISION_ID  = SA.DIVISION_ID
                       AND XA.PLAN_TYPE    = SA.PLAN_TYPE
                       AND XA.PLAN_SEQ     = SA.PLAN_SEQ
                       AND IA.PLAN_NAME    = SA.PLAN_START_YYYYMMDD
                       AND YA.PLAN_CYCLE   = 'WEEKLY'
                       AND XA.PLAN_TYPE    IN ('PR', 'MA', 'SE', 'FN', 'TE')
                       AND XA.DISPLAY_YN   = 'Y'
                       AND XA.DIVISION_ID  = P_DIVISION_ID
                       AND IA.PLAN_NAME    = P_PLAN_START_YYYYMMDD
                   ) A
                 , (SELECT BASIS_START_DATE
                      FROM SCM_SYS_CALENDAR_M
                     WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')) B;

        /* 05/25 FIX 추가관련 */
        OPEN O_RC3 FOR
            SELECT DIVISION_ID || BIZ_TYPE || PROJECT_CODE || ITEM_ID || TO_SITE || INCOTERMS    AS KEY_IDX
                 , FIX_ID
                 , FROM_SITE
                 , INCOTERMS
                 , BOD_ID
                 , 'D_' || YYYYMMDD                 AS YYYYMMDD
              FROM SCP_ANL_SHIPMENT_PLAN_FIX
             WHERE DIVISION_ID = P_DIVISION_ID
               AND BIZ_TYPE    = P_BIZ_TYPE
               AND YYYYMMDD   >= P_FROM_YYYYMMDD
               AND YYYYMMDD   <= P_TO_YYYYMMDD
               -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
               -- AND (P_ITEM_ID      IS NULL OR ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
               AND (P_ITEM_ID      IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' OR ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
               -- 2026.10.06 AJS 조회조건 ALL 처리 (END)
               /* AS-IS 두 번째 조건은 @p_project_code 를 검사하되 대상 컬럼·값이 모두 ITEM 이다. 원문 그대로 둔다. */
               -- 2026.10.06 AJS 조회조건 ALL 처리 (START)
               -- AND (P_PROJECT_CODE IS NULL OR P_ITEM_ID IS NULL OR ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
               AND (P_PROJECT_CODE IS NULL OR UPPER(TRIM(P_PROJECT_CODE)) = 'ALL' OR P_ITEM_ID IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' OR ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
               -- 2026.10.06 AJS 조회조건 ALL 처리 (END)
             ORDER BY KEY_IDX
                    , DIVISION_ID
                    , BIZ_TYPE
                    , ITEM_ID
                    , TO_SITE
                    , PROJECT_CODE
                    , INCOTERMS
                    , FROM_SITE
                    , BOD_ID;

    EXCEPTION
        WHEN OTHERS THEN
            PR_SCM_SYS_LOG_BATCH(P_PROGRAM_NAME  => $$PLSQL_UNIT || '.P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL'
                               , P_LOG_TYPE      => 'ERROR'
                               , P_LOG_COUNT     => NULL
                               , P_LOG_MESSAGE   => SQLERRM
                               , P_DESCRIPTION   => NULL
                               , P_EVENT_DATE    => SYSDATE
                               , P_IN_PARA_DATA  => V_PARA
                               , P_SQL_ERR_CODE  => TO_CHAR(SQLCODE)
                               , P_SQL_ERR_MSG   => SQLERRM
                               , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE;

    END P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL;


    /* ==============================================================================================
       SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING
       ============================================================================================== */
    PROCEDURE P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING
    (
        P_DIVISION_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD       IN  VARCHAR2,
        P_PLAN_TYPE                 IN  VARCHAR2,
        P_SEQ                       IN  NUMBER,
        P_ITEM_ID                   IN  VARCHAR2,
        P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2,
        P_ORIGIN_TO_DIVISION_ID     IN  VARCHAR2,
        P_ELECTRODE_TYPE            IN  VARCHAR2,
        P_BIZ_TYPE                  IN  VARCHAR2,
        P_TO_SITE                   IN  VARCHAR2,
        P_DUEDATE                   IN  VARCHAR2,
        P_PROJECT_CODE              IN  VARCHAR2,
        O_RC1                       OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING
     * Description  : Shipment Plan - pegging 조회
     *===================================================================================================
     *   Date			In Charge		Description
     *===================================================================================================
     * 2018/05/17		KYH				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/07/12		KYH				신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
     * 2018/08/14		YHW				PROJECT CODE 문제로 안나오는 오류 수정(조인조건)
     * 2026.09.11       [MSSQL -> Oracle 전환]
     *
     * EX)
     * EXEC SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING @p_division_id='81', @p_plan_start_yyyymmdd='20180514', @p_plan_type='MA', @p_seq=2,
     *	@p_item_id='ACPP1015U-B1', @p_origin_from_division_id='' , @p_origin_to_division_id='', @p_electrode_type='', @p_biz_type='A', @p_to_site='BAE_US_ENC', @p_duedate='20180528'
     */
    BEGIN

        OPEN O_RC1 FOR
            SELECT A.PEGGING_OPERATION_CODE
                 , B.SEGMENT2                                       AS PEGGING_OPERATION
                 , A.ITEM_ID
                 , NVL(A.ORIGIN_FROM_DIVISION_ID, '-')              AS ORIGIN_FROM_DIVISION_ID
                 , A.FROM_SITE
                 , NVL(A.ORIGIN_TO_DIVISION_ID, '-')                AS ORIGIN_TO_DIVISION_ID
                 , A.TO_SITE
                 , A.DUE_DATE
                 , A.PLAN_START_DATE
                 , A.PLAN_END_DATE
                 , FN_GET_LOOKUP_CODE_DESC('BIZ_TYPE', A.OPERATION_GROUP)   AS OPERATION_GROUP
                 , NVL(A.ELECTRODE_TYPE, '-')                       AS ELECTRODE_TYPE
                 , A.REQUIRED_QTY
                 , A.PLANNED_QTY
                 , A.PROBLEM_TYPE                                   AS PROBLEM_TYPE
                 , A.LPST
                 , A.STOCK_PLAN_LOT_ID
              FROM SCP_ANL_PROBLEM_REPORT_PEGGING A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
             WHERE A.PEGGING_OPERATION_CODE = B.SEGMENT1(+)
               AND B.LOOKUP_TYPE(+)         = 'PEGGING_OPERATION'
               AND FN_SCM_SPLIT(A.ENG_DEMAND_ID, 2, '::') = P_PROJECT_CODE
               AND A.DIVISION_ID            = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD    = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE              = P_PLAN_TYPE
               AND A.SEQ                    = P_SEQ
               /* and a.pegging_operation_code in ('ALLOC','PSHIP','CSHIP','ESHIP') */
               AND A.OPERATION_GROUP        = P_BIZ_TYPE
               AND A.TO_SITE                = P_TO_SITE
               AND A.ITEM_ID                = P_ITEM_ID
               AND A.DUE_DATE               = TO_TIMESTAMP(P_DUEDATE, 'YYYYMMDD')
               /* AND A.ORIGIN_FROM_DIVISION_ID = @p_origin_from_division_id
                  AND A.ORIGIN_TO_DIVISION_ID   = @p_origin_to_division_id
                  AND A.ELECTRODE_TYPE          = @p_electrode_type */
               AND NVL(A.ELECTRODE_TYPE, '-') = NVL(P_ELECTRODE_TYPE, '-');

    END P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING;


    /* ==============================================================================================
       SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM
       ============================================================================================== */
    PROCEDURE P_SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  NUMBER,
        P_ITEM_ID               IN  VARCHAR2,
        P_PROJECT_CODE          IN  VARCHAR2,
        P_TO_SITE               IN  VARCHAR2,
        P_DUEDATE               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM
     * Description  : Shipment Plan - problem 조회
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
    BEGIN

        OPEN O_RC1 FOR
            SELECT PROBLEM_SEQ
                 , ENG_PROBLEM_TYPE
                 , ENG_PROBLEM_DESC
                 , REQUEST_TIME
                 , RESPONSE_TIME
                 , CAST(PROBLEM_QTY AS NUMBER(10))      AS PROBLEM_QTY
                 /* , CREATED_BY
                    , CREATION_DATE
                    , LAST_UPDATED_BY
                    , LAST_UPDATE_DATE */
              FROM SCP_ANL_PROBLEM_REPORT_DESC
             WHERE 1 = 1
               AND FN_SCM_SPLIT(ENG_DEMAND_ID, 1, '::') = P_ITEM_ID
               AND FN_SCM_SPLIT(ENG_DEMAND_ID, 2, '::') = P_PROJECT_CODE
               AND FN_SCM_SPLIT(ENG_DEMAND_ID, 3, '::') = P_TO_SITE
               AND FN_SCM_SPLIT(ENG_DEMAND_ID, 6, '::') = P_DUEDATE
               AND DIVISION_ID          = P_DIVISION_ID
               AND PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
               AND PLAN_TYPE            = P_PLAN_TYPE
               AND SEQ                  = P_SEQ
               /* and REQUEST_TIME = CONVERT(DATETIME , @p_duedate)
                  AND eng_demand_id		= @p_eng_demand_id
                  AND eng_problem_type    = @p_problemtype */
             ORDER BY PROBLEM_SEQ;

    END P_SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM;


    /* ==============================================================================================
       SCP0011_GET_LAST_PLAN_VERSION
       ============================================================================================== */
    PROCEDURE P_SCP0011_GET_LAST_PLAN_VERSION
    (
        P_DIVISION_ID   IN  VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0011_GET_LAST_PLAN_VERSION
     * Description  : 최종 PLAN VERSION 조회
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
        V_PLAN_VERSION  VARCHAR2(100 CHAR);
    BEGIN

        V_PLAN_VERSION := FN_GET_SCP_LAST_PLAN_VERSION_ID(P_DIVISION_ID);

        OPEN O_RC1 FOR
            SELECT FN_SCM_SPLIT(V_PLAN_VERSION, 1, '-')                                     AS PLAN_START_YYYYMMDD
                 , FN_SCM_SPLIT(V_PLAN_VERSION, 2, '-')                                     AS PLAN_TYPE
                 , TO_CHAR(TO_NUMBER(FN_SCM_SPLIT(V_PLAN_VERSION, 3, '-') DEFAULT NULL ON CONVERSION ERROR))    AS PLAN_SEQ
              FROM DUAL;

    END P_SCP0011_GET_LAST_PLAN_VERSION;


    /* ==============================================================================================
       SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX
       ============================================================================================== */
    PROCEDURE P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_FIX
    (
        P_ACTIVE_FLAG               IN  VARCHAR2,
        P_DIVISION_ID               IN  VARCHAR2,
        P_BIZ_TYPE                  IN  VARCHAR2,
        P_ITEM_ID                   IN  VARCHAR2,
        P_TO_SITE                   IN  VARCHAR2,
        P_FROM_SITE                 IN  VARCHAR2,
        P_PROJECT_CODE              IN  VARCHAR2,
        P_INCOTERMS                 IN  VARCHAR2,
        P_BOD_ID                    IN  VARCHAR2,
        P_YYYYMMDD                  IN  VARCHAR2,
        P_QTY                       IN  VARCHAR2,
        P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2,
        P_ORIGIN_TO_DIVISION_ID     IN  VARCHAR2,
        P_ELECTRODE_TYPE            IN  VARCHAR2,
        P_FIX_REASON                IN  VARCHAR2,
        P_USER_ID                   IN  VARCHAR2,
        P_DEBUG_MODE                IN  VARCHAR2 DEFAULT 'F',
        O_RC1                       OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX
     * Description  : SHIPMENT PLAN FG FIX 등록,수정
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2018/05/24   KYH				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/07/19	KYH				신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
        V_ACTIVE_FLAG               VARCHAR2(4000 CHAR);
        V_DIVISION_ID               VARCHAR2(4000 CHAR);
        V_BIZ_TYPE                  VARCHAR2(4000 CHAR);
        V_ITEM_ID                   VARCHAR2(4000 CHAR);
        V_TO_SITE                   VARCHAR2(4000 CHAR);
        V_FROM_SITE                 VARCHAR2(4000 CHAR);
        V_PROJECT_CODE              VARCHAR2(4000 CHAR);
        V_INCOTERMS                 VARCHAR2(4000 CHAR);
        V_BOD_ID                    VARCHAR2(4000 CHAR);
        V_YYYYMMDD                  VARCHAR2(4000 CHAR);
        V_QTY                       VARCHAR2(4000 CHAR);
        V_ORIGIN_FROM_DIVISION_ID   VARCHAR2(4000 CHAR);
        V_ORIGIN_TO_DIVISION_ID     VARCHAR2(4000 CHAR);
        V_ELECTRODE_TYPE            VARCHAR2(4000 CHAR);
        V_FIX_REASON                VARCHAR2(4000 CHAR);
        V_LAST_UPDATED_BY           VARCHAR2(4000 CHAR) := P_USER_ID;
        V_FIX_ID                    VARCHAR2(4000 CHAR);
        V_DELIMITER                 VARCHAR2(1 CHAR) := '^';
        V_MAX_LOOP_CNT              PLS_INTEGER := 0;
        V_MST_LOOP_CNT              PLS_INTEGER := 0;
        V_PK_CNT                    PLS_INTEGER := 0;
        V_SEQ                       NUMBER;
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME              VARCHAR2(150 CHAR) := 'SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX';
        V_LOG_TYPE                  VARCHAR2(30 CHAR);      /* START/END/ERROR/... */
        V_N_LOG_COUNT               PLS_INTEGER := 0;
        V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
        V_DESCRIPTION               VARCHAR2(500 CHAR);
        V_EVENT_DATE                DATE;
        /* 예외처리 변수 설정 */
        V_ERR_CODE                  VARCHAR2(20 CHAR);
        V_ERR_MESSAGE               VARCHAR2(4000 CHAR);
    BEGIN

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        /* 프로시저 LOOP 길이를 판단 */
        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);

        WHILE NVL(LENGTH(P_ACTIVE_FLAG), 0) > 0
          AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            /* @mst_loop_cnt 1증가 */
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG             := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG            , V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID             := SCM_ARR_SPL_VAL(P_DIVISION_ID            , V_DELIMITER, V_MST_LOOP_CNT);
            V_BIZ_TYPE                := SCM_ARR_SPL_VAL(P_BIZ_TYPE               , V_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID                 := SCM_ARR_SPL_VAL(P_ITEM_ID                , V_DELIMITER, V_MST_LOOP_CNT);
            V_TO_SITE                 := SCM_ARR_SPL_VAL(P_TO_SITE                , V_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE               := SCM_ARR_SPL_VAL(P_FROM_SITE              , V_DELIMITER, V_MST_LOOP_CNT);
            V_PROJECT_CODE            := SCM_ARR_SPL_VAL(P_PROJECT_CODE           , V_DELIMITER, V_MST_LOOP_CNT);
            V_INCOTERMS               := SCM_ARR_SPL_VAL(P_INCOTERMS              , V_DELIMITER, V_MST_LOOP_CNT);
            V_BOD_ID                  := SCM_ARR_SPL_VAL(P_BOD_ID                 , V_DELIMITER, V_MST_LOOP_CNT);
            V_YYYYMMDD                := SCM_ARR_SPL_VAL(P_YYYYMMDD               , V_DELIMITER, V_MST_LOOP_CNT);
            V_QTY                     := SCM_ARR_SPL_VAL(P_QTY                    , V_DELIMITER, V_MST_LOOP_CNT);
            V_ORIGIN_FROM_DIVISION_ID := SCM_ARR_SPL_VAL(P_ORIGIN_FROM_DIVISION_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_ORIGIN_TO_DIVISION_ID   := SCM_ARR_SPL_VAL(P_ORIGIN_TO_DIVISION_ID  , V_DELIMITER, V_MST_LOOP_CNT);
            V_ELECTRODE_TYPE          := SCM_ARR_SPL_VAL(P_ELECTRODE_TYPE         , V_DELIMITER, V_MST_LOOP_CNT);
            V_FIX_REASON              := P_FIX_REASON;

            IF P_DEBUG_MODE = 'T' THEN
                DBMS_OUTPUT.PUT_LINE('V_MST_LOOP_CNT = ' || TO_CHAR(V_MST_LOOP_CNT));
                DBMS_OUTPUT.PUT_LINE('=================================================');
                DBMS_OUTPUT.PUT_LINE('V_ACTIVE_FLAG   = ''' || V_ACTIVE_FLAG   || '''');
                DBMS_OUTPUT.PUT_LINE('V_DIVISION_ID   = ''' || V_DIVISION_ID   || '''');
                DBMS_OUTPUT.PUT_LINE('V_BIZ_TYPE      = ''' || V_BIZ_TYPE      || '''');
                DBMS_OUTPUT.PUT_LINE('V_ITEM_ID       = ''' || V_ITEM_ID       || '''');
                DBMS_OUTPUT.PUT_LINE('V_TO_SITE       = ''' || V_TO_SITE       || '''');
                DBMS_OUTPUT.PUT_LINE('V_FROM_SITE     = ''' || V_FROM_SITE     || '''');
                DBMS_OUTPUT.PUT_LINE('V_PROJECT_CODE  = ''' || V_PROJECT_CODE  || '''');
                DBMS_OUTPUT.PUT_LINE('V_INCOTERMS     = ''' || V_INCOTERMS     || '''');
                DBMS_OUTPUT.PUT_LINE('V_BOD_ID        = ''' || V_BOD_ID        || '''');
                DBMS_OUTPUT.PUT_LINE('V_YYYYMMDD      = ''' || V_YYYYMMDD      || '''');
                DBMS_OUTPUT.PUT_LINE('V_QTY           = ''' || V_QTY           || '''');
                DBMS_OUTPUT.PUT_LINE('V_ORIGIN_FROM_DIVISION_ID = ''' || V_ORIGIN_FROM_DIVISION_ID || '''');
                DBMS_OUTPUT.PUT_LINE('V_ORIGIN_TO_DIVISION_ID   = ''' || V_ORIGIN_TO_DIVISION_ID   || '''');
                DBMS_OUTPUT.PUT_LINE('V_ELECTRODE_TYPE          = ''' || V_ELECTRODE_TYPE          || '''');
                DBMS_OUTPUT.PUT_LINE('V_FIX_REASON    = ''' || V_FIX_REASON    || '''');
                DBMS_OUTPUT.PUT_LINE('P_USER_ID       = ''' || P_USER_ID       || '''');
            END IF;

            /* 기존 데이타 존재여부 조회 */
            SELECT COUNT(*)
              INTO V_PK_CNT
              FROM SCP_ANL_SHIPMENT_PLAN_FIX
             WHERE 1 = 1
               AND DIVISION_ID             = V_DIVISION_ID
               AND BIZ_TYPE                = V_BIZ_TYPE
               AND ITEM_ID                 = V_ITEM_ID
               AND TO_SITE                 = V_TO_SITE
               AND FROM_SITE               = V_FROM_SITE
               AND PROJECT_CODE            = V_PROJECT_CODE
               AND INCOTERMS               = V_INCOTERMS
               AND BOD_ID                  = V_BOD_ID
               AND YYYYMMDD                = V_YYYYMMDD
               AND ORIGIN_FROM_DIVISION_ID = V_ORIGIN_FROM_DIVISION_ID
               AND ORIGIN_TO_DIVISION_ID   = V_ORIGIN_TO_DIVISION_ID
               AND ELECTRODE_TYPE          = V_ELECTRODE_TYPE;

            /* 입력, 수정 모드 결정 */
            IF V_ACTIVE_FLAG != 'D' THEN
                IF V_PK_CNT > 0 THEN
                    V_ACTIVE_FLAG := 'M';
                ELSE
                    V_ACTIVE_FLAG := 'I';
                END IF;
            END IF;

            /* FIX_KEY 생성 */
            IF V_ACTIVE_FLAG = 'I' THEN

                SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX.NEXTVAL
                  INTO V_SEQ
                  FROM DUAL;

                V_FIX_ID := 'F' || V_YYYYMMDD || LPAD(TO_CHAR(V_SEQ), 11, '0');

            ELSE

                SELECT MAX(FIX_ID)
                  INTO V_FIX_ID
                  FROM SCP_ANL_SHIPMENT_PLAN_FIX
                 WHERE 1 = 1
                   AND DIVISION_ID             = V_DIVISION_ID
                   AND BIZ_TYPE                = V_BIZ_TYPE
                   AND ITEM_ID                 = V_ITEM_ID
                   AND TO_SITE                 = V_TO_SITE
                   AND FROM_SITE               = V_FROM_SITE
                   AND PROJECT_CODE            = V_PROJECT_CODE
                   AND INCOTERMS               = V_INCOTERMS
                   AND BOD_ID                  = V_BOD_ID
                   AND YYYYMMDD                = V_YYYYMMDD
                   AND ORIGIN_FROM_DIVISION_ID = V_ORIGIN_FROM_DIVISION_ID
                   AND ORIGIN_TO_DIVISION_ID   = V_ORIGIN_TO_DIVISION_ID
                   AND ELECTRODE_TYPE          = V_ELECTRODE_TYPE;

            END IF;

            IF V_QTY IS NULL THEN
                V_QTY := NULL;
            END IF;

            P_FIX_HIST(P_FIX_ID                  => V_FIX_ID
                     , P_DIVISION_ID             => V_DIVISION_ID
                     , P_BIZ_TYPE                => V_BIZ_TYPE
                     , P_ITEM_ID                 => V_ITEM_ID
                     , P_TO_SITE                 => V_TO_SITE
                     , P_FROM_SITE               => V_FROM_SITE
                     , P_PROJECT_CODE            => V_PROJECT_CODE
                     , P_INCOTERMS               => V_INCOTERMS
                     , P_BOD_ID                  => V_BOD_ID
                     , P_YYYYMMDD                => V_YYYYMMDD
                     , P_QTY                     => V_QTY
                     , P_ORIGIN_FROM_DIVISION_ID => V_ORIGIN_FROM_DIVISION_ID
                     , P_ORIGIN_TO_DIVISION_ID   => V_ORIGIN_TO_DIVISION_ID
                     , P_ELECTRODE_TYPE          => V_ELECTRODE_TYPE
                     , P_FIX_REASON              => V_FIX_REASON
                     , P_CREATED_BY              => V_LAST_UPDATED_BY
                     , P_CREATION_DATE           => V_EVENT_DATE
                     , P_LAST_UPDATED_BY         => V_LAST_UPDATED_BY);

            IF V_MST_LOOP_CNT > 0 THEN

                IF V_ACTIVE_FLAG = 'I' THEN

                    INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX
                    (
                        FIX_ID
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
                      , ORIGIN_FROM_DIVISION_ID
                      , ORIGIN_TO_DIVISION_ID
                      , ELECTRODE_TYPE
                      , FIX_REASON
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                    )
                    VALUES
                    (
                        V_FIX_ID
                      , V_DIVISION_ID
                      , V_BIZ_TYPE
                      , V_ITEM_ID
                      , V_TO_SITE
                      , V_FROM_SITE
                      , V_PROJECT_CODE
                      , V_INCOTERMS
                      , V_BOD_ID
                      , V_YYYYMMDD
                      , TO_NUMBER(V_QTY DEFAULT NULL ON CONVERSION ERROR)
                      , V_ORIGIN_FROM_DIVISION_ID
                      , V_ORIGIN_TO_DIVISION_ID
                      , V_ELECTRODE_TYPE
                      , V_FIX_REASON
                      , V_LAST_UPDATED_BY
                      , V_EVENT_DATE
                      , V_LAST_UPDATED_BY
                      , V_EVENT_DATE
                    );

                ELSIF V_ACTIVE_FLAG = 'M' THEN

                    UPDATE SCP_ANL_SHIPMENT_PLAN_FIX
                       SET QTY              = TO_NUMBER(V_QTY DEFAULT NULL ON CONVERSION ERROR)
                         , FIX_REASON       = V_FIX_REASON
                         , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                         , LAST_UPDATE_DATE = V_EVENT_DATE
                     WHERE 1 = 1
                       AND DIVISION_ID             = V_DIVISION_ID
                       AND BIZ_TYPE                = V_BIZ_TYPE
                       AND ITEM_ID                 = V_ITEM_ID
                       AND TO_SITE                 = V_TO_SITE
                       AND FROM_SITE               = V_FROM_SITE
                       AND PROJECT_CODE            = V_PROJECT_CODE
                       AND INCOTERMS               = V_INCOTERMS
                       AND BOD_ID                  = V_BOD_ID
                       AND YYYYMMDD                = V_YYYYMMDD
                       AND ORIGIN_FROM_DIVISION_ID = V_ORIGIN_FROM_DIVISION_ID
                       AND ORIGIN_TO_DIVISION_ID   = V_ORIGIN_TO_DIVISION_ID
                       AND ELECTRODE_TYPE          = V_ELECTRODE_TYPE;

                ELSIF V_ACTIVE_FLAG = 'D' THEN

                    DELETE FROM SCP_ANL_SHIPMENT_PLAN_FIX
                     WHERE DIVISION_ID             = V_DIVISION_ID
                       AND BIZ_TYPE                = V_BIZ_TYPE
                       AND ITEM_ID                 = V_ITEM_ID
                       AND TO_SITE                 = V_TO_SITE
                       AND FROM_SITE               = V_FROM_SITE
                       AND PROJECT_CODE            = V_PROJECT_CODE
                       AND INCOTERMS               = V_INCOTERMS
                       AND BOD_ID                  = V_BOD_ID
                       AND YYYYMMDD                = V_YYYYMMDD
                       AND ORIGIN_FROM_DIVISION_ID = V_ORIGIN_FROM_DIVISION_ID
                       AND ORIGIN_TO_DIVISION_ID   = V_ORIGIN_TO_DIVISION_ID
                       AND ELECTRODE_TYPE          = V_ELECTRODE_TYPE;

                END IF;

            END IF;

        END LOOP;   /* END OF WHILE */

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR
            SELECT 'S'              AS RESULT_CODE
                 , V_MAX_LOOP_CNT   AS RESULT_CNT
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            /* SQLCODE · SQLERRM 은 SQL 문 안에서 바로 쓸 수 없으므로 변수로 받는다 */
            V_ERR_CODE    := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SQLERRM;

            /* AS-IS 는 BEGIN TRAN 없이 돌고 CATCH 에서 IF @@TRANCOUNT > 0 COMMIT WORK 를 한다.
               즉 오류 직전까지 반영된 행을 되돌리지 않는다. 그 동작을 그대로 유지한다. */

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
                V_PROGRAM_NAME
              , 'ERROR'
              , NULL
              , V_ERR_MESSAGE
              , NULL
              , SYSDATE
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
            );

            COMMIT;

            /* error코드, error 메시지 반환 */
            OPEN O_RC1 FOR
                SELECT 'F'                                      AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                  FROM DUAL;

    END P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_FIX;


    /* ==============================================================================================
       SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DATASET
       ============================================================================================== */
    PROCEDURE P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET
    (
        P_SCP0009   IN  T_SCP0009_TAB,
        O_RC1       OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DATASET
     * Description  : SHIPMENT PLAN FG FIX 등록,수정
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019/05/24   yhw				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2021.10.18	khj79			[PJ20209643] 주차 fix 를 위한 @SCP0009.p_bucket_type 컬럼 추가
     * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
        V_MAX_LOOP_CNT      VARCHAR2(50 CHAR);
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DATASET';
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        V_N_LOG_COUNT       PLS_INTEGER := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        V_EVENT_DATE        DATE;
        /* 실행시간 확인용 */
        V_START_TIME        DATE := SYSDATE;
        V_EXEC_TIME         VARCHAR2(10 CHAR) := '';
        V_SCP0009_HIST      T_SCP0009_TAB;
        /* 예외처리 변수 설정 */
        V_ERR_CODE          VARCHAR2(20 CHAR);
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
    BEGIN

        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0009_FIX;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        INSERT INTO GT_SCP0009_FIX
        (
            P_ACTIVE_FLAG
          , P_DIVISION_ID
          , P_PLAN_START_YYYYMMDD
          , P_PLAN_TYPE
          , P_SEQ
          , P_BIZ_TYPE
          , P_ITEM_ID
          , P_TO_SITE
          , P_FROM_SITE
          , P_PROJECT_CODE
          , P_INCOTERMS
          , P_BOD_ID
          , P_YYYYMMDD
          , P_QTY
          , P_ORIGIN_FROM_DIVISION_ID
          , P_ORIGIN_TO_DIVISION_ID
          , P_ELECTRODE_TYPE
          , P_FIX_REASON
          , P_BUCKET_TYPE
          , P_USER_ID
          , DEBUG_MODE
          , FIX_ID
        )
        SELECT P_ACTIVE_FLAG
             , P_DIVISION_ID
             , P_PLAN_START_YYYYMMDD     /* 2021.10.18 : 주차 fix 를 위한 컬럼 추가 */
             , P_PLAN_TYPE               /* 2021.10.18 : 주차 fix 를 위한 컬럼 추가 */
             , P_SEQ                     /* 2021.10.18 : 주차 fix 를 위한 컬럼 추가 */
             , P_BIZ_TYPE
             , P_ITEM_ID
             , P_TO_SITE
             , P_FROM_SITE
             , P_PROJECT_CODE
             , P_INCOTERMS
             , P_BOD_ID
             , P_YYYYMMDD
             , P_QTY
             , P_ORIGIN_FROM_DIVISION_ID
             , P_ORIGIN_TO_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_FIX_REASON
             , P_BUCKET_TYPE             /* 2021.10.18 : 주차 fix 를 위한 @SCP0009.p_bucket_type 컬럼 추가 */
             , P_LAST_UPDATED_BY
             , DEBUG_MODE
             , NULL
          FROM TABLE(P_SCP0009);

        /* 2021.10.18 : 주차 fix UI 에서 fix 처리 시 0 으로 전달. SCP_ANL_SHIPMENT_PLAN_FG 값으로 update 한다 */
        UPDATE GT_SCP0009_FIX A
           SET A.P_QTY = (SELECT TO_CHAR(MAX(B.QTY))
                            FROM SCP_ANL_SHIPMENT_PLAN_FG B
                           WHERE B.PLAN_START_YYYYMMDD_DATE = TO_DATE(A.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                             AND B.DIVISION_ID         = A.P_DIVISION_ID
                             AND B.PLAN_START_YYYYMMDD = A.P_PLAN_START_YYYYMMDD
                             AND B.PLAN_TYPE           = A.P_PLAN_TYPE
                             AND B.SEQ                 = TO_NUMBER(A.P_SEQ DEFAULT NULL ON CONVERSION ERROR)
                             AND B.YYYYMMDD            = A.P_YYYYMMDD
                             AND B.BIZ_TYPE            = A.P_BIZ_TYPE
                             AND B.ITEM_ID             = A.P_ITEM_ID
                             AND B.PROJECT_CODE        = A.P_PROJECT_CODE
                             AND B.TO_SITE             = A.P_TO_SITE
                             AND B.FROM_SITE           = A.P_FROM_SITE
                             AND B.INCOTERMS           = A.P_INCOTERMS
                             AND B.BOD_ID              = A.P_BOD_ID
                             AND B.MEASURE             = 'SHIP_PLAN_AMEND')
         WHERE A.P_BUCKET_TYPE = 'WEEKLY'
           AND EXISTS (SELECT 1
                         FROM SCP_ANL_SHIPMENT_PLAN_FG IA
                        WHERE IA.PLAN_START_YYYYMMDD_DATE = TO_DATE(A.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                          AND IA.DIVISION_ID         = A.P_DIVISION_ID
                          AND IA.PLAN_START_YYYYMMDD = A.P_PLAN_START_YYYYMMDD
                          AND IA.PLAN_TYPE           = A.P_PLAN_TYPE
                          AND IA.SEQ                 = TO_NUMBER(A.P_SEQ DEFAULT NULL ON CONVERSION ERROR)
                          AND IA.YYYYMMDD            = A.P_YYYYMMDD
                          AND IA.BIZ_TYPE            = A.P_BIZ_TYPE
                          AND IA.ITEM_ID             = A.P_ITEM_ID
                          AND IA.PROJECT_CODE        = A.P_PROJECT_CODE
                          AND IA.TO_SITE             = A.P_TO_SITE
                          AND IA.FROM_SITE           = A.P_FROM_SITE
                          AND IA.INCOTERMS           = A.P_INCOTERMS
                          AND IA.BOD_ID              = A.P_BOD_ID
                          AND IA.MEASURE             = 'SHIP_PLAN_AMEND');

        DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SCP0009_FIX', NO_INVALIDATE => FALSE);

        /* 수정 Row */
        SELECT TO_CHAR(NVL(COUNT(*), 0))
          INTO V_MAX_LOOP_CNT
          FROM GT_SCP0009_FIX;

        /* 입력,수정모드 결정 */
        UPDATE GT_SCP0009_FIX
           SET P_ACTIVE_FLAG = NULL
         WHERE NVL(P_ACTIVE_FLAG, '-') != 'D';

        /* 수정모드 */
        UPDATE GT_SCP0009_FIX B
           SET B.P_ACTIVE_FLAG = 'M'
             , B.FIX_ID        = (SELECT MAX(A.FIX_ID)
                                    FROM SCP_ANL_SHIPMENT_PLAN_FIX A
                                   WHERE A.DIVISION_ID             = B.P_DIVISION_ID
                                     AND A.BIZ_TYPE                = B.P_BIZ_TYPE
                                     AND A.ITEM_ID                 = B.P_ITEM_ID
                                     AND A.TO_SITE                 = B.P_TO_SITE
                                     AND A.FROM_SITE               = B.P_FROM_SITE
                                     AND A.PROJECT_CODE            = B.P_PROJECT_CODE
                                     AND A.INCOTERMS               = B.P_INCOTERMS
                                     AND A.BOD_ID                  = B.P_BOD_ID
                                     AND A.YYYYMMDD                = B.P_YYYYMMDD
                                     AND A.ORIGIN_FROM_DIVISION_ID = B.P_ORIGIN_FROM_DIVISION_ID
                                     AND A.ORIGIN_TO_DIVISION_ID   = B.P_ORIGIN_TO_DIVISION_ID
                                     AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-'))
         WHERE NVL(B.P_ACTIVE_FLAG, '-') != 'D'
           AND EXISTS (SELECT 1
                         FROM SCP_ANL_SHIPMENT_PLAN_FIX IA
                        WHERE IA.DIVISION_ID             = B.P_DIVISION_ID
                          AND IA.BIZ_TYPE                = B.P_BIZ_TYPE
                          AND IA.ITEM_ID                 = B.P_ITEM_ID
                          AND IA.TO_SITE                 = B.P_TO_SITE
                          AND IA.FROM_SITE               = B.P_FROM_SITE
                          AND IA.PROJECT_CODE            = B.P_PROJECT_CODE
                          AND IA.INCOTERMS               = B.P_INCOTERMS
                          AND IA.BOD_ID                  = B.P_BOD_ID
                          AND IA.YYYYMMDD                = B.P_YYYYMMDD
                          AND IA.ORIGIN_FROM_DIVISION_ID = B.P_ORIGIN_FROM_DIVISION_ID
                          AND IA.ORIGIN_TO_DIVISION_ID   = B.P_ORIGIN_TO_DIVISION_ID
                          AND NVL(IA.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-'));

        /* 입력모드 */
        UPDATE GT_SCP0009_FIX
           SET P_ACTIVE_FLAG = 'I'
         WHERE P_ACTIVE_FLAG IS NULL;

        /* 입력대상 데이타 FIX_ID 채번 */
        UPDATE GT_SCP0009_FIX
           SET FIX_ID = TO_CHAR(SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX.NEXTVAL)
         WHERE P_ACTIVE_FLAG = 'I';

        UPDATE GT_SCP0009_FIX
           SET FIX_ID = 'F' || P_YYYYMMDD || LPAD(FIX_ID, 11, '0')
         WHERE P_ACTIVE_FLAG = 'I';

        /* 1. 입력 */
        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX
        (
            FIX_ID
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
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , FIX_REASON
          , CREATED_BY
          , CREATION_DATE
          , LAST_UPDATED_BY
          , LAST_UPDATE_DATE
        )
        SELECT FIX_ID
             , P_DIVISION_ID
             , P_BIZ_TYPE
             , P_ITEM_ID
             , P_TO_SITE
             , P_FROM_SITE
             , P_PROJECT_CODE
             , P_INCOTERMS
             , P_BOD_ID
             , P_YYYYMMDD
             , TO_NUMBER(P_QTY DEFAULT NULL ON CONVERSION ERROR)
             , P_ORIGIN_FROM_DIVISION_ID
             , P_ORIGIN_TO_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_FIX_REASON
             , P_USER_ID
             , V_EVENT_DATE
             , P_USER_ID
             , V_EVENT_DATE
          FROM GT_SCP0009_FIX
         WHERE P_ACTIVE_FLAG = 'I';

        /* 2. 수정
           AS-IS 는 UPDATE A SET ... FROM A, B 형태의 조인 UPDATE 다.
           온라인 SQL 에서 MERGE 를 쓰지 않으므로 상관 서브쿼리로 옮긴다. */
        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX A
           SET (A.QTY, A.FIX_REASON, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE)
               = (SELECT TO_NUMBER(B.P_QTY DEFAULT NULL ON CONVERSION ERROR)
                       , B.P_FIX_REASON
                       , B.P_USER_ID
                       , V_EVENT_DATE
                    FROM GT_SCP0009_FIX B
                   WHERE A.DIVISION_ID             = B.P_DIVISION_ID
                     AND A.BIZ_TYPE                = B.P_BIZ_TYPE
                     AND A.ITEM_ID                 = B.P_ITEM_ID
                     AND A.TO_SITE                 = B.P_TO_SITE
                     AND A.FROM_SITE               = B.P_FROM_SITE
                     AND A.PROJECT_CODE            = B.P_PROJECT_CODE
                     AND A.INCOTERMS               = B.P_INCOTERMS
                     AND A.BOD_ID                  = B.P_BOD_ID
                     AND A.YYYYMMDD                = B.P_YYYYMMDD
                     AND A.ORIGIN_FROM_DIVISION_ID = B.P_ORIGIN_FROM_DIVISION_ID
                     AND A.ORIGIN_TO_DIVISION_ID   = B.P_ORIGIN_TO_DIVISION_ID
                     AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-')
                     AND B.P_ACTIVE_FLAG IN ('M')
                     AND ROWNUM = 1)
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0009_FIX IA
                        WHERE A.DIVISION_ID             = IA.P_DIVISION_ID
                          AND A.BIZ_TYPE                = IA.P_BIZ_TYPE
                          AND A.ITEM_ID                 = IA.P_ITEM_ID
                          AND A.TO_SITE                 = IA.P_TO_SITE
                          AND A.FROM_SITE               = IA.P_FROM_SITE
                          AND A.PROJECT_CODE            = IA.P_PROJECT_CODE
                          AND A.INCOTERMS               = IA.P_INCOTERMS
                          AND A.BOD_ID                  = IA.P_BOD_ID
                          AND A.YYYYMMDD                = IA.P_YYYYMMDD
                          AND A.ORIGIN_FROM_DIVISION_ID = IA.P_ORIGIN_FROM_DIVISION_ID
                          AND A.ORIGIN_TO_DIVISION_ID   = IA.P_ORIGIN_TO_DIVISION_ID
                          AND NVL(A.ELECTRODE_TYPE, '-') = NVL(IA.P_ELECTRODE_TYPE, '-')
                          AND IA.P_ACTIVE_FLAG IN ('M'));

        /* 3. Fix History
           2021.10.18 : 주차 fix UI 에서 fix 처리 시 0 으로 전달. 임시 테이블로 이력 테이블 생성 */
        SELECT T_SCP0009_ROW(NULL                        /* A */
                           , P_ACTIVE_FLAG
                           , P_DIVISION_ID
                           , P_PLAN_START_YYYYMMDD
                           , P_PLAN_TYPE
                           , P_SEQ
                           , P_BIZ_TYPE
                           , P_PROJECT_CODE
                           , P_ITEM_ID
                           , P_TO_SITE
                           , P_INCOTERMS
                           , P_FROM_SITE
                           , P_BOD_ID
                           , NULL                        /* P_MEASURE */
                           , P_YYYYMMDD
                           , P_QTY
                           , P_ORIGIN_FROM_DIVISION_ID
                           , P_ORIGIN_TO_DIVISION_ID
                           , P_ELECTRODE_TYPE
                           , P_FIX_REASON
                           , P_BUCKET_TYPE
                           , NULL                        /* P_TRANS_MODE */
                           , P_USER_ID
                           , P_USER_ID
                           , ''
                           , '')
          BULK COLLECT INTO V_SCP0009_HIST
          FROM GT_SCP0009_FIX;

        P_FIX_HIST_DATASET(V_SCP0009_HIST);

        /* 4. 삭제 */
        DELETE FROM SCP_ANL_SHIPMENT_PLAN_FIX A
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0009_FIX B
                        WHERE A.DIVISION_ID             = B.P_DIVISION_ID
                          AND A.BIZ_TYPE                = B.P_BIZ_TYPE
                          AND A.ITEM_ID                 = B.P_ITEM_ID
                          AND A.TO_SITE                 = B.P_TO_SITE
                          AND A.FROM_SITE               = B.P_FROM_SITE
                          AND A.PROJECT_CODE            = B.P_PROJECT_CODE
                          AND A.INCOTERMS               = B.P_INCOTERMS
                          AND A.BOD_ID                  = B.P_BOD_ID
                          AND A.YYYYMMDD                = B.P_YYYYMMDD
                          AND A.ORIGIN_FROM_DIVISION_ID = B.P_ORIGIN_FROM_DIVISION_ID
                          AND A.ORIGIN_TO_DIVISION_ID   = B.P_ORIGIN_TO_DIVISION_ID
                          AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-')
                          AND B.P_ACTIVE_FLAG = 'D');

        V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                    || ':'
                    || LPAD(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
        V_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR
            SELECT 'S'              AS RESULT_CODE
                 , V_MAX_LOOP_CNT   AS RESULT_CNT
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            /* SQLCODE · SQLERRM 은 SQL 문 안에서 바로 쓸 수 없으므로 변수로 받는다 */
            V_ERR_CODE    := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SQLERRM;

            /* AS-IS 는 BEGIN TRAN 없이 돌고 CATCH 에서 IF @@TRANCOUNT > 0 COMMIT WORK 를 한다.
               즉 오류 직전까지 반영된 행을 되돌리지 않는다. 그 동작을 그대로 유지한다. */

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
                V_PROGRAM_NAME
              , 'ERROR'
              , NULL
              , V_ERR_MESSAGE
              , NULL
              , SYSDATE
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
            );

            COMMIT;

            OPEN O_RC1 FOR
                SELECT 'F'                                      AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                  FROM DUAL;

    END P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET;


    /* ==============================================================================================
       SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY
       ============================================================================================== */
    PROCEDURE P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY
    (
        P_SCP0009   IN  T_SCP0009_TAB,
        O_RC1       OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY
     * Description  : ANL SHIPMENT PLAN FG save
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2022/09/07	jahn1501		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 주차별 수량 입력
     * 2022/12/01   jahn1501        PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Parial Weekly 수량 입력 가능하도록 변경
     * 2024/07/04   mrchois         PJ20244573 / LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성		- Weekly로 저장 시에 연도가 바뀌는 W01주차에 정상저장 되도록 변경
     * 2026/07/06	YMH				E20260211-000957 SHIPMENT FG - SHIP PLAN AMEND WEEKLY 입력시 DAILY 환산 문제
     * 2026.09.11   [MSSQL -> Oracle 전환]
     *
     * ※ AS-IS 의 주차 분배 INSERT 는 EXEC(@mEXEC) 동적 SQL 이나, 조립되는 문장이
     *    분배횟수(@ship_count) 3 갈래의 고정 CASE 식이므로 정적 SQL 로 옮긴다.
     */
        V_MAX_LOOP_CNT      VARCHAR2(50 CHAR);
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY';
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        V_N_LOG_COUNT       PLS_INTEGER := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        V_EVENT_DATE        DATE;
        V_TIME_ZONE         VARCHAR2(100 CHAR);
        V_CREATION_DATE     DATE;              /* timezone에 따른 저장위해서 */
        /* 실행시간 확인용 */
        V_START_TIME        DATE := SYSDATE;
        V_EXEC_TIME         VARCHAR2(10 CHAR) := '';
        V_BUCKET            VARCHAR2(50 CHAR) := '';
        /* 주차 분배용 */
        V_MM                VARCHAR2(10 CHAR);
        V_YYYY              VARCHAR2(4 CHAR);
        V_WW                VARCHAR2(2 CHAR);
        V_YYYYWW            VARCHAR2(10 CHAR);
        V_LOTSIZE           NUMBER := 0;
        V_LOTSIZE_TMP       NUMBER;
        V_SHIP_DAYS         PLS_INTEGER := 0;
        V_SHIP_COUNT        PLS_INTEGER := 0;
        V_A                 NUMBER := 1;       /* 나머지 */
        V_C                 NUMBER := 1;       /* 몫 */
        V_SUM               NUMBER := 0;
        V_MO                NUMBER := 0;       /* 몫 */
        V_CNT               PLS_INTEGER := 0;
        V_ROW_CNT           PLS_INTEGER;
        V_ALL_CNT           PLS_INTEGER;
        V_QTY               NUMBER;
        /* 예외처리 변수 설정 */
        V_ERR_CODE          VARCHAR2(20 CHAR);
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
    BEGIN

        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0009_DYNAMIC;
        DELETE FROM GT_SCP0009_LAST_INFO;
        DELETE FROM GT_SCP0009_SHIP_EXIST_DATA;
        DELETE FROM GT_SCP0009_SHIP_EXIST_INFO;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        SELECT MAX(P_BUCKET_TYPE)
          INTO V_BUCKET
          FROM (SELECT P_BUCKET_TYPE
                  FROM TABLE(P_SCP0009)
                 WHERE ROWNUM = 1);

        /* TimeZone set */
        SELECT MAX(P_TIME_ZONE)
          INTO V_TIME_ZONE
          FROM (SELECT P_TIME_ZONE
                  FROM TABLE(P_SCP0009)
                 WHERE ROWNUM = 1);

        IF V_TIME_ZONE IS NULL THEN
            V_TIME_ZONE := 'AS054';
        END IF;

        V_CREATION_DATE := FN_MULTY_TIME(V_TIME_ZONE);

        IF V_BUCKET = 'DAILY' THEN

            /* 임시테이블 데이타 생성 */
            INSERT INTO GT_SCP0009_DYNAMIC
            (
                A
              , P_ACTIVE_FLAG
              , P_DIVISION_ID
              , P_PLAN_START_YYYYMMDD
              , P_PLAN_TYPE
              , P_SEQ
              , P_BIZ_TYPE
              , P_PROJECT_CODE
              , P_ITEM_ID
              , P_TO_SITE
              , P_INCOTERMS
              , P_FROM_SITE
              , P_BOD_ID
              , P_MEASURE
              , P_YYYYMMDD
              , P_QTY
              , P_ORIGIN_FROM_DIVISION_ID
              , P_ORIGIN_TO_DIVISION_ID
              , P_ELECTRODE_TYPE
              , P_CREATED_BY
              , P_LAST_UPDATED_BY
              , P_TIME_ZONE
              , P_CPLT_FLAG
            )
            SELECT A
                 , P_ACTIVE_FLAG
                 , P_DIVISION_ID
                 , P_PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE
                 , P_SEQ
                 , P_BIZ_TYPE
                 , P_PROJECT_CODE
                 , P_ITEM_ID
                 , P_TO_SITE
                 , P_INCOTERMS
                 , P_FROM_SITE
                 , P_BOD_ID
                 , P_MEASURE
                 , P_YYYYMMDD
                 , P_QTY
                 , P_ORIGIN_FROM_DIVISION_ID
                 , P_ORIGIN_TO_DIVISION_ID
                 , P_ELECTRODE_TYPE
                 , P_CREATED_BY
                 , P_LAST_UPDATED_BY
                 , P_TIME_ZONE
                 , NULL
              FROM TABLE(P_SCP0009);

            DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_SCP0009_DYNAMIC', NO_INVALIDATE => FALSE);

            /* 수정 Row */
            SELECT TO_CHAR(NVL(COUNT(*), 0))
              INTO V_MAX_LOOP_CNT
              FROM GT_SCP0009_DYNAMIC;

            /* 1. 수정수량 UPDATE */
            UPDATE SCP_ANL_SHIPMENT_PLAN_FG A
               SET (A.QTY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY)
                   = (SELECT TRUNC(TO_NUMBER(B.P_QTY DEFAULT NULL ON CONVERSION ERROR), 0)
                             /* A.QTY = cast(B.p_qty as int) */
                           , V_CREATION_DATE
                           , B.P_LAST_UPDATED_BY
                        FROM GT_SCP0009_DYNAMIC B
                       WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(B.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                         AND A.DIVISION_ID             = B.P_DIVISION_ID
                         AND A.PLAN_START_YYYYMMDD     = B.P_PLAN_START_YYYYMMDD
                         AND A.PLAN_TYPE               = B.P_PLAN_TYPE
                         AND A.SEQ                     = TO_NUMBER(B.P_SEQ DEFAULT NULL ON CONVERSION ERROR)
                         AND A.BIZ_TYPE                = B.P_BIZ_TYPE
                         AND A.PROJECT_CODE            = B.P_PROJECT_CODE
                         AND A.ITEM_ID                 = B.P_ITEM_ID
                         AND A.TO_SITE                 = B.P_TO_SITE
                         AND A.INCOTERMS               = B.P_INCOTERMS
                         AND A.FROM_SITE               = B.P_FROM_SITE
                         AND A.BOD_ID                  = B.P_BOD_ID
                         AND A.MEASURE                 = B.P_MEASURE
                         AND A.YYYYMMDD                = B.P_YYYYMMDD
                         AND A.ORIGIN_FROM_DIVISION_ID = B.P_ORIGIN_FROM_DIVISION_ID
                         AND A.ORIGIN_TO_DIVISION_ID   = B.P_ORIGIN_TO_DIVISION_ID
                         AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-')
                         AND B.P_ACTIVE_FLAG IN ('M', 'I')
                         AND ROWNUM = 1)
             WHERE EXISTS (SELECT 1
                             FROM GT_SCP0009_DYNAMIC IA
                            WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(IA.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                              AND A.DIVISION_ID             = IA.P_DIVISION_ID
                              AND A.PLAN_START_YYYYMMDD     = IA.P_PLAN_START_YYYYMMDD
                              AND A.PLAN_TYPE               = IA.P_PLAN_TYPE
                              AND A.SEQ                     = TO_NUMBER(IA.P_SEQ DEFAULT NULL ON CONVERSION ERROR)
                              AND A.BIZ_TYPE                = IA.P_BIZ_TYPE
                              AND A.PROJECT_CODE            = IA.P_PROJECT_CODE
                              AND A.ITEM_ID                 = IA.P_ITEM_ID
                              AND A.TO_SITE                 = IA.P_TO_SITE
                              AND A.INCOTERMS               = IA.P_INCOTERMS
                              AND A.FROM_SITE               = IA.P_FROM_SITE
                              AND A.BOD_ID                  = IA.P_BOD_ID
                              AND A.MEASURE                 = IA.P_MEASURE
                              AND A.YYYYMMDD                = IA.P_YYYYMMDD
                              AND A.ORIGIN_FROM_DIVISION_ID = IA.P_ORIGIN_FROM_DIVISION_ID
                              AND A.ORIGIN_TO_DIVISION_ID   = IA.P_ORIGIN_TO_DIVISION_ID
                              AND NVL(A.ELECTRODE_TYPE, '-') = NVL(IA.P_ELECTRODE_TYPE, '-')
                              AND IA.P_ACTIVE_FLAG IN ('M', 'I'));

            UPDATE GT_SCP0009_DYNAMIC B
               SET B.P_CPLT_FLAG = 'Y'
             WHERE B.P_ACTIVE_FLAG IN ('M', 'I')
               AND EXISTS (SELECT 1
                             FROM SCP_ANL_SHIPMENT_PLAN_FG A
                            WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(B.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                              AND A.DIVISION_ID             = B.P_DIVISION_ID
                              AND A.PLAN_START_YYYYMMDD     = B.P_PLAN_START_YYYYMMDD
                              AND A.PLAN_TYPE               = B.P_PLAN_TYPE
                              AND A.SEQ                     = TO_NUMBER(B.P_SEQ DEFAULT NULL ON CONVERSION ERROR)
                              AND A.BIZ_TYPE                = B.P_BIZ_TYPE
                              AND A.PROJECT_CODE            = B.P_PROJECT_CODE
                              AND A.ITEM_ID                 = B.P_ITEM_ID
                              AND A.TO_SITE                 = B.P_TO_SITE
                              AND A.INCOTERMS               = B.P_INCOTERMS
                              AND A.FROM_SITE               = B.P_FROM_SITE
                              AND A.BOD_ID                  = B.P_BOD_ID
                              AND A.MEASURE                 = B.P_MEASURE
                              AND A.YYYYMMDD                = B.P_YYYYMMDD
                              AND A.ORIGIN_FROM_DIVISION_ID = B.P_ORIGIN_FROM_DIVISION_ID
                              AND A.ORIGIN_TO_DIVISION_ID   = B.P_ORIGIN_TO_DIVISION_ID
                              AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-'));

            /* 2. 신규수량 INSERT */
            INSERT INTO SCP_ANL_SHIPMENT_PLAN_FG
            (
                DIVISION_ID
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
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
              /* PLAN_START_YYYYMMDD_DATE 는 가상 컬럼이라 INSERT 대상이 아니다(ORA-54013).
                 PLAN_START_YYYYMMDD 값으로 자동 계산된다. */
            )
            SELECT P_DIVISION_ID
                 , P_PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE
                 , TO_NUMBER(P_SEQ DEFAULT NULL ON CONVERSION ERROR)
                 , P_BIZ_TYPE
                 , P_PROJECT_CODE
                 , P_ITEM_ID
                 , P_TO_SITE
                 , P_INCOTERMS
                 , P_FROM_SITE
                 , P_BOD_ID
                 , P_MEASURE
                 , P_YYYYMMDD
                 /* , cast(p_qty as int) */
                 , TRUNC(TO_NUMBER(P_QTY DEFAULT NULL ON CONVERSION ERROR), 0)
                 , P_ORIGIN_FROM_DIVISION_ID
                 , P_ORIGIN_TO_DIVISION_ID
                 , P_ELECTRODE_TYPE
                 , P_CREATED_BY
                 , V_CREATION_DATE
                 , P_LAST_UPDATED_BY
                 , V_CREATION_DATE
              FROM GT_SCP0009_DYNAMIC
             WHERE P_ACTIVE_FLAG IN ('M', 'I')
               AND P_CPLT_FLAG IS NULL;

            /* 3. 삭제수량 DELETE */
            DELETE FROM SCP_ANL_SHIPMENT_PLAN_FG A
             WHERE EXISTS (SELECT 1
                             FROM GT_SCP0009_DYNAMIC B
                            WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(B.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                              AND A.DIVISION_ID             = B.P_DIVISION_ID
                              AND A.PLAN_START_YYYYMMDD     = B.P_PLAN_START_YYYYMMDD
                              AND A.PLAN_TYPE               = B.P_PLAN_TYPE
                              AND A.SEQ                     = TO_NUMBER(B.P_SEQ DEFAULT NULL ON CONVERSION ERROR)
                              AND A.BIZ_TYPE                = B.P_BIZ_TYPE
                              AND A.PROJECT_CODE            = B.P_PROJECT_CODE
                              AND A.ITEM_ID                 = B.P_ITEM_ID
                              AND A.TO_SITE                 = B.P_TO_SITE
                              AND A.INCOTERMS               = B.P_INCOTERMS
                              AND A.FROM_SITE               = B.P_FROM_SITE
                              AND A.BOD_ID                  = B.P_BOD_ID
                              AND A.MEASURE                 = B.P_MEASURE
                              AND A.YYYYMMDD                = B.P_YYYYMMDD
                              AND A.ORIGIN_FROM_DIVISION_ID = B.P_ORIGIN_FROM_DIVISION_ID
                              AND A.ORIGIN_TO_DIVISION_ID   = B.P_ORIGIN_TO_DIVISION_ID
                              AND A.ELECTRODE_TYPE          = B.P_ELECTRODE_TYPE
                              AND B.P_ACTIVE_FLAG           = 'D');

            /* 4. FIX수량 UPDATE */
            UPDATE SCP_ANL_SHIPMENT_PLAN_FIX A
               SET (A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE)
                   = (SELECT TO_NUMBER(B.P_QTY DEFAULT NULL ON CONVERSION ERROR)
                             /* A.qty = cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int) */
                           , B.P_LAST_UPDATED_BY
                           , V_CREATION_DATE
                        FROM GT_SCP0009_DYNAMIC B
                       WHERE A.DIVISION_ID             = B.P_DIVISION_ID
                         AND A.BIZ_TYPE                = B.P_BIZ_TYPE
                         AND A.ITEM_ID                 = B.P_ITEM_ID
                         AND A.TO_SITE                 = B.P_TO_SITE
                         AND A.FROM_SITE               = B.P_FROM_SITE
                         AND A.PROJECT_CODE            = B.P_PROJECT_CODE
                         AND A.INCOTERMS               = B.P_INCOTERMS
                         AND A.BOD_ID                  = B.P_BOD_ID
                         AND A.YYYYMMDD                = B.P_YYYYMMDD
                         AND A.ORIGIN_FROM_DIVISION_ID = B.P_ORIGIN_FROM_DIVISION_ID
                         AND A.ORIGIN_TO_DIVISION_ID   = B.P_ORIGIN_TO_DIVISION_ID
                         AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-')
                         AND ROWNUM = 1)
             WHERE EXISTS (SELECT 1
                             FROM GT_SCP0009_DYNAMIC IA
                            WHERE A.DIVISION_ID             = IA.P_DIVISION_ID
                              AND A.BIZ_TYPE                = IA.P_BIZ_TYPE
                              AND A.ITEM_ID                 = IA.P_ITEM_ID
                              AND A.TO_SITE                 = IA.P_TO_SITE
                              AND A.FROM_SITE               = IA.P_FROM_SITE
                              AND A.PROJECT_CODE            = IA.P_PROJECT_CODE
                              AND A.INCOTERMS               = IA.P_INCOTERMS
                              AND A.BOD_ID                  = IA.P_BOD_ID
                              AND A.YYYYMMDD                = IA.P_YYYYMMDD
                              AND A.ORIGIN_FROM_DIVISION_ID = IA.P_ORIGIN_FROM_DIVISION_ID
                              AND A.ORIGIN_TO_DIVISION_ID   = IA.P_ORIGIN_TO_DIVISION_ID
                              AND NVL(A.ELECTRODE_TYPE, '-') = NVL(IA.P_ELECTRODE_TYPE, '-'));

            COMMIT;

            /* 5. FIX이력저장 */
            P_FIX_HIST_DATASET(P_SCP0009);

            /* 6. 이력저장 */
            P_FG_HIST_DATASET(P_SCP0009);

        ELSE    /* WEEKLY */

            /* 수정 Row */
            SELECT TO_CHAR(NVL(COUNT(*), 0))
              INTO V_MAX_LOOP_CNT
              FROM TABLE(P_SCP0009);

            FOR CUR IN (SELECT P_DIVISION_ID
                             , P_ITEM_ID
                             , P_FROM_SITE
                             , P_TO_SITE
                             , P_PROJECT_CODE
                             , P_QTY
                             , P_PLAN_TYPE
                             , P_BOD_ID
                             , P_PLAN_START_YYYYMMDD
                             , P_SEQ
                             , P_YYYYMMDD
                             , P_TRANS_MODE
                             , P_LAST_UPDATED_BY
                          FROM TABLE(P_SCP0009))
            LOOP

                DELETE FROM GT_SCP0009_SHIP_EXIST_DATA;
                DELETE FROM GT_SCP0009_SHIP_EXIST_INFO;

                V_QTY := TO_NUMBER(CUR.P_QTY DEFAULT NULL ON CONVERSION ERROR);

                /* 마지막 주차 수량 수정시 에러 대응 20240704 mrchois START */
                V_MM   := SUBSTR(CUR.P_YYYYMMDD, 5, 2);
                V_YYYY := SUBSTR(CUR.P_YYYYMMDD, 1, 4);
                V_WW   := SUBSTR(CUR.P_YYYYMMDD, 7, 2);

                /* 월 마지막주차인경우 다음해 첫주차이므로 ISO_YYYYWW 매칭을 위해 해당년도 + 1 */
                IF V_MM = '12' AND V_WW = '01' THEN
                    V_YYYY := TO_CHAR(TO_NUMBER(V_YYYY) + 1);   /* 해당년도 + 1 */
                END IF;

                /* E20260211-000957 SHIPMENT FG - SHIP PLAN AMEND WEEKLY 입력시 DAILY 환산 문제 */
                IF V_MM = '01' AND V_WW = '53' THEN
                    V_YYYY := TO_CHAR(TO_NUMBER(V_YYYY) - 1);   /* 해당년도 - 1 */
                END IF;

                V_YYYYWW := V_YYYY || SUBSTR(CUR.P_YYYYMMDD, 7, 2);     /* 실적년도주차 */
                /* 마지막 주차 수량 수정시 에러 대응 20240704 mrchois END */

                /* 주차 정보 조회 */
                INSERT INTO GT_SCP0009_SHIP_EXIST_DATA
                (
                    DIVISION_ID
                  , BOD_ID
                  , FROM_SITE
                  , TO_SITE
                  , SHIP_LT_TOTAL
                  , DAYOFWEEK_NM
                  , DAYOFWEEK_CD
                  , EXIST_YN
                  , TRANSPORT_MODE
                  , REMARK
                )
                SELECT DIVISION_ID
                     , BOD_ID
                     , FROM_SITE
                     , TO_SITE
                     , SHIP_LT_TOTAL
                     , DAYOFWEEK                    AS DAYOFWEEK_NM
                     , CASE WHEN DAYOFWEEK = 'DAYS_MON' THEN '2'    /* MON */
                            WHEN DAYOFWEEK = 'DAYS_TUE' THEN '3'    /* TUE */
                            WHEN DAYOFWEEK = 'DAYS_WED' THEN '4'    /* WED */
                            WHEN DAYOFWEEK = 'DAYS_THU' THEN '5'    /* THU */
                            WHEN DAYOFWEEK = 'DAYS_FRI' THEN '6'    /* FRI */
                            WHEN DAYOFWEEK = 'DAYS_SAT' THEN '7'    /* SAT */
                            WHEN DAYOFWEEK = 'DAYS_SUN' THEN '1'    /* SUN */
                            ELSE '' END             AS DAYOFWEEK_CD
                     , EXIST_YN
                     , TRANSPORT_MODE
                     , NULL                         AS REMARK       /* lotsize가 입력 수량보다 클때 분배요일 재지정 */
                  FROM (SELECT DIVISION_ID
                             , BOD_ID
                             , FROM_SITE
                             , TO_SITE
                             , SHIP_LT_TOTAL
                             , TRANSPORT_MODE
                             , DAYS_MON
                             , DAYS_TUE
                             , DAYS_WED
                             , DAYS_THU
                             , DAYS_FRI
                             , DAYS_SAT
                             , DAYS_SUN
                          FROM SCP_MST_BOD_N_V
                         WHERE DIVISION_ID = CUR.P_DIVISION_ID
                           AND BOD_ID      = CUR.P_BOD_ID)
                 UNPIVOT (EXIST_YN FOR DAYOFWEEK
                          IN (DAYS_MON, DAYS_TUE, DAYS_WED, DAYS_THU, DAYS_FRI, DAYS_SAT, DAYS_SUN));

                INSERT INTO GT_SCP0009_SHIP_EXIST_INFO
                (
                    DIVISION_ID
                  , BOD_ID
                  , FROM_SITE
                  , TO_SITE
                  , SHIP_LT_TOTAL
                  , DAYOFWEEK_NM
                  , DAYOFWEEK_CD
                  , EXIST_YN
                  , TRANSPORT_MODE
                  , REMARK
                  , CALENDAR_MONTH
                )
                SELECT A.DIVISION_ID
                     , A.BOD_ID
                     , A.FROM_SITE
                     , A.TO_SITE
                     , A.SHIP_LT_TOTAL
                     , A.DAYOFWEEK_NM
                     , A.DAYOFWEEK_CD
                     , A.EXIST_YN
                     , A.TRANSPORT_MODE
                     , A.REMARK
                     , B.CALENDAR_MONTH
                  FROM GT_SCP0009_SHIP_EXIST_DATA A
                     , SCM_SYS_CALENDAR_M B
                 WHERE TO_NUMBER(A.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) = B.DAYOFWEEK_NO
                   AND B.ISO_YYYYWW = V_YYYYWW;

                /* 분배횟수 */
                SELECT COUNT(*)
                  INTO V_SHIP_COUNT
                  FROM GT_SCP0009_SHIP_EXIST_INFO A
                     , SCM_SYS_CALENDAR_M B
                 WHERE TO_NUMBER(A.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) = B.DAYOFWEEK_NO
                   AND B.ISO_YYYYWW     = V_YYYYWW
                   AND A.EXIST_YN       = 'Y'
                   AND B.CALENDAR_MONTH = V_MM;

                /* 출하 Lot Size
                   AS-IS 는 조회 행이 없으면 직전 루프의 값을 그대로 쓴다. 그 동작을 유지한다. */
                SELECT MAX(LOT_SIZE)
                  INTO V_LOTSIZE_TMP
                  FROM SCP_MST_SHIPMENT_LOT_SIZE
                 WHERE DIVISION_ID    = CUR.P_DIVISION_ID
                   AND ITEM_ID        = CUR.P_ITEM_ID
                   AND FROM_SITE      = CUR.P_FROM_SITE
                   AND TO_SITE        = CUR.P_TO_SITE
                   AND TRANSPORT_MODE = CUR.P_TRANS_MODE
                   AND VALID_YN       = 'Y';

                IF V_LOTSIZE_TMP IS NOT NULL THEN
                    V_LOTSIZE := V_LOTSIZE_TMP;
                END IF;

                IF NVL(V_LOTSIZE, 0) = 0 THEN
                    V_LOTSIZE := 1;
                END IF;

                V_SHIP_DAYS := CASE WHEN V_SHIP_COUNT = 0 THEN 1 ELSE V_SHIP_COUNT END;

                /* 항차분배 계산 (MSSQL 정수 나눗셈이므로 TRUNC 를 쓴다) */
                V_A := CASE WHEN MOD(V_QTY, V_LOTSIZE * V_SHIP_DAYS) = 0 THEN 0
                            ELSE MOD(V_QTY, V_LOTSIZE * V_SHIP_DAYS) END;   /* 나머지 */

                V_CNT := 0;

                /* 입력수량보다 @v_a 같은 경우 (몫이 lotsize보다 작을수없다.) */
                IF V_A = V_QTY THEN

                    V_A         := CASE WHEN V_QTY < V_LOTSIZE THEN 0 ELSE MOD(V_QTY, V_LOTSIZE) END;
                    V_C         := CASE WHEN V_QTY < V_LOTSIZE OR V_SHIP_DAYS = 1 THEN V_QTY
                                        ELSE TRUNC((V_QTY - V_A) / TRUNC(V_QTY / V_LOTSIZE)) END;
                    V_SHIP_DAYS := CASE WHEN V_QTY < V_LOTSIZE THEN 1 ELSE TRUNC(V_QTY / V_LOTSIZE) END;

                    V_ROW_CNT := 2;
                    V_ALL_CNT := 0;

                    WHILE 7 > V_CNT
                    LOOP

                        V_CNT := V_CNT + 1;

                        UPDATE GT_SCP0009_SHIP_EXIST_INFO
                           SET REMARK = 'Y'
                         WHERE DAYOFWEEK_CD   = TO_CHAR(V_ROW_CNT)
                           AND EXIST_YN       = 'Y'
                           AND CALENDAR_MONTH = V_MM;

                        V_ROW_CNT := V_ROW_CNT + 1;

                        IF V_ROW_CNT = 7 THEN
                            V_ROW_CNT := 1;
                        END IF;

                        SELECT COUNT(*)
                          INTO V_ALL_CNT
                          FROM GT_SCP0009_SHIP_EXIST_INFO
                         WHERE REMARK = 'Y';

                        IF V_ALL_CNT = V_SHIP_DAYS THEN

                            UPDATE GT_SCP0009_SHIP_EXIST_INFO
                               SET REMARK = 'N'
                             WHERE REMARK IS NULL;

                            EXIT;

                        END IF;

                    END LOOP;

                ELSE

                    V_C := CASE WHEN V_A = 0 THEN TRUNC(V_QTY / V_SHIP_DAYS)
                                ELSE TRUNC((V_QTY - V_A) / V_SHIP_DAYS) END;

                END IF;

                V_SUM := V_A + V_C;
                V_MO  := V_C;

                /* 분배 결과 적재
                   AS-IS 는 @ship_count 값에 따라 CASE 식을 동적으로 조립한다. 세 갈래를 그대로 옮긴다. */
                IF V_SHIP_COUNT = 1 THEN

                    INSERT INTO GT_SCP0009_LAST_INFO
                    (
                        LT_WEEK
                      , EXIST_YN
                      , BASIS_YYYYMMDD
                      , QTY
                      , DIVISION_ID
                      , BOD_ID
                      , ITEM_ID
                      , PROJECT_CODE
                      , PLAN_TYPE
                      , PLAN_START_YYYYMMDD
                    )
                    SELECT CASE WHEN A.TRANSPORT_MODE = 'TRK' THEN A.DAYOFWEEK_CD ELSE TO_CHAR(A.LT_WEEK) END    AS LT_WEEK
                         , A.EXIST_YN
                         , A.BASIS_YYYYMMDD
                         , CASE WHEN A.DAYOFWEEK_CD IN ('1', '2', '3', '4', '5', '6', '7')
                                THEN CASE WHEN A.EXIST_YN = 'Y'
                                          THEN CASE WHEN A.CALENDAR_MONTH = V_MM THEN V_SUM ELSE 0 END
                                          ELSE 0 END
                                ELSE 0 END                                                                      AS QTY
                         , A.DIVISION_ID
                         , A.BOD_ID
                         , A.ITEM_ID
                         , A.PROJECT_CODE
                         , A.PLAN_TYPE
                         , A.PLAN_START_YYYYMMDD
                      FROM (SELECT X.EXIST_YN
                                 , X.REMARK
                                 , X.DAYOFWEEK_CD
                                 , X.SHIP_LT_TOTAL
                                 , CASE WHEN TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) <= MOD(X.SHIP_LT_TOTAL, 7)
                                        THEN (7 + TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR)) - MOD(X.SHIP_LT_TOTAL, 7)
                                        ELSE TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) - MOD(X.SHIP_LT_TOTAL, 7)
                                        END                             AS LT_WEEK
                                 , X.TRANSPORT_MODE
                                 , X.DIVISION_ID
                                 , X.BOD_ID
                                 , X.FROM_SITE
                                 , X.TO_SITE
                                 , K.BASIS_YYYYMMDD
                                 , K.CALENDAR_MONTH
                                 , CUR.P_ITEM_ID                        AS ITEM_ID
                                 , CUR.P_PROJECT_CODE                   AS PROJECT_CODE
                                 , CUR.P_PLAN_TYPE                      AS PLAN_TYPE
                                 , CUR.P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                                 , ROW_NUMBER() OVER (PARTITION BY X.CALENDAR_MONTH ORDER BY NULL)  AS SEQ
                              FROM GT_SCP0009_SHIP_EXIST_INFO X
                                 , SCM_SYS_CALENDAR_M K
                             WHERE TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) = K.DAYOFWEEK_NO
                               AND K.ISO_YYYYWW     = V_YYYYWW
                               AND X.CALENDAR_MONTH = V_MM
                           ) A;

                ELSIF V_SHIP_COUNT = 0 THEN

                    INSERT INTO GT_SCP0009_LAST_INFO
                    (
                        LT_WEEK
                      , EXIST_YN
                      , BASIS_YYYYMMDD
                      , QTY
                      , DIVISION_ID
                      , BOD_ID
                      , ITEM_ID
                      , PROJECT_CODE
                      , PLAN_TYPE
                      , PLAN_START_YYYYMMDD
                    )
                    SELECT CASE WHEN A.TRANSPORT_MODE = 'TRK' THEN A.DAYOFWEEK_CD ELSE TO_CHAR(A.LT_WEEK) END    AS LT_WEEK
                         , A.EXIST_YN
                         , A.BASIS_YYYYMMDD
                         , CASE WHEN A.DAYOFWEEK_CD IN ('1', '2', '3', '4', '5', '6', '7')
                                THEN CASE WHEN A.CALENDAR_MONTH = V_MM
                                          THEN CASE WHEN A.SEQ = 1 THEN V_SUM ELSE 0 END
                                          ELSE 0 END
                                ELSE 0 END                                                                      AS QTY
                         , A.DIVISION_ID
                         , A.BOD_ID
                         , A.ITEM_ID
                         , A.PROJECT_CODE
                         , A.PLAN_TYPE
                         , A.PLAN_START_YYYYMMDD
                      FROM (SELECT X.EXIST_YN
                                 , X.REMARK
                                 , X.DAYOFWEEK_CD
                                 , X.SHIP_LT_TOTAL
                                 , CASE WHEN TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) <= MOD(X.SHIP_LT_TOTAL, 7)
                                        THEN (7 + TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR)) - MOD(X.SHIP_LT_TOTAL, 7)
                                        ELSE TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) - MOD(X.SHIP_LT_TOTAL, 7)
                                        END                             AS LT_WEEK
                                 , X.TRANSPORT_MODE
                                 , X.DIVISION_ID
                                 , X.BOD_ID
                                 , X.FROM_SITE
                                 , X.TO_SITE
                                 , K.BASIS_YYYYMMDD
                                 , K.CALENDAR_MONTH
                                 , CUR.P_ITEM_ID                        AS ITEM_ID
                                 , CUR.P_PROJECT_CODE                   AS PROJECT_CODE
                                 , CUR.P_PLAN_TYPE                      AS PLAN_TYPE
                                 , CUR.P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                                 , ROW_NUMBER() OVER (PARTITION BY X.CALENDAR_MONTH ORDER BY NULL)  AS SEQ
                              FROM GT_SCP0009_SHIP_EXIST_INFO X
                                 , SCM_SYS_CALENDAR_M K
                             WHERE TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) = K.DAYOFWEEK_NO
                               AND K.ISO_YYYYWW     = V_YYYYWW
                               AND X.CALENDAR_MONTH = V_MM
                           ) A;

                ELSIF V_SHIP_COUNT <> V_SHIP_DAYS THEN

                    /* lotsize 가 입력 수량보다 큰 경우 Remark = 'Y' 로 분배
                       AS-IS 는 DAYOFWEEK_CD = 2 일 때만 달(CALENDAR_MONTH)이 다르면 @v_sum 을 넣고
                       나머지 요일은 0 을 넣는다. */
                    INSERT INTO GT_SCP0009_LAST_INFO
                    (
                        LT_WEEK
                      , EXIST_YN
                      , BASIS_YYYYMMDD
                      , QTY
                      , DIVISION_ID
                      , BOD_ID
                      , ITEM_ID
                      , PROJECT_CODE
                      , PLAN_TYPE
                      , PLAN_START_YYYYMMDD
                    )
                    SELECT CASE WHEN A.TRANSPORT_MODE = 'TRK' THEN A.DAYOFWEEK_CD ELSE TO_CHAR(A.LT_WEEK) END    AS LT_WEEK
                         , A.EXIST_YN
                         , A.BASIS_YYYYMMDD
                         , CASE WHEN A.DAYOFWEEK_CD IN ('1', '2', '3', '4', '5', '6', '7')
                                THEN CASE WHEN A.REMARK = 'Y'
                                          THEN CASE WHEN A.CALENDAR_MONTH = V_MM
                                                    THEN CASE WHEN A.SEQ = 1 THEN V_SUM ELSE V_MO END
                                                    ELSE CASE WHEN A.DAYOFWEEK_CD = '2' THEN V_SUM ELSE 0 END
                                                    END
                                          ELSE 0 END
                                ELSE 0 END                                                                      AS QTY
                         , A.DIVISION_ID
                         , A.BOD_ID
                         , A.ITEM_ID
                         , A.PROJECT_CODE
                         , A.PLAN_TYPE
                         , A.PLAN_START_YYYYMMDD
                      FROM (SELECT X.EXIST_YN
                                 , X.REMARK
                                 , X.DAYOFWEEK_CD
                                 , X.SHIP_LT_TOTAL
                                 , CASE WHEN TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) <= MOD(X.SHIP_LT_TOTAL, 7)
                                        THEN (7 + TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR)) - MOD(X.SHIP_LT_TOTAL, 7)
                                        ELSE TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) - MOD(X.SHIP_LT_TOTAL, 7)
                                        END                             AS LT_WEEK
                                 , X.TRANSPORT_MODE
                                 , X.DIVISION_ID
                                 , X.BOD_ID
                                 , X.FROM_SITE
                                 , X.TO_SITE
                                 , K.BASIS_YYYYMMDD
                                 , K.CALENDAR_MONTH
                                 , CUR.P_ITEM_ID                        AS ITEM_ID
                                 , CUR.P_PROJECT_CODE                   AS PROJECT_CODE
                                 , CUR.P_PLAN_TYPE                      AS PLAN_TYPE
                                 , CUR.P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                                 , ROW_NUMBER() OVER (PARTITION BY X.CALENDAR_MONTH ORDER BY NULL)  AS SEQ
                              FROM GT_SCP0009_SHIP_EXIST_INFO X
                                 , SCM_SYS_CALENDAR_M K
                             WHERE TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) = K.DAYOFWEEK_NO
                               AND K.ISO_YYYYWW     = V_YYYYWW
                               AND X.CALENDAR_MONTH = V_MM
                           ) A;

                ELSE

                    INSERT INTO GT_SCP0009_LAST_INFO
                    (
                        LT_WEEK
                      , EXIST_YN
                      , BASIS_YYYYMMDD
                      , QTY
                      , DIVISION_ID
                      , BOD_ID
                      , ITEM_ID
                      , PROJECT_CODE
                      , PLAN_TYPE
                      , PLAN_START_YYYYMMDD
                    )
                    SELECT CASE WHEN A.TRANSPORT_MODE = 'TRK' THEN A.DAYOFWEEK_CD ELSE TO_CHAR(A.LT_WEEK) END    AS LT_WEEK
                         , A.EXIST_YN
                         , A.BASIS_YYYYMMDD
                         , CASE WHEN A.DAYOFWEEK_CD IN ('1', '2', '3', '4', '5', '6', '7')
                                THEN CASE WHEN A.EXIST_YN = 'Y'
                                          THEN CASE WHEN A.CALENDAR_MONTH = V_MM
                                                    THEN CASE WHEN A.SEQ = 1 THEN V_SUM ELSE V_MO END
                                                    ELSE CASE WHEN A.DAYOFWEEK_CD = '2' THEN V_SUM ELSE 0 END
                                                    END
                                          ELSE 0 END
                                ELSE 0 END                                                                      AS QTY
                         , A.DIVISION_ID
                         , A.BOD_ID
                         , A.ITEM_ID
                         , A.PROJECT_CODE
                         , A.PLAN_TYPE
                         , A.PLAN_START_YYYYMMDD
                      FROM (SELECT X.EXIST_YN
                                 , X.REMARK
                                 , X.DAYOFWEEK_CD
                                 , X.SHIP_LT_TOTAL
                                 , CASE WHEN TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) <= MOD(X.SHIP_LT_TOTAL, 7)
                                        THEN (7 + TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR)) - MOD(X.SHIP_LT_TOTAL, 7)
                                        ELSE TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) - MOD(X.SHIP_LT_TOTAL, 7)
                                        END                             AS LT_WEEK
                                 , X.TRANSPORT_MODE
                                 , X.DIVISION_ID
                                 , X.BOD_ID
                                 , X.FROM_SITE
                                 , X.TO_SITE
                                 , K.BASIS_YYYYMMDD
                                 , K.CALENDAR_MONTH
                                 , CUR.P_ITEM_ID                        AS ITEM_ID
                                 , CUR.P_PROJECT_CODE                   AS PROJECT_CODE
                                 , CUR.P_PLAN_TYPE                      AS PLAN_TYPE
                                 , CUR.P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                                 , ROW_NUMBER() OVER (PARTITION BY X.CALENDAR_MONTH ORDER BY NULL)  AS SEQ
                              FROM GT_SCP0009_SHIP_EXIST_INFO X
                                 , SCM_SYS_CALENDAR_M K
                             WHERE TO_NUMBER(X.DAYOFWEEK_CD DEFAULT NULL ON CONVERSION ERROR) = K.DAYOFWEEK_NO
                               AND K.ISO_YYYYWW     = V_YYYYWW
                               AND X.CALENDAR_MONTH = V_MM
                           ) A;

                END IF;

                /* Daily Update. */
                UPDATE SCP_ANL_SHIPMENT_PLAN_FG A
                   SET (A.QTY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY)
                       = (SELECT B.QTY
                               , NVL(V_CREATION_DATE, SYSDATE)
                               , CUR.P_LAST_UPDATED_BY
                            FROM GT_SCP0009_LAST_INFO B
                           WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(B.PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                             AND A.YYYYMMDD            = B.BASIS_YYYYMMDD
                             AND A.DIVISION_ID         = B.DIVISION_ID
                             AND A.BOD_ID              = B.BOD_ID
                             AND A.PLAN_TYPE           = B.PLAN_TYPE
                             AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                             AND A.PROJECT_CODE        = B.PROJECT_CODE
                             AND A.ITEM_ID             = B.ITEM_ID
                             AND ROWNUM = 1)
                 WHERE A.SEQ     = TO_NUMBER(CUR.P_SEQ DEFAULT NULL ON CONVERSION ERROR)
                   AND A.MEASURE = 'SHIP_PLAN_AMEND'
                   AND EXISTS (SELECT 1
                                 FROM GT_SCP0009_LAST_INFO IA
                                WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(IA.PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                                  AND A.YYYYMMDD            = IA.BASIS_YYYYMMDD
                                  AND A.DIVISION_ID         = IA.DIVISION_ID
                                  AND A.BOD_ID              = IA.BOD_ID
                                  AND A.PLAN_TYPE           = IA.PLAN_TYPE
                                  AND A.PLAN_START_YYYYMMDD = IA.PLAN_START_YYYYMMDD
                                  AND A.PROJECT_CODE        = IA.PROJECT_CODE
                                  AND A.ITEM_ID             = IA.ITEM_ID);

                /* FIX수량 UPDATE */
                UPDATE SCP_ANL_SHIPMENT_PLAN_FIX A
                   SET (A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE)
                       = (SELECT B.QTY
                               , CUR.P_LAST_UPDATED_BY
                               , NVL(V_CREATION_DATE, SYSDATE)
                            FROM GT_SCP0009_LAST_INFO B
                           WHERE A.DIVISION_ID  = B.DIVISION_ID
                             AND A.ITEM_ID      = B.ITEM_ID
                             AND A.PROJECT_CODE = B.PROJECT_CODE
                             AND A.BOD_ID       = B.BOD_ID
                             AND A.YYYYMMDD     = B.BASIS_YYYYMMDD
                             AND ROWNUM = 1)
                 WHERE EXISTS (SELECT 1
                                 FROM GT_SCP0009_LAST_INFO IA
                                WHERE A.DIVISION_ID  = IA.DIVISION_ID
                                  AND A.ITEM_ID      = IA.ITEM_ID
                                  AND A.PROJECT_CODE = IA.PROJECT_CODE
                                  AND A.BOD_ID       = IA.BOD_ID
                                  AND A.YYYYMMDD     = IA.BASIS_YYYYMMDD);
                /* and A.BIZ_TYPE = B.p_biz_type
                   and A.TO_SITE = B.p_to_site
                   and A.FROM_SITE = B.p_from_site
                   and A.INCOTERMS = B.p_incoterms
                   AND A.ORIGIN_FROM_DIVISION_ID = B.p_origin_from_division_id
                   AND A.ORIGIN_TO_DIVISION_ID = B.p_origin_to_division_id
                   AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(B.p_electrode_type,''),'-') */

            END LOOP;

            /* 5. FIX이력저장 */
            P_FIX_HIST_DATASET(P_SCP0009);

            /* 6. 이력저장 */
            P_FG_HIST_DATASET(P_SCP0009);

            COMMIT;

        END IF;

        V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                    || ':'
                    || LPAD(TO_CHAR(MOD(TRUNC((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
        V_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, V_N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR
            SELECT 'S'              AS RESULT_CODE
                 , V_MAX_LOOP_CNT   AS RESULT_CNT
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            /* SQLCODE · SQLERRM 은 SQL 문 안에서 바로 쓸 수 없으므로 변수로 받는다 */
            V_ERR_CODE    := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK;   /* AS-IS : if (xact_state() <> 0) ROLLBACK TRAN - 입력 데이타 롤백 처리 */

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
                V_PROGRAM_NAME
              , 'ERROR'
              , NULL
              , V_ERR_MESSAGE
              , NULL
              , SYSDATE
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
            );

            COMMIT;

            OPEN O_RC1 FOR
                SELECT 'F'                                      AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                  FROM DUAL;

    END P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY;


    /* 2026.10.07 AJS 화면 저장용 JSON 래퍼 추가 (START) */
    /* ==============================================================================================
       F_SCP0009_JSON_TO_COLLECTION
       CLOB(JSON 배열) → T_SCP0009_TAB 변환. 입력이 NULL·빈 CLOB 이면 빈 컬렉션.
       서버(nscm-be)가 컬렉션 IN 인자를 바인딩하지 못해 화면 저장은 JSON 으로 받는다(PKG_DMF0068 과 같은 방식).
       - ERROR ON ERROR : 형식이 깨진 JSON 을 0행(저장 0건 성공)으로 넘기지 않고 오류로 낸다
       - NULL ON EMPTY : 행에 없는 키는 NULL (ERROR ON ERROR 만 두면 빠진 키도 오류가 됨)
       - 칸 길이는 4000 으로 받고 실제 길이 검증은 T_SCP0009_ROW 생성자가 한다(초과 시 오류)
       - RN(배열 순서)으로 정렬해 화면이 보낸 행 순서를 유지한다
       ============================================================================================== */
    FUNCTION F_SCP0009_JSON_TO_COLLECTION
    (
        P_DATA  IN CLOB
    )
    RETURN T_SCP0009_TAB
    IS
        V_TAB  T_SCP0009_TAB := T_SCP0009_TAB();
    BEGIN
        IF P_DATA IS NULL OR DBMS_LOB.GETLENGTH(P_DATA) = 0 THEN
            RETURN V_TAB;
        END IF;

        SELECT T_SCP0009_ROW(A
                           , ACTIVE_FLAG
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
                           , ORIGIN_FROM_DIVISION_ID
                           , ORIGIN_TO_DIVISION_ID
                           , ELECTRODE_TYPE
                           , FIX_REASON
                           , BUCKET_TYPE
                           , TRANS_MODE
                           , CREATED_BY
                           , LAST_UPDATED_BY
                           , TIME_ZONE
                           , DEBUG_MODE)
          BULK COLLECT
          INTO V_TAB
          FROM JSON_TABLE(P_DATA, '$[*]' ERROR ON ERROR
                              COLUMNS (RN                      FOR ORDINALITY
                                     , A                       VARCHAR2(4000 CHAR) PATH '$.a' NULL ON EMPTY
                                     , ACTIVE_FLAG             VARCHAR2(4000 CHAR) PATH '$.activeFlag' NULL ON EMPTY
                                     , DIVISION_ID             VARCHAR2(4000 CHAR) PATH '$.divisionId' NULL ON EMPTY
                                     , PLAN_START_YYYYMMDD     VARCHAR2(4000 CHAR) PATH '$.planStartYyyymmdd' NULL ON EMPTY
                                     , PLAN_TYPE               VARCHAR2(4000 CHAR) PATH '$.planType' NULL ON EMPTY
                                     , SEQ                     VARCHAR2(4000 CHAR) PATH '$.seq' NULL ON EMPTY
                                     , BIZ_TYPE                VARCHAR2(4000 CHAR) PATH '$.bizType' NULL ON EMPTY
                                     , PROJECT_CODE            VARCHAR2(4000 CHAR) PATH '$.projectCode' NULL ON EMPTY
                                     , ITEM_ID                 VARCHAR2(4000 CHAR) PATH '$.itemId' NULL ON EMPTY
                                     , TO_SITE                 VARCHAR2(4000 CHAR) PATH '$.toSite' NULL ON EMPTY
                                     , INCOTERMS               VARCHAR2(4000 CHAR) PATH '$.incoterms' NULL ON EMPTY
                                     , FROM_SITE               VARCHAR2(4000 CHAR) PATH '$.fromSite' NULL ON EMPTY
                                     , BOD_ID                  VARCHAR2(4000 CHAR) PATH '$.bodId' NULL ON EMPTY
                                     , MEASURE                 VARCHAR2(4000 CHAR) PATH '$.measure' NULL ON EMPTY
                                     , YYYYMMDD                VARCHAR2(4000 CHAR) PATH '$.yyyymmdd' NULL ON EMPTY
                                     , QTY                     VARCHAR2(4000 CHAR) PATH '$.qty' NULL ON EMPTY
                                     , ORIGIN_FROM_DIVISION_ID VARCHAR2(4000 CHAR) PATH '$.originFromDivisionId' NULL ON EMPTY
                                     , ORIGIN_TO_DIVISION_ID   VARCHAR2(4000 CHAR) PATH '$.originToDivisionId' NULL ON EMPTY
                                     , ELECTRODE_TYPE          VARCHAR2(4000 CHAR) PATH '$.electrodeType' NULL ON EMPTY
                                     , FIX_REASON              VARCHAR2(4000 CHAR) PATH '$.fixReason' NULL ON EMPTY
                                     , BUCKET_TYPE             VARCHAR2(4000 CHAR) PATH '$.bucketType' NULL ON EMPTY
                                     , TRANS_MODE              VARCHAR2(4000 CHAR) PATH '$.transMode' NULL ON EMPTY
                                     , CREATED_BY              VARCHAR2(4000 CHAR) PATH '$.createdBy' NULL ON EMPTY
                                     , LAST_UPDATED_BY         VARCHAR2(4000 CHAR) PATH '$.lastUpdatedBy' NULL ON EMPTY
                                     , TIME_ZONE               VARCHAR2(4000 CHAR) PATH '$.timeZone' NULL ON EMPTY
                                     , DEBUG_MODE              VARCHAR2(4000 CHAR) PATH '$.debugMode' NULL ON EMPTY))
         ORDER BY RN;

        RETURN V_TAB;
    END F_SCP0009_JSON_TO_COLLECTION;

    /* ==============================================================================================
       P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY_JSON
       Save 버튼용(일·주 저장).
       JSON 을 컬렉션으로 바꿔 P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY 을 호출하고 그 결과(O_RC1)를 그대로 돌려준다.
       COMMIT·ROLLBACK 은 호출되는 프로시저가 처리한다.
       - 입력이 비면 호출하지 않고 RESULT_CODE 'S' · RESULT_CNT '0'
       - 변환 오류(JSON 형식·길이 초과)는 기존 프로시저와 같은 형식의 'F' 결과로 돌려준다
         (HTTP 500 으로 끝나면 화면 공용 처리가 저장 성공으로 표시함)
       ============================================================================================== */
    PROCEDURE P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY_JSON
    (
        P_DATA  IN  CLOB
      , O_RC1   OUT SYS_REFCURSOR    /* RESULT_CODE · RESULT_CNT | ERR_MESSAGE */
    )
    IS
        V_TAB          T_SCP0009_TAB;
        V_ERR_CODE     VARCHAR2(20);
        V_ERR_MESSAGE  VARCHAR2(4000);
    BEGIN
        BEGIN
            V_TAB := F_SCP0009_JSON_TO_COLLECTION(P_DATA);
        EXCEPTION
            WHEN OTHERS THEN
                V_ERR_CODE    := TO_CHAR(SQLCODE);
                V_ERR_MESSAGE := SQLERRM;

                OPEN O_RC1 FOR
                    SELECT 'F'                                      AS RESULT_CODE
                         , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                      FROM DUAL;
                RETURN;
        END;

        IF V_TAB.COUNT = 0 THEN
            OPEN O_RC1 FOR
                SELECT 'S' AS RESULT_CODE
                     , '0' AS RESULT_CNT
                  FROM DUAL;
            RETURN;
        END IF;

        P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY(V_TAB, O_RC1);
    END P_SCP0009_SAVE_ANL_SHIP_PLAN_FG_WEEKLY_JSON;

    /* ==============================================================================================
       P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET_JSON
       Fix/Unfix 버튼용. Fix 는 행마다 activeFlag 'I', Unfix 는 'D'(기존 프로시저가 'D' 일 때만 삭제).
       JSON 을 컬렉션으로 바꿔 P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET 을 호출하고 그 결과(O_RC1)를 그대로 돌려준다.
       COMMIT·ROLLBACK 은 호출되는 프로시저가 처리한다.
       - 입력이 비면 호출하지 않고 RESULT_CODE 'S' · RESULT_CNT '0'
       - 변환 오류(JSON 형식·길이 초과)는 기존 프로시저와 같은 형식의 'F' 결과로 돌려준다
         (HTTP 500 으로 끝나면 화면 공용 처리가 저장 성공으로 표시함)
       ============================================================================================== */
    PROCEDURE P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET_JSON
    (
        P_DATA  IN  CLOB
      , O_RC1   OUT SYS_REFCURSOR    /* RESULT_CODE · RESULT_CNT | ERR_MESSAGE */
    )
    IS
        V_TAB          T_SCP0009_TAB;
        V_ERR_CODE     VARCHAR2(20);
        V_ERR_MESSAGE  VARCHAR2(4000);
    BEGIN
        BEGIN
            V_TAB := F_SCP0009_JSON_TO_COLLECTION(P_DATA);
        EXCEPTION
            WHEN OTHERS THEN
                V_ERR_CODE    := TO_CHAR(SQLCODE);
                V_ERR_MESSAGE := SQLERRM;

                OPEN O_RC1 FOR
                    SELECT 'F'                                      AS RESULT_CODE
                         , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                      FROM DUAL;
                RETURN;
        END;

        IF V_TAB.COUNT = 0 THEN
            OPEN O_RC1 FOR
                SELECT 'S' AS RESULT_CODE
                     , '0' AS RESULT_CNT
                  FROM DUAL;
            RETURN;
        END IF;

        P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET(V_TAB, O_RC1);
    END P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET_JSON;
    /* 2026.10.07 AJS 화면 저장용 JSON 래퍼 추가 (END) */


END PKG_SCP0009;