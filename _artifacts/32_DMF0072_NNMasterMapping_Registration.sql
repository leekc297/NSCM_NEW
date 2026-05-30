--==============================================================================
-- DMF0072_NNMasterMapping — SQL*Plus 실행용 메타 등록
-- 사용: sqlplus SCM_MGR/...@FREEPDB1 @32_DMF0072_NNMasterMapping_Registration.sql
--==============================================================================

WHENEVER SQLERROR EXIT FAILURE
SET SERVEROUTPUT ON
SET ECHO OFF
SET FEEDBACK OFF

PROMPT === DMF0072 NNMasterMapping 메타 등록 시작 ===

@32_DMF0072_NNMasterMapping_Registration_DBeaver.sql

PROMPT === DMF0072 NNMasterMapping 메타 등록 완료 ===

EXIT
