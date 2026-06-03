/*=============================================================================================
 * File         : 11_DMF0020_fix_uppr_menu_case.sql
 * Description  : DMF0020 메뉴 트리 단절 fix
 *              :
 *              : 사고: 2026-06-03 사용자 보고 — "메뉴가 보이지 않네요"
 *              : 원인: DMF0020 의 UPPR_MNU_ID = 'DEMAND_MASTER' (대문자, 미존재)
 *              :       정상 DMF 화면 7개의 부모 = 'Demand_Master' (대소문자 D+M).
 *              :       MNU_TP_CD = 'FN' vs 정상 'SCREEN' 도 불일치.
 *              :
 *              : 처방: UPPR_MNU_ID → 'Demand_Master', MNU_TP_CD → 'SCREEN'.
 *              :       부모 메뉴 (Demand_Master / Master) 는 이미 SCM_ADM_MNU_M 등록됨.
 *              :       ADMIN 그룹의 부모 메뉴 권한도 기본 시드에 포함 → 별도 권한 추가 불필요.
 *              :
 *              : 멱등 — UPDATE WHERE 조건으로 재실행 안전.
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-03
 * 참조 hook   : Doc/_dev_rules/hooks/menu-not-displayed-debug.md (5단계)
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    v_before_uppr  VARCHAR2(50);
    v_before_tp    VARCHAR2(20);
    v_after_uppr   VARCHAR2(50);
    v_after_tp     VARCHAR2(20);
    v_admin_perm   NUMBER;
BEGIN
    SELECT UPPR_MNU_ID, MNU_TP_CD INTO v_before_uppr, v_before_tp
      FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0020';
    DBMS_OUTPUT.PUT_LINE('=== BEFORE ===');
    DBMS_OUTPUT.PUT_LINE('  UPPR_MNU_ID = '||v_before_uppr||'   (정상값: Demand_Master)');
    DBMS_OUTPUT.PUT_LINE('  MNU_TP_CD   = '||v_before_tp||'   (정상값: SCREEN)');

    UPDATE SCM_ADM_MNU_M
       SET UPPR_MNU_ID      = 'Demand_Master',
           MNU_TP_CD        = 'SCREEN',
           LAST_UPDATED_BY  = 'admin',
           LAST_UPDATE_DATE = SYSDATE
     WHERE MNU_ID = 'DMF0020'
       AND (UPPR_MNU_ID <> 'Demand_Master' OR MNU_TP_CD <> 'SCREEN');

    DBMS_OUTPUT.PUT_LINE('  rows updated: '||SQL%ROWCOUNT);
    COMMIT;

    SELECT UPPR_MNU_ID, MNU_TP_CD INTO v_after_uppr, v_after_tp
      FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0020';
    DBMS_OUTPUT.PUT_LINE('=== AFTER ===');
    DBMS_OUTPUT.PUT_LINE('  UPPR_MNU_ID = '||v_after_uppr);
    DBMS_OUTPUT.PUT_LINE('  MNU_TP_CD   = '||v_after_tp);

    -- 부모 메뉴 권한 (Demand_Master / Master) — ADMIN 그룹 기본 시드 확인
    SELECT COUNT(*) INTO v_admin_perm
      FROM SCM_ADM_USER_GR_MNU_MPG_M
     WHERE USER_GR_ID = 'ADMIN' AND MNU_ID IN ('Master','Demand_Master') AND USE_YN = 'Y';
    DBMS_OUTPUT.PUT_LINE('=== ADMIN 그룹의 부모 메뉴 권한 행 수 (기대 2) ===');
    DBMS_OUTPUT.PUT_LINE('  count = '||v_admin_perm);

    IF v_admin_perm < 2 THEN
        DBMS_OUTPUT.PUT_LINE('  WARN: 부모 메뉴 권한 누락 → 추가 INSERT');
        INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN,
                                                CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT 'ADMIN', m.MNU_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
          FROM (SELECT 'Master' AS MNU_ID FROM DUAL UNION ALL SELECT 'Demand_Master' FROM DUAL) m
         WHERE NOT EXISTS (
             SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M x
              WHERE x.USER_GR_ID='ADMIN' AND x.MNU_ID = m.MNU_ID
         );
        DBMS_OUTPUT.PUT_LINE('  added: '||SQL%ROWCOUNT||' rows');
        COMMIT;
    END IF;
END;
/

PROMPT === 최종 검증: DMF0020 트리 walk-up ===
SELECT LEVEL AS LV, MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_URL, MNU_TP_CD, USE_YN
  FROM SCM_ADM_MNU_M
 START WITH MNU_ID = 'DMF0020'
 CONNECT BY PRIOR UPPR_MNU_ID = MNU_ID
 ORDER BY LEVEL DESC;

PROMPT === minyonglee1 의 DMF0020 + 부모 권한 ===
SELECT DISTINCT mp.MNU_ID, mp.USE_YN, ug.USER_GR_ID
  FROM SCM_ADM_USER_GR_MPG_M ug
  JOIN SCM_ADM_USER_GR_MNU_MPG_M mp ON mp.USER_GR_ID = ug.USER_GR_ID
 WHERE ug.USER_ID = 'minyonglee1'
   AND mp.MNU_ID IN ('DMF0020','Demand_Master','Master')
 ORDER BY mp.MNU_ID;
