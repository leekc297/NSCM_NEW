'use strict';
// Vibe_Manager 1.3.1 — FLOW 진척 패널: 화면별 단계(파싱→문서→GAP→생성→게이트→수선→PKG→등록→E2E) 상태를 산출물로 판정해 표 + 진행률로 보여준다.
//   판정은 전부 파일 기반(기록 신뢰 X): Fact Pack / agent _gate.csv / Doc/documents xlsx / Doc/gap csv / Doc/gen(GEN_NOTES·CHECK·DOD·REPAIR·CHECK_PKG·_registration·_revert·PIPELINE) / 페이지 폴더 / Doc/e2e/results/_summary.csv
// 2.0.2(2026-11-11 사용자 지시): FLOW 표 다시 구성 — 문서+Excel → '문서' 1칸 · Smoke/CRUD/Auth/Auth×CRUD → 'Test' 1칸 · '수선' → '보완' ·
//   머리글 고정(요약 영역 + 표 머리글) · Doc/gen 버튼 삭제 · '★ 끝까지' → 'Batch Run' · 단일 색상 점·선 아이콘 디자인 ·
//   머리글 영문 · 파이프라인 열 삭제 · 열 = 현재 일괄 작업 체인이 순서대로 실행하는 단계만(8열 · Test·Cloud 는 체인 밖 별도 액션이라 제외).
//   판정(stageStatus)과 STAGES(내보내기 — UI Status·CSV 가 사용)는 13단계 그대로. 합친 칸은 화면 표시만 묶는다.
const vscode = require('vscode');
const fs = require('fs');
const path = require('path');

// 2026-11-18 사용자: 파싱부터 완료까지 바뀐 순서(🚀 ID 하나로 전체 체인)대로 — 파싱 → 실측 → 문서(MD) → 생성 → 등록SQL → PKG → 게이트 → CheckList → 보완 → TestResultList → 문서 Excel.
//   E2E 4종(smoke·crud·auth·authcrud)은 CheckList 안에서 실행되므로 단계에서 빼고 Status 의 E2E 타일로만 보인다(판정 값 s.smoke 등은 그대로 계산).
const STAGES = [
  { key: 'pack', label: '1 파싱', task: 'S1.packone' },
  { key: 'live', label: '2 실측', task: 'S1.liveScreen' },
  { key: 'docs', label: '3 문서', task: 'S3.agent' },
  { key: 'gen', label: '4 생성', task: 'S5.pipelinedry' },
  { key: 'reg', label: '5 등록SQL', task: 'S5.regsql' },
  { key: 'pkg', label: '6 PKG', task: 'S5.pkgrepair' },
  { key: 'gate', label: '7 게이트', task: 'S8.feGate' },
  { key: 'chk', label: '8 테스트(CheckList)', task: 'S8.verify' }, // 2026-11-18 사용자: E2E 4종(smoke·crud·auth·authcrud)이 CheckList 안에서 실행 → CheckList = 테스트 단계
  { key: 'repair', label: '9 보완', task: 'S8.repairClose' },
  { key: 'report', label: '10 TestResultList', task: 'S8.report' },
  { key: 'xlsx', label: '11 문서 Excel', task: 'S3.xlsx' },
];
const E2E_KINDS = ['smoke', 'crud', 'auth', 'authcrud'];
const parseCsv = text => { text = text.replace(/^﻿/, ''); const rows = []; let row = [], f = '', q = false; for (let i = 0; i < text.length; i++) { const ch = text[i]; if (q) { if (ch === '"') { if (text[i + 1] === '"') { f += '"'; i++; } else q = false; } else f += ch; } else if (ch === '"') q = true; else if (ch === ',') { row.push(f); f = ''; } else if (ch === '\n' || ch === '\r') { if (ch === '\r' && text[i + 1] === '\n') i++; row.push(f); f = ''; if (row.length > 1 || row[0] !== '') rows.push(row); row = []; } else f += ch; } if (f !== '' || row.length) { row.push(f); rows.push(row); } return rows; };
const csvObjs = file => { if (!fs.existsSync(file)) return []; const r = parseCsv(fs.readFileSync(file, 'utf8')); const h = r[0] || []; return r.slice(1).map(x => Object.fromEntries(h.map((k, i) => [k, x[i] || '']))); };
const has = f => fs.existsSync(f);
const rd = f => has(f) ? fs.readFileSync(f, 'utf8') : '';

