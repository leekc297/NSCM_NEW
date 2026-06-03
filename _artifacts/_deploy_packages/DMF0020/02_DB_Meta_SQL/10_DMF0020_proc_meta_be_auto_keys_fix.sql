/*=============================================================================================
 * File         : 10_DMF0020_proc_meta_be_auto_keys_fix.sql
 * Description  : PKG_DMF0020 PROC_M 메타 BE 자동 키 정합 fix
 *              : - userId   → sesUserId  (BE 자동 채움 키, 메모리 feedback_proc_meta_col_nm_be_auto_keys)
 *              : - menuId   → mnuId      (동일)
 *              : P_DMF0020_GET_FUTUREPRICE_INFO 만 영향 (P_USER_ID/P_MNU_ID IN 파라미터 2건).
 *              : P_DMF0000_SAVE_EXCHANGE_POPUP_DATA 는 createdBy/lastUpdatedBy 가 BE 자동 키 아님 → 그대로 유지.
 *              :
 *              : 멱등 (NOT EXISTS 패턴). 재실행 안전.
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-03
 * Refers       : Doc/_dev_rules/08_SCREEN_REGISTRATION.md §4.4 (자동 변환 SQL)
 *                memory/feedback_proc_meta_col_nm_be_auto_keys.md
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    v_before NUMBER;
    v_after  NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_before
    FROM SCM_ADM_PROC_M
    WHERE PROC_NM = 'PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO'
      AND COL_NM IN ('sesUserId', 'mnuId');

    -- userId → sesUserId
    UPDATE SCM_ADM_PROC_M
       SET COL_NM = 'sesUserId',
           LAST_UPDATED_BY = 'admin',
           LAST_UPDATE_DATE = SYSDATE
     WHERE PROC_NM = 'PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO'
       AND COL_NM  = 'userId'
       AND COL_TP_CD = 'IN';

    -- menuId → mnuId
    UPDATE SCM_ADM_PROC_M
       SET COL_NM = 'mnuId',
           LAST_UPDATED_BY = 'admin',
           LAST_UPDATE_DATE = SYSDATE
     WHERE PROC_NM = 'PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO'
       AND COL_NM  = 'menuId'
       AND COL_TP_CD = 'IN';

    COMMIT;

    SELECT COUNT(*) INTO v_after
    FROM SCM_ADM_PROC_M
    WHERE PROC_NM = 'PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO'
      AND COL_NM IN ('sesUserId', 'mnuId');

    DBMS_OUTPUT.PUT_LINE('PROC_M BE auto-keys: before='||v_before||' → after='||v_after||' (expect 2)');
END;
/

PROMPT === 검증: PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO 모든 파라미터 ===
SELECT COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD
  FROM SCM_ADM_PROC_M
 WHERE PROC_NM = 'PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO'
 ORDER BY SORT_ORD;

PROMPT === 검증: BE callProc 라우팅 (PR_GET_PROC_INFO_LIST) ===
DECLARE
    v_cur     SYS_REFCURSOR;
    v_proc_nm VARCHAR2(200); v_col_nm VARCHAR2(100);
    v_data_tp VARCHAR2(50);  v_col_tp VARCHAR2(50);
    v_sort_ord NUMBER;       v_cnt PLS_INTEGER := 0;
BEGIN
    SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(
        P_MNU_ID => 'DMF0020', P_SHT_NM => 'futurePrice', P_MNU_BTN_CD => 'SEARCH',
        O_CURSOR => v_cur
    );
    LOOP
        FETCH v_cur INTO v_proc_nm, v_col_nm, v_data_tp, v_col_tp, v_sort_ord;
        EXIT WHEN v_cur%NOTFOUND;
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('  ['||v_cnt||'] '||v_col_nm||' / '||v_data_tp||' / '||v_col_tp);
    END LOOP;
    CLOSE v_cur;
    IF v_cnt = 6 THEN
        DBMS_OUTPUT.PUT_LINE('  ✅ 6 행 (4 IN + 2 OUT) OK');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  ❌ '||v_cnt||' 행 — 예상 6');
    END IF;
END;
/
