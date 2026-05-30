--==============================================================================
-- DMF0043_Contribute_Main — SQL*Plus 실행용 메타 등록
-- 사용: sqlplus SCM_MGR/...@FREEPDB1 @30_DMF0043_Contribute_Main_Registration.sql
-- DBeaver 호환판 (_DBeaver.sql) 과 동일 로직. SQL*Plus 명령 사용 가능 (PROMPT 등).
--==============================================================================

WHENEVER SQLERROR EXIT FAILURE
SET SERVEROUTPUT ON
SET ECHO OFF
SET FEEDBACK OFF

PROMPT === DMF0043 Contribute_Main 메타 등록 시작 ===

@30_DMF0043_Contribute_Main_Registration_DBeaver.sql

PROMPT === DMF0043 Contribute_Main 메타 등록 완료 — Verify 별도 실행 ===

EXIT
