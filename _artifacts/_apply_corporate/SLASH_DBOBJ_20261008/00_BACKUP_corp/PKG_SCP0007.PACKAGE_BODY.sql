PACKAGE BODY         PKG_SCP0007 IS

    -- =========================================================================================
    -- GET: Division/Site 별 Country/City (AS-IS SCP0007_GET_COUNTRY_CITY 1:1)
    -- =========================================================================================
    PROCEDURE P_SCP0007_GET_COUNTRY_CITY
    (
        P_DIVISION_ID    IN  VARCHAR2,
        P_SCM_SITE_ID    IN  VARCHAR2,
        O_RC             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN O_RC FOR
            SELECT A.DIVISION_ID,
                   A.SCM_SITE_ID,
                   A.COUNTRY,
                   A.CITY,
                   A.VMI_YN,
                   A.SITE_TYPE
              FROM SCM_MST_SITE A
             WHERE (P_DIVISION_ID IS NULL OR P_DIVISION_ID = ''
                    OR ',' || UPPER(REPLACE(P_DIVISION_ID, ' ')) || ',' LIKE '%,ALL,%'   -- 2026.09.22 AJS
                    OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))))
               AND (P_SCM_SITE_ID IS NULL OR P_SCM_SITE_ID = ''
                    OR ',' || UPPER(REPLACE(P_SCM_SITE_ID, ' ')) || ',' LIKE '%,ALL,%'   -- 2026.09.22 AJS
                    OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_SCM_SITE_ID, ','))));

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            DECLARE
                V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
            BEGIN
                OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
                OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
            END;
    END P_SCP0007_GET_COUNTRY_CITY;

    -- =========================================================================================
    -- GET: From/To City 조합의 Route 존재 건수 (AS-IS SCP0007_GET_ROUTE_CNT 1:1)
    -- =========================================================================================
    PROCEDURE P_SCP0007_GET_ROUTE_CNT
    (
        P_FROM_CITY      IN  VARCHAR2,
        P_TO_CITY        IN  VARCHAR2,
        O_RC             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN O_RC FOR
            SELECT COUNT(*) AS ROUTE_CNT
              FROM SCP_MST_DISTRIBUTION_ROUTE
             WHERE FROM_CITY = P_FROM_CITY
               AND TO_CITY   = P_TO_CITY;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            DECLARE
                V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
            BEGIN
                OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
                OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
            END;
    END P_SCP0007_GET_ROUTE_CNT;

    -- =========================================================================================
    -- GET: BOD 메인 그리드 조회 (AS-IS SCP0007_GET_BOD 6-UNION 정적 재구성)
    --
    --   As-Is 는 SELECT 문 자체를 문자열로 조립하는 동적 SQL 이지만, 실측 결과 UNION 구조와
    --   컬럼셋은 입력값과 무관하게 항상 동일하고, 달라지는 것은 (1) bo 조인에 bod_id 매치 조건이
    --   붙는지 여부(Completed 일 때만), (2) 최종 WHERE 필터 값, (3) ORDER BY/추가 WHERE(Required
    --   전용 OSP 제외) 뿐이다. 그래서 동적 SQL(EXECUTE IMMEDIATE) 없이 정적 SQL + OR 기반 조건부
    --   필터로 재구성했다 — 6개 UNION 브랜치(1-1/1-2/2-1/2-2/3/4)는 As-Is 그대로 보존.
    --
    --   ma: BOD 후보/실등록 6-UNION
    --     1-1 Div=81  : Mkt Fcst 기반 후보(Project Route/Sales Site 조인)
    --     1-2 Div=40,82 : 1-1 과 동일하되 Project Route/Sales Site 조인 없음
    --     2-1 Div=81  : VMI=Y 대상의 DAP 전극 후보(scp_mst_bod 미등록분만, NOT EXISTS 중복 배제)
    --     2-2 Div=40,82 : 2-1 과 동일 division 그룹 차이
    --     3   Completed : scp_mst_bod 실등록 마스터 그대로
    --     4   VMI N→Y 전환 : 기존 등록 마스터 중 VMI=Y 로 전환됐는데 DAP 미등록인 건에 DAP 후보 추가
    --   bo: 실제 scp_mst_bod(+route) 매치 — Completed 일 때만 bod_id 까지 매치
    --   ro: bo.route_id 로 재조회한 route 마스터(ROUTE_CHK/요일 컬럼용)
    --
    --   FN_GET_DIVISION_DIV('81') 는 Oracle 미존재 함수 — As-Is 정의(SCM_MST_DIVISION.ATTRIBUTE3
    --   필터) 확인 후 인라인 스칼라 서브쿼리로 대체(신규 함수 미신설, 최신 사업부 공통화 마스터
    --   데이터를 그대로 반영해 하드코딩 division 목록보다 오히려 최신 상태 유지).
    --
    --   DIVISION_NAME/FROM_SITE_NAME/TO_SITE_NAME 은 As-Is 에서도 주석 처리되어 실행되지 않던
    --   컬럼이라(dbo.fn_get_division_name 등 호출부 전체 주석) NULL 로 반환 — 신규 로직 추가 아님.
    --   FROM_YYYYMMDD/TO_YYYYMMDD 는 As-Is 가 CONVERT(date,attr,112) 로 재포맷하지만 실측
    --   데이터가 이미 8자리 YYYYMMDD 문자열이라(SCP_MST_BOD.ATTRIBUTE2/3 샘플 확인) 원문 그대로
    --   반환해도 결과가 동일 — 불필요한 포맷 변환 생략.
    -- * 2026.10.06   AJS          조회 속도 개선 : BOD 바깥 조인 조건 등식화 · 리드타임/경로 건수 행별 조회를 바깥 조인으로 · 마케팅 계획 전체 읽기
    -- =========================================================================================
    PROCEDURE P_SCP0007_GET_BOD
    (
        P_DIVISION_ID     IN  VARCHAR2,
        P_FROM_SITE       IN  VARCHAR2,
        P_TO_SITE         IN  VARCHAR2,
        P_INCOTERMS       IN  VARCHAR2,
        P_INCOTERMS_SSP   IN  VARCHAR2,
        P_TRANS_MODE      IN  VARCHAR2,
        P_INPUT_STATUS    IN  VARCHAR2,
        P_VALID_YN        IN  VARCHAR2,
        O_RC              OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN O_RC FOR
            SELECT DISTINCT
                   T.DIVISION_ID
                 , T.BOD_ID
                 , T.CUSTOMER
                 , T.INCOTERMS
                 , T.INCOTERMS_SSP
                 , T.FROM_SITE_CODE
                 , T.TO_SITE_CODE
                 , T.FROM_COUNTRY
                 , T.FROM_CITY
                 , T.TO_COUNTRY
                 , T.TO_CITY
                 , T.TRANSPORT_MODE_CODE
                 , NVL((SELECT C.SEGMENT2
                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL C
                         WHERE C.LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'
                           AND NVL(C.SEGMENT1, '-') = NVL(T.TRANSPORT_MODE_CODE, '-')
                           AND ROWNUM = 1), '') AS TRANSPORT_MODE
                 , T.SAFETY_STOCK
                 , T.PRIORITY
                 , T.BOD_VALID
                 , T.ROUTE_VALID
                 , T.ROUTE_ID
                 , T.LT_TYPE
                 , T.DAYS_MON
                 , T.DAYS_TUE
                 , T.DAYS_WED
                 , T.DAYS_THU
                 , T.DAYS_FRI
                 , T.DAYS_SAT
                 , T.DAYS_SUN
--               , T.LEAD_TIME   --  2026.10.06 AJS
                 , XA.LT_TOTAL AS LEAD_TIME   --  2026.10.06 AJS
                 , T.DIS_TOTAL_LEAD_TIME
                 , T.FROM_YYYYMMDD
                 , T.TO_YYYYMMDD
                 , T.BEFORE_LEAD_TIME
                 , T.AFTER_LEAD_TIME
                 , T.REMARKS
                 , T.CREATED_BY
                 , T.CREATION_DATE
                 , T.LAST_UPDATED_BY
                 , T.LAST_UPDATE_DATE
                 , T.ROUTE_CHK
                 -- 2026.10.06 AJS 경로 건수 행별 조회를 묶음 바깥 조인으로 (START)
--               , (SELECT COUNT(*)
--                    FROM SCP_MST_DISTRIBUTION_ROUTE
--                   WHERE TRANSPORT_MODE = T.TRANSPORT_MODE_CODE
--                     AND FROM_CITY      = T.FROM_CITY
--                     AND TO_CITY        = T.TO_CITY) AS ROUTE_CNT
                 , NVL(IA.ROUTE_CNT, 0) AS ROUTE_CNT
                 -- 2026.10.06 AJS 경로 건수 행별 조회를 묶음 바깥 조인으로 (END)
                 , CASE WHEN SUBSTR(T.FROM_SITE_CODE, -1, 1) = 'E'
                        THEN (SELECT NVL(VMI_YN, 'N')
                                FROM SCM_MST_SITE
                               WHERE SCM_SITE_ID = T.TO_SITE_CODE
                                 AND ROWNUM = 1)
                        ELSE (SELECT NVL(VMI_YN, 'N')
                                FROM SCM_MST_SITE
                               WHERE DIVISION_ID = T.DIVISION_ID
                                 AND SCM_SITE_ID = T.TO_SITE_CODE
                                 AND ROWNUM = 1)
                   END AS VMI_YN
              FROM (
                    SELECT MA.DIVISION_ID, BO.BOD_ID, MA.CUSTOMER, MA.INCOTERMS,
                           NVL(MA.ATTRIBUTE1, MA.INCOTERMS) AS INCOTERMS_SSP,
                           MA.FROM_SITE AS FROM_SITE_CODE, MA.TO_SITE AS TO_SITE_CODE,
                           MA.FROM_COUNTRY, MA.FROM_CITY, MA.TO_COUNTRY, MA.TO_CITY,
                           MA.TRANSPORT_MODE AS TRANSPORT_MODE_CODE,
                           BO.SAFETY_STOCK, BO.PRIORITY,
                           BO.VALID_YN AS BOD_VALID,
                           RO.VALID_YN AS ROUTE_VALID,
                           RO.ROUTE_ID,
                           RO.LT_TYPE,
                           RO.DAYS_MON, RO.DAYS_TUE, RO.DAYS_WED, RO.DAYS_THU, RO.DAYS_FRI, RO.DAYS_SAT, RO.DAYS_SUN,
                           -- 2026.10.06 AJS 리드타임 행별 뷰 조회 제거 - 바깥 단계에서 묶음 바깥 조인으로 (START)
--                         (SELECT V.LT_TOTAL FROM SCP_MST_BOD_N_V V
--                           WHERE V.DIVISION_ID = MA.DIVISION_ID AND V.BOD_ID = BO.BOD_ID) AS LEAD_TIME,
                           -- 2026.10.06 AJS 리드타임 행별 뷰 조회 제거 - 바깥 단계에서 묶음 바깥 조인으로 (END)
                           NVL(BO.LT_DEPARTURE_INLAND,0) + NVL(BO.LT_WAIT_SHIPPING,0) + NVL(BO.LT_VOYAGE,0)
                             + NVL(BO.LT_LAY_OFF_CLEARANCE,0) + NVL(BO.LT_ARRIVAL_INLAND,0) AS DIS_TOTAL_LEAD_TIME,
                           --TO_DATE(BO.ATTRIBUTE2, 'YYYYMMDD') AS FROM_YYYYMMDD,   /* AS-IS CONVERT(date, x, 112) */
                           --TO_DATE(BO.ATTRIBUTE3, 'YYYYMMDD') AS TO_YYYYMMDD,     /* AS-IS CONVERT(date, x, 112) */
                           TO_CHAR(FN_CHAR_TO_DATE(BO.ATTRIBUTE2),'YYYY-MM-DD') AS FROM_YYYYMMDD,
					       TO_CHAR(FN_CHAR_TO_DATE(BO.ATTRIBUTE3),'YYYY-MM-DD') AS TO_YYYYMMDD,
                           NVL(BO.ATTRIBUTE4,0) AS BEFORE_LEAD_TIME,
                           NVL(BO.ATTRIBUTE5,0) AS AFTER_LEAD_TIME,
                           BO.ATTRIBUTE6 AS REMARKS,
                           NVL(BO.CREATED_BY, MA.CREATED_BY) AS CREATED_BY,
                           NVL(BO.CREATION_DATE, MA.CREATION_DATE) AS CREATION_DATE,
                           NVL(BO.LAST_UPDATED_BY, MA.LAST_UPDATED_BY) AS LAST_UPDATED_BY,
                           NVL(BO.LAST_UPDATE_DATE, MA.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE,
                           CASE WHEN (RO.FROM_CITY = MA.FROM_CITY) AND (RO.TO_CITY = MA.TO_CITY) THEN 'Y' ELSE 'N' END AS ROUTE_CHK
                      FROM (
                            -- 1-1. Div=81, BOD Required — Mkt Fcst 후보, Project Route/Sales Site 조인
                            SELECT T.DIVISION_ID, T.TO_SITE, T.CUSTOMER, T.INCOTERMS, T.FROM_SITE,
                                   T.FROM_COUNTRY, T.FROM_CITY, T.TO_COUNTRY, T.TO_CITY, U.TRANSPORT_MODE,
                                   NULL CREATED_BY, NULL CREATION_DATE, NULL LAST_UPDATED_BY, NULL LAST_UPDATE_DATE,
                                   NULL AS ATTRIBUTE1, '-' AS BOD_ID
                              FROM (
                                    SELECT DISTINCT DE.DIVISION_ID, DE.SCM_SITE_ID AS TO_SITE, DE.CUSTOMER, DE.INCOTERMS,
                                           SI.SCM_SITE_ID AS FROM_SITE,
                                           F_CI.COUNTRY AS FROM_COUNTRY, F_CI.CITY AS FROM_CITY,
                                           T_CI.COUNTRY AS TO_COUNTRY, T_CI.CITY AS TO_CITY
                                      FROM (SELECT F.DIVISION_ID, F.SCM_SITE_ID, M.END_CUSTOMER AS CUSTOMER,
                                                   F.INCOTERMS, F.PROJECT_CODE, F.ITEM_ID
                                              FROM DM_PLN_MKT_FCST F
                                              JOIN SCM_MST_SITE M ON F.DIVISION_ID = M.DIVISION_ID
                                                   AND F.SCM_SITE_ID = M.SCM_SITE_ID AND M.VALID_YN = 'Y'
                                              LEFT JOIN SCM_MST_SITE S ON S.DIVISION_ID = F.DIVISION_ID
                                                   AND S.SCM_SITE_ID = F.SCM_SITE_ID
                                                   AND (S.VMI_YN = 'Y' OR (S.SITE_TYPE = 'SALES' AND S.OPERATION_GROUP = 'W'))
                                             WHERE F.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION
                                                                       WHERE VALID_YN = 'Y' AND ATTRIBUTE3 = '81')
                                               AND F.MEASURE = CASE WHEN S.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                                                     WHEN S.VMI_YN = 'Y' THEN 'VMI_In_Req'
                                                                     WHEN RTRIM(F.ATTRIBUTE10) IS NULL THEN 'MKT_FCST' END
                                           ) DE
                                      LEFT OUTER JOIN (
                                            SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.ITEM_ID, B.PROJECT_CODE,
                                                   C.PRIORITY, C.SALES_SITE_ID, SUBSTR(C.PLANT_SITE_ID,-1,1) PLANT_TYPE
                                                   /* 'E' 공장은 프로젝트·판매사이트 매칭 면제 — 결합조건의 OR 를 없애 해시 결합 유도 */
                                                   , CASE WHEN SUBSTR(C.PLANT_SITE_ID,-1,1) = 'E' THEN NULL ELSE B.PROJECT_CODE  END AS MK_PROJECT_CODE
                                                   , CASE WHEN SUBSTR(C.PLANT_SITE_ID,-1,1) = 'E' THEN NULL ELSE C.SALES_SITE_ID END AS MK_SALES_SITE_ID
                                              FROM SCM_MST_SITE A, SCM_MST_SITE_ITEM B,
                                                   SCM_MST_SITE_ITEM_PRIORITY C
                                             WHERE A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                               AND B.DIVISION_ID = C.DIVISION_ID AND B.SCM_SITE_ID = C.PLANT_SITE_ID
                                               AND B.PROJECT_CODE = C.PROJECT_CODE AND B.ITEM_ID = C.ITEM_ID
                                               AND A.VALID_YN = 'Y' AND B.VALID_YN = 'Y' AND C.VALID_YN = 'Y'
                                               AND A.SITE_TYPE = 'PLANT'
                                               AND A.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION
                                                                       WHERE VALID_YN = 'Y' AND ATTRIBUTE3 = '81')
                                           ) SI ON DE.DIVISION_ID = SI.DIVISION_ID
                                                AND DE.ITEM_ID     = SI.ITEM_ID
                                                AND NVL(SI.MK_PROJECT_CODE,  DE.PROJECT_CODE) = DE.PROJECT_CODE
                                                AND NVL(SI.MK_SALES_SITE_ID, DE.SCM_SITE_ID)  = DE.SCM_SITE_ID
                                      LEFT OUTER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, COUNTRY, CITY
                                                          FROM SCM_MST_SITE WHERE VALID_YN = 'Y') F_CI
                                             ON DE.DIVISION_ID = F_CI.DIVISION_ID AND SI.SCM_SITE_ID = F_CI.SCM_SITE_ID
                                      LEFT OUTER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, COUNTRY, CITY
                                                          FROM SCM_MST_SITE WHERE VALID_YN = 'Y') T_CI
                                             ON DE.DIVISION_ID = T_CI.DIVISION_ID AND DE.SCM_SITE_ID = T_CI.SCM_SITE_ID
                                   ) T
                              LEFT JOIN (SELECT DISTINCT FROM_COUNTRY, FROM_CITY, TO_COUNTRY, TO_CITY, TRANSPORT_MODE
                                           FROM SCP_MST_DISTRIBUTION_ROUTE WHERE VALID_YN = 'Y') U
                                     ON T.FROM_COUNTRY = U.FROM_COUNTRY AND T.FROM_CITY = U.FROM_CITY
                                    AND T.TO_COUNTRY = U.TO_COUNTRY AND T.TO_CITY = U.TO_CITY

                            UNION ALL
                            -- 1-2. Div=40,82, BOD Required — 1-1 과 동일하되 Project Route/Sales Site 조인 없음
                            SELECT T.DIVISION_ID, T.TO_SITE, T.CUSTOMER, T.INCOTERMS, T.FROM_SITE,
                                   T.FROM_COUNTRY, T.FROM_CITY, T.TO_COUNTRY, T.TO_CITY, U.TRANSPORT_MODE,
                                   NULL CREATED_BY, NULL CREATION_DATE, NULL LAST_UPDATED_BY, NULL LAST_UPDATE_DATE,
                                   NULL AS ATTRIBUTE1, '-' AS BOD_ID
                              FROM (
                                    SELECT DISTINCT DE.DIVISION_ID, DE.SCM_SITE_ID AS TO_SITE, DE.CUSTOMER, DE.INCOTERMS,
                                           SI.SCM_SITE_ID AS FROM_SITE,
                                           F_CI.COUNTRY AS FROM_COUNTRY, F_CI.CITY AS FROM_CITY,
                                           T_CI.COUNTRY AS TO_COUNTRY, T_CI.CITY AS TO_CITY
                                      FROM (SELECT F.DIVISION_ID, F.SCM_SITE_ID, M.END_CUSTOMER AS CUSTOMER,
                                                   F.INCOTERMS, F.PROJECT_CODE, F.ITEM_ID
                                              FROM DM_PLN_MKT_FCST F
                                              JOIN SCM_MST_SITE M ON F.DIVISION_ID = M.DIVISION_ID
                                                   AND F.SCM_SITE_ID = M.SCM_SITE_ID AND M.VALID_YN = 'Y'
                                              LEFT JOIN SCM_MST_SITE S ON S.DIVISION_ID = F.DIVISION_ID
                                                   AND S.SCM_SITE_ID = F.SCM_SITE_ID
                                                   AND (S.VMI_YN = 'Y' OR (S.SITE_TYPE = 'SALES' AND S.OPERATION_GROUP = 'W'))
                                             WHERE F.DIVISION_ID IN ('40','82')
                                               AND F.MEASURE = CASE WHEN S.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                                                     WHEN S.VMI_YN = 'Y' THEN 'VMI_In_Req'
                                                                     WHEN RTRIM(F.ATTRIBUTE10) IS NULL THEN 'MKT_FCST' END
                                           ) DE
                                      LEFT OUTER JOIN (
                                            SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.ITEM_ID, B.PROJECT_CODE,
                                                   C.PRIORITY, C.SALES_SITE_ID, SUBSTR(C.PLANT_SITE_ID,-1,1) PLANT_TYPE
                                              FROM SCM_MST_SITE A, SCM_MST_SITE_ITEM B,
                                                   SCM_MST_SITE_ITEM_PRIORITY C
                                             WHERE A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                               AND B.DIVISION_ID = C.DIVISION_ID AND B.SCM_SITE_ID = C.PLANT_SITE_ID
                                               AND B.PROJECT_CODE = C.PROJECT_CODE AND B.ITEM_ID = C.ITEM_ID
                                               AND A.VALID_YN = 'Y' AND B.VALID_YN = 'Y' AND C.VALID_YN = 'Y'
                                               AND A.SITE_TYPE = 'PLANT' AND A.DIVISION_ID IN ('40','82')
                                           ) SI ON DE.DIVISION_ID = SI.DIVISION_ID AND DE.ITEM_ID = SI.ITEM_ID
                                      LEFT OUTER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, COUNTRY, CITY
                                                          FROM SCM_MST_SITE WHERE VALID_YN = 'Y') F_CI
                                             ON DE.DIVISION_ID = F_CI.DIVISION_ID AND SI.SCM_SITE_ID = F_CI.SCM_SITE_ID
                                      LEFT OUTER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, COUNTRY, CITY
                                                          FROM SCM_MST_SITE WHERE VALID_YN = 'Y') T_CI
                                             ON DE.DIVISION_ID = T_CI.DIVISION_ID AND DE.SCM_SITE_ID = T_CI.SCM_SITE_ID
                                   ) T
                              LEFT JOIN (SELECT DISTINCT FROM_COUNTRY, FROM_CITY, TO_COUNTRY, TO_CITY, TRANSPORT_MODE
                                           FROM SCP_MST_DISTRIBUTION_ROUTE WHERE VALID_YN = 'Y') U
                                     ON T.FROM_COUNTRY = U.FROM_COUNTRY AND T.FROM_CITY = U.FROM_CITY
                                    AND T.TO_COUNTRY = U.TO_COUNTRY AND T.TO_CITY = U.TO_CITY

                            UNION ALL
                            -- 2-1. Div=81, BOD Required — VMI=Y 대상 DAP 전극 후보(미등록분만)
                            SELECT A.DIVISION_ID, A.TO_SITE, A.CUSTOMER, 'DAP' AS INCOTERMS, A.FROM_SITE,
                                   A.FROM_COUNTRY, A.FROM_CITY, A.TO_COUNTRY, A.TO_CITY, A.TRANSPORT_MODE,
                                   A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE,
                                   NULL AS ATTRIBUTE1, '-' AS BOD_ID
                              FROM (
                                    SELECT T.DIVISION_ID, T.TO_SITE, T.CUSTOMER, T.INCOTERMS, T.FROM_SITE,
                                           T.FROM_COUNTRY, T.FROM_CITY, T.TO_COUNTRY, T.TO_CITY, U.TRANSPORT_MODE,
                                           NULL CREATED_BY, NULL CREATION_DATE, NULL LAST_UPDATED_BY, NULL LAST_UPDATE_DATE
                                      FROM (
                                            SELECT DISTINCT DE.DIVISION_ID, DE.SCM_SITE_ID AS TO_SITE, DE.CUSTOMER, DE.INCOTERMS,
                                                   SI.SCM_SITE_ID AS FROM_SITE,
                                                   F_CI.COUNTRY AS FROM_COUNTRY, F_CI.CITY AS FROM_CITY,
                                                   T_CI.COUNTRY AS TO_COUNTRY, T_CI.CITY AS TO_CITY
--                                            FROM (SELECT F.DIVISION_ID, F.SCM_SITE_ID, M.END_CUSTOMER AS CUSTOMER,   --  2026.10.06 AJS
                                              FROM (SELECT /*+ FULL(F) */ F.DIVISION_ID, F.SCM_SITE_ID, M.END_CUSTOMER AS CUSTOMER,   /* 계획 원장 행별 인덱스 접근 대신 한 번에 읽기 */   --  2026.10.06 AJS
                                                           F.INCOTERMS, F.PROJECT_CODE, F.ITEM_ID
                                                      FROM DM_PLN_MKT_FCST F
                                                      JOIN SCM_MST_SITE M ON F.DIVISION_ID = M.DIVISION_ID
                                                           AND F.SCM_SITE_ID = M.SCM_SITE_ID AND M.VALID_YN = 'Y'
                                                           AND (M.VMI_YN = 'Y' OR (M.SITE_TYPE = 'SALES' AND M.OPERATION_GROUP = 'W'))
                                                      LEFT JOIN SCM_MST_SITE S ON S.DIVISION_ID = F.DIVISION_ID
                                                           AND S.SCM_SITE_ID = F.SCM_SITE_ID
                                                           AND (S.VMI_YN = 'Y' OR (S.SITE_TYPE = 'SALES' AND S.OPERATION_GROUP = 'W'))
                                                     WHERE F.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION
                                                                               WHERE VALID_YN = 'Y' AND ATTRIBUTE3 = '81')
                                                       AND F.MEASURE = CASE WHEN S.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                                                             WHEN S.VMI_YN = 'Y' THEN 'VMI_In_Req'
                                                                             WHEN RTRIM(F.ATTRIBUTE10) IS NULL THEN 'MKT_FCST' END
                                                   ) DE
                                              LEFT OUTER JOIN (
                                                    SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.ITEM_ID, B.PROJECT_CODE,
                                                           C.PRIORITY, C.SALES_SITE_ID, SUBSTR(C.PLANT_SITE_ID,-1,1) PLANT_TYPE
                                                           /* 'E' 공장은 프로젝트·판매사이트 매칭 면제 — 결합조건의 OR 를 없애 해시 결합 유도 */
                                                           , CASE WHEN SUBSTR(C.PLANT_SITE_ID,-1,1) = 'E' THEN NULL ELSE B.PROJECT_CODE  END AS MK_PROJECT_CODE
                                                           , CASE WHEN SUBSTR(C.PLANT_SITE_ID,-1,1) = 'E' THEN NULL ELSE C.SALES_SITE_ID END AS MK_SALES_SITE_ID
                                                      FROM SCM_MST_SITE A, SCM_MST_SITE_ITEM B,
                                                           SCM_MST_SITE_ITEM_PRIORITY C
                                                     WHERE A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                                       AND B.DIVISION_ID = C.DIVISION_ID AND B.SCM_SITE_ID = C.PLANT_SITE_ID
                                                       AND B.PROJECT_CODE = C.PROJECT_CODE AND B.ITEM_ID = C.ITEM_ID
                                                       AND A.VALID_YN = 'Y' AND B.VALID_YN = 'Y' AND C.VALID_YN = 'Y'
                                                       AND A.SITE_TYPE = 'PLANT'
                                                       AND A.DIVISION_ID IN (SELECT DIVISION_ID FROM SCM_MST_DIVISION
                                                                               WHERE VALID_YN = 'Y' AND ATTRIBUTE3 = '81')
                                                   ) SI ON DE.DIVISION_ID = SI.DIVISION_ID
                                                        AND DE.ITEM_ID     = SI.ITEM_ID
                                                        AND NVL(SI.MK_PROJECT_CODE,  DE.PROJECT_CODE) = DE.PROJECT_CODE
                                                        AND NVL(SI.MK_SALES_SITE_ID, DE.SCM_SITE_ID)  = DE.SCM_SITE_ID
                                              LEFT OUTER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, COUNTRY, CITY
                                                                  FROM SCM_MST_SITE WHERE VALID_YN = 'Y') F_CI
                                                     ON DE.DIVISION_ID = F_CI.DIVISION_ID AND SI.SCM_SITE_ID = F_CI.SCM_SITE_ID
                                              LEFT OUTER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, COUNTRY, CITY
                                                                  FROM SCM_MST_SITE WHERE VALID_YN = 'Y') T_CI
                                                     ON DE.DIVISION_ID = T_CI.DIVISION_ID AND DE.SCM_SITE_ID = T_CI.SCM_SITE_ID
                                           ) T
                                      LEFT JOIN (SELECT DISTINCT FROM_COUNTRY, FROM_CITY, TO_COUNTRY, TO_CITY, TRANSPORT_MODE
                                                   FROM SCP_MST_DISTRIBUTION_ROUTE WHERE VALID_YN = 'Y') U
                                             ON T.FROM_COUNTRY = U.FROM_COUNTRY AND T.FROM_CITY = U.FROM_CITY
                                            AND T.TO_COUNTRY = U.TO_COUNTRY AND T.TO_CITY = U.TO_CITY
                                   ) A
                             WHERE NOT EXISTS (
                                   SELECT 1
                                     FROM (SELECT DISTINCT A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, B.TRANSPORT_MODE
                                             FROM SCP_MST_BOD A
                                             INNER JOIN SCP_MST_BOD_N_V B ON A.DIVISION_ID = B.DIVISION_ID
                                                  AND A.BOD_ID = B.BOD_ID AND A.FROM_SITE = B.FROM_SITE
                                                  AND A.TO_SITE = B.TO_SITE AND A.INCOTERMS = B.INCOTERMS
                                            WHERE A.INCOTERMS = 'DAP'
                                          ) B
                                    WHERE A.DIVISION_ID = B.DIVISION_ID AND A.FROM_SITE = B.FROM_SITE
                                      AND A.TO_SITE = B.TO_SITE AND A.TRANSPORT_MODE = B.TRANSPORT_MODE
                                   )

                            UNION ALL
                            -- 2-2. Div=40,82, BOD Required — 2-1 과 동일 division 그룹 차이
                            SELECT A.DIVISION_ID, A.TO_SITE, A.CUSTOMER, 'DAP' AS INCOTERMS, A.FROM_SITE,
                                   A.FROM_COUNTRY, A.FROM_CITY, A.TO_COUNTRY, A.TO_CITY, A.TRANSPORT_MODE,
                                   A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE,
                                   NULL AS ATTRIBUTE1, '-' AS BOD_ID
                              FROM (
                                    SELECT T.DIVISION_ID, T.TO_SITE, T.CUSTOMER, T.INCOTERMS, T.FROM_SITE,
                                           T.FROM_COUNTRY, T.FROM_CITY, T.TO_COUNTRY, T.TO_CITY, U.TRANSPORT_MODE,
                                           NULL CREATED_BY, NULL CREATION_DATE, NULL LAST_UPDATED_BY, NULL LAST_UPDATE_DATE
                                      FROM (
                                            SELECT DISTINCT DE.DIVISION_ID, DE.SCM_SITE_ID AS TO_SITE, DE.CUSTOMER, DE.INCOTERMS,
                                                   SI.SCM_SITE_ID AS FROM_SITE,
                                                   F_CI.COUNTRY AS FROM_COUNTRY, F_CI.CITY AS FROM_CITY,
                                                   T_CI.COUNTRY AS TO_COUNTRY, T_CI.CITY AS TO_CITY
--                                            FROM (SELECT F.DIVISION_ID, F.SCM_SITE_ID, M.END_CUSTOMER AS CUSTOMER,   --  2026.10.06 AJS
                                              FROM (SELECT /*+ FULL(F) */ F.DIVISION_ID, F.SCM_SITE_ID, M.END_CUSTOMER AS CUSTOMER,   /* 계획 원장 행별 인덱스 접근 대신 한 번에 읽기 */   --  2026.10.06 AJS
                                                           F.INCOTERMS, F.PROJECT_CODE, F.ITEM_ID
                                                      FROM DM_PLN_MKT_FCST F
                                                      JOIN SCM_MST_SITE M ON F.DIVISION_ID = M.DIVISION_ID
                                                           AND F.SCM_SITE_ID = M.SCM_SITE_ID AND M.VALID_YN = 'Y'
                                                           AND (M.VMI_YN = 'Y' OR (M.SITE_TYPE = 'SALES' AND M.OPERATION_GROUP = 'W'))
                                                      LEFT JOIN SCM_MST_SITE S ON S.DIVISION_ID = F.DIVISION_ID
                                                           AND S.SCM_SITE_ID = F.SCM_SITE_ID
                                                           AND (S.VMI_YN = 'Y' OR (S.SITE_TYPE = 'SALES' AND S.OPERATION_GROUP = 'W'))
                                                     WHERE F.DIVISION_ID IN ('40','82')
                                                       AND F.MEASURE = CASE WHEN S.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                                                             WHEN S.VMI_YN = 'Y' THEN 'VMI_In_Req'
                                                                             WHEN RTRIM(F.ATTRIBUTE10) IS NULL THEN 'MKT_FCST' END
                                                   ) DE
                                              LEFT OUTER JOIN (
                                                    SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.ITEM_ID, B.PROJECT_CODE,
                                                           C.PRIORITY, C.SALES_SITE_ID, SUBSTR(C.PLANT_SITE_ID,-1,1) PLANT_TYPE
                                                      FROM SCM_MST_SITE A, SCM_MST_SITE_ITEM B,
                                                           SCM_MST_SITE_ITEM_PRIORITY C
                                                     WHERE A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
                                                       AND B.DIVISION_ID = C.DIVISION_ID AND B.SCM_SITE_ID = C.PLANT_SITE_ID
                                                       AND B.PROJECT_CODE = C.PROJECT_CODE AND B.ITEM_ID = C.ITEM_ID
                                                       AND A.VALID_YN = 'Y' AND B.VALID_YN = 'Y' AND C.VALID_YN = 'Y'
                                                       AND A.SITE_TYPE = 'PLANT' AND A.DIVISION_ID IN ('40','82')
                                                   ) SI ON DE.DIVISION_ID = SI.DIVISION_ID AND DE.ITEM_ID = SI.ITEM_ID
                                              LEFT OUTER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, COUNTRY, CITY
                                                                  FROM SCM_MST_SITE WHERE VALID_YN = 'Y') F_CI
                                                     ON DE.DIVISION_ID = F_CI.DIVISION_ID AND SI.SCM_SITE_ID = F_CI.SCM_SITE_ID
                                              LEFT OUTER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, COUNTRY, CITY
                                                                  FROM SCM_MST_SITE WHERE VALID_YN = 'Y') T_CI
                                                     ON DE.DIVISION_ID = T_CI.DIVISION_ID AND DE.SCM_SITE_ID = T_CI.SCM_SITE_ID
                                           ) T
                                      LEFT JOIN (SELECT DISTINCT FROM_COUNTRY, FROM_CITY, TO_COUNTRY, TO_CITY, TRANSPORT_MODE
                                                   FROM SCP_MST_DISTRIBUTION_ROUTE WHERE VALID_YN = 'Y') U
                                             ON T.FROM_COUNTRY = U.FROM_COUNTRY AND T.FROM_CITY = U.FROM_CITY
                                            AND T.TO_COUNTRY = U.TO_COUNTRY AND T.TO_CITY = U.TO_CITY
                                   ) A
                             WHERE NOT EXISTS (
                                   SELECT 1
                                     FROM (SELECT DISTINCT A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, B.TRANSPORT_MODE
                                             FROM SCP_MST_BOD A
                                             INNER JOIN SCP_MST_BOD_N_V B ON A.DIVISION_ID = B.DIVISION_ID
                                                  AND A.BOD_ID = B.BOD_ID AND A.FROM_SITE = B.FROM_SITE
                                                  AND A.TO_SITE = B.TO_SITE AND A.INCOTERMS = B.INCOTERMS
                                            WHERE A.INCOTERMS = 'DAP'
                                          ) B
                                    WHERE A.DIVISION_ID = B.DIVISION_ID AND A.FROM_SITE = B.FROM_SITE
                                      AND A.TO_SITE = B.TO_SITE AND A.TRANSPORT_MODE = B.TRANSPORT_MODE
                                   )

                            UNION ALL
                            -- 3. BOD Completed — 실등록 마스터
                            SELECT A.DIVISION_ID, A.TO_SITE,
                                   (SELECT END_CUSTOMER FROM SCM_MST_SITE
                                     WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = A.TO_SITE AND ROWNUM = 1) AS CUSTOMER,
                                   A.INCOTERMS, A.FROM_SITE,
                                   F_CI.COUNTRY AS FROM_COUNTRY, F_CI.CITY AS FROM_CITY,
                                   T_CI.COUNTRY AS TO_COUNTRY, T_CI.CITY AS TO_CITY,
                                   RO.TRANSPORT_MODE,
                                   A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1,
                                   A.BOD_ID
                              FROM SCP_MST_BOD A
                              INNER JOIN SCP_MST_DISTRIBUTION_ROUTE RO ON A.ROUTE_ID = RO.ROUTE_ID
                              LEFT OUTER JOIN SCM_MST_SITE F_CI ON F_CI.DIVISION_ID = A.DIVISION_ID
                                   AND F_CI.SCM_SITE_ID = A.FROM_SITE AND F_CI.VALID_YN = 'Y'
                              LEFT OUTER JOIN SCM_MST_SITE T_CI ON T_CI.SCM_SITE_ID = A.TO_SITE
                                   AND T_CI.VALID_YN = 'Y'

                            UNION ALL
                            -- 4. VMI N→Y 전환 — 기존 등록 마스터 중 DAP 미등록분에 DAP 후보 추가
                            SELECT A.DIVISION_ID, A.TO_SITE,
                                   (SELECT END_CUSTOMER FROM SCM_MST_SITE
                                     WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = A.TO_SITE AND ROWNUM = 1) AS CUSTOMER,
                                   'DAP' AS INCOTERMS, A.FROM_SITE,
                                   A.FROM_COUNTRY, A.FROM_CITY, A.TO_COUNTRY, A.TO_CITY, A.TRANSPORT_MODE,
                                   NULL CREATED_BY, NULL CREATION_DATE, NULL LAST_UPDATED_BY, NULL LAST_UPDATE_DATE, A.ATTRIBUTE1,
                                   A.BOD_ID
                              FROM (
                                    SELECT A.DIVISION_ID, A.TO_SITE,
                                           A.INCOTERMS, A.FROM_SITE,
                                           F_CI.COUNTRY AS FROM_COUNTRY, F_CI.CITY AS FROM_CITY,
                                           T_CI.COUNTRY AS TO_COUNTRY, T_CI.CITY AS TO_CITY,
                                           RO.TRANSPORT_MODE,
                                           A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1,
                                           A.BOD_ID
                                      FROM SCP_MST_BOD A
                                      INNER JOIN SCP_MST_DISTRIBUTION_ROUTE RO ON A.ROUTE_ID = RO.ROUTE_ID
                                      LEFT OUTER JOIN SCM_MST_SITE F_CI ON F_CI.DIVISION_ID = A.DIVISION_ID
                                           AND F_CI.SCM_SITE_ID = A.FROM_SITE AND F_CI.VALID_YN = 'Y'
                                      LEFT OUTER JOIN SCM_MST_SITE T_CI ON T_CI.SCM_SITE_ID = A.TO_SITE
                                           AND T_CI.VALID_YN = 'Y'
                                   ) A
                              INNER JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.TO_SITE = C.SCM_SITE_ID
                             WHERE C.VMI_YN = 'Y'
                               AND A.INCOTERMS != 'DAP'
                               AND NOT EXISTS (
                                     SELECT 1
                                       FROM (SELECT DISTINCT A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, B.TRANSPORT_MODE
                                               FROM SCP_MST_BOD A
                                               INNER JOIN SCP_MST_BOD_N_V B ON A.DIVISION_ID = B.DIVISION_ID
                                                    AND A.BOD_ID = B.BOD_ID AND A.FROM_SITE = B.FROM_SITE
                                                    AND A.TO_SITE = B.TO_SITE AND A.INCOTERMS = B.INCOTERMS
                                              WHERE A.INCOTERMS = 'DAP'
                                            ) B
                                       INNER JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND B.TO_SITE = C.SCM_SITE_ID
                                      WHERE C.VMI_YN = 'Y' AND A.FROM_SITE = B.FROM_SITE AND A.TO_SITE = B.TO_SITE
                                        AND A.TRANSPORT_MODE = B.TRANSPORT_MODE
                                   )
                           ) MA
                      LEFT OUTER JOIN (
                            SELECT A.*, B.TRANSPORT_MODE, B.LT_DEPARTURE_INLAND, B.LT_WAIT_SHIPPING, B.LT_VOYAGE,
                                   B.LT_LAY_OFF_CLEARANCE, B.LT_ARRIVAL_INLAND
                              FROM SCP_MST_BOD A
                              INNER JOIN SCP_MST_DISTRIBUTION_ROUTE B ON A.ROUTE_ID = B.ROUTE_ID
                           ) BO ON BO.DIVISION_ID = MA.DIVISION_ID AND BO.TO_SITE = MA.TO_SITE
                                AND BO.INCOTERMS = MA.INCOTERMS AND BO.FROM_SITE = MA.FROM_SITE
                                AND BO.TRANSPORT_MODE = MA.TRANSPORT_MODE
                                -- Completed 조회일 때만 실제 등록건(bod_id) 까지 매치 (As-Is L546-547)
