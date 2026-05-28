/*=============================================================================================
 * File         : 06_DMF0020_User_Permission_Check.sql
 * Description  : 로그인 사용자 기준 DMF0020 화면 데이터/권한 진단 (SQL*Plus 통합본)
 *              :
 *              : 사용자 ID 는 DEFINE 으로 파라미터화 — 다른 계정으로 전환해 재실행 가능.
 *              : 7개 영역 진단 (DBeaver 단일 SELECT 본과 동일):
 *              :   1.USER / 2.GROUP / 3.MENU_PERM / 4.BTN_PERM / 5.EDIT_AUTH / 6.DATA / 7.JOIN_SIM
 *              :
 *              : 본 파일 read-only — UPDATE 없음.
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-19
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED
SET LINESIZE 200
SET PAGESIZE 100

DEFINE V_USER_ID = 'minyonglee1'
DEFINE V_MENU_ID = 'DMF0020'

PROMPT
PROMPT ============================================================
PROMPT 진단 대상 : USER_ID = &V_USER_ID  /  MNU_ID = &V_MENU_ID
PROMPT ============================================================
PROMPT

-- =============================================================================================
-- STEP 1: 통합 진단 (7 SECTION UNION ALL)
-- =============================================================================================
COLUMN SECTION FORMAT A12
COLUMN KEY     FORMAT A22
COLUMN VAL     FORMAT A35
COLUMN STATUS  FORMAT A22
COLUMN NOTE    FORMAT A60

SELECT '1.USER'        AS SECTION,
       U.USER_ID       AS KEY,
       U.USER_NM       AS VAL,
       CASE WHEN U.USE_YN <> 'Y'     THEN 'DISABLED'
            WHEN U.ACNT_LOK_YN = 'Y' THEN 'LOCKED'
            ELSE 'ACTIVE' END        AS STATUS,
       'DEPT='||NVL(U.DEPT_ID,'-')||' LANG='||NVL(U.LANG_CD,'-') AS NOTE
  FROM SCM_ADM_USER_M U
 WHERE U.USER_ID = '&V_USER_ID'
UNION ALL
SELECT '1.USER', '&V_USER_ID', '(not found)', 'MISSING',
       'SCM_ADM_USER_M 에 행 없음'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_M WHERE USER_ID = '&V_USER_ID')
UNION ALL
SELECT '2.GROUP', UGM.USER_GR_ID, NVL(GR.USER_GR_NM,'(no name)'),
       CASE WHEN UGM.USE_YN = 'Y' THEN 'OK' ELSE 'DISABLED' END,
       'USER_GR_MPG_M USE_YN='||UGM.USE_YN
  FROM SCM_ADM_USER_GR_MPG_M UGM
  LEFT JOIN SCM_ADM_USER_GR_M GR ON GR.USER_GR_ID = UGM.USER_GR_ID
 WHERE UGM.USER_ID = '&V_USER_ID'
UNION ALL
SELECT '2.GROUP', '(none)', '소속 그룹 없음', 'MISSING',
       'USER_GR_MPG_M 매핑 없음'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = '&V_USER_ID')
UNION ALL
SELECT '3.MENU_PERM', UGMNU.USER_GR_ID, '&V_MENU_ID',
       CASE WHEN UGMNU.USE_YN = 'Y' THEN 'OK' ELSE 'DISABLED' END,
       TO_CHAR(UGMNU.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI')
  FROM SCM_ADM_USER_GR_MNU_MPG_M UGMNU
 WHERE UGMNU.MNU_ID = '&V_MENU_ID'
   AND UGMNU.USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = '&V_USER_ID')
UNION ALL
SELECT '3.MENU_PERM', '(none)', '&V_MENU_ID 메뉴권한 없음', 'MISSING',
       '05_Repair_Permissions 실행 필요'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M
                    WHERE MNU_ID = '&V_MENU_ID'
                      AND USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = '&V_USER_ID'))
UNION ALL
SELECT '4.BTN_PERM', UGBTN.USER_GR_ID, UGBTN.SHT_NM||' / '||UGBTN.MNU_BTN_CD,
       CASE WHEN UGBTN.USE_YN = 'Y' THEN 'OK' ELSE 'DISABLED' END,
       TO_CHAR(UGBTN.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI')
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M UGBTN
 WHERE UGBTN.MNU_ID = '&V_MENU_ID'
   AND UGBTN.USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = '&V_USER_ID')
UNION ALL
SELECT '4.BTN_PERM', '(none)', '&V_MENU_ID 버튼권한 없음', 'MISSING',
       'No Permission 직접 원인'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
                    WHERE MNU_ID = '&V_MENU_ID'
                      AND USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = '&V_USER_ID'))
UNION ALL
SELECT '5.EDIT_AUTH', EA.UNIT_ID, 'Division (UNIT_TP_CD=D)',
       NVL(EA.EDIT_YN,'NULL'),
       'SP INNER JOIN 핵심'
  FROM SCM_ADM_USER_MNU_EDIT_AUTH_V EA
 WHERE EA.USER_ID = '&V_USER_ID'
   AND EA.MNU_ID  = '&V_MENU_ID'
   AND EA.UNIT_TP_CD = 'D'
UNION ALL
SELECT '5.EDIT_AUTH', '(none)', 'EDIT_AUTH_V 행 없음', 'MISSING',
       '★ 빈 결과/No Permission 가장 흔한 원인'
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                    WHERE USER_ID = '&V_USER_ID' AND MNU_ID = '&V_MENU_ID' AND UNIT_TP_CD = 'D')
UNION ALL
SELECT '6.DATA', 'DM_MST_EXCHANGE_RATE', 'rows='||TO_CHAR(COUNT(*)),
       CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'EMPTY' END,
       'min='||NVL(MIN(YYYYMMDD),'-')||' max='||NVL(MAX(YYYYMMDD),'-')
  FROM DM_MST_EXCHANGE_RATE
UNION ALL
SELECT '7.JOIN_SIM', '&V_USER_ID × &V_MENU_ID', 'visible rows = '||TO_CHAR(COUNT(*)),
       CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'EMPTY (No Permission)' END,
       'distinct DIV='||COUNT(DISTINCT T1.DIVISION_ID)
       ||' / '||NVL(MIN(T1.YYYYMMDD),'-')||'~'||NVL(MAX(T1.YYYYMMDD),'-')
  FROM DM_MST_EXCHANGE_RATE T1
  INNER JOIN (SELECT UNIT_ID FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
               WHERE USER_ID = '&V_USER_ID' AND MNU_ID = '&V_MENU_ID' AND UNIT_TP_CD = 'D') T2
    ON T1.DIVISION_ID = T2.UNIT_ID
 ORDER BY SECTION, KEY NULLS LAST, VAL;

PROMPT
PROMPT === STEP 2: SP 실제 호출 시뮬레이션 (P_START_YYYYMMDD~P_END_YYYYMMDD 범위로 조회) ===
PROMPT

VARIABLE V_RC1 REFCURSOR;
VARIABLE V_RESULT_CURSOR REFCURSOR;

BEGIN
    SCM_MGR.PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO(
        P_START_YYYYMMDD => TO_CHAR(SYSDATE - 30, 'YYYYMMDD'),
        P_END_YYYYMMDD   => TO_CHAR(SYSDATE,      'YYYYMMDD'),
        P_USER_ID        => '&V_USER_ID',
        P_MNU_ID         => '&V_MENU_ID',
        O_RC1            => :V_RC1,
        O_RESULT_CURSOR  => :V_RESULT_CURSOR
    );
    DBMS_OUTPUT.PUT_LINE('SP 호출 완료 — PRINT :V_RC1 로 결과 확인');
END;
/

PRINT V_RC1

PROMPT
PROMPT === 완료 ===
