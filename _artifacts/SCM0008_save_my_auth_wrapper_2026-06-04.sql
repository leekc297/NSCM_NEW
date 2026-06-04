-- ============================================================================
-- SCM0008 (Auth Request) — SAVE_MY_AUTH wrapper SP (CRUD_TYPE 분기)
-- 작성: 2026-06-04
-- 기존: PKG_SYS0011.P_SYS0011_SAVE_MY_AUTH_DATA — MERGE INSERT 만 (CRUD_TYPE 무시) ⚠️
-- 신규: SCM_MGR.P_SYS0011_SAVE_MY_AUTH_CRUD (standalone) — CRUD_TYPE 분기 + AS-IS 3 SP logic 통합
-- ----------------------------------------------------------------------------
-- AS-IS 3 SP 통합:
--   ADD     (CRUD_TYPE='I') — UP_FX_SaveReqAuthAddMyList   (INSERT IF NOT EXISTS)
--   REQUEST (CRUD_TYPE='M') — UP_FX_SaveReqAuthRequestMyList (UPDATE APPROVAL_RESULT='REQUESTING')
--   DELETE  (CRUD_TYPE='D') — UP_FX_DeleteReqAuthAddedMyList (DELETE row)
--
-- FE payload (mutateMyAuth):
--   [{ USER_GR_ID, USER_ID, DIVISION_ID, PLANT_ID, CRUD_TYPE, LAST_UPDATED_BY, APPROVAL_RESULT, ... }, ...]
--   USER_ID 는 FE 가 session.userId 로 자동 채움 (auth-request 화면은 자기 자신 권한 요청)
--   APPROVAL_RESULT 는 REQUEST 시 'REQUESTING' 으로 설정 (FE 의 APPROVAL_RESULT enum)
-- ============================================================================

