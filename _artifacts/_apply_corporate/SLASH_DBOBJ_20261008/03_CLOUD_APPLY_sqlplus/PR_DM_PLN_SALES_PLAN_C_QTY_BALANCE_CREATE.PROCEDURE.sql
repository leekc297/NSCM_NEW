-- [E20261008-SLASHOBJ] PROCEDURE PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE — 사내 현재 원문(적용본, 사내 LAST_DDL 2026-10-08 16:51:14, 1980줄)
CREATE OR REPLACE PROCEDURE           "PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE" 
(   P_DIVISION_ID       IN VARCHAR2                       /* DIVISION_ID */
  , P_CUTOFF_YYYYMMDD   IN VARCHAR2                       /* Sales Plan Cutoff 날짜 */
  , P_CREATION_TYPE     IN VARCHAR2 DEFAULT 'REGULAR'     /* [E20250529-001289] 생성 유형(메일 문구 구분) */
)
/*==============================================================================================================================
 * Program ID   : PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE
 * Description  : 매주 목,금요일에 Sales Plan Weekly cutoff 수행(81 : 목 00시, 40,82 : 금 00시)
 * Program History
 *==============================================================================================================================
 *   Date       In Charge   Description
 *==============================================================================================================================
 * 2020-07-01   P.C.I        [PJ20200138] Sales Plan Waterfall cut-off 주기 변경 - MKT_FCST_C/SALES_PLAN_C 분리(Weekly Cutoff Sales Price Version No 조회 (40,81 : 화요일 /82 : SP Version과 동일))
 * 2020-07-22   P.C.I        [PJ20200138] Sales Plan Weekly Cutoff 생성시 Sales Price, Exchange Rate Cutoff 동시 생성
 * 2020-07-27   P.C.I        [PJ20200138] Sales Plan Weekly Cutoff 생성시 실적은 MKT Fcst가 Cutoff 되는 시점의 화요일 Cutoff 실적을 사용하도록 로직 수정
 * 2020-07-31   HWI1993      과제 - ESS 실적매핑시 내부거래등 제거로직 적용에 따른 RESULT.ATTRIBUTE2 추가(확인) - 변경사항 없음.
 * 2020-09-09   P.C.I        [C20200909-000203] LOG 표준화 적용
 * 2020-12-08   P.C.I        [C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2021-02-05   KUNI         [C20210204-000387] (82)ESS사업부_SALES PLAN WATERFALL에 ETC매출 포함(LOOKUP)
 * 2021-07-02   HWI1993      [C20210629-000239] [SCM PI팀] MKT FCST Amt. 추가의 건
 * 2022-04-07   hwi1993      GM JV 작업
 * 2023-01-17   chano0612    [E20230112-000310] GSCM 자동차사업부 시스템 상 MKT FCST 입력을 위한 기능변경 건 - 선박BIZ건
 * 2023-03-11   chano0612    [E20230309-000241]자동차사업부 GSCM내 선박 고객사 RTF 미부여의 건
 * 2024-04-03   KCW3408      Sales Plan 관련 자동사업부 기타 매출 추가(LOOKUP_TYPE:DM_SALES_PLAN_WATERFALL_SP_W_ADD)
 * 2024-05-28   HMIN         [E20240508-000695] Corvus/Siemens사 자동차사업부 RTF 산출 시 동기화 반영 요청
 *                           룩업(DM_NET_DEMAND_EXCEPTION)에 등록된 SITE대상으로 82번 사업부에 RTF정보를 81번 RTF 정보로 반영 처리
 * 2024-10-30   JSSAE        [E20241024-001084]_MKT FCST ↔ Sales Plan 실적 차이 발생 개선 요청 件
 * 2024-11-15   KJJ          [PJ2024-50611] 소형사업부 Sales Plan 기타매출 입력 추가
 * 2024-11-15   KANG.H.J     [PJ2024-50611] 소형 매출 프로세스 개선
 * 2024-11-29   KANG.H.J     [PJ2024-50611] FROM_SITE_ID가 추가된 'DM_PLN_RTF_ALLOCATION_C' 테이블 Sales Plan Cutoff(전 사업부대상)
 * 2024-12-03   KJJ          [PJ2024-50611] 소형사업부 Sales Plan Catch Up 컷오프 추가
 * 2024-12-17   KJJ          [PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025-03-18   KANG.H.J     [PJ2025-50017] 소형 매출계획 동기화 개선
 * 2025-04-08   KANG.H.J     [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025-04-23   KANG.H.J     [PJ2025-50017] 소형 매출계획 동기화 개선 - MF_W / SF_W 를 LOOKUP 기준에서 조치함. / SCM_FCST 추가
 * 2025-04-28   KANG.H.J     [PJ2025-50017] 소형 매출계획 동기화 개선 - BPS 전송용 FROM_SITE_ID(ATTRIBUTE2 연계) (40사업부/CELL_PROD_SITE_ID='-'일 때만 생성)
 * 2025-05-02   KANG.H.J     [PJ2025-50017] 소형 매출계획 동기화 개선 - #T_PRICE의 CELL_PROD_SITE_ID 기준을 MKT_DEMAND_PLAN_C로 기준 변경
 * 2025-05-07   KANG.H.J     [PJ2025-50188] 기준수요처레에 따른 CUTOFF_TYPE 버젼 생성 구분처리
 * 2025-05-29   KANG.H.J     [PJ2025-50188] 임시테이블 #T3_MKT_FCST / #T3_PRICE DROP 추가, 임시테이블 #T3_MKT_FCST ==> #T_SP_C_BALANCE_MKT_FCST / #T3_PRICE ==> #T_SP_C_BALANCE_PRICE 변경
 * 2025-06-05   KANG.H.J     [PJ2025-50188] EXCEPTION_DEMAND의 CELL_PROD_SITE_ID 수정
 * 2025-06-05   JSSBAE       [E20250529-001289]_DM 장애 대응 개선을 위한 시스템 개선
 * 2025-06-13   KANG.H.J     [PJ2025-50188] SALES_AMT (3종) ATTRIBUTE2 (FROM_SITE_ID) 누락 개선
 * 2025-06-18   KANG.H.J     [PJ2025-50188] ON절에서 WHERE 절로 이동
 * 2025-06-18   KANG.H.J     [PJ2025-50188] 40사업부는 CELL_PROD_SITE_ID까지 PRICE 비교 / 81,82사업부는 CELL_PROD_SITE_ID를 '-'로 치환하여 PRICE 비교
 * 2025.06.23   KANG.H.J     [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.23   JSSBAE       [PJ2025-50188]_소형 매출계획 동기화 개선 고도화 [Sales Price Cutoff 개선]
 * 2026.07.08   JSSBAE       [E20260630-000725]_[요청] SCM Sales Plan Waterfall 내 판가 반영 및 매출금액 산출 로직 오류 점검 요청
 * 2026.07.06   ZIONEX       [PJ202650304] NextSCM Migration
 *
 * EXEC PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE  @p_division_id='81', @p_cutoff_yyyymmdd = '20240401'
 * --PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE '81', '20230314'
 *==============================================================================================================================*/
