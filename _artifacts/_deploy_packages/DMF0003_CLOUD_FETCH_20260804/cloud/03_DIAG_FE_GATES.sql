-- =============================================================================
-- 03_DIAG_FE_GATES.sql — 클라우드 sqlplus 실행: DMF0003 화면(FE) 편집 게이트 재현
-- 서버(EDIT_FLAG) 게이트는 02 진단에서 통과 확인 — 남은 것은 FE 가 콤보로 받는 값들.
-- FE 편집 = (F1 editableSet 82 포함) AND (F2 userEditSet 비었거나 82 포함)
--           AND (F3 SCP Planner 아님) — 하나라도 어긋나면 EDIT_FLAG=Y 라도 전 셀 잠금.
-- 사내 기준값 주석 병기. PROMPT 미사용(이전 실행에서 특수문자 충돌) — 라벨은 SELECT.
-- =============================================================================
SET PAGESIZE 200 LINESIZE 200 SQLBLANKLINES ON
COLUMN GATE FORMAT A10
COLUMN CODE FORMAT A30
COLUMN NAME FORMAT A30
COLUMN SQL_ID FORMAT A28
COLUMN REGISTERED FORMAT A10

SELECT '[F0] wonqthanq 그룹 전체 (사내: DM ADMIN 1건 — SCP Planner 있으면 FE 82 편집 차단!)' AS GATE_DESC FROM DUAL;
SELECT USER_GR_ID, USE_YN FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'wonqthanq';

SELECT '[F0-b] CMBO 4종 클라우드 등재 여부 (사내: 4종 전부 등재)' AS GATE_DESC FROM DUAL;
SELECT SQL_ID, 'Y' AS REGISTERED FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE SQL_ID IN ('MktFcstEditableDivision','MktFcstUserEditDivision','MktFcstWsPlannerYn','MktFcstUserGroups');

SELECT '[F1] editableSet 재현 (사내: 82 1행 — 0행이면 FE fallback 82 로 통과하므로 OK)' AS GATE_DESC FROM DUAL;
SELECT SEGMENT2 AS CODE FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
WHERE LOOKUP_TYPE = 'DM_UI_EDITABLE_DIVISION' AND SEGMENT1 = 'DMF0003'
  AND ATTRIBUTE1 = 'Y' AND VALID_YN = 'Y' ORDER BY SEGMENT2;

SELECT '[F2] userEditSet 재현 (사내: 82 1행 — 82 없는 비공집합이면 차단!)' AS GATE_DESC FROM DUAL;
SELECT DISTINCT UNIT_ID AS CODE FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M
WHERE UNIT_TP_CD = 'D' AND EDIT_YN = 'Y' AND USE_YN = 'Y' AND USER_ID = 'wonqthanq';

SELECT '[F3] SCP Planner 여부 (사내: N — Y 면 82 편집 차단)' AS GATE_DESC FROM DUAL;
SELECT CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
                         WHERE USER_ID = 'wonqthanq' AND USER_GR_ID = 'SCP Planner' AND USE_YN = 'Y')
       THEN 'Y' ELSE 'N' END AS SCP_PLANNER FROM DUAL;

SELECT '[F4] W-S Planner 여부 (사내: N)' AS GATE_DESC FROM DUAL;
SELECT CASE WHEN EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
                         WHERE USER_ID = 'wonqthanq' AND USER_GR_ID = 'DM Planner (W/S)')
       THEN 'Y' ELSE 'N' END AS WS_PLANNER FROM DUAL;

-- =============================================================================
-- [F5] 클라우드 FE 소스 세대 확인 — DB 아님. 클라우드 셸에서 실행:
--   grep -c "MktFcstUserGroups" nscm-fe/features/demand/src/pages/mkt-fcst/MktFcst.tsx
--   grep -c "isEditableDivision" nscm-fe/features/demand/src/pages/mkt-fcst/MktFcst.tsx
--   기대: 둘 다 1 이상. 0 이면 클라우드 FE 가 구세대 본 — 구세대 게이트(session.groupId 등)가
--   편집을 막는 것이므로 mkt-fcst 폴더 전체를 최신본으로 교체해야 함 (파일 단위 덮어쓰기 금지).
-- =============================================================================
SELECT '=== 진단 끝 — F0~F4 가 사내 기준값과 전부 일치하면 원인은 F5(클라우드 FE 구세대) ===' AS FIN FROM DUAL;
