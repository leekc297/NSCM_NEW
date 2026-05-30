-- ============================================================================================
-- File         : 02_seed_minyonglee1_Diagnose.sql
-- Description  : DBeaver Diagnose — 로그인 실패 시 진단.
-- Connection   : SCM_MGR @ FREEPDB1
-- ============================================================================================

-- 1) PR_GET_NSCM_USER 직접 호출 (BE 가 호출하는 것과 동일 흐름)
DECLARE
    v_cursor SYS_REFCURSOR;
    v_user_id      VARCHAR2(200);
    v_password     VARCHAR2(200);
    v_user_nm      VARCHAR2(600);
    v_user_eng_nm  VARCHAR2(600);
    v_lang_cd      VARCHAR2(40);
BEGIN
    PKG_NSCM_UI_COM_USER.PR_GET_NSCM_USER('minyonglee1', v_cursor);
    LOOP
        FETCH v_cursor INTO v_user_id, v_password, v_user_nm, v_user_eng_nm, v_lang_cd;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('USER_ID='||v_user_id||' NM='||v_user_nm||' EN='||v_user_eng_nm||' LANG='||v_lang_cd);
    END LOOP;
    CLOSE v_cursor;
END;

-- 2) minyonglee1 의 데이터 흐름 — 4단계 row 확인
SELECT 'SSO_USER_INFO' AS source, USER_ID, USER_NAME AS NAME FROM SCM_MST_SSO_USER_INFO WHERE USER_ID='minyonglee1'
UNION ALL
SELECT 'USER_M',      USER_ID, USER_NM      FROM SCM_ADM_USER_M       WHERE USER_ID='minyonglee1'
UNION ALL
SELECT 'GROUP_MAP',   USER_ID, USER_GR_ID   FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID='minyonglee1';

-- 3) PR_GET_NSCM_USER PKG body 의 line 60 SELECT 직접 실행 — 결과 row 없음 = 자동 INSERT trigger
SELECT U.USER_ID AS SSO_USER, UU.USER_ID AS USER_M, UU.USER_NM, UU.LANG_CD
  FROM SCM_MST_SSO_USER_INFO U
  LEFT JOIN SCM_ADM_USER_M UU ON UU.USER_ID = U.USER_ID
 WHERE U.USER_ID = 'minyonglee1';

-- 4) 로그인 후 메뉴 조회 — 메뉴 데이터가 없으면 빈 결과 (로그인은 성공)
SELECT COUNT(*) AS menu_master_count        FROM SCM_ADM_MNU_M;
SELECT COUNT(*) AS group_menu_mapping_count FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_GR_ID='GUEST';
