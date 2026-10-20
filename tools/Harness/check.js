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
if (hasAsis && !files.some(f => rel(f) === '__asis-mapping__.md')) F('BLOCK', 'S01', '표준 파일 없음: __asis-mapping__.md (As-is Fact Pack 이 있는 화면은 대사표 필수)');
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
// 3b) 커밋본 대비 후퇴 감지 — 2026-10-19 SCP0096 사고(파이프라인이 손으로 완성한 커밋본을 골격으로 교체: 대사표 91→20행, dynamic-columns/types 삭제)
//     git 이 추적하는 페이지면 ①커밋본 파일 삭제(M07) ②대사표 행·구현 수 축소(M06) 를 BLOCK — "빈 칸 0" 만 보던 M01~M05 의 구멍
{
  const cp = require('child_process'); const GT = require('./lib/applied').gitTracked(pageDir); // 감싸는 저장소 전부 확인(nscm-fe 중첩 .git 대응)
  const git = args => { try { const r = cp.spawnSync('git', ['-C', GT.root, ...args], { encoding: 'utf8' }); return r.status === 0 ? r.stdout : null; } catch { return null; } };
  const strip = f => { f = f.replace(/\\/g, '/'); const pre = GT && GT.rel !== '.' ? GT.rel + '/' : ''; return f.startsWith(pre) ? f.slice(pre.length) : f; };
  if (GT) {
    for (const d of (git(['ls-files', '--deleted', '--', GT.rel]) || '').split(/\r?\n/).filter(Boolean).map(strip)) F(FINAL ? 'BLOCK' : 'WARN', 'M07', `커밋본에 있던 파일이 삭제됨: ${d} — 골격 재생성으로 기능 유실 의심(git checkout -- 로 복원 후 병합, 저장소 ${GT.root})`, d);
    if (mapFile && GT.files.some(f => strip(f) === '__asis-mapping__.md')) {
      const headTxt = git(['show', `HEAD:${GT.rel === '.' ? '' : GT.rel + '/'}__asis-mapping__.md`]);
      if (headTxt != null) {
        const cnt = txt => { let n = 0, impl = 0; for (const line of txt.split(/\r?\n/)) { const m = line.match(/^\|\s*([A-Z]\d{2}-[\dP]+-\d{3})\s*\|(.*)\|\s*$/); if (!m) continue; n++; if (/^구현/.test((m[2].split('|').pop() || '').trim())) impl++; } return { n, impl }; };
        const h = cnt(headTxt), c = cnt(read(mapFile));
        if (c.n < h.n || c.impl < h.impl) F(FINAL ? 'BLOCK' : 'WARN', 'M06', `대사표 후퇴: 행 ${h.n}→${c.n} · 구현 ${h.impl}→${c.impl} (커밋본 대비) — 기존 대사표를 재생성하지 말고 커밋본 위에 행을 추가`, '__asis-mapping__.md');
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
    const over = n => mem.some(r => r.member === n);
    const pairs = [['InsertButton', 'insert'], ['DeleteButton', 'delete'], ['SaveButton', 'save'], ['UploadButton', 'upload'], ['ImportButton', 'upload']];
    for (const [asis, key] of pairs) if (over(asis) && hk) dod('B08', !new RegExp(`\\b${key}:\\s*false`).test(hkBody), `As-is ${asis} override 있음 → hotkeyConfig.${key} 가 false 가 아니어야 함`, `As-is 기능 누락(members.csv ${asis})`);
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
  //        메타형(SCM_MST_SHEET_COLUMNS 만 읽는 공통 타이틀)은 admin 컬럼 메타로 대체 = 판정 제외. 대사표 '제외/해당없음'+사유면 사람 결정으로 통과.
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
          if (used.length || decided) { dod('B27', true, `동적 헤더 원천 ${t.sp} → FE 조회`, used.length ? `시트 '${used.join("','")}' 조회` : `대사표 ${mr.id} ${mr.status}: ${mr.reason}`); continue; }
          if (c.via === 'exact') dod('B27', false, `동적 헤더 원천 ${t.sp} → FE 조회`, `${evid} · 사내 배선 시트 '${c.sheets.join("','")}'(${c.procs.join(',')})를 FE 가 조회하지 않음 → 기간 컬럼이 그려지지 않음. SHEETS 에 시트 추가 + useTabProcQuery 로 조회기간을 넘겨 o_rc1(COLUMN_NAME·COLUMN_LABEL_NAME·SMALL/LARGE_CLASS_LABEL_NAME·DAY_CODE)로 헤더 생성(As-is InitSpreadDateColumn 1:1)`);
          else F('WARN', 'B27', `${evid} · 사내 정확 배선 없음${c.via === 'family' ? `(같은 화면 타이틀 계열 '${c.sheets.join("','")}' 추정)` : ''} — 동적 컬럼 원천을 확인: 배선 등록(DB 메타) 후 FE 조회 또는 대사표에 대체 근거(BE/메타 원문 확인)를 적고 '제외'`, 'grid');
        }
        if (!titles.length && loops.length) F('WARN', 'B27', `As-is grid_code DB루프(${loops.slice(0, 3).join(', ')}) — 루프 원천 결과셋이 타이틀 SP 판정에 안 걸림. 동적 컬럼 원천 확인`, 'grid');
        // M08: As-is DB루프 컬럼 생성(grid_code DB_DRIVEN · Add*Column) → 대사표 행 필수. 대사표 생성기가 grid_effective(정적 컬럼)만 써서
        //      동적 컬럼 생성 행이 한 번도 안 생겼던 구멍(2026-10-20 전수: 대사표 100페이지 중 31화면 73행 누락). 문서 누락이라 WARN — 미구현 자체는 B27/M09 가 차단.
        const missLoop = loops.filter(loc => { const [mem, line] = loc.split(':'); return !mapRows.some(x => new RegExp(`${mem}\\s*[/:]\\s*${line}\\b`).test(x.summary)); });
        if (mapFile && missLoop.length) F('WARN', 'M08', `대사표에 As-is DB루프 컬럼 생성 행 없음: ${missLoop.join(', ')} — '## §6 동적 컬럼' 에 행 추가(요지 '${missLoop[0].replace(':', ' / ')} (DB루프 컬럼 생성 ← 타이틀 SP)', 구현 위치 = 동적 컬럼 생성 코드 + 타이틀 시트 조회 위치)`, '__asis-mapping__.md');
        // M09: 대사표 엔드포인트 행이 '구현' 인데 사내 정확 배선 시트를 FE 가 조회하지 않음 = 구현 근거 불일치(SCP0096 D00-4-005 '데이터 alias 로 흡수' 사고).
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
    const tscfg = path.join(fe, 'features', feat, 'tsconfig.json');
    const r = spawnSync(process.execPath, [path.join(fe, 'node_modules', 'typescript', 'bin', 'tsc'), '--noEmit', '--pretty', 'false', '-p', tscfg], { cwd: path.join(fe, 'features', feat), encoding: 'utf8', maxBuffer: 64 * 1024 * 1024, timeout: 600000 });
    const out = (r.stdout || '') + (r.stderr || '');
    if (r.error) F('WARN', 'T00', `tsc 실행 실패: ${r.error.message}`);
    else { let n = 0; for (const line of out.split(/\r?\n/)) { const m = /^(.+?)\((\d+),(\d+)\): error (TS\d+): (.*)$/.exec(line); if (!m) continue; const abs = path.resolve(path.join(fe, 'features', feat), m[1]).toLowerCase(); if (abs.startsWith(pageAbs)) { n++; if (n <= 30) F('BLOCK', 'T01', `${m[4]} ${m[5]}`, `${path.relative(pageDir, path.resolve(path.join(fe, 'features', feat), m[1]))}:${m[2]}`); } } if (n > 30) F('BLOCK', 'T01', `타입 오류 ${n}건 (30건만 표시)`); if (!n && r.status !== 0) F('WARN', 'T02', `tsc 가 다른 파일에서 오류를 보고(페이지 범위 밖) — exit ${r.status}`); }
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
if (a.includes('--json')) console.log(JSON.stringify({ id: ID, pageDir, block: block.length, warn: warn.length, findings }));
else (block.length ? console.error : console.log)(lines.join('\n'));
process.exit(block.length ? 2 : warn.length ? 1 : 0);
