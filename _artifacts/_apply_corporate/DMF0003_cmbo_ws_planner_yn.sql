-- =====================================================================
-- DMF0003 — CMBO MktFcstWsPlannerYn (로그인 사용자 W/S Planner 여부 → AS 강제)
-- 목적: AS-IS DMF0003_MktFcst.cs L1679 (E20260211-001189) —
--        p_as_yn = (NowGroupID == 'DM Planner (W/S)') ? 'Y' : 'N'.
--        구 cboAS 체크박스 → W/S Planner 그룹 소속 여부로 대체.
--   TO-BE: BE UserSession 에 groupId 미제공 → 로그인 사용자(USER_ID)의 그룹 소속을
--          SCM_ADM_USER_GR_MPG_M(USER_ID→USER_GR_ID, 다중그룹)에서 직접 판정.
--          'DM Planner (W/S)' 그룹 row 존재 시 'Y'. (SCM_ADM_USER_GR_M 에 동일 USER_GR_ID 존재 확인.)
-- 파라미터: @sesUserId — BE 세션 자동 주입·자동 quoting (TeambyDivision 선례 동일).
-- 반환: 단일행 CODE='Y'|'N'. FE 가 result[0].CODE 로 asYn OR-강제.
-- 멱등 MERGE. 감사 'admin'.
-- =====================================================================

MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M t
USING (SELECT 'MktFcstWsPlannerYn' SQL_ID FROM DUAL) s
ON (t.SQL_ID = s.SQL_ID)
WHEN MATCHED THEN UPDATE SET
    t.MDU_DIVS_CD = 'DM',
    t.SQL_NM = 'MKT FCST 로그인 사용자 W/S Planner 여부',
    t.SQL_DTL_CTN = 'SELECT CASE WHEN EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = @sesUserId AND USER_GR_ID = ''DM Planner (W/S)'') THEN ''Y'' ELSE ''N'' END AS CODE, ''WS_PLANNER'' AS NAME FROM DUAL',
    t.USE_YN = 'Y',
    t.LAST_UPDATED_BY = 'admin',
    t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('MktFcstWsPlannerYn', 'DM', 'MKT FCST 로그인 사용자 W/S Planner 여부',
     'SELECT CASE WHEN EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = @sesUserId AND USER_GR_ID = ''DM Planner (W/S)'') THEN ''Y'' ELSE ''N'' END AS CODE, ''WS_PLANNER'' AS NAME FROM DUAL',
     'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 원복 (ROLLBACK — 필요 시 수동)
-- DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='MktFcstWsPlannerYn';
-- COMMIT;
