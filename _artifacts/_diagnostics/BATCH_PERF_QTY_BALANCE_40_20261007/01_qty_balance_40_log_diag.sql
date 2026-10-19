/* =====================================================================================================
 * 배치 속도 진단 — SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE(P_DIVISION_ID => '40', P_PLAN_ID => NULL, O_RESULT_CURSOR => v_cur)
 *             (스케줄러 잡 JOB_SCMPROD_PLAN_FINAL_40_CREATION 의 PL/SQL 블록 — 구 PR_SCP_ENG_CONTROL('1','FN') 대체 호출)
 *
 * 대상 로그 : SCM_MGR.SCM_SYS_LOG_BATCH
 *   루트 SP  → PR_DM_SYS_LOG_BATCH 가 적재. PROGRAM_NAME = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' ($$PLSQL_UNIT)
 *              IN_PARA_DATA = '{"p_division_id":"40","p_plan_id":"NULL"}'  ← 한 실행의 모든 행(START/ING/END/ERROR/INVALID)에 동일하게 찍힘 (실행 식별 키)
 *              DESCRIPTION  = START/END/INVALID 행 'p_division_id : 40 / p_plan_id : NULL' · ING 행 '' · ERROR 행 = 에러 backtrace(줄 번호)
 *              LOG_MESSAGE  = ING 행 'step - A0nn ' (SP 내부 진행 단계) · ERROR 행 = SQLERRM
 *              CREATED_BY   = 실행 세션 계정(USER) — 스케줄러 잡이면 잡 소유 계정
 *   하위 SP  → PR_SCM_SYS_LOG_BATCH 가 적재. CREATED_BY 는 항상 'scm_batch' 고정(세션 계정 아님) → 루트와 CREATED_BY 로 묶을 수 없고 시간 구간 + 사업부 문구로 묶는다
 *              PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW : DESCRIPTION '@p_division_id : 40 / @v_created_by : SYSTEM'
 *              PR_DM_DNM_CREATE_WS_RTF                   : DESCRIPTION '@P_DIVISION_ID: 40'
 *
 * 이 호출(P_PLAN_ID NULL = 배치 경로, V_BATCH_CALL_YN='Y')이 남기는 step 순서 (2026-10-07 사내 SP 원문 L1250~L3162 기준):
 *   START → A001 → A007 → A010 → A011 → A018 → A019 → [KRW START/END] → A020 → END
 *   (A002 = 화면 CALL 전용 · A021/A024 = UI 호출 전용 CUTOFF 블록 → 이 호출에서는 찍히지 않음)
 *   step 과 SP 구간의 대응은 Q2 의 SECTION 컬럼 / 00_README.md 표 참조
 *
 * 기간     : 전주 월요일 00:00 ~ 전주 목요일 24:00  (= 이번 주 월요일 TRUNC(SYSDATE,'IW') 기준 -7일 ~ -3일(미포함))
 *             다른 기간은 각 쿼리 W(윈도)의 두 날짜를 직접 바꾼다. 윈도 시작 전에 START 하고 윈도 안에서 끝난 실행은 Q1~Q3 에서 빠진다(from_dt 를 하루 앞당기면 포함).
 * 조회 전용 — DB 변경 없음. 클라우드에서 SCM_MGR(또는 SCM_SYS_LOG_BATCH 조회 권한 계정)으로 실행.
 * 주의     : SCM_SYS_LOG_BATCH 에 인덱스가 없어 전부 풀스캔. 기간을 넓히면 그만큼 느려진다.
 *             같은 초에 찍힌 START 와 step 행은 EVENT_DATE 만으로는 순서가 뒤집힐 수 있어 ORD(START 0 < ING 1 < INVALID 2 < END/ERROR 3) + step 번호로 정렬한다.
 * ===================================================================================================== */

/* ---------- Q0. 기간 확인 ---------- */
SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt            -- 전주 월요일 00:00
     , TRUNC(SYSDATE, 'IW') - 3 AS to_dt_exclusive    -- 전주 금요일 00:00 (목요일 24:00)
  FROM dual;


/* ---------- Q1. 실행 목록 — 실행별 시작/종료/소요(분)/상태/step 궤적 ----------
 * 실행 식별 : 같은 계정의 로그를 시간순으로 놓고 START 마다 run_no 를 +1 (START 뒤에 END/ERROR 없이 다음 START 가 와도 분리됨)
 * 상태      : END = 정상 · ERROR = 예외(ERR/ERR_AT 에 SQLERRM·에러 줄) · INVALID→END = 대상 없음(최신 PLAN_ID 없음 등, L1409) 조기 종료 · 미종료 = END/ERROR 없음(세션 kill·타임아웃 의심)
 * STEP_LIST : 찍힌 step 궤적. 정상 배치 경로 = A001,A007,A010,A011,A018,A019,A020                                                  */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
