PROCEDURE           "PR_DM_PLN_SALES_PLAN_CUTOFF" 
(
      P_DIVISION_ID          IN  VARCHAR2    /* division_id 전달받음 */
    , P_VERSION_DESCRIPTION  IN  CLOB        /* description 전달받음 */
    , P_VER_TYPE             IN  VARCHAR2
    , P_CREATED_BY           IN  VARCHAR2
)
/*
 * Program ID   : PR_DM_PLN_SALES_PLAN_CUTOFF
 * Description  : 매주 화요일에 Weekly cutoff 수행(40, 82 : 00시, 81 : 04시)
 * Program History
 *===================================================================================================
 *   Date       In Charge              Description
 *===================================================================================================
 * 2017. 02. 05    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가 (20180703 임시 주석처리함)
 * 20180726 KHSONG PR_SCM_MST_FUTURE_PRICE_CUTOFF 호출 추가
 * 20180806 KHSONG PR_DM_MST_EXCHANGE_RATE_CUTOFF 호출 추가
 * 20191113 KYH Companyid 추가
 * 20200709 P.C.I   [PJ20200138] Sales Plan Weekly Cutoff 분리
                    [40] 화요일 : Sales Price Weekly Cutoff, Exchange Rate Weekly Cutoff/금요일 : Sales Plan Cutoff Weekly Version
                    [81] 화요일 : Sales Price Weekly Cutoff, Exchange Rate Weekly Cutoff/목요일 : Sales Plan Cutoff Weekly Version
                    [82] 금요일 : Sales Plan Weekly Cutoff Version, Sales Price Weekly Cutoff, Exchange Rate Weekly Cutoff
 * 20200722 P.C.I   [PJ20200138] Sales Plan Cutoff 생성시 Sales Price, Exchange Rate Cutoff 동시 생성 - Weekly Cutoff 제외
 * 2020/09/09	P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2022.04.07	hwi1993     GM JV 작업
 * 2025.01.21	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.03.18	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선.
 * 2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2026.07.06   ZIONEX   [PJ202650304] NextSCM Migration
 */
AS


    N_HISTORY_SEQ      INTEGER;
    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME     VARCHAR2(150 CHAR) := 'PR_DM_PLN_SALES_PLAN_CUTOFF';
    V_LOG_TYPE         VARCHAR2(30 CHAR);      /* START/END/ERROR/... */
    N_LOG_COUNT        INTEGER := 0;
    V_LOG_MESSAGE      VARCHAR2(1000 CHAR);
    V_DESCRIPTION      VARCHAR2(500 CHAR);
    D_EVENT_DATE       DATE;

    /* */
    V_DIVISION_ID      VARCHAR2(4000 CHAR);
    V_VER_DESCRIPTION  VARCHAR2(4000 CHAR);
    V_VER_TYPE         VARCHAR2(4000 CHAR);
    V_ROLLING_TYPE     VARCHAR2(4000 CHAR);
    V_CREATED_BY       VARCHAR2(4000 CHAR);

    V_VER_RETURN_NO    VARCHAR2(100 CHAR);     /* cut off Generated Number */
    V_PLAN_WEEK        VARCHAR2(4000 CHAR);
    V_OK_DESCRIPTION   VARCHAR2(1200 CHAR);    /* cut off Generated Number */


    V_VERSION_DESCRIPTION  CLOB;


    V_PROC_INPUT       VARCHAR2(4000 CHAR);
    V_SQL_CODE         VARCHAR2(100 CHAR);
    V_SQL_ERRMSG       VARCHAR2(1000 CHAR);
    V_BACKTRACE        VARCHAR2(4000 CHAR);
