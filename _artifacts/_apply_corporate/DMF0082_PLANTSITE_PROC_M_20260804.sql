-- ====================================================================================================
-- DMF0082 Plant Site 조회조건 추가 — PROC_M 재등록 (멱등: DELETE→INSERT)
-- 대상: PKG_DMF0082.P_DMF0082_GET_MAIN_DATA / P_DMF0082_GET_MAIN_DATA_CURRENT (각 19행)
-- 변경: plantSiteId IN @13 신규 (DMF0003 동일 명칭), OUT 커서 13~18 → 14~19 시프트
-- 규약: 감사컬럼 'admin' (hook feedback_meta_audit_column_admin_only) / PROC_RESULT+OUT 표준
-- 2026-08-04
-- ====================================================================================================

DELETE FROM SCM_MGR.SCM_ADM_PROC_M
WHERE PROC_NM IN ('PKG_DMF0082.P_DMF0082_GET_MAIN_DATA', 'PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT');

INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'PKG_DMF0082.P_DMF0082_GET_MAIN_DATA', COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE FROM (
    SELECT 'divisionId'      COL_NM, 'VARCHAR'     DATA_TP_CD, 'IN'  COL_TP_CD,  1 SORT_ORD FROM DUAL UNION ALL
    SELECT 'deptId'         , 'VARCHAR'    , 'IN' ,  2 FROM DUAL UNION ALL
    SELECT 'endCustomer'    , 'VARCHAR'    , 'IN' ,  3 FROM DUAL UNION ALL
    SELECT 'bizType'        , 'VARCHAR'    , 'IN' ,  4 FROM DUAL UNION ALL
    SELECT 'fromYyyymmdd'   , 'VARCHAR'    , 'IN' ,  5 FROM DUAL UNION ALL
    SELECT 'toYyyymmdd'     , 'VARCHAR'    , 'IN' ,  6 FROM DUAL UNION ALL
    SELECT 'salesSite'      , 'VARCHAR'    , 'IN' ,  7 FROM DUAL UNION ALL
    SELECT 'itemId'         , 'VARCHAR'    , 'IN' ,  8 FROM DUAL UNION ALL
    SELECT 'versionType'    , 'VARCHAR'    , 'IN' ,  9 FROM DUAL UNION ALL
    SELECT 'qtyYn'          , 'VARCHAR'    , 'IN' , 10 FROM DUAL UNION ALL
    SELECT 'sesUserId'      , 'VARCHAR'    , 'IN' , 11 FROM DUAL UNION ALL
    SELECT 'userGroup'      , 'VARCHAR'    , 'IN' , 12 FROM DUAL UNION ALL
    SELECT 'plantSiteId'    , 'VARCHAR'    , 'IN' , 13 FROM DUAL UNION ALL
    SELECT 'fcstNPrice'     , 'CURSOR'     , 'OUT', 14 FROM DUAL UNION ALL
    SELECT 'drop1'          , 'CURSOR'     , 'OUT', 15 FROM DUAL UNION ALL
    SELECT 'drop2'          , 'CURSOR'     , 'OUT', 16 FROM DUAL UNION ALL
    SELECT 'drop3'          , 'CURSOR'     , 'OUT', 17 FROM DUAL UNION ALL
    SELECT 'drop4'          , 'CURSOR'     , 'OUT', 18 FROM DUAL UNION ALL
    SELECT 'O_RESULT_CURSOR', 'PROC_RESULT', 'OUT', 19 FROM DUAL
);

INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'PKG_DMF0082.P_DMF0082_GET_MAIN_DATA_CURRENT', COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE FROM (
    SELECT 'divisionId'      COL_NM, 'VARCHAR'     DATA_TP_CD, 'IN'  COL_TP_CD,  1 SORT_ORD FROM DUAL UNION ALL
    SELECT 'team'           , 'VARCHAR'    , 'IN' ,  2 FROM DUAL UNION ALL
    SELECT 'endCustomer'    , 'VARCHAR'    , 'IN' ,  3 FROM DUAL UNION ALL
    SELECT 'bizType'        , 'VARCHAR'    , 'IN' ,  4 FROM DUAL UNION ALL
    SELECT 'startDate'      , 'VARCHAR'    , 'IN' ,  5 FROM DUAL UNION ALL
    SELECT 'endDate'        , 'VARCHAR'    , 'IN' ,  6 FROM DUAL UNION ALL
    SELECT 'salesSite'      , 'VARCHAR'    , 'IN' ,  7 FROM DUAL UNION ALL
    SELECT 'itemId'         , 'VARCHAR'    , 'IN' ,  8 FROM DUAL UNION ALL
    SELECT 'version'        , 'VARCHAR'    , 'IN' ,  9 FROM DUAL UNION ALL
    SELECT 'qtyYn'          , 'VARCHAR'    , 'IN' , 10 FROM DUAL UNION ALL
    SELECT 'sesUserId'      , 'VARCHAR'    , 'IN' , 11 FROM DUAL UNION ALL
    SELECT 'userGroup'      , 'VARCHAR'    , 'IN' , 12 FROM DUAL UNION ALL
    SELECT 'plantSiteId'    , 'VARCHAR'    , 'IN' , 13 FROM DUAL UNION ALL
    SELECT 'o_rc1'          , 'CURSOR'     , 'OUT', 14 FROM DUAL UNION ALL
    SELECT 'o_rc2'          , 'CURSOR'     , 'OUT', 15 FROM DUAL UNION ALL
    SELECT 'o_rc3'          , 'CURSOR'     , 'OUT', 16 FROM DUAL UNION ALL
    SELECT 'o_rc4'          , 'CURSOR'     , 'OUT', 17 FROM DUAL UNION ALL
    SELECT 'o_rc5'          , 'CURSOR'     , 'OUT', 18 FROM DUAL UNION ALL
    SELECT 'o_result_cursor', 'PROC_RESULT', 'OUT', 19 FROM DUAL
);

COMMIT;
