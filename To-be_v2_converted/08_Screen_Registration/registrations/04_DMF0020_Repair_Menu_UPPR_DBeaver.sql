/*=============================================================================================
 * File         : 04_DMF0020_Repair_Menu_UPPR_DBeaver.sql
 * Description  : DMF0020 메뉴 트리 + URL 복구 [PART 2 of 3]
 *              :
 *              : 03_DMF0020_Registration 의 두 가지 오류를 동시 보정:
 *              :   (1) BLOCK 4 MERGE 가 UPPR_MNU_ID 를 'DEMAND_MASTER' (DB에 존재하지 않는 ID)
 *              :       로 덮어써서 트리 끊김 → DMF0007 의 부모/레벨/유형으로 복원
 *              :   (2) MNU_URL 에 전체 경로 '/master/demand-master/sales-future-price' 가
 *              :       저장되어 FE 라우터가 매칭 실패 → slug 'sales-future-price' 로 변경
 *              :       (FE 가 부모 메뉴 경로를 자동 조립하므로 leaf slug 만 저장)
 *              :
 *              : UPDATE 1행 + COMMIT.
 *              : 사전에 04_DMF0020_Repair_Menu_UPPR_DBeaver_Diagnose.sql 결과 확인 후 실행할 것.
 *
 * 실행 방법   : 본 파일 열기 → 전체 선택 (Ctrl+A) → Ctrl+Enter
 * 실행 계정   : SCM_MGR
 * 사전 조건   : SCM_ADM_MNU_M 에 DMF0020 행과 DMF0007 행이 모두 존재
 *
 * 다음 단계   : 04_DMF0020_Repair_Menu_UPPR_DBeaver_Verify.sql 실행 → SYS0003 화면 새로고침
 *===========================================================================================*/

DECLARE
    v_ref_uppr   VARCHAR2(50);
    v_ref_lv     NUMBER;
    v_ref_tp     VARCHAR2(20);
    v_new_url    CONSTANT VARCHAR2(200) := 'sales-future-price';
    v_updated    NUMBER;
BEGIN
    -- 기준 메뉴 (DMF0007) 의 부모/레벨/유형 조회
    SELECT UPPR_MNU_ID, MNU_LV_NO, MNU_TP_CD
      INTO v_ref_uppr, v_ref_lv, v_ref_tp
      FROM SCM_ADM_MNU_M
     WHERE MNU_ID = 'DMF0007';

    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('DMF0020 메뉴 트리 + URL 복구 시작');
    DBMS_OUTPUT.PUT_LINE('============================================================');
    DBMS_OUTPUT.PUT_LINE('기준 (DMF0007): UPPR='||v_ref_uppr||', LV='||v_ref_lv||', TP='||v_ref_tp);
    DBMS_OUTPUT.PUT_LINE('새 URL  (slug): '||v_new_url);

    -- DMF0020 보정 (부모/레벨/유형 + URL 동시)
    UPDATE SCM_ADM_MNU_M
       SET UPPR_MNU_ID      = v_ref_uppr,
           MNU_LV_NO        = v_ref_lv,
           MNU_TP_CD        = NVL(MNU_TP_CD, v_ref_tp),
           MNU_URL          = v_new_url,
           USE_YN           = 'Y',
           LAST_UPDATED_BY  = 'admin',
           LAST_UPDATE_DATE = SYSDATE
     WHERE MNU_ID = 'DMF0020';

    v_updated := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('DMF0020 UPDATE: '||v_updated||' 행');

    IF v_updated = 0 THEN
        DBMS_OUTPUT.PUT_LINE('WARN: DMF0020 행 없음 — 03_DMF0020_Registration_DBeaver.sql 재실행 필요');
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('ROLLBACK 됨');
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('COMMIT 됨 (UPPR='||v_ref_uppr||', LV='||v_ref_lv||', URL='||v_new_url||')');
        DBMS_OUTPUT.PUT_LINE('============================================================');
        DBMS_OUTPUT.PUT_LINE('복구 완료 — 다음 단계:');
        DBMS_OUTPUT.PUT_LINE('  1. 04_DMF0020_Repair_Menu_UPPR_DBeaver_Verify.sql 실행');
        DBMS_OUTPUT.PUT_LINE('  2. SYS0003 메뉴 UI 새로고침 → DMF0020 표시 + 클릭 시 화면 정상 로드 확인');
        DBMS_OUTPUT.PUT_LINE('============================================================');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('FAIL: DMF0007 (기준 메뉴) 행이 존재하지 않음 — 기준 변경 필요');
        DBMS_OUTPUT.PUT_LINE('       조치: 본 스크립트의 DMF0007 부분을 다른 정상 형제 메뉴 ID 로 수정');
        RAISE;
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('FAIL — ROLLBACK');
        DBMS_OUTPUT.PUT_LINE('SQLCODE: '||SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQLERRM: '||SQLERRM);
        RAISE;
END;
