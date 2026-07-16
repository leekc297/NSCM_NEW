-- =====================================================================
-- DMF0003 — CMBO MktFcstEditableDivision 등록 (FE editableSet 소스)
-- FE MktFcst.tsx:84 useTabComboQueries({filters:['MktFcstEditableDivision']}) 가
--   CODE 컬럼으로 편집가능 division 목록을 받아 editableSet 구성.
-- lookup 은 ATTRIBUTE1(EDIT_YN) 플래그 구조 → ATTRIBUTE1='Y' 필터로 편집가능만 반환.
--   현재 DMF0003 에서 82 만 EDIT_YN='Y' → CMBO 는 82 단건 반환 → editableSet={82}.
-- 멱등: MERGE (재실행 시 SQL 본문 동기화).
-- =====================================================================

MERGE INTO SCM_MGR.SCM_ADM_CMBO_SQL_M t
USING (SELECT 'MktFcstEditableDivision' SQL_ID FROM DUAL) s
ON (t.SQL_ID = s.SQL_ID)
WHEN MATCHED THEN UPDATE SET
    t.MDU_DIVS_CD = 'ALL',
    t.SQL_NM = 'MKT FCST 편집가능 Division',
    t.SQL_DTL_CTN = 'SELECT SEGMENT2 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = ''DM_UI_EDITABLE_DIVISION'' AND SEGMENT1 = ''DMF0003'' AND ATTRIBUTE1 = ''Y'' AND VALID_YN = ''Y'' ORDER BY SEGMENT2',
    t.USE_YN = 'Y',
    t.LAST_UPDATED_BY = 'admin',
    t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    ('MktFcstEditableDivision', 'ALL', 'MKT FCST 편집가능 Division',
     'SELECT SEGMENT2 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = ''DM_UI_EDITABLE_DIVISION'' AND SEGMENT1 = ''DMF0003'' AND ATTRIBUTE1 = ''Y'' AND VALID_YN = ''Y'' ORDER BY SEGMENT2',
     'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 원복 (ROLLBACK SCRIPT — 필요 시 수동 실행)
-- DELETE FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='MktFcstEditableDivision';
-- COMMIT;
