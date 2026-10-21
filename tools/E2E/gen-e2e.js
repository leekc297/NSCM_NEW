#!/usr/bin/env node
'use strict';
// gen-e2e — Fact Pack(e2e_plan.json) + Oracle 메타 + 테스트계정 → Playwright 스펙 생성
//   node gen-e2e.js [ID ...] [--all]      ID 없고 --all 이면 Doc/gen/*/e2e_plan.json 전부
//   산출: Doc/e2e/specs/<ID>.smoke.spec.ts / <ID>.crud.spec.ts / <ID>.auth.spec.ts / <ID>.authcrud.spec.ts(2026-10-20 계정별 권한 CRUD) / <ID>.plan.json, _index.csv, _matrix.csv
const fs = require('fs'); const path = require('path');
const cfg = JSON.parse(fs.readFileSync(path.join(__dirname, 'e2e.config.json'), 'utf8').replace(/^﻿/, ''));
const a = process.argv.slice(2);
// 2026-10-20 테스트 모드(화면 성격별 계정 축) — --mode admin|division|auto. 명시하면 users.json screens[<메뉴>].mode 에 저장돼 다음 기본값이 된다
const MODE_ARG = (() => { const i = a.indexOf('--mode'); const v = i >= 0 ? String(a[i + 1] || '').toLowerCase() : (a.find(x => x.startsWith('--mode=')) || '').slice(7).toLowerCase(); return /^(admin|division|auto)$/.test(v) ? v : ''; })();
const ids = a.filter((x, i) => !x.startsWith('--') && a[i - 1] !== '--mode').map(x => x.toUpperCase());
const specs = cfg.specsDir; fs.mkdirSync(specs, { recursive: true });
const readCsv = f => { if (!fs.existsSync(f)) return []; const t = fs.readFileSync(f, 'utf8').replace(/^﻿/, ''); const lines = []; let cur = '', q = false, row = []; for (let i = 0; i < t.length; i++) { const ch = t[i]; if (q) { if (ch === '"') { if (t[i + 1] === '"') { cur += '"'; i++; } else q = false; } else cur += ch; } else if (ch === '"') q = true; else if (ch === ',') { row.push(cur); cur = ''; } else if (ch === '\n' || ch === '\r') { if (ch === '\r' && t[i + 1] === '\n') i++; row.push(cur); lines.push(row); row = []; cur = ''; } else cur += ch; } if (cur || row.length) { row.push(cur); lines.push(row); } const h = lines.shift() || []; return lines.filter(r => r.length > 1 || r[0]).map(r => Object.fromEntries(h.map((k, i) => [k, r[i] ?? '']))); };
const up = s => (s || '').toUpperCase();
const accounts = fs.existsSync(path.join(__dirname, 'accounts.json')) ? JSON.parse(fs.readFileSync(path.join(__dirname, 'accounts.json'), 'utf8')) : { accounts: [], authMatrix: [], divisions: ['40'] };
const scenarios = readCsv(path.join(__dirname, 'scenarios.csv'));
const sheetCols = readCsv(path.join(cfg.tobeOutDir, 'db', 'sheet_columns.csv'));
const btnAuth = readCsv(path.join(cfg.tobeOutDir, 'db', 'btn_auth.csv'));
const menu = readCsv(path.join(cfg.tobeOutDir, 'db', 'menu.csv'));
// 2026-10-21(SCP0100 smoke): To-Be 화면은 LBL 코드로 라벨을 그리므로 기대 라벨 = msg_master 의 LBL 문구(EN 우선). As-is 라벨('Plan date*','Plan-type')은 후보로만.
const msgMaster = readCsv(path.join(cfg.tobeOutDir, 'db', 'msg_master.csv'));
const lblText = code => { if (!code) return ''; const rows = msgMaster.filter(r => up(r.msg_id) === up(code) && (r.use_yn || 'Y') !== 'N'); const r = rows.find(x => up(x.lang_cd) === 'EN') || rows[0]; return r ? String(r.msg_nm || '').trim() : ''; };
const feRoot = cfg.feRoot || path.resolve(cfg.genOutDir, '..', '..', 'nscm-fe');
// 2026-10-20 auth별 CRUD: 계정별 기대 권한의 원천 = To-Be 메타(사용자→그룹 user_group_user · 그룹→메뉴 user_group_menu · 그룹×메뉴×버튼 btn_auth). 데이터셋(accounts.json) 의 그룹은 참고 표기만
const ugUser = readCsv(path.join(cfg.tobeOutDir, 'db', 'user_group_user.csv'));
const ugMenu = readCsv(path.join(cfg.tobeOutDir, 'db', 'user_group_menu.csv'));
// 사용자 관리 명부 users.json → 계정 목록(역할·Division 배정은 표기/범위용, 기대 권한은 To-Be 메타로 계산)
const USERS = (() => { const f = path.join(__dirname, 'users.json'); if (!fs.existsSync(f)) return null; try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, '')); } catch (e) { console.error(`users.json 해석 실패: ${e.message}`); return null; } })();
function rosterAccounts(u, okIds) {
  const byId = new Map(); const allDivs = Object.keys(u.divisions || {});
  const get = id => { if (!byId.has(id)) byId.set(id, { id, name: (u.names || {})[id] || '', groups: [], divisions: [], roles: {}, adminAlso: false, adminOf: [], usable: true, screens: {}, loginOk: okIds ? okIds.includes(id) : true, source: 'users.json' }); return byId.get(id); };
  for (const [div, roles] of Object.entries(u.divisions || {})) for (const [role, id] of Object.entries(roles || {})) { if (!id) continue; const a = get(id); if (!a.divisions.includes(div)) a.divisions.push(div); a.roles[div] = role; if (!a.groups.includes(role)) a.groups.push(role); }
  for (const [adm, ids] of Object.entries(u.admins || {})) for (const id of ids || []) { const a = get(id); a.adminAlso = true; a.adminOf.push(adm); if (!a.groups.includes(adm)) a.groups.push(adm); if (!a.groups.includes('SYSTEM ADMIN')) a.groups.push('SYSTEM ADMIN'); for (const d of allDivs) if (!a.divisions.includes(d)) a.divisions.push(d); }
  const list = [...byId.values()];
  const noLogin = list.filter(a => !a.loginOk).map(a => a.id); if (noLogin.length) console.error(`  ⚠ users.json 계정 중 로그인 불가(BE 사용자 없음): ${noLogin.join(', ')} — 스펙에서 제외`);
  return list.filter(a => a.loginOk);
}
const tobeGroupsOf = uid => [...new Set(ugUser.filter(r => up(r.user_id) === up(uid) && (r.use_yn || 'Y') !== 'N').map(r => r.user_gr_id))];
// 권한 메타 스냅샷 나이 — 사내 권한은 수시로 바뀐다(2026-10-20: SCM Viewer 의 SCP0096 SAVE 가 10-19 export 뒤 제거돼 기대가 어긋남). run-e2e.cmd 가 실행 전 새로고침한다
{ const f = path.join(cfg.tobeOutDir, 'db', 'btn_auth.csv'); if (fs.existsSync(f)) { const h = (Date.now() - fs.statSync(f).mtimeMs) / 36e5; if (h > 24) console.error(`  ⚠ 권한 메타(btn_auth.csv) 가 ${Math.round(h)}시간 전 스냅샷 — python tools/DbConn/export_tobe_meta.py btn_auth user_group_user user_group_menu 로 새로고침 권장`); } }
const mapScreen = readCsv(path.join(path.dirname(cfg.genOutDir), '..', 'tools', 'Harness', 'rules', 'map_screen.csv'));
const tobeIdOf = id => { const m = mapScreen.find(r => up(r.asis_id) === id); return m && m.tobe_id ? up(m.tobe_id) : id; };

