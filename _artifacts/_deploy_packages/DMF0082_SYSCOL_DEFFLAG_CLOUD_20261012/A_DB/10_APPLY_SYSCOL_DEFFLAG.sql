-- 10_APPLY — DMF0082 · FcstNPrice 시스템 컬럼 10개의 DEFAULT_FLAG 를 'N' → 공백 1칸으로 복원 (전체 F5, 값 입력 없음, 멱등)
-- 증상: 조회 시 ORA-00904 "SORT_KEY" (PKG_DMF0082.P_DMF0082_GET_MAIN_DATA 결과 커서 OPEN)
-- 원인: 조회 SP 는 출력 컬럼 목록에 '메타에서 DEFAULT_FLAG 가 빈 값인 컬럼'(SORT_KEY·EDIT_FLAG·GROUP_ID 등 시스템 컬럼)을 더한다.
--       클라우드 QA 실측(2026-10-12 V08): 이 10개가 전부 'N' 이라 빈 값 판정에 하나도 안 잡힘 → 정렬절의 SORT_KEY 가 출력 목록에 없음.
--       (같은 조회가 17:31 까지는 정상 — 그 뒤 값이 바뀐 것. 수정 시각 컬럼은 갱신되지 않아 누가 바꿨는지는 미확인)
-- 대상: 아래 10개 컬럼 중 **지금 값이 'N' 인 행만** 공백 1칸으로. 이미 빈 값이면 건드리지 않는다. 다른 컬럼·다른 화면 무변경.
--       10개 목록 = 사내 ZIOUI1 메타에서 DEFAULT_FLAG 가 빈 값인 컬럼 전부 (AS-IS 원문 조건 DEFAULT_FLAG = '' 에 해당하는 시스템 컬럼)
-- 원복: 99_ROLLBACK_SYSCOL_DEFFLAG.sql
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    n PLS_INTEGER;
BEGIN
    UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS C
       SET C.DEFAULT_FLAG = ' ', C.LAST_UPDATED_BY = 'admin', C.LAST_UPDATE_DATE = SYSDATE
     WHERE C.PROGRAM_ID = 'DMF0082' AND C.SHEET_NAME = 'FcstNPrice'
       AND C.COLUMN_NAME IN ('AS_YN','ATTR1','BUCKET','EDIT_FLAG','GROUP_ID','MEASURE_GROUP','NEW_FLAG','SORT_KEY','VERSION_NO','VMI_STD_DIO')
       AND C.DEFAULT_FLAG = 'N';
    n := SQL%ROWCOUNT;
    IF n > 10 THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, '중단 — 대상 ' || n || '행 (10 이하 기대, 같은 컬럼명이 중복 등록됨). 변경 취소함');
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(CASE WHEN n = 0 THEN 'SKIP — 복원 대상 없음 (이미 빈 값)' ELSE 'APPLIED — ' || n || '행을 공백으로 복원 · COMMIT' END
                         || ' · ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'));
END;
/
