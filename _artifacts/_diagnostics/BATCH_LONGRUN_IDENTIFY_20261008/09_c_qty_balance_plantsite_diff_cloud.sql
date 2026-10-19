/* =====================================================================================================
 * 09 — 클라우드 실행용 (08 X4 후속): 클라우드 C_QTY_BALANCE 에서 '--' 로 막힌 PLANT_SITE_ID CASE 8줄 주변 원문
 *      사내(10-01 18:43 판)에서는 같은 8줄이 **활성 코드**(L745·761·778·794·926·939·959·977):
 *        , CASE WHEN A.DIVISION_ID IN ('82','40') THEN ' ' ELSE A.PLANT_SITE_ID END AS PLANT_SITE_ID
 *      클라우드(10-02 15:39 판)는 이 줄을 주석 처리하고 총 줄수가 +8 → 각 주석 줄 뒤에 대체 줄이 들어간 것으로 추정.
 *      = 82/40 사업부 RTF_SCP 적재 시 PLANT_SITE_ID 를 공백으로 접는지(사내) / 원값을 유지하는지(클라우드?) 의 **로직 차이** 후보.
 *      SQL Developer 스크립트 창에 전체 붙여넣기 → F5. 조회 전용.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

-- Y1. 주석 줄 8개의 전후 3줄 (클라우드 줄 번호 기준)
SELECT line, SUBSTR(RTRIM(text), 1, 170) AS text
  FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE'
   AND (   line BETWEEN 742 AND 749   OR line BETWEEN 759 AND 766   OR line BETWEEN 777 AND 784   OR line BETWEEN 794 AND 801
        OR line BETWEEN 927 AND 934   OR line BETWEEN 941 AND 948   OR line BETWEEN 962 AND 969   OR line BETWEEN 981 AND 988 )
 ORDER BY line;

-- Y2. 클라우드에서 PLANT_SITE_ID 를 SELECT 절에 올리는 활성 줄 전부 (L700~1000) — 사내는 8줄 전부 CASE ... THEN ' ' 형태
SELECT line, SUBSTR(RTRIM(text), 1, 170) AS text
  FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE'
   AND line BETWEEN 700 AND 1000
   AND UPPER(text) LIKE '%PLANT_SITE_ID%'
   AND NOT REGEXP_LIKE(text, '^\s*-{2}')
 ORDER BY line;

-- Y3. 변경 흔적 — 10-02 전후 마커 (클라우드에만 있는 변경이면 여기에 날짜/작성자 주석이 있을 수 있음)
SELECT line, SUBSTR(RTRIM(text), 1, 170) AS text
  FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE' AND type = 'PROCEDURE'
   AND REGEXP_LIKE(text, '2026[./-]?10[./-]?0[1-8]|PLANT_SITE_ID.*(주석|제거|삭제|유지|원복|복원)|(주석|제거|삭제|유지|원복|복원).*PLANT_SITE_ID')
 ORDER BY line;

-- Y4. 같은 CASE 패턴이 루트 QTY_BALANCE_CREATE / SALES_PLAN_C 에도 있는지 (사내 대조용)
SELECT name, line, SUBSTR(RTRIM(text), 1, 150) AS text, CASE WHEN REGEXP_LIKE(text, '^\s*-{2}') THEN '주석' ELSE '활성' END AS state
  FROM all_source
 WHERE owner = 'SCM_MGR' AND type = 'PROCEDURE'
   AND name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE')
   AND REGEXP_LIKE(UPPER(text), 'IN \(\s*''82''\s*,\s*''40''\s*\)\s*THEN\s*''\s''\s*ELSE\s*A\.PLANT_SITE_ID')
 ORDER BY name, line;