, l AS (
    SELECT l.log_type, l.log_message, l.description, l.event_date, l.created_by, l.sql_err_code
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, s AS (
    SELECT l.*
         , SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END)
               OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no
      FROM l
)
SELECT run_no, created_by
     , TO_CHAR(MIN(CASE WHEN log_type = 'START' THEN event_date END), 'YYYY-MM-DD HH24:MI:SS')          AS start_time
     , TO_CHAR(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END), 'YYYY-MM-DD HH24:MI:SS') AS end_time
     , ROUND((MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END)
            - MIN(CASE WHEN log_type = 'START' THEN event_date END)) * 1440, 1)                           AS elapsed_min
     , CASE WHEN MAX(CASE WHEN log_type = 'ERROR'   THEN 1 ELSE 0 END) = 1 THEN 'ERROR'
            WHEN MAX(CASE WHEN log_type = 'INVALID' THEN 1 ELSE 0 END) = 1 THEN 'INVALID→END'
            WHEN MAX(CASE WHEN log_type = 'END'     THEN 1 ELSE 0 END) = 1 THEN 'END'
            ELSE '미종료' END                                                                                AS status
     , SUM(CASE WHEN log_type = 'ING' THEN 1 ELSE 0 END)                                                   AS steps
     , LISTAGG(CASE WHEN log_type = 'ING' THEN REGEXP_SUBSTR(log_message, 'A[0-9]{3}') END, ',')
           WITHIN GROUP (ORDER BY event_date, ord, log_message)                                            AS step_list
     , MAX(CASE WHEN log_type = 'ERROR' THEN sql_err_code END)                                             AS err_code
     , MAX(CASE WHEN log_type = 'ERROR' THEN SUBSTR(log_message, 1, 150) END)                              AS err
     , MAX(CASE WHEN log_type = 'ERROR' THEN SUBSTR(description, 1, 150) END)                              AS err_at   -- backtrace: 에러 난 SP 줄 번호
  FROM s
 WHERE run_no > 0
 GROUP BY run_no, created_by
 ORDER BY start_time;


/* ---------- Q2. 실행별 단계 타임라인 — 어느 구간에서 시간이 가는가 ----------
 * 루트 SP 의 모든 행 + 그 실행 구간 안에 찍힌 하위 SP(40 사업부) START/END/ERROR 를 시간순으로 놓고 직전 행과의 간격(GAP_SEC)을 구한다.
 * GAP_SEC 이 큰 행 = 그 직전 구간(SECTION 컬럼)이 오래 걸린 단계. SECTION 은 '이 행이 찍히기까지 수행된 SP 구간'(사내 원문 2026-10-07 줄 번호).
 * 하위 SP 행은 CREATED_BY 가 'scm_batch' 고정이어서 계정으로 묶지 않고, 루트 구간 안 + '@p_division_id : 40' 문구로 묶는다.
 * 미종료 실행은 다음 START 직전(없으면 +1일)까지를 구간으로 본다.                                                                      */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
