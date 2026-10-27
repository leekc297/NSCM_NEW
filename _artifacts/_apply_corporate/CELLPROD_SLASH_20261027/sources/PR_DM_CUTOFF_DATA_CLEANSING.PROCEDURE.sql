PROCEDURE           "PR_DM_CUTOFF_DATA_CLEANSING" 
/* =====================================================================================================
 * Program ID   : PR_DM_CUTOFF_DATA_CLEANSING
 * Description  :
 * Program History
 *-----------------------------------------------------------------------------------------------------
 *   Date       In Charge      Description
 *-----------------------------------------------------------------------------------------------------
 * 2018. 10. 30    SongKH      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/03/16		HWI1993	[C20210316-000106] Daily Cutoff Data Cleansing, 삭제주기를 -7*8 --> -7*2 (2주전 월요일 이전데이터), 삭제단위를 5만으로 변경, 환율테이블 추가함.
 * 2021/03/18		HWI1993	성능문제로 테이블별로 인덱스에 맞춰서 삭제쿼리 다시 작성함.
 * 2021/06/24		hwi1993	[2021하반기과제] 성능개선 - 컷오프테이블 데이터 이동
 * 2021/07/23		hwi1993	[2021하반기과제] 소형 중장기계획에 따른 DM_PLN_BP_FCST_C_KEEP 컬럼변경 적용
 * 2022/01/04		kdw2819 [C20220103-000581] 다빈치 DataLake 데이터 수집을 위한 보관테이블 이력 기록
 * 2022.04.05       HWI1993 GM JV 작업
 * 2022.06.21		rosia27	[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2022.09.23		rosia27	[C20220905-000191]Sales Report 데이터 보관 기간 설정의 건
 * 2024.05.09		JSSBAE	[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2024.12.01		KANG.H.J [PJ2024-50611]  FROM_SITE_ID 추가
 * 2025.02.05		KANG.H.J [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화
 * 2025.04.08		KANG.H.J [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.04.25		KANG.H.J [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP 등록
 * 2025.06.23		KANG.H.J [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.07.24		KANG.H.J [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP / DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록
 * 2026.07.06   ZIONEX  [PJ202650304]  NextSCM Migration
 * 2026.10.20   AJS     KEEP 이동 삭제 조건에 파티션 칸 조건 추가(파티션 전체 탐색 제거) · 버전 단위 COMMIT(AS-IS 문장 단위 확정과 맞춤)
 * ===================================================================================================== */
AS

    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_DM_CUTOFF_DATA_CLEANSING';
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;

    V_VERSION_NO    VARCHAR2(50 CHAR);
    V_WEEKDAY       NUMBER;
    V_DATA_CNT      INTEGER;
    V_MOVE_CNT      INTEGER;
    V_DIVISION_ID   VARCHAR2(30 CHAR);
