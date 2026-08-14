-- ============================================================================
-- [E20260813-EXCELFORM] DMF0082 Excel Form 조회 배선 + 안내 메시지 (멱등)
--   감사컬럼 = 'admin' 고정 (hook: 메타 감사컬럼 admin only)
--   ⚠ 신규 시트를 만들지 않는다 — 기존 MAIN 시트(FcstNPrice)에 버튼코드 FORM_DATA 를 추가한다.
--      (SHEET_COLUMNS 이중 소스를 만들지 않기 위함. 양식 컬럼 정의의 정본은 SHEET_COLUMNS + HEADER_CONTENT)
-- ============================================================================

-- 1) API_M -------------------------------------------------------------------
MERGE INTO SCM_MGR.SCM_ADM_API_M T
USING (SELECT 'DMF0082_GET_EXCEL_FORM' AS API_ID FROM DUAL) S
   ON (T.API_ID = S.API_ID)
WHEN MATCHED THEN UPDATE
   SET T.API_TP_CD        = 'PROC_SELECT'
     , T.API_URL          = 'PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA'
     , T.API_MSG_DESC     = 'DMF0082 Excel Form 조회 (조회조건 기준 정적컬럼 x 입력가능 Measure)'
     , T.USE_YN           = 'Y'
     , T.LAST_UPDATED_BY  = 'admin'
     , T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
INSERT (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN
      , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ('DMF0082_GET_EXCEL_FORM', 'PROC_SELECT', '-'
      , 'DMF0082 Excel Form 조회 (조회조건 기준 정적컬럼 x 입력가능 Measure)'
      , 'PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA', 'Y'
      , 'admin', SYSDATE, 'admin', SYSDATE);

-- 2) BTN_MPG -----------------------------------------------------------------
MERGE INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M T
USING (SELECT 'DMF0082' AS MNU_ID, 'FcstNPrice' AS SHT_NM, 'FORM_DATA' AS MNU_BTN_CD FROM DUAL) S
   ON (T.MNU_ID = S.MNU_ID AND T.SHT_NM = S.SHT_NM AND T.MNU_BTN_CD = S.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE
   SET T.API_ID           = 'DMF0082_GET_EXCEL_FORM'
     , T.USE_YN           = 'Y'
     , T.LAST_UPDATED_BY  = 'admin'
     , T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ('DMF0082', 'FcstNPrice', 'FORM_DATA', 'DMF0082_GET_EXCEL_FORM', 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

-- 3) 권한그룹 — 기존 UPLOAD_DATA(양식 미리보기) 보유 그룹과 동일하게 부여 ---------
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
       (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT G.USER_GR_ID, G.MNU_ID, G.SHT_NM, 'FORM_DATA', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M G
 WHERE G.MNU_ID = 'DMF0082' AND G.SHT_NM = 'FcstNPrice' AND G.MNU_BTN_CD = 'UPLOAD_DATA'
   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
                    WHERE X.USER_GR_ID = G.USER_GR_ID AND X.MNU_ID = G.MNU_ID
                      AND X.SHT_NM = G.SHT_NM AND X.MNU_BTN_CD = 'FORM_DATA');

-- 4) PROC_M — 세트 교체 (키가 PROC_NM 이라 순번 꼬임 방지: DELETE 후 INSERT) -------
--    ⚠ COL_NM 은 P_DMF0082_GET_MAIN_DATA 의 1~16 과 **문자열 동일**해야 한다.
--      FE 가 메인 조회 payload 를 가공 없이 그대로 재사용하기 위한 전제.
DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA';

INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'PKG_DMF0082.P_DMF0082_GET_EXCEL_FORM_DATA', COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'divisionId'      COL_NM, 'VARCHAR'      DATA_TP_CD, 'IN'  COL_TP_CD,  1 SORT_ORD FROM DUAL UNION ALL
    SELECT 'deptId'         , 'VARCHAR'     , 'IN' ,  2 FROM DUAL UNION ALL
    SELECT 'endCustomer'    , 'VARCHAR'     , 'IN' ,  3 FROM DUAL UNION ALL
    SELECT 'bizType'        , 'VARCHAR'     , 'IN' ,  4 FROM DUAL UNION ALL
    SELECT 'fromYyyymmdd'   , 'VARCHAR'     , 'IN' ,  5 FROM DUAL UNION ALL
    SELECT 'toYyyymmdd'     , 'VARCHAR'     , 'IN' ,  6 FROM DUAL UNION ALL
    SELECT 'salesSite'      , 'VARCHAR'     , 'IN' ,  7 FROM DUAL UNION ALL
    SELECT 'itemId'         , 'VARCHAR'     , 'IN' ,  8 FROM DUAL UNION ALL
    SELECT 'versionType'    , 'VARCHAR'     , 'IN' ,  9 FROM DUAL UNION ALL
    SELECT 'qtyYn'          , 'VARCHAR'     , 'IN' , 10 FROM DUAL UNION ALL
    SELECT 'sesUserId'      , 'VARCHAR'     , 'IN' , 11 FROM DUAL UNION ALL
    SELECT 'userGroup'      , 'VARCHAR'     , 'IN' , 12 FROM DUAL UNION ALL
    SELECT 'plantSiteId'    , 'VARCHAR'     , 'IN' , 13 FROM DUAL UNION ALL
    SELECT 'projectCode'    , 'VARCHAR'     , 'IN' , 14 FROM DUAL UNION ALL
    SELECT 'owner'          , 'VARCHAR'     , 'IN' , 15 FROM DUAL UNION ALL
    SELECT 'senderCode'     , 'VARCHAR'     , 'IN' , 16 FROM DUAL UNION ALL
    SELECT 'o_rc1'          , 'CURSOR'      , 'OUT', 17 FROM DUAL UNION ALL
    SELECT 'o_result_cursor', 'PROC_RESULT' , 'OUT', 18 FROM DUAL
  );

-- 5) 안내 메시지 신규 채번 (hook #114 3점 동기 중 DB 축) --------------------------
--    MSG00705('업로드된 Excel 데이터가 없습니다')는 신 계약(조회조건 기준 조회)과 의미가 반대라 재사용 금지.
MERGE INTO SCM_MGR.SCM_ADM_MSG_M T
USING (SELECT 'MSG00718' MSG_ID, 'KO' LANG_CD, '조회 조건에 해당하는 데이터가 없습니다.' MSG_NM FROM DUAL UNION ALL
       SELECT 'MSG00718', 'EN', 'No data found for the search conditions.' FROM DUAL UNION ALL
       SELECT 'MSG00718', 'CN', '没有符合查询条件的数据。' FROM DUAL) S
   ON (T.MSG_ID = S.MSG_ID AND T.LANG_CD = S.LANG_CD)
WHEN MATCHED THEN UPDATE
   SET T.MSG_NM = S.MSG_NM, T.USE_YN = 'Y', T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN
INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (S.MSG_ID, S.LANG_CD, S.MSG_NM, 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;
