--==============================================================================
-- DMF0043_01_Contribute_View — SQL*Plus 실행용 메타 등록
-- 사용: sqlplus SCM_MGR/...@FREEPDB1 @31_DMF0043_01_Contribute_View_Registration.sql
-- 선결: @30_DMF0043_Contribute_Main_Registration.sql 먼저 (공유 POPUP API 의존)
--==============================================================================

WHENEVER SQLERROR EXIT FAILURE
SET SERVEROUTPUT ON
SET ECHO OFF
SET FEEDBACK OFF

PROMPT === DMF0043_01 Contribute_View 메타 등록 시작 ===

@31_DMF0043_01_Contribute_View_Registration_DBeaver.sql

PROMPT === DMF0043_01 Contribute_View 메타 등록 완료 ===

EXIT