BEGIN

    /* 시작 LOG (START) */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

    BEGIN


        V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;

        /* ============================ DAILY CUTOFF DATA 삭제 ============================ */

        /* dm_pln_mkt_fcst_c 삭제 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                         FROM DM_MST_VERSION    A
                            , DM_PLN_MKT_FCST_C  B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
                          AND A.VERSION_TYPE = 'MF_D'
                        GROUP BY A.VERSION_NO
                        ORDER BY A.VERSION_NO ) LOOP
                DELETE
                  FROM DM_PLN_MKT_FCST_C
                 WHERE VERSION_NO  = R.VERSION_NO
                   AND DIVISION_ID IN ( SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION
                                         WHERE ATTRIBUTE3 IN ('40', '81', '82') );
                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'dm_pln_mkt_fcst_c 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* dm_pln_sales_plan_c 삭제 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT DISTINCT A.VERSION_NO
                         FROM DM_MST_VERSION      A
                            , DM_PLN_SALES_PLAN_C  B
                        WHERE A.DIVISION_ID     = B.DIVISION_ID
                          AND A.VERSION_NO      = B.VERSION_NO
                          AND B.CUTOFF_TYPE     = 'SP_D'
                          AND B.CUTOFF_YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
                          AND A.YYYYMMDD        < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
                          AND A.VERSION_TYPE    = 'SP_D'
                        GROUP BY A.VERSION_NO
                        ORDER BY A.VERSION_NO ) LOOP
                DELETE
                  FROM DM_PLN_SALES_PLAN_C
                 WHERE VERSION_NO  = R.VERSION_NO
                   AND DIVISION_ID IN ( SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION
                                         WHERE ATTRIBUTE3 IN ('40', '81', '82') );
                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'dm_pln_sales_plan_c 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* dm_pln_mkt_fcst_result_c 삭제 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                         FROM DM_MST_VERSION           A
                            , DM_PLN_MKT_FCST_RESULT_C  B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
                          AND A.VERSION_TYPE = 'MF_D'
                        GROUP BY A.VERSION_NO
                        ORDER BY A.VERSION_NO ) LOOP
                DELETE
                  FROM DM_PLN_MKT_FCST_RESULT_C
                 WHERE VERSION_NO  = R.VERSION_NO
                   AND DIVISION_ID IN ( SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION
                                         WHERE ATTRIBUTE3 IN ('40', '81', '82') );
                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'dm_pln_mkt_fcst_result_c 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* dm_pln_sales_plan_result_c 삭제 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                         FROM DM_MST_VERSION             A
                            , DM_PLN_SALES_PLAN_RESULT_C  B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
                          AND A.VERSION_TYPE = 'SP_D'
                        GROUP BY A.VERSION_NO
                        ORDER BY A.VERSION_NO ) LOOP
                DELETE
                  FROM DM_PLN_SALES_PLAN_RESULT_C
                 WHERE VERSION_NO  = R.VERSION_NO
                   AND DIVISION_ID IN ( SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION
                                         WHERE ATTRIBUTE3 IN ('40', '81', '82') );
                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'dm_pln_sales_plan_result_c 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* dm_pln_cfm_mkt_demand_plan_c 삭제 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                         FROM DM_MST_VERSION                A
                            , DM_PLN_CFM_MKT_DEMAND_PLAN_C   B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
                          AND A.VERSION_TYPE IN ('MF_D', 'SF_D', 'SP_D')
                        GROUP BY A.VERSION_NO
                        ORDER BY A.VERSION_NO ) LOOP
                DELETE
                  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
                 WHERE VERSION_NO  = R.VERSION_NO
                   AND DIVISION_ID IN ( SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION
                                         WHERE ATTRIBUTE3 IN ('40', '81', '82') );
                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'dm_pln_cfm_mkt_demand_plan_c 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* [소형매출계획 동기화] DM_PLN_CFM_SELLING_PRICE_C 삭제 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                         FROM DM_MST_VERSION             A
                            , DM_PLN_CFM_SELLING_PRICE_C  B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
                          AND A.VERSION_TYPE IN ('MF_D', 'SF_D', 'SP_D')
                        GROUP BY A.VERSION_NO
                        ORDER BY A.VERSION_NO ) LOOP
                DELETE
                  FROM DM_PLN_CFM_SELLING_PRICE_C
                 WHERE VERSION_NO  = R.VERSION_NO
                   AND DIVISION_ID IN ( SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION
                                         WHERE ATTRIBUTE3 IN ('40', '81', '82') );
                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'dm_pln_cfm_selling_price_c 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* SCM_MST_FUTURE_PRICE_C 삭제 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                         FROM DM_MST_VERSION          A
                            , SCM_MST_FUTURE_PRICE_C   B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
                          AND A.VERSION_TYPE = 'SP_D'
                        GROUP BY A.VERSION_NO
                        ORDER BY A.VERSION_NO ) LOOP
                DELETE
                  FROM SCM_MST_FUTURE_PRICE_C
                 WHERE VERSION_NO  = R.VERSION_NO
                   AND DIVISION_ID IN ( SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION
                                         WHERE ATTRIBUTE3 IN ('40', '81', '82') );
                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'SCM_MST_FUTURE_PRICE_C 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* [C20210316-000106] DM_MST_EXCHANGE_RATE_C 삭제 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                         FROM DM_MST_VERSION          A
                            , DM_MST_EXCHANGE_RATE_C   B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 2), 'YYYYMMDD')
                          AND A.VERSION_TYPE = 'SP_D'
                        GROUP BY A.VERSION_NO
                        ORDER BY A.VERSION_NO ) LOOP
                DELETE
                  FROM DM_MST_EXCHANGE_RATE_C
                 WHERE VERSION_NO  = R.VERSION_NO
                   AND DIVISION_ID IN ( SELECT DIVISION_ID
                                          FROM SCM_MST_DIVISION
                                         WHERE ATTRIBUTE3 IN ('40', '81', '82') );
                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'DM_MST_EXCHANGE_RATE_C 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* ============================ 보관기간 지난 건들 이동처리 ============================ */

        /* DM_PLN_MKT_FCST_C 이동 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                            , A.DIVISION_ID
                            , COUNT(*)  AS CNT
                         FROM DM_MST_VERSION    A
                            , DM_PLN_MKT_FCST_C  B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 54), 'YYYYMMDD')
                          AND NVL(A.ATTRIBUTE1, ' ') <> 'MOVE'
                        GROUP BY A.VERSION_NO, A.DIVISION_ID ) LOOP
                V_VERSION_NO  := R.VERSION_NO;
                V_DIVISION_ID := R.DIVISION_ID;
                V_DATA_CNT    := R.CNT;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE1 = 'ING'
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                INSERT
                  INTO DM_PLN_MKT_FCST_C_KEEP
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
                     , ATTRIBUTE10
                  FROM DM_PLN_MKT_FCST_C
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                /* [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP 등록 START */
                INSERT
                  INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP
                     ( DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , PROJECT_CODE
                     , END_CUSTOMER
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
                     , END_CUSTOMER
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
                     , ATTRIBUTE10
                  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;
                /* [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP 등록 END */

                SELECT COUNT(*)
                  INTO V_MOVE_CNT
                  FROM DM_PLN_MKT_FCST_C_KEEP
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                IF ( V_MOVE_CNT = V_DATA_CNT ) THEN
                    DELETE
                      FROM DM_PLN_MKT_FCST_C A
                     WHERE A.VERSION_NO  = V_VERSION_NO
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND EXISTS ( SELECT 1
                                      FROM DM_PLN_MKT_FCST_C_KEEP B
                                     WHERE A.DIVISION_ID     = B.DIVISION_ID
                                       AND A.VERSION_NO      = B.VERSION_NO
                                       AND A.CUTOFF_TYPE     = B.CUTOFF_TYPE
                                       AND A.CUTOFF_YYYYMMDD = B.CUTOFF_YYYYMMDD
                                       AND A.PROJECT_CODE    = B.PROJECT_CODE
                                       AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                                       AND A.ITEM_ID         = B.ITEM_ID
                                       AND A.DOM_EXP         = B.DOM_EXP
                                       AND A.FCST_TYPE       = B.FCST_TYPE
                                       AND A.INCOTERMS       = B.INCOTERMS
                                       AND A.MEASURE         = B.MEASURE
                                       AND A.PLANT_SITE_ID   = B.PLANT_SITE_ID
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (START) : 행마다 파티션 전체를 찾던 것을 해당 컷오프 파티션 하나로 좁힘
--                                       AND A.YYYYMMDD        = B.YYYYMMDD );
                                       AND A.YYYYMMDD        = B.YYYYMMDD
                                       AND A.CUTOFF_YYYYMMDD_DATE = TO_DATE(B.CUTOFF_YYYYMMDD, 'YYYYMMDD') );
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (END)

                    /* [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP 등록 START */
                    DELETE
                      FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
                     WHERE A.VERSION_NO  = V_VERSION_NO
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND EXISTS ( SELECT 1
                                      FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP B
                                     WHERE A.DIVISION_ID      = B.DIVISION_ID
                                       AND A.VERSION_NO       = B.VERSION_NO
                                       AND A.CUTOFF_TYPE      = B.CUTOFF_TYPE
                                       AND A.CUTOFF_YYYYMMDD  = B.CUTOFF_YYYYMMDD
                                       AND A.PROJECT_CODE     = B.PROJECT_CODE
                                       AND A.END_CUSTOMER     = B.END_CUSTOMER
                                       AND A.SCM_SITE_ID      = B.SCM_SITE_ID
                                       AND A.ITEM_ID          = B.ITEM_ID
                                       AND A.DOM_EXP          = B.DOM_EXP
                                       AND A.FCST_TYPE        = B.FCST_TYPE
                                       AND A.INCOTERMS        = B.INCOTERMS
                                       AND A.MEASURE          = B.MEASURE
                                       AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
                                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (START) : 행마다 파티션 전체를 찾던 것을 해당 컷오프 파티션 하나로 좁힘
--                                       AND A.YYYYMMDD         = B.YYYYMMDD );
                                       AND A.YYYYMMDD         = B.YYYYMMDD
                                       AND A.CUTOFF_YYYYMMDD_DATE = TO_DATE(B.CUTOFF_YYYYMMDD, 'YYYYMMDD') );
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (END)
                    /* [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN_C_KEEP 등록 END */
                END IF;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE1 = 'MOVE'
                     , ATTRIBUTE4 = TO_CHAR(SYSDATE, 'YYYYMMDD')  /* [C20220103-000581] 다빈치 DataLake 이력 기록 */
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'DM_PLN_MKT_FCST_C 이동';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* DM_PLN_MKT_FCST_RESULT_C 이동 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                            , A.DIVISION_ID
                            , COUNT(*)  AS CNT
                         FROM DM_MST_VERSION           A
                            , DM_PLN_MKT_FCST_RESULT_C  B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 54), 'YYYYMMDD')
                          AND NVL(A.ATTRIBUTE2, ' ') <> 'MOVE'
                        GROUP BY A.VERSION_NO, A.DIVISION_ID ) LOOP
                V_VERSION_NO  := R.VERSION_NO;
                V_DIVISION_ID := R.DIVISION_ID;
                V_DATA_CNT    := R.CNT;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE2 = 'ING'
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                INSERT
                  INTO DM_PLN_MKT_FCST_RESULT_C_KEEP
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
                     , CELL_PROD_SITE_ID )   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
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
                     , ATTRIBUTE10
                     , CELL_PROD_SITE_ID     /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                  FROM DM_PLN_MKT_FCST_RESULT_C
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                SELECT COUNT(*)
                  INTO V_MOVE_CNT
                  FROM DM_PLN_MKT_FCST_RESULT_C_KEEP
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                IF ( V_MOVE_CNT = V_DATA_CNT ) THEN
                    DELETE
                      FROM DM_PLN_MKT_FCST_RESULT_C A
                     WHERE A.VERSION_NO  = V_VERSION_NO
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND EXISTS ( SELECT 1
                                      FROM DM_PLN_MKT_FCST_RESULT_C_KEEP B
                                     WHERE A.DIVISION_ID      = B.DIVISION_ID
                                       AND A.VERSION_NO       = B.VERSION_NO
                                       AND A.CUTOFF_TYPE      = B.CUTOFF_TYPE
                                       AND A.CUTOFF_YYYYMMDD  = B.CUTOFF_YYYYMMDD
                                       AND A.PROJECT_CODE     = B.PROJECT_CODE
                                       AND A.SCM_SITE_ID      = B.SCM_SITE_ID
                                       AND A.ITEM_ID          = B.ITEM_ID
                                       AND A.DOM_EXP          = B.DOM_EXP
                                       AND A.FCST_TYPE        = B.FCST_TYPE
                                       AND A.INCOTERMS        = B.INCOTERMS
                                       AND A.MEASURE          = B.MEASURE
                                       AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
                                       AND A.YYYYMMDD         = B.YYYYMMDD
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (START) : 행마다 파티션 전체를 찾던 것을 해당 컷오프 파티션 하나로 좁힘
--                                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID );  /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                                       AND A.CUTOFF_YYYYMMDD_DATE = TO_DATE(B.CUTOFF_YYYYMMDD, 'YYYYMMDD') );  /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (END)
                END IF;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE2 = 'MOVE'
                     , ATTRIBUTE5 = TO_CHAR(SYSDATE, 'YYYYMMDD')  /* [C20220103-000581] 다빈치 DataLake 이력 기록 */
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'DM_PLN_MKT_FCST_RESULT_C 이동';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* DM_PLN_SALES_PLAN_C 이동 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                            , A.DIVISION_ID
                            , COUNT(*)  AS CNT
                         FROM DM_MST_VERSION      A
                            , DM_PLN_SALES_PLAN_C  B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 54), 'YYYYMMDD')
                          AND NVL(A.ATTRIBUTE1, ' ') <> 'MOVE'
                        GROUP BY A.VERSION_NO, A.DIVISION_ID ) LOOP
                V_VERSION_NO  := R.VERSION_NO;
                V_DIVISION_ID := R.DIVISION_ID;
                V_DATA_CNT    := R.CNT;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE1 = 'ING'
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                INSERT
                  INTO DM_PLN_SALES_PLAN_C_KEEP
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
                     , CELL_PROD_SITE_ID )   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
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
                     , CELL_PROD_SITE_ID     /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                  FROM DM_PLN_SALES_PLAN_C
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                SELECT COUNT(*)
                  INTO V_MOVE_CNT
                  FROM DM_PLN_SALES_PLAN_C_KEEP
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                IF ( V_MOVE_CNT = V_DATA_CNT ) THEN
                    DELETE
                      FROM DM_PLN_SALES_PLAN_C A
                     WHERE A.VERSION_NO  = V_VERSION_NO
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND EXISTS ( SELECT 1
                                      FROM DM_PLN_SALES_PLAN_C_KEEP B
                                     WHERE A.DIVISION_ID      = B.DIVISION_ID
                                       AND A.VERSION_NO       = B.VERSION_NO
                                       AND A.CUTOFF_TYPE      = B.CUTOFF_TYPE
                                       AND A.CUTOFF_YYYYMMDD  = B.CUTOFF_YYYYMMDD
                                       AND A.PROJECT_CODE     = B.PROJECT_CODE
                                       AND A.SCM_SITE_ID      = B.SCM_SITE_ID
                                       AND A.ITEM_ID          = B.ITEM_ID
                                       AND A.DOM_EXP          = B.DOM_EXP
                                       AND A.FCST_TYPE        = B.FCST_TYPE
                                       AND A.INCOTERMS        = B.INCOTERMS
                                       AND A.MEASURE          = B.MEASURE
                                       AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
                                       AND A.YYYYMMDD         = B.YYYYMMDD
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (START) : 행마다 파티션 전체를 찾던 것을 해당 컷오프 파티션 하나로 좁힘
--                                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID );  /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                                       AND A.CUTOFF_YYYYMMDD_DATE = TO_DATE(B.CUTOFF_YYYYMMDD, 'YYYYMMDD') );  /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (END)
                END IF;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE1 = 'MOVE'
                     , ATTRIBUTE4 = TO_CHAR(SYSDATE, 'YYYYMMDD')  /* [C20220103-000581] 다빈치 DataLake 이력 기록 */
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'DM_PLN_SALES_PLAN_C 이동';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* DM_PLN_SALES_PLAN_RESULT_C 이동 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                            , A.DIVISION_ID
                            , COUNT(*)  AS CNT
                         FROM DM_MST_VERSION             A
                            , DM_PLN_SALES_PLAN_RESULT_C  B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 54), 'YYYYMMDD')
                          AND NVL(A.ATTRIBUTE2, ' ') <> 'MOVE'
                        GROUP BY A.VERSION_NO, A.DIVISION_ID ) LOOP
                V_VERSION_NO  := R.VERSION_NO;
                V_DIVISION_ID := R.DIVISION_ID;
                V_DATA_CNT    := R.CNT;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE2 = 'ING'
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                INSERT
                  INTO DM_PLN_SALES_PLAN_RESULT_C_KEEP
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
                     , COMPANY_ID
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
                     , CELL_PROD_SITE_ID )   /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
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
                     , YYYYMMDD
                     , CURRENCY
                     , COMPANY_ID
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
                     , CELL_PROD_SITE_ID     /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                  FROM DM_PLN_SALES_PLAN_RESULT_C
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                SELECT COUNT(*)
                  INTO V_MOVE_CNT
                  FROM DM_PLN_SALES_PLAN_RESULT_C_KEEP
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                IF ( V_MOVE_CNT = V_DATA_CNT ) THEN
                    DELETE
                      FROM DM_PLN_SALES_PLAN_RESULT_C A
                     WHERE A.VERSION_NO  = V_VERSION_NO
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND EXISTS ( SELECT 1
                                      FROM DM_PLN_SALES_PLAN_RESULT_C_KEEP B
                                     WHERE A.DIVISION_ID      = B.DIVISION_ID
                                       AND A.VERSION_NO       = B.VERSION_NO
                                       AND A.CUTOFF_TYPE      = B.CUTOFF_TYPE
                                       AND A.CUTOFF_YYYYMMDD  = B.CUTOFF_YYYYMMDD
                                       AND A.PROJECT_CODE     = B.PROJECT_CODE
                                       AND A.SCM_SITE_ID      = B.SCM_SITE_ID
                                       AND A.ITEM_ID          = B.ITEM_ID
                                       AND A.DOM_EXP          = B.DOM_EXP
                                       AND A.FCST_TYPE        = B.FCST_TYPE
                                       AND A.INCOTERMS        = B.INCOTERMS
                                       AND A.MEASURE          = B.MEASURE
                                       AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
                                       AND A.YYYYMMDD         = B.YYYYMMDD
                                       AND A.CURRENCY         = B.CURRENCY
                                       AND A.COMPANY_ID       = B.COMPANY_ID
                                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID );  /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 */
                END IF;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE2 = 'MOVE'
                     , ATTRIBUTE5 = TO_CHAR(SYSDATE, 'YYYYMMDD')  /* [C20220103-000581] 다빈치 DataLake 이력 기록 */
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'DM_PLN_SALES_PLAN_RESULT_C 이동';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* DM_PLN_BP_FCST_C 이동 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                            , A.DIVISION_ID
                            , COUNT(*)  AS CNT
                         FROM DM_MST_VERSION   A
                            , DM_PLN_BP_FCST_C  B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 54), 'YYYYMMDD')
                          AND NVL(A.ATTRIBUTE1, ' ') <> 'MOVE'
                        GROUP BY A.VERSION_NO, A.DIVISION_ID ) LOOP
                V_VERSION_NO  := R.VERSION_NO;
                V_DIVISION_ID := R.DIVISION_ID;
                V_DATA_CNT    := R.CNT;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE1 = 'ING'
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                INSERT
                  INTO DM_PLN_BP_FCST_C_KEEP
                     ( VERSION_NO
                     , DIVISION_ID
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , PROJECT_CODE
                     , PROJECT_NAME
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , MEASURE
                     , PLANT_SITE_ID
                     , DEPT_ID
                     , END_CUSTOMER
                     , BIZ_TYPE
                     , YYYYMM
                     , CURRENCY
                     , ITEM_USE
                     , UNIT_ENERGY
                     , QTY
                     , CELL_PER_PACK
                     , CELL_PER_MODULE
                     , MODULE_PER_PACK
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
                     , SEQ_NO
                     , INCOTERMS
                     , CELL_PROD_SITE )
                SELECT VERSION_NO
                     , DIVISION_ID
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , PROJECT_CODE
                     , PROJECT_NAME
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , MEASURE
                     , PLANT_SITE_ID
                     , DEPT_ID
                     , END_CUSTOMER
                     , BIZ_TYPE
                     , YYYYMM
                     , CURRENCY
                     , ITEM_USE
                     , UNIT_ENERGY
                     , QTY
                     , CELL_PER_PACK
                     , CELL_PER_MODULE
                     , MODULE_PER_PACK
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
                     , SEQ_NO
                     , INCOTERMS
                     , CELL_PROD_SITE
                  FROM DM_PLN_BP_FCST_C
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                SELECT COUNT(*)
                  INTO V_MOVE_CNT
                  FROM DM_PLN_BP_FCST_C_KEEP
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                IF ( V_MOVE_CNT = V_DATA_CNT ) THEN
                    DELETE
                      FROM DM_PLN_BP_FCST_C A
                     WHERE A.VERSION_NO  = V_VERSION_NO
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND EXISTS ( SELECT 1
                                      FROM DM_PLN_BP_FCST_C_KEEP B
                                     WHERE A.DIVISION_ID = B.DIVISION_ID
                                       AND A.VERSION_NO  = B.VERSION_NO
                                       AND A.SEQ_NO      = B.SEQ_NO );
                END IF;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE1 = 'MOVE'
                     , ATTRIBUTE4 = TO_CHAR(SYSDATE, 'YYYYMMDD')  /* [C20220103-000581] 다빈치 DataLake 이력 기록 */
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'DM_PLN_BP_FCST_C 이동';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        /* SCM_MST_FUTURE_PRICE_C 이동 */
        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                            , A.DIVISION_ID
                            , COUNT(*)  AS CNT
                         FROM DM_MST_VERSION          A
                            , SCM_MST_FUTURE_PRICE_C   B
                        WHERE A.DIVISION_ID  = B.DIVISION_ID
                          AND A.VERSION_TYPE = B.CUTOFF_TYPE
                          AND A.YYYYMMDD     = B.CUTOFF_YYYYMMDD
                          AND A.VERSION_NO   = B.VERSION_NO
                          AND A.YYYYMMDD     < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 54), 'YYYYMMDD')
                          AND NVL(A.ATTRIBUTE3, ' ') <> 'MOVE'
                        GROUP BY A.VERSION_NO, A.DIVISION_ID ) LOOP
                V_VERSION_NO  := R.VERSION_NO;
                V_DIVISION_ID := R.DIVISION_ID;
                V_DATA_CNT    := R.CNT;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE3 = 'ING'
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                INSERT
                  INTO SCM_MST_FUTURE_PRICE_C_KEEP
                     ( DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , PLANT_SITE_ID
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
                     , ATTRIBUTE10
                  FROM SCM_MST_FUTURE_PRICE_C
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                /* [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 START */
                INSERT
                  INTO DM_PLN_CFM_SELLING_PRICE_C_KEEP
                     ( DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , PROJECT_CODE
                     , END_CUSTOMER
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
                     , END_CUSTOMER
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
                     , ATTRIBUTE10
                  FROM DM_PLN_CFM_SELLING_PRICE_C
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;
                /* [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 END */

                SELECT COUNT(*)
                  INTO V_MOVE_CNT
                  FROM SCM_MST_FUTURE_PRICE_C_KEEP
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                IF ( V_MOVE_CNT = V_DATA_CNT ) THEN
                    DELETE
                      FROM SCM_MST_FUTURE_PRICE_C A
                     WHERE A.VERSION_NO  = V_VERSION_NO
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND EXISTS ( SELECT 1
                                      FROM SCM_MST_FUTURE_PRICE_C_KEEP B
                                     WHERE A.DIVISION_ID      = B.DIVISION_ID
                                       AND A.VERSION_NO       = B.VERSION_NO
                                       AND A.CUTOFF_TYPE      = B.CUTOFF_TYPE
                                       AND A.CUTOFF_YYYYMMDD  = B.CUTOFF_YYYYMMDD
                                       AND A.PROJECT_CODE     = B.PROJECT_CODE
                                       AND A.SCM_SITE_ID      = B.SCM_SITE_ID
                                       AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
                                       AND A.ITEM_ID          = B.ITEM_ID
                                       AND A.YYYYMMDD         = B.YYYYMMDD
                                       AND A.CURRENCY         = B.CURRENCY
                                       AND A.MEASURE          = B.MEASURE
                                       AND A.DOM_EXP          = B.DOM_EXP
                                       AND A.FCST_TYPE        = B.FCST_TYPE
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (START) : 행마다 파티션 전체를 찾던 것을 해당 컷오프 파티션 하나로 좁힘
--                                       AND A.INCOTERMS        = B.INCOTERMS );
                                       AND A.INCOTERMS        = B.INCOTERMS
                                       AND A.CUTOFF_YYYYMMDD_DATE = TO_DATE(B.CUTOFF_YYYYMMDD, 'YYYYMMDD') );
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (END)

                    /* [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 START */
                    DELETE
                      FROM DM_PLN_CFM_SELLING_PRICE_C A
                     WHERE A.VERSION_NO  = V_VERSION_NO
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND EXISTS ( SELECT 1
                                      FROM DM_PLN_CFM_SELLING_PRICE_C_KEEP B
                                     WHERE A.DIVISION_ID      = B.DIVISION_ID
                                       AND A.VERSION_NO       = B.VERSION_NO
                                       AND A.CUTOFF_TYPE      = B.CUTOFF_TYPE
                                       AND A.CUTOFF_YYYYMMDD  = B.CUTOFF_YYYYMMDD
                                       AND A.PROJECT_CODE     = B.PROJECT_CODE
                                       AND A.END_CUSTOMER     = B.END_CUSTOMER
                                       AND A.SCM_SITE_ID      = B.SCM_SITE_ID
                                       AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
                                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                                       AND A.ITEM_ID          = B.ITEM_ID
                                       AND A.YYYYMMDD         = B.YYYYMMDD
                                       AND A.CURRENCY         = B.CURRENCY
                                       AND A.MEASURE          = B.MEASURE
                                       AND A.DOM_EXP          = B.DOM_EXP
                                       AND A.FCST_TYPE        = B.FCST_TYPE
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (START) : 행마다 파티션 전체를 찾던 것을 해당 컷오프 파티션 하나로 좁힘
--                                       AND A.INCOTERMS        = B.INCOTERMS );
                                       AND A.INCOTERMS        = B.INCOTERMS
                                       AND A.CUTOFF_YYYYMMDD_DATE = TO_DATE(B.CUTOFF_YYYYMMDD, 'YYYYMMDD') );
                                       -- 2026.10.20 AJS 파티션 칸 조건 추가 (END)
                    /* [PJ2025-50188] 소형 매출계획 동기화 개선 - DM_PLN_CFM_SELLING_PRICE_C_KEEP 등록 END */
                END IF;

                UPDATE DM_MST_VERSION
                   SET ATTRIBUTE3 = 'MOVE'
                     , ATTRIBUTE6 = TO_CHAR(SYSDATE, 'YYYYMMDD')  /* [C20220103-000581] 다빈치 DataLake 이력 기록 */
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'SCM_MST_FUTURE_PRICE_C 이동';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */


        DELETE
          FROM DM_ANL_KPI_SUMMARY
         WHERE WORK_YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 27), 'YYYYMMDD');

        DELETE
          FROM DM_ANL_KPI_SALES_ACCURACY
         WHERE WORK_YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 27), 'YYYYMMDD');

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'KPI 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */


        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                            , A.DIVISION_ID
                         FROM DM_MST_VERSION          A
                            , DM_PLN_DEMANDID_PEGGING  B
                        WHERE A.DIVISION_ID = B.DIVISION_ID
                          AND A.VERSION_NO  = B.VERSION_NO
                          AND A.YYYYMMDD    < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 14), 'YYYYMMDD')
                        GROUP BY A.VERSION_NO, A.DIVISION_ID ) LOOP
                V_VERSION_NO  := R.VERSION_NO;
                V_DIVISION_ID := R.DIVISION_ID;

                DELETE
                  FROM DM_PLN_DEMANDID_PEGGING
                 WHERE VERSION_NO  = V_VERSION_NO
                   AND DIVISION_ID = V_DIVISION_ID;

                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'DM_PLN_DEMANDID_PEGGING 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */


        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                            , A.DIVISION_ID
                         FROM DM_MST_VERSION      A
                            , DM_PLN_NET_DEMAND    B
                        WHERE A.DIVISION_ID = B.DIVISION_ID
                          AND A.VERSION_NO  = B.VERSION_NO
                          AND A.YYYYMMDD    < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') + (-7 * 14), 'YYYYMMDD')
                        GROUP BY A.VERSION_NO, A.DIVISION_ID ) LOOP
                V_VERSION_NO  := R.VERSION_NO;
                V_DIVISION_ID := R.DIVISION_ID;

                DELETE
                  FROM DM_PLN_NET_DEMAND
                 WHERE VERSION_NO  = V_VERSION_NO
                   AND DIVISION_ID = V_DIVISION_ID;

                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'DM_PLN_NET_DEMAND 삭제';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */


        DELETE
          FROM DM_PLN_SALES_PLAN_REPORT_C A
         WHERE EXISTS ( SELECT 1
                          FROM DM_MDF_VERSION B
                         WHERE B.DIVISION_ID   = A.DIVISION_ID
                           AND B.VERSION_NO    = A.VERSION_NO
                           AND B.CREATION_DATE < ADD_MONTHS(SYSDATE, -3)
                           AND B.SEND_YN      <> 'Y' );


        IF V_WEEKDAY IN (1, 7) THEN
            FOR R IN ( SELECT A.VERSION_NO
                            , A.DIVISION_ID
                            , COUNT(*)  AS CNT
                         FROM DM_MDF_VERSION               A
                            , DM_PLN_SALES_PLAN_REPORT_C    B
                        WHERE A.DIVISION_ID   = B.DIVISION_ID
                          AND A.VERSION_NO    = B.VERSION_NO
                          AND A.CREATION_DATE < ADD_MONTHS(SYSDATE, -18)
                          AND NVL(A.ATTRIBUTE3, ' ') <> 'MOVE'
                        GROUP BY A.VERSION_NO, A.DIVISION_ID ) LOOP
                V_VERSION_NO  := R.VERSION_NO;
                V_DIVISION_ID := R.DIVISION_ID;
                V_DATA_CNT    := R.CNT;

                UPDATE DM_MDF_VERSION
                   SET ATTRIBUTE3 = 'ING'
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                INSERT
                  INTO DM_PLN_SALES_PLAN_REPORT_C_KEEP
                     ( DATA_TYPE
                     , DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , DEPARTMENT_ID
                     , DEPARTMENT_NAME
                     , DEPT_ID
                     , DEPT_NAME
                     , END_CUST_REPORT
                     , CUST_REPORT
                     , PRODUCT_GROUP
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
                     , SOLDTO_CUST_REPORT
                     , OWNER_NAME
                     , CUST_GROUP_DTL
                     , PRODUCT_DETAILS
                     , FORECAST_INFO_SPEC
                     , NICK_NAME
                     , FORECAST_INFO_CELL_MODEL
                     , FORECAST_INFO_CELL_PACK_COUNT
                     , FORECAST_INFO_BIZ_TYPE
                     , COMPANY_NAME
                     , APPLICATION
                     , APPLICATION_GR
                     , COUNTRY_KR_NAME
                     , ROUTE
                     , CELL_PROD_SITE )   /* [E20240429-000397] Sales Report화면 Cell Prod Site 칼럼 추가 */
                SELECT DATA_TYPE
                     , DIVISION_ID
                     , VERSION_NO
                     , CUTOFF_TYPE
                     , CUTOFF_YYYYMMDD
                     , DEPARTMENT_ID
                     , DEPARTMENT_NAME
                     , DEPT_ID
                     , DEPT_NAME
                     , END_CUST_REPORT
                     , CUST_REPORT
                     , PRODUCT_GROUP
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
                     , SOLDTO_CUST_REPORT
                     , OWNER_NAME
                     , CUST_GROUP_DTL
                     , PRODUCT_DETAILS
                     , FORECAST_INFO_SPEC
                     , NICK_NAME
                     , FORECAST_INFO_CELL_MODEL
                     , FORECAST_INFO_CELL_PACK_COUNT
                     , FORECAST_INFO_BIZ_TYPE
                     , COMPANY_NAME
                     , APPLICATION
                     , APPLICATION_GR
                     , COUNTRY_KR_NAME
                     , ROUTE
                     , CELL_PROD_SITE     /* [E20240429-000397] Sales Report화면 Cell Prod Site 칼럼 추가 */
                  FROM DM_PLN_SALES_PLAN_REPORT_C
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                SELECT COUNT(*)
                  INTO V_MOVE_CNT
                  FROM DM_PLN_SALES_PLAN_REPORT_C_KEEP
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                IF ( V_MOVE_CNT = V_DATA_CNT ) THEN
                    DELETE
                      FROM DM_PLN_SALES_PLAN_REPORT_C A
                     WHERE A.VERSION_NO  = V_VERSION_NO
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND EXISTS ( SELECT 1
                                      FROM DM_PLN_SALES_PLAN_REPORT_C_KEEP B
                                     WHERE A.DIVISION_ID   = B.DIVISION_ID
                                       AND A.VERSION_NO    = B.VERSION_NO
                                       AND A.DEPARTMENT_ID = B.DEPARTMENT_ID
                                       AND A.DEPT_ID       = B.DEPT_ID
                                       AND A.PROJECT_CODE  = B.PROJECT_CODE
                                       AND A.SCM_SITE_ID   = B.SCM_SITE_ID
                                       AND A.ITEM_ID       = B.ITEM_ID
                                       AND A.FCST_TYPE     = B.FCST_TYPE
                                       AND A.INCOTERMS     = B.INCOTERMS
                                       AND A.MEASURE       = B.MEASURE
                                       AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
                                       AND A.YYYYMMDD      = B.YYYYMMDD
                                       AND A.CURRENCY      = B.CURRENCY
                                       AND A.COMPANY_ID    = B.COMPANY_ID
                                       AND A.COMPO_40      = B.COMPO_40 );
                END IF;

                UPDATE DM_MDF_VERSION
                   SET ATTRIBUTE3 = 'MOVE'
                     , ATTRIBUTE5 = TO_CHAR(SYSDATE, 'YYYYMMDD')  /* [C20220103-000581] 다빈치 DataLake 이력 기록 */
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND VERSION_NO  = V_VERSION_NO;

                -- 2026.10.20 AJS 버전 단위 확정 (START) : AS-IS 는 문장마다 자동 확정
                COMMIT;
                -- 2026.10.20 AJS 버전 단위 확정 (END)
                V_WEEKDAY := MOD(TRUNC(SYSDATE) - TRUNC(SYSDATE, 'IW') + 1, 7) + 1;
                EXIT WHEN V_WEEKDAY NOT IN (1, 7);
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'PROCESS';
        V_LOG_MESSAGE := '########## Process............##########';
        V_DESCRIPTION := 'DM_PLN_SALES_PLAN_REPORT_C 이동';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /* <- 변수 재사용을 위하여 초기화해야함 */

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            /* ERROR LOG VALUE SAVE (원본 CATCH : ERROR_MESSAGE()/ERROR_LINE()) */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := 'ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            D_EVENT_DATE  := SYSDATE;
            /* [C20200909-000203] LOG 표준화 적용 */
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    END;


    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := NULL;
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

END PR_DM_CUTOFF_DATA_CLEANSING;