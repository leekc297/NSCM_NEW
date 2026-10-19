/* =====================================================================================================
 * 12 — 클라우드 실행용 (긴급): 2026-10-08 13:30:46 재실행(11 S2)이 남긴 영향 확인 + 복구 사본 보존
 *      경위: PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE 가 L501~650 에서 해당 MF_W 버전의 RTF 계열 행을 DM_PLN_MKT_FCST_C / DM_PLN_CFM_MKT_DEMAND_PLAN_C 에서
 *            DELETE 한 뒤 L728 ORA-00979 로 실패 → 재삽입(L1193~) 미실행 → 호출 블록의 COMMIT 으로 삭제 확정.
 *      D1~D3 = 조회만. D4 = 플래시백 사본 보존(CREATE TABLE … AS OF) — UNDO 보존시간 안에만 가능하므로 **가장 먼저** 돌릴 것(D1 보고 바로).
 *      SQL Developer 스크립트 창 F5.
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET FEEDBACK ON

-- D0. 오늘 13:30 실행이 호출한 C 의 실제 버전 인자 (DBMS_OUTPUT 은 MF_W_20261006_V001 로 보였음 — 로그로 확정)
SELECT TO_CHAR(event_date, 'HH24:MI:SS') AS at_time, log_type, SUBSTR(description, 1, 120) AS description, sql_err_code
  FROM SCM_MGR.SCM_SYS_LOG_BATCH
 WHERE event_date >= TO_DATE('2026-10-08 13:30', 'YYYY-MM-DD HH24:MI')
   AND program_name = 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE'
 ORDER BY event_date;

-- D1. 현재 vs 13:30:00 시점(플래시백) 측정값별 행수 — 40 사업부, 이번 주 MF_W/SF_W 버전 전부. CUR_ROWS < AS_OF_ROWS 인 측정값이 삭제된 것
WITH v AS (SELECT version_no FROM DM_MST_VERSION WHERE division_id = '40' AND version_type IN ('MF_W', 'SF_W')
              AND yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD'))
, cur AS (
    SELECT 'MKT_FCST_C' AS tbl, version_no, measure, COUNT(*) AS cnt, SUM(qty) AS qty FROM DM_PLN_MKT_FCST_C
     WHERE division_id = '40' AND version_no IN (SELECT version_no FROM v) GROUP BY version_no, measure
    UNION ALL
    SELECT 'CFM_C', version_no, measure, COUNT(*), SUM(qty) FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
     WHERE division_id = '40' AND version_no IN (SELECT version_no FROM v) GROUP BY version_no, measure)
, bef AS (
    SELECT 'MKT_FCST_C' AS tbl, version_no, measure, COUNT(*) AS cnt, SUM(qty) AS qty
      FROM DM_PLN_MKT_FCST_C AS OF TIMESTAMP TO_TIMESTAMP('2026-10-08 13:30:00', 'YYYY-MM-DD HH24:MI:SS')
     WHERE division_id = '40' AND version_no IN (SELECT version_no FROM v) GROUP BY version_no, measure
    UNION ALL
    SELECT 'CFM_C', version_no, measure, COUNT(*), SUM(qty)
      FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C AS OF TIMESTAMP TO_TIMESTAMP('2026-10-08 13:30:00', 'YYYY-MM-DD HH24:MI:SS')
     WHERE division_id = '40' AND version_no IN (SELECT version_no FROM v) GROUP BY version_no, measure)
SELECT NVL(b.tbl, c.tbl) AS tbl, NVL(b.version_no, c.version_no) AS version_no, NVL(b.measure, c.measure) AS measure
     , b.cnt AS as_of_1330_rows, c.cnt AS cur_rows, NVL(b.cnt, 0) - NVL(c.cnt, 0) AS lost_rows
     , b.qty AS as_of_qty, c.qty AS cur_qty
     , CASE WHEN NVL(b.cnt, 0) > NVL(c.cnt, 0) THEN '◆ 삭제됨' WHEN NVL(b.cnt, 0) < NVL(c.cnt, 0) THEN '추가됨' END AS flag
  FROM bef b FULL OUTER JOIN cur c ON b.tbl = c.tbl AND b.version_no = c.version_no AND b.measure = c.measure
 ORDER BY 1, 2, 3;

-- D2. 플래시백이 아직 가능한지 (UNDO 보존) — D1 이 ORA-01555/ORA-08180 이면 사본 보존 불가 → D5 재생성 경로로
SELECT COUNT(*) AS rows_at_1330
  FROM DM_PLN_MKT_FCST_C AS OF TIMESTAMP TO_TIMESTAMP('2026-10-08 13:30:00', 'YYYY-MM-DD HH24:MI:SS')
 WHERE division_id = '40' AND version_no IN (SELECT version_no FROM DM_MST_VERSION WHERE division_id = '40' AND version_type IN ('MF_W', 'SF_W')
                                                AND yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD'));

-- D3. 13:30 이후 이 버전들을 다른 세션이 또 건드렸나 (LAST_UPDATE_DATE / CREATION_DATE 최신)
SELECT 'MKT_FCST_C' AS tbl, version_no, TO_CHAR(MAX(creation_date), 'MM-DD HH24:MI:SS') AS max_created, TO_CHAR(MAX(last_update_date), 'MM-DD HH24:MI:SS') AS max_updated, COUNT(*) AS rows_
  FROM DM_PLN_MKT_FCST_C WHERE division_id = '40' AND version_no IN (SELECT version_no FROM DM_MST_VERSION WHERE division_id = '40' AND version_type IN ('MF_W', 'SF_W') AND yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD'))
 GROUP BY version_no
UNION ALL
SELECT 'CFM_C', version_no, TO_CHAR(MAX(creation_date), 'MM-DD HH24:MI:SS'), TO_CHAR(MAX(last_update_date), 'MM-DD HH24:MI:SS'), COUNT(*)
  FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WHERE division_id = '40' AND version_no IN (SELECT version_no FROM DM_MST_VERSION WHERE division_id = '40' AND version_type IN ('MF_W', 'SF_W') AND yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD'))
 GROUP BY version_no
 ORDER BY 1, 2;


/* ---------- D4. 복구 사본 보존 (D1 에 '◆ 삭제됨' 이 있고 D2 가 정상이면 즉시) — 주석을 풀어 실행. 새 테이블 2개 생성(SCM_MGR), 원본 변경 없음 ----------
CREATE TABLE SCM_MGR.ZZ_BK_MKT_FCST_C_20261008_1330 AS
SELECT * FROM DM_PLN_MKT_FCST_C AS OF TIMESTAMP TO_TIMESTAMP('2026-10-08 13:30:00', 'YYYY-MM-DD HH24:MI:SS')
 WHERE division_id = '40' AND version_no IN (SELECT version_no FROM DM_MST_VERSION WHERE division_id = '40' AND version_type IN ('MF_W', 'SF_W')
                                                AND yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD'));

CREATE TABLE SCM_MGR.ZZ_BK_CFM_C_20261008_1330 AS
SELECT * FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C AS OF TIMESTAMP TO_TIMESTAMP('2026-10-08 13:30:00', 'YYYY-MM-DD HH24:MI:SS')
 WHERE division_id = '40' AND version_no IN (SELECT version_no FROM DM_MST_VERSION WHERE division_id = '40' AND version_type IN ('MF_W', 'SF_W')
                                                AND yyyymmdd >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD'));

SELECT 'MKT_FCST_C' t, COUNT(*) FROM SCM_MGR.ZZ_BK_MKT_FCST_C_20261008_1330
UNION ALL SELECT 'CFM_C', COUNT(*) FROM SCM_MGR.ZZ_BK_CFM_C_20261008_1330;
---------------------------------------------------------------------------------------------------------------------------------- */

/* ---------- D5. 복구 방법 (사용자 결정 후 별도 파일로 제공) ----------
 *   방법 A) 사본에서 삭제된 행만 되살리기: INSERT INTO DM_PLN_MKT_FCST_C SELECT * FROM ZZ_BK_… b WHERE NOT EXISTS (현재 동일 PK) — 13:30 시점 그대로 복원
 *   방법 B) 클라우드 C_QTY_BALANCE 의 L763 tail 누락을 고친 뒤 해당 버전으로 C 를 다시 돌려 재생성 — 09-30 수동 실행들과 같은 방식(현재 계획 1464 기준값으로 재작성)
 *   두 방법은 결과가 다를 수 있다(A = 13:30 이전 값, B = 지금 계획 기준 재계산). 사용자 결정 필요.
 * ------------------------------------------------------------------------------------------------------------------------------- */
