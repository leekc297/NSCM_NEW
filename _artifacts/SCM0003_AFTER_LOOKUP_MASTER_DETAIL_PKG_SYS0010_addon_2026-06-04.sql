-- ============================================================================
-- SCM0003 격차 #1 — AFTER_LOOKUP_MASTER_DETAIL SP (standalone)
-- 작성: 2026-06-04
-- AS-IS: dbo.SCM0003_AFTER_LOOKUP_MASTER_DETAIL (MSSQL, 130 lines)
-- TO-BE: SCM_MGR.P_SYS0010_AFTER_LOOKUP_MASTER_DETAIL (Oracle, standalone)
-- 동작: Lookup Master/Detail 저장 후 후처리 (현재 AS-IS 본문은 모든 비즈니스 로직 주석 처리됨 —
--       START/END LOG_BATCH 만 호출 + 'S'/result_cnt cursor 반환)
-- ============================================================================

CREATE OR REPLACE PROCEDURE SCM_MGR.P_SYS0010_AFTER_LOOKUP_MASTER_DETAIL (
    P_PROGRAM_ID    IN  VARCHAR2
  , P_SHEET_NAME    IN  VARCHAR2
  , P_USER_ID       IN  VARCHAR2
  , P_DEBUG_MODE    IN  VARCHAR2
  , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : P_SYS0010_AFTER_LOOKUP_MASTER_DETAIL
 * Description  : Lookup 저장 후 후처리 (AS-IS : dbo.SCM0003_AFTER_LOOKUP_MASTER_DETAIL)
 *                AS-IS 본문은 비즈니스 로직 모두 주석 처리 (2025-02-10 mrchois)
 *                — 시스템별 추가 후처리 필요 시 본문에 분기 추가 hook 으로 유지
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2024.10.10   chaan          AS-IS Initial Release [PJ20230692 SCP 개선과제 Phase2]
 * 2025.02.10   mrchois        AS-IS 본문 logic 주석 처리 [PJ20249346]
 * 2026.06.04   gyucheollee    Oracle 1:1 변환 — TO-BE SYS0010 격차 #1 SP wire
 */
IS
    V_ALL_CNT       NUMBER := 0;
    V_PROGRAM_NAME  NVARCHAR2(150) := 'P_SYS0010_AFTER_LOOKUP_MASTER_DETAIL';
    V_LOG_TYPE      NVARCHAR2(30);
    N_LOG_COUNT     NUMBER := 0;
    V_LOG_MESSAGE   NVARCHAR2(1000);
    V_LOG_DESC      NVARCHAR2(500);
    D_EVENT_DATE    DATE;
BEGIN
    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_LOG_DESC    := 'program_id=' || P_PROGRAM_ID || ', sheet_name=' || P_SHEET_NAME || ', user_id=' || P_USER_ID;
    D_EVENT_DATE  := SYSDATE;

    IF NVL(P_DEBUG_MODE, 'F') <> 'T' THEN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);
    END IF;

    -- AS-IS 시스템별 추가 작업 hook (현재 비활성 — 2025-02-10 mrchois)
    --IF P_SHEET_NAME = 'SCP_CAPA_LOSS_MEASURE' THEN
    --    SCM_MGR.PR_SCP_MST_CAPA_LOSS_MEASURE_IG_CHNG_AP(P_USER_ID);
    --ELSIF P_SHEET_NAME = 'SCP_CAPA_ELTR_LOSS_MEASURE' THEN
    --    SCM_MGR.PR_SCP_MST_CAPA_LOSS_MEASURE_IG_CHNG_ELTR(P_USER_ID);
    --END IF;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_LOG_DESC    := '';
    D_EVENT_DATE  := SYSDATE;

    IF NVL(P_DEBUG_MODE, 'F') <> 'T' THEN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);
    END IF;

    COMMIT;

    -- 결과 cursor 반환 (AS-IS: SELECT 'S' AS result_code, @v_all_cnt AS result_cnt;)
    OPEN O_RESULT_CURSOR FOR
        SELECT 'S'                AS RESULT_CODE
             , TO_CHAR(V_ALL_CNT) AS RESULT_CNT
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SQLERRM;
        V_LOG_DESC    := TO_CHAR(SQLCODE);
        D_EVENT_DATE  := SYSDATE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);
        EXCEPTION WHEN OTHERS THEN NULL;  -- LOG_BATCH 실패가 본 SP 결과를 막지 않도록
        END;

        -- AS-IS: SELECT 'F' AS result_code; (에러 cursor 반환, 호출자가 result_code 만 확인)
        --        SQLERRM 은 SELECT 절 직접 사용 불가 → V_LOG_MESSAGE 변수 경유
        OPEN O_RESULT_CURSOR FOR
            SELECT 'F'              AS RESULT_CODE
                 , V_LOG_MESSAGE    AS ERROR_MESSAGE
              FROM DUAL;
END P_SYS0010_AFTER_LOOKUP_MASTER_DETAIL;
/

SHOW ERRORS PROCEDURE SCM_MGR.P_SYS0010_AFTER_LOOKUP_MASTER_DETAIL;
