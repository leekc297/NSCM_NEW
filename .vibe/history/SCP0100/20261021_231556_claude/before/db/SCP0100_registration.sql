/* SCP0100_registration.sql — 사내 현행 메타 미러(비파괴·멱등) · 2026-10-20 사람 재작성
 * 원 생성: tools/Harness/gen-register-sql.js 2026-10-20 (register.json). 생성본은 REPORT/SEARCH → P_SCP0100_GET_PLAN_DATE ·
 *   REPORT/ACTION → 'PKG_SCP0100.P_'(프로시저명 공란)로 사내 현행(P_SCP0100_GET → P_SCP0100_GET_GLOBAL_PSI_REPORT)과 달랐고(DoD B23),
 *   DELETE 후 INSERT 라 사내 MNU_BTN_MPG_M 9행·SHEET_COLUMNS 33행(DIVISION_ID NULL → 'ALL')·그룹권한 5그룹 45행을 덮어쓸 수 있었다.
 *   → 7영역 전부 사내 현행값 그대로 + NOT EXISTS / WHEN NOT MATCHED 로 재작성(SCP0096 미러 선례 동형).
 *   사내(ZIOUI1)에서 실행하면 0행 변경이 정상이고, 클라우드 등 부재 환경에서는 부재분만 생성된다. 기존 행 UPDATE·DELETE 없음.
 * 원천(hook #152 착수 재조회): ZIOUI1 SCM_MGR 2026-10-20 22:16:56 — SCM_ADM_MNU_M / MNU_BTN_MPG_M+API_M / PROC_M / SHEET_COLUMNS /
 *   USER_GR_MNU_MPG_M / USER_GR_MNU_BTN_MPG_M / MSG_M 실측. PKG_SCP0100 PACKAGE VALID 2026-10-09 13:38:32 · BODY VALID 2026-10-16 09:42:30
 * 실행: python tools/DbConn/run_sql.py <이 파일> [--commit]  (SQL*Plus/SQLcl 도 가능). COMMIT 은 BLOCK 8 결과 확인 후.
 * 등록 SQL 재생성 금지: gen-register-sql.js 로 다시 만들면 DELETE+INSERT 생성본으로 회귀한다(register.json note 참조).
 */
SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED
DEFINE V_MENU_ID     = 'SCP0100'
DEFINE V_MENU_MSG_ID = 'MNU_SCP0100'
DEFINE V_MENU_URL    = 'global-psi-report'
DEFINE V_PKG_NM      = 'PKG_SCP0100'
DEFINE V_USER_ID     = 'harness'

-- BLOCK 1: i18n 메뉴명 — 사내는 MNU_SCP0100 기등록(KO/EN/CN 'Global PSI New' 재사용). 부재 환경만 INSERT … NOT EXISTS (hook #140)
INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT '&V_MENU_MSG_ID', L.LANG_CD, 'Global PSI New', 'MNU', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
  FROM (SELECT 'KO' AS LANG_CD FROM DUAL UNION ALL SELECT 'EN' FROM DUAL UNION ALL SELECT 'CN' FROM DUAL) L
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MSG_M M WHERE M.MSG_ID = '&V_MENU_MSG_ID' AND M.LANG_CD = L.LANG_CD);

-- BLOCK 2: PROC_M — ALL_ARGUMENTS 동적 등록, NOT EXISTS(PROC_NM+SORT_ORD) 멱등. 사내 현행 33행(19+5+4+5).
--   COL_NM 규칙 = 사내 현행과 동일(IN → camelCase(P_ 제거) / OUT → 소문자 · O_RESULT_CURSOR → PROC_RESULT) — FE filter 키의 정본(DoD B22).
--   주의: 사내 SORT_ORD 는 OUT 이 100/101 이다(IN 1..n). 부재 환경 신규 생성분은 1..n 연번 — PR_GET_PROC_INFO_LIST 는 순서만 사용.
DECLARE
  v_n NUMBER; v_rows NUMBER;
