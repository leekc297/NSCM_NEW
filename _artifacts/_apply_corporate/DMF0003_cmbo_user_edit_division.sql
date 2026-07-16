-- =====================================================================
-- DMF0003 — CMBO MktFcstUserEditDivision 등록 (G6 그룹×Division EDIT_YN, OR 규칙)
-- 사용자(@sesUserId)가 편집 권한(EDIT_YN='Y')을 가진 division 목록.
--   OR 규칙(사용자 결정 2026-07-11): 여러 그룹 중 하나라도 EDIT_YN='Y' 면 편집 허용
--   → DISTINCT UNIT_ID (그룹 무관 집계). ADMIN 권한 보유자는 편집 가능.
-- FE 합성: editable = isEditableDivision(div, editableSet[=82]) AND userEditSet.has(div).
--   userEditSet 비면(미응답) 관대 통과 — 회귀 0.
-- 바인딩: @sesUserId (BE 런타임 치환, MyDivision/TeambyDivision 등 동일 패턴).
-- 멱등: MERGE.
-- =====================================================================

MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M t
USING (SELECT 'MktFcstUserEditDivision' SQL_ID FROM DUAL) s
ON (t.SQL_ID = s.SQL_ID)
WHEN MATCHED THEN UPDATE SET
    t.MDU_DIVS_CD = 'ALL',
    t.SQL_NM = 'MKT FCST 사용자 편집가능 Division',
    t.SQL_DTL_CTN = 'SELECT DISTINCT UNIT_ID AS CODE, UNIT_ID AS NAME FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE UNIT_TP_CD = ''D'' AND EDIT_YN = ''Y'' AND USE_YN = ''Y'' AND USER_ID = @sesUserId',
    t.USE_YN = 'Y',
    t.LAST_UPDATED_BY = 'admin',
    t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('MktFcstUserEditDivision', 'ALL', 'MKT FCST 사용자 편집가능 Division',
     'SELECT DISTINCT UNIT_ID AS CODE, UNIT_ID AS NAME FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE UNIT_TP_CD = ''D'' AND EDIT_YN = ''Y'' AND USE_YN = ''Y'' AND USER_ID = @sesUserId',
     'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 원복 (ROLLBACK SCRIPT — 필요 시 수동 실행)
-- DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='MktFcstUserEditDivision';
-- COMMIT;