, l AS (
    SELECT l.program_name, l.log_type, l.log_message, l.description, l.event_date, l.created_by, l.sql_err_code, l.log_count
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, s AS (
    SELECT l.*
         , SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END)
               OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no
      FROM l
)
, run AS (   -- 실행 구간
    SELECT run_no, created_by
         , MIN(CASE WHEN log_type = 'START' THEN event_date END)                 AS run_start
         , NVL(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END)
             , NVL(LEAD(MIN(CASE WHEN log_type = 'START' THEN event_date END)) OVER (PARTITION BY created_by ORDER BY run_no) - 1 / 86400
                 , MIN(CASE WHEN log_type = 'START' THEN event_date END) + 1))  AS run_end
      FROM s
     WHERE run_no > 0
     GROUP BY run_no, created_by
)
, t AS (
    SELECT run_no, created_by, program_name, log_type, log_message, description, event_date, ord, sql_err_code, log_count FROM s WHERE run_no > 0
    UNION ALL
    SELECT run.run_no, run.created_by, c.program_name, c.log_type, c.log_message, c.description, c.event_date
         , CASE c.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END, c.sql_err_code, c.log_count
      FROM run
      JOIN SCM_MGR.SCM_SYS_LOG_BATCH c
        ON c.event_date BETWEEN run.run_start AND run.run_end
       AND c.program_name IN ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_DNM_CREATE_WS_RTF'
                            , 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE')   -- 뒤 2개는 UI 호출 경로 전용(이 호출에서는 안 나와야 정상)
       AND REGEXP_LIKE(c.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i')
       AND (c.program_name <> 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW' OR c.description LIKE '%@v_created_by : SYSTEM%')   -- 환율 배치 등 다른 호출자의 KRW(40) 로그 제외 (클라우드 1차: 00:04 환율 KRW END 가 섞임)
)
, x AS (
    SELECT t.*
         , CASE WHEN program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
                THEN NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), log_type)
                ELSE REPLACE(REPLACE(program_name, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'KRW'), 'PR_DM_DNM_CREATE_WS_RTF', 'WS_RTF') || ':' || log_type
           END AS marker
      FROM t
)
SELECT run_no
     , TO_CHAR(MIN(event_date) OVER (PARTITION BY run_no), 'MM-DD HH24:MI')                                           AS run_id
     , TO_CHAR(event_date, 'MM-DD HH24:MI:SS')                                                                        AS at_time
     , ROUND((event_date - LAG(event_date) OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message)) * 86400) AS gap_sec
     , ROUND((event_date - MIN(event_date) OVER (PARTITION BY run_no)) * 1440, 1)                                      AS min_from_start
     , marker
     , CASE marker
         WHEN 'START'     THEN '시작 (GTT 19종 DELETE 직후, L1223~1250)'
         WHEN 'A001'      THEN '변수 셋팅 · 장기계획 주차수 LOOKUP · V_MEASURE(40=SCM_FCST) (L1253~1348) ※ L1269 블록은 이 호출에서 미수행(README 발견1)'
         WHEN 'A007'      THEN '대상추출: SCP_PLN_RTF_ALLOCATION_V MAX PLAN_ID · SCP_PLN_INTERFACE_YN RTF flag · GT_PRDM2_MF_BALANCE_MKT_FCST/RESULTS/MF_RTF_ALLOCATION 적재+통계 (L1387~1649)'
         WHEN 'A010'      THEN 'DM_PLN_MKT_FCST 통계수집(L1857) → GT_PRDM2_MKT_FCST_INSERT(L1859) · GT_PRDM2_CFM_DEMAND_INSERT(L1938) · CELL_PROD_SITE_ID 보정(L2023) (L1674~2137)'
         WHEN 'A011'      THEN 'INSERT INTO DM_PLN_MKT_FCST(L2150) · RMA 처리 MKT_FCST/CFM_MKT_DEMAND_PLAN(L2181~2300)'
         WHEN 'WS_RTF:START' THEN 'VMI 재고 추출(GT_PRDM2_FP_STOCK_QTY/VMI_MST/VMI_TEMP*) · VMI RTF DELETE/INSERT MKT_FCST+CFM(L2311~2683)'
         WHEN 'WS_RTF:END'   THEN 'PR_DM_DNM_CREATE_WS_RTF 본체(L2689, AS 재고 → RTF)'
         WHEN 'A018'      THEN 'VMI DIO 계산 40 분기(DELETE/INSERT CFM_MKT_DEMAND_PLAN·MKT_FCST, L2694~2826) · GT_PRDM2_MF_BALANCE_MKT_FCST 40(L2842) · GT_PRDM2_MST(L2871) +통계 (L2836~2903)'
         WHEN 'A019'      THEN 'GT_PRDM2_MST_ACCUM(L2913) · GT_PRDM2_TEMPX(L2923) · DELETE BALANCE from DM_PLN_MKT_FCST(L2935) (L2913~2950)'
         WHEN 'KRW:START' THEN 'INSERT BALANCE into DM_PLN_MKT_FCST(L2957) · 40: DM_PLN_CFM_MKT_DEMAND_PLAN BALANCE(L2971~3000)'
         WHEN 'KRW:END'   THEN 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW 본체(L3010, 금액 생성)'
         WHEN 'A020'      THEN 'KRW 호출 복귀 (L3010~3017)'
         WHEN 'END'       THEN '종료 — V_BATCH_CALL_YN=Y 라 CUTOFF 블록(L3024~3153, A021/A024/C_QTY_BALANCE/SALES_PLAN_C) 미수행'
         WHEN 'ERROR'     THEN '예외 종료 — DESCRIPTION 의 backtrace 줄 번호가 실패 지점'
         WHEN 'INVALID'   THEN '대상 없음 조기 종료 (SCM_MST_DIVISION 없음 또는 SCP_PLN_RTF_ALLOCATION_V 에 PLAN_ID 없음, L1409)'
         ELSE program_name
       END                                                                                                             AS section
     , program_name, log_type, log_count
     , SUBSTR(log_message, 1, 100)                                                                                     AS log_message
     , SUBSTR(description, 1, 100)                                                                                     AS description
     , sql_err_code
  FROM x
 ORDER BY run_no, event_date, ord, log_message;


