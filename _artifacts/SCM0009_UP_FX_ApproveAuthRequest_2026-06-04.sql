-- ============================================================================
-- SCM0009 권한 승인 화면 — APPROVE 신규 SP (AS-IS UP_FX_SaveApprovalAuthRequest 의 APPROVED 분기)
-- 작성: 2026-06-04
-- AS-IS: dbo.UP_FX_SaveApprovalAuthRequest APPROVED 분기 (line 138-239)
-- TO-BE: SCM_MGR.UP_FX_ApproveAuthRequest
-- ----------------------------------------------------------------------------
-- AS-IS APPROVE 분기:
--   1. UPDATE SCM_MST_AUTH_REQUEST → APPROVAL_RESULT='APPROVED'
--   2. (user 단위) UP_FX_SaveUserInfo — SSO 정보 동기화 + DefaultGroupID 갱신
--      ⚠️ TO-BE 는 SSO 동기화 외부 (SCM_ADM_USER_M 에 DefaultGroupID 컬럼 없음)
--         → 본 SP 에서는 user 마스터 갱신 logic 생략 (SSO 측에서 처리)
--   3. (group 단위) UP_FX_SaveUserGroupInfo → INSERT/UPDATE SCM_ADM_USER_GR_MPG_M
--   4. (division 단위) UP_FX_SaveUserGroupAuthExtention → INSERT/UPDATE SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
--
-- FE payload:
--   { requestIds: 'U|G|D|P,U|G|D|P,...' } (REJECT 와 동일)
-- ============================================================================

