-- =====================================================================
-- DMF0020 / 09_GTT_STATS / patch_B (이번 turn 핵심)
-- 목적: GT_FTPR_* GTT 14개 의 통계 정책을 SESSION 단위로 활성화
-- 효과: 옵티마이저가 실제 row count 기반 plan 선택 → DMF0020 elapsed 단축
-- 결과 정합: 100% 보장 (SP body 무변경, plan 정책만 변경)
-- 실행 계정: SCM_MGR
-- 실행 시간: ~30초 (1회만)
-- =====================================================================
BEGIN
    FOR R IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'GT_FTPR_%') LOOP
        BEGIN
            DBMS_STATS.SET_TABLE_PREFS(USER, R.TABLE_NAME, 'GLOBAL_TEMP_TABLE_STATS', 'SESSION');
            DBMS_OUTPUT.PUT_LINE('SET SESSION stats: ' || R.TABLE_NAME);
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('SKIP ' || R.TABLE_NAME || ': ' || SQLERRM);
        END;
    END LOOP;
END;
/
