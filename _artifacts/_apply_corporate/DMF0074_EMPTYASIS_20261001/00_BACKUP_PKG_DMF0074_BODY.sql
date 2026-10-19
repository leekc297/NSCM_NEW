-- SOURCE-FRESH: SCM_MGR.PKG_DMF0074 PACKAGE BODY LAST_DDL=2026-10-01 14:53:27 FETCHED=2026-10-01 16:46 DB=ZIOUI1
CREATE OR REPLACE PACKAGE BODY         "PKG_DMF0074" IS
/****************************************************************************************************/
/* Program ID  : PKG_DMF0074                                                                        */
/* Description : PKG_DMF0074                                                                        */
/* Usage       :                                                                                    */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.04.03  SSLEE        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                          UI 항목으로 Package로 전환                                                 */
/****************************************************************************************************/

PROCEDURE P_DMF0074_GET_METAL_LINK_PRICE
(
    P_DIVISION_ID   IN  VARCHAR2,
    P_DEPT_ID       IN  VARCHAR2,   --Department
    P_END_CUSTOMER  IN  VARCHAR2,   --Endcustomer
    P_SCM_SITE_ID   IN  VARCHAR2,
    P_PLANT_SITE_ID IN  VARCHAR2,
    P_PROJECT_CODE  IN  VARCHAR2,
    P_ITEM_ID       IN  VARCHAR2,
    P_FROM_YYYYMMDD IN  VARCHAR2,
    P_TO_YYYYMMDD   IN  VARCHAR2,
    P_VERSION_TYPE  IN  VARCHAR2,
    P_USER_ID       IN  VARCHAR2,
    P_MENU_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : [DMF0074_GET_METAL_LINK_PRICE]
 * Description  : 메탈링크 화면 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2024.07.12   KJJ     [PJ2024-50244]SCM DM 고객수요관리 고도화 및 개선 - 신규생성
 * 2024.08.29   KJJ     [PJ2024-50461] Team Mapping 로직 변경 - Sales Site Project Model 의 Owner 팀 적용(40번 사업부와 동일. 81, 81_JV, 82 사업부 적용)
 * 2024.10.24   KJJ     [PJ2024-50611]소형 이동계획 확산

 */
IS
    V_GROUP_ID      VARCHAR2(50 CHAR)  := '';
    P_PROGRAM_ID    VARCHAR2(4000 CHAR) := 'DMF0074';

    V_PROGRAM_NAME  VARCHAR2(200 CHAR);
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     NUMBER            := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(20 CHAR);
    V_SQL_ERRMSG    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);

    -- String_Split 결과를 담을 TYPE (LIKE '%xxx%' 검색용)
    TYPE T_LIKE_TAB IS TABLE OF VARCHAR2(4000 CHAR);
    L_PROJECT_LIKE  T_LIKE_TAB;
    L_ITEM_LIKE     T_LIKE_TAB;

BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- GTT 초기화 (이 시점 이전 일반 테이블 DML 없음 → TRUNCATE 사용)
    DELETE FROM SCM_MGR.GT_DM74_TMP_SEARCHED_METAL_LINK_PRICE; /*[E20260818-GTTDEL] DDL 경합 제거*/

    -------------------------------------------------------------------------------------------
    --검색조건을 먼저 처리
    -------------------------------------------------------------------------------------------
    IF UPPER(P_VERSION_TYPE) LIKE '%CURRENT%' THEN
        INSERT INTO SCM_MGR.GT_DM74_TMP_SEARCHED_METAL_LINK_PRICE
        (
            DIVISION_ID, DEPT_ID, FCST_TYPE, SCM_SITE_ID, END_CUSTOMER,
            PROJECT_CODE, PROJECT_NAME, PLANT_SITE_ID, ITEM_ID, METAL_KIND_CODE,
            CURRENCY, METAL_EXCEPTION_YN, METAL_LINK_YN, APPLY_PRICE_TYPE_CODE,
            PLAN_YYYYMM, FROM_PERIOD_YYYYMM, TO_PERIOD_YYYYMM,
            CONTRACT_UNIT_PRICE, METAL_APPLY_UNIT_PRICE, METAL_REQR_QTY, ENERGY
        )
        SELECT
            A.DIVISION_ID
            --[PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용
            --,A.DEPT_ID
          , TEAM.DEPT_ID
            --[PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용
          , A.FCST_TYPE
          , A.SCM_SITE_ID
          , A.END_CUSTOMER
          , A.PROJECT_CODE
          , MP.PROJECT_NAME --[PJ2024-50611] 속도개선을 위한 프로젝트 테이블 조인 변경
          , A.PLANT_SITE_ID
          , A.ITEM_ID
          , A.METAL_KIND_CODE
          , A.CURRENCY
          , A.METAL_EXCEPTION_YN
          , A.METAL_LINK_YN
          , A.APPLY_PRICE_TYPE_CODE
          , A.PLAN_YYYYMM
          , A.FROM_PERIOD_YYYYMM
          , A.TO_PERIOD_YYYYMM
          , A.CONTRACT_UNIT_PRICE
          , A.METAL_APPLY_UNIT_PRICE
          , A.METAL_REQR_QTY
          , NVL(A.ENERGY, 0)
        FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE A
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 start
        /*LEFT JOIN SCM_MST_SSO_DEPT_INFO AS TEAM ...
          LEFT JOIN (SELECT B.DIVISION_ID, ...) AS PJT ... */
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 end
        LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM SITE_ITEM
               ON A.DIVISION_ID = SITE_ITEM.DIVISION_ID
              --[PJ2024-50611] 소형일 경우 END_CUSTOMER로 비교. 나머지는 PROJECT_CODE로 비교
              --AND A.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
              AND CASE WHEN A.DIVISION_ID = '40' THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END = SITE_ITEM.PROJECT_CODE
              --[PJ2024-50611]소형일 경우 END_CUSTOMER로 비교. 나머지는 PROJECT_CODE로 비교
              AND A.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
              AND A.ITEM_ID     = SITE_ITEM.ITEM_ID
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 start
        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN (
            -- [hook#150 2026-09-06 AJS] AS-IS: SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: FROM   SCM_MGR.SCM_MST_SSO_USER_INFO  B
            -- [hook#150 2026-09-06 AJS] AS-IS: INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
        -- [hook#150 2026-09-06 AJS] AS-IS: ) TEAM
               -- [hook#150 2026-09-06 AJS] AS-IS: ON TEAM.USER_ID = TRIM(CASE WHEN INSTR(SITE_ITEM.OWNER, ',') > 0
                                           -- [hook#150 2026-09-06 AJS] AS-IS: THEN SUBSTR(SITE_ITEM.OWNER, 1, INSTR(SITE_ITEM.OWNER, ',') - 1)
                                           -- [hook#150 2026-09-06 AJS] AS-IS: ELSE SITE_ITEM.OWNER END)
        -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
               ON TEAM.DEPT_ID = SITE_ITEM.DEPT_ID
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 end
        INNER JOIN (
            -- INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) b1
            SELECT '%' || TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) || '%' AS TST
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
        ) B1 ON CASE WHEN P_PROJECT_CODE = '' THEN P_PROJECT_CODE ELSE A.PROJECT_CODE END LIKE B1.TST
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 start
        /*OR CASE WHEN P_PROJECT_CODE = '' THEN P_PROJECT_CODE ELSE PJT.PROJECT_NAME END like B1.tst */
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 end
        INNER JOIN (
            SELECT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
        ) B2 ON CASE WHEN P_ITEM_ID = '' THEN P_ITEM_ID ELSE A.ITEM_ID END LIKE B2.TST
        -- [PJ2024-50461] Project Master join 추가 start
        LEFT JOIN SCM_MGR.SCM_MST_PROJECT MP
               ON A.DIVISION_ID = MP.DIVISION_ID
              AND CASE WHEN A.DIVISION_ID = '40' THEN '' ELSE A.PROJECT_CODE END = MP.PROJECT_CODE
        -- [PJ2024-50461] Project Master join 추가 END
        WHERE A.DIVISION_ID = P_DIVISION_ID
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 start
        /* AND CASE WHEN @p_dept_id = 'ALL' ... PJT.DEPT_ID ... END IN (...) */
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 end
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 start
        AND (P_DEPT_ID = 'ALL'
             OR TEAM.DEPT_ID IN (
                 SELECT TRIM(REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL))
                 FROM DUAL CONNECT BY REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL) IS NOT NULL
             ))
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 end
        AND (P_END_CUSTOMER = 'ALL'
             OR NVL(CASE WHEN P_DIVISION_ID <> '40' THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END, '') IN (
                 SELECT TRIM(REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL))
                 FROM DUAL CONNECT BY REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL) IS NOT NULL
             ))
        AND (P_SCM_SITE_ID = 'ALL'
             OR A.SCM_SITE_ID IN (
                 SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL))
                 FROM DUAL CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
             ))
        AND (P_PLANT_SITE_ID = 'ALL'
             OR A.PLANT_SITE_ID IN (
                 SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID, '[^,]+', 1, LEVEL))
                 FROM DUAL CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
             ))
        AND A.PLAN_YYYYMM >= P_FROM_YYYYMMDD
        AND A.PLAN_YYYYMM <= P_TO_YYYYMMDD;

    ELSE
        INSERT INTO SCM_MGR.GT_DM74_TMP_SEARCHED_METAL_LINK_PRICE
        (
            DIVISION_ID, DEPT_ID, FCST_TYPE, SCM_SITE_ID, END_CUSTOMER,
            PROJECT_CODE, PROJECT_NAME, PLANT_SITE_ID, ITEM_ID, METAL_KIND_CODE,
            CURRENCY, METAL_EXCEPTION_YN, METAL_LINK_YN, APPLY_PRICE_TYPE_CODE,
            PLAN_YYYYMM, FROM_PERIOD_YYYYMM, TO_PERIOD_YYYYMM,
            CONTRACT_UNIT_PRICE, METAL_APPLY_UNIT_PRICE, METAL_REQR_QTY, ENERGY
        )
        SELECT /*+ FULL(A) PARALLEL(4) */
            A.DIVISION_ID
            --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인
            --,A.DEPT_ID
          , TEAM.DEPT_ID
            --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인
          , A.FCST_TYPE
          , A.SCM_SITE_ID
          , A.END_CUSTOMER
          , A.PROJECT_CODE
          , MP.PROJECT_NAME --[PJ2024-50611] 속도개선을 위한 프로젝트 테이블 조인 변경
          , A.PLANT_SITE_ID
          , A.ITEM_ID
          , A.METAL_KIND_CODE
          , A.CURRENCY
          , A.METAL_EXCEPTION_YN
          , A.METAL_LINK_YN
          , A.APPLY_PRICE_TYPE_CODE
          , A.PLAN_YYYYMM
          , A.FROM_PERIOD_YYYYMM
          , A.TO_PERIOD_YYYYMM
          , A.CONTRACT_UNIT_PRICE
          , A.METAL_APPLY_UNIT_PRICE
          , A.METAL_REQR_QTY
          , NVL(A.ENERGY, 0)
        FROM SCM_MGR.DM_BPS_METAL_LINK_PRICE_C A
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 start
        /* LEFT JOIN ...(주석 처리된 PJT 서브쿼리 생략) */
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 end
        LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM SITE_ITEM
               ON A.DIVISION_ID = SITE_ITEM.DIVISION_ID
              --[PJ2024-50611]소형일 경우 END_CUSTOMER로 비교. 나머지는 PROJECT_CODE로 비교
              --AND A.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
              AND CASE WHEN A.DIVISION_ID = '40' THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END = SITE_ITEM.PROJECT_CODE
              --[PJ2024-50611]소형일 경우 END_CUSTOMER로 비교. 나머지는 PROJECT_CODE로 비교
              AND A.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
              AND A.ITEM_ID     = SITE_ITEM.ITEM_ID
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 start
        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN (
            -- [hook#150 2026-09-06 AJS] AS-IS: SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: FROM   SCM_MGR.SCM_MST_SSO_USER_INFO  B
            -- [hook#150 2026-09-06 AJS] AS-IS: INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
        -- [hook#150 2026-09-06 AJS] AS-IS: ) TEAM
               -- [hook#150 2026-09-06 AJS] AS-IS: ON TEAM.USER_ID = TRIM(CASE WHEN INSTR(SITE_ITEM.OWNER, ',') > 0
                                           -- [hook#150 2026-09-06 AJS] AS-IS: THEN SUBSTR(SITE_ITEM.OWNER, 1, INSTR(SITE_ITEM.OWNER, ',') - 1)
                                           -- [hook#150 2026-09-06 AJS] AS-IS: ELSE SITE_ITEM.OWNER END)
        -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
               ON TEAM.DEPT_ID = SITE_ITEM.DEPT_ID
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 end
        INNER JOIN (
            SELECT '%' || TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) || '%' AS TST
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
        ) B1 ON CASE WHEN P_PROJECT_CODE = '' THEN P_PROJECT_CODE ELSE A.PROJECT_CODE END LIKE B1.TST
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 start
        /*OR CASE WHEN P_PROJECT_CODE = '' THEN P_PROJECT_CODE ELSE PJT.PROJECT_NAME END like B1.tst */
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 end
        INNER JOIN (
            SELECT '%' || TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL)) || '%' AS TST
            FROM DUAL
            CONNECT BY REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
        ) B2 ON CASE WHEN P_ITEM_ID = '' THEN P_ITEM_ID ELSE A.ITEM_ID END LIKE B2.TST
        -- [PJ2024-50461] Project Master join 추가 start
        LEFT JOIN SCM_MGR.SCM_MST_PROJECT MP
               ON A.DIVISION_ID = MP.DIVISION_ID
              AND CASE WHEN A.DIVISION_ID = '40' THEN '' ELSE A.PROJECT_CODE END = MP.PROJECT_CODE
        -- [PJ2024-50461] Project Master join 추가 END
        WHERE A.DIVISION_ID = P_DIVISION_ID
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 start
        /* AND CASE WHEN @p_dept_id = 'ALL' ... PJT.DEPT_ID ... END IN (...) */
        --[PJ2024-50461] Team Mapping: 40번 사업부 외 적용하던 로직 제거 end
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 start
        AND (P_DEPT_ID = 'ALL'
             OR TEAM.DEPT_ID IN (
                 SELECT TRIM(REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL))
                 FROM DUAL CONNECT BY REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL) IS NOT NULL
             ))
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 end
        AND (P_END_CUSTOMER = 'ALL'
             OR NVL(CASE WHEN P_DIVISION_ID <> '40' THEN A.END_CUSTOMER ELSE A.PROJECT_CODE END, '') IN (
                 SELECT TRIM(REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL))
                 FROM DUAL CONNECT BY REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL) IS NOT NULL
             ))
        AND (P_SCM_SITE_ID = 'ALL'
             OR A.SCM_SITE_ID IN (
                 SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL))
                 FROM DUAL CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
             ))
        AND (P_PLANT_SITE_ID = 'ALL'
             OR A.PLANT_SITE_ID IN (
                 SELECT TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID, '[^,]+', 1, LEVEL))
                 FROM DUAL CONNECT BY REGEXP_SUBSTR(P_PLANT_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
             ))
        AND A.PLAN_YYYYMM >= P_FROM_YYYYMMDD
        AND A.PLAN_YYYYMM <= P_TO_YYYYMMDD
        -- LEFT() + CHARINDEX() → SUBSTR() + INSTR() 로 변환
        AND A.VERSION_NO IN (
            SELECT TRIM(
                       SUBSTR(TOKEN,
                              1,
                              CASE WHEN INSTR(TOKEN, '(') = 0 THEN LENGTH(TOKEN)
                                   ELSE INSTR(TOKEN, '(') - 1
                              END)
                   ) AS VER
            FROM (
                SELECT TRIM(REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL)) AS TOKEN
                FROM DUAL
                CONNECT BY REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
            )
        );
    END IF;

    -------------------------------------------------------------------------------------------------------------
    --검색처리된 데이터셋 완료
    -------------------------------------------------------------------------------------------------------------

    /*******************************************************************************************************************
    합치기
    : MSSQL 임시테이블 6개 PIVOT (#TMP_APPLY_PRICE_TYPE / #TMP_FROM_PERIOD / #TMP_TO_PERIOD /
      #TMP_CONTRACT_UNIT / #TMP_METAL_APPLY / #TMP_METAL_REQR) + #TEMP_METAL_KEY_VALUE
      → Oracle CTE + CASE/MAX 패턴으로 통합
    **********************************************************************************************************************/
    OPEN O_RC1 FOR
    WITH
    -- 룩업테이블의 METAL_KEY_VALUE 조회
    TEMP_METAL_KEY_VALUE AS (
        SELECT /*+ RESULT_CACHE */
            SEGMENT1  -- DIVISION_ID
          , SEGMENT2  -- 광물 종류 (Ni / Co / Li2Co3 / LIOH / Al / Mn / Cu)
          , SEGMENT3  -- METAL_KEY_CODE
          , SEGMENT4  -- METAL_KEY_NAME
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE LOOKUP_TYPE = 'METAL_KEY_VALUE'
          AND VALID_YN    = 'Y'
    ),
    -- 6개 PIVOT 임시테이블을 단일 CASE/MAX CTE로 통합
    PIVOT_BASE AS (
        SELECT
            DIVISION_ID, PLAN_YYYYMM, DEPT_ID, END_CUSTOMER, PROJECT_CODE,
            PROJECT_NAME, --[PJ2024-50611] 속도개선을 위한 프로젝트 테이블 조인 변경
            PLANT_SITE_ID, ITEM_ID, METAL_LINK_YN, SCM_SITE_ID, CURRENCY,
            FCST_TYPE, METAL_EXCEPTION_YN, ENERGY,
            --APPLY_PRICE_TYPE 처리 : 기본 데이터셋에서 APPLY_PRICE_TYPE 추출하여 PIVOT 데이터셋 생성
            MAX(CASE WHEN METAL_KIND_CODE = 'Ni'     THEN APPLY_PRICE_TYPE_CODE  END) AS APPLY_PRICE_TYPE_CODE1,
            MAX(CASE WHEN METAL_KIND_CODE = 'Co'     THEN APPLY_PRICE_TYPE_CODE  END) AS APPLY_PRICE_TYPE_CODE2,
            MAX(CASE WHEN METAL_KIND_CODE = 'Li2CO3' THEN APPLY_PRICE_TYPE_CODE  END) AS APPLY_PRICE_TYPE_CODE3,
            MAX(CASE WHEN METAL_KIND_CODE = 'LIOH'   THEN APPLY_PRICE_TYPE_CODE  END) AS APPLY_PRICE_TYPE_CODE4,
            MAX(CASE WHEN METAL_KIND_CODE = 'Al'     THEN APPLY_PRICE_TYPE_CODE  END) AS APPLY_PRICE_TYPE_CODE5,
            MAX(CASE WHEN METAL_KIND_CODE = 'Mn'     THEN APPLY_PRICE_TYPE_CODE  END) AS APPLY_PRICE_TYPE_CODE6,
            MAX(CASE WHEN METAL_KIND_CODE = 'Cu'     THEN APPLY_PRICE_TYPE_CODE  END) AS APPLY_PRICE_TYPE_CODE7,
            --FROM_PERIOD 처리 : 기본 데이터셋에서 FROM_PERIOD_YYYYMM 추출하여 PIVOT 데이터셋 생성
            MAX(CASE WHEN METAL_KIND_CODE = 'Ni'     THEN FROM_PERIOD_YYYYMM     END) AS FROM_PERIOD1,
            MAX(CASE WHEN METAL_KIND_CODE = 'Co'     THEN FROM_PERIOD_YYYYMM     END) AS FROM_PERIOD2,
            MAX(CASE WHEN METAL_KIND_CODE = 'Li2CO3' THEN FROM_PERIOD_YYYYMM     END) AS FROM_PERIOD3,
            MAX(CASE WHEN METAL_KIND_CODE = 'LIOH'   THEN FROM_PERIOD_YYYYMM     END) AS FROM_PERIOD4,
            MAX(CASE WHEN METAL_KIND_CODE = 'Al'     THEN FROM_PERIOD_YYYYMM     END) AS FROM_PERIOD5,
            MAX(CASE WHEN METAL_KIND_CODE = 'Mn'     THEN FROM_PERIOD_YYYYMM     END) AS FROM_PERIOD6,
            MAX(CASE WHEN METAL_KIND_CODE = 'Cu'     THEN FROM_PERIOD_YYYYMM     END) AS FROM_PERIOD7,
            --TO_PERIOD 처리 : 기본 데이터셋에서 TO_PERIOD_YYYYMM 추출하여 PIVOT 데이터셋 생성
            MAX(CASE WHEN METAL_KIND_CODE = 'Ni'     THEN TO_PERIOD_YYYYMM       END) AS TO_PERIOD1,
            MAX(CASE WHEN METAL_KIND_CODE = 'Co'     THEN TO_PERIOD_YYYYMM       END) AS TO_PERIOD2,
            MAX(CASE WHEN METAL_KIND_CODE = 'Li2CO3' THEN TO_PERIOD_YYYYMM       END) AS TO_PERIOD3,
            MAX(CASE WHEN METAL_KIND_CODE = 'LIOH'   THEN TO_PERIOD_YYYYMM       END) AS TO_PERIOD4,
            MAX(CASE WHEN METAL_KIND_CODE = 'Al'     THEN TO_PERIOD_YYYYMM       END) AS TO_PERIOD5,
            MAX(CASE WHEN METAL_KIND_CODE = 'Mn'     THEN TO_PERIOD_YYYYMM       END) AS TO_PERIOD6,
            MAX(CASE WHEN METAL_KIND_CODE = 'Cu'     THEN TO_PERIOD_YYYYMM       END) AS TO_PERIOD7,
            --CONTRACT_UNIT 처리 : 기본 데이터셋에서 CONTRACT_UNIT_PRICE 추출하여 PIVOT 데이터셋 생성
            MAX(CASE WHEN METAL_KIND_CODE = 'Ni'     THEN CONTRACT_UNIT_PRICE    END) AS CONTRACT_UNIT1,
            MAX(CASE WHEN METAL_KIND_CODE = 'Co'     THEN CONTRACT_UNIT_PRICE    END) AS CONTRACT_UNIT2,
            MAX(CASE WHEN METAL_KIND_CODE = 'Li2CO3' THEN CONTRACT_UNIT_PRICE    END) AS CONTRACT_UNIT3,
            MAX(CASE WHEN METAL_KIND_CODE = 'LIOH'   THEN CONTRACT_UNIT_PRICE    END) AS CONTRACT_UNIT4,
            MAX(CASE WHEN METAL_KIND_CODE = 'Al'     THEN CONTRACT_UNIT_PRICE    END) AS CONTRACT_UNIT5,
            MAX(CASE WHEN METAL_KIND_CODE = 'Mn'     THEN CONTRACT_UNIT_PRICE    END) AS CONTRACT_UNIT6,
            MAX(CASE WHEN METAL_KIND_CODE = 'Cu'     THEN CONTRACT_UNIT_PRICE    END) AS CONTRACT_UNIT7,
            --METAL_APPLY 처리 : 기본 데이터셋에서 METAL_APPLY_UNIT_PRICE 추출하여 PIVOT 데이터셋 생성
            MAX(CASE WHEN METAL_KIND_CODE = 'Ni'     THEN METAL_APPLY_UNIT_PRICE END) AS METAL_APPLY1,
            MAX(CASE WHEN METAL_KIND_CODE = 'Co'     THEN METAL_APPLY_UNIT_PRICE END) AS METAL_APPLY2,
            MAX(CASE WHEN METAL_KIND_CODE = 'Li2CO3' THEN METAL_APPLY_UNIT_PRICE END) AS METAL_APPLY3,
            MAX(CASE WHEN METAL_KIND_CODE = 'LIOH'   THEN METAL_APPLY_UNIT_PRICE END) AS METAL_APPLY4,
            MAX(CASE WHEN METAL_KIND_CODE = 'Al'     THEN METAL_APPLY_UNIT_PRICE END) AS METAL_APPLY5,
            MAX(CASE WHEN METAL_KIND_CODE = 'Mn'     THEN METAL_APPLY_UNIT_PRICE END) AS METAL_APPLY6,
            MAX(CASE WHEN METAL_KIND_CODE = 'Cu'     THEN METAL_APPLY_UNIT_PRICE END) AS METAL_APPLY7,
            --METAL_REQR 처리 : 기본 데이터셋에서 METAL_REQR_QTY 추출하여 PIVOT 데이터셋 생성
            MAX(CASE WHEN METAL_KIND_CODE = 'Ni'     THEN METAL_REQR_QTY         END) AS METAL_REQR1,
            MAX(CASE WHEN METAL_KIND_CODE = 'Co'     THEN METAL_REQR_QTY         END) AS METAL_REQR2,
            MAX(CASE WHEN METAL_KIND_CODE = 'Li2CO3' THEN METAL_REQR_QTY         END) AS METAL_REQR3,
            MAX(CASE WHEN METAL_KIND_CODE = 'LIOH'   THEN METAL_REQR_QTY         END) AS METAL_REQR4,
            MAX(CASE WHEN METAL_KIND_CODE = 'Al'     THEN METAL_REQR_QTY         END) AS METAL_REQR5,
            MAX(CASE WHEN METAL_KIND_CODE = 'Mn'     THEN METAL_REQR_QTY         END) AS METAL_REQR6,
            MAX(CASE WHEN METAL_KIND_CODE = 'Cu'     THEN METAL_REQR_QTY         END) AS METAL_REQR7
        FROM SCM_MGR.GT_DM74_TMP_SEARCHED_METAL_LINK_PRICE
        GROUP BY
            DIVISION_ID, PLAN_YYYYMM, DEPT_ID, END_CUSTOMER, PROJECT_CODE,
            PROJECT_NAME, PLANT_SITE_ID, ITEM_ID, METAL_LINK_YN, SCM_SITE_ID,
            CURRENCY, FCST_TYPE, METAL_EXCEPTION_YN, ENERGY
    )
    SELECT
        APPLY_PRICE_TYPE.DIVISION_ID
      , APPLY_PRICE_TYPE.PLAN_YYYYMM
      , APPLY_PRICE_TYPE.DEPT_ID
      , DI.DEPT_NAME_KO                                          AS DEPT_NAME
      , APPLY_PRICE_TYPE.END_CUSTOMER
      , APPLY_PRICE_TYPE.PROJECT_CODE
      , APPLY_PRICE_TYPE.PROJECT_NAME
      , APPLY_PRICE_TYPE.PLANT_SITE_ID
      , APPLY_PRICE_TYPE.ITEM_ID
      , APPLY_PRICE_TYPE.METAL_LINK_YN
      , APPLY_PRICE_TYPE.SCM_SITE_ID
      , APPLY_PRICE_TYPE.CURRENCY
      , APPLY_PRICE_TYPE.FCST_TYPE                              AS FCST_TYPE_CODE
      , LUP.SEGMENT2                                            AS FCST_TYPE
      , APPLY_PRICE_TYPE.METAL_EXCEPTION_YN
      , CAST(APPLY_PRICE_TYPE.ENERGY          AS NUMBER(30, 2)) AS ENERGY
      , METAL_KEY_NI.SEGMENT4                                   AS APPLY_PRICE_TYPE_CODE1
      , METAL_KEY_CO.SEGMENT4                                   AS APPLY_PRICE_TYPE_CODE2
      , METAL_KEY_LI2CO3.SEGMENT4                               AS APPLY_PRICE_TYPE_CODE3
      , METAL_KEY_LIOH.SEGMENT4                                 AS APPLY_PRICE_TYPE_CODE4
      , METAL_KEY_AL.SEGMENT4                                   AS APPLY_PRICE_TYPE_CODE5
      , METAL_KEY_MN.SEGMENT4                                   AS APPLY_PRICE_TYPE_CODE6
      , METAL_KEY_CU.SEGMENT4                                   AS APPLY_PRICE_TYPE_CODE7
      , APPLY_PRICE_TYPE.FROM_PERIOD1
      , APPLY_PRICE_TYPE.FROM_PERIOD2
      , APPLY_PRICE_TYPE.FROM_PERIOD3
      , APPLY_PRICE_TYPE.FROM_PERIOD4
      , APPLY_PRICE_TYPE.FROM_PERIOD5
      , APPLY_PRICE_TYPE.FROM_PERIOD6
      , APPLY_PRICE_TYPE.FROM_PERIOD7
      , APPLY_PRICE_TYPE.TO_PERIOD1
      , APPLY_PRICE_TYPE.TO_PERIOD2
      , APPLY_PRICE_TYPE.TO_PERIOD3
      , APPLY_PRICE_TYPE.TO_PERIOD4
      , APPLY_PRICE_TYPE.TO_PERIOD5
      , APPLY_PRICE_TYPE.TO_PERIOD6
      , APPLY_PRICE_TYPE.TO_PERIOD7
      , CAST(APPLY_PRICE_TYPE.CONTRACT_UNIT1  AS NUMBER(30, 2)) AS CONTRACT_UNIT1
      , CAST(APPLY_PRICE_TYPE.CONTRACT_UNIT2  AS NUMBER(30, 2)) AS CONTRACT_UNIT2
      , CAST(APPLY_PRICE_TYPE.CONTRACT_UNIT3  AS NUMBER(30, 2)) AS CONTRACT_UNIT3
      , CAST(APPLY_PRICE_TYPE.CONTRACT_UNIT4  AS NUMBER(30, 2)) AS CONTRACT_UNIT4
      , CAST(APPLY_PRICE_TYPE.CONTRACT_UNIT5  AS NUMBER(30, 2)) AS CONTRACT_UNIT5
      , CAST(APPLY_PRICE_TYPE.CONTRACT_UNIT6  AS NUMBER(30, 2)) AS CONTRACT_UNIT6
      , CAST(APPLY_PRICE_TYPE.CONTRACT_UNIT7  AS NUMBER(30, 2)) AS CONTRACT_UNIT7
      , CAST(APPLY_PRICE_TYPE.METAL_APPLY1    AS NUMBER(30, 2)) AS METAL_APPLY1
      , CAST(APPLY_PRICE_TYPE.METAL_APPLY2    AS NUMBER(30, 2)) AS METAL_APPLY2
      , CAST(APPLY_PRICE_TYPE.METAL_APPLY3    AS NUMBER(30, 2)) AS METAL_APPLY3
      , CAST(APPLY_PRICE_TYPE.METAL_APPLY4    AS NUMBER(30, 2)) AS METAL_APPLY4
      , CAST(APPLY_PRICE_TYPE.METAL_APPLY5    AS NUMBER(30, 2)) AS METAL_APPLY5
      , CAST(APPLY_PRICE_TYPE.METAL_APPLY6    AS NUMBER(30, 2)) AS METAL_APPLY6
      , CAST(APPLY_PRICE_TYPE.METAL_APPLY7    AS NUMBER(30, 2)) AS METAL_APPLY7
      , CAST(APPLY_PRICE_TYPE.METAL_REQR1     AS NUMBER(30, 2)) AS METAL_REQR1
      , CAST(APPLY_PRICE_TYPE.METAL_REQR2     AS NUMBER(30, 2)) AS METAL_REQR2
      , CAST(APPLY_PRICE_TYPE.METAL_REQR3     AS NUMBER(30, 2)) AS METAL_REQR3
      , CAST(APPLY_PRICE_TYPE.METAL_REQR4     AS NUMBER(30, 2)) AS METAL_REQR4
      , CAST(APPLY_PRICE_TYPE.METAL_REQR5     AS NUMBER(30, 2)) AS METAL_REQR5
      , CAST(APPLY_PRICE_TYPE.METAL_REQR6     AS NUMBER(30, 2)) AS METAL_REQR6
      , CAST(APPLY_PRICE_TYPE.METAL_REQR7     AS NUMBER(30, 2)) AS METAL_REQR7
      , EDY.EDIT_YN
    FROM PIVOT_BASE APPLY_PRICE_TYPE
    INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
         ON EDY.USER_ID = P_USER_ID
        AND EDY.MNU_ID  = P_MENU_ID
        AND EDY.UNIT_ID = APPLY_PRICE_TYPE.DIVISION_ID
    INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO DI
           ON DI.DEPT_ID = APPLY_PRICE_TYPE.DEPT_ID
    INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
           ON LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
          AND LUP.VALID_YN    = 'Y'
          AND LUP.SEGMENT4   <> 'FREE' ----FCST_TYPE_NOT_FREE
          AND LUP.SEGMENT1    = APPLY_PRICE_TYPE.FCST_TYPE
    LEFT OUTER JOIN TEMP_METAL_KEY_VALUE METAL_KEY_NI
           ON METAL_KEY_NI.SEGMENT1 = SUBSTR(APPLY_PRICE_TYPE.DIVISION_ID, 1, 2)
          AND METAL_KEY_NI.SEGMENT2 = 'Ni'
          AND METAL_KEY_NI.SEGMENT3 = APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE1
    LEFT OUTER JOIN TEMP_METAL_KEY_VALUE METAL_KEY_CO
           ON METAL_KEY_CO.SEGMENT1 = SUBSTR(APPLY_PRICE_TYPE.DIVISION_ID, 1, 2)
          AND METAL_KEY_CO.SEGMENT2 = 'Co'
          AND METAL_KEY_CO.SEGMENT3 = APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE2
    LEFT OUTER JOIN TEMP_METAL_KEY_VALUE METAL_KEY_LI2CO3
           ON METAL_KEY_LI2CO3.SEGMENT1 = SUBSTR(APPLY_PRICE_TYPE.DIVISION_ID, 1, 2)
          AND METAL_KEY_LI2CO3.SEGMENT2 = 'Li2Co3'
          AND METAL_KEY_LI2CO3.SEGMENT3 = APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE3
    LEFT OUTER JOIN TEMP_METAL_KEY_VALUE METAL_KEY_LIOH
           ON METAL_KEY_LIOH.SEGMENT1 = SUBSTR(APPLY_PRICE_TYPE.DIVISION_ID, 1, 2)
          AND METAL_KEY_LIOH.SEGMENT2 = 'LIOH'
          AND METAL_KEY_LIOH.SEGMENT3 = APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE4
    LEFT OUTER JOIN TEMP_METAL_KEY_VALUE METAL_KEY_AL
           ON METAL_KEY_AL.SEGMENT1 = SUBSTR(APPLY_PRICE_TYPE.DIVISION_ID, 1, 2)
          AND METAL_KEY_AL.SEGMENT2 = 'Al'
          AND METAL_KEY_AL.SEGMENT3 = APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE5
    LEFT OUTER JOIN TEMP_METAL_KEY_VALUE METAL_KEY_MN
           ON METAL_KEY_MN.SEGMENT1 = SUBSTR(APPLY_PRICE_TYPE.DIVISION_ID, 1, 2)
          AND METAL_KEY_MN.SEGMENT2 = 'Mn'
          AND METAL_KEY_MN.SEGMENT3 = APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE6
    LEFT OUTER JOIN TEMP_METAL_KEY_VALUE METAL_KEY_CU
           ON METAL_KEY_CU.SEGMENT1 = SUBSTR(APPLY_PRICE_TYPE.DIVISION_ID, 1, 2)
          AND METAL_KEY_CU.SEGMENT2 = 'Cu'
          AND METAL_KEY_CU.SEGMENT3 = APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE7;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'   VALUE P_DIVISION_ID,
            'P_DEPT_ID'       VALUE P_DEPT_ID,
            'P_END_CUSTOMER'  VALUE P_END_CUSTOMER,
            'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
            'P_PLANT_SITE_ID' VALUE P_PLANT_SITE_ID,
            'P_PROJECT_CODE'  VALUE P_PROJECT_CODE,
            'P_ITEM_ID'       VALUE P_ITEM_ID,
            'P_FROM_YYYYMMDD' VALUE P_FROM_YYYYMMDD,
            'P_TO_YYYYMMDD'   VALUE P_TO_YYYYMMDD,
            'P_VERSION_TYPE'  VALUE P_VERSION_TYPE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM='    || V_SQL_ERRMSG  ||
            ' / BACKTRACE='  || V_BACKTRACE   ||
            ' / PARAMS='     || V_PROC_INPUT
        );
