--==============================================================================
-- 83_axis3a_sp_missing_cleanup.sql
-- AXIS 3-A — SP MISSING (PROC_M 만 등록, 실제 SP 없음) 9건 cleanup
--
-- 대상:
--   - DMF0082_GET_MAIN_DATA / DMF0082_SAVE_MAIN_DATA
--   - PG_NSCM_COMM.SP_GET_MENU_LIST / SP_GET_PROC_INFO_LIST
--   - PKG_SYS0108.SYS0108_GET_MAIN_DATA
--   - SCM0000_GET_GRID_HEADER
--   - UP_FX_ApproveAuthRequest / GetApprovalAuthRequest / RejectAuthRequest (MSSQL AS-IS 변환 잔재)
--
-- 위 SP 호출 시도 시 PLS-00201 → BE 응답 실패. PROC_M cleanup 으로 dead meta 정리.
-- 실제 호출 라우팅이 필요한 화면이 있다면 별도 작업.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === DELETE SP MISSING PROC_M ===
DELETE FROM SCM_MGR.SCM_ADM_PROC_M P
 WHERE NOT EXISTS (
   SELECT 1 FROM ALL_OBJECTS O
    WHERE O.OWNER='SCM_MGR'
      AND ( (INSTR(P.PROC_NM,'.')>0 AND O.OBJECT_NAME = SUBSTR(P.PROC_NM, 1, INSTR(P.PROC_NM,'.')-1) AND O.OBJECT_TYPE='PACKAGE')
         OR (INSTR(P.PROC_NM,'.')=0 AND O.OBJECT_NAME = P.PROC_NM AND O.OBJECT_TYPE='PROCEDURE')
          )
 );

COMMIT;

PROMPT === VERIFY (SP MISSING 0건 의무) ===
SELECT P.PROC_NM
  FROM SCM_MGR.SCM_ADM_PROC_M P
 WHERE NOT EXISTS (
   SELECT 1 FROM ALL_OBJECTS O
    WHERE O.OWNER='SCM_MGR'
      AND ( (INSTR(P.PROC_NM,'.')>0 AND O.OBJECT_NAME = SUBSTR(P.PROC_NM, 1, INSTR(P.PROC_NM,'.')-1) AND O.OBJECT_TYPE='PACKAGE')
         OR (INSTR(P.PROC_NM,'.')=0 AND O.OBJECT_NAME = P.PROC_NM AND O.OBJECT_TYPE='PROCEDURE')
          )
 )
 GROUP BY P.PROC_NM;
EXIT;
