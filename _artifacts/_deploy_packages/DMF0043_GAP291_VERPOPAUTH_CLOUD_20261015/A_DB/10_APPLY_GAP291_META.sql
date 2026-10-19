-- SOURCE-FRESH: META SCM_ADM_MNU_BTN_MPG_M / SCM_ADM_USER_GR_MNU_BTN_MPG_M (MNU_ID='DMF0043', SHT_NM='version') FETCHED=2026-10-15 DB=ZIOUI1 (클라우드는 자기 행 기준 멱등 반영)
-- 10_APPLY — [GAP291 2026-10-15] DMF0043 기여율 버전관리 팝업 Insert/Delete/Save = ADMIN · DM ADMIN 만 (전체 F5, 값 입력 없음, 멱등)
-- AS-IS : POPUP/DMF0043_ContributeRatePopup.cs DefineProperty L111~123 — NowGroupID 가 ADMIN · DM ADMIN 이 아니면
--         Edit/Insert/Save/Delete 버튼 숨김
-- 내용  : [B] 적용 전 상태 백업 테이블 2개 (최초 1회만 생성 — 재실행 시 보존)
--         [1] SCM_ADM_MNU_BTN_MPG_M         DMF0043|version EDIT · INSERT · DELETE 추가 (API 없음, FE 표시 게이트)
--         [2] SCM_ADM_USER_GR_MNU_BTN_MPG_M 위 3종 = ADMIN · DM ADMIN 만
--         [3] version|SAVE 의 ADMIN · DM ADMIN 외 그룹 USE_YN='N' (서버 버튼권한 검사가 저장 API 차단, 물리 DELETE 없음)
-- 판정  : PKG_NSCM_UI_COM_AUTH — USER_ID 의 보유 그룹 전체 JOIN(합집합). 패키지·BE 무변경, BE 재기동 불필요.
-- FE    : ContributeVersionModal 버튼을 hasButton('EDIT') 등으로 감싸야 화면 표시가 바뀐다 (README 의 FE 가이드)
-- 실행 전 00_PRECHECK_CLOUD · 실행 뒤 90_VERIFY · 원복 = 99_ROLLBACK_GAP291_META
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_cnt  PLS_INTEGER;
    v_ins1 PLS_INTEGER := 0;
    v_ins2 PLS_INTEGER := 0;
    v_upd  PLS_INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM SCM_ADM_USER_GR_M WHERE USER_GR_ID IN ('ADMIN', 'DM ADMIN');
    IF v_cnt <> 2 THEN
        DBMS_OUTPUT.PUT_LINE('중단 — ADMIN / DM ADMIN 그룹 ' || v_cnt || '건 (기대 2). 변경 없음');
        RETURN;
    END IF;

    -- [B] 원복용 백업 (최초 1회)
    SELECT COUNT(*) INTO v_cnt FROM USER_TABLES WHERE TABLE_NAME = 'SCM_ADM_MNU_BTN_BAK_GAP291';
    IF v_cnt = 0 THEN
        BEGIN
            EXECUTE IMMEDIATE 'CREATE TABLE SCM_ADM_MNU_BTN_BAK_GAP291 AS SELECT * FROM SCM_ADM_MNU_BTN_MPG_M'
                           || ' WHERE MNU_ID = ''DMF0043'' AND SHT_NM = ''version''';
            EXECUTE IMMEDIATE 'CREATE TABLE SCM_ADM_GR_BTN_BAK_GAP291 AS SELECT * FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M'
                           || ' WHERE MNU_ID = ''DMF0043'' AND SHT_NM = ''version''';
            DBMS_OUTPUT.PUT_LINE('BACKUP — SCM_ADM_MNU_BTN_BAK_GAP291 / SCM_ADM_GR_BTN_BAK_GAP291 생성');
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('중단 — 백업 생성 실패: ' || SQLERRM || '. 변경 없음');
            RETURN;
        END;
    ELSE
        DBMS_OUTPUT.PUT_LINE('BACKUP — 기존 백업 보존(최초 적용 전 상태)');
    END IF;

    -- [1] 메뉴 버튼 마스터
    INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT 'DMF0043', 'version', t.BTN_CD, NULL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
      FROM (SELECT 'EDIT' AS BTN_CD FROM DUAL UNION ALL
            SELECT 'INSERT'          FROM DUAL UNION ALL
            SELECT 'DELETE'          FROM DUAL) t
     WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M b
                        WHERE b.MNU_ID = 'DMF0043' AND b.SHT_NM = 'version' AND b.MNU_BTN_CD = t.BTN_CD);
    v_ins1 := SQL%ROWCOUNT;

    -- [2] 그룹 × 버튼 — ADMIN / DM ADMIN 만
    INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                               CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT g.GR_ID, 'DMF0043', 'version', b.BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
      FROM (SELECT 'ADMIN' AS GR_ID FROM DUAL UNION ALL SELECT 'DM ADMIN' FROM DUAL) g
     CROSS JOIN (SELECT 'EDIT' AS BTN_CD FROM DUAL UNION ALL
                 SELECT 'INSERT'          FROM DUAL UNION ALL
                 SELECT 'DELETE'          FROM DUAL) b
     WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M u
                        WHERE u.USER_GR_ID = g.GR_ID AND u.MNU_ID = 'DMF0043'
                          AND u.SHT_NM = 'version' AND u.MNU_BTN_CD = b.BTN_CD);
    v_ins2 := SQL%ROWCOUNT;

    -- [3] version|SAVE — ADMIN · DM ADMIN 외 회수
    UPDATE SCM_ADM_USER_GR_MNU_BTN_MPG_M
       SET USE_YN = 'N', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
     WHERE MNU_ID = 'DMF0043' AND SHT_NM = 'version' AND MNU_BTN_CD = 'SAVE'
       AND USER_GR_ID NOT IN ('ADMIN', 'DM ADMIN')
       AND USE_YN = 'Y';
    v_upd := SQL%ROWCOUNT;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('APPLIED — MNU_BTN 추가 ' || v_ins1 || ' · GR_BTN 추가 ' || v_ins2
                         || ' · SAVE 회수 ' || v_upd || ' (재실행 시 0 · 0 · 0 = SKIP)');
EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('실패 — ' || SQLERRM || ' (롤백됨, 변경 없음)');
END;
/
