/*=============================================================================================
 * File         : 02_seed_minyonglee1.sql
 * Description  : 로컬 로그인 테스트용 최소 시드
 *              :   - SCM_ADM_USER_GR_M : 'GUEST' 그룹
 *              :   - SCM_MST_SSO_USER_INFO : 'minyonglee1' 사용자
 *              : (PR_GET_NSCM_USER 가 자동으로 SCM_ADM_USER_M + SCM_ADM_USER_GR_MPG_M(GUEST) 생성)
 * Connection   : SCM_MGR @ FREEPDB1
 * Created      : 2026-05-26
 *===========================================================================================*/

SET ECHO ON
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT SQL.SQLCODE

-- ---------------------------------------------------------------------------------------------
-- BLOCK 1. GUEST 그룹 (있으면 skip — idempotent)
-- ---------------------------------------------------------------------------------------------
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
        DBMS_OUTPUT.PUT_LINE('Inserted GUEST user group.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('GUEST already exists.');
    END IF;
END;
/

-- ---------------------------------------------------------------------------------------------
-- BLOCK 2. SSO 사용자 minyonglee1 (있으면 skip)
-- ---------------------------------------------------------------------------------------------
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
        DBMS_OUTPUT.PUT_LINE('Inserted SSO user minyonglee1.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('minyonglee1 already exists.');
    END IF;
END;
/

COMMIT;

-- ---------------------------------------------------------------------------------------------
-- BLOCK 3. 검증
-- ---------------------------------------------------------------------------------------------
PROMPT === Verification ===
COLUMN USER_ID FORMAT A20
COLUMN USER_NAME FORMAT A20
SELECT USER_GR_ID, USER_GR_NM, USE_YN FROM SCM_ADM_USER_GR_M WHERE USER_GR_ID = 'GUEST';
SELECT USER_ID, USER_NAME, USER_NAME_EN, DEPT_ID, ACTIVE_FLAG FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = 'minyonglee1';

PROMPT === DONE: 02_seed_minyonglee1.sql ===
EXIT
