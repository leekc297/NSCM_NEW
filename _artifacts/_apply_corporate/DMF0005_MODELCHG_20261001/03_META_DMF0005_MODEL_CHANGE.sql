-- =====================================================================================================
-- DMF0005 Model Code Change — META (클라우드 동기용 · 멱등 · 비파괴 · WHEN NOT MATCHED 만)
--   대상 SP : PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP (P_DATA CLOB / P_USER_ID / O_RESULT_CURSOR)
--   AS-IS   : DMF0005_SaleSite_PjtModelMapping.btnModelChange (Division 40 + 그룹 ADMIN·DM ADMIN·SCM PI ADMIN 만 노출)
--             → POPUP DMF0005_ModelCodeChange.SaveData → DM.DMF0005_SAVE_MODEL_CHANGE_POPUP
--   값 원천 : 사내 ZIOUI1 실상태(2026-10-01 13:0x 실측) 그대로 — 사내는 타 작업 경로로 기등록(API_M 11:07 · 버튼 11:18 ·
--             PROC_M 11:22). 본 파일은 사내 기준 no-op, 클라우드에 같은 행을 싣는다.
--             (1차본은 다른 이름 버튼을 만들어 중복 → 04_ROLLBACK_META_DUP 로 사내 원복 완료)
--   권한    : 그룹 마스터 실재 그룹만 (사내: ADMIN / DM ADMIN / 'SCM PI Admin' — 대소문자 주의)
--   LBL/MSG 신규 채번 없음 (작업 범위 외)
-- =====================================================================================================

-- [1] API_M
MERGE INTO SCM_ADM_API_M T
USING (SELECT 'P_DMF0005_MODELCHANGE_SAVE'                    AS API_ID
            , 'PROC_SAVE'                                     AS API_TP_CD
            , '-'                                             AS API_MSG_ID
            , 'Model Code Change 저장'                         AS API_MSG_DESC
            , 'PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP' AS API_URL
         FROM DUAL) S
   ON (T.API_ID = S.API_ID)
 WHEN NOT MATCHED THEN
      INSERT (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
      VALUES (S.API_ID, S.API_TP_CD, S.API_MSG_ID, S.API_MSG_DESC, S.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

-- [2] PROC_M (ALL_ARGUMENTS position 1~3 = SORT_ORD)
MERGE INTO SCM_ADM_PROC_M T
USING (SELECT 'PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP' AS PROC_NM, 'data'            AS COL_NM, 'CLOB'        AS DATA_TP_CD, 'IN'  AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL UNION ALL
       SELECT 'PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP'        , 'sesUserId'                , 'VARCHAR'                    , 'IN'               , 2             FROM DUAL UNION ALL
       SELECT 'PKG_DMF0005.P_DMF0005_SAVE_MODEL_CHANGE_POPUP'        , 'O_RESULT_CURSOR'          , 'PROC_RESULT'                , 'OUT'              , 3             FROM DUAL) S
   ON (T.PROC_NM = S.PROC_NM AND T.COL_NM = S.COL_NM AND T.COL_TP_CD = S.COL_TP_CD)
 WHEN NOT MATCHED THEN
      INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
      VALUES (S.PROC_NM, S.COL_NM, S.DATA_TP_CD, S.COL_TP_CD, S.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE);

-- [3] MNU_BTN_MPG_M — 화면 버튼(팝업 오픈, API 없음) + 팝업 시트 저장
MERGE INTO SCM_ADM_MNU_BTN_MPG_M T
USING (SELECT 'DMF0005' AS MNU_ID, 'production'  AS SHT_NM, 'MODEL_CHANGE' AS MNU_BTN_CD, CAST(NULL AS VARCHAR2(50)) AS API_ID FROM DUAL UNION ALL
       SELECT 'DMF0005'          , 'modelChange'           , 'SAVE'                      , 'P_DMF0005_MODELCHANGE_SAVE'          FROM DUAL) S
   ON (T.MNU_ID = S.MNU_ID AND T.SHT_NM = S.SHT_NM AND T.MNU_BTN_CD = S.MNU_BTN_CD)
 WHEN NOT MATCHED THEN
      INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
      VALUES (S.MNU_ID, S.SHT_NM, S.MNU_BTN_CD, S.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

-- [4] USER_GR_MNU_BTN_MPG_M — 그룹 마스터 실재 그룹만
MERGE INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M T
USING (SELECT M.USER_GR_ID, B.MNU_ID, B.SHT_NM, B.MNU_BTN_CD
         FROM SCM_ADM_USER_GR_M M
        CROSS JOIN (SELECT 'DMF0005' AS MNU_ID, 'production'  AS SHT_NM, 'MODEL_CHANGE' AS MNU_BTN_CD FROM DUAL UNION ALL
                    SELECT 'DMF0005'          , 'modelChange'           , 'SAVE'                       FROM DUAL) B
        WHERE M.USER_GR_ID IN ('ADMIN', 'DM ADMIN', 'SCM PI Admin')) S
   ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID AND T.SHT_NM = S.SHT_NM AND T.MNU_BTN_CD = S.MNU_BTN_CD)
 WHEN NOT MATCHED THEN
      INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
      VALUES (S.USER_GR_ID, S.MNU_ID, S.SHT_NM, S.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;