/* ---------- Q3. 구간별 소요 집계 — 실행들을 합쳐 어느 구간이 병목인지 순위 ----------
 * Q2 와 같은 타임라인에서 "직전 marker → 이 marker" 구간별로 합계·평균·최대를 낸다. TOTAL_SEC 상위가 튜닝 1순위 구간.
 * 하위 SP 구간(WS_RTF:START→WS_RTF:END, KRW:START→KRW:END)은 그 SP 자체 소요. 루트 구간은 SP 본문 SQL 들의 합(어느 SQL 인지는 Q7 로 추가 특정).   */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
, l AS (
    SELECT l.program_name, l.log_type, l.log_message, l.description, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= w.from_dt AND l.event_date < w.to_dt
)
, s AS (
    SELECT l.*
         , SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END)
               OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no
      FROM l
)
, run AS (
    SELECT run_no, created_by
         , MIN(CASE WHEN log_type = 'START' THEN event_date END)                 AS run_start
         , NVL(MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END)
             , NVL(LEAD(MIN(CASE WHEN log_type = 'START' THEN event_date END)) OVER (PARTITION BY created_by ORDER BY run_no) - 1 / 86400
                 , MIN(CASE WHEN log_type = 'START' THEN event_date END) + 1))  AS run_end
      FROM s
     WHERE run_no > 0
     GROUP BY run_no, created_by
)
, t AS (
    SELECT run_no, created_by, program_name, log_type, log_message, event_date, ord FROM s WHERE run_no > 0
    UNION ALL
    SELECT run.run_no, run.created_by, c.program_name, c.log_type, c.log_message, c.event_date
         , CASE c.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END
      FROM run
      JOIN SCM_MGR.SCM_SYS_LOG_BATCH c
        ON c.event_date BETWEEN run.run_start AND run.run_end
       AND c.program_name IN ('PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_DNM_CREATE_WS_RTF'
                            , 'PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE', 'PR_DM_PLN_SALES_PLAN_C_QTY_BALANCE_CREATE')
       AND c.log_type IN ('START', 'END', 'ERROR')
       AND REGEXP_LIKE(c.description, '^@p_division_id\s*:\s*40(\s|/|$)', 'i')
       AND (c.program_name <> 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW' OR c.description LIKE '%@v_created_by : SYSTEM%')   -- 환율 배치 등 다른 호출자의 KRW(40) 로그 제외 (클라우드 1차: 00:04 환율 KRW END 가 섞임)
)
, x AS (
    SELECT t.*
         , CASE WHEN program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
                THEN NVL(REGEXP_SUBSTR(log_message, 'A[0-9]{3}'), log_type)
                ELSE REPLACE(REPLACE(program_name, 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'KRW'), 'PR_DM_DNM_CREATE_WS_RTF', 'WS_RTF') || ':' || log_type
           END AS marker
      FROM t
)
, g AS (
    SELECT run_no, marker
         , LAG(marker)     OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message) AS prev_marker
         , (event_date - LAG(event_date) OVER (PARTITION BY run_no ORDER BY event_date, ord, log_message)) * 86400 AS gap_sec
      FROM x
)
SELECT prev_marker || ' → ' || marker                          AS segment
     , COUNT(*)                                                 AS runs
     , ROUND(SUM(gap_sec))                                      AS total_sec
     , ROUND(AVG(gap_sec))                                      AS avg_sec
     , ROUND(MAX(gap_sec))                                      AS max_sec
     , ROUND(MIN(gap_sec))                                      AS min_sec
     , ROUND(RATIO_TO_REPORT(SUM(gap_sec)) OVER () * 100, 1)    AS pct
  FROM g
 WHERE prev_marker IS NOT NULL
 GROUP BY prev_marker || ' → ' || marker
 ORDER BY total_sec DESC;


/* ---------- Q4. 오류·INVALID — 기간 안 전체(타 SP 포함) ----------
 * 루트 SP 의 ERROR 는 DESCRIPTION/BACKTRACE 에 'ORA-06512: at "SCM_MGR.PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE", line NNNN' 로 실패 줄이 남는다.
 * 하위 SP 가 예외를 올리면 루트 EXCEPTION(L3167) 에서 한 번 더 ERROR 가 찍힌다(하위 SP 자체 ERROR 행 + 루트 ERROR 행 2건).                      */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
SELECT TO_CHAR(l.event_date, 'YYYY-MM-DD HH24:MI:SS') AS at_time
     , l.program_name, l.log_type
     , SUBSTR(l.description, 1, 200)                   AS description
     , SUBSTR(l.log_message, 1, 200)                   AS log_message
     , l.sql_err_code, SUBSTR(l.sql_err_msg, 1, 200)   AS sql_err_msg
     , SUBSTR(l.sql_backtrace, 1, 300)                 AS backtrace
     , l.in_para_data, l.created_by
  FROM SCM_MGR.SCM_SYS_LOG_BATCH l, w
 WHERE l.event_date >= w.from_dt AND l.event_date < w.to_dt
   AND (l.log_type IN ('ERROR', 'error', 'INVALID') OR l.sql_err_code IS NOT NULL)
 ORDER BY l.event_date;


