/* =====================================================================================================
 * 03 — 클라우드 전/후 실행 비교 (C_QTY_BALANCE 만 직접 호출 — 루트·메일 분기를 거치지 않으므로 제외시간 무관, 메일 0)
 *      R0 버전 확인 → R1 구판 실행(01 적용 전) + 시각 기록 → 01 적용(02 V1) → R3 신판 실행 → R4 결과 동치(플래시백 비교) → R5 소요 비교
 *      같은 버전을 두 번 다시 쓰므로(00시 롤링이 매일 하는 것과 동일) 데이터 변화는 없고, 두 실행 사이 수 분 안에 입력이 바뀌지 않도록 연속 실행한다.
 *      이 파일은 조회만(R0 · R0-b · R5, 그대로 F5). 실제 실행은 03a(구판) / 03b(신판+비교) 파일을 그대로 F5.
 *      C SP 는 내부 COMMIT 이 없고 C_WS_RTF 가 중간 COMMIT 하므로 블록 끝에서 COMMIT 한다(결과 커서 없음 · 오류 시 예외 전파 → ROLLBACK).
 * ===================================================================================================== */
SET SQLFORMAT ansiconsole
SET PAGESIZE 5000
SET LINESIZE 400
SET SERVEROUTPUT ON SIZE UNLIMITED
SET TIMING ON

-- R0. 이번 주 40 버전 (기대 2행: MF_W_yyyymmdd_V001 · SF_W_yyyymmdd_V001). 아래 블록의 버전 리터럴을 이 값으로 맞춘다
SELECT DIVISION_ID, VERSION_NO, YYYYMMDD
  FROM SCM_MGR.DM_MST_VERSION
 WHERE DIVISION_ID = '40' AND VERSION_TYPE IN ('MF_W', 'SF_W') AND YYYYMMDD >= TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD')
 ORDER BY VERSION_NO;

-- R0-b. 실행 전 상태 기록 (측정값별 건수·QTY 합) — 비교 기준선 참고용
SELECT 'MKT_FCST_C' AS tbl, VERSION_NO, MEASURE, COUNT(*) AS n, SUM(QTY) AS qty, MAX(LAST_UPDATE_DATE) AS max_upd
  FROM SCM_MGR.DM_PLN_MKT_FCST_C
 WHERE DIVISION_ID = '40' AND VERSION_NO IN ('MF_W_20261005_V001', 'SF_W_20261005_V001') AND CUTOFF_YYYYMMDD_DATE = TO_DATE('20261005', 'YYYYMMDD')
 GROUP BY VERSION_NO, MEASURE
UNION ALL
SELECT 'CFM_C', VERSION_NO, MEASURE, COUNT(*), SUM(QTY), MAX(LAST_UPDATE_DATE)
  FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C
 WHERE DIVISION_ID = '40' AND VERSION_NO IN ('MF_W_20261005_V001', 'SF_W_20261005_V001') AND CUTOFF_YYYYMMDD_DATE = TO_DATE('20261005', 'YYYYMMDD')
 GROUP BY VERSION_NO, MEASURE
 ORDER BY 1, 2, 3;

-- R1. 구판 실행 = 03a_RUN_OLD_cloud.sql (그대로 F5). 출력 T_START / MF_W sec / SF_W sec / T_END 기록
-- ======== 01 적용 (SCM_MGR) → 02 V1~V3 통과 ========
-- R3+R4. 신판 실행 + 결과 동치 비교 = 03b_RUN_NEW_AND_COMPARE_cloud.sql (그대로 F5, 입력값 없음). 마지막 줄 DIFF_ROWS=0 => EQUIVALENT
--        03a 와 연속 실행(수 분 안). 비교는 블록 시작 시각 플래시백(= 03a 결과) 대비.

-- R5. 소요 비교 — 모듈별(구/신) 벽시계·ASH 초, 그리고 문장별 상위 (1초 ASH 가 남아 있을 때)
SELECT h.module, h.action, COUNT(*) AS ash_sec, TO_CHAR(MIN(h.sample_time), 'HH24:MI:SS') AS first_, TO_CHAR(MAX(h.sample_time), 'HH24:MI:SS') AS last_
     , SUM(CASE WHEN h.event IS NULL THEN 1 ELSE 0 END) AS cpu_sec, SUM(CASE WHEN h.wait_class = 'User I/O' THEN 1 ELSE 0 END) AS io_sec
  FROM v$active_session_history h
 WHERE h.module IN ('RUN_C_OLD_1464', 'RUN_C_NEW_1464')
 GROUP BY h.module, h.action
 ORDER BY 1, 2;

SELECT h.module, h.sql_id, COUNT(*) AS sec, MAX(h.sql_plan_hash_value) AS phv
     , SUM(CASE WHEN h.event IS NULL THEN 1 ELSE 0 END) AS cpu_sec
     , SUBSTR((SELECT REPLACE(REPLACE(q.sql_text, CHR(10), ' '), CHR(13), ' ') FROM v$sqlarea q WHERE q.sql_id = h.sql_id), 1, 100) AS sql_text
  FROM v$active_session_history h
 WHERE h.module IN ('RUN_C_OLD_1464', 'RUN_C_NEW_1464')
 GROUP BY h.module, h.sql_id
HAVING COUNT(*) >= 2
 ORDER BY 1, sec DESC;

-- R5-b. 신판 VMI INSERT 의 실제 플랜 — Pstart/Pstop 이 단일(KEY) 인지. sql_id 는 위 R5 결과에서 'INSERT INTO GT_DPMFCQB_VMI_MST_MAIN' 행의 값
-- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR('<sql_id>', NULL, 'BASIC +PREDICATE +PARTITION +ROWS'));
