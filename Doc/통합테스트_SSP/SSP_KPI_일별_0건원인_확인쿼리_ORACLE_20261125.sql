-- ==============================================================================================================
-- 일별 KPI(PR_SSP_KPI_BR_BOD_REGISTRATION) 0건 원인 확인 · Oracle(클라우드) · 조회만 수행 · 실행일 20261125
-- 순서 : [D1] 로그 → [D2] 실행 중 여부 → [D3] 기준 정보 → [D4] 대상 추출 건수 → [D5] 적재 이력
-- 0건이 되는 경로(원문 기준) : ① 실행 안 됨 ② 오류 → ROLLBACK(오류를 밖으로 내지 않음) ③ 달력 실행일 행 없음 ④ 대상(BOD 미등록 구간) 0건
-- 실행 : DBeaver 에서 쿼리 하나씩(Ctrl+Enter). 각 쿼리 PRM 줄의 실행일만 바꿈. [D4] 는 SYSDATE 기준이라 실행일 당일에 실행
-- 원문 기준 : 사내 ZIOUI1 2026-11-25 17:40:31 조회(LAST_DDL_TIME 2026-11-17 17:17:14) · 생성 tools/Analysis/ssp_it_precheck/gen_kpi_br_diag.py
-- ZIOUI1 시험(2026-11-25 17:40:31) : D1 0.1초 0행 · D2 0.1초 0행 · D3 0.1초 1행 · D4 349.9초 3행 · D5 0.0초 0행
-- ==============================================================================================================

-- ==============================================================================================================
-- [D1] 실행일 실행 로그(START · TXN · END · ERROR)
-- 판정 : START 가 없으면 실행되지 않은 것(다른 DB · 다른 접속에서 실행했는지, [R1] 확인 문장 ORA-20001 로 멈췄는지 확인)
--        ERROR 행이 있으면 오류로 ROLLBACK 된 것. 프로그램이 오류를 밖으로 내지 않아 실행 창에서는 정상 종료로 보임 → LOG_MESSAGE · DESCRIPTION(오류 줄) 회신
--        TXN 행(INSERT INTO SSP_KPI_BR_BOD_REGISTRATION)이 있고 ERROR 가 없으면 COMMIT 까지 끝난 것 → 0건 원인은 [D3] [D4]
--        START 만 있고 END 가 없으면 아직 실행 중 → [D2]
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT L.EVENT_DATE
     , L.LOG_TYPE
     , L.LOG_COUNT
     , SUBSTR(L.LOG_MESSAGE, 1, 300) AS LOG_MESSAGE
     , SUBSTR(L.DESCRIPTION, 1, 400) AS DESCRIPTION
     , L.SQL_ERR_CODE
     , SUBSTR(L.SQL_ERR_MSG, 1, 300) AS SQL_ERR_MSG
     , L.CREATED_BY
  FROM SCM_SYS_LOG_BATCH L
     , PRM
 WHERE L.PROGRAM_NAME = 'PR_SSP_KPI_BR_BOD_REGISTRATION'
   AND L.EVENT_DATE >= TO_DATE(PRM.P_DAY, 'YYYYMMDD')
   AND L.EVENT_DATE <  TO_DATE(PRM.P_DAY, 'YYYYMMDD') + 1
 ORDER BY L.EVENT_DATE;

-- ==============================================================================================================
-- [D2] 지금 실행 중인지(V$ 권한 필요)
-- 판정 : 행이 있으면 아직 실행 중. SQL_RUN_MIN · EVENT 확인. ORA-00942 면 DBA 에 실행 요청
-- ==============================================================================================================
SELECT S.INST_ID
     , S.SID
     , S.SERIAL#
     , S.USERNAME
     , S.MODULE
     , S.STATUS
     , S.SQL_EXEC_START
     , ROUND((SYSDATE - S.SQL_EXEC_START) * 1440, 1) AS SQL_RUN_MIN
     , S.EVENT
     , S.SQL_ID
  FROM GV$SESSION S
 WHERE S.PLSQL_ENTRY_OBJECT_ID = (SELECT O.OBJECT_ID
                                    FROM ALL_OBJECTS O
                                   WHERE O.OWNER       = 'SCM_MGR'
                                     AND O.OBJECT_NAME = 'PR_SSP_KPI_BR_BOD_REGISTRATION'
                                     AND O.OBJECT_TYPE = 'PROCEDURE');

