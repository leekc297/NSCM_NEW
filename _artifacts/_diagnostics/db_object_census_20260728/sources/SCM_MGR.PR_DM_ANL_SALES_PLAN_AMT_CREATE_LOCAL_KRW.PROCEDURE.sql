PROCEDURE PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW

(
    P_DIVISION_ID   IN VARCHAR2
  , P_CREATED_BY    IN VARCHAR2
)
/*=====================================================================================================================================================
 * Program ID   : PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW
 * Description  : Sales Plan AMT Create ( Local/KRW )
 * Program History
 *=====================================================================================================================================================
 *   Date       In Charge      	Description
 *=====================================================================================================================================================
 * 2017.02.05	DWOK/KHSONG	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.08.08				SALES_PLAN_CUTOFF  주석처리
 * 2019.07.09	KHSONG 		[CSR ID:4034895]  GSCM RTF[system] Measure 관련 요청건
 * 2019.11.14	KHSONG 		SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
 * 2020.02.13	HWI1993 	자동차사업부 SALES AMT 메저를 RTF_SCP 기준으로 생성
 * 2020.03.09	KHSONG 		TMM_FCST ADD
 * 2020.05.07	KHSONG 		C20200507-000035 (소형사업부 RTF 관련 Measure 숨기기)
 * 2020.08.06	hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
 * 2020.12.08    P.C.I		[C20201208-000087] ESS 'RTF'(RTF_MKT) -> 'RTF_SYS_RP'(RTF_SCP) 적용
 * 2021.07.02	HWI1993		[C20210629-000239] [SCM PI팀] MKT FCST Amt. 추가의 건
 * 2021.08.25	HWI1993		성능이슈로 긴급 수정함.
 * 2022.01.04	kdw2819		[C20211215-000199][ESS영업관리팀] GSCM Sales Price 내 Batch Job 버튼 실행 불가의 건
 * 2022.01.25   kdw2819		[C20220125-000410]Sales Plan, Sales Plan Waterfall Current 버전의 RTF없는 금액 표기 오류 수정 요청의 건
 * 2022.04.05   hwi1993     GM JV 작업
 * 2024.11.15	KANG.H.J	[PJ2024-50611] 소형 매출 프로세스 개선
 * 2024.11.29	KJJ			[PJ2024-50611] Catch Up 메저 삭제 금지
 * 2024.12.01	KANG.H.J	[PJ2024-50611] BPS 매출(RTF_SYS_RP Measrue) 전송 시 전 사업부 FROM_SITE_ID 추가 -- 기존 로직과 동일하도록 수정이 필요 함..
 * 2025.01.21	KJJ			[PJ2024-50611] 기타매출, Catch Up 테이블 분리
 * 2025.02.11	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - SALES_PLAN에 SCM_FCST MEASURE 추가
 * 2025.03.25	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 'AMT 부문' 업데이트
 * 2025.04.08	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제
 * 2025.04.28	KANG.H.J	[PJ2025-50017] 소형 매출계획 동기화 개선 - BPS전송용 FROM_SITE_ID 생성 (key 아님)
 * 2025.05.12	JSSBAE		[E20250507-000390]_Sales Plan UI 환율 재계산 기능 추가
 * 2025.05.13	KANG.H.J	[PJ2025-50188] 환율 변경시 DM_PLN_SALES_PLAN_RESULT SALES_AMT_KRW / MKT_AMT_KRW 재생성
 * 2025.06.10	KANG.H.J	[PJ2025-50188] 임시테이블 DROP 처리
 * 2025.06.23	KANG.H.J	[PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가
 * 2025.08.14	JSSBAE		[E20250813-000790]_시스템 환율 IF 및 환율 수기 변경 오류 확인 요청의 건
 * 2026.04.09	JSSBAE		[E20260331-000648]_[자동차 SCM] 자동차사업부 '기준수요'기능 중 'RTF수정기능'만 우선 적용 요청 건
 *===================================================================================================================================================*/
