/*=====================================================================================================================================================
 * File        : 04_proc_m_api_btn_wiring.sql
 * Program ID  : DMF0082 Excel Upload — 메타 배선 (PROC_M / API_M / BTN_MPG / USER_GR)
 * Description : DMF0082 Excel Upload 3 SP 의 실행 메타 멱등 등록 (전량 MERGE — 재실행 안전)
 *
 *               ⚠️ 본 파일은 "파일 산출물"이며 DB 에 적용하지 않았음 (작업 지시: DB 적용 절대 금지).
 *
 * 배선 구성 (기존 DMF0014/DMF0074 Excel Upload 2-Step 표준 + 기존 DMF0082 배선 실측 준거):
 *   1) SCM_ADM_PROC_M          : 3 SP 시그니처 positional 등록 (변환본 시그니처와 1:1 — proc-meta-signature-match)
 *   2) SCM_ADM_API_M           : UPLOAD 계열 4 API (main_UPLOAD / upload_SAVE / GET_UPLOAD_DATA / GET_CURRENT)
 *   3) SCM_ADM_MNU_BTN_MPG_M   : MNU_ID='DMF0082', SHT_NM='fcstNPrice' 버튼 4종
 *   4) SCM_ADM_USER_GR_MNU_BTN_MPG_M : 업로드 3버튼 = ADMIN / DM ADMIN 2그룹 (Viewer 제외)
 *                                      SEARCH_CURRENT = ADMIN / DM ADMIN / DM Viewer (기존 SEARCH 와 동일 3그룹)
 *
 * COL_NM 규칙 (실측 준거):
 *   - GET_MAIN_DATA_CURRENT : 기존 DMF0082_GET_MAIN_DATA PROC_M 스타일 (divisionId/team/endCustomer/...)
 *                             + p_created_by 는 BE 자동주입 명칭 sesUserId (PKG_DMF0082.P_DMF0082_GET_MAIN_DATA 준거)
 *   - EXCEL_UPLOAD / GET_EXCEL_UPLOAD_DATA : DMF0014/0074 upload 표준 (mode NUMBER / createdBy — FcstUploadModal 이 사용자 전달)
 *   - OUT: o_rc* = CURSOR / o_result_cursor = PROC_RESULT
 * 감사 컬럼 = 'admin' (hook #98 §1.1 — claude ID 금지)
 *=====================================================================================================================================================
 * Date         In Charge    Description
 *=====================================================================================================================================================
 * 2026-07-12   Claude       최초 작성
 *===================================================================================================================================================*/

--=====================================================================================================================================================
-- 1. SCM_ADM_PROC_M — 3 SP 시그니처 (positional = 변환본 시그니처 1:1)
--=====================================================================================================================================================

-- 1-1. DMF0082_GET_MAIN_DATA_CURRENT (12 IN + 5 CURSOR + 1 PROC_RESULT = 18)
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T
USING (
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT' AS PROC_NM, 'divisionId'      AS COL_NM, 'VARCHAR'     AS DATA_TP_CD, 'IN'  AS COL_TP_CD, 1  AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'team'           , 'VARCHAR'    , 'IN' , 2  FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'endCustomer'    , 'VARCHAR'    , 'IN' , 3  FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'bizType'        , 'VARCHAR'    , 'IN' , 4  FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'startDate'      , 'VARCHAR'    , 'IN' , 5  FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'endDate'        , 'VARCHAR'    , 'IN' , 6  FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'salesSite'      , 'VARCHAR'    , 'IN' , 7  FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'itemId'         , 'VARCHAR'    , 'IN' , 8  FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'version'        , 'VARCHAR'    , 'IN' , 9  FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'qtyYn'          , 'VARCHAR'    , 'IN' , 10 FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'sesUserId'      , 'VARCHAR'    , 'IN' , 11 FROM DUAL UNION ALL   /* p_created_by = BE 세션 자동주입 */
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'userGroup'      , 'VARCHAR'    , 'IN' , 12 FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'o_rc1'          , 'CURSOR'     , 'OUT', 13 FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'o_rc2'          , 'CURSOR'     , 'OUT', 14 FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'o_rc3'          , 'CURSOR'     , 'OUT', 15 FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'o_rc4'          , 'CURSOR'     , 'OUT', 16 FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'o_rc5'          , 'CURSOR'     , 'OUT', 17 FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_MAIN_DATA_CURRENT', 'o_result_cursor', 'PROC_RESULT', 'OUT', 18 FROM DUAL
) S
ON (T.PROC_NM = S.PROC_NM AND T.SORT_ORD = S.SORT_ORD)
WHEN MATCHED THEN UPDATE SET
    T.COL_NM = S.COL_NM, T.DATA_TP_CD = S.DATA_TP_CD, T.COL_TP_CD = S.COL_TP_CD
  , T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);

