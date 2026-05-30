-- ============================================================================================
-- File         : 02_seed_minyonglee1_DBeaver.sql
-- Description  : DBeaver 호환판. SCM_MGR 로 FREEPDB1 접속 후 각 블록 Ctrl+Enter 실행.
-- Connection   : SCM_MGR / !SCMroqkf2026 @ jdbc:oracle:thin:@//localhost:1521/FREEPDB1
-- ============================================================================================

-- BLOCK 1. GUEST 그룹 (idempotent)
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM SCM_ADM_USER_GR_M WHERE USER_GR_ID = 'GUEST';
    IF v_cnt = 0 THEN
        INSERT INTO SCM_ADM_USER_GR_M (
            USER_GR_ID, USER_GR_NM, USE_YN,
            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        ) VALUES (
            'GUEST', 'Guest Group', 'Y',
            'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
        );
    END IF;
    COMMIT;
END;

-- BLOCK 2. minyonglee1 SSO 사용자 (idempotent)
DECLARE
    v_cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = 'minyonglee1';
    IF v_cnt = 0 THEN
        INSERT INTO SCM_MST_SSO_USER_INFO (
            USER_ID, USER_NAME, USER_NAME_EN, DEPT_ID,
            JOB_CODE, JOB_NAME, COMPANY_ID, WORKING_CODE, WORKING_NAME,
            SSO_LOCATE, ACTIVE_FLAG,
            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        ) VALUES (
            'minyonglee1', '이민용', 'Min-yong Lee', 'NSCM_LOCAL',
            'DEV', 'Developer', 'LGES', 'WORK01', 'Working',
            'KR', 'Y',
            'SYSTEM', SYSDATE, 'SYSTEM', SYSDATE
        );
    END IF;
    COMMIT;
END;
