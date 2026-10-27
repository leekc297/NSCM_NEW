PROCEDURE PR_DM_SSP_SYNC
(
    P_DIVISION_ID   IN  VARCHAR2   /* 사업부 확장에 대비해서 사업부별로 호출하도록 한다. */
)
/* =====================================================================================================
 * Program ID   : PR_DM_SSP_SYNC
 * Description  : SSP 의 출하계획에 BOD를 감안한 매출일자와 MKT FCST 를 동기화함
 * Program History
 *-----------------------------------------------------------------------------------------------------
 *   Date         In Charge     Description
 *-----------------------------------------------------------------------------------------------------
 * 2020.09.16    HWI1993     INITIAL RELEASE [C20200804-000123]업무 정확도 향상을 위한 MKT FCST - SSP 동기화 기능 추가
 * 2021.01.14    HWI1993     [C20210112-000446] [SCM PI팀] 소형사업부 MKT FCST - SSP 동기화 ( 동기화구간 및 일부 수정 )
 * 2021.01.25    KUNI        [C20210126-000023] [SCMPI팀] 소형 MKT FCST & SSP 동기화 시 내/외수 구분자 개선 요청건
 * 2021.02.09    P.C.I       [C20210225-000385] MKT_FCST_CONFIRM Table 생성하여 출하실적/매출실적 매핑
 * 2021.04.20    P.C.I       [C20210420-000162] 매출실적이 없는 데이터만 동기화 대상으로 적용(네팅)
 * 2021.05.26    P.C.I       [C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일)
 * 2021.07.01    HWI1993     [C20210625-000103] SSP - DM 연동 로직 수정 요청의 건
 * 2021.08.24    hwi1993     [pj20209643] bod 유효기간 추가 건
 * 2021.11.23    hwi1993     [C20211122-000433] GSCM SSP - DM간 동기화 대상 중 Pack 제외 요청의 건
 *                           [C20211122-000007]SSP-DM 사내 플랜트 동기화건 수정 요청의 건
 * 2022.01.20    kdw2819     [C20220120-000145] SSP 입력 수량 MKT FCST 미연동 건
 * 2022.04.07    hwi1993     GM JV 작업
 * 2022.07.11    hwi1993     [C20220707-000107] MKT FCST 입력 오류건(carry over 중복오류 )
 * 2022.07.11    hwi1993     [C20220704-000441] 소형수요 간소화 - dom_exp 를 e 로 고정
 * 2022.07.18    hwi1993     [C20220707-000107] 추가 - change_type 조건 추가 ( N:신규생성중, C:확정, P:계획 -- 현재 미사용)
 * 2022.08.19    rosia27     [C20220809-000013] SSP-DM 동기화 로직 정비 요청의 건
 * 2022.09.12    hwi1993     오류 수정
 * 2025.06.23    KANG.H.J    [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.07.06    ZIONEX      [PJ202650304]  NextSCM Migration
 *
 * -- 1. 동기화할 SSP 데이터를 가져온다.
 * -- 2. MKT FCST 와 join 해서 INSERT/UPDATE 한다.
 * -- 3. 네팅 대상 데이터를 가져와서 복사본을 만든다.
 * -- 4. 키값별로 루프를 돌면서 YYYYMMDD 순서대로 네팅처리한다.
 * -- 5. 네팅이 끝난 값을 한꺼번에 UPDATE/INSERT 한다.
 *
 * 주의 : 1. 이 프로시저는 월요일에 돌아간다는 가정이라, 월요일이 아닐 경우 일자를 조정해줘야 함.
 *        2. ERP 실적배치가 끝난 이후에 돌아가야 일요일까지의 실적이 들어온 상태에서 동작하게 됨.
 *
 *  Usage : PR_DM_SSP_SYNC('40')
 *
 *   - 원본 이중 PIVOT(C1~C100/Q1~Q100) 2블록 → PIVOT 없이 GROUP BY + SUM(QTY) + LISTAGG(CONFIRM_ID) 등가재작성.
 * ===================================================================================================== */
IS
    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PR_DM_SSP_SYNC';
    V_LOG_TYPE              VARCHAR2(30 CHAR);
    N_LOG_COUNT             NUMBER(10) := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            DATE;
    N_DELETE_COUNT          NUMBER(10) := 0;
    N_INSERT_COUNT          NUMBER(10) := 0;

    /* 동기화 구간 */
    V_SYNC_DAY_CNT          NUMBER(10);
    V_START_YYYYMMDD        VARCHAR2(8 CHAR);
    V_END_YYYYMMDD          VARCHAR2(8 CHAR);
    V_NET_YN                VARCHAR2(1 CHAR);      /* 네팅작업 처리 여부 */

    /* 네팅 기간 */
    V_NET_START_YYYYMMDD    VARCHAR2(8 CHAR);
    V_NET_END_YYYYMMDD      VARCHAR2(8 CHAR);
    V_NET_START_WEEK_CNT    VARCHAR2(2 CHAR);      /* 네팅시작기간을 몇 주 전부터 시작하는지 */
    V_RESULT_START_YYYYMMDD VARCHAR2(8 CHAR);      /* [C20210225-000385] */
