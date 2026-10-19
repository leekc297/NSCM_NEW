PROCEDURE           "PR_DM_DNM_EDI_CALLOFF_MKT_FCST" 
/*
 * Program ID  : PR_DM_DNM_EDI_CALLOFF_MKT_FCST
 * Description  : GSCM COMPLETED EDI 정보 -> MKT_FCST INSERT(CUST_FCST_EDI MEASURE)
 *                  DM_DNM_EDI_CALLOFF_ITEM -> DM_PLN_MKT_FCST
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 배포시 주의사항 : 개발기 -> LGCE_INFDEV , 운영기 -> LGCE_INF
 *===================================================================================================
   20230503 kdmcc14      [EDI과제] PROJECT EDI_CALLOFF DATA -> MKT FCST MEASURE 생성
   20231006 chutoc730    [EDI과제] CUST_MATERIAL_CODE NOT LIKE '9j1%' 예외 분기 추가
   20231101 chutoc730    [EDI과제] MEASURE(SCHEDULING_TYPE) 별 오류 합 수정
   20231116 chutoc730    [EDI과제] Porsche/Audi/DRX Audi_DE_SHM / Porsche_DE_SHM 예외 로직 추가 / 추후 제외 소급 적용 룰 추가
   20231205 chutoc730    [EDI과제] 유통기간내 고객수요를 합산 로직을 기간내 MAX(IF_SEQ) 조건으로 합산 / 그룹조건에 CUSTOMER_PLANT를 추가하고 CUST_MATERIAL_CODE 를 제거 수정.
   20231206 chutoc730    MKT FCST[Auto] 화면 관련하여 발주처 예외처리.
   20240105 chutoc730    기존데이터 삭제 기준 날짜 변경 금주월요일~계획구간에서 당일~계획구간.
   20240116 chutoc730    END_CUSTOMER 추가 및 기준 하드코딩 LOOKUP(DM_EDI_CALLOFF_MKT_FCST_END_CUSTOMER) 에 데이터화.
   20240424 kcw3408      SENDER_NAME 30--> 200 으로 수정
   20240429 kcw3408      N:N Model Mapping_적재 추가(집계 시점에 Cust Item/Unloading Point/Plant 고려,Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음)
   20240626 JSSBAE       [E20240620-001488]_SCM DM 고객수요분석- Cust Plant NULL인 데이터 처리로직 개선
   20240626 JSSBAE       [E20240610-000320]_SCM DM EDI(Cust FCST) 관련 문의사항 (예외로직적용: 앞뒤 공백값, NULL값 공백으로 치환해서 비교 처리)
   20240703 JSSBAE       [E20240701-000472]_[공급 SCM PI팀] ERP EDI Master화면 업데이트 범위 개선
   20241204 JSSBAE       [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정
   20241216 KANG.H.J     [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선
 */
AS
    V_BATCH_USER         VARCHAR2(150 CHAR) := 'scm_batch';
    V_PROGRAM_NAME       VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_BATCH_CHK_MSG      VARCHAR2(150 CHAR) := ' [DM]SOLDTO_CODE 없이 들어와서 계속해서 에러를 발생시켜서 TRANSFER_FLAG 를 변경함.';
    V_LOG_TYPE           VARCHAR2(30 CHAR);
    N_LOG_COUNT          INTEGER := 0;
    V_LOG_MESSAGE        VARCHAR2(1000 CHAR);
    V_DESCRIPTION        VARCHAR2(500 CHAR);
    D_EVENT_DATE         DATE;
    V_IFSEQNO_INSERT     VARCHAR2(30 CHAR);
    V_SOLDTO_CODE        VARCHAR2(10 CHAR);
    V_SHIPTO_CODE        VARCHAR2(10 CHAR);
    V_UNLOADING_POINT    VARCHAR2(35 CHAR);
    V_CUSTOMER_PLANT     VARCHAR2(8 CHAR);
    V_SCHEDULING_TYPE    VARCHAR2(6 CHAR);
    V_PROJECT_CODE       VARCHAR2(100 CHAR);
    V_SCM_SITE_ID        VARCHAR2(100 CHAR);
    V_CUST_MATERIAL_CODE VARCHAR2(70 CHAR);
    V_ITEM_ID            VARCHAR2(100 CHAR);
    V_END_CUSTOMER       VARCHAR2(35 CHAR);
    V_SENDER_NAME        VARCHAR2(200 CHAR);
    V_CREATE_DATE        VARCHAR2(16 CHAR);
    V_CREATE_TIME        VARCHAR2(10 CHAR);
    V_0WEEK_MONDAY       VARCHAR2(8 CHAR);
    V_1WEEK_MONDAY       VARCHAR2(8 CHAR);
    V_TODAY              VARCHAR2(8 CHAR);
    V_HOUR               VARCHAR2(2 CHAR);
    V_YYYYMMDD           VARCHAR2(8 CHAR);
    V_DATEADDTODAY       DATE;
    V_I                  INTEGER := 1;
    V_CNT                INTEGER := 0;
    V_J                  INTEGER := 1;
    V_CNT_ORG            INTEGER := 0;
    V_FROM_YYYYMMDD      VARCHAR2(4000 CHAR);
    V_CUST_FCST_I        INTEGER;
    V_CUST_FCST_CNT      INTEGER;
    V_CUST_FCST_DIVISION VARCHAR2(30 CHAR);
    V_IN_PARA_DATA       VARCHAR2(4000 CHAR);
BEGIN

    /* LOG 용 변수 설정 */
    V_HOUR := NULL;


    DELETE FROM GT_DDECM_DM_CUST_MODEL_MAPPING;
    DELETE FROM GT_DDECM_CUST_FCST_DIVISION;
    DELETE FROM GT_DDECM_MKT_ORG_DATA;

    /* 시작 LOG */
    V_LOG_TYPE     := 'START';
    V_LOG_MESSAGE  := '########## Start of procedure ##########';
    V_DESCRIPTION  := NULL;
    D_EVENT_DATE   := SYSDATE;
    D_EVENT_DATE   := SYSDATE;
    V_DATEADDTODAY := SYSDATE;
    V_TODAY        := TO_CHAR(V_DATEADDTODAY, 'YYYYMMDD');

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    V_0WEEK_MONDAY := TO_CHAR(FN_NEXT_DAY(V_DATEADDTODAY, 'MON') + (-7), 'YYYYMMDD');     /* W0월요일 */
    V_1WEEK_MONDAY := TO_CHAR(FN_NEXT_DAY(V_DATEADDTODAY, 'MON') + (-7 + 7), 'YYYYMMDD'); /* W1월요일 */
    /* 현재시간 */
    V_HOUR := SUBSTR(TO_CHAR(V_DATEADDTODAY, 'HH24:MI:SS'), 1, 2);

    DBMS_OUTPUT.PUT_LINE(V_1WEEK_MONDAY);

    /* 오늘 기준 52W 전까지 조회함 */
    V_FROM_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE, 'IW') - (52 * 7), 'YYYYMMDD');
    /* PSA 데이터 조회일자 */
    BEGIN
        /* 다음주 일요일을 날짜기준으로 삼는데. (단 오늘이 일요일이면 오늘부터 기준을 삼음) */
        SELECT CASE
                   WHEN TO_NUMBER(TO_CHAR(V_DATEADDTODAY, 'D')) = 1 THEN TO_CHAR(FN_NEXT_DAY(V_DATEADDTODAY, 'SUN') + (-7), 'YYYYMMDD')
                   ELSE TO_CHAR(FN_NEXT_DAY(V_DATEADDTODAY, 'SUN') + 0, 'YYYYMMDD')
               END
          INTO V_YYYYMMDD
          FROM DUAL;
    END;

    BEGIN

        /* 예외 Sales Site 관리 테이블중복제거 / 임시확인용 Sales Site 관리 테이블 중복제거 */
        DELETE FROM GT_DDECM_EDI_MGM_SALES_SITE;

        /* 테이블중복제거 / 임시확인용테이블 중복제거 */
        DELETE FROM GT_DDECM_EDI_END_CUSTOMER;

        /* EDI END_CUSTOMER별 기간 설정 */
        BEGIN
            /* EDI_END_CUSTOMER Lookup의 Active = 'Off'이면 CREATE_DATE -52주부터, 'On'이면 Lookup 기간 사용 */
            INSERT INTO GT_DDECM_EDI_END_CUSTOMER
                (DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE)
            SELECT A.DIVISION_ID                                          AS DIVISION_ID
                 , A.END_CUSTOMER                                         AS END_CUSTOMER
                 , NVL(NULLIF(RTRIM(B.SEGMENT4),''), '/')                                   AS SCM_SITE_ID
                 , CASE WHEN NVL(B.SEGMENT5, 'On') = 'On' THEN NVL(B.ATTRIBUTE1, '-1')
                        ELSE '-52'
                   END                                                    AS FROM_WEEK
                 , NVL(B.ATTRIBUTE2, 'TUE')                               AS FROM_DAY
                 , NVL(B.ATTRIBUTE3, '0')                                 AS TO_WEEK
                 , NVL(B.ATTRIBUTE4, 'MON')                               AS TO_DAY
                 , NVL(B.SEGMENT5, 'On')                                  AS ACTIVE
              FROM SCM_MST_SITE A
              LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                ON  B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER'
                AND A.DIVISION_ID  = B.SEGMENT1
                AND A.END_CUSTOMER = B.SEGMENT2
                AND B.VALID_YN     = 'Y'
             WHERE A.END_CUSTOMER IS NOT NULL
             GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;
        END;

        BEGIN
            /* 테이블중복제거 / 임시확인용테이블 중복제거 */
            DELETE FROM GT_DDECM_EDI_ALL;

            /* EDI STATUS_CODE가 SUCCESS인 DATA */
            BEGIN
                /* DIVISION_ID, SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT, ITEM_ID, SCHEDULING_TYPE 기준으로 DATA 추출 */
                /* EDI물동 기준이 되는 IFSEQNO 추출함. */
                INSERT INTO GT_DDECM_EDI_ALL
                    (NUM, DIVISION_ID, IFSEQNO, SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT, CUSTOMER_PLANT, SCHEDULING_TYPE
                    , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, ERP_FCST_TYPE, CREATE_DATE, CREATE_TIME, MESSAGE_TYPE, END_CUSTOMER, SENDER_NAME, YYYYMMDD)
                SELECT ROW_NUMBER() OVER (ORDER BY A.IFSEQNO)             AS NUM   /* 해당 칼럼이 필요한가?? */
                     , A.DIVISION_ID
                     , A.IFSEQNO
                     , A.SOLDTO_CODE
                     , A.SHIPTO_CODE
                     , A.UNLOADING_POINT
                     , A.CUSTOMER_PLANT
                     , A.SCHEDULING_TYPE
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.ERP_FCST_TYPE
                     , A.CREATE_DATE
                     , A.CREATE_TIME
                     , A.MESSAGE_TYPE
                     , A.END_CUSTOMER
                     , A.SENDER_NAME
                     , A.YYYYMMDD
                  FROM (
                        SELECT ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.SCHEDULING_TYPE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
                                                             , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END
                                                  ORDER BY A.CREATE_DATE DESC, A.IFSEQNO DESC)     AS RNK
                             , A.DIVISION_ID
                             , A.IFSEQNO
                             , A.SOLDTO_CODE
                             , A.SHIPTO_CODE
                             , NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), ' ')  AS UNLOADING_POINT
                             , NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), ' ')   AS CUSTOMER_PLANT
                             , A.SCHEDULING_TYPE
                             , A.PROJECT_CODE
                             , A.SCM_SITE_ID
                             , A.ITEM_ID
                             , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END           AS ERP_FCST_TYPE
                             , A.CREATE_DATE
                             , A.CREATE_TIME
                             , A.MESSAGE_TYPE
                             , B.END_CUSTOMER
                             , A.SENDER_NAME
                             , A.YYYYMMDD
                          FROM DM_DNM_EDI_CALLOFF_ITEM A
                          LEFT OUTER JOIN SCM_MST_SITE B
                            ON  A.DIVISION_ID = B.DIVISION_ID
                            AND A.SCM_SITE_ID = B.SCM_SITE_ID
                            AND B.SITE_TYPE   = 'SALES'
                            AND B.VALID_YN    = 'Y'
                            AND REPLACE(B.END_CUSTOMER, '-', '') IS NOT NULL
                          LEFT OUTER JOIN LATERAL (SELECT C1.*
                                         FROM GT_DDECM_EDI_END_CUSTOMER C1
                                        WHERE A.DIVISION_ID  = C1.DIVISION_ID
                                          AND C1.END_CUSTOMER = B.END_CUSTOMER
                                          AND C1.SCM_SITE_ID  = NVL((SELECT X99.SCM_SITE_ID
                                                                       FROM GT_DDECM_EDI_END_CUSTOMER X99
                                                                      WHERE X99.DIVISION_ID  = A.DIVISION_ID
                                                                        AND X99.END_CUSTOMER = B.END_CUSTOMER
                                                                        AND X99.SCM_SITE_ID  = A.SCM_SITE_ID), '/')) C ON (1 = 1)
                         WHERE 1 = 1
                           AND A.CREATE_DATE >= V_FROM_YYYYMMDD    /* 52주 전부터가 유효한 데이터임. */
                           AND A.YYYYMMDD    >= V_TODAY            /* 당일 이후 */
