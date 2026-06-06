--==============================================================================
-- 77_SYS0014_15_move_to_System.sql
-- 목적: SYS0014 Group User + SYS0015 Program 의 UPPR_MNU_ID 를 Admin_Menu → System 으로 이동
--       사용자 명시 요구 (2026-06-09)
-- 멱등성: 이미 System 이면 UPDATE 0 rows
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === 사전 ===
SELECT MNU_ID, UPPR_MNU_ID, SORT_ORD FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID IN ('SYS0014','SYS0015') ORDER BY MNU_ID;

PROMPT === UPDATE: Admin_Menu → System (sort_ord 도 System 의 다음 슬롯으로) ===
UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET UPPR_MNU_ID = 'System',
       SORT_ORD    = 10,                -- Group User: SYS0009 까지 사용 후 다음
       LAST_UPDATED_BY = 'system',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID='SYS0014' AND UPPR_MNU_ID='Admin_Menu';

UPDATE SCM_MGR.SCM_ADM_MNU_M
   SET UPPR_MNU_ID = 'System',
       SORT_ORD    = 11,                -- Program
       LAST_UPDATED_BY = 'system',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID='SYS0015' AND UPPR_MNU_ID='Admin_Menu';

PROMPT === 사후 ===
SELECT MNU_ID, UPPR_MNU_ID, SORT_ORD FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID IN ('SYS0014','SYS0015') ORDER BY MNU_ID;

COMMIT;
EXIT;
