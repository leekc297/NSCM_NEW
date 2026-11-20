#!/usr/bin/env node
'use strict';
// gen-register-sql — 신규 화면의 Oracle 메타 등록 SQL(7영역) 을 Fact Pack 에서 생성한다 (템플릿: To-be_v2_converted/08_Screen_Registration/02_NEW_SCREEN_FULL_REGISTRATION_TEMPLATE.sql)
//   node gen-register-sql.js <ID> [--config harness.json]
//   입력: Doc/gen/<ID>/register.json(프로시저×시트×버튼), Doc/asisfacts/db/meta/dbo.SCM_MST_SHEET_COLUMNS.csv(As-is 시트 메타 전 컬럼),
//         screens/<ID>/grid_effective.csv(하드코딩 컬럼), db/meta/dbo.TB_FX_MenuItemInfo.csv(메뉴명·상위·정렬), dbo.TB_FX_GroupMenuAuth.csv(그룹 권한),
//         db/db_params.csv(As-is SP 파라미터 — PKG 미배포 시 폴백), Doc/tobefacts/db/menu.csv·user_group.csv(있으면 상위메뉴/그룹 ID 확정)
//   산출: Doc/gen/<ID>/<ID>_registration.sql  — 자기완결형. PROC_M 은 ALL_ARGUMENTS 에서 동적 생성(PKG 가 있으면 정확, 없으면 WARN + As-is 파라미터 폴백)
const fs = require('fs'); const path = require('path');
const { readCsv } = require('../TobeFacts/src/util');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const ID0 = (a.find(x => !x.startsWith('--') && a[a.indexOf(x) - 1] !== '--config') || '').toUpperCase(); if (!ID0) { console.error('화면ID'); process.exit(2); }
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'harness.json')), 'utf8').replace(/^﻿/, ''));
const R = cfg.rulesDir || path.join(__dirname, 'rules'); const rc = p => fs.existsSync(p) ? readCsv(p) : [];
const mapScreen = rc(path.join(R, 'map_screen.csv')); const mA = mapScreen.find(r => r.asis_id.toUpperCase() === ID0), mT = mapScreen.find(r => r.tobe_id.toUpperCase() === ID0);
const ID = mA ? mA.tobe_id.toUpperCase() : ID0, AID = mT ? mT.asis_id.toUpperCase() : ID0;
const genDir = path.join(cfg.genOutDir, ID); const regF = path.join(genDir, 'register.json'); if (!fs.existsSync(regF)) { console.error(`register.json 없음: ${regF} (gen.js 먼저)`); process.exit(2); }
const reg = JSON.parse(fs.readFileSync(regF, 'utf8'));
const meta = p => path.join(cfg.asisOutDir, 'db', 'meta', p);
const sheetCols = rc(meta('dbo.SCM_MST_SHEET_COLUMNS.csv')).filter(r => r.PROGRAM_ID.toUpperCase() === AID && r.VALID_YN !== 'N');
const gridEff = rc(path.join(cfg.asisOutDir, 'screens', AID, 'grid_effective.csv'));
const menuInfo = rc(meta('dbo.TB_FX_MenuItemInfo.csv')).find(r => r.ProgramID.toUpperCase() === AID || r.MenuID.toUpperCase() === AID) || {};
const groups = rc(meta('dbo.TB_FX_GroupMenuAuth.csv')).filter(r => r.MenuID.toUpperCase() === AID && r.UseYN !== 'N');
const params = rc(path.join(cfg.asisOutDir, 'db', 'db_params.csv'));
const tobeMenu = rc(path.join(cfg.tobeOutDir, 'db', 'menu.csv')), tobeGroups = rc(path.join(cfg.tobeOutDir, 'db', 'user_group.csv'));
const lbl = rc(path.join(R, 'lbl_codes.csv')); const lblOf = text => { const t = (text || '').trim().toLowerCase(); const h = lbl.find(r => (r.text || r.label || '').trim().toLowerCase() === t); return h ? (h.code || h.lbl) : ''; };
const q = s => String(s ?? '').replace(/'/g, "''");
const pkg = (reg.procs.find(p => p.tobe_pkg_candidate) || {}).tobe_pkg_candidate; const PKG = pkg ? pkg.split('.')[0] : `PKG_${ID}`;
const sheetKey = s => s.replace(/[^A-Za-z0-9]+/g, '_').replace(/^_|_$/g, '').toUpperCase();
// 프로시저 → API/버튼 매핑 (콤보·spreadTitle 제외)
const procs = reg.procs.filter(p => p.tobe_pkg_candidate && !/^\(/.test(p.btn) && p.sheet !== '(combo)').map(p => ({ proc: p.tobe_pkg_candidate, sheet: p.sheet === 'spreadTitle' ? 'main' : p.sheet, btn: p.btn.replace(/[^A-Z0-9_]/gi, '_').toUpperCase(), asis: p.asis_sp }));
const seen = new Set(); const uniq = procs.filter(p => { const k = `${p.sheet}|${p.btn}`; if (seen.has(k)) return false; seen.add(k); return true; });
// 상위 메뉴: To-Be menu.csv 가 있으면 As-is 상위 메뉴 Title 로 찾는다
const parentTitle = menuInfo.PrntMenuID || ''; const tobeParent = tobeMenu.find(r => Object.values(r).some(v => v === parentTitle)) || null;
const UPPR = tobeParent ? (tobeParent.MNU_ID || tobeParent.mnu_id) : (parentTitle ? `/* TODO 상위메뉴 ID — As-is 상위 '${parentTitle}' */ 'DMF'` : "'DMF'");
const title = menuInfo.Title || reg.screenName || ID; const url = reg.pageDir;
// 자기 메뉴 행(이미 등록되어 있으면 — DMF0052 처럼 USE_YN=N 자리표시) · ROUTE_PATH = 상위 route_path + '/' + url (viewRegistry 는 leaf 로도 찾는다)
const selfMenu = tobeMenu.find(r => (r.mnu_id || r.MNU_ID || '').toUpperCase() === ID) || null;
const parentRoute = tobeParent ? (tobeParent.route_path || tobeParent.ROUTE_PATH || '') : '';
const routePath = parentRoute ? `${parentRoute}/${url}` : `${reg.feature}/${url}`;
const hasRouteCol = tobeMenu.length ? Object.keys(tobeMenu[0]).some(k => k.toLowerCase() === 'route_path') : true;
// 그룹: To-Be user_group.csv 있으면 이름 매칭, 없으면 As-is 그룹명 그대로(확인 필요)
const grpId = name => { if (!tobeGroups.length) return name; const h = tobeGroups.find(r => Object.values(r).some(v => String(v).toLowerCase() === name.toLowerCase())); return h ? (h.USER_GR_ID || h.user_gr_id || name) : name; };
const grpRows = groups.length ? groups.map(g => ({ id: grpId(g.GroupID), read: g.BasicACLR === '1' || g.BasicACLC === '1' || g.BasicACLU === '1' || g.BasicACLD === '1', save: g.BasicACLU === '1' || g.BasicACLC === '1' || g.BasicACLD === '1', src: g.GroupID })) : [{ id: 'ADMIN', read: true, save: true, src: '(기본)' }];
// 시트 컬럼 JSON: As-is 메타 그대로 + 하드코딩(CODE) 컬럼 추가
const colRows = [];
const unusedSheets = new Set(gridEff.filter(g => /미참조/.test(g.sheet_rule || '')).map(g => g.sheet)); // 메타만 있고 코드 미참조 시트 — 컬럼 등록 생략
for (const r of sheetCols) if (!unusedSheets.has(r.SHEET_NAME)) colRows.push({ sht_nm: r.SHEET_NAME, col_nm: r.COLUMN_NAME, col_lbl: r.COLUMN_LABEL_NAME, sort_ord: Number(r.SORT_ORDER_NO) || 0, small_cls: r.SMALL_CLASS_LABEL_NAME || undefined, large_cls: r.LARGE_CLASS_LABEL_NAME || undefined, fixed: r.FIXED_FLAG || undefined, col_wth: Number(r.COLUMN_WIDTH) || undefined, cell_tp: r.CELL_CONTROL_OBJECT_TYPE_CODE || undefined, cell_cbo: r.CELL_COMBO_DATA_TYPE || undefined, scale: r.DATA_SCALE_NUMBER ? Number(r.DATA_SCALE_NUMBER) : undefined, max_len: r.DATA_MAX_LENGTH ? Number(r.DATA_MAX_LENGTH) : undefined, align: r.HORIZONTAL_ALIGN_CODE || undefined, upper: r.UPPERCASE_APPLY_FLAG || undefined, visible: r.VISIBLE_FLAG || undefined, default_f: r.DEFAULT_FLAG || undefined, usr_sel: r.USER_SELECTABLE_FLAG || undefined, div_id: r.DIVISION_ID || 'ALL', input_tp: r.INPUT_TP_CD || undefined });
const divCols = gridEff.length ? Object.keys(gridEff[0]).filter(k => !['sheet', 'sheet_rule', 'column', 'label', 'source'].includes(k)) : [];
let hardN = 0;
for (const g of gridEff.filter(g => g.source === 'CODE')) {
  const divs = divCols.filter(d => g[d]); const all = divs.length === divCols.length || divs.length === 0;
  const base = { sht_nm: g.sheet, col_nm: g.column, col_lbl: lblOf(g.label) || g.label, sort_ord: 9000 + (++hardN), cell_tp: 'FPText', col_wth: 100, visible: 'Y', default_f: 'Y', usr_sel: 'Y', input_tp: 'OPTIONAL', _src: 'As-is 하드코딩 컬럼' };
  if (all) colRows.push(Object.assign(base, { div_id: 'ALL' })); else for (const d of divs) colRows.push(Object.assign({}, base, { div_id: d }));
}
const colJson = colRows.map(r => '        ' + JSON.stringify(Object.fromEntries(Object.entries(r).filter(([k, v]) => v !== undefined && v !== '' && !k.startsWith('_'))))).join(',\n');
// As-is 파라미터 폴백(PKG 미배포 시)
const asisParams = sp => params.filter(r => r.object_name.toUpperCase() === sp.toUpperCase() && r.type.trim() === 'P' && r.is_output === '0').sort((x, y) => Number(x.parameter_id) - Number(y.parameter_id)).map(r => ({ name: r.param_name.replace(/^@/, ''), tp: /char|text|date|time/i.test(r.data_type) ? (/date|time/i.test(r.data_type) ? 'DATE' : 'VARCHAR') : 'NUMERIC' }));
const camel = s => { const t = s.replace(/^P_/i, '').toLowerCase().split('_').map((w, i) => i ? w[0].toUpperCase() + w.slice(1) : w).join(''); return t; };
const procBlocks = uniq.map(p => {
  const fb = asisParams(p.asis); const fbRows = fb.map((x, i) => `      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('${q(p.proc)}', '${camel(x.name)}', 'IN', '${x.tp}', ${i + 1}, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);`).join('\n');
  return `  -- ${p.sheet} / ${p.btn}  ← As-is ${p.asis}
  v_pkg := '${q(p.proc.split('.')[0])}'; v_obj := '${q(p.proc.split('.').pop())}'; v_n := 0;
  DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = '${q(p.proc)}';
  FOR r IN (SELECT ARGUMENT_NAME, IN_OUT, DATA_TYPE, POSITION FROM ALL_ARGUMENTS WHERE OWNER = 'SCM_MGR' AND PACKAGE_NAME = v_pkg AND OBJECT_NAME = v_obj AND DATA_LEVEL = 0 AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION) LOOP
    v_n := v_n + 1;
    INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    VALUES ('${q(p.proc)}',
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN LOWER(r.ARGUMENT_NAME) ELSE PKG_NSCM_UI_COMM.FN_TO_CAMEL_CASE(REGEXP_REPLACE(r.ARGUMENT_NAME, '^P_', '')) END,
            CASE WHEN r.IN_OUT LIKE '%OUT%' THEN 'OUT' ELSE 'IN' END,
            CASE WHEN r.ARGUMENT_NAME = 'O_RESULT_CURSOR' THEN 'PROC_RESULT' ELSE PKG_NSCM_UI_COMM.FN_GET_SYSTEM_DATA_TP(r.DATA_TYPE) END,
            v_n, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  END LOOP;
  IF v_n = 0 THEN
    DBMS_OUTPUT.PUT_LINE('  WARN ${p.proc} 가 ALL_ARGUMENTS 에 없음(PKG 미배포) — As-is ${p.asis} 파라미터 ${fb.length}건으로 임시 등록 (PKG 배포 후 이 SQL 재실행)');
${fbRows || "      NULL;"}
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('${q(p.proc)}', 'o_rc1', 'OUT', 'CURSOR', ${fb.length + 1}, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
      INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, COL_TP_CD, DATA_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('${q(p.proc)}', 'o_result_cursor', 'OUT', 'PROC_RESULT', ${fb.length + 2}, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
  ELSE DBMS_OUTPUT.PUT_LINE('  OK ${p.proc} 파라미터 ' || v_n || '건'); END IF;`;
}).join('\n\n');
const apiRows = uniq.map(p => `  INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n    VALUES ('${ID}_${sheetKey(p.sheet)}_${p.btn}', 'PROC', NULL, '${ID} ${q(p.sheet)} ${p.btn}', '${q(p.proc)}', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)`).join('\n');
const btnRows = uniq.map(p => `  INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n    VALUES ('${ID}', '${q(p.sheet)}', '${p.btn}', '${ID}_${sheetKey(p.sheet)}_${p.btn}', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)`).join('\n');
const grpMenu = grpRows.filter(g => g.read).map(g => `  INTO SCM_ADM_USER_GR_MNU_MPG_M (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('${q(g.id)}', '${ID}', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)  -- As-is ${g.src}`).join('\n');
const saveBtns = uniq.filter(p => /SAVE|DEL|UPD|INS|UPLOAD/.test(p.btn));
const grpBtn = grpRows.filter(g => g.read && !g.save).flatMap(g => saveBtns.map(p => `  INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('${q(g.id)}', '${ID}', '${p.btn}', 'N', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)  -- 읽기 전용 그룹: 저장 버튼 차단`)).join('\n');
const sql = `/* ${ID}_registration.sql — 생성: tools/Harness/gen-register-sql.js ${new Date().toISOString().slice(0, 10)}
 * 원천: Doc/gen/${ID}/register.json · As-is SCM_MST_SHEET_COLUMNS(${sheetCols.length}행) + 하드코딩 컬럼(${hardN}) · TB_FX_MenuItemInfo · TB_FX_GroupMenuAuth(${groups.length})
 * 7영역: i18n(MNU) · PROC_M(ALL_ARGUMENTS 동적) · SHEET_COLUMNS · MNU_M · API_M · MNU_BTN_MPG_M · USER_GR_MNU_MPG_M(+버튼 권한)
 * 실행: SQL*Plus/SQLcl @${ID}_registration.sql  (SCM_MGR). 재실행 안전(DELETE 후 INSERT / MERGE). 마지막 COMMIT 은 BLOCK 8 결과 확인 후.
 * TODO 표시는 사람이 확정: 상위 메뉴 ID${tobeParent ? '(To-Be menu.csv 로 확정됨)' : '(To-Be menu.csv 를 export_tobe_meta.py 로 내려받으면 자동 확정)'}, 메뉴 KO/CN 명, 그룹 ID${tobeGroups.length ? '(user_group.csv 로 확정됨)' : '(As-is 그룹명 그대로 — To-Be 그룹 ID 확인)'}
 */
SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED
DEFINE V_MENU_ID     = '${ID}'
DEFINE V_MENU_MSG_ID = 'MNU_${ID}'
DEFINE V_MENU_URL    = '${q(url)}'
DEFINE V_PKG_NM      = '${q(PKG)}'
DEFINE V_USER_ID     = 'harness'

-- BLOCK 1: i18n 메뉴명 (KO/CN 은 As-is Title 로 임시 — TODO 번역)${selfMenu && (selfMenu.mnu_msg_id || selfMenu.MNU_MSG_ID) ? `\n-- 기존 메뉴가 MSG_ID ${selfMenu.mnu_msg_id || selfMenu.MNU_MSG_ID} 를 이미 쓰므로 신규 MNU_ 메시지는 등록하지 않음(아래 INSERT 는 참고용으로 주석 처리)` : ''}
${selfMenu && (selfMenu.mnu_msg_id || selfMenu.MNU_MSG_ID) ? '/*' : ''}DELETE FROM SCM_ADM_MSG_M WHERE MSG_ID = '&V_MENU_MSG_ID';
INSERT ALL
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('&V_MENU_MSG_ID', 'KO', '${q(title)}', 'MNU', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('&V_MENU_MSG_ID', 'EN', '${q(title)}', 'MNU', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
  INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE) VALUES ('&V_MENU_MSG_ID', 'CN', '${q(title)}', 'MNU', 'Y', '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE)
SELECT * FROM DUAL;${selfMenu && (selfMenu.mnu_msg_id || selfMenu.MNU_MSG_ID) ? '*/' : ''}

-- BLOCK 2: PROC_M — ALL_ARGUMENTS 에서 동적 등록 (PKG 배포 전이면 As-is 파라미터로 임시 등록 + WARN)
DECLARE v_pkg VARCHAR2(128); v_obj VARCHAR2(128); v_n NUMBER;
BEGIN
${procBlocks || "  NULL; -- 등록할 프로시저 없음(register.json procs 비어 있음)"}
END;
/

-- BLOCK 3: SHEET_COLUMNS — As-is 메타 ${sheetCols.length}행 이관 + 하드코딩 컬럼 ${hardN}건(sort 9000+, DIV 별)
DECLARE
    v_col_json CLOB := '[
${colJson.replace(/'/g, "''")}
    ]';
BEGIN
    DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = '&V_MENU_ID';
    INSERT INTO SCM_MST_SHEET_COLUMNS (PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, FIXED_FLAG, COLUMN_WIDTH,
        CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID, INPUT_TP_CD,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT '&V_MENU_ID', jt.SHT_NM, jt.COL_NM, jt.COL_LBL, jt.SORT_ORD, jt.SMALL_CLS, jt.LARGE_CLS, NVL(jt.FIXED, 'N'), NVL(jt.COL_WTH, 100), NVL(jt.CELL_TP, 'FPText'), jt.CELL_CBO, NVL(jt.SCALE, 0), NVL(jt.MAX_LEN, 200), NVL(jt.ALIGN, 'L'), NVL(jt.UPPER, 'N'), NVL(jt.VISIBLE, 'Y'), NVL(jt.DEFAULT_F, 'Y'), NVL(jt.USR_SEL, 'Y'), 'Y', NVL(jt.DIV_ID, 'ALL'), NVL(jt.INPUT_TP, 'OPTIONAL'), '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
    FROM JSON_TABLE(v_col_json, '$[*]' COLUMNS (SHT_NM VARCHAR2(50 CHAR) PATH '$.sht_nm', COL_NM VARCHAR2(100 CHAR) PATH '$.col_nm', COL_LBL VARCHAR2(200 CHAR) PATH '$.col_lbl', SORT_ORD NUMBER PATH '$.sort_ord', SMALL_CLS VARCHAR2(100 CHAR) PATH '$.small_cls', LARGE_CLS VARCHAR2(100 CHAR) PATH '$.large_cls', FIXED VARCHAR2(1 CHAR) PATH '$.fixed', COL_WTH NUMBER PATH '$.col_wth', CELL_TP VARCHAR2(50 CHAR) PATH '$.cell_tp', CELL_CBO VARCHAR2(100 CHAR) PATH '$.cell_cbo', SCALE NUMBER PATH '$.scale', MAX_LEN NUMBER PATH '$.max_len', ALIGN VARCHAR2(1 CHAR) PATH '$.align', UPPER VARCHAR2(1 CHAR) PATH '$.upper', VISIBLE VARCHAR2(1 CHAR) PATH '$.visible', DEFAULT_F VARCHAR2(1 CHAR) PATH '$.default_f', USR_SEL VARCHAR2(1 CHAR) PATH '$.usr_sel', DIV_ID VARCHAR2(100 CHAR) PATH '$.div_id', INPUT_TP VARCHAR2(50 CHAR) PATH '$.input_tp')) jt;
    DBMS_OUTPUT.PUT_LINE('[BLOCK 3] SCM_MST_SHEET_COLUMNS: ' || SQL%ROWCOUNT || ' 행');
END;
/

-- BLOCK 4: MENU (As-is: 상위 '${q(parentTitle)}', 정렬 ${menuInfo.SortOrder || 99}, 레벨 ${menuInfo.MenuLevel || 3})
MERGE INTO SCM_ADM_MNU_M T USING (SELECT '&V_MENU_ID' AS MNU_ID FROM DUAL) S ON (T.MNU_ID = S.MNU_ID)
WHEN MATCHED THEN UPDATE SET T.UPPR_MNU_ID = ${tobeParent ? `'${q(UPPR)}'` : UPPR}, T.MNU_LV_NO = ${menuInfo.MenuLevel || 3}, T.MNU_MSG_ID = ${selfMenu && (selfMenu.mnu_msg_id || selfMenu.MNU_MSG_ID) ? `'${q(selfMenu.mnu_msg_id || selfMenu.MNU_MSG_ID)}'` : "'&V_MENU_MSG_ID'"}, T.MNU_URL = '&V_MENU_URL', T.SORT_ORD = ${menuInfo.SortOrder || 99}, T.USE_YN = 'Y'${hasRouteCol ? `, T.ROUTE_PATH = '${q(routePath)}'` : ''}, T.MNU_TP_CD = NVL(T.MNU_TP_CD, 'SCREEN'), T.LAST_UPDATED_BY = '&V_USER_ID', T.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (MNU_ID, UPPR_MNU_ID, MNU_LV_NO, MNU_MSG_ID, MNU_URL, SORT_ORD, USE_YN, MNU_TP_CD${hasRouteCol ? ', ROUTE_PATH' : ''}, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES ('&V_MENU_ID', ${tobeParent ? `'${q(UPPR)}'` : UPPR}, ${menuInfo.MenuLevel || 3}, '&V_MENU_MSG_ID', '&V_MENU_URL', ${menuInfo.SortOrder || 99}, 'Y', 'SCREEN'${hasRouteCol ? `, '${q(routePath)}'` : ''}, '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE);
-- ${selfMenu ? `기존 메뉴 행 있음(USE_YN=${selfMenu.use_yn || selfMenu.USE_YN}, MNU_MSG_ID=${selfMenu.mnu_msg_id || selfMenu.MNU_MSG_ID} 유지) → USE_YN 'Y' 로 올림` : '신규 메뉴 행'}

-- BLOCK 5: API (${uniq.length})
DELETE FROM SCM_ADM_API_M WHERE API_ID LIKE '&V_MENU_ID' || '\\_%' ESCAPE '\\';
${apiRows ? 'INSERT ALL\n' + apiRows + '\nSELECT * FROM DUAL;' : '-- (없음)'}

-- BLOCK 6: MNU_BTN_MPG (시트×버튼 → API)
DELETE FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';
${btnRows ? 'INSERT ALL\n' + btnRows + '\nSELECT * FROM DUAL;' : '-- (없음)'}

-- BLOCK 7: 그룹 권한 (As-is TB_FX_GroupMenuAuth ${groups.length}건 → 읽기 그룹 메뉴 허용, 읽기 전용 그룹은 저장류 버튼 N)
DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';
DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID';
${grpMenu ? 'INSERT ALL\n' + grpMenu + '\nSELECT * FROM DUAL;' : '-- (읽기 그룹 없음)'}
${grpBtn ? 'INSERT ALL\n' + grpBtn + '\nSELECT * FROM DUAL;' : '-- (버튼 권한 분리 없음)'}

-- BLOCK 8: 검증
SELECT '1.MENU' AS AREA, COUNT(*) AS CNT FROM SCM_ADM_MNU_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL SELECT '2.PROC_M', COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE '&V_PKG_NM' || '.%'
UNION ALL SELECT '3.SHEET_COLUMNS', COUNT(*) FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = '&V_MENU_ID'
UNION ALL SELECT '5.API', COUNT(*) FROM SCM_ADM_API_M WHERE API_ID LIKE '&V_MENU_ID' || '\\_%' ESCAPE '\\'
UNION ALL SELECT '6.MNU_BTN_MPG', COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL SELECT '7.GROUP_MENU', COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL SELECT '1.I18N', COUNT(*) FROM SCM_ADM_MSG_M WHERE MSG_ID = ${selfMenu && (selfMenu.mnu_msg_id || selfMenu.MNU_MSG_ID) ? `'${q(selfMenu.mnu_msg_id || selfMenu.MNU_MSG_ID)}'` : "'&V_MENU_MSG_ID'"} ORDER BY 1;
DECLARE v_cur SYS_REFCURSOR; v_proc VARCHAR2(200); v_col VARCHAR2(100); v_dt VARCHAR2(50); v_ct VARCHAR2(50); v_so NUMBER; v_cnt NUMBER := 0;
BEGIN
  SCM_MGR.PKG_NSCM_UI_COMM.PR_GET_PROC_INFO_LIST(P_MNU_ID => '&V_MENU_ID', P_SHT_NM => '${q((uniq[0] || { sheet: 'main' }).sheet)}', P_MNU_BTN_CD => '${(uniq[0] || { btn: 'SEARCH' }).btn}', O_CURSOR => v_cur);
  LOOP FETCH v_cur INTO v_proc, v_col, v_dt, v_ct, v_so; EXIT WHEN v_cur%NOTFOUND; v_cnt := v_cnt + 1; END LOOP; CLOSE v_cur;
  DBMS_OUTPUT.PUT_LINE(CASE WHEN v_cnt = 0 THEN 'FAIL 라우팅 없음' WHEN v_cnt = 1 THEN 'WARN PROC_M 미등록(PKG 배포 후 재실행)' ELSE 'OK 파라미터 ' || v_cnt END);
END;
/
-- COMMIT;   -- BLOCK 8 확인 후 수동 커밋 (롤백: ROLLBACK;)
UNDEFINE V_MENU_ID V_MENU_MSG_ID V_MENU_URL V_PKG_NM V_USER_ID
`;
fs.writeFileSync(path.join(genDir, `${ID}_registration.sql`), sql, 'utf8');
// ── 되돌리기 스크립트: 등록 7영역을 역순으로 제거(기존 메뉴 행이 있었으면 USE_YN 만 원복, 없었으면 삭제) + PKG DROP ──
const prevUseYn = (typeof selfMenu !== 'undefined' && selfMenu) ? (selfMenu.USE_YN || selfMenu.use_yn || 'N') : null;
const revert = `/* ${ID}_revert.sql — ${ID}_registration.sql + ${ID}_PKG.sql 되돌리기 (생성: gen-register-sql.js ${new Date().toISOString().slice(0, 10)})
 * 실행: python tools/DbConn/run_sql.py Doc/gen/${ID}/${ID}_revert.sql [--commit]   (기본 ROLLBACK 미리보기)
 * 메뉴 행: ${prevUseYn !== null ? `등록 전부터 존재(USE_YN='${prevUseYn}') → USE_YN 만 원복` : '등록이 신규 생성 → 삭제'} */
SET DEFINE ON
DEFINE V_MENU_ID = '${ID}'
DEFINE V_PKG_NM  = 'PKG_${ID}'
DELETE FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';
DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = '&V_MENU_ID';
DELETE FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';
DELETE FROM SCM_ADM_API_M WHERE API_ID LIKE '&V_MENU_ID' || '\\_%' ESCAPE '\\';
DELETE FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = '&V_MENU_ID';
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE '&V_PKG_NM' || '.%';
DELETE FROM SCM_ADM_MSG_M WHERE MSG_ID = 'MNU_' || '&V_MENU_ID';
${prevUseYn !== null ? `UPDATE SCM_ADM_MNU_M SET USE_YN = '${prevUseYn}' WHERE MNU_ID = '&V_MENU_ID';` : `DELETE FROM SCM_ADM_MNU_M WHERE MNU_ID = '&V_MENU_ID';`}
BEGIN
  EXECUTE IMMEDIATE 'DROP PACKAGE SCM_MGR.&V_PKG_NM';
  DBMS_OUTPUT.PUT_LINE('DROP PACKAGE &V_PKG_NM OK');
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE = -4043 THEN DBMS_OUTPUT.PUT_LINE('PKG &V_PKG_NM 없음(건너뜀)'); ELSE RAISE; END IF;
END;
/
SELECT 'MNU_M' AS T, COUNT(*) AS N, MAX(USE_YN) AS USE_YN FROM SCM_ADM_MNU_M WHERE MNU_ID = '&V_MENU_ID'
UNION ALL SELECT 'PROC_M', COUNT(*), NULL FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE '&V_PKG_NM' || '.%'
UNION ALL SELECT 'SHEET_COLUMNS', COUNT(*), NULL FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = '&V_MENU_ID'
UNION ALL SELECT 'API_M', COUNT(*), NULL FROM SCM_ADM_API_M WHERE API_ID LIKE '&V_MENU_ID' || '\\_%' ESCAPE '\\'
UNION ALL SELECT 'BTN_MPG', COUNT(*), NULL FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = '&V_MENU_ID';
UNDEFINE V_MENU_ID V_PKG_NM
`;
fs.writeFileSync(path.join(genDir, `${ID}_revert.sql`), revert, 'utf8');
console.log(`${ID}_registration.sql → ${genDir}  (PROC ${uniq.length} · 시트컬럼 ${sheetCols.length}+${hardN} · 그룹 ${grpRows.length} · 상위메뉴 ${tobeParent ? '확정' : 'TODO'})`);
