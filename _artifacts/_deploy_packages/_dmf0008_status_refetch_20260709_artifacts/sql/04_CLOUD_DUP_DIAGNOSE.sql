-- =====================================================================================
-- DMF0008 Status Update ORA-30926 — 중복 원천 상세 진단 (클라우드 실행)
--
-- 원인: PR_DM_DNM_EDI_CALLOFF_STATUS 의 Sales Site 판정 MERGE(사내본 L214)가
--   USING = SCM_MST_SITE_CUSTOMER × SCM_MST_SITE(SALES,'Y') / ON 키 = (DIVISION_ID, SOLDTO, SHIPTO).
--   같은 키에 SCM_SITE_ID 가 2개 이상 매핑되면 동일 대상 행을 2번 UPDATE → ORA-30926.
-- 참고: 사내에도 중복 키 17건 존재하나 실행 대상(EDI 데이터 범위)과 미교차라 통과 중 — 잠재 동일 리스크.
-- =====================================================================================

-- (1) 중복 키 상세 — 어떤 거래처 매핑이 복수 Sales Site 를 갖는지
SELECT A1.DIVISION_ID, A1.SOLDTO_CODE, A1.SHIPTO_CODE,
       COUNT(*) AS SRC_ROWS,
       LISTAGG(A1.SCM_SITE_ID, ',') WITHIN GROUP (ORDER BY A1.SCM_SITE_ID) AS SITES
  FROM SCM_MST_SITE_CUSTOMER A1
  JOIN SCM_MST_SITE A2
    ON A1.DIVISION_ID = A2.DIVISION_ID
   AND A1.SCM_SITE_ID = A2.SCM_SITE_ID
   AND A2.SITE_TYPE   = 'SALES'
   AND A2.VALID_YN    = 'Y'
 WHERE A1.VALID_YN = 'Y'
 GROUP BY A1.DIVISION_ID, A1.SOLDTO_CODE, A1.SHIPTO_CODE
HAVING COUNT(*) > 1
 ORDER BY SRC_ROWS DESC;

-- (2) (1)의 중복 키가 실제 EDI CALLOFF 점검 대상과 교차하는지 (교차 행 = 30926 유발 지점)
SELECT T.DIVISION_ID, T.SOLDTO_CODE, T.SHIPTO_CODE, COUNT(*) AS EDI_ROWS
  FROM DM_DNM_EDI_CALLOFF_ITEM T
 WHERE (T.DIVISION_ID, T.SOLDTO_CODE, T.SHIPTO_CODE) IN (
        SELECT A1.DIVISION_ID, A1.SOLDTO_CODE, A1.SHIPTO_CODE
          FROM SCM_MST_SITE_CUSTOMER A1
          JOIN SCM_MST_SITE A2
            ON A1.DIVISION_ID = A2.DIVISION_ID
           AND A1.SCM_SITE_ID = A2.SCM_SITE_ID
           AND A2.SITE_TYPE   = 'SALES'
           AND A2.VALID_YN    = 'Y'
         WHERE A1.VALID_YN = 'Y'
         GROUP BY A1.DIVISION_ID, A1.SOLDTO_CODE, A1.SHIPTO_CODE
        HAVING COUNT(*) > 1
       )
 GROUP BY T.DIVISION_ID, T.SOLDTO_CODE, T.SHIPTO_CODE
 ORDER BY EDI_ROWS DESC;
