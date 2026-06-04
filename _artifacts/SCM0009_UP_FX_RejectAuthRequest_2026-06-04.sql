-- ============================================================================
-- SCM0009 권한 승인 화면 — REJECT 신규 SP (AS-IS UP_FX_SaveApprovalAuthRequest 의 REJECT 분기만)
-- 작성: 2026-06-04
-- AS-IS: dbo.UP_FX_SaveApprovalAuthRequest (288 lines, REJECT/APPROVED 분기 SP)
-- TO-BE: SCM_MGR.UP_FX_RejectAuthRequest (REJECT 전용, framework 의존성 0 — TO-BE 표준 테이블 직접 매핑)
-- ----------------------------------------------------------------------------
-- AS-IS REJECT 분기 (line 103-136):
--   1. UPDATE SCM_MST_AUTH_REQUEST: APPROVAL_RESULT='REJECT' / APPROVAL_USER / REJECT_REASON / LAST_UPDATE_DATE
--   2. DELETE FROM TB_FX_UserGroupAuthExtention (권한 회수 — Division level)
--   3. UPDATE TB_FX_UserGroupInfo SET useyn='N' (NOT EXISTS 잔여권한 → 그룹 비활성화)
--
-- TO-BE 테이블 매핑:
--   TB_FX_UserGroupAuthExtention → SCM_ADM_USER_GR_UNIT_AUTH_MPG_M (UNIT_TP_CD='D' = Division)
--   TB_FX_UserGroupInfo          → SCM_ADM_USER_GR_MPG_M
--
-- FE payload:
--   { requestIds: 'USER_ID|GROUP_ID|DIVISION_ID|PLANT_ID,USER_ID|GROUP_ID|...' (콤마 구분 composite list) }
--   GET SP 의 REQUEST_ID 합성 컬럼과 1:1 매칭
-- ============================================================================