function targets(p) {
  // 대상 = Recon 대조표 in_target=Y 또는 status 가 누락-ToBe/OK/재확인 + Doc/gen 에 있는 ID (검증용 포함)
  const rec = csvObjs(path.join(p.reconOutDir, '대사표_화면.csv'));
  const ids = new Map();
  for (const r of rec) { const id = (r.tobe_id || r.asis_id || '').toUpperCase(); if (!id) continue; const tgt = r.in_target === 'Y' || /누락-ToBe|^OK|재확인|검토필요/.test(r.status || ''); if (tgt) ids.set(id, { id, asis: r.asis_id, title: r.title || '', status: r.status || '', reason: r.reason || '' }); }
  if (has(p.genDir)) for (const d of fs.readdirSync(p.genDir)) if (/^[A-Z]{2,4}\d{4}/.test(d) && !ids.has(d)) ids.set(d, { id: d, asis: d, title: '', status: '(Doc/gen)', reason: '' });
  // 2026-11-20 사용자 지시 'UI 명칭 누락분 현재 메뉴에서 찾아 채움': 대사표에 없어 명칭이 빈 화면(Doc/gen 만 있는 화면 41개 실측)은 TO-BE 메뉴(Doc/tobefacts/db/menu.csv mnu_desc) 명칭으로
  try { const mf = path.join(p.tobeOutDir || path.join(p.root || '', 'Doc', 'tobefacts'), 'db', 'menu.csv'); if ([...ids.values()].some(x => !x.title) && has(mf)) { const mn = new Map(csvObjs(mf).map(r => [String(r.mnu_id || '').toUpperCase(), String(r.mnu_desc || '').trim()])); for (const x of ids.values()) if (!x.title && mn.get(x.id)) x.title = mn.get(x.id); } } catch { /* 메뉴 파일 없음 = 명칭 비움 유지 */ }
  return [...ids.values()].sort((a, b) => a.id.localeCompare(b.id));
}
function pageDirOf(p, id) { try { const r = JSON.parse(rd(path.join(p.genDir, id, 'register.json'))); return path.join(p.tobeDir, 'features', r.feature, 'src', 'pages', r.pageDir); } catch { return ''; } }
// 개선안 20261124043431_SELF: UI/DB MODE 게이트 대상 = tools/Harness/gate_baseline.tsv 와 내용이 다른 파일이 있는 화면 폴더(harness-stop-gate.ps1 과 같은 계산).
//   nscm-fe git status(-uall) 중 features/<f>/src/pages/<dir>/ 파일의 SHA1(없는 파일 = D)이 기준선과 다르면 그 폴더를 바뀐 화면으로 본다. 15초 동안 재사용.
//   기준선·nscm-fe .git 이 없거나 git 실행 실패 = null(호출 쪽이 종전대로 CHECK.md 판정)
let gbCache = { ms: 0, v: null };
function gateBaseline(p) {
  const bf = path.join(p.root || '', 'tools', 'Harness', 'gate_baseline.tsv');
  if (!p.tobeDir || !has(bf) || !has(path.join(p.tobeDir, '.git'))) return null;
  const now = Date.now(); if (gbCache.ms && now - gbCache.ms < 15000) return gbCache.v;
  let v = null;
  try {
    const txt = rd(bf); const base = new Map(); const at = (/at=(\S+ \S+)/.exec(txt.split(/\r?\n/, 1)[0] || '') || [])[1] || '';
    for (const l of txt.split(/\r?\n/)) { if (!l || l[0] === '#') continue; const i = l.indexOf('\t'); if (i > 0) base.set(l.slice(i + 1), l.slice(0, i)); }
    const out = require('child_process').execFileSync('git', ['-c', 'core.quotepath=false', 'status', '--porcelain', '-uall'], { cwd: p.tobeDir, encoding: 'utf8', timeout: 15000, windowsHide: true, maxBuffer: 64 * 1024 * 1024 });
    const crypto = require('crypto'); const dirs = new Set();
    for (const l of out.split(/\r?\n/)) {
      if (!l || l.length < 4) continue;
      let f = l.slice(3).replace(/^"|"$/g, ''); if (f.includes(' -> ')) f = f.split(' -> ').pop().replace(/^"|"$/g, '');
      const m = /(features\/[^/]+\/src\/pages\/[^/]+)\//.exec(f); if (!m) continue;
      let h = 'D'; try { const full = path.join(p.tobeDir, f); if (fs.statSync(full).isFile()) h = crypto.createHash('sha1').update(fs.readFileSync(full)).digest('hex'); } catch { /* 없는 파일 = D */ }
      if (base.get(f) !== h) dirs.add(m[1]);
    }
    v = { at, dirs };
  } catch { v = null; }
  gbCache = { ms: now, v }; return v;
}
function stageStatus(p, id) {
  const g = path.join(p.genDir, id); const s = {};
  const pack = path.join(p.outDir, 'screens', id); s.pack = has(path.join(pack, `${id}_summary.md`)) ? 'ok' : (has(pack) ? 'warn' : 'none');
  const gate = path.join(p.outDir, 'agent', id, '_gate.csv');
  if (has(gate)) { const rows = csvObjs(gate); const bad = rows.filter(r => /FAIL|BLOCK/i.test(r.status || r.result || '')).length; s.docs = bad ? 'warn' : 'ok'; } else s.docs = has(path.join(p.outDir, 'agent', id, 'analysis.md')) ? 'warn' : 'none';
  // 2026-11-18: 문서 Excel = 팀 폴더(화면설계서·화면분석서·단위테스트) 최신 위치 + 구 Doc/documents/<ID>
  const xlsxIn = d => { try { return fs.readdirSync(d).some(f => /\.xlsx$/i.test(f) && f.toUpperCase().startsWith(id) && !f.startsWith('~$')); } catch { return false; } };
  const xn = ['화면설계서', '화면분석서', '단위테스트'].filter(d => xlsxIn(path.join(p.root, 'Doc', d)));
  s.xlsx = xn.length || xlsxIn(path.join(p.root, 'Doc', 'documents', id)) ? 'ok' : 'none'; if (xn.length) s.xlsxN = `${xn.length}/3`;
  // 2026-11-18: AS-IS 실측 = Doc/asislive/<ID>/screen_bundle.json 상태(OK·NA 완료 · PARTIAL 일부 실패 · ERROR 미측정)
  try { const bd = JSON.parse(rd(path.join(p.root, 'Doc', 'asislive', id, 'screen_bundle.json')).replace(/^\uFEFF/, '')); s.live = /^(OK|NA)$/.test(bd.status) ? 'ok' : bd.status === 'PARTIAL' ? 'warn' : 'bad'; s.liveN = bd.status; } catch { s.live = has(path.join(p.root, 'Doc', 'asislive', id, 'latest.json')) ? 'warn' : 'none'; }
  // 2026-11-18: CheckList = run_verify.result.json(FAIL·판정필요·미검증) + '미검증' 시트(checklist_counts.json) · 보완 = fixlist 조치 필요 행 처리 상태
  const vd = path.join(p.root, 'Doc', 'verify', id); let env = null, cc = null;
  try { env = JSON.parse(rd(path.join(vd, 'run_verify.result.json')).replace(/^\uFEFF/, '')); } catch { }
  try { cc = JSON.parse(rd(path.join(vd, 'checklist_counts.json')).replace(/^\uFEFF/, '')); } catch { }
  // 2026-11-19 사용자: 미검증 해소 보완 뒤 CheckList 재수행 전이면 보완 전 건수를 보여 주지 않는다(타일·말풍선 모두) — tools/VibeManager/recheck.js
  const prc = require('./recheck').pendingRecheck(vd);
  if (prc && env && env.summary) { s.chk = 'warn'; s.chkN = '재수행 전'; s.chkTip = prc.note; s.chkPending = prc; }
  else if (env && env.summary) { const sm = env.summary; const unv = cc ? cc.unverified_sheet : null; const clean = !sm.FAIL && !sm['판정필요'] && !sm['미검증'] && unv === 0 && env.state === 'completed';
    s.chk = clean ? 'ok' : (env.state !== 'completed' || sm['미검증'] ? 'bad' : 'warn'); s.chkN = `F ${sm.FAIL}`; s.chkTip = `FAIL ${sm.FAIL} · 판정필요 ${sm['판정필요']} · 미검증 ${sm['미검증']} · 미검증 시트 ${unv == null ? '미집계' : unv} · ${env.started || ''}`;
    s.chkCounts = { FAIL: sm.FAIL, 판정필요: sm['판정필요'], 미검증: sm['미검증'], 미검증시트: unv, started: env.started || '', state: env.state }; }
  else s.chk = 'none';
  const fxF = path.join(vd, 'fixlist.csv');
  if (has(fxF)) { const rows = csvObjs(fxF).filter(r => (r.action_needed || '').toUpperCase() === 'Y'); const open = rows.filter(r => !/^(적용|검증완료)/.test(r.status || '')).length; s.repair = !rows.length || !open ? 'ok' : (open < rows.length ? 'warn' : 'bad'); s.repairN = `${rows.length - open}/${rows.length}`; s.repairTip = `조치 필요 ${rows.length} · 처리 ${rows.length - open} · 남음 ${open}`; s.fixOpen = open; s.fixTot = rows.length; }
  // 2026-11-18: TestResultList = Doc/테스트결과서/<ID>_*.xlsx · CheckList 보다 오래되면 warn
  try { const td = path.join(p.root, 'Doc', '테스트결과서'); const ts = fs.readdirSync(td).filter(f => f.toUpperCase().startsWith(id + '_') && /\.xlsx$/i.test(f) && !f.startsWith('~$')).map(f => fs.statSync(path.join(td, f)).mtimeMs); const envAt = has(path.join(vd, 'run_verify.result.json')) ? fs.statSync(path.join(vd, 'run_verify.result.json')).mtimeMs : 0; s.report = ts.length ? (Math.max(...ts) >= envAt ? 'ok' : 'warn') : 'none'; } catch { s.report = 'none'; }
  s.gen = has(path.join(g, 'GEN_NOTES.md')) ? (pageDirOf(p, id) && has(pageDirOf(p, id)) ? 'ok' : 'warn') : 'none';
  // 개선안 20261124043431_SELF(규칙 R135 · 2026-11-19 사용자 지시): DB MODE = FE 소스가 변경 대상 아님 → 게이트 칸 제외(통과로 셈).
  //   UI/DB MODE = gate_baseline.tsv 이후 바뀐 파일이 있는 화면만 CHECK.md 로 판정(harness-stop-gate.ps1 과 같은 기준). 기준선·git 을 못 읽으면 종전대로 CHECK.md.
  //   fe_gate.json(브라우저 열기) 제외 여부는 사용자 판정 대상이라 아래 73줄 판정은 그대로 둔다.
  let wm = null; try { wm = require('./workbench').workMode(p); } catch { /* 모드 못 읽음 = 종전 판정 */ }
  const pgDir = pageDirOf(p, id); const pgRel = pgDir && p.tobeDir ? path.relative(p.tobeDir, pgDir).replace(/\\/g, '/') : '';
  const gb = wm && !wm.db && pgRel ? gateBaseline(p) : null;
  if (wm && wm.db) { s.gate = 'ok'; s.gateN = p.language === 'en' ? 'skip' : '제외'; s.gateTip = 'DB MODE: FE 변경 대상 아님(게이트 제외 · harness.json repairScope DB_ONLY)'; }
  else if (gb && !gb.dirs.has(pgRel)) { s.gate = 'ok'; s.gateN = p.language === 'en' ? 'no change' : '변경 없음'; s.gateTip = `UI/DB MODE: 기준선(gate_baseline.tsv ${gb.at}) 이후 바뀐 파일 없음 · 게이트 대상 아님`; }
  else { const chk = rd(path.join(g, 'CHECK.md')); const m = chk.match(/BLOCK (\d+) \/ WARN (\d+)/); s.gate = m ? (Number(m[1]) === 0 ? 'ok' : 'bad') : 'none'; s.gateN = m ? `${m[1]}/${m[2]}` : ''; }
  // 2026-11-18: 게이트 = FE 게이트(Doc/verify/<ID>/fe_gate.json · 실제 브라우저 열기·콘솔·조회)가 있으면 그것을, 없으면 check.js(CHECK.md)
  try { const fg = JSON.parse(rd(path.join(p.root, 'Doc', 'verify', id, 'fe_gate.json')).replace(/^\uFEFF/, '')); const gs = (fg.gates || []).filter(x => x && x.result); const f = gs.filter(x => x.result === 'FAIL').length, ok = gs.filter(x => x.result === 'PASS').length; if (gs.length) { s.gate = f ? 'bad' : ok === gs.length ? 'ok' : 'warn'; s.gateN = `${ok}/${gs.length}`; s.gateTip = gs.map(x => `${x.gate} ${x.result}`).join(' · ') + ` · ${fg.at || ''}`; } } catch { }
  const dod = rd(path.join(g, 'DOD.md')).match(/(\d+)\/(\d+) 충족/); s.dod = dod ? `${dod[1]}/${dod[2]}` : '';
  const rep = rd(path.join(g, 'REPAIR.md')); if (!s.repair) s.repair = /\*\*PASS\*\*/.test(rep) ? 'ok' : (/NEEDS_HUMAN|사람 확인 큐/.test(rep) ? 'bad' : (rep ? 'warn' : 'none'));
  const pk = rd(path.join(g, 'CHECK_PKG.md')).match(/BLOCK (\d+) \/ WARN (\d+)/); s.pkg = pk ? (Number(pk[1]) === 0 ? 'ok' : 'bad') : (has(path.join(g, `${id}_PKG.sql`)) ? 'warn' : 'none'); s.pkgN = pk ? `${pk[1]}/${pk[2]}` : '';
  s.reg = has(path.join(g, `${id}_registration.sql`)) ? (has(path.join(g, `${id}_revert.sql`)) ? 'ok' : 'warn') : 'none';
  // 1.9.42(2026-11-06): 화면 폴더 요약 Doc/e2e/results/<ID>/_summary.csv 우선 · 없으면(전환 전) 공용 색인
  const e2eF = [path.join(p.e2eOutDir, 'results', id, '_summary.csv'), path.join(p.e2eOutDir, 'results', '_summary.csv')].find(f => has(f)) || '';
  const e2e = csvObjs(e2eF).filter(r => (r.menu_id || '').toUpperCase() === id);
  // 종류별: 결과 있음 → PASS 비율로 ok/warn/bad · 결과 없고 스펙만 있음 → warn(미실행) · 스펙도 없음 → none. s.e2e = 전체 합(구 호환)
  for (const k of E2E_KINDS) {
    const rows = e2e.filter(r => (r.kind || '').toLowerCase() === k);
    if (rows.length) { const pass = rows.filter(r => /pass/i.test(r.status)).length; s[k] = pass === rows.length ? 'ok' : (pass ? 'warn' : 'bad'); s[k + 'N'] = `${pass}/${rows.length}`; }
    else s[k] = has(path.join(p.e2eOutDir, 'specs', `${id}.${k}.spec.ts`)) ? 'warn' : 'none';
  }
  if (e2e.length) { const pass = e2e.filter(r => /pass/i.test(r.status)).length; s.e2e = pass === e2e.length ? 'ok' : (pass ? 'warn' : 'bad'); s.e2eN = `${pass}/${e2e.length}`; } else s.e2e = has(path.join(p.e2eOutDir, 'specs', `${id}.smoke.spec.ts`)) ? 'warn' : 'none';
  const pl = rd(path.join(g, 'PIPELINE.md')).match(/^# PIPELINE \S+ — ([\d-]+ [\d:]+) (✅|⚠)/m); s.pipeline = pl ? `${pl[2]} ${pl[1]}` : '';
  return s;
}
const SYM = { ok: '●', warn: '◐', bad: '✖', none: '○' };
const CLS = { ok: 'ok', warn: 'warn', bad: 'bad', none: 'none' };

// ───────────────────────── FLOW 표 열 (표시 전용 묶음) ─────────────────────────
//   parts = 묶는 판정 키. 묶음 상태 = 전부 ok → ok · 하나라도 bad → bad · 전부 none → none · 그 외 warn.
//   클릭 = 한 칸짜리는 그 단계 작업 · 문서 = 아직 ok 가 아닌 첫 부분의 작업(문서 → S3.agent, Excel → S3.xlsx) · Test = S7.all(4종 한 번에)
const COLS = [ // 🚀 ID 하나로 전체 체인 순서(2026-11-18 사용자: 파싱부터 완료까지 바뀐 순서). 머리글은 언어 설정과 무관하게 영문
  //   제외: E2E 단독 실행(S7.* — 11-04 E2E 메뉴 단계 폐지, E2E 는 CheckList 안에서 실행) · 클라우드 이관(수동 메뉴)
  { key: 'pack', ko: '파싱', en: 'Parse', parts: ['pack'] },
  { key: 'live', ko: '실측', en: 'Live', parts: ['live'] },
  { key: 'docs', ko: '문서', en: 'Docs', parts: ['docs'] },
  { key: 'gen', ko: '생성', en: 'Build', parts: ['gen'] },
  { key: 'reg', ko: '등록SQL', en: 'META', parts: ['reg'] },
  { key: 'pkg', ko: 'PKG', en: 'PKG', parts: ['pkg'] },
  { key: 'gate', ko: '게이트', en: 'Gate', parts: ['gate'] },
  { key: 'chk', ko: '테스트(CheckList)', en: 'Test·CheckList', parts: ['chk'] },
  { key: 'repair', ko: '보완', en: 'Fix', parts: ['repair'] },
  { key: 'report', ko: 'TestResultList', en: 'Result', parts: ['report'] },
  { key: 'xlsx', ko: '문서 Excel', en: 'Excel', parts: ['xlsx'] },
];
const PART = { docs: ['문서', 'Docs'], xlsx: ['Excel', 'Excel'], live: ['실측', 'Live'], report: ['TestResultList', 'Result'], smoke: ['Smoke', 'Smoke'], crud: ['CRUD', 'CRUD'], auth: ['Auth', 'Auth'], authcrud: ['Auth×CRUD', 'Auth×CRUD'] };
const taskOf = key => (STAGES.find(st => st.key === key) || {}).task || '';
function cell(col, s, en) {
  const vs = col.parts.map(k => s[k] || 'none');
  const v = vs.every(x => x === 'ok') ? 'ok' : vs.some(x => x === 'bad') ? 'bad' : vs.every(x => x === 'none') ? 'none' : 'warn';
  let n = '';
  if (col.parts.length === 1) n = s[col.key + 'N'] || (col.key === 'gate' && s.dod ? `DoD ${s.dod}` : '');
  else { let a = 0, b = 0; for (const k of col.parts) { const m = /^(\d+)\/(\d+)$/.exec(s[k + 'N'] || ''); if (m) { a += Number(m[1]); b += Number(m[2]); } } if (b) n = `${a}/${b}`; }
  const task = col.task || taskOf(col.parts.find(k => (s[k] || 'none') !== 'ok') || col.parts[0]);
  const tip = col.parts.length === 1 ? (s[col.key + 'Tip'] || '') : col.parts.map(k => `${PART[k][en ? 1 : 0]} ${SYM[s[k] || 'none']}${s[k + 'N'] ? ' ' + s[k + 'N'] : ''}`).join(' · ');
  return { v, n, task, tip };
}
const IC = {
  play: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M8 5.5v13l10.5-6.5z"/></svg>',
  refresh: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M20 11a8 8 0 0 0-14.5-3.5M4 4v4h4M4 13a8 8 0 0 0 14.5 3.5M20 20v-4h-4"/></svg>',
  search: '<svg viewBox="0 0 24 24" aria-hidden="true"><circle cx="11" cy="11" r="6.5"/><path d="M16 16l4.5 4.5"/></svg>',
  save: '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 4v11M7.5 11l4.5 4.5 4.5-4.5M5 19.5h14"/></svg>'
};
// 워크벤치 탭과 독립 패널이 같이 쓰는 스타일 — 요약 영역은 위에 고정, 표만 스크롤(표 머리글 sticky)
const FLOW_CSS = `
.flow-root{--fa:var(--vscode-textLink-foreground,#3794ff);--fl:var(--vscode-editorWidget-border,rgba(128,128,128,.3));--fd:var(--vscode-descriptionForeground,#9d9d9d);--fok:var(--vscode-testing-iconPassed,#3fb950);--fwarn:var(--vscode-testing-iconQueued,#d29922);--fbad:var(--vscode-testing-iconFailed,#f85149);
display:flex;flex-direction:column;height:100%;min-height:0;font:12px/1.4 var(--vscode-font-family);color:var(--vscode-foreground)}
.flow-root svg{width:1em;height:1em;fill:none;stroke:currentColor;stroke-width:1.8;stroke-linecap:round;stroke-linejoin:round;flex:none}
.flow-root .fl-head{flex:none;padding:10px 12px 8px;border-bottom:1px solid var(--fl)}
.flow-root .fl-top{display:flex;align-items:center;gap:10px;flex-wrap:wrap}
.flow-root h3{margin:0;font-size:14px;font-weight:650;letter-spacing:-.01em}
.flow-root .fl-meta{color:var(--fd);font-size:11.5px;font-variant-numeric:tabular-nums}.flow-root .fl-meta b{color:var(--vscode-foreground);font-weight:600}
.flow-root .fl-sp{flex:1}
.flow-root .fl-find{position:relative;display:inline-flex;align-items:center}
.flow-root .fl-find svg{position:absolute;left:9px;font-size:13px;color:var(--fd);pointer-events:none}
.flow-root .fl-find input{width:170px;height:26px;border-radius:13px;border:1px solid var(--fl);background:var(--vscode-input-background);color:var(--vscode-input-foreground);padding:0 10px 0 28px;font:inherit;font-size:11.5px}
.flow-root .fl-find input:focus{outline:0;border-color:var(--vscode-focusBorder,var(--fa))}
.flow-root .fl-ib{display:inline-flex;align-items:center;gap:5px;height:26px;padding:0 10px;margin:0;border-radius:13px;border:1px solid var(--fl);background:transparent;color:var(--vscode-foreground);font-size:11.5px;cursor:pointer}
.flow-root .fl-ib:hover{background:color-mix(in srgb,var(--fa) 12%,transparent);border-color:var(--fa);color:var(--fa)}
.flow-root .bar{height:4px;background:color-mix(in srgb,var(--vscode-foreground) 10%,transparent);border:0;border-radius:2px;overflow:hidden;margin:9px 0 8px}
.flow-root .bar div{height:100%;background:var(--fok);border-radius:2px}
.flow-root .stages{display:grid;grid-template-columns:repeat(auto-fit,minmax(84px,1fr));gap:6px;margin:0}
.flow-root .stages .sg{border:0;border-radius:8px;padding:6px 9px 7px;background:color-mix(in srgb,var(--vscode-foreground) 5%,transparent);min-width:0}
.flow-root .stages .sl{display:block;font-size:10.5px;color:var(--fd);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.flow-root .stages .sv{font-size:13px;font-weight:650;font-variant-numeric:tabular-nums}.flow-root .stages .sv i{font-style:normal;font-weight:400;font-size:10.5px;color:var(--fd)}
.flow-root .stages .sb{display:block;height:3px;border-radius:2px;background:color-mix(in srgb,var(--vscode-foreground) 10%,transparent);margin-top:4px;overflow:hidden}
.flow-root .stages .sb span{display:block;height:100%;background:var(--fa);border-radius:2px}
.flow-root .legend{display:flex;flex-wrap:wrap;gap:6px 14px;align-items:center;margin:8px 0 0;font-size:11px;color:var(--fd)}
.flow-root .legend span{display:inline-flex;align-items:center;gap:5px}
.flow-root .fl-wrap{flex:1;min-height:220px;overflow:auto} /* 2026-11-25 사용자: 창이 낮으면 머리(단계 요약)가 공간을 다 써 표 높이 0 · 스크롤 없음(600x500 실측 머리 305px, 표 0px). 표는 220px 이상 두고 모자라면 바깥 틀이 스크롤 */
.flow-root .dot{display:inline-block;width:11px;height:11px;border-radius:50%;box-sizing:border-box;vertical-align:middle}
.flow-root .dot.ok{background:var(--fok)}
.flow-root .dot.warn{border:2px solid var(--fwarn);background:linear-gradient(90deg,var(--fwarn) 50%,transparent 50%)}
.flow-root .dot.bad{background:var(--fbad);border-radius:3px;transform:rotate(45deg) scale(.9)}
.flow-root .dot.none{border:1.5px solid color-mix(in srgb,var(--vscode-foreground) 42%,transparent)}
.flow-tbl{border-collapse:separate;border-spacing:0;width:100%;margin:0;font-size:11.5px}
.flow-tbl th,.flow-tbl td{border:0;border-bottom:1px solid var(--fl);padding:5px 8px;vertical-align:middle;text-align:left}
.flow-tbl th{position:sticky;top:0;z-index:2;background:var(--vscode-editor-background);font-size:10.5px;font-weight:600;color:var(--fd);letter-spacing:.02em;white-space:nowrap;box-shadow:0 1px 0 var(--fl)}
.flow-tbl th.c{text-align:center}
.flow-tbl tbody tr:hover td{background:color-mix(in srgb,var(--vscode-foreground) 4%,transparent)}
.flow-tbl td.id{white-space:nowrap;font-weight:650;font-variant-numeric:tabular-nums}
.flow-tbl td.t{min-width:150px}
.flow-tbl .sub{font-size:10.5px;font-weight:400;color:var(--fd)}
.flow-tbl td.fc{text-align:center;cursor:pointer;width:64px;padding:5px 4px}
.flow-tbl td.fc:hover{background:color-mix(in srgb,var(--fa) 14%,transparent)}
.flow-tbl td.fc .n{font-size:10px;color:var(--fd);font-variant-numeric:tabular-nums;margin-top:2px;line-height:1.1}
.flow-tbl td.fc.bad .n{color:var(--fbad)}.flow-tbl td.fc.warn .n{color:var(--fwarn)}
.flow-tbl .pl{white-space:nowrap;font-size:10.5px;color:var(--fd);font-variant-numeric:tabular-nums}
.flow-tbl .fact{white-space:nowrap;text-align:right;width:1%}
.flow-tbl .fbtn{display:inline-flex;align-items:center;gap:5px;height:24px;padding:0 10px;margin:0;border-radius:12px;border:1px solid color-mix(in srgb,var(--fa) 55%,transparent);background:transparent;color:var(--fa);font-size:11px;font-weight:600;cursor:pointer}
.flow-tbl .fbtn:hover{background:var(--fa);color:var(--vscode-editor-background)}
.flow-tbl .fbtn.off,.flow-tbl .fbtn.off:hover{opacity:.38;cursor:not-allowed;background:transparent;color:var(--fa)}
.flow-tbl .fbtn svg{font-size:11px;fill:currentColor;stroke:none}
.flow-tbl td.hint{text-align:center;color:var(--fd);padding:24px}
/* ── 2026-11-20 사용자: FLOW 프리미엄 글래스모피즘(은은한 색감) · VMO·VMW·Workbench 와 같은 변수 ── */
.flow-root{--fg:var(--vscode-foreground);--fa:color-mix(in srgb,var(--vscode-textLink-foreground,#3794ff) 62%,#8b93a7);--fok:color-mix(in srgb,var(--vscode-testing-iconPassed,#3fb950) 72%,#8b93a7);--fwarn:color-mix(in srgb,var(--vscode-testing-iconQueued,#d29922) 72%,#8b93a7);--fbad:color-mix(in srgb,var(--vscode-testing-iconFailed,#f85149) 70%,#8b93a7);
  --fl:color-mix(in srgb,var(--fg) 10%,transparent);
  --gx1:color-mix(in srgb,var(--fg) 7.5%,transparent);--gx0:color-mix(in srgb,var(--fg) 3%,transparent);--gxb:color-mix(in srgb,var(--fg) 12%,transparent);
  --gxh:inset 0 1px 0 rgba(255,255,255,.10),inset 0 -1px 0 rgba(255,255,255,.02);--gxs:0 16px 40px -18px rgba(0,0,0,.55),0 2px 6px rgba(0,0,0,.18);gap:8px;padding:8px}
.vscode-light .flow-root{--gxh:inset 0 1px 0 rgba(255,255,255,.85),inset 0 -1px 0 rgba(255,255,255,.3);--gxs:0 14px 36px -18px rgba(40,60,120,.26),0 2px 6px rgba(40,60,120,.06);--gx1:color-mix(in srgb,#fff 62%,transparent);--gx0:color-mix(in srgb,#fff 40%,transparent);--gxb:color-mix(in srgb,#fff 85%,transparent);--fl:color-mix(in srgb,var(--fg) 12%,transparent)}
.flow-root .fl-head,.flow-root .fl-wrap{background:linear-gradient(155deg,var(--gx1),var(--gx0) 60%);border:1px solid var(--gxb);border-radius:14px;box-shadow:var(--gxs),var(--gxh);-webkit-backdrop-filter:blur(22px) saturate(160%);backdrop-filter:blur(22px) saturate(160%)}
.flow-root .fl-head{padding:10px 14px 10px}
.flow-root h3::before{content:"";display:inline-block;vertical-align:-3px;width:16px;height:16px;margin-right:7px;border-radius:5px;background:conic-gradient(from 210deg,var(--fa),color-mix(in srgb,var(--vscode-charts-purple,#a371f7) 55%,#8b93a7),var(--fok),var(--fa));box-shadow:inset 0 1px 0 rgba(255,255,255,.35);opacity:.85}
.flow-root .fl-find input{border-color:var(--gxb);background:var(--gx0);box-shadow:var(--gxh)}
.flow-root .fl-ib{border-color:var(--gxb);background:var(--gx0);box-shadow:var(--gxh)}
.flow-root .fl-ib:hover{background:var(--gx1);border-color:color-mix(in srgb,var(--fa) 45%,var(--gxb));color:var(--vscode-foreground)}
.flow-root .bar{height:5px;border-radius:4px;background:color-mix(in srgb,var(--fg) 8%,transparent)}
.flow-root .bar div{background:linear-gradient(90deg,color-mix(in srgb,var(--fok) 60%,transparent),var(--fok));border-radius:4px}
.flow-root .stages .sg{border:1px solid color-mix(in srgb,var(--fg) 8%,transparent);border-radius:11px;background:color-mix(in srgb,var(--fg) 3.5%,transparent);box-shadow:var(--gxh)}
.vscode-light .flow-root .stages .sg{background:color-mix(in srgb,#fff 50%,transparent);border-color:color-mix(in srgb,#fff 80%,transparent)}
.flow-root .stages .sb{background:color-mix(in srgb,var(--fg) 8%,transparent)}
.flow-root .stages .sb span{background:color-mix(in srgb,var(--fa) 80%,transparent)}
.flow-root .fl-wrap{overflow:auto}
.flow-tbl th{background:color-mix(in srgb,var(--vscode-editor-background) 78%,transparent);-webkit-backdrop-filter:blur(14px);backdrop-filter:blur(14px);box-shadow:0 1px 0 var(--gxb)}
.flow-tbl th:first-child{border-top-left-radius:14px}.flow-tbl th:last-child{border-top-right-radius:14px}
.flow-tbl tbody tr:hover td{background:color-mix(in srgb,var(--fg) 5%,transparent)}
.flow-tbl td.fc{border-radius:8px}
.flow-tbl .fbtn{border-color:color-mix(in srgb,var(--fa) 40%,var(--gxb));background:var(--gx0);box-shadow:var(--gxh)}
.flow-tbl .fbtn:hover{background:color-mix(in srgb,var(--fa) 70%,transparent);color:var(--vscode-editor-background)}
.flow-root .fl-wrap::-webkit-scrollbar{width:8px;height:8px}.flow-root .fl-wrap::-webkit-scrollbar-thumb{background:color-mix(in srgb,var(--fg) 14%,transparent);border-radius:8px}
@media (prefers-reduced-transparency:reduce){.flow-root .fl-head,.flow-root .fl-wrap,.flow-tbl th{-webkit-backdrop-filter:none;backdrop-filter:none;background:var(--vscode-editor-background)}}
`;

// 표 본문(워크벤치 탭·독립 패널 공용). opts.csv = CSV 저장 버튼(독립 패널만)
function body(p, rows, filter, opts) {
  const esc = s => String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;');
  const en = p.language === 'en'; const L = (ko, e) => en ? e : ko;
  // 2026-11-12 사용자: DB MODE 에서는 Batch Run 을 실행하지 않는다 — 버튼을 흐리게 하고 이유를 툴팁에 적는다(실제 차단은 workbench.flowEnd)
  let dbMode = true; try { dbMode = (JSON.parse(fs.readFileSync(path.join(p.root, 'tools', 'Harness', 'harness.json'), 'utf8').replace(/^\uFEFF/, '')).repairScope || 'DB_ONLY') !== 'DB_FE'; } catch { }
  const calc = rows.map(r => ({ r, cs: COLS.map(c => cell(c, r.s, en)) }));
  const total = rows.length; const done = calc.filter(x => x.cs.every(c => c.v === 'ok')).length; const pct = total ? Math.round(done * 100 / total) : 0;
  const per = COLS.map((c, i) => ({ c, n: calc.filter(x => x.cs[i].v === 'ok').length }));
  const trs = calc.map(({ r, cs }) => `<tr data-id="${esc(r.id)}"><td class="id">${esc(r.id)}${r.asis && r.asis !== r.id ? `<div class="sub">As-is ${esc(r.asis)}</div>` : ''}</td><td class="t">${esc(r.title)}<div class="sub">${esc(r.status)}</div></td>${COLS.map((c, i) => { const x = cs[i]; const name = c.en; return `<td class="fc c ${CLS[x.v]}" title="${esc(name)}${x.tip ? ' — ' + esc(x.tip) : ''} — ${L('클릭', 'click')}: ${esc(x.task)}" data-task="${esc(x.task)}" data-id="${esc(r.id)}"><span class="dot ${CLS[x.v]}"></span>${x.n ? `<div class="n">${esc(x.n)}</div>` : ''}</td>`; }).join('')}<td class="fact act"><button class="fbtn${dbMode ? ' off' : ''}" data-act="pipeline" data-id="${esc(r.id)}" title="${dbMode ? L('DB MODE 에서는 실행하지 않습니다. 환경설정에서 작업 모드를 UI/DB MODE 로 바꾸세요', 'Not run in DB MODE — switch Work Mode to UI/DB MODE in Settings') : L('일괄 작업. 페이지가 있으면 자동 보완, 테스트, 문서까지. 없으면 새 화면 전체', 'Batch run — existing page → auto fix → tests & docs / none → whole new-screen flow')}">${IC.play}Batch Run</button></td></tr>`).join('');
  return `<div class="flow-root">
  <div class="fl-head">
    <div class="fl-top"><h3>NSCM Migration Flow</h3><span class="fl-meta">${L('화면', 'Screens')} <b>${total}</b> · ${L('전 단계 완료', 'All stages done')} <b>${done}</b> (${pct}%)</span><span class="fl-sp"></span>
      <span class="fl-find">${IC.search}<input id="flow-f" placeholder="${L('ID/제목 필터, Enter', 'Filter by ID/title — Enter')}" value="${esc(filter || '')}"></span>
      <button class="fl-ib" id="flow-rf" title="${L('새로고침', 'Refresh')}">${IC.refresh}${L('새로고침', 'Refresh')}</button>${opts && opts.csv ? `<button class="fl-ib" id="flow-csv" title="CSV">${IC.save}CSV</button>` : ''}</div>
    <div class="bar"><div style="width:${pct}%"></div></div>
    <div class="stages">${per.map(x => `<div class="sg" title="${esc(x.c.en)}${en ? '' : ' (' + esc(x.c.ko) + ')'} ${x.n}/${total}"><span class="sl">${esc(x.c.en)}</span><span class="sv">${x.n}<i> / ${total}</i></span><span class="sb"><span style="width:${total ? Math.round(x.n * 100 / total) : 0}%"></span></span></div>`).join('')}</div>
    <div class="legend"><span><i class="dot ok"></i>${L('완료', 'Done')}</span><span><i class="dot warn"></i>${L('부분/확인', 'Partial / check')}</span><span><i class="dot bad"></i>${L('실패(BLOCK/NEEDS_HUMAN)', 'Failed (BLOCK/NEEDS_HUMAN)')}</span><span><i class="dot none"></i>${L('없음', 'None')}</span><span>${L('셀 클릭 = 그 단계 작업 실행', 'Click a cell to run that stage')}</span></div>
  </div>
  <div class="fl-wrap"><table class="flow-tbl"><thead><tr><th>Screen</th><th>Title / Status</th>${COLS.map(c => `<th class="c">${esc(c.en)}</th>`).join('')}<th></th></tr></thead><tbody>${trs || `<tr><td colspan="99" class="hint">${L('대상 없음. 대조표/Doc/gen 미생성', 'No targets — recon table / Doc/gen not generated')}</td></tr>`}</tbody></table></div>
</div>`;
}
function loadRows(p, filter) {
  let rows = targets(p).map(t => Object.assign(t, { s: stageStatus(p, t.id) }));
  if (filter) { const f = filter.toLowerCase(); rows = rows.filter(r => r.id.toLowerCase().includes(f) || (r.title || '').toLowerCase().includes(f) || (r.status || '').includes(filter)); }
  return rows;
}

function html(p, rows, filter) {
  return `<!doctype html><html><head><meta charset="utf-8"><style>
html,body{height:100%}body{margin:0;padding:0;background:var(--vscode-editor-background);overflow-x:hidden;overflow-y:auto}
${FLOW_CSS}body{background:radial-gradient(120% 90% at 50% 0%,color-mix(in srgb,var(--vscode-editor-background) 92%,#24304d),var(--vscode-editor-background) 70%)}
.vmo-aur{position:fixed;inset:0;z-index:-1;overflow:hidden;pointer-events:none}
.vmo-aur i{position:absolute;border-radius:50%;filter:blur(90px);opacity:.24;animation:vmoDrift 30s ease-in-out infinite alternate}
.vmo-aur i:nth-child(1){width:600px;height:600px;left:-160px;top:-240px;background:color-mix(in srgb,var(--vscode-charts-blue,#3794ff) 58%,#8b93a7)}
.vmo-aur i:nth-child(2){width:520px;height:520px;right:-170px;top:-140px;background:color-mix(in srgb,var(--vscode-charts-purple,#a371f7) 55%,#8b93a7);animation-duration:36s}
.vmo-aur i:nth-child(3){width:440px;height:440px;left:36%;bottom:-260px;background:color-mix(in srgb,var(--vscode-charts-green,#3fb9a8) 50%,#8b93a7);opacity:.14;animation-duration:42s}
.vscode-light .vmo-aur i{opacity:.14}.vscode-light .vmo-aur i:nth-child(3){opacity:.09}
@keyframes vmoDrift{to{transform:translate(50px,34px) scale(1.06)}}
@media (prefers-reduced-motion:reduce){.vmo-aur i{animation:none}}
@media (prefers-reduced-transparency:reduce){.vmo-aur{display:none}}
</style></head><body>
<div class="vmo-aur" aria-hidden="true"><i></i><i></i><i></i></div>
${body(p, rows, filter, { csv: true })}
<script>const vscode=acquireVsCodeApi();
document.querySelectorAll('td.fc').forEach(td=>td.onclick=()=>vscode.postMessage({type:'task',task:td.dataset.task,id:td.dataset.id}));
document.querySelectorAll('button[data-act]').forEach(b=>b.onclick=()=>vscode.postMessage({type:b.dataset.act,id:b.dataset.id}));
document.getElementById('flow-rf').onclick=()=>vscode.postMessage({type:'refresh',filter:document.getElementById('flow-f').value});
document.getElementById('flow-csv').onclick=()=>vscode.postMessage({type:'csv'});
document.getElementById('flow-f').addEventListener('keydown',e=>{if(e.key==='Enter')vscode.postMessage({type:'refresh',filter:e.target.value});});
</script></body></html>`;
}

let panel = null;
function open(api) {
  const render = (filter) => {
    const p = api.paths(); const rows = loadRows(p, filter);
    panel.webview.html = html(p, rows, filter); panel._rows = rows;
  };
  if (panel) { panel.reveal(); render(panel._filter || ''); return; }
  panel = vscode.window.createWebviewPanel('vibeManager.flow', 'NSCM FLOW 진척, Vibe Manager ' + require('./package.json').version, vscode.ViewColumn.One, { enableScripts: true, retainContextWhenHidden: true });
  panel.onDidDispose(() => { panel = null; });
  panel.webview.onDidReceiveMessage(async m => {
    const p = api.paths();
    if (m.type === 'refresh') { panel._filter = m.filter || ''; render(panel._filter); }
    else if (m.type === 'task') await api.runTaskById(m.task, { id: m.id, ids: m.id, dir: pageDirOf(p, m.id) });
    else if (m.type === 'pipeline') { if (!(await require('./workbench').runFlowEnd(m.id))) vscode.window.showWarningMessage('Vibe_Manager: Workbench 를 열 수 없어 Batch Run 을 실행하지 못했습니다'); } // 2026-10-22: 기존 화면 🚒 / 새 화면 🚀
    else if (m.type === 'open') api.openPath(path.join(p.genDir, m.id));
    else if (m.type === 'csv') { const out = path.join(p.vibeDir, 'reports', `flow_${require('./history').nowLocal().slice(0, 10)}.csv`); fs.mkdirSync(path.dirname(out), { recursive: true }); const rows = panel._rows || []; const head = ['id', 'asis', 'title', 'status', ...STAGES.map(s => s.key), 'dod', 'pipeline']; fs.writeFileSync(out, '﻿' + [head.join(','), ...rows.map(r => [r.id, r.asis, r.title, r.status, ...STAGES.map(s => r.s[s.key]), r.s.dod, r.s.pipeline].map(v => `"${String(v == null ? '' : v).replace(/"/g, '""')}"`).join(','))].join('\n'), 'utf8'); vscode.window.showInformationMessage(`FLOW CSV → ${out}`); }
  });
  render('');
}
function refresh() { if (panel) open._api && open(open._api); }

// 워크벤치 내부 탭용: 전체 HTML 문서가 아닌 콘텐츠 영역만 반환
function innerHtml(p, filter) { return body(p, loadRows(p, filter), filter, {}); }

module.exports = { open, refresh, STAGES, COLS, stageStatus, targets, innerHtml, FLOW_CSS };
