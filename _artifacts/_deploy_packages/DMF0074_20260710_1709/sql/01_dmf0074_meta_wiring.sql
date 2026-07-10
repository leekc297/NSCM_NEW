-- =====================================================================
-- DMF0074 Metal Link Price — 신규 FE 화면 메타 배선 (2026-07-10)
-- 원칙: BE 코드 변경 0 — call-proc/excel-upload 공용 체인 재사용.
-- 멱등: 전부 MERGE (재실행 안전). DBeaver 호환 (SET/슬래시 없음).
-- 실측 근거: PKG_DMF0074 ALL_ARGUMENTS + DMF0014/DMF0020 등록 형식 실측.
-- =====================================================================

-- ---------------------------------------------------------------------
-- BLOCK 1. SCM_ADM_API_M — 7행 (main 5 + template 1 + version 1)
--   main aux(EXCEL/SORT/FILTER) = GET proc 지정 (DMF0014 파리티)
--   UPLOAD = PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD (FileController 체인 auth 용)
--   version = PROC_SELECT + DMF0073_GET_VERSION_SALESPRICE (DMF0020 파리티·PROC_M 공유)
-- ---------------------------------------------------------------------
MERGE INTO SCM_ADM_API_M t
USING (
  SELECT 'DMF0074_main_SEARCH' API_ID, 'PROC' API_TP_CD, 'MSG_API_DMF0074_MAIN_SEARCH' API_MSG_ID, 'DMF0074 Metal Link Price Search' API_MSG_DESC, 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE' API_URL FROM DUAL
  UNION ALL SELECT 'DMF0074_main_EXCEL',  'PROC', 'MSG_API_DMF0074_MAIN_EXCEL',  'DMF0074 Metal Link Price Excel',  'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE' FROM DUAL
  UNION ALL SELECT 'DMF0074_main_SORT',   'PROC', 'MSG_API_DMF0074_MAIN_SORT',   'DMF0074 Metal Link Price Sort',   'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE' FROM DUAL
  UNION ALL SELECT 'DMF0074_main_FILTER', 'PROC', 'MSG_API_DMF0074_MAIN_FILTER', 'DMF0074 Metal Link Price Filter', 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE' FROM DUAL
  UNION ALL SELECT 'DMF0074_main_UPLOAD', 'PROC', 'MSG_API_DMF0074_MAIN_UPLOAD', 'DMF0074 Metal Link Price Excel Upload', 'PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD' FROM DUAL
  UNION ALL SELECT 'DMF0074_template_SEARCH', 'PROC', 'MSG_API_DMF0074_TEMPLATE_SEARCH', 'DMF0074 Metal Link Template Search', 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE' FROM DUAL
  UNION ALL SELECT 'DMF0074_version_SEARCH', 'PROC_SELECT', 'MSG_API_DMF0074_VERSION_SEARCH', 'DMF0074 Sales Price Version Search', 'DMF0073_GET_VERSION_SALESPRICE' FROM DUAL
) s
ON (t.API_ID = s.API_ID)
WHEN MATCHED THEN UPDATE SET t.API_TP_CD = s.API_TP_CD, t.API_URL = s.API_URL,
  t.API_MSG_DESC = s.API_MSG_DESC, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.API_ID, s.API_TP_CD, s.API_MSG_ID, s.API_MSG_DESC, s.API_URL, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

-- ---------------------------------------------------------------------
-- BLOCK 2. SCM_ADM_PROC_M — 19행
--   main GET 14행 (SORT_ORD = SP positional 정확 일치 — ALL_ARGUMENTS 실측)
--   template GET 5행. version(DMF0073_GET_VERSION_SALESPRICE) 9행 기존재 — 미등록.
--   sesUserId/mnuId = BE 자동주입 (NDaoInterface). o_result_cursor 소문자 (DMF0014 파리티).
-- ---------------------------------------------------------------------
MERGE INTO SCM_ADM_PROC_M t
USING (
  SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE' PROC_NM, 'divisionId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'deptId',          'VARCHAR', 'IN', 2  FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'endCustomer',     'VARCHAR', 'IN', 3  FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'scmSiteId',       'VARCHAR', 'IN', 4  FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'plantSiteId',     'VARCHAR', 'IN', 5  FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'projectCode',     'VARCHAR', 'IN', 6  FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'itemId',          'VARCHAR', 'IN', 7  FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'fromYyyymmdd',    'VARCHAR', 'IN', 8  FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'toYyyymmdd',      'VARCHAR', 'IN', 9  FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'versionType',     'VARCHAR', 'IN', 10 FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'sesUserId',       'VARCHAR', 'IN', 11 FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'mnuId',           'VARCHAR', 'IN', 12 FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'o_rc1',           'CURSOR',      'OUT', 13 FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_PRICE', 'o_result_cursor', 'PROC_RESULT', 'OUT', 14 FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE', 'divisionId',      'VARCHAR',     'IN',  1 FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE', 'sesUserId',       'VARCHAR',     'IN',  2 FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE', 'mnuId',           'VARCHAR',     'IN',  3 FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE', 'o_rc1',           'CURSOR',      'OUT', 4 FROM DUAL
  UNION ALL SELECT 'PKG_DMF0074.P_DMF0074_GET_METAL_LINK_TEMPLATE', 'o_result_cursor', 'PROC_RESULT', 'OUT', 5 FROM DUAL
) s
ON (t.PROC_NM = s.PROC_NM AND t.COL_NM = s.COL_NM)
WHEN MATCHED THEN UPDATE SET t.DATA_TP_CD = s.DATA_TP_CD, t.COL_TP_CD = s.COL_TP_CD, t.SORT_ORD = s.SORT_ORD,
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.PROC_NM, s.COL_NM, s.DATA_TP_CD, s.COL_TP_CD, s.SORT_ORD,
  'admin', SYSDATE, 'admin', SYSDATE);