/*
   [원본 보존] 아래 CALENDAR 기반 CREATE_DATE 시작/종료일 산출 블록은 원본 MSSQL에서 주석처리되어 비활성 상태임.
   AND A.CREATE_DATE >= (
       SELECT BASIS_YYYYMMDD   -- 시작일의 정의 (-1주 OR -52주의 날짜를 지정한 요일로 추출함)
       FROM (
             SELECT RANK() OVER (ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK, DT.BASIS_YYYYMMDD
             FROM   SCM_SYS_CALENDAR_M DT
             WHERE  BASIS_YYYYMMDD <= (CASE WHEN TO_NUMBER(TO_CHAR(V_DATEADDTODAY,'D')) = 2 THEN TO_CHAR(V_DATEADDTODAY-1,'YYYYMMDD')
                                            WHEN TO_NUMBER(TO_CHAR(V_DATEADDTODAY,'D')) = 3 THEN (CASE WHEN V_HOUR < '05' THEN TO_CHAR(V_DATEADDTODAY-2,'YYYYMMDD') ELSE TO_CHAR(V_DATEADDTODAY,'YYYYMMDD') END)
             AND    DAYOFWEEK = C.FROM_DAY   -- 사용자가 정의한 요일로 처리
            ) D
       WHERE D.RK = C.FROM_WEEK    -- FROM_WEEK는 -1 OR -52로만 존재함.
   )
   AND A.CREATE_DATE <= (
       SELECT BASIS_YYYYMMDD -- 종료일을 지정함 (0주(금주) OR -1주(차주)의 날짜를 지정한 요일로 추출함)
       FROM (
             SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER (ORDER BY BASIS_YYYYMMDD) - 2
                          ELSE RANK() OVER (ORDER BY BASIS_YYYYMMDD) - 1 END) AS RK, DT.BASIS_YYYYMMDD
             FROM   SCM_SYS_CALENDAR_M DT
             WHERE  BASIS_YYYYMMDD >= (CASE WHEN TO_NUMBER(TO_CHAR(V_DATEADDTODAY,'D')) = 2 THEN TO_CHAR(V_DATEADDTODAY-1,'YYYYMMDD')
                                            WHEN TO_NUMBER(TO_CHAR(V_DATEADDTODAY,'D')) = 3 THEN (CASE WHEN V_HOUR < '05' THEN TO_CHAR(V_DATEADDTODAY-2,'YYYYMMDD') ELSE TO_CHAR(V_DATEADDTODAY,'YYYYMMDD') END)
             AND    DAYOFWEEK = C.TO_DAY
            ) D
       WHERE D.RK = C.TO_WEEK
   )
*/
                           AND A.STATUS_CODE = 'S'
                           AND EXISTS (
                                        SELECT 1
                                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                                         WHERE LUP.LOOKUP_TYPE = 'DM_EDI_CALLOFF_MKT_FCST_END_CUSTOMER'
                                           AND LUP.SEGMENT1    = A.DIVISION_ID
                                           AND LUP.SEGMENT2    = A.SENDER_NAME
                                           AND LUP.SEGMENT3    = B.END_CUSTOMER
                                           AND LUP.SEGMENT4    = A.SCHEDULING_TYPE
                                           AND A.MESSAGE_TYPE  = (CASE WHEN LUP.SEGMENT5 IN ('DELJIT', 'DELFOR') THEN LUP.SEGMENT5   /* DELJIT / DELFOR로 정의되어 있으면. 정의된 데이터만 추출함. */
                                                                       ELSE (                                                       /* 그렇지 않을 경우 이번주 일요일까지는 DELJIT / 그 이후로는 DELFOR 로 정의된 추출함. */
                                                                             CASE WHEN A.YYYYMMDD <= V_YYYYMMDD THEN 'DELJIT'
                                                                                  ELSE 'DELFOR'
                                                                             END)
                                                                  END)
                                           AND LUP.VALID_YN = 'Y'
                                           AND ((LENGTH(LUP.ATTRIBUTE2) < 8 AND LENGTH(LUP.ATTRIBUTE3) < 8) OR (A.YYYYMMDD BETWEEN LUP.ATTRIBUTE1 AND LUP.ATTRIBUTE2))  /* 유효날짜 체크함. */
                                      )
                         GROUP BY A.DIVISION_ID
                                , A.IFSEQNO
                                , A.SOLDTO_CODE
                                , A.SHIPTO_CODE
                                , NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), ' ')
                                , NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), ' ')
                                , A.SCHEDULING_TYPE
                                , A.PROJECT_CODE
                                , A.SCM_SITE_ID
                                , A.ITEM_ID
                                , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END
                                , A.CREATE_DATE
                                , A.CREATE_TIME
                                , A.MESSAGE_TYPE
                                , B.END_CUSTOMER
                                , A.SENDER_NAME
                                , A.YYYYMMDD
                       ) A
                 WHERE RNK = 1
                   AND LENGTH(A.YYYYMMDD) = 8    /* 강현준 추가 ('444444' 가 추가되어 있음 */
                 ORDER BY A.IFSEQNO;
            END;

            /* 자료 추출(고객수요 N:N Mapping 적용) */
            /* 테이블중복제거 / 임시확인용테이블 중복제거 */
            DELETE FROM GT_DDECM_EDI_MKT_FCST;
            DELETE FROM GT_DDECM_EDI_MKT_FCST_ALL;

            /* 2024.04.29    kcw3408       고객수요 N:N Mapping  */
            BEGIN
                /* [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 START */
                INSERT INTO GT_DDECM_DM_CUST_MODEL_MAPPING
                    (DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, PROJECT_CODE, FCST_TYPE, INCOTERMS, DOM_EXP, ITEM_ID, MAPPING_ITEM_ID
                    , UNLOADING_POINT, CUSTOMER_PLANT, CUSTOMER_ITEM_ID, VALID_START_DATE, VALID_END_DATE)
                SELECT DISTINCT A.DIVISION_ID
                     /* , A.DATA_TYPE_CODE  -- MKT_FCST(CUST_FCST)는 롤인/롤아웃 구분없이 모두 생성하므로 DATA_TYPE_CODE 구분없이 처리함. */
                     , A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE
                     , A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, A.ITEM_ID, A.MAPPING_ITEM_ID
                     , NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), ' ')  AS UNLOADING_POINT
                     , NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), ' ')   AS CUSTOMER_PLANT
                     , NVL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)), ' ') AS CUSTOMER_ITEM_ID
                     , MAX(A.VALID_START_DATE)                    AS VALID_START_DATE
                     , MAX(A.VALID_END_DATE)                      AS VALID_END_DATE
                  FROM DM_CUST_MODEL_MAPPING_M A
                 WHERE A.ACTIVE_YN = 'Y'
                 /* AND A.DATA_TYPE_CODE = 'SCM' */
                 GROUP BY A.DIVISION_ID
                     , A.END_CUSTOMER, A.SCM_SITE_ID, A.PROJECT_CODE
                     , A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, A.ITEM_ID, A.MAPPING_ITEM_ID
                     , NVL(RTRIM(LTRIM(A.UNLOADING_POINT)), ' '), NVL(RTRIM(LTRIM(A.CUSTOMER_PLANT)), ' ')
                     , NVL(RTRIM(LTRIM(A.CUSTOMER_ITEM_ID)), ' ');
                /* [PJ2024-50647] 자동차사업부 고객 수요 분석 기능 개선 END */
            END;

            SELECT COUNT(*) INTO V_CNT FROM GT_DDECM_EDI_ALL;

            IF (V_CNT > 0) THEN

                INSERT INTO GT_DDECM_EDI_MKT_FCST_ALL
                    (EDI_IF_SEQ, SUB_NO, YYYYMMDD, DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, ERP_FCST_TYPE
                    , BASIS_YYYYMMDD, QTY, EDI_INCOTERMS, SALES_PLANT_SITE_ID, DOM_EXP, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE
                    , DOC_IDENTIFINER, MESSAGE_TYPE, UNLOADING_POINT, CUSTOMER_PLANT, RDD_START, RDD_END, IFSEQNO
                    , SCHEDULING_TYPE, DELFOR_TYPE, EDI_LT, CUST_MATERIAL_CODE, CREATE_DATE, CREATE_TIME, SENDER_CODE, SENDER_NAME, CHANGE_STATUS)
                SELECT X1.EDI_IF_SEQ, X1.SUB_NO, X1.YYYYMMDD
                     , X1.DIVISION_ID, X1.SCM_SITE_ID, X1.ITEM_ID, X1.PROJECT_CODE
                     , CASE WHEN X1.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END                 AS ERP_FCST_TYPE
                     , X1.BASIS_YYYYMMDD, X1.QTY, X1.EDI_INCOTERMS, X1.SALES_PLANT_SITE_ID
                     , 'E'                                                                         AS DOM_EXP
                     , X1.COMPANY_ID, X1.SOLDTO_CODE, X1.SHIPTO_CODE
                     , X1.DOC_IDENTIFINER, X1.MESSAGE_TYPE
                     , NVL(RTRIM(LTRIM(X1.UNLOADING_POINT)), ' ')                                 AS UNLOADING_POINT
                     , NVL(RTRIM(LTRIM(X1.CUSTOMER_PLANT)), ' ')                                  AS CUSTOMER_PLANT
                     , X1.RDD_START, X1.RDD_END
                     , X1.IFSEQNO
                     , X1.SCHEDULING_TYPE
                     , CASE WHEN (X1.MESSAGE_TYPE = 'DELFOR' AND X1.SOLDTO_CODE = 'FR000064' AND X1.RDD_START <> X1.RDD_END AND X1.RDD_START >= V_1WEEK_MONDAY) THEN 'Periodic DELFOR'
                            ELSE NULL
                       END                                                                        AS DELFOR_TYPE
                     , X1.EDI_LT
                     , NVL(RTRIM(LTRIM(X1.CUST_MATERIAL_CODE)), ' ')                              AS CUST_MATERIAL_CODE
                     , X1.CREATE_DATE, X1.CREATE_TIME
                     , X1.SENDER_CODE, X1.SENDER_NAME
                     , X1.ATTRIBUTE10
                  FROM DM_DNM_EDI_CALLOFF_ITEM X1
                  INNER JOIN GT_DDECM_EDI_ALL X2
                    ON  X1.IFSEQNO         = X2.IFSEQNO
                    AND X1.SOLDTO_CODE     = X2.SOLDTO_CODE
                    AND X1.SHIPTO_CODE     = X2.SHIPTO_CODE
                    AND X1.SCHEDULING_TYPE = X2.SCHEDULING_TYPE
                    AND X1.PROJECT_CODE    = X2.PROJECT_CODE
                    AND X1.SCM_SITE_ID     = X2.SCM_SITE_ID
                    AND X1.ITEM_ID         = X2.ITEM_ID
                    AND X1.SENDER_NAME     = X2.SENDER_NAME
                    AND X1.CREATE_DATE     = X2.CREATE_DATE
                    AND X1.CREATE_TIME     = X2.CREATE_TIME
                    AND X1.SHIPTO_CODE     = X2.SHIPTO_CODE
                 WHERE 1 = 1
                   AND X1.STATUS_CODE = 'S'
                   AND TO_NUMBER(REPLACE(NVL(X1.QTY, '0'), ',', '')) <> 0
                   AND NVL(X1.EXCEPTION_FLAG, 'N') != 'Y';

            END IF;

            BEGIN

                BEGIN
                /*
                   2024.04.29    kcw3408       고객수요 N:N Mapping
                   전체 대생 추출후 N:N Model Mapping 작업
                    .집계 시점에 Cust Item/Unloading Point/Plant 반영
                    .Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음
                    . GT_DDECM_EDI_MKT_FCST: 최종 결과,insert 작업
                */
                    BEGIN
                        INSERT INTO GT_DDECM_EDI_MKT_FCST
                            (EDI_IF_SEQ, SUB_NO, YYYYMMDD, DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, ERP_FCST_TYPE
                            , BASIS_YYYYMMDD, QTY, EDI_INCOTERMS, SALES_PLANT_SITE_ID, DOM_EXP, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE
                            , DOC_IDENTIFINER, MESSAGE_TYPE, UNLOADING_POINT, CUSTOMER_PLANT, RDD_START, RDD_END, IFSEQNO
                            , SCHEDULING_TYPE, DELFOR_TYPE, EDI_LT, CUST_MATERIAL_CODE, CREATE_DATE, SENDER_CODE, SENDER_NAME, CHANGE_STATUS)
                        SELECT X.EDI_IF_SEQ
                             , X.SUB_NO
                             , X.YYYYMMDD
                             , X.DIVISION_ID
                             , X.SCM_SITE_ID
                             , B.ITEM_ID
                             , X.PROJECT_CODE
                             , X.ERP_FCST_TYPE
                             , X.BASIS_YYYYMMDD
                             , X.QTY
                             , X.EDI_INCOTERMS
                             , X.SALES_PLANT_SITE_ID
                             , X.DOM_EXP
                             , X.COMPANY_ID
                             , X.SOLDTO_CODE
                             , X.SHIPTO_CODE
                             , X.DOC_IDENTIFINER
                             , X.MESSAGE_TYPE
                             , NVL(RTRIM(LTRIM(X.UNLOADING_POINT)), ' ')  AS UNLOADING_POINT
                             , NVL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), ' ')   AS CUSTOMER_PLANT
                             , X.RDD_START
                             , X.RDD_END
                             , X.IFSEQNO
                             , X.SCHEDULING_TYPE
                             , X.DELFOR_TYPE
                             , X.EDI_LT
                             , NVL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), ' ') AS CUST_MATERIAL_CODE
                             , X.CREATE_DATE
                             , X.SENDER_CODE
                             , X.SENDER_NAME
                             , X.CHANGE_STATUS
                          FROM GT_DDECM_EDI_MKT_FCST_ALL X
                          JOIN GT_DDECM_DM_CUST_MODEL_MAPPING B
                            ON  X.DIVISION_ID   = B.DIVISION_ID
                            AND X.SCM_SITE_ID   = B.SCM_SITE_ID
                            AND X.PROJECT_CODE  = B.PROJECT_CODE
                            AND X.ERP_FCST_TYPE = B.FCST_TYPE
                            AND X.EDI_INCOTERMS = B.INCOTERMS
                            AND X.DOM_EXP       = B.DOM_EXP
                            AND X.ITEM_ID       = B.ITEM_ID
                            AND NVL(RTRIM(LTRIM(X.UNLOADING_POINT)), ' ')   = NVL(RTRIM(LTRIM(B.UNLOADING_POINT)), ' ')
                            AND NVL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), ' ')    = NVL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), ' ')
                            AND NVL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), ' ') = NVL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)), ' ')
                         WHERE 1 = 1
                           AND X.BASIS_YYYYMMDD >= B.VALID_START_DATE
                           AND X.BASIS_YYYYMMDD <= B.VALID_END_DATE
                           AND B.ITEM_ID IS NOT NULL;
                    END;
                END;

                BEGIN
                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                /* CUST_FCST_EDI 및 하위 MEASURE 생성 (BEGIN) */
                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                    DELETE FROM DM_PLN_MKT_FCST
                     WHERE MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')  /* CUST_fcst는 제외 */
                       AND YYYYMMDD >= V_TODAY
                       AND EXISTS (
                                    SELECT X.PROJECT_CODE
                                      FROM GT_DDECM_EDI_MKT_FCST_ALL X
                                     WHERE DM_PLN_MKT_FCST.DIVISION_ID  = X.DIVISION_ID
                                       AND DM_PLN_MKT_FCST.DOM_EXP      = 'E'
                                       AND DM_PLN_MKT_FCST.ATTRIBUTE5   = X.SENDER_NAME
                                       AND X.BASIS_YYYYMMDD             >= V_TODAY   /* 금일 20240105 당주월요일이후 */
                                  );

                /* 날짜 중복데이터는 SUM한 값으로 입력 */
                    INSERT INTO DM_PLN_MKT_FCST
                        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE4    /* SENDER_CODE 값 저장 */
                        , ATTRIBUTE5    /* SENDER_NAME 값 저장 */
                        , ATTRIBUTE6    /* IFSEQNO 값 저장 */
                        , ATTRIBUTE7    /* LEADTIME 적용전 ORIGINAL YYYYMMDD 값 저장 */
                        , ATTRIBUTE8    /* EDI_LT 값 저장 */
                        , ATTRIBUTE9    /* CREATE_DATE 값 저장 */
                        , ATTRIBUTE10)  /* 소급적용여부 */
                    SELECT A.DIVISION_ID
                         , A.PROJECT_CODE
                         , A.SCM_SITE_ID
                         , A.ITEM_ID
                         , A.DOM_EXP
                         , A.ERP_FCST_TYPE                            AS FCST_TYPE
                         , A.EDI_INCOTERMS                            AS INCOTERMS
                         , 'CUST_FCST_EDI'                            AS MEASURE
                         , NVL(NULLIF(RTRIM(A.SALES_PLANT_SITE_ID),''), '/')           AS PLANT_SITE_ID
                         , A.BASIS_YYYYMMDD                           AS YYYYMMDD
                         , SUM(TO_NUMBER(REPLACE(A.QTY, ',', '')))    AS QTY
                         , 'EDI'
                         , SYSDATE
                         , 'EDI'
                         , SYSDATE
                         , MAX(A.SENDER_CODE)                         AS ATTRIBUTE4
                         , MAX(A.SENDER_NAME)                         AS ATTRIBUTE5
                         , MAX(A.IFSEQNO)                             AS ATTRIBUTE6
                         , MAX(A.YYYYMMDD)                            AS ATTRIBUTE7
                         , MAX(A.EDI_LT)                              AS ATTRIBUTE8
                         , MAX(A.CREATE_DATE)                         AS ATTRIBUTE9
                         , MAX(A.CHANGE_STATUS)                       AS ATTRIBUTE10
                      FROM GT_DDECM_EDI_MKT_FCST A
                      INNER JOIN (
                                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, SCHEDULING_TYPE, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' ')  AS SALES_PLANT_SITE_ID
                                         , BASIS_YYYYMMDD, CREATE_DATE
                                      FROM GT_DDECM_EDI_MKT_FCST
                                     WHERE BASIS_YYYYMMDD >= V_TODAY   /* 금일 20240105 */
                                     GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, SCHEDULING_TYPE, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' '), BASIS_YYYYMMDD, CREATE_DATE
                                 ) B
                        ON  A.DIVISION_ID     = B.DIVISION_ID
                        AND A.PROJECT_CODE    = B.PROJECT_CODE
                        AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                        AND A.ITEM_ID         = B.ITEM_ID
                        AND A.SCHEDULING_TYPE = B.SCHEDULING_TYPE
                        AND A.DOM_EXP         = B.DOM_EXP
                        AND A.ERP_FCST_TYPE   = B.ERP_FCST_TYPE
                        AND A.UNLOADING_POINT = B.UNLOADING_POINT
                        AND A.CUSTOMER_PLANT  = B.CUSTOMER_PLANT
                        AND A.EDI_INCOTERMS   = B.EDI_INCOTERMS
                        AND NVL(A.SALES_PLANT_SITE_ID, ' ') = NVL(B.SALES_PLANT_SITE_ID, ' ')
                        AND A.CREATE_DATE     = B.CREATE_DATE
                        AND A.BASIS_YYYYMMDD  = B.BASIS_YYYYMMDD
                     WHERE 1 = 1
                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE, A.EDI_INCOTERMS
                         , NVL(NULLIF(RTRIM(A.SALES_PLANT_SITE_ID),''), '/') /* [E20261009-GRPBYFIX] GROUP BY 식 = SELECT 식 */, A.BASIS_YYYYMMDD;
                END;

                /* MEASURE별 SUM한 값으로 생성 */
                BEGIN
                    INSERT INTO DM_PLN_MKT_FCST
                        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
                    SELECT A.DIVISION_ID
                         , A.PROJECT_CODE
                         , A.SCM_SITE_ID
                         , A.ITEM_ID
                         , A.DOM_EXP
                         , A.ERP_FCST_TYPE
                         , A.EDI_INCOTERMS
                         , CASE WHEN A.SCHEDULING_TYPE = '4'  THEN 'Planning_Forecast'
                                WHEN A.SCHEDULING_TYPE = '10' THEN 'Immidiate'
                                WHEN A.SCHEDULING_TYPE = '24' THEN 'Commercial_Agreement'
                                WHEN A.SCHEDULING_TYPE = '1'  THEN 'Firm_Temp'
                                WHEN A.SCHEDULING_TYPE = '2'  THEN 'Manumacturing_Material_Temp'
                                WHEN A.SCHEDULING_TYPE = '3'  THEN 'Material_Temp'
                                WHEN A.SCHEDULING_TYPE = '83' THEN 'Backorder'
                           END                                       AS MEASURE
                         , NVL(NULLIF(RTRIM(A.SALES_PLANT_SITE_ID),''), '/')           AS PLANT_SITE_ID
                         , A.BASIS_YYYYMMDD
                         , SUM(TO_NUMBER(REPLACE(A.QTY, ',', '')))
                         , 'EDI'
                         , SYSDATE
                         , 'EDI'
                         , SYSDATE
                         , MAX(A.SENDER_CODE)                        AS ATTRIBUTE4
                         , MAX(A.SENDER_NAME)                        AS ATTRIBUTE5
                         , MAX(A.IFSEQNO)                            AS ATTRIBUTE6
                         , MAX(A.YYYYMMDD)                           AS ATTRIBUTE7
                         , MAX(A.EDI_LT)                             AS ATTRIBUTE8
                         , MAX(A.CREATE_DATE)                        AS ATTRIBUTE9
                         , MAX(A.CHANGE_STATUS)                      AS ATTRIBUTE10
                      FROM GT_DDECM_EDI_MKT_FCST A
                      INNER JOIN (
                                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, SCHEDULING_TYPE, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' ')  AS SALES_PLANT_SITE_ID
                                         , BASIS_YYYYMMDD, CREATE_DATE
                                      FROM GT_DDECM_EDI_MKT_FCST
                                     WHERE BASIS_YYYYMMDD >= V_TODAY   /* 금일 20240105 */
                                     GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, SCHEDULING_TYPE, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' '), BASIS_YYYYMMDD, CREATE_DATE
                                 ) B
                        ON  A.DIVISION_ID     = B.DIVISION_ID
                        AND A.PROJECT_CODE    = B.PROJECT_CODE
                        AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                        AND A.ITEM_ID         = B.ITEM_ID
                        AND A.SCHEDULING_TYPE = B.SCHEDULING_TYPE
                        AND A.DOM_EXP         = B.DOM_EXP
                        AND A.ERP_FCST_TYPE   = B.ERP_FCST_TYPE
                        AND A.UNLOADING_POINT = B.UNLOADING_POINT
                        AND A.CUSTOMER_PLANT  = B.CUSTOMER_PLANT
                        AND A.EDI_INCOTERMS   = B.EDI_INCOTERMS
                        AND NVL(A.SALES_PLANT_SITE_ID, ' ') = NVL(B.SALES_PLANT_SITE_ID, ' ')
                        AND A.CREATE_DATE     = B.CREATE_DATE
                        AND A.BASIS_YYYYMMDD  = B.BASIS_YYYYMMDD
                     WHERE 1 = 1
                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE, A.EDI_INCOTERMS
                         , A.SCHEDULING_TYPE, NVL(NULLIF(RTRIM(A.SALES_PLANT_SITE_ID),''), '/') /* [E20261009-GRPBYFIX] GROUP BY 식 = SELECT 식 */, A.BASIS_YYYYMMDD;
                END;

                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                /* CUST_FCST_EDI 및 하위 MEASURE 생성 (END) */
                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                /* [E20241126-000426]_Cust.FCST(P+P) Measure 로직 수정 START */
                /* 프로시져를 호출하여, CUST_FCST 메져 데이터를 생성한다 */
                DELETE FROM GT_DDECM_CUST_FCST_DIVISION;

                INSERT INTO GT_DDECM_CUST_FCST_DIVISION (DIVISION_ID, SEQ)
                SELECT DIVISION_ID
                     , ROW_NUMBER() OVER (ORDER BY DIVISION_ID) - 1  AS SEQ
                  FROM (SELECT DISTINCT DIVISION_ID FROM GT_DDECM_EDI_MKT_FCST);

                SELECT NVL(MAX(SEQ), -1) INTO V_CUST_FCST_CNT FROM GT_DDECM_CUST_FCST_DIVISION;
                V_CUST_FCST_I        := 0;
                V_CUST_FCST_DIVISION := NULL;

                WHILE V_CUST_FCST_I <= V_CUST_FCST_CNT LOOP
                    SELECT DIVISION_ID INTO V_CUST_FCST_DIVISION
                      FROM GT_DDECM_CUST_FCST_DIVISION
                     WHERE SEQ = V_CUST_FCST_I;

                    /* DIVISION 단위로 생성 (CUST_FCST = CUST_FCST_EDI + RPA + EXCEL) */
                    PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST(V_CUST_FCST_DIVISION);   /* > 81, 81_UC */
                    V_CUST_FCST_I := V_CUST_FCST_I + 1;
                END LOOP;

                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                /* History 기능 추가 (BEGIN) */
                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                BEGIN
                    INSERT INTO DM_PLN_MKT_FCST_H
                        (DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
                    SELECT B.DIVISION_ID
                         , SEQ1_DM_PLN_MKT_FCST_H.NEXTVAL   /* History Seqno */
                         , B.PROJECT_CODE
                         , B.SCM_SITE_ID
                         , B.ITEM_ID
                         , B.DOM_EXP
                         , FCST_TYPE
                         , INCOTERMS
                         , MEASURE
                         , PLANT_SITE_ID
                         , B.BASIS_YYYYMMDD
                         , TO_NUMBER(REPLACE(B.QTY, ',', ''))
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                      FROM DM_PLN_MKT_FCST A
                      INNER JOIN GT_DDECM_EDI_MKT_FCST B
                        ON  A.DIVISION_ID  = B.DIVISION_ID
                        AND A.PROJECT_CODE = B.PROJECT_CODE
                        AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                        AND A.ITEM_ID      = B.ITEM_ID
                        AND A.MEASURE      = CASE WHEN B.SCHEDULING_TYPE = '4'  THEN 'Planning_Forecast'
                                                  WHEN B.SCHEDULING_TYPE = '10' THEN 'Immidiate'
                                                  WHEN B.SCHEDULING_TYPE = '24' THEN 'Commercial_Agreement'
                                                  WHEN B.SCHEDULING_TYPE = '1'  THEN 'Firm_Temp'
                                                  WHEN B.SCHEDULING_TYPE = '2'  THEN 'Manumacturing_Material_Temp'
                                                  WHEN B.SCHEDULING_TYPE = '3'  THEN 'Material_Temp'
                                                  WHEN B.SCHEDULING_TYPE = '83' THEN 'Backorder'
                                             END
                        AND A.PLANT_SITE_ID = B.SALES_PLANT_SITE_ID
                        AND A.YYYYMMDD      = B.BASIS_YYYYMMDD
                      INNER JOIN (
                                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' ')  AS SALES_PLANT_SITE_ID
                                         , BASIS_YYYYMMDD, CREATE_DATE
                                      FROM GT_DDECM_EDI_MKT_FCST
                                     WHERE BASIS_YYYYMMDD >= V_TODAY   /* 금일 20240105 */
                                     GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' '), BASIS_YYYYMMDD, CREATE_DATE
                                 ) C
                        ON  A.DIVISION_ID     = C.DIVISION_ID
                        AND B.PROJECT_CODE    = C.PROJECT_CODE
                        AND B.SCM_SITE_ID     = C.SCM_SITE_ID
                        AND B.ITEM_ID         = C.ITEM_ID
                        AND B.DOM_EXP         = C.DOM_EXP
                        AND B.ERP_FCST_TYPE   = C.ERP_FCST_TYPE
                        AND B.UNLOADING_POINT = C.UNLOADING_POINT
                        AND B.CUSTOMER_PLANT  = C.CUSTOMER_PLANT
                        AND B.EDI_INCOTERMS   = C.EDI_INCOTERMS
                        AND NVL(B.SALES_PLANT_SITE_ID, ' ') = NVL(C.SALES_PLANT_SITE_ID, ' ')
                        AND B.CREATE_DATE     = C.CREATE_DATE
                        AND B.BASIS_YYYYMMDD  = C.BASIS_YYYYMMDD
                     WHERE 1 = 1
                       AND A.YYYYMMDD >= V_TODAY   /* 금일 20240105 W1월요일이후 */
                       AND A.MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder');
                END;
                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                /* History 기능 추가 (END) */
                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */

            END;

        END;

        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
        /* CUST_FCST_EDI[Org.] START */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
        BEGIN
            /* 테이블중복제거 / 임시확인용테이블 중복제거 */
            DELETE FROM GT_DDECM_EDI_END_CUSTOMER_ORG;

            /* EDI END_CUSTOMER별 기간 설정 */
            BEGIN
                /* EDI_END_CUSTOMER_ORG Lookup의 Active = 'Off'이면 CREATE_DATE -52주부터, 'On'이면 Lookup 기간 사용 */
                /* ORG Lookup의 Active가 'On'이면 Lookup기간중 EDI 데이터 미수신시 수량 0으로 변경 */
                INSERT INTO GT_DDECM_EDI_END_CUSTOMER_ORG
                    (DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, FROM_WEEK, FROM_DAY, TO_WEEK, TO_DAY, ACTIVE)
                SELECT A.DIVISION_ID                                       AS DIVISION_ID
                     , A.END_CUSTOMER                                      AS END_CUSTOMER
                     , NVL(NULLIF(RTRIM(B.SEGMENT4),''), '/')                                AS SCM_SITE_ID
                     , CASE WHEN NVL(B.SEGMENT5, 'On') = 'On' THEN NVL(B.ATTRIBUTE1, '-1')
                            ELSE '-52'
                       END                                                 AS FROM_WEEK
                     , NVL(B.ATTRIBUTE2, 'TUE')                            AS FROM_DAY
                     , NVL(B.ATTRIBUTE3, '0')                              AS TO_WEEK
                     , NVL(B.ATTRIBUTE4, 'MON')                            AS TO_DAY
                     , NVL(B.SEGMENT5, 'On')                               AS ACTIVE
                  FROM SCM_MST_SITE A
                  LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                    ON  B.LOOKUP_TYPE  = 'EDI_END_CUSTOMER_ORG'
                    AND A.DIVISION_ID  = B.SEGMENT1
                    AND A.END_CUSTOMER = B.SEGMENT2
                    AND B.VALID_YN     = 'Y'
                 WHERE A.END_CUSTOMER IS NOT NULL
                 GROUP BY A.DIVISION_ID, A.END_CUSTOMER, B.SEGMENT4, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4, B.SEGMENT5;
            END;

            BEGIN
                /* 테이블중복제거 / 임시확인용테이블 중복제거 */
                DELETE FROM GT_DDECM_EDI_ORG_ALL;

                /* EDI STATUS_CODE가 SUCCESS인 DATA */
                BEGIN
                    /* SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT, ITEM_ID, SCHEDULING 기준으로 DATA 추출 */
                    INSERT INTO GT_DDECM_EDI_ORG_ALL
                        (NUM, DIVISION_ID, IFSEQNO, SOLDTO_CODE, SHIPTO_CODE, UNLOADING_POINT, CUSTOMER_PLANT, SCHEDULING_TYPE
                        , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, ERP_FCST_TYPE, CREATE_DATE, CREATE_TIME, MESSAGE_TYPE, END_CUSTOMER, SENDER_NAME, YYYYMMDD)
                    SELECT ROW_NUMBER() OVER (ORDER BY A.IFSEQNO)          AS NUM
                         , A.DIVISION_ID
                         , A.IFSEQNO
                         , A.SOLDTO_CODE
                         , A.SHIPTO_CODE
                         , A.UNLOADING_POINT
                         , A.CUSTOMER_PLANT
                         , A.SCHEDULING_TYPE
                         , A.PROJECT_CODE
                         , A.SCM_SITE_ID
                         , A.ITEM_ID
                         , A.ERP_FCST_TYPE
                         , A.CREATE_DATE
                         , A.CREATE_TIME
                         , A.MESSAGE_TYPE
                         , A.END_CUSTOMER
                         , A.SENDER_NAME
                         , A.YYYYMMDD
                      FROM (
                            SELECT ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.SCHEDULING_TYPE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
                                                                 , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END
                                                      ORDER BY A.CREATE_DATE DESC, A.IFSEQNO DESC)   AS RNK
                                 , A.DIVISION_ID
                                 , A.IFSEQNO
                                 , A.SOLDTO_CODE
                                 , A.SHIPTO_CODE
                                 , A.UNLOADING_POINT
                                 , A.CUSTOMER_PLANT
                                 , A.SCHEDULING_TYPE
                                 , A.PROJECT_CODE
                                 , A.SCM_SITE_ID
                                 , A.ITEM_ID
                                 , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END         AS ERP_FCST_TYPE
                                 , A.CREATE_DATE
                                 , A.CREATE_TIME
                                 , A.MESSAGE_TYPE
                                 , B.END_CUSTOMER
                                 , A.SENDER_NAME
                                 , A.YYYYMMDD
                              FROM DM_DNM_EDI_CALLOFF_ITEM A
                              LEFT OUTER JOIN SCM_MST_SITE B
                                ON  A.DIVISION_ID = B.DIVISION_ID
                                AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                AND B.SITE_TYPE   = 'SALES'
                                AND B.VALID_YN    = 'Y'
                                AND REPLACE(B.END_CUSTOMER, '-', '') IS NOT NULL
                              LEFT OUTER JOIN LATERAL (SELECT C1.*
                                             FROM GT_DDECM_EDI_END_CUSTOMER_ORG C1
                                            WHERE A.DIVISION_ID  = C1.DIVISION_ID
                                              AND C1.END_CUSTOMER = B.END_CUSTOMER
                                              AND C1.SCM_SITE_ID  = NVL((SELECT X99.SCM_SITE_ID
                                                                           FROM GT_DDECM_EDI_END_CUSTOMER_ORG X99
                                                                          WHERE X99.DIVISION_ID  = A.DIVISION_ID
                                                                            AND X99.END_CUSTOMER = B.END_CUSTOMER
                                                                            AND X99.SCM_SITE_ID  = A.SCM_SITE_ID), '/')) C ON (1 = 1)
                             WHERE 1 = 1
                               AND A.CREATE_DATE >= V_FROM_YYYYMMDD
                               AND A.YYYYMMDD    >= V_TODAY   /* 당일 이후 */
