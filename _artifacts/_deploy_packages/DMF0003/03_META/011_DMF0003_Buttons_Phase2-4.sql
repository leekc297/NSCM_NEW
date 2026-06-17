/*=============================================================================================
 * File         : 011_DMF0003_Buttons_Phase2-4.sql
 * Description  : DMF0003 (Market Forecast) — UI 동적 속성관리 hook §3 (Menu Button) 보강
 *              :   - Phase 1 (010) 에 SEARCH 1건만 등록되어 있음
 *              :   - Phase 2~4 + custom 4종 일괄 등록 (사용자 결정 2026-06-15 "전체 함께 등록")
 *              :   - 등록 후 admin SYS0009 에서 USE_YN 토글로 화면 즉시 반영
 *              :
 *              : 등록 인벤토리 (총 10건 + custom 3건 = 13건, SEARCH 는 010 에서 이미 등록):
 *              :   표준 CRUD 6: INSERT / SAVE / DELETE / EXCEL / SORT / FILTER
 *              :   custom 3   : COLUMN_SETUP / MEASURE_SELECT / MASTER_CHG
 *              :
 *              : 7-BLOCK 표준 (010 패턴 그대로):
 *              :   1. i18n            (SCM_ADM_MSG_M)        — API_MSG (KO/EN/CN 3 lang × 13 btn = 39 행)
 *              :   2. API             (SCM_ADM_API_M)        — 13 API
 *              :   3. MNU_BTN_MPG     (SCM_ADM_MNU_BTN_MPG_M) — 13 btn (멱등 NOT EXISTS)
 *              :   4. 검증            (COUNT)
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-15
 * Plan         : C:\Users\ejene\.claude\plans\dmf0003-jazzy-ullman.md
 *
 * 관련 hook    : Doc/_rules_v2/hooks/ui-dynamic-property-management.md §3
 *              : Doc/_rules_v2/hooks/menu-button-dynamic-fetch.md §3
 *              :
 * 사전 조건   : 010_DMF0003_Registration.sql 실행 완료 (메뉴 + Phase 1 SEARCH 등록)
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DEFINE V_MENU_ID = 'DMF0003'
DEFINE V_SHT_NM  = 'main'
DEFINE V_USER_ID = 'admin'


-- =============================================================================================
-- BLOCK 1: i18n (SCM_ADM_MSG_M) — 13 API × KO/EN/CN = 39 행 (멱등)
-- =============================================================================================

INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, 'API', 'Y',
       '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0003_MAIN_INSERT'          MSG_ID, 'KO' LANG_CD, '시장 수요 계획 추가'      MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_INSERT',                 'EN',         'Market Forecast Insert'         FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_INSERT',                 'CN',         '市场需求计划 添加'              FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_SAVE',                   'KO',         '시장 수요 계획 저장'            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_SAVE',                   'EN',         'Market Forecast Save'           FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_SAVE',                   'CN',         '市场需求计划 保存'              FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_DELETE',                 'KO',         '시장 수요 계획 삭제'            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_DELETE',                 'EN',         'Market Forecast Delete'         FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_DELETE',                 'CN',         '市场需求计划 删除'              FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_EXCEL',                  'KO',         '시장 수요 계획 엑셀'            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_EXCEL',                  'EN',         'Market Forecast Excel'          FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_EXCEL',                  'CN',         '市场需求计划 Excel'             FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_SORT',                   'KO',         '시장 수요 계획 정렬'            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_SORT',                   'EN',         'Market Forecast Sort'           FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_SORT',                   'CN',         '市场需求计划 排序'              FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_FILTER',                 'KO',         '시장 수요 계획 필터'            FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_FILTER',                 'EN',         'Market Forecast Filter'         FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_FILTER',                 'CN',         '市场需求计划 筛选'              FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_COLUMN_SETUP',           'KO',         '컬럼 표시 설정'                FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_COLUMN_SETUP',           'EN',         'Column Setup'                   FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_COLUMN_SETUP',           'CN',         '列设置'                         FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_MEASURE_SELECT',         'KO',         'Measure 선택'                   FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_MEASURE_SELECT',         'EN',         'Measure Select'                 FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_MEASURE_SELECT',         'CN',         '指标选择'                       FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_MASTER_CHG',             'KO',         'Master Change'                  FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_MASTER_CHG',             'EN',         'Master Change'                  FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0003_MAIN_MASTER_CHG',             'CN',         '主数据变更'                     FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_MSG_M E
    WHERE E.MSG_ID = NEW.MSG_ID AND E.LANG_CD = NEW.LANG_CD
 );


-- =============================================================================================
-- BLOCK 2: API 등록 (SCM_ADM_API_M) — 9 신규 API (Phase 1 SEARCH 제외)
--   API_URL 은 향후 SP 작성 시 정확한 PROC_NM 으로 교체 (Phase 2~4 진행 시).
--   현재는 SEARCH SP redirect 또는 무동작 stub (admin USE_YN='Y' 만 의미).
-- =============================================================================================

INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.API_ID, 'PROC', NEW.MSG_ID, NEW.DESC_TXT, NEW.API_URL, 'Y',
       '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
  FROM (
    SELECT 'DMF0003_main_INSERT'         API_ID, 'MSG_API_DMF0003_MAIN_INSERT'         MSG_ID, 'DMF0003 Insert'         DESC_TXT, 'DMF0003_GET_MKT_FCST_DATA' API_URL FROM DUAL UNION ALL
    SELECT 'DMF0003_main_SAVE',                  'MSG_API_DMF0003_MAIN_SAVE',                  'DMF0003 Save',                   'DMF0003_SAVE_MKT_FCST'              FROM DUAL UNION ALL
    SELECT 'DMF0003_main_DELETE',                'MSG_API_DMF0003_MAIN_DELETE',                'DMF0003 Delete',                 'DMF0003_SAVE_MKT_FCST'              FROM DUAL UNION ALL
    SELECT 'DMF0003_main_EXCEL',                 'MSG_API_DMF0003_MAIN_EXCEL',                 'DMF0003 Excel',                  'DMF0003_GET_MKT_FCST_DATA'          FROM DUAL UNION ALL
    SELECT 'DMF0003_main_SORT',                  'MSG_API_DMF0003_MAIN_SORT',                  'DMF0003 Sort',                   'DMF0003_GET_MKT_FCST_DATA'          FROM DUAL UNION ALL
    SELECT 'DMF0003_main_FILTER',                'MSG_API_DMF0003_MAIN_FILTER',                'DMF0003 Filter',                 'DMF0003_GET_MKT_FCST_DATA'          FROM DUAL UNION ALL
    SELECT 'DMF0003_main_COLUMN_SETUP',          'MSG_API_DMF0003_MAIN_COLUMN_SETUP',          'DMF0003 Column Setup',           'DMF0003_GET_MKT_FCST_DATA'          FROM DUAL UNION ALL
    SELECT 'DMF0003_main_MEASURE_SELECT',        'MSG_API_DMF0003_MAIN_MEASURE_SELECT',        'DMF0003 Measure Select',         'DMF0003_GET_MKT_FCST_DATA'          FROM DUAL UNION ALL
    SELECT 'DMF0003_main_MASTER_CHG',            'MSG_API_DMF0003_MAIN_MASTER_CHG',            'DMF0003 Master Change',          'DMF0003_GET_MKT_FCST_DATA'          FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_API_M E WHERE E.API_ID = NEW.API_ID
 );


-- =============================================================================================
-- BLOCK 3: MNU_BTN_MPG (SCM_ADM_MNU_BTN_MPG_M) — 9 신규 button 멱등 INSERT
--   (010 의 SEARCH 1건은 유지, 동일 멱등 패턴이라 충돌 없음)
--   MNU_BTN_CD 표준: 룰 12 §13 — SEARCH/INSERT/SAVE/DELETE/EXCEL/SORT/FILTER/...
-- =============================================================================================

INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT '&V_MENU_ID', '&V_SHT_NM', NEW.MNU_BTN_CD, NEW.API_ID, 'Y',
       '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
  FROM (
    SELECT 'INSERT'         MNU_BTN_CD, 'DMF0003_main_INSERT'         API_ID FROM DUAL UNION ALL
    SELECT 'SAVE',                       'DMF0003_main_SAVE'                  FROM DUAL UNION ALL
    SELECT 'DELETE',                     'DMF0003_main_DELETE'                FROM DUAL UNION ALL
    SELECT 'EXCEL',                      'DMF0003_main_EXCEL'                 FROM DUAL UNION ALL
    SELECT 'SORT',                       'DMF0003_main_SORT'                  FROM DUAL UNION ALL
    SELECT 'FILTER',                     'DMF0003_main_FILTER'                FROM DUAL UNION ALL
    SELECT 'COLUMN_SETUP',               'DMF0003_main_COLUMN_SETUP'          FROM DUAL UNION ALL
    SELECT 'MEASURE_SELECT',             'DMF0003_main_MEASURE_SELECT'        FROM DUAL UNION ALL
    SELECT 'MASTER_CHG',                 'DMF0003_main_MASTER_CHG'            FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M E
    WHERE E.MNU_ID = '&V_MENU_ID' AND E.SHT_NM = '&V_SHT_NM' AND E.MNU_BTN_CD = NEW.MNU_BTN_CD
 );


COMMIT;


-- =============================================================================================
-- BLOCK 4: 검증 SELECT (3 카테고리)
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT DMF0003 Button 메타 보강 결과
PROMPT ============================================================

SELECT '1.MSG_M_API'   AS K, COUNT(*) AS CNT, 27 AS EXPECT_MIN, 'SCM_ADM_MSG_M (9 API × 3 lang)' AS TBL FROM SCM_ADM_MSG_M    WHERE MSG_ID LIKE 'MSG_API_DMF0003_MAIN_%'
UNION ALL
SELECT '2.API_M',         COUNT(*),           10, 'SCM_ADM_API_M (1 + 9)'                        FROM SCM_ADM_API_M       WHERE API_ID LIKE 'DMF0003\_main\_%' ESCAPE '\'
UNION ALL
SELECT '3.BTN_MPG_M',     COUNT(*),           10, 'SCM_ADM_MNU_BTN_MPG_M (1 + 9)'                FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID' AND SHT_NM = '&V_SHT_NM'
ORDER BY 1;

PROMPT
PROMPT === DMF0003 등록된 button 목록 (USE_YN='Y') ===
SELECT MNU_BTN_CD, API_ID, USE_YN FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = '&V_MENU_ID' AND SHT_NM = '&V_SHT_NM'
 ORDER BY MNU_BTN_CD;