-- 1-2. DMF0082_GET_EXCEL_UPLOAD_DATA (1 IN + 2 CURSOR + 1 PROC_RESULT = 4)
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T
USING (
    SELECT 'DMF0082_GET_EXCEL_UPLOAD_DATA' AS PROC_NM, 'createdBy'       AS COL_NM, 'VARCHAR'     AS DATA_TP_CD, 'IN'  AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_EXCEL_UPLOAD_DATA', 'o_rc1'          , 'CURSOR'     , 'OUT', 2 FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_EXCEL_UPLOAD_DATA', 'o_rc2'          , 'CURSOR'     , 'OUT', 3 FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_EXCEL_UPLOAD_DATA', 'o_result_cursor', 'PROC_RESULT', 'OUT', 4 FROM DUAL
) S
ON (T.PROC_NM = S.PROC_NM AND T.SORT_ORD = S.SORT_ORD)
WHEN MATCHED THEN UPDATE SET
    T.COL_NM = S.COL_NM, T.DATA_TP_CD = S.DATA_TP_CD, T.COL_TP_CD = S.COL_TP_CD
  , T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);

-- 1-3. DMF0082_EXCEL_UPLOAD (2 IN + 1 PROC_RESULT = 3, mode = NUMBER — Excel Upload 2-Step 표준)
MERGE INTO SCM_MGR.SCM_ADM_PROC_M T
USING (
    SELECT 'DMF0082_EXCEL_UPLOAD' AS PROC_NM, 'mode'           AS COL_NM, 'NUMBER'      AS DATA_TP_CD, 'IN'  AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0082_EXCEL_UPLOAD', 'createdBy'      , 'VARCHAR'    , 'IN' , 2 FROM DUAL UNION ALL
    SELECT 'DMF0082_EXCEL_UPLOAD', 'o_result_cursor', 'PROC_RESULT', 'OUT', 3 FROM DUAL
) S
ON (T.PROC_NM = S.PROC_NM AND T.SORT_ORD = S.SORT_ORD)
WHEN MATCHED THEN UPDATE SET
    T.COL_NM = S.COL_NM, T.DATA_TP_CD = S.DATA_TP_CD, T.COL_TP_CD = S.COL_TP_CD
  , T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);