BEGIN

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* 시작 LOG  (END) */
    V_LOG_MESSAGE := NULL;


    DELETE FROM GT_DS_SSP;
    DELETE FROM GT_DS_SSP_SUM;
    DELETE FROM GT_DS_MKT_RESULT;
    DELETE FROM GT_DS_MKT_RESULT_SUM;
    DELETE FROM GT_DS_SHIP_RESULT;
    DELETE FROM GT_DS_SALES_RESULT;

    /* 원본 최상단 주석처리된 LOOKUP 사전조회 블록 (원문 보존, 미실행)
    --BEGIN
    --      SET @V_SYNC_DAY_CNT = 0
    --      SELECT @V_SYNC_DAY_CNT  = SEGMENT2
    --          , @V_START_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
    --      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
    --      WHERE LOOKUP_TYPE = 'DM_SSP_SYNC_OPTION' AND SEGMENT1 = @P_DIVISION_ID AND VALID_YN = 'Y'
    --      IF ( ISNUMERIC(@V_SYNC_DAY_CNT) < 1 OR @V_SYNC_DAY_CNT < 1 )
    --      BEGIN
    --          SET @V_LOG_TYPE = 'END'
    --          SET @V_DESCRIPTION = N'LOOKUP 정보가 없습니다.'
    --          GOTO ERR_RTN
    --      END
    --END
    */

    /* 원본 BEGIN TRAN SALES_SITE_MODEL_PRODUCTION → Oracle 평면 트랜잭션(정상경로 COMMIT / 오류경로 ROLLBACK). */
    BEGIN

        /* ------------------------------------------------------------------------------------------------ */
        /* 1. 동기화할 SSP 데이터를 가져온다. */
        /* ------------------------------------------------------------------------------------------------ */
        V_SYNC_DAY_CNT := 0;
        BEGIN
            /* 동기화구간 ( 금주월요일 부터 시작 ) */
            SELECT SEGMENT2
                 , TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
              INTO V_SYNC_DAY_CNT
                 , V_START_YYYYMMDD
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
             WHERE LOOKUP_TYPE = 'DM_SSP_SYNC_OPTION'
               AND SEGMENT1 = P_DIVISION_ID
               AND VALID_YN = 'Y';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_SYNC_DAY_CNT := 0;
        END;

        /* 원본 ISNUMERIC(@V_SYNC_DAY_CNT)<1 은 INT 변수라 항상 거짓 → V_SYNC_DAY_CNT<1 만 유효 */
        IF ( V_SYNC_DAY_CNT < 1 ) THEN
            /* 원본 @V_LOG_TYPE='INVALID' + GOTO ERR_RTN (아래 대량 DML 건너뛰고 종료부 ERR_RTN 로직에서 ROLLBACK) */
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'LOOKUP 정보가 없습니다.';
        ELSE

            /*            IF ( ISNUMERIC(@V_NET_START_WEEK_CNT) < 1 OR @V_NET_START_WEEK_CNT < 0 ) AND ISNULL(@V_NET_YN,'') = 'Y'
            BEGIN SET @V_LOG_TYPE = 'INVALID' SET @V_DESCRIPTION = N'LOOKUP 정보가 잘못되었습니다.' GOTO ERR_RTN END
            */

            V_END_YYYYMMDD := TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') + (V_SYNC_DAY_CNT - 1), 'YYYYMMDD');

            /* [C20210225-000385] 실적 기준 Start YYYYMMDD (전월1일/1일은 전전월1일) */
            V_RESULT_START_YYYYMMDD :=
                SUBSTR(TO_CHAR(ADD_MONTHS(SYSDATE, CASE WHEN TO_CHAR(SYSDATE, 'DD') = '01' THEN -2 ELSE -1 END), 'YYYYMMDD'), 1, 6) || '01';

            /* [C20210225-000385] 네팅 구간은 실적일 부터 적용 */
            V_NET_START_YYYYMMDD := V_RESULT_START_YYYYMMDD;
            V_NET_END_YYYYMMDD   := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7 - 1, 'YYYYMMDD');

            /* ------------------------------------------------------------------------------------------------ */
            /* Start[C20210225-000385] DM_PLN_MKT_FCST_CONFIRM 데이터 생성 */
            /* ------------------------------------------------------------------------------------------------ */
            DELETE
              FROM DM_PLN_MKT_FCST_CONFIRM
             WHERE DIVISION_ID = P_DIVISION_ID
               /* [C20210528-000332] 동기화 적용일 변경(매출계획일 -> 출하계획일) */
               AND ( ETA          BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
                  OR SHIP_YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD );

            INSERT
              INTO DM_PLN_MKT_FCST_CONFIRM
                 ( DIVISION_ID
                 , CONFIRM_ID
                 , SO_NO
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , PLANT_SITE_ID
                 , ETA
                 , PLAN_QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 , SHIP_YYYYMMDD )
            SELECT
                  A.DIVISION_ID
                , A.CONFIRM_ID
                , NVL(A.ERP_SO_NO, 'X')
                , A.PROJECT_CODE
                , A.TO_SITE
                , A.ITEM_ID
                , 'E' AS DOM_EXP
                , A.FCST_TYPE
                , B.INCOTERMS
                , '#' AS PLANT_SITE_ID
                , A.ETA_DATE    AS ETA
                , SUM(A.QTY)    AS CONFIRM_QTY
                , 'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
                , A.YYYYMMDD  AS SHIP_YYYYMMDD
              FROM SSP_ANL_SHIP_CONFIRM         A
                 , SCP_MST_BOD_N_V              B
                 , SCP_MST_DISTRIBUTION_ROUTE   C
                 , SCM_MST_SITE                 D
             WHERE 1 = 1
               AND A.DIVISION_ID = B.DIVISION_ID
               AND A.BOD_ID = B.BOD_ID
               AND C.ROUTE_ID = B.ROUTE_ID
               AND A.DIVISION_ID = D.DIVISION_ID
               AND A.TO_SITE = D.SCM_SITE_ID
               AND D.SITE_TYPE = 'SALES'
               AND ( A.YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
                  OR A.ETA_DATE BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD )
               AND A.QTY <> 0
               AND A.DIVISION_ID   = P_DIVISION_ID
               AND A.FCST_TYPE <> '-'
               AND A.SHIPMENT_STATUS = 'C'
               AND EXISTS ( SELECT 1
                              FROM DM_MST_ITEM_SINGLE_V E
                             WHERE E.DIVISION_ID = A.DIVISION_ID
                               AND E.ITEM_ID = A.ITEM_ID
                               AND E.FORECAST_INFO_BIZ_TYPE IS NOT NULL )   /* [C20210225-000385] 전극대상 제외 */
               AND A.BIZ_TYPE = 'A'          /* [C20211122-000433] */
               AND A.CHANGE_TYPE = 'C'
             GROUP BY A.DIVISION_ID
                 , A.CONFIRM_ID
                 , A.ERP_SO_NO
                 , A.PROJECT_CODE
                 , A.TO_SITE
                 , A.ITEM_ID
                 , A.FCST_TYPE
                 , B.INCOTERMS
                 , A.ETA_DATE
                 , A.YYYYMMDD;

            /* [C20220704-000441] 소형수요 간소화 - dom_exp 를 e 로 고정 (DOM_EXP 못찾는 경우 E) */
            UPDATE DM_PLN_MKT_FCST_CONFIRM A
               SET A.DOM_EXP = 'E'
             WHERE A.DOM_EXP IS NULL
               AND A.DIVISION_ID = P_DIVISION_ID
               AND ( A.SHIP_YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
                  OR A.ETA           BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD );

            /* Confirm ID/SO_NO 기준 출하 실적 (DOC_TYPE : D10 생성, D20 공장출고, D30 운송중, D40 매출, D90 삭제) */
            INSERT
              INTO GT_DS_SHIP_RESULT
                 ( DIVISION_ID
                 , CONFIRM_ID
                 , SO_NO
                 , ITEM_ID
                 , SHIP_RESULT_QTY )
            SELECT A.DIVISION_ID, A.CONFIRM_ID, LPAD(RTRIM(A.ORDER_NO), 10, '0') AS SO_NO, A.ITEM_ID, SUM(A.EXFACTORY_QTY) AS SHIP_RESULT_QTY
              FROM SCM_DNM_EXFACTORY_RESULT     A
                 , SCM_ADM_LOOKUP_MASTER_DETAIL B
             WHERE 1 = 1
               AND B.LOOKUP_TYPE = 'ERP_SSP_TYPE'
               AND B.VALID_YN = 'Y'
               AND B.SEGMENT1 = A.SSP_TYPE
               AND NVL(A.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')
               AND A.DIVISION_ID = P_DIVISION_ID
               AND A.CONFIRM_ID LIKE 'C%'
               AND A.EXFACTORY_DATE BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
               AND A.ORDER_TYPE_CODE NOT IN ('ZKM', 'ZKN')
             GROUP BY A.DIVISION_ID, A.CONFIRM_ID, A.ORDER_NO, A.ITEM_ID;

            /* SCM_DNM_EXFACTORY_RESULT SO_NO 출하 실적 데이터 UPDATE ( UPDATE FROM JOIN → 상관 UPDATE ) */
            UPDATE DM_PLN_MKT_FCST_CONFIRM A
               SET ( A.SHIP_RESULT_QTY, A.PLAN_QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE ) =
                   ( SELECT B.SHIP_RESULT_QTY
                          , CASE WHEN A.PLAN_QTY <> B.SHIP_RESULT_QTY THEN B.SHIP_RESULT_QTY ELSE A.PLAN_QTY END
                          , 'SYSTEM_RESULT', SYSDATE
                       FROM GT_DS_SHIP_RESULT B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SO_NO = A.SO_NO
                        AND B.ITEM_ID = A.ITEM_ID
                        AND ROWNUM = 1 )
             WHERE A.DIVISION_ID = P_DIVISION_ID
               AND ( A.SHIP_YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
                  OR A.ETA           BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD )
               AND EXISTS ( SELECT 1
                              FROM GT_DS_SHIP_RESULT B
                             WHERE B.DIVISION_ID = A.DIVISION_ID
                               AND B.SO_NO = A.SO_NO
                               AND B.ITEM_ID = A.ITEM_ID );

            /* SO_NO 기준 매출 실적 대상 적재 [PJ2025-50188] ( CROSS APPLY → TABLE() 조인, SO_NO CLOB → TO_CHAR ) */
            INSERT
              INTO GT_DS_SALES_RESULT
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , QTY
                 , SO_NO
                 , SO_QTY
                 , SPLIT_SO_NO
                 , SO_NO_NUM
                 , SPLIT_SO_QTY
                 , SO_QTY_NUM )
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.QTY, A.SO_NO, A.SO_QTY
                 , LPAD(RTRIM(B.VALUE), 10, '0') AS SPLIT_SO_NO
                 , B.ID AS SO_NO_NUM, C.VALUE AS SPLIT_SO_QTY, C.ID AS SO_QTY_NUM
              FROM (
                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                         , TO_CHAR(SO_NO) AS SO_NO, SO_QTY
                         , SUM(QTY) AS QTY
                      FROM DM_PLN_MKT_FCST_RESULT
                     WHERE DIVISION_ID = P_DIVISION_ID
                       AND YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
                       AND MEASURE IN ('RTF')
                       AND QTY <> 0
                     GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                         , TO_CHAR(SO_NO), SO_QTY
                   ) A
                 , TABLE(FN_SPLITSTRING(A.SO_NO, ','))  B
                 , TABLE(FN_SPLITSTRING(A.SO_QTY, ',')) C
             WHERE A.DIVISION_ID = P_DIVISION_ID
               AND A.YYYYMMDD BETWEEN V_RESULT_START_YYYYMMDD AND V_END_YYYYMMDD
               AND A.MEASURE IN ('RTF')
               AND A.QTY <> 0
               AND RTRIM(C.VALUE) IS NOT NULL      /* 2022.09.12  (원본 SQ.VALUE <> '') */
               AND B.ID = C.ID;

            UPDATE GT_DS_SALES_RESULT A
               SET A.CONFIRM_ID = ( SELECT B.CONFIRM_ID
                                      FROM XIF_ERP_SHIP_DOC_R_SN B
                                     WHERE A.SPLIT_SO_NO = B.DOC_NO
                                       AND ROWNUM = 1 )
             WHERE EXISTS ( SELECT 1
                              FROM XIF_ERP_SHIP_DOC_R_SN B
                             WHERE A.SPLIT_SO_NO = B.DOC_NO );

            /* SO_NO 기준 매출 실적 업데이트 ( UPDATE FROM JOIN → 상관 UPDATE ) */
            UPDATE DM_PLN_MKT_FCST_CONFIRM A
               SET ( A.SALES_RESULT_QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE ) =
                   ( SELECT SUM(CAST(CASE WHEN NVL(B.SPLIT_SO_QTY, 0) = 0 THEN 0 ELSE B.SPLIT_SO_QTY END AS NUMBER(30, 0)))
                          , 'SYSTEM_SALES_RESULT', SYSDATE
                       FROM GT_DS_SALES_RESULT B
                          , SCM_MST_SITE        C
                      WHERE C.DIVISION_ID(+) = B.DIVISION_ID
                        AND C.SCM_SITE_ID(+) = NVL(B.SCM_SITE_ID, ' ')
                        AND B.DIVISION_ID = P_DIVISION_ID
                        AND B.DIVISION_ID = A.DIVISION_ID
                        AND B.SPLIT_SO_NO = A.SO_NO
                        AND B.ITEM_ID = A.ITEM_ID
                      GROUP BY B.DIVISION_ID, B.SPLIT_SO_NO, B.ITEM_ID )
             WHERE EXISTS ( SELECT 1
                              FROM GT_DS_SALES_RESULT B
                             WHERE B.DIVISION_ID = P_DIVISION_ID
                               AND B.DIVISION_ID = A.DIVISION_ID
                               AND B.SPLIT_SO_NO = A.SO_NO
                               AND B.ITEM_ID = A.ITEM_ID );

            /* CONFIRM_ID 기준 매출 실적 업데이트 ( 다중매치 → ROWNUM=1 로 임의 1건, 원본 UPDATE JOIN 등가 ) */
            UPDATE DM_PLN_MKT_FCST_CONFIRM A
               SET ( A.SALES_RESULT_QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE ) =
                   ( SELECT QCOL, 'SYSTEM_SALES_RESULT', SYSDATE
                       FROM ( SELECT SUM(CAST(CASE WHEN NVL(B.SPLIT_SO_QTY, 0) = 0 THEN 0 ELSE B.SPLIT_SO_QTY END AS NUMBER(30, 0))) AS QCOL
                                FROM GT_DS_SALES_RESULT B
                                   , SCM_MST_SITE        C
                               WHERE C.DIVISION_ID(+) = B.DIVISION_ID
                                 AND C.SCM_SITE_ID(+) = NVL(B.SCM_SITE_ID, ' ')
                                 AND B.DIVISION_ID = P_DIVISION_ID
                                 AND B.DIVISION_ID = A.DIVISION_ID
                                 AND B.ITEM_ID = A.ITEM_ID
                                 AND B.CONFIRM_ID = A.CONFIRM_ID
                               GROUP BY B.DIVISION_ID, B.SPLIT_SO_NO, B.ITEM_ID, B.CONFIRM_ID )
                      WHERE ROWNUM = 1 )
             WHERE A.SALES_RESULT_QTY IS NULL
               AND EXISTS ( SELECT 1
                              FROM GT_DS_SALES_RESULT B
                             WHERE B.DIVISION_ID = P_DIVISION_ID
                               AND B.DIVISION_ID = A.DIVISION_ID
                               AND B.ITEM_ID = A.ITEM_ID
                               AND B.CONFIRM_ID = A.CONFIRM_ID );
            /* End [C20210225-000385] DM_PLN_MKT_FCST_CONFIRM 데이터 생성 */

            /* 원본 동기화 테스트용 데이터 추가 생성 (원문 보존, 미실행)
            --INSERT INTO #T_SSP ( DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, QTY, ETA )
            --VALUES ( '40', 'NT', 'NT_CN_CGU', 'MIF409858C11', 'MPS', 'DDP', 100000, '20210104' )
            --INSERT INTO #T_SSP ( DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, QTY, ETA )
            --VALUES ( '40', 'NT', 'NT_CN_CGU', 'MIF409858C11', 'MPS', 'DDP', 100000, '20210106' )
            */

            /* ------------------------------------------------------------------------------------------------ */
            /* 2. MKT FCST 와 join 해서 INSERT/UPDATE 한다. */
            /*   ATTRIBUTE1=동기화+네팅수량, ATTRIBUTE2=네팅수량, [C20210225-000385] ATTRIBUTE4=동기화 CONFIRM_ID */
            /* ------------------------------------------------------------------------------------------------ */
            INSERT
              INTO GT_DS_SSP
                 ( DIVISION_ID
                 , CONFIRM_ID
                 , PROJECT_CODE
                 , TO_SITE
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , ETA
                 , QTY )
            SELECT DIVISION_ID, CONFIRM_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                 , DOM_EXP, FCST_TYPE, INCOTERMS, ETA, SUM(PLAN_QTY) AS QTY
              FROM DM_PLN_MKT_FCST_CONFIRM   /* [C20210225-000385] DM_PLN_MKT_FCST_CONFIRM 사용 */
             WHERE DIVISION_ID = P_DIVISION_ID
               AND SHIP_YYYYMMDD BETWEEN V_NET_START_YYYYMMDD AND V_END_YYYYMMDD   /* [C20210528-000332] SHIP_YYYYMMDD 출하계획일 */
               AND ETA >= V_START_YYYYMMDD                                         /* [C20210528-000332] 매출계획일 당주이후 동기화 */
               AND NVL(SALES_RESULT_QTY, 0) = 0                                    /* [C20210420-000162] 매출실적 없는 데이터만 */
             GROUP BY DIVISION_ID, CONFIRM_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                 , DOM_EXP, FCST_TYPE, INCOTERMS, ETA;

            /* [C20210225-000385] CONFIRM_ID 추가. 원본 이중 PIVOT(C1~C100/Q1~Q100) → 조건부집계(SUM/LISTAGG). */
            /*   Cn = key그룹 내 CONFIRM_ID 순번(<=100)별 값, Qn = 해당 순번 QTY. QTY=순번1~100 합, CONFIRM_ID=순번1~100 콤마결합. */
            INSERT
              INTO GT_DS_SSP_SUM
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , TO_SITE
                 , ITEM_ID
                 , FCST_TYPE
                 , INCOTERMS
                 , ETA
                 , DOM_EXP
                 , QTY
                 , CONFIRM_ID )
            SELECT DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, ETA, DOM_EXP
                 , NVL(SUM(CASE WHEN RN <= 100 THEN QTY END), 0) AS QTY
                 , LISTAGG(CASE WHEN RN <= 100 THEN CONFIRM_ID END, ',') WITHIN GROUP (ORDER BY CONFIRM_ID) AS CONFIRM_ID
              FROM ( SELECT DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, ETA, DOM_EXP, CONFIRM_ID, QTY
                          , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, ETA, DOM_EXP
                                                ORDER BY CONFIRM_ID ) AS RN
                       FROM GT_DS_SSP )
             GROUP BY DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, FCST_TYPE, INCOTERMS, ETA, DOM_EXP;

            /* [C20210225-000385] 동기화 데이터 삭제 ( 원본 단순 UPDATE, 조인 없음 ) */
            UPDATE DM_PLN_MKT_FCST A
               SET A.QTY = CASE WHEN A.QTY - CAST(A.ATTRIBUTE1 AS NUMBER(30, 10)) - CAST(A.ATTRIBUTE3 AS NUMBER(30, 10)) > 0 THEN A.QTY
                                ELSE CAST(A.ATTRIBUTE1 AS NUMBER(30, 10))
                           END
                 , A.ATTRIBUTE3 = NULL
                 , A.ATTRIBUTE4 = NULL
                 , A.LAST_UPDATED_BY = 'SSP_SYNC_DEL'
                 , A.LAST_UPDATE_DATE = SYSDATE
             WHERE A.DIVISION_ID = P_DIVISION_ID
               AND A.YYYYMMDD >= V_START_YYYYMMDD   /* [C20210528-000332] 매출계획일 당주이후 삭제 */
               AND A.MEASURE = 'MKT_FCST'
               AND REGEXP_LIKE(A.ATTRIBUTE3, '^[+-]?[0-9]+(\.[0-9]+)?$');

            /* MKT FCST 테이블에 인서트/업데이트 */
            MERGE INTO DM_PLN_MKT_FCST A
            USING ( SELECT DIVISION_ID, PROJECT_CODE, TO_SITE, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, ETA, QTY, CONFIRM_ID
                      FROM GT_DS_SSP_SUM ) B
               ON ( A.DIVISION_ID  = B.DIVISION_ID
                AND A.PROJECT_CODE = B.PROJECT_CODE
                AND A.SCM_SITE_ID  = B.TO_SITE
                AND A.ITEM_ID      = B.ITEM_ID
                AND A.DOM_EXP      = B.DOM_EXP
                AND A.FCST_TYPE    = B.FCST_TYPE
                AND A.INCOTERMS    = B.INCOTERMS
                AND A.YYYYMMDD     = B.ETA
                AND A.MEASURE      = 'MKT_FCST' )
            WHEN MATCHED THEN
                UPDATE SET A.QTY = CASE WHEN REGEXP_LIKE(A.ATTRIBUTE3, '^[+-]?[0-9]+(\.[0-9]+)?$')
                                         AND CAST(A.ATTRIBUTE3 AS NUMBER(30, 10)) > 0
                                         AND A.QTY = CAST(A.ATTRIBUTE3 AS NUMBER(30, 10))
                                            THEN B.QTY
                                        ELSE CASE WHEN A.QTY > B.QTY THEN A.QTY ELSE B.QTY END   /* MF 값과 SSP 중 큰 값 */
                                   END
                         , A.ATTRIBUTE1 = CASE WHEN REGEXP_LIKE(A.ATTRIBUTE1, '^[+-]?[0-9]+(\.[0-9]+)?$') THEN A.ATTRIBUTE1
                                               ELSE TO_CHAR(A.QTY)
                                          END
                         , A.ATTRIBUTE2 = NULL
                         , A.ATTRIBUTE3 = TO_CHAR(B.QTY)
                         , A.ATTRIBUTE4 = B.CONFIRM_ID   /* [C20210225-000385] CONFIRM_ID 추가 */
                         , A.LAST_UPDATED_BY = 'SSP_SYNC'
                         , A.LAST_UPDATE_DATE = SYSDATE
            WHEN NOT MATCHED THEN
                INSERT
                     ( A.DIVISION_ID
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , A.MEASURE
                     , A.PLANT_SITE_ID
                     , A.YYYYMMDD
                     , A.QTY
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                     , A.ATTRIBUTE1
                     , A.ATTRIBUTE2
                     , A.ATTRIBUTE3
                     , A.ATTRIBUTE4
                     , A.ATTRIBUTE5
                     , A.ATTRIBUTE6
                     , A.ATTRIBUTE7
                     , A.ATTRIBUTE8
                     , A.ATTRIBUTE9
                     , A.ATTRIBUTE10 )
                VALUES ( B.DIVISION_ID
                     , B.PROJECT_CODE
                     , B.TO_SITE
                     , B.ITEM_ID
                     , B.DOM_EXP
                     , B.FCST_TYPE
                     , B.INCOTERMS
                     , 'MKT_FCST'
                     , '#'
                     , B.ETA
                     , B.QTY
                     , 'SSP_SYNC'
                     , SYSDATE
                     , 'SSP_SYNC'
                     , SYSDATE
                     , '0'
                     , NULL
                     , TO_CHAR(B.QTY)
                     , B.CONFIRM_ID         /* [C20210225-000385] CONFIRM_ID 추가 */
                     , NULL
                     , NULL
                     , NULL
                     , NULL
                     , NULL
                     , NULL );

            /* ------------------------------------------------------------------------------------------------ */
            /* 3. 네팅 대상 데이터를 가져와서 복사본을 만든다. ( 계획보다 실적이 빨리 발생한 경우 네팅/캐리오버 ) */
            /*   ATTRIBUTE1=동기화+네팅수량, ATTRIBUTE2=네팅수량, [C20210225-000385] ATTRIBUTE5=캐리오버 CONFIRM_ID, ATTRIBUTE6=네팅 CONFIRM_ID */
            /* ------------------------------------------------------------------------------------------------ */
            /* Start [C20210225-000385] MKT Result CONFIRM_ID - SO_NO 데이터로 변경 */
            INSERT
              INTO GT_DS_MKT_RESULT
                 ( DIVISION_ID
                 , CONFIRM_ID
                 , SO_NO
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , QTY )
            SELECT DIVISION_ID, CONFIRM_ID, SO_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , SUM(NVL(PLAN_QTY, 0) - NVL(SALES_RESULT_QTY, 0)) AS QTY
              FROM DM_PLN_MKT_FCST_CONFIRM
             WHERE DIVISION_ID = P_DIVISION_ID
               AND ( SHIP_YYYYMMDD BETWEEN V_NET_START_YYYYMMDD AND V_END_YYYYMMDD
                  OR ETA           BETWEEN V_NET_START_YYYYMMDD AND V_END_YYYYMMDD )   /* [C20210625-000103] */
               AND NVL(SHIP_RESULT_QTY, 0) <> 0
             GROUP BY DIVISION_ID, CONFIRM_ID, SO_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
            HAVING SUM(NVL(PLAN_QTY, 0)) <> SUM(NVL(SALES_RESULT_QTY, 0));

            /* [C20220707-000107] 일반 동기화에 들어있는 confirm id 는 carry over 대상에서 제거 */
            DELETE
              FROM GT_DS_MKT_RESULT A
             WHERE EXISTS ( SELECT 1
                              FROM GT_DS_SSP B
                             WHERE A.CONFIRM_ID = B.CONFIRM_ID );

            /* 원본 주석: PK 오류 여부 확인 → 안남(PK 로 GROUP BY 처리) */

            /* [C20210225-000385] 실적이 계획보다 적게 들어온 경우 SUM. 원본 이중 PIVOT(C1~C100/Q1~Q100) → 조건부집계(SUM/LISTAGG). */

            /*   (첫째 블록 GT_DS_SSP_SUM(MSSQL L499-511)은 Q1~Q100 전량 포함). SUM(QTY) 등가재작성으로 전량 합산 정정. */
            INSERT
              INTO GT_DS_MKT_RESULT_SUM
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , QTY
                 , CONFIRM_ID )
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , NVL(SUM(CASE WHEN RN <= 100 THEN QTY END), 0) AS QTY
                 , LISTAGG(CASE WHEN RN <= 100 THEN CONFIRM_ID END, ',') WITHIN GROUP (ORDER BY CONFIRM_ID) AS CONFIRM_ID
              FROM ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, CONFIRM_ID, QTY
                          , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, FCST_TYPE, INCOTERMS, DOM_EXP
                                                ORDER BY CONFIRM_ID ) AS RN
                       FROM GT_DS_MKT_RESULT )
             GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS;

            /* QTY 부호에 따라 순번 세팅 (실적이 덜 들어온 경우 오늘 날짜에 캐리오버) */
            UPDATE GT_DS_MKT_RESULT_SUM A
               SET A.SEQ = ( SELECT B.SEQ
                               FROM ( SELECT ROW_NUM, ROW_NUMBER() OVER ( ORDER BY QTY ) AS SEQ
                                        FROM GT_DS_MKT_RESULT_SUM
                                       WHERE QTY > 0 ) B
                              WHERE B.ROW_NUM = A.ROW_NUM )
             WHERE A.QTY > 0;

            /* 실적이 더 들어온 경우에 미래 계획구간 네팅 */
            UPDATE GT_DS_MKT_RESULT_SUM A
               SET A.SEQ = ( SELECT B.SEQ
                               FROM ( SELECT ROW_NUM, ROW_NUMBER() OVER ( ORDER BY QTY ) AS SEQ
                                        FROM GT_DS_MKT_RESULT_SUM
                                       WHERE QTY < 0 ) B
                              WHERE B.ROW_NUM = A.ROW_NUM )
             WHERE A.QTY < 0;

            /* [C20210225-000385] Carry Over 데이터 삭제 ( 원본 단순 UPDATE, 조인 없음 ) */
            UPDATE DM_PLN_MKT_FCST A
               SET A.QTY = CASE WHEN REGEXP_LIKE(A.ATTRIBUTE2, '^[+-]?[0-9]+(\.[0-9]+)?$') AND CAST(A.ATTRIBUTE2 AS NUMBER(30, 10)) > 0
                                  THEN A.QTY - CAST(A.ATTRIBUTE2 AS NUMBER(30, 10))
                                ELSE A.QTY
                           END
                 , A.ATTRIBUTE2 = NULL
                 , A.ATTRIBUTE5 = NULL
                 , A.LAST_UPDATED_BY = 'SSP_SYNC_DEL'
                 , A.LAST_UPDATE_DATE = SYSDATE
             WHERE A.DIVISION_ID = P_DIVISION_ID
               AND A.YYYYMMDD = TO_CHAR(TO_DATE(V_NET_END_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD')   /* 오늘 (첫 계획구간 일자) */
               AND A.MEASURE = 'MKT_FCST'
               AND REGEXP_LIKE(A.ATTRIBUTE2, '^[+-]?[0-9]+(\.[0-9]+)?$');

            /* 실적이 계획보다 적게 들어온 경우를 먼저 일괄 업데이트 ( SET이 B값 참조 → 상관 UPDATE, 단일매치 ) */
            UPDATE DM_PLN_MKT_FCST A
               SET ( A.QTY, A.ATTRIBUTE2, A.ATTRIBUTE5, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE ) =
                   ( SELECT CASE WHEN REGEXP_LIKE(A.ATTRIBUTE2, '^[+-]?[0-9]+(\.[0-9]+)?$') AND CAST(A.ATTRIBUTE2 AS NUMBER(30, 10)) > 0
                                   THEN A.QTY
                                 ELSE A.QTY + B.QTY
                            END
                          , CASE WHEN REGEXP_LIKE(A.ATTRIBUTE2, '^[+-]?[0-9]+(\.[0-9]+)?$') AND CAST(A.ATTRIBUTE2 AS NUMBER(30, 10)) > 0
                                   THEN A.ATTRIBUTE2
                                 ELSE TO_CHAR(B.QTY)
                            END
                          , B.CONFIRM_ID   /* [C20210225-000385] ATTRIBUTE5 = CARRY OVER CONFIRM ID */
                          , 'SSP_CARRY_OVER', SYSDATE
                       FROM GT_DS_MKT_RESULT_SUM B
                      WHERE A.DIVISION_ID = B.DIVISION_ID
                        AND A.PROJECT_CODE = B.PROJECT_CODE
                        AND A.SCM_SITE_ID = B.SCM_SITE_ID
                        AND A.ITEM_ID = B.ITEM_ID
                        AND A.DOM_EXP = B.DOM_EXP
                        AND A.FCST_TYPE = B.FCST_TYPE
                        AND A.INCOTERMS = B.INCOTERMS
                        AND B.QTY > 0 )
             WHERE A.DIVISION_ID = P_DIVISION_ID
               AND A.YYYYMMDD = TO_CHAR(TO_DATE(V_NET_END_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD')
               AND A.MEASURE = 'MKT_FCST'
               AND EXISTS ( SELECT 1
                              FROM GT_DS_MKT_RESULT_SUM B
                             WHERE A.DIVISION_ID = B.DIVISION_ID
                               AND A.PROJECT_CODE = B.PROJECT_CODE
                               AND A.SCM_SITE_ID = B.SCM_SITE_ID
                               AND A.ITEM_ID = B.ITEM_ID
                               AND A.DOM_EXP = B.DOM_EXP
                               AND A.FCST_TYPE = B.FCST_TYPE
                               AND A.INCOTERMS = B.INCOTERMS
                               AND B.QTY > 0 );

            INSERT
              INTO DM_PLN_MKT_FCST
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , YYYYMMDD
                 , QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 , ATTRIBUTE1
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , ATTRIBUTE8
                 , ATTRIBUTE9
                 , ATTRIBUTE10 )
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                 , A.FCST_TYPE, A.INCOTERMS, 'MKT_FCST' AS MEASURE, '#' AS PLANT_SITE_ID
                 , TO_CHAR(TO_DATE(V_NET_END_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD') AS YYYYMMDD   /* 오늘 (첫 계획구간 일자) */
                 , A.QTY, 'SSP_SYNC' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'SSP_CARRY_OVER' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
                 , '0' AS ATTRIBUTE1, TO_CHAR(A.QTY) AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, A.CONFIRM_ID AS ATTRIBUTE5   /* [C20210225-000385] ATTRIBUTE5=CARRY OVER CONFIRM ID */
                 , NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8, NULL AS ATTRIBUTE9, NULL AS ATTRIBUTE10
              FROM GT_DS_MKT_RESULT_SUM A
             WHERE A.QTY > 0
               AND NOT EXISTS ( SELECT 1
                                  FROM DM_PLN_MKT_FCST B
                                 WHERE A.DIVISION_ID = B.DIVISION_ID
                                   AND A.PROJECT_CODE = B.PROJECT_CODE
                                   AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                   AND A.ITEM_ID = B.ITEM_ID
                                   AND A.DOM_EXP = B.DOM_EXP
                                   AND A.FCST_TYPE = B.FCST_TYPE
                                   AND A.INCOTERMS = B.INCOTERMS
                                   AND B.YYYYMMDD = TO_CHAR(TO_DATE(V_NET_END_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD')
                                   AND B.MEASURE = 'MKT_FCST'
                                   AND B.DIVISION_ID = P_DIVISION_ID );

            COMMIT;

        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;      /* 원본 ROLLBACK TRAN SALES_SITE_MODEL_PRODUCTION */
            /* ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
                , JSON_OBJECT('DIVISION_ID' VALUE P_DIVISION_ID RETURNING VARCHAR2(4000 CHAR))
                , SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            /* 원본 SELECT '['+ERROR_NUMBER()+']'+ERROR_MESSAGE() (디버그 출력) */
            DBMS_OUTPUT.PUT_LINE('[' || SQLCODE || ']' || SQLERRM);

    END;

    /* 종료 LOG (정상 경로) : 원본 IF @V_LOG_TYPE NOT IN ('INVALID','ERROR') 블록 */
    IF V_LOG_TYPE NOT IN ('INVALID', 'ERROR') THEN
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END OF PROCEDURE ##########';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END IF;

    /* 원본 ERR_RTN 라벨 : INVALID 인 경우 ROLLBACK 후 종료 LOG */
    IF V_LOG_TYPE = 'INVALID' THEN
        DBMS_OUTPUT.PUT_LINE(V_LOG_TYPE);   /* 원본 SELECT @V_LOG_TYPE (디버그 출력) */
        ROLLBACK;                           /* 원본 ROLLBACK TRAN SALES_SITE_MODEL_PRODUCTION */
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END OF PROCEDURE ##########';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END IF;

END;