/* ---------- Q5. 최근 8주 추이 — 이 호출(40 / NULL)의 실행별 소요(분) 주차 집계 ----------
 * 속도 개선 전후 비교 기준선. 주차 = ISO 주 월요일 날짜.                                                                    */
WITH l AS (
    SELECT l.log_type, l.log_message, l.event_date, l.created_by
         , CASE l.log_type WHEN 'START' THEN 0 WHEN 'ING' THEN 1 WHEN 'INVALID' THEN 2 ELSE 3 END AS ord
      FROM SCM_MGR.SCM_SYS_LOG_BATCH l
     WHERE l.program_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE'
       AND l.in_para_data = '{"p_division_id":"40","p_plan_id":"NULL"}'
       AND l.event_date >= TRUNC(SYSDATE, 'IW') - 56
)
, s AS (
    SELECT l.*
         , SUM(CASE WHEN log_type = 'START' THEN 1 ELSE 0 END)
               OVER (PARTITION BY created_by ORDER BY event_date, ord, log_message ROWS UNBOUNDED PRECEDING) AS run_no
      FROM l
)
, r AS (
    SELECT run_no, created_by
         , MIN(CASE WHEN log_type = 'START' THEN event_date END)              AS run_start
         , MAX(CASE WHEN log_type IN ('END', 'ERROR') THEN event_date END)    AS run_end
         , MAX(CASE WHEN log_type = 'ERROR' THEN 1 ELSE 0 END)                AS is_err
         , MAX(CASE WHEN log_type = 'INVALID' THEN 1 ELSE 0 END)              AS is_invalid
      FROM s WHERE run_no > 0
     GROUP BY run_no, created_by
)
SELECT TO_CHAR(TRUNC(run_start, 'IW'), 'YYYY-MM-DD')                 AS week_monday
     , COUNT(*)                                                       AS runs
     , ROUND(MAX((run_end - run_start) * 1440), 1)                    AS max_min
     , ROUND(AVG((run_end - run_start) * 1440), 1)                    AS avg_min
     , SUM(is_err)                                                    AS errors
     , SUM(is_invalid)                                                AS invalids
     , SUM(CASE WHEN run_end IS NULL THEN 1 ELSE 0 END)               AS not_ended
     , LISTAGG(TO_CHAR(run_start, 'Dy HH24:MI'), ' | ') WITHIN GROUP (ORDER BY run_start) AS starts
  FROM r
 GROUP BY TRUNC(run_start, 'IW')
 ORDER BY 1;


/* ---------- Q6. 스케줄러 잡 실행 이력 — DB 가 기록한 잡 단위 소요·상태·세션 ----------
 * 이 블록을 DBMS_SCHEDULER 잡(JOB_SCMPROD_PLAN_FINAL_40_CREATION)으로 돌렸다면 잡 로그에 실제 소요(RUN_DURATION)·CPU·에러·세션(SID,SERIAL#)이 남는다.
 * SESSION_ID 는 Q7(ASH) 에서 그 세션의 SQL 별 대기를 보는 열쇠. 수동 실행(SQL 툴에서 블록 실행)이면 0행.
 * 사내 정의: PLSQL_BLOCK · 스케줄 THU 01:30 + TUE 15:30:10 (클라우드 스케줄은 아래 두 번째 쿼리로 확인)                                  */
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
SELECT d.job_name, d.status
     , TO_CHAR(d.actual_start_date, 'YYYY-MM-DD HH24:MI:SS')    AS started
     , d.run_duration
     , ROUND(EXTRACT(HOUR FROM d.run_duration) * 60 + EXTRACT(MINUTE FROM d.run_duration) + EXTRACT(SECOND FROM d.run_duration) / 60, 1) AS run_min
     , d.cpu_used
     , d.error#
     , d.session_id                                              -- 'SID,SERIAL#'
     , d.slave_pid, d.instance_id
     , SUBSTR(d.additional_info, 1, 300)                         AS additional_info
     , SUBSTR(d.errors, 1, 300)                                  AS errors
  FROM all_scheduler_job_run_details d, w
 WHERE d.owner = 'SCM_MGR'
   AND d.job_name = 'JOB_SCMPROD_PLAN_FINAL_40_CREATION'
   AND d.actual_start_date >= w.from_dt AND d.actual_start_date < w.to_dt
 ORDER BY d.actual_start_date;