--=====================================================================================================================================================
-- 2. SCM_ADM_API_M — UPLOAD 계열 4 API (API_URL = SP 명 — feedback_api_m_diagnosis_by_api_id)
--    API_MSG_ID = '-' (기존 DMF0082 API 행 스타일 준거)
--=====================================================================================================================================================
MERGE INTO SCM_MGR.SCM_ADM_API_M T
USING (
    SELECT 'DMF0082_main_UPLOAD'     AS API_ID, 'PROC'        AS API_TP_CD, '-' AS API_MSG_ID
         , 'DMF0082 Fcst&Price Excel Upload 검증분류 (mode=0)' AS API_MSG_DESC
         , 'DMF0082_EXCEL_UPLOAD'    AS API_URL FROM DUAL UNION ALL
    SELECT 'DMF0082_upload_SAVE'     , 'PROC'       , '-'
         , 'DMF0082 Excel Upload Save (mode>0 게이트)'
         , 'DMF0082_EXCEL_UPLOAD'    FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_UPLOAD_DATA' , 'PROC_SELECT', '-'
         , 'DMF0082 Excel Upload 월별→Daily 전개 조회'
         , 'DMF0082_GET_EXCEL_UPLOAD_DATA' FROM DUAL UNION ALL
    SELECT 'DMF0082_GET_CURRENT'     , 'PROC_SELECT', '-'
         , 'DMF0082 Current 버전 메인 조회'
         , 'DMF0082_GET_MAIN_DATA_CURRENT' FROM DUAL
) S
ON (T.API_ID = S.API_ID)
WHEN MATCHED THEN UPDATE SET
    T.API_TP_CD = S.API_TP_CD, T.API_MSG_ID = S.API_MSG_ID, T.API_MSG_DESC = S.API_MSG_DESC
  , T.API_URL = S.API_URL, T.USE_YN = 'Y'
  , T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    (S.API_ID, S.API_TP_CD, S.API_MSG_ID, S.API_MSG_DESC, S.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

--=====================================================================================================================================================
-- 3. SCM_ADM_MNU_BTN_MPG_M — DMF0082 / fcstNPrice 버튼 4종 (DMF0014 UPLOAD/UPLOAD_SAVE 표준 준거)
--=====================================================================================================================================================
MERGE INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M T
USING (
    SELECT 'DMF0082' AS MNU_ID, 'fcstNPrice' AS SHT_NM, 'UPLOAD'         AS MNU_BTN_CD, 'DMF0082_main_UPLOAD'     AS API_ID FROM DUAL UNION ALL
    SELECT 'DMF0082', 'fcstNPrice', 'UPLOAD_SAVE'   , 'DMF0082_upload_SAVE'     FROM DUAL UNION ALL
    SELECT 'DMF0082', 'fcstNPrice', 'UPLOAD_DATA'   , 'DMF0082_GET_UPLOAD_DATA' FROM DUAL UNION ALL
    SELECT 'DMF0082', 'fcstNPrice', 'SEARCH_CURRENT', 'DMF0082_GET_CURRENT'     FROM DUAL
) S
ON (T.MNU_ID = S.MNU_ID AND T.SHT_NM = S.SHT_NM AND T.MNU_BTN_CD = S.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET
    T.API_ID = S.API_ID, T.USE_YN = 'Y'
  , T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    (S.MNU_ID, S.SHT_NM, S.MNU_BTN_CD, S.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

--=====================================================================================================================================================
-- 4. SCM_ADM_USER_GR_MNU_BTN_MPG_M — 버튼 권한
--    업로드 3버튼(UPLOAD/UPLOAD_SAVE/UPLOAD_DATA) = ADMIN / DM ADMIN (DM Viewer 제외)
--    SEARCH_CURRENT = ADMIN / DM ADMIN / DM Viewer (기존 SEARCH 권한 3그룹과 동일 — 실측 준거)
--=====================================================================================================================================================
MERGE INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M T
USING (
    SELECT 'ADMIN'     AS USER_GR_ID, 'DMF0082' AS MNU_ID, 'fcstNPrice' AS SHT_NM, 'UPLOAD'         AS MNU_BTN_CD FROM DUAL UNION ALL
    SELECT 'ADMIN'     , 'DMF0082', 'fcstNPrice', 'UPLOAD_SAVE'    FROM DUAL UNION ALL
    SELECT 'ADMIN'     , 'DMF0082', 'fcstNPrice', 'UPLOAD_DATA'    FROM DUAL UNION ALL
    SELECT 'ADMIN'     , 'DMF0082', 'fcstNPrice', 'SEARCH_CURRENT' FROM DUAL UNION ALL
    SELECT 'DM ADMIN'  , 'DMF0082', 'fcstNPrice', 'UPLOAD'         FROM DUAL UNION ALL
    SELECT 'DM ADMIN'  , 'DMF0082', 'fcstNPrice', 'UPLOAD_SAVE'    FROM DUAL UNION ALL
    SELECT 'DM ADMIN'  , 'DMF0082', 'fcstNPrice', 'UPLOAD_DATA'    FROM DUAL UNION ALL
    SELECT 'DM ADMIN'  , 'DMF0082', 'fcstNPrice', 'SEARCH_CURRENT' FROM DUAL UNION ALL
    SELECT 'DM Viewer' , 'DMF0082', 'fcstNPrice', 'SEARCH_CURRENT' FROM DUAL   /* 조회 버튼만 Viewer 허용 */
) S
ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID AND T.SHT_NM = S.SHT_NM AND T.MNU_BTN_CD = S.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET
    T.USE_YN = 'Y'
  , T.LAST_UPDATED_BY = 'admin', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT
    (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES
    (S.USER_GR_ID, S.MNU_ID, S.SHT_NM, S.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

--=====================================================================================================================================================
-- (검증용 SELECT — 적용 후 실행 권장)
--=====================================================================================================================================================
-- SELECT PROC_NM, SORT_ORD, COL_NM, DATA_TP_CD, COL_TP_CD FROM SCM_MGR.SCM_ADM_PROC_M
--  WHERE PROC_NM IN ('DMF0082_GET_MAIN_DATA_CURRENT','DMF0082_GET_EXCEL_UPLOAD_DATA','DMF0082_EXCEL_UPLOAD') ORDER BY PROC_NM, SORT_ORD;
-- SELECT * FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'DMF0082%';
-- SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0082';
-- SELECT * FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0082' ORDER BY USER_GR_ID, MNU_BTN_CD;
-- PROC_M ↔ ALL_ARGUMENTS positional diff (proc-meta-signature-match §3):
-- SELECT NVL(P.PROC_NM, A.OBJECT_NAME) PROC_NM, NVL(P.SORT_ORD, A.POSITION) POS, P.COL_NM, A.ARGUMENT_NAME, A.DATA_TYPE, A.IN_OUT
--   FROM (SELECT * FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM LIKE 'DMF0082%') P
--   FULL OUTER JOIN (SELECT OBJECT_NAME, POSITION, ARGUMENT_NAME, DATA_TYPE, IN_OUT FROM ALL_ARGUMENTS
--                     WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('DMF0082_GET_MAIN_DATA_CURRENT','DMF0082_GET_EXCEL_UPLOAD_DATA','DMF0082_EXCEL_UPLOAD')) A
--     ON P.PROC_NM = A.OBJECT_NAME AND P.SORT_ORD = A.POSITION
--  ORDER BY 1, 2;