END P_DMF0074_GET_METAL_LINK_PRICE;


PROCEDURE P_DMF0074_GET_METAL_LINK_TEMPLATE
(
    P_DIVISION_ID   IN  VARCHAR2,
    P_USER_ID       IN  VARCHAR2,
    P_MENU_ID       IN  VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*===================================================================================================
 * Program ID  : [DMF0074_GET_METAL_LINK_TEMPLATE]
 * Description  : 각 사업부 별 업로드에 맞는 템플릿 데이터 조회

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2024.07.17   KJJ     [PJ2024-50244]SCM DM 고객수요관리 고도화 및 개선 - 최초 작성
 2024.09.18   KJJ     [PJ2024-50461] Team Mapping 로직 변경 - Sales Site Project Model 의 Owner 팀 적용(40번 사업부와 동일. 81, 81_JV, 82 사업부 적용)
 2024.10.02   KJJ     [PJ2024-50461] 기능개선-  업로드 대상은 '제품(P)'만 해당
 2024.10.04   KJJ     [PJ2024-50461] 기능개선-  당주가 아니라 최신의 버전으로 처리함
 2024.10.15   KJJ     [PJ2024-50461] 기능개선-  업로드 대상 로직 수정
 2024.10.23   KJJ     [PJ2024-50611] 소형 이동계획 확산

--EXEC DMF0074_GET_METAL_LINK_TEMPLATE '82'
 ===================================================================================================*/
IS
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);
    V_LOG_TYPE      VARCHAR2(30  CHAR);
    N_LOG_COUNT     NUMBER           := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500  CHAR);
    D_EVENT_DATE    DATE;
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(20   CHAR);
    V_SQL_ERRMSG    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- #TEMP_VERSION_NO, #rtntmp → CTE(WITH절) 로 변환 (일회성 소규모 임시테이블)
    OPEN O_RC1 FOR
    WITH TEMP_VERSION_NO AS (
        --[PJ2024-50461]DIV별 최신 버전
        SELECT
            --[PJ2024-50461]조회시 * 가져오지 말고 구체적 필드 표시START
            A.DIVISION_ID
          , A.VERSION_NO
          , A.YYYYMMDD
            --[PJ2024-50461]조회시 * 가져오지 말고 구체적 필드 표시END
          , B.BASIS_YYYYMM AS YYYYMM
            --[PJ2024-50461]날짜조작 데이터 변수로 처리 START
            --[E20260825-DATECONV] FN_NEXT_DAY 파라미터는 DATE — VARCHAR2 암묵 변환은 세션 NLS_DATE_FORMAT 의존
            --  (클라우드 BE 'DD-MON-RR' 세션에서 ORA-01861 — 명시 TO_DATE 선행. 동일 PKG L1022~1026 기적용 패턴)
          , CASE WHEN B.BASIS_YYYYMM > TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMM')
                 THEN TO_CHAR(ADD_MONTHS(TO_DATE(B.BASIS_YYYYMM || '01', 'YYYYMMDD'), -1), 'YYYYMMDD')
                 ELSE B.BASIS_YYYYMM || '01'
            END AS RESULT_FROM
          , TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')       AS RESULT_TO  --[E20260825-DATECONV]
          , TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'MON') - 7 + (52 * 7) - 1, 'YYYYMMDD') AS PLAN_TO  --[E20260825-DATECONV]
            --[PJ2024-50611]날짜조작 데이터 변수로 처리 END
        FROM (
            SELECT DIVISION_ID, MAX(VERSION_NO) AS VERSION_NO, MAX(YYYYMMDD) AS YYYYMMDD
            FROM   SCM_MGR.DM_MST_VERSION
            WHERE  DIVISION_ID  = P_DIVISION_ID
            AND    VERSION_TYPE = 'SP_W'
            --[MRFPARITY 2026-08-18] AS-IS 파리티 복원 — 변환 원본에서 이 줄은 **주석**이다
            --  (To-be_v2_converted/06_Packages/04_Package_PKG_DMF0074.sql:688 `--AND NVL(ATTRIBUTE7,'') = 'Y'`).
            --  활성화하면 금주 SP_W 는 전 division ATTRIBUTE7=NULL 이라 과거 MRF='Y' 버전으로 밀리고,
            --  81/82 는 그 버전의 원장이 0행이라 템플릿 0건 → MSG00656 안내가 뜬다(사용자 신고).
            --  형제 화면 PKG_DMF0020 L2697 도 동일하게 주석 유지. UPLOAD 쪽 적재 조건은 원본대로 활성 유지.
            --AND    NVL(ATTRIBUTE7, 'N') = 'Y'
            GROUP BY DIVISION_ID
        ) A
        INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B
               ON B.BASIS_YYYYMMDD = A.YYYYMMDD
    ),
    BASE_DATA AS (
        SELECT
            SP.DIVISION_ID
            --[PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용
            --,MS.DEPT_ID
            --, DI.DEPT_NAME_KO
          , TEAM.DEPT_ID
          , TEAM.DEPT_NAME_KO
            --[PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용
          , CASE WHEN SP.DIVISION_ID = '40' THEN SP.PROJECT_CODE ELSE MS.END_CUSTOMER END AS END_CUSTOMER --[PJ2024-50611]소형일 경우 PROJECT_CODE로 비교. 나머지는 END_CUSTOMER로 비교
          , MP.PROJECT_CODE
          , MP.PROJECT_NAME
          , SP.ITEM_ID
          , SP.SCM_SITE_ID
          , CASE WHEN NVL(SP.CURRENCY, '@#@#@#') = '@#@#@#' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY --CURRENCY가 없을 경우 SSPM의 값을 가져옴
          , LUP.SEGMENT2 AS FCST_TYPE
        FROM SCM_MGR.DM_PLN_SALES_PLAN_C SP
        INNER JOIN SCM_MGR.SCM_MST_SITE MS
               ON MS.DIVISION_ID = SP.DIVISION_ID
              AND MS.SCM_SITE_ID = SP.SCM_SITE_ID
              AND MS.VALID_YN    = 'Y'
        INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
               ON LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
              AND LUP.VALID_YN    = 'Y'
              AND LUP.SEGMENT4   <> 'FREE' ----FCST_TYPE_NOT_FREE
              AND LUP.SEGMENT1    = SP.FCST_TYPE
        INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
               ON SI.DIVISION_ID  = SP.DIVISION_ID
              AND SI.PROJECT_CODE = SP.PROJECT_CODE
              AND SI.SCM_SITE_ID  = SP.SCM_SITE_ID
              AND SI.ITEM_ID      = SP.ITEM_ID
              AND SI.VALID_YN     = 'Y'
        --[PJ2024-50461]업로드 대상은 '제품(P)'만 해당START
        INNER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V SV
               ON SV.DIVISION_ID = SI.DIVISION_ID
              AND SV.ITEM_ID     = SI.ITEM_ID
              AND SV.ITEM_TYPE   = 'P' --'제품(P)'만 해당
        --[PJ2024-50461]업로드 대상은 '제품(P)'만 해당END
        --[PJ2024-50461]DIV별 최신버전 START
        INNER JOIN TEMP_VERSION_NO T_VER
               ON SP.DIVISION_ID = T_VER.DIVISION_ID
              AND SP.VERSION_NO  = T_VER.VERSION_NO
        --[PJ2024-50461]DIV별 최신버전 END
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 START
        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN (
            -- [hook#150 2026-09-06 AJS] AS-IS: SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: FROM   SCM_MGR.SCM_MST_SSO_USER_INFO  B
            -- [hook#150 2026-09-06 AJS] AS-IS: INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
        -- [hook#150 2026-09-06 AJS] AS-IS: ) TEAM
               -- [hook#150 2026-09-06 AJS] AS-IS: ON TEAM.USER_ID = TRIM(CASE WHEN INSTR(SI.OWNER, ',') > 0
                                           -- [hook#150 2026-09-06 AJS] AS-IS: THEN SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1)
                                           -- [hook#150 2026-09-06 AJS] AS-IS: ELSE SI.OWNER END)
        -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
               ON TEAM.DEPT_ID = SI.DEPT_ID
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 END
        LEFT JOIN SCM_MGR.SCM_MST_PROJECT MP
               ON SP.DIVISION_ID = MP.DIVISION_ID
              AND CASE WHEN SP.DIVISION_ID = '40' THEN '' ELSE SP.PROJECT_CODE END = MP.PROJECT_CODE --[PJ2024-50611] 소형사업부는 PROJECT_CODE가 없으므로 빈값으로 조인
        INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP2 ----등록된 END CUSTOMER만 처리
               ON SP.DIVISION_ID  = LUP2.SEGMENT1
              AND LUP2.LOOKUP_TYPE = 'END_CUSTOMER'
              AND CASE WHEN SP.DIVISION_ID = '40' THEN SP.PROJECT_CODE ELSE MS.END_CUSTOMER END = LUP2.SEGMENT2 --[PJ2024-50611]소형일 경우 PROJECT_CODE로 비교. 나머지는 END_CUSTOMER로 비교
        WHERE SP.DIVISION_ID = P_DIVISION_ID
          AND SP.QTY        <> 0
          AND SP.MEASURE     = 'RTF_SYS_RP'
          --[PJ2024-50461]버전의 날짜로 처리 START
          AND SP.YYYYMMDD   >= T_VER.RESULT_TO
          AND SP.YYYYMMDD   <= T_VER.PLAN_TO
          --[PJ2024-50461]버전의 날짜로 처리 END
          --[PJ2024-50461]82번 사업부는 에너지 있는 모델만 추출 START
          AND (
                  (P_DIVISION_ID = '82' AND EXISTS (
                      SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN MIS
                      WHERE  MIS.DIVISION_ID = '82'
                      AND    MIS.ITEM_ID     = SP.ITEM_ID
                      AND    NVL(MIS.ENERGE, '@#@#@#') <> '@#@#@#' --Energy가 있는 모델만
                      AND    MIS.ACTIVE_FLAG  = 'Y'
                  ))
              OR (P_DIVISION_ID <> '82')
              )
          --[PJ2024-50461]82번 사업부는 에너지 있는 모델만 추출 END
        UNION ALL
        SELECT
            SP.DIVISION_ID
            --[PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용
            --,MS.DEPT_ID
            --, DI.DEPT_NAME_KO
          , TEAM.DEPT_ID
          , TEAM.DEPT_NAME_KO
            --[PJ2024-50461] Sales Site Project Model 의 Owner 팀 적용
          , CASE WHEN SP.DIVISION_ID = '40' THEN SP.PROJECT_CODE ELSE MS.END_CUSTOMER END AS END_CUSTOMER --[PJ2024-50611]소형일 경우 PROJECT_CODE로 비교. 나머지는 END_CUSTOMER로 비교
          , MP.PROJECT_CODE
          , MP.PROJECT_NAME
          , SP.ITEM_ID
          , SP.SCM_SITE_ID
          , CASE WHEN NVL(SP.CURRENCY, '@#@#@#') = '@#@#@#' THEN SI.CURRENCY ELSE SP.CURRENCY END AS CURRENCY --CURRENCY가 없을 경우 SSPM의 값을 가져옴
          , LUP.SEGMENT2 AS FCST_TYPE
        FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C SP
        INNER JOIN SCM_MGR.SCM_MST_SITE MS
               ON MS.DIVISION_ID = SP.DIVISION_ID
              AND MS.SCM_SITE_ID = SP.SCM_SITE_ID
              AND MS.VALID_YN    = 'Y'
        INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
               ON LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
              AND LUP.VALID_YN    = 'Y'
              AND LUP.SEGMENT4   <> 'FREE' ----FCST_TYPE_NOT_FREE
              AND LUP.SEGMENT1    = SP.FCST_TYPE
        INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
               ON SI.DIVISION_ID  = SP.DIVISION_ID
              AND SI.PROJECT_CODE = SP.PROJECT_CODE
              AND SI.SCM_SITE_ID  = SP.SCM_SITE_ID
              AND SI.ITEM_ID      = SP.ITEM_ID
              AND SI.VALID_YN     = 'Y'
        --[PJ2024-50461]업로드 대상은 '제품(P)'만 해당START
        INNER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V SV
               ON SV.DIVISION_ID = SI.DIVISION_ID
              AND SV.ITEM_ID     = SI.ITEM_ID
              AND SV.ITEM_TYPE   = 'P' --'제품(P)'만 해당
        --[PJ2024-50461]업로드 대상은 '제품(P)'만 해당END
        --[PJ2024-50461]DIV별 최신버전 START
        INNER JOIN TEMP_VERSION_NO T_VER
               ON SP.DIVISION_ID = T_VER.DIVISION_ID
              AND SP.VERSION_NO  = T_VER.VERSION_NO
        --[PJ2024-50461]DIV별 최신버전 END
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 START
        -- [hook#150 2026-09-06 AJS] AS-IS: LEFT JOIN (
            -- [hook#150 2026-09-06 AJS] AS-IS: SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
            -- [hook#150 2026-09-06 AJS] AS-IS: FROM   SCM_MGR.SCM_MST_SSO_USER_INFO  B
            -- [hook#150 2026-09-06 AJS] AS-IS: INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
        -- [hook#150 2026-09-06 AJS] AS-IS: ) TEAM
               -- [hook#150 2026-09-06 AJS] AS-IS: ON TEAM.USER_ID = TRIM(CASE WHEN INSTR(SI.OWNER, ',') > 0
                                           -- [hook#150 2026-09-06 AJS] AS-IS: THEN SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1)
                                           -- [hook#150 2026-09-06 AJS] AS-IS: ELSE SI.OWNER END)
        -- 2026-09-06 hook#150 AJS: DEPT_ID 원천 = SCM_MST_SITE_ITEM.DEPT_ID (SCM_MST_SITE.DEPT_ID 삭제 예정 / OWNER 경유 폐기)
        LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM
               ON TEAM.DEPT_ID = SI.DEPT_ID
        --[PJ2024-50461] Sales Site Project Model 의 Owner 정보 조인 END
        LEFT JOIN SCM_MGR.SCM_MST_PROJECT MP
               ON SP.DIVISION_ID = MP.DIVISION_ID
              AND CASE WHEN SP.DIVISION_ID = '40' THEN '' ELSE SP.PROJECT_CODE END = MP.PROJECT_CODE --[PJ2024-50611] 소형사업부는 PROJECT_CODE가 없으므로 빈값으로 조인
        INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP2 ----등록된 END CUSTOMER만 처리
               ON SP.DIVISION_ID  = LUP2.SEGMENT1
              AND LUP2.LOOKUP_TYPE = 'END_CUSTOMER'
              AND CASE WHEN SP.DIVISION_ID = '40' THEN SP.PROJECT_CODE ELSE MS.END_CUSTOMER END = LUP2.SEGMENT2 --[PJ2024-50611]소형일 경우 PROJECT_CODE로 비교. 나머지는 END_CUSTOMER로 비교
        WHERE SP.DIVISION_ID = P_DIVISION_ID
          AND SP.QTY        <> 0
          AND SP.MEASURE     = 'RTF_SYS_RP'
          --[PJ2024-50461]버전의 날짜로 처리 START
          AND SP.YYYYMMDD   >= T_VER.RESULT_FROM
          AND SP.YYYYMMDD    < T_VER.RESULT_TO
          --[PJ2024-50461]버전의 날짜로 처리 END
          --[PJ2024-50461]82번 사업부는 에너지 있는 모델만 추출 START
          AND (
                  (P_DIVISION_ID = '82' AND EXISTS (
                      SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN MIS
                      WHERE  MIS.DIVISION_ID = '82'
                      AND    MIS.ITEM_ID     = SP.ITEM_ID
                      AND    NVL(MIS.ENERGE, '@#@#@#') <> '@#@#@#' --Energy가 있는 모델만
                      AND    MIS.ACTIVE_FLAG  = 'Y'
                  ))
              OR (P_DIVISION_ID <> '82')
              )
          --[PJ2024-50461]82번 사업부는 에너지 있는 모델만 추출 END
    )
    SELECT
        A.DIVISION_ID
        --[E20260825-DASHRM] 데이터 영역 '-' placeholder 44곳 제거 → 빈값 (사용자 지시 2026-08-25).
        --  FE 다운로드의 '-'→빈칸 치환은 no-op 로 무해. 그리드 표시도 빈칸.
      , ''    AS PLAN_YYYYMM --날짜는 빈칸으로 내려받게
      , A.DEPT_ID
      , A.DEPT_NAME_KO AS DEPT_NAME
      , A.END_CUSTOMER
      , A.PROJECT_CODE
      , A.PROJECT_NAME
      , A.ITEM_ID
      , 'Y'   AS METAL_LINK_YN
      , A.SCM_SITE_ID
      , A.CURRENCY
      , A.FCST_TYPE
      , 'N'   AS METAL_EXCEPTION_YN
      , ''    AS ENERGY
      , ''    AS APPLY_PRICE_TYPE_CODE1
      , ''    AS APPLY_PRICE_TYPE_CODE2
      , ''    AS APPLY_PRICE_TYPE_CODE3
      , ''    AS APPLY_PRICE_TYPE_CODE4
      , ''    AS APPLY_PRICE_TYPE_CODE5
      , ''    AS APPLY_PRICE_TYPE_CODE6
      , ''    AS APPLY_PRICE_TYPE_CODE7
      , ''    AS FROM_PERIOD1
      , ''    AS FROM_PERIOD2
      , ''    AS FROM_PERIOD3
      , ''    AS FROM_PERIOD4
      , ''    AS FROM_PERIOD5
      , ''    AS FROM_PERIOD6
      , ''    AS FROM_PERIOD7
      , ''    AS TO_PERIOD1
      , ''    AS TO_PERIOD2
      , ''    AS TO_PERIOD3
      , ''    AS TO_PERIOD4
      , ''    AS TO_PERIOD5
      , ''    AS TO_PERIOD6
      , ''    AS TO_PERIOD7
      , ''    AS CONTRACT_UNIT1
      , ''    AS CONTRACT_UNIT2
      , ''    AS CONTRACT_UNIT3
      , ''    AS CONTRACT_UNIT4
      , ''    AS CONTRACT_UNIT5
      , ''    AS CONTRACT_UNIT6
      , ''    AS CONTRACT_UNIT7
      , ''    AS METAL_APPLY1
      , ''    AS METAL_APPLY2
      , ''    AS METAL_APPLY3
      , ''    AS METAL_APPLY4
      , ''    AS METAL_APPLY5
      , ''    AS METAL_APPLY6
      , ''    AS METAL_APPLY7
      , ''    AS METAL_REQR1
      , ''    AS METAL_REQR2
      , ''    AS METAL_REQR3
      , ''    AS METAL_REQR4
      , ''    AS METAL_REQR5
      , ''    AS METAL_REQR6
      , ''    AS METAL_REQR7
      , EDY.EDIT_YN
    FROM BASE_DATA A
    INNER JOIN SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V EDY
         ON EDY.USER_ID = P_USER_ID
        AND EDY.MNU_ID  = P_MENU_ID
        AND EDY.UNIT_ID = A.DIVISION_ID
    GROUP BY
        A.DIVISION_ID
      , A.DEPT_ID
      , A.DEPT_NAME_KO
      , A.END_CUSTOMER
      , A.PROJECT_CODE
      , A.PROJECT_NAME
      , A.ITEM_ID
      , A.SCM_SITE_ID
      , A.CURRENCY
      , A.FCST_TYPE
      , EDY.EDIT_YN;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, NULL AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM='    || V_SQL_ERRMSG  ||
            ' / BACKTRACE='  || V_BACKTRACE   ||
            ' / PARAMS='     || V_PROC_INPUT
        );
END P_DMF0074_GET_METAL_LINK_TEMPLATE;

PROCEDURE P_DMF0074_EXCEL_UPLOAD
(
      P_MODE          IN PLS_INTEGER
     ,P_CREATED_BY    IN VARCHAR2
     ,P_PROGRAM_ID    IN VARCHAR2 -- 3/26 추가 결정
     ,P_SHEET_NAME    IN VARCHAR2 -- 3/26 추가 결정
     ,O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*===================================================================================================
 * Program ID   : [DMF0074_EXCEL_UPLOAD]
 * Description  : 이동계획 판가 메탈연동 - 엑셀업로드
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2024.07.02   KJJ     [PJ2024-50244]SCM DM 고객수요관리 고도화 및 개선 - 최초 작성
 * 2024.09.12   KJJ     [PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
 * 2024.10.02   KJJ     [PJ2024-50461] 업로드 대상은 '제품(P)'만 해당
 * 2024.10.15   KJJ     [PJ2024-50461] 업로드시 에너지 값이 없는것은 제외(82사업부만 적용)
 * 2024.10.22   KJJ     [PJ2024-50461] 템플릿 다운시 CURRENCY가 없을 경우 SSPM의 값을 가져오게 되어져 있으므로
                업로드시에도 해당조건 추가하여 업로드 가능하게 변경
 * 2024.10.24   KJJ     [PJ2024-50611]소형 이동계획 확산
 ===================================================================================================*/
IS
    V_PROGRAM_NAME    VARCHAR2(300 CHAR);
    V_PROGRAM_ID      VARCHAR2(40  CHAR)   := P_PROGRAM_ID; --'DMF0074';
    V_SHEET_NAME      VARCHAR2(40  CHAR)   := P_SHEET_NAME; --'Metal Link Price';
    V_CREATION_DATE   VARCHAR2(50  CHAR);
    V_COUNT           PLS_INTEGER;
   V_LOAD_CAND        PLS_INTEGER := 0; /* [E20260827-D4-NOLOADGUARD] 적재 후보 행수 */
    V_START_YYYYMMDD  VARCHAR2(8   CHAR);
    V_END_YYYYMMDD    VARCHAR2(8   CHAR);
    V_DIVISION        VARCHAR2(10  CHAR);

    -- LOG 용 변수 설정
    V_LOG_TYPE        VARCHAR2(30   CHAR);  -- START/END/ERROR/...
    N_LOG_COUNT       PLS_INTEGER := 0;
    V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
    V_DESCRIPTION     VARCHAR2(500  CHAR);
    D_EVENT_DATE      DATE;

    -- EXCEPTION 로깅용 변수
    V_PROC_INPUT      VARCHAR2(4000 CHAR);
    V_SQL_CODE        VARCHAR2(20   CHAR);
    V_SQL_ERRMSG      VARCHAR2(2000 CHAR);
    V_BACKTRACE       VARCHAR2(4000 CHAR);

    -- 버전/날짜 체크용
    V_YYYYMMDD        VARCHAR2(8    CHAR);
    V_FROM_YYYYMMDD   VARCHAR2(8    CHAR);
    V_TO_YYYYMMDD     VARCHAR2(8    CHAR);

BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- GTT 초기화 (이전 일반 테이블 DML 없음 → TRUNCATE 허용)
    DELETE FROM SCM_MGR.GT_DM74_TEMP_VERSION_NO; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TEMP_MST_ITEM; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TEMP_MST_ITEM_ENERGY; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TEMP_SP_ITEM; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_APPLY_PRICE_TYPE; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_FROM_PERIOD; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_TO_PERIOD; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_CONTRACT_UNIT; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_METAL_APPLY; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_METAL_REQR; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_ITEM; /*[E20260818-GTTDEL] DDL 경합 제거*/
    DELETE FROM SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE; /*[E20260818-GTTDEL] DDL 경합 제거*/

    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
    INTO   V_CREATION_DATE
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID  LIKE V_PROGRAM_ID || '%'
    AND    T.SHEET_NAME = V_SHEET_NAME
    AND    T.CREATED_BY = P_CREATED_BY;

    IF V_CREATION_DATE IS NULL THEN
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := 'Data Not Found [' || TO_CHAR(V_CREATION_DATE) || ']';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

        OPEN O_RESULT_CURSOR FOR
        SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check : '||V_DESCRIPTION AS MSG,TO_CHAR(NULL)  AS EVENT FROM DUAL;
        RETURN;
    END IF;

    BEGIN
        SELECT ATTRIBUTE1
        INTO   V_DIVISION
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        WHERE  PROGRAM_ID          LIKE V_PROGRAM_ID || '%'
        AND    SHEET_NAME          = V_SHEET_NAME
        AND    CREATED_BY          = P_CREATED_BY
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
        AND    UPLOAD_STATUS_CODE  = 'SUCCESS'
        FETCH FIRST 1 ROW ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_DIVISION := NULL;
    END;

    ----[PJ2024-50461]DIV별 최신 버전
    INSERT INTO SCM_MGR.GT_DM74_TEMP_VERSION_NO
             (DIVISION_ID,VERSION_NO,YYYYMMDD,YYYYMM,RESULT_FROM,RESULT_TO,PLAN_TO)
        SELECT
            --[PJ2024-50461]조회시 * 가져오지 말고 구체적 필드 표시START
              A.DIVISION_ID
            , A.VERSION_NO
            , A.YYYYMMDD
            --[PJ2024-50461]조회시 * 가져오지 말고 구체적 필드 표시END
            , B.BASIS_YYYYMM YYYYMM
            , CASE WHEN B.BASIS_YYYYMM > TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.YYYYMMDD,'YYYYMMDD'),'MON') - 7, 'YYYYMM')
                THEN TO_CHAR(ADD_MONTHS(TO_DATE(B.BASIS_YYYYMM || '01','YYYYMMDD'), -1), 'YYYYMMDD')
                ELSE B.BASIS_YYYYMM || '01' END RESULT_FROM
            , TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.YYYYMMDD,'YYYYMMDD'),'MON') - 7, 'YYYYMMDD') RESULT_TO
            , TO_CHAR(SCM_MGR.FN_NEXT_DAY(TO_DATE(A.YYYYMMDD,'YYYYMMDD'),'MON') - 7 + 52*7 - 1, 'YYYYMMDD') PLAN_TO
        FROM
        (
            SELECT DIVISION_ID, MAX(VERSION_NO) VERSION_NO, MAX(YYYYMMDD) YYYYMMDD
            FROM   SCM_MGR.DM_MST_VERSION
            WHERE  VERSION_TYPE = 'SP_W'
            AND    NVL(ATTRIBUTE7, 'N') = 'Y'
            GROUP BY DIVISION_ID
        ) A
        INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B
                ON B.BASIS_YYYYMMDD = A.YYYYMMDD;

    ------------------------------------------------------------------------
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'A1';
    V_LOG_MESSAGE := '########## INSERT = GT_DM74_TEMP_VERSION_NO ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ------------------------------------------------------------------------
    ------------------------------------------------------------

    --[PJ2024-50461]업로드시 type이 '제품' 인 것만 조회되게 tmp table생성 start
    INSERT INTO SCM_MGR.GT_DM74_TEMP_MST_ITEM
              (DIVISION_ID,ITEM_ID)
        SELECT DISTINCT DIVISION_ID, ITEM_ID
        FROM   SCM_MGR.DM_MST_ITEM_SINGLE_V SV
        WHERE  SV.ITEM_TYPE   = 'P'--'제품(P)'만 해당
        AND    SV.ACTIVE_FLAG = 'Y';
    --[PJ2024-50461]업로드시 type이 '제품' 인 것만 조회되게 tmp table생성 end
    ------------------------------------------------------------------------
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'A2';
    V_LOG_MESSAGE := '########## INSERT = GT_DM74_TEMP_MST_ITEM ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ------------------------------------------------------------------------

    --[PJ2024-50461]업로드시 Energy가 있는 모델만(82사업부만 적용) start
    INSERT INTO SCM_MGR.GT_DM74_TEMP_MST_ITEM_ENERGY
        SELECT DISTINCT DIVISION_ID, ITEM_ID
        FROM   SCM_MGR.DM_MST_ITEM_SINGLE_V SV
        WHERE  DIVISION_ID    = '82'
        AND    SV.ENERGE IS NOT NULL  -- MSSQL ISNULL(SV.ENERGE,'') <> '' → Oracle에서 ''=NULL이므로 IS NOT NULL 동일
        AND    SV.ACTIVE_FLAG = 'Y';
    --[PJ2024-50461]업로드시 Energy가 있는 모델만(82사업부만 적용) end
    ------------------------------------------------------------------------
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'A3';
    V_LOG_MESSAGE := '########## INSERT = GT_DM74_TEMP_MST_ITEM_ENERGY ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ------------------------------------------------------------------------


    /* #################################################### */
    /* [E20260918-KEYNAMETOCODE] 광물 KEY 명칭 → 코드 정규화                     */
    /*                                                                                      */
    /* 조회 SP(P_DMF0074_GET_METAL_LINK_PRICE)는 METAL_KEY_*.SEGMENT4(명칭)를 내려주는데,     */
    /* 업로드 검증(Invalid KEY CODE)·적재는 SEGMENT3(코드)만 받는다. 그래서 화면/엑셀        */
    /* 다운로드에서 본 명칭(예: DIV 81 Ni = 'LME')을 그대로 올리면 전건이 반려된다.          */
    /* AS-IS(dbo.DMF0074_EXCEL_UPLOAD L499)도 코드만 받아 동일 제약이었으나, 사용자가        */
    /* 코드를 외워 입력할 수 없으므로 명칭 입력을 수용하도록 보완한다.                        */
    /*                                                                                      */
    /* 무손실 근거 (LOOKUP 'METAL_KEY_VALUE' 58건 실측, 2026-09-18)                          */
    /*   - DIV+METAL 내 SEGMENT4(명칭) 유일  → 명칭→코드 매핑 모호 0건                       */
    /*   - SEGMENT3(코드) 와 SEGMENT4(명칭) 의 값 충돌 0건 → 양쪽 수용 시 오인식 없음         */
    /* 이미 코드로 입력된 값은 NOT EXISTS 가드로 그대로 두고(코드 우선),                      */
    /* 명칭·코드 어느 쪽도 아닌 값은 손대지 않아 기존 'Invalid KEY CODE' 가 정상 발생한다.    */
    /*                                                                                      */
    /* 적재 위치 : 검증(P_MODE=0)은 여기서 GT_DM74_TMP_EXCEL_UPLOAD_RAW 로 복사되고,          */
    /*             저장(P_MODE=1)은 SCM_ADM_EXCEL_UPLOAD 를 직접 읽으므로(본 BODY L2681),     */
    /*             원본 스테이징 1곳만 정규화하면 검증·저장이 함께 코드 기준으로 정렬된다.    */
    /* 컬럼 위치 : 40 사업부 = ATTRIBUTE12~18 / 그 외 = ATTRIBUTE14~20 (SCM_ADM_EXCEL_COLUMNS */
    /*             DMF0074_40 53토큰 · DMF0074 55토큰 실측)                                  */
    /* #################################################### */
    --40 사업부 (Key_Ni~Key_Cu = ATTRIBUTE12~18)
    UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
       SET T.LAST_UPDATE_DATE = T.LAST_UPDATE_DATE
           , T.ATTRIBUTE12 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Ni'
                              AND L.SEGMENT4    = T.ATTRIBUTE12                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE12)
                            ), T.ATTRIBUTE12)
           , T.ATTRIBUTE13 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Co'
                              AND L.SEGMENT4    = T.ATTRIBUTE13                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE13)
                            ), T.ATTRIBUTE13)
           , T.ATTRIBUTE14 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Li2Co3'
                              AND L.SEGMENT4    = T.ATTRIBUTE14                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE14)
                            ), T.ATTRIBUTE14)
           , T.ATTRIBUTE15 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'LIOH'
                              AND L.SEGMENT4    = T.ATTRIBUTE15                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE15)
                            ), T.ATTRIBUTE15)
           , T.ATTRIBUTE16 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Al'
                              AND L.SEGMENT4    = T.ATTRIBUTE16                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE16)
                            ), T.ATTRIBUTE16)
           , T.ATTRIBUTE17 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Mn'
                              AND L.SEGMENT4    = T.ATTRIBUTE17                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE17)
                            ), T.ATTRIBUTE17)
           , T.ATTRIBUTE18 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Cu'
                              AND L.SEGMENT4    = T.ATTRIBUTE18                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE18)
                            ), T.ATTRIBUTE18)
     WHERE T.PROGRAM_ID   LIKE V_PROGRAM_ID || '%'
       AND T.SHEET_NAME    = V_SHEET_NAME
       AND T.CREATED_BY    = P_CREATED_BY
       AND TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
       AND NVL(T.UPLOAD_STATUS_CODE,'X') NOT IN ('@TITLE','SKIP')
       AND T.ATTRIBUTE1 = '40';

    ------------------------------------------------------------------------
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'B0';
    V_LOG_MESSAGE := '########## [E20260918-KEYNAMETOCODE] KEY NAME -> CODE (DIV 40) ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ------------------------------------------------------------------------
    --그 외 사업부 (Key_Ni~Key_Cu = ATTRIBUTE14~20)
    UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
       SET T.LAST_UPDATE_DATE = T.LAST_UPDATE_DATE
           , T.ATTRIBUTE14 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Ni'
                              AND L.SEGMENT4    = T.ATTRIBUTE14                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE14)
                            ), T.ATTRIBUTE14)
           , T.ATTRIBUTE15 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Co'
                              AND L.SEGMENT4    = T.ATTRIBUTE15                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE15)
                            ), T.ATTRIBUTE15)
           , T.ATTRIBUTE16 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Li2Co3'
                              AND L.SEGMENT4    = T.ATTRIBUTE16                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE16)
                            ), T.ATTRIBUTE16)
           , T.ATTRIBUTE17 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'LIOH'
                              AND L.SEGMENT4    = T.ATTRIBUTE17                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE17)
                            ), T.ATTRIBUTE17)
           , T.ATTRIBUTE18 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Al'
                              AND L.SEGMENT4    = T.ATTRIBUTE18                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE18)
                            ), T.ATTRIBUTE18)
           , T.ATTRIBUTE19 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Mn'
                              AND L.SEGMENT4    = T.ATTRIBUTE19                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE19)
                            ), T.ATTRIBUTE19)
           , T.ATTRIBUTE20 = NVL( (SELECT MIN(L.SEGMENT3)
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE L.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                              AND L.VALID_YN    = 'Y'
                              AND L.SEGMENT1    = SUBSTR(T.ATTRIBUTE1, 1, 2)
                              AND L.SEGMENT2    = 'Cu'
                              AND L.SEGMENT4    = T.ATTRIBUTE20                      --명칭(화면 표시값)
                              AND NOT EXISTS (SELECT 1                       --이미 코드면 코드 우선
                                                FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                                               WHERE L2.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                                 AND L2.VALID_YN    = 'Y'
                                                 AND L2.SEGMENT1    = L.SEGMENT1
                                                 AND L2.SEGMENT2    = L.SEGMENT2
                                                 AND L2.SEGMENT3    = T.ATTRIBUTE20)
                            ), T.ATTRIBUTE20)
     WHERE T.PROGRAM_ID   LIKE V_PROGRAM_ID || '%'
       AND T.SHEET_NAME    = V_SHEET_NAME
       AND T.CREATED_BY    = P_CREATED_BY
       AND TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
       AND NVL(T.UPLOAD_STATUS_CODE,'X') NOT IN ('@TITLE','SKIP')
       AND T.ATTRIBUTE1 <> '40';

    ------------------------------------------------------------------------
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'B0';
    V_LOG_MESSAGE := '########## [E20260918-KEYNAMETOCODE] KEY NAME -> CODE (DIV NOT 40) ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ------------------------------------------------------------------------
    -- @p_mode = 0 이면 Validation
    IF NVL(P_MODE, 0) = 0
    THEN

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'UPLOAD'
             , MESSAGE_TEXT       = NULL
        WHERE  PROGRAM_ID    LIKE V_PROGRAM_ID || '%'
        AND    SHEET_NAME    = V_SHEET_NAME
        AND    CREATED_BY    = P_CREATED_BY
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
        AND    NVL(UPLOAD_STATUS_CODE,'X') != 'UPLOAD';

        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'B1';
        V_LOG_MESSAGE := '########## RESET Status = UPLOAD ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SKIP'
        WHERE  PROGRAM_ID    LIKE V_PROGRAM_ID || '%'
        AND    SHEET_NAME    = V_SHEET_NAME
        AND    CREATED_BY    = P_CREATED_BY
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
         --ATTRIBUTE1 ~ ATTRIBUTE13까지는 빈칸임(헤더가 2줄이라서)
        AND    (ATTRIBUTE1  = '' OR ATTRIBUTE1  IS NULL)
        AND    (ATTRIBUTE2  = '' OR ATTRIBUTE2  IS NULL)
        AND    (ATTRIBUTE3  = '' OR ATTRIBUTE3  IS NULL)
        AND    (ATTRIBUTE4  = '' OR ATTRIBUTE4  IS NULL)
        AND    (ATTRIBUTE5  = '' OR ATTRIBUTE5  IS NULL)
        AND    (ATTRIBUTE6  = '' OR ATTRIBUTE6  IS NULL)
        AND    (ATTRIBUTE7  = '' OR ATTRIBUTE7  IS NULL)
        AND    (ATTRIBUTE8  = '' OR ATTRIBUTE8  IS NULL)
        AND    (ATTRIBUTE9  = '' OR ATTRIBUTE9  IS NULL)
        AND    (ATTRIBUTE10 = '' OR ATTRIBUTE10 IS NULL)
        AND    (ATTRIBUTE11 = '' OR ATTRIBUTE11 IS NULL)
        AND    (ATTRIBUTE12 = '' OR ATTRIBUTE12 IS NULL)
        AND    (ATTRIBUTE13 = '' OR ATTRIBUTE13 IS NULL);

        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'B2';
        V_LOG_MESSAGE := '########## SKIP EMPTY LINE ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = '@TITLE'
        WHERE  PROGRAM_ID    LIKE V_PROGRAM_ID || '%'
        AND    SHEET_NAME    = V_SHEET_NAME
        AND    CREATED_BY    = P_CREATED_BY
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
        AND    UPPER(ATTRIBUTE1) = 'DIV';

        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'B3';
        V_LOG_MESSAGE := '########## TITLE Header Line ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        --본격적 VALIDATION 시작
        -- [PJ2024-50611]tmp table 에 업로드한것 적재 start
        -- 40번 사업부일 경우 2칸 조정한다
        INSERT INTO SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
             (UPLOAD_ID,PROGRAM_ID,SHEET_NAME,UPLOAD_STATUS_CODE,MESSAGE_TEXT,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
             ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
             ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,ATTRIBUTE16,ATTRIBUTE17,ATTRIBUTE18,ATTRIBUTE19,ATTRIBUTE20
             ,ATTRIBUTE21,ATTRIBUTE22,ATTRIBUTE23,ATTRIBUTE24,ATTRIBUTE25,ATTRIBUTE26,ATTRIBUTE27,ATTRIBUTE28,ATTRIBUTE29,ATTRIBUTE30
             ,ATTRIBUTE31,ATTRIBUTE32,ATTRIBUTE33,ATTRIBUTE34,ATTRIBUTE35,ATTRIBUTE36,ATTRIBUTE37,ATTRIBUTE38,ATTRIBUTE39,ATTRIBUTE40
             ,ATTRIBUTE41,ATTRIBUTE42,ATTRIBUTE43,ATTRIBUTE44,ATTRIBUTE45,ATTRIBUTE46,ATTRIBUTE47,ATTRIBUTE48,ATTRIBUTE49,ATTRIBUTE50
             ,ATTRIBUTE51,ATTRIBUTE52,ATTRIBUTE53,ATTRIBUTE54,ATTRIBUTE55
             )
        SELECT
              UPLOAD_ID,
              PROGRAM_ID,
              SHEET_NAME,
              UPLOAD_STATUS_CODE,
              MESSAGE_TEXT,
              CREATED_BY,
              CREATION_DATE,
              LAST_UPDATED_BY,
              LAST_UPDATE_DATE,
              ATTRIBUTE1  --DIVISION_ID
              ,ATTRIBUTE2  --PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,ATTRIBUTE3  --DEPT_NAME
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,ATTRIBUTE4  --End Customer
              ,CASE WHEN ATTRIBUTE1 = '40' THEN '' ELSE ATTRIBUTE5 END  --Project Code(소형사업부는 공백처리)
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE5 ELSE ATTRIBUTE7 END  --MODEL Code
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE6 ELSE ATTRIBUTE8 END  --Metal Link
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE7 ELSE ATTRIBUTE9 END  --Sales Site
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE8 ELSE ATTRIBUTE10 END  --Currency
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE9 ELSE ATTRIBUTE11 END  --FCST type
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE10 ELSE ATTRIBUTE12 END  --Exception
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE11 ELSE ATTRIBUTE13 END  --Energy
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE12 ELSE ATTRIBUTE14 END  --Ni     APPLY_PRICE_TYPE_CODE1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE13 ELSE ATTRIBUTE15 END  --Co     APPLY_PRICE_TYPE_CODE2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE14 ELSE ATTRIBUTE16 END  --Li2CO3 APPLY_PRICE_TYPE_CODE3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE15 ELSE ATTRIBUTE17 END  --LIOH   APPLY_PRICE_TYPE_CODE4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE16 ELSE ATTRIBUTE18 END  --Al     APPLY_PRICE_TYPE_CODE5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE17 ELSE ATTRIBUTE19 END  --Mn     APPLY_PRICE_TYPE_CODE6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE18 ELSE ATTRIBUTE20 END  --Cu     APPLY_PRICE_TYPE_CODE7
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE19 ELSE ATTRIBUTE21 END  --Ni     FROM_PERIOD1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE20 ELSE ATTRIBUTE22 END  --Co     FROM_PERIOD2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE21 ELSE ATTRIBUTE23 END  --Li2CO3 FROM_PERIOD3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE22 ELSE ATTRIBUTE24 END  --LIOH   FROM_PERIOD4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE23 ELSE ATTRIBUTE25 END  --Al     FROM_PERIOD5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE24 ELSE ATTRIBUTE26 END  --Mn     FROM_PERIOD6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE25 ELSE ATTRIBUTE27 END  --Cu     FROM_PERIOD7
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE26 ELSE ATTRIBUTE28 END  --Ni     TO_PERIOD1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE27 ELSE ATTRIBUTE29 END  --Co     TO_PERIOD2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE28 ELSE ATTRIBUTE30 END  --Li2CO3 TO_PERIOD3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE29 ELSE ATTRIBUTE31 END  --LIOH   TO_PERIOD4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE30 ELSE ATTRIBUTE32 END  --Al     TO_PERIOD5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE31 ELSE ATTRIBUTE33 END  --Mn     TO_PERIOD6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE32 ELSE ATTRIBUTE34 END  --Cu     TO_PERIOD7
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE33 ELSE ATTRIBUTE35 END  --Ni     CONTRACT_UNIT1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE34 ELSE ATTRIBUTE36 END  --Co     CONTRACT_UNIT2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE35 ELSE ATTRIBUTE37 END  --Li2CO3 CONTRACT_UNIT3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE36 ELSE ATTRIBUTE38 END  --LIOH   CONTRACT_UNIT4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE37 ELSE ATTRIBUTE39 END  --Al     CONTRACT_UNIT5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE38 ELSE ATTRIBUTE40 END  --Mn     CONTRACT_UNIT6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE39 ELSE ATTRIBUTE41 END  --Cu     CONTRACT_UNIT7
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE40 ELSE ATTRIBUTE42 END  --Ni     METAL_APPLY1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE41 ELSE ATTRIBUTE43 END  --Co     METAL_APPLY2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE42 ELSE ATTRIBUTE44 END  --Li2CO3 METAL_APPLY3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE43 ELSE ATTRIBUTE45 END  --LIOH   METAL_APPLY4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE44 ELSE ATTRIBUTE46 END  --Al     METAL_APPLY5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE45 ELSE ATTRIBUTE47 END  --Mn     METAL_APPLY6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE46 ELSE ATTRIBUTE48 END  --Cu     METAL_APPLY7
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE47 ELSE ATTRIBUTE49 END  --Ni     METAL_REQR1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE48 ELSE ATTRIBUTE50 END  --Co     METAL_REQR2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE49 ELSE ATTRIBUTE51 END  --Li2CO3 METAL_REQR3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE50 ELSE ATTRIBUTE52 END  --LIOH   METAL_REQR4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE51 ELSE ATTRIBUTE53 END  --Al     METAL_REQR5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE52 ELSE ATTRIBUTE54 END  --Mn     METAL_REQR6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE53 ELSE ATTRIBUTE55 END  --Cu     METAL_REQR7
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        WHERE  1 = 1
        AND    PROGRAM_ID          LIKE V_PROGRAM_ID || '%'
        AND    SHEET_NAME          = V_SHEET_NAME
        AND    CREATED_BY          = P_CREATED_BY
        AND    UPLOAD_STATUS_CODE  = 'UPLOAD'
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE;
        -- [PJ2024-50611]tmp table 에 업로드한것 적재 end
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'B4';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_EXCEL_UPLOAD_RAW ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 필수 값 NULL 값 체크 (요청사항 변경으로 인해 광물은 별도로 체크)     */
        /* ATTRIBUTE1  : Div                  */
        /* ATTRIBUTE2  : Plan Date                */
        /* ATTRIBUTE3  : Team                 */
        /* ATTRIBUTE4  : End Customer             */
        /* ATTRIBUTE5 : Project Code              */
        /* ATTRIBUTE9 : Sales Site                */
        /* ATTRIBUTE10 : Currency               */
        /* ATTRIBUTE11 : FCST type                */
        /* ATTRIBUTE8 : Metal Link(2024.09.06 추가됨)                */
        /* 추가 체크(2024.07.08  박필수 책임)*/
        /* ATTRIBUTE14 ~ ATTRIBUTE20 : APPLY_PRICE_TYPE_CODE(요청사항 변경으로 인해 하단에서 별도로 체크)*/
        /* ATTRIBUTE21 ~ ATTRIBUTE27 : FROM_PERIOD_YYYYMM(요청사항 변경으로 인해 하단에서 별도로 체크)*/
        /* ATTRIBUTE28 ~ ATTRIBUTE34 : TO_PERIOD_YYYYMM(요청사항 변경으로 인해 하단에서 별도로 체크)*/
        /* ATTRIBUTE3  : 필수 체크에서 제외 [PJ2024-50461] Team Mapping*/
        /* ATTRIBUTE5 : 소형사업부는 프로젝트 코드 체크 안함 --[PJ2024-50611]소형 이동계획 확산*/
        /* #################################################### */
        --Div Team  End Customer  Project Code  Currency
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = CASE WHEN NVL(ATTRIBUTE1 ,'@#@#@#') = '@#@#@#'  THEN 'NULL DIVISION.'
                                         WHEN NVL(ATTRIBUTE2 ,'@#@#@#') = '@#@#@#'  THEN 'NULL PLAN DATE.'
                                         --WHEN NVL(ATTRIBUTE3,'@#@#@#') = '@#@#@#'  THEN 'NULL TEAM.' --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
                                         WHEN NVL(ATTRIBUTE4 ,'@#@#@#') = '@#@#@#'  THEN 'NULL END CUSTOMER.'
                                         WHEN NVL(ATTRIBUTE5 ,'@#@#@#') = '@#@#@#' AND ATTRIBUTE1 <> '40' THEN 'NULL PROJECT CODE.' --[PJ2024-50461] 소형 이동계획 확산 : 소형사업부는 프로젝트 코드 체크 안함
                                         WHEN NVL(ATTRIBUTE9 ,'@#@#@#') = '@#@#@#'  THEN 'NULL SALES SITE.'
                                         WHEN NVL(ATTRIBUTE10,'@#@#@#') = '@#@#@#' THEN 'NULL CURRENCY.'
                                         WHEN NVL(ATTRIBUTE11,'@#@#@#') = '@#@#@#' THEN 'NULL FCST TYPE.'
                                         WHEN NVL(ATTRIBUTE8 ,'@#@#@#') = '@#@#@#'  THEN 'NULL Metal Link.'
                                     END
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND (   --[PJ2024-50461] 팀정보 관리 안하므로 ATTRIBUTE3 체크 제외
                   NVL(ATTRIBUTE1 ,'@#@#@#') = '@#@#@#'
                OR NVL(ATTRIBUTE2 ,'@#@#@#') = '@#@#@#'
                /*OR NVL(ATTRIBUTE3 ,'') = '' */
                OR NVL(ATTRIBUTE4 ,'@#@#@#') = '@#@#@#'
                OR (NVL(ATTRIBUTE5,'@#@#@#') = '@#@#@#' AND ATTRIBUTE1 <> '40')----[PJ2024-50611]소형 이동계획 확산 : 소형사업부는 프로젝트 코드 체크 안함
                OR NVL(ATTRIBUTE9 ,'@#@#@#') = '@#@#@#'
                OR NVL(ATTRIBUTE10,'@#@#@#') = '@#@#@#'
                OR NVL(ATTRIBUTE11,'@#@#@#') = '@#@#@#'
                OR NVL(ATTRIBUTE8 ,'@#@#@#') = '@#@#@#'
                );

        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C2';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = Div Team  End Customer  Project Code  Currency ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 업로드 시에도 금주차 컷오프 버전이 있는지 체크해야 함     */
        /* #################################################### */
        V_YYYYMMDD := TO_CHAR(SYSDATE, 'YYYYMMDD');

        SELECT MIN(B.BASIS_YYYYMMDD)  --금주 시작일
             , MAX(B.BASIS_YYYYMMDD)  --금주 종료일
        INTO   V_FROM_YYYYMMDD
             , V_TO_YYYYMMDD
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B
                ON A.ISO_YYYYWW = B.ISO_YYYYWW
        WHERE  A.BASIS_YYYYMMDD = V_YYYYMMDD;

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'There is no version of Monthly Rolling Forest:Y in Sales Plan Waterfall this week.'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
         AND NOT EXISTS (  SELECT 1
                             FROM SCM_MGR.GT_DM74_TEMP_VERSION_NO T_VER
                            WHERE T_VER.DIVISION_ID = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1  --Div
                          );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C3';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 금주차 컷오프 버전이 있는지 체크 ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 광물은 7개중 5개 이상 입력해야 함     */
        /* =>요청사항변경(2024-08-21 : 1개만 입력도 가능하게)      */
        /* ATTRIBUTE14 ~ ATTRIBUTE20  */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NULL APPLY PRICE TYPE CODE.'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
        AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
        AND (
                    NVL(ATTRIBUTE14, '@#@#@#') = '@#@#@#'
                AND NVL(ATTRIBUTE15, '@#@#@#') = '@#@#@#'
                AND NVL(ATTRIBUTE16, '@#@#@#') = '@#@#@#'
                AND NVL(ATTRIBUTE17, '@#@#@#') = '@#@#@#'
                AND NVL(ATTRIBUTE18, '@#@#@#') = '@#@#@#'
                AND NVL(ATTRIBUTE19, '@#@#@#') = '@#@#@#'
                AND NVL(ATTRIBUTE20, '@#@#@#') = '@#@#@#'
            );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C4';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 광물은 7개중 5개 이상 입력해야 함  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 광물 룩업VALUE 체크            */
        /* ATTRIBUTE14 ~ ATTRIBUTE20  */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid KEY CODE : Ni'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
        AND    LENGTH(ATTRIBUTE14) > 0
        AND    NOT EXISTS (  SELECT 1
                               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                              WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                AND LUP.VALID_YN    = 'Y'
                                AND LUP.SEGMENT1    = SUBSTR(GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1, 2)  --Div
                                AND LUP.SEGMENT2    = 'Ni'                                                   --KEY
                                AND LUP.SEGMENT3    = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE14               --CODE
                             );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C5';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 광물 룩업VALUE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid KEY CODE : Co'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
        AND    LENGTH(ATTRIBUTE15) > 0
        AND    NOT EXISTS (  SELECT 1
                               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                              WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                AND LUP.VALID_YN    = 'Y'
                                AND LUP.SEGMENT1    = SUBSTR(GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1, 2)  --Div
                                AND LUP.SEGMENT2    = 'Co'                                                   --KEY
                                AND LUP.SEGMENT3    = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE15               --CODE
                             );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C6';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 광물 룩업VALUE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid KEY CODE : Li2CO3'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
        AND    LENGTH(ATTRIBUTE16) > 0
        AND    NOT EXISTS (  SELECT 1
                               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                              WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                AND LUP.VALID_YN    = 'Y'
                                AND LUP.SEGMENT1    = SUBSTR(GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1, 2)  --Div
                                AND LUP.SEGMENT2    = 'Li2Co3'                                               --KEY
                                AND LUP.SEGMENT3    = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE16               --CODE
                             );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C7';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 광물 룩업VALUE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid KEY CODE : LIOH'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
        AND    LENGTH(ATTRIBUTE17) > 0
        AND    NOT EXISTS (  SELECT 1
                               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                              WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                AND LUP.VALID_YN    = 'Y'
                                AND LUP.SEGMENT1    = SUBSTR(GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1, 2)  --Div
                                AND LUP.SEGMENT2    = 'LIOH'                                                 --KEY
                                AND LUP.SEGMENT3    = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE17               --CODE
                             );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C8';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 광물 룩업VALUE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid KEY CODE : Al'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
        AND    LENGTH(ATTRIBUTE18) > 0
        AND    NOT EXISTS (  SELECT 1
                               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                              WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                AND LUP.VALID_YN    = 'Y'
                                AND LUP.SEGMENT1    = SUBSTR(GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1, 2)  --Div
                                AND LUP.SEGMENT2    = 'Al'                                                   --KEY
                                AND LUP.SEGMENT3    = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE18               --CODE
                             );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C9';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 광물 룩업VALUE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid KEY CODE : Mn'
        WHERE    UPLOAD_STATUS_CODE = 'UPLOAD'
         AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#') /*[E20260816-NULLFIX] 형제블록 표준식 정합*/) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
        AND    LENGTH(ATTRIBUTE19) > 0
        AND    NOT EXISTS (  SELECT 1
                               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                              WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                AND LUP.VALID_YN    = 'Y'
                                AND LUP.SEGMENT1    = SUBSTR(GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1, 2)  --Div
                                AND LUP.SEGMENT2    = 'Mn'                                                   --KEY
                                AND LUP.SEGMENT3    = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE19               --CODE
                             );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C10';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 광물 룩업VALUE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid KEY CODE : Cu'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
        AND    LENGTH(ATTRIBUTE20) > 0
        AND    NOT EXISTS (  SELECT 1
                               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                              WHERE LUP.LOOKUP_TYPE = 'METAL_KEY_VALUE'
                                AND LUP.VALID_YN    = 'Y'
                                AND LUP.SEGMENT1    = SUBSTR(GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1, 1, 2)  --Div
                                AND LUP.SEGMENT2    = 'Cu'                                                   --KEY
                                AND LUP.SEGMENT3    = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE20               --CODE
                             );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C11';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 광물 룩업VALUE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 동일아이템 중복 체크      */
        /* ATTRIBUTE1  : Div                  */
        /* ATTRIBUTE2  : Plan Date                */
        /* ATTRIBUTE3  : Team                 */
        /* ATTRIBUTE4  : End Customer             */
        /* ATTRIBUTE5 : Project Code              */
        /* ATTRIBUTE7 : Model Code                */
        /* ATTRIBUTE9 : Sales Site                */
        /* ATTRIBUTE10 : Currency               */
        /* ATTRIBUTE11 : FCST type                */
        /* ATTRIBUTE3 :  중복체크에서 제외  [PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거*/
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Duplication Model.'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
          AND  EXISTS (SELECT 1
                         FROM  (SELECT X.ATTRIBUTE1 AS COL1
                                     , X.ATTRIBUTE2 AS COL2
                                     --, X.ATTRIBUTE3 AS COL3--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
                                     , X.ATTRIBUTE4 AS COL4
                                     , X.ATTRIBUTE5 AS COL5
                                     , X.ATTRIBUTE7 AS COL7
                                     , X.ATTRIBUTE9 AS COL9
                                     , X.ATTRIBUTE10 AS COL10
                                     , X.ATTRIBUTE11 AS COL11
                                FROM   SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW X
                                GROUP BY X.ATTRIBUTE1
                                       , X.ATTRIBUTE2
                                       --, X.ATTRIBUTE3--[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
                                       , X.ATTRIBUTE4
                                       , X.ATTRIBUTE5
                                       , X.ATTRIBUTE7
                                       , X.ATTRIBUTE9
                                       , X.ATTRIBUTE10
                                       , X.ATTRIBUTE11
                                HAVING COUNT(*) > 1 ) T
                        WHERE 1 = 1
                          /*[E20260816-NULLFIX] 40 은 PROJECT_CODE 를 NULL 로 강제(위 INSERT)하는데
                             NULL = NULL 은 UNKNOWN 이라 중복이 전혀 검출되지 않았다.
                             MSSQL 에서는 ''='' 가 TRUE 라 정상 동작하던 로직 — 양변 NVL 로 복원 */
                          AND NVL(T.COL1 ,'@#@#@#') = NVL(ATTRIBUTE1 ,'@#@#@#')
                          AND NVL(T.COL2 ,'@#@#@#') = NVL(ATTRIBUTE2 ,'@#@#@#')
                          AND NVL(T.COL4 ,'@#@#@#') = NVL(ATTRIBUTE4 ,'@#@#@#')
                          AND NVL(T.COL5 ,'@#@#@#') = NVL(ATTRIBUTE5 ,'@#@#@#')
                          AND NVL(T.COL7 ,'@#@#@#') = NVL(ATTRIBUTE7 ,'@#@#@#')
                          AND NVL(T.COL9 ,'@#@#@#') = NVL(ATTRIBUTE9 ,'@#@#@#')
                          AND NVL(T.COL10,'@#@#@#') = NVL(ATTRIBUTE10,'@#@#@#')
                          AND NVL(T.COL11,'@#@#@#') = NVL(ATTRIBUTE11,'@#@#@#')
                       );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C12';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 동일아이템 중복 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* PLAN_YYYYMM  체크                  */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Date Format.'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
          AND  (LENGTH(ATTRIBUTE2) <> 6
                OR NOT (REGEXP_LIKE(ATTRIBUTE2, '^[0-9]{6}$')
                        AND TO_NUMBER(SUBSTR(ATTRIBUTE2, 5, 2)) BETWEEN 1 AND 12
                       )
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C13';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = PLAN_YYYYMM 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        --당월 이후만 입력가능
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Past Date.'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
          AND  ATTRIBUTE2 < TO_CHAR(SYSDATE, 'YYYYMM');
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C14';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 당월 이후만 입력가능  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* TEAM 체크                      */
        /* 체크 안함 : [PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거*/
        /* #################################################### */
        /*BEGIN
            ...
        END;*/

        /* #################################################### */
        /* END CUSTOMER 체크                  */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid END CUSTOMER.'
         WHERE   UPLOAD_STATUS_CODE = 'UPLOAD'
         --긴급 수정 =>[PJ2024-50461]END CUSTOMER는 룩업에 등록된 것들 기준으로 변경
         AND NOT EXISTS (  SELECT 1
                             FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
                            AND    SEGMENT1    = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
                            AND    SEGMENT2    = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE4
                            AND    VALID_YN    = 'Y'
                           );

        /* #################################################### */
        /* PROJECT CODE 체크                  */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid PROJECT CODE.'
         WHERE ATTRIBUTE1 <> '40' --[PJ2024-50611]소형 이동계획 확산 : 40 사업부는 체크안함
         AND   UPLOAD_STATUS_CODE = 'UPLOAD'
         AND NOT EXISTS (  SELECT 1
                             FROM SCM_MGR.SCM_MST_PROJECT MP
                            WHERE 1 = 1
                              AND MP.DIVISION_ID  = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
                              AND MP.PROJECT_CODE = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE5
                           );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C15';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = PROJECT CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* MODEL 체크                   */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid MODEL.'
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NVL(ATTRIBUTE7, '@#@#@#') <> '@#@#@#' /*[E20260816-NULLFIX] ''=NULL 사문화 정정*/--Model
           AND NOT EXISTS (  SELECT 1
                               FROM SCM_MGR.SCM_MST_SITE MS
                               INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM ITM
                                   ON ITM.DIVISION_ID  = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
                                   --[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교
                                   --AND ITM.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                                   AND ITM.PROJECT_CODE = CASE WHEN ITM.DIVISION_ID = '40' THEN GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE4 ELSE GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE5 END
                                   --[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교
                                   AND ITM.SCM_SITE_ID  = MS.SCM_SITE_ID
                                   AND ITM.ITEM_ID      = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE7
                                   AND ITM.VALID_YN     = 'Y'
                              WHERE 1 = 1
                                AND MS.DIVISION_ID = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
                                --AND MS.END_CUSTOMER = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4--[PJ2024-50461]END_CUSTOMER는 필수값이 아니므로 조인 조건에서 제외
                                AND MS.VALID_YN = 'Y'
                            );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C16';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = MODEL 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        --[PJ2024-50461]에너지 없는 모델일 경우 별도 메세지(82번 사업부만)-----
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid MODEL : NULL ENERGY'
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NVL(ATTRIBUTE7, '@#@#@#') <> '@#@#@#' /*[E20260816-NULLFIX] ''=NULL 사문화 정정*/--Model
           AND ATTRIBUTE1 = '82' --82번 사업부만
           AND NOT EXISTS (
                           SELECT 1
                             FROM SCM_MGR.GT_DM74_TEMP_MST_ITEM_ENERGY SV
                            WHERE 1 = 1
                              AND SV.DIVISION_ID = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
                              AND SV.ITEM_ID     = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE7
                          );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C17';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 에너지 없는 모델일 경우 별도 메세지(82번 사업부만)  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        --[PJ2024-50461]제품TYPE이 P가 아닌경우 별도 메세지-----
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid MODEL : TYPE P.'
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NVL(ATTRIBUTE7, '@#@#@#') <> '@#@#@#' /*[E20260816-NULLFIX] ''=NULL 사문화 정정*/--Model
           AND NOT EXISTS (
                           SELECT 1
                             FROM SCM_MGR.GT_DM74_TEMP_MST_ITEM SV
                            WHERE 1 = 1
                              AND SV.DIVISION_ID = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
                              AND SV.ITEM_ID     = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE7
                          );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C18';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 제품TYPE이 P가 아닌경우 별도 메세지  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* [E20260827-D5-ORDER] Sales Site(C21)/Currency(C22)/FCST type(C23) 단건 검증을 C19(Sales Plan Waterfall 조합 검증) 앞으로 이동.
           C19 가 Site/Currency/FCST type 을 조인 키로 포함해 먼저 걸리면 구체 메시지가 'Invalid Sales Plan Waterfall MODEL.' 로 가려졌다(D5, TC14~16).
           AS-IS(MSSQL DMF0074_EXCEL_UPLOAD) 도 C19 선행이었으나 사용자 안내 목적의 순서 정정(2026-08-27 사용자 요청). 판정 조건은 무변경. */
        /* #################################################### */
        /* Sales Site  체크                   */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Sales Site.'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
          AND  NOT EXISTS ( SELECT 1 FROM SCM_MGR.SCM_MST_SITE MS
                            WHERE MS.DIVISION_ID = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
                            AND MS.VALID_YN      = 'Y'
                            AND MS.SCM_SITE_ID   = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE9
                           );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C21';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = Sales Site 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* CURRENCY 체크                    */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid CURRENCY.'
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NOT EXISTS (  SELECT 1
                               FROM SCM_MGR.DM_MST_EXCHANGE_RATE ER
                              WHERE 1 = 1
                                AND ER.DIVISION_ID   = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
                                AND ER.UNIT_CURRENCY = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE10
                           );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C22';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = CURRENCY 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* FCST type 체크                   */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid FCST TYPE.'
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NOT EXISTS (  SELECT 1
                               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                              WHERE LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                AND LUP.VALID_YN    = 'Y'
                                AND LUP.SEGMENT4   <> 'FREE'----FCST_TYPE_NOT_FREE
                                AND LUP.SEGMENT2    = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE11
                           );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C23';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = FCST type 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Sales Plan Waterfall MODEL.'
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
           AND NVL(ATTRIBUTE7, '@#@#@#') <> '@#@#@#'--Model
           AND NOT EXISTS (
                           SELECT 1 FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C RC
                               INNER JOIN SCM_MGR.GT_DM74_TEMP_VERSION_NO T_VER
                                   ON RC.DIVISION_ID = T_VER.DIVISION_ID
                                   AND RC.VERSION_NO = T_VER.VERSION_NO
                               INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM SI--[PJ2024-50461]CURRENCY 처리 위해 조인 추가
                                   ON SI.DIVISION_ID  = RC.DIVISION_ID
                                   AND SI.PROJECT_CODE = RC.PROJECT_CODE
                                   AND SI.SCM_SITE_ID  = RC.SCM_SITE_ID
                                   AND SI.ITEM_ID      = RC.ITEM_ID
                                   AND SI.VALID_YN     = 'Y'
                           WHERE RC.DIVISION_ID = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
                           --[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교
                           --AND RC.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                           AND RC.PROJECT_CODE = CASE WHEN RC.DIVISION_ID = '40' THEN GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE4 ELSE GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE5 END
                           --[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교
                           AND RC.ITEM_ID     = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE7
                           AND RC.SCM_SITE_ID = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE9
                           AND NVL(RC.CURRENCY, SI.CURRENCY) /*[E20260816-NULLFIX] 폴백 사문화 정정*/ = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE10--[PJ2024-50461]CURRENCY가 없을 경우 SSPM의 값을 가져옴
                           AND FCST_TYPE IN
                           (
                               SELECT LUP.SEGMENT1
                               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                               WHERE LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                   AND LUP.VALID_YN  = 'Y'
                                   AND LUP.SEGMENT4 <> 'FREE'----FCST_TYPE_NOT_FREE
                                   AND LUP.SEGMENT2  = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE11
                           )
                           AND RC.YYYYMMDD >= T_VER.RESULT_FROM
                           AND RC.YYYYMMDD < T_VER.RESULT_TO
                           UNION ALL
                           SELECT 1 FROM SCM_MGR.DM_PLN_SALES_PLAN_C PC
                               INNER JOIN SCM_MGR.GT_DM74_TEMP_VERSION_NO T_VER
                                   ON PC.DIVISION_ID = T_VER.DIVISION_ID
                                   AND PC.VERSION_NO = T_VER.VERSION_NO
                               INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM SI--[PJ2024-50461] CURRENCY 처리 위해 조인 추가
                                   ON SI.DIVISION_ID  = PC.DIVISION_ID
                                   AND SI.PROJECT_CODE = PC.PROJECT_CODE
                                   AND SI.SCM_SITE_ID  = PC.SCM_SITE_ID
                                   AND SI.ITEM_ID      = PC.ITEM_ID
                                   AND SI.VALID_YN     = 'Y'
                           WHERE PC.DIVISION_ID = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE1
                           --[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교
                           --AND PC.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                           AND PC.PROJECT_CODE = CASE WHEN PC.DIVISION_ID = '40' THEN GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE4 ELSE GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE5 END
                           --[PJ2024-50611]소형일 경우 ATTRIBUTE4(END_CUSTOMER)로 비교. 나머지는 ATTRIBUTE5(PROJECT_CODE)로 비교
                           AND PC.ITEM_ID     = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE7
                           AND PC.SCM_SITE_ID = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE9
                           AND NVL(PC.CURRENCY, SI.CURRENCY) /*[E20260816-NULLFIX] 폴백 사문화 정정*/ = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE10--[PJ2024-50461] CURRENCY가 없을 경우 SSPM의 값을 가져옴
                           AND FCST_TYPE IN
                           (
                               SELECT LUP.SEGMENT1
                               FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
                               WHERE LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                   AND LUP.VALID_YN  = 'Y'
                                   AND LUP.SEGMENT4 <> 'FREE'----FCST_TYPE_NOT_FREE
                                   AND LUP.SEGMENT2  = GT_DM74_TMP_EXCEL_UPLOAD_RAW.ATTRIBUTE11
                           )
                           --[PJ2024-50461]날짜 조건 추가
                           AND PC.YYYYMMDD >= T_VER.RESULT_TO
                           AND PC.YYYYMMDD <= T_VER.PLAN_TO
                          );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C19';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = Invalid Sales Plan Waterfall MODEL  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* Metal Link  체크                   */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid Metal Link.'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
          AND  UPPER(ATTRIBUTE8) NOT IN ('Y', 'N');
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C20';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = Metal Link 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------


        /* #################################################### */
        /* EXCEPTION  체크                    */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid EXCEPTION.'
        WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
          AND  NVL(ATTRIBUTE12, '@#@#@#') <> '@#@#@#' /*[E20260816-NULLFIX] ''=NULL 사문화 정정*/
          AND  UPPER(ATTRIBUTE12) NOT IN ('Y', 'N');
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C24';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = EXCEPTION 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 광물의 값이 미사용 / 미연동 일 경우 입력금지       */
        /*
        ATTRIBUTE14 = 'Ni'    : Period(Fr) = 21 / Period(To) = 28 / Contract Price(/kg) = 35  / Change Price(/kg) = 42  / Metal Index (kg/Biz type) = 49
        ATTRIBUTE15 = 'Co'    : Period(Fr) = 22 / Period(To) = 29 / Contract Price(/kg) = 36  / Change Price(/kg) = 43  / Metal Index (kg/Biz type) = 50
        ATTRIBUTE16 = 'Li2CO3'  : Period(Fr) = 23 / Period(To) = 30 / Contract Price(/kg) = 37  / Change Price(/kg) = 44  / Metal Index (kg/Biz type) = 51
        ATTRIBUTE17 = 'LIOH'  : Period(Fr) = 24 / Period(To) = 31 / Contract Price(/kg) = 38  / Change Price(/kg) = 45  / Metal Index (kg/Biz type) = 52
        ATTRIBUTE18 = 'Al'    : Period(Fr) = 25 / Period(To) = 32 / Contract Price(/kg) = 39  / Change Price(/kg) = 46  / Metal Index (kg/Biz type) = 53
        ATTRIBUTE19 = 'Mn'    : Period(Fr) = 26 / Period(To) = 33 / Contract Price(/kg) = 40  / Change Price(/kg) = 47  / Metal Index (kg/Biz type) = 54
        ATTRIBUTE20 = 'Cu'    : Period(Fr) = 27 / Period(To) = 34 / Contract Price(/kg) = 41  / Change Price(/kg) = 48  / Metal Index (kg/Biz type) = 55  */
        /* #################################################### */
        --룩업에 등록된 미사용 / 미연동 코드값 저장
        INSERT INTO SCM_MGR.GT_DM74_TMP_NOTUSE_CODE
              (NOTUSE_CODE)
        SELECT SEGMENT3 AS NOTUSE_CODE
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL METAL_KEY_MN
        WHERE METAL_KEY_MN.LOOKUP_TYPE = 'METAL_KEY_VALUE'
        AND VALID_YN = 'Y'
        AND SEGMENT4 IN ('미사용', '미연동');
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C25';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 룩업에 등록된 미사용 / 미연동 코드값  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Ni : '
                                 || CASE WHEN NVL(ATTRIBUTE21,'@#@#@#') <> '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE28,'@#@#@#') <> '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE35,'@#@#@#') <> '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE42,'@#@#@#') <> '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE49,'@#@#@#') <> '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
           AND (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#') /*[E20260816-NULLFIX] 형제블록 표준식 정합*/) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
           AND (
                    (
                        NVL(ATTRIBUTE14,'@#@#@#') = '@#@#@#'
                     OR ATTRIBUTE14 IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                    )
                    AND (   NVL(ATTRIBUTE21,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE28,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE35,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE42,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE49,'@#@#@#') <> '@#@#@#'
                        )
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C26';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Co : '
                                 || CASE WHEN NVL(ATTRIBUTE22,'@#@#@#') <> '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE29,'@#@#@#') <> '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE36,'@#@#@#') <> '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE43,'@#@#@#') <> '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE50,'@#@#@#') <> '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
         AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND   (
                    (
                        NVL(ATTRIBUTE15,'@#@#@#') = '@#@#@#'
                     OR ATTRIBUTE15 IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                    )
                    AND (   NVL(ATTRIBUTE22,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE29,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE36,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE43,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE50,'@#@#@#') <> '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C27';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Li2CO3 : '
                                 || CASE WHEN NVL(ATTRIBUTE23,'@#@#@#') <> '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE30,'@#@#@#') <> '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE37,'@#@#@#') <> '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE44,'@#@#@#') <> '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE51,'@#@#@#') <> '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
         AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND   (
                    (
                        NVL(ATTRIBUTE16,'@#@#@#') = '@#@#@#'
                     OR ATTRIBUTE16 IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                    )
                    AND (   NVL(ATTRIBUTE23,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE30,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE37,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE44,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE51,'@#@#@#') <> '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C28';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NEED EMPTY VALUE - LIOH : '
                                 || CASE WHEN NVL(ATTRIBUTE24,'@#@#@#') <> '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE31,'@#@#@#') <> '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE38,'@#@#@#') <> '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE45,'@#@#@#') <> '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE52,'@#@#@#') <> '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND   (
                    (
                        NVL(ATTRIBUTE17,'@#@#@#') = '@#@#@#'
                     OR ATTRIBUTE17 IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                    )
                    AND (   NVL(ATTRIBUTE24,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE31,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE38,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE45,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE52,'@#@#@#') <> '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C29';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Al : '
                                 || CASE WHEN NVL(ATTRIBUTE25,'@#@#@#') <> '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE32,'@#@#@#') <> '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE39,'@#@#@#') <> '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE46,'@#@#@#') <> '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE53,'@#@#@#') <> '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND   (
                    (
                        NVL(ATTRIBUTE18,'@#@#@#') = '@#@#@#'
                     OR ATTRIBUTE18 IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                    )
                    AND (   NVL(ATTRIBUTE25,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE32,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE39,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE46,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE53,'@#@#@#') <> '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C30';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Mn : '
                                 || CASE WHEN NVL(ATTRIBUTE26,'@#@#@#') <> '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE33,'@#@#@#') <> '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE40,'@#@#@#') <> '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE47,'@#@#@#') <> '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE54,'@#@#@#') <> '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND   (
                    (
                        NVL(ATTRIBUTE19,'@#@#@#') = '@#@#@#'
                     OR ATTRIBUTE19 IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                    )
                    AND (   NVL(ATTRIBUTE26,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE33,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE40,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE47,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE54,'@#@#@#') <> '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C31';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NEED EMPTY VALUE - Cu : '
                                 || CASE WHEN NVL(ATTRIBUTE27,'@#@#@#') <> '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE34,'@#@#@#') <> '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE41,'@#@#@#') <> '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE48,'@#@#@#') <> '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE55,'@#@#@#') <> '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND   (
                    (
                        NVL(ATTRIBUTE20,'@#@#@#') = '@#@#@#'
                     OR ATTRIBUTE20 IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                    )
                    AND (   NVL(ATTRIBUTE27,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE34,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE41,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE48,'@#@#@#') <> '@#@#@#'
                         OR NVL(ATTRIBUTE55,'@#@#@#') <> '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C32';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 각 광물별 입력값 체크
        광물의 값이 있고 미사용/미전송이 아닐 경우에, 쌍이되는 5개 항목 체크
        ATTRIBUTE14 = 'Ni'    : Period(Fr) = 21 / Period(To) = 28 / Contract Price(/kg) = 35  / Change Price(/kg) = 42  / Metal Index (kg/Biz type) = 49
        ATTRIBUTE15 = 'Co'    : Period(Fr) = 22 / Period(To) = 29 / Contract Price(/kg) = 36  / Change Price(/kg) = 43  / Metal Index (kg/Biz type) = 50
        ATTRIBUTE16 = 'Li2CO3'  : Period(Fr) = 23 / Period(To) = 30 / Contract Price(/kg) = 37  / Change Price(/kg) = 44  / Metal Index (kg/Biz type) = 51
        ATTRIBUTE17 = 'LIOH'  : Period(Fr) = 24 / Period(To) = 31 / Contract Price(/kg) = 38  / Change Price(/kg) = 45  / Metal Index (kg/Biz type) = 52
        ATTRIBUTE18 = 'Al'    : Period(Fr) = 25 / Period(To) = 32 / Contract Price(/kg) = 39  / Change Price(/kg) = 46  / Metal Index (kg/Biz type) = 53
        ATTRIBUTE19 = 'Mn'    : Period(Fr) = 26 / Period(To) = 33 / Contract Price(/kg) = 40  / Change Price(/kg) = 47  / Metal Index (kg/Biz type) = 54
        ATTRIBUTE20 = 'Cu'    : Period(Fr) = 27 / Period(To) = 34 / Contract Price(/kg) = 41  / Change Price(/kg) = 48  / Metal Index (kg/Biz type) = 55
        */
        /*[PJ2024-50461]81번 사업부는 광물 미입력 체크 안함*/
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NULL Ni : '
                                 || CASE WHEN NVL(ATTRIBUTE21,'@#@#@#') = '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE28,'@#@#@#') = '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE35,'@#@#@#') = '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE42,'@#@#@#') = '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE49,'@#@#@#') = '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND   SUBSTR(ATTRIBUTE1, 1, 2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND   (
                    NVL(ATTRIBUTE14, '@#@#@#') <> '@#@#@#'
                AND ATTRIBUTE14 NOT IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                AND (   NVL(ATTRIBUTE21,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE28,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE35,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE42,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE49,'@#@#@#') = '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C33';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NULL Co : '
                                 || CASE WHEN NVL(ATTRIBUTE22,'@#@#@#') = '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE29,'@#@#@#') = '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE36,'@#@#@#') = '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE43,'@#@#@#') = '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE50,'@#@#@#') = '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE  UPLOAD_STATUS_CODE = 'UPLOAD'
         AND    SUBSTR(ATTRIBUTE1, 1, 2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND   (
                    NVL(ATTRIBUTE15, '@#@#@#') <> '@#@#@#'
                AND ATTRIBUTE15 NOT IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                AND (   NVL(ATTRIBUTE22,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE29,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE36,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE43,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE50,'@#@#@#') = '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C34';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NULL Li2CO3 : '
                                 || CASE WHEN NVL(ATTRIBUTE23,'@#@#@#') = '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE30,'@#@#@#') = '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE37,'@#@#@#') = '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE44,'@#@#@#') = '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE51,'@#@#@#') = '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND   SUBSTR(ATTRIBUTE1, 1, 2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND   (
                    NVL(ATTRIBUTE16, '@#@#@#') <> '@#@#@#'
                AND ATTRIBUTE16 NOT IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                AND (   NVL(ATTRIBUTE23,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE30,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE37,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE44,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE51,'@#@#@#') = '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C35';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NULL LIOH : '
                                 || CASE WHEN NVL(ATTRIBUTE24,'@#@#@#') = '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE31,'@#@#@#') = '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE38,'@#@#@#') = '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE45,'@#@#@#') = '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE52,'@#@#@#') = '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND   SUBSTR(ATTRIBUTE1, 1, 2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND   (
                    NVL(ATTRIBUTE17, '@#@#@#') <> '@#@#@#'
                AND ATTRIBUTE17 NOT IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                AND (   NVL(ATTRIBUTE24,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE31,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE38,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE45,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE52,'@#@#@#') = '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C36';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NULL Al : '
                                 || CASE WHEN NVL(ATTRIBUTE25,'@#@#@#') = '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE32,'@#@#@#') = '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE39,'@#@#@#') = '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE46,'@#@#@#') = '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE53,'@#@#@#') = '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND   SUBSTR(ATTRIBUTE1, 1, 2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND
               (
                    NVL(ATTRIBUTE18, '@#@#@#') <> '@#@#@#'
                AND ATTRIBUTE18 NOT IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                AND (   NVL(ATTRIBUTE25,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE32,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE39,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE46,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE53,'@#@#@#') = '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C37';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NULL Mn : '
                                 || CASE WHEN NVL(ATTRIBUTE26,'@#@#@#') = '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE33,'@#@#@#') = '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE40,'@#@#@#') = '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE47,'@#@#@#') = '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE54,'@#@#@#') = '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND   SUBSTR(ATTRIBUTE1, 1, 2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND
               (
                    NVL(ATTRIBUTE19, '@#@#@#') <> '@#@#@#'
                AND ATTRIBUTE19 NOT IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                AND (   NVL(ATTRIBUTE26,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE33,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE40,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE47,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE54,'@#@#@#') = '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C38';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'NULL Cu : '
                                 || CASE WHEN NVL(ATTRIBUTE27,'@#@#@#') = '@#@#@#'  THEN 'Period(Fr) '
                                         WHEN NVL(ATTRIBUTE34,'@#@#@#') = '@#@#@#'  THEN 'Period(To) '
                                         WHEN NVL(ATTRIBUTE41,'@#@#@#') = '@#@#@#'  THEN 'Contract Price '
                                         WHEN NVL(ATTRIBUTE48,'@#@#@#') = '@#@#@#'  THEN 'Change Price '
                                         WHEN NVL(ATTRIBUTE55,'@#@#@#') = '@#@#@#'  THEN 'Metal Index (Fr) '
                                    END
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND   SUBSTR(ATTRIBUTE1, 1, 2) <> '81'--[PJ2024-50461]81_JV 사업부는 광물 미입력 체크 안함
         AND   (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND
               (
                    NVL(ATTRIBUTE20, '@#@#@#') <> '@#@#@#'
                 AND ATTRIBUTE20 NOT IN (SELECT NOTUSE_CODE FROM SCM_MGR.GT_DM74_TMP_NOTUSE_CODE)
                 AND (  NVL(ATTRIBUTE27,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE34,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE41,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE48,'@#@#@#') = '@#@#@#'
                     OR NVL(ATTRIBUTE55,'@#@#@#') = '@#@#@#')
               );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C39';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = NOTUSE_CODE 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 숫자여부 체크(ATTRIBUTE21 ~ ATTRIBUTE55)
            FROM_PERIOD_YYYYMM
            TO_PERIOD_YYYYMM
            CONTRACT_UNIT_PRICE
            METAL_APPLY_UNIT_PRICE
            METAL_REQR_QTY
        */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid NUMERIC.'
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND
           (
                (NVL(ATTRIBUTE21, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE21, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE22, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE22, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE23, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE23, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE24, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE24, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE25, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE25, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE26, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE26, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE27, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE27, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE28, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE28, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE29, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE29, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE30, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE30, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE31, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE31, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE32, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE32, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE33, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE33, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE34, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE34, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE35, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE35, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE36, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE36, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE37, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE37, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE38, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE38, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE39, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE39, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE40, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE40, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE41, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE41, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE42, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE42, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE43, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE43, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE44, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE44, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE45, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE45, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE46, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE46, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE47, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE47, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE48, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE48, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE49, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE49, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE50, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE50, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE51, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE51, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE52, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE52, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE53, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE53, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE54, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE54, '^-?[0-9]+(\.[0-9]+)?$')) OR
                (NVL(ATTRIBUTE55, '@#@#@#') <> '@#@#@#' AND NOT REGEXP_LIKE(ATTRIBUTE55, '^-?[0-9]+(\.[0-9]+)?$'))
           );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C40';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 숫자여부 체크 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 마이너스 여부 체크(ATTRIBUTE21 ~ ATTRIBUTE55)
            FROM_PERIOD_YYYYMM
            TO_PERIOD_YYYYMM
            CONTRACT_UNIT_PRICE
            METAL_APPLY_UNIT_PRICE
            METAL_REQR_QTY(Metal Index OR Cost Impact : 이름변경 필요?) =>음수체크 제외   (49 ~ 55)                   */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Negative Number.'
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND
           (
                (NVL(ATTRIBUTE21, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE21, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE21) < 0) OR
                (NVL(ATTRIBUTE22, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE22, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE22) < 0) OR
                (NVL(ATTRIBUTE23, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE23, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE23) < 0) OR
                (NVL(ATTRIBUTE24, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE24, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE24) < 0) OR
                (NVL(ATTRIBUTE25, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE25, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE25) < 0) OR
                (NVL(ATTRIBUTE26, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE26, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE26) < 0) OR
                (NVL(ATTRIBUTE27, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE27, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE27) < 0) OR
                (NVL(ATTRIBUTE28, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE28, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE28) < 0) OR
                (NVL(ATTRIBUTE29, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE29, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE29) < 0) OR
                (NVL(ATTRIBUTE30, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE30, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE30) < 0) OR
                (NVL(ATTRIBUTE31, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE31, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE31) < 0) OR
                (NVL(ATTRIBUTE32, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE32, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE32) < 0) OR
                (NVL(ATTRIBUTE33, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE33, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE33) < 0) OR
                (NVL(ATTRIBUTE34, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE34, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE34) < 0) OR
                (NVL(ATTRIBUTE35, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE35, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE35) < 0) OR
                (NVL(ATTRIBUTE36, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE36, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE36) < 0) OR
                (NVL(ATTRIBUTE37, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE37, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE37) < 0) OR
                (NVL(ATTRIBUTE38, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE38, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE38) < 0) OR
                (NVL(ATTRIBUTE39, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE39, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE39) < 0) OR
                (NVL(ATTRIBUTE40, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE40, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE40) < 0) OR
                (NVL(ATTRIBUTE41, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE41, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE41) < 0) OR
                (NVL(ATTRIBUTE42, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE42, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE42) < 0) OR
                (NVL(ATTRIBUTE43, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE43, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE43) < 0) OR
                (NVL(ATTRIBUTE44, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE44, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE44) < 0) OR
                (NVL(ATTRIBUTE45, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE45, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE45) < 0) OR
                (NVL(ATTRIBUTE46, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE46, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE46) < 0) OR
                (NVL(ATTRIBUTE47, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE47, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE47) < 0) OR
                (NVL(ATTRIBUTE48, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE48, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE48) < 0)
           );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C41';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 마이너스 여부 체크 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 0 ~ 12 여부 체크(ATTRIBUTE21 ~ ATTRIBUTE34)
            FROM_PERIOD_YYYYMM
            TO_PERIOD_YYYYMM
            정수만 입력가능
            1)12보다 큰가
            2).이 있나
            */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'Invalid INTEGER 0 ~ 12.'
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND
           (
                (NVL(ATTRIBUTE21, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE21, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE21) > 12 OR INSTR(ATTRIBUTE21, '.') > 0)) OR
                (NVL(ATTRIBUTE22, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE22, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE22) > 12 OR INSTR(ATTRIBUTE22, '.') > 0)) OR
                (NVL(ATTRIBUTE23, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE23, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE23) > 12 OR INSTR(ATTRIBUTE23, '.') > 0)) OR
                (NVL(ATTRIBUTE24, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE24, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE24) > 12 OR INSTR(ATTRIBUTE24, '.') > 0)) OR
                (NVL(ATTRIBUTE25, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE25, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE25) > 12 OR INSTR(ATTRIBUTE25, '.') > 0)) OR
                (NVL(ATTRIBUTE26, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE26, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE26) > 12 OR INSTR(ATTRIBUTE26, '.') > 0)) OR
                (NVL(ATTRIBUTE27, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE27, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE27) > 12 OR INSTR(ATTRIBUTE27, '.') > 0)) OR
                (NVL(ATTRIBUTE28, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE28, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE28) > 12 OR INSTR(ATTRIBUTE28, '.') > 0)) OR
                (NVL(ATTRIBUTE29, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE29, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE29) > 12 OR INSTR(ATTRIBUTE29, '.') > 0)) OR
                (NVL(ATTRIBUTE30, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE30, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE30) > 12 OR INSTR(ATTRIBUTE30, '.') > 0)) OR
                (NVL(ATTRIBUTE31, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE31, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE31) > 12 OR INSTR(ATTRIBUTE31, '.') > 0)) OR
                (NVL(ATTRIBUTE32, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE32, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE32) > 12 OR INSTR(ATTRIBUTE32, '.') > 0)) OR
                (NVL(ATTRIBUTE33, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE33, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE33) > 12 OR INSTR(ATTRIBUTE33, '.') > 0)) OR
                (NVL(ATTRIBUTE34, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE34, '^-?[0-9]+(\.[0-9]+)?$') AND (TO_NUMBER(ATTRIBUTE34) > 12 OR INSTR(ATTRIBUTE34, '.') > 0))
           );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C42';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 일자 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* Period(To) < Period(From) 체크(ATTRIBUTE21 ~ ATTRIBUTE34)
            From 이 커야 함
            쌍이 되는 ATTRIBUTE
            ATTRIBUTE21 : ATTRIBUTE28
            ATTRIBUTE22 : ATTRIBUTE29
            ATTRIBUTE23 : ATTRIBUTE30
            ATTRIBUTE24 : ATTRIBUTE31
            ATTRIBUTE25 : ATTRIBUTE32
            ATTRIBUTE26 : ATTRIBUTE33
            ATTRIBUTE27 : ATTRIBUTE34
            체크 로직 : 쌍이 되는 ATTRIBUTE 둘다 빈 값이 아니고, 둘 다 숫자이고, FROM VALUE <= TO VALUE 이면 튕겨냄
            */
        /* #################################################### */
        UPDATE SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW
           SET UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = 'From Value must be larger than To Value.'
         WHERE UPLOAD_STATUS_CODE = 'UPLOAD'
         AND  (ATTRIBUTE8 = 'Y' AND (ATTRIBUTE12 = 'N' OR NVL(ATTRIBUTE12,'@#@#@#') = '@#@#@#')) --[PJ2024-50461]Metal Link : Y 이고 EXCEPTION : N 일때만 체크
         AND
           (
                (NVL(ATTRIBUTE21, '@#@#@#') <> '@#@#@#' AND NVL(ATTRIBUTE28, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE21, '^-?[0-9]+(\.[0-9]+)?$') AND REGEXP_LIKE(ATTRIBUTE28, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE21) <= TO_NUMBER(ATTRIBUTE28)) OR
                (NVL(ATTRIBUTE22, '@#@#@#') <> '@#@#@#' AND NVL(ATTRIBUTE29, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE22, '^-?[0-9]+(\.[0-9]+)?$') AND REGEXP_LIKE(ATTRIBUTE29, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE22) <= TO_NUMBER(ATTRIBUTE29)) OR
                (NVL(ATTRIBUTE23, '@#@#@#') <> '@#@#@#' AND NVL(ATTRIBUTE30, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE23, '^-?[0-9]+(\.[0-9]+)?$') AND REGEXP_LIKE(ATTRIBUTE30, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE23) <= TO_NUMBER(ATTRIBUTE30)) OR
                (NVL(ATTRIBUTE24, '@#@#@#') <> '@#@#@#' AND NVL(ATTRIBUTE31, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE24, '^-?[0-9]+(\.[0-9]+)?$') AND REGEXP_LIKE(ATTRIBUTE31, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE24) <= TO_NUMBER(ATTRIBUTE31)) OR
                (NVL(ATTRIBUTE25, '@#@#@#') <> '@#@#@#' AND NVL(ATTRIBUTE32, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE25, '^-?[0-9]+(\.[0-9]+)?$') AND REGEXP_LIKE(ATTRIBUTE32, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE25) <= TO_NUMBER(ATTRIBUTE32)) OR
                (NVL(ATTRIBUTE26, '@#@#@#') <> '@#@#@#' AND NVL(ATTRIBUTE33, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE26, '^-?[0-9]+(\.[0-9]+)?$') AND REGEXP_LIKE(ATTRIBUTE33, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE26) <= TO_NUMBER(ATTRIBUTE33)) OR
                (NVL(ATTRIBUTE27, '@#@#@#') <> '@#@#@#' AND NVL(ATTRIBUTE34, '@#@#@#') <> '@#@#@#' AND REGEXP_LIKE(ATTRIBUTE27, '^-?[0-9]+(\.[0-9]+)?$') AND REGEXP_LIKE(ATTRIBUTE34, '^-?[0-9]+(\.[0-9]+)?$') AND TO_NUMBER(ATTRIBUTE27) <= TO_NUMBER(ATTRIBUTE34))
           );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C43';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = Period(To) < Period(From) 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        /* #################################################### */
        /* 소숫점 2자리 체크(ATTRIBUTE35 ~ ATTRIBUTE55)      */
        /* 체크 안하고 셋째 자리에서 반올림 처리해서 둘째자리까지 반영(2024.07.08 박필수 책임 확인)*/
        /* #################################################### */
        /*BEGIN ... END;*/

        -----------------------------------------------------------------------------------------------
        --[PJ2024-50611]VALIDATION 결과를 원본 테이블에 업데이트한다
        MERGE INTO SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
        USING SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_RAW TMP
        ON (T.UPLOAD_ID = TMP.UPLOAD_ID AND TMP.UPLOAD_STATUS_CODE = 'ERROR')
        WHEN MATCHED THEN
            UPDATE SET
            T.UPLOAD_STATUS_CODE = TMP.UPLOAD_STATUS_CODE,
            T.MESSAGE_TEXT = TMP.MESSAGE_TEXT;
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C44';
        V_LOG_MESSAGE := '########## VALIDATEION CHECK = 소숫점 2자리 체크  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------
        -----------------------------------------------------------------------------------------------

        -- 정상(SUCCESS) 처리
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SUCCESS'
        WHERE  PROGRAM_ID         LIKE V_PROGRAM_ID || '%'
        AND    SHEET_NAME         = V_SHEET_NAME
        AND    CREATED_BY         = P_CREATED_BY
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
        AND    UPLOAD_STATUS_CODE = 'UPLOAD';

        ----------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'C99';
        V_LOG_MESSAGE := '########## SUCCESS ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ----------------------------------------------------------------------------

    END IF;

    ------------------------------------- validation 로직 종료 ----------------------------------------------
    ------------------------------------- validation 로직 종료 ----------------------------------------------
    ------------------------------------- validation 로직 종료 ----------------------------------------------

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    N_LOG_COUNT   := SQL%ROWCOUNT;
    V_LOG_TYPE    := 'D1';
    V_LOG_MESSAGE := '########## INSERT DATA START ##########';
    V_DESCRIPTION := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ----------------------------------------------------------------------------

    --//======================================================================================
    SELECT COUNT(1)
    INTO   V_COUNT
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID          LIKE V_PROGRAM_ID || '%'
    AND    T.SHEET_NAME          = V_SHEET_NAME
    AND    T.CREATED_BY          = P_CREATED_BY
    AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
    AND    T.UPLOAD_STATUS_CODE  = 'ERROR';

    --실제 업무처리
    IF P_MODE > 0 AND V_COUNT = 0
    THEN
        --------------------------------------------------
        -- 1)엑셀 업로드용 TMP 테이블 생성 및 데이터 저장
        --------------------------------------------------
        --[PJ2024-50611]40번 사업부일 경우 컬럼을 2칸 조정 start
        INSERT INTO SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD
              (DIVISION_ID,PLAN_YYYYMM,END_CUSTOMER,PROJECT_CODE,ITEM_ID,METAL_LINK_YN,SCM_SITE_ID,CURRENCY,FCST_TYPE,METAL_EXCEPTION_YN,ENERGY
              ,APPLY_PRICE_TYPE_CODE1,APPLY_PRICE_TYPE_CODE2,APPLY_PRICE_TYPE_CODE3,APPLY_PRICE_TYPE_CODE4
              ,APPLY_PRICE_TYPE_CODE5,APPLY_PRICE_TYPE_CODE6,APPLY_PRICE_TYPE_CODE7
              ,FROM_PERIOD1,FROM_PERIOD2,FROM_PERIOD3,FROM_PERIOD4,FROM_PERIOD5,FROM_PERIOD6,FROM_PERIOD7
              ,TO_PERIOD1,TO_PERIOD2,TO_PERIOD3,TO_PERIOD4,TO_PERIOD5,TO_PERIOD6,TO_PERIOD7
              ,CONTRACT_UNIT1,CONTRACT_UNIT2,CONTRACT_UNIT3,CONTRACT_UNIT4,CONTRACT_UNIT5,CONTRACT_UNIT6,CONTRACT_UNIT7
              ,METAL_APPLY1,METAL_APPLY2,METAL_APPLY3,METAL_APPLY4,METAL_APPLY5,METAL_APPLY6,METAL_APPLY7
              ,METAL_REQR1,METAL_REQR2,METAL_REQR3,METAL_REQR4,METAL_REQR5,METAL_REQR6,METAL_REQR7
              )
        SELECT
               ATTRIBUTE1  --DIVISION_ID
              ,ATTRIBUTE2  --PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,ATTRIBUTE3  --DEPT_NAME
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,ATTRIBUTE4  --End Customer
              ,CASE WHEN ATTRIBUTE1 = '40' THEN '' ELSE ATTRIBUTE5 END  --Project Code(소형사업부는 공백처리)
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE5 ELSE ATTRIBUTE7 END  --MODEL Code
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE6 ELSE ATTRIBUTE8 END  --Metal Link
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE7 ELSE ATTRIBUTE9 END  --Sales Site
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE8 ELSE ATTRIBUTE10 END  --Currency
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE9 ELSE ATTRIBUTE11 END  --FCST type
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE10 ELSE ATTRIBUTE12 END  --Exception
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE11 ELSE ATTRIBUTE13 END  --Energy
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE12 ELSE ATTRIBUTE14 END  --Ni     APPLY_PRICE_TYPE_CODE1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE13 ELSE ATTRIBUTE15 END  --Co     APPLY_PRICE_TYPE_CODE2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE14 ELSE ATTRIBUTE16 END  --Li2CO3 APPLY_PRICE_TYPE_CODE3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE15 ELSE ATTRIBUTE17 END  --LIOH   APPLY_PRICE_TYPE_CODE4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE16 ELSE ATTRIBUTE18 END  --Al     APPLY_PRICE_TYPE_CODE5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE17 ELSE ATTRIBUTE19 END  --Mn     APPLY_PRICE_TYPE_CODE6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE18 ELSE ATTRIBUTE20 END  --Cu     APPLY_PRICE_TYPE_CODE7
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE19 ELSE ATTRIBUTE21 END  --Ni     FROM_PERIOD1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE20 ELSE ATTRIBUTE22 END  --Co     FROM_PERIOD2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE21 ELSE ATTRIBUTE23 END  --Li2CO3 FROM_PERIOD3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE22 ELSE ATTRIBUTE24 END  --LIOH   FROM_PERIOD4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE23 ELSE ATTRIBUTE25 END  --Al     FROM_PERIOD5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE24 ELSE ATTRIBUTE26 END  --Mn     FROM_PERIOD6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE25 ELSE ATTRIBUTE27 END  --Cu     FROM_PERIOD7
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE26 ELSE ATTRIBUTE28 END  --Ni     TO_PERIOD1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE27 ELSE ATTRIBUTE29 END  --Co     TO_PERIOD2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE28 ELSE ATTRIBUTE30 END  --Li2CO3 TO_PERIOD3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE29 ELSE ATTRIBUTE31 END  --LIOH   TO_PERIOD4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE30 ELSE ATTRIBUTE32 END  --Al     TO_PERIOD5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE31 ELSE ATTRIBUTE33 END  --Mn     TO_PERIOD6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE32 ELSE ATTRIBUTE34 END  --Cu     TO_PERIOD7
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE33 ELSE ATTRIBUTE35 END  --Ni     CONTRACT_UNIT1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE34 ELSE ATTRIBUTE36 END  --Co     CONTRACT_UNIT2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE35 ELSE ATTRIBUTE37 END  --Li2CO3 CONTRACT_UNIT3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE36 ELSE ATTRIBUTE38 END  --LIOH   CONTRACT_UNIT4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE37 ELSE ATTRIBUTE39 END  --Al     CONTRACT_UNIT5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE38 ELSE ATTRIBUTE40 END  --Mn     CONTRACT_UNIT6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE39 ELSE ATTRIBUTE41 END  --Cu     CONTRACT_UNIT7
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE40 ELSE ATTRIBUTE42 END  --Ni     METAL_APPLY1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE41 ELSE ATTRIBUTE43 END  --Co     METAL_APPLY2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE42 ELSE ATTRIBUTE44 END  --Li2CO3 METAL_APPLY3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE43 ELSE ATTRIBUTE45 END  --LIOH   METAL_APPLY4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE44 ELSE ATTRIBUTE46 END  --Al     METAL_APPLY5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE45 ELSE ATTRIBUTE47 END  --Mn     METAL_APPLY6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE46 ELSE ATTRIBUTE48 END  --Cu     METAL_APPLY7
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE47 ELSE ATTRIBUTE49 END  --Ni     METAL_REQR1
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE48 ELSE ATTRIBUTE50 END  --Co     METAL_REQR2
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE49 ELSE ATTRIBUTE51 END  --Li2CO3 METAL_REQR3
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE50 ELSE ATTRIBUTE52 END  --LIOH   METAL_REQR4
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE51 ELSE ATTRIBUTE53 END  --Al     METAL_REQR5
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE52 ELSE ATTRIBUTE54 END  --Mn     METAL_REQR6
              ,CASE WHEN ATTRIBUTE1 = '40' THEN ATTRIBUTE53 ELSE ATTRIBUTE55 END  --Cu     METAL_REQR7
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        WHERE  1 = 1
        AND    PROGRAM_ID    LIKE V_PROGRAM_ID || '%'
        AND    SHEET_NAME    = V_SHEET_NAME
        AND    CREATED_BY    = P_CREATED_BY
        AND    UPLOAD_STATUS_CODE = 'SUCCESS'
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE;
        --[PJ2024-50611]40번 사업부일 경우 컬럼을 2칸 조정 end
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D2';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_EXCEL_UPLOAD  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --2)동일 PJT에 속한 모든 ITEMID 가져오기
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DM74_TEMP_SP_ITEM
              (DIVISION_ID,VERSION_NO,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP
              ,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY)
        SELECT DISTINCT PC.DIVISION_ID, PC.VERSION_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
                      , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, PC.YYYYMMDD, CURRENCY
        FROM SCM_MGR.DM_PLN_SALES_PLAN_C PC
            INNER JOIN SCM_MGR.GT_DM74_TEMP_VERSION_NO T_VER
                ON PC.DIVISION_ID = T_VER.DIVISION_ID
                AND PC.VERSION_NO = T_VER.VERSION_NO
        WHERE PC.QTY <> 0
        AND PC.MEASURE = 'RTF_SYS_RP'
        --[PJ2024-50461]버전의 날짜로 처리
        AND PC.YYYYMMDD >= T_VER.RESULT_TO
        AND PC.YYYYMMDD <= T_VER.PLAN_TO
        UNION ALL
        SELECT DISTINCT RC.DIVISION_ID, RC.VERSION_NO, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
                      , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, RC.YYYYMMDD, CURRENCY
        FROM SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C RC
            INNER JOIN SCM_MGR.GT_DM74_TEMP_VERSION_NO T_VER
                ON RC.DIVISION_ID = T_VER.DIVISION_ID
                AND RC.VERSION_NO = T_VER.VERSION_NO
        WHERE RC.QTY <> 0
        AND RC.MEASURE = 'RTF_SYS_RP'
        --[PJ2024-50461]버전의 날짜로 처리
        AND RC.YYYYMMDD >= T_VER.RESULT_FROM
        AND RC.YYYYMMDD < T_VER.RESULT_TO;
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D3';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TEMP_SP_ITEM  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --2-1)ITEMID 없는것 처리(전체)
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL
              (DIVISION_ID,PLAN_YYYYMM,END_CUSTOMER,PROJECT_CODE,PLANT_SITE_ID,ITEM_ID,METAL_LINK_YN,SCM_SITE_ID,CURRENCY,FCST_TYPE,METAL_EXCEPTION_YN,ENERGY
              ,APPLY_PRICE_TYPE_CODE1,APPLY_PRICE_TYPE_CODE2,APPLY_PRICE_TYPE_CODE3,APPLY_PRICE_TYPE_CODE4
              ,APPLY_PRICE_TYPE_CODE5,APPLY_PRICE_TYPE_CODE6,APPLY_PRICE_TYPE_CODE7
              ,FROM_PERIOD1,FROM_PERIOD2,FROM_PERIOD3,FROM_PERIOD4,FROM_PERIOD5,FROM_PERIOD6,FROM_PERIOD7
              ,TO_PERIOD1,TO_PERIOD2,TO_PERIOD3,TO_PERIOD4,TO_PERIOD5,TO_PERIOD6,TO_PERIOD7
              ,CONTRACT_UNIT1,CONTRACT_UNIT2,CONTRACT_UNIT3,CONTRACT_UNIT4,CONTRACT_UNIT5,CONTRACT_UNIT6,CONTRACT_UNIT7
              ,METAL_APPLY1,METAL_APPLY2,METAL_APPLY3,METAL_APPLY4,METAL_APPLY5,METAL_APPLY6,METAL_APPLY7
              ,METAL_REQR1,METAL_REQR2,METAL_REQR3,METAL_REQR4,METAL_REQR5,METAL_REQR6,METAL_REQR7
              )
        SELECT
               TMP.DIVISION_ID
              ,TMP.PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,DI.DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,TMP.END_CUSTOMER
              --[PJ2024-50611]40 사업부는 프로젝트 코드 공백처리
              --,TMP.PROJECT_CODE
              , CASE WHEN TMP.DIVISION_ID = '40' THEN '' ELSE TMP.PROJECT_CODE END AS PROJECT_CODE
              --[PJ2024-50611]40 사업부는 프로젝트 코드 공백처리
              ,ITM.SALES_PLANT AS PLANT_SITE_ID
              ,ITM.ITEM_ID
              ,TMP.METAL_LINK_YN
              ,TMP.SCM_SITE_ID
              ,TMP.CURRENCY
              ,LUP.SEGMENT1 FCST_TYPE
              ,TMP.METAL_EXCEPTION_YN
              ,TMP.ENERGY
              ,TMP.APPLY_PRICE_TYPE_CODE1
              ,TMP.APPLY_PRICE_TYPE_CODE2
              ,TMP.APPLY_PRICE_TYPE_CODE3
              ,TMP.APPLY_PRICE_TYPE_CODE4
              ,TMP.APPLY_PRICE_TYPE_CODE5
              ,TMP.APPLY_PRICE_TYPE_CODE6
              ,TMP.APPLY_PRICE_TYPE_CODE7
              ,TMP.FROM_PERIOD1
              ,TMP.FROM_PERIOD2
              ,TMP.FROM_PERIOD3
              ,TMP.FROM_PERIOD4
              ,TMP.FROM_PERIOD5
              ,TMP.FROM_PERIOD6
              ,TMP.FROM_PERIOD7
              ,TMP.TO_PERIOD1
              ,TMP.TO_PERIOD2
              ,TMP.TO_PERIOD3
              ,TMP.TO_PERIOD4
              ,TMP.TO_PERIOD5
              ,TMP.TO_PERIOD6
              ,TMP.TO_PERIOD7
              ,TMP.CONTRACT_UNIT1
              ,TMP.CONTRACT_UNIT2
              ,TMP.CONTRACT_UNIT3
              ,TMP.CONTRACT_UNIT4
              ,TMP.CONTRACT_UNIT5
              ,TMP.CONTRACT_UNIT6
              ,TMP.CONTRACT_UNIT7
              ,TMP.METAL_APPLY1
              ,TMP.METAL_APPLY2
              ,TMP.METAL_APPLY3
              ,TMP.METAL_APPLY4
              ,TMP.METAL_APPLY5
              ,TMP.METAL_APPLY6
              ,TMP.METAL_APPLY7
              ,TMP.METAL_REQR1
              ,TMP.METAL_REQR2
              ,TMP.METAL_REQR3
              ,TMP.METAL_REQR4
              ,TMP.METAL_REQR5
              ,TMP.METAL_REQR6
              ,TMP.METAL_REQR7
          FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD TMP
          INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM ITM
              ON ITM.DIVISION_ID = TMP.DIVISION_ID
              --[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교
              --AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
              AND ITM.PROJECT_CODE = CASE WHEN TMP.DIVISION_ID = '40' THEN TMP.END_CUSTOMER ELSE TMP.PROJECT_CODE END
              --[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교
              AND ITM.SCM_SITE_ID = TMP.SCM_SITE_ID
              AND ITM.VALID_YN    = 'Y'
          --[PJ2024-50461] 40번 사업부 외 적용하던 로직 제거 start
          /*INNER JOIN SCM_MST_SITE S
              ON S.DIVISION_ID   = TMP.DIVISION_ID
              AND S.SCM_SITE_ID  = TMP.SCM_SITE_ID
              AND S.SITE_TYPE    = 'SALES'
              AND S.VALID_YN     = 'Y'
          inner JOIN SCM_MST_SSO_DEPT_INFO DI
              ON  DI.DEPT_ID = S.DEPT_ID
              AND DI.DEPT_NAME_KO = TMP.DEPT_NAME
              AND DI.VALID_YN = 'Y'*/
          --[PJ2024-50461] 40번 사업부 외 적용하던 로직 제거 end
          --FCST type
          INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
              ON LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
              AND LUP.VALID_YN   = 'Y'
              AND LUP.SEGMENT4  <> 'FREE'----FCST_TYPE_NOT_FREE
              AND LUP.SEGMENT2   = TMP.FCST_TYPE
              --[PJ2024-50461]업로드 대상은 '제품(P)'만 해당
          INNER JOIN SCM_MGR.GT_DM74_TEMP_MST_ITEM SV
          ON SV.DIVISION_ID = ITM.DIVISION_ID
          AND SV.ITEM_ID    = ITM.ITEM_ID
        WHERE NVL(TMP.ITEM_ID, '@#@#@#') = '@#@#@#'
        --[PJ2024-50461]Sales Plan Waterfall 에 있는 아이템만 적용되어야 함 start
        AND ITM.ITEM_ID IN
        (
            SELECT ITEM_ID FROM SCM_MGR.GT_DM74_TEMP_SP_ITEM PC
            WHERE PC.DIVISION_ID = TMP.DIVISION_ID
            --[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교
            --AND PROJECT_CODE = TMP.PROJECT_CODE
            AND PROJECT_CODE = CASE WHEN TMP.DIVISION_ID = '40' THEN TMP.END_CUSTOMER ELSE TMP.PROJECT_CODE END
            --[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교
            AND SCM_SITE_ID = TMP.SCM_SITE_ID
            AND CURRENCY    = TMP.CURRENCY
            AND FCST_TYPE   = LUP.SEGMENT1
        )
        --[PJ2024-50461]Sales Plan Waterfall 에 있는 아이템만 적용되어야 함 end
        AND (
            --[PJ2024-50461]82번 사업부는 에너지 있는 모델만 추출 start
                (TMP.DIVISION_ID = '82' AND ITM.ITEM_ID IN
                    (
                        SELECT ITEM_ID FROM SCM_MGR.GT_DM74_TEMP_MST_ITEM_ENERGY
                    )
                ) OR
                (TMP.DIVISION_ID <> '82')
            --[PJ2024-50461]82번 사업부는 에너지 있는 모델만 추출 end
        );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D4';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_EXCEL_UPLOAD_FINAL  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --2-2)ITEMID 있는것 처리
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_ITEM
              (DIVISION_ID,PLAN_YYYYMM,END_CUSTOMER,PROJECT_CODE,PLANT_SITE_ID,ITEM_ID,METAL_LINK_YN,SCM_SITE_ID,CURRENCY,FCST_TYPE,METAL_EXCEPTION_YN,ENERGY
              ,APPLY_PRICE_TYPE_CODE1,APPLY_PRICE_TYPE_CODE2,APPLY_PRICE_TYPE_CODE3,APPLY_PRICE_TYPE_CODE4
              ,APPLY_PRICE_TYPE_CODE5,APPLY_PRICE_TYPE_CODE6,APPLY_PRICE_TYPE_CODE7
              ,FROM_PERIOD1,FROM_PERIOD2,FROM_PERIOD3,FROM_PERIOD4,FROM_PERIOD5,FROM_PERIOD6,FROM_PERIOD7
              ,TO_PERIOD1,TO_PERIOD2,TO_PERIOD3,TO_PERIOD4,TO_PERIOD5,TO_PERIOD6,TO_PERIOD7
              ,CONTRACT_UNIT1,CONTRACT_UNIT2,CONTRACT_UNIT3,CONTRACT_UNIT4,CONTRACT_UNIT5,CONTRACT_UNIT6,CONTRACT_UNIT7
              ,METAL_APPLY1,METAL_APPLY2,METAL_APPLY3,METAL_APPLY4,METAL_APPLY5,METAL_APPLY6,METAL_APPLY7
              ,METAL_REQR1,METAL_REQR2,METAL_REQR3,METAL_REQR4,METAL_REQR5,METAL_REQR6,METAL_REQR7
              )
        SELECT
               TMP.DIVISION_ID
              ,TMP.PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,DI.DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,TMP.END_CUSTOMER
              --[PJ2024-50611]40 사업부는 프로젝트 코드 공백처리
              --,TMP.PROJECT_CODE
              , CASE WHEN TMP.DIVISION_ID = '40' THEN '' ELSE TMP.PROJECT_CODE END AS PROJECT_CODE
              --[PJ2024-50611]40 사업부는 프로젝트 코드 공백처리
              ,ITM.SALES_PLANT AS PLANT_SITE_ID
              ,ITM.ITEM_ID
              ,TMP.METAL_LINK_YN
              ,TMP.SCM_SITE_ID
              ,TMP.CURRENCY
              ,LUP.SEGMENT1 FCST_TYPE
              ,TMP.METAL_EXCEPTION_YN
              ,TMP.ENERGY
              ,TMP.APPLY_PRICE_TYPE_CODE1
              ,TMP.APPLY_PRICE_TYPE_CODE2
              ,TMP.APPLY_PRICE_TYPE_CODE3
              ,TMP.APPLY_PRICE_TYPE_CODE4
              ,TMP.APPLY_PRICE_TYPE_CODE5
              ,TMP.APPLY_PRICE_TYPE_CODE6
              ,TMP.APPLY_PRICE_TYPE_CODE7
              ,TMP.FROM_PERIOD1
              ,TMP.FROM_PERIOD2
              ,TMP.FROM_PERIOD3
              ,TMP.FROM_PERIOD4
              ,TMP.FROM_PERIOD5
              ,TMP.FROM_PERIOD6
              ,TMP.FROM_PERIOD7
              ,TMP.TO_PERIOD1
              ,TMP.TO_PERIOD2
              ,TMP.TO_PERIOD3
              ,TMP.TO_PERIOD4
              ,TMP.TO_PERIOD5
              ,TMP.TO_PERIOD6
              ,TMP.TO_PERIOD7
              ,TMP.CONTRACT_UNIT1
              ,TMP.CONTRACT_UNIT2
              ,TMP.CONTRACT_UNIT3
              ,TMP.CONTRACT_UNIT4
              ,TMP.CONTRACT_UNIT5
              ,TMP.CONTRACT_UNIT6
              ,TMP.CONTRACT_UNIT7
              ,TMP.METAL_APPLY1
              ,TMP.METAL_APPLY2
              ,TMP.METAL_APPLY3
              ,TMP.METAL_APPLY4
              ,TMP.METAL_APPLY5
              ,TMP.METAL_APPLY6
              ,TMP.METAL_APPLY7
              ,TMP.METAL_REQR1
              ,TMP.METAL_REQR2
              ,TMP.METAL_REQR3
              ,TMP.METAL_REQR4
              ,TMP.METAL_REQR5
              ,TMP.METAL_REQR6
              ,TMP.METAL_REQR7
        FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD TMP
        INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM ITM
            ON ITM.DIVISION_ID = TMP.DIVISION_ID
            --[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교
            --AND ITM.PROJECT_CODE = TMP.PROJECT_CODE
            AND ITM.PROJECT_CODE = CASE WHEN TMP.DIVISION_ID = '40' THEN TMP.END_CUSTOMER ELSE TMP.PROJECT_CODE END
            --[PJ2024-50611]소형일 경우 END_CUSTOMER(ATTRIBUTE4)로 비교. 나머지는 PROJECT_CODE(ATTRIBUTE5)로 비교
            AND ITM.SCM_SITE_ID = TMP.SCM_SITE_ID
            AND ITM.ITEM_ID     = TMP.ITEM_ID
            AND ITM.VALID_YN    = 'Y'
        --[PJ2024-50461] 40번 사업부 외 적용하던 로직 제거 start
        /*INNER JOIN SCM_MST_SITE S
            ON S.DIVISION_ID   = TMP.DIVISION_ID
            AND S.SCM_SITE_ID  = TMP.SCM_SITE_ID
            AND S.SITE_TYPE    = 'SALES'
            AND S.VALID_YN     = 'Y'
        inner JOIN SCM_MST_SSO_DEPT_INFO DI
            ON  DI.DEPT_ID = S.DEPT_ID
            AND DI.DEPT_NAME_KO = TMP.DEPT_NAME
            AND DI.VALID_YN = 'Y'*/
        --[PJ2024-50461] 40번 사업부 외 적용하던 로직 제거 end
        --FCST type
        INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LUP
            ON LUP.LOOKUP_TYPE = 'SALES_TYPE_CODE'
            AND LUP.VALID_YN   = 'Y'
            AND LUP.SEGMENT4  <> 'FREE'----FCST_TYPE_NOT_FREE
            AND LUP.SEGMENT2   = TMP.FCST_TYPE
            --[PJ2024-50461]업로드 대상은 '제품(P)'만 해당
        INNER JOIN SCM_MGR.GT_DM74_TEMP_MST_ITEM SV
        ON SV.DIVISION_ID = ITM.DIVISION_ID
        AND SV.ITEM_ID    = ITM.ITEM_ID;
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D5';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_EXCEL_UPLOAD_ITEM  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --2-3)합치기
        -------------------------------------------------------------------------
        MERGE INTO SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL A
        USING SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_ITEM B
           ON (
                  A.DIVISION_ID   = B.DIVISION_ID
              AND A.PLAN_YYYYMM   = B.PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --AND A.DEPT_ID = B.DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              AND A.END_CUSTOMER  = B.END_CUSTOMER
              AND A.PROJECT_CODE  = B.PROJECT_CODE
              AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
              AND A.ITEM_ID       = B.ITEM_ID
              AND A.SCM_SITE_ID   = B.SCM_SITE_ID
              AND A.CURRENCY      = B.CURRENCY
              AND A.FCST_TYPE     = B.FCST_TYPE
              )
        WHEN MATCHED THEN
            UPDATE SET
                A.METAL_LINK_YN           = B.METAL_LINK_YN
                ,A.METAL_EXCEPTION_YN     = B.METAL_EXCEPTION_YN
                ,A.ENERGY                 = B.ENERGY
                ,A.APPLY_PRICE_TYPE_CODE1 = CASE WHEN NVL(B.APPLY_PRICE_TYPE_CODE1,'@#@#@#') = '@#@#@#' THEN A.APPLY_PRICE_TYPE_CODE1 ELSE B.APPLY_PRICE_TYPE_CODE1 END
                ,A.APPLY_PRICE_TYPE_CODE2 = CASE WHEN NVL(B.APPLY_PRICE_TYPE_CODE2,'@#@#@#') = '@#@#@#' THEN A.APPLY_PRICE_TYPE_CODE2 ELSE B.APPLY_PRICE_TYPE_CODE2 END
                ,A.APPLY_PRICE_TYPE_CODE3 = CASE WHEN NVL(B.APPLY_PRICE_TYPE_CODE3,'@#@#@#') = '@#@#@#' THEN A.APPLY_PRICE_TYPE_CODE3 ELSE B.APPLY_PRICE_TYPE_CODE3 END
                ,A.APPLY_PRICE_TYPE_CODE4 = CASE WHEN NVL(B.APPLY_PRICE_TYPE_CODE4,'@#@#@#') = '@#@#@#' THEN A.APPLY_PRICE_TYPE_CODE4 ELSE B.APPLY_PRICE_TYPE_CODE4 END
                ,A.APPLY_PRICE_TYPE_CODE5 = CASE WHEN NVL(B.APPLY_PRICE_TYPE_CODE5,'@#@#@#') = '@#@#@#' THEN A.APPLY_PRICE_TYPE_CODE5 ELSE B.APPLY_PRICE_TYPE_CODE5 END
                ,A.APPLY_PRICE_TYPE_CODE6 = CASE WHEN NVL(B.APPLY_PRICE_TYPE_CODE6,'@#@#@#') = '@#@#@#' THEN A.APPLY_PRICE_TYPE_CODE6 ELSE B.APPLY_PRICE_TYPE_CODE6 END
                ,A.APPLY_PRICE_TYPE_CODE7 = CASE WHEN NVL(B.APPLY_PRICE_TYPE_CODE7,'@#@#@#') = '@#@#@#' THEN A.APPLY_PRICE_TYPE_CODE7 ELSE B.APPLY_PRICE_TYPE_CODE7 END
                ,A.FROM_PERIOD1           = CASE WHEN NVL(B.FROM_PERIOD1          ,'@#@#@#') = '@#@#@#' THEN A.FROM_PERIOD1 ELSE B.FROM_PERIOD1 END
                ,A.FROM_PERIOD2           = CASE WHEN NVL(B.FROM_PERIOD2          ,'@#@#@#') = '@#@#@#' THEN A.FROM_PERIOD2 ELSE B.FROM_PERIOD2 END
                ,A.FROM_PERIOD3           = CASE WHEN NVL(B.FROM_PERIOD3          ,'@#@#@#') = '@#@#@#' THEN A.FROM_PERIOD3 ELSE B.FROM_PERIOD3 END
                ,A.FROM_PERIOD4           = CASE WHEN NVL(B.FROM_PERIOD4          ,'@#@#@#') = '@#@#@#' THEN A.FROM_PERIOD4 ELSE B.FROM_PERIOD4 END
                ,A.FROM_PERIOD5           = CASE WHEN NVL(B.FROM_PERIOD5          ,'@#@#@#') = '@#@#@#' THEN A.FROM_PERIOD5 ELSE B.FROM_PERIOD5 END
                ,A.FROM_PERIOD6           = CASE WHEN NVL(B.FROM_PERIOD6          ,'@#@#@#') = '@#@#@#' THEN A.FROM_PERIOD6 ELSE B.FROM_PERIOD6 END
                ,A.FROM_PERIOD7           = CASE WHEN NVL(B.FROM_PERIOD7          ,'@#@#@#') = '@#@#@#' THEN A.FROM_PERIOD7 ELSE B.FROM_PERIOD7 END
                ,A.TO_PERIOD1             = CASE WHEN NVL(B.TO_PERIOD1            ,'@#@#@#') = '@#@#@#' THEN A.TO_PERIOD1 ELSE B.TO_PERIOD1 END
                ,A.TO_PERIOD2             = CASE WHEN NVL(B.TO_PERIOD2            ,'@#@#@#') = '@#@#@#' THEN A.TO_PERIOD2 ELSE B.TO_PERIOD2 END
                ,A.TO_PERIOD3             = CASE WHEN NVL(B.TO_PERIOD3            ,'@#@#@#') = '@#@#@#' THEN A.TO_PERIOD3 ELSE B.TO_PERIOD3 END
                ,A.TO_PERIOD4             = CASE WHEN NVL(B.TO_PERIOD4            ,'@#@#@#') = '@#@#@#' THEN A.TO_PERIOD4 ELSE B.TO_PERIOD4 END
                ,A.TO_PERIOD5             = CASE WHEN NVL(B.TO_PERIOD5            ,'@#@#@#') = '@#@#@#' THEN A.TO_PERIOD5 ELSE B.TO_PERIOD5 END
                ,A.TO_PERIOD6             = CASE WHEN NVL(B.TO_PERIOD6            ,'@#@#@#') = '@#@#@#' THEN A.TO_PERIOD6 ELSE B.TO_PERIOD6 END
                ,A.TO_PERIOD7             = CASE WHEN NVL(B.TO_PERIOD7            ,'@#@#@#') = '@#@#@#' THEN A.TO_PERIOD7 ELSE B.TO_PERIOD7 END
                ,A.CONTRACT_UNIT1         = CASE WHEN NVL(B.CONTRACT_UNIT1        ,'@#@#@#') = '@#@#@#' THEN A.CONTRACT_UNIT1 ELSE B.CONTRACT_UNIT1 END
                ,A.CONTRACT_UNIT2         = CASE WHEN NVL(B.CONTRACT_UNIT2        ,'@#@#@#') = '@#@#@#' THEN A.CONTRACT_UNIT2 ELSE B.CONTRACT_UNIT2 END
                ,A.CONTRACT_UNIT3         = CASE WHEN NVL(B.CONTRACT_UNIT3        ,'@#@#@#') = '@#@#@#' THEN A.CONTRACT_UNIT3 ELSE B.CONTRACT_UNIT3 END
                ,A.CONTRACT_UNIT4         = CASE WHEN NVL(B.CONTRACT_UNIT4        ,'@#@#@#') = '@#@#@#' THEN A.CONTRACT_UNIT4 ELSE B.CONTRACT_UNIT4 END
                ,A.CONTRACT_UNIT5         = CASE WHEN NVL(B.CONTRACT_UNIT5        ,'@#@#@#') = '@#@#@#' THEN A.CONTRACT_UNIT5 ELSE B.CONTRACT_UNIT5 END
                ,A.CONTRACT_UNIT6         = CASE WHEN NVL(B.CONTRACT_UNIT6        ,'@#@#@#') = '@#@#@#' THEN A.CONTRACT_UNIT6 ELSE B.CONTRACT_UNIT6 END
                ,A.CONTRACT_UNIT7         = CASE WHEN NVL(B.CONTRACT_UNIT7        ,'@#@#@#') = '@#@#@#' THEN A.CONTRACT_UNIT7 ELSE B.CONTRACT_UNIT7 END
                ,A.METAL_APPLY1           = CASE WHEN NVL(B.METAL_APPLY1          ,'@#@#@#') = '@#@#@#' THEN A.METAL_APPLY1 ELSE B.METAL_APPLY1 END
                ,A.METAL_APPLY2           = CASE WHEN NVL(B.METAL_APPLY2          ,'@#@#@#') = '@#@#@#' THEN A.METAL_APPLY2 ELSE B.METAL_APPLY2 END
                ,A.METAL_APPLY3           = CASE WHEN NVL(B.METAL_APPLY3          ,'@#@#@#') = '@#@#@#' THEN A.METAL_APPLY3 ELSE B.METAL_APPLY3 END
                ,A.METAL_APPLY4           = CASE WHEN NVL(B.METAL_APPLY4          ,'@#@#@#') = '@#@#@#' THEN A.METAL_APPLY4 ELSE B.METAL_APPLY4 END
                ,A.METAL_APPLY5           = CASE WHEN NVL(B.METAL_APPLY5          ,'@#@#@#') = '@#@#@#' THEN A.METAL_APPLY5 ELSE B.METAL_APPLY5 END
                ,A.METAL_APPLY6           = CASE WHEN NVL(B.METAL_APPLY6          ,'@#@#@#') = '@#@#@#' THEN A.METAL_APPLY6 ELSE B.METAL_APPLY6 END
                ,A.METAL_APPLY7           = CASE WHEN NVL(B.METAL_APPLY7          ,'@#@#@#') = '@#@#@#' THEN A.METAL_APPLY7 ELSE B.METAL_APPLY7 END
                ,A.METAL_REQR1            = CASE WHEN NVL(B.METAL_REQR1           ,'@#@#@#') = '@#@#@#' THEN A.METAL_REQR1 ELSE B.METAL_REQR1 END
                ,A.METAL_REQR2            = CASE WHEN NVL(B.METAL_REQR2           ,'@#@#@#') = '@#@#@#' THEN A.METAL_REQR2 ELSE B.METAL_REQR2 END
                ,A.METAL_REQR3            = CASE WHEN NVL(B.METAL_REQR3           ,'@#@#@#') = '@#@#@#' THEN A.METAL_REQR3 ELSE B.METAL_REQR3 END
                ,A.METAL_REQR4            = CASE WHEN NVL(B.METAL_REQR4           ,'@#@#@#') = '@#@#@#' THEN A.METAL_REQR4 ELSE B.METAL_REQR4 END
                ,A.METAL_REQR5            = CASE WHEN NVL(B.METAL_REQR5           ,'@#@#@#') = '@#@#@#' THEN A.METAL_REQR5 ELSE B.METAL_REQR5 END
                ,A.METAL_REQR6            = CASE WHEN NVL(B.METAL_REQR6           ,'@#@#@#') = '@#@#@#' THEN A.METAL_REQR6 ELSE B.METAL_REQR6 END
                ,A.METAL_REQR7            = CASE WHEN NVL(B.METAL_REQR7           ,'@#@#@#') = '@#@#@#' THEN A.METAL_REQR7 ELSE B.METAL_REQR7 END
        WHEN NOT MATCHED THEN
            INSERT
            (
                DIVISION_ID              ,
                PLAN_YYYYMM              ,
                --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
                --DEPT_ID                ,
                --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
                END_CUSTOMER             ,
                PROJECT_CODE             ,
                PLANT_SITE_ID            ,
                ITEM_ID                  ,
                METAL_LINK_YN            ,
                SCM_SITE_ID              ,
                CURRENCY                 ,
                FCST_TYPE                ,
                METAL_EXCEPTION_YN       ,
                ENERGY                   ,
                APPLY_PRICE_TYPE_CODE1   ,
                APPLY_PRICE_TYPE_CODE2   ,
                APPLY_PRICE_TYPE_CODE3   ,
                APPLY_PRICE_TYPE_CODE4   ,
                APPLY_PRICE_TYPE_CODE5   ,
                APPLY_PRICE_TYPE_CODE6   ,
                APPLY_PRICE_TYPE_CODE7   ,
                FROM_PERIOD1             ,
                FROM_PERIOD2             ,
                FROM_PERIOD3             ,
                FROM_PERIOD4             ,
                FROM_PERIOD5             ,
                FROM_PERIOD6             ,
                FROM_PERIOD7             ,
                TO_PERIOD1               ,
                TO_PERIOD2               ,
                TO_PERIOD3               ,
                TO_PERIOD4               ,
                TO_PERIOD5               ,
                TO_PERIOD6               ,
                TO_PERIOD7               ,
                CONTRACT_UNIT1           ,
                CONTRACT_UNIT2           ,
                CONTRACT_UNIT3           ,
                CONTRACT_UNIT4           ,
                CONTRACT_UNIT5           ,
                CONTRACT_UNIT6           ,
                CONTRACT_UNIT7           ,
                METAL_APPLY1             ,
                METAL_APPLY2             ,
                METAL_APPLY3             ,
                METAL_APPLY4             ,
                METAL_APPLY5             ,
                METAL_APPLY6             ,
                METAL_APPLY7             ,
                --METAL_REQR
                METAL_REQR1              ,
                METAL_REQR2              ,
                METAL_REQR3              ,
                METAL_REQR4              ,
                METAL_REQR5              ,
                METAL_REQR6              ,
                METAL_REQR7
            )
            VALUES
            (
                B.DIVISION_ID            ,
                B.PLAN_YYYYMM            ,
                --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
                --B.DEPT_ID              ,
                --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
                B.END_CUSTOMER           ,
                B.PROJECT_CODE           ,
                B.PLANT_SITE_ID          ,
                B.ITEM_ID                ,
                B.METAL_LINK_YN          ,
                B.SCM_SITE_ID            ,
                B.CURRENCY               ,
                B.FCST_TYPE              ,
                B.METAL_EXCEPTION_YN     ,
                B.ENERGY                 ,
                B.APPLY_PRICE_TYPE_CODE1 ,
                B.APPLY_PRICE_TYPE_CODE2 ,
                B.APPLY_PRICE_TYPE_CODE3 ,
                B.APPLY_PRICE_TYPE_CODE4 ,
                B.APPLY_PRICE_TYPE_CODE5 ,
                B.APPLY_PRICE_TYPE_CODE6 ,
                B.APPLY_PRICE_TYPE_CODE7 ,
                B.FROM_PERIOD1           ,
                B.FROM_PERIOD2           ,
                B.FROM_PERIOD3           ,
                B.FROM_PERIOD4           ,
                B.FROM_PERIOD5           ,
                B.FROM_PERIOD6           ,
                B.FROM_PERIOD7           ,
                B.TO_PERIOD1             ,
                B.TO_PERIOD2             ,
                B.TO_PERIOD3             ,
                B.TO_PERIOD4             ,
                B.TO_PERIOD5             ,
                B.TO_PERIOD6             ,
                B.TO_PERIOD7             ,
                B.CONTRACT_UNIT1         ,
                B.CONTRACT_UNIT2         ,
                B.CONTRACT_UNIT3         ,
                B.CONTRACT_UNIT4         ,
                B.CONTRACT_UNIT5         ,
                B.CONTRACT_UNIT6         ,
                B.CONTRACT_UNIT7         ,
                B.METAL_APPLY1           ,
                B.METAL_APPLY2           ,
                B.METAL_APPLY3           ,
                B.METAL_APPLY4           ,
                B.METAL_APPLY5           ,
                B.METAL_APPLY6           ,
                B.METAL_APPLY7           ,
                B.METAL_REQR1            ,
                B.METAL_REQR2            ,
                B.METAL_REQR3            ,
                B.METAL_REQR4            ,
                B.METAL_REQR5            ,
                B.METAL_REQR6            ,
                B.METAL_REQR7
            );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D6';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_EXCEL_UPLOAD_FINAL  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------
        -------------------------------------------------------------------------
        --UNPIVOT 위한 GT_DM74_TMP_EXCEL_UPLOAD_FINAL 완성
        -------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --3) 각 그룹 별 UNPIVOT
        /*(
            APPLY_PRICE_TYPE_CODE,
            FROM_PERIOD_YYYYMM,
            TO_PERIOD_YYYYMM,
            CONTRACT_UNIT_PRICE,
            METAL_APPLY_UNIT_PRICE
        )
        */
        -------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --3-1) APPLY_PRICE_TYPE UNPIVOT
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DM74_TMP_APPLY_PRICE_TYPE
              (DIVISION_ID
              ,PLAN_YYYYMM
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,METAL_KIND_CODE
              ,APPLY_PRICE_TYPE_CODE
              )
        SELECT
               DIVISION_ID
              ,PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,CASE METAL_KIND_CODE_COL
                    WHEN 'APPLY_PRICE_TYPE_CODE1' THEN 'Ni'
                    WHEN 'APPLY_PRICE_TYPE_CODE2' THEN 'Co'
                    WHEN 'APPLY_PRICE_TYPE_CODE3' THEN 'Li2CO3'
                    WHEN 'APPLY_PRICE_TYPE_CODE4' THEN 'LIOH'
                    WHEN 'APPLY_PRICE_TYPE_CODE5' THEN 'Al'
                    WHEN 'APPLY_PRICE_TYPE_CODE6' THEN 'Mn'
                    WHEN 'APPLY_PRICE_TYPE_CODE7' THEN 'Cu'
                END METAL_KIND_CODE
              ,APPLY_PRICE_TYPE_CODE
        FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL
        UNPIVOT
        (
            APPLY_PRICE_TYPE_CODE FOR METAL_KIND_CODE_COL IN (
                APPLY_PRICE_TYPE_CODE1, APPLY_PRICE_TYPE_CODE2, APPLY_PRICE_TYPE_CODE3,
                APPLY_PRICE_TYPE_CODE4, APPLY_PRICE_TYPE_CODE5, APPLY_PRICE_TYPE_CODE6,
                APPLY_PRICE_TYPE_CODE7
            )
        );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D8';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_APPLY_PRICE_TYPE  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --3-2) FROM_PERIOD UNPIVOT
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DM74_TMP_FROM_PERIOD
              (DIVISION_ID
              ,PLAN_YYYYMM
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,METAL_KIND_CODE
              ,FROM_PERIOD
              )
        SELECT
               DIVISION_ID
              ,PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,CASE METAL_KIND_CODE_COL
                    WHEN 'FROM_PERIOD1' THEN 'Ni'
                    WHEN 'FROM_PERIOD2' THEN 'Co'
                    WHEN 'FROM_PERIOD3' THEN 'Li2CO3'
                    WHEN 'FROM_PERIOD4' THEN 'LIOH'
                    WHEN 'FROM_PERIOD5' THEN 'Al'
                    WHEN 'FROM_PERIOD6' THEN 'Mn'
                    WHEN 'FROM_PERIOD7' THEN 'Cu'
                END METAL_KIND_CODE
              ,FROM_PERIOD
        FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL
        UNPIVOT
        (
            FROM_PERIOD FOR METAL_KIND_CODE_COL IN (
                FROM_PERIOD1, FROM_PERIOD2, FROM_PERIOD3, FROM_PERIOD4, FROM_PERIOD5, FROM_PERIOD6, FROM_PERIOD7
            )
        );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D9';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_FROM_PERIOD  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --3-3) TO_PERIOD UNPIVOT
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DM74_TMP_TO_PERIOD
              (DIVISION_ID
              ,PLAN_YYYYMM
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,METAL_KIND_CODE
              ,TO_PERIOD
              )
        SELECT
               DIVISION_ID
              ,PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,CASE METAL_KIND_CODE_COL
                    WHEN 'TO_PERIOD1' THEN 'Ni'
                    WHEN 'TO_PERIOD2' THEN 'Co'
                    WHEN 'TO_PERIOD3' THEN 'Li2CO3'
                    WHEN 'TO_PERIOD4' THEN 'LIOH'
                    WHEN 'TO_PERIOD5' THEN 'Al'
                    WHEN 'TO_PERIOD6' THEN 'Mn'
                    WHEN 'TO_PERIOD7' THEN 'Cu'
                END METAL_KIND_CODE
              ,TO_PERIOD
        FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL
        UNPIVOT
        (
            TO_PERIOD FOR METAL_KIND_CODE_COL IN (
                TO_PERIOD1, TO_PERIOD2, TO_PERIOD3, TO_PERIOD4, TO_PERIOD5, TO_PERIOD6, TO_PERIOD7
            )
        );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D10';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_TO_PERIOD  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --3-4) CONTRACT_UNIT UNPIVOT
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DM74_TMP_CONTRACT_UNIT
              (DIVISION_ID
              ,PLAN_YYYYMM
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,METAL_KIND_CODE
              ,CONTRACT_UNIT
              )
        SELECT
               DIVISION_ID
              ,PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,CASE METAL_KIND_CODE_COL
                    WHEN 'CONTRACT_UNIT1' THEN 'Ni'
                    WHEN 'CONTRACT_UNIT2' THEN 'Co'
                    WHEN 'CONTRACT_UNIT3' THEN 'Li2CO3'
                    WHEN 'CONTRACT_UNIT4' THEN 'LIOH'
                    WHEN 'CONTRACT_UNIT5' THEN 'Al'
                    WHEN 'CONTRACT_UNIT6' THEN 'Mn'
                    WHEN 'CONTRACT_UNIT7' THEN 'Cu'
                END METAL_KIND_CODE
              ,CONTRACT_UNIT
        FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL
        UNPIVOT
        (
            CONTRACT_UNIT FOR METAL_KIND_CODE_COL IN (
                CONTRACT_UNIT1, CONTRACT_UNIT2, CONTRACT_UNIT3, CONTRACT_UNIT4, CONTRACT_UNIT5, CONTRACT_UNIT6, CONTRACT_UNIT7
            )
        );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D11';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_CONTRACT_UNIT  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --3-5) METAL_APPLY UNPIVOT
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DM74_TMP_METAL_APPLY
              (DIVISION_ID
              ,PLAN_YYYYMM
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,METAL_KIND_CODE
              ,METAL_APPLY
              )
        SELECT
               DIVISION_ID
              ,PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,CASE METAL_KIND_CODE_COL
                    WHEN 'METAL_APPLY1' THEN 'Ni'
                    WHEN 'METAL_APPLY2' THEN 'Co'
                    WHEN 'METAL_APPLY3' THEN 'Li2CO3'
                    WHEN 'METAL_APPLY4' THEN 'LIOH'
                    WHEN 'METAL_APPLY5' THEN 'Al'
                    WHEN 'METAL_APPLY6' THEN 'Mn'
                    WHEN 'METAL_APPLY7' THEN 'Cu'
                END METAL_KIND_CODE
              ,METAL_APPLY
        FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL
        UNPIVOT
        (
            METAL_APPLY FOR METAL_KIND_CODE_COL IN (
                METAL_APPLY1, METAL_APPLY2, METAL_APPLY3, METAL_APPLY4, METAL_APPLY5, METAL_APPLY6, METAL_APPLY7
            )
        );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D12';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_METAL_APPLY  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --3-6) METAL_APPLY UNPIVOT
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DM74_TMP_METAL_REQR
              (DIVISION_ID
              ,PLAN_YYYYMM
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,METAL_KIND_CODE
              ,METAL_REQR
              )
        SELECT
               DIVISION_ID
              ,PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,CASE METAL_KIND_CODE_COL
                    WHEN 'METAL_REQR1' THEN 'Ni'
                    WHEN 'METAL_REQR2' THEN 'Co'
                    WHEN 'METAL_REQR3' THEN 'Li2CO3'
                    WHEN 'METAL_REQR4' THEN 'LIOH'
                    WHEN 'METAL_REQR5' THEN 'Al'
                    WHEN 'METAL_REQR6' THEN 'Mn'
                    WHEN 'METAL_REQR7' THEN 'Cu'
                END METAL_KIND_CODE
              ,METAL_REQR
        FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD_FINAL
        UNPIVOT
        (
            METAL_REQR FOR METAL_KIND_CODE_COL IN (
                METAL_REQR1, METAL_REQR2, METAL_REQR3, METAL_REQR4, METAL_REQR5, METAL_REQR6, METAL_REQR7
            )
        );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D13';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_METAL_REQR  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --3-7)합치기
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE
              (DIVISION_ID
              ,PLAN_YYYYMM
              ,END_CUSTOMER
              ,PROJECT_CODE
              ,PLANT_SITE_ID
              ,ITEM_ID
              ,METAL_LINK_YN
              ,SCM_SITE_ID
              ,CURRENCY
              ,FCST_TYPE
              ,METAL_EXCEPTION_YN
              ,ENERGY
              ,METAL_KIND_CODE
              ,APPLY_PRICE_TYPE_CODE
              ,FROM_PERIOD
              ,TO_PERIOD
              ,CONTRACT_UNIT
              ,METAL_APPLY
              ,METAL_REQR
              ,VERSION_NO
              )
        SELECT
               APPLY_PRICE_TYPE.DIVISION_ID
              ,APPLY_PRICE_TYPE.PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --,APPLY_PRICE_TYPE.DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              ,APPLY_PRICE_TYPE.END_CUSTOMER
              ,APPLY_PRICE_TYPE.PROJECT_CODE
              ,APPLY_PRICE_TYPE.PLANT_SITE_ID
              ,APPLY_PRICE_TYPE.ITEM_ID
              ,APPLY_PRICE_TYPE.METAL_LINK_YN
              ,APPLY_PRICE_TYPE.SCM_SITE_ID
              ,APPLY_PRICE_TYPE.CURRENCY
              ,APPLY_PRICE_TYPE.FCST_TYPE
              ,APPLY_PRICE_TYPE.METAL_EXCEPTION_YN
              ,ROUND(TO_NUMBER(APPLY_PRICE_TYPE.ENERGY), 3) ENERGY
              ,APPLY_PRICE_TYPE.METAL_KIND_CODE
              ,APPLY_PRICE_TYPE.APPLY_PRICE_TYPE_CODE
              ,FROM_PERIOD.FROM_PERIOD
              ,TO_PERIOD.TO_PERIOD
              --셋째 자리에서 반올림 처리
              ,ROUND(TO_NUMBER(CONTRACT_UNIT.CONTRACT_UNIT), 2) CONTRACT_UNIT
              ,ROUND(TO_NUMBER(METAL_APPLY.METAL_APPLY), 2) METAL_APPLY
              ,ROUND(TO_NUMBER(METAL_REQR.METAL_REQR), 2) METAL_REQR
              ,T_VER.VERSION_NO
        FROM SCM_MGR.GT_DM74_TMP_APPLY_PRICE_TYPE APPLY_PRICE_TYPE
        INNER JOIN SCM_MGR.GT_DM74_TMP_FROM_PERIOD FROM_PERIOD
            ON APPLY_PRICE_TYPE.DIVISION_ID          = FROM_PERIOD.DIVISION_ID
            AND APPLY_PRICE_TYPE.PLAN_YYYYMM          = FROM_PERIOD.PLAN_YYYYMM
            --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
            --AND APPLY_PRICE_TYPE.DEPT_ID             = FROM_PERIOD.DEPT_ID
            --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
            AND APPLY_PRICE_TYPE.END_CUSTOMER         = FROM_PERIOD.END_CUSTOMER
            AND NVL(APPLY_PRICE_TYPE.PROJECT_CODE,'@#@#@#')         = NVL(FROM_PERIOD.PROJECT_CODE,'@#@#@#')
            AND NVL(APPLY_PRICE_TYPE.PLANT_SITE_ID,'@#@#@#')        = NVL(FROM_PERIOD.PLANT_SITE_ID,'@#@#@#')
            AND APPLY_PRICE_TYPE.ITEM_ID              = FROM_PERIOD.ITEM_ID
            AND APPLY_PRICE_TYPE.METAL_LINK_YN        = FROM_PERIOD.METAL_LINK_YN
            AND APPLY_PRICE_TYPE.SCM_SITE_ID          = FROM_PERIOD.SCM_SITE_ID
            AND APPLY_PRICE_TYPE.CURRENCY             = FROM_PERIOD.CURRENCY
            AND APPLY_PRICE_TYPE.FCST_TYPE            = FROM_PERIOD.FCST_TYPE
            AND APPLY_PRICE_TYPE.METAL_EXCEPTION_YN   = FROM_PERIOD.METAL_EXCEPTION_YN
            AND NVL(APPLY_PRICE_TYPE.ENERGY,'@#@#@#') = NVL(FROM_PERIOD.ENERGY,'@#@#@#')
            AND APPLY_PRICE_TYPE.METAL_KIND_CODE      = FROM_PERIOD.METAL_KIND_CODE
        INNER JOIN SCM_MGR.GT_DM74_TMP_TO_PERIOD TO_PERIOD
            ON APPLY_PRICE_TYPE.DIVISION_ID          = TO_PERIOD.DIVISION_ID
            AND APPLY_PRICE_TYPE.PLAN_YYYYMM          = TO_PERIOD.PLAN_YYYYMM
            --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
            --AND APPLY_PRICE_TYPE.DEPT_ID             = TO_PERIOD.DEPT_ID
            --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
            AND APPLY_PRICE_TYPE.END_CUSTOMER         = TO_PERIOD.END_CUSTOMER
            AND NVL(APPLY_PRICE_TYPE.PROJECT_CODE,'@#@#@#')         = NVL(TO_PERIOD.PROJECT_CODE,'@#@#@#')
            AND NVL(APPLY_PRICE_TYPE.PLANT_SITE_ID,'@#@#@#')        = NVL(TO_PERIOD.PLANT_SITE_ID,'@#@#@#')
            AND APPLY_PRICE_TYPE.ITEM_ID              = TO_PERIOD.ITEM_ID
            AND APPLY_PRICE_TYPE.METAL_LINK_YN        = TO_PERIOD.METAL_LINK_YN
            AND APPLY_PRICE_TYPE.SCM_SITE_ID          = TO_PERIOD.SCM_SITE_ID
            AND APPLY_PRICE_TYPE.CURRENCY             = TO_PERIOD.CURRENCY
            AND APPLY_PRICE_TYPE.FCST_TYPE            = TO_PERIOD.FCST_TYPE
            AND APPLY_PRICE_TYPE.METAL_EXCEPTION_YN   = TO_PERIOD.METAL_EXCEPTION_YN
            AND NVL(APPLY_PRICE_TYPE.ENERGY,'@#@#@#') = NVL(TO_PERIOD.ENERGY,'@#@#@#')
            AND APPLY_PRICE_TYPE.METAL_KIND_CODE      = TO_PERIOD.METAL_KIND_CODE
        INNER JOIN SCM_MGR.GT_DM74_TMP_CONTRACT_UNIT CONTRACT_UNIT
            ON APPLY_PRICE_TYPE.DIVISION_ID          = CONTRACT_UNIT.DIVISION_ID
            AND APPLY_PRICE_TYPE.PLAN_YYYYMM          = CONTRACT_UNIT.PLAN_YYYYMM
            --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
            --AND APPLY_PRICE_TYPE.DEPT_ID             = CONTRACT_UNIT.DEPT_ID
            --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
            AND APPLY_PRICE_TYPE.END_CUSTOMER         = CONTRACT_UNIT.END_CUSTOMER
            AND NVL(APPLY_PRICE_TYPE.PROJECT_CODE,'@#@#@#')         = NVL(CONTRACT_UNIT.PROJECT_CODE,'@#@#@#')
            AND NVL(APPLY_PRICE_TYPE.PLANT_SITE_ID,'@#@#@#')        = NVL(CONTRACT_UNIT.PLANT_SITE_ID,'@#@#@#')
            AND APPLY_PRICE_TYPE.ITEM_ID              = CONTRACT_UNIT.ITEM_ID
            AND APPLY_PRICE_TYPE.METAL_LINK_YN        = CONTRACT_UNIT.METAL_LINK_YN
            AND APPLY_PRICE_TYPE.SCM_SITE_ID          = CONTRACT_UNIT.SCM_SITE_ID
            AND APPLY_PRICE_TYPE.CURRENCY             = CONTRACT_UNIT.CURRENCY
            AND APPLY_PRICE_TYPE.FCST_TYPE            = CONTRACT_UNIT.FCST_TYPE
            AND APPLY_PRICE_TYPE.METAL_EXCEPTION_YN   = CONTRACT_UNIT.METAL_EXCEPTION_YN
            AND NVL(APPLY_PRICE_TYPE.ENERGY,'@#@#@#') = NVL(CONTRACT_UNIT.ENERGY,'@#@#@#')
            AND APPLY_PRICE_TYPE.METAL_KIND_CODE      = CONTRACT_UNIT.METAL_KIND_CODE
        INNER JOIN SCM_MGR.GT_DM74_TMP_METAL_APPLY METAL_APPLY
            ON APPLY_PRICE_TYPE.DIVISION_ID          = METAL_APPLY.DIVISION_ID
            AND APPLY_PRICE_TYPE.PLAN_YYYYMM          = METAL_APPLY.PLAN_YYYYMM
            --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
            --AND APPLY_PRICE_TYPE.DEPT_ID             = METAL_APPLY.DEPT_ID
            --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
            AND APPLY_PRICE_TYPE.END_CUSTOMER         = METAL_APPLY.END_CUSTOMER
            AND NVL(APPLY_PRICE_TYPE.PROJECT_CODE,'@#@#@#')         = NVL(METAL_APPLY.PROJECT_CODE,'@#@#@#')
            AND NVL(APPLY_PRICE_TYPE.PLANT_SITE_ID,'@#@#@#')        = NVL(METAL_APPLY.PLANT_SITE_ID,'@#@#@#')
            AND APPLY_PRICE_TYPE.ITEM_ID              = METAL_APPLY.ITEM_ID
            AND APPLY_PRICE_TYPE.METAL_LINK_YN        = METAL_APPLY.METAL_LINK_YN
            AND APPLY_PRICE_TYPE.SCM_SITE_ID          = METAL_APPLY.SCM_SITE_ID
            AND APPLY_PRICE_TYPE.CURRENCY             = METAL_APPLY.CURRENCY
            AND APPLY_PRICE_TYPE.FCST_TYPE            = METAL_APPLY.FCST_TYPE
            AND APPLY_PRICE_TYPE.METAL_EXCEPTION_YN   = METAL_APPLY.METAL_EXCEPTION_YN
            AND NVL(APPLY_PRICE_TYPE.ENERGY,'@#@#@#') = NVL(METAL_APPLY.ENERGY,'@#@#@#')
            AND APPLY_PRICE_TYPE.METAL_KIND_CODE      = METAL_APPLY.METAL_KIND_CODE
        INNER JOIN SCM_MGR.GT_DM74_TMP_METAL_REQR METAL_REQR
            ON APPLY_PRICE_TYPE.DIVISION_ID          = METAL_REQR.DIVISION_ID
            AND APPLY_PRICE_TYPE.PLAN_YYYYMM          = METAL_REQR.PLAN_YYYYMM
            --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
            --AND APPLY_PRICE_TYPE.DEPT_ID             = METAL_REQR.DEPT_ID
            --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
            AND APPLY_PRICE_TYPE.END_CUSTOMER         = METAL_REQR.END_CUSTOMER
            AND NVL(APPLY_PRICE_TYPE.PROJECT_CODE,'@#@#@#')         = NVL(METAL_REQR.PROJECT_CODE,'@#@#@#')
            AND NVL(APPLY_PRICE_TYPE.PLANT_SITE_ID,'@#@#@#')        = NVL(METAL_REQR.PLANT_SITE_ID,'@#@#@#')
            AND APPLY_PRICE_TYPE.ITEM_ID              = METAL_REQR.ITEM_ID
            AND APPLY_PRICE_TYPE.METAL_LINK_YN        = METAL_REQR.METAL_LINK_YN
            AND APPLY_PRICE_TYPE.SCM_SITE_ID          = METAL_REQR.SCM_SITE_ID
            AND APPLY_PRICE_TYPE.CURRENCY             = METAL_REQR.CURRENCY
            AND APPLY_PRICE_TYPE.FCST_TYPE            = METAL_REQR.FCST_TYPE
            AND APPLY_PRICE_TYPE.METAL_EXCEPTION_YN   = METAL_REQR.METAL_EXCEPTION_YN
            AND NVL(APPLY_PRICE_TYPE.ENERGY,'@#@#@#') = NVL(METAL_REQR.ENERGY,'@#@#@#')
            AND APPLY_PRICE_TYPE.METAL_KIND_CODE      = METAL_REQR.METAL_KIND_CODE
        INNER JOIN SCM_MGR.GT_DM74_TEMP_VERSION_NO T_VER--버전 정보 같이 저장(추후 TRACE 위해)
            ON T_VER.DIVISION_ID = APPLY_PRICE_TYPE.DIVISION_ID;
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D14';
        V_LOG_MESSAGE := '########## INSERT = GT_DM74_TMP_METAL_LINK_PRICE  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------
        -------------------------------------------------------------------------
        --UPLOAD용 UNPIVOT 데이터 완성
        -------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --4) DM_BPS_METAL_LINK_PRICE 저장
        -------------------------------------------------------------------------
        MERGE INTO SCM_MGR.DM_BPS_METAL_LINK_PRICE A
        USING SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE B
           ON (
                  A.DIVISION_ID      = B.DIVISION_ID
              AND A.PLAN_YYYYMM      = B.PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              --AND A.DEPT_ID = B.DEPT_ID
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 제거
              AND A.END_CUSTOMER     = B.END_CUSTOMER
              AND A.PROJECT_CODE     = NVL(B.PROJECT_CODE,'-')
              AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
              AND A.ITEM_ID          = B.ITEM_ID
              AND A.SCM_SITE_ID      = B.SCM_SITE_ID
              AND A.CURRENCY         = B.CURRENCY
              AND A.FCST_TYPE        = B.FCST_TYPE
              AND A.METAL_KIND_CODE  = B.METAL_KIND_CODE
              )
        WHEN MATCHED THEN
            UPDATE SET
                A.METAL_EXCEPTION_YN      = B.METAL_EXCEPTION_YN
                ,A.ENERGY                 = B.ENERGY
                ,A.METAL_LINK_YN          = B.METAL_LINK_YN
                ,A.APPLY_PRICE_TYPE_CODE  = B.APPLY_PRICE_TYPE_CODE
                ,A.FROM_PERIOD_YYYYMM     = B.FROM_PERIOD
                ,A.TO_PERIOD_YYYYMM       = B.TO_PERIOD
                ,A.CONTRACT_UNIT_PRICE    = B.CONTRACT_UNIT
                ,A.METAL_APPLY_UNIT_PRICE = B.METAL_APPLY
                ,A.METAL_REQR_QTY         = B.METAL_REQR
                ,A.LAST_UPDATED_BY        = P_CREATED_BY
                ,A.LAST_UPDATE_DATE       = SYSDATE
                ,A.ATTRIBUTE10            = B.VERSION_NO--버전 정보 같이 저장(추후 TRACE 위해)
        WHEN NOT MATCHED THEN
            INSERT
            (
                DIVISION_ID
               ,PLAN_YYYYMM
               ,DEPT_ID
               ,END_CUSTOMER
               ,PROJECT_CODE
               ,PLANT_SITE_ID
               ,ITEM_ID
               ,METAL_LINK_YN
               ,SCM_SITE_ID
               ,CURRENCY
               ,FCST_TYPE
               ,METAL_EXCEPTION_YN
               ,ENERGY
               ,METAL_KIND_CODE
               ,APPLY_PRICE_TYPE_CODE
               ,FROM_PERIOD_YYYYMM
               ,TO_PERIOD_YYYYMM
               ,CONTRACT_UNIT_PRICE
               ,METAL_APPLY_UNIT_PRICE
               ,METAL_REQR_QTY
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               ,ATTRIBUTE10
            )
            VALUES
            (
                B.DIVISION_ID
                ,B.PLAN_YYYYMM
                --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 공백저장
                --,B.DEPT_ID
                , '-'
                --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 공백저장
                ,B.END_CUSTOMER
                ,NVL(B.PROJECT_CODE,'-')
                ,B.PLANT_SITE_ID
                ,B.ITEM_ID
                ,B.METAL_LINK_YN
                ,B.SCM_SITE_ID
                ,B.CURRENCY
                ,B.FCST_TYPE
                ,B.METAL_EXCEPTION_YN
                ,B.ENERGY
                ,B.METAL_KIND_CODE
                ,B.APPLY_PRICE_TYPE_CODE
                ,B.FROM_PERIOD
                ,B.TO_PERIOD
                ,B.CONTRACT_UNIT
                ,B.METAL_APPLY
                ,B.METAL_REQR
                ,P_CREATED_BY
                ,SYSDATE
                ,P_CREATED_BY
                ,SYSDATE
                ,B.VERSION_NO
            );
        ------------------------------------------------------------------------
        N_LOG_COUNT   := SQL%ROWCOUNT;
        V_LOG_TYPE    := 'D15';
        V_LOG_MESSAGE := '########## INSERT = DM_BPS_METAL_LINK_PRICE  ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
        ------------------------------------------------------------------------

        -------------------------------------------------------------------------
        --5) DM_BPS_METAL_LINK_PRICE_H 저장
        -------------------------------------------------------------------------
        INSERT INTO SCM_MGR.DM_BPS_METAL_LINK_PRICE_H
               (
                DIVISION_ID
               ,PLAN_YYYYMM
               ,DEPT_ID
               ,END_CUSTOMER
               ,PROJECT_CODE
               ,PLANT_SITE_ID
               ,ITEM_ID
               ,METAL_LINK_YN
               ,SCM_SITE_ID
               ,CURRENCY
               ,FCST_TYPE
               ,METAL_EXCEPTION_YN
               ,ENERGY
               ,METAL_KIND_CODE
               ,APPLY_PRICE_TYPE_CODE
               ,FROM_PERIOD_YYYYMM
               ,TO_PERIOD_YYYYMM
               ,CONTRACT_UNIT_PRICE
               ,METAL_APPLY_UNIT_PRICE
               ,METAL_REQR_QTY
               ,CREATED_BY
               ,CREATION_DATE
               ,LAST_UPDATED_BY
               ,LAST_UPDATE_DATE
               ,ATTRIBUTE10
               )
        SELECT
               B.DIVISION_ID
              ,B.PLAN_YYYYMM
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 공백저장
              --,B.DEPT_ID
              , '-'
              --[PJ2024-50461] 메탈링크 업로드시 팀정보 관리 안하므로 공백저장
              ,B.END_CUSTOMER
              ,NVL(B.PROJECT_CODE,'-')
              ,B.PLANT_SITE_ID
              ,B.ITEM_ID
              ,B.METAL_LINK_YN
              ,B.SCM_SITE_ID
              ,B.CURRENCY
              ,B.FCST_TYPE
              ,B.METAL_EXCEPTION_YN
              ,B.ENERGY
              ,B.METAL_KIND_CODE
              ,B.APPLY_PRICE_TYPE_CODE
              ,B.FROM_PERIOD
              ,B.TO_PERIOD
              ,B.CONTRACT_UNIT
              ,B.METAL_APPLY
              ,B.METAL_REQR
              ,P_CREATED_BY
              ,SYSDATE
              ,P_CREATED_BY
              ,SYSDATE
              ,B.VERSION_NO
        FROM SCM_MGR.GT_DM74_TMP_METAL_LINK_PRICE B;

        N_LOG_COUNT := SQL%ROWCOUNT;

    END IF;

    COMMIT;

    ----------------------------------------------------------------------------
    --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## INSERT DATA END ##########';
    V_DESCRIPTION := TO_CHAR(P_MODE); --CONVERT(CHAR(30), @v_creation_date, 121);
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    ----------------------------------------------------------------------------

        /* [E20260827-D4-NOLOADGUARD] P_MODE>0 인데 실제로 아무것도 적재하지 않았으면 SUCCESS 를 돌려주지 않는다.
           1) 검증 오류 잔존(V_COUNT>0) -> IF 블록을 통째로 건너뛰므로 원장 delta 0 인데 CODE='0' 이 나가던 결함(D4).
           2) 적재 후보(Metal Link=Y, Exception<>Y, Key 1종 이상)가 있는데 이력 적재 0건 -> 조인 붕괴 = 허위 성공.
           (Metal Link=N 만 있는 파일은 후보 0 이라 종전대로 SUCCESS/EVENT=0 -- 설계상 적재 대상 없음)
           DMF0014 '허위성공 차단 (2)' 와 동일 계보. */
        IF NVL(P_MODE, 0) > 0 THEN
            IF NVL(V_COUNT, 0) > 0 THEN
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE
                     , 'ERR_RTN: - Validation errors remain (' || V_COUNT || ' rows) - nothing loaded' AS MSG
                     , 'NOLOAD_ERRORS' AS EVENT
                  FROM DUAL;
                RETURN;
            END IF;
            SELECT COUNT(*)
              INTO V_LOAD_CAND
              FROM SCM_MGR.GT_DM74_TMP_EXCEL_UPLOAD
             WHERE UPPER(METAL_LINK_YN) = 'Y'
               AND NVL(UPPER(METAL_EXCEPTION_YN), 'N') <> 'Y'
               AND (   APPLY_PRICE_TYPE_CODE1 IS NOT NULL OR APPLY_PRICE_TYPE_CODE2 IS NOT NULL OR APPLY_PRICE_TYPE_CODE3 IS NOT NULL
                    OR APPLY_PRICE_TYPE_CODE4 IS NOT NULL OR APPLY_PRICE_TYPE_CODE5 IS NOT NULL OR APPLY_PRICE_TYPE_CODE6 IS NOT NULL
                    OR APPLY_PRICE_TYPE_CODE7 IS NOT NULL );
            IF V_LOAD_CAND > 0 AND NVL(N_LOG_COUNT, 0) = 0 THEN
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE
                     , 'ERR_RTN: - Save verify failed (candidates=' || V_LOAD_CAND || ', loaded=0)' AS MSG
                     , 'SAVE_VERIFY' AS EVENT
                  FROM DUAL;
                RETURN;
            END IF;
        END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_MODE'        VALUE P_MODE,
            'P_CREATED_BY'  VALUE P_CREATED_BY
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || V_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0074_EXCEL_UPLOAD;

END PKG_DMF0074;
/