/*
   [원본 보존] 아래 CALENDAR 기반 CREATE_DATE 시작/종료일 산출 블록은 원본 MSSQL에서 주석처리되어 비활성 상태임.
   AND A.CREATE_DATE >= (
       SELECT BASIS_YYYYMMDD
       FROM (
             SELECT RANK() OVER (ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK, DT.BASIS_YYYYMMDD
             FROM   SCM_SYS_CALENDAR_M DT
             WHERE  BASIS_YYYYMMDD <= (CASE WHEN TO_NUMBER(TO_CHAR(SYSDATE,'D')) = 2 THEN TO_CHAR(SYSDATE-1,'YYYYMMDD')
                                            WHEN TO_NUMBER(TO_CHAR(SYSDATE,'D')) = 3 THEN (CASE WHEN V_HOUR < '05' THEN TO_CHAR(SYSDATE-2,'YYYYMMDD') ELSE TO_CHAR(SYSDATE,'YYYYMMDD') END)
             AND    DAYOFWEEK = C.FROM_DAY
            ) D
       WHERE D.RK = C.FROM_WEEK
   )
   AND A.CREATE_DATE <= (
       SELECT BASIS_YYYYMMDD
       FROM (
             SELECT (CASE WHEN DAYOFWEEK = 'SUN' THEN RANK() OVER (ORDER BY BASIS_YYYYMMDD) - 2
                          ELSE RANK() OVER (ORDER BY BASIS_YYYYMMDD) - 1 END) AS RK, DT.BASIS_YYYYMMDD
             FROM   SCM_SYS_CALENDAR_M DT
             WHERE  BASIS_YYYYMMDD >= (CASE WHEN TO_NUMBER(TO_CHAR(SYSDATE,'D')) = 2 THEN TO_CHAR(SYSDATE-1,'YYYYMMDD')
                                            WHEN TO_NUMBER(TO_CHAR(SYSDATE,'D')) = 3 THEN (CASE WHEN V_HOUR < '05' THEN TO_CHAR(SYSDATE-2,'YYYYMMDD') ELSE TO_CHAR(SYSDATE,'YYYYMMDD') END)
             AND    DAYOFWEEK = C.TO_DAY
            ) D
       WHERE D.RK = C.TO_WEEK
   )
*/
                               AND A.STATUS_CODE = 'S'
                               AND EXISTS (
                                            SELECT *
                                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                                             WHERE LUP.LOOKUP_TYPE = 'DM_EDI_CALLOFF_MKT_FCST_END_CUSTOMER'
                                               AND LUP.SEGMENT1    = A.DIVISION_ID
                                               AND LUP.SEGMENT2    = A.SENDER_NAME
                                               AND LUP.SEGMENT3    = B.END_CUSTOMER
                                               AND LUP.SEGMENT4    = A.SCHEDULING_TYPE
                                               AND A.MESSAGE_TYPE  = CASE WHEN LUP.SEGMENT5 IN ('DELJIT', 'DELFOR') THEN LUP.SEGMENT5   /* DELJIT / DELFOR로 정의되어 있으면. 정의된 데이터만 추출함. */
                                                                          ELSE (CASE WHEN A.YYYYMMDD <= V_YYYYMMDD THEN 'DELJIT' ELSE 'DELFOR' END)
                                                                     END
                                               AND LUP.VALID_YN = 'Y'
                                               AND ((LENGTH(LUP.ATTRIBUTE2) < 8 AND LENGTH(LUP.ATTRIBUTE3) < 8) OR (A.YYYYMMDD BETWEEN LUP.ATTRIBUTE1 AND LUP.ATTRIBUTE2))
                                          )
                             GROUP BY A.DIVISION_ID
                                    , A.IFSEQNO
                                    , A.SOLDTO_CODE
                                    , A.SHIPTO_CODE
                                    , A.UNLOADING_POINT
                                    , A.CUSTOMER_PLANT
                                    , A.SCHEDULING_TYPE
                                    , A.PROJECT_CODE
                                    , A.SCM_SITE_ID
                                    , A.ITEM_ID
                                    , CASE WHEN A.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END
                                    , A.CREATE_DATE
                                    , A.CREATE_TIME
                                    , A.MESSAGE_TYPE
                                    , B.END_CUSTOMER
                                    , A.SENDER_NAME
                                    , A.YYYYMMDD
                           ) A
                     WHERE RNK = 1
                       AND LENGTH(A.YYYYMMDD) = 8    /* 강현준 추가 ('444444' 가 추가되어 있음 */
                     ORDER BY A.IFSEQNO;
                END;

                /* 테이블중복제거 / 임시확인용테이블 중복제거 */
                DELETE FROM GT_DDECM_EDI_MKT_FCST_ORG;

                /* 기존 로직: 전체 대상 추출 ,삭제를 위한 자료 추출(고객수요 N:N Mapping 적용전 전체) */
                DELETE FROM GT_DDECM_EDI_MKT_FCST_ORG_ALL;

                SELECT COUNT(*) INTO V_CNT_ORG FROM GT_DDECM_EDI_ORG_ALL;

                IF V_CNT_ORG > 0 THEN

                    INSERT INTO GT_DDECM_EDI_MKT_FCST_ORG_ALL
                        (EDI_IF_SEQ, SUB_NO, YYYYMMDD, DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, ERP_FCST_TYPE
                        , BASIS_YYYYMMDD, QTY, EDI_INCOTERMS, SALES_PLANT_SITE_ID, DOM_EXP, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE
                        , DOC_IDENTIFINER, MESSAGE_TYPE, UNLOADING_POINT, CUSTOMER_PLANT, RDD_START, RDD_END, IFSEQNO
                        , SCHEDULING_TYPE, DELFOR_TYPE, EDI_LT, CUST_MATERIAL_CODE, CREATE_DATE, CREATE_TIME, SENDER_CODE, SENDER_NAME, CHANGE_STATUS)
                    SELECT X1.EDI_IF_SEQ, X1.SUB_NO, X1.YYYYMMDD
                         , X1.DIVISION_ID, X1.SCM_SITE_ID, X1.ITEM_ID, X1.PROJECT_CODE
                         , CASE WHEN X1.ERP_FCST_TYPE = 'S' THEN 'SMC' ELSE 'MPS' END              AS ERP_FCST_TYPE
                         , X1.BASIS_YYYYMMDD, X1.QTY, X1.EDI_INCOTERMS, X1.SALES_PLANT_SITE_ID
                         , 'E'                                                                     AS DOM_EXP
                         , X1.COMPANY_ID, X1.SOLDTO_CODE, X1.SHIPTO_CODE
                         , X1.DOC_IDENTIFINER, X1.MESSAGE_TYPE
                         , NVL(RTRIM(LTRIM(X1.UNLOADING_POINT)), ' ')                              AS UNLOADING_POINT
                         , NVL(RTRIM(LTRIM(X1.CUSTOMER_PLANT)), ' ')                               AS CUSTOMER_PLANT
                         , X1.RDD_START, X1.RDD_END
                         , X1.IFSEQNO
                         , X1.SCHEDULING_TYPE
                         , CASE WHEN (X1.MESSAGE_TYPE = 'DELFOR' AND X1.SOLDTO_CODE = 'FR000064' AND X1.RDD_START <> X1.RDD_END AND X1.RDD_START >= V_1WEEK_MONDAY) THEN 'Periodic DELFOR'
                                ELSE NULL
                           END                                                                    AS DELFOR_TYPE
                         , X1.EDI_LT
                         , NVL(RTRIM(LTRIM(X1.CUST_MATERIAL_CODE)), ' ')                           AS CUST_MATERIAL_CODE
                         , X1.CREATE_DATE
                         , X1.CREATE_TIME
                         , X1.SENDER_CODE
                         , X1.SENDER_NAME
                         , X1.ATTRIBUTE10
                      FROM DM_DNM_EDI_CALLOFF_ITEM X1
                      INNER JOIN GT_DDECM_EDI_ORG_ALL X2
                        ON  X1.IFSEQNO         = X2.IFSEQNO
                        AND X1.SOLDTO_CODE     = X2.SOLDTO_CODE
                        AND X1.SHIPTO_CODE     = X2.SHIPTO_CODE
                        AND X1.SCHEDULING_TYPE = X2.SCHEDULING_TYPE
                        AND X1.PROJECT_CODE    = X2.PROJECT_CODE
                        AND X1.SCM_SITE_ID     = X2.SCM_SITE_ID
                        AND X1.ITEM_ID         = X2.ITEM_ID
                        AND X1.SENDER_NAME     = X2.SENDER_NAME
                        AND X1.CREATE_DATE     = X2.CREATE_DATE
                        AND X1.CREATE_TIME     = X2.CREATE_TIME
                        AND X1.SHIPTO_CODE     = X2.SHIPTO_CODE
                     WHERE 1 = 1
                       AND X1.STATUS_CODE = 'S'
                       AND TO_NUMBER(REPLACE(NVL(X1.QTY, '0'), ',', '')) <> 0
                       AND NVL(X1.EXCEPTION_FLAG, 'N') != 'Y';

                    /*
                       2024.04.29    kcw3408       고객수요 N:N Mapping
                       전체 대생 추출후 N:N Model Mapping 작업
                        .집계 시점에 Cust Item/Unloading Point/Plant 반영
                        .Valid Range 1~5에 포함되지 않는 구간은 Calloff 데이터를 집계하지 않음
                        . GT_DDECM_EDI_MKT_FCST_ORG: 최종 결과,insert 작업
                    */
                    INSERT INTO GT_DDECM_EDI_MKT_FCST_ORG
                        (EDI_IF_SEQ, SUB_NO, YYYYMMDD, DIVISION_ID, SCM_SITE_ID, ITEM_ID, PROJECT_CODE, ERP_FCST_TYPE
                        , BASIS_YYYYMMDD, QTY, EDI_INCOTERMS, SALES_PLANT_SITE_ID, DOM_EXP, COMPANY_ID, SOLDTO_CODE, SHIPTO_CODE
                        , DOC_IDENTIFINER, MESSAGE_TYPE, UNLOADING_POINT, CUSTOMER_PLANT, RDD_START, RDD_END, IFSEQNO
                        , SCHEDULING_TYPE, DELFOR_TYPE, EDI_LT, CUST_MATERIAL_CODE, CREATE_DATE, SENDER_CODE, SENDER_NAME, CHANGE_STATUS)
                    SELECT X.EDI_IF_SEQ
                         , X.SUB_NO
                         , X.YYYYMMDD
                         , X.DIVISION_ID
                         , X.SCM_SITE_ID
                         , B.ITEM_ID
                         , X.PROJECT_CODE
                         , X.ERP_FCST_TYPE
                         , X.BASIS_YYYYMMDD
                         , X.QTY
                         , X.EDI_INCOTERMS
                         , X.SALES_PLANT_SITE_ID
                         , X.DOM_EXP
                         , X.COMPANY_ID
                         , X.SOLDTO_CODE
                         , X.SHIPTO_CODE
                         , X.DOC_IDENTIFINER
                         , X.MESSAGE_TYPE
                         , NVL(RTRIM(LTRIM(X.UNLOADING_POINT)), ' ')  AS UNLOADING_POINT
                         , NVL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), ' ')   AS CUSTOMER_PLANT
                         , X.RDD_START
                         , X.RDD_END
                         , X.IFSEQNO
                         , X.SCHEDULING_TYPE
                         , X.DELFOR_TYPE
                         , X.EDI_LT
                         , NVL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), ' ') AS CUST_MATERIAL_CODE
                         , X.CREATE_DATE
                         , X.SENDER_CODE
                         , X.SENDER_NAME
                         , X.CHANGE_STATUS
                      FROM GT_DDECM_EDI_MKT_FCST_ORG_ALL X
                      JOIN GT_DDECM_DM_CUST_MODEL_MAPPING B
                        ON  X.DIVISION_ID   = B.DIVISION_ID
                        AND X.SCM_SITE_ID   = B.SCM_SITE_ID
                        AND X.PROJECT_CODE  = B.PROJECT_CODE
                        AND X.ERP_FCST_TYPE = B.FCST_TYPE
                        AND X.EDI_INCOTERMS = B.INCOTERMS
                        AND X.DOM_EXP       = B.DOM_EXP
                        AND X.ITEM_ID       = B.ITEM_ID
                        AND NVL(RTRIM(LTRIM(X.UNLOADING_POINT)), ' ')   = NVL(RTRIM(LTRIM(B.UNLOADING_POINT)), ' ')
                        AND NVL(RTRIM(LTRIM(X.CUSTOMER_PLANT)), ' ')    = NVL(RTRIM(LTRIM(B.CUSTOMER_PLANT)), ' ')
                        AND NVL(RTRIM(LTRIM(X.CUST_MATERIAL_CODE)), ' ') = NVL(RTRIM(LTRIM(B.CUSTOMER_ITEM_ID)), ' ')
                     WHERE 1 = 1
                       AND X.BASIS_YYYYMMDD >= B.VALID_START_DATE
                       AND X.BASIS_YYYYMMDD <= B.VALID_END_DATE
                       AND B.ITEM_ID IS NOT NULL;

                    DELETE FROM DM_PLN_MKT_FCST
                     WHERE MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
                       AND YYYYMMDD < V_0WEEK_MONDAY   /* 당주월요일이전 */
                       AND YYYYMMDD >= (
                                        SELECT MIN(X.BASIS_YYYYMMDD)
                                          FROM GT_DDECM_EDI_MKT_FCST_ORG_ALL X
                                         WHERE DM_PLN_MKT_FCST.SCM_SITE_ID    = X.SCM_SITE_ID
                                           AND DM_PLN_MKT_FCST.ITEM_ID        = X.ITEM_ID
                                           AND DM_PLN_MKT_FCST.PROJECT_CODE   = X.PROJECT_CODE
                                           AND DM_PLN_MKT_FCST.FCST_TYPE      = X.ERP_FCST_TYPE
                                           AND DM_PLN_MKT_FCST.INCOTERMS      = X.EDI_INCOTERMS
                                           AND DM_PLN_MKT_FCST.PLANT_SITE_ID  = CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID END
                                           AND DM_PLN_MKT_FCST.DOM_EXP        = 'E'
                                           AND DM_PLN_MKT_FCST.DIVISION_ID    = X.DIVISION_ID
                                       )
                       AND EXISTS (
                                    SELECT X.PROJECT_CODE
                                      FROM GT_DDECM_EDI_MKT_FCST_ORG_ALL X
                                     WHERE DM_PLN_MKT_FCST.SCM_SITE_ID    = X.SCM_SITE_ID
                                       AND DM_PLN_MKT_FCST.ITEM_ID        = X.ITEM_ID
                                       AND DM_PLN_MKT_FCST.PROJECT_CODE   = X.PROJECT_CODE
                                       AND DM_PLN_MKT_FCST.FCST_TYPE      = X.ERP_FCST_TYPE
                                       AND DM_PLN_MKT_FCST.INCOTERMS      = X.EDI_INCOTERMS
                                       AND DM_PLN_MKT_FCST.PLANT_SITE_ID  = CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID END
                                       AND DM_PLN_MKT_FCST.DOM_EXP        = 'E'
                                       AND DM_PLN_MKT_FCST.DIVISION_ID    = X.DIVISION_ID
                                  );

                    DELETE FROM DM_PLN_MKT_FCST
                     WHERE MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
                       AND YYYYMMDD >= V_0WEEK_MONDAY   /* 금주월요일이후 */
                       AND YYYYMMDD >= (
                                        SELECT MIN(X.BASIS_YYYYMMDD)
                                          FROM GT_DDECM_EDI_MKT_FCST_ORG_ALL X
                                         WHERE DM_PLN_MKT_FCST.SCM_SITE_ID    = X.SCM_SITE_ID
                                           AND DM_PLN_MKT_FCST.ITEM_ID        = X.ITEM_ID
                                           AND DM_PLN_MKT_FCST.PROJECT_CODE   = X.PROJECT_CODE
                                           AND DM_PLN_MKT_FCST.FCST_TYPE      = X.ERP_FCST_TYPE
                                           AND DM_PLN_MKT_FCST.INCOTERMS      = X.EDI_INCOTERMS
                                           AND DM_PLN_MKT_FCST.PLANT_SITE_ID  = CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID END
                                           AND DM_PLN_MKT_FCST.DOM_EXP        = 'E'
                                           AND DM_PLN_MKT_FCST.DIVISION_ID    = X.DIVISION_ID
                                       )
                       AND EXISTS (
                                    SELECT X.PROJECT_CODE
                                      FROM GT_DDECM_EDI_MKT_FCST_ORG_ALL X
                                     WHERE DM_PLN_MKT_FCST.DIVISION_ID = X.DIVISION_ID
                                       AND DM_PLN_MKT_FCST.ATTRIBUTE5  = X.SENDER_NAME
                                       AND DM_PLN_MKT_FCST.DOM_EXP     = 'E'
                                  );

                    DELETE FROM DM_PLN_MKT_FCST
                     WHERE MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
                       AND YYYYMMDD < V_0WEEK_MONDAY   /* 당주월요일이전 */
                       AND YYYYMMDD >= (
                                        SELECT MIN(X.BASIS_YYYYMMDD)
                                          FROM GT_DDECM_EDI_MKT_FCST_ORG X
                                         WHERE DM_PLN_MKT_FCST.SCM_SITE_ID    = X.SCM_SITE_ID
                                           AND DM_PLN_MKT_FCST.ITEM_ID        = X.ITEM_ID
                                           AND DM_PLN_MKT_FCST.PROJECT_CODE   = X.PROJECT_CODE
                                           AND DM_PLN_MKT_FCST.FCST_TYPE      = X.ERP_FCST_TYPE
                                           AND DM_PLN_MKT_FCST.INCOTERMS      = X.EDI_INCOTERMS
                                           AND DM_PLN_MKT_FCST.PLANT_SITE_ID  = CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID END
                                           AND DM_PLN_MKT_FCST.DOM_EXP        = 'E'
                                           AND DM_PLN_MKT_FCST.DIVISION_ID    = X.DIVISION_ID
                                       )
                       AND EXISTS (
                                    SELECT X.PROJECT_CODE
                                      FROM GT_DDECM_EDI_MKT_FCST_ORG X
                                     WHERE DM_PLN_MKT_FCST.SCM_SITE_ID    = X.SCM_SITE_ID
                                       AND DM_PLN_MKT_FCST.ITEM_ID        = X.ITEM_ID
                                       AND DM_PLN_MKT_FCST.PROJECT_CODE   = X.PROJECT_CODE
                                       AND DM_PLN_MKT_FCST.FCST_TYPE      = X.ERP_FCST_TYPE
                                       AND DM_PLN_MKT_FCST.INCOTERMS      = X.EDI_INCOTERMS
                                       AND DM_PLN_MKT_FCST.PLANT_SITE_ID  = CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID END
                                       AND DM_PLN_MKT_FCST.DOM_EXP        = 'E'
                                       AND DM_PLN_MKT_FCST.DIVISION_ID    = X.DIVISION_ID
                                  );

                    DELETE FROM DM_PLN_MKT_FCST
                     WHERE MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
                       AND YYYYMMDD >= V_0WEEK_MONDAY   /* 금주월요일이후 */
                       AND YYYYMMDD >= (
                                        SELECT MIN(X.BASIS_YYYYMMDD)
                                          FROM GT_DDECM_EDI_MKT_FCST_ORG X
                                         WHERE DM_PLN_MKT_FCST.SCM_SITE_ID    = X.SCM_SITE_ID
                                           AND DM_PLN_MKT_FCST.ITEM_ID        = X.ITEM_ID
                                           AND DM_PLN_MKT_FCST.PROJECT_CODE   = X.PROJECT_CODE
                                           AND DM_PLN_MKT_FCST.FCST_TYPE      = X.ERP_FCST_TYPE
                                           AND DM_PLN_MKT_FCST.INCOTERMS      = X.EDI_INCOTERMS
                                           AND DM_PLN_MKT_FCST.PLANT_SITE_ID  = CASE WHEN X.DIVISION_ID = '81' THEN X.SALES_PLANT_SITE_ID ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID END
                                           AND DM_PLN_MKT_FCST.DOM_EXP        = 'E'
                                           AND DM_PLN_MKT_FCST.DIVISION_ID    = X.DIVISION_ID
                                       )
                       AND EXISTS (
                                    SELECT X.PROJECT_CODE
                                      FROM GT_DDECM_EDI_MKT_FCST_ORG X
                                  );
                END IF;

                /* 날짜 중복데이터는 SUM한 값으로 입력 */
                BEGIN
                    INSERT INTO DM_PLN_MKT_FCST
                        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
                         , A.DOM_EXP, A.ERP_FCST_TYPE, A.EDI_INCOTERMS
                         , 'CUST_FCST_EDI_ORG'                       AS MEASURE
                         , NVL(NULLIF(RTRIM(A.SALES_PLANT_SITE_ID),''), '/')           AS PLANT_SITE_ID
                         , A.BASIS_YYYYMMDD                          AS YYYYMMDD
                         , SUM(TO_NUMBER(REPLACE(A.QTY, ',', '')))   AS QTY
                         , 'EDI'                                     AS CREATED_BY
                         , SYSDATE                                   AS CREATION_DATE
                         , 'EDI'                                     AS LAST_UPDATED_BY
                         , SYSDATE                                   AS LAST_UPDATE_DATE
                         , MAX(A.SENDER_CODE)                        AS ATTRIBUTE4
                         , MAX(A.SENDER_NAME)                        AS ATTRIBUTE5
                         , MAX(A.IFSEQNO)                            AS ATTRIBUTE6
                         , MAX(A.YYYYMMDD)                           AS ATTRIBUTE7
                         , MAX(A.EDI_LT)                             AS ATTRIBUTE8
                         , MAX(A.CREATE_DATE)                        AS ATTRIBUTE9
                         , MAX(A.CHANGE_STATUS)                      AS ATTRIBUTE10
                      FROM GT_DDECM_EDI_MKT_FCST_ORG A
                      INNER JOIN (
                                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, SCHEDULING_TYPE, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' ')  AS SALES_PLANT_SITE_ID
                                         , BASIS_YYYYMMDD, CREATE_DATE
                                      FROM GT_DDECM_EDI_MKT_FCST_ORG
                                     WHERE 1 = 1
                                     GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, SCHEDULING_TYPE, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' '), BASIS_YYYYMMDD, CREATE_DATE
                                 ) B
                        ON  A.DIVISION_ID     = B.DIVISION_ID
                        AND A.PROJECT_CODE    = B.PROJECT_CODE
                        AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                        AND A.ITEM_ID         = B.ITEM_ID
                        AND A.SCHEDULING_TYPE = B.SCHEDULING_TYPE
                        AND A.DOM_EXP         = B.DOM_EXP
                        AND A.ERP_FCST_TYPE   = B.ERP_FCST_TYPE
                        AND A.UNLOADING_POINT = B.UNLOADING_POINT
                        AND A.CUSTOMER_PLANT  = B.CUSTOMER_PLANT
                        AND A.EDI_INCOTERMS   = B.EDI_INCOTERMS
                        AND NVL(A.SALES_PLANT_SITE_ID, ' ') = NVL(B.SALES_PLANT_SITE_ID, ' ')
                        AND A.CREATE_DATE     = B.CREATE_DATE
                        AND A.BASIS_YYYYMMDD  = B.BASIS_YYYYMMDD
                     WHERE 1 = 1
                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.ERP_FCST_TYPE, A.EDI_INCOTERMS
                         , NVL(NULLIF(RTRIM(A.SALES_PLANT_SITE_ID),''), '/') /* [E20261009-GRPBYFIX] GROUP BY 식 = SELECT 식 */, A.BASIS_YYYYMMDD;
                END;

                /* MEASURE별 SUM한 값으로 생성 */
                BEGIN
                    INSERT INTO DM_PLN_MKT_FCST
                        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
                    SELECT A.DIVISION_ID
                         , A.PROJECT_CODE
                         , A.SCM_SITE_ID
                         , A.ITEM_ID
                         , A.DOM_EXP
                         , A.ERP_FCST_TYPE
                         , A.EDI_INCOTERMS
                         , CASE WHEN A.SCHEDULING_TYPE = '1'  THEN 'Firm_Temp[Org.]'
                                WHEN A.SCHEDULING_TYPE = '2'  THEN 'Manumacturing_Material_Temp[Org.]'
                                WHEN A.SCHEDULING_TYPE = '3'  THEN 'Material_Temp[Org.]'
                                WHEN A.SCHEDULING_TYPE = '4'  THEN 'Planning_Forecast[Org.]'
                                WHEN A.SCHEDULING_TYPE = '10' THEN 'Immidiate[Org.]'
                                WHEN A.SCHEDULING_TYPE = '24' THEN 'Commercial_Agreement[Org.]'
                                WHEN A.SCHEDULING_TYPE = '83' THEN 'Backorder[Org.]'
                           END                                       AS MEASURE
                         , NVL(NULLIF(RTRIM(A.SALES_PLANT_SITE_ID),''), '/')           AS PLANT_SITE_ID
                         , A.BASIS_YYYYMMDD                          AS YYYYMMDD
                         , SUM(TO_NUMBER(REPLACE(A.QTY, ',', '')))   AS QTY
                         , 'EDI'                                     AS CREATED_BY
                         , SYSDATE                                   AS CREATION_DATE
                         , 'EDI'                                     AS LAST_UPDATED_BY
                         , SYSDATE                                   AS LAST_UPDATE_DATE
                         , MAX(A.SENDER_CODE)                        AS ATTRIBUTE4
                         , MAX(A.SENDER_NAME)                        AS ATTRIBUTE5
                         , MAX(A.IFSEQNO)                            AS ATTRIBUTE6
                         , MAX(A.YYYYMMDD)                           AS ATTRIBUTE7
                         , MAX(A.EDI_LT)                             AS ATTRIBUTE8
                         , MAX(A.CREATE_DATE)                        AS ATTRIBUTE9
                         , MAX(A.CHANGE_STATUS)                      AS ATTRIBUTE10
                      FROM GT_DDECM_EDI_MKT_FCST_ORG A
                      INNER JOIN (
                                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, SCHEDULING_TYPE, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' ')  AS SALES_PLANT_SITE_ID
                                         , BASIS_YYYYMMDD, CREATE_DATE
                                      FROM GT_DDECM_EDI_MKT_FCST_ORG
                                     WHERE 1 = 1
                                     GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, SCHEDULING_TYPE, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' '), BASIS_YYYYMMDD, CREATE_DATE
                                 ) B
                        ON  A.DIVISION_ID     = B.DIVISION_ID
                        AND A.PROJECT_CODE    = B.PROJECT_CODE
                        AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                        AND A.ITEM_ID         = B.ITEM_ID
                        AND A.SCHEDULING_TYPE = B.SCHEDULING_TYPE
                        AND A.DOM_EXP         = B.DOM_EXP
                        AND A.ERP_FCST_TYPE   = B.ERP_FCST_TYPE
                        AND A.UNLOADING_POINT = B.UNLOADING_POINT
                        AND A.CUSTOMER_PLANT  = B.CUSTOMER_PLANT
                        AND A.EDI_INCOTERMS   = B.EDI_INCOTERMS
                        AND NVL(A.SALES_PLANT_SITE_ID, ' ') = NVL(B.SALES_PLANT_SITE_ID, ' ')
                        AND A.CREATE_DATE     = B.CREATE_DATE
                        AND A.BASIS_YYYYMMDD  = B.BASIS_YYYYMMDD
                     WHERE 1 = 1
                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.SCHEDULING_TYPE, A.DOM_EXP, A.ERP_FCST_TYPE, A.EDI_INCOTERMS
                         , NVL(NULLIF(RTRIM(A.SALES_PLANT_SITE_ID),''), '/') /* [E20261009-GRPBYFIX] GROUP BY 식 = SELECT 식 */, A.BASIS_YYYYMMDD;
                END;

                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                /* CUST_FCST_EDI_ORG 및 하위 MEASURE 생성 (END) */
                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                /* History 기능 추가 (BEGIN) */
                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                BEGIN
                    INSERT INTO DM_PLN_MKT_FCST_H
                        (DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
                    SELECT B.DIVISION_ID
                         , SEQ1_DM_PLN_MKT_FCST_H.NEXTVAL   /* History Seqno */
                         , B.PROJECT_CODE
                         , B.SCM_SITE_ID
                         , B.ITEM_ID
                         , B.DOM_EXP
                         , FCST_TYPE
                         , INCOTERMS
                         , MEASURE
                         , PLANT_SITE_ID
                         , B.BASIS_YYYYMMDD
                         , TO_NUMBER(REPLACE(B.QTY, ',', ''))
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                      FROM DM_PLN_MKT_FCST A
                      INNER JOIN GT_DDECM_EDI_MKT_FCST_ORG B
                        ON  A.DIVISION_ID  = B.DIVISION_ID
                        AND A.PROJECT_CODE = B.PROJECT_CODE
                        AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                        AND A.ITEM_ID      = B.ITEM_ID
                        AND A.YYYYMMDD     = B.BASIS_YYYYMMDD
                      INNER JOIN (
                                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' ')  AS SALES_PLANT_SITE_ID
                                         , BASIS_YYYYMMDD, CREATE_DATE
                                      FROM GT_DDECM_EDI_MKT_FCST_ORG
                                     WHERE BASIS_YYYYMMDD >= V_0WEEK_MONDAY
                                     GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, ERP_FCST_TYPE
                                         , UNLOADING_POINT, CUSTOMER_PLANT, EDI_INCOTERMS
                                         , NVL(SALES_PLANT_SITE_ID, ' '), BASIS_YYYYMMDD, CREATE_DATE
                                 ) C
                        ON  A.DIVISION_ID     = C.DIVISION_ID
                        AND B.PROJECT_CODE    = C.PROJECT_CODE
                        AND B.SCM_SITE_ID     = C.SCM_SITE_ID
                        AND B.ITEM_ID         = C.ITEM_ID
                        AND B.DOM_EXP         = C.DOM_EXP
                        AND B.ERP_FCST_TYPE   = C.ERP_FCST_TYPE
                        AND B.UNLOADING_POINT = C.UNLOADING_POINT
                        AND B.CUSTOMER_PLANT  = C.CUSTOMER_PLANT
                        AND B.EDI_INCOTERMS   = C.EDI_INCOTERMS
                        AND NVL(B.SALES_PLANT_SITE_ID, ' ') = NVL(C.SALES_PLANT_SITE_ID, ' ')
                        AND B.CREATE_DATE     = C.CREATE_DATE
                        AND B.BASIS_YYYYMMDD  = C.BASIS_YYYYMMDD
                     WHERE 1 = 1
                       AND A.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]');
                END;
                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
                /* History 기능 추가 (END) */
                /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */

                /* EDI 데이터 LOOKUP FROM 기간 이후 데이터 미전송시 MKT_FCST 기존 수량을 전부 0으로 변경 START */
                BEGIN
                    /* 테이블중복제거 / 임시확인용테이블 중복제거 */
                    DELETE FROM GT_DDECM_MKT_ORG_DATA;

                    /* MKT_FCST 데이터 생성일 체크 */
                    BEGIN
                        /* LOOKUP적용 */
                        INSERT INTO GT_DDECM_MKT_ORG_DATA
                            (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, PLANT_SITE_ID)
                        SELECT A.DIVISION_ID
                             , A.PROJECT_CODE
                             , A.SCM_SITE_ID
                             , A.ITEM_ID
                             , A.PLANT_SITE_ID
                          FROM (
                                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, PLANT_SITE_ID
                                     , MAX(ATTRIBUTE6) AS IFSEQNO
                                     , MAX(ATTRIBUTE9) AS CREATE_DATE
                                  FROM DM_PLN_MKT_FCST
                                 WHERE MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
                                   AND QTY <> 0
                                 GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, PLANT_SITE_ID
                               ) A
                          LEFT OUTER JOIN SCM_MST_SITE B
                            ON  A.DIVISION_ID = B.DIVISION_ID
                            AND A.SCM_SITE_ID = B.SCM_SITE_ID
                            AND B.SITE_TYPE   = 'SALES'
                            AND B.VALID_YN    = 'Y'
                            AND REPLACE(B.END_CUSTOMER, '-', '') IS NOT NULL
                          LEFT OUTER JOIN LATERAL (SELECT C1.*
                                         FROM GT_DDECM_EDI_END_CUSTOMER_ORG C1
                                        WHERE A.DIVISION_ID  = C1.DIVISION_ID
                                          AND C1.END_CUSTOMER = B.END_CUSTOMER
                                          AND C1.SCM_SITE_ID  = NVL((SELECT X99.SCM_SITE_ID
                                                                       FROM GT_DDECM_EDI_END_CUSTOMER_ORG X99
                                                                      WHERE X99.DIVISION_ID  = A.DIVISION_ID
                                                                        AND X99.END_CUSTOMER = B.END_CUSTOMER
                                                                        AND X99.SCM_SITE_ID  = A.SCM_SITE_ID), '/')) C ON (1 = 1)
                         WHERE A.CREATE_DATE < (
                                SELECT BASIS_YYYYMMDD
                                  FROM (
                                        SELECT RANK() OVER (ORDER BY BASIS_YYYYMMDD DESC) * -1 AS RK, DT.BASIS_YYYYMMDD
                                          FROM SCM_SYS_CALENDAR_M DT
                                         WHERE BASIS_YYYYMMDD <= (CASE WHEN TO_NUMBER(TO_CHAR(SYSDATE, 'D')) = 2 THEN TO_CHAR(SYSDATE - 1, 'YYYYMMDD')
                                                                       WHEN TO_NUMBER(TO_CHAR(SYSDATE, 'D')) = 3 THEN (CASE WHEN V_HOUR < '05' THEN TO_CHAR(SYSDATE - 2, 'YYYYMMDD') ELSE TO_CHAR(SYSDATE, 'YYYYMMDD') END)
                                                                       ELSE TO_CHAR(SYSDATE, 'YYYYMMDD')
                                                                  END)
                                           AND DAYOFWEEK = C.FROM_DAY
                                       ) D
                                 WHERE D.RK = C.FROM_WEEK
                              )
                           AND C.ACTIVE = 'On';
                    END;

                    UPDATE DM_PLN_MKT_FCST MK
                       SET QTY              = 0
                         , LAST_UPDATED_BY  = 'EDI'
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE EXISTS (
                                    SELECT 1
                                      FROM GT_DDECM_MKT_ORG_DATA ED
                                     WHERE MK.DIVISION_ID   = ED.DIVISION_ID
                                       AND MK.PROJECT_CODE  = ED.PROJECT_CODE
                                       AND MK.SCM_SITE_ID   = ED.SCM_SITE_ID
                                       AND MK.ITEM_ID       = ED.ITEM_ID
                                       AND MK.PLANT_SITE_ID = ED.PLANT_SITE_ID
                                  )
                       AND MK.MEASURE IN ('CUST_FCST_EDI_ORG', 'Immidiate[Org.]', 'Planning_Forecast[Org.]', 'Commercial_Agreement[Org.]', 'Firm_Temp[Org.]', 'Manumacturing_Material_Temp[Org.]', 'Material_Temp[Org.]', 'Backorder[Org.]')
                       AND MK.QTY <> 0;
                END;
                /* EDI 데이터 LOOKUP FROM 기간 이후 데이터 미전송시 MKT_FCST 기존 수량을 전부 0으로 변경 END */

            END;
        END;
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */
        /* CUST_FCST_EDI[Org.] END */
        /* ----------------------------------------------------------------------------------------------------------------------------------------------------------------- */

    END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'CUST_FCST_EDI Insert';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                            , 'ERROR'
                            , 0
                            , SQLERRM
                            , NULL
                            , SYSDATE
                            , P_IN_PARA_DATA  => V_IN_PARA_DATA
                            , P_SQL_ERR_CODE  => SQLCODE
                            , P_SQL_ERR_MSG   => SQLERRM
                            , P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        RAISE_APPLICATION_ERROR(-20001
                              , '[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
END;
