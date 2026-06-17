-- 2026-06-16 — DMF0003 Measure 선택 popup 의 사용자 권한 SAVE endpoint 등록
-- 사용자 명시: 기존 BE 활용 (신규 Java code 작성 없이 기존 useProcMutation 표준 path 사용)
-- 활용 SP: PKG_SCM0002.P_SCM0002_SET_TITLESET_POPUP (사용자별 column/measure 권한 1 row UPSERT)
--
-- BUTTON_TYPE.SAVE + sheet='titleSet' 표준 — FE useProcMutation(menuId,sheetName='titleSet',procedureAction=SAVE)

-- ============================================================
-- BLOCK 1) SCM_ADM_API_M — endpoint 등록 (멱등 NOT EXISTS)
-- ============================================================
INSERT INTO SCM_MGR.SCM_ADM_API_M
( API_ID, API_TP_CD, API_MSG_ID, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
SELECT 'DMF0003_titleSet_SAVE', 'SAVE',
       'MSG_API_DMF0003_TITLESET_SAVE',
       'PKG_SCM0002.P_SCM0002_SET_TITLESET_POPUP',
       'Y', 'system', SYSDATE, 'system', SYSDATE
FROM   DUAL
WHERE  NOT EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID = 'DMF0003_titleSet_SAVE'
);

-- ============================================================
-- BLOCK 2) SCM_ADM_PROC_M — SP IN param 매핑 9 row (멱등)
-- ============================================================
INSERT INTO SCM_MGR.SCM_ADM_PROC_M
( PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD,
       'system', SYSDATE, 'system', SYSDATE
FROM (
  SELECT 'P_SCM0002_SET_TITLESET_POPUP' AS PROC_NM, 'mnuId'          AS COL_NM, 'VARCHAR2' AS DATA_TP_CD, 'IN' AS COL_TP_CD, 1  AS SORT_ORD FROM DUAL UNION ALL
  SELECT 'P_SCM0002_SET_TITLESET_POPUP',           'sheetName',                 'VARCHAR2',                'IN',              2           FROM DUAL UNION ALL
  SELECT 'P_SCM0002_SET_TITLESET_POPUP',           'columnType',                'VARCHAR2',                'IN',              3           FROM DUAL UNION ALL
  SELECT 'P_SCM0002_SET_TITLESET_POPUP',           'activeFlag',                'VARCHAR2',                'IN',              4           FROM DUAL UNION ALL
  SELECT 'P_SCM0002_SET_TITLESET_POPUP',           'columnName',                'VARCHAR2',                'IN',              5           FROM DUAL UNION ALL
  SELECT 'P_SCM0002_SET_TITLESET_POPUP',           'sortOrderNo',               'NUMBER',                  'IN',              6           FROM DUAL UNION ALL
  SELECT 'P_SCM0002_SET_TITLESET_POPUP',           'subTotalFlag',              'VARCHAR2',                'IN',              7           FROM DUAL UNION ALL
  SELECT 'P_SCM0002_SET_TITLESET_POPUP',           'sortMethodCode',            'VARCHAR2',                'IN',              8           FROM DUAL UNION ALL
  SELECT 'P_SCM0002_SET_TITLESET_POPUP',           'sesUserId',                 'VARCHAR2',                'IN',              9           FROM DUAL UNION ALL
  SELECT 'P_SCM0002_SET_TITLESET_POPUP',           'O_RESULT_CURSOR',           'CURSOR',                  'OUT',             10          FROM DUAL
) NEW
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M EXISTING
    WHERE  EXISTING.PROC_NM     = NEW.PROC_NM
      AND  EXISTING.COL_NM      = NEW.COL_NM
      AND  EXISTING.COL_TP_CD   = NEW.COL_TP_CD
);

COMMIT;
