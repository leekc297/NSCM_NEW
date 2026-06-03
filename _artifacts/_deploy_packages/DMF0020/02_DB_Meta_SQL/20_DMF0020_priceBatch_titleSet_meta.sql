/*=============================================================================================
 * File         : 20_DMF0020_priceBatch_titleSet_meta.sql
 * Description  : DMF0020 priceBatch / titleSet sheet 메타 등록 (Phase 2)
 *              :
 *              : 사용자 요구 (2026-06-03): "Price 일괄입력 / Grid Column Setting popup 실제 동작 구현"
 *              :
 *              : SP signatures (USER_ARGUMENTS 검증 완료):
 *              :   PriceBatch GET (P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP, 8 args):
 *              :     P_DIVISION_ID / P_FROM_YYYYMMDD / P_TO_YYYYMMDD / P_CREATED_BY /
 *              :     P_USER_ID / P_MNU_ID / O_RC1 / O_RESULT_CURSOR
 *              :   TitleSet GET (DMF0002_GET_TITLESET_POPUP, 7 args — standalone):
 *              :     P_PROGRAM_ID / P_SHEET_NAME / P_COLUMN_TYPE / P_USER_ID / P_DIVISION_ID / P_MENU_ID / O_CURSOR
 *              :
 *              : 멱등 (NOT EXISTS).
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-03
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- =============================================================================================
-- ① i18n MSG (PriceBatch + TitleSet API description)
-- =============================================================================================
INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT * FROM (
  SELECT 'MSG_API_DMF0020_PRICEBATCH_SEARCH' AS MSG_ID, 'KO' AS LANG_CD, 'Price 일괄입력 조회' AS MSG_NM, 'API' AS MSG_TP_CD, 'Y' AS USE_YN,
         'admin' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'admin' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE FROM DUAL UNION ALL
  SELECT 'MSG_API_DMF0020_TITLESET_SEARCH', 'KO', 'Grid Column Setting 조회', 'API', 'Y',
         'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
) s WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MSG_M x WHERE x.MSG_ID = s.MSG_ID AND x.LANG_CD = s.LANG_CD);

-- =============================================================================================
-- ② API_M
-- =============================================================================================
INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT * FROM (
  SELECT 'DMF0020_priceBatch_SEARCH' AS API_ID, 'PROC' AS API_TP_CD, 'MSG_API_DMF0020_PRICEBATCH_SEARCH' AS API_MSG_ID,
         'DMF0020 Price Batch Search' AS API_MSG_DESC, 'PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP' AS API_URL, 'Y' AS USE_YN,
         'admin' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'admin' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE FROM DUAL UNION ALL
  SELECT 'DMF0020_titleSet_SEARCH', 'PROC', 'MSG_API_DMF0020_TITLESET_SEARCH',
         'DMF0020 Grid Column Setting', 'DMF0002_GET_TITLESET_POPUP', 'Y',
         'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
) s WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M x WHERE x.API_ID = s.API_ID);

-- =============================================================================================
-- ③ MNU_BTN_MPG
-- =============================================================================================
INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT * FROM (
  SELECT 'DMF0020' AS MNU_ID, 'priceBatch' AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'DMF0020_priceBatch_SEARCH' AS API_ID, 'Y' AS USE_YN,
         'admin' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'admin' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE FROM DUAL UNION ALL
  SELECT 'DMF0020', 'titleSet', 'SEARCH', 'DMF0020_titleSet_SEARCH', 'Y',
         'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
) s WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M x
                      WHERE x.MNU_ID = s.MNU_ID AND x.SHT_NM = s.SHT_NM AND x.MNU_BTN_CD = s.MNU_BTN_CD);

-- =============================================================================================
-- ④ PROC_M (signature 정확 매핑)
-- =============================================================================================
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM IN (
  'PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP',
  'DMF0002_GET_TITLESET_POPUP'
);

INSERT ALL
  -- PriceBatch GET (8 args)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP', 'divisionId',    'IN',  'VARCHAR', 1, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP', 'fromYyyymmdd',  'IN',  'VARCHAR', 2, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP', 'toYyyymmdd',    'IN',  'VARCHAR', 3, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP', 'createdBy',     'IN',  'VARCHAR', 4, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP', 'sesUserId',     'IN',  'VARCHAR', 5, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP', 'mnuId',         'IN',  'VARCHAR', 6, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP', 'o_rc1',         'OUT', 'CURSOR',      7, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('PKG_DMF0020.P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP', 'o_result_cursor','OUT', 'PROC_RESULT', 8, 'admin', SYSDATE, 'admin', SYSDATE)
  -- TitleSet GET (7 args, standalone — PKG_NM 없음)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0002_GET_TITLESET_POPUP', 'programId',  'IN',  'VARCHAR', 1, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0002_GET_TITLESET_POPUP', 'sheetName',  'IN',  'VARCHAR', 2, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0002_GET_TITLESET_POPUP', 'columnType', 'IN',  'VARCHAR', 3, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0002_GET_TITLESET_POPUP', 'sesUserId',  'IN',  'VARCHAR', 4, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0002_GET_TITLESET_POPUP', 'divisionId', 'IN',  'VARCHAR', 5, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0002_GET_TITLESET_POPUP', 'mnuId',      'IN',  'VARCHAR', 6, 'admin', SYSDATE, 'admin', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DMF0002_GET_TITLESET_POPUP', 'o_rc1',      'OUT', 'CURSOR',  7, 'admin', SYSDATE, 'admin', SYSDATE)
SELECT * FROM DUAL;

-- =============================================================================================
-- ⑤ 권한 (GUEST 그룹에 신규 sheet 권한)
-- =============================================================================================
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', m.MNU_ID, m.SHT_NM, m.MNU_BTN_CD, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_ADM_MNU_BTN_MPG_M m
 WHERE m.MNU_ID = 'DMF0020' AND m.SHT_NM IN ('priceBatch', 'titleSet') AND m.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M x
      WHERE x.USER_GR_ID = 'GUEST' AND x.MNU_ID = m.MNU_ID
        AND x.SHT_NM = m.SHT_NM AND x.MNU_BTN_CD = m.MNU_BTN_CD
   );

COMMIT;

PROMPT === 검증: PriceBatch / TitleSet routing ===
DECLARE
  v_cur SYS_REFCURSOR;
  v_p VARCHAR2(200); v_c VARCHAR2(100); v_d VARCHAR2(50); v_t VARCHAR2(50); v_s NUMBER;
  v_n PLS_INTEGER;
BEGIN
  FOR sh IN (SELECT 'priceBatch' SHT FROM DUAL UNION ALL SELECT 'titleSet' FROM DUAL) LOOP
    v_n := 0;
    SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST('DMF0020', sh.SHT, 'SEARCH', v_cur);
    LOOP FETCH v_cur INTO v_p, v_c, v_d, v_t, v_s; EXIT WHEN v_cur%NOTFOUND; v_n := v_n + 1; END LOOP;
    CLOSE v_cur;
    DBMS_OUTPUT.PUT_LINE('  '||sh.SHT||' routing rows: '||v_n);
  END LOOP;
END;
/