-- ---------------------------------------------------------------------
-- BLOCK 3. SCM_ADM_MNU_BTN_MPG_M — 7행 (SHT_NM = FE SHEETS 상수 — hook #91)
--   main='Metal Link Price' (SCM_ADM_EXCEL_COLUMNS SHEET_NAME 과 동일 — excel-upload 체인 키)
--   조회전용 화면: INSERT/DELETE/SAVE 미등록 (AS-IS 빈 override 1:1)
-- ---------------------------------------------------------------------
MERGE INTO SCM_ADM_MNU_BTN_MPG_M t
USING (
  SELECT 'DMF0074' MNU_ID, 'Metal Link Price' SHT_NM, 'SEARCH' MNU_BTN_CD, 'DMF0074_main_SEARCH' API_ID FROM DUAL
  UNION ALL SELECT 'DMF0074', 'Metal Link Price', 'EXCEL',  'DMF0074_main_EXCEL'  FROM DUAL
  UNION ALL SELECT 'DMF0074', 'Metal Link Price', 'SORT',   'DMF0074_main_SORT'   FROM DUAL
  UNION ALL SELECT 'DMF0074', 'Metal Link Price', 'FILTER', 'DMF0074_main_FILTER' FROM DUAL
  UNION ALL SELECT 'DMF0074', 'Metal Link Price', 'UPLOAD', 'DMF0074_main_UPLOAD' FROM DUAL
  UNION ALL SELECT 'DMF0074', 'template', 'SEARCH', 'DMF0074_template_SEARCH' FROM DUAL
  UNION ALL SELECT 'DMF0074', 'version',  'SEARCH', 'DMF0074_version_SEARCH'  FROM DUAL
  -- ⭐ DIV=40 업로드 — FE 가 formId 'DMF0074_40' 으로 excel-upload 호출 (AS-IS 1:1) →
  --   checkMenuBtnAuth(mnuId='DMF0074_40') 통과용 auth 행 (BTN 테이블 FK 없음 실측 — MNU_M 불요)
  UNION ALL SELECT 'DMF0074_40', 'Metal Link Price', 'UPLOAD', 'DMF0074_main_UPLOAD' FROM DUAL
) s
ON (t.MNU_ID = s.MNU_ID AND t.SHT_NM = s.SHT_NM AND t.MNU_BTN_CD = s.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET t.API_ID = s.API_ID, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.MNU_ID, s.SHT_NM, s.MNU_BTN_CD, s.API_ID, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

-- ---------------------------------------------------------------------
-- BLOCK 4. SCM_ADM_USER_GR_MNU_BTN_MPG_M — 20행
--   ADMIN / DM ADMIN = 전 버튼 7. DM Viewer = UPLOAD 제외 6 (DMF0014 선례).
-- ---------------------------------------------------------------------
MERGE INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M t
USING (
  SELECT g.USER_GR_ID, b.MNU_ID, b.SHT_NM, b.MNU_BTN_CD
  FROM (SELECT 'ADMIN' USER_GR_ID FROM DUAL UNION ALL SELECT 'DM ADMIN' FROM DUAL UNION ALL SELECT 'DM Viewer' FROM DUAL) g
  CROSS JOIN (
    SELECT 'DMF0074' MNU_ID, 'Metal Link Price' SHT_NM, 'SEARCH' MNU_BTN_CD FROM DUAL
    UNION ALL SELECT 'DMF0074', 'Metal Link Price', 'EXCEL'  FROM DUAL
    UNION ALL SELECT 'DMF0074', 'Metal Link Price', 'SORT'   FROM DUAL
    UNION ALL SELECT 'DMF0074', 'Metal Link Price', 'FILTER' FROM DUAL
    UNION ALL SELECT 'DMF0074', 'Metal Link Price', 'UPLOAD' FROM DUAL
    UNION ALL SELECT 'DMF0074', 'template', 'SEARCH' FROM DUAL
    UNION ALL SELECT 'DMF0074', 'version',  'SEARCH' FROM DUAL
    -- ⭐ DIV=40 업로드 auth (formId 'DMF0074_40' — checkMenuBtnAuth mnuId 1:1)
    UNION ALL SELECT 'DMF0074_40', 'Metal Link Price', 'UPLOAD' FROM DUAL
  ) b
  WHERE NOT (g.USER_GR_ID = 'DM Viewer' AND b.MNU_BTN_CD = 'UPLOAD')
) s
ON (t.USER_GR_ID = s.USER_GR_ID AND t.MNU_ID = s.MNU_ID AND t.SHT_NM = s.SHT_NM AND t.MNU_BTN_CD = s.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.USER_GR_ID, s.MNU_ID, s.SHT_NM, s.MNU_BTN_CD, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

-- ---------------------------------------------------------------------
-- BLOCK 5. SCM_ADM_EXCEL_COLUMNS — STORAGE_SQL_ID 교정 (UPDATE 2행)
--   기존: DMF0074_EXCEL_UPLOAD (standalone — INVALID) → PKG 경로 (DMF0014 교정 선례)
-- ---------------------------------------------------------------------
UPDATE SCM_ADM_EXCEL_COLUMNS
SET STORAGE_SQL_ID = 'PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD',
    LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
WHERE PROGRAM_ID IN ('DMF0074', 'DMF0074_40')
  AND SHEET_NAME = 'Metal Link Price'
  AND STORAGE_SQL_ID <> 'PKG_DMF0074.P_DMF0074_EXCEL_UPLOAD';

-- ---------------------------------------------------------------------
-- BLOCK 6. SCM_ADM_MSG_M — 신규 채번 (KO=EN 통일 · CN 동일)
--   MSG00656 = 템플릿 0건 (AS-IS 팝업 L229 구 MSG00427 의도 — NSCM 미등록이므로 신규 채번)
--   LBL00762 = 'Excel Form' (템플릿 다운로드 커스텀 버튼 라벨)
--   MSG00049(날짜파싱)는 TO-BE 월 피커로 도달 불가 — 미등록 (격차 명기)
-- ---------------------------------------------------------------------
MERGE INTO SCM_ADM_MSG_M t
USING (
  SELECT 'MSG00656' MSG_ID, 'KO' LANG_CD, '이번 주 Sales Plan Waterfall 에 Monthly Rolling Forecast ''Y'' 버전이 존재하지 않습니다.' MSG_NM, 'MSG' MSG_TP_CD FROM DUAL
  UNION ALL SELECT 'MSG00656', 'EN', '이번 주 Sales Plan Waterfall 에 Monthly Rolling Forecast ''Y'' 버전이 존재하지 않습니다.', 'MSG' FROM DUAL
  UNION ALL SELECT 'MSG00656', 'CN', '이번 주 Sales Plan Waterfall 에 Monthly Rolling Forecast ''Y'' 버전이 존재하지 않습니다.', 'MSG' FROM DUAL
  UNION ALL SELECT 'LBL00762', 'KO', 'Excel Form', 'LBL' FROM DUAL
  UNION ALL SELECT 'LBL00762', 'EN', 'Excel Form', 'LBL' FROM DUAL
  UNION ALL SELECT 'LBL00762', 'CN', 'Excel Form', 'LBL' FROM DUAL
  UNION ALL SELECT 'LBL00763', 'KO', 'Excel Download', 'LBL' FROM DUAL
  UNION ALL SELECT 'LBL00763', 'EN', 'Excel Download', 'LBL' FROM DUAL
  UNION ALL SELECT 'LBL00763', 'CN', 'Excel Download', 'LBL' FROM DUAL
) s
ON (t.MSG_ID = s.MSG_ID AND t.LANG_CD = s.LANG_CD)
WHEN MATCHED THEN UPDATE SET t.MSG_NM = s.MSG_NM, t.MSG_TP_CD = s.MSG_TP_CD, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.MSG_ID, s.LANG_CD, s.MSG_NM, NULL, s.MSG_TP_CD, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

-- ---------------------------------------------------------------------
-- BLOCK 7. SCM_ADM_MNU_M — MNU_URL slug 교체 (라우팅 3-SET 정합)
--   dmf0074 (임시) → metal-link-price (route-paths.ts / Router.tsx 와 동일 kebab)
-- ---------------------------------------------------------------------
UPDATE SCM_ADM_MNU_M
SET MNU_URL = 'metal-link-price',
    LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
WHERE MNU_ID = 'DMF0074' AND MNU_URL <> 'metal-link-price';

-- ---------------------------------------------------------------------
-- BLOCK 8. SCM_MST_SHEET_COLUMNS — ⭐ hook #92 개정 (사용자 지시 2026-07-10):
--   ATTRIBUTE3 복사 방식 폐기 → DIVISION_ID **직접 사용** (서버측 토큰 필터 —
--   PKG_NSCM_UI_COM_MENU L164/214 `INSTR(','||C.DIVISION_ID||',', ','||P_DIVISION_ID||',')`).
--   FE 는 /admin/menu/{ID}/column body 에 divisionId 전달만 하면 됨 (메타 복사 불요).
--   기적용된 ATTRIBUTE3 복사분(2026-07-10 1회) 원복:
-- ---------------------------------------------------------------------
UPDATE SCM_MST_SHEET_COLUMNS
SET ATTRIBUTE3 = NULL,
    LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
WHERE PROGRAM_ID = 'DMF0074' AND SHEET_NAME = 'Metal Link Price'
  AND ATTRIBUTE3 = DIVISION_ID;

COMMIT;
