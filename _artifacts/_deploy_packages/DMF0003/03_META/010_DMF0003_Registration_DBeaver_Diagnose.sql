/*=============================================================================================
 * File         : 010_DMF0003_Registration_DBeaver_Diagnose.sql
 * Description  : DMF0003 라우팅 동작 진단 [PART 3 of 3]
 *              :
 *              : PR_GET_PROC_INFO_LIST(DMF0003, main, SEARCH) 호출 결과 출력.
 *              : 정상 등록 시 26 행 (22 IN + 4 OUT cursor) 라우팅되어야 함.
 *
 * 선행 파일   : 010_DMF0003_Registration_DBeaver.sql 실행 완료 후
 * 실행 방법   : 본 파일 열기 → 전체 선택 → Ctrl+Enter
 * 결과 확인   : Window → DBMS Output 뷰
 *
 * 사전 설정   : Window → Preferences → Database → Editors → Oracle → ✅ Enable DBMS_OUTPUT
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
    DBMS_OUTPUT.PUT_LINE('=== PR_GET_PROC_INFO_LIST(DMF0003, main, SEARCH) ===');

    SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(
        P_MNU_ID     => 'DMF0003',
        P_SHT_NM     => 'main',
        P_MNU_BTN_CD => 'SEARCH',
        O_CURSOR     => v_cur
    );

    LOOP
        FETCH v_cur INTO v_proc_nm, v_col_nm, v_data_tp, v_col_tp, v_sort_ord;
        EXIT WHEN v_cur%NOTFOUND;
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('  ['||v_cnt||'] '||v_proc_nm||' / '||v_col_nm||' / '||v_data_tp||' / '||v_col_tp||' / '||v_sort_ord);
    END LOOP;
    CLOSE v_cur;

    IF v_cnt = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  ❌ FAIL: 라우팅 0 행 — API_M / MNU_BTN_MPG_M / PROC_M 재확인 필요');
    ELSIF v_cnt < 26 THEN
        DBMS_OUTPUT.PUT_LINE('  ⚠ WARN: PROC_M 누락 ('||v_cnt||'/26) — BLOCK 2 재확인');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  ✅ OK: '||v_cnt||' 행 라우팅됨 (22 IN + 4 OUT = 26 예상)');
    END IF;

    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('다음 단계 (FE):');
    DBMS_OUTPUT.PUT_LINE('  1) Router.tsx + route-paths.ts + menu-ids.ts 에 DMF0003 등록');
    DBMS_OUTPUT.PUT_LINE('  2) FE 12 파일 (MktForecastMaster + store + Form + Grid + ...) 작성');
    DBMS_OUTPUT.PUT_LINE('  3) i18n KO/EN/CN.json 에 메뉴명 + API 메시지 추가');
    DBMS_OUTPUT.PUT_LINE('  4) start-all.ps1 → /master/demand-master/mkt-forecast-master 진입');
    DBMS_OUTPUT.PUT_LINE('  5) Find (F5) → grid 43 cols 표시 확인');
    DBMS_OUTPUT.PUT_LINE('============================================================');
END;
