-- DMF0068 Demand Manager — 버튼 배선 (2026-07-29)
-- ⭐ FE 가 사용하는 전 시트를 등록한다 (DMF0003 dayRange "오픈 시 권한없음" 사고 재발 방지)
--    시트 3종: ContributeSalesList / versionPopup / lookupProject
-- 멱등: 동일 (MNU_ID, SHT_NM, MNU_BTN_CD) 존재 시 INSERT 하지 않음

INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0068', V.SHT_NM, V.MNU_BTN_CD, V.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
FROM (
    SELECT 'ContributeSalesList' AS SHT_NM, 'SEARCH'        AS MNU_BTN_CD, 'DMF0068_main_SEARCH'          AS API_ID FROM DUAL
    UNION ALL SELECT 'ContributeSalesList', 'INSERT',        'DMF0068_main_INSERT'        FROM DUAL
    UNION ALL SELECT 'ContributeSalesList', 'EDIT',          'DMF0068_main_EDIT'          FROM DUAL
    UNION ALL SELECT 'ContributeSalesList', 'DELETE',        'DMF0068_main_DELETE'        FROM DUAL
    UNION ALL SELECT 'ContributeSalesList', 'SAVE',          'DMF0068_main_SAVE'          FROM DUAL
    UNION ALL SELECT 'ContributeSalesList', 'SORT',          'DMF0068_main_SORT'          FROM DUAL
    UNION ALL SELECT 'ContributeSalesList', 'FILTER',        'DMF0068_main_FILTER'        FROM DUAL
    UNION ALL SELECT 'ContributeSalesList', 'EXCEL',         'DMF0068_main_EXCEL'         FROM DUAL
    UNION ALL SELECT 'ContributeSalesList', 'COLUMN_SETUP',  'DMF0068_main_COLUMN_SETUP'  FROM DUAL
    UNION ALL SELECT 'ContributeSalesList', 'SP_VER',        'DMF0068_main_SP_VER'        FROM DUAL
    UNION ALL SELECT 'versionPopup',        'SEARCH',        'DMF0068_versionPopup_SEARCH'  FROM DUAL
    UNION ALL SELECT 'lookupProject',       'SEARCH',        'DMF0068_lookupProject_SEARCH' FROM DUAL
) V
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B
    WHERE B.MNU_ID = 'DMF0068' AND B.SHT_NM = V.SHT_NM AND B.MNU_BTN_CD = V.MNU_BTN_CD
);

COMMIT;

-- 검증 (12건 기대)
SELECT SHT_NM, MNU_BTN_CD, API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0068' ORDER BY SHT_NM, MNU_BTN_CD;
