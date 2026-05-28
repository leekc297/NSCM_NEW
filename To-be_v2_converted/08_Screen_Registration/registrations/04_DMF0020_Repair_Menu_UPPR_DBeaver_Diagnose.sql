/*=============================================================================================
 * File         : 04_DMF0020_Repair_Menu_UPPR_DBeaver_Diagnose.sql
 * Description  : DMF0020 메뉴 트리 진단 [PART 1 of 3]
 *              :
 *              : 03_DMF0020_Registration 실행 후 SYS0003 메뉴 UI 에서 DMF0020 이 사라진
 *              : 원인 추정 (BLOCK 4 MERGE 가 UPPR_MNU_ID 를 잘못된 값 'DEMAND_MASTER' 로
 *              : 덮어써서 트리가 끊김) 을 검증한다.
 *              :
 *              : 본 파일은 read-only — UPDATE 없음. 안전하게 반복 실행 가능.
 *
 * 실행 방법   :
 *   1. 본 파일 열기 → 전체 선택 (Ctrl+A) → Ctrl+Enter
 *   2. Window → DBMS Output 뷰에서 결과 확인
 *
 * 사전 설정   : Window → Preferences → Database → Editors → Oracle → Enable DBMS_OUTPUT
 * 실행 계정   : SCM_MGR
 *
 * 다음 단계   :
 *   • 진단 결과 'DEMAND_MASTER' 행 없음 또는 DMF0007 의 UPPR 과 다를 경우
 *     → 04_DMF0020_Repair_Menu_UPPR_DBeaver.sql 실행
 *===========================================================================================*/

