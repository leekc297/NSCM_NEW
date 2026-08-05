-- =============================================================================
-- 03_EXTRACT_PKG_SYS0014_ONLY.sql — 클라우드 Oracle 에서 sqlplus/SQLcl 로 실행
-- 목적: PKG_SYS0014 단독 추출 (SPEC + BODY) → C4_PKG_SYS0014.sql spool 생성
-- 참고: 2026-07-29 1차 추출본이 본 폴더 C4_PKG_SYS0014.sql 로 이미 커밋되어 있음 —
--       재추출 시 기존 파일과 diff 하여 클라우드 변경 여부 확인 (원문 1바이트 무수정 원칙)
-- 사전: 클라우드 PRECHECK 실측(2026-07-29) OWNER = SCM_MGR (SPEC/BODY 모두 VALID)
-- =============================================================================
DEFINE OWNER = 'SCM_MGR'

SET LONG 2000000 LONGCHUNKSIZE 32767 PAGESIZE 0 LINESIZE 32767
SET TRIMSPOOL ON TRIMOUT ON HEADING OFF FEEDBACK OFF VERIFY OFF ECHO OFF TERMOUT ON

-- 이관용 transform: 문장 종결자 포함 + 정렬
BEGIN
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'PRETTY', TRUE);
END;
/

SPOOL C4_PKG_SYS0014.sql
SELECT DBMS_METADATA.GET_DDL('PACKAGE_SPEC', 'PKG_SYS0014', '&OWNER') FROM DUAL;
SELECT DBMS_METADATA.GET_DDL('PACKAGE_BODY', 'PKG_SYS0014', '&OWNER') FROM DUAL;
SPOOL OFF

PROMPT === 추출 완료: C4_PKG_SYS0014.sql ===
PROMPT 검증 1) BODY 에 P_SYS0014_GET_DIVISION_DATA 멤버 포함 확인
PROMPT 검증 2) 기존 커밋본(_deploy_packages/CLOUD_DDL_FETCH_20260729/C4_PKG_SYS0014.sql)과 diff — 상이하면 클라우드 변경분 보고
PROMPT 사내 적용: SPEC → BODY 순서 실행 후 VALID 확인 + GRANT EXECUTE TO SCMD_APP (+SYNONYM 확인) + PROC_M positional 대조
