/*=============================================================================================
 * File         : 05_DMF0020_Repair_Permissions.sql
 * Description  : DMF0020 권한 복구 (SQL*Plus 통합본)
 *              :
 *              : DMF0007 의 그룹/버튼 권한을 DMF0020 에 복제.
 *              : 본 파일 단일 실행으로 [진단 → 복구 → 검증] 3 단계 수행.
 *              :
 *              : DBeaver 사용자는 분할 파일 사용 권장:
 *              :   • 05_DMF0020_Repair_Permissions_DBeaver_Diagnose.sql
 *              :   • 05_DMF0020_Repair_Permissions_DBeaver.sql
 *              :   • 05_DMF0020_Repair_Permissions_DBeaver_Verify.sql
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-19
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DEFINE V_TARGET_MENU = 'DMF0020'
DEFINE V_REF_MENU    = 'DMF0007'
DEFINE V_USER_ID     = 'admin'

-- =============================================================================================
-- STEP 1: 진단
-- =============================================================================================
DECLARE
    v_ref_menu_grp   NUMBER;
    v_tgt_menu_grp   NUMBER;
    v_ref_btn_cnt    NUMBER;
    v_tgt_btn_cnt    NUMBER;
    v_btn_define     NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('STEP 1: 권한 진단');
    DBMS_OUTPUT.PUT_LINE('============================================================');

    SELECT COUNT(*) INTO v_ref_menu_grp
      FROM SCM_ADM_USER_GR_MNU_MPG_M
     WHERE MNU_ID = '&V_REF_MENU' AND USE_YN = 'Y';
    SELECT COUNT(*) INTO v_tgt_menu_grp
      FROM SCM_ADM_USER_GR_MNU_MPG_M
     WHERE MNU_ID = '&V_TARGET_MENU' AND USE_YN = 'Y';
    DBMS_OUTPUT.PUT_LINE('[1] 메뉴 권한 그룹 수: &V_REF_MENU='||v_ref_menu_grp
                         ||' / &V_TARGET_MENU='||v_tgt_menu_grp);

    SELECT COUNT(*) INTO v_ref_btn_cnt
      FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
     WHERE MNU_ID = '&V_REF_MENU' AND USE_YN = 'Y';
    SELECT COUNT(*) INTO v_tgt_btn_cnt
      FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
     WHERE MNU_ID = '&V_TARGET_MENU' AND USE_YN = 'Y';
    DBMS_OUTPUT.PUT_LINE('[2] 버튼 권한 행 수  : &V_REF_MENU='||v_ref_btn_cnt
                         ||' / &V_TARGET_MENU='||v_tgt_btn_cnt);

    SELECT COUNT(*) INTO v_btn_define
      FROM SCM_ADM_MNU_BTN_MPG_M
     WHERE MNU_ID = '&V_TARGET_MENU';
    DBMS_OUTPUT.PUT_LINE('[3] &V_TARGET_MENU 버튼 정의 : '||v_btn_define||' 건');

    IF v_btn_define = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    WARN: 03_DMF0020_Registration BLOCK 6 결과 0건 — 본 복구 불가');
    END IF;
    DBMS_OUTPUT.PUT_LINE('============================================================');
END;
/

-- =============================================================================================
-- STEP 2: 복구 (INSERT + COMMIT)
-- =============================================================================================
DECLARE
    v_btn_define   NUMBER;
    v_menu_added   NUMBER;
    v_btn_added    NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('STEP 2: 권한 복구 시작 (기준: &V_REF_MENU)');

    SELECT COUNT(*) INTO v_btn_define FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_TARGET_MENU';
    IF v_btn_define = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  ROLLBACK — 버튼 정의 0건. 03_Registration BLOCK 6 먼저 실행');
        ROLLBACK;
        RETURN;
    END IF;

    -- STEP A: 메뉴 권한
    INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M
                (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT D7.USER_GR_ID, '&V_TARGET_MENU', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
      FROM SCM_ADM_USER_GR_MNU_MPG_M D7
     WHERE D7.MNU_ID = '&V_REF_MENU'
       AND D7.USE_YN = 'Y'
       AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M D20
                        WHERE D20.MNU_ID = '&V_TARGET_MENU'
                          AND D20.USER_GR_ID = D7.USER_GR_ID);
    v_menu_added := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('  STEP A — USER_GR_MNU_MPG_M     : '||v_menu_added||' 그룹 추가');

    -- STEP B: 버튼 권한
    INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M
                (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                 CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT DISTINCT
           UGB7.USER_GR_ID, '&V_TARGET_MENU', BTN20.SHT_NM, BTN20.MNU_BTN_CD, 'Y',
           '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
      FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M UGB7
      JOIN SCM_ADM_MNU_BTN_MPG_M         BTN20
        ON BTN20.MNU_ID = '&V_TARGET_MENU'
       AND BTN20.MNU_BTN_CD = UGB7.MNU_BTN_CD
     WHERE UGB7.MNU_ID = '&V_REF_MENU'
       AND UGB7.USE_YN = 'Y'
       AND BTN20.USE_YN = 'Y'
       AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M E
                        WHERE E.USER_GR_ID = UGB7.USER_GR_ID
                          AND E.MNU_ID     = '&V_TARGET_MENU'
                          AND E.SHT_NM     = BTN20.SHT_NM
                          AND E.MNU_BTN_CD = BTN20.MNU_BTN_CD);
    v_btn_added := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('  STEP B — USER_GR_MNU_BTN_MPG_M : '||v_btn_added||' 행 추가');

    IF v_menu_added = 0 AND v_btn_added = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  변경 없음 — ROLLBACK');
        ROLLBACK;
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('  COMMIT 됨 — 총 '||(v_menu_added + v_btn_added)||' 행 추가');
    END IF;
    DBMS_OUTPUT.PUT_LINE('============================================================');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('  FAIL — ROLLBACK: '||SQLERRM);
        RAISE;
END;
/

-- =============================================================================================
-- STEP 3: 검증
-- =============================================================================================
PROMPT === 메뉴 권한 (USER_GR_MNU_MPG_M) ===
SELECT MNU_ID, USER_GR_ID, USE_YN, TO_CHAR(LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI') AS UPD
  FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID IN ('&V_REF_MENU', '&V_TARGET_MENU')
 ORDER BY MNU_ID, USER_GR_ID;

PROMPT
PROMPT === 버튼 권한 (USER_GR_MNU_BTN_MPG_M) ===
SELECT MNU_ID, USER_GR_ID, SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID IN ('&V_REF_MENU', '&V_TARGET_MENU')
 ORDER BY MNU_ID, USER_GR_ID, MNU_BTN_CD;

PROMPT
PROMPT === 완료 — 브라우저 새로고침 또는 재로그인 후 DMF0020 진입 확인 ===
