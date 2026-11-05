#!/usr/bin/env node
'use strict';
// 하네스 게이트 — To-Be 화면 폴더를 As-is Fact Pack + 사전(rules/) 에 대고 판정한다. Claude Code hook / husky / CI 가 같은 이 파일을 부른다.
//   node check.js --page <pages/xxx 폴더> [--id DMF0052] [--final] [--tsc] [--lint] [--config harness.json] [--json]   (--final 은 tsc+eslint 포함)
//   node check.js --file <저장된 파일 경로>            (PostToolUse — 파일에서 페이지 폴더를 찾는다)
//   exit 0 = 통과, 1 = 경고만, 2 = 차단(BLOCK)
const fs = require('fs'); const path = require('path');
const { readCsv } = require('../TobeFacts/src/util');
const a = process.argv.slice(2); const opt = (k, d) => { const i = a.indexOf(k); return i >= 0 ? a[i + 1] : d; };
const cfg = JSON.parse(fs.readFileSync(opt('--config', path.join(__dirname, 'harness.json')), 'utf8').replace(/^﻿/, ''));
const R = cfg.rulesDir || path.join(__dirname, 'rules');
const FINAL = a.includes('--final');
let pageDir = opt('--page');
if (!pageDir && opt('--file')) { let d = path.dirname(path.resolve(opt('--file'))); while (d && !/[\\/]pages$/.test(path.dirname(d)) && d !== path.dirname(d)) d = path.dirname(d); pageDir = /[\\/]pages$/.test(path.dirname(d)) ? d : null; }
if (!pageDir || !fs.existsSync(pageDir)) { console.log('대상 페이지 폴더 아님 — 건너뜀'); process.exit(0); }
pageDir = path.resolve(pageDir);
const findings = []; const F = (level, code, msg, where) => findings.push({ level, code, msg, where: where || '' });
const walk = d => fs.readdirSync(d, { withFileTypes: true }).flatMap(e => e.isDirectory() ? (e.name === 'node_modules' ? [] : walk(path.join(d, e.name))) : [path.join(d, e.name)]);
const files = walk(pageDir); const rel = f => path.relative(pageDir, f).split(path.sep).join('/');
const read = f => fs.readFileSync(f, 'utf8').replace(/^﻿/, '');
const src = Object.fromEntries(files.filter(f => /\.tsx?$/.test(f)).map(f => [f, read(f)]));

// 0) 화면ID
let ID = opt('--id'); if (!ID) for (const t of Object.values(src)) { const m = t.match(/export const MENU_ID = '([A-Z0-9_]+)' as const/); if (m) { ID = m[1]; break; } }
if (!ID) F('BLOCK', 'S00', 'MENU_ID 상수 없음 — {page}.constants.ts 에 `export const MENU_ID = \'XXX\' as const`');

