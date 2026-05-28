/*=============================================================================================
 * File         : 05_DMF0020_Repair_Permissions_DBeaver.sql
 * Description  : DMF0020 권한 복구 [PART 2 of 3]
 *              :
 *              : DMF0007 (정상 형제) 의 그룹/버튼 권한을 DMF0020 에 복제한다.
 *              :   STEP A: SCM_ADM_USER_GR_MNU_MPG_M     — 메뉴 권한 (누락 그룹만 INSERT)
 *              :   STEP B: SCM_ADM_USER_GR_MNU_BTN_MPG_M — 버튼 권한 (DMF0020 의 SCM_ADM_MNU_BTN_MPG_M
 *              :                                            에 정의된 버튼만 대상으로 복제)
 *              :
 *              : 멱등성: 기존 행은 건드리지 않고 누락분만 추가. 반복 실행 가능.
 *              : COMMIT 포함.
 *
 * 실행 방법   : 본 파일 열기 → 전체 선택 (Ctrl+A) → Ctrl+Enter
 * 실행 계정   : SCM_MGR
 * 사전 조건   :
 *   • SCM_ADM_MNU_BTN_MPG_M 에 DMF0020 의 버튼 (SEARCH/SAVE 등) 등록 완료 (03_Registration BLOCK 6)
 *   • DMF0007 이 정상 권한 보유 (참조 기준)
 *
 * 다음 단계   : 05_DMF0020_Repair_Permissions_DBeaver_Verify.sql 실행 → 화면 재진입
 *===========================================================================================*/

DECLARE
    v_btn_define   NUMBER;
    v_menu_added   NUMBER;
    v_btn_added    NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('DMF0020 권한 복구 시작 (기준: DMF0007)');
    DBMS_OUTPUT.PUT_LINE('============================================================');

    -- 사전 점검: DMF0020 의 버튼 정의가 있는지
    SELECT COUNT(*) INTO v_btn_define
      FROM SCM_ADM_MNU_BTN_MPG_M
     WHERE MNU_ID = 'DMF0020';

    IF v_btn_define = 0 THEN
        DBMS_OUTPUT.PUT_LINE('FAIL: SCM_ADM_MNU_BTN_MPG_M 에 DMF0020 버튼 정의 0건');
        DBMS_OUTPUT.PUT_LINE('      → 03_DMF0020_Registration_DBeaver.sql 의 BLOCK 6 재실행 필요');
        RAISE_APPLICATION_ERROR(-20001, 'DMF0020 buttons not defined in SCM_ADM_MNU_BTN_MPG_M');
    END IF;
    DBMS_OUTPUT.PUT_LINE('사전점검 OK: DMF0020 버튼 정의 '||v_btn_define||' 건');

    -- ─── STEP A: 메뉴 권한 (USER_GR_MNU_MPG_M) ────────────────────────────────────────────
    INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M
                (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT D7.USER_GR_ID, 'DMF0020', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
      FROM SCM_ADM_USER_GR_MNU_MPG_M D7
     WHERE D7.MNU_ID = 'DMF0007'
       AND D7.USE_YN = 'Y'
       AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M D20
                        WHERE D20.MNU_ID = 'DMF0020'
                          AND D20.USER_GR_ID = D7.USER_GR_ID);
    v_menu_added := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('STEP A — SCM_ADM_USER_GR_MNU_MPG_M     : '||v_menu_added||' 그룹 추가');

    -- ─── STEP B: 버튼 권한 (USER_GR_MNU_BTN_MPG_M) ────────────────────────────────────────
    -- DMF0007 의 (group, button) 조합 × DMF0020 의 실제 버튼 정의
    INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M
                (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                 CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT DISTINCT
           UGB7.USER_GR_ID,
           'DMF0020',
           BTN20.SHT_NM,
           BTN20.MNU_BTN_CD,
           'Y',
           'admin', SYSDATE, 'admin', SYSDATE
      FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M UGB7
      JOIN SCM_ADM_MNU_BTN_MPG_M         BTN20
        ON BTN20.MNU_ID = 'DMF0020'
       AND BTN20.MNU_BTN_CD = UGB7.MNU_BTN_CD
     WHERE UGB7.MNU_ID = 'DMF0007'
       AND UGB7.USE_YN = 'Y'
       AND BTN20.USE_YN = 'Y'
       AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M E
                        WHERE E.USER_GR_ID = UGB7.USER_GR_ID
                          AND E.MNU_ID     = 'DMF0020'
                          AND E.SHT_NM     = BTN20.SHT_NM
                          AND E.MNU_BTN_CD = BTN20.MNU_BTN_CD);
    v_btn_added := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('STEP B — SCM_ADM_USER_GR_MNU_BTN_MPG_M : '||v_btn_added||' 행 추가');

    IF v_menu_added = 0 AND v_btn_added = 0 THEN
        DBMS_OUTPUT.PUT_LINE('변경 없음 — 이미 모든 권한이 등록되어 있음');
        ROLLBACK;
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('COMMIT 됨 — 총 '||(v_menu_added + v_btn_added)||' 행 추가');
    END IF;
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('다음 단계:');
    DBMS_OUTPUT.PUT_LINE('  1. 05_DMF0020_Repair_Permissions_DBeaver_Verify.sql 실행');
    DBMS_OUTPUT.PUT_LINE('  2. 브라우저 새로고침 (Shift+F5) 또는 로그아웃 후 재로그인');
    DBMS_OUTPUT.PUT_LINE('  3. DMF0020 메뉴 진입 → 화면 정상 로드 확인');
    DBMS_OUTPUT.PUT_LINE('============================================================');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('FAIL — ROLLBACK');
        DBMS_OUTPUT.PUT_LINE('SQLCODE: '||SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQLERRM: '||SQLERRM);
        RAISE;
END;