AS
    V_RECV_DIVISION_ID  VARCHAR2(4000 CHAR);
    V_DELIMITER         VARCHAR2(1 CHAR);
    V_MAX_LOOP_CNT      NUMBER := 0;
    V_MST_LOOP_CNT      NUMBER := 0;
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_CREATED_BY        VARCHAR2(4000 CHAR);
    V_START_YYYYMMDD    VARCHAR2(8 CHAR);
    V_END_YYYYMMDD      VARCHAR2(8 CHAR);
    V_SP_CUTOFF_FLAG    VARCHAR2(2 CHAR);
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW';
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    V_LOG_COUNT         NUMBER := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    V_EVENT_DATE        DATE;
BEGIN
    V_RECV_DIVISION_ID := P_DIVISION_ID;
    V_DELIMITER        := '^';

    V_START_YYYYMMDD := SUBSTR(TO_CHAR(ADD_MONTHS(SYSDATE, 0), 'YYYYMMDD'), 1, 6) || '01';  /* 당월 1일 */
    V_END_YYYYMMDD   := TO_CHAR(SYSDATE, 'YYYYMMDD');  /* 당일 */

    /* 사용자 매개변수: 있으면 그대로, 없으면 'CUTOFF' */
    IF P_CREATED_BY IS NULL THEN
        V_CREATED_BY := 'CUTOFF';
    ELSE
        V_CREATED_BY := P_CREATED_BY;
    END IF;

    /* [E20260331-000648] 40/81 사업부에 한해 당주 월요일 이후 SALES PLAN CUTOFF 데이터 존재 여부로 FLAG 결정 */
    IF ( P_DIVISION_ID = '40' OR SUBSTR(P_DIVISION_ID, 1, 2) = '81' ) THEN
        SELECT CASE WHEN A.CNT > 0 THEN 'Y' ELSE 'N' END
          INTO V_SP_CUTOFF_FLAG
          FROM ( SELECT COUNT(*) AS CNT
                   FROM DM_MST_VERSION
                  WHERE DIVISION_ID  = P_DIVISION_ID
                    AND VERSION_TYPE = 'SP_W'
                    AND YYYYMMDD    >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') ) A;
    ELSE
        V_SP_CUTOFF_FLAG := 'N';
    END IF;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '@p_division_id : ' || P_DIVISION_ID || ' / ' || '@v_created_by : ' || NVL(V_CREATED_BY, 'NULL');
    V_EVENT_DATE  := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);
    V_LOG_MESSAGE := NULL;  /* 변수 재사용 위해 초기화 */

    /* ================================ 트랜잭션 (TRY) ================================ */
    BEGIN

        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_DIVISION_ID, V_DELIMITER);
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A001--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        WHILE LENGTH(V_RECV_DIVISION_ID) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;
            V_DIVISION_ID  := SCM_ARR_SPL_VAL(P_DIVISION_ID, V_DELIMITER, V_MST_LOOP_CNT);

            IF V_MST_LOOP_CNT <= V_MAX_LOOP_CNT THEN

                /* 임시테이블 클리어 (원천 DROP+CREATE 대체) */
                DELETE FROM GT_PRDM_T2_MKT_FCST;
                DELETE FROM GT_PRDM_T2_PRICE;
                DELETE FROM GT_PRDM_SALES_PLAN_TEMP_LOC;
                DELETE FROM GT_PRDM_RTF_EXCEPTION_ITEM;
                DELETE FROM GT_PRDM_T_PRICE;

                /* [E20260331-000648] 당주 월요일 이후 수정이력 데이터 추출 (CUTOFF=Y 시) */
                IF ( V_SP_CUTOFF_FLAG = 'Y' ) THEN
                    INSERT INTO GT_PRDM_RTF_EXCEPTION_ITEM
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID )
                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                      FROM DM_PLN_SALES_PLAN
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                       AND TO_CHAR(LAST_UPDATE_DATE, 'YYYYMMDD') >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                       AND MEASURE IN ( 'RTF_SYS_RP', 'RTF', 'RTF_SCP' )
                       AND LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                     GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID;

                    INSERT INTO GT_PRDM_RTF_EXCEPTION_ITEM
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID )
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
                      FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
                         , GT_PRDM_RTF_EXCEPTION_ITEM B
                     WHERE A.DIVISION_ID       = B.DIVISION_ID
                       AND A.PROJECT_CODE      = B.PROJECT_CODE
                       AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                       AND A.ITEM_ID           = B.ITEM_ID
                       AND A.DOM_EXP           = B.DOM_EXP
                       AND A.FCST_TYPE         = B.FCST_TYPE
                       AND A.INCOTERMS         = B.INCOTERMS
                       AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
                       AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                       AND A.MEASURE = 'RTF_PR'
                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID;
                END IF;

                /* ==================== 기존 정보 삭제 (1) ==================== */
                DELETE FROM DM_PLN_SALES_PLAN
                 WHERE YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                   AND DIVISION_ID = V_DIVISION_ID
                   AND ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN GROUP BY ITEM_ID )
                   AND NOT EXISTS ( SELECT A.DIVISION_ID
                                      FROM SCM_MST_SITE_ITEM A, DM_PLN_SALES_PLAN B
                                     WHERE SALES_PLAN_ADJUST_YN = 'N'
                                       AND A.ITEM_ID      = B.ITEM_ID
                                       AND A.DIVISION_ID  = B.DIVISION_ID
                                       AND A.PROJECT_CODE = B.PROJECT_CODE
                                       AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                                       AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                                       AND B.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                                       AND A.DIVISION_ID  = DM_PLN_SALES_PLAN.DIVISION_ID
                                       AND A.PROJECT_CODE = DM_PLN_SALES_PLAN.PROJECT_CODE
                                       AND A.SCM_SITE_ID  = DM_PLN_SALES_PLAN.SCM_SITE_ID
                                       AND A.ITEM_ID      = DM_PLN_SALES_PLAN.ITEM_ID )
                   AND NOT EXISTS ( SELECT DISTINCT ITEM_ID
                                      FROM GT_PRDM_RTF_EXCEPTION_ITEM A
                                     WHERE DM_PLN_SALES_PLAN.DIVISION_ID   = A.DIVISION_ID
                                       AND DM_PLN_SALES_PLAN.PROJECT_CODE  = A.PROJECT_CODE
                                       AND DM_PLN_SALES_PLAN.SCM_SITE_ID   = A.SCM_SITE_ID
                                       AND DM_PLN_SALES_PLAN.ITEM_ID       = A.ITEM_ID
                                       AND DM_PLN_SALES_PLAN.DOM_EXP       = A.DOM_EXP
                                       AND DM_PLN_SALES_PLAN.FCST_TYPE     = A.FCST_TYPE
                                       AND DM_PLN_SALES_PLAN.INCOTERMS     = A.INCOTERMS
                                       AND DM_PLN_SALES_PLAN.MEASURE       = A.MEASURE
                                       AND DM_PLN_SALES_PLAN.PLANT_SITE_ID = A.PLANT_SITE_ID
                                       AND DM_PLN_SALES_PLAN.YYYYMMDD     >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') )
                   AND MEASURE NOT IN ( 'CATCH_UP', 'LOC_Catch_Up', 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up' );

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A002--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                /* ==================== 기존 정보 삭제 (2) : Unsync 수정건도 MKT_FCST/RTF 재계산 ==================== */
                DELETE FROM DM_PLN_SALES_PLAN
                 WHERE YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                   AND DIVISION_ID = V_DIVISION_ID
                   AND ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN GROUP BY ITEM_ID )
                   AND NOT EXISTS ( SELECT DISTINCT ITEM_ID
                                      FROM GT_PRDM_RTF_EXCEPTION_ITEM A
                                     WHERE DM_PLN_SALES_PLAN.DIVISION_ID   = A.DIVISION_ID
                                       AND DM_PLN_SALES_PLAN.PROJECT_CODE  = A.PROJECT_CODE
                                       AND DM_PLN_SALES_PLAN.SCM_SITE_ID   = A.SCM_SITE_ID
                                       AND DM_PLN_SALES_PLAN.ITEM_ID       = A.ITEM_ID
                                       AND DM_PLN_SALES_PLAN.DOM_EXP       = A.DOM_EXP
                                       AND DM_PLN_SALES_PLAN.FCST_TYPE     = A.FCST_TYPE
                                       AND DM_PLN_SALES_PLAN.INCOTERMS     = A.INCOTERMS
                                       AND DM_PLN_SALES_PLAN.MEASURE       = A.MEASURE
                                       AND DM_PLN_SALES_PLAN.PLANT_SITE_ID = A.PLANT_SITE_ID
                                       AND DM_PLN_SALES_PLAN.YYYYMMDD     >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') )
                   AND MEASURE IN ( 'MKT_FCST', 'CUST_FCST', 'RTF', 'RTF_SYS_RP', 'TMM_FCST', 'SCM_FCST', 'RTF_PR' );

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A003--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                /* 2021.08.25  Future Price -> #T_PRICE(GT_PRDM_T_PRICE) */
                INSERT INTO GT_PRDM_T_PRICE
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
                SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE
                  FROM SCM_MST_FUTURE_PRICE A
                 WHERE A.DIVISION_ID = V_DIVISION_ID
                   AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                   AND A.MEASURE IN ( 'KRW', 'LOC', 'USD' );

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A004--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                /* ==================== [PJ2025-50017] #T2_PRICE : 40=CFM_SELLING_PRICE / 그외=FUTURE_PRICE ==================== */
                IF ( V_DIVISION_ID = '40' ) THEN
                    INSERT INTO GT_PRDM_T2_PRICE
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
                    SELECT A.DIVISION_ID, A.END_CUSTOMER AS PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
                         , A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE
                      FROM DM_PLN_CFM_SELLING_PRICE A
                     WHERE A.DIVISION_ID = V_DIVISION_ID
                       AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                       AND A.MEASURE IN ( 'KRW', 'LOC', 'USD' );
                ELSE
                    INSERT INTO GT_PRDM_T2_PRICE
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID
                         , A.ITEM_ID, A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PRICE
                      FROM SCM_MST_FUTURE_PRICE A
                     WHERE A.DIVISION_ID = V_DIVISION_ID
                       AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                       AND A.MEASURE IN ( 'KRW', 'LOC', 'USD' );
                END IF;

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A005--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                /* ==================== [PJ2025-50017] #T2_MKT_FCST : 40=CFM_MKT_DEMAND_PLAN / 그외=MKT_FCST ==================== */
                IF ( V_DIVISION_ID = '40' ) THEN
                    INSERT INTO GT_PRDM_T2_MKT_FCST
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , FROM_SITE_ID, QTY, CREATED_BY, CREATION_DATE, LASTED_BY, LASTED_DATE )
                    SELECT A.DIVISION_ID, A.END_CUSTOMER AS PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
                         , A.ATTRIBUTE2 AS FROM_SITE_ID
                         , A.QTY, A.CREATED_BY, A.CREATION_DATE
                         , CASE WHEN V_SP_CUTOFF_FLAG = 'Y' THEN A.LAST_UPDATED_BY  ELSE V_CREATED_BY END
                         , CASE WHEN V_SP_CUTOFF_FLAG = 'Y' THEN A.LAST_UPDATE_DATE ELSE SYSDATE      END
                      FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
                     WHERE A.DIVISION_ID = V_DIVISION_ID
                       AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                       AND A.MEASURE IN ( 'MKT_FCST', 'RTF', 'RTF_SYS_RP', 'SCM_FCST', 'RTF_PR' )
                       AND A.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN GROUP BY ITEM_ID )
                    UNION
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID
                         , '-' AS FROM_SITE_ID
                         , A.QTY, A.CREATED_BY, A.CREATION_DATE
                         , CASE WHEN V_SP_CUTOFF_FLAG = 'Y' THEN A.LAST_UPDATED_BY  ELSE V_CREATED_BY END
                         , CASE WHEN V_SP_CUTOFF_FLAG = 'Y' THEN A.LAST_UPDATE_DATE ELSE SYSDATE      END
                      FROM DM_PLN_MKT_FCST A
                     WHERE A.DIVISION_ID = V_DIVISION_ID
                       AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                       AND A.MEASURE IN ( 'CUST_FCST', 'TMM_FCST' )
                       AND A.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN GROUP BY ITEM_ID );
                ELSE
                    INSERT INTO GT_PRDM_T2_MKT_FCST
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, CELL_PROD_SITE_ID
                    , FROM_SITE_ID, QTY, CREATED_BY, CREATION_DATE, LASTED_BY, LASTED_DATE )
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, '-' AS CELL_PROD_SITE_ID
                         , '-' AS FROM_SITE_ID
                         , A.QTY, A.CREATED_BY, A.CREATION_DATE
                         , CASE WHEN V_SP_CUTOFF_FLAG = 'Y' THEN A.LAST_UPDATED_BY  ELSE V_CREATED_BY END
                         , CASE WHEN V_SP_CUTOFF_FLAG = 'Y' THEN A.LAST_UPDATE_DATE ELSE SYSDATE      END
                      FROM DM_PLN_MKT_FCST A
                     WHERE A.DIVISION_ID = V_DIVISION_ID
                       AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                       AND A.MEASURE IN ( 'MKT_FCST', 'CUST_FCST', 'TMM_FCST', 'SCM_FCST' )
                       AND A.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN GROUP BY ITEM_ID )
                    UNION ALL
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, CELL_PROD_SITE_ID
                         , A.ATTRIBUTE2 AS FROM_SITE_ID
                         , A.QTY, A.CREATED_BY, A.CREATION_DATE
                         , CASE WHEN V_SP_CUTOFF_FLAG = 'Y' THEN A.LAST_UPDATED_BY  ELSE V_CREATED_BY END
                         , CASE WHEN V_SP_CUTOFF_FLAG = 'Y' THEN A.LAST_UPDATE_DATE ELSE SYSDATE      END
                      FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
                     WHERE A.DIVISION_ID = V_DIVISION_ID
                       AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                       AND A.MEASURE IN ( 'RTF', 'RTF_SYS_RP', 'RTF_PR' )
                       AND A.ITEM_ID IN ( SELECT ITEM_ID FROM SCM_MST_ITEM_SN GROUP BY ITEM_ID );
                END IF;

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A006--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                /* ==================== MKT_FCST 기반 MKT_AMT_KRW/LOC 생성 -> #SALES_PLAN_TEMP_LOC ==================== */
                INSERT INTO GT_PRDM_SALES_PLAN_TEMP_LOC
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, FROM_SITE_ID, YYYYMMDD, CURRENCY
                , QTY, CREATED_BY, CREATION_DATE, LASTED_BY, LASTED_DATE )
                SELECT DISTINCT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
                              , W.MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.FROM_SITE_ID, W.YYYYMMDD, SI.CURRENCY
                              , W.QTY, W.CREATED_BY, W.CREATION_DATE, W.LASTED_BY, W.LASTED_DATE
                  FROM GT_PRDM_T2_MKT_FCST W
                  /* H-3: SI가 W와 CALW(둘 다 아우터)에 종속되어 (+) 표현 불가(ORA-01417) -> ANSI OUTER JOIN 유지 */
                  LEFT OUTER JOIN SCM_SYS_CALENDAR_M CALW1 ON CALW1.BASIS_YYYYMMDD = W.YYYYMMDD
                  LEFT OUTER JOIN GT_PRDM_T2_PRICE SI
                               ON ( W.DIVISION_ID       = SI.DIVISION_ID
                              AND   W.PROJECT_CODE      = SI.PROJECT_CODE
                              AND   W.SCM_SITE_ID       = SI.SCM_SITE_ID
                              AND   W.ITEM_ID           = SI.ITEM_ID
                              AND   W.DOM_EXP           = SI.DOM_EXP
                              AND   W.FCST_TYPE         = SI.FCST_TYPE
                              AND   W.INCOTERMS         = SI.INCOTERMS
                              AND   W.PLANT_SITE_ID     = SI.PLANT_SITE_ID
                              AND   W.CELL_PROD_SITE_ID = SI.CELL_PROD_SITE_ID
                              AND   CALW1.BASIS_START_DATE = SI.YYYYMMDD )
                 WHERE W.MEASURE IN ( 'MKT_FCST', 'CUST_FCST', 'TMM_FCST', 'SCM_FCST' )
                UNION ALL
                SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
                     , CASE WHEN FP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                            WHEN FP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
                       END AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.FROM_SITE_ID, W.YYYYMMDD, FP.CURRENCY
                     , CASE WHEN FP.MEASURE = 'KRW' THEN ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                            WHEN FP.MEASURE = 'LOC' THEN ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                       END AS QTY, NULL, NULL, NULL, NULL
                  FROM GT_PRDM_T2_MKT_FCST W
                     , GT_PRDM_T2_PRICE FP
                 WHERE FP.DIVISION_ID       = W.DIVISION_ID
                   AND FP.PROJECT_CODE      = W.PROJECT_CODE
                   AND FP.SCM_SITE_ID       = W.SCM_SITE_ID
                   AND FP.ITEM_ID           = W.ITEM_ID
                   AND FP.DOM_EXP           = W.DOM_EXP
                   AND FP.FCST_TYPE         = W.FCST_TYPE
                   AND FP.INCOTERMS         = W.INCOTERMS
                   AND FP.PLANT_SITE_ID     = W.PLANT_SITE_ID
                   AND FP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
                   AND FP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
                   AND FP.MEASURE IN ( 'KRW', 'LOC' )
                   AND W.MEASURE = 'MKT_FCST';

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A007--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                /* ==================== RTF 기반 SalesAmt 생성 -> #SALES_PLAN_TEMP_LOC (40 / 그외) ==================== */
                IF ( V_DIVISION_ID = '40' ) THEN
                    INSERT INTO GT_PRDM_SALES_PLAN_TEMP_LOC
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, FROM_SITE_ID, YYYYMMDD, CURRENCY
                    , QTY, CREATED_BY, CREATION_DATE, LASTED_BY, LASTED_DATE )
                    SELECT DISTINCT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
                                  , W.MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.FROM_SITE_ID, W.YYYYMMDD, SI.CURRENCY
                                  , W.QTY, W.CREATED_BY, W.CREATION_DATE, W.LASTED_BY, W.LASTED_DATE
                      FROM GT_PRDM_T2_MKT_FCST W
                      /* H-3: SI가 W와 CALW(둘 다 아우터)에 종속되어 (+) 표현 불가(ORA-01417) -> ANSI OUTER JOIN 유지 */
                      LEFT OUTER JOIN SCM_SYS_CALENDAR_M CALW2 ON CALW2.BASIS_YYYYMMDD = W.YYYYMMDD
                      LEFT OUTER JOIN GT_PRDM_T2_PRICE SI
                                   ON ( W.DIVISION_ID       = SI.DIVISION_ID
                                  AND   W.PROJECT_CODE      = SI.PROJECT_CODE
                                  AND   W.SCM_SITE_ID       = SI.SCM_SITE_ID
                                  AND   W.ITEM_ID           = SI.ITEM_ID
                                  AND   W.DOM_EXP           = SI.DOM_EXP
                                  AND   W.FCST_TYPE         = SI.FCST_TYPE
                                  AND   W.INCOTERMS         = SI.INCOTERMS
                                  AND   W.PLANT_SITE_ID     = SI.PLANT_SITE_ID
                                  AND   W.CELL_PROD_SITE_ID = SI.CELL_PROD_SITE_ID
                                  AND   CALW2.BASIS_START_DATE = SI.YYYYMMDD )
                     WHERE W.MEASURE IN ( 'RTF', 'RTF_SYS_RP', 'RTF_PR' )
                    UNION ALL
                    SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
                         , CASE WHEN FP.MEASURE = 'KRW' THEN 'SalesAmt_KRW'
                                WHEN FP.MEASURE = 'LOC' THEN 'SalesAmt_LOC'
                                WHEN FP.MEASURE = 'USD' THEN 'SalesAmt_USD'
                                ELSE FP.MEASURE
                           END AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.FROM_SITE_ID, W.YYYYMMDD, FP.CURRENCY
                         , CASE WHEN FP.MEASURE = 'KRW' THEN ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                                WHEN FP.MEASURE = 'LOC' THEN ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                                WHEN FP.MEASURE = 'USD' THEN ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                           END AS QTY, NULL, NULL, NULL, NULL
                      FROM GT_PRDM_T2_MKT_FCST W
                         , GT_PRDM_T2_PRICE FP
                     WHERE FP.DIVISION_ID       = W.DIVISION_ID
                       AND FP.PROJECT_CODE      = W.PROJECT_CODE
                       AND FP.SCM_SITE_ID       = W.SCM_SITE_ID
                       AND FP.ITEM_ID           = W.ITEM_ID
                       AND FP.DOM_EXP           = W.DOM_EXP
                       AND FP.FCST_TYPE         = W.FCST_TYPE
                       AND FP.INCOTERMS         = W.INCOTERMS
                       AND FP.PLANT_SITE_ID     = W.PLANT_SITE_ID
                       AND FP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
                       AND FP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
                       AND W.MEASURE = 'RTF_SYS_RP'
                       AND NOT EXISTS ( SELECT A.DIVISION_ID
                                          FROM SCM_MST_SITE_ITEM A, DM_PLN_SALES_PLAN B
                                         WHERE A.SALES_PLAN_ADJUST_YN = 'N'
                                           AND A.ITEM_ID      = B.ITEM_ID
                                           AND A.DIVISION_ID  = B.DIVISION_ID
                                           AND A.PROJECT_CODE = B.PROJECT_CODE
                                           AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                                           AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                                           AND B.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                                           AND A.DIVISION_ID  = W.DIVISION_ID
                                           AND A.PROJECT_CODE = W.PROJECT_CODE
                                           AND A.SCM_SITE_ID  = W.SCM_SITE_ID
                                           AND A.ITEM_ID      = W.ITEM_ID );
                ELSE
                    INSERT INTO GT_PRDM_SALES_PLAN_TEMP_LOC
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, FROM_SITE_ID, YYYYMMDD, CURRENCY
                    , QTY, CREATED_BY, CREATION_DATE, LASTED_BY, LASTED_DATE )
                    SELECT DISTINCT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
                                  , W.MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.FROM_SITE_ID, W.YYYYMMDD, SI.CURRENCY
                                  , W.QTY, W.CREATED_BY, W.CREATION_DATE, W.LASTED_BY, W.LASTED_DATE
                      FROM GT_PRDM_T2_MKT_FCST W
                      /* H-3: SI가 W와 CALW(둘 다 아우터)에 종속되어 (+) 표현 불가(ORA-01417) -> ANSI OUTER JOIN 유지 */
                      LEFT OUTER JOIN SCM_SYS_CALENDAR_M CALW3 ON CALW3.BASIS_YYYYMMDD = W.YYYYMMDD
                      LEFT OUTER JOIN GT_PRDM_T2_PRICE SI
                                   ON ( W.DIVISION_ID   = SI.DIVISION_ID
                                  AND   W.PROJECT_CODE  = SI.PROJECT_CODE
                                  AND   W.SCM_SITE_ID   = SI.SCM_SITE_ID
                                  AND   W.ITEM_ID       = SI.ITEM_ID
                                  AND   W.DOM_EXP       = SI.DOM_EXP
                                  AND   W.FCST_TYPE     = SI.FCST_TYPE
                                  AND   W.INCOTERMS     = SI.INCOTERMS
                                  AND   W.PLANT_SITE_ID = SI.PLANT_SITE_ID
                                  AND   CALW3.BASIS_START_DATE = SI.YYYYMMDD )
                     WHERE W.MEASURE IN ( 'RTF', 'RTF_SYS_RP', 'RTF_PR' )
                    UNION ALL
                    SELECT W.DIVISION_ID, W.PROJECT_CODE, W.SCM_SITE_ID, W.ITEM_ID, W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
                         , CASE WHEN FP.MEASURE = 'KRW' THEN 'SalesAmt_KRW'
                                WHEN FP.MEASURE = 'LOC' THEN 'SalesAmt_LOC'
                                WHEN FP.MEASURE = 'USD' THEN 'SalesAmt_USD'
                                ELSE FP.MEASURE
                           END AS MEASURE, W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.FROM_SITE_ID, W.YYYYMMDD, FP.CURRENCY
                         , CASE WHEN FP.MEASURE = 'KRW' THEN ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                                WHEN FP.MEASURE = 'LOC' THEN ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                                WHEN FP.MEASURE = 'USD' THEN ROUND(W.QTY * NVL(FP.PRICE, 0), 5)
                           END AS QTY, NULL, NULL, NULL, NULL
                      FROM GT_PRDM_T2_MKT_FCST W
                         , GT_PRDM_T2_PRICE FP
                     WHERE FP.DIVISION_ID   = W.DIVISION_ID
                       AND FP.PROJECT_CODE  = W.PROJECT_CODE
                       AND FP.SCM_SITE_ID   = W.SCM_SITE_ID
                       AND FP.ITEM_ID       = W.ITEM_ID
                       AND FP.DOM_EXP       = W.DOM_EXP
                       AND FP.FCST_TYPE     = W.FCST_TYPE
                       AND FP.INCOTERMS     = W.INCOTERMS
                       AND FP.PLANT_SITE_ID = W.PLANT_SITE_ID
                       AND FP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
                       AND W.MEASURE = 'RTF_SYS_RP'
                       AND NOT EXISTS ( SELECT A.DIVISION_ID
                                          FROM SCM_MST_SITE_ITEM A, DM_PLN_SALES_PLAN B
                                         WHERE A.SALES_PLAN_ADJUST_YN = 'N'
                                           AND A.ITEM_ID      = B.ITEM_ID
                                           AND A.DIVISION_ID  = B.DIVISION_ID
                                           AND A.PROJECT_CODE = B.PROJECT_CODE
                                           AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                                           AND B.LAST_UPDATED_BY NOT IN ( 'SYSTEM', 'CUTOFF' )
                                           AND B.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                                           AND A.DIVISION_ID  = W.DIVISION_ID
                                           AND A.PROJECT_CODE = W.PROJECT_CODE
                                           AND A.SCM_SITE_ID  = W.SCM_SITE_ID
                                           AND A.ITEM_ID      = W.ITEM_ID );
                END IF;

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A008--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                /* ==================== [PJ2025-50188] RTF_SYS_RP 없고 MKT_FCST만 있으면 RTF_SYS_RP 0 생성 (40) ==================== */
                IF ( V_DIVISION_ID = '40' ) THEN
                    INSERT INTO GT_PRDM_SALES_PLAN_TEMP_LOC
                    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                    , PLANT_SITE_ID, CELL_PROD_SITE_ID, FROM_SITE_ID, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LASTED_BY, LASTED_DATE )
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'RTF_SYS_RP' AS MEASURE
                         , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, MAX(FROM_SITE_ID) AS FROM_SITE_ID, A.YYYYMMDD, MAX(CURRENCY) AS CURRENCY
                         , SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) AS QTY
                         , MIN(CREATED_BY)    AS CREATED_BY
                         , MIN(CREATION_DATE) AS CREATION_DATE
                         , MIN(LASTED_BY)     AS LASTED_BY
                         , MIN(LASTED_DATE)   AS LASTED_DATE
                      FROM GT_PRDM_SALES_PLAN_TEMP_LOC A
                     WHERE 1 = 1
                       AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST' )
                       AND NOT EXISTS ( SELECT B.DIVISION_ID
                                          FROM GT_PRDM_SALES_PLAN_TEMP_LOC B
                                         WHERE B.MEASURE = 'RTF_SYS_RP'
                                           AND A.DIVISION_ID       = B.DIVISION_ID
                                           AND A.PROJECT_CODE      = B.PROJECT_CODE
                                           AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                                           AND A.ITEM_ID           = B.ITEM_ID
                                           AND A.DOM_EXP           = B.DOM_EXP
                                           AND A.FCST_TYPE         = B.FCST_TYPE
                                           AND A.INCOTERMS         = B.INCOTERMS
                                           AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
                                           AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                                           AND A.YYYYMMDD          = B.YYYYMMDD )
                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
                    HAVING SUM(CASE WHEN A.MEASURE = 'MKT_FCST' THEN A.QTY ELSE 0 END) <> 0;
                END IF;

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                /* #SALES_PLAN_TEMP_LOC 대상 기존 DM_PLN_SALES_PLAN 삭제 */
                DELETE FROM DM_PLN_SALES_PLAN
                 WHERE EXISTS ( SELECT B.DIVISION_ID
                                  FROM GT_PRDM_SALES_PLAN_TEMP_LOC B
                                 WHERE 1 = 1
                                   AND DM_PLN_SALES_PLAN.DIVISION_ID       = B.DIVISION_ID
                                   AND DM_PLN_SALES_PLAN.PROJECT_CODE      = B.PROJECT_CODE
                                   AND DM_PLN_SALES_PLAN.SCM_SITE_ID       = B.SCM_SITE_ID
                                   AND DM_PLN_SALES_PLAN.ITEM_ID           = B.ITEM_ID
                                   AND DM_PLN_SALES_PLAN.DOM_EXP           = B.DOM_EXP
                                   AND DM_PLN_SALES_PLAN.FCST_TYPE         = B.FCST_TYPE
                                   AND DM_PLN_SALES_PLAN.INCOTERMS         = B.INCOTERMS
                                   AND DM_PLN_SALES_PLAN.MEASURE           = B.MEASURE
                                   AND DM_PLN_SALES_PLAN.PLANT_SITE_ID     = B.PLANT_SITE_ID
                                   AND DM_PLN_SALES_PLAN.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                                   AND DM_PLN_SALES_PLAN.YYYYMMDD          = B.YYYYMMDD );

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A010--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                INSERT INTO DM_PLN_SALES_PLAN
                ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
                SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                              , YYYYMMDD, CURRENCY, QTY, NVL(CREATED_BY, V_CREATED_BY), NVL(CREATION_DATE, SYSDATE)
                              , CASE WHEN LASTED_BY NOT IN ( 'SYSTEM', 'CUTOFF' ) THEN LASTED_BY   ELSE V_CREATED_BY END
                              , CASE WHEN LASTED_BY NOT IN ( 'SYSTEM', 'CUTOFF' ) THEN LASTED_DATE ELSE SYSTIMESTAMP END
                              , NULL AS ATTRIBUTE1
                              , FROM_SITE_ID AS ATTRIBUTE2
                              , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
                  FROM GT_PRDM_SALES_PLAN_TEMP_LOC;

                DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A011--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

            END IF;  /* IF V_MST_LOOP_CNT <= V_MAX_LOOP_CNT */

            /* ==================== [PJ2024-50611] 기타매출 Catch Up 테이블 분리 ==================== */
            DELETE FROM DM_PLN_SALES_ETC_PLAN
             WHERE 1 = 1
               AND DIVISION_ID = V_DIVISION_ID
               AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND MEASURE IN ( 'SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up' );

            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A012--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

            INSERT INTO DM_PLN_SALES_ETC_PLAN
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
            , MEASURE, PLANT_SITE_ID, YYYYMMDD
            , QTY, CURRENCY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, REMARK_TEXT )
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                 , CASE WHEN B.MEASURE = 'KRW' THEN 'SalesAmt_KRW_Catch_Up'
                        WHEN B.MEASURE = 'LOC' THEN 'SalesAmt_LOC_Catch_Up'
                        WHEN B.MEASURE = 'USD' THEN 'SalesAmt_USD_Catch_Up' ELSE B.MEASURE
                   END AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
                 , CASE WHEN B.MEASURE = 'KRW' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                        WHEN B.MEASURE = 'LOC' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                        WHEN B.MEASURE = 'USD' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                   END AS QTY, B.CURRENCY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.REMARK_TEXT
              FROM DM_PLN_SALES_ETC_PLAN A
                 , GT_PRDM_T_PRICE B
             WHERE A.DIVISION_ID   = B.DIVISION_ID
               AND A.PROJECT_CODE  = B.PROJECT_CODE
               AND A.SCM_SITE_ID   = B.SCM_SITE_ID
               AND A.ITEM_ID       = B.ITEM_ID
               AND A.DOM_EXP       = B.DOM_EXP
               AND A.FCST_TYPE     = B.FCST_TYPE
               AND A.INCOTERMS     = B.INCOTERMS
               AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
               AND B.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = A.YYYYMMDD )
               AND A.MEASURE = 'Catch_Up'
               AND A.DIVISION_ID = V_DIVISION_ID
               AND B.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND B.MEASURE IN ( 'KRW', 'LOC', 'USD' );

            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A013--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

            /* ==================== [E20250507-000390] Sales Plan UI 환율 재계산 ==================== */
            DELETE FROM DM_PLN_SALES_ETC_PLAN
             WHERE 1 = 1
               AND DIVISION_ID = V_DIVISION_ID
               AND YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND MEASURE IN ( 'SalesAmt_KRW', 'SalesAmt_USD' )
               AND FCST_TYPE = 'ETC';

            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A014--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

            /* SalesAmt_KRW 계산 */
            INSERT INTO DM_PLN_SALES_ETC_PLAN
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, REMARK_TEXT, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY
            , QTY
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
            , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.REMARK_TEXT, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'SalesAmt_KRW' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY
                 , CASE WHEN A.CURRENCY = 'KRW' THEN A.QTY
                        ELSE CASE WHEN A.CURRENCY = 'USD' THEN NVL(CAST(A.QTY AS NUMBER(30,10)) * ( SELECT CAST(EXCHANGE_PRICE AS NUMBER(14,4))
                                                                                                     FROM DM_MST_EXCHANGE_RATE
                                                                                                    WHERE DIVISION_ID = A.DIVISION_ID
                                                                                                      AND YYYYMMDD = SUBSTR(A.YYYYMMDD, 1, 6) || '01'
                                                                                                      AND UNIT_CURRENCY = 'USD'
                                                                                                      AND CURRENCY = 'KRW'
                                                                                                    GROUP BY CAST(EXCHANGE_PRICE AS NUMBER(14,4)) ), 0)
                                  ELSE CASE WHEN A.CURRENCY NOT IN ( 'KRW', 'USD' ) THEN NVL(CAST(A.QTY AS NUMBER(30,10)) * ( SELECT CAST(EXCHANGE_PRICE AS NUMBER(14,4))
                                                                                                                                FROM DM_MST_EXCHANGE_RATE
                                                                                                                               WHERE DIVISION_ID = A.DIVISION_ID
                                                                                                                                 AND YYYYMMDD = SUBSTR(A.YYYYMMDD, 1, 6) || '01'
                                                                                                                                 AND UNIT_CURRENCY = A.CURRENCY
                                                                                                                                 AND CURRENCY = 'KRW'
                                                                                                                               GROUP BY CAST(EXCHANGE_PRICE AS NUMBER(14,4)) ), 0)
                                       END
                             END
                   END AS QTY
                 , A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
                 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
              FROM DM_PLN_SALES_ETC_PLAN A
             WHERE A.MEASURE = 'SalesAmt_LOC'
               AND A.DIVISION_ID = V_DIVISION_ID
               AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND A.FCST_TYPE = 'ETC';

            DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A015--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

            /* SalesAmt_USD 계산 */
            INSERT INTO DM_PLN_SALES_ETC_PLAN
            ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, REMARK_TEXT, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, CURRENCY
            , QTY
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
            , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.REMARK_TEXT, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'SalesAmt_USD' AS MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, A.CURRENCY
                 , CASE WHEN A.CURRENCY = 'KRW' THEN NVL(CAST(A.QTY AS NUMBER(30,10)) / ( SELECT CAST(EXCHANGE_PRICE AS NUMBER(14,4))
                                                                                           FROM DM_MST_EXCHANGE_RATE
                                                                                          WHERE DIVISION_ID = A.DIVISION_ID
                                                                                            AND YYYYMMDD = SUBSTR(A.YYYYMMDD, 1, 6) || '01'
                                                                                            AND UNIT_CURRENCY = 'USD'
                                                                                            AND CURRENCY = 'KRW'
                                                                                          GROUP BY CAST(EXCHANGE_PRICE AS NUMBER(14,4)) ), 0)
                        ELSE CASE WHEN A.CURRENCY = 'USD' THEN A.QTY
                                  ELSE CASE WHEN A.CURRENCY NOT IN ( 'KRW', 'USD' ) THEN NVL(CAST(A.QTY AS NUMBER(30,10)) * ( SELECT CAST(EXCHANGE_PRICE AS NUMBER(14,4))
                                                                                                                                FROM DM_MST_EXCHANGE_RATE
                                                                                                                               WHERE DIVISION_ID = A.DIVISION_ID
                                                                                                                                 AND YYYYMMDD = SUBSTR(A.YYYYMMDD, 1, 6) || '01'
                                                                                                                                 AND UNIT_CURRENCY = A.CURRENCY
                                                                                                                                 AND CURRENCY = 'KRW'
                                                                                                                               GROUP BY CAST(EXCHANGE_PRICE AS NUMBER(14,4)) )
                                                                                          / ( SELECT CAST(EXCHANGE_PRICE AS NUMBER(14,4))
                                                                                                FROM DM_MST_EXCHANGE_RATE
                                                                                               WHERE DIVISION_ID = A.DIVISION_ID
                                                                                                 AND YYYYMMDD = SUBSTR(A.YYYYMMDD, 1, 6) || '01'
                                                                                                 AND UNIT_CURRENCY = 'USD'
                                                                                                 AND CURRENCY = 'KRW'
                                                                                               GROUP BY CAST(EXCHANGE_PRICE AS NUMBER(14,4)) ), 0)
                                       END
                             END
                   END AS QTY
                 , A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
                 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
              FROM DM_PLN_SALES_ETC_PLAN A
             WHERE A.MEASURE = 'SalesAmt_LOC'
               AND A.DIVISION_ID = V_DIVISION_ID
               AND A.YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND A.FCST_TYPE = 'ETC';

        END LOOP;  /* WHILE division split */

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A016--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        /* ==================== [PJ2025-50017] DM_PLN_CFM_MKT_DEMAND_PLAN MKT_AMT 업데이트 (MERGE) ==================== */
        MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN A
        USING ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                     , CASE WHEN B.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                            WHEN B.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
                       END AS MEASURE
                     , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID
                     , A.YYYYMMDD
                     , CASE WHEN B.MEASURE = 'KRW' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                            WHEN B.MEASURE = 'LOC' THEN ROUND(A.QTY * NVL(B.PRICE, 0), 5)
                       END AS QTY
                     , NVL(A.CREATED_BY, V_CREATED_BY)   AS CREATED_BY
                     , NVL(A.CREATION_DATE, SYSDATE)     AS CREATION_DATE
                     , V_CREATED_BY                      AS LAST_UPDATED_BY
                     , SYSTIMESTAMP                      AS LAST_UPDATE_DATE
                  FROM DM_PLN_CFM_MKT_DEMAND_PLAN A
                     , DM_PLN_CFM_SELLING_PRICE B
                 WHERE A.DIVISION_ID       = B.DIVISION_ID
                   AND A.PROJECT_CODE      = B.PROJECT_CODE
                   AND A.END_CUSTOMER      = B.END_CUSTOMER
                   AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                   AND A.ITEM_ID           = B.ITEM_ID
                   AND A.DOM_EXP           = B.DOM_EXP
                   AND A.FCST_TYPE         = B.FCST_TYPE
                   AND A.INCOTERMS         = B.INCOTERMS
                   AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
                   AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                   AND B.MEASURE IN ( 'KRW', 'LOC' )
                   AND ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = A.YYYYMMDD ) = B.YYYYMMDD
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.MEASURE     = 'MKT_FCST' ) B
        ON ( A.DIVISION_ID       = B.DIVISION_ID
        AND  A.PROJECT_CODE      = B.PROJECT_CODE
        AND  A.END_CUSTOMER      = B.END_CUSTOMER
        AND  A.SCM_SITE_ID       = B.SCM_SITE_ID
        AND  A.ITEM_ID           = B.ITEM_ID
        AND  A.DOM_EXP           = B.DOM_EXP
        AND  A.FCST_TYPE         = B.FCST_TYPE
        AND  A.INCOTERMS         = B.INCOTERMS
        AND  A.MEASURE           = B.MEASURE
        AND  A.PLANT_SITE_ID     = B.PLANT_SITE_ID
        AND  A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
        AND  A.YYYYMMDD          = B.YYYYMMDD )
        WHEN MATCHED THEN
            UPDATE SET A.QTY              = B.QTY
                     , A.LAST_UPDATED_BY  = B.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE = B.LAST_UPDATE_DATE
        WHEN NOT MATCHED THEN
            INSERT ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
                   , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            VALUES ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID
                   , B.YYYYMMDD, B.QTY, B.CREATED_BY, B.CREATION_DATE, B.LAST_UPDATED_BY, B.LAST_UPDATE_DATE );

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A017--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        /* ==================== [PJ2025-50188] 환율 변경 시 DM_PLN_SALES_PLAN_RESULT 재생성 (40) ==================== */
        IF ( P_DIVISION_ID = '40' ) THEN
            DELETE FROM DM_PLN_SALES_PLAN_RESULT
             WHERE DIVISION_ID = P_DIVISION_ID
               AND MEASURE IN ( 'SalesAmt_KRW', 'MKT_AMT_KRW' )
               AND YYYYMMDD >= V_START_YYYYMMDD
               AND YYYYMMDD <  V_END_YYYYMMDD;

            INSERT INTO DM_PLN_SALES_PLAN_RESULT
            ( DIVISION_ID, COMPANY_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            , ATTRIBUTE1, ATTRIBUTE2, CELL_PROD_SITE_ID )
            SELECT A.DIVISION_ID, A.COMPANY_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, C.MEASURE
                 , A.YYYYMMDD, A.CURRENCY, A.QTY * B.EXCHANGE_PRICE AS QTY, A.CREATED_BY, SYSDATE AS CREATION_DATE, A.LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
                 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.CELL_PROD_SITE_ID
              FROM DM_PLN_SALES_PLAN_RESULT A
                 , DM_MST_EXCHANGE_RATE B
                 , ( SELECT 'MKT_AMT_KRW' AS MEASURE FROM DUAL UNION ALL SELECT 'SalesAmt_KRW' AS MEASURE FROM DUAL ) C
             WHERE A.DIVISION_ID = B.DIVISION_ID
               AND SUBSTR(A.YYYYMMDD, 1, 6) || '01' = B.YYYYMMDD
               AND A.CURRENCY = B.UNIT_CURRENCY
               AND B.CURRENCY = 'KRW'
               AND 1 = 1
               AND A.DIVISION_ID = P_DIVISION_ID
               AND A.MEASURE     = 'SalesAmt_LOC'
               AND A.YYYYMMDD   >= V_START_YYYYMMDD
               AND A.YYYYMMDD   <  V_END_YYYYMMDD;
        END IF;

        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A018--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
        DBMS_OUTPUT.PUT_LINE(V_PROGRAM_NAME || ' : A019--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

        /* 트랜잭션 COMMIT */
        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR('ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            V_EVENT_DATE  := SYSTIMESTAMP;
            DBMS_OUTPUT.PUT_LINE('[' || SQLCODE || ']' || SQLERRM);
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);
    END;

    /* 수행결과 성공여부 */
    IF V_LOG_MESSAGE IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('success');
    END IF;

    /* 종료 LOG */
    IF V_LOG_MESSAGE IS NULL THEN
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '@p_division_id : ' || P_DIVISION_ID || ' / ' || '@v_created_by : ' || NVL(V_CREATED_BY, 'NULL');
        V_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);
    END IF;

END;