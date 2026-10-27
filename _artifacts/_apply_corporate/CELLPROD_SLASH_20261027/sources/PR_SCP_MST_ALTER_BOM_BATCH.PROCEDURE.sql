PROCEDURE         PR_SCP_MST_ALTER_BOM_BATCH
/* ============================================================
 * Program ID   : PR_SCP_MST_ALTER_BOM_BATCH
 * Description  : 대체 BOM 생성
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2021.04.12    SEO            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
 *                              - SCP 대치BOM
 * 2023.06.22    KSG            [PJ20230691] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 * 2023.07.25    HRK            [PJ20230691] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 해외 대응 - PROD/ASSY 매핑정보 생성 호출 순서 변경
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCP_MST_ALTER_BOM_BATCH';
    V_LOG_TYPE      VARCHAR2(30 CHAR);
    N_LOG_COUNT     INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
BEGIN
    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '[PR_SCP_MST_ALTER_BOM_BATCH]';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, NULL, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    BEGIN
        /* 하위 6 BOM proc 순차 실행 (호출 순서 원본 유지: ASSY맵->ALTER->MODEL->MODEL ADD ASSY->EFF->EFF ADD ASSY) */
        PR_SCP_MST_CELL_PROD_ASSY_MAP;
        PR_SCP_MST_ALTER_BOM;
        PR_SCP_MST_MODEL_BOM;
        PR_SCP_MST_MODEL_BOM_ADD_ASSY;
        PR_SCP_MST_MODEL_BOM_EFF;
        PR_SCP_MST_MODEL_BOM_EFF_ADD_ASSY;


        V_LOG_TYPE    := 'TXN';
        V_LOG_MESSAGE := 'RUN ';
        V_DESCRIPTION := 'Process Complete... ';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, NULL, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := 'ERROR_LINE : ' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 480);
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, NULL, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            RAISE;
    END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '[PR_SCP_MST_ALTER_BOM_BATCH]';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, NULL, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
END;