-- Q6-b. 잡 정의·스케줄 (클라우드 실제 실행 요일/시각 확인 — 사내는 DISABLED)
SELECT j.job_name, j.enabled, j.state, j.run_count, j.failure_count
     , TO_CHAR(j.last_start_date, 'YYYY-MM-DD HH24:MI:SS') AS last_start
     , TO_CHAR(j.next_run_date,   'YYYY-MM-DD HH24:MI:SS') AS next_run
     , j.schedule_name, j.repeat_interval, j.max_run_duration, j.job_priority, j.logging_level
  FROM all_scheduler_jobs j
 WHERE j.owner = 'SCM_MGR' AND j.job_name = 'JOB_SCMPROD_PLAN_FINAL_40_CREATION';

SELECT s.schedule_name, s.repeat_interval, TO_CHAR(s.start_date, 'YYYY-MM-DD HH24:MI') AS start_date
  FROM all_scheduler_schedules s
 WHERE s.owner = 'SCM_MGR' AND s.schedule_name LIKE 'SCH_JOB_SCMPROD_PLAN_FINAL_40_CREATION%';

-- Q6-c. 잡 로그(요약 — RUN_DETAILS 보다 오래 남는 경우가 있음)
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
SELECT TO_CHAR(g.log_date, 'YYYY-MM-DD HH24:MI:SS') AS log_time, g.job_name, g.operation, g.status, g.user_name, SUBSTR(g.additional_info, 1, 200) AS additional_info
  FROM all_scheduler_job_log g, w
 WHERE g.owner = 'SCM_MGR' AND g.job_name = 'JOB_SCMPROD_PLAN_FINAL_40_CREATION'
   AND g.log_date >= w.from_dt AND g.log_date < w.to_dt
 ORDER BY g.log_date;


/* ---------- Q7. (선택 · 권한 필요) 구간 안의 어느 SQL 이 느린가 — hook #129 0-b 실측 ----------
 * Q2/Q3 는 step 로그 단위라 "구간" 까지만 특정한다. 구간 안의 SQL 1문장을 특정하려면 아래 중 가능한 것을 쓴다.
 * 권한: Q7-a = SELECT ON V_$SQLAREA (+DBA_OBJECTS) · Q7-b/c = Diagnostics Pack 라이선스 + DBA_HIST_* 조회 권한. 사내 SCM_MGR 에는 둘 다 없음(권한 보유 계정으로).  */

-- Q7-a. 공유풀에 남은 이 SP 발 SQL 의 누적 소요 상위 (실행 직후에만 유효 — 밀려났으면 안 나옴). PROGRAM_LINE# = SP 안의 줄 번호
SELECT s.sql_id, s.plan_hash_value, s.executions
     , ROUND(s.elapsed_time / 1e6)                               AS elapsed_sec
     , ROUND(s.elapsed_time / NULLIF(s.executions, 0) / 1e6, 1)  AS sec_per_exec
     , s.buffer_gets, s.disk_reads, s.rows_processed
     , s.last_active_time
     , o.object_name                                             AS from_program
     , s.program_line#
     , SUBSTR(s.sql_text, 1, 160)                                AS sql_text
  FROM v$sqlarea s
  LEFT JOIN dba_objects o ON o.object_id = s.program_id
 WHERE s.parsing_schema_name = 'SCM_MGR'
   AND o.object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW', 'PR_DM_DNM_CREATE_WS_RTF')
   AND s.elapsed_time > 5 * 1e6
 ORDER BY s.elapsed_time DESC
 FETCH FIRST 40 ROWS ONLY;

