-- 00_PRECHECK — 조회 전용 (전체 F5, 값 입력 없음). [E20261012-FCSTTYPEADM] 적용 전 상태
-- * [P1] 콤보 SQL 2종 — 마커(적용 여부) · 앵커 2곳 매칭 수(각 1 이어야 10 적용 가능) · 길이
-- * [P2] 대상 사용자 — 일반 그룹(ADMIN · DM ADMIN · DM Planner · SCM PI Admin)과 'DM Planner (W/S)' 를 함께 가진 사용자 (적용 뒤 81 에서 후보가 늘어나는 사람)
-- * [P3] 영향 없는 사용자 수 — W/S 보유자 중 일반 그룹이 없는 사람 (적용 뒤에도 81 에서 W/S 유형만)
SET LINESIZE 200 PAGESIZE 200
SET DEFINE OFF
COLUMN CHK FORMAT A4
COLUMN SQL_ID FORMAT A30
COLUMN WHO FORMAT A12
COLUMN JUDGE FORMAT A60
COLUMN GROUPS FORMAT A110
SELECT 'P1' CHK, M.SQL_ID, SUBSTR(M.LAST_UPDATED_BY,1,12) WHO, TO_CHAR(M.LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI') UPD, LENGTHB(M.SQL_DTL_CTN) BYTES,
       CASE WHEN INSTR(M.SQL_DTL_CTN, 'E20261012-FCSTTYPEADM') > 0 THEN 'Y' ELSE 'N' END APPLIED,
       REGEXP_COUNT(M.SQL_DTL_CTN, '(G\.USER_GR_ID\s*=\s*''DM Planner \(W/S\)''\s+AND\s+(TO_CHAR\(G\.USE_YN\)|G\.USE_YN)\s*=\s*''Y''\s*\))(\s+UNION ALL)') ANCHOR1,
       REGEXP_COUNT(M.SQL_DTL_CTN, '(NOT\s*\(\s*NVL\(TRIM\(@divisionId\),\s*''-''\)\s+LIKE\s+''81%''\s+AND\s+EXISTS\s*\(\s*SELECT 1 FROM SCM_MGR\.SCM_ADM_USER_GR_MPG_M G\s+WHERE\s+G\.USER_ID\s*=\s*@sesUserId\s+AND\s+G\.USER_GR_ID\s*=\s*''DM Planner \(W/S\)''\s+AND\s+(TO_CHAR\(G\.USE_YN\)|G\.USE_YN)\s*=\s*''Y''\s*\)\s*\))') ANCHOR2,
       CASE WHEN INSTR(M.SQL_DTL_CTN, 'E20261012-FCSTTYPEADM') > 0 THEN '적용됨 — 10 재실행은 무동작'
            WHEN REGEXP_COUNT(M.SQL_DTL_CTN, '(G\.USER_GR_ID\s*=\s*''DM Planner \(W/S\)''\s+AND\s+(TO_CHAR\(G\.USE_YN\)|G\.USE_YN)\s*=\s*''Y''\s*\))(\s+UNION ALL)') = 1
             AND REGEXP_COUNT(M.SQL_DTL_CTN, '(NOT\s*\(\s*NVL\(TRIM\(@divisionId\),\s*''-''\)\s+LIKE\s+''81%''\s+AND\s+EXISTS\s*\(\s*SELECT 1 FROM SCM_MGR\.SCM_ADM_USER_GR_MPG_M G\s+WHERE\s+G\.USER_ID\s*=\s*@sesUserId\s+AND\s+G\.USER_GR_ID\s*=\s*''DM Planner \(W/S\)''\s+AND\s+(TO_CHAR\(G\.USE_YN\)|G\.USE_YN)\s*=\s*''Y''\s*\)\s*\))') = 1 THEN 'PASS → 10 적용 가능'
            ELSE 'FAIL — 앵커 불일치 (원문이 예상과 다름) → 중단·회신' END JUDGE
  FROM SCM_ADM_CMBO_SQL_M M WHERE M.SQL_ID IN ('FcstTypeEditDMF0082','FcstTypeByUserGroupDMF0082') ORDER BY M.SQL_ID;
SELECT 'P2' CHK, G.USER_ID, LISTAGG(G.USER_GR_ID, ' | ') WITHIN GROUP (ORDER BY G.USER_GR_ID) GROUPS
  FROM SCM_ADM_USER_GR_MPG_M G WHERE TO_CHAR(G.USE_YN) = 'Y'
 GROUP BY G.USER_ID
HAVING MAX(CASE WHEN G.USER_GR_ID = 'DM Planner (W/S)' THEN 1 ELSE 0 END) = 1
   AND MAX(CASE WHEN G.USER_GR_ID IN ('ADMIN','DM ADMIN','DM Planner','SCM PI Admin') THEN 1 ELSE 0 END) = 1
 ORDER BY G.USER_ID;
SELECT 'P3' CHK, COUNT(*) WS_ONLY_USERS FROM (
  SELECT G.USER_ID FROM SCM_ADM_USER_GR_MPG_M G WHERE TO_CHAR(G.USE_YN) = 'Y' GROUP BY G.USER_ID
  HAVING MAX(CASE WHEN G.USER_GR_ID = 'DM Planner (W/S)' THEN 1 ELSE 0 END) = 1
     AND MAX(CASE WHEN G.USER_GR_ID IN ('ADMIN','DM ADMIN','DM Planner','SCM PI Admin') THEN 1 ELSE 0 END) = 0);