CREATE OR REPLACE PROCEDURE SCM_MGR.P_SYS0011_SAVE_MY_AUTH_CRUD
(
    P_DATA          IN  CLOB,
    P_USER_ID       IN  VARCHAR2,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : P_SYS0011_SAVE_MY_AUTH_CRUD
 * Description  : SCM0008 SAVE_MY_AUTH wrapper — CRUD_TYPE 별 분기 (AS-IS UP_FX_*SaveReqAuth* 3 SP 통합)
 * Program History
 *===========================================================================================
 * Date         In Charge      Description
 *===========================================================================================
 * 2017.02.27   KYH            AS-IS UP_FX_SaveReqAuthAddMyList Initial
 * 2017.02.27   이정석          AS-IS UP_FX_DeleteReqAuthAddedMyList Initial
 * 2017.02.27   AS-IS          UP_FX_SaveReqAuthRequestMyList Initial
 * 2023.03.02   FP Pjt.        E20230216-000381 Merge 처리
 * 2026.04.16   park.choyi     [PJ20264226] PKG_SYS0011 P_SYS0011_SAVE_MY_AUTH_DATA (ADD 만)
 * 2026.06.04   gyucheollee    CRUD_TYPE 분기 wrapper — ADD/REQUEST/DELETE 통합
 */
AS
    V_ADD_CNT      NUMBER := 0;
    V_REQ_CNT      NUMBER := 0;
    V_DEL_CNT      NUMBER := 0;
    V_ERR_MSG      VARCHAR2(4000);

    V_PROGRAM_NAME NVARCHAR2(150) := 'P_SYS0011_SAVE_MY_AUTH_CRUD';
    V_LOG_TYPE     NVARCHAR2(30);
    V_LOG_MESSAGE  NVARCHAR2(1000);
    V_LOG_DESC     NVARCHAR2(500);
    D_EVENT_DATE   DATE;
BEGIN
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_LOG_DESC    := 'data len=' || NVL(TO_CHAR(LENGTH(P_DATA)), '0') || ', user=' || P_USER_ID;
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    -- (1) ADD: CRUD_TYPE='I' — MERGE INSERT (AS-IS UP_FX_SaveReqAuthAddMyList)
    --     기존 PKG_SYS0011.P_SYS0011_SAVE_MY_AUTH_DATA 의 INSERT logic 유지
    MERGE INTO SCM_MST_AUTH_REQUEST T
    USING (
        SELECT
            V_USER_ID                AS USER_ID,
            V_USER_GR_ID             AS USER_GR_ID,
            NVL(V_DIVISION_ID, '-')  AS DIVISION_ID,
            NVL(V_PLANT_ID,    '-')  AS PLANT_ID
          FROM JSON_TABLE(P_DATA, '$[*]'
              COLUMNS (
                  V_CRUD_TYPE   VARCHAR2(10)  PATH '$.CRUD_TYPE',
                  V_USER_ID     VARCHAR2(200) PATH '$.USER_ID',
                  V_USER_GR_ID  VARCHAR2(200) PATH '$.USER_GR_ID',
                  V_DIVISION_ID VARCHAR2(200) PATH '$.DIVISION_ID' NULL ON EMPTY NULL ON ERROR,
                  V_PLANT_ID    VARCHAR2(200) PATH '$.PLANT_ID'    NULL ON EMPTY NULL ON ERROR
              ))
         WHERE V_CRUD_TYPE = 'I'
    ) M
    ON  (T.USER_ID     = M.USER_ID
     AND T.GROUP_ID    = M.USER_GR_ID
     AND T.DIVISION_ID = M.DIVISION_ID
     AND T.PLANT_ID    = M.PLANT_ID)
    WHEN NOT MATCHED THEN INSERT
        (USER_ID, GROUP_ID, DIVISION_ID, PLANT_ID, CREATED_BY, CREATION_DATE)
        VALUES
        (M.USER_ID, M.USER_GR_ID, M.DIVISION_ID, M.PLANT_ID, P_USER_ID, SYSDATE);
    V_ADD_CNT := SQL%ROWCOUNT;

    -- (2) REQUEST: CRUD_TYPE='M' — UPDATE APPROVAL_RESULT='REQUESTING' (AS-IS UP_FX_SaveReqAuthRequestMyList)
    UPDATE SCM_MST_AUTH_REQUEST T
       SET APPROVAL_RESULT  = 'REQUESTING',
           REJECT_REASON    = NULL,
           LAST_UPDATED_BY  = P_USER_ID,
           LAST_UPDATE_DATE = SYSDATE
     WHERE (T.USER_ID, T.GROUP_ID, T.DIVISION_ID, T.PLANT_ID) IN (
         SELECT V_USER_ID, V_USER_GR_ID, NVL(V_DIVISION_ID, '-'), NVL(V_PLANT_ID, '-')
           FROM JSON_TABLE(P_DATA, '$[*]'
               COLUMNS (
                   V_CRUD_TYPE   VARCHAR2(10)  PATH '$.CRUD_TYPE',
                   V_USER_ID     VARCHAR2(200) PATH '$.USER_ID',
                   V_USER_GR_ID  VARCHAR2(200) PATH '$.USER_GR_ID',
                   V_DIVISION_ID VARCHAR2(200) PATH '$.DIVISION_ID' NULL ON EMPTY NULL ON ERROR,
                   V_PLANT_ID    VARCHAR2(200) PATH '$.PLANT_ID'    NULL ON EMPTY NULL ON ERROR
               ))
          WHERE V_CRUD_TYPE = 'M'
       );
    V_REQ_CNT := SQL%ROWCOUNT;

    -- (3) DELETE: CRUD_TYPE='D' — DELETE FROM SCM_MST_AUTH_REQUEST (AS-IS UP_FX_DeleteReqAuthAddedMyList)
    DELETE FROM SCM_MST_AUTH_REQUEST T
     WHERE (T.USER_ID, T.GROUP_ID, T.DIVISION_ID, T.PLANT_ID) IN (
         SELECT V_USER_ID, V_USER_GR_ID, NVL(V_DIVISION_ID, '-'), NVL(V_PLANT_ID, '-')
           FROM JSON_TABLE(P_DATA, '$[*]'
               COLUMNS (
                   V_CRUD_TYPE   VARCHAR2(10)  PATH '$.CRUD_TYPE',
                   V_USER_ID     VARCHAR2(200) PATH '$.USER_ID',
                   V_USER_GR_ID  VARCHAR2(200) PATH '$.USER_GR_ID',
                   V_DIVISION_ID VARCHAR2(200) PATH '$.DIVISION_ID' NULL ON EMPTY NULL ON ERROR,
                   V_PLANT_ID    VARCHAR2(200) PATH '$.PLANT_ID'    NULL ON EMPTY NULL ON ERROR
               ))
          WHERE V_CRUD_TYPE = 'D'
       );
    V_DEL_CNT := SQL%ROWCOUNT;

    COMMIT;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_LOG_DESC    := 'add=' || V_ADD_CNT || ', request=' || V_REQ_CNT || ', delete=' || V_DEL_CNT;
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, V_ADD_CNT + V_REQ_CNT + V_DEL_CNT, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'                                   AS CODE,
               'SUCCESS'                             AS MSG,
               TO_CHAR(V_ADD_CNT + V_REQ_CNT + V_DEL_CNT) AS EVENT,
               TO_CHAR(V_ADD_CNT)                    AS ADD_CNT,
               TO_CHAR(V_REQ_CNT)                    AS REQUEST_CNT,
               TO_CHAR(V_DEL_CNT)                    AS DELETE_CNT
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_LOG_DESC    := TO_CHAR(SQLCODE);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_LOG_DESC, D_EVENT_DATE);
        EXCEPTION WHEN OTHERS THEN NULL; END;

        IF SQLCODE = -1 THEN
            V_ERR_MSG := 'Duplicate key error.';
        ELSIF SQLCODE = -1400 THEN
            V_ERR_MSG := 'Required value is missing.';
        ELSIF SQLCODE = -12899 THEN
            V_ERR_MSG := 'Maximum data size exceeded.';
        ELSE
            V_ERR_MSG := SUBSTR(SQLERRM, 1, 4000);
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT,
                   TO_CHAR(0) AS ADD_CNT, TO_CHAR(0) AS REQUEST_CNT, TO_CHAR(0) AS DELETE_CNT
              FROM DUAL;
END P_SYS0011_SAVE_MY_AUTH_CRUD;
/

SHOW ERRORS PROCEDURE SCM_MGR.P_SYS0011_SAVE_MY_AUTH_CRUD;