IS
    /* LOG 용 변수 */
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE';
    V_LOG_TYPE              VARCHAR2(30 CHAR);
    N_LOG_COUNT             NUMBER := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            DATE;
    C_MF_VERSION            VARCHAR2(100 CHAR);
    V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR);
    V_CUTOFF_VERSION_TYPE   VARCHAR2(10 CHAR);
    C_MF_RESULT_VERSION     VARCHAR2(100 CHAR);
    C_SP_RESULT_VERSION     VARCHAR2(100 CHAR);
    C_VER_TYPE              VARCHAR2(10 CHAR)   := 'SP_W';
    V_CREATED_BY            VARCHAR2(1000 CHAR) := 'system';
    V_COUNT                 NUMBER := 0;
    S_COUNT                 NUMBER := 0;
    V_CNT                   NUMBER := 0;
    V_I                     NUMBER := 0;
    V_SITE_ID               VARCHAR2(100 CHAR);
    V_VER_RETURN_NO         VARCHAR2(100 CHAR);
    V_OK_DESCRIPTION        VARCHAR2(1200 CHAR);
    S_BLOCK_MODEL           VARCHAR2(4000 CHAR);
    /* 3. 81번 선박사업부 82번 매출 매핑용(원본 본문 중간 DECLARE -> 선언부로 이관) */
    C_MF_VERSION_81         VARCHAR2(100 CHAR);
    C_SP_VERSION_81         VARCHAR2(100 CHAR);
    P_CUTOFF_YYYYMMDD_81    VARCHAR2(8 CHAR);

    L_CUTOFF_YYYYMMDD       VARCHAR2(8 CHAR);
