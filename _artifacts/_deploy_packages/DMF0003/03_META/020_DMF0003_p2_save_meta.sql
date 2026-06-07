/*=============================================================================================
 * File         : 020_DMF0003_p2_save_meta.sql
 * Description  : DMF0003 Phase 2 메타 augment — 메인 SAVE SP + Insert/Delete/Save buttons
 *              :   - 메인 SAVE SP: SCM_MGR.DMF0003_SAVE_MKT_FCST (standalone, 15 IN + 2 OUT)
 *              :                  archive line 8332~10549 (2,218 lines)
 *              :   - SAVE/INSERT/DELETE 버튼 라우팅 추가 (BTN_MPG)
 *              :   - SAVE API msg 추가 (BLOCK 1 i18n)
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-07
 *
 * 선행 조건   : 010_DMF0003_Registration.sql 적재 완료
 *===========================================================================================*/

SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DEFINE V_MENU_ID         = 'DMF0003'
DEFINE V_SHEET_NM        = 'main'
DEFINE V_USER_ID         = 'admin'
DEFINE V_PROC_SAVE       = 'DMF0003_SAVE_MKT_FCST'
DEFINE V_API_SAVE        = 'DMF0003_main_SAVE'
DEFINE V_API_SAVE_MSG    = 'MSG_API_DMF0003_MKTFCST_SAVE'


-- =============================================================================================
-- BLOCK 1 (augment): SAVE API i18n (KO/EN/CN)
-- =============================================================================================

DELETE FROM SCM_ADM_MSG_M WHERE MSG_ID = '&V_API_SAVE_MSG';

INSERT ALL
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SAVE_MSG', 'KO', '시장 수요 계획 저장', 'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SAVE_MSG', 'EN', 'Market Forecast Save', 'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                      CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_API_SAVE_MSG', 'CN', '市场需求计划保存', 'API', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 2 (augment): SAVE SP PROC_M
-- AS-IS DMF0003_SAVE_MKT_FCST (archive L8332~10549, 2,218 lines)
-- signature: 15 IN + 2 OUT = 17 row
-- =============================================================================================

DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = '&V_PROC_SAVE';

INSERT ALL
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'activeFlag',      'IN', 'VARCHAR',  1, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'divisionId',      'IN', 'VARCHAR',  2, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'projectCode',     'IN', 'VARCHAR',  3, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'scmSiteId',       'IN', 'VARCHAR',  4, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'itemId',          'IN', 'VARCHAR',  5, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'domExp',          'IN', 'VARCHAR',  6, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'fcstType',        'IN', 'VARCHAR',  7, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'incoterms',       'IN', 'VARCHAR',  8, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'measure',         'IN', 'VARCHAR',  9, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'plantSiteId',     'IN', 'VARCHAR', 10, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'yyyymmdd',        'IN', 'VARCHAR', 11, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'qty',             'IN', 'VARCHAR', 12, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'createdBy',       'IN', 'VARCHAR', 13, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'asFromSite',      'IN', 'VARCHAR', 14, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'bucket',          'IN', 'VARCHAR', 15, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'o_rc1',           'OUT', 'CURSOR',      16, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD,
                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_PROC_SAVE', 'o_result_cursor', 'OUT', 'PROC_RESULT', 17, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 5 (augment): SAVE API
-- =============================================================================================

DELETE FROM SCM_ADM_API_M WHERE API_ID = '&V_API_SAVE';

INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES ('&V_API_SAVE', 'PROC', '&V_API_SAVE_MSG',
        'DMF0003 Market Forecast Save', '&V_PROC_SAVE', 'Y',
        '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);


-- =============================================================================================
-- BLOCK 6 (augment): SAVE/INSERT/DELETE BTN_MPG
-- ★ MNU_BTN_CD 표준: SAVE / INSERT / DELETE (룰 12 §13)
--    INSERT / DELETE 도 SAVE SP 호출 (CRUD_TYPE 으로 동작 구분 — ACTIVE_FLAG 'I'/'U'/'D')
-- =============================================================================================

DELETE FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID' AND MNU_BTN_CD IN ('SAVE', 'INSERT', 'DELETE');

INSERT ALL
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_ID', '&V_SHEET_NM', 'SAVE',   '&V_API_SAVE', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_ID', '&V_SHEET_NM', 'INSERT', '&V_API_SAVE', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('&V_MENU_ID', '&V_SHEET_NM', 'DELETE', '&V_API_SAVE', 'Y',
            '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


-- =============================================================================================
-- BLOCK 7 (augment): SAVE/INSERT/DELETE 버튼 권한
-- =============================================================================================

DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID' AND MNU_BTN_CD IN ('SAVE', 'INSERT', 'DELETE');

INSERT ALL
  INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('ADMIN',       'DMF0003', 'main', 'SAVE',   'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('ADMIN',       'DMF0003', 'main', 'INSERT', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('ADMIN',       'DMF0003', 'main', 'DELETE', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DEMAND_USER', 'DMF0003', 'main', 'SAVE',   'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DEMAND_USER', 'DMF0003', 'main', 'INSERT', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                       CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('DEMAND_USER', 'DMF0003', 'main', 'DELETE', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;


COMMIT;


-- =============================================================================================
-- 검증
-- =============================================================================================
PROMPT
PROMPT === DMF0003 Phase 2 SAVE 메타 검증 ===
SELECT '1.PROC_SAVE'  AS K, COUNT(*) AS CNT, 17 AS EXPECT FROM SCM_ADM_PROC_M           WHERE PROC_NM = '&V_PROC_SAVE'
UNION ALL
SELECT '2.API_SAVE',     COUNT(*),  1            FROM SCM_ADM_API_M             WHERE API_ID = '&V_API_SAVE'
UNION ALL
SELECT '3.BTN_MPG',      COUNT(*),  3            FROM SCM_ADM_MNU_BTN_MPG_M     WHERE MNU_ID = '&V_MENU_ID' AND MNU_BTN_CD IN ('SAVE','INSERT','DELETE')
UNION ALL
SELECT '4.BTN_PERM',     COUNT(*),  6            FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID' AND MNU_BTN_CD IN ('SAVE','INSERT','DELETE')
UNION ALL
SELECT '5.I18N_SAVE',    COUNT(*),  3            FROM SCM_ADM_MSG_M             WHERE MSG_ID = '&V_API_SAVE_MSG'
ORDER BY 1;


UNDEFINE V_MENU_ID V_SHEET_NM V_USER_ID V_PROC_SAVE V_API_SAVE V_API_SAVE_MSG
