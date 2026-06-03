/*=============================================================================================
 * File         : 15_DMF0020_btn_auth_version_fix.sql
 * Description  : DMF0020 신규 sheet 버튼 권한 추가
 *              :
 *              : 사고: 2026-06-03 BE 로그 — DMF0020/version/SEARCH HAS_AUTH_YN='N'
 *              : 원인: SCM_ADM_USER_GR_MNU_BTN_MPG_M 에 version/SEARCH GUEST 권한 미등록
 *              : 자매 화면 DMF0043_01 권한 그룹: GUEST 1개 (전체 화면 접근)
 *              :
 *              : 처방: DMF0020 의 등록된 SHT_NM x MNU_BTN_CD 전 조합에 GUEST 권한 INSERT (NOT EXISTS 멱등)
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-03
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    v_before NUMBER;
    v_after  NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_before
      FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0020' AND USE_YN='Y';
    DBMS_OUTPUT.PUT_LINE('=== BEFORE: DMF0020 btn auth rows: '||v_before);

    -- 자매 화면 DMF0043_01 패턴 — GUEST 그룹에 모든 MNU_BTN_MPG 등록 sheet x btn 권한 부여
    INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                                CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT 'GUEST', m.MNU_ID, m.SHT_NM, m.MNU_BTN_CD, 'Y',
           'admin', SYSDATE, 'admin', SYSDATE
      FROM SCM_ADM_MNU_BTN_MPG_M m
     WHERE m.MNU_ID = 'DMF0020' AND m.USE_YN = 'Y'
       AND NOT EXISTS (
             SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M x
              WHERE x.USER_GR_ID = 'GUEST'
                AND x.MNU_ID = m.MNU_ID
                AND x.SHT_NM = m.SHT_NM
                AND x.MNU_BTN_CD = m.MNU_BTN_CD
           );
    DBMS_OUTPUT.PUT_LINE('   INSERTED rows: '||SQL%ROWCOUNT);
    COMMIT;

    SELECT COUNT(*) INTO v_after
      FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0020' AND USE_YN='Y';
    DBMS_OUTPUT.PUT_LINE('=== AFTER: DMF0020 btn auth rows: '||v_after);
END;
/

PROMPT === DMF0020 권한 검증 ===
SELECT USER_GR_ID, SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0020' ORDER BY USER_GR_ID, SHT_NM, MNU_BTN_CD;

PROMPT === minyonglee1 의 DMF0020/version/SEARCH 권한 시뮬 (PR_CHECK_MNU_BTN_AUTH 동등) ===
DECLARE
    v_has_auth VARCHAR2(1);
BEGIN
    SELECT NVL(MAX('Y'), 'N') INTO v_has_auth
      FROM SCM_ADM_USER_GR_MPG_M ug
      JOIN SCM_ADM_USER_GR_MNU_BTN_MPG_M b ON b.USER_GR_ID = ug.USER_GR_ID
     WHERE ug.USER_ID = 'minyonglee1'
       AND b.MNU_ID = 'DMF0020' AND b.SHT_NM = 'version' AND b.MNU_BTN_CD = 'SEARCH' AND b.USE_YN = 'Y';
    DBMS_OUTPUT.PUT_LINE('  HAS_AUTH_YN (DMF0020/version/SEARCH): '||v_has_auth||' (expect Y)');
END;
/
