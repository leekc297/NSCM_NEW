#!/usr/bin/env node
'use strict';
// gen-e2e — Fact Pack(e2e_plan.json) + Oracle 메타 + 테스트계정 → Playwright 스펙 생성
//   node gen-e2e.js [ID ...] [--all]      ID 없고 --all 이면 Doc/gen/*/e2e_plan.json 전부
//   산출: Doc/e2e/specs/<ID>.smoke.spec.ts / <ID>.crud.spec.ts / <ID>.auth.spec.ts / <ID>.plan.json, _index.csv, _matrix.csv
const fs = require('fs'); const path = require('path');
const cfg = JSON.parse(fs.readFileSync(path.join(__dirname, 'e2e.config.json'), 'utf8').replace(/^﻿/, ''));
const a = process.argv.slice(2); const ids = a.filter(x => !x.startsWith('--')).map(x => x.toUpperCase());
const specs = cfg.specsDir; fs.mkdirSync(specs, { recursive: true });
const readCsv = f => { if (!fs.existsSync(f)) return []; const t = fs.readFileSync(f, 'utf8').replace(/^﻿/, ''); const lines = []; let cur = '', q = false, row = []; for (let i = 0; i < t.length; i++) { const ch = t[i]; if (q) { if (ch === '"') { if (t[i + 1] === '"') { cur += '"'; i++; } else q = false; } else cur += ch; } else if (ch === '"') q = true; else if (ch === ',') { row.push(cur); cur = ''; } else if (ch === '\n' || ch === '\r') { if (ch === '\r' && t[i + 1] === '\n') i++; row.push(cur); lines.push(row); row = []; cur = ''; } else cur += ch; } if (cur || row.length) { row.push(cur); lines.push(row); } const h = lines.shift() || []; return lines.filter(r => r.length > 1 || r[0]).map(r => Object.fromEntries(h.map((k, i) => [k, r[i] ?? '']))); };
const up = s => (s || '').toUpperCase();
const accounts = fs.existsSync(path.join(__dirname, 'accounts.json')) ? JSON.parse(fs.readFileSync(path.join(__dirname, 'accounts.json'), 'utf8')) : { accounts: [], authMatrix: [], divisions: ['40'] };
const scenarios = readCsv(path.join(__dirname, 'scenarios.csv'));
const sheetCols = readCsv(path.join(cfg.tobeOutDir, 'db', 'sheet_columns.csv'));
const btnAuth = readCsv(path.join(cfg.tobeOutDir, 'db', 'btn_auth.csv'));
const menu = readCsv(path.join(cfg.tobeOutDir, 'db', 'menu.csv'));
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
  const accs = accounts.accounts.filter(x => (x.usable || x.adminAlso) && (accounts.loginProbe ? x.loginOk : true));
  const plan = { id, menuId: MENU, page: P.page, routePath: P.routePath, asisName: P.asisName, fields: P.fields, buttons: P.buttons, mainSheets: mainSheets.map(s => ({ name: s.name, key: s.key, labels: s.labels.slice(0, 40) })), popupSheets: P.sheets.filter(s => s.popup).map(s => s.name), hasSave: P.hasSave, hasSpreadTitle: P.hasSpreadTitle, procs: P.procs, expectedCols, hasMeta, dynamicHeader, sample: { div: sample['DIV'] || cfg.defaultDivision, item: sample['ITEM_ID'] || '', site: sample['SCM_SITE_ID'] || '', project: sample['PROJECT_CODE'] || '', account: sample.account || sample['테스트계정'] || cfg.defaultAccount }, accounts: accs.map(x => ({ id: x.id, groups: x.groups, divisions: x.divisions, admin: x.adminAlso, screenGroup: x.screens[MENU] || x.screens[id] || '' })), expectedBtnsByGroup: Object.fromEntries(Object.entries(expectedBtnsByGroup).map(([k, v]) => [k, [...v]])), menuAuth: menu.length ? 'menu.csv' : '' };
  fs.writeFileSync(path.join(specs, `${id}.plan.json`), JSON.stringify(plan, null, 2), 'utf8');
  const head = `// 자동 생성 — tools/E2E/gen-e2e.js (${new Date().toISOString().slice(0, 10)}) · 원천: Doc/gen/${id}/e2e_plan.json · 손으로 고치지 말고 룰/플랜을 고칠 것\nimport { test, expect } from '${path.relative(specs, path.join(__dirname, 'fixtures', 'test')).replace(/\\/g, '/')}';\nimport * as fs from 'node:fs';\nconst PLAN = JSON.parse(fs.readFileSync(__dirname + '/${id}.plan.json', 'utf8'));\nconst MENU = ${J(MENU)};\n`;

  // ── smoke
  fs.writeFileSync(path.join(specs, `${id}.smoke.spec.ts`), head + `
test.describe(\`\${MENU} ${esc(P.asisName)} 스모크 @smoke\`, () => {
  test.use({ account: PLAN.sample.account || undefined });
  test('화면 열림 · 조회조건 · 조회 · 그리드 컬럼', async ({ nscm, page }) => {
    const r = await nscm.openScreen(MENU);
    expect(r.notFound, '404 아님').toBeFalsy();
    expect(r.authorized, '권한 안내 없이 열림').toBeTruthy();
    await nscm.snapshot(\`\${MENU}_open\`);
    // 조회조건 라벨 존재(soft) — 라벨 다국어/코드 미확정이면 WARN 성격
    for (const f of PLAN.fields) expect.soft(await nscm.fieldExists(f.label), \`조회조건 '\${f.label}' (\${f.component})\`).toBeTruthy();
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
    const expectCols = PLAN.hasMeta ? (PLAN.expectedCols[PLAN.mainSheets[0]?.name]?.[PLAN.sample.div] || []) : (PLAN.mainSheets[0]?.labels || []);
    const norm = (s: string) => s.toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
    const missing = expectCols.filter((c: string) => c && !headers.some(h => norm(h) === norm(c) || norm(h).includes(norm(c))));
    test.info().annotations.push({ type: 'columns', description: \`헤더 \${headers.length} / 기대 \${expectCols.length} / 누락 \${missing.length}: \${missing.slice(0, 10).join(', ')}\` });
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

  // ── crud
  const crudBody = P.hasSave ? `
test.describe.serial(\`\${MENU} ${esc(P.asisName)} CRUD @crud\`, () => {
  test.use({ account: PLAN.sample.account || undefined });
  const MARK = ${J(cfg.crudMarker)} + Date.now().toString(36).toUpperCase();
  test('Insert(F8) → 입력 → Save(F7) → 재조회 → Delete(F9) → Save → 재조회', async ({ nscm, page }) => {
    const r = await nscm.openScreen(MENU); expect(r.authorized).toBeTruthy();
    if (PLAN.sample.div) await nscm.setDivision(PLAN.sample.div);
    await nscm.search();
    expect(await nscm.subButtonVisible('Save'), 'Save(F7) 버튼').toBeTruthy();
    const canInsert = await nscm.subButtonVisible('Insert');
    const before = await nscm.gridRowCount(0);
    if (canInsert) {
      // C: 행 추가 + 첫 편집 가능 컬럼에 마커 입력 (키 컬럼 구성은 화면별 — 실패 시 플랜의 keyColumns 를 채워 보완)
      await nscm.subButton('Insert').click();
      await expect.poll(() => nscm.gridRowCount(0), { timeout: 10_000 }).toBeGreaterThan(before);
      const headers = await nscm.gridHeaders(0);
      const keyCols: string[] = PLAN.keyColumns || [];
      const targetCol = keyCols.length ? headers.findIndex(h => h.toLowerCase() === keyCols[0].toLowerCase()) : 0;
      await nscm.setCell(0, Math.max(targetCol, 0), MARK);
      const saved = await nscm.save();
      expect.soft(saved.message, '저장 알림').not.toMatch(/ORA-|Exception|실패|fail|error/i);
      for (const c of saved.calls) expect.soft(c.status, \`SAVE call-proc \${c.sheet}/\${c.btn}\`).toBeLessThan(400);
      // R: 재조회 → 마커 존재
      await nscm.search();
      const txt = await nscm.grid(0).innerText();
      expect.soft(txt.includes(MARK), '재조회 후 신규 행 존재').toBeTruthy();
      // U: 마커 행 수정(두 번째 컬럼) → Save → 재조회
      const rows = nscm.grid(0).locator('.wj-cells .wj-row'); const n = await rows.count(); let ri = -1;
      for (let i = 0; i < n && ri < 0; i++) if ((await rows.nth(i).innerText()).includes(MARK)) ri = i;
      if (ri >= 0 && headers.length > 1) { await nscm.setCell(ri, Math.min(targetCol + 1, headers.length - 1), MARK + '_U'); const u = await nscm.save(); expect.soft(u.message).not.toMatch(/ORA-|Exception|실패|error/i); await nscm.search(); expect.soft((await nscm.grid(0).innerText()).includes(MARK + '_U'), '수정 반영').toBeTruthy(); }
      // D: 마커 행 선택 → Delete(F9) → Save → 재조회 → 마커 없음
      if (await nscm.subButtonVisible('Delete')) {
        const rows2 = nscm.grid(0).locator('.wj-cells .wj-row'); const n2 = await rows2.count();
        for (let i = 0; i < n2; i++) if ((await rows2.nth(i).innerText()).includes(MARK)) { await rows2.nth(i).locator('.wj-cell').first().click(); break; }
        await nscm.subButton('Delete').click(); await nscm.closeAlert('ok');
        const d = await nscm.save(); expect.soft(d.message).not.toMatch(/ORA-|Exception|실패|error/i);
        await nscm.search();
        expect.soft((await nscm.grid(0).innerText()).includes(MARK), '삭제 후 마커 없음').toBeFalsy();
      } else test.info().annotations.push({ type: 'skip', description: 'Delete(F9) 버튼 없음 — 삭제 미지원 화면' });
    } else {
      // Insert 가 없는 저장 화면(셀 편집 저장형): 첫 행 첫 편집가능 컬럼 수정 → 저장 → 재조회 → 원복
      test.info().annotations.push({ type: 'mode', description: '셀 편집 저장형(Insert 없음)' });
      const cell = await nscm.gridCell(0, 1); const orig = (await cell.innerText()).trim();
      await nscm.setCell(0, 1, MARK); const s1 = await nscm.save(); expect.soft(s1.message).not.toMatch(/ORA-|Exception|실패|error/i);
      await nscm.search(); expect.soft((await nscm.grid(0).innerText()).includes(MARK), '수정 반영').toBeTruthy();
      await nscm.setCell(0, 1, orig); await nscm.save(); // 원복
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
  fs.writeFileSync(path.join(specs, `${id}.crud.spec.ts`), head + crudBody, 'utf8');

  // ── auth (계정 × Division)
  for (const acc of plan.accounts) for (const d of acc.divisions) matrixRows.push([MENU, acc.id, acc.groups.join('|'), d, acc.screenGroup]);
  fs.writeFileSync(path.join(specs, `${id}.auth.spec.ts`), head + `
// 계정별(권한그룹) × Division 매트릭스 — 로그인은 dev-login(id) 이라 비밀번호가 필요 없다
for (const acc of PLAN.accounts) {
  test.describe(\`\${MENU} 권한 @auth [\${acc.id} \${acc.groups.join('/')}]\`, () => {
    test.use({ account: acc.id });
    test('메뉴 접근 · 버튼 노출 · Division 데이터 범위', async ({ nscm }) => {
      const r = await nscm.openScreen(MENU);
      const expectedGroup = acc.screenGroup; // 통합테스트 데이터셋의 화면별 권한 해석(없으면 기록만)
      test.info().annotations.push({ type: 'access', description: \`authorized=\${r.authorized} notFound=\${r.notFound} group=\${expectedGroup || '-'}\` });
      if (!r.authorized || r.notFound) { expect.soft(acc.admin, 'ADMIN 계정은 모든 화면 접근 가능해야 함').toBeFalsy(); return; }
      const buttons = await nscm.visibleButtons();
      test.info().annotations.push({ type: 'buttons', description: buttons.join(' | ') });
      // btn_auth 메타가 있으면 그룹별 기대 버튼과 대사(soft)
      for (const g of acc.groups) { const exp = PLAN.expectedBtnsByGroup[g]; if (!exp) continue; for (const b of exp) expect.soft(buttons.some(x => x.toUpperCase().includes(String(b).toUpperCase())), \`[\${g}] 버튼 '\${b}' 노출\`).toBeTruthy(); }
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
  idxRows.push([id, MENU, P.asisName, P.fields.length, mainSheets.length, P.hasSave ? 'Y' : '', hasMeta ? 'Y' : '', plan.accounts.length, plan.sample.account, plan.sample.div]);
  console.log(`  ${id} → ${MENU}  smoke/crud(${P.hasSave ? 'save' : 'read-only'})/auth(${plan.accounts.length}계정)  메타컬럼 ${hasMeta ? 'Y' : 'N'}`);
}
fs.writeFileSync(path.join(specs, '_index.csv'), '﻿asis_id,menu_id,name,fields,main_sheets,has_save,meta_cols,accounts,sample_account,sample_div\n' + idxRows.map(r => r.join(',')).join('\n') + '\n', 'utf8');
fs.writeFileSync(path.join(specs, '_matrix.csv'), '﻿menu_id,account,groups,division,screen_group\n' + matrixRows.map(r => r.join(',')).join('\n') + '\n', 'utf8');
console.log(`스펙 ${idxRows.length}화면 × 3 → ${specs}  (계정×DIV 매트릭스 ${matrixRows.length}행)`);
