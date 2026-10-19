-- 10_APPLY — [GAP467 2026-10-15] SYS0014 그룹 원장 누락 그룹 4건 + 해당 그룹 사용자 매핑 이관 (전체 F5, 값 입력 없음, 멱등)
-- 근거: GAP 467 AS-IS 수치의 원천 = TO-BE 이관 사본 TB_FX_GROUPINFO / TB_FX_USERGROUPINFO (Guest 2,346 · CAPA Planner 220 · System Monitor 1 · '-' 34)
--   [A] 그룹 원장 SCM_ADM_USER_GR_M — 없는 그룹만 추가 (기존 행 무변경, 대소문자 무시 동명 있으면 건너뜀)
--       CAPA Planner   Y  (이관 사본 TB_FX_GROUPINFO 값)
--       System Monitor Y
--       SSP ADMIN      N
--       '-'            사본 사용자 매핑의 그룹 아이디 원래 값 '-' 유지(사용자 결정). 이름 '-' · 사용여부는 원천 값이 없어 초기값 '/'
--   [B] 사용자-그룹 매핑 SCM_ADM_USER_GR_MPG_M — CAPA Planner · System Monitor · '-' 의 사본 행을 기존 이관과 같게 1:1(감사컬럼 포함) 이관.
--       PK(USER_GR_ID, USER_ID) 없는 행만 INSERT · 추가 키는 ZZ_GAP467_MPG_ADDED 에 기록(원복은 기록분만)
--       NULL 값 초기값은 '/' (문자) · SYSDATE (일자)
-- 제외(사용자 결정): Guest — TO-BE 표준 대문자 GUEST 유지(사본 Guest 매핑은 이미 GUEST 로 이관됨).
-- 사본 TB_FX_USERGROUPINFO 가 없는 DB 에서는 [B] 를 SKIP 하고 메시지만 낸다(오류 없음).
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
SET LINESIZE 200 PAGESIZE 100
-- [A] 그룹 원장
MERGE INTO SCM_ADM_USER_GR_M T
USING (
    SELECT 'CAPA Planner'   AS USER_GR_ID, 'CAPA Planner'   AS USER_GR_NM, 'Y' AS USE_YN FROM DUAL UNION ALL
    SELECT 'System Monitor',                'System Monitor',                'Y'           FROM DUAL UNION ALL
    SELECT 'SSP ADMIN',                     'SSP ADMIN',                     'N'           FROM DUAL UNION ALL
    SELECT '-',                             '-',                             '/'           FROM DUAL
) S
ON (T.USER_GR_ID = S.USER_GR_ID)
WHEN NOT MATCHED THEN
    INSERT (USER_GR_ID, USER_GR_NM, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES (S.USER_GR_ID, S.USER_GR_NM, S.USE_YN, 'admin', SYSDATE, 'admin', SYSDATE)
    WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_M X WHERE UPPER(X.USER_GR_ID) = UPPER(S.USER_GR_ID));
COMMIT;
-- [B-1] 추가 키 기록 테이블 (없을 때만 생성)
DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZZ_GAP467_MPG_ADDED';
    IF n = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TABLE ZZ_GAP467_MPG_ADDED (USER_GR_ID VARCHAR2(200) NOT NULL, USER_ID VARCHAR2(200) NOT NULL, ADDED_AT DATE DEFAULT SYSDATE NOT NULL)';
    END IF;
END;
/
-- [B-2] 사용자 매핑 이관
DECLARE
    n      PLS_INTEGER;
    v_log  PLS_INTEGER;
    v_ins  PLS_INTEGER;
    c_grp  CONSTANT VARCHAR2(200) := q'[('CAPA Planner','System Monitor','-')]';
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'TB_FX_USERGROUPINFO';
    IF n = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP [B] — 이관 사본 TB_FX_USERGROUPINFO 없음. 그룹 원장[A]만 적용됨. 결과 회신');
        RETURN;
    END IF;
    EXECUTE IMMEDIATE
        'INSERT INTO ZZ_GAP467_MPG_ADDED (USER_GR_ID, USER_ID, ADDED_AT)
         SELECT I.GROUPID, I.USERID, SYSDATE FROM TB_FX_USERGROUPINFO I
          WHERE I.GROUPID IN ' || c_grp || '
            AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M M WHERE M.USER_GR_ID = I.GROUPID AND M.USER_ID = I.USERID)';
    v_log := SQL%ROWCOUNT;
    EXECUTE IMMEDIATE
        'INSERT INTO SCM_ADM_USER_GR_MPG_M (USER_GR_ID, USER_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
         SELECT I.GROUPID, I.USERID, NVL(I.USEYN, ''/''),
                NVL(I.REGTUSERID, ''/''), NVL(CAST(I.REGTDATETIME AS DATE), SYSDATE),
                NVL(I.UPDATEUSERID, ''/''), NVL(CAST(I.UPDATEDATETIME AS DATE), SYSDATE)
           FROM TB_FX_USERGROUPINFO I
          WHERE I.GROUPID IN ' || c_grp || '
            AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M M WHERE M.USER_GR_ID = I.GROUPID AND M.USER_ID = I.USERID)';
    v_ins := SQL%ROWCOUNT;
    IF v_ins <> v_log THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, '중단 — 기록 ' || v_log || '건 ≠ 이관 ' || v_ins || '건. 전부 취소됨');
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('APPLIED [B] — 사용자 매핑 ' || v_ins || '건 추가 (이미 있던 키는 건너뜀)');
END;
/
SELECT 'POST 그룹' CHK, USER_GR_ID, USER_GR_NM, USE_YN, CREATED_BY FROM SCM_ADM_USER_GR_M
 WHERE USER_GR_ID IN ('CAPA Planner','System Monitor','SSP ADMIN','-') ORDER BY USER_GR_ID;
SELECT 'POST 매핑' CHK, USER_GR_ID, COUNT(*) N FROM SCM_ADM_USER_GR_MPG_M
 WHERE USER_GR_ID IN ('CAPA Planner','System Monitor','-') GROUP BY USER_GR_ID ORDER BY USER_GR_ID;
