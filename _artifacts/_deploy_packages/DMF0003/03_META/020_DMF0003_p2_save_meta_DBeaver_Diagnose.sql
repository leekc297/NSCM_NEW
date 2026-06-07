/*=============================================================================================
 * File         : 020_DMF0003_p2_save_meta_DBeaver_Diagnose.sql
 * Description  : DMF0003 Phase 2 SAVE 라우팅 진단 [PART 3 of 3]
 *              :   PR_GET_PROC_INFO_LIST(DMF0003, main, SAVE) 호출 결과 출력 (기대 17 row)
 *===========================================================================================*/

DECLARE
    v_cur      SYS_REFCURSOR;
    v_proc_nm  VARCHAR2(200);
    v_col_nm   VARCHAR2(100);
    v_data_tp  VARCHAR2(50);
    v_col_tp   VARCHAR2(50);
    v_sort_ord NUMBER;
    v_cnt      PLS_INTEGER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== PR_GET_PROC_INFO_LIST(DMF0003, main, SAVE) ===');

    SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(
        P_MNU_ID     => 'DMF0003',
        P_SHT_NM     => 'main',
        P_MNU_BTN_CD => 'SAVE',
        O_CURSOR     => v_cur
    );

    LOOP
        FETCH v_cur INTO v_proc_nm, v_col_nm, v_data_tp, v_col_tp, v_sort_ord;
        EXIT WHEN v_cur%NOTFOUND;
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('  ['||v_cnt||'] '||v_proc_nm||' / '||v_col_nm||' / '||v_data_tp||' / '||v_col_tp);
    END LOOP;
    CLOSE v_cur;

    IF v_cnt = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  ❌ FAIL: SAVE 라우팅 0 행');
    ELSIF v_cnt < 17 THEN
        DBMS_OUTPUT.PUT_LINE('  ⚠ WARN: PROC_M 누락 ('||v_cnt||'/17)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  ✅ OK: '||v_cnt||' 행 (15 IN + 2 OUT = 17)');
    END IF;
END;