-- Q7-b. AWR ASH — 기간 안 이 SP 를 실행한 세션들이 어느 SQL/플랜 라인/대기이벤트에서 시간을 썼나 (10초 샘플 1건 ≈ 10초)
--       보존 기본 8일(사내 실측 8일/1시간 스냅샷) → 전주 월요일은 오늘(수) 기준 9일 전이라 월요일분이 비어 있을 수 있음. 비면 Q7-c 로.
--       PLSQL_ENTRY_OBJECT_ID = 루트 SP 객체 → 하위 SP 안에서 돈 SQL 도 전부 잡힌다(PLSQL_OBJECT_ID 는 비어 있는 경우가 많아 참고용).
--       DBID = CON_DBID : AWR 이 CDB 루트(dbid≠con_dbid)와 PDB 로 같은 샘플을 2벌 보존하므로 PDB 쪽 1벌만 집계(사내 실측: 같은 SQL 35+50 샘플 → 50 만 유효).
--       결과 상위 sql_id 는 SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_AWR('<sql_id>', <plan_hash>, NULL, 'ALLSTATS LAST')) 로 플랜 라인을 푼다.
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
SELECT h.sql_id, h.sql_plan_hash_value, h.sql_plan_line_id
     , h.sql_plan_operation || ' ' || h.sql_plan_options                            AS plan_op
     , (SELECT object_name FROM dba_objects WHERE object_id = h.plsql_object_id)  AS in_program   -- 그 순간 실행 중이던 SP(비어 있으면 루트)
     , NVL(h.event, 'ON CPU')                                                       AS event
     , COUNT(*) * 10                                                                AS approx_sec
     , ROUND(RATIO_TO_REPORT(COUNT(*)) OVER () * 100, 1)                            AS pct
     , MIN(TO_CHAR(h.sample_time, 'MM-DD HH24:MI:SS'))                              AS first_seen
     , MAX(TO_CHAR(h.sample_time, 'MM-DD HH24:MI:SS'))                              AS last_seen
     , LISTAGG(DISTINCT h.session_id || ',' || h.session_serial#, ' ') WITHIN GROUP (ORDER BY h.session_id) AS sessions   -- Q6 SESSION_ID 와 대조
     , MAX(h.module) AS module, MAX(h.action) AS action                              -- 스케줄러 실행이면 DBMS_SCHEDULER / 잡 이름
  FROM dba_hist_active_sess_history h, w
 WHERE h.sample_time >= w.from_dt AND h.sample_time < w.to_dt
   AND h.dbid = h.con_dbid
   AND (h.plsql_entry_object_id = (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND object_type = 'PROCEDURE') OR h.plsql_object_id = (SELECT object_id FROM dba_objects WHERE owner = 'SCM_MGR' AND object_name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND object_type = 'PROCEDURE'))
 GROUP BY h.sql_id, h.sql_plan_hash_value, h.sql_plan_line_id, h.sql_plan_operation || ' ' || h.sql_plan_options, h.plsql_object_id, NVL(h.event, 'ON CPU')
 ORDER BY approx_sec DESC
 FETCH FIRST 40 ROWS ONLY;

-- Q7-c. AWR SQLSTAT — 기간 안 스냅샷에서 이 스케줄러 잡 세션이 돌린 SQL 의 소요 상위 (SQL 단위 누적; ASH 가 비었을 때의 대안)
--       DBMS_SCHEDULER 잡 세션은 MODULE='DBMS_SCHEDULER', ACTION=잡 이름 으로 찍힌다(사내 실측: 자동 튜닝 태스크가 ACTION='ORA$AT_SQ_SQL_SW_nnn' 로 같은 MODULE 을 쓰므로 ACTION 으로 걸러야 한다).
--       수동 실행(SQL 툴)이면 ACTION 이 없어 0행 → Q7-b(PLSQL_ENTRY 기반)를 쓴다. DBID = CON_DBID 는 Q7-b 와 같은 2벌 보존 제거.
WITH w AS (SELECT TRUNC(SYSDATE, 'IW') - 7 AS from_dt, TRUNC(SYSDATE, 'IW') - 3 AS to_dt FROM dual)
SELECT t.sql_id, t.plan_hash_value
     , SUM(t.executions_delta)                                   AS execs
     , ROUND(SUM(t.elapsed_time_delta) / 1e6)                    AS elapsed_sec
     , ROUND(SUM(t.cpu_time_delta) / 1e6)                        AS cpu_sec
     , ROUND(SUM(t.iowait_delta) / 1e6)                          AS io_sec
     , SUM(t.buffer_gets_delta)                                  AS buffer_gets
     , SUM(t.disk_reads_delta)                                   AS disk_reads
     , SUM(t.rows_processed_delta)                               AS rows_processed
     , MIN(TO_CHAR(sn.begin_interval_time, 'MM-DD HH24:MI'))     AS first_snap
     , (SELECT SUBSTR(DBMS_LOB.SUBSTR(x.sql_text, 160, 1), 1, 160) FROM dba_hist_sqltext x WHERE x.sql_id = t.sql_id AND x.dbid = x.con_dbid AND ROWNUM = 1) AS sql_text
  FROM dba_hist_sqlstat t
  JOIN dba_hist_snapshot sn ON sn.snap_id = t.snap_id AND sn.dbid = t.dbid AND sn.instance_number = t.instance_number
  JOIN w ON sn.begin_interval_time >= w.from_dt AND sn.begin_interval_time < w.to_dt
 WHERE t.dbid = t.con_dbid
   AND t.parsing_schema_name = 'SCM_MGR'
   AND t.module = 'DBMS_SCHEDULER'
   AND t.action = 'JOB_SCMPROD_PLAN_FINAL_40_CREATION'
 GROUP BY t.sql_id, t.plan_hash_value
HAVING SUM(t.elapsed_time_delta) > 5 * 1e6
 ORDER BY elapsed_sec DESC
 FETCH FIRST 40 ROWS ONLY;


/* ---------- Q8. 클라우드 SP 버전 대조 — 줄 번호·GTT 정의가 사내 원문과 같은가 (2026-10-07 클라우드 1차 결과 후 추가) ----------
 * 클라우드 ERROR 줄(2312 = ORA-01400 GT_PRDM2_FP_STOCK_QTY.SCM_SITE_ID / 2703 = ORA-00001 PK_DM_PLN_CFM_MKT_DEMAND_PLAN)이 사내 원문(2316 / 2713)과 어긋남
 * → 클라우드 SP 가 다른 판본. Q2 SECTION 의 줄 번호도 클라우드에서는 몇 줄 어긋난다. 아래로 판본·에러 지점·AJS 2026.10.01 보정 포함 여부·GTT NOT NULL 을 확인한다. */

-- Q8-a. 판본 식별 (LAST_DDL · 총 줄수 · 2026.10.01 AJS 보정 2곳 포함 여부)
SELECT o.object_name, o.status, TO_CHAR(o.last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl
     , (SELECT MAX(line) FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type)                                          AS total_lines
     , (SELECT COUNT(*)  FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%2026.10.01 AJS%')      AS ajs_1001_marks   -- 사내 = 4 (END_CUSTOMER 조인 2 + ATTRIBUTE 복사 2)
     , (SELECT COUNT(*)  FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND s.text LIKE '%E20261006-ASISDELTA%') AS asisdelta_1006_marks   -- 사내 = 1 이상
     , (SELECT COUNT(*)  FROM all_source s WHERE s.owner = o.owner AND s.name = o.object_name AND s.type = o.object_type AND UPPER(s.text) LIKE '%STEP - A0%')    AS step_marks   -- 사내 = 11
  FROM all_objects o
 WHERE o.owner = 'SCM_MGR' AND o.object_name IN ('PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE', 'PR_DM_DNM_CREATE_WS_RTF', 'PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW')
   AND o.object_type = 'PROCEDURE';

-- Q8-b. 에러 줄 전후 원문 (Q1 ERR_AT 의 line NNNN 을 넣는다)
SELECT line, text FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND type = 'PROCEDURE'
   AND (line BETWEEN 2312 - 8 AND 2312 + 20 OR line BETWEEN 2703 - 12 AND 2703 + 60)
 ORDER BY line;

-- Q8-c. step 마커 줄 번호 (클라우드 기준 SECTION 줄 범위 재계산용)
SELECT line, TRIM(text) AS text FROM all_source
 WHERE owner = 'SCM_MGR' AND name = 'PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE' AND type = 'PROCEDURE'
   AND (UPPER(text) LIKE '%STEP - A0%' OR text LIKE '%PR_DM_DNM_CREATE_WS_RTF(%' OR text LIKE '%PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW(%' OR text LIKE '%GATHER_TABLE_STATS%')
 ORDER BY line;

-- Q8-d. GTT 정의 — 사내는 GT_PRDM2_FP_STOCK_QTY 4칸 전부 NULL 허용(AS-IS #T 는 SCM_SITE_ID NOT NULL). 클라우드 ORA-01400 은 NOT NULL 판본이라는 뜻
SELECT t.table_name, t.temporary, t.duration, c.column_name, c.data_type, c.data_length, c.nullable
  FROM all_tables t JOIN all_tab_columns c ON c.owner = t.owner AND c.table_name = t.table_name
 WHERE t.owner = 'SCM_MGR' AND t.table_name IN ('GT_PRDM2_FP_STOCK_QTY', 'GT_PRDM2_RESULTS', 'GT_PRDM2_VMI_MST_MAIN')
 ORDER BY t.table_name, c.column_id;

-- Q8-e. ORA-01400 원인 데이터 — SCM_SITE_ID 가 비어 있는 LOCATION 에 재고가 걸리는가 (40, 전주 월요일 기준일). 0 이면 그 시점 데이터가 이미 정리된 것
SELECT 'STOCK_SN' AS src, COUNT(*) AS null_site_rows
  FROM SCM_DNM_STOCK_SN S JOIN SCM_MST_LOCATION L ON L.DIVISION_ID = S.DIVISION_ID AND L.STORAGE_ID = S.STORAGE_ID
 WHERE S.DIVISION_ID = '40' AND L.SCM_SITE_ID IS NULL AND S.CUTOFF_DATE >= TRUNC(SYSDATE, 'IW') - 14
UNION ALL
SELECT 'LOCATION', COUNT(*) FROM SCM_MST_LOCATION L WHERE L.DIVISION_ID = '40' AND L.SCM_SITE_ID IS NULL;
