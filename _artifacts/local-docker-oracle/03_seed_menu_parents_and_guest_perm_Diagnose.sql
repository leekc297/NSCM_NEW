-- ============================================================================================
-- File         : 03_seed_menu_parents_and_guest_perm_Diagnose.sql
-- Description  : DBeaver Diagnose — 메뉴 표시 실패 시 진단.
-- Connection   : SCM_MGR @ FREEPDB1
-- ============================================================================================

-- 1) PR_GET_MENU_LIST(minyonglee1) — BE 가 호출하는 것과 동일
DECLARE
    v_cur SYS_REFCURSOR;
    v_mnu VARCHAR2(50); v_uppr VARCHAR2(50); v_url VARCHAR2(200);
    v_msg VARCHAR2(100); v_desc VARCHAR2(500); v_sort NUMBER; v_bmk VARCHAR2(4);
BEGIN
    PKG_NSCM_UI_COM_MENU.PR_GET_MENU_LIST(P_USER_ID => 'minyonglee1', DATA => v_cur);
    LOOP
        FETCH v_cur INTO v_mnu, v_uppr, v_url, v_msg, v_desc, v_sort, v_bmk;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(RPAD(v_mnu, 20)||' upper='||RPAD(NVL(v_uppr,'NULL'),16)||' bmk=['||NVL(v_bmk,'NULL')||']');
    END LOOP;
    CLOSE v_cur;
END;

-- 2) 메뉴 트리 (부모 → 자식)
SELECT MNU_LV_NO, LPAD(' ', (MNU_LV_NO-1)*4) || MNU_ID AS tree, UPPR_MNU_ID, MNU_TP_CD, MNU_URL
  FROM SCM_ADM_MNU_M ORDER BY MNU_LV_NO, SORT_ORD;

-- 3) GUEST 그룹 의 메뉴 권한
SELECT USER_GR_ID, MNU_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE USER_GR_ID = 'GUEST' ORDER BY MNU_ID;

-- 4) minyonglee1 → GUEST 그룹 매핑 (PR_GET_NSCM_USER 가 자동 생성)
SELECT USER_ID, USER_GR_ID, USE_YN FROM SCM_ADM_USER_GR_MPG_M
 WHERE USER_ID = 'minyonglee1';

-- 5) BMK_YN 컬럼 값 확인 (NULL 이면 BE MenuDto.of NPE — PKG 수정 필요)
-- 기대: 'Y' 또는 'N' (NULL/empty 아님)
DECLARE
    v_cur SYS_REFCURSOR;
    v_mnu VARCHAR2(50); v_uppr VARCHAR2(50); v_url VARCHAR2(200);
    v_msg VARCHAR2(100); v_desc VARCHAR2(500); v_sort NUMBER; v_bmk VARCHAR2(4);
BEGIN
    PKG_NSCM_UI_COM_MENU.PR_GET_MENU_LIST(P_USER_ID => 'minyonglee1', DATA => v_cur);
    FETCH v_cur INTO v_mnu, v_uppr, v_url, v_msg, v_desc, v_sort, v_bmk;
    IF v_bmk IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('!!! BMK_YN IS NULL — fix PKG NVL2(..., Y, '''') to NVL2(..., Y, N)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('OK BMK_YN = '||v_bmk);
    END IF;
    CLOSE v_cur;
END;
