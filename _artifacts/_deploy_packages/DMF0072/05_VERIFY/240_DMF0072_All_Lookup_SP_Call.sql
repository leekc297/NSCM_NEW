--==============================================================================
-- 240_DMF0072_All_Lookup_SP_Call.sql
--
-- 목적:
--   메인 WRAPPER SP 는 정상 (-99). 화면 진입 시 5 lookup + 2 popup 동시 호출 중
--   하나 실패 의심.
--   각 lookup SP 단독 호출하여 진짜 ORA 캡쳐.
--
-- 또한 SCMD_APP 권한 (USER_GR_MNU_BTN_MPG_M / 테이블 권한) 확인.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 250

PROMPT === DIAG 1 : 각 lookup SP signature ===

SELECT object_name, argument_name, position, in_out
  FROM all_arguments
 WHERE owner = 'SCM_MGR'
   AND object_name IN (
     'DMF0072_GET_DATA_TYPE_LIST',
     'DMF0072_GET_TEAM_LIST',
     'DMF0072_GET_END_CUSTOMER_LIST',
     'DMF0072_GET_SALES_SITE_LIST',
     'DMF0072_GET_PROJECT_POPUP_LIST',
     'DMF0072_GET_ITEM_POPUP_LIST',
     'DMF0008_GET_MY_DIVISION_LIST'
   )
   AND package_name IS NULL
 ORDER BY object_name, position;

PROMPT === DIAG 2 : dataType 호출 ===
DECLARE
  v_rc1 SYS_REFCURSOR; v_cnt PLS_INTEGER := 0; v_d VARCHAR2(4000);
BEGIN
  DMF0072_GET_DATA_TYPE_LIST(o_rc1 => v_rc1);
  BEGIN LOOP FETCH v_rc1 INTO v_d; EXIT WHEN v_rc1%NOTFOUND OR v_cnt>=3; v_cnt:=v_cnt+1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt:=-99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_OUTPUT.PUT_LINE('dataType fetch = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('dataType ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
END;
/

PROMPT === DIAG 3 : division 호출 (공용 DMF0008) ===
-- DMF0008_GET_MY_DIVISION_LIST signature 가 알 수 없으므로 sig 결과로 분기 — 일단 가정
DECLARE
  v_rc1 SYS_REFCURSOR; v_cnt PLS_INTEGER := 0; v_d VARCHAR2(4000);
BEGIN
  EXECUTE IMMEDIATE 'BEGIN SCM_MGR.DMF0008_GET_MY_DIVISION_LIST(:1, :2, :3); END;'
    USING IN 'minyonglee1', IN 'DMF0072', OUT v_rc1;
  BEGIN LOOP FETCH v_rc1 INTO v_d; EXIT WHEN v_rc1%NOTFOUND OR v_cnt>=3; v_cnt:=v_cnt+1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt:=-99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_OUTPUT.PUT_LINE('division (3args sesUserId/mnuId/o_rc1) fetch = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('division (3args) ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
END;
/

PROMPT === DIAG 4 : team 호출 ===
DECLARE
  v_rc1 SYS_REFCURSOR; v_cnt PLS_INTEGER := 0; v_d VARCHAR2(4000);
BEGIN
  DMF0072_GET_TEAM_LIST(divisionId => '81', o_rc1 => v_rc1);
  BEGIN LOOP FETCH v_rc1 INTO v_d; EXIT WHEN v_rc1%NOTFOUND OR v_cnt>=3; v_cnt:=v_cnt+1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt:=-99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_OUTPUT.PUT_LINE('team fetch = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('team ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
END;
/

PROMPT === DIAG 5 : endCustomer 호출 ===
DECLARE
  v_rc1 SYS_REFCURSOR; v_cnt PLS_INTEGER := 0; v_d VARCHAR2(4000);
BEGIN
  DMF0072_GET_END_CUSTOMER_LIST(divisionId => '81', deptId => 'ALL', o_rc1 => v_rc1);
  BEGIN LOOP FETCH v_rc1 INTO v_d; EXIT WHEN v_rc1%NOTFOUND OR v_cnt>=3; v_cnt:=v_cnt+1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt:=-99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_OUTPUT.PUT_LINE('endCustomer fetch = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('endCustomer ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
END;
/

PROMPT === DIAG 6 : salesSite 호출 ===
DECLARE
  v_rc1 SYS_REFCURSOR; v_cnt PLS_INTEGER := 0; v_d VARCHAR2(4000);
BEGIN
  DMF0072_GET_SALES_SITE_LIST(divisionId => '81', endCustomer => 'ALL', o_rc1 => v_rc1);
  BEGIN LOOP FETCH v_rc1 INTO v_d; EXIT WHEN v_rc1%NOTFOUND OR v_cnt>=3; v_cnt:=v_cnt+1; END LOOP;
  EXCEPTION WHEN OTHERS THEN v_cnt:=-99; END;
  BEGIN CLOSE v_rc1; EXCEPTION WHEN OTHERS THEN NULL; END;
  DBMS_OUTPUT.PUT_LINE('salesSite fetch = ' || v_cnt);
EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('salesSite ERR ' || SQLCODE || ' / ' || SUBSTR(SQLERRM, 1, 300));
END;
/

PROMPT === DIAG 7 : minyonglee1 의 DMF0072 권한 (USER_GR_MNU_BTN_MPG_M) ===

SELECT u.user_id, u.user_group_id, mb.mnu_id, mb.sht_nm, mb.mnu_btn_cd, mb.api_id
  FROM SCM_MGR.SCM_ADM_USER_M u
  JOIN SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M mb ON mb.user_group_id = u.user_group_id
 WHERE u.user_id = 'minyonglee1'
   AND mb.mnu_id = 'DMF0072'
 ORDER BY mb.sht_nm, mb.mnu_btn_cd;

PROMPT === DIAG 8 : 메인 SP 의 사용 테이블 SCMD_APP 권한 ===

SELECT grantee, owner, table_name, LISTAGG(privilege, ',') WITHIN GROUP (ORDER BY privilege) AS privs
  FROM dba_tab_privs
 WHERE grantee = 'SCMD_APP'
   AND owner = 'SCM_MGR'
   AND table_name IN (
     'DM_CUST_MODEL_MAPPING_M',
     'SCM_MST_SITE',
     'SCM_MST_SITE_ITEM',
     'SCM_MST_SSO_USER_INFO',
     'SCM_MST_SSO_DEPT_INFO'
   )
 GROUP BY grantee, owner, table_name
 ORDER BY table_name;

PROMPT === 판독 ===
PROMPT - DIAG 1: lookup SP 인자 갯수 cross-check (PROC_M args 와 일치?)
PROMPT - DIAG 2~6: 각 lookup 단독 호출 — ERR 발견 시 진짜 SQLCODE 노출
PROMPT - DIAG 7: minyonglee1 가 DMF0072 의 어떤 SHT_NM/BTN 권한 있는지
PROMPT - DIAG 8: 메인 SP 본문이 사용하는 5 테이블 SCMD_APP SELECT 권한
