-- ============================================================================
-- [DMF0005 PERF 20260722] Step 2: FBI — FN_GET_MULTI_OWNER_NAME 조회 SARGable 화 (멱등)
-- 사유: 함수 내부 SELECT 가 UPPER(USER_ID)=UPPER(:x) 라 PK(USER_ID) 를 못 타고
--       호출당 SCM_MST_SSO_USER_INFO 128,610행 풀스캔 → DMF0005 '81' 300s+ 의 주범 (ASH 298/300).
--       동일 함수를 쓰는 DMF0003 등 전 화면 공통 이득.
-- ============================================================================
DECLARE
    E_EXISTS  EXCEPTION;  PRAGMA EXCEPTION_INIT(E_EXISTS,  -955);
    E_DUPCOLS EXCEPTION;  PRAGMA EXCEPTION_INIT(E_DUPCOLS, -1408);
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX IDX02_SCM_MST_SSO_USER_INFO ON SCM_MST_SSO_USER_INFO (UPPER(USER_ID))';
    DBMS_OUTPUT.PUT_LINE('CREATED: IDX02_SCM_MST_SSO_USER_INFO');
EXCEPTION
    WHEN E_EXISTS  THEN DBMS_OUTPUT.PUT_LINE('SKIP(-955): IDX02_SCM_MST_SSO_USER_INFO');
    WHEN E_DUPCOLS THEN DBMS_OUTPUT.PUT_LINE('SKIP(-1408): 동일 컬럼 인덱스 기존재');
END;
/

-- 검증: VALID / ENABLED 이어야 함
SELECT index_name, status, funcidx_status
  FROM user_indexes
 WHERE table_name = 'SCM_MST_SSO_USER_INFO';