const planDirs = ids.length ? ids : (a.includes('--all') ? fs.readdirSync(cfg.genOutDir).filter(d => fs.existsSync(path.join(cfg.genOutDir, d, 'e2e_plan.json'))) : []);
if (!planDirs.length) { console.error('화면ID 또는 --all 을 지정하세요 (Doc/gen/<ID>/e2e_plan.json 필요 — gen.js 선행)'); process.exit(2); }
const idxRows = [], matrixRows = [];
const J = v => JSON.stringify(v);
const esc = s => String(s).replace(/[\\`$]/g, '\\$&');

for (const id0 of planDirs) {
  const id = up(id0); const pf = path.join(cfg.genOutDir, id, 'e2e_plan.json');
  if (!fs.existsSync(pf)) { console.error(`  ${id}: e2e_plan.json 없음 (node ../Harness/gen.js ${id} 먼저)`); continue; }
  const P = JSON.parse(fs.readFileSync(pf, 'utf8')); const MENU = tobeIdOf(P.menuId);
  const mainSheets = P.sheets.filter(s => !s.popup && s.name !== 'spreadTitle');
  // 2026-10-21: FE 시트명(call-proc 경로의 sheet, 예 searchLevel) → admin 시트명(SEARCH_LEVEL). 기대 컬럼은 '실제 조회된 시트' 기준으로 고른다
  //   (SCP0100: 기본 Search Mode 가 SEARCH_LEVEL 시트인데 mainSheets[0]=REPORT 컬럼을 기대해 '누락 6' 오탐)
  const regF = path.join(cfg.genOutDir, id, 'register.json'); const REG = fs.existsSync(regF) ? JSON.parse(fs.readFileSync(regF, 'utf8').replace(/^\uFEFF/, '')) : null;
  const sheetMap = Object.fromEntries(((REG && REG.sheets) || []).filter(x => x.sheetName && x.adminSheetName).map(x => [x.sheetName, x.adminSheetName]));
  // FE 페이지의 __asis-mapping__.md 에서 '제외' 로 닫힌 As-is 컨트롤(dead control·NO-OP 등) — 그 조회조건은 라벨 검사 대상에서 뺀다(어노테이션만)
  const mapMd = REG && REG.feature && REG.pageDir ? path.join(feRoot, 'features', REG.feature, 'src', 'pages', REG.pageDir, '__asis-mapping__.md') : '';
  const excludedRows = mapMd && fs.existsSync(mapMd) ? fs.readFileSync(mapMd, 'utf8').split(/\r?\n/).filter(l => /^\|/.test(l) && /\|\s*제외\s*\|\s*$/.test(l)) : [];
  //   컨트롤 행(§1 …)만 본다 — §2 이벤트 행의 '제외'(핸들러 본문 공백 등)는 컨트롤 자체는 살아 있으므로 라벨 검사 대상(SCP0100 chkCellQty·cboDisplay 오판 방지)
  const excludedReason = asis => { if (!asis) return ''; const re = new RegExp(`\\b${asis}\\b`, 'i'); const row = excludedRows.find(l => { const cells = l.split('|').map(x => x.trim()).filter(Boolean); return !!cells[1] && /^§1\b/.test(cells[1]) && re.test(cells[1]); }); if (!row) return ''; const cells = row.split('|').map(x => x.trim()).filter(Boolean); return `${cells[0] || ''} ${cells[1] || ''}`.trim().slice(0, 120); };
  const fieldsPlan = (P.fields || []).map(f => {
    const asisLabel = String(f.label || '').replace(/^\s*\*+\s*|\s*\*+\s*$/g, '').trim(); const tobe = lblText(f.lbl);
    const cands = [tobe, asisLabel, ...asisLabel.split('/').map(x => x.trim()).filter(x => x.length >= 2)];
    if (f.kind === 'period' || /Period/i.test(f.component || '')) cands.push('From', 'To', 'Period', '기간');
    const ex = excludedReason(f.asis);
    return Object.assign({}, f, { tobeLabel: tobe, labels: [...new Set(cands.filter(Boolean))], excluded: ex ? true : false, excludedWhy: ex });
  });
  // 메타 기대 컬럼(화면×시트×DIV) — 없으면 Fact Pack 라벨
  const metaFor = (sheet, div) => sheetCols.filter(r => up(r.program_id) === MENU && r.sheet_name.toLowerCase() === sheet.toLowerCase() && (r.visible_flag || 'Y') !== 'N' && (r.valid_yn || 'Y') !== 'N' && (!r.division_id || !div || r.division_id === div || r.division_id.split('_')[0] === div)).sort((x, y) => Number(x.sort_order_no) - Number(y.sort_order_no)).map(r => r.column_label_name || r.column_name);
  const divs = (accounts.divisions && accounts.divisions.length ? accounts.divisions : [cfg.defaultDivision]);
  const expectedCols = Object.fromEntries(mainSheets.map(s => [s.name, Object.fromEntries(divs.map(d => [d, metaFor(s.name, d).slice(0, 40)]))]));
  const hasMeta = Object.values(expectedCols).some(o => Object.values(o).some(arr => arr.length));
  // 시나리오 파라미터(화면 기준) → Division/Item/Site 샘플
  const sc = scenarios.filter(r => up(r['화면']) === MENU || up(r['화면']) === id);
  const sample = Object.assign({}, sc[0] || scenarios.find(r => r['DIV'] === cfg.defaultDivision) || {});
  // 샘플 계정은 BE dev-login 으로 확인된 계정만(probe-accounts.js → accounts.loginProbe.ok). 미확인이면 defaultAccount 로.
  { const okIds = (accounts.loginProbe && accounts.loginProbe.ok) || null; const want = cfg.forceAccount || sample['테스트계정'] || cfg.defaultAccount; // forceAccount: 사용자 지정 계정 고정
    const pick = okIds ? (okIds.includes(want) ? want : (okIds.find(x => (accounts.accounts.find(a => a.id === x) || {}).divisions?.includes(sample.DIV || sample.div || cfg.defaultDivision)) || okIds.includes(cfg.defaultAccount) && cfg.defaultAccount || okIds[0])) : want;
    sample.account = cfg.forceAccount || pick; }
  // 권한: btn_auth.csv(그룹×메뉴×버튼) 있으면 그룹별 기대 버튼
  const authRows = btnAuth.filter(r => Object.values(r).some(v => up(v) === MENU));
  const grpCol = authRows.length ? Object.keys(authRows[0]).find(k => /GR(OUP)?_?(ID|NM|CD)/i.test(k)) : null; const btnCol = authRows.length ? Object.keys(authRows[0]).find(k => /BTN/i.test(k) && !/MNU_ID|GR/i.test(k)) : null;
  const expectedBtnsByGroup = {}; if (grpCol && btnCol) for (const r of authRows) (expectedBtnsByGroup[r[grpCol]] = expectedBtnsByGroup[r[grpCol]] || new Set()).add(r[btnCol]);
  // 동적 헤더(기간 컬럼) 기대 — 2026-10-20 SCP0096: 기대 컬럼이 sheet_columns 메타(정적 6)뿐이라 기간 컬럼 0 인 화면이 '헤더 6/기대 6' PASS.
  //   As-is Fact Pack 에서 기간형 타이틀 SP(GetSpdTitle → *_3SPAN 등)·grid_code DB루프(DB_DRIVEN 컬럼 생성)를 찾으면 smoke 가
  //   ①정적 메타에 없는 컬럼 binding ≥1 ②사내 배선 타이틀 시트 조회 를 확인한다. 판정 = tools/Harness/lib/dyncol(check.js B27·gap.js 와 동일).
  const dynamicHeader = (() => {
    try {
      const DY = require(path.join(__dirname, '..', 'Harness', 'lib', 'dyncol'));
      const asisId = (mapScreen.find(r => up(r.tobe_id) === MENU) || {}).asis_id || id; const sd = path.join(cfg.asisOutDir, 'screens', up(asisId));
      if (!fs.existsSync(path.join(sd, 'endpoints.csv'))) return null;
      const titles = DY.asisTitleEndpoints(readCsv(path.join(sd, 'endpoints.csv'))).filter(t => t.kind === 'period'); const dbLoop = DY.asisDbLoop(sd);
      if (!titles.length && !dbLoop.length) return null;
      const pm = readCsv(path.join(cfg.tobeOutDir, 'db', 'proc_meta.csv')).filter(r => up(r.menu_id) === MENU && r.use_yn !== 'N' && r.proc);
      // (시트,버튼) 쌍 — 같은 시트에 데이터 SEARCH 와 타이틀 버튼이 함께 배선될 수 있어 호출 판정은 쌍 단위(DMF0020 main/SPREAD_TITLE_DATE)
      const exactPairs = titles.flatMap(t => { const c = DY.corpTitleSheets(t.sp, pm); return c.via === 'exact' ? c.pairs : []; });
      const titlePairs = (exactPairs.length ? exactPairs : DY.corpAllTitlePairs(pm)).map(p => ({ sheet: p.sheet, btn: p.btn })).filter((p, i, arr) => arr.findIndex(x => x.sheet === p.sheet && x.btn === p.btn) === i);
      const titleSheets = [...new Set(titlePairs.map(p => p.sheet))];
      const staticBindings = [...new Set(sheetCols.filter(r => up(r.program_id) === MENU && mainSheets.some(s => s.name.toLowerCase() === (r.sheet_name || '').toLowerCase())).map(r => up(r.column_name)))];
      return { titles: titles.map(t => ({ sp: t.sp, members: t.members })), dbLoop, titleSheets, titlePairs, staticBindings };
    } catch (e) { console.error(`  ${id}: 동적 헤더 판정 실패 — ${e.message}`); return null; }
  })();
  // 2026-10-20: 계정 원천 = users.json(사용자 관리 명부) 이 있으면 그것(Division 별 역할 계정 + ADMIN 계정 전부), 없으면 데이터셋 accounts.json.
  //   로그인 가능 여부는 probe-accounts.js 결과(loginProbe.ok)로 거른다 — 명부에 있지만 BE 에 없는 계정은 '로그인 불가' 로 목록에만 남긴다
  const okIds = (accounts.loginProbe && accounts.loginProbe.ok) || null;
  const accsAll = USERS ? rosterAccounts(USERS, okIds) : accounts.accounts.filter(x => (x.usable || x.adminAlso) && (okIds ? x.loginOk : true));
  // 메뉴에 등록된 버튼 코드 전체(어느 그룹이든) — 이 메뉴에 INSERT/DELETE 코드 자체가 없으면 그 버튼은 비교하지 않는다
  const menuBtnCodes = [...new Set(authRows.filter(r => (r.use_yn || 'Y') !== 'N').map(r => up(r[btnCol] || '')).filter(Boolean))];
  const accountTruth = x => {
    const tg = tobeGroupsOf(x.id);
    // BE PKG_NSCM_UI_COM_AUTH.PR_GET_MNU_BTN_AUTH(사내 원문 2026-10-20 확인) = 사용자 그룹(UG) ⋈ 그룹 메뉴권한(GM, 같은 그룹) ⋈ 그룹 버튼권한(GMB, 같은 그룹)
    //   → 버튼 기대 = '그 메뉴 권한이 있는 그룹' 들의 버튼 합집합. 메뉴 권한 없는 그룹의 btn_auth 행은 세지 않는다
    const hasMenu = g => ugMenu.some(r => r.user_gr_id === g && up(r.mnu_id) === MENU && (r.use_yn || 'Y') !== 'N');
    const tgMenu = ugMenu.length ? tg.filter(hasMenu) : tg;
    const menuAccess = !ugMenu.length ? '' : (tgMenu.length ? 'Y' : 'N');
    const btns = grpCol && btnCol ? [...new Set(authRows.filter(r => tgMenu.includes(r[grpCol]) && (r.use_yn || 'Y') !== 'N').map(r => up(r[btnCol])))] : null;
    const matrix = (accounts.authMatrix || []).filter(m => up(m.screen) === MENU && x.groups.includes(m.group)).map(m => `${m.group}/${m.div}:${m.editMeasure || '-'}${m.editDay ? '@' + m.editDay : ''}`);
    return { tobeGroups: tg, menuAccess, expectedBtns: btns && authRows.length ? btns : null, matrix };
  };
  // ── 테스트 모드 → 계정 축 ──
  //   admin   : 영역 ADMIN(SYSTEM ADMIN 겸, DMF→DM ADMIN / SCP→SCP ADMIN / SSP→SSP ADMIN) + 메뉴 권한 없는 사용자 1명, Division 반복 없음(마스터 화면)
  //   division: Division 별 역할 계정 전부 + 영역 ADMIN (Division 데이터 범위가 있는 화면)
  //   auto    : users.json screens[<메뉴>].mode → 없으면 화면 메타(Division 조회조건 유무)로 추정. 사용자가 실행 시 지정하는 것이 원칙
  const SCREENS = (USERS && USERS.screens) || {};
  const area = /^DM/i.test(MENU) ? 'DM ADMIN' : /^SCP/i.test(MENU) ? 'SCP ADMIN' : /^SSP/i.test(MENU) ? 'SSP ADMIN' : '';
  const hasDivField = (P.fields || []).some(f => /division/i.test(f.label || '') || /division/i.test(f.component || '')) || (P.handlers || []).some(h => /division/i.test(JSON.stringify(h)));
  const saved = SCREENS[MENU] || SCREENS[id] || null;
  const mode = MODE_ARG && MODE_ARG !== 'auto' ? MODE_ARG : (saved && saved.mode) || (hasDivField ? 'division' : 'admin');
  const modeSource = MODE_ARG && MODE_ARG !== 'auto' ? '--mode' : (saved && saved.mode) ? 'users.json screens' : `auto(Division 조회조건 ${hasDivField ? '있음' : '없음'})`;
  if (MODE_ARG && MODE_ARG !== 'auto' && USERS) { try { USERS.screens = USERS.screens || {}; USERS.screens[MENU] = Object.assign({}, USERS.screens[MENU] || {}, { mode: MODE_ARG, updated: new Date().toISOString().slice(0, 10) }); fs.writeFileSync(path.join(__dirname, 'users.json'), JSON.stringify(USERS, null, 2) + '\n', 'utf8'); } catch (e) { console.error(`  users.json screens 저장 실패: ${e.message}`); } }
  const truthAll = new Map(accsAll.map(x => [x.id, accountTruth(x)]));
  const isAreaAdmin = x => x.adminAlso && (!area || (x.adminOf || []).includes(area) || (x.adminOf || []).length >= 3);
  let accs;
  if (mode === 'admin') {
    // 2026-10-20 사용자 지시: ADMIN 계정 하나 + 메뉴 권한 없는 사용자 1명. ADMIN 은 그 영역 '전용' ADMIN(예: SCP → jaeuk.shin) 우선, 없으면 공통(minyonglee1)
    const admins = accsAll.filter(isAreaAdmin);
    const admin1 = admins.find(x => (x.adminOf || []).length === 1 && (!area || x.adminOf[0] === area)) || admins.find(x => (x.adminOf || []).includes(area)) || admins[0] || null;
    const noAuth = accsAll.find(x => !x.adminAlso && truthAll.get(x.id).menuAccess === 'N') || accsAll.find(x => !x.adminAlso && !(truthAll.get(x.id).expectedBtns || []).includes('SAVE')) || null;
    accs = (admin1 ? [admin1] : []).concat(noAuth ? [noAuth] : []).map(x => Object.assign({}, x, { divisions: [sample['DIV'] || cfg.defaultDivision], roleNote: x.adminAlso ? 'ADMIN' : '권한 없음 대표' }));
    if (!admin1) console.error(`  ⚠ ${MENU}: 명부(users.json admins)에 ${area || 'ADMIN'} 계정이 없어 ADMIN 검증 생략`);
    if (!noAuth) console.error(`  ⚠ ${MENU}: 메뉴 권한 없는 계정을 명부에서 찾지 못해 ADMIN 만 검증`);
  } else {
    // division 모드도 '필요한 계정만'(2026-10-20 사용자: 명부 = 계정 풀, 전수 테스트 아님): 화면 영역의 역할만 Division 별로 + 영역 ADMIN 1 + 메뉴 권한 없는 사용자 1
    const roleRe = area === 'DM ADMIN' ? /^DM\b/i : area === 'SCP ADMIN' ? /^SCP\b/i : area === 'SSP ADMIN' ? /^SSP\b/i : /./;
    const roleAccs = accsAll.filter(x => !x.adminAlso && Object.values(x.roles || {}).some(r => roleRe.test(r)));
    const admins = accsAll.filter(isAreaAdmin);
    const admin1 = admins.find(x => (x.adminOf || []).length === 1 && (!area || x.adminOf[0] === area)) || admins.find(x => (x.adminOf || []).includes(area)) || admins[0] || null;
    const noAuth = accsAll.find(x => !x.adminAlso && !roleAccs.includes(x) && truthAll.get(x.id).menuAccess === 'N') || null;
    accs = roleAccs.concat(admin1 ? [Object.assign({}, admin1, { roleNote: 'ADMIN' })] : []).concat(noAuth ? [Object.assign({}, noAuth, { divisions: [sample['DIV'] || cfg.defaultDivision], roleNote: '권한 없음 대표' })] : []);
    if (!roleAccs.length) console.error(`  ⚠ ${MENU}: 명부(users.json divisions)에 ${area ? area.replace(' ADMIN', '') + ' 계열' : ''} 역할 계정이 없음 — ADMIN/권한없음만 검증`);
  }
  console.log(`  ${id} 테스트 모드 ${mode} (${modeSource}) → 계정 ${accs.length}: ${accs.map(x => x.id).join(', ')}`);
  const plan = { id, mode, modeSource, menuId: MENU, page: P.page, routePath: P.routePath, asisName: P.asisName, fields: fieldsPlan, sheetMap, asisMapping: mapMd && fs.existsSync(mapMd) ? path.relative(feRoot, mapMd) : '', buttons: P.buttons, mainSheets: mainSheets.map(s => ({ name: s.name, key: s.key, labels: s.labels.slice(0, 40) })), popupSheets: P.sheets.filter(s => s.popup).map(s => s.name), hasSave: P.hasSave, hasSpreadTitle: P.hasSpreadTitle, procs: P.procs, expectedCols, hasMeta, dynamicHeader, sample: { div: sample['DIV'] || cfg.defaultDivision, item: sample['ITEM_ID'] || '', site: sample['SCM_SITE_ID'] || '', project: sample['PROJECT_CODE'] || '', account: sample.account || sample['테스트계정'] || cfg.defaultAccount }, accounts: accs.map(x => Object.assign({ id: x.id, name: x.name || '', groups: x.groups, divisions: x.divisions, roles: x.roles || {}, roleNote: x.roleNote || '', admin: x.adminAlso, adminOf: x.adminOf || [], screenGroup: (x.screens || {})[MENU] || (x.screens || {})[id] || '', source: x.source || 'accounts.json' }, accountTruth(x))), accountSource: USERS ? 'users.json' : 'accounts.json', expectedBtnsByGroup: Object.fromEntries(Object.entries(expectedBtnsByGroup).map(([k, v]) => [k, [...v]])), menuBtnCodes, menuAuth: menu.length ? 'menu.csv' : '', authSource: { groups: ugUser.length ? 'user_group_user.csv' : '', menus: ugMenu.length ? 'user_group_menu.csv' : '', buttons: authRows.length ? 'btn_auth.csv' : '' } };
  fs.writeFileSync(path.join(specs, `${id}.plan.json`), JSON.stringify(plan, null, 2), 'utf8');
  const relLib = path.relative(specs, path.join(__dirname, 'lib', 'crud')).replace(/\\/g, '/');
  const head = `// 자동 생성 — tools/E2E/gen-e2e.js (${new Date().toISOString().slice(0, 10)}) · 원천: Doc/gen/${id}/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것\nimport { test, expect } from '${path.relative(specs, path.join(__dirname, 'fixtures', 'test')).replace(/\\/g, '/')}';\nimport * as fs from 'node:fs';\nconst PLAN = JSON.parse(fs.readFileSync(__dirname + '/${id}.plan.json', 'utf8'));\nconst MENU = ${J(MENU)};\n`;
  const headCrud = head + `import { crudCycle } from '${relLib}';\n`;

  // ── smoke
  fs.writeFileSync(path.join(specs, `${id}.smoke.spec.ts`), head + `
test.describe(\`\${MENU} ${esc(P.asisName)} 스모크 @smoke\`, () => {
  test.use({ account: PLAN.sample.account || undefined });
  test('화면 열림 · 조회조건 · 조회 · 그리드 컬럼', async ({ nscm, page }) => {
    const r = await nscm.openScreen(MENU);
    expect(r.notFound, '404 아님').toBeFalsy();
    expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
    await nscm.snapshot(\`\${MENU}_open\`);
    // 조회조건 라벨 존재(soft) — 2026-10-21: 접힌 조건(extraConditions) 펼친 뒤, To-Be LBL 문구 → As-is 라벨('*' 제거) → '/' 분할 후보 순으로 찾는다.
    //   __asis-mapping__.md 에서 '제외' 로 닫힌 As-is 컨트롤(dead control·NO-OP)은 검사하지 않고 어노테이션만 남긴다.
    const expanded = await nscm.expandSearchArea();
    const labelHits: string[] = [], labelMiss: string[] = [], labelSkip: string[] = [];
    for (const f of PLAN.fields) {
      if (f.excluded) { labelSkip.push(\`\${f.label}(\${f.asis}: \${f.excludedWhy})\`); continue; }
      const hit = await nscm.fieldExistsAny(f.labels && f.labels.length ? f.labels : [f.label]);
      if (hit) labelHits.push(\`\${f.label}→\${hit}\`); else labelMiss.push(f.label);
      expect.soft(!!hit, \`조회조건 '\${f.label}' (\${f.component}) — 후보 [\${(f.labels || [f.label]).join(' | ')}]\`).toBeTruthy();
    }
    test.info().annotations.push({ type: 'labels', description: \`펼침=\${expanded} 일치 \${labelHits.length} / 누락 \${labelMiss.length}\${labelMiss.length ? ': ' + labelMiss.join(', ') : ''}\${labelSkip.length ? ' / 제외 ' + labelSkip.length + ': ' + labelSkip.join('; ') : ''}\` });
    // 그리드 수 ≥ 1 (다그리드는 탭/패널이라 1 이상이면 통과, 메인시트 수와 함께 기록)
    const gridCount = await nscm.grids().count();
    expect(gridCount, \`그리드 ≥1 (메인시트 \${PLAN.mainSheets.length})\`).toBeGreaterThanOrEqual(1);
    // Division 선택(있으면) 후 조회
    if (PLAN.sample.div) await nscm.setDivision(PLAN.sample.div);
    const calls = await nscm.search();
    const search = calls.filter(c => /SEARCH|GET|_|^$/i.test(c.btn));
    expect(calls.length, 'call-proc 호출 발생').toBeGreaterThan(0);
    for (const c of calls) expect.soft(c.status, \`call-proc \${c.sheet}/\${c.btn} HTTP\`).toBeLessThan(400);
    const alert = await nscm.alertText(); if (alert) { await nscm.closeAlert(); }
    expect.soft(alert, '조회 후 오류 알림 없음').not.toMatch(/ORA-|Exception|오류|error/i);
    // 컬럼 대사: 메타(sheet_columns) 있으면 메타, 없으면 As-is 라벨(soft)
    const headers = await nscm.gridHeaders(0);
    // 기대 컬럼의 시트 = 실제 조회된 시트(첫 SEARCH call-proc 의 sheet → register.json adminSheetName). 매핑이 없으면 mainSheets[0]
    const titleSheets: string[] = (PLAN.dynamicHeader && PLAN.dynamicHeader.titleSheets) || [];
    const firstSearch = calls.find(c => /SEARCH/i.test(c.btn) && !titleSheets.includes(c.sheet)) || calls.find(c => /SEARCH/i.test(c.btn)) || calls[0]; // 타이틀(기간 헤더) 시트 호출은 제외
    const mappedSheet = firstSearch && PLAN.sheetMap ? PLAN.sheetMap[firstSearch.sheet] : '';
    const sheetName = mappedSheet && PLAN.mainSheets.some((s: { name: string }) => s.name === mappedSheet) ? mappedSheet : PLAN.mainSheets[0]?.name;
    const expectCols = PLAN.hasMeta ? (PLAN.expectedCols[sheetName]?.[PLAN.sample.div] || []) : (PLAN.mainSheets.find((s: { name: string }) => s.name === sheetName)?.labels || []);
    const norm = (s: string) => s.toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
    const missing = expectCols.filter((c: string) => c && !headers.some(h => norm(h) === norm(c) || norm(h).includes(norm(c))));
    test.info().annotations.push({ type: 'columns', description: \`시트 \${sheetName}(\${firstSearch ? firstSearch.sheet : '-'}) 헤더 \${headers.length} / 기대 \${expectCols.length} / 누락 \${missing.length}: \${missing.slice(0, 10).join(', ')}\` });
    expect.soft(missing.length, \`그리드 컬럼 누락 (\${PLAN.hasMeta ? '메타' : 'As-is 라벨'} 기준)\`).toBeLessThanOrEqual(Math.ceil(expectCols.length * 0.2));
    // 동적 헤더(기간 컬럼) — As-is 타이틀 SP/DB루프가 있으면 정적 메타 밖 컬럼 ≥1 + 사내 배선 타이틀 시트 조회(2026-10-20 SCP0096)
    if (PLAN.dynamicHeader) {
      const DH = PLAN.dynamicHeader;
      const binds = await nscm.gridBindings(0);
      const stat = new Set((DH.staticBindings || []).map((s: string) => s.toUpperCase()));
      const dyn = (binds || []).filter((b: string) => !stat.has(b.toUpperCase()));
      const titleCalls = nscm.calls.filter(c => (DH.titlePairs || []).some((p: { sheet: string; btn: string }) => p.sheet === c.sheet && p.btn.toUpperCase() === c.btn.toUpperCase()));
      test.info().annotations.push({ type: 'dynamic', description: \`As-is \${DH.titles.map((t: { sp: string }) => t.sp).join(',') || '-'} · DB루프 \${(DH.dbLoop || []).join(',') || '-'} · 컬럼정의 \${binds ? binds.length : '판정불가'} / 정적밖 \${dyn.length} (\${dyn.slice(0, 5).join(',')}) · 타이틀 시트 \${(DH.titleSheets || []).join(',') || '(사내 배선 없음)'} 호출 \${titleCalls.length}\` });
      expect.soft(binds, '그리드 컬럼 정의 판독(Wijmo columns) — null 이면 판정 불가(ERROR)').not.toBeNull();
      expect.soft(dyn.length, \`동적 기간 컬럼 ≥1 (As-is \${DH.titles.map((t: { sp: string }) => t.sp).join(',') || 'DB루프'} — 정적 메타 \${stat.size}개 밖 컬럼)\`).toBeGreaterThan(0);
      if ((DH.titleSheets || []).length) expect.soft(titleCalls.some(c => c.status < 400), \`타이틀 시트 '\${DH.titleSheets.join(\"','\")}' call-proc 조회\`).toBeTruthy();
    }
    await nscm.snapshot(\`\${MENU}_searched\`);
    test.info().annotations.push({ type: 'calls', description: JSON.stringify(calls.map(c => [c.sheet, c.btn, c.status, c.rows, c.ms])) });
  });
});
`, 'utf8');

  // ── crud — 공용 사이클(lib/crud.ts): Insert 화면만 마커 행 C→R→U→D(끝에 정리), Insert 없는 저장 화면은 편집기 열림만(기존 행 보호), 조회 전용은 Save 비노출
  const crudBody = P.hasSave ? `
test.describe.serial(\`\${MENU} ${esc(P.asisName)} CRUD @crud\`, () => {
  test.use({ account: PLAN.sample.account || undefined });
  const MARK = ${J(cfg.crudMarker)} + Date.now().toString(36).toUpperCase();
  test('Save 노출 · Insert 화면은 마커 행 Insert→Save→재조회→수정→Delete→Save→재조회 · Insert 없는 화면은 셀 수정 Save→재조회→원복 Save→재조회', async ({ nscm }) => {
    test.setTimeout(300_000); // 수정 저장 → 재조회 → 원복 저장 → 재조회(저장·조회 각 최대 60~120s)
    const r = await nscm.openScreen(MENU); expect(r.authorized).toBeTruthy();
    if (PLAN.sample.div) await nscm.setDivision(PLAN.sample.div);
    await nscm.search();
    const out = await crudCycle(nscm, test.info(), PLAN, MARK);
    expect(out.saveVisible, 'As-is 저장 SP 있음 → Save(F7) 버튼').toBeTruthy();
    if (out.mode === 'insert') {
      expect.soft(out.inserted, 'Insert(F8) 로 행 추가').toBeTruthy();
      expect.soft(out.saved, \`마커 행 저장 성공 \${out.saveErrors.join(' / ')}\`).toBeTruthy();
      expect.soft(out.found, '재조회 후 신규 행 존재').toBeTruthy();
      if (out.found) expect.soft(out.updated, '수정 반영').toBeTruthy();
      expect(out.cleaned, '마커 행 정리(삭제) 완료 — 남아 있으면 수동 삭제 필요').toBeTruthy();
    } else if (out.mode === 'edit-save') {
      // 셀 편집 저장형: 값 변경 → Save → 재조회 반영 → 원복 Save → 재조회 복원 (2026-10-20 사용자 승인)
      expect.soft(out.editable, '편집 가능 셀 존재(값 변경됨)').toBeTruthy();
      if (out.editable) { expect.soft(out.saved, \`수정 저장 성공 \${out.saveErrors.join(' / ')}\`).toBeTruthy(); expect.soft(out.found, '재조회 후 수정값 반영').toBeTruthy(); expect(out.restored, '원래 값으로 복원 저장·확인 — 실패면 수동 복원 필요').toBeTruthy(); }
    }
    await nscm.snapshot(\`\${MENU}_crud\`);
  });
});
` : `
test.describe(\`\${MENU} ${esc(P.asisName)} CRUD @crud\`, () => {
  test('조회 전용 화면 — 저장 버튼이 없어야 한다', async ({ nscm }) => {
    const r = await nscm.openScreen(MENU); expect(r.authorized).toBeTruthy();
    expect.soft(await nscm.subButtonVisible('Save'), 'As-is 에 저장 SP 없음 → Save(F7) 비노출').toBeFalsy();
  });
});
`;
  fs.writeFileSync(path.join(specs, `${id}.crud.spec.ts`), headCrud + crudBody, 'utf8');

  // ── auth (계정 × Division)
  for (const acc of plan.accounts) for (const d of acc.divisions) matrixRows.push([MENU, acc.id, acc.groups.join('|'), d, (acc.roles || {})[d] || (acc.adminOf || []).join('|') || acc.screenGroup]);
  fs.writeFileSync(path.join(specs, `${id}.auth.spec.ts`), head + `
// 계정별(권한그룹) × Division 매트릭스 — 로그인은 dev-login(id) 이라 비밀번호가 필요 없다
// 2026-10-20: btn_auth 의 코드 중 실제 '버튼' 으로 뜨는 것만 노출 대조 — EDIT(셀 편집 권한)·SEARCH(조회 버튼은 항상) 등은 버튼이 아니거나 항상 있어 제외
const BUTTON_CODES: Record<string, RegExp> = { SAVE: /^Save/i, INSERT: /^Insert/i, DELETE: /^Delete/i, EXCEL: /Excel/i, EXCEL_UPLOAD: /Excel\\s*Upload/i, EXCEL_DOWNLOAD: /Excel\\s*Download/i, COPY: /^Copy/i, PRINT: /^Print/i, EXECUTE: /^Execute/i, CONFIRM: /^Confirm/i, APPROVE: /^Approve/i, TRANSFER: /^Transfer/i, ACTION: /^Action/i };
for (const acc of PLAN.accounts) {
  const G = (acc.tobeGroups && acc.tobeGroups.length ? acc.tobeGroups : acc.groups) as string[];
  test.describe(\`\${MENU} 권한 @auth [\${acc.id} \${G.join('/')}]\`, () => {
    test.use({ account: acc.id });
    test('메뉴 접근 · 버튼 노출 · Division 데이터 범위', async ({ nscm }) => {
      // 시간 예산: Division 마다 조회(최대 searchTimeoutMs) — 기본 180s 로는 3 Division 계정이 초과한다(2026-10-20 실측)
      test.setTimeout(90_000 + (acc.divisions || []).length * (${Number(cfg.searchTimeoutMs) || 120000} + 30_000));
      const r = await nscm.openScreen(MENU);
      const expectedGroup = acc.screenGroup; // 통합테스트 데이터셋의 화면별 권한 해석(없으면 기록만)
      test.info().annotations.push({ type: 'access', description: \`authorized=\${r.authorized} notFound=\${r.notFound} menuAccess=\${acc.menuAccess || '?'} tobeGroups=\${G.join('|')} roster=\${Object.entries(acc.roles || {}).map(([d, ro]) => d + ':' + ro).join(',') || (acc.adminOf || []).join('|') || expectedGroup || '-'} (\${PLAN.accountSource || 'accounts.json'})\` });
      if (!r.authorized || r.notFound) { expect.soft(acc.admin, 'ADMIN 계정은 모든 화면 접근 가능해야 함').toBeFalsy(); return; }
      if (acc.menuAccess === 'N') test.info().annotations.push({ type: 'gap', description: \`메뉴 권한(user_group_menu) 없는 계정이 /view/\${MENU} 직접 접근으로 열림 — To-Be FE 는 라우트 가드 없음(메뉴 트리에서만 숨김)\` });
      const buttons = await nscm.visibleButtons();
      test.info().annotations.push({ type: 'buttons', description: buttons.join(' | ') });
      // To-Be 메타 기대(계정 그룹 합집합 × btn_auth) 와 대사 — 버튼 코드만, 양방향(있어야 할 버튼 노출 · 없어야 할 버튼 비노출)
      const expBtns: string[] | null = acc.expectedBtns || null; const codes: string[] = PLAN.menuBtnCodes || [];
      if (expBtns) for (const code of codes) { const re = BUTTON_CODES[code]; if (!re) continue; const want = expBtns.includes(code); expect.soft(buttons.some(x => re.test(x)), \`[\${acc.id} \${G.join('/')}] btn_auth \${code}=\${want ? 'Y' : 'N'} → 버튼 \${want ? '노출' : '비노출'}\`).toBe(want); }
      else test.info().annotations.push({ type: 'note', description: 'btn_auth 에 이 계정 그룹의 행이 없어 버튼 실측만 기록' });
      // Viewer/Planner 가 아닌데 Save 가 보이면 의심(soft)
      if (!acc.admin && acc.groups.every((g: string) => /viewer/i.test(g))) expect.soft(buttons.some(b => /^Save/i.test(b)), 'Viewer 그룹은 Save 비노출').toBeFalsy();
      for (const d of acc.divisions) {
        const ok = await nscm.setDivision(d);
        const calls = await nscm.search();
        for (const c of calls) expect.soft(c.status, \`[\${d}] call-proc \${c.sheet}/\${c.btn}\`).toBeLessThan(400);
        const alert = await nscm.alertText(); if (alert) await nscm.closeAlert();
        // DIVISION 컬럼이 있으면 값이 선택 Division 과 같아야 한다
        const divVals = (await nscm.gridColumnValues('DIVISION')).concat(await nscm.gridColumnValues('DIVISION_ID')).concat(await nscm.gridColumnValues('Division'));
        if (divVals.length) expect.soft(divVals.every(v => !v || v.startsWith(d)), \`[\${d}] 그리드 DIVISION 값 범위\`).toBeTruthy();
        test.info().annotations.push({ type: 'division', description: \`\${d} set=\${ok} rows=\${await nscm.gridRowCount(0)} alert=\${alert.slice(0, 80)}\` });
      }
    });
  });
}
`, 'utf8');
  // ── authcrud (계정별 권한 × CRUD) — 기대 = To-Be 메타(user_group_user → btn_auth) · 허용 계정은 공용 CRUD 사이클, 비허용 계정은 Save 비노출·편집 불가·SAVE 호출 0
  fs.writeFileSync(path.join(specs, `${id}.authcrud.spec.ts`), headCrud + `
// 계정별 권한 CRUD — 기대 권한은 To-Be 메타(그룹 소속 user_group_user.csv × 버튼 권한 btn_auth.csv), 데이터셋 그룹은 표기만. 로그인은 비밀번호 없는 /user/login(id)
const CODES: string[] = PLAN.menuBtnCodes || [];
const has = (arr: string[] | null, code: string) => arr ? arr.includes(code) : null;
for (const acc of PLAN.accounts) {
  const G = (acc.tobeGroups && acc.tobeGroups.length ? acc.tobeGroups : acc.groups) as string[];
  test.describe(\`\${MENU} 권한별 CRUD @authcrud [\${acc.id} \${G.join('/')}]\`, () => {
    test.use({ account: acc.id });
    const MARK = ${J(cfg.crudMarker)} + acc.id.replace(/[^A-Za-z0-9]/g, '').slice(0, 6).toUpperCase() + Date.now().toString(36).toUpperCase().slice(-4);
    test('메뉴 접근 → 기대 버튼(SAVE/INSERT/DELETE/EDIT) ↔ 실제 노출·편집 → 허용이면 마커 행 CRUD · 비허용이면 편집 불가', async ({ nscm }) => {
      test.setTimeout(420_000); // 로그인 → 조회(최대 searchTimeoutMs) → CRUD 사이클(저장·재조회 반복) 예산
      const expSave = has(acc.expectedBtns, 'SAVE'), expIns = CODES.includes('INSERT') ? has(acc.expectedBtns, 'INSERT') : null, expDel = CODES.includes('DELETE') ? has(acc.expectedBtns, 'DELETE') : null, expEdit = CODES.includes('EDIT') ? has(acc.expectedBtns, 'EDIT') : null;
      test.info().annotations.push({ type: 'authcrud', description: \`tobeGroups=\${G.join('|') || '-'} menuAccess=\${acc.menuAccess || '?'} expected=\${acc.expectedBtns ? acc.expectedBtns.join('|') : '(btn_auth 미등록)'} dataset=\${acc.groups.join('|')} matrix=\${(acc.matrix || []).join(' ') || '-'}\` });
      const r = await nscm.openScreen(MENU);
      if (!r.authorized || r.notFound) { expect.soft(acc.menuAccess, \`[\${acc.id}] 메뉴 권한 있음(user_group_menu) 인데 접근 불가 (authorized=\${r.authorized} notFound=\${r.notFound})\`).not.toBe('Y'); return; }
      // 메뉴 권한 없는 계정도 URL 직접 접근으로는 열린다(To-Be FE 라우트 가드 없음) → 기록하고, 버튼·편집은 '없어야 함' 으로 계속 검증
      if (acc.menuAccess === 'N') test.info().annotations.push({ type: 'gap', description: \`메뉴 권한(user_group_menu) 없는 계정이 /view/\${MENU} 직접 접근으로 열림\` });
      const div = (acc.divisions && acc.divisions[0]) || PLAN.sample.div; if (div) await nscm.setDivision(div);
      const calls = await nscm.search(); for (const c of calls) expect.soft(c.status, \`[\${acc.id}] call-proc \${c.sheet}/\${c.btn}\`).toBeLessThan(400);
      const out = await crudCycle(nscm, test.info(), PLAN, MARK);
      // 버튼 노출 ↔ 기대
      if (expSave != null) expect.soft(out.saveVisible, \`[\${acc.id} \${G.join('/')}] btn_auth SAVE=\${expSave ? 'Y' : 'N'} → Save 버튼 \${expSave ? '노출' : '비노출'}\`).toBe(expSave);
      if (expIns != null) expect.soft(out.insertVisible, \`[\${acc.id}] btn_auth INSERT=\${expIns ? 'Y' : 'N'} → Insert 버튼\`).toBe(expIns);
      if (expDel != null) expect.soft(out.deleteVisible, \`[\${acc.id}] btn_auth DELETE=\${expDel ? 'Y' : 'N'} → Delete 버튼\`).toBe(expDel);
      // EDIT 코드 = 셀 편집 권한 → 편집기 열림 여부와 대조(판정 가능할 때만)
      if (expEdit != null && out.editable != null) expect.soft(out.editable, \`[\${acc.id}] btn_auth EDIT=\${expEdit ? 'Y' : 'N'} → 셀 편집기 \${expEdit ? '열림' : '안 열림'}\`).toBe(expEdit);
      if (expSave === true) {
        if (out.mode === 'insert') { expect.soft(out.saved, \`[\${acc.id}] 허용 계정 마커 행 저장 \${out.saveErrors.join(' / ')}\`).toBeTruthy(); expect.soft(out.found, \`[\${acc.id}] 재조회 후 신규 행 존재\`).toBeTruthy(); expect(out.cleaned, \`[\${acc.id}] 마커 행 정리 완료\`).toBeTruthy(); }
        else if (out.mode === 'edit-save') { expect.soft(out.editable, \`[\${acc.id}] 허용 계정 편집 가능 셀 존재\`).toBeTruthy(); if (out.editable) { expect.soft(out.saved, \`[\${acc.id}] 수정 저장 성공 \${out.saveErrors.join(' / ')}\`).toBeTruthy(); expect.soft(out.found, \`[\${acc.id}] 재조회 후 수정값 반영\`).toBeTruthy(); expect(out.restored, \`[\${acc.id}] 원래 값 복원 저장·확인\`).toBeTruthy(); } }
      } else if (expSave === false) {
        if (out.editable != null) expect.soft(out.editable, \`[\${acc.id}] 비허용 계정 셀 편집 불가\`).toBeFalsy();
        expect.soft(out.saveCalls, \`[\${acc.id}] 비허용 계정 SAVE 계열 call-proc 0\`).toBe(0);
      } else test.info().annotations.push({ type: 'note', description: 'btn_auth 에 이 계정 그룹의 행이 없어 실측만 기록(기대 없음)' });
      await nscm.snapshot(\`\${MENU}_authcrud_\${acc.id}\`);
    });
  });
}
`, 'utf8');
  idxRows.push([id, MENU, P.asisName, P.fields.length, mainSheets.length, P.hasSave ? 'Y' : '', hasMeta ? 'Y' : '', plan.accounts.length, plan.sample.account, plan.sample.div, mode]);
  console.log(`  ${id} → ${MENU}  smoke/crud(${P.hasSave ? 'save' : 'read-only'})/auth(${plan.accounts.length}계정)/authcrud(기대 있음 ${plan.accounts.filter(x => x.expectedBtns).length}계정)  메타컬럼 ${hasMeta ? 'Y' : 'N'}`);
}
fs.writeFileSync(path.join(specs, '_index.csv'), '﻿asis_id,menu_id,name,fields,main_sheets,has_save,meta_cols,accounts,sample_account,sample_div,mode\n' + idxRows.map(r => r.join(',')).join('\n') + '\n', 'utf8');
fs.writeFileSync(path.join(specs, '_matrix.csv'), '﻿menu_id,account,groups,division,role\n' + matrixRows.map(r => r.join(',')).join('\n') + '\n', 'utf8');
console.log(`스펙 ${idxRows.length}화면 × 4(smoke·crud·auth·authcrud) → ${specs}  (계정×DIV 매트릭스 ${matrixRows.length}행)`);
