/*=============================================================================================
 * File         : 04_DMF0020_Repair_Menu_UPPR.sql
 * Description  : DMF0020 메뉴 트리 복구 (SQL*Plus 통합본)
 *              :
 *              : 03_DMF0020_Registration BLOCK 4 MERGE 가 UPPR_MNU_ID 를
 *              : 잘못된 'DEMAND_MASTER' 로 덮어쓰는 바람에 SYS0003 메뉴 UI 에서
 *              : DMF0020 이 사라진 현상을 진단 + 복구 + 검증한다.
 *              :
 *              : 본 파일은 단일 실행으로 [진단 → 복구 → 검증] 3 단계를 모두 수행.
 *              : DBeaver 사용자는 각 PART 별 분할 파일 사용 권장:
 *              :   • 04_DMF0020_Repair_Menu_UPPR_DBeaver_Diagnose.sql
 *              :   • 04_DMF0020_Repair_Menu_UPPR_DBeaver.sql
 *              :   • 04_DMF0020_Repair_Menu_UPPR_DBeaver_Verify.sql
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
DEFINE V_NEW_URL     = 'sales-future-price'

-- =============================================================================================
-- STEP 1: 진단
-- =============================================================================================
DECLARE
    v_target_uppr   VARCHAR2(50);
    v_target_lv     NUMBER;
    v_target_tp     VARCHAR2(20);
    v_target_use    VARCHAR2(1);
    v_target_url    VARCHAR2(200);
    v_target_count  NUMBER;
    v_ref_uppr      VARCHAR2(50);
    v_ref_lv        NUMBER;
    v_ref_tp        VARCHAR2(20);
    v_ref_url       VARCHAR2(200);
    v_demand_master NUMBER;
    v_parent_exists NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('STEP 1: DMF0020 메뉴 트리 진단');
    DBMS_OUTPUT.PUT_LINE('============================================================');

    SELECT COUNT(*) INTO v_target_count FROM SCM_ADM_MNU_M WHERE MNU_ID = '&V_TARGET_MENU';
    DBMS_OUTPUT.PUT_LINE('[1] &V_TARGET_MENU 행 존재: '
                         ||CASE WHEN v_target_count > 0 THEN 'YES' ELSE 'NO' END);

    IF v_target_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    FAIL: 행이 없어 복구 불가 — 03_DMF0020_Registration.sql 재실행 필요');
        RETURN;
    END IF;

    SELECT UPPR_MNU_ID, MNU_LV_NO, MNU_TP_CD, USE_YN, MNU_URL
      INTO v_target_uppr, v_target_lv, v_target_tp, v_target_use, v_target_url
      FROM SCM_ADM_MNU_M
     WHERE MNU_ID = '&V_TARGET_MENU';

    DBMS_OUTPUT.PUT_LINE('    UPPR_MNU_ID = '||v_target_uppr);
    DBMS_OUTPUT.PUT_LINE('    MNU_LV_NO   = '||v_target_lv);
    DBMS_OUTPUT.PUT_LINE('    MNU_TP_CD   = '||v_target_tp);
    DBMS_OUTPUT.PUT_LINE('    USE_YN      = '||v_target_use);
    DBMS_OUTPUT.PUT_LINE('    MNU_URL     = '||v_target_url
                         ||CASE WHEN INSTR(v_target_url, '/') > 0 THEN '   <-- WARN: 디렉토리 prefix' ELSE '' END);

    SELECT COUNT(*) INTO v_demand_master FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DEMAND_MASTER';
    DBMS_OUTPUT.PUT_LINE('[2] DEMAND_MASTER 행 존재: '
                         ||CASE WHEN v_demand_master > 0 THEN 'YES' ELSE 'NO (트리 끊김 원인)' END);

    SELECT UPPR_MNU_ID, MNU_LV_NO, MNU_TP_CD, MNU_URL
      INTO v_ref_uppr, v_ref_lv, v_ref_tp, v_ref_url
      FROM SCM_ADM_MNU_M
     WHERE MNU_ID = '&V_REF_MENU';

    DBMS_OUTPUT.PUT_LINE('[3] &V_REF_MENU (기준) 의 부모/URL:');
    DBMS_OUTPUT.PUT_LINE('    UPPR_MNU_ID = '||v_ref_uppr);
    DBMS_OUTPUT.PUT_LINE('    MNU_LV_NO   = '||v_ref_lv);
    DBMS_OUTPUT.PUT_LINE('    MNU_TP_CD   = '||v_ref_tp);
    DBMS_OUTPUT.PUT_LINE('    MNU_URL     = '||v_ref_url||'   (slug only)');

    SELECT COUNT(*) INTO v_parent_exists FROM SCM_ADM_MNU_M WHERE MNU_ID = v_target_uppr;
    DBMS_OUTPUT.PUT_LINE('[4] &V_TARGET_MENU 의 현재 부모 ('||v_target_uppr||') 실제 존재: '
                         ||CASE WHEN v_parent_exists > 0 THEN 'YES' ELSE 'NO (고아 노드)' END);
    DBMS_OUTPUT.PUT_LINE('============================================================');
END;
/

-- =============================================================================================
-- STEP 2: 복구 (UPDATE + COMMIT)
-- =============================================================================================
DECLARE
    v_ref_uppr  VARCHAR2(50);
    v_ref_lv    NUMBER;
    v_ref_tp    VARCHAR2(20);
    v_updated   NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('STEP 2: 복구 시작');

    SELECT UPPR_MNU_ID, MNU_LV_NO, MNU_TP_CD
      INTO v_ref_uppr, v_ref_lv, v_ref_tp
      FROM SCM_ADM_MNU_M
     WHERE MNU_ID = '&V_REF_MENU';

    UPDATE SCM_ADM_MNU_M
       SET UPPR_MNU_ID      = v_ref_uppr,
           MNU_LV_NO        = v_ref_lv,
           MNU_TP_CD        = NVL(MNU_TP_CD, v_ref_tp),
           MNU_URL          = '&V_NEW_URL',
           USE_YN           = 'Y',
           LAST_UPDATED_BY  = '&V_USER_ID',
           LAST_UPDATE_DATE = SYSDATE
     WHERE MNU_ID = '&V_TARGET_MENU';

    v_updated := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('  &V_TARGET_MENU UPDATE: '||v_updated||' 행');

    IF v_updated = 0 THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('  ROLLBACK — 대상 행 없음');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('  COMMIT 됨 (UPPR='||v_ref_uppr||', LV='||v_ref_lv||', URL=&V_NEW_URL)');
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
SELECT M.MNU_ID,
       M.UPPR_MNU_ID,
       M.MNU_LV_NO,
       M.MNU_MSG_ID,
       M.MNU_URL,
       M.MNU_TP_CD,
       M.USE_YN,
       CASE WHEN P.MNU_ID IS NULL THEN 'NO (FAIL)' ELSE 'YES (OK)' END AS PARENT_EXISTS
  FROM SCM_ADM_MNU_M M
  LEFT JOIN SCM_ADM_MNU_M P ON P.MNU_ID = M.UPPR_MNU_ID
 WHERE M.MNU_ID IN ('&V_REF_MENU', '&V_TARGET_MENU')
 ORDER BY M.MNU_ID;

PROMPT
PROMPT === 부모 체인 (DMF0020 → root) ===
SELECT LEVEL AS DEPTH, MNU_ID, UPPR_MNU_ID, MNU_LV_NO, USE_YN
  FROM SCM_ADM_MNU_M
 START WITH MNU_ID = '&V_TARGET_MENU'
 CONNECT BY PRIOR UPPR_MNU_ID = MNU_ID
 ORDER BY LEVEL;

PROMPT
PROMPT === 완료 — SYS0003 화면 새로고침 후 DMF0020 노출 확인 ===
