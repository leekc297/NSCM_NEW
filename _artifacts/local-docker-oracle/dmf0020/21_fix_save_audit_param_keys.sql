-- =====================================================================================
-- DMF0020 저장 미동작 주범: createdBy/lastUpdatedBy 단일값 덮어쓰기 회피 (2026-06-27)
--   증상: div81/82 저장 시 ORA-20001 ← ORA-01400 NULL CREATED_BY (SP L737).
--   원인: BE NDaoInterface._selectList L436-437 이 paramMap 의 'createdBy'/'lastUpdatedBy' 키를
--         세션 userId 단일값으로 강제 주입 → FE 가 보낸 ^×N 배열을 1토큰으로 덮어씀
--         → SP split 시 2~4행 CREATED_BY NULL. (BE = Hard Boundary 변경불가)
--   조치: 두 IN 파라미터의 PROC_M COL_NM 을 BE 가 가로채지 않는 키명(createdByList/lastUpdatedByList)
--         으로 변경. positional 순서(14/16)·타입(VARCHAR) 불변. FE payload 키도 동일 변경.
-- 멱등: UPDATE (재실행 무해). 적용: python _artifacts/_diagnostics/ora.py exec <this>
-- =====================================================================================
WHENEVER SQLERROR CONTINUE;
SET DEFINE OFF;

UPDATE SCM_ADM_PROC_M
   SET COL_NM = 'createdByList', LAST_UPDATED_BY = 'minyonglee1', LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL' AND SORT_ORD = 14;

UPDATE SCM_ADM_PROC_M
   SET COL_NM = 'lastUpdatedByList', LAST_UPDATED_BY = 'minyonglee1', LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL' AND SORT_ORD = 16;

COMMIT;