-- ==============================================================================================================
-- [D3] 최종 입력 조건 · 기준 정보 건수
-- 판정 : CALENDAR_CNT = 0 이면 0건(최종 INSERT 가 SCM_SYS_CALENDAR_M 실행일 행과 JOIN, 원문 659 ~ 661줄)
--        FROM_SITE_CNT · TO_SITE_CNT · INCOTERMS_CNT · MKT_FCST_CNT 중 0 이 있으면 대상 추출이 0건(원문 77 ~ 102, 165 ~ 178, 571 ~ 574줄)
--        BOD_VALID_CNT = 실행일에 유효한 BOD(ATTRIBUTE2 ≤ 실행일 ≤ ATTRIBUTE3) · ROUTE_VALID_CNT = 유효 배송 경로
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT (SELECT COUNT(*) FROM SCM_SYS_CALENDAR_M C, PRM WHERE C.BASIS_YYYYMMDD = PRM.P_DAY) AS CALENDAR_CNT
     , (SELECT COUNT(*) FROM (SELECT A.SCM_SITE_ID FROM SCM_MST_SITE A JOIN SCM_MST_DIVISION D ON A.DIVISION_ID = D.DIVISION_ID WHERE A.SITE_TYPE = 'PLANT' AND A.VALID_YN = 'Y' AND D.ATTRIBUTE3 IN ('40','81','82'))) AS FROM_SITE_CNT
     , (SELECT COUNT(*) FROM (SELECT A.SCM_SITE_ID FROM ( SELECT A.SCM_SITE_ID FROM SCM_MST_SITE A JOIN SCM_MST_DIVISION D ON A.DIVISION_ID = D.DIVISION_ID WHERE A.VALID_YN = 'Y' AND D.ATTRIBUTE3 IN ('40','81','82') UNION SELECT A.SCM_SITE_ID FROM SCM_MST_SITE A WHERE A.VALID_YN = 'Y' AND A.SCM_SITE_ID LIKE '%' || '-A' ) A)) AS TO_SITE_CNT
     , (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WHERE A.LOOKUP_TYPE = 'INCOTERMS' AND A.VALID_YN = 'Y') AS INCOTERMS_CNT
     , (SELECT COUNT(*) FROM DM_PLN_MKT_FCST F, SCM_MST_DIVISION D WHERE F.DIVISION_ID = D.DIVISION_ID AND D.ATTRIBUTE3 IN ('40', '81', '82') AND F.MEASURE IN ('MKT_FCST', 'VMI_In_Req')) AS MKT_FCST_CNT
     , (SELECT COUNT(*) FROM SCP_MST_BOD B, PRM WHERE B.ATTRIBUTE2 <= PRM.P_DAY AND B.ATTRIBUTE3 >= PRM.P_DAY) AS BOD_VALID_CNT
     , (SELECT COUNT(*) FROM SCP_MST_DISTRIBUTION_ROUTE R WHERE R.VALID_YN = 'Y') AS ROUTE_VALID_CNT
  FROM DUAL;