CREATE OR REPLACE PROCEDURE SCM_MGR.UP_FX_RejectAuthRequest
(
    p_requestIds   IN  CLOB,        -- composite "U|G|D|P" 콤마 구분
    p_rejectReason IN  VARCHAR2,    -- REJECT 사유
    p_sesUserId    IN  VARCHAR2,    -- 처리자 (BE 자동 주입)
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : UP_FX_RejectAuthRequest
 * Description  : 권한 요청 REJECT 처리 (AS-IS UP_FX_SaveApprovalAuthRequest REJECT 분기 만)
 *                AS-IS framework SP 의존성 제거 — TO-BE 표준 테이블 직접 매핑
 * Program History
 *===========================================================================================
 * Date         In Charge      Description
 *===========================================================================================
 * 2018.02.27   KYH            AS-IS UP_FX_SaveApprovalAuthRequest Initial PJ20170278
 * 2023.03.02   FP Pjt.        E20230216-000381 REJECT 시 기존 권한 회수
 * 2026.06.04   gyucheollee    Oracle 신규 작성 — REJECT 분기 1:1 logic + TO-BE 표준 테이블 매핑
 */
AS
    v_request_id       VARCHAR2(500);
    v_user_id          VARCHAR2(150);
    v_group_id         VARCHAR2(20);
    v_division_id      VARCHAR2(30);
    v_plant_id         VARCHAR2(30);
    v_pos1             PLS_INTEGER;
    v_pos2             PLS_INTEGER;
    v_pos3             PLS_INTEGER;
    n_processed_cnt    PLS_INTEGER := 0;
    n_perm_revoked_cnt PLS_INTEGER := 0;
    n_group_off_cnt    PLS_INTEGER := 0;

    V_PROGRAM_NAME  NVARCHAR2(150) := 'UP_FX_RejectAuthRequest';
    V_LOG_TYPE      NVARCHAR2(30);
    V_LOG_MESSAGE   NVARCHAR2(1000);
    V_LOG_DESC      NVARCHAR2(500);
    D_EVENT_DATE    DATE;
BEGIN
    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_LOG_DESC    := 'requestIds len=' || NVL(TO_CHAR(LENGTH(p_requestIds)), '0') || ', sesUserId=' || p_sesUserId;
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, n_processed_cnt, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -- LOOP 처리 (composite "U|G|D|P" 콤마 split → 각 row 매핑)
    FOR rec IN (
        SELECT COLUMN_VALUE AS REQ_ID
          FROM TABLE(SCM_MGR.FN_SCM_STRING_SPLIT(TO_CHAR(p_requestIds), ','))
    ) LOOP
        v_request_id := rec.REQ_ID;
        IF v_request_id IS NULL OR LENGTH(TRIM(v_request_id)) = 0 THEN CONTINUE; END IF;

        -- "U|G|D|P" 4-segment split
        v_pos1 := INSTR(v_request_id, '|', 1, 1);
        v_pos2 := INSTR(v_request_id, '|', 1, 2);
        v_pos3 := INSTR(v_request_id, '|', 1, 3);
        IF v_pos1 = 0 OR v_pos2 = 0 OR v_pos3 = 0 THEN
            -- malformed REQUEST_ID — skip + log
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'WARN', n_processed_cnt, 'Malformed REQUEST_ID', v_request_id, SYSDATE);
            EXCEPTION WHEN OTHERS THEN NULL; END;
            CONTINUE;
        END IF;

        v_user_id     := SUBSTR(v_request_id, 1,           v_pos1 - 1);
        v_group_id    := SUBSTR(v_request_id, v_pos1 + 1,  v_pos2 - v_pos1 - 1);
        v_division_id := SUBSTR(v_request_id, v_pos2 + 1,  v_pos3 - v_pos2 - 1);
        v_plant_id    := SUBSTR(v_request_id, v_pos3 + 1);

        -- (1) AS-IS UPDATE SCM_MST_AUTH_REQUEST (REJECT 상태 + 사유 기록)
        UPDATE SCM_MST_AUTH_REQUEST
           SET APPROVAL_RESULT  = 'REJECT',
               APPROVAL_USER    = p_sesUserId,
               REJECT_REASON    = p_rejectReason,
               LAST_UPDATED_BY  = p_sesUserId,
               LAST_UPDATE_DATE = SYSDATE
         WHERE USER_ID     = v_user_id
           AND GROUP_ID    = v_group_id
           AND DIVISION_ID = v_division_id
           AND PLANT_ID    = v_plant_id;

        IF SQL%ROWCOUNT > 0 THEN
            n_processed_cnt := n_processed_cnt + 1;
        END IF;

        -- (2) AS-IS DELETE FROM TB_FX_UserGroupAuthExtention (권한 회수, Division level)
        --     TO-BE: SCM_ADM_USER_GR_UNIT_AUTH_MPG_M / UNIT_TP_CD='D' / UNIT_ID = Division_ID
        DELETE FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
         WHERE USER_GR_ID = v_group_id
           AND USER_ID    = v_user_id
           AND UNIT_TP_CD = 'D'
           AND UNIT_ID    = v_division_id;
        n_perm_revoked_cnt := n_perm_revoked_cnt + SQL%ROWCOUNT;

        -- (3) AS-IS UPDATE TB_FX_UserGroupInfo SET useyn='N' (NOT EXISTS 잔여권한)
        --     TO-BE: SCM_ADM_USER_GR_MPG_M / NOT EXISTS SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
        UPDATE SCM_ADM_USER_GR_MPG_M t
           SET t.USE_YN           = 'N',
               t.LAST_UPDATED_BY  = p_sesUserId,
               t.LAST_UPDATE_DATE = SYSDATE
         WHERE t.USER_ID    = v_user_id
           AND t.USER_GR_ID = v_group_id
           AND NOT EXISTS (
               SELECT 1 FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M s
                WHERE s.USER_GR_ID = t.USER_GR_ID
                  AND s.USER_ID    = t.USER_ID
           );
        n_group_off_cnt := n_group_off_cnt + SQL%ROWCOUNT;
    END LOOP;

    COMMIT;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_LOG_DESC    := 'processed=' || n_processed_cnt || ', perm_revoked=' || n_perm_revoked_cnt || ', group_off=' || n_group_off_cnt;
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, n_processed_cnt, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -- AS-IS: SELECT 'S' AS result_code, @max_loop_cnt AS result_cnt
    OPEN O_RESULT_CURSOR FOR
        SELECT 'S'                          AS RESULT_CODE,
               TO_CHAR(n_processed_cnt)     AS RESULT_CNT,
               TO_CHAR(n_perm_revoked_cnt)  AS PERM_REVOKED_CNT,
               TO_CHAR(n_group_off_cnt)     AS GROUP_OFF_CNT
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_LOG_DESC    := TO_CHAR(SQLCODE);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, n_processed_cnt, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_LOG_DESC ||
            ' / SQLERRM=' || V_LOG_MESSAGE ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END UP_FX_RejectAuthRequest;
/

SHOW ERRORS PROCEDURE SCM_MGR.UP_FX_RejectAuthRequest;
