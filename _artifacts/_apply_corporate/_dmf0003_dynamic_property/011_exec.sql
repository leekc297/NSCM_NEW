-- ora.py exec 호환 변형 (011_DMF0003_Buttons_Phase2-4.sql)
-- SQL*Plus 명령(SET/PROMPT/DEFINE) 제거 + &V 변수 inline.
-- BLOCK 4 검증 SELECT 제거 (015 audit 에서 통합 검증).

INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, 'API', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
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

INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.API_ID, 'PROC', NEW.MSG_ID, NEW.DESC_TXT, NEW.API_URL, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
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

INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0003', 'main', NEW.MNU_BTN_CD, NEW.API_ID, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
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
    WHERE E.MNU_ID = 'DMF0003' AND E.SHT_NM = 'main' AND E.MNU_BTN_CD = NEW.MNU_BTN_CD
 );

COMMIT;