CREATE OR REPLACE PROCEDURE SCM_MGR.UP_FX_ApproveAuthRequest
(
    p_requestIds  IN  CLOB,        -- composite "U|G|D|P" 콤마 구분
    p_sesUserId   IN  VARCHAR2,    -- 처리자 (BE 자동 주입)
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : UP_FX_ApproveAuthRequest
 * Description  : 권한 요청 APPROVE 처리 (AS-IS UP_FX_SaveApprovalAuthRequest APPROVED 분기)
 *                AS-IS framework SP 의존성 제거 — TO-BE 표준 테이블 직접 매핑.
 *                ⚠️ AS-IS 의 SSO 정보 동기화 (UP_FX_SaveUserInfo, DefaultGroupID) 는 TO-BE 외부 처리.
 * Program History
 *===========================================================================================
 * Date         In Charge      Description
 *===========================================================================================
 * 2018.02.27   KYH            AS-IS UP_FX_SaveApprovalAuthRequest Initial PJ20170278
 * 2018.04.09   ygkim          AS-IS 추가 요청 권한이 Default 자동 변경되지 않게 처리
 * 2020.03.12   KHJ79          AS-IS PermanentYN 처리
 * 2026.06.04   gyucheollee    Oracle 신규 작성 — APPROVE 분기 핵심 logic (AUTH UPDATE + GR_MPG + UNIT_AUTH)
 *                              + framework SP 의존성 0 + SSO 동기화 외부 위임
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
    n_gr_mpg_cnt       PLS_INTEGER := 0;
    n_unit_auth_cnt    PLS_INTEGER := 0;

    V_PROGRAM_NAME  NVARCHAR2(150) := 'UP_FX_ApproveAuthRequest';
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

        v_pos1 := INSTR(v_request_id, '|', 1, 1);
        v_pos2 := INSTR(v_request_id, '|', 1, 2);
        v_pos3 := INSTR(v_request_id, '|', 1, 3);
        IF v_pos1 = 0 OR v_pos2 = 0 OR v_pos3 = 0 THEN
            BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'WARN', n_processed_cnt, 'Malformed REQUEST_ID', v_request_id, SYSDATE);
            EXCEPTION WHEN OTHERS THEN NULL; END;
            CONTINUE;
        END IF;

        v_user_id     := SUBSTR(v_request_id, 1,           v_pos1 - 1);
        v_group_id    := SUBSTR(v_request_id, v_pos1 + 1,  v_pos2 - v_pos1 - 1);
        v_division_id := SUBSTR(v_request_id, v_pos2 + 1,  v_pos3 - v_pos2 - 1);
        v_plant_id    := SUBSTR(v_request_id, v_pos3 + 1);

        -- (1) AS-IS UPDATE SCM_MST_AUTH_REQUEST (APPROVED 상태)
        UPDATE SCM_MST_AUTH_REQUEST
           SET APPROVAL_RESULT  = 'APPROVED',
               APPROVAL_USER    = p_sesUserId,
               REJECT_REASON    = NULL,
               LAST_UPDATED_BY  = p_sesUserId,
               LAST_UPDATE_DATE = SYSDATE
         WHERE USER_ID     = v_user_id
           AND GROUP_ID    = v_group_id
           AND DIVISION_ID = v_division_id
           AND PLANT_ID    = v_plant_id;

        IF SQL%ROWCOUNT = 0 THEN
            -- AUTH_REQUEST 매칭 없음 → 무효 request → 권한 부여 skip
            CONTINUE;
        END IF;
        n_processed_cnt := n_processed_cnt + 1;

        -- (2) [SKIP] AS-IS UP_FX_SaveUserInfo — TO-BE 외부 (SSO 측)
        --     SCM_ADM_USER_M 의 user master 갱신은 SSO sync 가 수행

        -- (3) AS-IS UP_FX_SaveUserGroupInfo (user ↔ group)
        --     TO-BE: SCM_ADM_USER_GR_MPG_M MERGE
        MERGE INTO SCM_ADM_USER_GR_MPG_M tgt
        USING (SELECT v_group_id AS USER_GR_ID, v_user_id AS USER_ID FROM DUAL) src
           ON (tgt.USER_GR_ID = src.USER_GR_ID AND tgt.USER_ID = src.USER_ID)
        WHEN MATCHED THEN UPDATE
           SET tgt.USE_YN           = 'Y',
               tgt.LAST_UPDATED_BY  = p_sesUserId,
               tgt.LAST_UPDATE_DATE = SYSDATE
        WHEN NOT MATCHED THEN INSERT
           (USER_GR_ID, USER_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
           VALUES
           (src.USER_GR_ID, src.USER_ID, 'Y', p_sesUserId, SYSDATE, p_sesUserId, SYSDATE);
        n_gr_mpg_cnt := n_gr_mpg_cnt + SQL%ROWCOUNT;

        -- (4) AS-IS UP_FX_SaveUserGroupAuthExtention (division 단위 권한)
        --     TO-BE: SCM_ADM_USER_GR_UNIT_AUTH_MPG_M MERGE (UNIT_TP_CD='D' = Division)
        --     v_plant_id 가 '*' (=ALL) 이거나 NULL 이면 plant level 없음 — division 만 처리
        IF v_division_id IS NOT NULL AND v_division_id <> '' AND v_division_id <> '*' THEN
            MERGE INTO SCM_ADM_USER_GR_UNIT_AUTH_MPG_M tgt
            USING (SELECT v_group_id AS USER_GR_ID, v_user_id AS USER_ID,
                          'D' AS UNIT_TP_CD, v_division_id AS UNIT_ID,
                          '*' AS UPPR_UNIT_ID FROM DUAL) src
               ON (tgt.USER_GR_ID = src.USER_GR_ID
              AND tgt.USER_ID    = src.USER_ID
              AND tgt.UNIT_TP_CD = src.UNIT_TP_CD
              AND tgt.UNIT_ID    = src.UNIT_ID)
            WHEN MATCHED THEN UPDATE
               SET tgt.USE_YN           = 'Y',
                   tgt.LAST_UPDATED_BY  = p_sesUserId,
                   tgt.LAST_UPDATE_DATE = SYSDATE
            WHEN NOT MATCHED THEN INSERT
               (USER_GR_ID, USER_ID, UNIT_TP_CD, UNIT_ID, UPPR_UNIT_ID, EDIT_YN, USE_YN,
                CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
               VALUES
               (src.USER_GR_ID, src.USER_ID, src.UNIT_TP_CD, src.UNIT_ID, src.UPPR_UNIT_ID,
                'Y', 'Y', p_sesUserId, SYSDATE, p_sesUserId, SYSDATE);
            n_unit_auth_cnt := n_unit_auth_cnt + SQL%ROWCOUNT;
        END IF;
    END LOOP;

    COMMIT;

    -- 종료 LOG
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_LOG_DESC    := 'processed=' || n_processed_cnt || ', gr_mpg=' || n_gr_mpg_cnt || ', unit_auth=' || n_unit_auth_cnt;
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, n_processed_cnt, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    OPEN O_RESULT_CURSOR FOR
        SELECT 'S'                          AS RESULT_CODE,
               TO_CHAR(n_processed_cnt)     AS RESULT_CNT,
               TO_CHAR(n_gr_mpg_cnt)        AS GR_MPG_CNT,
               TO_CHAR(n_unit_auth_cnt)     AS UNIT_AUTH_CNT
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
END UP_FX_ApproveAuthRequest;
/

SHOW ERRORS PROCEDURE SCM_MGR.UP_FX_ApproveAuthRequest;