--                              AND (NVL(P_INPUT_STATUS,'#') != 'C' OR BO.BOD_ID = MA.BOD_ID)   --  2026.10.06 AJS
                                AND BO.BOD_ID = NVL(CASE WHEN NVL(P_INPUT_STATUS,'#') = 'C' THEN MA.BOD_ID END, BO.BOD_ID)   /* OR 조건이 행마다 BOD 전체 읽기를 부름 - 같은 판정을 등식으로 */   --  2026.10.06 AJS
                      LEFT OUTER JOIN SCP_MST_DISTRIBUTION_ROUTE RO ON BO.ROUTE_ID = RO.ROUTE_ID
                     WHERE 1 = 1
                       -- R: 아직 Route 미배정 / C: Route 배정 완료 (As-Is L554-557)
                       AND (NVL(P_INPUT_STATUS,'#') != 'R' OR BO.ROUTE_ID IS NULL)
                       AND (NVL(P_INPUT_STATUS,'#') != 'C' OR BO.ROUTE_ID IS NOT NULL)
                       -- AND (P_VALID_YN IS NULL OR P_VALID_YN = '' OR BO.VALID_YN = P_VALID_YN)   -- 2026.09.22 AJS
                       AND (P_VALID_YN IS NULL OR P_VALID_YN = ''
                            OR ',' || UPPER(REPLACE(P_VALID_YN, ' ')) || ',' LIKE '%,ALL,%'   -- 2026.09.22 AJS
                            OR BO.VALID_YN = P_VALID_YN)
                       AND (P_DIVISION_ID IS NULL OR P_DIVISION_ID = ''
                            OR ',' || UPPER(REPLACE(P_DIVISION_ID, ' ')) || ',' LIKE '%,ALL,%'   -- 2026.09.22 AJS
                            OR MA.DIVISION_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))))
                       AND (P_FROM_SITE IS NULL OR P_FROM_SITE = ''
                            OR ',' || UPPER(REPLACE(P_FROM_SITE, ' ')) || ',' LIKE '%,ALL,%'   -- 2026.09.22 AJS
                            OR MA.FROM_SITE IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_FROM_SITE, ','))))
                       AND (P_TO_SITE IS NULL OR P_TO_SITE = ''
                            OR ',' || UPPER(REPLACE(P_TO_SITE, ' ')) || ',' LIKE '%,ALL,%'   -- 2026.09.22 AJS
                            OR MA.TO_SITE IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_TO_SITE, ','))))
                       AND (P_INCOTERMS IS NULL OR P_INCOTERMS = ''
                            OR ',' || UPPER(REPLACE(P_INCOTERMS, ' ')) || ',' LIKE '%,ALL,%'   -- 2026.09.22 AJS
                            OR MA.INCOTERMS IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_INCOTERMS, ','))))
                       -- Completed 조회일 때만 SSP Incoterms 필터 적용 (As-Is L571-575)
                       AND (NVL(P_INPUT_STATUS,'#') != 'C' OR P_INCOTERMS_SSP IS NULL OR P_INCOTERMS_SSP = ''
                            OR ',' || UPPER(REPLACE(P_INCOTERMS_SSP, ' ')) || ',' LIKE '%,ALL,%'   -- 2026.09.22 AJS
                            OR MA.ATTRIBUTE1 IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_INCOTERMS_SSP, ','))))
                       AND (P_TRANS_MODE IS NULL OR P_TRANS_MODE = ''
                            OR ',' || UPPER(REPLACE(P_TRANS_MODE, ' ')) || ',' LIKE '%,ALL,%'   -- 2026.09.22 AJS
                            OR RO.TRANSPORT_MODE IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_TRANS_MODE, ','))))
                   ) T
                 -- 2026.10.06 AJS 경로 건수·리드타임 묶음 바깥 조인 (START)
                 , (SELECT TRANSPORT_MODE
                         , FROM_CITY
                         , TO_CITY
                         , COUNT(*) AS ROUTE_CNT
                      FROM SCP_MST_DISTRIBUTION_ROUTE
                     GROUP BY TRANSPORT_MODE
                            , FROM_CITY
                            , TO_CITY) IA
                 , (SELECT /*+ NO_MERGE */
                           DIVISION_ID
                         , BOD_ID
                         , LT_TOTAL
                      FROM SCP_MST_BOD_N_V) XA
