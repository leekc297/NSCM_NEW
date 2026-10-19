-- 99_ROLLBACK — [GAP291 2026-10-15] 10_APPLY 이전 상태로 원복 (전체 F5, 값 입력 없음, 멱등)
-- 기준: 10_APPLY 가 최초 실행 때 만든 백업 테이블 SCM_ADM_MNU_BTN_BAK_GAP291 / SCM_ADM_GR_BTN_BAK_GAP291
--   - 백업에 없는 DMF0043|version 행(EDIT/INSERT/DELETE) 삭제 · 백업에 있는 행은 USE_YN 을 백업 값으로 복원
--   - 백업 테이블이 없으면 아무것도 바꾸지 않고 중단 · 백업 테이블은 남겨 둔다(재적용 시 원래 상태 보존)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_cnt PLS_INTEGER;
    v_d1  PLS_INTEGER := 0;
    v_d2  PLS_INTEGER := 0;
    v_u   PLS_INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM USER_TABLES
     WHERE TABLE_NAME IN ('SCM_ADM_MNU_BTN_BAK_GAP291', 'SCM_ADM_GR_BTN_BAK_GAP291');
    IF v_cnt <> 2 THEN
        DBMS_OUTPUT.PUT_LINE('중단 — 백업 테이블 ' || v_cnt || '개 (기대 2). 변경 없음');
        RETURN;
    END IF;

    EXECUTE IMMEDIATE
        'DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M u'
     || ' WHERE u.MNU_ID = ''DMF0043'' AND u.SHT_NM = ''version'''
     || '   AND u.MNU_BTN_CD IN (''EDIT'', ''INSERT'', ''DELETE'')'
     || '   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_GR_BTN_BAK_GAP291 k'
     || '                    WHERE k.USER_GR_ID = u.USER_GR_ID AND k.MNU_BTN_CD = u.MNU_BTN_CD)';
    v_d2 := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE
        'DELETE FROM SCM_ADM_MNU_BTN_MPG_M b'
     || ' WHERE b.MNU_ID = ''DMF0043'' AND b.SHT_NM = ''version'''
     || '   AND b.MNU_BTN_CD IN (''EDIT'', ''INSERT'', ''DELETE'')'
     || '   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_BAK_GAP291 k WHERE k.MNU_BTN_CD = b.MNU_BTN_CD)';
    v_d1 := SQL%ROWCOUNT;

    EXECUTE IMMEDIATE
        'UPDATE SCM_ADM_USER_GR_MNU_BTN_MPG_M u'
     || '   SET u.USE_YN = (SELECT k.USE_YN FROM SCM_ADM_GR_BTN_BAK_GAP291 k'
     || '                    WHERE k.USER_GR_ID = u.USER_GR_ID AND k.MNU_BTN_CD = u.MNU_BTN_CD),'
     || '       u.LAST_UPDATED_BY = ''admin'', u.LAST_UPDATE_DATE = SYSDATE'
     || ' WHERE u.MNU_ID = ''DMF0043'' AND u.SHT_NM = ''version'' AND u.MNU_BTN_CD = ''SAVE'''
     || '   AND EXISTS (SELECT 1 FROM SCM_ADM_GR_BTN_BAK_GAP291 k'
     || '                WHERE k.USER_GR_ID = u.USER_GR_ID AND k.MNU_BTN_CD = u.MNU_BTN_CD'
     || '                  AND k.USE_YN <> u.USE_YN)';
    v_u := SQL%ROWCOUNT;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — GR_BTN 삭제 ' || v_d2 || ' · MNU_BTN 삭제 ' || v_d1
                         || ' · SAVE 복원 ' || v_u || ' (재실행 시 0 · 0 · 0 = SKIP)');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('실패 — ' || SQLERRM || ' (롤백됨, 변경 없음)');
END;
/