-- ==============================================================================================================
-- [D4] 대상 추출 결과 건수(원문 대상 추출 SELECT 그대로, 사업부별)
-- 판정 : 프로그램이 넣을 행 수. 결과 0행이면 실행일 기준 BOD 미등록 구간이 없음(MKT FCST 구간이 모두 BOD 등록됨) → 0건이 정상 결과
--        TARGET_CNT 가 있는데 테이블에 행이 없으면 → [D1] ERROR · [D3] CALENDAR_CNT 확인
-- 원문 = PR_SSP_KPI_BR_BOD_REGISTRATION 128 ~ 597줄(사내 ZIOUI1 LAST_DDL_TIME 2026-11-17 17:17:14). 세션 임시 테이블 GT_SKBBR_PIVOT_FROM · _TO 는 원문 78 ~ 102줄 SELECT 로 바꿈
-- SYSDATE 기준 쿼리라 실행일 당일에 실행
-- ==============================================================================================================
SELECT X.DIVISION_ID
     , COUNT(*) AS TARGET_CNT
     , SUM(X.ROUTE_CNT) AS ROUTE_CNT
  FROM (
        SELECT DISTINCT
               T.DIVISION_ID
              ,T.FROM_SITE
              ,T.FROM_CITY
              ,T.TO_SITE
              ,T.TO_CITY
              /* ,t.incoterms */
              ,NVL(S.SSP_INCOTERMS, T.INCOTERMS)  AS INCOTERMS
              ,T.TRANSPORT_MODE
              ,T.CUSTOMER
              ,(SELECT COUNT(*) AS ROUTE_CNT FROM SCP_MST_DISTRIBUTION_ROUTE WHERE TRANSPORT_MODE = T.TRANSPORT_MODE AND FROM_CITY = T.FROM_CITY  AND TO_CITY = T.TO_CITY ) AS ROUTE_CNT
              ,CASE WHEN SUBSTR(T.FROM_SITE, -1) = 'E' THEN (SELECT NVL(VMI_YN,'N') FROM SCM_MST_SITE WHERE SCM_SITE_ID = T.TO_SITE AND ROWNUM = 1 )
               ELSE (SELECT NVL(VMI_YN,'N') FROM SCM_MST_SITE WHERE DIVISION_ID = T.DIVISION_ID AND SCM_SITE_ID = T.TO_SITE ) END VMI_YN
              ,TO_CHAR(SYSDATE, 'YYYYMMDD') AS YYYYMMDD
          FROM (
               SELECT
                      MA.DIVISION_ID
                     ,MA.CUSTOMER
                     ,MA.INCOTERMS
                     ,MA.FROM_SITE
                     ,MA.TO_SITE
                     ,MA.FROM_CITY
                     ,MA.TO_CITY
                     ,MA.TRANSPORT_MODE
                    /* [ma] table - division_id ~ transport_mode_code -> 4 Steps */
                 FROM (
                      /* 1-1. # Div = 81, BOD Requied - From Site : Project route , To Site : Mkt FCST project_code, sales_site_id Join */
                      SELECT T.DIVISION_ID, T.TO_SITE, T.CUSTOMER, T.INCOTERMS, T.FROM_SITE, T.FROM_COUNTRY, T.FROM_CITY, T.TO_COUNTRY, T.TO_CITY, U.TRANSPORT_MODE
                            ,NULL CREATED_BY, NULL CREATION_DATE, NULL LAST_UPDATED_BY, NULL LAST_UPDATE_DATE
                        FROM (
                             SELECT DISTINCT DE.DIVISION_ID, DE.SCM_SITE_ID AS TO_SITE,  DE.CUSTOMER, DE.INCOTERMS, SI.SCM_SITE_ID AS FROM_SITE
                                   ,F_CI.COUNTRY    AS FROM_COUNTRY
                                   ,F_CI.CITY       AS FROM_CITY
                                   ,T_CI.COUNTRY    AS TO_COUNTRY
                                   ,T_CI.CITY       AS TO_CITY
                               FROM (
                                    SELECT F.DIVISION_ID, F.SCM_SITE_ID, M.END_CUSTOMER AS CUSTOMER, F.INCOTERMS, F.PROJECT_CODE, F.ITEM_ID
                                      FROM DM_PLN_MKT_FCST F
                                           JOIN SCM_MST_DIVISION D
                                        ON F.DIVISION_ID = D.DIVISION_ID
                                           JOIN SCM_MST_SITE M
                                        ON F.DIVISION_ID = M.DIVISION_ID
                                       AND F.SCM_SITE_ID = M.SCM_SITE_ID
                                           LEFT JOIN SCM_MST_SITE S
                                        ON S.DIVISION_ID = F.DIVISION_ID
                                       AND S.SCM_SITE_ID = F.SCM_SITE_ID
                                       AND S.VMI_YN='Y'
                                     WHERE 1=1
                                       AND D.ATTRIBUTE3  = '81'
                                       AND F.MEASURE = CASE WHEN NVL(S.VMI_YN, 'N') = 'Y' THEN 'VMI_In_Req' ELSE 'MKT_FCST' END
                                    ) DE
                                    LEFT OUTER JOIN (SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.ITEM_ID, B.PROJECT_CODE, C.PRIORITY ,C.SALES_SITE_ID, SUBSTR(PLANT_SITE_ID, -1) PLANT_TYPE
                                                       FROM SCM_MST_SITE A
                                                          , SCM_MST_SITE_ITEM B
                                                          , SCM_MST_SITE_ITEM_PRIORITY C
                                                          , SCM_MST_DIVISION D
                                                      WHERE A.DIVISION_ID  = B.DIVISION_ID
                                                        AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                                                        AND B.DIVISION_ID  = C.DIVISION_ID
                                                        AND B.SCM_SITE_ID  = C.PLANT_SITE_ID
                                                        AND B.PROJECT_CODE = C.PROJECT_CODE
                                                        AND B.ITEM_ID      = C.ITEM_ID
                                                        AND A.DIVISION_ID  = D.DIVISION_ID
                                                        AND A.VALID_YN     = 'Y'
                                                        AND B.VALID_YN     = 'Y'
                                                        AND C.VALID_YN     = 'Y'
                                                        AND A.SITE_TYPE    = 'PLANT'
                                                        AND D.ATTRIBUTE3   = '81'
                                                    ) SI
                                 ON DE.DIVISION_ID  = SI.DIVISION_ID
                                AND ((SI.PLANT_TYPE != 'E' AND DE.PROJECT_CODE = SI.PROJECT_CODE  AND DE.SCM_SITE_ID  = SI.SALES_SITE_ID)  OR (SI.PLANT_TYPE = 'E'))
                                AND DE.ITEM_ID      = SI.ITEM_ID
                                    LEFT OUTER JOIN (
                                                    SELECT  DIVISION_ID, SCM_SITE_ID, COUNTRY, CITY
                                                      FROM SCM_MST_SITE A
                                                     WHERE A.VALID_YN = 'Y'
                                                    ) F_CI
                                 ON DE.DIVISION_ID = F_CI.DIVISION_ID AND SI.SCM_SITE_ID = F_CI.SCM_SITE_ID
                                    LEFT OUTER JOIN (
                                                    SELECT DIVISION_ID, SCM_SITE_ID,COUNTRY,CITY
                                                      FROM SCM_MST_SITE A
                                                     WHERE A.VALID_YN = 'Y'
                                                    ) T_CI
                                 ON DE.DIVISION_ID = T_CI.DIVISION_ID AND DE.SCM_SITE_ID = T_CI.SCM_SITE_ID
                             ) T
                             LEFT JOIN (
                                       SELECT DISTINCT FROM_COUNTRY, FROM_CITY, TO_COUNTRY, TO_CITY, TRANSPORT_MODE
                                         FROM SCP_MST_DISTRIBUTION_ROUTE
                                        WHERE VALID_YN ='Y'
                                       ) U
                            ON T.FROM_COUNTRY = U.FROM_COUNTRY
                           AND T.FROM_CITY    = U.FROM_CITY
                           AND T.TO_COUNTRY   = U.TO_COUNTRY
                           AND T.TO_CITY      = U.TO_CITY
                       UNION ALL
                      /* 1-2. # Div = 40,82,  BOD Requied - From Site : Project route , To Site : Mkt FCST project_code, sales_site_id NOT Join */
                      SELECT T.DIVISION_ID, T.TO_SITE, T.CUSTOMER, T.INCOTERMS, T.FROM_SITE, T.FROM_COUNTRY, T.FROM_CITY, T.TO_COUNTRY, T.TO_CITY, U.TRANSPORT_MODE
                            ,NULL CREATED_BY, NULL CREATION_DATE, NULL LAST_UPDATED_BY, NULL LAST_UPDATE_DATE
                        FROM (
                             SELECT DISTINCT DE.DIVISION_ID, DE.SCM_SITE_ID AS TO_SITE,  DE.CUSTOMER, DE.INCOTERMS, SI.SCM_SITE_ID AS FROM_SITE
                                  , F_CI.COUNTRY AS FROM_COUNTRY
                                  , F_CI.CITY    AS FROM_CITY
                                  , T_CI.COUNTRY AS TO_COUNTRY
                                  , T_CI.CITY    AS TO_CITY
                               FROM (
                                    SELECT F.DIVISION_ID, F.SCM_SITE_ID, M.END_CUSTOMER AS CUSTOMER, F.INCOTERMS, F.PROJECT_CODE, F.ITEM_ID
                                      FROM DM_PLN_MKT_FCST F
                                           JOIN SCM_MST_DIVISION D
                                        ON F.DIVISION_ID  = D.DIVISION_ID
                                           JOIN SCM_MST_SITE M
                                        ON F.DIVISION_ID  = M.DIVISION_ID
                                       AND F.SCM_SITE_ID  = M.SCM_SITE_ID
                                           LEFT JOIN SCM_MST_SITE S
                                        ON S.DIVISION_ID  = F.DIVISION_ID
                                       AND S.SCM_SITE_ID  = F.SCM_SITE_ID
                                       AND S.VMI_YN       = 'Y'
                                     WHERE 1 = 1
                                       AND D.ATTRIBUTE3 IN ('40','82')
                                       AND F.MEASURE = CASE WHEN NVL(S.VMI_YN, 'N') = 'Y' THEN 'VMI_In_Req' ELSE 'MKT_FCST' END
                                    ) DE
                                    LEFT OUTER JOIN (
                                                    SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.ITEM_ID, B.PROJECT_CODE, C.PRIORITY ,C.SALES_SITE_ID, SUBSTR(PLANT_SITE_ID, -1) PLANT_TYPE
                                                      FROM SCM_MST_SITE A
                                                         , SCM_MST_SITE_ITEM B
                                                         , SCM_MST_SITE_ITEM_PRIORITY C
                                                         , SCM_MST_DIVISION D
                                                     WHERE A.DIVISION_ID  = B.DIVISION_ID
                                                       AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                                                       AND B.DIVISION_ID  = C.DIVISION_ID
                                                       AND B.SCM_SITE_ID  = C.PLANT_SITE_ID
                                                       AND B.PROJECT_CODE = C.PROJECT_CODE
                                                       AND B.ITEM_ID      = C.ITEM_ID
                                                       AND A.DIVISION_ID  = D.DIVISION_ID
                                                       AND A.VALID_YN     = 'Y'
                                                       AND B.VALID_YN     = 'Y'
                                                       AND C.VALID_YN     = 'Y'
                                                       AND A.SITE_TYPE    = 'PLANT'
                                                       AND D.ATTRIBUTE3  IN ('40','82')
                                                    ) SI
                                 ON DE.DIVISION_ID  = SI.DIVISION_ID
                                AND DE.ITEM_ID      = SI.ITEM_ID
                                    LEFT OUTER JOIN (
                                                    SELECT DIVISION_ID, SCM_SITE_ID, COUNTRY, CITY
                                                      FROM SCM_MST_SITE A
                                                     WHERE A.VALID_YN = 'Y'
                                                    ) F_CI
                                 ON DE.DIVISION_ID = F_CI.DIVISION_ID AND SI.SCM_SITE_ID = F_CI.SCM_SITE_ID
                                    LEFT OUTER JOIN (
                                                    SELECT DIVISION_ID, SCM_SITE_ID,COUNTRY,CITY
                                                      FROM SCM_MST_SITE A
                                                     WHERE A.VALID_YN = 'Y'
                                                    ) T_CI
                                 ON DE.DIVISION_ID = T_CI.DIVISION_ID AND DE.SCM_SITE_ID = T_CI.SCM_SITE_ID
                             ) T
                             LEFT JOIN (
                                       SELECT DISTINCT FROM_COUNTRY, FROM_CITY, TO_COUNTRY, TO_CITY, TRANSPORT_MODE
                                         FROM SCP_MST_DISTRIBUTION_ROUTE
                                        WHERE VALID_YN ='Y'
                                       ) U
                            ON T.FROM_COUNTRY = U.FROM_COUNTRY
                           AND T.FROM_CITY    = U.FROM_CITY
                           AND T.TO_COUNTRY   = U.TO_COUNTRY
                           AND T.TO_CITY      = U.TO_CITY
                       UNION ALL
                        /* 2-1. # Div = 81, BOD Requied - VMI = Y and scp_mst_bod not exists DAP raw insert.project_code, sales_site_id Join */
                      SELECT A.DIVISION_ID, A.TO_SITE, A.CUSTOMER, 'DAP' INCOTERMS, A.FROM_SITE, A.FROM_COUNTRY, A.FROM_CITY, A.TO_COUNTRY, A.TO_CITY, A.TRANSPORT_MODE
                            ,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        FROM (
                             SELECT T.DIVISION_ID, T.TO_SITE, T.CUSTOMER, T.INCOTERMS, T.FROM_SITE, T.FROM_COUNTRY, T.FROM_CITY, T.TO_COUNTRY, T.TO_CITY, U.TRANSPORT_MODE
                                   ,NULL CREATED_BY, NULL CREATION_DATE, NULL LAST_UPDATED_BY, NULL LAST_UPDATE_DATE
                               FROM (
                                    SELECT DISTINCT DE.DIVISION_ID, DE.SCM_SITE_ID AS TO_SITE,  DE.CUSTOMER, DE.INCOTERMS, SI.SCM_SITE_ID AS FROM_SITE
                                         , F_CI.COUNTRY  AS FROM_COUNTRY
                                         , F_CI.CITY     AS FROM_CITY
                                         , T_CI.COUNTRY  AS TO_COUNTRY
                                         , T_CI.CITY     AS TO_CITY
                                      FROM (
                                           SELECT F.DIVISION_ID, F.SCM_SITE_ID, M.END_CUSTOMER AS CUSTOMER, F.INCOTERMS, F.PROJECT_CODE, F.ITEM_ID
                                             FROM DM_PLN_MKT_FCST F
                                                  JOIN SCM_MST_DIVISION D
                                               ON F.DIVISION_ID = D.DIVISION_ID
                                                  JOIN SCM_MST_SITE M
                                               ON F.DIVISION_ID = M.DIVISION_ID
                                              AND F.SCM_SITE_ID = M.SCM_SITE_ID
                                              AND M.VMI_YN = 'Y'
                                                  LEFT JOIN SCM_MST_SITE S
                                               ON S.DIVISION_ID=F.DIVISION_ID AND S.SCM_SITE_ID=F.SCM_SITE_ID AND S.VMI_YN='Y'
                                            WHERE 1 = 1
                                              AND D.ATTRIBUTE3 = '81'
                                              AND F.MEASURE = CASE WHEN NVL(S.VMI_YN, 'N') = 'Y' THEN 'VMI_In_Req' ELSE 'MKT_FCST' END
                                           ) DE
                                           LEFT OUTER JOIN (
                                                           SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.ITEM_ID, B.PROJECT_CODE, C.PRIORITY ,C.SALES_SITE_ID, SUBSTR(PLANT_SITE_ID, -1) PLANT_TYPE
                                                             FROM SCM_MST_SITE A
                                                                , SCM_MST_SITE_ITEM B
                                                                , SCM_MST_SITE_ITEM_PRIORITY C
                                                                , SCM_MST_DIVISION D
                                                            WHERE A.DIVISION_ID  = B.DIVISION_ID
                                                              AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                                                              AND B.DIVISION_ID  = C.DIVISION_ID
                                                              AND B.SCM_SITE_ID  = C.PLANT_SITE_ID
                                                              AND B.PROJECT_CODE = C.PROJECT_CODE
                                                              AND B.ITEM_ID      = C.ITEM_ID
                                                              AND A.DIVISION_ID  = D.DIVISION_ID
                                                              AND A.VALID_YN     = 'Y'
                                                              AND B.VALID_YN     = 'Y'
                                                              AND C.VALID_YN     = 'Y'
                                                              AND A.SITE_TYPE    = 'PLANT'
                                                              AND D.ATTRIBUTE3   = '81'
                                                           ) SI
                                        ON DE.DIVISION_ID  = SI.DIVISION_ID
                                       AND ((SI.PLANT_TYPE  != 'E' AND DE.PROJECT_CODE = SI.PROJECT_CODE  AND DE.SCM_SITE_ID  = SI.SALES_SITE_ID) OR (SI.PLANT_TYPE = 'E'))
                                       AND DE.ITEM_ID      = SI.ITEM_ID
                                           LEFT OUTER JOIN (
                                                           SELECT DIVISION_ID, SCM_SITE_ID,COUNTRY,CITY
                                                             FROM SCM_MST_SITE A
                                                            WHERE A.VALID_YN = 'Y'
                                                           ) F_CI
                                        ON DE.DIVISION_ID = F_CI.DIVISION_ID AND SI.SCM_SITE_ID = F_CI.SCM_SITE_ID
                                           LEFT OUTER JOIN (
                                                           SELECT DIVISION_ID, SCM_SITE_ID,COUNTRY,CITY
                                                             FROM SCM_MST_SITE A
                                                            WHERE A.VALID_YN = 'Y'
                                                           ) T_CI
                                        ON DE.DIVISION_ID = T_CI.DIVISION_ID AND DE.SCM_SITE_ID = T_CI.SCM_SITE_ID
                                    ) T
                                    LEFT JOIN (
                                              SELECT DISTINCT FROM_COUNTRY, FROM_CITY, TO_COUNTRY, TO_CITY, TRANSPORT_MODE
                                                FROM SCP_MST_DISTRIBUTION_ROUTE
                                               WHERE VALID_YN ='Y'
                                              ) U
                                 ON T.FROM_COUNTRY = U.FROM_COUNTRY
                                AND T.FROM_CITY    = U.FROM_CITY
                                AND T.TO_COUNTRY   = U.TO_COUNTRY
                                AND T.TO_CITY      = U.TO_CITY
                             ) A
                       WHERE NOT EXISTS (
                                        SELECT 1
                                          FROM (
                                               SELECT DISTINCT A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, B.TRANSPORT_MODE
                                                 FROM SCP_MST_BOD A
                                                      INNER JOIN SCP_MST_BOD_V B
                                                   ON A.DIVISION_ID  = B.DIVISION_ID
                                                  AND A.BOD_ID       = B.BOD_ID
                                                  AND A.FROM_SITE    = B.FROM_SITE
                                                  AND A.TO_SITE      = B.TO_SITE
                                                  AND A.INCOTERMS    = B.INCOTERMS
                                                WHERE A.INCOTERMS    = 'DAP'
                                              ) B
                                         WHERE A.DIVISION_ID      = B.DIVISION_ID
                                           AND A.FROM_SITE        = B.FROM_SITE
                                           AND A.TO_SITE          = B.TO_SITE
                                           AND A.TRANSPORT_MODE   = B.TRANSPORT_MODE
                                        )
                       UNION ALL
                        /* 2-2. # Div = 40,82, BOD Requied - VMI = Y and scp_mst_bod not exists DAP raw insert. project_code, sales_site_id NOT Join */
                      SELECT A.DIVISION_ID, A.TO_SITE, A.CUSTOMER, 'DAP' INCOTERMS, A.FROM_SITE, A.FROM_COUNTRY, A.FROM_CITY, A.TO_COUNTRY, A.TO_CITY, A.TRANSPORT_MODE
                            ,CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        FROM (
                             SELECT T.DIVISION_ID, T.TO_SITE, T.CUSTOMER, T.INCOTERMS, T.FROM_SITE, T.FROM_COUNTRY, T.FROM_CITY, T.TO_COUNTRY, T.TO_CITY, U.TRANSPORT_MODE
                                   ,NULL CREATED_BY, NULL CREATION_DATE, NULL LAST_UPDATED_BY, NULL LAST_UPDATE_DATE
                               FROM (
                                    SELECT DISTINCT DE.DIVISION_ID, DE.SCM_SITE_ID AS TO_SITE,  DE.CUSTOMER, DE.INCOTERMS, SI.SCM_SITE_ID AS FROM_SITE
                                         , F_CI.COUNTRY  AS FROM_COUNTRY
                                         , F_CI.CITY     AS FROM_CITY
                                         , T_CI.COUNTRY  AS TO_COUNTRY
                                         , T_CI.CITY     AS TO_CITY
                                      FROM (
                                           SELECT  F.DIVISION_ID, F.SCM_SITE_ID, M.END_CUSTOMER AS CUSTOMER, F.INCOTERMS, F.PROJECT_CODE, F.ITEM_ID
                                             FROM DM_PLN_MKT_FCST F
                                                  JOIN SCM_MST_DIVISION D
                                               ON F.DIVISION_ID = D.DIVISION_ID
                                                  JOIN SCM_MST_SITE M
                                               ON F.DIVISION_ID = M.DIVISION_ID
                                              AND F.SCM_SITE_ID = M.SCM_SITE_ID
                                              AND M.VMI_YN = 'Y'
                                                  LEFT JOIN SCM_MST_SITE S
                                               ON S.DIVISION_ID=F.DIVISION_ID
                                              AND S.SCM_SITE_ID=F.SCM_SITE_ID
                                              AND S.VMI_YN='Y'
                                            WHERE 1 = 1
                                              AND D.ATTRIBUTE3 IN ('40','82')
                                              AND F.MEASURE = CASE WHEN NVL(S.VMI_YN, 'N') = 'Y' THEN 'VMI_In_Req' ELSE 'MKT_FCST' END
                                           ) DE
                                           LEFT OUTER JOIN (
                                                           SELECT A.DIVISION_ID, A.SCM_SITE_ID, B.ITEM_ID, B.PROJECT_CODE, C.PRIORITY ,C.SALES_SITE_ID, SUBSTR(PLANT_SITE_ID, -1) PLANT_TYPE
                                                             FROM SCM_MST_SITE A
                                                                , SCM_MST_SITE_ITEM B
                                                                , SCM_MST_SITE_ITEM_PRIORITY C
                                                                , SCM_MST_DIVISION D
                                                            WHERE A.DIVISION_ID  = B.DIVISION_ID
                                                              AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                                                              AND B.DIVISION_ID  = C.DIVISION_ID
                                                              AND B.SCM_SITE_ID  = C.PLANT_SITE_ID
                                                              AND B.PROJECT_CODE = C.PROJECT_CODE
                                                              AND B.ITEM_ID      = C.ITEM_ID
                                                              AND A.DIVISION_ID  = D.DIVISION_ID
                                                              AND A.VALID_YN     = 'Y'
                                                              AND B.VALID_YN     = 'Y'
                                                              AND C.VALID_YN     = 'Y'
                                                              AND A.SITE_TYPE    = 'PLANT'
                                                              AND D.ATTRIBUTE3  IN ('40','82')
                                                           ) SI
                                        ON DE.DIVISION_ID  = SI.DIVISION_ID
                                       AND DE.ITEM_ID      = SI.ITEM_ID
                                           LEFT OUTER JOIN (
                                                           SELECT DIVISION_ID, SCM_SITE_ID,COUNTRY,CITY
                                                             FROM SCM_MST_SITE A
                                                            WHERE A.VALID_YN = 'Y'
                                                           ) F_CI
                                        ON DE.DIVISION_ID = F_CI.DIVISION_ID AND SI.SCM_SITE_ID = F_CI.SCM_SITE_ID
                                           LEFT OUTER JOIN (
                                                           SELECT DIVISION_ID, SCM_SITE_ID,COUNTRY,CITY
                                                             FROM SCM_MST_SITE A
                                                            WHERE A.VALID_YN = 'Y'
                                                           ) T_CI
                                        ON DE.DIVISION_ID = T_CI.DIVISION_ID AND DE.SCM_SITE_ID = T_CI.SCM_SITE_ID
                                    ) T
                                    LEFT JOIN (
                                              SELECT DISTINCT FROM_COUNTRY, FROM_CITY, TO_COUNTRY, TO_CITY, TRANSPORT_MODE
                                                FROM SCP_MST_DISTRIBUTION_ROUTE
                                               WHERE VALID_YN ='Y'
                                              ) U
                                 ON T.FROM_COUNTRY = U.FROM_COUNTRY
                                AND T.FROM_CITY    = U.FROM_CITY
                                AND T.TO_COUNTRY   = U.TO_COUNTRY
                                AND T.TO_CITY      = U.TO_CITY
                             ) A
                       WHERE NOT EXISTS (
                                        SELECT 1
                                          FROM (
                                               SELECT DISTINCT A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, B.TRANSPORT_MODE
                                                 FROM SCP_MST_BOD A
                                                      INNER JOIN SCP_MST_BOD_V B
                                                   ON A.DIVISION_ID = B.DIVISION_ID
                                                  AND A.BOD_ID = B.BOD_ID
                                                  AND A.FROM_SITE = B.FROM_SITE
                                                  AND A.TO_SITE = B.TO_SITE
                                                  AND A.INCOTERMS = B.INCOTERMS
                                                WHERE A.INCOTERMS = 'DAP'
                                               ) B
                                         WHERE A.DIVISION_ID    =  B.DIVISION_ID
                                           AND A.FROM_SITE      =  B.FROM_SITE
                                           AND A.TO_SITE        =  B.TO_SITE
                                           AND A.TRANSPORT_MODE =  B.TRANSPORT_MODE
                                        )
                       UNION ALL
                      /*  3. BOD Completed - BOD Master */
                      SELECT A.DIVISION_ID, A.TO_SITE
                            ,(SELECT END_CUSTOMER FROM SCM_MST_SITE WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = A.TO_SITE) AS CUSTOMER
                            ,A.INCOTERMS, A.FROM_SITE
                            ,F_CI.COUNTRY AS FROM_COUNTRY
                            ,F_CI.CITY    AS FROM_CITY
                            ,T_CI.COUNTRY AS TO_COUNTRY
                            ,T_CI.CITY    AS TO_CITY
                            ,RO.TRANSPORT_MODE
                            ,A.CREATED_BY,A.CREATION_DATE, A.LAST_UPDATED_BY,A.LAST_UPDATE_DATE
                        FROM SCP_MST_BOD A
                             INNER JOIN SCP_MST_DISTRIBUTION_ROUTE RO
                          ON A.ROUTE_ID = RO.ROUTE_ID
                             LEFT OUTER JOIN SCM_MST_SITE F_CI
                          ON F_CI.DIVISION_ID = A.DIVISION_ID AND F_CI.SCM_SITE_ID = A.FROM_SITE AND F_CI.VALID_YN = 'Y'
                             LEFT OUTER JOIN SCM_MST_SITE T_CI
                          ON T_CI.SCM_SITE_ID = A.TO_SITE    AND T_CI.VALID_YN = 'Y'
                       WHERE A.ATTRIBUTE2 <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                         AND A.ATTRIBUTE3 >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                       UNION ALL
                      /* 4. BOD Required - VMI = N -> Y Change and scp_mst_bod not exists DAP raw insert. */
                       SELECT A.DIVISION_ID, A.TO_SITE
                             ,(SELECT END_CUSTOMER FROM SCM_MST_SITE WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = A.TO_SITE) AS CUSTOMER
                             ,'DAP' INCOTERMS, A.FROM_SITE
                             ,FROM_COUNTRY
                             ,FROM_CITY
                             ,TO_COUNTRY
                             ,TO_CITY
                             ,TRANSPORT_MODE
                             ,NULL CREATED_BY,NULL CREATION_DATE, NULL LAST_UPDATED_BY,NULL LAST_UPDATE_DATE
                         FROM (
                              SELECT A.DIVISION_ID, A.TO_SITE
                                    ,(SELECT END_CUSTOMER FROM SCM_MST_SITE WHERE DIVISION_ID = A.DIVISION_ID AND SCM_SITE_ID = A.TO_SITE) AS CUSTOMER
                                    ,A.INCOTERMS, A.FROM_SITE
                                    ,F_CI.COUNTRY AS FROM_COUNTRY
                                    ,F_CI.CITY    AS FROM_CITY
                                    ,T_CI.COUNTRY AS TO_COUNTRY
                                    ,T_CI.CITY    AS TO_CITY
                                    ,RO.TRANSPORT_MODE
                                    ,A.CREATED_BY,A.CREATION_DATE, A.LAST_UPDATED_BY,A.LAST_UPDATE_DATE
                                FROM SCP_MST_BOD A
                                     INNER JOIN SCP_MST_DISTRIBUTION_ROUTE RO
                                  ON A.ROUTE_ID = RO.ROUTE_ID
                                     LEFT OUTER JOIN SCM_MST_SITE F_CI
                                  ON F_CI.DIVISION_ID = A.DIVISION_ID AND F_CI.SCM_SITE_ID = A.FROM_SITE AND F_CI.VALID_YN = 'Y'
                                     LEFT OUTER JOIN SCM_MST_SITE T_CI
                                  ON T_CI.SCM_SITE_ID = A.TO_SITE   AND T_CI.VALID_YN = 'Y'
                               WHERE A.ATTRIBUTE2 <= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                 AND A.ATTRIBUTE3 >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                              ) A
                              INNER JOIN SCM_MST_SITE C
                           ON A.DIVISION_ID = C.DIVISION_ID AND A.TO_SITE = C.SCM_SITE_ID
                        WHERE C.VMI_YN = 'Y'
                          AND INCOTERMS != 'DAP'
                          AND NOT EXISTS (
                                         SELECT 1
                                           FROM (
                                                SELECT DISTINCT A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, B.TRANSPORT_MODE
                                                  FROM SCP_MST_BOD A
                                                       INNER JOIN SCP_MST_BOD_V B
                                                    ON A.DIVISION_ID = B.DIVISION_ID
                                                   AND A.BOD_ID = B.BOD_ID
                                                   AND A.FROM_SITE = B.FROM_SITE
                                                   AND A.TO_SITE = B.TO_SITE
                                                   AND A.INCOTERMS = B.INCOTERMS
                                                 WHERE A.INCOTERMS = 'DAP'
                                                ) B
                                                INNER JOIN SCM_MST_SITE C
                                             ON A.DIVISION_ID = C.DIVISION_ID AND B.TO_SITE = C.SCM_SITE_ID
                                          WHERE C.VMI_YN       =  'Y'
                                            AND A.FROM_SITE      =  B.FROM_SITE
                                            AND A.TO_SITE        =  B.TO_SITE
                                            AND A.TRANSPORT_MODE =  B.TRANSPORT_MODE
                                         )
                      ) MA
                      /* bo table - Trasport Mode Add  */
                      LEFT OUTER JOIN (
                                      SELECT A.*, B.TRANSPORT_MODE
                                        FROM SCP_MST_BOD A
                                             INNER JOIN SCP_MST_DISTRIBUTION_ROUTE B
                                          ON A.ROUTE_ID = B.ROUTE_ID
                                      ) BO
                   ON BO.DIVISION_ID    = MA.DIVISION_ID
                  AND BO.TO_SITE        = MA.TO_SITE
                  AND BO.INCOTERMS      = MA.INCOTERMS
                  AND BO.FROM_SITE      = MA.FROM_SITE
                  AND BO.TRANSPORT_MODE = MA.TRANSPORT_MODE
                 /* ro table - Distribution Route Add */
                      LEFT OUTER JOIN SCP_MST_DISTRIBUTION_ROUTE RO
                   ON BO.ROUTE_ID       = RO.ROUTE_ID
                      INNER JOIN (
        SELECT A.SCM_SITE_ID
          FROM SCM_MST_SITE          A
               JOIN SCM_MST_DIVISION D
            ON A.DIVISION_ID    = D.DIVISION_ID
         WHERE A.SITE_TYPE      = 'PLANT'
           AND A.VALID_YN       = 'Y'
           AND D.ATTRIBUTE3     IN ('40','81','82')
) FR
                   ON FR.SCM_SITE_ID    = MA.FROM_SITE
                      INNER JOIN (
        SELECT A.SCM_SITE_ID
          FROM (
               SELECT A.SCM_SITE_ID
                 FROM SCM_MST_SITE          A
                      JOIN SCM_MST_DIVISION D
                   ON A.DIVISION_ID         = D.DIVISION_ID
                WHERE A.VALID_YN            = 'Y'
                  AND D.ATTRIBUTE3          IN ('40','81','82')
                UNION
               SELECT A.SCM_SITE_ID
                 FROM SCM_MST_SITE          A
                WHERE A.VALID_YN            = 'Y'
                  AND A.SCM_SITE_ID         LIKE '%' || '-A'
               ) A
) TR
                   ON TR.SCM_SITE_ID    = MA.TO_SITE
                      INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL UP
                   ON UP.LOOKUP_TYPE    = 'INCOTERMS'
                  AND UP.VALID_YN       = 'Y'
                  AND UP.SEGMENT1       = MA.INCOTERMS
                      JOIN SCM_MST_DIVISION D
                   ON MA.DIVISION_ID    = D.DIVISION_ID
                WHERE 1 = 1
                /* R : Required */
                  AND BO.ROUTE_ID IS NULL
                /* 조회조건 */
                  AND D.ATTRIBUTE3 IN ('40','81','82')
               ) T
         /* 법인간 거래 - 실제 매출 Incoterms 적용 */
               LEFT OUTER JOIN SCP_MST_BOD_V  S
            ON S.DIVISION_ID    = T.DIVISION_ID
           AND S.FROM_SITE      = T.FROM_SITE
           AND S.TO_SITE        = T.TO_SITE
           AND (S.INCOTERMS     = T.INCOTERMS OR S.SSP_INCOTERMS  = T.INCOTERMS)
         /* From Site가 외주 이고 오른쪽 끝이 'A'(Cell) 인건은 Required에서 보여주지 않음.  Completed 에서는 공장간 이동 등록된것 보여야 함 */
         WHERE NOT EXISTS (
                          SELECT 1
                            FROM SCM_MST_SITE S
                           WHERE S.DIVISION_ID = T.DIVISION_ID AND S.SCM_SITE_ID = T.FROM_SITE AND S.VALID_YN = 'Y' AND S.OSP_YN = 'Y' AND S.OPERATION_GROUP = 'A'
                          )
       ) X
 GROUP BY X.DIVISION_ID
 ORDER BY X.DIVISION_ID;

-- ==============================================================================================================
-- [D5] 최근 14일 일별 KPI 적재 이력
-- 판정 : 이전 실행일의 사업부별 행 수와 비교. 같은 날 CREATED_AT 이 여러 개면 여러 번 실행된 것
-- ==============================================================================================================
WITH PRM AS (SELECT '20261125' AS P_DAY FROM DUAL)   /* 실행일. 이 줄의 값만 바꿔 실행 */
SELECT A.YYYYMMDD
     , A.DIVISION_ID
     , TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS') AS CREATED_AT
     , A.CREATED_BY
     , COUNT(*) AS ROW_CNT
  FROM SSP_KPI_BR_BOD_REGISTRATION A
     , PRM
 WHERE A.YYYYMMDD >= TO_CHAR(TO_DATE(PRM.P_DAY, 'YYYYMMDD') - 14, 'YYYYMMDD')
 GROUP BY A.YYYYMMDD
        , A.DIVISION_ID
        , TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS')
        , A.CREATED_BY
 ORDER BY A.YYYYMMDD DESC
        , A.DIVISION_ID;