BEGIN

    DELETE
      FROM GT_DPSPCQB_SP_C_BALANCE_MKT_FCST;
    DELETE
      FROM GT_DPSPCQB_SP_C_BALANCE_PRICE;
    DELETE
      FROM GT_DPSPCQB_SALES_PLAN;
    DELETE
      FROM GT_DPSPCQB_SALES_ETC_PLAN;
    DELETE
      FROM GT_DPSPCQB_AFTER_RTF_81;

    L_CUTOFF_YYYYMMDD := P_CUTOFF_YYYYMMDD;

    DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A001: DIVISION_ID: ' || P_DIVISION_ID || ' / CUTOFF_YYYYMMDD: ' || L_CUTOFF_YYYYMMDD);

    /*=========================================================================================================== */
    /* 변수값 셋팅 */
    /*=========================================================================================================== */
    IF L_CUTOFF_YYYYMMDD IS NULL THEN
        L_CUTOFF_YYYYMMDD := TO_CHAR(SYSDATE, 'YYYYMMDD');
    END IF;

    V_PLAN_START_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(TO_DATE(L_CUTOFF_YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD');   /* 월요일 */

    /*=========================================================================================================== */
    /* 시작 LOG (START) */
    /*=========================================================================================================== */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '@p_division_id : ' || RTRIM(LTRIM(P_DIVISION_ID));
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;

    /* [C20210204-000387] / 2024-04-03 Sales Plan 자동사업부 기타 매출(DM_SALES_PLAN_WATERFALL_SP_W_ADD) */
    IF (P_DIVISION_ID = '82' OR P_DIVISION_ID LIKE '81%') THEN
        S_BLOCK_MODEL := '';
        BEGIN
            SELECT NVL(LOOKUP_TYPE, ' ')
              INTO S_BLOCK_MODEL
              FROM (SELECT LOOKUP_TYPE
                       FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                      WHERE LOOKUP_TYPE  = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                        AND SEGMENT1     = P_DIVISION_ID
                        AND VALID_YN     = 'Y'
                        AND SEGMENT1    IS NOT NULL
                        AND SEGMENT2    IS NOT NULL
                        AND SEGMENT3    IS NOT NULL )
             WHERE ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            S_BLOCK_MODEL := '';
        END;

        IF S_BLOCK_MODEL IS NULL THEN
            V_LOG_TYPE    := 'INVALID';
            DBMS_OUTPUT.PUT_LINE('MODEL : ' || S_BLOCK_MODEL || CHR(10) || 'DM_SALES_PLAN_WATERFALL_SP_W_ADD IS NOT');
            V_DESCRIPTION := 'MODEL : ' || S_BLOCK_MODEL || CHR(10) || 'DM_SALES_PLAN_WATERFALL_SP_W_ADD IS NOT';

            V_LOG_MESSAGE := '########## END of procedure ##########';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            RETURN;
        END IF;
    END IF;

    /*------------------------------------------------------------------------------------------ */
    BEGIN
    /*------------------------------------------------------------------------------------------ */
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A002: DIVISION_ID: ' || P_DIVISION_ID || ' / CUTOFF_YYYYMMDD: ' || L_CUTOFF_YYYYMMDD);

        /* MKT FCST -> SALES PLAN 동기화 진행 */
        PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(P_DIVISION_ID, 'SYSTEM');

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A003: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /* Cutoff Version 생성 */
        PR_DM_PLN_VERSION_CREATE( P_DIVISION_ID
                                , 'SALES_PLAN WEEKLY CUTOFF'
                                , C_VER_TYPE
                                , V_CREATED_BY
                                , V_VER_RETURN_NO
                                , V_OK_DESCRIPTION );

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A004: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /* [PJ2025-50188] VERSION_TYPE 구분 (가장 최근 버젼, SF_W가 MF_W보다 우선) */
        BEGIN
            SELECT VERSION_TYPE
              INTO V_CUTOFF_VERSION_TYPE
              FROM (SELECT VERSION_TYPE
                          , RANK() OVER (ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC, VERSION_TYPE DESC) AS RN
                       FROM DM_MST_VERSION
                      WHERE DIVISION_ID  = P_DIVISION_ID
                        AND VERSION_TYPE IN ('MF_W', 'SF_W')
                        AND YYYYMMDD    >= V_PLAN_START_YYYYMMDD )
             WHERE RN = 1 AND ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            V_CUTOFF_VERSION_TYPE := NULL;
        END;

        SELECT MAX(VERSION_NO)
          INTO C_MF_VERSION      /* 40=SF_W / 그 외=MF_W 기반 VERSION */
          FROM DM_MST_VERSION
         WHERE DIVISION_ID   = P_DIVISION_ID
           AND YYYYMMDD     >= V_PLAN_START_YYYYMMDD
           AND VERSION_TYPE  = V_CUTOFF_VERSION_TYPE;

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A005: DIVISION_ID: ' || P_DIVISION_ID || ' / MF_W버전: ' || C_MF_VERSION);

        SELECT MAX(VERSION_NO)
          INTO C_MF_RESULT_VERSION      /* 실적 연계 VERSION은 MF_W 한정 */
          FROM DM_MST_VERSION
         WHERE DIVISION_ID   = P_DIVISION_ID
           AND YYYYMMDD     >= V_PLAN_START_YYYYMMDD
           AND VERSION_TYPE  = 'MF_W';

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A006: DIVISION_ID: ' || P_DIVISION_ID || ' / 실적버전: ' || C_MF_VERSION);

        /* [PJ20200138] Sales Plan Result Daily Cutoff Version */
        SELECT MIN(VERSION_NO)
          INTO C_SP_RESULT_VERSION
          FROM DM_MST_VERSION
         WHERE DIVISION_ID   = P_DIVISION_ID
           AND YYYYMMDD      = SUBSTR(C_MF_RESULT_VERSION, 6, 8)   /* [PJ2025-50188] 실적 연계 MF_W 한정 */
           AND VERSION_TYPE  = 'SP_D';

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A007: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_D버전: ' || C_SP_RESULT_VERSION);


        V_LOG_TYPE    := 'ING';
        V_LOG_MESSAGE := 'SALES_PLAN WEEKLY CUTOFF';
        V_DESCRIPTION := '@p_division_id : ' || RTRIM(LTRIM(P_DIVISION_ID)) || ' / ' || '@v_ver_return_no : ' || RTRIM(LTRIM(V_VER_RETURN_NO)) || ' / ' || '@c_MF_version : ' || RTRIM(LTRIM(C_MF_VERSION))
                      || ' / ' || '@c_MF_result_version : ' || RTRIM(LTRIM(C_MF_RESULT_VERSION));
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL;

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A008: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_D버전: ' || C_SP_RESULT_VERSION);

        /* [PJ20200138] Sales Price / Exchange Rate Cutoff 동시 생성 */
        /* SALES PRICE CUTOFF (금액) */
        PR_SCM_MST_FUTURE_PRICE_CUTOFF(P_DIVISION_ID, C_VER_TYPE, V_CREATED_BY, V_VER_RETURN_NO, C_MF_RESULT_VERSION);
        /* EXCHANGE CUTOFF (환율) */
        PR_DM_MST_EXCHANGE_RATE_CUTOFF(P_DIVISION_ID, C_VER_TYPE, V_CREATED_BY, V_VER_RETURN_NO);

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A009: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /*=========================================================================================================== */
        /* 1. DM_PLN_SALES_PLAN_C CUTOFF */
        /*=========================================================================================================== */
        /* [PJ2025-50017] 40 = DM_PLN_CFM_MKT_DEMAND_PLAN_C 기반 / 81,82 = DM_PLN_MKT_FCST_C + DM_PLN_CFM_MKT_DEMAND_PLAN_C 기반 */
        IF (P_DIVISION_ID = '40') THEN
            /* DM_PLN_CFM_MKT_DEMAND_PLAN_C -> GT_DPSPCQB_SP_C_BALANCE_MKT_FCST */
            INSERT
              INTO GT_DPSPCQB_SP_C_BALANCE_MKT_FCST
                 ( DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
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
            SELECT DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
                 , YYYYMMDD
                 , QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , V_CREATED_BY AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , ATTRIBUTE1
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , ATTRIBUTE8
                 , ATTRIBUTE9
                 , ATTRIBUTE10
              FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
             WHERE DIVISION_ID  = P_DIVISION_ID
               AND VERSION_NO   = C_MF_VERSION
               AND YYYYMMDD    >= V_PLAN_START_YYYYMMDD;

            /* [PJ2025-50188] RTF_SCP 는 RTF_SYS_RP 기반 COPY 필요 -> 기존 RTF_SCP 삭제 */
            DELETE
              FROM GT_DPSPCQB_SP_C_BALANCE_MKT_FCST
             WHERE DIVISION_ID  = P_DIVISION_ID
               AND VERSION_NO   = C_MF_VERSION
               AND YYYYMMDD    >= V_PLAN_START_YYYYMMDD
               AND MEASURE      = 'RTF_SCP';

            /* RTF_SYS_RP -> RTF_SCP 로 복제 */
            INSERT
              INTO GT_DPSPCQB_SP_C_BALANCE_MKT_FCST
                 ( DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
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
            SELECT DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , 'RTF_SCP' AS MEASURE
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
                 , YYYYMMDD
                 , QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , V_CREATED_BY AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , ATTRIBUTE1
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , ATTRIBUTE8
                 , ATTRIBUTE9
                 , ATTRIBUTE10
              FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
             WHERE DIVISION_ID  = P_DIVISION_ID
               AND VERSION_NO   = C_MF_VERSION
               AND YYYYMMDD    >= V_PLAN_START_YYYYMMDD
               AND MEASURE      = 'RTF_SYS_RP';

            /* DM_PLN_CFM_SELLING_PRICE_C -> GT_DPSPCQB_SP_C_BALANCE_PRICE */
            INSERT
              INTO GT_DPSPCQB_SP_C_BALANCE_PRICE
                 ( DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
                 , ITEM_ID
                 , YYYYMMDD
                 , CURRENCY
                 , MEASURE
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , PRICE
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
            SELECT DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
                 , ITEM_ID
                 , YYYYMMDD
                 , CURRENCY
                 , MEASURE
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , PRICE
                 , CREATED_BY
                 , CREATION_DATE
                 , V_CREATED_BY AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , ATTRIBUTE1
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , ATTRIBUTE8
                 , ATTRIBUTE9
                 , ATTRIBUTE10
              FROM DM_PLN_CFM_SELLING_PRICE_C
             WHERE DIVISION_ID  = P_DIVISION_ID
               AND VERSION_NO   = V_VER_RETURN_NO
               AND YYYYMMDD    >= V_PLAN_START_YYYYMMDD;

            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A011: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);
        ELSE
            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A012: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);


            INSERT
              INTO GT_DPSPCQB_SP_C_BALANCE_MKT_FCST
                 ( DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
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
            SELECT DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , '-' AS CELL_PROD_SITE_ID
                 , YYYYMMDD
                 , QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , V_CREATED_BY AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , ATTRIBUTE1
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , ATTRIBUTE8
                 , ATTRIBUTE9
                 , ATTRIBUTE10
              FROM DM_PLN_MKT_FCST_C
             WHERE DIVISION_ID  = P_DIVISION_ID
               AND VERSION_NO   = C_MF_VERSION
               AND YYYYMMDD    >= V_PLAN_START_YYYYMMDD
               AND MEASURE NOT IN ('RTF','RTF_SYS_RP','RTF_SCP','RTF_PR','SalesAmt_LOC','SalesAmt_KRW','SalesAmt_USD','VMI_IN_PLAN','AS_IN_PLAN')
            UNION
            SELECT DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
                 , YYYYMMDD
                 , QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , V_CREATED_BY AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , ATTRIBUTE1
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , ATTRIBUTE8
                 , ATTRIBUTE9
                 , ATTRIBUTE10
              FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
             WHERE DIVISION_ID  = P_DIVISION_ID
               AND VERSION_NO   = C_MF_VERSION
               AND YYYYMMDD    >= V_PLAN_START_YYYYMMDD
               AND MEASURE IN ('RTF','RTF_SYS_RP','RTF_SCP','RTF_PR','SalesAmt_LOC','SalesAmt_KRW','SalesAmt_USD','VMI_IN_PLAN','AS_IN_PLAN');

            /* SCM_MST_FUTURE_PRICE_C -> GT_DPSPCQB_SP_C_BALANCE_PRICE */
            INSERT
              INTO GT_DPSPCQB_SP_C_BALANCE_PRICE
                 ( DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , PLANT_SITE_ID
                 , CELL_PROD_SITE_ID
                 , ITEM_ID
                 , YYYYMMDD
                 , CURRENCY
                 , MEASURE
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , PRICE
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
            SELECT DISTINCT A.DIVISION_ID
                 , A.VERSION_NO
                 , A.CUTOFF_TYPE
                 , A.CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE
                 , A.SCM_SITE_ID
                 , A.PLANT_SITE_ID
                 , '-' AS CELL_PROD_SITE_ID
                 , A.ITEM_ID
                 , A.YYYYMMDD
                 , A.CURRENCY
                 , A.MEASURE
                 , A.DOM_EXP
                 , A.FCST_TYPE
                 , A.INCOTERMS
                 , A.PRICE
                 , A.CREATED_BY
                 , A.CREATION_DATE
                 , V_CREATED_BY AS LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , A.ATTRIBUTE1
                 , A.ATTRIBUTE2
                 , A.ATTRIBUTE3
                 , A.ATTRIBUTE4
                 , A.ATTRIBUTE5
                 , A.ATTRIBUTE6
                 , A.ATTRIBUTE7
                 , A.ATTRIBUTE8
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
              FROM SCM_MST_FUTURE_PRICE_C A
             WHERE A.DIVISION_ID  = P_DIVISION_ID
               AND A.VERSION_NO   = V_VER_RETURN_NO
               AND A.YYYYMMDD    >= V_PLAN_START_YYYYMMDD;
        END IF;

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A013: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /*=========================================================================================================== */
        /* QTY measure 생성 */
        /*=========================================================================================================== */
        INSERT
          INTO GT_DPSPCQB_SALES_PLAN
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID
             , YYYYMMDD
             , CURRENCY
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
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , NVL(IA.CURRENCY, ' ') AS CURRENCY
             , A.QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , V_CREATED_BY AS LAST_UPDATED_BY
             , SYSDATE
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE7
             , A.ATTRIBUTE8
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
          FROM GT_DPSPCQB_SP_C_BALANCE_MKT_FCST A
             , SCM_SYS_CALENDAR_M B
             , (SELECT *
                   FROM GT_DPSPCQB_SP_C_BALANCE_PRICE
                  WHERE DIVISION_ID  = P_DIVISION_ID
                    AND VERSION_NO   = V_VER_RETURN_NO ) IA
         WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
           AND A.DIVISION_ID       = IA.DIVISION_ID(+)
           AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
           AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
           AND A.ITEM_ID           = IA.ITEM_ID(+)
           AND A.DOM_EXP           = IA.DOM_EXP(+)
           AND A.FCST_TYPE         = IA.FCST_TYPE(+)
           AND A.INCOTERMS         = IA.INCOTERMS(+)
           AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
           AND CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END = IA.CELL_PROD_SITE_ID(+)
           AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
           AND IA.MEASURE(+)       = 'LOC'
           AND A.DIVISION_ID       = P_DIVISION_ID
           AND A.VERSION_NO        = C_MF_VERSION
           AND A.YYYYMMDD         >= V_PLAN_START_YYYYMMDD
           AND A.MEASURE    IN ('MKT_FCST','SCM_FCST','CUST_FCST','TMM_FCST','RTF_SCP','RTF_SYS_RP','RTF','RTF_PR')
           AND A.ITEM_ID    IN (SELECT ITEM_ID
                                   FROM SCM_MST_ITEM_SN
                                  GROUP BY ITEM_ID );

        /*=========================================================================================================== */
        /* AMT measure 생성 (SalesAmt_KRW / LOC / USD, MKT_AMT_KRW / LOC) */
        /*=========================================================================================================== */
        INSERT
          INTO GT_DPSPCQB_SALES_PLAN
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID
             , YYYYMMDD
             , CURRENCY
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

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'SalesAmt_KRW' AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , IA.CURRENCY
             , ROUND(A.QTY * NVL(IA.PRICE, 0), 5)
             , A.CREATED_BY
             , A.CREATION_DATE
             , V_CREATED_BY AS LAST_UPDATED_BY
             , SYSDATE
             , NULL
             , A.ATTRIBUTE2
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM GT_DPSPCQB_SALES_PLAN A
             , SCM_SYS_CALENDAR_M B
             , (SELECT *
                   FROM GT_DPSPCQB_SP_C_BALANCE_PRICE
                  WHERE DIVISION_ID  = P_DIVISION_ID
                    AND VERSION_NO   = V_VER_RETURN_NO ) IA
         WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
           AND A.DIVISION_ID       = IA.DIVISION_ID(+)
           AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
           AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
           AND A.ITEM_ID           = IA.ITEM_ID(+)
           AND A.DOM_EXP           = IA.DOM_EXP(+)
           AND A.FCST_TYPE         = IA.FCST_TYPE(+)
           AND A.INCOTERMS         = IA.INCOTERMS(+)
           AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
           AND CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END = IA.CELL_PROD_SITE_ID(+)
           AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
           AND IA.MEASURE(+)       = 'KRW'
           AND A.DIVISION_ID       = P_DIVISION_ID
           /* [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START)
           AND A.MEASURE           = 'RTF_SCP'   [C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용 */
           AND A.MEASURE           = 'RTF_SYS_RP'

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'SalesAmt_LOC' AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , IA.CURRENCY
             , ROUND(A.QTY * NVL(IA.PRICE, 0), 5)
             , A.CREATED_BY
             , A.CREATION_DATE
             , V_CREATED_BY AS LAST_UPDATED_BY
             , SYSDATE
             , NULL
             , A.ATTRIBUTE2
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM GT_DPSPCQB_SALES_PLAN A
             , SCM_SYS_CALENDAR_M B
             , (SELECT *
                   FROM GT_DPSPCQB_SP_C_BALANCE_PRICE
                  WHERE DIVISION_ID  = P_DIVISION_ID
                    AND VERSION_NO   = V_VER_RETURN_NO ) IA
         WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
           AND A.DIVISION_ID       = IA.DIVISION_ID(+)
           AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
           AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
           AND A.ITEM_ID           = IA.ITEM_ID(+)
           AND A.DOM_EXP           = IA.DOM_EXP(+)
           AND A.FCST_TYPE         = IA.FCST_TYPE(+)
           AND A.INCOTERMS         = IA.INCOTERMS(+)
           AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
           AND CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END = IA.CELL_PROD_SITE_ID(+)
           AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
           AND IA.MEASURE(+)       = 'LOC'
           AND A.DIVISION_ID       = P_DIVISION_ID
           /* [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START)
           AND A.MEASURE           = 'RTF_SCP'   [C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용 */
           AND A.MEASURE           = 'RTF_SYS_RP'

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'SalesAmt_USD' AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , IA.CURRENCY
             , ROUND(A.QTY * NVL(IA.PRICE, 0), 5)
             , A.CREATED_BY
             , A.CREATION_DATE
             , V_CREATED_BY AS LAST_UPDATED_BY
             , SYSDATE
             , NULL
             , A.ATTRIBUTE2
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM GT_DPSPCQB_SALES_PLAN A
             , SCM_SYS_CALENDAR_M B
             , (SELECT *
                   FROM GT_DPSPCQB_SP_C_BALANCE_PRICE
                  WHERE DIVISION_ID  = P_DIVISION_ID
                    AND VERSION_NO   = V_VER_RETURN_NO ) IA
         WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
           AND A.DIVISION_ID       = IA.DIVISION_ID(+)
           AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
           AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
           AND A.ITEM_ID           = IA.ITEM_ID(+)
           AND A.DOM_EXP           = IA.DOM_EXP(+)
           AND A.FCST_TYPE         = IA.FCST_TYPE(+)
           AND A.INCOTERMS         = IA.INCOTERMS(+)
           AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
           AND CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END = IA.CELL_PROD_SITE_ID(+)
           AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
           AND IA.MEASURE(+)       = 'USD'
           AND A.DIVISION_ID       = P_DIVISION_ID
           /* [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START)
           AND A.MEASURE           = 'RTF_SCP'   [C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용 */
           AND A.MEASURE           = 'RTF_SYS_RP'

        UNION ALL
        /* MKT_AMT_KRW (C20200803-000105, [C20210629-000239] 사업부제한 없앰) */
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_AMT_KRW' AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , IA.CURRENCY
             , ROUND(A.QTY * NVL(IA.PRICE, 0), 5)
             , A.CREATED_BY
             , A.CREATION_DATE
             , V_CREATED_BY AS LAST_UPDATED_BY
             , SYSDATE
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM GT_DPSPCQB_SALES_PLAN A
             , SCM_SYS_CALENDAR_M B
             , (SELECT *
                   FROM GT_DPSPCQB_SP_C_BALANCE_PRICE
                  WHERE DIVISION_ID  = P_DIVISION_ID
                    AND VERSION_NO   = V_VER_RETURN_NO ) IA
         WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
           AND A.DIVISION_ID       = IA.DIVISION_ID(+)
           AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
           AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
           AND A.ITEM_ID           = IA.ITEM_ID(+)
           AND A.DOM_EXP           = IA.DOM_EXP(+)
           AND A.FCST_TYPE         = IA.FCST_TYPE(+)
           AND A.INCOTERMS         = IA.INCOTERMS(+)
           AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
           AND CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END = IA.CELL_PROD_SITE_ID(+)
           AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
           AND IA.MEASURE(+)       = 'KRW'
           AND A.MEASURE           = 'MKT_FCST'
        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_AMT_LOC' AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , IA.CURRENCY
             , ROUND(A.QTY * NVL(IA.PRICE, 0), 5)
             , A.CREATED_BY
             , A.CREATION_DATE
             , V_CREATED_BY AS LAST_UPDATED_BY
             , SYSDATE
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
             , NULL
          FROM GT_DPSPCQB_SALES_PLAN A
             , SCM_SYS_CALENDAR_M B
             , (SELECT *
                   FROM GT_DPSPCQB_SP_C_BALANCE_PRICE
                  WHERE DIVISION_ID  = P_DIVISION_ID
                    AND VERSION_NO   = V_VER_RETURN_NO ) IA
         WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
           AND A.DIVISION_ID       = IA.DIVISION_ID(+)
           AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
           AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
           AND A.ITEM_ID           = IA.ITEM_ID(+)
           AND A.DOM_EXP           = IA.DOM_EXP(+)
           AND A.FCST_TYPE         = IA.FCST_TYPE(+)
           AND A.INCOTERMS         = IA.INCOTERMS(+)
           AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
           AND CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END = IA.CELL_PROD_SITE_ID(+)
           AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
           AND IA.MEASURE(+)       = 'LOC'
           AND A.MEASURE           = 'MKT_FCST';

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A014: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /* [C20210204-000387] / 2024-04-03 기타매출(ETC) -> GT_DPSPCQB_SALES_ETC_PLAN */
        INSERT
          INTO GT_DPSPCQB_SALES_ETC_PLAN
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , REMARK_TEXT
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , CURRENCY
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
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.REMARK_TEXT
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.YYYYMMDD
             , A.CURRENCY
             , A.QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , V_CREATED_BY AS LAST_UPDATED_BY
             , SYSDATE
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE7
             , A.ATTRIBUTE8
             , A.ATTRIBUTE9
             , 'ADD.ETC'
          FROM DM_PLN_SALES_ETC_PLAN A
             , SCM_SYS_CALENDAR_M B
         WHERE B.BASIS_YYYYMMDD  = A.YYYYMMDD
           AND A.DIVISION_ID     = P_DIVISION_ID
           AND A.YYYYMMDD       >= V_PLAN_START_YYYYMMDD
           AND A.FCST_TYPE IN (SELECT DISTINCT SEGMENT2
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                 WHERE LOOKUP_TYPE  = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                   AND VALID_YN     = 'Y'
                                   AND SEGMENT1     = A.DIVISION_ID )
           AND A.ITEM_ID IN (SELECT DISTINCT SEGMENT3
                                FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE LOOKUP_TYPE  = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                 AND VALID_YN     = 'Y'
                                 AND SEGMENT1     = A.DIVISION_ID )
           /* [ETC 매출 조회 불가] GSCM MKT FCST 수정 요청 (DM_SALE_PLAN_ETC_EXCEPTION 제외) */
           AND NOT EXISTS (SELECT 1
                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                             WHERE SA.LOOKUP_TYPE  = 'DM_SALE_PLAN_ETC_EXCEPTION'
                               AND SA.VALID_YN     = 'Y'
                               AND A.PROJECT_CODE  = SA.ATTRIBUTE1
                               AND A.ITEM_ID       = SA.SEGMENT2
                               AND A.YYYYMMDD      = SA.SEGMENT4
                               AND A.FCST_TYPE     = SA.ATTRIBUTE3
                               AND A.MEASURE       = SA.SEGMENT3 );

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A015: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /* [PJ2024-50611] 소형사업부 Sales Plan Catch Up 컷오프 추가 */
        INSERT
          INTO GT_DPSPCQB_SALES_ETC_PLAN
             ( DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , REMARK_TEXT
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , CURRENCY
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
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.REMARK_TEXT
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.YYYYMMDD
             , A.CURRENCY
             , A.QTY
             , A.CREATED_BY
             , A.CREATION_DATE
             , V_CREATED_BY AS LAST_UPDATED_BY
             , SYSDATE
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE7
             , A.ATTRIBUTE8
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
          FROM DM_PLN_SALES_ETC_PLAN A
             , SCM_SYS_CALENDAR_M B
         WHERE B.BASIS_YYYYMMDD  = A.YYYYMMDD
           AND A.DIVISION_ID     = P_DIVISION_ID
           AND A.YYYYMMDD       >= V_PLAN_START_YYYYMMDD
           AND A.MEASURE IN ('Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up');

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A016: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /* [E20230309-000241] 자동차사업부 선박 고객사 RTF 미부여 (81) */
        V_COUNT := 0;
        S_COUNT := 0;
        V_CNT   := 0;
        IF (P_DIVISION_ID = '81') THEN
            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A017: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

            SELECT COUNT(SEGMENT2)
              INTO V_CNT
              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
             WHERE LOOKUP_TYPE  = 'DM_NET_DEMAND_EXCEPTION'
               AND VALID_YN     = 'Y';

            V_I := 1;
            WHILE V_I <= V_CNT LOOP
                V_SITE_ID := '';
                BEGIN
                    SELECT SEGMENT2
                      INTO V_SITE_ID
                      FROM (SELECT ROW_NUMBER() OVER(ORDER BY SEGMENT2) AS SEQ
                                  , SEGMENT2
                               FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                              WHERE LOOKUP_TYPE  = 'DM_NET_DEMAND_EXCEPTION'
                                AND VALID_YN     = 'Y' ) IA
                     WHERE IA.SEQ = V_I;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    V_SITE_ID := NULL;
                END;

                SELECT COUNT(*)
                  INTO V_COUNT
                  FROM GT_DPSPCQB_SALES_PLAN
                 WHERE DIVISION_ID  = '81'
                   AND MEASURE      = 'RTF_SYS_RP'
                   AND SCM_SITE_ID  = V_SITE_ID;

                IF (V_COUNT = 0) THEN
                    SELECT COUNT(*)
                      INTO S_COUNT
                      FROM GT_DPSPCQB_SALES_PLAN
                     WHERE DIVISION_ID  = '81'
                       AND SCM_SITE_ID  = V_SITE_ID
                       AND MEASURE      = 'RTF';

                    IF (S_COUNT > 0) THEN
                        UPDATE GT_DPSPCQB_SALES_PLAN
                           SET MEASURE = 'RTF_SYS_RP'
                         WHERE DIVISION_ID  = '81'
                           AND SCM_SITE_ID  = V_SITE_ID
                           AND MEASURE      = 'RTF';
                        DBMS_OUTPUT.PUT_LINE(V_SITE_ID);
                    ELSE
                        INSERT
                          INTO GT_DPSPCQB_SALES_PLAN
                             ( DIVISION_ID
                             , PROJECT_CODE
                             , SCM_SITE_ID
                             , ITEM_ID
                             , DOM_EXP
                             , FCST_TYPE
                             , INCOTERMS
                             , MEASURE
                             , PLANT_SITE_ID
                             , CELL_PROD_SITE_ID
                             , YYYYMMDD
                             , CURRENCY
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
                        SELECT A.DIVISION_ID
                             , A.PROJECT_CODE
                             , A.SCM_SITE_ID
                             , A.ITEM_ID
                             , A.DOM_EXP
                             , A.FCST_TYPE
                             , A.INCOTERMS
                             , 'RTF_SYS_RP' AS MEASURE
                             , A.PLANT_SITE_ID
                             , A.CELL_PROD_SITE_ID
                             , A.YYYYMMDD
                             , NVL(IA.CURRENCY, ' ') AS CURRENCY
                             , A.QTY
                             , A.CREATED_BY
                             , A.CREATION_DATE
                             , V_CREATED_BY AS LAST_UPDATED_BY
                             , SYSDATE
                             , A.ATTRIBUTE1
                             , A.ATTRIBUTE2
                             , A.ATTRIBUTE3
                             , A.ATTRIBUTE4
                             , A.ATTRIBUTE5
                             , A.ATTRIBUTE6
                             , A.ATTRIBUTE7
                             , A.ATTRIBUTE8
                             , A.ATTRIBUTE9
                             , A.ATTRIBUTE10
                          FROM GT_DPSPCQB_SP_C_BALANCE_MKT_FCST A
                             , SCM_SYS_CALENDAR_M B
                             , (SELECT *
                                   FROM GT_DPSPCQB_SP_C_BALANCE_PRICE
                                  WHERE DIVISION_ID  = P_DIVISION_ID
                                    AND VERSION_NO   = V_VER_RETURN_NO ) IA
                         WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
                           AND A.DIVISION_ID       = IA.DIVISION_ID(+)
                           AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
                           AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
                           AND A.ITEM_ID           = IA.ITEM_ID(+)
                           AND A.DOM_EXP           = IA.DOM_EXP(+)
                           AND A.FCST_TYPE         = IA.FCST_TYPE(+)
                           AND A.INCOTERMS         = IA.INCOTERMS(+)
                           AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
                           AND CASE WHEN A.DIVISION_ID = '40' THEN A.CELL_PROD_SITE_ID ELSE '-' END = IA.CELL_PROD_SITE_ID(+)
                           AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
                           AND IA.MEASURE(+)       = 'LOC'
                           AND A.DIVISION_ID       = P_DIVISION_ID
                           AND A.VERSION_NO        = C_MF_VERSION
                           AND A.YYYYMMDD         >= V_PLAN_START_YYYYMMDD
                           AND A.MEASURE    IN ('MKT_FCST')
                           AND A.SCM_SITE_ID       = V_SITE_ID;
                        DBMS_OUTPUT.PUT_LINE(V_SITE_ID);
                    END IF;
                END IF;

                V_I := V_I + 1;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A018: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);
        END IF;

        /* dm_pln_sales_plan_c 에 cutoff data insert (CUTOFF_YYYYMMDD_DATE 가상컬럼 제외) */
        INSERT
          INTO DM_PLN_SALES_PLAN_C
             ( DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID
             , YYYYMMDD
             , CURRENCY
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
        SELECT DISTINCT
               DIVISION_ID
             , V_VER_RETURN_NO
             , C_VER_TYPE
             , L_CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , CELL_PROD_SITE_ID
             , YYYYMMDD
             , CURRENCY
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
          FROM GT_DPSPCQB_SALES_PLAN
         WHERE DIVISION_ID = P_DIVISION_ID;

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A019: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /* [PJ2024-50611] 기타매출, Catch Up 별도 테이블 컷오프 */
        INSERT
          INTO DM_PLN_SALES_ETC_PLAN_C
             ( DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , REMARK_TEXT
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , CURRENCY
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
        SELECT DISTINCT
               DIVISION_ID
             , V_VER_RETURN_NO
             , C_VER_TYPE
             , L_CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , REMARK_TEXT
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , CURRENCY
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , SYSDATE AS LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
          FROM GT_DPSPCQB_SALES_ETC_PLAN
         WHERE DIVISION_ID = P_DIVISION_ID;

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A020: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /*=========================================================================================================== */
        /* 2. DM_PLN_SALES_PLAN_RESULT_C CUTOFF */
        /*=========================================================================================================== */
        INSERT
          INTO DM_PLN_SALES_PLAN_RESULT_C
             ( DIVISION_ID
             , VERSION_NO
             , CUTOFF_TYPE
             , CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , CURRENCY
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
             , ATTRIBUTE10
             , COMPANY_ID
             , CELL_PROD_SITE_ID )
        SELECT DIVISION_ID
             , V_VER_RETURN_NO AS VERSION_NO
             , C_VER_TYPE AS CUTOFF_TYPE
             , TO_CHAR(SYSDATE, 'YYYYMMDD') AS CUTOFF_YYYYMMDD
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , DOM_EXP
             , FCST_TYPE
             , INCOTERMS
             , MEASURE
             , PLANT_SITE_ID
             , YYYYMMDD
             , NVL(NULLIF(RTRIM(CURRENCY),''), '/')
             , QTY
             , CREATED_BY
             , CREATION_DATE
             , V_CREATED_BY AS LAST_UPDATED_BY
             , SYSDATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5
             , ATTRIBUTE6
             , ATTRIBUTE7
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             , COMPANY_ID
             , CELL_PROD_SITE_ID
          FROM DM_PLN_SALES_PLAN_RESULT_C   /* [PJ20200138] 실적은 화요일 Cutoff 실적 사용 */
         WHERE DIVISION_ID  = P_DIVISION_ID
           AND VERSION_NO   = C_SP_RESULT_VERSION;

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A021: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /*=========================================================================================================== */
        /* 3. 81번 선박사업부 82번 매출 매핑 */
        /*=========================================================================================================== */
        IF (P_DIVISION_ID = '82') THEN
            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A022: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

            /* MKT_FCST Cutoff 버전 */
            SELECT MAX(VERSION_NO)
              INTO C_MF_VERSION_81
              FROM DM_MST_VERSION
             WHERE DIVISION_ID   = '81'
               AND VERSION_TYPE  = 'MF_W'
               AND YYYYMMDD     >= V_PLAN_START_YYYYMMDD;

            /* Sales_Plan Cutoff 버전 */
            SELECT MAX(VERSION_NO)
                 , MAX(YYYYMMDD)
              INTO C_SP_VERSION_81
                 , P_CUTOFF_YYYYMMDD_81
              FROM DM_MST_VERSION
             WHERE DIVISION_ID   = '81'
               AND VERSION_TYPE  = 'SP_W'
               AND YYYYMMDD     >= V_PLAN_START_YYYYMMDD;

            DBMS_OUTPUT.PUT_LINE(NVL(C_MF_VERSION_81,'Z') || '||' || NVL(C_SP_VERSION_81,'X') || '||' || NVL(P_CUTOFF_YYYYMMDD_81,'Y'));

            INSERT
              INTO GT_DPSPCQB_AFTER_RTF_81
                 ( DIVISION_ID
                 , VERSION_NO
                 , CUTOFF_TYPE
                 , CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , YYYYMMDD
                 , CURRENCY
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
                 , ATTRIBUTE10
                 , CELL_PROD_SITE_ID )
            WITH SALES_PLAN_TEMP_81 AS (
                /* QTY MEASURE 생성 */
                SELECT A.DIVISION_ID
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , A.MEASURE
                     , A.PLANT_SITE_ID
                     , A.YYYYMMDD
                     , NVL(IA.CURRENCY, ' ') AS CURRENCY
                     , A.QTY
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , 'system' AS LAST_UPDATED_BY
                     , SYSDATE AS LAST_UPDATE_DATE
                     , A.ATTRIBUTE1
                     , A.ATTRIBUTE2
                     , A.ATTRIBUTE3
                     , A.ATTRIBUTE4
                     , A.ATTRIBUTE5
                     , A.ATTRIBUTE6
                     , A.ATTRIBUTE7
                     , A.ATTRIBUTE8
                     , A.ATTRIBUTE9
                     , A.ATTRIBUTE10
                     , A.CELL_PROD_SITE_ID
                  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
                     , SCM_SYS_CALENDAR_M B
                     , (SELECT *
                           FROM SCM_MST_FUTURE_PRICE_C
                          WHERE DIVISION_ID  = '81'
                            AND VERSION_NO   = C_SP_VERSION_81 ) IA
                 WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
                   AND A.DIVISION_ID       = IA.DIVISION_ID(+)
                   AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
                   AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
                   AND A.ITEM_ID           = IA.ITEM_ID(+)
                   AND A.DOM_EXP           = IA.DOM_EXP(+)
                   AND A.FCST_TYPE         = IA.FCST_TYPE(+)
                   AND A.INCOTERMS         = IA.INCOTERMS(+)
                   AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
                   AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
                   AND IA.MEASURE(+)       = 'LOC'
                   AND A.DIVISION_ID       = '81'
                   AND A.VERSION_NO        = C_MF_VERSION_81
                   AND A.YYYYMMDD         >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                   AND A.ITEM_ID    IN (SELECT ITEM_ID
                                           FROM SCM_MST_ITEM_SN
                                          GROUP BY ITEM_ID )
                   AND A.MEASURE    IN ('RTF_SCP','RTF_SYS_RP','RTF')
                   AND A.SCM_SITE_ID IN (SELECT SEGMENT2
                                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                           WHERE LOOKUP_TYPE  = 'DM_NET_DEMAND_EXCEPTION'
                                             AND VALID_YN     = 'Y' )
            )
            , SALES_PLAN_TEMP_81_2 AS (
                /* KRW */
                SELECT A.DIVISION_ID
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , 'SalesAmt_KRW' AS MEASURE
                     , A.PLANT_SITE_ID
                     , A.YYYYMMDD
                     , IA.CURRENCY
                     , ROUND(A.QTY * NVL(IA.PRICE, 0), 5) AS QTY
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , 'system' AS LAST_UPDATED_BY
                     , SYSDATE AS LAST_UPDATE_DATE
                     , NULL AS ATTRIBUTE1
                     , NULL AS ATTRIBUTE2
                     , NULL AS ATTRIBUTE3
                     , NULL AS ATTRIBUTE4
                     , NULL AS ATTRIBUTE5
                     , NULL AS ATTRIBUTE6
                     , NULL AS ATTRIBUTE7
                     , NULL AS ATTRIBUTE8
                     , NULL AS ATTRIBUTE9
                     , NULL AS ATTRIBUTE10
                     , A.CELL_PROD_SITE_ID
                  FROM SALES_PLAN_TEMP_81 A
                     , SCM_SYS_CALENDAR_M B
                     , (SELECT *
                           FROM SCM_MST_FUTURE_PRICE_C
                          WHERE DIVISION_ID  = '81'
                            AND VERSION_NO   = C_SP_VERSION_81 ) IA
                 WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
                   AND A.DIVISION_ID       = IA.DIVISION_ID(+)
                   AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
                   AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
                   AND A.ITEM_ID           = IA.ITEM_ID(+)
                   AND A.DOM_EXP           = IA.DOM_EXP(+)
                   AND A.FCST_TYPE         = IA.FCST_TYPE(+)
                   AND A.INCOTERMS         = IA.INCOTERMS(+)
                   AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
                   AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
                   AND IA.MEASURE(+)       = 'KRW'
                   AND A.DIVISION_ID       = '81'
                   /* [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START)
                   AND A.MEASURE           = 'RTF_SCP'   [C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용 */
                   AND A.MEASURE           = 'RTF_SYS_RP'

                   AND A.SCM_SITE_ID IN (SELECT SEGMENT2
                                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                           WHERE LOOKUP_TYPE  = 'DM_NET_DEMAND_EXCEPTION'
                                             AND VALID_YN     = 'Y' )
                UNION ALL
                /* LOC */
                SELECT A.DIVISION_ID
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , 'SalesAmt_LOC' AS MEASURE
                     , A.PLANT_SITE_ID
                     , A.YYYYMMDD
                     , IA.CURRENCY
                     , ROUND(A.QTY * NVL(IA.PRICE, 0), 5) AS QTY
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , 'system' AS LAST_UPDATED_BY
                     , SYSDATE AS LAST_UPDATE_DATE
                     , NULL AS ATTRIBUTE1
                     , NULL AS ATTRIBUTE2
                     , NULL AS ATTRIBUTE3
                     , NULL AS ATTRIBUTE4
                     , NULL AS ATTRIBUTE5
                     , NULL AS ATTRIBUTE6
                     , NULL AS ATTRIBUTE7
                     , NULL AS ATTRIBUTE8
                     , NULL AS ATTRIBUTE9
                     , NULL AS ATTRIBUTE10
                     , A.CELL_PROD_SITE_ID
                  FROM SALES_PLAN_TEMP_81 A
                     , SCM_SYS_CALENDAR_M B
                     , (SELECT *
                           FROM SCM_MST_FUTURE_PRICE_C
                          WHERE DIVISION_ID  = '81'
                            AND VERSION_NO   = C_SP_VERSION_81 ) IA
                 WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
                   AND A.DIVISION_ID       = IA.DIVISION_ID(+)
                   AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
                   AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
                   AND A.ITEM_ID           = IA.ITEM_ID(+)
                   AND A.DOM_EXP           = IA.DOM_EXP(+)
                   AND A.FCST_TYPE         = IA.FCST_TYPE(+)
                   AND A.INCOTERMS         = IA.INCOTERMS(+)
                   AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
                   AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
                   AND IA.MEASURE(+)       = 'LOC'
                   AND A.DIVISION_ID       = '81'
                   /* [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START)
                   AND A.MEASURE           = 'RTF_SCP'   [C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용 */
                   AND A.MEASURE           = 'RTF_SYS_RP'

                   AND A.SCM_SITE_ID IN (SELECT SEGMENT2
                                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                           WHERE LOOKUP_TYPE  = 'DM_NET_DEMAND_EXCEPTION'
                                             AND VALID_YN     = 'Y' )
                UNION ALL
                /* USD */
                SELECT A.DIVISION_ID
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , 'SalesAmt_USD' AS MEASURE
                     , A.PLANT_SITE_ID
                     , A.YYYYMMDD
                     , IA.CURRENCY
                     , ROUND(A.QTY * NVL(IA.PRICE, 0), 5) AS QTY
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , 'system' AS LAST_UPDATED_BY
                     , SYSDATE AS LAST_UPDATE_DATE
                     , NULL AS ATTRIBUTE1
                     , NULL AS ATTRIBUTE2
                     , NULL AS ATTRIBUTE3
                     , NULL AS ATTRIBUTE4
                     , NULL AS ATTRIBUTE5
                     , NULL AS ATTRIBUTE6
                     , NULL AS ATTRIBUTE7
                     , NULL AS ATTRIBUTE8
                     , NULL AS ATTRIBUTE9
                     , NULL AS ATTRIBUTE10
                     , A.CELL_PROD_SITE_ID
                  FROM SALES_PLAN_TEMP_81 A
                     , SCM_SYS_CALENDAR_M B
                     , (SELECT *
                           FROM SCM_MST_FUTURE_PRICE_C
                          WHERE DIVISION_ID  = '81'
                            AND VERSION_NO   = C_SP_VERSION_81 ) IA
                 WHERE B.BASIS_YYYYMMDD    = A.YYYYMMDD
                   AND A.DIVISION_ID       = IA.DIVISION_ID(+)
                   AND A.PROJECT_CODE      = IA.PROJECT_CODE(+)
                   AND A.SCM_SITE_ID       = IA.SCM_SITE_ID(+)
                   AND A.ITEM_ID           = IA.ITEM_ID(+)
                   AND A.DOM_EXP           = IA.DOM_EXP(+)
                   AND A.FCST_TYPE         = IA.FCST_TYPE(+)
                   AND A.INCOTERMS         = IA.INCOTERMS(+)
                   AND A.PLANT_SITE_ID     = IA.PLANT_SITE_ID(+)
                   AND B.BASIS_START_DATE  = IA.YYYYMMDD(+)
                   AND IA.MEASURE(+)       = 'USD'
                   AND A.DIVISION_ID       = '81'
                   /* [E20260630-000725]_현업사용자가 보이는 수량으로 계산할 수있도록 변경한다 [RTF_SYS_RP] 로 계산하는것으로 변경한다 원소스 주석처리 (START)
                   AND A.MEASURE           = 'RTF_SCP'   [C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용 */
                   AND A.MEASURE           = 'RTF_SYS_RP'

                   AND A.SCM_SITE_ID IN (SELECT SEGMENT2
                                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                           WHERE LOOKUP_TYPE  = 'DM_NET_DEMAND_EXCEPTION'
                                             AND VALID_YN     = 'Y' )
            )
            , FINAL_DATA AS (
                SELECT *
                  FROM SALES_PLAN_TEMP_81    /* 수량 */
                UNION ALL
                SELECT *
                  FROM SALES_PLAN_TEMP_81_2  /* 금액 */
            )
            SELECT DIVISION_ID
                 , C_SP_VERSION_81 AS VERSION_NO
                 , 'SP_W' AS CUTOFF_TYPE
                 , P_CUTOFF_YYYYMMDD_81 AS CUTOFF_YYYYMMDD
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , YYYYMMDD
                 , CURRENCY
                 , QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , SYSDATE AS LAST_UPDATE_DATE
                 , ATTRIBUTE1
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , ATTRIBUTE8
                 , ATTRIBUTE9
                 , ATTRIBUTE10
                 , CELL_PROD_SITE_ID
              FROM FINAL_DATA;

            V_COUNT := 0;
            S_COUNT := 0;
            V_CNT   := 0;
            SELECT COUNT(DISTINCT SCM_SITE_ID)
              INTO V_CNT
              FROM GT_DPSPCQB_AFTER_RTF_81;
            DBMS_OUTPUT.PUT_LINE(V_CNT);

            V_I := 1;
            WHILE V_I <= V_CNT LOOP
                V_SITE_ID := '';
                BEGIN
                    SELECT SCM_SITE_ID
                      INTO V_SITE_ID
                      FROM (SELECT ROW_NUMBER() OVER(ORDER BY SCM_SITE_ID) AS SEQ
                                  , SCM_SITE_ID
                               FROM GT_DPSPCQB_AFTER_RTF_81
                              GROUP BY SCM_SITE_ID ) IA
                     WHERE IA.SEQ = V_I;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    V_SITE_ID := NULL;
                END;

                SELECT COUNT(*)
                  INTO V_COUNT
                  FROM GT_DPSPCQB_AFTER_RTF_81
                 WHERE DIVISION_ID  = '81'
                   AND MEASURE      = 'RTF_SYS_RP'
                   AND SCM_SITE_ID  = V_SITE_ID;

                IF (V_COUNT = 0) THEN
                    SELECT COUNT(*)
                      INTO S_COUNT
                      FROM GT_DPSPCQB_AFTER_RTF_81
                     WHERE DIVISION_ID  = '81'
                       AND SCM_SITE_ID  = V_SITE_ID
                       AND MEASURE      = 'RTF';

                    IF (S_COUNT > 0) THEN
                        UPDATE GT_DPSPCQB_AFTER_RTF_81
                           SET MEASURE = 'RTF_SYS_RP'
                         WHERE DIVISION_ID  = '81'
                           AND SCM_SITE_ID  = V_SITE_ID
                           AND MEASURE      = 'RTF';
                        DBMS_OUTPUT.PUT_LINE(V_SITE_ID);
                    END IF;
                END IF;

                V_I := V_I + 1;
            END LOOP;

            IF (V_CNT > 0) THEN
                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A023: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);
                DELETE
                  FROM DM_PLN_SALES_PLAN_C
                 WHERE DIVISION_ID  = '81'
                   AND VERSION_NO   = C_SP_VERSION_81
                   AND SCM_SITE_ID IN (SELECT SEGMENT2
                                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                         WHERE LOOKUP_TYPE  = 'DM_NET_DEMAND_EXCEPTION'
                                           AND VALID_YN     = 'Y' )
                   AND SCM_SITE_ID IN (SELECT SCM_SITE_ID
                                          FROM GT_DPSPCQB_AFTER_RTF_81
                                         GROUP BY SCM_SITE_ID )
                   AND MEASURE IN ('RTF','RTF_SCP','RTF_SYS_RP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

                INSERT
                  INTO DM_PLN_SALES_PLAN_C
                     ( DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , CELL_PROD_SITE_ID
                     , YYYYMMDD
                     , CURRENCY
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
                SELECT DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , CELL_PROD_SITE_ID
                     , YYYYMMDD
                     , CURRENCY
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
                     , ATTRIBUTE10
                  FROM GT_DPSPCQB_AFTER_RTF_81;
            END IF;
        END IF;
        /* 3-END */

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' A024: DIVISION_ID: ' || P_DIVISION_ID || ' / SP_W버전: ' || V_VER_RETURN_NO);

        /* (원본 #T3_MKT_FCST / #T3_PRICE DROP-if-exists : 리네임 이전 obsolete temp 정리 -> Oracle GTT 자동관리로 불요) */

        /* [E20250529-001289] SALES PLAN CUTOFF 완료 후 메일링 */
        PR_DM_IRREGULAR_SALES_PLAN_CUTOFF_MAIL_SEND(P_DIVISION_ID, P_CREATION_TYPE);

    /*------------------------------------------------------------------------------------------ */
    EXCEPTION
    /*------------------------------------------------------------------------------------------ */
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        D_EVENT_DATE  := SYSDATE;
        DBMS_OUTPUT.PUT_LINE('[' || SQLCODE || ']' || SQLERRM);   /* 에러메시지 DISPLAY */

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
                           , JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID, 'p_cutoff_yyyymmdd' VALUE P_CUTOFF_YYYYMMDD, 'p_creation_type' VALUE P_CREATION_TYPE RETURNING VARCHAR2(4000 CHAR))
                           , SQLCODE, SQLERRM, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

        RAISE_APPLICATION_ERROR(-20001, '[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '@p_division_id : ' || RTRIM(LTRIM(P_DIVISION_ID));
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END;
/
SHOW ERRORS PROCEDURE PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE
