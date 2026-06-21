-- =====================================================================
-- DMF0020 / 09_GTT_STATS / rollback
-- 사용: patch_B 적용 후 부정적 효과 발견 시
-- =====================================================================
BEGIN
    FOR R IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME LIKE 'GT_FTPR_%') LOOP
        BEGIN
            DBMS_STATS.SET_TABLE_PREFS(USER, R.TABLE_NAME, 'GLOBAL_TEMP_TABLE_STATS', 'SHARED');
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END LOOP;
END;
/
