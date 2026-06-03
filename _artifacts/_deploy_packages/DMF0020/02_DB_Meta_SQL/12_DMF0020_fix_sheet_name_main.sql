/*=============================================================================================
 * File         : 12_DMF0020_fix_sheet_name_main.sql
 * Description  : DMF0020 SHT_NM / SHEET_NAME 통일 — 'futurePrice' → 'main'
 *              :
 *              : 사고: 2026-06-03 사용자 보고 — "화면 오픈 시 sql error 발생"
 *              : 원인: BE 로그 ORA-01403 at PKG_NSCM_UI_COMM line 17 (retrieveBtnInfoList).
 *              :       FE 가 shtNm='main' 으로 호출 vs DB 메타가 SHT_NM='futurePrice' 등록.
 *              :       자매 화면 DMF0072 표준은 'main' — DMF0020 만 'futurePrice' 단독 사용.
 *              :
 *              : 처방: SCM_ADM_MNU_BTN_MPG_M 의 SHT_NM 'futurePrice' → 'main' UPDATE.
 *              :       SCM_MST_SHEET_COLUMNS 의 SHEET_NAME 도 함께 UPDATE.
 *              :
 *              : 멱등 — WHERE 조건으로 재실행 안전.
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-03
 * 참조        : 자매 화면 DMF0072 SHT_NM='main' 표준
 *               BE 로그 ORA-01403 at PKG_NSCM_UI_COMM:17 (retrieveBtnInfoList)
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    v_btn_before     NUMBER;
    v_btn_after      NUMBER;
    v_col_before     NUMBER;
    v_col_after      NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_btn_before
      FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0020' AND SHT_NM = 'futurePrice';
    SELECT COUNT(*) INTO v_col_before
      FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'futurePrice';
    DBMS_OUTPUT.PUT_LINE('=== BEFORE ===');
    DBMS_OUTPUT.PUT_LINE('  MNU_BTN_MPG futurePrice: '||v_btn_before);
    DBMS_OUTPUT.PUT_LINE('  SHEET_COLUMNS futurePrice: '||v_col_before);

    UPDATE SCM_ADM_MNU_BTN_MPG_M
       SET SHT_NM           = 'main',
           LAST_UPDATED_BY  = 'admin',
           LAST_UPDATE_DATE = SYSDATE
     WHERE MNU_ID = 'DMF0020' AND SHT_NM = 'futurePrice';
    DBMS_OUTPUT.PUT_LINE('  MNU_BTN_MPG updated: '||SQL%ROWCOUNT);

    UPDATE SCM_MST_SHEET_COLUMNS
       SET SHEET_NAME       = 'main',
           LAST_UPDATED_BY  = 'admin',
           LAST_UPDATE_DATE = SYSDATE
     WHERE PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'futurePrice';
    DBMS_OUTPUT.PUT_LINE('  SHEET_COLUMNS updated: '||SQL%ROWCOUNT);

    COMMIT;

    SELECT COUNT(*) INTO v_btn_after
      FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0020' AND SHT_NM = 'main';
    SELECT COUNT(*) INTO v_col_after
      FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = 'DMF0020' AND SHEET_NAME = 'main';
    DBMS_OUTPUT.PUT_LINE('=== AFTER ===');
    DBMS_OUTPUT.PUT_LINE('  MNU_BTN_MPG main: '||v_btn_after||' (expect 2 — SEARCH + SAVE)');
    DBMS_OUTPUT.PUT_LINE('  SHEET_COLUMNS main: '||v_col_after||' (expect 7)');
END;
/

PROMPT === 최종 검증: BE retrieveBtnInfoList 라우팅 ===
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID
  FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0020' ORDER BY SHT_NM, MNU_BTN_CD;

PROMPT === PR_GET_PROC_INFO_LIST(DMF0020, main, SEARCH) 검증 ===
DECLARE
    v_cur     SYS_REFCURSOR;
    v_proc_nm VARCHAR2(200); v_col_nm VARCHAR2(100);
    v_data_tp VARCHAR2(50);  v_col_tp VARCHAR2(50);
    v_sort_ord NUMBER;       v_cnt PLS_INTEGER := 0;
BEGIN
    SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(
        P_MNU_ID => 'DMF0020', P_SHT_NM => 'main', P_MNU_BTN_CD => 'SEARCH',
        O_CURSOR => v_cur
    );
    LOOP
        FETCH v_cur INTO v_proc_nm, v_col_nm, v_data_tp, v_col_tp, v_sort_ord;
        EXIT WHEN v_cur%NOTFOUND;
        v_cnt := v_cnt + 1;
        DBMS_OUTPUT.PUT_LINE('  ['||v_cnt||'] '||v_col_nm||' / '||v_data_tp||' / '||v_col_tp);
    END LOOP;
    CLOSE v_cur;
    IF v_cnt = 6 THEN DBMS_OUTPUT.PUT_LINE('  ✅ 6 행 (4 IN + 2 OUT) OK');
    ELSE DBMS_OUTPUT.PUT_LINE('  ❌ '||v_cnt||' 행 — 예상 6'); END IF;
END;
/