BEGIN
  FOR p IN (SELECT 'PKG_SCP0100' AS PKG, 'P_SCP0100_GET_GLOBAL_PSI_REPORT'     AS OBJ FROM DUAL UNION ALL
            SELECT 'PKG_SCP0100',        'P_SCP0100_GET_SITE'                         FROM DUAL UNION ALL
            SELECT 'PKG_SCP0100',        'P_SCP0100_GET_PLAN_DATE'                    FROM DUAL UNION ALL
            SELECT 'PKG_SCP0100',        'P_SCP0100_GET_SHEET_CALENDAR_3SPAN'         FROM DUAL) LOOP
    SELECT COUNT(*) INTO v_rows FROM SCM_ADM_PROC_M M WHERE M.PROC_NM = p.PKG || '.' || p.OBJ;
    v_n := 0;
    IF v_rows = 0 THEN
      FOR r IN (SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION
                  FROM ALL_ARGUMENTS
                 WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = p.PKG AND OBJECT_NAME = p.OBJ
                   AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL
                 ORDER BY POSITION) LOOP
        v_n := v_n + 1;
        INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        VALUES (p.PKG || '.' || p.OBJ,
                CASE WHEN r.IN_OUT LIKE '%OUT%' THEN LOWER(r.ARGUMENT_NAME) ELSE PKG_NSCM_UI_COMM.FN_TO_CAMEL_CASE(REGEXP_REPLACE(r.ARGUMENT_NAME, '^P_', '')) END,
                CASE WHEN r.IN_OUT LIKE '%OUT%' THEN 'OUT' ELSE 'IN' END,
                CASE WHEN r.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT' ELSE PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(r.DATA_TYPE) END,
                v_n, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      END LOOP;
      IF v_n = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  WARN ' || p.PKG || '.' || p.OBJ || ' 가 ALL_ARGUMENTS 에 없음(PKG 미배포) — PKG 배포 후 이 SQL 재실행');
      ELSE
        DBMS_OUTPUT.PUT_LINE('  NEW ' || p.PKG || '.' || p.OBJ || ' PROC_M ' || v_n || '행 생성');
      END IF;
    ELSE
      DBMS_OUTPUT.PUT_LINE('  OK ' || p.PKG || '.' || p.OBJ || ' PROC_M 기등록 ' || v_rows || '행(무변경)');
    END IF;
  END LOOP;
END;
/

-- BLOCK 3: SHEET_COLUMNS — 사내 현행 33행 미러(2026-10-20 실측값: FIXED '-'/'Y' · UPPERCASE '-' · USER_SELECTABLE 'Y'/'-' · DIVISION_ID NULL ·
--   INPUT_TP_CD 'S' · CELL_CONTROL 공란 4행(DIVISION_ID·FROM_SITE·TO_SITE)). NOT EXISTS(PROGRAM_ID+SHEET_NAME+COLUMN_NAME) — 기존 행 무변경.
--   '-' 는 기존 데이터 값 그대로 보존(센티널 신규 작성 아님 — #119 §0.5 원래 '-' 데이터 유지).
DECLARE
    v_col_json CLOB := '[
        {"sht_nm":"REPORT","col_nm":"DIVISION_ID","col_lbl":"Div","sort_ord":10,"col_wth":60,"align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"REPORT","col_nm":"CELL_GROUP","col_lbl":"Cell Group","sort_ord":20,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"REPORT","col_nm":"OPERATION_ID","col_lbl":"Operation","sort_ord":30,"col_wth":80,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"REPORT","col_nm":"MEASURE_GROUP","col_lbl":"Measure Group","sort_ord":40,"col_wth":110,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"REPORT","col_nm":"PRODUCT_LEVEL1","col_lbl":"Product Level1","sort_ord":50,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"REPORT","col_nm":"PRODUCT_LEVEL2","col_lbl":"Product Level2","sort_ord":60,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"REPORT","col_nm":"PRODUCT_LEVEL3","col_lbl":"Product Level3","sort_ord":70,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"REPORT","col_nm":"MEASURE_UI","col_lbl":"Measure","sort_ord":80,"col_wth":150,"cell_tp":"FPTextBox","align":"C","visible":"N","default_f":"N","usr_sel":"-"},
        {"sht_nm":"REPORT","col_nm":"MEASURE_NAME","col_lbl":"Measure Name","sort_ord":90,"fixed":"Y","col_wth":150,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"REPORT","col_nm":"FROM_SITE","col_lbl":"From Site","sort_ord":100,"col_wth":100,"align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"REPORT","col_nm":"TO_SITE","col_lbl":"To Site","sort_ord":110,"col_wth":110,"align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"REPORT","col_nm":"INCOTERMS","col_lbl":"INCOTERMS","sort_ord":120,"col_wth":75,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"REPORT","col_nm":"ITEM_ID","col_lbl":"Model","sort_ord":130,"col_wth":120,"cell_tp":"FPTextBox","align":"L","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"REPORT","col_nm":"VARIOUS_KEY","col_lbl":"Trans Mode or Line or Project","sort_ord":140,"col_wth":70,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"REPORT","col_nm":"CELL_CF","col_lbl":"Cell Qty","sort_ord":150,"col_wth":90,"cell_tp":"FPNumber","align":"R","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL","col_nm":"DIVISION_ID","col_lbl":"Div","sort_ord":10,"col_wth":60,"align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL","col_nm":"CELL_GROUP","col_lbl":"Cell Group","sort_ord":20,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL","col_nm":"PRODUCT_LEVEL1","col_lbl":"Product Level1","sort_ord":30,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL","col_nm":"PRODUCT_LEVEL2","col_lbl":"Product Level2","sort_ord":40,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL","col_nm":"PRODUCT_LEVEL3","col_lbl":"Product Level3","sort_ord":50,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL","col_nm":"OPERATION_GROUP","col_lbl":"Operation Group","sort_ord":60,"col_wth":115,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"SEARCH_LEVEL","col_nm":"MEASURE_GROUP","col_lbl":"Measure Group","sort_ord":70,"col_wth":110,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL","col_nm":"MEASURE_UI","col_lbl":"Measure","sort_ord":80,"col_wth":150,"cell_tp":"FPTextBox","align":"C","visible":"N","default_f":"N","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL","col_nm":"MEASURE_NAME","col_lbl":"Measure Name","sort_ord":90,"fixed":"Y","col_wth":150,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL_DETAIL","col_nm":"DIVISION_ID","col_lbl":"Div","sort_ord":10,"col_wth":60,"align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL_DETAIL","col_nm":"CELL_GROUP","col_lbl":"Cell Group","sort_ord":20,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL_DETAIL","col_nm":"PRODUCT_LEVEL1","col_lbl":"Product Level1","sort_ord":30,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL_DETAIL","col_nm":"MEASURE_GROUP","col_lbl":"Measure Group","sort_ord":40,"col_wth":110,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL_DETAIL","col_nm":"OPERATION_GROUP","col_lbl":"Operation Group","sort_ord":50,"col_wth":115,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"Y"},
        {"sht_nm":"SEARCH_LEVEL_DETAIL","col_nm":"PRODUCT_LEVEL2","col_lbl":"Product Level2","sort_ord":60,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL_DETAIL","col_nm":"PRODUCT_LEVEL3","col_lbl":"Product Level3","sort_ord":70,"col_wth":140,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL_DETAIL","col_nm":"MEASURE_UI","col_lbl":"Measure","sort_ord":80,"col_wth":150,"cell_tp":"FPTextBox","align":"C","visible":"N","default_f":"N","usr_sel":"-"},
        {"sht_nm":"SEARCH_LEVEL_DETAIL","col_nm":"MEASURE_NAME","col_lbl":"Measure Name","sort_ord":90,"fixed":"Y","col_wth":150,"cell_tp":"FPTextBox","align":"C","visible":"Y","default_f":"Y","usr_sel":"-"}
    ]';
BEGIN
    INSERT INTO SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG, COLUMN_WIDTH,
        CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID, INPUT_TP_CD,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT '&V_MENU_ID', jt.SHT_NM, jt.COL_NM, jt.COL_LBL, jt.SORT_ORD, jt.COL_LBL, jt.COL_LBL, NVL(jt.FIXED, '-'), NVL(jt.COL_WTH, 100), jt.CELL_TP, NULL, NULL, NULL, NVL(jt.ALIGN, 'L'), '-', NVL(jt.VISIBLE, 'Y'), NVL(jt.DEFAULT_F, 'Y'), NVL(jt.USR_SEL, '-'), 'Y', NULL, 'S', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
    FROM JSON_TABLE(v_col_json, '$[*]' COLUMNS (SHT_NM VARCHAR2(50 CHAR) PATH '$.sht_nm', COL_NM VARCHAR2(100 CHAR) PATH '$.col_nm', COL_LBL VARCHAR2(200 CHAR) PATH '$.col_lbl', SORT_ORD NUMBER PATH '$.sort_ord', FIXED VARCHAR2(1 CHAR) PATH '$.fixed', COL_WTH NUMBER PATH '$.col_wth', CELL_TP VARCHAR2(50 CHAR) PATH '$.cell_tp', ALIGN VARCHAR2(1 CHAR) PATH '$.align', VISIBLE VARCHAR2(1 CHAR) PATH '$.visible', DEFAULT_F VARCHAR2(1 CHAR) PATH '$.default_f', USR_SEL VARCHAR2(1 CHAR) PATH '$.usr_sel')) jt
    WHERE NOT EXISTS (SELECT 1 FROM SCM_MST_SHEET_COLUMNS C WHERE C.PROGRAM_ID = '&V_MENU_ID' AND C.SHEET_NAME = jt.SHT_NM AND C.COLUMN_NAME = jt.COL_NM);
    DBMS_OUTPUT.PUT_LINE('[BLOCK 3] SCM_MST_SHEET_COLUMNS 신규 ' || SQL%ROWCOUNT || ' 행 (사내 기등록 33행이면 0)');
END;
/

-- BLOCK 4: MENU — 사내 현행(상위 Supply_Plan · 레벨 3 · 정렬 100 · ROUTE_PATH supply/global-psi-report). 부재 시에만 INSERT(기존 행 UPDATE 없음).
MERGE INTO SCM_ADM_MNU_M T USING (SELECT '&V_MENU_ID' AS MNU_ID FROM DUAL) S ON (T.MNU_ID = S.MNU_ID)
WHEN NOT MATCHED THEN INSERT (MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_MSG_ID, MNU_URL, SORT_ORD, USE_YN, MNU_TP_CD, ROUTE_PATH, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES ('&V_MENU_ID', 'Supply_Plan', 3, '&V_MENU_MSG_ID', '&V_MENU_URL', 100, 'Y', 'SCREEN', 'supply/global-psi-report', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);

-- BLOCK 5: API (사내 현행 4행 — API_ID·API_TP_CD·API_URL 실측 그대로. P_SCP0100_GET 은 report/searchLevel/searchLevelDetail 3시트 공용)
MERGE INTO SCM_ADM_API_M T USING (SELECT 'P_SCP0100_GET' AS API_ID FROM DUAL) S ON (T.API_ID = S.API_ID)
WHEN NOT MATCHED THEN INSERT (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES ('P_SCP0100_GET', 'PROC_SELECT', NULL, 'SCP0100 Global PSI Report SEARCH', 'PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
MERGE INTO SCM_ADM_API_M T USING (SELECT 'P_SCP0100_SITE_GET' AS API_ID FROM DUAL) S ON (T.API_ID = S.API_ID)
WHEN NOT MATCHED THEN INSERT (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES ('P_SCP0100_SITE_GET', 'PROC_SELECT', NULL, 'SCP0100 From/To Site', 'PKG_SCP0100.P_SCP0100_GET_SITE', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
MERGE INTO SCM_ADM_API_M T USING (SELECT 'P_SCP0100_PLAN_DATE_GET' AS API_ID FROM DUAL) S ON (T.API_ID = S.API_ID)
WHEN NOT MATCHED THEN INSERT (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES ('P_SCP0100_PLAN_DATE_GET', 'PROC_SELECT', NULL, 'SCP0100 Plan Date', 'PKG_SCP0100.P_SCP0100_GET_PLAN_DATE', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
MERGE INTO SCM_ADM_API_M T USING (SELECT 'P_SCP0100_CALENDAR_GET' AS API_ID FROM DUAL) S ON (T.API_ID = S.API_ID)
WHEN NOT MATCHED THEN INSERT (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES ('P_SCP0100_CALENDAR_GET', 'PROC_SELECT', NULL, 'SCP0100 Sheet Calendar 3SPAN', 'PKG_SCP0100.P_SCP0100_GET_SHEET_CALENDAR_3SPAN', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);

-- BLOCK 6: MNU_BTN_MPG (사내 현행 9행 — 시트×버튼 → API. COLUMN_SETUP/EXCEL/MEASURE_SELECT 는 API 없음(권한 게이트 전용 — FE hasButton).
--   INSERT/SAVE/DELETE 정의 없음 = FE hotkeyConfig false(read-only 리포트))
MERGE INTO SCM_ADM_MNU_BTN_MPG_M T
USING (SELECT '&V_MENU_ID' AS MNU_ID, SHT_NM, MNU_BTN_CD, API_ID FROM (
         SELECT 'calendar' AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, CAST('P_SCP0100_CALENDAR_GET' AS VARCHAR2(100)) AS API_ID FROM DUAL UNION ALL
         SELECT 'planDate',           'SEARCH',               'P_SCP0100_PLAN_DATE_GET'                               FROM DUAL UNION ALL
         SELECT 'report',             'COLUMN_SETUP',         NULL                                                    FROM DUAL UNION ALL
         SELECT 'report',             'EXCEL',                NULL                                                    FROM DUAL UNION ALL
         SELECT 'report',             'MEASURE_SELECT',       NULL                                                    FROM DUAL UNION ALL
         SELECT 'report',             'SEARCH',               'P_SCP0100_GET'                                         FROM DUAL UNION ALL
         SELECT 'searchLevel',        'SEARCH',               'P_SCP0100_GET'                                         FROM DUAL UNION ALL
         SELECT 'searchLevelDetail',  'SEARCH',               'P_SCP0100_GET'                                         FROM DUAL UNION ALL
         SELECT 'site',               'SEARCH',               'P_SCP0100_SITE_GET'                                    FROM DUAL)) S
   ON (T.MNU_ID = S.MNU_ID AND T.SHT_NM = S.SHT_NM AND T.MNU_BTN_CD = S.MNU_BTN_CD)
WHEN NOT MATCHED THEN INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (S.MNU_ID, S.SHT_NM, S.MNU_BTN_CD, S.API_ID, 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);

-- BLOCK 7: 그룹 권한 — 사내 현행 5그룹(ADMIN · SCM PI Admin · SCM Viewer · SCP Planner · SCP Tester) 메뉴 + 9버튼 전부 Y (2026-10-20 실측 45행). NOT EXISTS.
INSERT INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT G.USER_GR_ID, '&V_MENU_ID', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
  FROM (SELECT 'ADMIN' AS USER_GR_ID FROM DUAL UNION ALL SELECT 'SCM PI Admin' FROM DUAL UNION ALL SELECT 'SCM Viewer' FROM DUAL UNION ALL SELECT 'SCP Planner' FROM DUAL UNION ALL SELECT 'SCP Tester' FROM DUAL) G
 WHERE EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_M U WHERE U.USER_GR_ID = G.USER_GR_ID)
   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M E WHERE E.USER_GR_ID = G.USER_GR_ID AND E.MNU_ID = '&V_MENU_ID');
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT G.USER_GR_ID, B.MNU_ID, B.SHT_NM, B.MNU_BTN_CD, 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
  FROM SCM_ADM_MNU_BTN_MPG_M B
 CROSS JOIN (SELECT 'ADMIN' AS USER_GR_ID FROM DUAL UNION ALL SELECT 'SCM PI Admin' FROM DUAL UNION ALL SELECT 'SCM Viewer' FROM DUAL UNION ALL SELECT 'SCP Planner' FROM DUAL UNION ALL SELECT 'SCP Tester' FROM DUAL) G
 WHERE B.MNU_ID = '&V_MENU_ID'
   AND EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_M U WHERE U.USER_GR_ID = G.USER_GR_ID)
   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M E
                    WHERE E.USER_GR_ID = G.USER_GR_ID AND E.MNU_ID = B.MNU_ID AND E.SHT_NM = B.SHT_NM AND E.MNU_BTN_CD = B.MNU_BTN_CD);

-- BLOCK 8: 검증 — 기대값(사내 2026-10-20 실측): MENU 1 · I18N 3 · PROC_M(PKG_SCP0100) 33 · SHEET_COLUMNS 33 · API 4 · MNU_BTN_MPG 9 · GROUP_MENU 5 · GROUP_BTN 45
SELECT '1.MENU' AS AREA, COUNT(*) AS CNT FROM SCM_ADM_MNU_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL SELECT '1.I18N', COUNT(*) FROM SCM_ADM_MSG_M WHERE MSG_ID = '&V_MENU_MSG_ID'
UNION ALL SELECT '2.PROC_M', COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE '&V_PKG_NM' || '.%'
UNION ALL SELECT '3.SHEET_COLUMNS', COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = '&V_MENU_ID'
UNION ALL SELECT '5.API', COUNT(*) FROM SCM_ADM_API_M WHERE API_ID IN ('P_SCP0100_GET', 'P_SCP0100_SITE_GET', 'P_SCP0100_PLAN_DATE_GET', 'P_SCP0100_CALENDAR_GET')
UNION ALL SELECT '6.MNU_BTN_MPG', COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL SELECT '7.GROUP_MENU', COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL SELECT '7.GROUP_BTN', COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID' ORDER BY 1;
DECLARE v_cur SYS_REFCURSOR; v_proc VARCHAR2(200); v_col VARCHAR2(100); v_dt VARCHAR2(50); v_ct VARCHAR2(50); v_so NUMBER; v_cnt NUMBER := 0;
BEGIN
  SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(P_MNU_ID => '&V_MENU_ID', P_SHT_NM => 'report', P_MNU_BTN_CD => 'SEARCH', O_CURSOR => v_cur);
  LOOP FETCH v_cur INTO v_proc, v_col, v_dt, v_ct, v_so; EXIT WHEN v_cur%NOTFOUND; v_cnt := v_cnt + 1; END LOOP; CLOSE v_cur;
  DBMS_OUTPUT.PUT_LINE('report SEARCH 라우팅: ' || CASE WHEN v_cnt = 0 THEN 'FAIL 라우팅 없음' WHEN v_cnt < 19 THEN 'WARN PROC_M ' || v_cnt || '행(기대 19)' ELSE 'OK 파라미터 ' || v_cnt END);
  v_cnt := 0;
  SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(P_MNU_ID => '&V_MENU_ID', P_SHT_NM => 'calendar', P_MNU_BTN_CD => 'SEARCH', O_CURSOR => v_cur);
  LOOP FETCH v_cur INTO v_proc, v_col, v_dt, v_ct, v_so; EXIT WHEN v_cur%NOTFOUND; v_cnt := v_cnt + 1; END LOOP; CLOSE v_cur;
  DBMS_OUTPUT.PUT_LINE('calendar 라우팅: ' || CASE WHEN v_cnt = 0 THEN 'FAIL 라우팅 없음' WHEN v_cnt < 4 THEN 'WARN PROC_M ' || v_cnt || '행(기대 4)' ELSE 'OK 파라미터 ' || v_cnt END);
END;
/
-- COMMIT;   -- BLOCK 8 확인 후 수동 커밋 (롤백: ROLLBACK;)
UNDEFINE V_MENU_ID V_MENU_MSG_ID V_MENU_URL V_PKG_NM V_USER_ID