BEGIN
    V_DIVISION_ID     := NULL;
    V_VER_DESCRIPTION := NULL;
    V_VER_TYPE        := NULL;
    V_ROLLING_TYPE    := NULL;
    V_CREATED_BY      := NULL;

    /* 시작 LOG  (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
    /* 시작 LOG  (END) */

    /*------------------------------------------------------------------------------------------*/
    BEGIN  /* 트랜잭션 (START) : MSSQL BEGIN TRANSACTION → Oracle 평면 트랜잭션 / BEGIN TRY */
    /*------------------------------------------------------------------------------------------*/

        /* [PJ20200138] SP_W 의 Created_by는 'WITHOUT_SP_W'로 설정하여 화면에서 구분
        IF @p_ver_type = 'SP_W' AND @p_division_id IN ('40','81')
        BEGIN
            SET @p_created_by = 'WITHOUT_SP_W'
        END
        */

        V_DIVISION_ID := P_DIVISION_ID;
        V_VERSION_DESCRIPTION :=
            CASE
                WHEN (P_VER_TYPE = 'SP_M') THEN P_VERSION_DESCRIPTION
                WHEN (P_VER_TYPE = 'SP_D') THEN TO_CLOB('SALES_PLAN DAILY CUTOFF')
                WHEN (P_VER_TYPE = 'SP_W') THEN TO_CLOB('SALES_PLAN WEEKLY CUTOFF')
            END;

        PR_DM_PLN_VERSION_CREATE(   /* @return_value = PR_DM_PLN_VERSION_CREATE */
              V_DIVISION_ID
            , V_VERSION_DESCRIPTION  /* 'DM_PLN_SALES_PLAN DAILY CUTOFF' */
            , P_VER_TYPE
            , P_CREATED_BY
            , V_VER_RETURN_NO
            , V_OK_DESCRIPTION
        );

        /* [PJ20200138] Weekly Cutoff는 화요일에 수행하지 않음 (원본 --IF @p_ver_type <> 'SP_W') */
        BEGIN

            /* 1. [DM_PLN_SALES_PLAN] -> [DM_PLN_SALES_PLAN_C] */
            BEGIN
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
                     , CELL_PROD_SITE_ID   /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
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
                     , V_VER_RETURN_NO                     /* VERSION_NO */
                     , P_VER_TYPE                          /* CUTOFF_TYPE */
                     , TO_CHAR(SYSDATE, 'YYYYMMDD')        /* CUTOFF_YYYYMMDD : CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) */
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , CELL_PROD_SITE_ID                   /* [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                     , YYYYMMDD
                     , CURRENCY                            /* 20180319 skh : MSSQL isnull(CURRENCY,'') → Oracle ''=NULL, NVL('') 금지 → 원본 컬럼 그대로 */
                     , QTY
                     , CREATED_BY
                     , CREATION_DATE
                     , P_CREATED_BY
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
                  FROM DM_PLN_SALES_PLAN A
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')   /* 금주 월요일 이후 */
                   AND A.FCST_TYPE NOT IN (SELECT DISTINCT SEGMENT2
                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                            WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                              AND VALID_YN = 'Y'
                                              AND SEGMENT1 = A.DIVISION_ID)
                   AND A.ITEM_ID NOT IN (SELECT DISTINCT SEGMENT3
                                           FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                          WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                            AND VALID_YN = 'Y'
                                            AND SEGMENT1 = A.DIVISION_ID)
                   AND A.MEASURE NOT IN (SELECT SEGMENT2
                                           FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                          WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
                                            AND VALID_YN = 'Y');

                /* [PJ2024-50611] 기타매출, Catch Up 테이블 분리 */
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
                     /* , CELL_PROD_SITE_ID   [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
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
                     , V_VER_RETURN_NO                     /* VERSION_NO */
                     , P_VER_TYPE                          /* CUTOFF_TYPE */
                     , TO_CHAR(SYSDATE, 'YYYYMMDD')        /* CUTOFF_YYYYMMDD : CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) */
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , REMARK_TEXT
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     /* , CELL_PROD_SITE_ID   [PJ2025-50017] CELL_PROD_SITE_ID 추가 */
                     , YYYYMMDD
                     , CURRENCY                            /* 20180319 skh : MSSQL isnull(CURRENCY,'') → Oracle ''=NULL, NVL('') 금지 → 원본 컬럼 그대로 */
                     , QTY
                     , CREATED_BY
                     , CREATION_DATE
                     , P_CREATED_BY
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
                  FROM DM_PLN_SALES_ETC_PLAN A
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');   /* 금주 월요일 이후 */

                /* [PJ2024-50611] 기타매출, Catch Up 테이블 분리 */

            END;

            /* 1. [DM_PLN_SALES_PLAN_RESULT] -> [DM_PLN_SALES_PLAN_RESULT_C]
               [2018-03-28][추가][DM_PLN_SALES_PLAN_REULT_C CUTOFF DATA INSERT] */
            BEGIN
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
                     , CELL_PROD_SITE_ID   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */ )
                SELECT DIVISION_ID
                     , V_VER_RETURN_NO                     /* VERSION_NO */
                     , P_VER_TYPE                          /* CUTOFF_TYPE */
                     , TO_CHAR(SYSDATE, 'YYYYMMDD')        /* CUTOFF_YYYYMMDD : CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) */
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , YYYYMMDD
                     , CURRENCY                            /* 20180319 skh : MSSQL isnull(CURRENCY,'') → Oracle ''=NULL, NVL('') 금지 → 원본 컬럼 그대로 */
                     , QTY
                     , CREATED_BY
                     , CREATION_DATE
                     , P_CREATED_BY
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
                     , CELL_PROD_SITE_ID                   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                  FROM DM_PLN_SALES_PLAN_RESULT
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND YYYYMMDD <  TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')        /* [2018-03-28] 금주 월요일 이전 */
                   AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7 * 54, 'YYYYMMDD');  /* 최근 1년치 */
            END;

            /* --------------------------------------------------------------------- 20180528 KHSONG DW I/F 테이블 생성 Procedure 호출 추가
               EXEC [dbo].PR_DM_TO_XIF_DM_PLN_SALES_PLAN_C @v_division_id, @v_ver_return_no  (원본 주석)
               --------------------------------------------------------------------- */

            /* [PJ20200138] Sales Price / Exchange Rate Weekly Cutoff 동시 수행 (원본 --IF @p_ver_type <> 'SP_W' 주석) */

            /* 20180726 KHSONG PR_SCM_MST_FUTURE_PRICE_CUTOFF 호출 추가 */
            PR_SCM_MST_FUTURE_PRICE_CUTOFF(
                  V_DIVISION_ID
                , P_VER_TYPE
                , P_CREATED_BY
                , V_VER_RETURN_NO
            );

            /* 20180806 KHSONG PR_DM_MST_EXCHANGE_RATE_CUTOFF 호출 추가 */
            PR_DM_MST_EXCHANGE_RATE_CUTOFF(
                  V_DIVISION_ID
                , P_VER_TYPE
                , P_CREATED_BY
                , V_VER_RETURN_NO
            );
        END;

        /* 트랜잭션 (COMMIT) */
        COMMIT;

    /*------------------------------------------------------------------------------------------*/
    EXCEPTION
    /*------------------------------------------------------------------------------------------*/
        WHEN OTHERS THEN
            /* ROLLBACK / 트랜잭션 (END) */
            ROLLBACK;

            /* ERROR LOG VALUE SAVE */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SQLERRM;
            V_DESCRIPTION := 'ERROR_BACKTRACE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            D_EVENT_DATE  := SYSDATE;
            V_SQL_CODE    := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG  := SQLERRM;
            V_PROC_INPUT  := JSON_OBJECT(
                  'DIVISION_ID' VALUE P_DIVISION_ID
                , 'VER_TYPE'    VALUE P_VER_TYPE
                , 'CREATED_BY'  VALUE P_CREATED_BY
                  RETURNING VARCHAR2(4000 CHAR)
            );
            V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            /* 에러메시지 DISPLAY
               SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
            */

            /* [C20200909-000203] LOG 표준화 적용 */
            PR_SCM_SYS_LOG_BATCH(
                  V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE
                , V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT
                , V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
    /*------------------------------------------------------------------------------------------*/
    END;
    /*------------------------------------------------------------------------------------------*/

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
END;