--           WHERE
             WHERE IA.TRANSPORT_MODE(+) = T.TRANSPORT_MODE_CODE
               AND IA.FROM_CITY(+)      = T.FROM_CITY
               AND IA.TO_CITY(+)        = T.TO_CITY
               AND XA.DIVISION_ID(+)    = T.DIVISION_ID
               AND XA.BOD_ID(+)         = T.BOD_ID
               AND (
                 -- 2026.10.06 AJS 경로 건수·리드타임 묶음 바깥 조인 (END)
                   -- Required 조회 전용: From Site 가 외주(OSP)이고 코드 끝이 'A'(Cell) 인 것은 제외
                   -- (As-Is L584-585 — Completed 에서는 공장간 이동 등록분이 보여야 하므로 제외 안 함)
                   NVL(P_INPUT_STATUS,'#') != 'R'
                OR NOT EXISTS (SELECT 1 FROM SCM_MST_SITE S
                                WHERE S.DIVISION_ID = T.DIVISION_ID AND S.SCM_SITE_ID = T.FROM_SITE_CODE
                                  AND S.VALID_YN = 'Y' AND S.OSP_YN = 'Y' AND S.OPERATION_GROUP = 'A')
                   )   --  2026.10.06 AJS
             /* Input Status 별 정렬 상이 — Required 는 ROUTE_CNT·TRANSPORT_MODE 포함,
                Completed 는 FROM_YYYYMMDD 포함 (AS-IS 조립문 L584-590) */
             ORDER BY DIVISION_ID
                    , CASE WHEN NVL(P_INPUT_STATUS,'#') = 'R' THEN ROUTE_CNT END
                    , CUSTOMER
                    , INCOTERMS
                    , FROM_SITE_CODE
                    , TO_SITE_CODE
                    , CASE WHEN NVL(P_INPUT_STATUS,'#') = 'C' THEN FROM_YYYYMMDD END
                    , PRIORITY
                    , ROUTE_ID
                    , CASE WHEN NVL(P_INPUT_STATUS,'#') = 'R' THEN TRANSPORT_MODE END
                    , DAYS_MON
                    , DAYS_TUE
                    , DAYS_WED
                    , DAYS_THU
                    , DAYS_FRI
                    , DAYS_SAT
                    , DAYS_SUN;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            DECLARE
                V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
            BEGIN
                OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
                OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
            END;
    END P_SCP0007_GET_BOD;

    -- =========================================================================================
    -- SAVE: BOD 마스터 등록/수정/삭제 (AS-IS SCP0007_SAVE_BOD)
    --
    --   AS-IS 는 20개 파라미터를 '^' 로 이어붙인 병렬 배열을 SCM_ARR_SPL_VAL 로 인덱스 분리하며
    --   두 번 순회한다. TO-BE 는 화면 저장 규격(P_DATA CLOB JSON, 프로젝트 선례 50건)에 맞추되
    --   순회 구조·처리 순서·판정 시점은 AS-IS 그대로 유지한다.
    --
    --     루프1(저장)  : 행마다 (1) PK 채번 (2) 이력 저장(PR_SCP_MST_BOD_HIST, CRUD 종류 무관)
    --                    (3) I/M 은 MERGE + BOD_ITEM 기간 동기화, D 는 DELETE
    --                    (4) Input Status='R' 이고 VMI_YN='Y' 인 행은 Incoterms 'DAP' 행을
    --                        추가 채번·등록(중복 없을 때만) 후 이력 저장   /* 전극 로직 */
    --     루프2(검증)  : 저장이 모두 끝난 뒤 행마다 기간 중복 건수를 세어 1건 초과면 99030 오류.
    --                    AS-IS 가 루프를 나눈 이유가 이 시점 차이 — 같은 저장 묶음 안에서 뒤 행이
    --                    아직 등록되기 전에 세면 겹침을 놓친다.
    --
    --   AS-IS 원형 보존 : 루프2 의 VMI_YN 만 인덱스가 루프1 종료값(마지막 행)으로 고정되어 있어
    --   모든 행이 마지막 행의 VMI_YN 을 쓴다. 결과 동일 원칙에 따라 그대로 옮긴다.
    -- =========================================================================================
    PROCEDURE P_SCP0007_SAVE_BOD
    (
        P_DATA           IN  CLOB,
        P_INPUT_STATUS   IN  VARCHAR2,
        P_USER_ID        IN  VARCHAR2,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    IS
        TYPE T_BOD_ROW IS RECORD
        (
            CRUD_TYPE        VARCHAR2(10),
            BOD_ID           VARCHAR2(600),
            DIVISION_ID      VARCHAR2(120),
            CUSTOMER         VARCHAR2(600),
            FROM_SITE_CODE   VARCHAR2(120),
            TO_SITE_CODE     VARCHAR2(120),
            INCOTERMS        VARCHAR2(40),
            INCOTERMS_SSP    VARCHAR2(40),
            PRIORITY         VARCHAR2(50),
            ROUTE_ID         VARCHAR2(50),
            SAFETY_STOCK     VARCHAR2(50),
            VMI_YN           VARCHAR2(4),
            FROM_YYYYMMDD    VARCHAR2(32),
            TO_YYYYMMDD      VARCHAR2(32),
            BEFORE_LEAD_TIME VARCHAR2(50),
            AFTER_LEAD_TIME  VARCHAR2(50),
            REMARKS          VARCHAR2(600),
            BOD_VALID        VARCHAR2(4)
        );
        TYPE T_BOD_TAB IS TABLE OF T_BOD_ROW INDEX BY PLS_INTEGER;

        V_ROWS            T_BOD_TAB;
        V_PROGRAM_NAME    VARCHAR2(150)  := '[SCP0007_SAVE_BOD]';
        V_WORKING_TIME    DATE           := SYSDATE;
        V_MAX_LOOP_CNT    PLS_INTEGER    := 0;
        V_BOD_ID          VARCHAR2(600);
        V_TRANSPORT_MODE  VARCHAR2(600);
        V_INCOTERMS       VARCHAR2(40);
        V_VMI_YN_LAST     VARCHAR2(4);
        V_DUP_CNT         PLS_INTEGER    := 0;
        V_BOD_LIST        VARCHAR2(32767);
        V_ERR_CODE        PLS_INTEGER;
        V_ERR_MSG         VARCHAR2(4000);
        V_DIVISION_ID     VARCHAR2(120);
        V_CUSTOMER        VARCHAR2(600);
        V_FROM_SITE       VARCHAR2(120);
        V_TO_SITE         VARCHAR2(120);
        V_INCOTERMS_SSP   VARCHAR2(40);
        V_PRIORITY        VARCHAR2(50);
        V_ROUTE_ID        VARCHAR2(50);
        V_FROM_YYYYMMDD   VARCHAR2(32);
        V_TO_YYYYMMDD     VARCHAR2(32);
        EX_BIZ            EXCEPTION;
    BEGIN

        /* 시작 LOG (AS-IS L147-152) */
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'START', 0,
                                       '########## Start of procedure ##########', '', SYSDATE);

        /* 저장 대상 행 적재 (AS-IS 의 구분자 병렬배열 분리 SCM_ARR_SPL_VAL 에 대응) */
        SELECT TRIM(JT.CRUD_TYPE)
             , TRIM(JT.BOD_ID)
             , TRIM(JT.DIVISION_ID)
             , TRIM(JT.CUSTOMER)
             , TRIM(JT.FROM_SITE_CODE)
             , TRIM(JT.TO_SITE_CODE)
             , TRIM(JT.INCOTERMS)
             , TRIM(JT.INCOTERMS_SSP)
             , TRIM(JT.PRIORITY)
             , TRIM(JT.ROUTE_ID)
             , TRIM(JT.SAFETY_STOCK)
             , TRIM(JT.VMI_YN)
             , TRIM(JT.FROM_YYYYMMDD)
             , TRIM(JT.TO_YYYYMMDD)
             , TRIM(JT.BEFORE_LEAD_TIME)
             , TRIM(JT.AFTER_LEAD_TIME)
             , JT.REMARKS
             , TRIM(JT.BOD_VALID)
          BULK COLLECT INTO V_ROWS
          FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS
               (
                 CRUD_TYPE        VARCHAR2(10)  PATH '$."CRUD_TYPE"'        NULL ON EMPTY NULL ON ERROR,
                 BOD_ID           VARCHAR2(600) PATH '$."BOD_ID"'           NULL ON EMPTY NULL ON ERROR,
                 DIVISION_ID      VARCHAR2(120) PATH '$."DIVISION_ID"'      NULL ON EMPTY NULL ON ERROR,
                 CUSTOMER         VARCHAR2(600) PATH '$."CUSTOMER"'         NULL ON EMPTY NULL ON ERROR,
                 FROM_SITE_CODE   VARCHAR2(120) PATH '$."FROM_SITE_CODE"'   NULL ON EMPTY NULL ON ERROR,
                 TO_SITE_CODE     VARCHAR2(120) PATH '$."TO_SITE_CODE"'     NULL ON EMPTY NULL ON ERROR,
                 INCOTERMS        VARCHAR2(40)  PATH '$."INCOTERMS"'        NULL ON EMPTY NULL ON ERROR,
                 INCOTERMS_SSP    VARCHAR2(40)  PATH '$."INCOTERMS_SSP"'    NULL ON EMPTY NULL ON ERROR,
                 PRIORITY         VARCHAR2(50)  PATH '$."PRIORITY"'         NULL ON EMPTY NULL ON ERROR,
                 ROUTE_ID         VARCHAR2(50)  PATH '$."ROUTE_ID"'         NULL ON EMPTY NULL ON ERROR,
                 SAFETY_STOCK     VARCHAR2(50)  PATH '$."SAFETY_STOCK"'     NULL ON EMPTY NULL ON ERROR,
                 VMI_YN           VARCHAR2(4)   PATH '$."VMI_YN"'           NULL ON EMPTY NULL ON ERROR,
                 FROM_YYYYMMDD    VARCHAR2(32)  PATH '$."FROM_YYYYMMDD"'    NULL ON EMPTY NULL ON ERROR,
                 TO_YYYYMMDD      VARCHAR2(32)  PATH '$."TO_YYYYMMDD"'      NULL ON EMPTY NULL ON ERROR,
                 BEFORE_LEAD_TIME VARCHAR2(50)  PATH '$."BEFORE_LEAD_TIME"' NULL ON EMPTY NULL ON ERROR,
                 AFTER_LEAD_TIME  VARCHAR2(50)  PATH '$."AFTER_LEAD_TIME"'  NULL ON EMPTY NULL ON ERROR,
                 REMARKS          VARCHAR2(600) PATH '$."REMARKS"'          NULL ON EMPTY NULL ON ERROR,
                 BOD_VALID        VARCHAR2(4)   PATH '$."BOD_VALID"'        NULL ON EMPTY NULL ON ERROR
               )) JT;

        V_MAX_LOOP_CNT := V_ROWS.COUNT;

        /* ----------------------------------------------------------------------------------- */
        /* 루프1 : 저장 (AS-IS L155-487)                                                        */
        /* ----------------------------------------------------------------------------------- */
        FOR I IN 1 .. V_MAX_LOOP_CNT LOOP

            V_BOD_ID         := V_ROWS(I).BOD_ID;
            V_INCOTERMS      := V_ROWS(I).INCOTERMS;
            V_TRANSPORT_MODE := NULL;

            /* 오류 반환용 마지막 처리행 보관 (AS-IS 는 변수 재사용으로 남는 값) */
            V_DIVISION_ID    := V_ROWS(I).DIVISION_ID;
            V_CUSTOMER       := V_ROWS(I).CUSTOMER;
            V_FROM_SITE      := V_ROWS(I).FROM_SITE_CODE;
            V_TO_SITE        := V_ROWS(I).TO_SITE_CODE;
            V_INCOTERMS_SSP  := V_ROWS(I).INCOTERMS_SSP;
            V_PRIORITY       := V_ROWS(I).PRIORITY;
            V_ROUTE_ID       := V_ROWS(I).ROUTE_ID;
            V_FROM_YYYYMMDD   := CASE WHEN REGEXP_LIKE(V_ROWS(I).FROM_YYYYMMDD, '^[0-9]{4}[-/.][0-9]{2}[-/.][0-9]{2}')
                                 THEN SUBSTR(REPLACE(REPLACE(REPLACE(V_ROWS(I).FROM_YYYYMMDD, '-'), '/'), '.'), 1, 8)
                                 ELSE V_ROWS(I).FROM_YYYYMMDD END;   -- 2026.09.22 AJS
            V_TO_YYYYMMDD     := CASE WHEN REGEXP_LIKE(V_ROWS(I).TO_YYYYMMDD, '^[0-9]{4}[-/.][0-9]{2}[-/.][0-9]{2}')
                                 THEN SUBSTR(REPLACE(REPLACE(REPLACE(V_ROWS(I).TO_YYYYMMDD, '-'), '/'), '.'), 1, 8)
                                 ELSE V_ROWS(I).TO_YYYYMMDD END;   -- 2026.09.22 AJS

            /* Route 의 Transport Mode 조회 (AS-IS L214-215) */
            BEGIN
                SELECT TRANSPORT_MODE
                  INTO V_TRANSPORT_MODE
                  FROM SCP_MST_DISTRIBUTION_ROUTE
                 WHERE ROUTE_ID = TO_NUMBER(V_ROWS(I).ROUTE_ID);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_TRANSPORT_MODE := NULL;
            END;

            /* PK 채번 (AS-IS L217-227) */
            IF V_BOD_ID IS NULL THEN
                SELECT TO_CHAR(SEQ1_SCP_MST_BOD.NEXTVAL) INTO V_BOD_ID FROM DUAL;
            END IF;

            /* 저장 대상 BOD_ID 누적 — BOD_ITEM 재계산 인자 (AS-IS L229-236) */
            IF V_BOD_LIST IS NULL THEN
                V_BOD_LIST := V_BOD_ID;
            ELSE
                V_BOD_LIST := V_BOD_LIST || ',' || V_BOD_ID;
            END IF;

            /* 이력 저장 — CRUD 종류와 무관하게 실행 (AS-IS L239-259) */
            PR_SCP_MST_BOD_HIST(V_BOD_ID
                              , V_ROWS(I).DIVISION_ID
                              , V_ROWS(I).FROM_SITE_CODE
                              , V_ROWS(I).TO_SITE_CODE
                              , V_INCOTERMS
                              , V_ROWS(I).INCOTERMS_SSP
                              , V_ROWS(I).SAFETY_STOCK
                              , V_ROWS(I).PRIORITY
                              , V_ROWS(I).ROUTE_ID
                              , V_ROWS(I).BOD_VALID
                              , V_FROM_YYYYMMDD
                              , V_TO_YYYYMMDD
                              , V_ROWS(I).BEFORE_LEAD_TIME
                              , V_ROWS(I).AFTER_LEAD_TIME
                              , V_ROWS(I).REMARKS
                              , P_USER_ID
                              , V_WORKING_TIME
                              , P_USER_ID
                              , V_WORKING_TIME);

            IF V_ROWS(I).CRUD_TYPE IN ('M', 'I') THEN

                /* 등록·수정 (AS-IS L267-336) */
                MERGE INTO SCP_MST_BOD A
                USING (SELECT V_BOD_ID AS BOD_ID FROM DUAL) B
                   ON (A.BOD_ID = B.BOD_ID)
                 WHEN MATCHED THEN
                      UPDATE
                         SET A.DIVISION_ID      = V_ROWS(I).DIVISION_ID
                           , A.SAFETY_STOCK     = CASE WHEN V_ROWS(I).SAFETY_STOCK IS NULL THEN NULL
                                                       ELSE TO_NUMBER(V_ROWS(I).SAFETY_STOCK) END
                           , A.FROM_SITE        = V_ROWS(I).FROM_SITE_CODE
                           , A.TO_SITE          = V_ROWS(I).TO_SITE_CODE
                           , A.INCOTERMS        = V_INCOTERMS
                           , A.ATTRIBUTE1       = V_ROWS(I).INCOTERMS_SSP
                           , A.PRIORITY         = TO_NUMBER(V_ROWS(I).PRIORITY)
                           , A.ROUTE_ID         = TO_NUMBER(V_ROWS(I).ROUTE_ID)
                           , A.VALID_YN         = V_ROWS(I).BOD_VALID
                           , A.ATTRIBUTE2       = V_FROM_YYYYMMDD
                           , A.ATTRIBUTE3       = V_TO_YYYYMMDD
                           , A.ATTRIBUTE4       = NVL(V_ROWS(I).BEFORE_LEAD_TIME, '0')
                           , A.ATTRIBUTE5       = NVL(V_ROWS(I).AFTER_LEAD_TIME, '0')
                           , A.ATTRIBUTE6       = V_ROWS(I).REMARKS
                           , A.LAST_UPDATED_BY  = P_USER_ID
                           , A.LAST_UPDATE_DATE = V_WORKING_TIME
                 WHEN NOT MATCHED THEN
                      INSERT (A.BOD_ID
                            , A.DIVISION_ID
                            , A.SAFETY_STOCK
                            , A.FROM_SITE
                            , A.TO_SITE
                            , A.INCOTERMS
                            , A.ATTRIBUTE1
                            , A.PRIORITY
                            , A.ROUTE_ID
                            , A.VALID_YN
                            , A.ATTRIBUTE2
                            , A.ATTRIBUTE3
                            , A.ATTRIBUTE4
                            , A.ATTRIBUTE5
                            , A.ATTRIBUTE6
                            , A.CREATED_BY
                            , A.CREATION_DATE
                            , A.LAST_UPDATED_BY
                            , A.LAST_UPDATE_DATE)
                      VALUES (V_BOD_ID
                            , V_ROWS(I).DIVISION_ID
                            , CASE WHEN V_ROWS(I).SAFETY_STOCK IS NULL THEN NULL
                                   ELSE TO_NUMBER(V_ROWS(I).SAFETY_STOCK) END
                            , V_ROWS(I).FROM_SITE_CODE
                            , V_ROWS(I).TO_SITE_CODE
                            , V_INCOTERMS
                            , V_ROWS(I).INCOTERMS_SSP
                            , TO_NUMBER(V_ROWS(I).PRIORITY)
                            , TO_NUMBER(V_ROWS(I).ROUTE_ID)
                            , V_ROWS(I).BOD_VALID
                            , V_FROM_YYYYMMDD
                            , V_TO_YYYYMMDD
                            , NVL(V_ROWS(I).BEFORE_LEAD_TIME, '0')
                            , NVL(V_ROWS(I).AFTER_LEAD_TIME, '0')
                            , V_ROWS(I).REMARKS
                            , P_USER_ID
                            , V_WORKING_TIME
                            , P_USER_ID
                            , V_WORKING_TIME);

                /* BOD_ITEM 적용 기간 동기화 (AS-IS L337-344) */
                UPDATE SCP_MST_BOD_ITEM
                   SET FROM_YYYYMMDD    = V_FROM_YYYYMMDD
                     , TO_YYYYMMDD      = V_TO_YYYYMMDD
                     , LAST_UPDATED_BY  = P_USER_ID
                     , LAST_UPDATE_DATE = V_WORKING_TIME
                 WHERE BOD_ID = V_BOD_ID;

                /* ------------------------------------------------------------------------- */
                /* 전극 로직 (AS-IS L346-476)                                                 */
                /* Input Status 가 Required 이고 To Site 가 VMI='Y' 이면 Incoterms 'DAP' 행을 */
                /* 같은 구간에 하나 더 만든다. 이미 같은 조합이 있으면 만들지 않는다.        */
                /* ------------------------------------------------------------------------- */
                IF P_INPUT_STATUS = 'R' AND V_ROWS(I).VMI_YN = 'Y' THEN

                    V_DUP_CNT   := 0;
                    V_INCOTERMS := 'DAP';

                    SELECT COUNT(*)
                      INTO V_DUP_CNT
                      FROM SCP_MST_BOD A
                         , SCP_MST_DISTRIBUTION_ROUTE B
                     WHERE A.ROUTE_ID       = B.ROUTE_ID
                       AND A.DIVISION_ID    = V_ROWS(I).DIVISION_ID
                       AND A.FROM_SITE      = V_ROWS(I).FROM_SITE_CODE
                       AND A.TO_SITE        = V_ROWS(I).TO_SITE_CODE
                       AND A.INCOTERMS      = V_INCOTERMS
                       AND B.TRANSPORT_MODE = V_TRANSPORT_MODE;

                    IF V_DUP_CNT = 0 THEN

                        SELECT TO_CHAR(SEQ1_SCP_MST_BOD.NEXTVAL) INTO V_BOD_ID FROM DUAL;

                        MERGE INTO SCP_MST_BOD A
                        USING (SELECT V_BOD_ID AS BOD_ID FROM DUAL) B
                           ON (A.BOD_ID = B.BOD_ID)
                         WHEN MATCHED THEN
                              UPDATE
                                 SET A.DIVISION_ID      = V_ROWS(I).DIVISION_ID
                                   , A.SAFETY_STOCK     = CASE WHEN V_ROWS(I).SAFETY_STOCK IS NULL THEN NULL
                                                               ELSE TO_NUMBER(V_ROWS(I).SAFETY_STOCK) END
                                   , A.FROM_SITE        = V_ROWS(I).FROM_SITE_CODE
                                   , A.TO_SITE          = V_ROWS(I).TO_SITE_CODE
                                   , A.INCOTERMS        = V_INCOTERMS
                                   , A.ATTRIBUTE1       = V_ROWS(I).INCOTERMS_SSP
                                   , A.PRIORITY         = TO_NUMBER(V_ROWS(I).PRIORITY)
                                   , A.ROUTE_ID         = TO_NUMBER(V_ROWS(I).ROUTE_ID)
                                   , A.VALID_YN         = V_ROWS(I).BOD_VALID
                                   , A.ATTRIBUTE2       = V_FROM_YYYYMMDD
                                   , A.ATTRIBUTE3       = V_TO_YYYYMMDD
                                   , A.ATTRIBUTE4       = NVL(V_ROWS(I).BEFORE_LEAD_TIME, '0')
                                   , A.ATTRIBUTE5       = NVL(V_ROWS(I).AFTER_LEAD_TIME, '0')
                                   , A.ATTRIBUTE6       = V_ROWS(I).REMARKS
                                   , A.LAST_UPDATED_BY  = P_USER_ID
                                   , A.LAST_UPDATE_DATE = V_WORKING_TIME
                         WHEN NOT MATCHED THEN
                              INSERT (A.BOD_ID
                                    , A.DIVISION_ID
                                    , A.SAFETY_STOCK
                                    , A.FROM_SITE
                                    , A.TO_SITE
                                    , A.INCOTERMS
                                    , A.ATTRIBUTE1
                                    , A.PRIORITY
                                    , A.ROUTE_ID
                                    , A.VALID_YN
                                    , A.ATTRIBUTE2
                                    , A.ATTRIBUTE3
                                    , A.ATTRIBUTE4
                                    , A.ATTRIBUTE5
                                    , A.ATTRIBUTE6
                                    , A.CREATED_BY
                                    , A.CREATION_DATE
                                    , A.LAST_UPDATED_BY
                                    , A.LAST_UPDATE_DATE)
                              VALUES (V_BOD_ID
                                    , V_ROWS(I).DIVISION_ID
                                    , CASE WHEN V_ROWS(I).SAFETY_STOCK IS NULL THEN NULL
                                           ELSE TO_NUMBER(V_ROWS(I).SAFETY_STOCK) END
                                    , V_ROWS(I).FROM_SITE_CODE
                                    , V_ROWS(I).TO_SITE_CODE
                                    , V_INCOTERMS
                                    , V_ROWS(I).INCOTERMS_SSP
                                    , TO_NUMBER(V_ROWS(I).PRIORITY)
                                    , TO_NUMBER(V_ROWS(I).ROUTE_ID)
                                    , V_ROWS(I).BOD_VALID
                                    , V_FROM_YYYYMMDD
                                    , V_TO_YYYYMMDD
                                    , NVL(V_ROWS(I).BEFORE_LEAD_TIME, '0')
                                    , NVL(V_ROWS(I).AFTER_LEAD_TIME, '0')
                                    , V_ROWS(I).REMARKS
                                    , P_USER_ID
                                    , V_WORKING_TIME
                                    , P_USER_ID
                                    , V_WORKING_TIME);

                        /* BOD_ITEM 적용 기간 동기화 (AS-IS L438-443) */
                        UPDATE SCP_MST_BOD_ITEM
                           SET FROM_YYYYMMDD    = V_FROM_YYYYMMDD
                             , TO_YYYYMMDD      = V_TO_YYYYMMDD
                             , LAST_UPDATED_BY  = P_USER_ID
                             , LAST_UPDATE_DATE = V_WORKING_TIME
                         WHERE BOD_ID = V_BOD_ID;

                    END IF;

                    /* DAP 행 이력 저장 — 중복으로 신규 등록을 건너뛴 경우에도 실행 (AS-IS L454-473) */
                    PR_SCP_MST_BOD_HIST(V_BOD_ID
                                      , V_ROWS(I).DIVISION_ID
                                      , V_ROWS(I).FROM_SITE_CODE
                                      , V_ROWS(I).TO_SITE_CODE
                                      , V_INCOTERMS
                                      , V_ROWS(I).INCOTERMS_SSP
                                      , V_ROWS(I).SAFETY_STOCK
                                      , V_ROWS(I).PRIORITY
                                      , V_ROWS(I).ROUTE_ID
                                      , V_ROWS(I).BOD_VALID
                                      , V_FROM_YYYYMMDD
                                      , V_TO_YYYYMMDD
                                      , V_ROWS(I).BEFORE_LEAD_TIME
                                      , V_ROWS(I).AFTER_LEAD_TIME
                                      , V_ROWS(I).REMARKS
                                      , P_USER_ID
                                      , V_WORKING_TIME
                                      , P_USER_ID
                                      , V_WORKING_TIME);
                END IF;

            ELSIF V_ROWS(I).CRUD_TYPE = 'D' THEN

                /* 삭제 (AS-IS L479-483) */
                DELETE
                  FROM SCP_MST_BOD
                 WHERE BOD_ID = V_BOD_ID;

            END IF;

        END LOOP;

        /* 루프2 의 VMI_YN 은 AS-IS 가 루프1 종료 인덱스를 그대로 쓴다 — 마지막 행 값 고정 */
        IF V_MAX_LOOP_CNT > 0 THEN
            V_VMI_YN_LAST := V_ROWS(V_MAX_LOOP_CNT).VMI_YN;
        END IF;

        /* ----------------------------------------------------------------------------------- */
        /* 루프2 : 기간 중복 검증 (AS-IS L505-670) — 저장이 모두 끝난 뒤에 센다                 */
        /* ----------------------------------------------------------------------------------- */
        FOR I IN 1 .. V_MAX_LOOP_CNT LOOP

            V_INCOTERMS      := V_ROWS(I).INCOTERMS;
            V_TRANSPORT_MODE := NULL;
            V_DUP_CNT        := 0;

            V_DIVISION_ID    := V_ROWS(I).DIVISION_ID;
            V_CUSTOMER       := V_ROWS(I).CUSTOMER;
            V_FROM_SITE      := V_ROWS(I).FROM_SITE_CODE;
            V_TO_SITE        := V_ROWS(I).TO_SITE_CODE;
            V_INCOTERMS_SSP  := V_ROWS(I).INCOTERMS_SSP;
            V_PRIORITY       := V_ROWS(I).PRIORITY;
            V_ROUTE_ID       := V_ROWS(I).ROUTE_ID;
            V_FROM_YYYYMMDD   := CASE WHEN REGEXP_LIKE(V_ROWS(I).FROM_YYYYMMDD, '^[0-9]{4}[-/.][0-9]{2}[-/.][0-9]{2}')
                                 THEN SUBSTR(REPLACE(REPLACE(REPLACE(V_ROWS(I).FROM_YYYYMMDD, '-'), '/'), '.'), 1, 8)
                                 ELSE V_ROWS(I).FROM_YYYYMMDD END;   -- 2026.09.22 AJS
            V_TO_YYYYMMDD     := CASE WHEN REGEXP_LIKE(V_ROWS(I).TO_YYYYMMDD, '^[0-9]{4}[-/.][0-9]{2}[-/.][0-9]{2}')
                                 THEN SUBSTR(REPLACE(REPLACE(REPLACE(V_ROWS(I).TO_YYYYMMDD, '-'), '/'), '.'), 1, 8)
                                 ELSE V_ROWS(I).TO_YYYYMMDD END;   -- 2026.09.22 AJS

            IF P_INPUT_STATUS = 'R' AND V_VMI_YN_LAST = 'Y' THEN
                V_INCOTERMS := 'DAP';
            END IF;

            /* E20260616-000549 : Route 의 Transport Mode 로 비교 (AS-IS L556-559) */
            BEGIN
                SELECT TRANSPORT_MODE
                  INTO V_TRANSPORT_MODE
                  FROM SCP_MST_DISTRIBUTION_ROUTE
                 WHERE ROUTE_ID = TO_NUMBER(V_ROWS(I).ROUTE_ID);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_TRANSPORT_MODE := NULL;
            END;

            SELECT COUNT(*)
              INTO V_DUP_CNT
              FROM SCP_MST_BOD A
                 , SCP_MST_DISTRIBUTION_ROUTE B
             WHERE A.ROUTE_ID       = B.ROUTE_ID
               AND A.DIVISION_ID    = V_ROWS(I).DIVISION_ID
               AND A.FROM_SITE      = V_ROWS(I).FROM_SITE_CODE
               AND A.TO_SITE        = V_ROWS(I).TO_SITE_CODE
               AND A.INCOTERMS      = V_INCOTERMS
               AND B.TRANSPORT_MODE = V_TRANSPORT_MODE
               AND A.ATTRIBUTE3    >= V_FROM_YYYYMMDD
               AND A.ATTRIBUTE2    <= V_TO_YYYYMMDD;

            IF V_DUP_CNT > 1 THEN
                V_ERR_CODE := 99030;
                V_ERR_MSG  := '중복된 기간을 저장할 수 없습니다';
                RAISE EX_BIZ;
            END IF;

        END LOOP;

        /* 종료 LOG (AS-IS L672-676) */
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'END', 0,
                                       '########## END of procedure ##########', '', SYSDATE);

        COMMIT;

        /* BOD_ITEM 재계산 — 이번 저장분만 (AS-IS L681) */
        IF V_BOD_LIST IS NOT NULL THEN
            PR_SCP_MST_BOD_ITEM(V_BOD_LIST);
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT 'S'                     AS RESULT_CODE
                 , TO_CHAR(V_MAX_LOOP_CNT) AS RESULT_CNT
                 , '0'                     AS CODE
                 , 'SUCCESS'               AS MSG
              FROM DUAL;

    EXCEPTION
        WHEN EX_BIZ THEN
            ROLLBACK;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'ERROR', 0, V_ERR_MSG, '', SYSDATE);
            OPEN O_RESULT_CURSOR FOR
                SELECT 'F'                  AS RESULT_CODE
                     , '-1'                 AS CODE
                     , V_ERR_MSG            AS MSG
                     , TO_CHAR(V_ERR_CODE)  AS ERR_CODE
                     , V_ERR_MSG            AS ERR_MESSAGE
                     , V_DIVISION_ID        AS DIVISION_ID
                     , V_CUSTOMER           AS CUSTOMER
                     , V_FROM_SITE          AS FROM_SITE_CODE
                     , V_TO_SITE            AS TO_SITE_CODE
                     , V_INCOTERMS          AS INCOTERMS
                     , V_INCOTERMS_SSP      AS INCOTERMS_SSP
                     , V_TRANSPORT_MODE     AS TRANSPORT_MODE
                     , V_PRIORITY           AS PRIORITY
                     , V_ROUTE_ID           AS ROUTE_ID
                     , V_BOD_ID             AS BOD_ID
                     , V_FROM_YYYYMMDD      AS FROM_YYYYMMDD
                     , V_TO_YYYYMMDD        AS TO_YYYYMMDD
                  FROM DUAL;
        WHEN OTHERS THEN
            ROLLBACK;
            V_ERR_CODE := SQLCODE;
            V_ERR_MSG  := SUBSTR(SQLERRM, 1, 4000);
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'ERROR', 0, V_ERR_MSG, '', SYSDATE);
            OPEN O_RESULT_CURSOR FOR
                SELECT 'F'                  AS RESULT_CODE
                     , '-1'                 AS CODE
                     , V_ERR_MSG            AS MSG
                     , TO_CHAR(V_ERR_CODE)  AS ERR_CODE
                     , V_ERR_MSG            AS ERR_MESSAGE
                     , V_DIVISION_ID        AS DIVISION_ID
                     , V_CUSTOMER           AS CUSTOMER
                     , V_FROM_SITE          AS FROM_SITE_CODE
                     , V_TO_SITE            AS TO_SITE_CODE
                     , V_INCOTERMS          AS INCOTERMS
                     , V_INCOTERMS_SSP      AS INCOTERMS_SSP
                     , V_TRANSPORT_MODE     AS TRANSPORT_MODE
                     , V_PRIORITY           AS PRIORITY
                     , V_ROUTE_ID           AS ROUTE_ID
                     , V_BOD_ID             AS BOD_ID
                     , V_FROM_YYYYMMDD      AS FROM_YYYYMMDD
                     , V_TO_YYYYMMDD        AS TO_YYYYMMDD
                  FROM DUAL;
    END P_SCP0007_SAVE_BOD;

END PKG_SCP0007;