// 1) 금지 패턴 (주석 제외 — 주석 속 코드로 오탐하지 않음)
const stripComments = t => t.replace(/\/\*[\s\S]*?\*\//g, m => m.replace(/[^\n]/g, ' ')).replace(/(^|[^:])\/\/.*$/gm, (m, p) => p + ' '.repeat(m.length - p.length));
for (const r of readCsv(path.join(R, 'forbidden.csv'))) {
  if (r.scope !== 'tsx') continue;
  const re = new RegExp(r.pattern, 'g');
  for (const [f, t] of Object.entries(src)) { const code = stripComments(t); let m; re.lastIndex = 0; while ((m = re.exec(code))) F(r.level, r.id, r.message, `${rel(f)}:${code.slice(0, m.index).split('\n').length}`); }
}
// 2) 구조
const base = path.basename(pageDir);
const need = [[`${base}.constants.ts`, 'WARN'], ['index.ts', 'WARN']];
const hasAsis = ID && fs.existsSync(path.join(cfg.asisOutDir, 'screens', ID));
// T03 (2026-10-21 SCP0080 사고): i18next `TFunction` 타입을 매개변수/변수 타입으로 쓰면 useTranslation() 의 t(react-i18next, 다른 제네릭) 와의
//   대입 검사에서 typed resources(ko.json 1,614 키) 오버로드가 교차곱으로 폭발 → tsc 가 feature 전체에서 OOM/RangeError(12GB 도 초과).
//   같은 폴더 사본에서 `t: (key: string, opts?: { defaultValue?: string }) => string` 로 바꾸면 647MB·127s 정상. 정적 검출(BLOCK) — tsc 가 죽기 전에 막는다.
for (const f of files.filter(x => /\.(ts|tsx)$/.test(x) && !/\.d\.ts$/.test(x))) {
  const txt = fs.readFileSync(f, 'utf8'); if (!/\bTFunction\b/.test(txt)) continue;
  txt.split(/\r?\n/).forEach((l, i) => { if (/(^|[^\w])TFunction\b/.test(l) && !/^\s*\/\//.test(l)) F('BLOCK', 'T03', `i18next TFunction 타입 사용 — tsc 타입 폭발(교차곱) 원인. t 는 좁은 콜백 타입 '(key: string, opts?: { defaultValue?: string }) => string' 으로 받거나 호출측에서 문자열을 만들어 넘길 것`, `${rel(f)}:${i + 1}`); });
}
// H01/H02 (2026-10-21 SCP0100 사고 — 대조표 '구현' 인데 실측 불일치였던 2종을 정적으로 잡는다. 사용자 지시 "사전 조치가 앞으로는 자동 적용")
//   H01: DataGrid 에 headerRowHeight 를 주면서 동적 컬럼(dynamicColumns/columnGroups)을 쓰는 페이지는 Wijmo 가 columnGroups 재대입 때 헤더 행 높이를 기본값으로
//        되돌리므로(공용 DataGrid 는 initialized 1회만 적용 — DataGrid.tsx:1739) `updatedLayout` 핸들러에서 `columnHeaders.rows.defaultSize` 를 다시 세워야 한다. 없으면 3행×48=144px 로 보인다.
//   H02: 공용 ColumnLayoutModal 은 저장된 개인화(titleSet)가 없으면 fallbackColumns 로 목록을 만든다 — 안 넘기면 "No Column". 다른 8개 화면은 전부 넘긴다.
for (const f of files.filter(x => /\.tsx$/.test(x))) {
  const txt = fs.readFileSync(f, 'utf8');
  if (/headerRowHeight\s*=/.test(txt) && /(dynamicColumns\s*=|columnGroups)/.test(txt) && !/updatedLayout/.test(txt))
    F('BLOCK', 'H01', `headerRowHeight 를 주고 동적 컬럼을 쓰는데 updatedLayout 재적용이 없음 — columnGroups 재대입 뒤 헤더 행 높이가 기본(48px)으로 돌아간다. 그리드 initialized 에서 grid.updatedLayout.addHandler(() => { const r = grid.columnHeaders.rows; if (Math.round(r.defaultSize) !== HEADER_ROW_HEIGHT) r.defaultSize = HEADER_ROW_HEIGHT; }) 를 등록할 것`, rel(f));
  // H05 (2026-10-21 사용자 지적): 동적 컬럼을 그룹(columnGroups: header + columns[])으로 만들고 leaf 가 리터럴(예 'Qty')이면 헤더 가로 병합을 꺼야 한다 — 기본 allowMerging(ColumnHeaders/All) 은
  //   동일 문구 인접 헤더 셀을 1칸으로 합쳐 'Qty' 가 전 월에 걸친 1칸(w910)이 된다. AllowMerging.Cells(본문만) 또는 None, 또는 mergeManager 의 ColumnHeader 제외가 있어야 통과.
  if (/dynamicColumns\s*=/.test(txt) && /<DataGrid\b/.test(txt) && !/AllowMerging\.(Cells|None)\b/.test(txt) && !/mergeManager/.test(txt)) {
    const utilHasGroups = files.some(u => /\.(ts|tsx)$/.test(u) && u !== f && /columns:\s*\[\]/.test(fs.readFileSync(u, 'utf8')) && /header:/.test(fs.readFileSync(u, 'utf8')));
    if (utilHasGroups) F(FINAL ? 'BLOCK' : 'WARN', 'H05', `동적 그룹 헤더(columnGroups)인데 헤더 가로 병합이 켜져 있음(allowMerging 기본/All) — 리터럴 leaf(Qty) 칸이 인접 월에 걸쳐 1칸으로 합쳐진다. allowMerging={AllowMerging.Cells}(본문 병합만) 로 넘기거나 mergeManager 에서 ColumnHeader 패널 제외. 행 높이는 그룹 행 20 / leaf 행 40(As-is ColumnHeaderSpan)`, rel(f));
  }
  // H06 (2026-10-21 SCP0100 런타임 사고): DataGrid mergeManager prop 으로 넘긴 MergeManager 인스턴스는 Wijmo Control.initialize 의 copy() 가 **객체 속성을 재귀 복사**한다 —
  //   클래스에 own 인스턴스 필드(private inner = null 등, useDefineForClassFields)가 있으면 "Assertion failed in Wijmo: Unknown property "inner"" 로 그리드 생성 자체가 죽는다(화면 전체 빈 화면).
  //   룰 D4(props 직접 전달)는 유지하되 상태는 모듈 WeakMap/클로저로 두고 클래스 본문에는 메서드만 둔다.
  if (/mergeManager\s*=\s*\{/.test(txt)) {
    for (const u of files.filter(x => /\.(ts|tsx)$/.test(x))) {
      const ut = fs.readFileSync(u, 'utf8'); if (!/extends\s+(CustomMergeManager|MergeManager)\b/.test(ut)) continue;
      const body = ut.slice(ut.search(/extends\s+(CustomMergeManager|MergeManager)\b/));
      const fieldDecl = body.match(/^\s*(private|protected|public|readonly)?\s*(static\s+)?[A-Za-z_]\w*\s*(\?|!)?\s*(:\s*[^=;(]+)?(=\s*[^;]+)?;\s*$/m);
      if (fieldDecl && !/static/.test(fieldDecl[0]) && !/^\s*(get|set|async)\b/.test(fieldDecl[0])) F('BLOCK', 'H06', `DataGrid mergeManager prop 으로 넘기는 MergeManager 클래스에 인스턴스 필드가 있음(${fieldDecl[0].trim().slice(0, 60)}) — Wijmo copy() 가 "Unknown property" 단언으로 그리드 생성 실패. 상태는 모듈 WeakMap<FlexGrid,…>/클로저로 옮기고 클래스에는 메서드만 둘 것`, rel(u));
    }
  }
  if (/<ColumnLayoutModal\b/.test(txt) && !/fallbackColumns\s*=/.test(txt))
    F('BLOCK', 'H02', `ColumnLayoutModal 에 fallbackColumns 가 없음 — 저장된 개인화(titleSet)가 없는 사용자는 목록이 "No Column" 으로 빈다. 활성 시트 admin 컬럼 메타(staticColumns)를 { key: colNm, header: colLblNm, width } 로 넘길 것(SalesPlanModals 패턴)`, rel(f));
}
if (hasAsis && !files.some(f => rel(f) === '__asis-mapping__.md')) F('BLOCK', 'S01', '표준 파일 없음: __asis-mapping__.md (As-is Fact Pack 이 있는 화면은 대조표 필수)');
for (const [n, lv] of need) if (!files.some(f => rel(f) === n)) F(lv, 'S01', `표준 파일 없음: ${n}`);
if (!files.some(f => /components\/.*Form\.tsx$/.test(rel(f)))) F('WARN', 'S01', '표준 파일 없음: components/{Page}Form.tsx');
if (!files.some(f => /components\/.*Grid[A-Za-z0-9]*\.tsx$/.test(rel(f)))) F('WARN', 'S01', '표준 파일 없음: components/{Page}Grid*.tsx');
if (!files.some(f => /^use[A-Z].*Store\.ts$/.test(rel(f)))) F('WARN', 'S01', '표준 파일 없음: use{Page}Store.ts');
// 2b) Form 표준 (룰 06 §4): SearchArea + onSearch + isHidden
for (const [f, t] of Object.entries(src)) if (/Form\.tsx$/.test(f)) { if (!/<SearchArea/.test(t)) F('WARN', 'S02', 'Form 에 <SearchArea> 없음 (룰 06 §1)', rel(f)); else { if (!/onSearch=/.test(t)) F('WARN', 'S02', 'SearchArea onSearch 누락', rel(f)); if (!/isHidden=/.test(t)) F('WARN', 'S02', 'SearchArea isHidden 누락 (조회영역 접기)', rel(f)); } }
for (const [f, t] of Object.entries(src)) if (/^(?!.*components\/).*\.tsx$/.test(rel(f)) && /PageProps</.test(t)) { if (!/<MainTitle/.test(t)) F('WARN', 'S03', 'Page 에 <MainTitle> 없음', rel(f)); if (!/<SubTitle/.test(t)) F('WARN', 'S03', 'Page 에 <SubTitle> 없음', rel(f)); }
// 3) 매핑표
const mapFile = files.find(f => rel(f) === '__asis-mapping__.md');
const mapRows = [];
if (mapFile) for (const line of read(mapFile).split(/\r?\n/)) { const m = line.match(/^\|\s*([A-Z]\d{2}-[\dP]+-\d{3})\s*\|(.*)\|\s*$/); if (!m) continue; const c = m[2].split('|').map(s => s.trim()); const row = { id: m[1], summary: c[0] || '', impl: c[1] || '', reason: c[2] || '', status: c[3] || '' }; mapRows.push(row);
  if (!row.status) F('BLOCK', 'M01', `상태 빈칸: ${row.id} ${row.summary}`, '__asis-mapping__.md');
  else if (/^구현/.test(row.status) && !row.impl) F('BLOCK', 'M02', `구현인데 위치 없음: ${row.id} ${row.summary}`, '__asis-mapping__.md');
  else if (/^(제외|해당없음)/.test(row.status) && !row.reason) F('BLOCK', 'M03', `${row.status} 인데 사유 없음: ${row.id} ${row.summary}`, '__asis-mapping__.md');
  else if (/^미구현/.test(row.status)) F(FINAL ? 'BLOCK' : 'WARN', 'M04', `미구현: ${row.id} ${row.summary}${row.reason ? ' — ' + row.reason : ''}`, '__asis-mapping__.md');
  if (/^구현/.test(row.status) && row.impl) { const fn = (row.impl.match(/([\w./-]+\.tsx?)/) || [])[1]; if (fn && !files.some(f => rel(f) === fn.replace(/^\.\//, ''))) F('WARN', 'M05', `구현 위치 파일 없음: ${row.id} → ${fn}`, '__asis-mapping__.md'); }
}
// 3a) AS-IS 액션 대조표 (사용자 지시 2026-10-23) — tools/AsisFacts 가 추출한 핸들러 본문의 구체 액션(값 비움·목록 재구성·그리드·상태·메시지·엔드포인트·
//     사전 미등록 외부 호출 포함) 1건 1행. 페이지 폴더 __asis-actions__.md(신규 화면 — 생성기) → 없으면 Doc/asisfacts/screens/<AS-IS ID>/__asis-actions__.md(기존 화면 문서 — actions-checklist.js).
//     AC0 = 대조표 없음 · AC1 = 상태 빈칸/미구현/구현인데 위치 없음/제외·해당없음인데 사유 없음 · AC2 = 사전 미등록 외부/상속 호출(CALL_EXT·CALL_BASE) 의미 미기입
//     수준(사용자 지시 2026-10-23 '개발된 UI·작업 흐름 무영향 — 문서 보강 먼저'): 페이지 폴더 대조표(생성기가 만든 신규 화면) = --final BLOCK,
//     기존 화면 문서(AS-IS 자료 폴더) = 항상 WARN · AC0 = WARN
if (ID) {
  const AC = require('./lib/actions');
  const acPage = files.find(f => rel(f) === AC.FILE); const acGen = AC.docPath(cfg, ID);
  const acFile = acPage || (fs.existsSync(acGen) ? acGen : null);
  const hasActs = fs.existsSync(path.join(cfg.asisOutDir, 'screens', AC.asisId(cfg, ID), 'actions.csv'));
  if (!acFile && hasActs) F('WARN', 'AC0', `AS-IS 액션 대조표 없음 — node tools/Harness/actions-checklist.js ${ID} 로 생성(${path.relative(path.dirname(cfg.feRoot), acGen).replace(/\\/g, '/')}) 후 행마다 상태·구현 위치·사유 기입`);
  if (acFile) {
    const where = acPage ? AC.FILE : path.relative(path.dirname(cfg.feRoot), acGen).replace(/\\/g, '/');
    const lv = FINAL && acPage ? 'BLOCK' : 'WARN'; const cnt = { AC1: 0, AC2: 0 }; const first = { AC1: [], AC2: [] };
    for (const r of AC.rowsOf(fs.readFileSync(acFile, 'utf8'))) {
      const bad1 = !r.status ? '상태 빈칸' : /^미구현/.test(r.status) ? '미구현' : (/^구현/.test(r.status) && !r.impl) ? '구현인데 위치 없음' : (/^(제외|해당없음)/.test(r.status) && !r.reason) ? `${r.status}인데 사유 없음` : '';
      if (bad1) { cnt.AC1++; if (first.AC1.length < 8) first.AC1.push(`${r.id}(${bad1} ${r.kind} ${r.target.slice(0, 30)})`); }
      if (AC.UNKNOWN.has(r.kind) && (!r.meaning || r.meaning.startsWith('⚠'))) { cnt.AC2++; if (first.AC2.length < 8) first.AC2.push(`${r.id}(${r.target.slice(0, 40)} @${r.where})`); }
    }
    if (cnt.AC1) F(lv, 'AC1', `액션 대조표 미처리 ${cnt.AC1}행: ${first.AC1.join(', ')}${cnt.AC1 > 8 ? ' …' : ''}`, where);
    if (cnt.AC2) F(lv, 'AC2', `사전 미등록 외부/상속 호출 의미 미기입 ${cnt.AC2}행(AS-IS 원문 위치를 열어 '의미' 칸에 실제 동작 기입): ${first.AC2.join(', ')}${cnt.AC2 > 8 ? ' …' : ''}`, where);
  }
}
// 3b) 커밋본 대비 후퇴 감지 — 2026-10-19 SCP0096 사고(파이프라인이 손으로 완성한 커밋본을 골격으로 교체: 대조표 91→20행, dynamic-columns/types 삭제)
//     git 이 추적하는 페이지면 ①커밋본 파일 삭제(M07) ②대조표 행·구현 수 축소(M06) 를 BLOCK — "빈 칸 0" 만 보던 M01~M05 의 구멍
{
  const cp = require('child_process'); const GT = require('./lib/applied').gitTracked(pageDir); // 감싸는 저장소 전부 확인(nscm-fe 중첩 .git 대응)
  const git = args => { try { const r = cp.spawnSync('git', ['-C', GT.root, ...args], { encoding: 'utf8' }); return r.status === 0 ? r.stdout : null; } catch { return null; } };
  const strip = f => { f = f.replace(/\\/g, '/'); const pre = GT && GT.rel !== '.' ? GT.rel + '/' : ''; return f.startsWith(pre) ? f.slice(pre.length) : f; };
  if (GT) {
    for (const d of (git(['ls-files', '--deleted', '--', GT.rel]) || '').split(/\r?\n/).filter(Boolean).map(strip)) F(FINAL ? 'BLOCK' : 'WARN', 'M07', `커밋본에 있던 파일이 삭제됨: ${d} — 골격 재생성으로 기능 유실 의심(git checkout -- 로 복원 후 병합, 저장소 ${GT.root})`, d);
    if (mapFile && GT.files.some(f => strip(f) === '__asis-mapping__.md')) {
      const headTxt = git(['show', `HEAD:${GT.rel === '.' ? '' : GT.rel + '/'}__asis-mapping__.md`]);
      if (headTxt != null) {
        // 2026-10-21: '구현' → '부분/미구현' 으로 내려간 행이라도 비고에 날짜 있는 '실측 정정' 표식(예 "2026-10-21 실측 정정")이 있으면 후퇴가 아니라 정정이다
        //   (SCP0100 헤더·모달 행 — 라이브 실측으로 '구현' 이 틀렸음을 확인하고 내린 경우). 표식 없는 하향만 후퇴로 센다.
        const parse = txt => { const m = new Map(); for (const line of txt.split(/\r?\n/)) { const r = line.match(/^\|\s*([A-Z]\d{2}-[\dP]+-\d{3})\s*\|(.*)\|\s*$/); if (!r) continue; const cells = r[2].split('|').map(s => s.trim()); m.set(r[1], { status: cells[cells.length - 1] || '', note: cells.slice(0, -1).join(' ') }); } return m; };
        const H = parse(headTxt), C = parse(read(mapFile));
        const corrected = [...H.entries()].filter(([id, hv]) => /^구현/.test(hv.status) && C.has(id) && !/^구현/.test(C.get(id).status) && /\d{4}-\d{2}-\d{2}\s*(실측|규칙|룰)\s*정정/.test(C.get(id).note)).map(([id]) => id);
        const cnt = M => { let impl = 0; for (const v of M.values()) if (/^구현/.test(v.status)) impl++; return { n: M.size, impl }; };
        const h = cnt(H), c = cnt(C); const cImplAdj = c.impl + corrected.length;
        if (corrected.length) F('WARN', 'M06', `대조표 실측 정정 ${corrected.length}행(구현→${corrected.map(id => C.get(id).status).join('/')}): ${corrected.join(', ')} — 후퇴로 세지 않음(비고의 'YYYY-MM-DD 실측|규칙 정정' 표식)`, '__asis-mapping__.md');
        if (c.n < h.n || cImplAdj < h.impl) F(FINAL ? 'BLOCK' : 'WARN', 'M06', `대조표 후퇴: 행 ${h.n}→${c.n} · 구현 ${h.impl}→${c.impl}${corrected.length ? `(정정 ${corrected.length} 제외 시 ${cImplAdj})` : ''} (커밋본 대비) — 기존 대조표를 재생성하지 말고 커밋본 위에 행을 추가`, '__asis-mapping__.md');
      }
    }
  }
}
// 4) As-is Fact Pack 대사 (gap-lite)
const sdir = ID ? path.join(cfg.asisOutDir, 'screens', ID) : null;
if (sdir && fs.existsSync(sdir)) {
  const cur = rows => rows.filter(r => r.variant !== 'legacy');
  const gaps = readCsv(path.join(R, 'allowed_gaps.csv'));
  const allowed = (kind, v) => gaps.some(g => g.kind === kind && new RegExp(g.pattern, 'i').test(v));
  const all = Object.values(src).join('\n');
  // 4a 시트 → SHEETS enum
  const grid = readCsv(path.join(sdir, 'grid_effective.csv'));
  for (const sheet of [...new Set(grid.map(g => g.sheet))].filter(s => s && s !== '(시트 미상)' && !/popup/i.test(s))) if (!all.includes(`'${sheet}'`)) F('WARN', 'G01', `As-is 시트 '${sheet}' 가 SHEETS enum 에 없음 (배포 SHEET_NAME 케이싱 그대로)`);
  // 4b 엔드포인트 → 매핑표 §4 또는 코드 참조
  const eps = cur(readCsv(path.join(sdir, 'endpoints.csv'))); const seen = new Set();
  for (const e of eps) { const sp = (e.sp_or_sql || '').replace(/^SP\s+/, ''); const k = e.key || e.candidate; if (!k || seen.has(k)) continue; seen.add(k); if (allowed('endpoint', sp) || allowed('endpoint', k)) continue;
    const row = mapRows.find(r => r.summary.includes(k) || (sp && r.summary.includes(sp)));
    if (!row) F('WARN', 'G02', `As-is 엔드포인트 ${k} (${sp}) 매핑표 §4 에 없음`); else if (/^미구현/.test(row.status) && FINAL) F('BLOCK', 'G02', `As-is 엔드포인트 ${k} 미구현 (SP 등록·배선 필요)`); }
  // 4c 이벤트 핸들러 → 매핑표 §2
  const evs = cur(readCsv(path.join(sdir, 'events.csv'))).filter(e => e.op === '+=' && e.handler !== '<lambda>' && /^[A-Z]/.test(e.event));
  const mainClass = (evs.find(e => e.class.startsWith(ID + '_') && !/popup/i.test(e.class)) || evs[0] || {}).class;
  for (const e of evs.filter(e => e.class === mainClass)) { const tgt = e.target.replace(/^this\./, ''); if (allowed('event', e.target + ' ' + e.event) || allowed('control_name', tgt)) continue;
    const row = mapRows.find(r => r.summary.includes(`${tgt} / ${e.event}`)); if (!row) F('WARN', 'G03', `As-is 이벤트 ${tgt}.${e.event} → ${e.handler} 매핑표 §2 에 없음`); }
  // 4d 조회조건 컨트롤 → 매핑표 §1
  const ctls = cur(readCsv(path.join(sdir, 'controls.csv'))).filter(c => c.class === mainClass);
  const mapCtl = readCsv(path.join(R, 'map_control.csv'));
  for (const c of ctls) { const t = c.type.split('.').pop(); const r = mapCtl.find(x => x.asis_type === t); if (allowed('control_type', t) || allowed('control_name', c.name) || (r && (r.gen === 'skip' || r.gen === 'container'))) continue;
    const row = mapRows.find(x => x.summary.includes(`${c.name} / `)); if (!row) F('WARN', 'G04', `As-is 컨트롤 ${c.name} / ${t} 매핑표 §1 에 없음`); }
  // H04 (2026-10-21 사용자 룰 "Checkbox·RadioButton Design"): As-is RadioGroup/UsrRadio/RadioButton 컨트롤은 To-Be 도 라디오(@shared/lges 의 Radio·RadioGroup — packages/shared/src/lib/lges.ts 가 design-system 을 재export)로 만든다.
  //   "공용 RadioGroup 부재" 를 이유로 CustomDropdown 으로 바꾼 사례(SCP0100 rgrpSearchLevel, capa-line-master)는 사실과 다르다. 예외 = 매핑표 §1 그 컨트롤 행이 '제외'(카탈로그 '조회조건 삭제' 근거).
  {
    const radios = ctls.filter(c => /RadioGroup|UsrRadio|RadioButton/i.test(c.type));
    const pageHasRadio = Object.values(src).some(t => /<RadioGroup\b|<Radio\b/.test(t));
    for (const c of radios) {
      if (allowed('control_name', c.name)) continue;
      const row = mapRows.find(x => x.summary.includes(`${c.name} / `));
      if (row && /^(제외|해당없음)/.test(row.status)) continue;
      if (!pageHasRadio) F(FINAL ? 'BLOCK' : 'WARN', 'H04', `As-is 라디오 ${c.name}(${c.type.split('.').pop()}) 인데 페이지에 RadioGroup/Radio 가 없음 — 드롭다운 대체 금지. @shared/lges 의 RadioGroup+Radio(labelText) 로 구현하거나, 카탈로그 '조회조건 삭제' 면 매핑표 행을 '제외'(근거 기재)로`, '__asis-mapping__.md');
    }
  }
  // H03 (hook #154 v2 — 사용자 지시 2026-10-23 캡처, 10-21 '한 칸 묶음' 판정을 대체): 조회조건 Checkbox/Radio 디자인 =
  //   조건명은 FormItem 좌측 라벨 열(label=조건명/그룹명) · Checkbox 는 박스만(labelText 금지) · 체크박스 조건마다 Grid 칸 1개.
  //   정본 = supply/global-psi-report GlobalPsiReportForm checkbox()/radio(). 판정 구간 = 컨트롤 직전 <Grid ~ 컨트롤.
  for (const [f, t] of Object.entries(src)) if (/Form\.tsx$/.test(f) && /<SearchArea\b|conditions=\{/.test(t)) {
    for (const m of t.matchAll(/<(Checkbox|RadioGroup)\b/g)) {
      const g = t.lastIndexOf('<Grid', m.index); if (g < 0) continue;
      const seg = t.slice(g, m.index); const fi = seg.lastIndexOf('<FormItem'); const tail = fi >= 0 ? seg.slice(fi) : '';
      const tag = t.slice(m.index, t.indexOf('>', m.index) + 1); const ln = t.slice(0, m.index).split('\n').length;
      let why = '';
      if (fi < 0) why = 'FormItem 없음(라벨 열부터 시작)';
      else if (/\blabel=\{?(''|"")\}?/.test(tail) || !/\blabel=/.test(tail)) why = "FormItem label 빈값/미지정(라벨 트랙 없음)";
      else if (/\blabel=\{?['"`](\\u00[Aa]0| | )['"`]\}?/.test(tail)) why = 'v1 무라벨(NBSP/공백 라벨) — 조건명을 FormItem label 로';
      else if (m[1] === 'Checkbox' && /\blabelText=/.test(tag)) why = 'Checkbox labelText(박스 옆 글자) — 조건명은 FormItem label 로, 박스만';
      else if (m[1] === 'Checkbox' && (seg.slice(fi).match(/<Checkbox\b/g) || []).length >= 1) why = '한 FormItem 안에 체크박스 여러 개 — 조건마다 Grid 칸 1개';
      if (why) F(FINAL ? 'BLOCK' : 'WARN', 'H03', `조회조건 <${m[1]}> 디자인(hook #154 v2): ${why}. 정본 GlobalPsiReportForm checkbox()/radio() — Grid(customGrid)+FormItem(formItem, label=조건명, labelAlign='right')+customCheckbox+<Checkbox checked onChange/> · Radio = FormItem label=그룹명 + <RadioGroup row><Radio labelText/>`, `${rel(f)}:${ln}`);
    }
  }
  // 4e 사전 준수 — Form 에서 쓴 컴포넌트가 사전의 To-Be 컴포넌트 집합 안인가
  // 카탈로그(rules/tobe_catalog.csv — TobeFacts framework.js 가 @foundation/@shared/master 공통에서 추출) 가 있으면 그 컴포넌트 전부가 허용 집합
  const catalog = fs.existsSync(path.join(R, 'tobe_catalog.csv')) ? readCsv(path.join(R, 'tobe_catalog.csv')) : [];
  const allowedComps = new Set(catalog.filter(r => r.kind === 'component').map(r => r.name).concat(mapCtl.map(r => r.tobe_component)).concat(['FlexGridFilter', 'FlexGrid', 'FlexGridColumn', 'PanelSeparator', 'Panel', 'PanelGroup', 'Fragment']).concat(['FormItem', 'Grid', 'SearchArea', 'MainTitle', 'SubTitle', 'DataGrid', 'CustomDialog', 'Button', 'Box', 'Stack', 'Panel', 'PanelGroup', 'TabWrapper', 'TabItem', 'Typography', 'Tooltip', 'Divider', 'Label', 'ResultArea', 'ProgressIndicator', 'ColumnLayoutModal', 'MeasureSelectModal', 'ItemByDivisionModal', 'ProjectByDivisionModal', 'SsoUserModal', 'SsoDeptModal', 'CustomerModal', 'OwnerByDivisionModal', 'ItemField', 'ProjectField', 'DivisionField', 'SalesSiteField', 'TeamField', 'OwnerField', 'VersionField', 'FunctionSearchIcon', 'IcGridColumnSetup', 'IcMeasureSelect', 'CascadeDropdown', 'PeriodRangePicker', 'DatePickerCalendar', 'Radio', 'RadioGroup', 'Checkbox', 'InputField', 'TextField', 'CustomDropdown', 'PeriodField']));
  const localComps = new Set(files.filter(f => /\.tsx$/.test(f)).map(f => path.basename(f, '.tsx')));
  for (const [f, t] of Object.entries(src)) if (catalog.length ? /\.tsx$/.test(f) : /Form\.tsx$/.test(f)) { for (const m of stripComments(t).matchAll(/(?<![\w\]\)])<([A-Z][A-Za-z0-9]*)[\s/>]/g)) if (!allowedComps.has(m[1]) && !localComps.has(m[1]) && !/^(React|Fragment|Suspense)$/.test(m[1])) F('WARN', 'D01', `사전 밖 컴포넌트 <${m[1]}> — 표준이면 rules/map_control.csv 에 등록, 아니면 공용 컴포넌트로 교체`, rel(f)); }
} else if (ID) F('WARN', 'G00', `As-is Fact Pack 없음: ${sdir} — As-is 대사 생략 (신규 To-Be 전용 화면이면 정상)`);
// 5) Validation / Expression 100% (룰 09) — 분석 MD 행 수 = 코드의 V-/E- 마커 수, 빈 apply 는 미이식
if (ID && cfg.analysisRoot) {
  const AN = require('./lib/analysis');
  for (const [kind, label, file] of [['V', 'Validation', /Validation\.ts$/], ['E', 'Expression', /Expression\.ts$/]]) {
    const rows = AN.load(cfg.analysisRoot, ID, kind).filter(r => !r.popup); if (!rows.length) continue;
    const hook = Object.entries(src).find(([f]) => file.test(f));
    if (!hook) { F(FINAL ? 'BLOCK' : 'WARN', 'V01', `As-is ${label} ${rows.length}건인데 hooks/use*${label}.ts 없음 (룰 09 100% 적용)`); continue; }
    const ids = new Set([...hook[1].matchAll(new RegExp(`id:\\s*'(${kind}-\\d{3})'`, 'g'))].map(m => m[1]));
    const missing = rows.filter(r => !ids.has(`${kind}-${String(r.no).padStart(3, '0')}`));
    if (missing.length) F('BLOCK', 'V01', `${label} 마커 누락 ${missing.length}/${rows.length}: ${missing.slice(0, 8).map(r => kind + '-' + String(r.no).padStart(3, '0') + '(L' + r.line + ')').join(' ')}`, rel(hook[0]));
    const todo = (hook[1].match(/apply: \(\) => \{ \/\* TODO/g) || []).length;
    if (todo) F(FINAL ? 'BLOCK' : 'WARN', 'V02', `${label} 미이식 ${todo}/${rows.length} (apply 본문이 TODO)`, rel(hook[0]));
  }
}
// 6) 메시지 ID (2026-10-22 사용자 지시) — AS-IS 와 TO-BE 는 같은 MSG ID 를 다른 문구에 쓴다(MSG00001 AS-IS '모든 항목은 필수 입력입니다.' / TO-BE '저장 하시겠습니까?').
//    이 화면이 AS-IS 에서 쓰던 MSG ID 가 페이지 코드에 그대로 있고 TO-BE 에서 뜻이 다르면 BLOCK — 문구로 찾은 TO-BE ID(lib/msgmap)를 써야 한다.
//    TO-BE 뜻으로 일부러 쓴 것이면 같은 줄에 `MSG-OK` 주석. 주석 안의 ID(생성기 표기 'AS-IS MSGxxxxx')는 보지 않는다.
if (ID) {
  const MM = require('./lib/msgmap'); const MSGM = MM.load(cfg);
  if (MSGM.ok) {
    const asisUsed = new Set(); const seenMs1 = new Set();
    try { for (const r of require('./lib/analysis').load(cfg.analysisRoot, ID, 'V')) { const c = String(r.asisMsg || r.msg || '').trim().toUpperCase(); if (/^MSG\d+$/.test(c)) asisUsed.add(c); } } catch { /* 분석서 없음 */ }
    const fpDir = path.join(cfg.asisOutDir || '', 'screens', ID);
    if (fs.existsSync(fpDir)) for (const f of fs.readdirSync(fpDir)) { try { for (const m of fs.readFileSync(path.join(fpDir, f), 'utf8').matchAll(/MSG\d{5}/g)) asisUsed.add(m[0]); } catch { /* 폴더 등 */ } }
    for (const [f, t] of Object.entries(src)) t.split(/\r?\n/).forEach(ln => {
      if (/MSG-OK/.test(ln)) return;
      const cut = ln.indexOf('//'); const codePart = cut >= 0 ? ln.slice(0, cut) : ln;
      for (const m of codePart.replace(/\/\*.*?\*\//g, '').matchAll(/MSG\d{5}/g)) {
        const c = m[0]; if (!asisUsed.has(c) || !MM.collides(MSGM, c)) continue;
        const r = MM.map(MSGM, c); if (r.tobe === c || seenMs1.has(c + '@' + f)) continue; seenMs1.add(c + '@' + f);
        const tt = (MSGM.tobe.get(c) || {}).KO || '';
        // 검증 마커(생성기가 만든 AS-IS 유래 자리)·TO-BE 에 같은 문구가 없는 ID 는 BLOCK, 그 밖(핸들러 등)은 의도적 TO-BE 사용일 수 있어 WARN(전수 스캔 10-22: 44화면 — MSG00002 'TO-BE 저장 성공' 등 오탐 가능)
        const lv = (/Validation\.ts$/.test(f) && /\bmsg:\s*'MSG\d{5}'/.test(ln)) || r.tobe === 'MSG?????' ? 'BLOCK' : 'WARN';
        F(lv, 'MS1', `AS-IS 메시지 ID 그대로 사용: ${c} — AS-IS '${r.asisText.slice(0, 40)}' / TO-BE ${c} = '${tt.slice(0, 40)}' → 문구로 찾은 TO-BE ID ${r.tobe}${r.tobe === 'MSG?????' ? ' (TO-BE 에 같은 문구 없음 — msg_master 신규 등록 MSG01001+)' : ''}`, rel(f));
      }
    });
  }
}

// 7) VALIDATION 취합 대조 (사용자 지시 2026-10-23) — SCP·SSP 화면은 Doc/화면분석서/{SCP|SSP}_화면_VALIDATION_취합_<최신>/<ID>.md 가 AS-IS 검증 전수 + TO-BE 판정.
//    VR1 = 취합 기준 UI 미적용 행(AS-IS 에 있고 TO-BE 에 없던 검사) 안내 · VR2 = 취합이 [메시지 불일치]/[메시지 미등록] 으로 판정한 TO-BE ID 가 코드에 남아 있음.
//    취합은 2026-10-22 판독 시점의 판정이라 이후 보완을 반영하지 못한다 → BLOCK 이 아닌 WARN(확인 후 고쳤거나 의도면 같은 줄 `VR-OK` 주석).
if (ID) {
  const VR = require('./lib/valref'); const vr = VR.find(cfg, ID);
  if (vr && vr.screen) {
    const one = s => String(s || '').replace(/\s+/g, ' ');
    const ui = vr.block.filter(x => x['UI / DB'] === 'UI');
    const miss = ui.filter(x => x['TO-BE 적용여부'] === '미적용');
    if (miss.length) F('WARN', 'VR1', `VALIDATION 취합(${vr.stamp}) 기준 UI 미적용 ${miss.length}건 — ${miss.slice(0, 6).map(x => `${x.EVENT} SEQ${x.SEQ} ${one(x['VALIDATION MESSAGE']).slice(0, 30)}`).join(' / ')}${miss.length > 6 ? ' …' : ''} → 이식 또는 __asis-mapping__ 에 제외 근거`, vr.screen);
    const bad = new Map(); // TO-BE ID → 행 설명
    for (const x of ui) {
      const tag = VR.tagOf(x, '[메시지 미등록]') ? '[메시지 미등록]' : VR.tagOf(x, '[메시지 불일치]') ? '[메시지 불일치]' : ''; if (!tag) continue;
      const ids = VR.msgIds(x['(참고) MSG ID']);
      for (const t of ids.tobe) if (!bad.has(t)) bad.set(t, `${x.EVENT} SEQ${x.SEQ} AS-IS ${ids.asis.join('/') || '-'} ${tag} — ${one(x['(참고) 메시지 의미 대조']).slice(0, 90)}`);
    }
    const seenVr = new Set();
    for (const [f, t] of Object.entries(src)) t.split(/\r?\n/).forEach((ln, i) => {
      if (/VR-OK/.test(ln)) return; const cut = ln.indexOf('//'); const codePart = (cut >= 0 ? ln.slice(0, cut) : ln).replace(/\/\*.*?\*\//g, '');
      for (const m of codePart.matchAll(/MSG\d{5}/g)) if (bad.has(m[0]) && !seenVr.has(m[0] + '@' + f)) { seenVr.add(m[0] + '@' + f); F('WARN', 'VR2', `${m[0]} — VALIDATION 취합 판정: ${bad.get(m[0])}`, `${rel(f)}:${i + 1}`); }
    });
  }
}

// 8) 조회조건 기준표 (사용자 지시 2026-10-23) — SCP·SSP 화면 조회조건 순서·사용여부 = rules/search_cond.csv (참고자료 tools/VibeManager/rules/40_SEARCH_COND.md)
//    SC1 = 조회조건 순서가 기준표와 다름 · SC2 = 기준표가 제외/통합한 AS-IS 조건이 Form 에 남아 있음.
//    gen.js 산출(Form 주석 '기준표 #n' 표지 + Doc/gen/<ID>/search_cond.json)이 있는 페이지 = BLOCK(생성 후 손으로 순서·제외를 되돌린 것),
//    표지 없는 기존 화면 = WARN(라벨 문자열로 대조 — 기준표 반영 검토). 의도된 차이는 해당 줄 `SC-OK` 주석.
if (ID) {
  const SC = require('./lib/searchcond'); const ref = SC.forScreen(R, ID);
  if (ref) {
    const forms = Object.entries(src).filter(([f]) => /Form\.tsx$/.test(f) && !/[\\/]modals[\\/]/.test(f));
    const jf = path.join(cfg.genOutDir || '', ID, 'search_cond.json'); const J = cfg.genOutDir && fs.existsSync(jf) ? JSON.parse(read(jf)) : null;
    const tagged = forms.some(([, t]) => /기준표 #\d/.test(t)); const lv = tagged && J ? 'BLOCK' : 'WARN';
    if (J) {
      for (const [f, t] of forms) {
        const lines = t.split(/\r?\n/); const posOf = ctl => lines.findIndex(l => new RegExp(`AS-IS ${ctl} /`).test(l) && !/SC-OK/.test(l));
        const seq = J.order.map(o => ({ ...o, at: posOf(o.ctl) })).filter(o => o.at >= 0);
        for (let i = 1; i < seq.length; i++) if (seq[i].at < seq[i - 1].at) { F(lv, 'SC1', `조회조건 순서가 기준표(${J.domain} ${J.src})와 다름: '${seq[i].label}'(기준 ${seq[i].seq}번) 이 '${seq[i - 1].label}'(기준 ${seq[i - 1].seq}번) 보다 앞 — 기준 순서: ${J.order.map(o => o.label).join(' → ')}`, `${rel(f)}:${seq[i].at + 1}`); break; }
        for (const x of J.excluded) { const at = posOf(x.ctl); if (at >= 0) F(lv, 'SC2', `기준표가 ${x.usage}(${x.reason}) 로 정한 AS-IS 조회조건 ${x.ctl} 가 Form 에 남아 있음 — 제거(BUTTON_AREA 면 버튼 영역으로 이식)`, `${rel(f)}:${at + 1}`); }
      }
    } else if (forms.length) {
      // 라벨 대조: t('LBL…' | LBL.X, '_라벨') 의 '_라벨' 순서를 기준표 To-Be/As-Is 명칭에 대어 단조 증가인지
      const want = ref.main.filter(r => r.tobe_order); const ordOf = s => { const k = SC.canon(s.replace(/\*$/, '')); const r = want.find(r => SC.canon(r.tobe_name) === k) || want.find(r => SC.canon(r.asis_name) === k); return r ? Number(r.tobe_order) : 0; };
      for (const [f, t] of forms) {
        const hits = [...t.matchAll(/\bt\(\s*(?:'[A-Z?0-9]+'|LBL\.[A-Z0-9_]+)\s*,\s*'_([^']+)'\s*\)/g)].map(m => ({ label: m[1], o: ordOf(m[1]), line: t.slice(0, m.index).split('\n').length })).filter(h => h.o);
        for (let i = 1; i < hits.length; i++) if (hits[i].o < hits[i - 1].o) { F('WARN', 'SC1', `조회조건 순서가 기준표(${ref.domain} ${ref.src})와 다를 수 있음(라벨 대조): '${hits[i].label}' 이 '${hits[i - 1].label}' 보다 앞 — 기준 순서: ${[...new Map(want.sort((x, y) => x.tobe_order - y.tobe_order).map(r => [r.tobe_order, r.tobe_name])).values()].join(' → ')} (40_SEARCH_COND.md #### ${ID})`, `${rel(f)}:${hits[i].line}`); break; }
        const gone = ref.main.filter(r => SC.EXCLUDE.has(r.usage) && r.asis_name);
        for (const h of [...t.matchAll(/\bt\(\s*(?:'[A-Z?0-9]+'|LBL\.[A-Z0-9_]+)\s*,\s*'_([^']+)'\s*\)/g)]) { const k = SC.canon(h[1].replace(/\*$/, '')); const r = gone.find(r => SC.canon(r.asis_name) === k && !ref.main.some(x => x.usage === 'USE' && SC.canon(x.tobe_name) === k)); if (r) F('WARN', 'SC2', `기준표가 ${r.usage}(${r.usage_reason || r.change}) 로 정한 조회조건 '${h[1]}' 가 Form 에 있음 — 기준표 반영 검토`, `${rel(f)}:${t.slice(0, h.index).split('\n').length}`); }
      }
    }
  }
}

// 8c) 라벨 별칭 룰 (사용자 지시 2026-10-30 · CR-092) — SCP·SSP 컬럼·조회조건 명칭 Valid → Active 일괄. 정본 rules/label_alias.csv(scope·asis_label·tobe_label).
//    LB1 = 페이지 소스의 라벨 리터럴 '_Valid' / label: 'Valid' / header: 'Valid' 잔존 → 'Active' 로(FINAL BLOCK · 평소 WARN · 의도된 예외는 그 줄 `LB-OK`)
//    LB2 = TO-BE 메타(Doc/tobefacts/db/sheet_columns.csv) 이 화면 COLUMN_LABEL_NAME 이 변경 전 라벨 → 메타 UPDATE 대상(WARN — 화면 코드로 못 고치는 항목이라 BLOCK 하지 않음)
if (ID) {
  const laP = path.join(R, 'label_alias.csv');
  const csvRows = txt => { const L = txt.replace(/^\uFEFF/, '').split(/\r?\n/).filter(l => l.trim()); const cells = l => { const o = []; let c = '', q = false; for (let i = 0; i < l.length; i++) { const ch = l[i]; if (q) { if (ch === '"' && l[i + 1] === '"') { c += '"'; i++; } else if (ch === '"') q = false; else c += ch; } else if (ch === '"') q = true; else if (ch === ',') { o.push(c); c = ''; } else c += ch; } o.push(c); return o; }; const h = cells(L[0]); return L.slice(1).map(l => Object.fromEntries(cells(l).map((v, i) => [h[i], v]))); };
  const canonL = v => String(v || '').replace(/\*/g, '').toLowerCase().replace(/[^a-z0-9가-힣]/g, '');
  const scopeOkL = sc => { const ss = String(sc || 'ALL').toUpperCase().split(';').map(x => x.trim()).filter(Boolean); return ss.includes('ALL') || ss.includes(ID) || ss.some(x => x.length === 3 && ID.startsWith(x)); };
  const aliases = fs.existsSync(laP) ? csvRows(read(laP)).filter(a => a.asis_label && a.tobe_label && scopeOkL(a.scope)) : [];
  if (aliases.length) {
    const lv = FINAL ? 'BLOCK' : 'WARN';
    for (const [f, t] of Object.entries(src)) t.split(/\r?\n/).forEach((ln, i) => {
      if (/LB-OK/.test(ln)) return;
      for (const m of ln.matchAll(/(?:'_([^']+)'|\b(?:label|header|headerName|title|columnLabel)\s*:\s*'([^']+)')/g)) {
        const lit = m[1] || m[2]; const a = aliases.find(x => canonL(x.asis_label) === canonL(lit));
        if (a) F(lv, 'LB1', `라벨 리터럴 '${lit}' 은 TO-BE 룰 ${a.req_id}(SCP·SSP ${a.asis_label}→${a.tobe_label}) 변경 대상 — '${a.tobe_label}' 로 바꾼다(의도된 예외면 줄 끝 LB-OK)`, `${rel(f)}:${i + 1}`);
      }
    });
    const scP = path.join(__dirname, '..', '..', 'Doc', 'tobefacts', 'db', 'sheet_columns.csv');
    if (fs.existsSync(scP)) {
      for (const r of csvRows(read(scP))) {
        if (String(r.program_id || '').toUpperCase() !== ID || (r.valid_yn || 'Y') !== 'Y') continue;
        const a = aliases.find(x => canonL(x.asis_label) === canonL(r.column_label_name));
        if (a) F('WARN', 'LB2', `TO-BE 메타 SHEET_COLUMNS ${r.sheet_name}.${r.column_name} 라벨 '${r.column_label_name}' 은 TO-BE 룰 ${a.req_id} 변경 대상 → COLUMN_LABEL_NAME '${a.tobe_label}' 메타 UPDATE(사내 적용 절차 T18 · 화면 코드 수정으로는 해결 안 됨)`, `Doc/tobefacts/db/sheet_columns.csv PROGRAM_ID=${ID}`);
      }
    }
  }
}

// 8b) 조회영역 일괄 입력 = 버튼 영역 버튼 + 입력 팝업 (hook #155 — 사용자 지시 2026-10-23, 정본 SCP0096 shipment-working-day-osp)
//    대상 = 조회조건 기준표가 BUTTON_AREA + 'Bulk Update' 검토문구로 표시한 화면(SCP0019/SCP0096/SCP0098/SSP0005).
//    BU1 = ①SubTitle customButtons 에 Input/Bulk 버튼 없음 ②<Page>InputModal.tsx / BulkUpdateModal.tsx 없음(FINAL BLOCK·평소 WARN) ③버튼 라벨 리터럴(WARN)
if (ID) {
  const SCb = require('./lib/searchcond'); const refB = SCb.forScreen(R, ID);
  const bulk = refB ? refB.main.filter(r => r.usage === 'BUTTON_AREA' && /Bulk Update/i.test(`${r.review} ${r.change}`)) : [];
  if (bulk.length) {
    const all = Object.entries(src); const lv = FINAL ? 'BLOCK' : 'WARN';
    const btnHit = all.find(([, t]) => /customButtons=\{[\s\S]{0,600}?(LBL\.INPUT|'_?Input'|Bulk)/.test(t));
    const modalHit = files.find(f => /(InputModal|BulkUpdateModal)\.tsx$/.test(f));
    const where = `기준표 ${bulk.map(r => r.asis_name).join('·')} (${refB.domain} ${bulk[0].src_row}행~)`;
    if (!btnHit) F(lv, 'BU1', `조회영역 일괄 입력(${where}) — SubTitle customButtons 에 Input 버튼 없음. hook #155: 조회영역에서 빼고 customButtons [{ label: t(LBL.INPUT, '_Input'), action: handleInputOpen }](편집 권한 게이트 · 조회 선행 가드) — 정본 SCP0096`);
    if (!modalHit) F(lv, 'BU1', `조회영역 일괄 입력(${where}) — 입력 팝업 components/<Page>InputModal.tsx 없음. hook #155 정본 ShipmentWorkingDayOspInputModal(CustomDialog 520×280 modaless · FormItem · OK/Close · onConfirm boolean · EditTracker 경유 셀 기록)`);
    if (btnHit && /customButtons=\{[\s\S]{0,600}?label:\s*'[^']*(Input|Bulk)[^']*'/.test(btnHit[1])) F('WARN', 'BU1', `일괄 입력 버튼 라벨이 리터럴 — t(LBL.INPUT, '_Input') 로(다국어 E13·hook #155 X3)`, rel(btnHit[0]));
  }
}

// 8c) 대조표 검증 커버리지 (사용자 지시 2026-10-26 — "대조표에 있는데 오류여부를 확인하지 않으면 제대로 생성된 것인지 확인할 방법이 없다 · 누락되는 검증 없이")
//    원천 = Doc/verify/<ID>/mapping_trace_summary.json (tools/Harness/verify/mapping_trace.py — 🔎 화면 정합검증 run_verify 마지막 단계)
//    VC1 = 대조표(FE __asis-mapping__ + AS-IS 액션 전 문장) 행 중 FAIL·미구현·미검증(NOT_RUN·NOPATH·TODO·BLOCKED·REVIEW) > 0 또는 추적 미실행 · FE 대조표 없음 — 완료(--final) 차단, 평소 WARN (v2 2026-10-26: 검증 불필요 분류 없음)
//    VC2 = 시노님·권한 누락(Doc/verify/<ID>/syn_check.csv — SCMP_APP 이 부르는 PKG·콤보 SQL 객체) — 완료 차단, 평소 WARN
if (ID) {
  const vdir = path.join(path.dirname(cfg.genOutDir || path.join(__dirname, '..', '..', 'Doc', 'gen')), 'verify', ID);
  const sumF = path.join(vdir, 'mapping_trace_summary.json'); const lv = FINAL ? 'BLOCK' : 'WARN';
  if (!fs.existsSync(sumF)) F(lv, 'VC1', `대조표 검증 추적 없음 — 🔎 화면 정합검증(python tools/Harness/verify/run_verify.py ${ID}) 또는 mapping_trace.py ${ID} 실행. 대조표 행마다 검증 결과가 있어야 완료`);
  else {
    const s = JSON.parse(read(sumF)); const v = s.verdict || {};
    if (s.fe_mapping_missing) F(lv, 'VC1', `FE 대조표(__asis-mapping__.md) 없음 — AS-IS 기능 대조 원천이 없어 검증 대상 자체가 없다`);
    if (v.FAIL) F(lv, 'VC1', `대조표 FAIL ${v.FAIL}행 (Doc/verify/${ID}/mapping_trace.md §FAIL)`);
    if (v['미구현']) F(lv, 'VC1', `대조표 미구현 ${v['미구현']}행 — 작업 원장 Doc/verify/${ID}/work_ledger.md W1(기능 구현)`);
    if (v['미검증']) F(lv, 'VC1', `대조표 미검증 ${v['미검증']}행 — 검사 사유 ${Object.entries(s.unverified_reasons || {}).map(([k, n]) => `${k} ${n}`).join(' · ')} (NOT_RUN = 검사기 있음·미실행 · NOPATH = 검사기 있으나 이 대상 실행 경로 없음 · TODO = 검사기 미구현). 미검증은 PASS 가 아니다`);
    // 작업 원장(impl_engine.py) — PASS·NA 가 아닌 검사 인스턴스 전부 = 할 일. 0건이어야 완료
    const wlF = path.join(vdir, 'work_ledger_summary.json');
    if (fs.existsSync(wlF)) { const w = JSON.parse(read(wlF)); if (w.open) F(lv, 'VC1', `작업 원장 미완료 ${w.open}건 / 검사 인스턴스 ${w.instances} — ${Object.entries(w.by_type || {}).map(([k, n]) => `${k} ${n}`).join(' · ')}${w.suspect_not_implemented ? ` · 구현 의심 ${w.suspect_not_implemented}` : ''} (Doc/verify/${ID}/work_ledger.md)`); }
    else F('WARN', 'VC1', `작업 원장 없음 — python tools/Harness/verify/impl_engine.py ${ID}`);
    if (s.version !== 2) F('WARN', 'VC1', `대조표 추적 v1 결과 — mapping_trace.py v2(대조표 전 행 × 검사 카탈로그) 로 재실행`);
    const age = (Date.now() - fs.statSync(sumF).mtimeMs) / 36e5; if (age > 24) F('WARN', 'VC1', `대조표 검증 추적이 ${Math.round(age)}시간 전 결과 — 재실행 후 판정`);
  }
  const synF = path.join(vdir, 'syn_check.csv');
  if (fs.existsSync(synF)) { const bad = readCsv(synF).filter(r => /SYN_MISSING|PRIV_MISSING|TARGET_MISSING|INVALID/.test(r.verdict)); if (bad.length) F(lv, 'VC2', `BE 계정 시노님·권한 문제 ${bad.length}건 — ${bad.slice(0, 4).map(r => `[${r.verdict}] ${r.kind} ${r.source} ${r.name}`).join(' · ')} (호출 시 ${bad[0].error_if_called}) · Doc/verify/${ID}/syn_check.csv`); }
}

// 9) 다국어 미적용 (사용자 지시 2026-10-23 — "다국어가 적용되지 않아서 접두어(_) 붙어서 나오는 것도 오류")
//    번역 원천 = DB SCM_ADM_MSG_M(FE i18n loadPath 'admin/message'). t(코드, '_기본문구') 의 코드가 마스터에 없으면(또는 '' / LBL????? / 미해석 상수)
//    화면에 '_기본문구' 가 그대로 보인다. I18N1 = '_' 노출 확정(FINAL BLOCK · 평소 WARN) · I18N2 = 코드 미등록이지만 기본문구에 '_' 없음(영문 고정 — 다국어 미적용, WARN)
//    · I18N3 = 코드는 있으나 KO/EN 행 일부 없음(WARN). 판정 원천 = Doc/tobefacts/db/msg_master.csv 스냅샷(24h 초과면 메시지에 표기 — 런타임 확인은 E2E smoke 'i18n').
//    의도된 예외는 해당 줄 `I18N-OK` 주석.
{
  const mf = path.join(cfg.tobeOutDir || '', 'db', 'msg_master.csv');
  if (cfg.tobeOutDir && fs.existsSync(mf)) {
    const ageH = Math.round((Date.now() - fs.statSync(mf).mtimeMs) / 36e5); const stale = ageH > 24 ? ` (msg_master 스냅샷 ${ageH}시간 전 — python tools/DbConn/export_tobe_meta.py msg_master 로 새로고침 후 재판정)` : '';
    const langs = new Map(); for (const r of readCsv(mf)) { if ((r.use_yn || 'Y') === 'N') continue; const k = String(r.msg_id || '').toUpperCase(); if (!langs.has(k)) langs.set(k, new Set()); langs.get(k).add(String(r.lang_cd || '').toUpperCase()); }
    // 페이지 안 상수 객체(export const LBL/MSG/… = { NAME: 'LBL00112', … }) → 'LBL.NAME' 해석표
    const consts = new Map();
    for (const t of Object.values(src)) for (const m of t.matchAll(/export\s+const\s+([A-Z_][A-Z0-9_]*)\s*=\s*\{([\s\S]*?)\}\s*(?:as\s+const)?\s*;/g)) for (const kv of m[2].matchAll(/([A-Z_][A-Z0-9_]*)\s*:\s*'((?:LBL|MSG|MNU)[0-9?]{5})'/g)) consts.set(`${m[1]}.${kv[1]}`, kv[2]);
    const seenI = new Set();
    for (const [f, t] of Object.entries(src)) {
      if (/\.test\.tsx?$|__tests__/.test(f)) continue;
      const lines = t.split(/\r?\n/); const code0 = stripComments(t); // 주석 속 예시(t(LBL.KEY, '_Fallback') 등)는 제외 — 위치는 보존
      for (const m of code0.matchAll(/\bt\(\s*('([^']*)'|([A-Z_][A-Z0-9_]*\.[A-Z0-9_]+))\s*,\s*'([^']*)'/g)) {
        const ln = code0.slice(0, m.index).split('\n').length; if (/I18N-OK/.test(lines[ln - 1] || '')) continue;
        const ref = m[2] != null ? m[2] : m[3]; const code = m[2] != null ? m[2] : consts.get(m[3]) || ''; const def = m[4];
        const key = `${f}:${ln}:${ref}`; if (seenI.has(key)) continue; seenI.add(key);
        const has = code && /^(LBL|MSG|MNU)\d{5}$/.test(code) && langs.has(code.toUpperCase());
        if (!has) {
          const why = !ref ? "코드 '' (빈 키)" : /\?/.test(code) ? `코드 ${code}(미확정)` : !code ? `상수 ${ref} 해석 불가(페이지 constants 에 없음)` : `코드 ${code} 가 msg_master 에 없음`;
          if (/^_/.test(def)) F(FINAL ? 'BLOCK' : 'WARN', 'I18N1', `다국어 미적용 — 화면에 '${def}' 가 그대로 보임: ${why}. 기존 LBL/MSG 재사용(문구로 찾기) 또는 SCM_ADM_MSG_M 신규 등록(KO/EN/CN, LBL01001+/MSG01001+) 후 코드 기입${stale}`, `${rel(f)}:${ln}`);
          else if (def) F('WARN', 'I18N2', `다국어 미적용(영문 고정 '${def.slice(0, 30)}'): ${why} — 언어 전환 시 번역되지 않음${stale}`, `${rel(f)}:${ln}`);
        } else {
          const ls = langs.get(code.toUpperCase()); const miss = ['KO', 'EN'].filter(x => !ls.has(x));
          if (miss.length) F('WARN', 'I18N3', `${code} 의 ${miss.join('/')} 행 없음 — 해당 언어에서 '${def}' 로 보일 수 있음${stale}`, `${rel(f)}:${ln}`);
        }
      }
    }
  }
}

// ── B) 기초 누락 방지(완료 정의 DoD) — 룰 25/12/13/17 의 '기초' 항목을 기계 판정. 산출: Doc/gen/<ID>/DOD.md
// ── R: 이관 룰 게이트 (tools/VibeManager/rules/10_RULES_KEEP.md — 출처 hook 번호 표기). 주석 제거 후 검사.
{
  const stripC = t => t.replace(/\/\*[\s\S]*?\*\//g, '').replace(/^\s*\/\/.*$/gm, '');
  const R = [
    ['R01', 'BLOCK', /from\s+'(\.\.\/){3,}|from\s+'@(foundation|shared)\/[^'/]+\/[^'/]+\//, '페이지 폴더 밖 상대 import / alias deep import — 2-depth alias 만 (#71 framework-foundation-entry)'],
    ['R02', 'BLOCK', /from\s+'(clsx|lodash|react-i18next|@tanstack\/react-query)'/, '직접 import 금지 → @foundation 재export (#40 react-query-foundation-reexport, UI체크 3.3)'],
    ['R03', 'BLOCK', /\bwindow\.(alert|confirm)\s*\(|(^|[^\w.])alert\s*\(/m, 'window.alert/confirm → useMessageStore (#26 messaging-api)'],
    ['R04', 'BLOCK', /(^|[^\w])<FlexGrid(Column)?(\s|\/?>)/m, 'FlexGrid JSX 직접 금지 → 공용 DataGrid (#10 datagrid-shared-component)'],
    ['R05', 'BLOCK', /:\s*any\b|as\s+any\b|as\s+unknown\s+as\b/, '`any` / `as unknown as` 금지 (#73 procedure-dts-ssot)'],
    ['R06', 'BLOCK', /<DataGrid[^>]*\binitialized=/, 'DataGrid initialized prop deprecated → useEffect+gridRef (#70 runtime-pitfalls)'],
    ['R07', 'BLOCK', /use\w+Store\(\s*(state|s)\s*=>\s*(state|s)\.\w+\s*\?\?\s*(\[\]|\{\})/, 'zustand selector ?? 폴백 금지 — 초기값 stable 참조 (#70)'],
    ['R08', 'BLOCK', /useTabProcQuery<[^>]*>\(\s*\{[^}]*\bfilters:\s*\{/, 'useTabProcQuery filters 인라인 객체 리터럴 금지(참조 비교 → 무한 재요청) (#70)'],
    ['R09', 'BLOCK', /\b(rowStatus|ROW_STATUS|actionFlag|isNewRow)\b/, '자체 행상태 필드 금지 — CRUD_TYPE 전용 (#99 §0)'],
    ['R10', 'WARN', /createdBy:\s*''|map\(\(\)\s*=>\s*''\)/, '감사키 빈문자열 (#99 §0.1)'],
    ['R11', 'BLOCK', /\bfetch\s*\(|from\s+'axios'/, '직접 fetch/axios 금지 → useTabProcQuery/useProcMutation/apiClient (.claude/rules/00-fe-screen §E)'],
    ['R12', 'BLOCK', /style=\{\{/, 'inline style 금지 → SCSS Module (절대금지 ⑤)'],
    ['R13', 'BLOCK', /console\.log\(/, 'console.log 금지 (절대금지 ③)'],
    ['R14', 'WARN', /<dialog[\s>]|from\s+'@mui\/material'/, '인라인 dialog/MUI Dialog 금지 → CustomDialog (#35)'],
  ];
  for (const [f, t] of Object.entries(src)) { if (/\.(test|spec|repro\.test)\.tsx?$/.test(rel(f))) continue; const c = stripC(t); for (const [code, lv, re, msg] of R) { const m = re.exec(c); if (m) F(lv === 'BLOCK' && !FINAL ? 'WARN' : lv, code, msg, `${rel(f)}:${c.slice(0, m.index).split('\n').length}`); } }
  // R15: apiClient.post(call-proc) 직접 호출 후 5줄 안에 결과 판정(res.status >= 400 || code) 없음 (gate §1-3)
  for (const [f, t] of Object.entries(src)) { const lines = stripC(t).split('\n'); lines.forEach((ln, i) => { if (/apiClient\.post\([^)]*call-proc/.test(ln) && !/status\s*>=\s*400|\.code\)/.test(lines.slice(i, i + 6).join('\n'))) F(FINAL ? 'BLOCK' : 'WARN', 'R15', 'call-proc 직접 호출 결과 판정 없음 — if (res.status >= 400 || Number(res.data.code)) (gate §1-3)', `${rel(f)}:${i + 1}`); }); }
  // R16: 진입 Page 400 라인 초과 (#9 components-folder-pattern)
  for (const [f, t] of Object.entries(src)) if (/^(?!.*components\/).*\.tsx$/.test(rel(f)) && /PageProps</.test(t) && t.split('\n').length > 400) F('WARN', 'R16', `진입 Page ${t.split('\n').length} 라인 > 400 — components/ 분리 (#9)`, rel(f));
}
const DOD = []; const dod = (code, ok, what, how, level) => { DOD.push({ code, ok, what, how }); if (!ok) F(level || (FINAL ? 'BLOCK' : 'WARN'), code, `${what} — ${how}`); };
{
  const all = Object.values(src).join('\n'); const pageFiles = Object.entries(src).filter(([f]) => /^(?!.*components\/).*\.tsx$/.test(rel(f)) && /PageProps</.test(src[f]));
  const pageSrc = pageFiles.map(([, t]) => t).join('\n'); const formSrc = Object.entries(src).filter(([f]) => /Form\.tsx$/.test(f)).map(([, t]) => t).join('\n'); const gridSrc = Object.entries(src).filter(([f]) => /Grid[A-Za-z0-9]*\.tsx$/.test(f)).map(([, t]) => t).join('\n');
  const constSrc = Object.entries(src).filter(([f]) => /constants\.ts$/.test(f)).map(([, t]) => t).join('\n'); const storeSrc = Object.entries(src).filter(([f]) => /^use[A-Z].*Store\.ts$/.test(rel(f))).map(([, t]) => t).join('\n');
  const idxF = files.find(f => rel(f) === 'index.ts');
  dod('B01', !!idxF && /export\s+(\{|default|\*)/.test(idxF ? read(idxF) : ''), 'index.ts 가 화면 컴포넌트를 export', 'viewRegistry 는 pages/*/index.ts 를 glob 수집 — export 없으면 메뉴에서 열리지 않음');
  dod('B02', /export const MENU_ID = '[A-Z0-9_]+' as const/.test(constSrc) && /export type MENU_ID = typeof MENU_ID/.test(constSrc), 'constants: MENU_ID as const + type MENU_ID', 'useTabProcQuery<MENU_ID> 제네릭·procedures.d.ts 연결의 전제');
  dod('B03', /SHEETS/.test(constSrc), 'constants: SHEETS(시트명) 상수', '시트명 문자열 하드코딩 금지 — call-proc 3-키의 sheet');
  dod('B04', /createPersistedStoreWithTab/.test(storeSrc), 'store: createPersistedStoreWithTab', 'MDI 탭별 상태 격리 규약(룰 17)');
  dod('B05', /useTabProcQuery<MENU_ID[,>]/.test(pageSrc), 'Page: useTabProcQuery<MENU_ID> 조회', '화면 조회는 메타 기반 call-proc 훅으로 — apiClient 직접 호출 금지');
  const hk = pageSrc.match(/const hotkeyConfig: HotkeyConfig = \{([\s\S]*?)\n  \};/); const hkBody = hk ? hk[1] : '';
  dod('B06', !!hk && /\bsearch:/.test(hkBody), 'SubTitle hotkeyConfig 에 search 지정', 'F5 조회 배선(룰 25 §1.5.1)');
  for (const k of ['save', 'insert', 'delete', 'upload', 'manual']) dod('B07', !hk || new RegExp(`\\b${k}:\\s*(false|\\w+)`).test(hkBody), `hotkeyConfig.${k} 명시(function 또는 false)`, '정의 없는 공통 버튼은 false 명시 의무 — silent omit 금지(룰 25 §1.5.1)');
  // As-is 근거 대조: members.csv(BaseForm override) 가 있으면 override 된 버튼이 false 면 BLOCK
  if (sdir && fs.existsSync(path.join(sdir, 'members.csv'))) {
    const mem = readCsv(path.join(sdir, 'members.csv')).filter(r => r.variant !== 'legacy' && /override/.test(r.modifiers || '') && Number(r.lines) > 3);
    // 2026-10-26 TO-BE 룰: 기능이 없는 공통버튼은 숨긴다 — AS-IS override 가 있어도 본문이 NO-OP(actions.csv 에 그 메서드의 RETURN/주석 외 동작 문장 0)이면 false 가 정답
    const acts = fs.existsSync(path.join(sdir, 'actions.csv')) ? readCsv(path.join(sdir, 'actions.csv')) : null;
    const noop = n => acts ? !acts.some(a => a.method === n && !/^(RETURN|COMMENT)$/.test(a.kind || '')) : false;
    const over = n => mem.some(r => r.member === n) && !noop(n);
    const pairs = [['InsertButton', 'insert'], ['DeleteButton', 'delete'], ['SaveButton', 'save'], ['UploadButton', 'upload'], ['ImportButton', 'upload']];
    for (const [asis, key] of pairs) if (over(asis) && hk) dod('B08', !new RegExp(`\\b${key}:\\s*false`).test(hkBody), `As-is ${asis} override 있음 → hotkeyConfig.${key} 가 false 가 아니어야 함`, `As-is 기능 누락(members.csv ${asis})`);
    // 역방향(2026-10-26): AS-IS 가 NO-OP 인데 TO-BE 가 핸들러를 넘기면 '기능 없는 버튼 노출' — 명시적 무동작 `() => undefined` 도 금지
    for (const [asis, key] of pairs) if (mem.some(r => r.member === asis) && noop(asis) && hk) dod('B08', !new RegExp(`\\b${key}:\\s*\\(\\)\\s*=>\\s*undefined`).test(hkBody), `As-is ${asis} 는 NO-OP → hotkeyConfig.${key} 는 false(기능 없는 공통버튼 숨김 — TO-BE 룰 2026-10-26)`, `무동작 핸들러로 버튼을 노출 중`);
    if (!over('ExcelButton') && hk) dod('B08', /excel:\s*false/.test(hkBody) || true, 'As-is ExcelButton 없음 — excel 기본 활성 허용(SubTitle 기본)', '정보', 'WARN');
    const ctl = readCsv(path.join(sdir, 'controls.csv')).filter(r => r.variant !== 'legacy'); const hasCond = ctl.some(c => /UsrConditionPanel/i.test(c.type));
    if (hk && !hasCond) dod('B09', /condition:\s*false/.test(hkBody) && /resetCondition:\s*false/.test(hkBody), 'UsrConditionPanel 없는 화면: condition/resetCondition: false 명시', '룰 25 §1.5.3');
    // 팝업: As-is 팝업 클래스 → components/modals/*Modal.tsx 또는 매핑표에 공통 재사용 명시
    const popups = [...new Set(ctl.map(c => c.class).filter(cl => /popup/i.test(cl)))];
    const mapTxt = mapFile ? read(mapFile) : '';
    for (const pc of popups) { const stem = pc.replace(/^[A-Z]+\d{4}_?/, '').replace(/Popup|PopUp/i, ''); const has = files.some(f => /components\/modals\/.*Modal\.tsx$/.test(rel(f)) && new RegExp(stem.slice(0, 6), 'i').test(path.basename(f))) || new RegExp(pc + '[^\n]*(재사용|공통|@shared|@master)').test(mapTxt); dod('B10', has, `As-is 팝업 ${pc} → components/modals/*Modal.tsx 또는 매핑표에 공통 모달 재사용 명시`, '룰 25 §3 연결 POPUP 1:1'); }
    if (popups.length) dod('B11', /## POPUP 매핑|§3 POPUP|POPUP/.test(mapTxt), '__asis-mapping__.md 에 POPUP 매핑 섹션', '룰 25 §3.3.1 — button/SP/event/validation 4축');
    // Division 분기 보존: As-is grid_effective 의 division 축이 2개 이상 다른 구성 → 코드에 divisionId 참조
    const ge = readCsv(path.join(sdir, 'grid_effective.csv')); const divCols = ge.length ? Object.keys(ge[0]).filter(k => !['sheet', 'sheet_rule', 'column', 'label', 'source'].includes(k)) : [];
    const differs = ge.some(g => { const vals = new Set(divCols.map(d => g[d] ? 'Y' : 'N')); return vals.size > 1; });
    if (differs) dod('B12', /divisionId|DIVISION_ID|division/i.test(pageSrc + gridSrc + formSrc + storeSrc), 'As-is Division 별 컬럼 구성이 다름 → Division 분기 참조 존재', 'Division 40/81/82 분기 통합 금지(룰 09)', 'WARN');
    // 핸들러 AS-IS 라인 주석
    const ev = readCsv(path.join(sdir, 'events.csv')).filter(r => r.variant !== 'legacy' && r.op === '+=' && /^[A-Z]/.test(r.event)).length;
    const asisRefs = (all.match(/AS-IS [^\n]*:\d+/g) || []).length;
    dod('B13', ev === 0 || asisRefs >= Math.min(ev, 3), 'AS-IS 파일:라인 주석(// AS-IS …:L)', `이벤트 ${ev}건 대비 AS-IS 참조 주석 ${asisRefs}건 — 1:1 추적 근거`, 'WARN');
  }
  // Form 표준 import(룰 25 §1.5.4)
  if (formSrc) {
    dod('B14', /from '@shared\/components'/.test(formSrc) && /SearchArea/.test(formSrc), 'Form: SearchArea(@shared/components)', '룰 25 §1.5.4 표준 5종 import');
    dod('B15', /FormItem/.test(formSrc) && /from '@shared\/lges'/.test(formSrc), 'Form: FormItem(@shared/lges) 라벨 규약', '직접 <label> 금지');
    dod('B16', !/label=['"][A-Za-z가-힣 .]+['"]/.test(formSrc.replace(/t\('[^']*',\s*'[^']*'\)/g, '')), 'Form: 라벨 리터럴 직접 입력 없음(t(\'LBL…\'))', '룰 13 i18n — 라벨은 LBL 코드');
    dod('B17', !/useTabProcQuery/.test(formSrc) || /useTabComboQueries/.test(formSrc), 'Form: 콤보는 useTabComboQueries(개별 lookup SP 호출 금지)', '룰 25 §1.5.4');
  }
  // 그리드: DataGrid 래퍼
  if (gridSrc) dod('B18', /<DataGrid/.test(gridSrc) || /DataGrid/.test(gridSrc), 'Grid: DataGrid 래퍼 사용', 'Wijmo FlexGrid 직접 배치 금지(룰 12)');
  // 검증/표현식 훅 — As-is 분석 행이 있으면 훅 존재(V01 과 중복 아님: 파일 존재)
  if (ID && cfg.analysisRoot) { const AN = require('./lib/analysis'); const V = AN.load(cfg.analysisRoot, ID, 'V'), E = AN.load(cfg.analysisRoot, ID, 'E'); if (V.length) dod('B19', files.some(f => /hooks\/use.*Validation\.ts$/.test(rel(f))), `validation.md ${V.length}행 → hooks/use{Page}Validation.ts`, '룰 09 100% 적용'); if (E.length) dod('B19', files.some(f => /hooks\/use.*Expression\.ts$/.test(rel(f))), `expressions.md ${E.length}행 → hooks/use{Page}Expression.ts`, '룰 09 100% 적용'); }
  dod('B20', files.some(f => /__tests__\/.*\.spec\.tsx?$/.test(rel(f))), '__tests__/*.spec.ts 단위 테스트', '룰 17 9-Step ⑨', 'WARN');
  // DB/메타 조각(Doc/gen) — 화면 하나의 나머지 조각
  if (ID) { const g = path.join(cfg.genOutDir, ID); for (const [fn, what] of [['register.json', '등록 3-키 초안'], ['e2e_plan.json', 'E2E 플랜'], [`${ID}_registration.sql`, 'Oracle 메타 등록 SQL(gen-register-sql.js)'], [`${ID}_PKG.sql`, 'Oracle PKG 골격(gen-pkg.js)']]) dod('B21', fs.existsSync(path.join(g, fn)), `Doc/gen/${ID}/${fn} — ${what}`, '화면=FE+메타+PKG 한 세트(룰 17 9-Step ①②)', 'WARN'); }
  // B22~B25 — 2026-10-19 SCP0096 보강: 정적 게이트 PASS 인데 조회 0건·저장 미배선·초기기간 공란이던 구멍
  //   원천: Doc/tobefacts/db/proc_meta.csv(사내 현행 API 배선) · proc_params.csv(PROC_M COL_NM) · cfg.asisSrcRoot 의 .cs 원문
  const tobeDb = cfg.tobeOutDir ? path.join(cfg.tobeOutDir, 'db') : null;
  if (ID && tobeDb && fs.existsSync(path.join(tobeDb, 'proc_meta.csv')) && fs.existsSync(path.join(tobeDb, 'proc_params.csv'))) {
    const meta = readCsv(path.join(tobeDb, 'proc_meta.csv')).filter(r => r.menu_id === ID && r.use_yn !== 'N' && r.proc);
    const params = readCsv(path.join(tobeDb, 'proc_params.csv'));
    const sheetVals = (() => { const m = constSrc.match(/SHEETS\s*(=|\{)[\s\S]*?\}/); return m ? [...m[0].matchAll(/'([^']+)'/g)].map(x => x[1]) : []; })();
    const searchRows = meta.filter(r => r.btn === 'SEARCH' && (sheetVals.length === 0 || sheetVals.includes(r.sheet)));
    // B22: 조회 filter 키 = 사내 PROC_M IN COL_NM (BE 는 COL_NM 으로 positional 매핑 — 키가 다르면 NULL 전달 → 조회 0건·오류 없음)
    const tf = storeSrc.match(/const toFilter\s*=[\s\S]*?=>\s*\(\{([\s\S]*?)\}\)/);
    const filterKeys = tf ? [...tf[1].matchAll(/^\s*(\w+)\s*:/gm)].map(m => m[1]) : null;
    if (!searchRows.length) dod('B22', false, `사내 메타(proc_meta.csv) 에 ${ID} SEARCH 배선 없음`, 'registration.sql 적용 전이면 정상 — 적용 후 export_tobe_meta 재실행으로 재판정', 'WARN');
    for (const r of searchRows) {
      const ins = params.filter(p => p.proc === r.proc && p.col_tp_cd === 'IN').map(p => p.col_nm); if (!ins.length) continue;
      const have = filterKeys || ins.filter(k => new RegExp(`\\b${k}\\s*:`).test(storeSrc + pageSrc));
      const missing = ins.filter(k => !have.includes(k)); const pn = r.proc.split('.').pop();
      dod('B22', !missing.length, `조회 filter 키 = 사내 PROC_M COL_NM (${pn} · 시트 '${r.sheet}')`, missing.length ? `누락 ${missing.join(', ')} — 현재 키: ${(filterKeys || have).join(', ') || '(toFilter 없음)'} · BE positional 매핑이라 값이 NULL 로 감` : `IN ${ins.length}개 일치`);
      if (filterKeys) { const extra = filterKeys.filter(k => !ins.includes(k)); if (extra.length) F('WARN', 'B22', `filter 키 ${extra.join(', ')} 는 ${pn} 의 IN 파라미터가 아님(서버가 무시)`, 'store'); }
    }
    // B23: registration.sql 의 API 배선이 사내 현행과 다르면(또는 프로시저명 공란) 적용 금지
    const regSql = path.join(cfg.genOutDir, ID, `${ID}_registration.sql`);
    if (fs.existsSync(regSql) && meta.length) {
      const txt = read(regSql); const norm = s => s.replace(/[^A-Z0-9_]/gi, '_').toUpperCase(); const bad = [];
      // API_TP_CD 는 하네스 'PROC' 외에 사내 현행 'PROC_SELECT'/'PROC_SAVE' 도 대조. API_ID 는 하네스 규칙명 또는 사내 현행 api_id 로 매칭(2026-10-20 SCP0096 미러 등록 SQL)
      for (const m of txt.matchAll(/VALUES\s*\('([A-Z0-9_]+)',\s*'PROC[A-Z_]*',\s*NULL,\s*'[^']*',\s*'([^']*)'/g)) {
        const apiId = m[1], proc = m[2]; const row = meta.find(r => norm(`${ID}_${r.sheet}_${r.btn}`) === apiId || r.api_id === apiId);
        if (/\.P_$/.test(proc)) bad.push(`${apiId} → '${proc}'(프로시저명 공란)`); else if (row && row.proc !== proc) bad.push(`${apiId}: 등록 SQL ${proc} ≠ 사내 현행 ${row.proc}`);
      }
      dod('B23', !bad.length, 'registration.sql API 배선 = 사내 현행(proc_meta.csv)', bad.length ? bad.join(' · ') + ' — 그대로 적용하면 운용 중 배선이 바뀜(적용 금지 · register.json 정리)' : `${meta.length}행 대조 일치`);
    }
  }
  // B24: As-is Form_Load/InitControls 초기 조회조건(InitValue · DateUtil.GetDayRange → SCM0001_GET_SCP_MONTH_PERIOD 등) — 프레임워크 유틸 호출이라 flow.csv 에 없다 → .cs 원문 대조
  if (sdir && cfg.asisSrcRoot && fs.existsSync(path.join(sdir, 'files.csv'))) {
    const csFiles = readCsv(path.join(sdir, 'files.csv')).filter(r => r.variant === 'current' && /\.cs$/i.test(r.file) && !/Designer\.cs$/i.test(r.file)).map(r => path.join(cfg.asisSrcRoot, r.file)).filter(f => fs.existsSync(f));
    if (csFiles.length) {
      const cs = csFiles.map(f => stripComments(read(f))).join('\n');
      const hits = [...cs.matchAll(/\b(\w+)\.InitValue\s*=\s*([^;]+);|\b(\w+)\.(Text1|Text2|Text|Value)\s*=\s*((DateUtil|DateTime)\.[^;]+);/g)].map(m => m[0].trim().replace(/\s+/g, ' '));
      const dateInit = hits.filter(h => /InitValue\s*=\s*\w*(DayRange|Date|Period|Month|Week)|DateUtil\.|DateTime\./i.test(h));
      const initBlock = (storeSrc.match(/const init\w*Param[^=]*=\s*\{([\s\S]*?)\n\};/) || [, ''])[1];
      const periodEmpty = /\b\w+(From|To)\s*:\s*''/.test(initBlock);
      if (dateInit.length) dod('B24', !periodEmpty, 'As-is Form_Load 초기 조회기간(InitValue/GetDayRange) → store 초기값', `As-is: ${dateInit.slice(0, 3).join(' / ')} — 프레임워크 유틸 호출은 flow.csv 에 없으므로 .cs 를 직접 읽어 채운다(DateUtil.GetDayRange = SCM0001_GET_SCP_MONTH_PERIOD, Doc/tobefacts/db/proc_meta.csv 의 dayRange 배선 참조)`);
      const otherInit = hits.filter(h => !dateInit.includes(h)); if (otherInit.length) F('WARN', 'B24', `As-is 초기값 ${otherInit.length}건(${otherInit.slice(0, 2).join(' / ')}) — store 초기값 반영 여부 사람 확인`, 'store');
    }
  }
  // B25: hotkeyConfig 공통버튼 핸들러 본문이 비어 있음(TODO 스텁) — "false 가 아니면 통과" 이던 B08 의 구멍(SCP0096 handleSave)
  if (hk) for (const k of ['save', 'insert', 'delete', 'upload']) {
    const m = hkBody.match(new RegExp(`\\b${k}:\\s*(?:\\(\\)\\s*=>\\s*(?:void\\s+)?)?(\\w+)`)); if (!m || m[1] === 'false') continue;
    const fn = m[1]; const def = pageSrc.search(new RegExp(`const ${fn}\\s*=`)); if (def < 0) continue;
    const arrow = pageSrc.indexOf('=>', def); if (arrow < 0 || arrow - def > 300) continue; const open = pageSrc.indexOf('{', arrow); if (open < 0 || open - arrow > 5) continue;
    let depth = 0, i = open; for (; i < pageSrc.length; i++) { const ch = pageSrc[i]; if (ch === '{') depth++; else if (ch === '}') { depth--; if (!depth) break; } }
    const body = stripComments(pageSrc.slice(open + 1, i)).trim();
    dod('B25', body.length > 0, `hotkeyConfig.${k} 핸들러 ${fn} 본문 있음`, body.length ? `${body.split('\n').length}줄` : `${fn} 본문이 비어 있음(TODO 스텁) — As-is 기능 미배선인데 B08 을 통과하던 구멍`);
  }
  // B26·B27 — 2026-10-20 SCP0096 보강: 조회 시 동적 기간 컬럼 0 인데 정적 게이트·DoD 28/28·GAP COVERED 로 통과하던 구멍
  //   B26: RESPONSE_SET 값(응답 키) ⊂ 사내 PROC_M OUT COL_NM ∪ {DATARESULT} — BE BaseService 는 이 키만 만든다(대소문자 그대로).
  //        o_rc1_columns 같은 ResultSetMetaData 사이드카는 SYS0013 DynamicQuery 전용 → 일반 화면에서 읽으면 항상 undefined.
  //   B27: As-is 기간형 타이틀 SP(GetSpdTitle → *_GET_SHEET_CALENDAR_3SPAN / *_GET_SPREAD_TITLE …)가 있고 사내 배선이 있으면 FE 가 그 시트를 조회해야 한다.
  //        메타형(SCM_MST_SHEET_COLUMNS 만 읽는 공통 타이틀)은 admin 컬럼 메타로 대체 = 판정 제외. 대조표 '제외/해당없음'+사유면 사람 결정으로 통과.
  {
    const DY = require('./lib/dyncol');
    const tobeDb2 = cfg.tobeOutDir ? path.join(cfg.tobeOutDir, 'db') : null;
    const pmF = tobeDb2 && path.join(tobeDb2, 'proc_meta.csv'), ppF = tobeDb2 && path.join(tobeDb2, 'proc_params.csv');
    if (ID && pmF && fs.existsSync(pmF) && fs.existsSync(ppF)) {
      const pm = readCsv(pmF), pp = readCsv(ppF);
      const menuMeta = pm.filter(r => r.menu_id === ID && r.use_yn !== 'N' && r.proc);
      const regF = path.join(cfg.genOutDir, ID, 'register.json'); let regProcs = [];
      try { if (fs.existsSync(regF)) regProcs = (JSON.parse(read(regF)).procs || []).map(p => p.tobe_proc).filter(Boolean); } catch { }
      const procs = [...new Set(menuMeta.map(r => r.proc).concat(regProcs))];
      // B26
      const rs = DY.responseSetValues(constSrc);
      if (rs.length && procs.length) {
        const own = DY.outKeys(procs, pp); const glob = DY.outKeys([...new Set(pp.map(p => p.proc))], pp);
        const bad = [];
        for (const { key, value } of rs) {
          if (own.has(value)) continue;
          const ci = [...own].find(o => o.toLowerCase() === value.toLowerCase());
          if (ci) bad.push(`${key}='${value}' → 대소문자 불일치(사내 OUT '${ci}' — BE 는 COL_NM 그대로 키로 씀)`);
          else if (glob.has(value)) F('WARN', 'B26', `RESPONSE_SET.${key}='${value}' 는 ${ID} 배선 프로시저의 OUT 이 아님(타 메뉴 프로시저 OUT 에는 있음 — 타 menuId 로 호출하는지 확인)`, 'constants');
          else bad.push(`${key}='${value}' → 사내 PROC_M OUT 어디에도 없음${/_columns$/i.test(value) ? '(ResultSetMetaData 사이드카 = SYS0013 DynamicQuery 전용, 일반 call-proc 응답에 없음)' : ''}`);
        }
        dod('B26', !bad.length, 'RESPONSE_SET 응답 키 = 사내 PROC_M OUT COL_NM(proc_params.csv)', bad.length ? bad.join(' · ') + ' — 이 키로 읽는 값은 항상 undefined(빈 그리드·빈 팝업으로 보이고 오류는 안 남)' + (bad.some(b => /_columns'/.test(b)) ? '. 동적 헤더 원천은 사내 배선 타이틀 SP 시트(B27) 또는 Object.keys(rows[0])(mybatis callSettersOnNulls=true)' : '') : `${rs.length}키 일치`);
      } else if (rs.length) F('WARN', 'B26', `사내 메타(proc_meta.csv)·register.json 에 ${ID} 프로시저 없음 — 응답 키 대조 불가`, 'constants');
      // B27
      if (sdir && fs.existsSync(path.join(sdir, 'endpoints.csv'))) {
        const titles = DY.asisTitleEndpoints(readCsv(path.join(sdir, 'endpoints.csv'))); const loops = DY.asisDbLoop(sdir);
        const exactSheets = new Set(titles.flatMap(t => { const c = DY.corpTitleSheets(t.sp, menuMeta); return c.via === 'exact' ? c.sheets : []; }));
        for (const t of titles.filter(t => t.kind === 'period')) {
          const c = DY.corpTitleSheets(t.sp, menuMeta, exactSheets);
          // 정확 배선이면 그 시트만 인정. 정확 배선이 없으면 같은 화면 타이틀 계열 시트 조회도 인정(As-is 변형 SP — 예: 3SPAN_ISO ↔ 3SPAN 시트)
          const used = [...new Set((c.via === 'exact' ? c.pairs : DY.corpAllTitlePairs(menuMeta)).filter(p => DY.consumesPair(src, p)).map(p => p.sheet + (p.btn !== 'SEARCH' ? '/' + p.btn : '')))];
          const mr = mapRows.find(r => r.summary.includes(t.sp)); const decided = mr && /^(제외|해당없음)/.test(mr.status) && mr.reason;
          const evid = `As-is ${t.members.join('/')} → ${t.sp} [${t.signals.join('+')}${loops.length ? ' + grid_code DB루프 ' + loops.slice(0, 2).join(',') : ''}]`;
          if (used.length || decided) { dod('B27', true, `동적 헤더 원천 ${t.sp} → FE 조회`, used.length ? `시트 '${used.join("','")}' 조회` : `대조표 ${mr.id} ${mr.status}: ${mr.reason}`); continue; }
          if (c.via === 'exact') dod('B27', false, `동적 헤더 원천 ${t.sp} → FE 조회`, `${evid} · 사내 배선 시트 '${c.sheets.join("','")}'(${c.procs.join(',')})를 FE 가 조회하지 않음 → 기간 컬럼이 그려지지 않음. SHEETS 에 시트 추가 + useTabProcQuery 로 조회기간을 넘겨 o_rc1(COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE)로 헤더 생성(As-is InitSpreadDateColumn 1:1)`);
          else F('WARN', 'B27', `${evid} · 사내 정확 배선 없음${c.via === 'family' ? `(같은 화면 타이틀 계열 '${c.sheets.join("','")}' 추정)` : ''} — 동적 컬럼 원천을 확인: 배선 등록(DB 메타) 후 FE 조회 또는 대조표에 대체 근거(BE/메타 원문 확인)를 적고 '제외'`, 'grid');
        }
        if (!titles.length && loops.length) F('WARN', 'B27', `As-is grid_code DB루프(${loops.slice(0, 3).join(', ')}) — 루프 원천 결과셋이 타이틀 SP 판정에 안 걸림. 동적 컬럼 원천 확인`, 'grid');
        // M08: As-is DB루프 컬럼 생성(grid_code DB_DRIVEN · Add*Column) → 대조표 행 필수. 대조표 생성기가 grid_effective(정적 컬럼)만 써서
        //      동적 컬럼 생성 행이 한 번도 안 생겼던 구멍(2026-10-20 전수: 대조표 100페이지 중 31화면 73행 누락). 문서 누락이라 WARN — 미구현 자체는 B27/M09 가 차단.
        const missLoop = loops.filter(loc => { const [mem, line] = loc.split(':'); return !mapRows.some(x => new RegExp(`${mem}\\s*[/:]\\s*${line}\\b`).test(x.summary)); });
        if (mapFile && missLoop.length) F('WARN', 'M08', `대조표에 As-is DB루프 컬럼 생성 행 없음: ${missLoop.join(', ')} — '## §6 동적 컬럼' 에 행 추가(요지 '${missLoop[0].replace(':', ' / ')} (DB루프 컬럼 생성 ← 타이틀 SP)', 구현 위치 = 동적 컬럼 생성 코드 + 타이틀 시트 조회 위치)`, '__asis-mapping__.md');
        // M09: 대조표 엔드포인트 행이 '구현' 인데 사내 정확 배선 시트를 FE 가 조회하지 않음 = 구현 근거 불일치(SCP0096 D00-4-005 '데이터 alias 로 흡수' 사고).
        //      2026-10-20 전수 1건(SCP0096) — 오탐 없음 → final BLOCK
        const epSps = [...new Set(readCsv(path.join(sdir, 'endpoints.csv')).filter(e => e.variant !== 'legacy').map(e => (e.sp_or_sql || '').replace(/^SP\s+/, '').trim()).filter(Boolean))];
        for (const sp of epSps) {
          const row = mapRows.find(x => x.summary.includes(sp)); if (!row || !/^구현/.test(row.status)) continue;
          const ex = menuMeta.filter(x => (x.proc_nm || '').toUpperCase().endsWith(sp.toUpperCase())); if (!ex.length) continue;
          const sheets = [...new Set(ex.map(x => x.sheet))]; if (ex.some(x => DY.consumesPair(src, { sheet: x.sheet, btn: x.btn || 'SEARCH' }))) continue;
          F(FINAL ? 'BLOCK' : 'WARN', 'M09', `구현 근거 불일치: ${row.id} '${sp}' 가 '구현' 인데 사내 배선 시트 '${sheets.join("','")}'(${[...new Set(ex.map(x => x.btn))].join('/')})를 FE 가 조회하지 않음 — 구현 위치/사유의 대체 설명을 BE·메타 원문으로 검증하고, 아니면 배선 시트를 조회하도록 구현`, '__asis-mapping__.md');
        }
      }
    }
  }
  // DoD 리포트
  try { const rep = path.join(cfg.genOutDir, ID || path.basename(pageDir)); fs.mkdirSync(rep, { recursive: true }); fs.writeFileSync(path.join(rep, 'DOD.md'), `# 완료 정의(DoD) — ${ID || path.basename(pageDir)} ${new Date().toISOString().slice(0, 16).replace('T', ' ')}\n\n${DOD.filter(d => d.ok).length}/${DOD.length} 충족\n\n| 코드 | 상태 | 항목 | 근거 |\n|---|---|---|---|\n` + DOD.map(d => `| ${d.code} | ${d.ok ? '✅' : '❌'} | ${d.what} | ${d.how} |`).join('\n') + '\n', 'utf8'); } catch { }
}

// ── 컴파일/린트 게이트(--tsc / --lint, --final 이면 둘 다): 저장소 node_modules 의 tsc·eslint 를 직접 실행(pnpm 미사용·오프라인)
//   T01 타입 오류(해당 페이지 파일) = BLOCK · L01 eslint error = BLOCK · L02 eslint warning = WARN
if (a.includes('--tsc') || a.includes('--lint') || FINAL) {
  const { spawnSync } = require('child_process');
  const fe = cfg.feRoot; const featMatch = /[\\/]features[\\/]([^\\/]+)[\\/]/.exec(pageDir + path.sep); const feat = featMatch ? featMatch[1] : null;
  const pageAbs = path.resolve(pageDir).toLowerCase();
  if ((a.includes('--tsc') || FINAL) && feat && fs.existsSync(path.join(fe, 'node_modules', 'typescript', 'bin', 'tsc'))) {
    // 2026-10-21 보강(SCP0100 사고): ① 기본 = 페이지 범위 프로그램(임시 tsconfig: 페이지 폴더 + d.ts, incremental/declaration 끔) — feature 전체(62페이지)는
    //   다른 페이지의 타입 폭발(getCrossProductIntersections → RangeError: Map maximum size exceeded, 12GB 힙도 초과)에 끌려 게이트가 죽는다.
    //   페이지 범위는 SCP0100 실측 655MB·52s. `--tsc-feature` 를 주면 종전처럼 feature tsconfig 전체.
    //   ② 힙 명시(harness.json tscHeapMb, 기본 4096) ③ **비정상 종료(status≠0 인데 'error TS' 0건 — OOM/RangeError/시그널) = BLOCK T00** —
    //   종전엔 WARN T02('다른 파일 오류') 로 흘려 BLOCK 0 으로 통과했다(CHECK.md "exit 134").
    const featDir = path.join(fe, 'features', feat); const featCfg = path.join(featDir, 'tsconfig.json');
    const heapMb = Number(cfg.tscHeapMb || 4096); const wholeFeature = a.includes('--tsc-feature');
    let tscfg = featCfg, scopeNote = 'feature 전체';
    if (!wholeFeature) {
      const fwd = p => p.replace(/\\/g, '/');
      const tmpDir = path.join(require('os').tmpdir(), 'nscm-harness-tsc', `${feat}-${path.basename(pageDir)}`); fs.mkdirSync(tmpDir, { recursive: true });
      const tmpCfg = { extends: fwd(featCfg), compilerOptions: { noEmit: true, baseUrl: fwd(fe) + '/', incremental: false, declaration: false, declarationMap: false, sourceMap: false },
        include: [fwd(path.resolve(pageDir)) + '/**/*', fwd(path.join(fe, 'configs', 'types')) + '/*.d.ts', fwd(path.join(featDir, 'src')) + '/*.d.ts'], exclude: [] };
      tscfg = path.join(tmpDir, 'tsconfig.json'); fs.writeFileSync(tscfg, JSON.stringify(tmpCfg, null, 1), 'utf8'); scopeNote = '페이지 범위';
    }
    const r = spawnSync(process.execPath, [`--max-old-space-size=${heapMb}`, path.join(fe, 'node_modules', 'typescript', 'bin', 'tsc'), '--noEmit', '--pretty', 'false', '-p', tscfg], { cwd: featDir, encoding: 'utf8', maxBuffer: 64 * 1024 * 1024, timeout: 900000 });
    const out = (r.stdout || '') + (r.stderr || '');
    if (r.error) F('BLOCK', 'T00', `tsc 실행 실패(${scopeNote}): ${r.error.message}`);
    else {
      let n = 0, total = 0;
      for (const line of out.split(/\r?\n/)) { const m = /^(.+?)\((\d+),(\d+)\): error (TS\d+): (.*)$/.exec(line); if (!m) continue; total++; const abs = path.resolve(featDir, m[1]).toLowerCase(); if (abs.startsWith(pageAbs)) { n++; if (n <= 30) F('BLOCK', 'T01', `${m[4]} ${m[5]}`, `${path.relative(pageDir, path.resolve(featDir, m[1]))}:${m[2]}`); } }
      if (n > 30) F('BLOCK', 'T01', `타입 오류 ${n}건 (30건만 표시)`);
      if (!total && r.status !== 0) {
        const sig = out.split(/\r?\n/).find(l => /RangeError|FATAL ERROR|heap out of memory|Maximum call stack/i.test(l)) || (out.trim().split(/\r?\n/).pop() || '');
        const why = /Map maximum size exceeded|getCrossProductIntersections/.test(out) ? '타입 교차곱 폭발(getCrossProductIntersections) — 특정 파일의 유니온×교차 타입이 원인, 힙을 늘려도 해결되지 않음. 페이지별 tsc 로 이분 탐색' : /heap out of memory/i.test(out) ? `메모리 부족(힙 ${heapMb}MB) — harness.json tscHeapMb 상향 또는 타입 폭발 의심` : '원인 미상';
        F('BLOCK', 'T00', `tsc 비정상 종료(${scopeNote}, exit ${r.status}${r.signal ? ' ' + r.signal : ''}) — 검사가 수행되지 않았으므로 통과로 볼 수 없음. ${why}`, sig.slice(0, 200));
      }
      else if (!n && total) F('WARN', 'T02', `tsc 가 페이지 밖 파일에서 오류 ${total}건 (${scopeNote}) — 이 페이지가 import 하는 공용/자매 파일 확인`);
    }
  }
  if ((a.includes('--lint') || FINAL) && fs.existsSync(path.join(fe, 'node_modules', 'eslint', 'bin', 'eslint.js'))) {
    const r = spawnSync(process.execPath, [path.join(fe, 'node_modules', 'eslint', 'bin', 'eslint.js'), '--format', 'json', '--no-color', path.resolve(pageDir)], { cwd: feat ? path.join(fe, 'features', feat) : fe, encoding: 'utf8', maxBuffer: 64 * 1024 * 1024, timeout: 600000 });
    try { const res = JSON.parse(r.stdout || '[]'); for (const f of res) for (const m of f.messages) F(m.severity === 2 ? 'BLOCK' : 'WARN', m.severity === 2 ? 'L01' : 'L02', `${m.ruleId || 'eslint'}: ${m.message}`, `${path.relative(pageDir, f.filePath)}:${m.line}`); }
    catch { if (r.error || r.status) F('WARN', 'L00', `eslint 실행 실패: ${(r.error && r.error.message) || (r.stderr || '').split('\n')[0]}`); }
  }
}

// 결과
const block = findings.filter(f => f.level === 'BLOCK'), warn = findings.filter(f => f.level === 'WARN');
const title = `[Harness] ${ID || '?'} ${path.basename(pageDir)} — BLOCK ${block.length} / WARN ${warn.length}${FINAL ? ' (final)' : ''}`;
const lines = [title, ...block.map(f => `  ✗ ${f.code} ${f.msg}${f.where ? '  @' + f.where : ''}`), ...warn.slice(0, 40).map(f => `  ! ${f.code} ${f.msg}${f.where ? '  @' + f.where : ''}`), warn.length > 40 ? `  … 경고 ${warn.length - 40}건 더 (CHECK.md)` : ''].filter(Boolean);
try { const rep = path.join(cfg.genOutDir, ID || path.basename(pageDir)); fs.mkdirSync(rep, { recursive: true }); fs.writeFileSync(path.join(rep, 'CHECK.md'), `# ${title}\n\n` + findings.map(f => `- ${f.level} ${f.code} ${f.msg}${f.where ? ' @' + f.where : ''}`).join('\n') + '\n', 'utf8'); } catch (_) { }
// 결과 봉투 Doc/gen/<ID>/CHECK.result.json (vibe-result/1, 2026-10-26) — CHECK.md 의 기계 판독본. BLOCK 0 = pass(--final 이 아니면 최종 판정 아님을 final 로 표시)
try {
  const rep = path.join(cfg.genOutDir, ID || path.basename(pageDir)); const kindOf = c => /^T0/.test(c) ? 'build' : /^L0/.test(c) ? 'lint' : 'exec';
  require('./lib/envelope').write(path.join(rep, 'CHECK.result.json'), { producer: 'check.js', id: ID || null, final: FINAL, page: path.relative(path.resolve(__dirname, '..', '..'), pageDir).split(path.sep).join('/'),
    state: 'completed', verdict: block.length ? 'fail' : 'pass', summary: { block: block.length, warn: warn.length },
    issues: block.map(f => ({ id: f.code, class: 'BLOCK', msg: f.msg, where: f.where, evidence: [{ kind: kindOf(f.code), ref: `check.js ${f.code}` }] })),
    evidence: [{ kind: 'exec', ref: `check.js${FINAL ? ' --final' : ''}` }] });
} catch (e) { console.error(`[WARN] CHECK.result.json 기록 실패: ${e.message}`); }
if (a.includes('--json')) console.log(JSON.stringify({ id: ID, pageDir, block: block.length, warn: warn.length, findings }));
else (block.length ? console.error : console.log)(lines.join('\n'));
process.exit(block.length ? 2 : warn.length ? 1 : 0);