DECLARE
    v_dmf0020_uppr   VARCHAR2(50);
    v_dmf0020_lv     NUMBER;
    v_dmf0020_tp     VARCHAR2(20);
    v_dmf0020_use    VARCHAR2(1);
    v_dmf0020_url    VARCHAR2(200);
    v_dmf0007_uppr   VARCHAR2(50);
    v_dmf0007_lv     NUMBER;
    v_dmf0007_tp     VARCHAR2(20);
    v_dmf0007_url    VARCHAR2(200);
    v_demand_master  NUMBER;
    v_dmf0020_count  NUMBER;
    v_parent_exists  NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('DMF0020 메뉴 트리 진단');
    DBMS_OUTPUT.PUT_LINE('============================================================');

    -- 1. DMF0020 존재 및 현재 상태
    SELECT COUNT(*) INTO v_dmf0020_count FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0020';
    DBMS_OUTPUT.PUT_LINE('[1] DMF0020 행 존재 여부: '||CASE WHEN v_dmf0020_count > 0 THEN 'YES' ELSE 'NO' END);

    IF v_dmf0020_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    FAIL: DMF0020 행이 존재하지 않음 — 03_DMF0020_Registration_DBeaver.sql 재실행 필요');
        RETURN;
    END IF;

    SELECT UPPR_MNU_ID, MNU_LV_NO, MNU_TP_CD, USE_YN, MNU_URL
      INTO v_dmf0020_uppr, v_dmf0020_lv, v_dmf0020_tp, v_dmf0020_use, v_dmf0020_url
      FROM SCM_ADM_MNU_M
     WHERE MNU_ID = 'DMF0020';

    DBMS_OUTPUT.PUT_LINE('    UPPR_MNU_ID = '||v_dmf0020_uppr);
    DBMS_OUTPUT.PUT_LINE('    MNU_LV_NO   = '||v_dmf0020_lv);
    DBMS_OUTPUT.PUT_LINE('    MNU_TP_CD   = '||v_dmf0020_tp);
    DBMS_OUTPUT.PUT_LINE('    USE_YN      = '||v_dmf0020_use);
    DBMS_OUTPUT.PUT_LINE('    MNU_URL     = '||v_dmf0020_url
                         ||CASE WHEN INSTR(v_dmf0020_url, '/') > 0 THEN '   <-- WARN: 디렉토리 prefix 포함 (slug 만 저장해야 함)' ELSE '' END);

    -- 2. 등록 SQL 이 설정한 부모 'DEMAND_MASTER' 가 실제 존재하는가
    SELECT COUNT(*) INTO v_demand_master FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DEMAND_MASTER';
    DBMS_OUTPUT.PUT_LINE('[2] DEMAND_MASTER (등록 SQL 추정 부모) 행 존재: '
                         ||CASE WHEN v_demand_master > 0 THEN 'YES' ELSE 'NO (트리 끊김)' END);

    -- 3. 형제 메뉴 DMF0007 의 정상 부모
    SELECT UPPR_MNU_ID, MNU_LV_NO, MNU_TP_CD, MNU_URL
      INTO v_dmf0007_uppr, v_dmf0007_lv, v_dmf0007_tp, v_dmf0007_url
      FROM SCM_ADM_MNU_M
     WHERE MNU_ID = 'DMF0007';

    DBMS_OUTPUT.PUT_LINE('[3] DMF0007 (정상 형제) 의 부모/URL:');
    DBMS_OUTPUT.PUT_LINE('    UPPR_MNU_ID = '||v_dmf0007_uppr);
    DBMS_OUTPUT.PUT_LINE('    MNU_LV_NO   = '||v_dmf0007_lv);
    DBMS_OUTPUT.PUT_LINE('    MNU_TP_CD   = '||v_dmf0007_tp);
    DBMS_OUTPUT.PUT_LINE('    MNU_URL     = '||v_dmf0007_url||'   (참고: leaf slug 만 저장됨)');

    -- 4. DMF0020 의 현재 부모가 실제 존재하는가
    SELECT COUNT(*) INTO v_parent_exists FROM SCM_ADM_MNU_M WHERE MNU_ID = v_dmf0020_uppr;
    DBMS_OUTPUT.PUT_LINE('[4] DMF0020 의 현재 부모 ('||v_dmf0020_uppr||') 실제 존재: '
                         ||CASE WHEN v_parent_exists > 0 THEN 'YES' ELSE 'NO (고아 노드)' END);

    -- 5. 결론
    DBMS_OUTPUT.PUT_LINE('============================================================');
    IF v_parent_exists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('진단 결과: 트리 끊김 — 부모 메뉴 부재로 SYS0003 UI 에서 사라짐');
        DBMS_OUTPUT.PUT_LINE('조치     : 04_DMF0020_Repair_Menu_UPPR_DBeaver.sql 실행');
        DBMS_OUTPUT.PUT_LINE('           (UPPR_MNU_ID + MNU_URL 동시 보정)');
    ELSIF v_dmf0020_uppr <> v_dmf0007_uppr THEN
        DBMS_OUTPUT.PUT_LINE('진단 결과: 부모는 존재하나 DMF0007 과 다른 트리 — 의도적 분리인지 확인');
        DBMS_OUTPUT.PUT_LINE('           (현재 ['||v_dmf0020_uppr||'] vs 형제 ['||v_dmf0007_uppr||'])');
    ELSIF v_dmf0020_use <> 'Y' THEN
        DBMS_OUTPUT.PUT_LINE('진단 결과: 부모는 정상이나 USE_YN <> Y — Repair 스크립트로 활성화');
    ELSIF INSTR(v_dmf0020_url, '/') > 0 THEN
        DBMS_OUTPUT.PUT_LINE('진단 결과: 트리는 정상이나 MNU_URL 에 디렉토리 prefix 포함');
        DBMS_OUTPUT.PUT_LINE('           (현재 ['||v_dmf0020_url||'] -> slug 만 저장해야 함)');
        DBMS_OUTPUT.PUT_LINE('조치     : 04_DMF0020_Repair_Menu_UPPR_DBeaver.sql 실행 (URL 도 함께 보정)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('진단 결과: 트리/URL 모두 정상 — 다른 원인 (캐시/세션/그룹권한) 가능성');
        DBMS_OUTPUT.PUT_LINE('           SYS0003 화면 새로고침 또는 BLOCK 7 (USER_GR_MNU) 재확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('============================================================');
END;
