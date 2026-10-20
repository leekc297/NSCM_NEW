'use strict';
// Vibe_Manager 1.5 — 워크벤치 (멀티 인스턴스 · 리본 메뉴 · 내부 탭 FLOW/이력 · 첨부 · 자동 컨텍스트/하네스 · 로딩 애니)
//   왼쪽: 전체 메뉴 아코디언 (quick.json 그룹 + 단계·DoD·룰/Hook/하네스·환경설정)
//   오른쪽 위: 작업출력 / Claude / 화면현황 / FLOW / 이력 (탭=언더라인, 버튼=필) + 로딩 스피너
//   오른쪽 아래: 프롬프트 + 첨부(📎) + 전송·새세션·새화면·새창·지우기·중지
//   멀티: ➕ 새 창 → 각 패널이 독립 Claude 세션·화면ID·procs·attached 보유
//   자동: 화면ID 가 있으면 컨텍스트 자동 첨부, S5/S4/S3 등 신규 UI·GAP 작업은 하네스 자동 ON
const vscode = require('vscode');
const fs = require('fs');
const path = require('path');
const cp = require('child_process');
const promptPanel = require('./prompt-panel');
const flow = require('./flow-panel');
const history = require('./history');

let seq = 0;
let instSeq = 0;
const panels = new Set();  // WB 인스턴스 집합
let lastWB = null;

const esc = s => String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;');
const substQ = (s, vars) => String(s == null ? '' : s).replace(/\$\{(\w+)\}/g, (m, k) => (vars[k] != null ? String(vars[k]) : m));

// 신규 UI 생성·GAP 분석/보완은 하네스 자동 ON — 사용자가 체크 안 해도 적용
const AUTO_HARNESS_TASKS = new Set([
  'S5.pipeline', 'S5.pipelinedesign', 'S5.pipelineregen', 'S5.pipelinedry',
  'S5.new', 'S5.claude', 'S5.repair', 'S5.check', 'S5.final',
  'S5.pkgrepair', 'S5.pkg', 'S5.pkgdeploy',
  'S4.one', 'S3.agent'
]);
function effectiveHarness(userHarness, taskId, item, id) {
  if (userHarness) return true;
  if (taskId && AUTO_HARNESS_TASKS.has(taskId)) return true;
  if (item && item.needsId === true) return true;
  if (id) return true; // 화면ID 가 지정된 모든 Claude 지시 — 사용자 지시 "불이익 없게"
  return false;
}

function claudeArgs(p, resume, overrides) {
  // 1.7: 모델 선택은 Claude Code 공식 메커니즘(/model · settings.json) 그대로 사용.
  //   VibeManager 자체 하드코딩 리스트 없음 → 최신 모델(Opus 5.5, Fable 5.1 등) 자동 노출.
  //   vibeManager.claudeModel 설정이 있으면 --model 로 override, 비어 있으면 미전달(=CLI 자체 디폴트).
  //   1.7.2: 하단 모델 드롭다운 복원 — 세션 선택값(overrides.model) > 전역 설정 > 미전달(CLI 디폴트).
  overrides = overrides || {};
  const mode = overrides.permissionMode || p.permissionMode || 'bypassPermissions';
  const model = overrides.model || p.claudeModel;
  const a = ['-p', '--output-format', 'stream-json', '--verbose', '--permission-mode', mode, '--allowedTools', 'Read,Edit,Write,Glob,Grep,Bash(node *),Bash(dir *),Bash(ls *),Bash(type *),Bash(cat *),Bash(python *),Bash(git status*),Bash(git diff*),Bash(git log*)'];
  if (model) a.push('--model', model);
  if (resume) a.push('--resume', resume);
  return a;
}
let flowSeq = 0; // 1.8.9: Flow 보드 일련번호(체인·단일 작업)
// 1.9.5: 체인 단계 산출물 검증 — verify: { type: 'e2eRows', kind } → Doc/e2e/results/_summary.csv 에 (화면, 종류) 행이 이번 실행(파일 갱신 시각 ≥ 단계 시작) 뒤 존재 · { type: 'fileExists', file }
function verifyStep(p, v, id) {
  if (process.env.VIBE_CHAIN_NO_VERIFY === '1') return { ok: true, why: '검증 생략(VIBE_CHAIN_NO_VERIFY)' }; // 모의 테스트 전용
  try {
    if (v.type === 'e2eRows') {
      const f = path.join(p.e2eOutDir, 'results', '_summary.csv'); if (!fs.existsSync(f)) return { ok: false, why: `E2E 요약 없음: ${f}` };
      const since = v._since || 0; const mt = fs.statSync(f).mtimeMs; if (since && mt < since) return { ok: false, why: `E2E 요약이 이번 실행에서 갱신되지 않음(Playwright 미실행 가능성) — ${path.relative(p.root, f)}` };
      const rows = fs.readFileSync(f, 'utf8').split(/\r?\n/).filter(l => l.includes(`"${id}"`) && (!v.kind || l.includes(`"${v.kind}"`)));
      if (!rows.length) return { ok: false, why: `E2E 결과에 ${id}${v.kind ? '/' + v.kind : ''} 행이 없음(스펙 미생성 또는 실행 실패)` };
      const pass = rows.filter(l => l.includes('"PASS"')).length; return { ok: true, why: `E2E ${v.kind || ''} ${pass}/${rows.length} PASS` };
    }
    if (v.type === 'fileExists') { const f = String(v.file || '').replace(/\$\{id\}/g, id).replace(/\$\{root\}/g, p.root).replace(/\$\{genDir\}/g, p.genDir); return fs.existsSync(f) ? { ok: true, why: `산출물 있음 ${path.relative(p.root, f)}` } : { ok: false, why: `산출물 없음 ${f}` }; }
    return { ok: true, why: '검증 규칙 없음' };
  } catch (e) { return { ok: false, why: `검증 예외: ${e.message}` }; }
}
const tabview = require('./tabview'); // 1.9.0: Workbench 내부 탭 뷰어
const summ = inp => { try { const s = JSON.stringify(inp); return s.length > 160 ? s.slice(0, 160) + '…' : s; } catch { return ''; } };
// 1.8.4: 도구 호출 한 줄 요약(사람이 읽는 형태) — Step 카드의 접힌 요약·도구 행 제목에 사용
// 1.8.7: 로컬 파일·폴더를 OS 기본 프로그램으로 열기 — vscode.env.openExternal(Uri.file) 은 Windows 에서 한글 경로(Doc\화면설계서 등)를
//   file: URI 로 넘기며 깨져 "지정된 파일을 찾을 수 없습니다 (0x2)" 가 난다 → Windows 는 cmd start 로, 그 외는 openExternal
function openWithOS(p, wb, file) {
  try {
    const f = path.normalize(String(file || ''));
    if (!f || !fs.existsSync(f)) { const msg = `파일/폴더가 없습니다: ${f}`; vscode.window.showErrorMessage(`Vibe_Manager: ${msg}`); if (wb) wb.out('task', msg + '\n', 'bad'); return; }
    if (process.platform === 'win32') {
      const ch = cp.spawn('cmd.exe', ['/d', '/s', '/c', `start "" "${f}"`], { windowsVerbatimArguments: true, windowsHide: true, detached: true, stdio: 'ignore' });
      ch.on('error', e => vscode.window.showErrorMessage(`Vibe_Manager: 열기 실패 ${f} — ${e.message}`)); ch.unref();
      if (wb) wb.out('task', `📂 열기: ${f}\n`, 'ok');
    } else vscode.env.openExternal(vscode.Uri.file(f));
  } catch (e) { vscode.window.showErrorMessage(`Vibe_Manager: 열기 실패 ${file} — ${e.message}`); }
}
function toolBrief(name, inp, ko) {
  try {
    inp = inp || {}; const base = s => String(s || '').replace(/\\/g, '/').split('/').slice(-2).join('/');
    const W = ko ? { read: '읽기', write: '쓰기', edit: '수정', grep: '검색', glob: '파일 찾기', run: '실행', agent: '에이전트', fetch: '웹 열기', search: '웹 검색', ask: '사용자 질문' }
                 : { read: 'Read', write: 'Write', edit: 'Edit', grep: 'Search', glob: 'Find files', run: 'Run', agent: 'Agent', fetch: 'Fetch', search: 'Web search', ask: 'Ask user' };
    switch (name) {
      case 'Read': return `${W.read} ${base(inp.file_path)}`;
      case 'Edit': case 'MultiEdit': case 'Write': case 'NotebookEdit': return `${name === 'Write' ? W.write : W.edit} ${base(inp.file_path || inp.notebook_path)}`;
      case 'Grep': return `${W.grep} "${String(inp.pattern || '').slice(0, 40)}"${inp.path ? ' in ' + base(inp.path) : ''}`;
      case 'Glob': return `${W.glob} ${String(inp.pattern || '').slice(0, 50)}`;
      case 'Bash': case 'PowerShell': return `${W.run} ${String(inp.description || inp.command || '').replace(/\s+/g, ' ').slice(0, 70)}`;
      case 'Agent': case 'Task': return `${W.agent} ${String(inp.description || '').slice(0, 60)}`;
      case 'WebFetch': case 'WebSearch': return `${name === 'WebFetch' ? W.fetch : W.search} ${String(inp.url || inp.query || '').slice(0, 60)}`;
      case 'AskUserQuestion': return W.ask;
      default: return `${name} ${summ(inp).slice(0, 60)}`;
    }
  } catch { return name; }
}

// ── 1.8.3: UI 텍스트 사전 (vibeManager.language: en 기본 / ko) ──
const UI = {
  tab_claude: ['Claude', 'Claude'], tab_log: ['Log', 'Log'], tab_task: ['Task Log', 'Task Log'], tab_status: ['UI Status', 'UI Status'], tab_flow: ['FLOW', 'FLOW'], tab_hist: ['History', 'History'],
  send: ['📤 Send (Ctrl+Enter)', '📤 전송 (Ctrl+Enter)'], sending: ['⌛ Responding…', '⌛ 응답 중…'], stop: ['⏹️ Stop', '⏹️ 중지'], clear: ['🧹 Clear', '🧹 지우기'], attach: ['📎 Attach', '📎 첨부'],
  noid: ['(no ID)', '(ID 없음)'], mode_auto: ['🤖 Auto (accept edits)', '🤖 자동 (수용)'], mode_manual: ['🖐️ Manual', '🖐️ 수동'], mode_plan: ['📋 PLAN', '📋 PLAN'], mode_bypass: ['🔓 Auto-approve (all)', '🔓 자동승인 (전부허용)'],
  model_default: ['Default (Claude Code /model · settings)', '기본 (Claude Code /model·settings)'], model_default_set: ['Default (setting: ', '기본 (설정: '], model_custom: ['✏️ Enter model…', '✏️ 직접 입력…'], inuse: ['in use', '사용중'], after_send: ['(shown after first send)', '(전송 후 표시)'],
  remote: ['📱 Remote', '📱 원격'], nosess: ['no session', '세션 없음'], sess: ['session ', '세션 '], newsess: ['🔄 New Session', '🔄 새 세션'], newwin: ['➕ New Window', '➕ 새 창'], editq: ['✎ quick.json', '✎ quick.json'],
  latest: ['⤓ Latest', '⤓ 최신'], belog: ['☕ BE Log', '☕ BE Log'], felog: ['🎨 FE Log', '🎨 FE Log'], tasklog: ['🧾 Task Log', '🧾 Task Log'],
  ph: ['Prompt — Ctrl+Enter to send · 📎 attach files · screen context is attached automatically when an ID is set · harness is automatic for new-UI/GAP work', '프롬프트 — Ctrl+Enter 전송 · 📎 파일 첨부 · 화면ID 있으면 그 화면 컨텍스트가 자동 첨부 · 신규 UI/GAP 작업은 하네스 자동'],
  chat_hint: ['Send a prompt — Claude replies and tool use appear here (session kept).', '프롬프트를 보내면 Claude 응답·도구 사용이 여기 표시됩니다 (세션 유지).'], flow_hint: ['Loads when the FLOW tab is opened…', 'FLOW 탭 선택 시 자동 로드됩니다…'], hist_hint: ['Loads when the History tab is opened…', 'History 탭 선택 시 자동 로드됩니다…'],
  st_pick: ['Set a screen ID to see its progress, gates and outputs here.', '화면ID 를 입력하면 그 화면의 단계 현황·산출물이 여기 나옵니다.'], st_progress: ['Progress', '진행률'], st_stages: ['stages done', '단계 완료'], st_dod: ['DoD', 'DoD'], st_fe: ['FE Gate', 'FE 게이트'], st_pkg: ['PKG Gate', 'PKG 게이트'], st_gap: ['GAP open', 'GAP 미반영'], st_e2e: ['E2E', 'E2E'],
  st_notrun: ['not run', '미실행'], st_nospec: ['no spec', '스펙 없음'], st_items: ['items', '건'], st_outputs: ['Outputs', '산출물'], st_docs: ['Documents', '문서'], st_recent: ['Recent work', '최근 작업'], st_none: ['none', '없음'], st_changed: ['changed', '변경'], st_open: ['open', '진행중'], st_pipeline: ['Last pipeline', '마지막 파이프라인'],
  tb: [{ reload: 'Reload', edit: 'Edit', view: 'View', save: 'Save', editor: 'Open in editor', os: 'Open with OS', close: 'Close tab' }, { reload: '새로고침', edit: '편집', view: '보기', save: '저장', editor: '에디터로', os: 'OS 로 열기', close: '탭 닫기' }],
  bd: [{ step: 'Step', tools: 'tools', edits: 'edits', elapsed: 'elapsed', running: 'Running', done: 'Done', error: 'Error', stopped: 'Stopped', prep: 'Prep', final: 'Final report', optional: 'optional', warn: 'Done w/ warnings', fs: { RUN: 'running', OK: 'done', FAIL: 'failed', WARN: 'warning', CANCEL: 'cancelled', NOT_RUN: 'not run', WAIT: 'waiting' }, k: { read: 'Read', edit: 'Edit', run: 'Run', find: 'Search', agent: 'Agent', web: 'Web', other: 'Tool' } },
       { step: 'Step', tools: '도구', edits: '수정', elapsed: '경과', running: '진행 중', done: '완료', error: '오류', stopped: '중지', prep: '준비', final: '최종 보고', optional: '선택', warn: '경고 포함 완료', fs: { RUN: '진행 중', OK: '완료', FAIL: '실패', WARN: '경고', CANCEL: '취소', NOT_RUN: '미실행', WAIT: '대기' }, k: { read: '읽기', edit: '수정', run: '실행', find: '검색', agent: '에이전트', web: '웹', other: '도구' } }],
  st_menu: ['Menu', '메뉴'], st_page: ['Page', '페이지'], st_click: ['Click a stage to run it', '단계를 누르면 실행됩니다'],
};
const t = (p, k) => (UI[k] || [k, k])[(p && p.language) === 'ko' ? 1 : 0];
const STAGE_EN = { pack: '1 Parse', docs: '2 Docs', xlsx: '2x Excel', gap: '3 GAP', gen: '4 Build', gate: '5 Gate', repair: '6 Repair', pkg: '7 PKG', reg: '8 Reg SQL', e2e: '9 E2E', smoke: '9 Smoke', crud: '10 CRUD', auth: '11 Auth', authcrud: '12 Auth×CRUD' };
// 1.8.8: UI Status 의 테스트 타일 4종(단계 키 → 라벨)
const E2E_TILES = [['smoke', 'Smoke', 'Smoke'], ['crud', 'CRUD', 'CRUD'], ['auth', 'Auth', '권한'], ['authcrud', 'Auth×CRUD', '권한별 CRUD']];

// ── 화면 현황(UI Status) — 1.8.3 대시보드 ──
function statusHtml(p, id) {
  if (!id) return `<div class="hint">${t(p, 'st_pick')}</div>`;
  const s = flow.stageStatus(Object.assign({}, p, { pageDirOf: () => '' }), id); const g = path.join(p.genDir, id);
  const rd = f => { try { return fs.readFileSync(f, 'utf8'); } catch { return ''; } };
  // 화면명·메뉴 경로 (운영 메뉴 CSV)
  let name = '', mpath = '';
  try {
    const rows = rd(path.join(p.tobeOutDir, 'db', 'menu.csv')).replace(/^﻿/, '').split(/\r?\n/).filter(Boolean).map(l => l.split(','));
    const h = rows[0] || []; const ix = k => h.indexOf(k); const byId = new Map(rows.slice(1).map(r => [r[ix('mnu_id')], r]));
    const me = byId.get(id); if (me) { name = me[ix('mnu_desc')] || ''; const chain = []; let cur = me, seen = new Set(); while (cur && !seen.has(cur[ix('mnu_id')])) { seen.add(cur[ix('mnu_id')]); chain.unshift(cur[ix('mnu_desc')] || cur[ix('mnu_id')]); cur = byId.get(cur[ix('uppr_mnu_id')]); } mpath = chain.join(' › '); }
  } catch { }
  let pageRel = ''; try { const r = JSON.parse(rd(path.join(g, 'register.json'))); pageRel = `features/${r.feature}/src/pages/${r.pageDir}`; } catch { }
  const dod = /(\d+)\/(\d+) 충족/.exec(rd(path.join(g, 'DOD.md'))); const fe = /BLOCK (\d+) \/ WARN (\d+)/.exec(rd(path.join(g, 'CHECK.md'))); const pk = /BLOCK (\d+) \/ WARN (\d+)/.exec(rd(path.join(g, 'CHECK_PKG.md')));
  let gapOpen = null, gapTot = 0; try { const gl = rd(path.join(p.gapDir, `${id}_gap.csv`)).split(/\r?\n/).filter(Boolean); if (gl.length > 1) { const h = gl[0].split(','); const si = h.indexOf('status'); gapTot = gl.length - 1; gapOpen = gl.slice(1).filter(l => /MISSING|UNMAPPED/.test((l.split(',')[si] || ''))).length; } } catch { }
  const stages = flow.STAGES; const done = stages.filter(st => s[st.key] === 'ok').length; const pct = Math.round(done / stages.length * 100);
  const tile = (label, value, sub, cls) => `<div class="kpi ${cls || ''}"><div class="kv">${value}</div><div class="kl">${label}</div>${sub ? `<div class="ks">${sub}</div>` : ''}</div>`;
  const kpis = [
    tile(t(p, 'st_progress'), `${pct}%`, `${done}/${stages.length} ${t(p, 'st_stages')}`, pct === 100 ? 'ok' : pct ? 'mid' : ''),
    tile(t(p, 'st_dod'), dod ? `${dod[1]}/${dod[2]}` : '–', dod ? '' : t(p, 'st_notrun'), dod ? (dod[1] === dod[2] ? 'ok' : 'mid') : ''),
    tile(t(p, 'st_fe'), fe ? `B ${fe[1]} · W ${fe[2]}` : '–', fe ? '' : t(p, 'st_notrun'), fe ? (fe[1] === '0' ? 'ok' : 'bad') : ''),
    tile(t(p, 'st_pkg'), pk ? `B ${pk[1]} · W ${pk[2]}` : '–', pk ? '' : t(p, 'st_notrun'), pk ? (pk[1] === '0' ? 'ok' : 'bad') : ''),
    tile(t(p, 'st_gap'), gapOpen == null ? '–' : String(gapOpen), gapOpen == null ? t(p, 'st_notrun') : `/ ${gapTot} ${t(p, 'st_items')}`, gapOpen == null ? '' : (gapOpen === 0 ? 'ok' : 'bad')),
    // 1.8.8: 테스트 4단계 타일 — 결과 있음 n/m(ok/bad) · 스펙만 있음 '미실행' · 스펙 없음 '–'
    ...E2E_TILES.map(([k, en, ko2]) => { const st = s[k] || 'none', n = s[k + 'N']; return tile(`E2E ${p.language === 'ko' ? ko2 : en}`, n || '–', n ? '' : (st === 'warn' ? t(p, 'st_notrun') : t(p, 'st_nospec')), n ? (st === 'ok' ? 'ok' : st === 'warn' ? 'mid' : 'bad') : ''); }),
  ].join('');
  const SYM = { ok: '✓', warn: '◐', bad: '✖', none: '' };
  const stepper = stages.map(st => { const stt = s[st.key] || 'none'; const lbl = p.language === 'ko' ? st.label : (STAGE_EN[st.key] || st.label); return `<div class="stp ${stt}" data-task="${esc(st.task || '')}" title="${esc(lbl)}${s[st.key + 'N'] ? ' — ' + esc(s[st.key + 'N']) : ''}"><span class="dot">${SYM[stt] || ''}</span><span class="sl">${esc(lbl)}</span>${s[st.key + 'N'] ? `<span class="sn">${esc(s[st.key + 'N'])}</span>` : ''}</div>`; }).join('<span class="stc"></span>');
  const ko = p.language === 'ko';
  const files = [['PIPELINE.md', ko ? '🛤️ 파이프라인' : '🛤️ Pipeline'], ['DOD.md', '✔️ DoD'], ['CHECK.md', ko ? '🚧 FE 게이트' : '🚧 FE Gate'], ['REPAIR.md', ko ? '🔧 FE 수선' : '🔧 FE Repair'], ['CHECK_PKG.md', ko ? '🧱 PKG 게이트' : '🧱 PKG Gate'], ['REPAIR_PKG.md', ko ? '🔗 PKG 이식' : '🔗 PKG Port'], ['GEN_NOTES.md', ko ? '📝 생성 노트' : '📝 Gen Notes'], [`${id}_registration.sql`, ko ? '✅ 등록 SQL' : '✅ Registration SQL'], [`${id}_PKG.sql`, '📦 PKG'], [`${id}_revert.sql`, ko ? '↩️ 되돌리기' : '↩️ Revert']].filter(([f]) => fs.existsSync(path.join(g, f)));
  const pack = path.join(p.outDir, 'screens', id, `${id}_summary.md`); const agent = path.join(p.outDir, 'agent', id); const docs = fs.existsSync(agent) ? fs.readdirSync(agent).filter(f => /\.md$/.test(f) && !/^_/.test(f)) : [];
  // Excel 문서: 팀 폴더(화면설계서·화면분석서·단위테스트) + 구 documents 폴더
  const xlsx = [];
  for (const [dir, icon] of [[path.join(p.root, 'Doc', '화면설계서'), '📘'], [path.join(p.root, 'Doc', '화면분석서'), '📗'], [path.join(p.root, 'Doc', '단위테스트'), '🧪'], [path.join(p.root, 'Doc', 'documents', id), '📄']]) {
    try { for (const f of fs.readdirSync(dir)) if (/\.xlsx$/i.test(f) && f.toUpperCase().startsWith(id)) xlsx.push([path.join(dir, f), `${icon} ${f.replace(/\.xlsx$/i, '')}`]); } catch { }
  }
  const hist = history.list(p).filter(h => h.id === id).slice(0, 8);
  const chip = (href, label, attr = 'data-f') => `<a class="chip" ${attr}="${esc(href)}">${esc(label)}</a>`;
  return `<div class="dash">
    <div class="dhead"><div class="did">${esc(id)}</div><div class="dmeta"><div class="dname">${esc(name || '')}</div><div class="dsub">${mpath ? `${t(p, 'st_menu')}: ${esc(mpath)}` : ''}${pageRel ? `${mpath ? ' · ' : ''}${t(p, 'st_page')}: ${esc(pageRel)}` : ''}</div></div></div>
    <div class="kpis">${kpis}</div>
    <div class="dcard"><div class="dct">${ko ? '단계' : 'Stages'} <span class="hint">· ${t(p, 'st_click')}</span>${s.pipeline ? `<span class="hint" style="margin-left:auto">${t(p, 'st_pipeline')}: ${esc(s.pipeline)}</span>` : ''}</div><div class="stepper">${stepper}</div></div>
    <div class="dcols">
      <div class="dcard"><div class="dct">📂 ${t(p, 'st_outputs')}</div><div class="chips">${fs.existsSync(pack) ? chip(pack, ko ? '📜 Fact Pack 요약' : '📜 Fact Pack summary') : ''}${files.map(([f, l]) => chip(path.join(g, f), l)).join('')}${!files.length && !fs.existsSync(pack) ? `<span class="hint">${t(p, 'st_none')}</span>` : ''}</div></div>
      <div class="dcard"><div class="dct">📚 ${t(p, 'st_docs')} <span class="hint">· MD ${docs.length} · Excel ${xlsx.length}</span></div><div class="chips">${docs.map(f => chip(path.join(agent, f), f.replace('.md', ''))).join('')}${xlsx.map(([f, l]) => chip(f, l, 'data-open')).join('')}${!docs.length && !xlsx.length ? `<span class="hint">${t(p, 'st_none')}</span>` : ''}</div></div>
    </div>
    <div class="dcard"><div class="dct">🕒 ${t(p, 'st_recent')}</div>${hist.length ? `<div class="tl">${hist.map(h => `<div class="tli"><span class="tlt">${esc(history.fmtLocal(h.start).slice(5, 16))}</span><a data-hist="${esc(h.dir)}">${esc(h.task)}</a><span class="tln ${h.exit === 0 ? 'ok' : (h.end ? 'bad' : '')}">${h.changed ? `${t(p, 'st_changed')} ${h.changed.length}` : t(p, 'st_open')}</span></div>`).join('')}</div>` : `<div class="hint">${t(p, 'st_none')}</div>`}</div>
  </div>`;
}

// ── 1.7.9: 포트 점유자 조회 (Windows: netstat → tasklist · 그 외: lsof) — 없으면 '' ──
// 1.8.1: 점유자 상세 {pid,name} — Finish(종료) 기능이 PID 로 종료하기 위해 분리. portOwner() 는 표시용 문자열.
function portOwnerInfo(port) {
  try {
    if (process.platform === 'win32') {
      const ns = cp.execSync(`netstat -ano -p tcp | findstr /R /C:":${port} .*LISTENING"`, { encoding: 'utf8', windowsHide: true, timeout: 8000 });
      const m = /LISTENING\s+(\d+)\s*$/m.exec(ns); if (!m) return null;
      const pid = Number(m[1]); let name = '';
      try { const tl = cp.execSync(`tasklist /FI "PID eq ${pid}" /FO CSV /NH`, { encoding: 'utf8', windowsHide: true, timeout: 8000 }); name = (tl.split(',')[0] || '').replace(/"/g, '').trim(); } catch { }
      return { pid, name: name || 'PID' };
    }
    const o = cp.execSync(`lsof -iTCP:${port} -sTCP:LISTEN -P -n | tail -n +2`, { encoding: 'utf8', timeout: 8000 }).trim();
    if (!o) return null; const f = o.split(/\s+/); return { pid: Number(f[1]), name: f[0] };
  } catch { return null; }
}
// 종료 금지 프로세스 — VPN/보안 에이전트(종료 시 사내망 끊김: 2026 메모 F5FltSrv) · 시스템
const PROTECTED_PROC = /^(F5FltSrv|f5fpclientW|BIGIPEdge|svchost|System|lsass|csrss|wininit|services|explorer|Code|vpnagent|vpnui|GlobalProtect|PanGPS|NordVPN|openvpn)/i;
function killTree(pid) {
  if (!pid) return false;
  try {
    if (process.platform === 'win32') {
      const r = cp.spawnSync('taskkill', ['/PID', String(pid), '/T', '/F'], { encoding: 'utf8', windowsHide: true, timeout: 15000 });
      if (r.status === 0) return true;
      // taskkill 이 막힌 환경(정책) → PowerShell Stop-Process 로 재시도(자식 포함)
      const ps = `Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq ${pid} } | ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }; Stop-Process -Id ${pid} -Force -ErrorAction Stop`;
      const r2 = cp.spawnSync('powershell', ['-NoProfile', '-Command', ps], { encoding: 'utf8', windowsHide: true, timeout: 20000 });
      return r2.status === 0;
    }
    try { process.kill(-pid, 'SIGTERM'); } catch { process.kill(pid, 'SIGTERM'); } return true;
  } catch { return false; }
}
function portOwner(port) {
  const i = portOwnerInfo(port); return i ? `${i.name} ${i.pid}` : '';
}
// ── WB 클래스: 패널 하나의 독립 상태 ──
class WB {
  constructor(api) {
    this.api = api;
    this.inst = ++instSeq;
    this.panel = null;
    this.claudeProc = null;
    this.claudeSession = null;
    this.procs = new Map();  // id → {child, label}
    this.attached = [];       // {path, name, isImage}
  }
  stateKey() { return this.inst === 1 ? 'vibe.wb.state' : `vibe.wb.state.${this.inst}`; }
  getState() {
    // 1.6: ctx/harness 체크박스는 UI 에서 제거되었지만 workspaceState 하위호환을 위해 그대로 둔다(없어도 로직 영향 없음).
    //   신규 필드: permissionMode (default = 설정 defaultPermissionMode), model ('' = 전역 설정 사용).
    //   1.7.1: 기본 모드 = VS Code 설정 vibeManager.defaultPermissionMode (기본 bypassPermissions = 자동승인).
    //   예전 버전이 저장해 둔 permissionMode('acceptEdits')는 permVer<2 이면 버리고 설정값을 따른다.
    const def = { id: this.api.ctx.workspaceState.get('vibeManager.lastId', ''), ctx: true, harness: false, permissionMode: this.api.paths().permissionMode, model: '', permVer: 2 };
    const saved = Object.assign({}, this.api.ctx.workspaceState.get(this.stateKey()) || {});
    if (saved.permVer !== 2) delete saved.permissionMode;
    return Object.assign(def, saved, { permVer: 2 });
  }
  setState(s) { this.api.ctx.workspaceState.update(this.stateKey(), s); }
  post(m) { if (this.panel) try { this.panel.webview.postMessage(m); } catch { } }
  out(stream, text, cls) { this.post({ type: 'out', stream, text: String(text), cls: cls || '' }); }
  updateBusy() {
    const labels = [...this.procs.values()].map(x => x.label);
    this.post({ type: 'busy', procs: this.procs.size, claude: !!this.claudeProc, labels });
  }

  spawnStream(p, cmd, args, opts, stream, label) {
    const id = ++seq; const logDir = path.join(p.vibeDir, 'logs'); fs.mkdirSync(logDir, { recursive: true });
    const logF = path.join(logDir, `${history.nowLocal().slice(0, 19).replace(/[:.]/g, '-')}_${(label || 'run').replace(/[^\w.-]/g, '_')}.log`); // 1.8.2: 로컬 시간
    this.out(stream, `▶ ${label || cmd} \n  $ ${cmd} ${args.join(' ')}\n`, 'cmd');
    const child = cp.spawn(cmd, args, Object.assign({ cwd: p.root, shell: process.platform === 'win32', env: Object.assign({}, process.env, opts && opts.env || {}) }, opts && opts.spawn || {}));
    this.procs.set(id, { child, label });
    this.post({ type: 'proc', id, label, state: 'start' }); this.updateBusy();
    const ws = fs.createWriteStream(logF); let buf = '';
    const onLine = opts && typeof opts.onLine === 'function' ? opts.onLine : null; // 1.7.9: 줄 단위 콜백(서버 기동 완료 감지 등)
    const onData = d => { const t = d.toString('utf8'); ws.write(t); buf += t; const lines = buf.split(/\r?\n/); buf = lines.pop(); for (const ln of lines) { this.out(stream, ln + '\n'); if (onLine) try { onLine(ln); } catch { } } };
    child.stdout.on('data', onData); child.stderr.on('data', onData);
    if (opts && opts.input != null) { child.stdin.write(opts.input); child.stdin.end(); }
    return new Promise(res => child.on('close', code => {
      if (buf) this.out(stream, buf + '\n');
      ws.end(); this.procs.delete(id);
      this.post({ type: 'proc', id, label, state: 'end', code }); this.updateBusy();
      this.out(stream, `■ 종료 exit ${code} — 로그 ${path.relative(p.root, logF)}\n`, code === 0 ? 'ok' : 'bad');
      res(code);
    }));
  }

  // 1.7.9: 서버 기동 = 스트리밍 + 완료 감지 (quick.json: ready 정규식 · port · readyTimeoutSec)
  //   완료 로그 매치 → ✅ 기동 완료(초) 출력 + VS Code 알림 · 완료 전 종료 → ✖ 기동 실패 + 마지막 출력 · 시간 초과 → ⚠ 안내(포트 LISTEN 이면 완료로 간주)
  //   1.9.6: Promise<{ok,sec}> 반환 — 기동 완료/실패/시간초과 시 한 번 resolve (E2E 선행 자동 기동이 기다린다)
  startServerStream(p, it, cwd, name) {
    const t0 = Date.now(); let ready = false; let timer = null; const tail = [];
    const re = it.ready ? new RegExp(it.ready) : null;
    let settle = null; const result = new Promise(r => { settle = r; });
    const done = (ok, msg) => {
      if (ready) return; ready = true; if (timer) clearTimeout(timer);
      const sec = Math.round((Date.now() - t0) / 1000); try { settle({ ok, sec, msg }); } catch { }
      const sstream = it.port === 8080 || /\bBE\b/i.test(name) ? 'be' : it.port === 5173 || /\bFE\b/i.test(name) ? 'fe' : 'task';
      this.out(sstream, `${ok ? '✅' : '✖'} ${name} ${msg} (${sec}s)${it.hint ? ' — ' + it.hint.split(' · ')[0] : ''}\n`, ok ? 'ok' : 'bad');
      this.post({ type: 'chat', role: 'meta', text: `${ok ? '✅' : '✖'} ${name} ${msg} (${sec}s)` });
      this.post({ type: 'server', name, ok, sec });
      if (ok) vscode.window.showInformationMessage(`Vibe_Manager ✅ ${name} 기동 완료 (${sec}s)${it.port ? ` · 포트 ${it.port}` : ''}`);
      else Promise.resolve(vscode.window.showWarningMessage(`Vibe_Manager ✖ ${name} ${msg.split('\n')[0]}`, 'Log 보기')).then(a => { if (a) this.post({ type: 'showTab', tab: 'logs' }); }, () => { });
    };
    const onLine = ln => {
      tail.push(ln); if (tail.length > 8) tail.shift();
      if (!ready && re && re.test(ln)) done(true, '기동 완료');
      if (!ready && /Port \d+ was already in use|Address already in use|EADDRINUSE/.test(ln)) done(false, `기동 실패 — 포트 ${it.port || ''} 사용 중`);
      if (!ready && /is not recognized as an internal or external command|cannot find the path|could not find or load main class/i.test(ln)) done(false, `기동 실패 — 명령 실행 불가: ${ln.trim().slice(0, 120)}`);
    };
    const to = Number(it.readyTimeoutSec || 0);
    if (to > 0 && re) timer = setTimeout(() => {
      if (ready) return;
      if (it.port && portOwner(it.port)) { done(true, `포트 ${it.port} LISTEN 확인(완료 로그는 미출력)`); return; }
      this.out('task', `⚠ ${name} ${to}초 안에 완료 로그('${it.ready}')가 보이지 않습니다 — 작업 출력 확인\n`, 'warn');
      this.post({ type: 'chat', role: 'meta', text: `⚠ ${name} ${to}초 경과 — 완료 로그 미확인` });
      try { settle({ ok: false, sec: to, msg: '시간 초과(완료 로그·포트 미확인)', timeout: true }); } catch { }
    }, to * 1000);
    // 1.8.0: 서버 출력은 Log 탭의 BE Log / FE Log 창으로 (포트 8080/5173 또는 이름의 BE/FE 로 판별)
    const stream = it.port === 8080 || /\bBE\b/i.test(name) ? 'be' : it.port === 5173 || /\bFE\b/i.test(name) ? 'fe' : 'task';
    try { this.post({ type: 'showTab', tab: stream === 'task' ? 'log' : 'logs' }); } catch { }
    this.spawnStream(p, 'cmd', ['/c', it.cmd], { spawn: { cwd }, onLine }, stream, name).then(code => {
      if (!ready) done(false, `기동 실패 — exit ${code}${tail.length ? '\n   ' + tail.filter(x => x.trim()).slice(-4).join('\n   ') : ''}`);
      else { this.post({ type: 'chat', role: 'meta', text: `■ ${name} 종료 (exit ${code})` }); }
    });
    return result;
  }

  // 1.9.6: E2E 선행 — BE(8080)/FE(5173) 가 LISTEN 이 아니면 quick.json 의 ☕ BE Start / 🎨 FE Start 항목으로 먼저 기동하고 완료를 기다린다(사용자 지시 2026-10-21).
  //   둘 다 동시에 기동 · 완료 로그(ready) 또는 포트 LISTEN 으로 판정 · 이미 이 워크벤치가 띄운 중이면 포트가 열릴 때까지만 대기(readyTimeoutSec).
  //   반환 true = 두 포트 모두 LISTEN. false 면 호출자가 E2E 를 실행하지 않는다.
  async ensureServers(p, ports) {
    ports = ports && ports.length ? ports : [8080, 5173];
    const need = ports.filter(pt => !portOwnerInfo(pt));
    const label = pt => pt === 8080 ? 'BE 8080' : pt === 5173 ? 'FE 5173' : `포트 ${pt}`;
    if (!need.length) { this.out('task', `🔌 선행 확인 — ${ports.map(label).join(' · ')} 기동 중(LISTEN)\n`, 'ok'); return true; }
    const all = promptPanel.loadQuick(p.extDir, p.root).groups.flatMap(g => g.items);
    this.out('task', `🔌 선행 확인 — ${need.map(label).join(' · ')} 미기동 → 먼저 기동합니다 (완료까지 대기 · BE 약 80초)\n`, 'warn');
    this.post({ type: 'chat', role: 'meta', text: `🔌 E2E 선행: ${need.map(label).join(' · ')} 미기동 → 자동 기동 중 …` });
    const waitPort = (pt, sec) => new Promise(res => { const t1 = Date.now(); const tick = () => { if (portOwnerInfo(pt)) return res(true); if (Date.now() - t1 > sec * 1000) return res(false); setTimeout(tick, 2000); }; tick(); });
    const jobs = need.map(pt => {
      const it = all.find(x => x.kind === 'terminal' && Number(x.port) === pt);
      if (!it) { this.out('task', `⛔ ${label(pt)} 기동 항목(kind terminal · port ${pt})이 quick.json 에 없습니다\n`, 'bad'); return Promise.resolve(false); }
      const name = it.name || it.label; const cwd = substQ(it.cwd, { root: p.root });
      if (!fs.existsSync(cwd)) { this.out('task', `⛔ ${name} 폴더 없음: ${cwd}\n`, 'bad'); return Promise.resolve(false); }
      if ([...this.procs.values()].some(x => x.label === name)) { this.out('task', `⏳ ${name} 이미 기동 중 — 포트 ${pt} 가 열릴 때까지 대기\n`, 'warn'); return waitPort(pt, Number(it.readyTimeoutSec || 300)); }
      return this.startServerStream(p, it, cwd, name).then(r => (r && r.ok) || !!portOwnerInfo(pt));
    });
    const rs = await Promise.all(jobs);
    // 완료 로그 직후 포트가 열리기까지 잠깐 걸릴 수 있어 짧게 재확인
    for (const pt of need) if (!portOwnerInfo(pt)) await waitPort(pt, 10);
    const missing = ports.filter(pt => !portOwnerInfo(pt));
    if (rs.every(Boolean) && !missing.length) { this.out('task', `✅ 선행 완료 — ${ports.map(label).join(' · ')} LISTEN\n`, 'ok'); this.post({ type: 'chat', role: 'meta', text: `✅ E2E 선행: ${need.map(label).join(' · ')} 기동 완료` }); return true; }
    this.out('task', `✖ 선행 실패 — ${missing.map(label).join(' · ') || '기동 실패'} (BE Log / FE Log 탭 확인) → E2E 를 실행하지 않습니다\n`, 'bad');
    this.post({ type: 'chat', role: 'meta', text: `✖ E2E 선행 실패: ${missing.map(label).join(' · ') || '기동 실패'}` });
    try { vscode.window.showWarningMessage(`Vibe_Manager ✖ E2E 선행 실패 — ${missing.map(label).join(' · ') || '서버 기동 실패'} (BE/FE Log 확인)`); } catch { }
    return false;
  }

  // 1.8.1: 서버 종료(Finish) — ① 포트 점유 프로세스(java/node) 트리 종료 ② 워크벤치가 띄운 같은 이름의 프로세스 트리 종료 ③ 포트 해제까지 대기(최대 20초)
  //   보호: PROTECTED_PROC(VPN 등)·expectProc 밖의 프로세스는 종료하지 않고 안내만.
  async stopServer(p, it, name) {
    const stream = it.port === 8080 || /\bBE\b/i.test(name) ? 'be' : it.port === 5173 || /\bFE\b/i.test(name) ? 'fe' : 'task';
    try { this.post({ type: 'showTab', tab: stream === 'task' ? 'log' : 'logs' }); } catch { }
    const t0 = Date.now(); const expect = new RegExp(`^(${it.expectProc || 'java|node|cmd|powershell|pwsh'})(\\.exe)?$`, 'i');
    let acted = false;
    const occ = it.port ? portOwnerInfo(it.port) : null;
    if (occ) {
      if (PROTECTED_PROC.test(occ.name)) { this.out(stream, `⛔ ${name} 종료 중단 — 포트 ${it.port} 점유 프로세스 ${occ.name}(${occ.pid}) 는 보호 대상(VPN/시스템). 수동 확인 필요.\n`, 'bad'); vscode.window.showErrorMessage(`Vibe_Manager ⛔ ${name}: 포트 ${it.port} 점유자 ${occ.name} 는 종료 금지 대상입니다.`); return; }
      if (!expect.test(occ.name)) { this.out(stream, `⚠ ${name} 종료 보류 — 포트 ${it.port} 점유 프로세스가 예상(${it.expectProc || 'java|node'})과 다름: ${occ.name}(${occ.pid}). 직접 확인 후 종료하세요.\n`, 'warn'); vscode.window.showWarningMessage(`Vibe_Manager ⚠ ${name}: 포트 ${it.port} 점유자 ${occ.name}(${occ.pid}) 가 예상 프로세스가 아니라 종료하지 않았습니다.`); return; }
      this.out(stream, `⏹ ${name} 종료 — 포트 ${it.port} 점유 ${occ.name}(${occ.pid}) 트리 종료 ${killTree(occ.pid) ? '요청됨' : '실패(권한?)'}\n`, 'warn'); acted = true;
    }
    for (const pr of [...this.procs.values()]) if (pr.label === name) { const ok = killTree(pr.child.pid); this.out(stream, `⏹ ${name} 워크벤치 프로세스(PID ${pr.child.pid}) 트리 종료 ${ok ? '요청됨' : (pr.child.exitCode != null || pr.child.killed ? '(이미 종료됨)' : '실패 — 권한 확인')}\n`, 'warn'); acted = true; }
    if (!acted) { this.out(stream, `ℹ ${name} 실행 중 아님 — 포트 ${it.port || '-'} 비어 있음\n`, 'ok'); this.post({ type: 'chat', role: 'meta', text: `ℹ ${name} 실행 중 아님` }); this.post({ type: 'server', name, state: 'stopped', sec: 0 }); return; }
    // 포트 해제 대기
    let freed = !it.port;
    for (let i = 0; it.port && i < 20; i++) { await new Promise(r => setTimeout(r, 1000)); if (!portOwnerInfo(it.port)) { freed = true; break; } }
    const sec = Math.round((Date.now() - t0) / 1000);
    if (freed) { this.out(stream, `✅ ${name} 종료 완료 (${sec}s)${it.port ? ` — 포트 ${it.port} 해제` : ''}\n`, 'ok'); this.post({ type: 'chat', role: 'meta', text: `✅ ${name} 종료 완료 (${sec}s)` }); this.post({ type: 'server', name, state: 'stopped', sec }); vscode.window.showInformationMessage(`Vibe_Manager ✅ ${name} 종료 완료 (${sec}s)`); }
    else { const still = portOwnerInfo(it.port); this.out(stream, `⚠ ${name} 종료 요청 후 ${sec}s — 포트 ${it.port} 아직 점유: ${still ? still.name + ' ' + still.pid : '?'}\n`, 'bad'); vscode.window.showWarningMessage(`Vibe_Manager ⚠ ${name}: 포트 ${it.port} 가 아직 점유 중입니다 (${still ? still.name + ' ' + still.pid : '?'}).`); }
  }

  stopAll() {
    for (const [, pr] of this.procs) try { if (process.platform === 'win32') cp.spawn('taskkill', ['/pid', String(pr.child.pid), '/T', '/F']); else pr.child.kill('SIGTERM'); } catch { }
    if (this.claudeProc) try { if (process.platform === 'win32') cp.spawn('taskkill', ['/pid', String(this.claudeProc.pid), '/T', '/F']); else this.claudeProc.kill(); } catch { }
  }

  // 1.8.8: Promise 반환 — 체인(runChain)이 Claude 단계의 종료(코드·is_error)를 기다릴 수 있게. 바쁘면 null
  askClaude(p, prompt, harness) {
    if (this.claudeProc) { vscode.window.showWarningMessage(`워크벤치 #${this.inst}: Claude 가 아직 응답 중입니다 — 중지 후 다시 보내세요.`); return Promise.resolve(null); }
    return new Promise(resolveDone => { let resultError = false;
    // 첨부 파일 → Claude Code 에 @path 토큰으로 전달
    const atPrefix = this.attached.length ? this.attached.map(f => `@${f.path.replace(/\\/g, '/')}`).join(' ') + '\n' : '';
    const full = atPrefix + prompt;
    this.post({ type: 'chat', role: 'user', text: full });
    if (this.attached.length) { this.attached = []; this.post({ type: 'attached', files: [] }); }
    const env = Object.assign({}, process.env, harness ? { VIBE_HARNESS: '1', NSCM_SKIP_RULE_READ: '1' } : {});
    const s = this.getState();
    // 1.7.2: 모델 드롭다운 복원 — permissionMode·model 세션별 override ('' = 전역 설정/CLI 기본).
    const overrides = { permissionMode: s.permissionMode || p.permissionMode, model: s.model || '' };
    // 1.7.5: p.claude = 자동 선택된 최신 CLI 전체 경로 — shell 실행이므로 공백 경로 인용
    // 1.8.0: Claude 프롬프트(🛠️/🧯/💬 보완 포함)도 작업 전·후 스냅샷 — 화면ID 가 있을 때 FE 페이지 + DB 객체(both)
    let hdir = null; try { const sid = (s.id || '').toUpperCase(); if (sid) hdir = history.begin(Object.assign({}, p, { pageDirOf: this.api.pageDirOf }), sid, 'claude', prompt.replace(/\s+/g, ' ').slice(0, 140), 'both'); } catch { }
    const child = cp.spawn(/\s/.test(p.claude) ? `"${p.claude}"` : p.claude, claudeArgs(p, this.claudeSession, overrides), { cwd: p.root, shell: process.platform === 'win32', env });
    this.claudeProc = child; this.post({ type: 'claude', state: 'start' }); this.updateBusy();
    let buf = ''; let any = false;
    const handle = line => {
      let j; try { j = JSON.parse(line); } catch { this.out('claude', line + '\n'); return; }
      if (j.type === 'system' && j.session_id) {
        this.claudeSession = j.session_id;
        this.post({ type: 'session', id: this.claudeSession });
        // 1.7: Claude Code system init 에 model 필드가 있으면 UI 모델 라벨에 즉시 반영 (최신 모델이 자동 노출됨)
        if (j.model) this.post({ type: 'model', name: String(j.model) });
      }
      else if (j.type === 'assistant' && j.message && Array.isArray(j.message.content)) {
        if (j.message.model) this.post({ type: 'model', name: String(j.message.model) });
        for (const c of j.message.content) {
          if (c.type === 'text' && c.text) { any = true; this.post({ type: 'chat', role: 'assistant', text: c.text }); }
          else if (c.type === 'tool_use') {
            // 1.8.4: 할 일 목록(TodoWrite) = Step 총수/현재 Step 의 원천 → 상황판 헤더로. 그 외 도구는 이름·요약을 분리해 Step 카드 안에 묶는다
            if (c.name === 'TodoWrite' && c.input && Array.isArray(c.input.todos)) this.post({ type: 'todos', items: c.input.todos.map(x => ({ content: String(x.content || ''), status: String(x.status || ''), active: String(x.activeForm || '') })) });
            else this.post({ type: 'chat', role: 'tool', name: c.name, text: `${c.name} ${summ(c.input)}`, brief: toolBrief(c.name, c.input, p.language === 'ko') });
          }
        }
      }
      else if (j.type === 'user' && j.message && Array.isArray(j.message.content)) {
        for (const c of j.message.content) if (c.type === 'tool_result') {
          const t = typeof c.content === 'string' ? c.content : Array.isArray(c.content) ? c.content.map(x => x.text || '').join('\n') : '';
          if (t) this.post({ type: 'chat', role: 'result', text: t.length > 1200 ? t.slice(0, 1200) + ` … (+${t.length - 1200})` : t });
        }
      }
      else if (j.type === 'result') {
        if (j.session_id) this.claudeSession = j.session_id; if (j.is_error) resultError = true;
        // 1.8.4: 최종 결과 = 상황판 마감(run done) — 헤더 상태·진행바 100%·최종 보고 펼침
        this.post({ type: 'run', state: 'done', ok: !j.is_error, text: `${j.is_error ? '✖ 오류' : '✓ 완료'} · ${j.num_turns || ''}턴 · ${Math.round((j.duration_ms || 0) / 1000)}s${j.total_cost_usd != null ? ` · ${Number(j.total_cost_usd).toFixed(3)}` : ''}` });
        if (j.is_error && j.result && !any) this.post({ type: 'chat', role: 'assistant', text: String(j.result) });
      }
    };
    const onData = d => { buf += d.toString('utf8'); const lines = buf.split(/\r?\n/); buf = lines.pop(); for (const ln of lines) if (ln.trim()) handle(ln); };
    child.stdout.on('data', onData); child.stderr.on('data', d => this.out('claude', d.toString('utf8')));
    child.stdin.write(full); child.stdin.end();
    child.on('close', code => {
      if (buf.trim()) handle(buf);
      this.claudeProc = null;
      this.post({ type: 'claude', state: 'end', code }); this.updateBusy();
      if (code !== 0 && !any) this.post({ type: 'chat', role: 'meta', text: `claude 종료 코드 ${code} — 이전 세션이 만료됐으면 "새 세션" 후 다시 보내세요` });
      if (hdir) { try { history.finish(Object.assign({}, p, { pageDirOf: this.api.pageDirOf }), hdir, code, 'end'); const n = (JSON.parse(fs.readFileSync(path.join(hdir, 'meta.json'), 'utf8')).changed || []).length; this.post({ type: 'chat', role: 'meta', text: `🕒 수정 이력 저장 — 변경 ${n}개 파일 (이력 탭에서 수정전 ↔ 수정후 비교)` }); } catch { } this.post({ type: 'history', html: history.innerHtml(p, 'screen', '') }); }
      resolveDone({ code, ok: code === 0 && !resultError, error: resultError });
    });
    });
  }

  // 1.9.0: 파일/폴더를 Workbench 탭으로. 바이너리(xlsx 등)는 OS 프로그램, http 는 브라우저. line 이 있으면 그 줄로 스크롤·강조
  openTab(p, file, opts = {}) {
    try {
      const f = path.normalize(String(file || '')); if (!f) return false;
      if (/^https?:\/\//i.test(String(file))) { vscode.env.openExternal(vscode.Uri.parse(String(file))); return true; }
      if (!fs.existsSync(f)) { const msg = `파일/폴더가 없습니다: ${f}`; vscode.window.showWarningMessage(`Vibe_Manager: ${msg}`); this.out('task', msg + '\n', 'bad'); return true; }
      const kind = tabview.kindOf(f);
      if (kind === 'binary') { openWithOS(p, this, f); return true; }
      let imgSrc = ''; if (kind === 'image') { try { imgSrc = String(this.panel.webview.asWebviewUri(vscode.Uri.file(f))); } catch { } }
      const t = tabview.buildTab(f, { root: p.root, line: opts.line || 0, imgSrc });
      if (t.external) { openWithOS(p, this, f); return true; }
      t.meta = t.size != null ? `${t.size < 1024 ? t.size + ' B' : (t.size / 1024).toFixed(1) + ' KB'} · ${history.fmtLocal ? history.fmtLocal(t.mtime, 16) : t.mtime}` : '';
      this.post(Object.assign({ type: 'tab' }, t)); try { this.panel.reveal(undefined, true); } catch { }
      return true;
    } catch (e) { vscode.window.showErrorMessage(`Vibe_Manager: 탭 열기 실패 ${file} — ${e.message}`); return true; }
  }
  openDiffTab(key, title, aText, bText, aLabel, bLabel, sub) {
    this.post({ type: 'tab', key: 'diff:' + key, title: '⇄ ' + title, sub: sub || '', path: '', kind: 'diff', html: tabview.diffHtml(aText, bText, aLabel, bLabel), editable: false, canEditor: false, canOS: false, isDir: false, meta: `${aLabel} ↔ ${bLabel}` });
    try { this.panel.reveal(undefined, true); } catch { }
  }

  // 1.8.8: 체인 실행 — quick 항목 kind 'chain': steps[] 를 순서대로(작업 task / Claude 프롬프트 claude·claudeOf). 실패하면 거기서 멈추고(optional 단계는 계속),
  //   어디까지 됐는지 Task Log + Doc/gen/<ID>/FULLRUN.md 에 남긴다. 단계 내부 확인창(task.confirm)은 체인 시작 확인으로 갈음한다.
  async runChain(p, item, id, harness) {
    const steps = item.steps || []; if (!id) { this.out('task', `⛔ 체인 '${item.label}' 은 화면 ID 가 필요합니다\n`, 'bad'); return; }
    if (!steps.length) { this.out('task', `⛔ 체인 '${item.label}' 에 steps 가 없습니다 (quick.json)\n`, 'bad'); return; }
    const all = promptPanel.loadQuick(p.extDir, p.root).groups.flatMap(g => g.items);
    const t0 = Date.now(); const res = []; let stopped = false;
    const genDir = path.join(p.genDir, id); try { fs.mkdirSync(genDir, { recursive: true }); } catch { }
    const mdPath = path.join(genDir, 'FULLRUN.md');
    const nameOf = st => st.title || (st.task ? `${st.task} ${(this.api.findTask(st.task) || {}).title || ''}`.trim() : (st.claudeOf || 'Claude'));
    const writeMd = (final) => {
      const stamp = history.nowLocal ? history.nowLocal().slice(0, 16).replace('T', ' ') : new Date().toISOString();
      const fail = res.find(r => r.status === 'FAIL' || r.status === 'CANCEL'); const warn = res.some(r => r.status === 'WARN');
      const head = !final ? '⏳ 진행 중' : fail ? `✖ ${fail.no}단계에서 중단 (${fail.name})` : warn ? '⚠ 경고 포함 완료' : '✅ 전부 완료';
      const rows = steps.map((st, i) => { const r = res[i]; return `| ${i + 1} | ${nameOf(st)}${st.optional ? ' (선택)' : ''} | ${r ? r.status : 'NOT_RUN'} | ${r && r.code != null ? r.code : '-'} | ${r ? r.sec + 's' : '-'} |`; });
      const next = fail ? `다음 할 일: ${fail.no}단계 '${fail.name}' 의 원인을 Task Log 에서 확인하고 그 단계 메뉴를 다시 실행 → 이후 단계는 이 체인을 다시 누르면 처음부터(완료 단계는 각 도구가 보존/건너뜀) 진행됩니다.` : (final ? '다음 할 일: UI Status 의 단계·E2E 타일과 Doc/gen/' + id + '/PIPELINE.md · Doc/e2e/results/_summary.md 확인' : '');
      const md = [`# FULLRUN ${id} — ${stamp} ${head}`, '', `체인: ${item.label} · 총 ${Math.round((Date.now() - t0) / 1000)}s`, '', '| # | 단계 | 결과 | exit | 소요 |', '|---|---|---|---|---|', ...rows, '', next, ''].join('\n');
      try { fs.writeFileSync(mdPath, md, 'utf8'); } catch { }
    };
    // 1.8.9: Flow 보드 — Claude 탭에 체인 전체(Step 수·현재 Step·진행바)와 Step 별 상태 카드. 작업 출력은 Task Log 에 그대로 남고 카드에는 최근 줄만
    const fid = ++flowSeq; try { this.panel.reveal(undefined, true); this.post({ type: 'showTab', tab: 'chat' }); } catch { }
    this.post({ type: 'fb', state: 'start', id: fid, title: item.label, screen: id, steps: steps.map((st, i) => ({ no: i + 1, name: nameOf(st), kind: st.task ? 'task' : 'claude', optional: !!st.optional })), md: `Doc/gen/${id}/FULLRUN.md` });
    this.out('task', `\n🚀 체인 시작 — ${item.label} · ${id} · ${steps.length}단계\n`, 'cmd');
    this.api.record(`chain:${item.chainId || item.label}`, id);
    for (let i = 0; i < steps.length; i++) {
      const st = steps[i]; const name = nameOf(st); const no = i + 1;
      if (stopped) { res.push({ no, name, status: 'NOT_RUN', code: null, sec: 0 }); this.post({ type: 'fb', state: 'step', id: fid, no, status: 'NOT_RUN' }); continue; }
      this.out('task', `\n── [${no}/${steps.length}] ${name}\n`, 'cmd'); const s0 = Date.now(); let code = null, cancelled = false;
      this.post({ type: 'fb', state: 'step', id: fid, no, status: 'RUN' });
      if (st.verify) st.verify = Object.assign({}, st.verify, { _since: Date.now() - 1000 });
      try {
        if (st.task) { code = await this.runTaskStreaming(p, st.task, id, { noConfirm: true, inFlow: true, args: st.args || null }); if (code == null) cancelled = true; }
        else {
          const q = st.claudeOf ? all.find(x => x.label === st.claudeOf || x.label_en === st.claudeOf) : null;
          const prompt = st.claude || (q && q.prompt);
          if (!prompt) { this.out('task', `프롬프트 없음: ${st.claudeOf || '(claude)'}\n`, 'bad'); code = 2; }
          else { const r = await this.askClaude(p, substQ(prompt, { root: p.root, id }), harness !== false); code = r ? (r.ok ? 0 : (r.code || 1)) : null; if (!r) cancelled = true; }
        }
      } catch (e) { code = -1; this.out('task', `예외: ${e.message}\n`, 'bad'); }
      // 1.9.5: 단계 결과 검증(verify) — 종료코드 0 이어도 산출물이 없으면 실패로 본다(E2E 가 시작도 못 했는데 '완료' 로 닫힌 SCP0100 사고)
      if (code === 0 && st.verify) { const v = verifyStep(p, st.verify, id); if (!v.ok) { code = 3; this.out('task', `✖ 검증 실패: ${v.why}\n`, 'bad'); } else this.out('task', `✔ 검증: ${v.why}\n`, 'ok'); }
      const sec = Math.round((Date.now() - s0) / 1000); const ok = code === 0;
      const status = cancelled ? 'CANCEL' : ok ? 'OK' : (st.optional ? 'WARN' : 'FAIL');
      res.push({ no, name, status, code, sec });
      this.post({ type: 'fb', state: 'step', id: fid, no, status, code, sec });
      this.out('task', `${ok ? '✅' : status === 'WARN' ? '⚠' : '✖'} [${no}/${steps.length}] ${name} — ${status}${code != null ? ` (exit ${code})` : ''} · ${sec}s\n`, ok ? 'ok' : status === 'WARN' ? 'warn' : 'bad');
      if (status === 'FAIL' || status === 'CANCEL') stopped = true;
      writeMd(false);
    }
    writeMd(true);
    const fail = res.find(r => r.status === 'FAIL' || r.status === 'CANCEL'); const okN = res.filter(r => r.status === 'OK').length; const total = Math.round((Date.now() - t0) / 1000);
    const summary = fail ? `✖ 체인 중단 — ${fail.no}/${steps.length} '${fail.name}' ${fail.status} · 완료 ${okN}단계 · ${total}s` : `✅ 체인 완료 — ${steps.length}단계 중 OK ${okN}${res.some(r => r.status === 'WARN') ? ` · 경고 ${res.filter(r => r.status === 'WARN').length}` : ''} · ${total}s`;
    this.out('task', `\n${summary}\n   → ${path.relative(p.root, mdPath)}\n`, fail ? 'bad' : 'ok');
    this.post({ type: 'fb', state: 'end', id: fid, ok: !fail, warn: res.some(r => r.status === 'WARN'), summary, sec: total });
    try { (fail ? vscode.window.showWarningMessage : vscode.window.showInformationMessage)(`Vibe_Manager ${summary}`); } catch { }
    this.post({ type: 'status', html: statusHtml(p, id) }); this.post({ type: 'flow', html: flow.innerHtml(p, '') });
    return res;
  }

  async runTaskStreaming(p, taskId, id, opts = {}) {
    const api = this.api;
    const task0 = api.findTask(taskId); if (!task0) { this.out('task', `작업 없음: ${taskId}\n`, 'bad'); return null; }
    const task = opts.noConfirm && task0.confirm ? Object.assign({}, task0, { confirm: '' }) : task0;
    if (task.kind === 'claude') {
      const vars0 = await api.collectInputs(task, { id, ids: id }); if (!vars0) return;
      const pf = path.join(p.promptsDir, task.prompt); if (!fs.existsSync(pf)) { this.out('task', `프롬프트 파일 없음: ${pf}\n`, 'bad'); return; }
      const rel = path.relative(p.root, pf).split(path.sep).join('/'); const sid = vars0.inputs.id || vars0.inputs.ids || id;
      this.askClaude(p, `${rel} 를 읽고 그 지시대로 화면 ${sid} 작업을 해주세요.${fs.existsSync(path.join(p.genDir, sid, 'GEN_NOTES.md')) ? ` 메모: Doc/gen/${sid}/GEN_NOTES.md.` : ''} 룰은 tools/VibeManager/rules/10_RULES_KEEP.md 를 따르고, TODO(이식) 지점만 채우고 끝나면 __asis-mapping__.md 상태를 갱신하세요.`, true);
      api.record(task.id, `${rel} ${sid}`); return;
    }
    if (!/^(node|python|powershell|cmd)$/.test(task.kind)) { await api.runTaskById(taskId, { id, ids: id, dir: id ? api.pageDirOf(id) : '' }); return 0; }
    // 1.9.1: 체인 안에서는 선택 입력(mode 등)을 묻지 않고 'auto'(users.json 화면 지정 → 메타 추정)
    const vars = await api.collectInputs(task, Object.assign({ id, ids: id, dir: id ? api.pageDirOf(id) : '' }, opts.inFlow ? { mode: 'auto' } : {})); if (!vars) return null;
    // 1.9.4: 체인 단계가 인자를 직접 지정하면(st.args — 예: pipeline --phase N) 그 인자로 실행
    const extra = Array.isArray(opts.args) && opts.args.length ? opts.args.flatMap(a => { const v = api.subst(a, vars); return /\$\{input:/.test(a) && task.splitArgs ? v.split(/\s+/).filter(Boolean) : (v === '' ? [] : [v]); }) : null;
    if (opts.inFlow) return await this.execShell(p, task, vars, extra, id);
    // 1.8.9: 단일 작업도 1단계 Flow 보드로(체인 밖에서 메뉴/스테퍼로 실행한 경우) — 진행·결과가 텍스트 로그가 아니라 보드에 보이게
    const fid = ++flowSeq; const title = task.title || taskId; const s0 = Date.now();
    this.post({ type: 'fb', state: 'start', id: fid, title, screen: id || '', steps: [{ no: 1, name: title, kind: 'task', optional: false }], md: '' });
    this.post({ type: 'fb', state: 'step', id: fid, no: 1, status: 'RUN' });
    let code = null; try { code = await this.execShell(p, task, vars, null, id); } catch (e) { code = -1; this.out('task', `예외: ${e.message}\n`, 'bad'); }
    const sec = Math.round((Date.now() - s0) / 1000); const ok = code === 0;
    this.post({ type: 'fb', state: 'step', id: fid, no: 1, status: ok ? 'OK' : 'FAIL', code, sec });
    this.post({ type: 'fb', state: 'end', id: fid, ok, warn: false, summary: `${ok ? '✅ 완료' : '✖ 실패'} — ${title}${code != null ? ` (exit ${code})` : ''} · ${sec}s`, sec });
    return code;
  }

  // 1.7.7: 스크립트 실행 본체 — 워크벤치 '작업 출력' 탭에 스트리밍 + 실제 exit code. 확장의 runShell(VS Code 작업 터미널) 도 여기로 위임.
  //   사유: 워크스페이스 터미널 프로파일(-NoExit · shellIntegration off)에서 VS Code 작업이 종료를 못 잡아 exit undefined(✗ 경고)·'실행 중' 고착 (2026-10-19 GAP/E2E).
  async execShell(p, task, vars, extraArgs, id) {
    const api = this.api;
    const script = api.subst(task.script, vars); if (!fs.existsSync(script)) { this.out('task', `스크립트 없음: ${script}\n`, 'bad'); return; }
    const args = extraArgs || api.buildArgs(task, vars); const cwd = api.subst(task.cwd || path.dirname(script), vars);
    try { this.panel.reveal(undefined, true); this.post({ type: 'showTab', tab: 'log' }); } catch { }
    // 1.9.6: E2E(run-e2e.cmd · steps.json requireServers) 는 BE/FE 가 떠 있어야 한다 — 미기동이면 먼저 기동(메뉴·스테퍼·체인 모든 경로가 여기를 지난다)
    if (task.requireServers || /run-e2e\.cmd$/i.test(script)) {
      const ok = await this.ensureServers(p, Array.isArray(task.requireServers) ? task.requireServers.map(Number) : null);
      if (!ok) { api.record(task.id, `(선행 실패 — BE/FE 미기동) ${path.basename(script)} ${args.join(' ')}`); api.afterTask(task.id, 5); return 5; }
    }
    const histId = (vars.inputs.id || (vars.inputs.ids || '').split(/\s+/)[0] || '').toUpperCase(); let hdir = null;
    try { hdir = history.begin(Object.assign({}, p, { pageDirOf: api.pageDirOf }), histId, task.id, `${path.basename(script)} ${args.join(' ')}`); } catch { }
    api.record(task.id, `${path.basename(script)} ${args.join(' ')}`);
    let cmd, a;
    if (task.kind === 'node') { cmd = p.node; a = [script, ...args]; }
    else if (task.kind === 'python') { cmd = p.python || 'python'; a = [script, ...args]; }
    else if (task.kind === 'powershell') { cmd = p.powershell || 'powershell'; a = ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script, ...args]; }
    else { cmd = 'cmd'; a = ['/c', script, ...args]; }
    // 1.7.5: 하네스(repair-loop 등)가 같은 최신 CLI·이 창의 모델 선택을 쓰도록 CLAUDE_BIN/CLAUDE_MODEL 전달
    const cenv = api.claudeEnv ? api.claudeEnv(p, this.getState().model || p.claudeModel) : {};
    const code = await this.spawnStream(p, cmd, a, { spawn: { cwd }, env: cenv }, 'task', task.title);
    if (hdir) try { history.finish(Object.assign({}, p, { pageDirOf: api.pageDirOf }), hdir, code); } catch { }
    api.afterTask(task.id, code);
    this.post({ type: 'status', html: statusHtml(p, histId || id || '') });
    // 작업 종료 후 FLOW/history 탭도 자동 갱신
    this.post({ type: 'flow', html: flow.innerHtml(p, '') });
    this.post({ type: 'history', html: history.innerHtml(p, 'screen', '') });
    return code;
  }
}

// ── HTML ──
function html(wb, p, state) {
  // 1.7.4: 워크벤치 좌측 메뉴 영역 제거(사용자 지시 "메뉴 Layer 없어도 됨") — 전체 메뉴는 사이드바(vibeManager.menu) 하나로.
  //        sidebar 항목 실행은 vibeManager.runQuick → workbench.quick() → onMsg('quick') 경로 그대로.
  // 1.7.2: 모델 드롭다운 — 목록 = 설정 vibeManager.modelList (+ 전역 claudeModel · 세션 선택값이 목록에 없으면 추가)
  const modelList = (p.modelList && p.modelList.length ? p.modelList : []).filter(x => x && x.id).map(x => ({ id: String(x.id), label: String(x.label || x.id) }));
  for (const extra of [p.claudeModel, state.model]) if (extra && !modelList.some(x => x.id === extra)) modelList.push({ id: extra, label: extra });
  const defLabel = p.claudeModel ? `${t(p, 'model_default_set')}${p.claudeModel})` : t(p, 'model_default');
  const modelOpts = `<option value=""${!state.model ? ' selected' : ''}>✴️ ${esc(defLabel)}</option>` +
    modelList.map(x => `<option value="${esc(x.id)}"${state.model === x.id ? ' selected' : ''}>${esc(x.label)}${x.label !== x.id ? ' · ' + esc(x.id) : ''}</option>`).join('') +
    `<option value="__custom__">${t(p, 'model_custom')}</option>`;
  return `<!doctype html><html><head><meta charset="utf-8"><style>
:root{--b:var(--vscode-editorWidget-border,#444)}
*{box-sizing:border-box}
body{font:12px var(--vscode-font-family);color:var(--vscode-foreground);margin:0;height:100vh;display:grid;grid-template-columns:1fr;grid-template-rows:1fr auto;grid-template-areas:"top" "bottom"}
#top{grid-area:top;overflow:hidden;padding:6px 10px;display:flex;flex-direction:column;min-height:0}
#bottom{grid-area:bottom;border-top:1px solid var(--b);padding:6px 10px}

/* 모델 표시 박스 (1.7: 하드코딩 셀렉트 제거 → Claude Code 공식 /model 사용 안내) */
.modelbox{display:inline-flex;align-items:center;gap:4px;padding:2px 8px;border:1px solid var(--b);border-radius:3px;font-size:11px;background:var(--vscode-editorWidget-background,transparent);user-select:text;max-width:220px;overflow:hidden}
.modelbox .mlbl{opacity:.65;font-weight:600}
.modelbox #modelName{font-family:var(--vscode-editor-font-family);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}

/* 오른쪽 상단 탭 (언더라인) */
.rtabs{display:flex;gap:0;margin-bottom:4px;flex-wrap:wrap;align-items:center;border-bottom:1px solid var(--b)}
.rtabs .rtb{background:transparent;color:var(--vscode-foreground);border:0;border-bottom:2px solid transparent;padding:5px 12px;margin:0;cursor:pointer;border-radius:0;font-size:12px;opacity:.65}
.rtabs .rtb:hover{opacity:1}
.rtabs .rtb.on{opacity:1;border-bottom-color:var(--vscode-focusBorder);font-weight:700}
#busy{display:none;align-items:center;gap:6px;margin-left:auto;padding-right:4px;font-size:11px;opacity:.9}
#busy.on{display:inline-flex}
#busy .label{opacity:.75}
.spinner{width:12px;height:12px;border:2px solid var(--vscode-foreground);border-right-color:transparent;border-radius:50%;animation:spin .8s linear infinite;display:inline-block;vertical-align:middle;opacity:.7}
@keyframes spin{to{transform:rotate(360deg)}}
.pulse{display:inline-block;opacity:.6;animation:pulse 1.4s ease-in-out infinite}
@keyframes pulse{0%,100%{opacity:.35}50%{opacity:1}}

/* 일반 버튼 (필 스타일) */
button{background:var(--vscode-button-background);color:var(--vscode-button-foreground);border:0;padding:3px 10px;margin:1px;cursor:pointer;border-radius:3px;font-size:11px}
button.sec{background:var(--vscode-button-secondaryBackground);color:var(--vscode-button-secondaryForeground)}

summary{cursor:pointer;font-weight:600;margin-top:6px}

#log,#chat,#status,#flow,#hist{flex:1;overflow:auto;background:var(--vscode-editor-background);border:1px solid var(--b);padding:6px;white-space:pre-wrap;font-family:var(--vscode-editor-font-family);font-size:12px;min-height:0}
/* 1.8.0: Log 탭 = BE Log | FE Log 2창 · Task Log 탭 */
#logs{flex:1;display:flex;gap:6px;min-height:0}
#logs .logpane{flex:1;display:flex;flex-direction:column;min-width:0;min-height:0}
#logwrap{flex:1;display:flex;flex-direction:column;min-height:0}
.loghead{display:flex;align-items:center;gap:6px;padding:2px 4px;font-size:11px}
.loghead .logttl{font-weight:700}
.loghead .logst{flex:1;opacity:.65;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.loghead .latest{font-size:10px;padding:1px 6px;margin:0}
.logbody{flex:1;overflow:auto;background:var(--vscode-editor-background);border:1px solid var(--b);padding:6px;white-space:pre-wrap;font-family:var(--vscode-editor-font-family);font-size:12px;min-height:0}
#logwrap .loghead .latest{margin-left:auto}
#chat,#status,#flow,#hist{white-space:normal;font-family:var(--vscode-font-family)}
.m{margin:4px 0;padding:4px 6px;border-radius:4px;white-space:pre-wrap}
.m.user{background:var(--vscode-input-background);border-left:3px solid var(--vscode-focusBorder)}
.m.assistant{border-left:3px solid #3fb950}
.m.meta{opacity:.6;font-size:11px}
details.m{padding:3px 6px;background:transparent;opacity:1;max-height:none;overflow:visible}
details.m summary{cursor:pointer;list-style:revert;font-size:11px;opacity:.8;white-space:pre-wrap;font-weight:400}
details.m[open] summary{opacity:1;font-weight:600}
details.m .mb{white-space:pre-wrap;margin-top:4px;max-height:360px;overflow:auto;font-family:var(--vscode-editor-font-family);font-size:11px;background:var(--vscode-textCodeBlock-background,rgba(127,127,127,.08));padding:4px 6px;border-radius:3px}
details.m.tool{border-left:3px solid #d29922}
details.m.result{border-left:3px solid var(--vscode-focusBorder)}
.thinking{display:none;margin:6px 2px;padding:4px 8px;font-size:11px;opacity:.75;border-left:3px solid #d29922}
.thinking.on{display:block}
.thinking .pulse{margin-right:6px}

.cmd{color:#58a6ff}.ok{color:#3fb950}.bad{color:#f85149}.warn{color:#d29922}.none{opacity:.35}
/* 1.8.4: Claude 상황판 (run 보드 + Step 카드) */
.run{margin:6px 0 14px}
details.runq{border-left:3px solid var(--vscode-focusBorder);background:var(--vscode-input-background)}
details.runq summary{font-weight:600;font-size:12px;opacity:1}
.board{border:1px solid var(--b);border-radius:8px;background:var(--vscode-editorWidget-background,transparent);overflow:hidden;margin-top:6px}
.board.running{border-color:#d29922}.board.done{border-color:#3fb950}.board.bad{border-color:#f85149}
/* 1.8.9: 로그용 색상 클래스(.bad/.ok/.warn)가 보드 전체 글자색으로 상속되지 않게 — 상태는 배지·테두리·번호만 */
.board,.board .step,.board .stext,.board .m,.board summary{color:var(--vscode-foreground)}
.board .sbody details.m.tool.bad>summary,.board .bk-st.bad,.board .m.meta.bad{color:#f85149}
.bhead{display:flex;align-items:center;gap:14px;padding:10px 12px;background:linear-gradient(135deg,var(--vscode-button-background) 0%,var(--vscode-editorWidget-background,transparent) 140%)}
.bstep{display:flex;align-items:baseline;font-family:var(--vscode-editor-font-family);min-width:96px;flex:none}
.bstep .bcur{font-size:26px;font-weight:800;line-height:1}.bstep .bsl{font-size:16px;opacity:.6;margin:0 3px}.bstep .btot{font-size:16px;font-weight:600;opacity:.85}.bstep .bsll{font-size:10px;opacity:.65;margin-left:6px}
.bmid{flex:1;min-width:0}
.btitle{font-weight:700;font-size:12px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;min-height:15px}
.bbar{height:6px;border-radius:3px;background:rgba(127,127,127,.25);margin:5px 0 4px;overflow:hidden}.bbar i{display:block;height:100%;width:0;background:#3fb950;transition:width .4s}
.board.running .bbar i{background:#d29922}.board.bad .bbar i{background:#f85149}
.bnow{font-size:11px;opacity:.75;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;min-height:14px}
.bkpis{display:flex;gap:10px;flex:none;align-items:center}
.bk{text-align:center;min-width:44px}.bk b{display:block;font-size:16px;font-family:var(--vscode-editor-font-family);line-height:1.1}.bk span{font-size:10px;opacity:.65}
.bk .bk-st{font-size:11px;padding:3px 9px;border-radius:10px;border:1px solid var(--b);font-family:var(--vscode-font-family)}
.bk-st.running{color:#d29922;border-color:#d29922}.bk-st.done{color:#3fb950;border-color:#3fb950}.bk-st.bad{color:#f85149;border-color:#f85149}
.bsteps{padding:6px 8px;display:flex;flex-direction:column;gap:4px}
details.step{border:1px solid var(--b);border-radius:6px;background:var(--vscode-editor-background)}
details.step>summary{display:flex;align-items:center;gap:8px;padding:6px 8px;cursor:pointer;list-style:none;font-size:12px}
details.step>summary::-webkit-details-marker{display:none}
details.step>summary::before{content:'▸';opacity:.5;font-size:11px;width:8px}details.step[open]>summary::before{content:'▾'}
.step .sno{display:inline-flex;align-items:center;justify-content:center;width:20px;height:20px;border-radius:50%;background:var(--b);font-size:11px;font-weight:700;flex:none}
.step.done .sno{background:#3fb950;color:#fff}.step.running .sno{background:#d29922;color:#fff}.step.bad .sno{background:#f85149;color:#fff}.step.wait{opacity:.6}
.step.running>summary{background:rgba(210,153,34,.08)}
.step .sttl{flex:1;min-width:0;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;font-weight:600}
.step .schips{display:flex;gap:4px;flex:none}.step .sc{font-size:10px;padding:1px 6px;border-radius:9px;border:1px solid var(--b);opacity:.85;white-space:nowrap}
.step .slast{font-size:10px;opacity:.6;max-width:34%;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;flex:none}
.step[open] .slast{display:none}
.sbody{padding:4px 8px 8px 30px;border-top:1px dashed var(--b)}
.stext{white-space:pre-wrap;font-size:12px;margin:4px 0;padding:4px 6px;border-left:3px solid #3fb950}
.sbody details.m.tool{margin:2px 0}
.sbody details.m.tool.bad{border-left-color:#f85149}
.mr{white-space:pre-wrap;margin-top:4px;max-height:260px;overflow:auto;font-family:var(--vscode-editor-font-family);font-size:11px;border-left:2px solid var(--vscode-focusBorder);padding:4px 6px;opacity:.9}
.bfoot{padding:2px 8px 6px}.bfoot .m.meta{margin:2px 0}.bfoot:empty{display:none}
details.bfinal{border-top:1px solid var(--b);padding:6px 10px 8px}
details.bfinal summary{cursor:pointer;font-weight:700;font-size:12px}
/* 1.8.9: Flow 보드(체인·단일 작업) */
.board.fboard .bhead{background:linear-gradient(135deg,rgba(88,166,255,.35) 0%,var(--vscode-editorWidget-background,transparent) 140%)}
.fboard .step .sdur{font-size:10px;opacity:.7;flex:none;font-family:var(--vscode-editor-font-family)}
.fboard .step .slast{max-width:44%}
.ftail{margin:0;padding:4px 6px;max-height:220px;overflow:auto;white-space:pre-wrap;font-family:var(--vscode-editor-font-family);font-size:11px;opacity:.85;background:var(--vscode-textCodeBlock-background,rgba(127,127,127,.08));border-radius:3px}
.ftail:empty{display:none}
.fboard .sbody .run{margin:4px 0 2px}
.fboard .sbody .run .board{margin-top:4px}
/* 1.9.0: Workbench 내부 탭 뷰어 */
.rtabs .rtb.dyn{display:inline-flex;align-items:center;gap:6px;max-width:260px}
.rtabs .rtb.dyn .tl{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.rtabs .rtb.dyn .tx{opacity:.5;font-size:11px;padding:0 2px;border-radius:3px}.rtabs .rtb.dyn .tx:hover{opacity:1;background:var(--vscode-list-hoverBackground)}
.dtab{display:none;flex:1;min-height:0;flex-direction:column;border:1px solid var(--b);background:var(--vscode-editor-background)}
.dtb{display:flex;align-items:center;gap:6px;padding:4px 6px;border-bottom:1px solid var(--b);font-size:11px;background:var(--vscode-editorWidget-background,transparent)}
.dtb .dtp{flex:1;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-family:var(--vscode-editor-font-family);opacity:.8}
.dtb .dtsp{opacity:.6;white-space:nowrap}
.dtb button{font-size:10px;padding:1px 7px;margin:0}
.dtc{flex:1;overflow:auto;padding:8px 12px;white-space:normal;font-family:var(--vscode-font-family)}
.dte{flex:1;min-height:0;width:100%;box-sizing:border-box;resize:none;border:0;padding:8px;font:12px var(--vscode-editor-font-family);background:var(--vscode-editor-background);color:var(--vscode-editor-foreground,var(--vscode-foreground))}
.mdv{max-width:1100px;line-height:1.5;font-size:12.5px}
.mdv h1{font-size:18px;margin:10px 0 8px;padding-bottom:4px;border-bottom:1px solid var(--b)}.mdv h2{font-size:15px;margin:14px 0 6px;padding-bottom:3px;border-bottom:1px solid var(--b)}.mdv h3{font-size:13px;margin:12px 0 4px}.mdv h4,.mdv h5,.mdv h6{font-size:12px;margin:10px 0 4px;opacity:.9}
.mdv p{margin:4px 0 8px}.mdv ul,.mdv ol{margin:2px 0 8px;padding-left:22px}.mdv li{margin:2px 0}
.mdv code{font-family:var(--vscode-editor-font-family);font-size:11.5px;background:var(--vscode-textCodeBlock-background,rgba(127,127,127,.12));padding:0 4px;border-radius:3px}
.mdv pre.mdcode{background:var(--vscode-textCodeBlock-background,rgba(127,127,127,.1));padding:8px 10px;border-radius:4px;overflow:auto;font-size:11.5px;line-height:1.4;white-space:pre}
.mdv pre.mdcode code{background:transparent;padding:0}
.mdv blockquote{margin:6px 0;padding:4px 10px;border-left:3px solid var(--vscode-focusBorder);opacity:.9;background:rgba(127,127,127,.06)}
.mdv hr{border:0;border-top:1px solid var(--b);margin:10px 0}
.mdv a{color:var(--vscode-textLink-foreground,#58a6ff);cursor:pointer;text-decoration:none}.mdv a:hover{text-decoration:underline}.mdv a.pth{opacity:.9;border-bottom:1px dotted currentColor}
.mdtw{overflow:auto;margin:6px 0 10px}.mdt{border-collapse:collapse;font-size:11.5px;min-width:50%}.mdt th,.mdt td{border:1px solid var(--b);padding:3px 8px;vertical-align:top}.mdt th{background:var(--vscode-editorWidget-background,rgba(127,127,127,.12));position:sticky;top:0}.mdt tbody tr:nth-child(even){background:rgba(127,127,127,.05)}.mdtn{font-size:10px;opacity:.5;margin-top:2px}
.okk{color:#3fb950}.badd{color:#f85149}.warnn{color:#d29922}
.csvw,.folderw,.diffw{font-size:11.5px}.csvn{font-size:11px;opacity:.75;margin-bottom:6px;display:flex;gap:8px;align-items:center}.csvf{width:200px;font-size:11px;padding:2px 6px}
table.csvt{border-collapse:collapse;white-space:nowrap}table.csvt th,table.csvt td{border:1px solid var(--b);padding:2px 7px;max-width:520px;overflow:hidden;text-overflow:ellipsis}table.csvt th{position:sticky;top:0;background:var(--vscode-editorWidget-background,#252526);z-index:1;text-align:left}table.csvt td.ln,table.csvt td.num{text-align:right;opacity:.6;font-family:var(--vscode-editor-font-family)}table.csvt td.mono{font-family:var(--vscode-editor-font-family);opacity:.75}table.csvt tbody tr:hover{background:var(--vscode-list-hoverBackground)}
table.csvt.folder a{cursor:pointer;color:var(--vscode-textLink-foreground,#58a6ff)}table.csvt.folder a:hover{text-decoration:underline}.folderw a{cursor:pointer;color:var(--vscode-textLink-foreground,#58a6ff)}
.codew{font-family:var(--vscode-editor-font-family);font-size:11.5px}table.codet{border-collapse:collapse;width:100%}table.codet td{padding:0 8px;vertical-align:top;white-space:pre;line-height:1.45}table.codet td.ln{text-align:right;opacity:.4;user-select:none;width:1%;border-right:1px solid var(--b)}table.codet tr.hl td{background:rgba(210,153,34,.18)}
table.difft tr.dadd td.cd{background:rgba(63,185,80,.15)}table.difft tr.ddel td.cd{background:rgba(248,81,73,.15)}table.difft tr.gap td{text-align:center;opacity:.45;font-size:10px;padding:2px}table.difft tr.ctxh{display:none}.diffw.all table.difft tr.ctxh{display:table-row}.diffw.all table.difft tr.gap{display:none}
.imgw{display:flex;justify-content:center;padding:10px}.imgw img{max-width:100%;border:1px solid var(--b)}
details.bfinal .ft{white-space:pre-wrap;font-size:12px;max-height:420px;overflow:auto;margin-top:6px;padding:6px 8px;border-left:3px solid #3fb950;background:var(--vscode-editor-background)}

/* 1.8.3: UI Status 대시보드 */
.dash{display:flex;flex-direction:column;gap:10px;padding:2px}
.dhead{display:flex;align-items:center;gap:14px;padding:10px 14px;border-radius:8px;background:linear-gradient(135deg,var(--vscode-button-background) 0%,var(--vscode-editorWidget-background,transparent) 140%);color:var(--vscode-foreground)}
.dhead .did{font-size:22px;font-weight:800;letter-spacing:.5px;font-family:var(--vscode-editor-font-family)}
.dhead .dname{font-size:14px;font-weight:600}.dhead .dsub{font-size:11px;opacity:.75;margin-top:2px}
.kpis{display:grid;grid-template-columns:repeat(auto-fit,minmax(118px,1fr));gap:8px}
.kpi{border:1px solid var(--b);border-radius:8px;padding:8px 10px;background:var(--vscode-editorWidget-background,transparent);border-left:4px solid var(--b)}
.kpi .kv{font-size:20px;font-weight:700;line-height:1.1;font-family:var(--vscode-editor-font-family)}.kpi .kl{font-size:11px;opacity:.75;margin-top:2px}.kpi .ks{font-size:10px;opacity:.55}
.kpi.ok{border-left-color:#3fb950}.kpi.mid{border-left-color:#d29922}.kpi.bad{border-left-color:#f85149}
.dcard{border:1px solid var(--b);border-radius:8px;padding:8px 10px;background:var(--vscode-editorWidget-background,transparent)}
.dcard .dct{display:flex;align-items:center;gap:6px;font-weight:700;font-size:12px;margin-bottom:6px}
.dcols{display:grid;grid-template-columns:1fr 1fr;gap:10px}
@media (max-width:900px){.dcols{grid-template-columns:1fr}}
.stepper{display:flex;align-items:center;flex-wrap:wrap;gap:2px}
.stp{display:inline-flex;align-items:center;gap:5px;padding:4px 9px;border-radius:14px;border:1px solid var(--b);cursor:pointer;font-size:11px;white-space:nowrap;background:var(--vscode-editor-background)}
.stp:hover{background:var(--vscode-list-hoverBackground)}
.stp .dot{display:inline-flex;align-items:center;justify-content:center;width:14px;height:14px;border-radius:50%;font-size:9px;background:var(--b)}
.stp.ok{border-color:#3fb950}.stp.ok .dot{background:#3fb950;color:#fff}.stp.warn{border-color:#d29922}.stp.warn .dot{background:#d29922;color:#fff}.stp.bad{border-color:#f85149}.stp.bad .dot{background:#f85149;color:#fff}.stp.none{opacity:.6}
.stp .sn{font-size:10px;opacity:.6}
.stc{display:inline-block;width:10px;height:1px;background:var(--b)}
.chips{display:flex;flex-wrap:wrap;gap:4px}
.chip{display:inline-block;padding:2px 8px;border-radius:10px;border:1px solid var(--b);font-size:11px;cursor:pointer;text-decoration:none;color:var(--vscode-foreground);background:var(--vscode-editor-background)}
.chip:hover{background:var(--vscode-list-hoverBackground)}
.tl{display:flex;flex-direction:column;gap:3px}
.tli{display:flex;align-items:center;gap:8px;font-size:11px;padding:2px 0;border-bottom:1px dotted var(--b)}
.tli .tlt{font-family:var(--vscode-editor-font-family);opacity:.65;min-width:84px}.tli a{cursor:pointer;text-decoration:underline;flex:1}.tli .tln{opacity:.65;font-size:10px}.tli .tln.ok{color:#3fb950}.tli .tln.bad{color:#f85149}

.prow{display:flex;gap:6px;align-items:stretch}
.prow textarea{flex:1;min-width:0}
.pact{display:flex;flex-direction:column;gap:3px;flex:none;width:132px}
.pact button{margin:0;width:100%;text-align:center;white-space:nowrap}
.pact #send{flex:1;font-weight:600}
textarea{width:100%;box-sizing:border-box;min-height:64px;resize:vertical;background:var(--vscode-input-background);color:var(--vscode-input-foreground);border:1px solid var(--vscode-input-border,transparent);padding:6px;font:12px var(--vscode-font-family)}
input[type=text]{width:92px;background:var(--vscode-input-background);color:var(--vscode-input-foreground);border:1px solid var(--vscode-input-border,transparent);padding:3px 5px;border-radius:2px}
select.dd{background:var(--vscode-button-secondaryBackground);color:var(--vscode-button-secondaryForeground);border:1px solid var(--vscode-input-border,transparent);padding:3px 6px;border-radius:3px;font-size:11px;cursor:pointer}
.idbtn{font-weight:700;outline:1px solid var(--vscode-focusBorder)}
.vsep{display:inline-block;width:1px;height:16px;background:var(--b);margin:0 2px;vertical-align:middle}
.row{display:flex;align-items:center;gap:6px;flex-wrap:wrap;margin:3px 0}
.hint{opacity:.6;font-size:11px}
.stg span{display:inline-block;margin:2px 8px 2px 0}
.files a{display:inline-block;margin:2px 8px 2px 0;cursor:pointer;text-decoration:underline}
.hi a{cursor:pointer;text-decoration:underline}
h4{margin:8px 0 2px 0}

/* 첨부 칩 */
#attached{display:flex;flex-wrap:wrap;gap:4px;margin:4px 0}
#attached:empty{display:none}
.chip{display:inline-flex;align-items:center;gap:4px;background:var(--vscode-badge-background);color:var(--vscode-badge-foreground);padding:2px 6px;border-radius:10px;font-size:11px}
.chip .x{cursor:pointer;opacity:.7;padding:0 2px}
.chip .x:hover{opacity:1}

/* FLOW inner */
.flow-root h3{margin:0 0 4px 0;font-size:13px}
.flow-root .bar{height:12px;background:var(--vscode-input-background);border:1px solid var(--b);border-radius:6px;overflow:hidden;margin:4px 0}
.flow-root .bar div{height:100%;background:#3fb950}
.flow-root .stages{display:flex;flex-wrap:wrap;gap:4px;margin:4px 0}
.flow-root .stages div{border:1px solid var(--b);border-radius:3px;padding:2px 6px;font-size:11px}
.flow-root .legend{font-size:11px;margin:4px 0;display:flex;flex-wrap:wrap;gap:8px;align-items:center}
.flow-tbl{border-collapse:collapse;width:100%;margin-top:6px;font-size:11px}
.flow-tbl th,.flow-tbl td{border:1px solid var(--b);padding:3px 5px;vertical-align:top}
.flow-tbl th{background:var(--vscode-editorWidget-background);position:sticky;top:0;z-index:1}
.flow-tbl td.fc{text-align:center;cursor:pointer;font-size:13px;width:54px}
.flow-tbl td.fc .n{font-size:10px;opacity:.75}
.flow-tbl .id{white-space:nowrap}.flow-tbl .pl{white-space:nowrap;font-size:10px}
.flow-tbl .sub{font-size:10px;opacity:.6}
.flow-tbl .fbtn{font-size:10px;padding:2px 6px}

/* 이력 inner */
.hist-root{display:flex;flex-direction:column;height:100%}
.hist-top{display:flex;gap:4px;flex-wrap:wrap;align-items:center;margin-bottom:4px}
.hist-cols{flex:1;display:grid;grid-template-columns:46% 54%;gap:6px;min-height:0}
.hist-l,.hist-r{overflow:auto;padding:4px 6px;border:1px solid var(--b);border-radius:3px}
.hit{padding:3px 5px;border-radius:3px;cursor:pointer;margin:2px 0;font-size:11px}
.hit:hover{background:var(--vscode-list-hoverBackground)}
.hit.hsel{background:var(--vscode-list-activeSelectionBackground);color:var(--vscode-list-activeSelectionForeground)}
.hit .task{opacity:.8}.hit .when{opacity:.6;font-size:10px}.hit .n{opacity:.6;font-size:10px}
.hit .st.ok{color:#3fb950}.hit .st.bad{color:#f85149}.hit .st.run{color:#d29922}
.hf{padding:2px 4px;cursor:pointer;font-size:11px}
.hf:hover{background:var(--vscode-list-hoverBackground)}
.hf .k{display:inline-block;width:14px}
.hf.added .k{color:#3fb950}.hf.deleted .k{color:#f85149}.hf.modified .k{color:#d29922}
</style></head><body>
<div id="top">
  <!-- 1.8.0: '작업 출력' → Log. Log 탭 = BE Log | FE Log 두 창(서버 기동 스트림) · Task Log 탭 = 그 외 작업(gap.js·pipeline 등) 출력. 각 창에 ⤓ 최신 버튼 -->
  <div class="rtabs"><button class="rtb on" data-t="chat">✴️ Claude</button><button class="rtb" data-t="logs">📜 Log</button><button class="rtb" data-t="log">🧾 Task Log</button><button class="rtb" data-t="status">🎯 UI Status</button><button class="rtb" data-t="hist">🕒 History</button><span id="dtabs"></span><span id="busy"><span class="spinner"></span><span class="label"></span></span></div>
  <div id="chat">
    <div class="hint">${t(p, 'chat_hint')}</div>
    <div id="thinking" class="thinking"><span class="pulse">✻</span><span>Thinking…</span></div>
  </div>
  <div id="logs" style="display:none">
    <div class="logpane"><div class="loghead"><span class="logttl">${t(p, 'belog')}</span><span class="logst" id="belogst"></span><button class="sec latest" data-for="belog" title="${p.language === 'ko' ? '마지막(최신) 로그로 이동' : 'Jump to latest log'}">${t(p, 'latest')}</button><button class="sec latest" data-clear="belog" title="BE Log 지우기">🧹</button></div><div id="belog" class="logbody"></div></div>
    <div class="logpane"><div class="loghead"><span class="logttl">${t(p, 'felog')}</span><span class="logst" id="felogst"></span><button class="sec latest" data-for="felog" title="${p.language === 'ko' ? '마지막(최신) 로그로 이동' : 'Jump to latest log'}">${t(p, 'latest')}</button><button class="sec latest" data-clear="felog" title="FE Log 지우기">🧹</button></div><div id="felog" class="logbody"></div></div>
  </div>
  <div id="logwrap" style="display:none"><div class="loghead"><span class="logttl">${t(p, 'tasklog')}</span><button class="sec latest" data-for="log" title="${p.language === 'ko' ? '마지막(최신) 로그로 이동' : 'Jump to latest log'}">${t(p, 'latest')}</button></div><div id="log" class="logbody"></div></div>
  <div id="status" style="display:none">${statusHtml(p, state.id)}</div>
  <div id="flow" style="display:none"><div class="hint">${t(p, 'flow_hint')}</div></div>
  <div id="hist" style="display:none"><div class="hint">${t(p, 'hist_hint')}</div></div>
</div>
<div id="bottom">
  <div id="attached"></div>
  <!-- 1.7.6: 프롬프트 우측 = 전송(Ctrl+Enter) · 중지 · 지우기 세로 배치 -->
  <div class="prow">
    <textarea id="t" placeholder="${esc(t(p, 'ph'))}"></textarea>
    <div class="pact">
      <button id="send" title="프롬프트를 Claude 에 전송 (Ctrl+Enter)">${t(p, 'send')}</button>
      <button class="sec" id="stop" title="실행 중인 자식 프로세스·Claude 요청 모두 중지">${t(p, 'stop')}</button>
      <button class="sec" id="clear" title="작업 출력·Claude 대화 지우기">${t(p, 'clear')}</button>
    </div>
  </div>
  <div class="row">
    <button class="sec" id="attach" title="파일 첨부 — 선택한 파일을 Claude 에 @경로 로 전달. 이미지는 Claude 가 직접 읽습니다. 클립보드 이미지는 textarea 에 Ctrl+V 로 붙여넣기 가능.">${t(p, 'attach')}</button>
    <span class="vsep"></span>
    <button class="sec idbtn" id="idBtn" title="화면 ID 확정 — 유지/다른 ID 입력/AS-IS DB 목록에서 선택. 묵시적 재사용 금지(1.6 룰).">📍 ${esc(state.id || t(p, 'noid'))}</button>
    <select class="sec dd" id="mode" title="Claude 모드 (/mode) — 자동(acceptEdits) · 수동(default) · PLAN · 전부허용(bypassPermissions)">
      <option value="acceptEdits"${state.permissionMode === 'acceptEdits' ? ' selected' : ''}>${t(p, 'mode_auto')}</option>
      <option value="default"${state.permissionMode === 'default' ? ' selected' : ''}>${t(p, 'mode_manual')}</option>
      <option value="plan"${state.permissionMode === 'plan' ? ' selected' : ''}>${t(p, 'mode_plan')}</option>
      <option value="bypassPermissions"${(state.permissionMode || 'bypassPermissions') === 'bypassPermissions' ? ' selected' : ''}>${t(p, 'mode_bypass')}</option>
    </select>
    <select class="sec dd" id="model" title="Claude 모델 (--model) — 다음 전송부터 적용(세션 유지). 목록은 VS Code 설정 vibeManager.modelList, 없는 모델은 '직접 입력…'">${modelOpts}</select>
    <span id="modelInfo" class="modelbox" title="현재 세션에서 실제로 응답한 모델 (Claude Code stream 의 model 필드)">
      <span class="mlbl">${t(p, 'inuse')}</span><span id="modelName">${esc(state.model || p.claudeModel || t(p, 'after_send'))}</span>
    </span>
    <button class="sec" id="remote" title="📱 원격 — 현재 Claude 세션 ID 를 모바일 Claude Code 로 이어받기 위한 세션 ID / --resume 명령 복사">${t(p, 'remote')}</button>
    <span id="sess" class="hint">${wb.claudeSession ? t(p, 'sess') + esc(wb.claudeSession.slice(0, 8)) : t(p, 'nosess')}</span>
    <span class="vsep"></span>
    <button class="sec" id="newS" title="Claude 세션 리셋 — 다음 전송부터 새 대화 (화면ID 유지)">${t(p, 'newsess')}</button>
    <button class="sec" id="newWin" title="워크벤치를 하나 더 열기 — 각 창이 독립된 Claude 세션·화면ID 로 멀티 작업 가능">${t(p, 'newwin')}</button>
    <button class="sec" id="editQ" title="quick.json 편집 — 전체 메뉴 그룹·항목 커스터마이즈">✎ quick.json</button>
  </div>
</div>
<script>
const vscode=acquireVsCodeApi();const $=i=>document.getElementById(i);
const UI_SEND=${JSON.stringify(t(p, 'send'))},UI_SENDING=${JSON.stringify(t(p, 'sending'))},UI_SESS=${JSON.stringify(t(p, 'sess'))},UI_NOSESS=${JSON.stringify(t(p, 'nosess'))},UI_NOID=${JSON.stringify(t(p, 'noid'))},UI_AFTERSEND=${JSON.stringify(t(p, 'after_send'))},UI_BD=${JSON.stringify(t(p, 'bd'))},UI_TB=${JSON.stringify(t(p, 'tb'))};
let CUR_ID=${JSON.stringify(String(state.id || ''))};
// 1.7.2: 모델 드롭다운 복원 — st() 에 model 포함 ('' = 기본).
let CUR_MODEL=$('model').value==='__custom__'?'':$('model').value;
const st=()=>({id:CUR_ID,permissionMode:$('mode').value,model:CUR_MODEL});
const save=()=>vscode.postMessage(Object.assign({type:'state'},st()));
$('mode').addEventListener('change',save);
function addModelOpt(id,label){const sel=$('model');if(!id||[...sel.options].some(o=>o.value===id))return;const o=document.createElement('option');o.value=id;o.textContent=label||id;sel.insertBefore(o,sel.querySelector('option[value="__custom__"]'));}
$('model').addEventListener('change',()=>{const v=$('model').value;if(v==='__custom__'){$('model').value=CUR_MODEL;vscode.postMessage({type:'pickModel',cur:CUR_MODEL});return;}CUR_MODEL=v;save();});
function showTab(t){
  if(t.startsWith('t:')){showDynTab(t);if(t==='t:flow')vscode.postMessage(Object.assign({type:'flow:refresh',filter:''},st()));return;}
  document.querySelectorAll('.dtab').forEach(d=>d.style.display='none');
  document.querySelectorAll('.rtabs .rtb').forEach(x=>x.classList.toggle('on',x.dataset.t===t));
  [['log','logwrap'],['logs','logs'],['chat','chat'],['status','status'],['hist','hist']].forEach(([k,el])=>$(el).style.display=k===t?'':'none');
  if(t==='logs'){['belog','felog'].forEach(scrollLatest);} else if(t==='log') scrollLatest('log');
  if(t==='hist') vscode.postMessage(Object.assign({type:'history:refresh',mode:'screen',sel:''},st()));
  else if(t==='status') vscode.postMessage(Object.assign({type:'status'},st()));
}
document.querySelectorAll('.rtabs .rtb').forEach(b=>b.onclick=()=>showTab(b.dataset.t));


function send(){const text=$('t').value;if(!text.trim())return;vscode.postMessage(Object.assign({type:'prompt',text},st()));$('t').value='';showTab('chat');}
$('send').onclick=send;
$('t').addEventListener('keydown',e=>{if(e.ctrlKey&&e.key==='Enter'){e.preventDefault();send();}});
$('t').addEventListener('paste',e=>{
  const items=(e.clipboardData||{}).items||[];
  for(const it of items){
    if(it.kind==='file'&&String(it.type||'').startsWith('image/')){
      const f=it.getAsFile();if(!f)continue;
      const rd=new FileReader();rd.onload=()=>vscode.postMessage({type:'pastedImage',data:String(rd.result),mime:f.type||'image/png'});rd.readAsDataURL(f);
      e.preventDefault();return;
    }
  }
});
$('attach').onclick=()=>vscode.postMessage({type:'pickFiles'});
$('newS').onclick=()=>vscode.postMessage({type:'newSession'});
$('idBtn').onclick=()=>vscode.postMessage(Object.assign({type:'pickId'},st()));
$('remote').onclick=()=>vscode.postMessage({type:'remote'});
$('editQ').onclick=()=>vscode.postMessage({type:'editQuick'});
$('newWin').onclick=()=>vscode.postMessage({type:'newWindow'});
// 1.8.0: ⤓ 최신 = 해당 로그창 맨 아래로 · 🧹 = 그 창만 지우기
function scrollLatest(id){const b=$(id);if(b)b.scrollTop=b.scrollHeight;}
document.querySelectorAll('.latest[data-for]').forEach(b=>b.onclick=()=>scrollLatest(b.dataset.for));
document.querySelectorAll('.latest[data-clear]').forEach(b=>b.onclick=()=>{$(b.dataset.clear).innerHTML='';});
$('clear').onclick=()=>{if(RUN&&RUN.timer)clearInterval(RUN.timer);RUN=null;if(FLOW&&FLOW.timer)clearInterval(FLOW.timer);FLOW=null;$('log').innerHTML='';$('belog').innerHTML='';$('felog').innerHTML='';$('chat').innerHTML='<div class="hint">새 대화 (대화 지움). 전송하면 Claude 응답이 여기 표시됩니다.</div><div id="thinking" class="thinking"><span class="pulse">✻</span><span>Thinking…</span></div>';};
$('stop').onclick=()=>vscode.postMessage({type:'stop'});

// ── 1.8.4 Claude 상황판: 프롬프트 1회 = run 1개 → 헤더(현재 Step/전체 Step·진행바·경과) + Step 카드(접힘) + 최종 보고 ──
let RUN=null;
const TK={read:['Read'],edit:['Edit','MultiEdit','Write','NotebookEdit'],run:['Bash','PowerShell'],find:['Grep','Glob'],agent:['Agent','Task'],web:['WebFetch','WebSearch']};
const TKI={read:'📖',edit:'✏️',run:'▶',find:'🔎',agent:'🤖',web:'🌐',other:'🔧'};
function tkind(n){for(const k in TK)if(TK[k].includes(n))return k;return 'other';}
function el(tag,cls,txt){const e=document.createElement(tag);if(cls)e.className=cls;if(txt!=null)e.textContent=txt;return e;}
function fmtSec(s){s=Math.max(0,Math.round(s));return s<60?s+'s':Math.floor(s/60)+'m '+(s%60)+'s';}
function firstLine(t){return (String(t||'').split('\\n').find(x=>x.trim())||'').replace(/^[#>*\\-\\s]+/,'').replace(/\\*\\*/g,'').trim();}
function chatStick(){const c=$('chat');return c.scrollHeight-c.scrollTop-c.clientHeight<80;}
function chatScroll(stick){if(stick)$('chat').scrollTop=$('chat').scrollHeight;}
function newRun(promptText){
  if(RUN&&!RUN.done)endRun(null,null);
  const r={steps:[],cur:-1,todos:null,t0:Date.now(),tools:0,edits:0,done:false,ok:null,lastText:'',totalHint:0,timer:null};
  const mk=(String(promptText).match(/\\[\\s*\\d+\\s+[^\\]]{1,20}\\]/g)||[]);if(mk.length>=2)r.totalHint=new Set(mk).size;
  r.el=el('div','run');
  const u=el('details','m user runq');const us=el('summary');const f=firstLine(promptText)||promptText;us.textContent='💬 '+(f.length>140?f.slice(0,140)+'…':f);u.appendChild(us);u.appendChild(el('div','mb',promptText));r.el.appendChild(u);
  const b=el('div','board running');
  b.innerHTML='<div class="bhead"><div class="bstep"><span class="bcur">0</span><span class="bsl">/</span><span class="btot">?</span><span class="bsll"></span></div><div class="bmid"><div class="btitle"></div><div class="bbar"><i></i></div><div class="bnow"></div></div><div class="bkpis"><div class="bk"><b class="bk-tools">0</b><span></span></div><div class="bk"><b class="bk-edits">0</b><span></span></div><div class="bk"><b class="bk-time">0s</b><span></span></div><div class="bk"><b class="bk-st running"></b></div></div></div><div class="bsteps"></div><div class="bfoot"></div>';
  b.querySelector('.bsll').textContent=UI_BD.step;
  const kl=b.querySelectorAll('.bk span');kl[0].textContent=UI_BD.tools;kl[1].textContent=UI_BD.edits;kl[2].textContent=UI_BD.elapsed;
  r.board=b;r.el.appendChild(b);
  runContainer().appendChild(r.el);const th=$('thinking');if(th)$('chat').appendChild(th);
  RUN=r;setStatus(UI_BD.running,'running');updateHead();
  r.timer=setInterval(()=>{if(RUN!==r||r.done){clearInterval(r.timer);return;}r.board.querySelector('.bk-time').textContent=fmtSec((Date.now()-r.t0)/1000);},1000);
  chatScroll(true);return r;
}
function setStatus(txt,cls){if(!RUN)return;const s=RUN.board.querySelector('.bk-st');s.textContent=txt;s.className='bk-st '+cls;RUN.board.className='board '+cls;}
function setStepStatus(st,s){st.status=s;st.el.className='step '+(s==='run'?'running':s);}
function newStep(title,idx,isTodo){
  const r=RUN;if(!r)return null;
  const d=el('details','step');const s=el('summary');
  s.innerHTML='<span class="sno"></span><span class="sttl"></span><span class="schips"></span><span class="slast"></span>';
  d.appendChild(s);const body=el('div','sbody');d.appendChild(body);
  const st={el:d,sum:s,body:body,title:title||'',tools:[],kinds:{},status:'run',idx:idx!=null?idx:r.steps.length,todo:null};
  s.querySelector('.sno').textContent=st.idx+1;s.querySelector('.sttl').textContent=st.title||UI_BD.prep;
  if(!isTodo){r.steps.forEach(x=>{if(x.status==='run'){setStepStatus(x,'done');x.sum.querySelector('.slast').textContent='';}});}
  r.steps.push(st);if(!isTodo)r.cur=r.steps.length-1;
  setStepStatus(st,isTodo?'wait':'run');
  r.board.querySelector('.bsteps').appendChild(d);
  return st;
}
function curStep(){const r=RUN;if(!r)return null;if(r.cur>=0&&r.steps[r.cur])return r.steps[r.cur];const st=newStep('',null,false);updateHead();return st;}
function addText(txt){
  const r=RUN;if(!r)return;const f=firstLine(txt);r.lastText=txt;
  let st=r.cur>=0?r.steps[r.cur]:null;
  const marker=/^\\[?\\s*\\d+\\s*[\\].:)]\\s*\\S/.test(f)||/^(step|단계)\\s*\\d+/i.test(f);
  if(!r.todos&&(!st||st.tools.length>0||marker)){st=newStep(f.slice(0,90),null,false);}
  else if(!st){st=curStep();}
  else if(!st.title&&!st.todo){st.title=f.slice(0,90);st.sum.querySelector('.sttl').textContent=st.title;}
  st.body.appendChild(el('div','stext',txt));
  st.sum.querySelector('.slast').textContent='💬 '+f.slice(0,80);
  r.board.querySelector('.bnow').textContent='💬 '+f.slice(0,120);
  updateHead();
}
function addTool(m){
  const r=RUN;if(!r)return;const st=curStep();
  const k=tkind(m.name||'');r.tools++;if(k==='edit')r.edits++;st.kinds[k]=(st.kinds[k]||0)+1;
  const brief=m.brief||m.text||'';
  const d=el('details','m tool k-'+k);d.appendChild(el('summary',null,(TKI[k]||'🔧')+' '+brief));d.appendChild(el('div','mb',m.text));
  st.body.appendChild(d);st.tools.push(d);
  st.sum.querySelector('.slast').textContent='↻ '+brief;
  r.board.querySelector('.bnow').textContent='↻ '+brief;
  renderChips(st);updateHead();
}
function addResult(txt){
  const r=RUN;if(!r)return;const st=r.cur>=0?r.steps[r.cur]:null;const last=st&&st.tools[st.tools.length-1];
  if(!last){const d=el('details','m result');d.appendChild(el('summary',null,'↳ '+firstLine(txt).slice(0,160)));d.appendChild(el('div','mb',txt));(st?st.body:$('chat')).appendChild(d);return;}
  let mr=last.querySelector('.mr');if(!mr){mr=el('div','mr');last.appendChild(mr);}
  mr.textContent=txt;
  if(/\\b(error|exception|traceback|failed|ORA-\\d+|PLS-\\d+)\\b|✖|✗|is not recognized/i.test(txt.slice(0,400)))last.classList.add('bad');
}
function renderChips(st){const c=st.sum.querySelector('.schips');c.innerHTML='';for(const k in st.kinds){const sp=el('span','sc k-'+k,(TKI[k]||'🔧')+' '+st.kinds[k]);sp.title=UI_BD.k[k]||k;c.appendChild(sp);}}
function updateHead(){
  const r=RUN;if(!r)return;const b=r.board;
  let tot,cur;
  if(r.todos){const ts=r.steps.filter(x=>x.todo);tot=ts.length;const done=ts.filter(x=>x.status==='done').length;cur=Math.min(tot,done+(ts.some(x=>x.status==='run')?1:0));}
  else{cur=r.steps.length;tot=Math.max(r.totalHint,cur);}
  b.querySelector('.bcur').textContent=cur;b.querySelector('.btot').textContent=tot||'?';
  const prog=r.done?(r.ok?tot:cur):Math.max(0,cur-0.5);
  b.querySelector('.bbar i').style.width=(tot?Math.round(100*prog/tot):0)+'%';
  b.querySelector('.bk-tools').textContent=r.tools;b.querySelector('.bk-edits').textContent=r.edits;
  const cs=r.steps[r.cur];b.querySelector('.btitle').textContent=cs?((cs.idx+1)+'. '+(cs.title||UI_BD.prep)):'';
}
function applyTodos(items){
  const r=RUN;if(!r)return;
  if(!r.todos){
    // 첫 할 일 목록 도착: 그 전까지의 동적 step 은 '0 준비' 하나로 합침
    if(r.steps.length){const keep=r.steps[0];for(let i=1;i<r.steps.length;i++){const x=r.steps[i];while(x.body.firstChild)keep.body.appendChild(x.body.firstChild);keep.tools=keep.tools.concat(x.tools);for(const k in x.kinds)keep.kinds[k]=(keep.kinds[k]||0)+x.kinds[k];x.el.remove();}
      r.steps=[keep];keep.idx=-1;keep.sum.querySelector('.sno').textContent='0';keep.sum.querySelector('.sttl').textContent=UI_BD.prep;keep.sum.querySelector('.slast').textContent='';renderChips(keep);setStepStatus(keep,'done');}
    r.todos=[];
  }
  items.forEach((td,i)=>{
    let st=r.steps.find(x=>x.todo&&x.todo.content===td.content);
    if(!st){st=newStep(td.content,i,true);st.todo={content:td.content};}
    st.idx=i;st.sum.querySelector('.sno').textContent=i+1;
    const ns=td.status==='completed'?'done':td.status==='in_progress'?'run':'wait';
    if(st.status!==ns){setStepStatus(st,ns);if(ns==='done')st.sum.querySelector('.slast').textContent='';}
  });
  r.todos=items;
  let ci=r.steps.findIndex(x=>x.todo&&x.status==='run');if(ci<0)ci=r.steps.findIndex(x=>x.todo&&x.status==='wait');if(ci<0)ci=r.steps.length-1;r.cur=ci;
  updateHead();
}
function endRun(text,ok){
  const r=RUN;if(!r||r.done)return;r.done=true;r.ok=ok;if(r.timer)clearInterval(r.timer);
  r.board.querySelector('.bk-time').textContent=fmtSec((Date.now()-r.t0)/1000);
  r.steps.forEach(x=>{if(x.status==='run')setStepStatus(x,ok?'done':(ok===false?'bad':'wait'));x.sum.querySelector('.slast').textContent='';});
  setStatus(ok?UI_BD.done:(ok===false?UI_BD.error:UI_BD.stopped),ok?'done':'bad');
  r.board.querySelector('.bnow').textContent='';
  if(r.lastText){const fd=el('details','bfinal');fd.open=true;fd.appendChild(el('summary',null,'📄 '+UI_BD.final));fd.appendChild(el('div','ft',r.lastText));r.board.insertBefore(fd,r.board.querySelector('.bfoot'));}
  if(text)addMeta(text);
  updateHead();
}
function addMeta(text){const d=el('div','m meta',text);if(RUN)RUN.board.querySelector('.bfoot').appendChild(d);else $('chat').appendChild(d);}

// ── 1.8.9 Flow 보드: 체인/단일 작업 = 전체 Step 수·현재 Step·진행바·경과 + Step 카드(대기/진행/완료/실패/경고). Claude 단계의 상황판(run)은 그 Step 카드 안에 ──
let FLOW=null;
const FST={RUN:'running',OK:'done',FAIL:'bad',WARN:'warn',CANCEL:'bad',NOT_RUN:'wait',WAIT:'wait'};
const FSI={RUN:'⏳',OK:'✅',FAIL:'✖',WARN:'⚠',CANCEL:'⛔',NOT_RUN:'○',WAIT:'○'};
function flowStart(m){
  if(FLOW&&!FLOW.done)flowEnd({ok:false,summary:UI_BD.stopped,sec:0});
  const f={id:m.id,steps:[],cur:0,total:(m.steps||[]).length,t0:Date.now(),done:false,timer:null,title:m.title||'',screen:m.screen||'',md:m.md||''};
  f.el=el('div','run flowrun');
  const b=el('div','board fboard running');
  b.innerHTML='<div class="bhead"><div class="bstep"><span class="bcur">0</span><span class="bsl">/</span><span class="btot">0</span><span class="bsll"></span></div><div class="bmid"><div class="btitle"></div><div class="bbar"><i></i></div><div class="bnow"></div></div><div class="bkpis"><div class="bk"><b class="bk-done">0</b><span></span></div><div class="bk"><b class="bk-time">0s</b><span></span></div><div class="bk"><b class="bk-st running"></b></div></div></div><div class="bsteps"></div><div class="bfoot"></div>';
  b.querySelector('.bsll').textContent=UI_BD.step;b.querySelector('.btot').textContent=f.total;
  const kl=b.querySelectorAll('.bk span');kl[0].textContent=UI_BD.done;kl[1].textContent=UI_BD.elapsed;
  b.querySelector('.btitle').textContent='🧭 '+f.title+(f.screen?' · '+f.screen:'');
  b.querySelector('.bk-st').textContent=UI_BD.running;
  f.board=b;f.el.appendChild(b);
  const list=b.querySelector('.bsteps');
  (m.steps||[]).forEach(s=>{
    const d=el('details','step wait');const sm=el('summary');
    sm.innerHTML='<span class="sno"></span><span class="sttl"></span><span class="sdur"></span><span class="slast"></span>';
    sm.querySelector('.sno').textContent=s.no;sm.querySelector('.sttl').textContent=(s.kind==='claude'?'✴️ ':'')+s.name+(s.optional?' ('+UI_BD.optional+')':'');
    d.appendChild(sm);const body=el('div','sbody');const tail=el('pre','ftail');body.appendChild(tail);d.appendChild(body);list.appendChild(d);
    f.steps.push({no:s.no,el:d,sum:sm,body:body,tail:tail,status:'WAIT',lines:[],kind:s.kind});
  });
  $('chat').appendChild(f.el);const th=$('thinking');if(th)$('chat').appendChild(th);
  FLOW=f;flowHead();
  f.timer=setInterval(()=>{if(FLOW!==f||f.done){clearInterval(f.timer);return;}f.board.querySelector('.bk-time').textContent=fmtSec((Date.now()-f.t0)/1000);},1000);
  chatScroll(true);
}
function flowStepEl(no){return FLOW?FLOW.steps.find(s=>s.no===no):null;}
function flowStep(m){
  const f=FLOW;if(!f||f.id!==m.id)return;const s=flowStepEl(m.no);if(!s)return;
  s.status=m.status;s.el.className='step '+(FST[m.status]||'wait');
  if(m.status==='RUN'){f.cur=m.no;f.active=s;s.sum.querySelector('.slast').textContent='';}
  else{if(f.active===s)f.active=null;s.sum.querySelector('.sdur').textContent=(m.sec!=null?fmtSec(m.sec):'')+(m.code!=null&&m.code!==0?' · exit '+m.code:'');s.sum.querySelector('.slast').textContent=FSI[m.status]+' '+(UI_BD.fs[m.status]||m.status);}
  flowHead();
}
function flowHead(){
  const f=FLOW;if(!f)return;const b=f.board;
  const done=f.steps.filter(s=>s.status==='OK'||s.status==='WARN').length;
  const cur=f.done?done:Math.min(f.total,done+(f.active?1:0));
  b.querySelector('.bcur').textContent=f.active?f.active.no:cur;b.querySelector('.bk-done').textContent=done;
  const prog=f.done?done:Math.max(0,done+(f.active?0.5:0));
  b.querySelector('.bbar i').style.width=(f.total?Math.round(100*prog/f.total):0)+'%';
  b.querySelector('.bnow').textContent=f.active?('▶ '+f.active.sum.querySelector('.sttl').textContent):'';
}
function flowOut(text){
  const f=FLOW;if(!f||f.done||!f.active)return;const s=f.active;
  const parts=String(text).split('\\n');
  for(const ln of parts){if(!ln.trim())continue;s.lines.push(ln);if(s.lines.length>60)s.lines.shift();}
  s.tail.textContent=s.lines.join('\\n');
  const last=s.lines.length?s.lines[s.lines.length-1].trim():'';
  if(last)s.sum.querySelector('.slast').textContent='↻ '+last.slice(0,100);
  f.board.querySelector('.bnow').textContent='▶ '+s.sum.querySelector('.sttl').textContent+(last?' — '+last.slice(0,80):'');
}
function flowEnd(m){
  const f=FLOW;if(!f||f.done)return;f.done=true;if(f.timer)clearInterval(f.timer);
  f.board.querySelector('.bk-time').textContent=fmtSec(m.sec!=null?m.sec:(Date.now()-f.t0)/1000);
  const cls=m.ok?(m.warn?'warn':'done'):'bad';
  const st=f.board.querySelector('.bk-st');st.textContent=m.ok?(m.warn?UI_BD.warn:UI_BD.done):UI_BD.error;st.className='bk-st '+(cls==='warn'?'running':cls);
  f.board.className='board fboard '+(cls==='warn'?'running':cls);
  f.steps.forEach(s=>{if(s.status==='RUN'){s.status=m.ok?'OK':'FAIL';s.el.className='step '+FST[s.status];}});
  f.active=null;flowHead();f.board.querySelector('.bnow').textContent='';
  if(m.summary){const d=el('div','m meta',m.summary+(f.md?' · '+f.md:''));f.board.querySelector(':scope > .bfoot').appendChild(d);}
}
// Claude 상황판(run)이 들어갈 컨테이너 — Flow 의 진행 중 Step 이 있으면 그 카드 안, 없으면 chat
function runContainer(){return (FLOW&&!FLOW.done&&FLOW.active&&FLOW.active.kind==='claude')?FLOW.active.body:$('chat');}

// ── 1.9.0 Workbench 내부 탭(파일 뷰어/편집·폴더·diff) ──
const TABS={};
function tabKey(k){return 'dt-'+String(k).replace(/[^a-z0-9]/gi,'_');}
function openTabUI(m){
  const id=tabKey(m.key);let T=TABS[m.key];
  if(!T){
    const btn=el('button','rtb dyn');btn.dataset.t='t:'+m.key;
    const lb=el('span','tl',m.title);const x=el('span','tx','✕');x.title=UI_TB.close;btn.appendChild(lb);btn.appendChild(x);
    x.onclick=ev=>{ev.stopPropagation();closeTab(m.key);};btn.onclick=()=>showTab('t:'+m.key);
    $('dtabs').appendChild(btn);
    const pane=el('div','dtab');pane.id=id;
    pane.innerHTML='<div class="dtb"><span class="dtp"></span><span class="dtsp"></span><button class="sec dt-reload"></button><button class="sec dt-edit"></button><button class="sec dt-save" style="display:none"></button><button class="sec dt-editor"></button><button class="sec dt-os"></button></div><div class="dtc"></div><textarea class="dte" style="display:none" spellcheck="false"></textarea>';
    pane.querySelector('.dt-reload').textContent='🔄 '+UI_TB.reload;pane.querySelector('.dt-edit').textContent='✏️ '+UI_TB.edit;pane.querySelector('.dt-save').textContent='💾 '+UI_TB.save;pane.querySelector('.dt-editor').textContent='📝 '+UI_TB.editor;pane.querySelector('.dt-os').textContent='↗ '+UI_TB.os;
    pane.querySelector('.dt-reload').onclick=()=>{if(T.kind==='html')vscode.postMessage({type:'tab:refresh',key:T.key});else vscode.postMessage({type:'tab:open',file:T.path,line:0});};
    pane.querySelector('.dt-editor').onclick=()=>vscode.postMessage({type:'tab:editor',file:T.path,line:T.line||0});
    pane.querySelector('.dt-os').onclick=()=>vscode.postMessage({type:'tab:os',file:T.path});
    pane.querySelector('.dt-edit').onclick=()=>toggleEdit(T);
    pane.querySelector('.dt-save').onclick=()=>{vscode.postMessage({type:'tab:save',file:T.path,text:pane.querySelector('.dte').value});};
    $('top').appendChild(pane);
    T=TABS[m.key]={key:m.key,pane:pane,btn:btn,editing:false};
  }
  Object.assign(T,{path:m.path,title:m.title,editable:!!m.editable,text:m.text||'',line:m.line||0,isDir:!!m.isDir,kind:m.kind||''});
  T.btn.querySelector('.tl').textContent=m.title;T.btn.title=m.sub||m.path||'';
  const pane=T.pane;pane.querySelector('.dtp').textContent=m.sub||m.path||'';pane.querySelector('.dtsp').textContent=m.meta||'';
  pane.querySelector('.dt-edit').style.display=m.editable?'':'none';pane.querySelector('.dt-editor').style.display=m.canEditor===false?'none':'';pane.querySelector('.dt-os').style.display=m.canOS===false?'none':'';
  const c=pane.querySelector('.dtc');c.innerHTML=m.html||'';T.editing=false;pane.querySelector('.dte').style.display='none';c.style.display='';pane.querySelector('.dt-save').style.display='none';pane.querySelector('.dt-edit').textContent='✏️ '+UI_TB.edit;
  bindTabContent(T);
  showTab('t:'+m.key);
  if(m.line){const r=c.querySelector('#L'+m.line);if(r)r.scrollIntoView({block:'center'});}
}
function bindTabContent(T){
  const c=T.pane.querySelector('.dtc');
  c.querySelectorAll('a[data-open]').forEach(a=>a.onclick=ev=>{ev.preventDefault();vscode.postMessage({type:'tab:open',file:a.dataset.open});});
  c.querySelectorAll('a[data-ext]').forEach(a=>a.onclick=ev=>{ev.preventDefault();vscode.postMessage({type:'tab:ext',url:a.dataset.ext});});
  const f=c.querySelector('.csvf');if(f){f.oninput=()=>{const q=f.value.toLowerCase();c.querySelectorAll('table.csvt tbody tr').forEach(tr=>{tr.style.display=!q||tr.textContent.toLowerCase().includes(q)?'':'none';});};}
  const da=c.querySelector('.diffall');if(da){da.onchange=()=>c.querySelector('.diffw').classList.toggle('all',da.checked);}
  c.querySelectorAll('[data-action]').forEach(el=>el.onclick=ev=>{ev.preventDefault();vscode.postMessage({type:'tab:action',key:T.key,action:el.dataset.action,data:Object.assign({},el.dataset)});});
}
function toggleEdit(T){
  const pane=T.pane;const ta=pane.querySelector('.dte');const c=pane.querySelector('.dtc');
  T.editing=!T.editing;
  if(T.editing){ta.value=T.text;ta.style.display='';c.style.display='none';pane.querySelector('.dt-save').style.display='';pane.querySelector('.dt-edit').textContent='👁 '+UI_TB.view;}
  else{ta.style.display='none';c.style.display='';pane.querySelector('.dt-save').style.display='none';pane.querySelector('.dt-edit').textContent='✏️ '+UI_TB.edit;}
}
function closeTab(key){const T=TABS[key];if(!T)return;const active=T.btn.classList.contains('on');T.btn.remove();T.pane.remove();delete TABS[key];if(T.kind==='html')vscode.postMessage({type:'tab:closed',key:key});if(active)showTab('chat');}
function showDynTab(t){
  const key=t.slice(2);
  document.querySelectorAll('.dtab').forEach(d=>d.style.display='none');
  [['log','logwrap'],['logs','logs'],['chat','chat'],['status','status'],['flow','flow'],['hist','hist']].forEach(([k,id])=>$(id).style.display='none');
  const T=TABS[key];if(T)T.pane.style.display='flex';
  document.querySelectorAll('.rtabs .rtb').forEach(x=>x.classList.toggle('on',x.dataset.t===t));
}

function renderAttached(files){
  const box=$('attached');box.innerHTML='';
  files.forEach((f,i)=>{const c=document.createElement('span');c.className='chip';c.innerHTML='';
    const em=document.createElement('span');em.textContent=f.isImage?'🖼️':'📄';c.appendChild(em);
    const nm=document.createElement('span');nm.textContent=f.name;nm.title=f.path;c.appendChild(nm);
    const x=document.createElement('span');x.className='x';x.textContent='✕';x.title='제거';x.onclick=()=>vscode.postMessage({type:'removeAttached',idx:i});c.appendChild(x);
    box.appendChild(c);
  });
}

function bindStatus(){
  document.querySelectorAll('#status .stp[data-task]').forEach(e=>e.onclick=()=>{if(e.dataset.task)vscode.postMessage(Object.assign({type:'task',task:e.dataset.task},st()));});
  document.querySelectorAll('#status a[data-f]').forEach(a=>a.onclick=()=>vscode.postMessage({type:'show',file:a.dataset.f}));
  document.querySelectorAll('#status a[data-open]').forEach(a=>a.onclick=()=>vscode.postMessage({type:'openExternal',file:a.dataset.open}));
  document.querySelectorAll('#status a[data-hist]').forEach(a=>a.onclick=()=>{showTab('hist');vscode.postMessage({type:'history:refresh',mode:'screen',sel:a.dataset.hist});});
}
function bindFlow(){
  document.querySelectorAll('#flow td.fc').forEach(td=>td.onclick=()=>vscode.postMessage({type:'flow:task',task:td.dataset.task,id:td.dataset.id}));
  document.querySelectorAll('#flow .fbtn[data-act]').forEach(b=>b.onclick=()=>vscode.postMessage({type:'flow:'+b.dataset.act,id:b.dataset.id}));
  const ff=document.getElementById('flow-f');if(ff)ff.addEventListener('keydown',e=>{if(e.key==='Enter')vscode.postMessage({type:'flow:refresh',filter:e.target.value});});
  const frf=document.getElementById('flow-rf');if(frf)frf.onclick=()=>vscode.postMessage({type:'flow:refresh',filter:(document.getElementById('flow-f')||{}).value||''});
}
function bindHist(){
  document.querySelectorAll('#hist [data-hmode]').forEach(b=>b.onclick=()=>vscode.postMessage({type:'history:refresh',mode:b.dataset.hmode,sel:''}));
  const hrf=document.getElementById('hist-rf');if(hrf)hrf.onclick=()=>vscode.postMessage({type:'history:refresh',mode:document.querySelector('#hist [data-hmode].on')?.dataset.hmode||'screen',sel:''});
  document.querySelectorAll('#hist .hit').forEach(e=>e.onclick=()=>vscode.postMessage({type:'history:select',dir:e.dataset.dir}));
  document.querySelectorAll('#hist .hf').forEach(e=>e.onclick=ev=>{if(ev.target.classList.contains('hlive'))return;vscode.postMessage({type:'history:diff',dir:e.dataset.dir,file:e.dataset.file});});
  document.querySelectorAll('#hist .hlive').forEach(b=>b.onclick=ev=>{ev.stopPropagation();vscode.postMessage({type:'history:diffLive',dir:b.dataset.dir,file:b.dataset.file});});
  const od=document.getElementById('hist-od');if(od)od.onclick=()=>vscode.postMessage({type:'openExternal',file:od.dataset.dir});
  const del=document.getElementById('hist-del');if(del)del.onclick=()=>vscode.postMessage({type:'history:delete',dir:del.dataset.dir});
}
bindStatus();

const procs={};
window.addEventListener('message',e=>{const m=e.data;
 if(m.type==='out'){if(m.stream==='task')flowOut(m.text);const box=$(m.stream==='be'?'belog':m.stream==='fe'?'felog':'log');const stick=box.scrollHeight-box.scrollTop-box.clientHeight<40;const d=document.createElement('span');if(m.cls)d.className=m.cls;d.textContent=m.text;box.appendChild(d);while(box.childNodes.length>4000)box.removeChild(box.firstChild);if(stick)box.scrollTop=box.scrollHeight;}
 else if(m.type==='server'){const st=$(m.name&&/BE/i.test(m.name)?'belogst':'felogst');if(st)st.textContent=m.state==='stopped'?'⏹ 종료됨':(m.ok?'✅ 기동 완료 ':'✖ 실패 ')+(m.sec!=null?m.sec+'s':'');}
 else if(m.type==='chat'){
   const stick=chatStick();
   if(m.role==='user'){newRun(String(m.text));}
   else if(m.role==='assistant'){if(RUN&&!RUN.done)addText(String(m.text));else{const d=document.createElement('div');d.className='m assistant';d.textContent=m.text;$('chat').appendChild(d);}}
   else if(m.role==='tool'){if(RUN&&!RUN.done)addTool(m);else{const d=document.createElement('details');d.className='m tool';const sm=document.createElement('summary');sm.textContent='🔧 '+(m.brief||firstLine(m.text));d.appendChild(sm);const b=document.createElement('div');b.className='mb';b.textContent=m.text;d.appendChild(b);$('chat').appendChild(d);}}
   else if(m.role==='result'){if(RUN&&!RUN.done)addResult(String(m.text));else{const d=document.createElement('details');d.className='m result';const sm=document.createElement('summary');sm.textContent='↳ '+firstLine(m.text).slice(0,160);d.appendChild(sm);const b=document.createElement('div');b.className='mb';b.textContent=m.text;d.appendChild(b);$('chat').appendChild(d);}}
   else {addMeta(String(m.text));}
   chatScroll(stick||m.role==='user');
   if(document.querySelector('.rtabs .rtb[data-t="chat"]').classList.contains('on')===false&&m.role!=='meta'){showTab('chat');}
 }
 else if(m.type==='fb'){const stick=chatStick();if(m.state==='start')flowStart(m);else if(m.state==='step')flowStep(m);else if(m.state==='end')flowEnd(m);chatScroll(stick||m.state==='start');if(m.state==='start'&&document.querySelector('.rtabs .rtb[data-t="chat"]').classList.contains('on')===false)showTab('chat');}
 else if(m.type==='todos'){const stick=chatStick();if(RUN&&!RUN.done)applyTodos(m.items||[]);chatScroll(stick);}
 else if(m.type==='run'){const stick=chatStick();if(m.state==='done')endRun(m.text||'',m.ok!==false);chatScroll(stick);}
 else if(m.type==='tab'){
   if(m.kind==='flow'){ // FLOW 탭: 기존 #flow 요소를 탭 안으로 옮겨 flow 메시지·bindFlow 가 그대로 동작
     if(!TABS['flow']){openTabUI({key:'flow',title:m.title||'📊 FLOW',sub:m.sub||'',path:'',kind:'flow',html:'',editable:false,canEditor:false});const T=TABS['flow'];const c=T.pane.querySelector('.dtc');const fl=$('flow');fl.style.display='';c.appendChild(fl);T.pane.querySelector('.dt-os').style.display='none';T.pane.querySelector('.dt-reload').onclick=()=>vscode.postMessage(Object.assign({type:'flow:refresh',filter:''},st()));}
     showTab('t:flow');
   } else openTabUI(m);
 }
 else if(m.type==='status'){$('status').innerHTML=m.html;bindStatus();}
 else if(m.type==='flow'){$('flow').innerHTML=m.html;bindFlow();}
 else if(m.type==='history'){$('hist').innerHTML=m.html;bindHist();}
 else if(m.type==='session'){$('sess').textContent=m.id?(UI_SESS+m.id.slice(0,8)):UI_NOSESS;}
 else if(m.type==='model'){const el=$('modelName');if(el)el.textContent=m.name||UI_AFTERSEND;if(m.name)addModelOpt(m.name,m.name);}
 else if(m.type==='showTab'){showTab(m.tab);}
 else if(m.type==='setModel'){if(m.id){addModelOpt(m.id,m.id);$('model').value=m.id;CUR_MODEL=m.id;save();}}
 else if(m.type==='proc'){if(m.state==='start')procs[m.id]=m.label;else delete procs[m.id];}
 else if(m.type==='busy'){
   const on=m.procs>0||m.claude;
   const b=$('busy');b.classList.toggle('on',on);
   const lbl=b.querySelector('.label');
   if(on){const parts=[];if(m.claude)parts.push('Claude 응답 중');if(m.procs>0)parts.push((m.labels||[]).join(', ')||(m.procs+'개 실행'));lbl.textContent=parts.join(' · ');}
   const th=$('thinking');if(th)th.classList.toggle('on',!!m.claude);
 }
 else if(m.type==='claude'){$('send').disabled=m.state==='start';$('send').textContent=m.state==='start'?UI_SENDING:UI_SEND;if(m.state==='end'&&RUN&&!RUN.done)endRun(null,m.code===0?true:(m.code==null?null:false));}
 else if(m.type==='setId'){CUR_ID=(m.id||'').toUpperCase();$('idBtn').textContent='📍 '+(CUR_ID||UI_NOID);vscode.postMessage(Object.assign({type:'state'},st()));vscode.postMessage(Object.assign({type:'status'},st()));}
 else if(m.type==='attached'){renderAttached(m.files||[]);}
});
</script></body></html>`;
}

// ── 1.6: 화면 ID 확정 유틸 (needsId quick 실행 전 반드시 호출) ──
//   사용자 지시: 묵시적 재사용 금지 — 항상 QuickPick 으로 명시 확인. "유지" 를 누를 때만 재사용.
async function pickFromAsisList(p, curId) {
  const script = path.join(p.root, 'tools', 'DbConn', 'list_asis_programs.py');
  if (!fs.existsSync(script)) {
    vscode.window.showWarningMessage('tools/DbConn/list_asis_programs.py 가 없어 목록 조회를 할 수 없습니다 — ID 직접 입력으로 진행하세요.');
    return null;
  }
  const data = await vscode.window.withProgress(
    { location: vscode.ProgressLocation.Notification, title: 'AS-IS DB 프로그램 목록 조회 중 (.env.asis)', cancellable: false },
    () => new Promise(res => {
      let buf = '';
      const child = cp.spawn(p.python || 'python', [script], { cwd: p.root, shell: process.platform === 'win32' });
      child.stdout.on('data', d => buf += d.toString('utf8'));
      child.stderr.on('data', d => buf += d.toString('utf8'));
      child.on('close', () => { try { res(JSON.parse(buf)); } catch { res({ ok: false, reason: (buf || '응답 없음').slice(0, 500) }); } });
      child.on('error', e => res({ ok: false, reason: `python 실행 실패: ${e.message}` }));
    })
  );
  if (!data.ok) { vscode.window.showWarningMessage(`AS-IS DB 조회 실패: ${data.reason || '사유 불명'} — 직접 입력으로 재시도하거나 .env.asis 를 확인하세요.`); return null; }
  const items = (data.items || []).map(it => ({
    label: `${it.id}  —  ${it.name || '(이름 없음)'}`,
    description: it.path || '',
    _id: it.id
  }));
  if (!items.length) { vscode.window.showInformationMessage('AS-IS 프로그램 목록이 비어 있습니다.'); return null; }
  const pick = await vscode.window.showQuickPick(items, {
    title: `AS-IS 프로그램 목록 (${items.length.toLocaleString()}건) · TB_FX_ProgramInfo UseYN=Y`,
    placeHolder: '프로그램 ID 또는 이름/경로로 검색' + (curId ? ` · 현재 ID: ${curId}` : ''),
    matchOnDescription: true,
    ignoreFocusOut: true
  });
  return pick ? pick._id : null;
}

async function confirmScreenIdOrPick(wb, curId, actionLabel) {
  const items = [];
  if (curId) items.push({ label: `✅ 현재 ID 유지 — ${curId}`, description: '명시적으로 확인 후 그대로 진행', _action: 'keep' });
  items.push({ label: '✏️ 다른 ID 직접 입력', description: '형식: 2~4자 영문 + 2~6자리 숫자 (예: DMF0052, SCP0096)', _action: 'input' });
  items.push({ label: '🔎 AS-IS DB 프로그램 목록에서 선택', description: 'TB_FX_ProgramInfo WHERE UseYN=\'Y\' (.env.asis 접속 필요)', _action: 'list' });
  items.push({ label: '⛔ 취소', description: '이 작업을 실행하지 않음', _action: 'cancel' });
  const pick = await vscode.window.showQuickPick(items, {
    title: `워크벤치 #${wb.inst} · "${actionLabel}" 실행 전 화면 ID 확정`,
    placeHolder: curId ? `현재 저장된 ID: ${curId}` : '화면 ID 가 설정되지 않았습니다 — 입력 또는 선택하세요',
    matchOnDescription: true,
    ignoreFocusOut: true
  });
  if (!pick || pick._action === 'cancel') return null;
  if (pick._action === 'keep') return curId;
  if (pick._action === 'input') {
    const nid = await vscode.window.showInputBox({
      prompt: '화면 ID 입력',
      value: curId || '',
      placeHolder: 'DMF0052',
      ignoreFocusOut: true,
      validateInput: v => v && !/^[A-Z]{2,4}[0-9]{2,6}$/i.test(v.trim()) ? '형식: 2~4자 영문 + 2~6자리 숫자' : null
    });
    if (!nid || !nid.trim()) return null;
    return nid.trim().toUpperCase();
  }
  if (pick._action === 'list') {
    const picked = await pickFromAsisList(wb.api.paths(), curId);
    return picked;
  }
  return null;
}

// ── open: 패널 생성/활성화 ──
function open(api, opts) {
  opts = opts || {};
  const fresh = !!opts.fresh;
  if (!fresh && lastWB && lastWB.panel && panels.has(lastWB)) {
    try { lastWB.panel.reveal(); return lastWB; } catch { }
  }
  const wb = new WB(api);
  const title = panels.size === 0 ? 'Vibe_Manager Workbench' : `Vibe_Manager Workbench #${wb.inst}`;
  const column = (fresh && panels.size > 0) ? vscode.ViewColumn.Beside : vscode.ViewColumn.Active;
  const panel = vscode.window.createWebviewPanel('vibeManager.workbench', title, column, { enableScripts: true, retainContextWhenHidden: true });
  const iconColor = vscode.Uri.file(path.join(api.ctx.extensionPath, 'media', 'vibe-color.svg'));
  const iconMono = vscode.Uri.file(path.join(api.ctx.extensionPath, 'media', 'vibe.svg'));
  try { panel.iconPath = { light: iconMono, dark: iconColor }; } catch { }
  wb.panel = panel; panels.add(wb); lastWB = wb;
  panel.onDidDispose(() => { panels.delete(wb); wb.stopAll(); if (lastWB === wb) lastWB = [...panels][0] || null; });

  const s = wb.getState();
  panel.webview.html = html(wb, api.paths(), Object.assign({ steps: api.loadSteps() }, s));

  const withCtx = (p, id, text, ctxCheck) => {
    // 자동 컨텍스트: 화면ID 가 있으면 체크 상태와 무관하게 attach
    if (!id) return text;
    const bits = [`[화면 ${id}]`];
    for (const f of ['GEN_NOTES.md', 'CHECK.md', 'DOD.md', 'PIPELINE.md']) if (fs.existsSync(path.join(p.genDir, id, f))) bits.push(`Doc/gen/${id}/${f}`);
    if (fs.existsSync(path.join(p.outDir, 'screens', id))) bits.push(`Doc/asisfacts/screens/${id}/`);
    bits.push('룰: tools/VibeManager/rules/10_RULES_KEEP.md');
    return `${bits.join(' · ')} — 참고 후: ${text}`;
  };

  const onMsg = async m => {
    const p = api.paths(); const id = (m.id || '').toUpperCase();
    try {
      switch (m.type) {
        case 'state': {
          const prev = wb.getState();
          wb.setState(Object.assign({}, prev, { id, permissionMode: m.permissionMode || prev.permissionMode, permVer: 2, model: m.model != null ? m.model : prev.model }));
          if (id) api.ctx.workspaceState.update('vibeManager.lastId', id);
          break;
        }
        case 'pickId': {
          const cur = id || api.ctx.workspaceState.get('vibeManager.lastId', '');
          const picked = await confirmScreenIdOrPick(wb, cur, '화면 ID 확정');
          if (picked === null) break;
          const prev = wb.getState(); wb.setState(Object.assign({}, prev, { id: picked }));
          if (picked) api.ctx.workspaceState.update('vibeManager.lastId', picked);
          wb.claudeSession = null; wb.post({ type: 'session', id: '' });
          wb.post({ type: 'setId', id: picked });
          wb.post({ type: 'chat', role: 'meta', text: picked ? `화면 ${picked} — 세션 리셋 · 다음 전송부터 ${picked} 컨텍스트가 자동 붙습니다` : '화면ID 해제' });
          vscode.commands.executeCommand('vibeManager.refresh');
          break;
        }
        case 'pickModel': {
          const v = await vscode.window.showInputBox({ prompt: 'Claude 모델 ID 또는 별칭 (--model 로 전달)', value: m.cur || '', placeHolder: 'claude-opus-5-5 · claude-fable-5-1 · sonnet …', ignoreFocusOut: true });
          if (v && v.trim()) wb.post({ type: 'setModel', id: v.trim() });
          break;
        }
        case 'remote': {
          // Claude Code 공식 /remote control CLI 플래그는 미공개 — 모바일 Claude Code 에서 동일 Anthropic 계정 로그인 후
          // 아래 세션 ID 로 'claude --resume <id>' 또는 "Resume session" 메뉴로 이어받는 흐름을 안내한다.
          const sid = wb.claudeSession || '';
          if (!sid) { vscode.window.showInformationMessage('현재 Claude 세션이 없습니다. 먼저 프롬프트를 한 번 보내면 세션이 생성됩니다.'); break; }
          const choice = await vscode.window.showInformationMessage(
            `📱 원격(모바일 Claude Code) 안내\n\n현재 세션 ID: ${sid}\n\n모바일 Claude Code 앱에서 동일 Anthropic 계정으로 로그인한 뒤 세션을 재개하면 이 작업을 이어서 확인·지시할 수 있습니다. 세션 ID 를 클립보드에 복사할까요?`,
            { modal: true }, '세션 ID 복사', 'claude --resume 명령 복사');
          if (choice === '세션 ID 복사') { await vscode.env.clipboard.writeText(sid); vscode.window.setStatusBarMessage(`세션 ID 복사됨: ${sid.slice(0, 12)}…`, 4000); }
          else if (choice === 'claude --resume 명령 복사') { await vscode.env.clipboard.writeText(`claude --resume ${sid}`); vscode.window.setStatusBarMessage('명령 복사됨', 4000); }
          break;
        }
        case 'editQuick': {
          const f = path.join(p.root, 'tools', 'VibeManager', 'quick.json');
          if (fs.existsSync(f)) vscode.commands.executeCommand('vscode.open', vscode.Uri.file(f));
          else vscode.window.showWarningMessage(`quick.json 없음: ${f}`);
          break;
        }
        case 'status': wb.post({ type: 'status', html: statusHtml(p, id) }); break;
        case 'flow:refresh': wb.post({ type: 'flow', html: flow.innerHtml(p, m.filter || '') }); break;
        case 'history:refresh': wb.post({ type: 'history', html: history.innerHtml(p, m.mode || 'screen', m.sel || '') }); break;
        case 'history:select': {
          const items = history.list(p); const meta = items.find(x => x.dir === m.dir);
          if (meta && !meta.afterMode) { try { history.finish(Object.assign({}, p, { pageDirOf: api.pageDirOf }), meta.dir, meta.exit, 'view'); } catch { } }
          wb.post({ type: 'history', html: history.innerHtml(p, 'screen', m.dir) });
          break;
        }
        case 'history:diff': {
          const b = path.join(m.dir, 'before', m.file), a = path.join(m.dir, 'after', m.file);
          // 1.9.0: VS Code diff 창 대신 Workbench diff 탭(수정전 ↔ 수정후). 1.8.0: 제목에 수정후의 실체(작업 종료 시점 vs 열람 시점 현재)를 명시
          let metaH = null; try { metaH = JSON.parse(fs.readFileSync(path.join(m.dir, 'meta.json'), 'utf8')); } catch { }
          const rd = f => { try { return fs.readFileSync(f, 'utf8'); } catch { return ''; } };
          wb.openDiffTab(`${m.dir}|${m.file}`, `${path.basename(m.file)} (${path.basename(m.dir)})`, fs.existsSync(b) ? rd(b) : '', fs.existsSync(a) ? rd(a) : '', fs.existsSync(b) ? '수정전' : '(없음)', fs.existsSync(a) ? history.afterLabel(metaH) : '(삭제됨)', `${m.dir} · ${m.file}`);
          break;
        }
        case 'history:diffLive': {
          const b = path.join(m.dir, 'after', m.file);
          try {
            const meta = JSON.parse(fs.readFileSync(path.join(m.dir, 'meta.json'), 'utf8'));
            const src = (meta.sources || []).find(s => m.file.startsWith(s.name + path.sep) || m.file.startsWith(s.name + '/'));
            const live = src ? path.join(src.dir, m.file.slice(src.name.length + 1)) : '';
            if (live && fs.existsSync(live)) wb.openDiffTab(`${m.dir}|${m.file}|live`, `${path.basename(m.file)} (작업후 ↔ 현재)`, fs.existsSync(b) ? fs.readFileSync(b, 'utf8') : '', fs.readFileSync(live, 'utf8'), '작업후', '현재', `${b} ↔ ${live}`);
            else vscode.window.showWarningMessage('현재 파일 없음');
          } catch (e) { vscode.window.showErrorMessage(`diffLive 실패: ${e.message}`); }
          break;
        }
        case 'history:delete': {
          const ok = await vscode.window.showWarningMessage(`이력 삭제: ${path.basename(m.dir)}`, { modal: true }, '삭제');
          if (ok === '삭제') { try { fs.rmSync(m.dir, { recursive: true, force: true }); } catch { } wb.post({ type: 'history', html: history.innerHtml(p, 'screen', '') }); }
          break;
        }
        case 'flow:task': {
          const pd = (() => { try { const r = JSON.parse(fs.readFileSync(path.join(p.genDir, m.id, 'register.json'), 'utf8')); return path.join(p.tobeDir, 'features', r.feature, 'src', 'pages', r.pageDir); } catch { return ''; } })();
          await api.runTaskById(m.task, { id: m.id, ids: m.id, dir: pd });
          break;
        }
        case 'flow:pipeline': await api.runTaskById('S5.pipeline', { id: m.id, ids: m.id }); break;
        case 'flow:open': wb.openTab(p, path.join(p.genDir, m.id)); break; // 1.9.0: 폴더 탭
        case 'cmd': vscode.commands.executeCommand(m.command); break;
        case 'show': wb.openTab(p, m.file); break; // 1.9.0: UI Status 칩 → Workbench 탭
        case 'tab:open': wb.openTab(p, m.file, { line: m.line || 0 }); break;
        case 'tab:closed': htmlTabs.delete(String(m.key || '').replace(/^html:/, '')); break;
        case 'tab:refresh': { const key = String(m.key || '').replace(/^html:/, ''); const h = htmlTabs.get(key); if (h) openHtmlTab(key, h.title, h.sub, h.render, h.onAction); break; } // 1.9.3 HTML 탭 다시 그리기
        case 'tab:action': { const key = String(m.key || '').replace(/^html:/, ''); const h = htmlTabs.get(key); if (h && h.onAction) { try { await h.onAction(m.action, m.data || {}); } catch (e) { vscode.window.showErrorMessage(`탭 동작 실패: ${e.message}`); } } break; }
        case 'tab:editor': { try { const doc = await vscode.workspace.openTextDocument(vscode.Uri.file(m.file)); const ed = await vscode.window.showTextDocument(doc, { preview: false, viewColumn: vscode.ViewColumn.Beside }); if (m.line) { const pos = new vscode.Position(Math.max(0, m.line - 1), 0); ed.selection = new vscode.Selection(pos, pos); ed.revealRange(new vscode.Range(pos, pos)); } } catch (e) { vscode.window.showErrorMessage(`에디터 열기 실패: ${e.message}`); } break; }
        case 'tab:os': openWithOS(p, wb, m.file); break;
        case 'tab:ext': if (/^https?:\/\//i.test(String(m.url || ''))) vscode.env.openExternal(vscode.Uri.parse(m.url)); break;
        case 'tab:save': { // 탭 안에서 저장 — 텍스트 파일만, 저장 후 같은 탭을 다시 렌더
          try { if (!m.file || !fs.existsSync(m.file) || fs.statSync(m.file).isDirectory()) throw new Error('파일이 아닙니다'); fs.writeFileSync(m.file, String(m.text == null ? '' : m.text), 'utf8'); wb.out('task', `💾 저장: ${path.relative(p.root, m.file)}\n`, 'ok'); wb.openTab(p, m.file); if (/quick\.json$/i.test(m.file)) vscode.commands.executeCommand('vibeManager.refresh'); }
          catch (e) { vscode.window.showErrorMessage(`저장 실패: ${e.message}`); }
          break;
        }
        case 'openExternal': openWithOS(p, wb, m.file); break;
        case 'prompt': {
          // 1.6: ctx/harness 체크박스 제거 — ID 가 있으면 자동 컨텍스트, 자동 하네스는 effectiveHarness 가 판정.
          const h = effectiveHarness(false, null, null, id);
          wb.askClaude(p, withCtx(p, id, m.text, true), h);
          api.record('prompt', m.text.slice(0, 120));
          break;
        }
        case 'newSession': wb.claudeSession = null; wb.post({ type: 'session', id: '' }); wb.post({ type: 'chat', role: 'meta', text: '새 세션 — 다음 전송부터 새 대화' }); break;
        case 'newScreen': {
          // 1.6: 하단에서는 'pickId' 가 호출된다. 이 핸들러는 외부(명령/트리뷰)에서 들어올 때 호환용.
          const cur = id || api.ctx.workspaceState.get('vibeManager.lastId', '');
          const picked = await confirmScreenIdOrPick(wb, cur, '화면 ID 확정');
          if (picked === null) break;
          const prev = wb.getState(); wb.setState(Object.assign({}, prev, { id: picked }));
          if (picked) api.ctx.workspaceState.update('vibeManager.lastId', picked);
          wb.claudeSession = null; wb.post({ type: 'session', id: '' });
          wb.post({ type: 'setId', id: picked });
          wb.post({ type: 'chat', role: 'meta', text: picked ? `화면 ${picked} — 세션 리셋 · 다음 전송부터 ${picked} 컨텍스트가 자동 붙습니다` : '화면ID 해제' });
          vscode.commands.executeCommand('vibeManager.refresh');
          break;
        }
        case 'newWindow': {
          const nwb = open(api, { fresh: true });
          wb.out('task', `➕ 워크벤치 #${nwb.inst} 열림 — 독립 Claude 세션/화면ID 로 멀티 작업\n`, 'ok');
          break;
        }
        case 'stop': wb.stopAll(); wb.out('task', '⏹️ 중지 요청\n', 'warn'); break;
        case 'task': await wb.runTaskStreaming(p, m.task, id); break;
        case 'pickFiles': {
          const uris = await vscode.window.showOpenDialog({ canSelectMany: true, canSelectFiles: true, canSelectFolders: false, openLabel: '첨부' });
          if (!uris || !uris.length) break;
          const files = uris.map(u => ({ path: u.fsPath, name: path.basename(u.fsPath), isImage: /\.(png|jpe?g|gif|webp|bmp|svg)$/i.test(u.fsPath) }));
          wb.attached.push(...files);
          wb.post({ type: 'attached', files: wb.attached });
          break;
        }
        case 'removeAttached': {
          wb.attached.splice(m.idx, 1);
          wb.post({ type: 'attached', files: wb.attached });
          break;
        }
        case 'pastedImage': {
          try {
            const dir = path.join(p.vibeDir, 'attached'); fs.mkdirSync(dir, { recursive: true });
            const ts = history.nowLocal().slice(0, 19).replace(/[:.]/g, '-');
            const ext = (String(m.mime || 'image/png').split('/')[1] || 'png').replace(/[^\w]/g, '');
            const file = path.join(dir, `paste-${ts}.${ext}`);
            const base64 = String(m.data || '').split(',')[1] || String(m.data || '');
            fs.writeFileSync(file, Buffer.from(base64, 'base64'));
            wb.attached.push({ path: file, name: path.basename(file), isImage: true });
            wb.post({ type: 'attached', files: wb.attached });
            wb.out('task', `📎 붙여넣기 이미지 저장: ${path.relative(p.root, file)}\n`, 'ok');
          } catch (e) { wb.out('task', `붙여넣기 저장 실패: ${e.message}\n`, 'bad'); }
          break;
        }
        case 'quick': {
          const item = m.item;
          // 1.6: needsId 아이템은 묵시 재사용 금지 — 매번 QuickPick 로 명시 확인(유지/변경/목록선택/취소).
          let effId = id;
          if (item.needsId) {
            effId = await confirmScreenIdOrPick(wb, id || api.ctx.workspaceState.get('vibeManager.lastId', ''), item.label);
            if (!effId) { wb.out('task', `⛔ 취소됨 — "${item.label}"\n`, 'warn'); break; }
            if (effId !== id) {
              const s = wb.getState(); wb.setState(Object.assign({}, s, { id: effId }));
              api.ctx.workspaceState.update('vibeManager.lastId', effId);
              wb.post({ type: 'setId', id: effId });
              wb.claudeSession = null; wb.post({ type: 'session', id: '' });
              wb.post({ type: 'chat', role: 'meta', text: `화면 ID → ${effId} · 세션 리셋` });
            }
          }
          const taskId = item.kind === 'task' ? item.task : null;
          const h = effectiveHarness(m.harness, taskId, item, effId);
          if (item.kind === 'task') await wb.runTaskStreaming(p, item.task, effId);
          else if (item.kind === 'chain') { // 1.8.8: 순차 체인(파싱→…→문서 등)
            // 1.9.2: 화면 ID 확정(QuickPick) 뒤 두 번째 모달 확인창은 없앤다 — 바깥 클릭/Esc 로 조용히 취소돼 "실행이 안 된다" 로 보였음(사용자 지시 "신규 ID 넣으면 바로 진행").
            //        대신 비차단 알림으로 시작을 알리고, 내용(item.confirm)은 Task Log 에 남긴다. 중지는 워크벤치 ⏹ 중지.
            if (item.confirm) wb.out('task', `ℹ ${item.confirm}\n`, '');
            vscode.window.showInformationMessage(`Vibe_Manager 🚀 ${item.label} — ${effId} 시작 (Claude 탭 Flow 보드에서 진행 확인)`);
            await wb.runChain(p, item, effId, h);
          }
          else if (item.kind === 'claude') wb.askClaude(p, substQ(item.prompt, { root: p.root, id: effId }), h);
          else if (item.kind === 'command') vscode.commands.executeCommand(item.command);
          else if (item.kind === 'flowtab') { wb.post({ type: 'tab', key: 'flow', kind: 'flow', title: '📊 FLOW', sub: 'FLOW — 화면별 단계 진척(파싱→…→E2E 4단계)', editable: false, canEditor: false, canOS: false }); } // 1.9.0: FLOW = 고정 탭에서 제외, 메뉴로 여는 탭
          else if (item.kind === 'terminal' || item.kind === 'multi' || item.kind === 'server-stop') {
            const all = promptPanel.loadQuick(p.extDir, p.root).groups.flatMap(g => g.items);
            const items = item.kind === 'multi' ? item.items.map(l => all.find(x => x.label === l)).filter(Boolean) : [item];
            for (const it of items) {
              const name = it.name || it.label;
              if (it.kind === 'server-stop') { await wb.stopServer(p, it, name); continue; } // 1.8.1: Finish
              const cwd = substQ(it.cwd, { root: p.root });
              if (!fs.existsSync(cwd)) { wb.out('task', `폴더 없음: ${cwd}\n`, 'bad'); continue; }
              if ([...wb.procs.values()].some(x => x.label === name)) { wb.out('task', `${name} 이미 실행 중\n`, 'warn'); continue; }
              // 1.7.9: 포트 선점검 — 이미 LISTEN 이면 점유 프로세스 이름을 보여주고 기동하지 않는다(종료는 사용자 판단 · F5FltSrv 등 VPN 프로세스 보호)
              if (it.port) { const occ = portOwner(it.port); if (occ) { wb.out('task', `⏸ ${name} 기동 생략 — 포트 ${it.port} 이미 사용 중: ${occ}\n   재기동하려면 그 프로세스를 먼저 종료하세요(VPN 관련 프로세스면 종료 금지).\n`, 'warn'); wb.post({ type: 'chat', role: 'meta', text: `⏸ ${name}: 포트 ${it.port} 이미 사용 중 (${occ}) — 기동 생략` }); continue; } }
              wb.startServerStream(p, it, cwd, name);
            }
          }
          else if (item.kind === 'git-upload-ui') {
            // 1.8.2: 화면 하나의 FE 소스만 공통소스 Git(common) 에 올린다.
            //   방식 = common/<base> 트리 + 선택 파일만 얹은 커밋(임시 인덱스 · 작업 브랜치와 무관) → <fetch URL> 로 feat/<id>-<날짜> 푸시.
            //   원격 'common' 의 push URL(no_push) 은 바꾸지 않고 fetch URL 을 명시적으로 사용. 삭제 파일은 반영하지 않는다(추가·수정만).
            const cwd = substQ(item.cwd, { root: p.root }); const ID = (effId || '').toUpperCase();
            const git = (args, opts) => { const r = cp.spawnSync('git', args, Object.assign({ cwd, encoding: 'utf8', windowsHide: true, maxBuffer: 64 * 1024 * 1024 }, opts || {})); return { code: r.status, out: ((r.stdout || '') + (r.stderr || '')).trim() }; };
            const rel = f => path.relative(cwd, f).split(path.sep).join('/');
            // ① 페이지 폴더 — register.json → 없으면 __asis-mapping__.md 에 ID 가 있는 pages 폴더 → 없으면 직접 입력
            let pageAbs = api.pageDirOf(ID) || '';
            if (!pageAbs || !fs.existsSync(pageAbs)) {
              pageAbs = '';
              const featRoot = path.join(cwd, 'features');
              try { for (const f of fs.readdirSync(featRoot)) { const pg = path.join(featRoot, f, 'src', 'pages'); if (!fs.existsSync(pg)) continue; for (const d of fs.readdirSync(pg)) { const mp = path.join(pg, d, '__asis-mapping__.md'); if (fs.existsSync(mp) && new RegExp(`\\b${ID}\\b`).test(fs.readFileSync(mp, 'utf8').slice(0, 4000))) { pageAbs = path.join(pg, d); break; } } if (pageAbs) break; } } catch { }
              if (!pageAbs) { const v = await vscode.window.showInputBox({ prompt: `${ID} 페이지 폴더 (nscm-fe 기준 상대경로)`, placeHolder: 'features/supply/src/pages/xxx', ignoreFocusOut: true }); if (!v) return; pageAbs = path.join(cwd, v.trim()); }
              if (!fs.existsSync(pageAbs)) { wb.out('task', `페이지 폴더 없음: ${pageAbs}\n`, 'bad'); return; }
            }
            const pageRel = rel(pageAbs); const pageBase = path.basename(pageAbs);
            const walkFiles = (dir, out = []) => { for (const e of fs.readdirSync(dir, { withFileTypes: true })) { const f = path.join(dir, e.name); if (e.isDirectory()) { if (!/node_modules|\.git/.test(e.name)) walkFiles(f, out); } else out.push(f); } return out; };
            const pageFiles = walkFiles(pageAbs).map(rel);
            // ② 그 화면을 참조하는 변경 파일(라우트 등록·feature index·i18n 등) — 경로/내용에 pageDir 이름 또는 ID
            const st = git(['status', '--porcelain', '-uall']).out.split(/\r?\n/).filter(Boolean).map(l => l.slice(3).replace(/^.* -> /, '').replace(/^"|"$/g, ''));
            //   경로 = pageDir 이름 또는 ID 포함 · 내용 = pageDir 이름(import 경로 등) 포함. 내용의 ID 만으로는 잡지 않는다(다른 화면의 대사표·문서가 ID 를 언급해 섞여 들어옴 — 2026-10-20 실측 shipment-working-day).
            //   다른 화면 폴더(src/pages/<다른 dir>/) 안의 파일은 이 화면의 소스가 아니므로 제외.
            const escRe = s => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
            const pathRe = new RegExp(`${escRe(pageBase)}|\\b${ID}\\b`, 'i'); const bodyRe = new RegExp(escRe(pageBase), 'i');
            const otherPage = f => /(^|\/)src\/pages\/[^/]+\//.test(f) && !f.startsWith(pageRel + '/');
            const related = st.filter(f => !f.startsWith(pageRel + '/') && f !== pageRel && !otherPage(f)).filter(f => { if (pathRe.test(f)) return true; try { const full = path.join(cwd, f); return fs.existsSync(full) && fs.statSync(full).size < 2 * 1024 * 1024 && bodyRe.test(fs.readFileSync(full, 'utf8')); } catch { return false; } });
            // ⛔ 업로드 금지 영역(사용자 지시 2026-10-20: Source Backup 이외에는 Vibe_Manager 관련 소스 절대 업로드 금지) + 화면 소스 허용 영역
            //    금지: tools/ · VibeManager · Harness · .vibe · .claude · _artifacts · Doc/ · .husky · 루트 설정류   /   허용: features/ · apps/web/src/ · packages/ 아래 소스만
            const DENY_RE = /(^|\/)(tools|\.vibe|\.claude|_artifacts|Doc|\.husky|node_modules|dist|build)(\/|$)|VibeManager|Harness|\.vsix$|\.env(\.|$)/i;
            const ALLOW_RE = /^(features|apps\/web\/src|packages)\//;
            const guard = f => !DENY_RE.test(f) && ALLOW_RE.test(f);
            const relatedOk = related.filter(guard); const relatedDenied = related.filter(f => !guard(f));
            if (relatedDenied.length) wb.out('task', `ℹ 업로드 대상에서 제외(허용 영역 밖): ${relatedDenied.slice(0, 8).join(', ')}${relatedDenied.length > 8 ? ' …' : ''}\n`, 'warn');
            // 후보 = 이 화면의 페이지 폴더 + 이 화면을 참조하는 변경 파일 뿐 — 그 밖의 변경 파일은 선택지에 올리지 않는다("특정 UI ID 기준으로 작업된 소스만")
            const picks = [
              ...pageFiles.filter(guard).map(f => ({ label: f, description: '페이지 폴더', picked: true, _f: f })),
              ...relatedOk.map(f => ({ label: f, description: '이 화면 참조(변경됨)', picked: true, _f: f })),
            ];
            if (!picks.length) { wb.out('task', `⛔ 업로드할 화면 소스가 없음 (${pageRel})\n`, 'warn'); return; }
            const sel = await vscode.window.showQuickPick(picks, { canPickMany: true, title: `Source Upload(UI) · ${ID} · ${pageRel}`, placeHolder: `업로드할 파일 선택 — ${ID} 화면 소스만 (페이지 폴더 + 이 화면 참조 변경 파일)`, ignoreFocusOut: true, matchOnDescription: true });
            if (!sel || !sel.length) { wb.out('task', `⛔ 취소 — 선택 파일 없음\n`, 'warn'); return; }
            const files = sel.map(x => x._f);
            const leak = files.filter(f => !guard(f));
            if (leak.length) { wb.out('task', `⛔ 업로드 중단 — 허용 영역 밖 파일 포함: ${leak.join(', ')}\n`, 'bad'); vscode.window.showErrorMessage(`Vibe_Manager ⛔ Source Upload(UI): Vibe_Manager/도구 소스는 업로드할 수 없습니다 (${leak[0]})`); return; }
            const url = git(['remote', 'get-url', item.remote || 'common']).out; if (!/^(https?:\/\/|ssh:\/\/|git@|file:\/\/|[A-Za-z]:[\\/]|\/)/.test(url)) { wb.out('task', `원격 ${item.remote} URL 없음: ${url}\n`, 'bad'); return; }
            const base = item.baseBranch || 'main'; const d = history.nowLocal().slice(0, 10).replace(/-/g, '');
            const branch = await vscode.window.showInputBox({ prompt: `푸시할 브랜치 (원격 ${url.replace(/\/\/[^@]+@/, '//')})`, value: `feat/${ID.toLowerCase()}-${d}`, ignoreFocusOut: true, validateInput: v => /^[\w./-]+$/.test(v.trim()) ? null : '브랜치 이름 형식' }); if (!branch) return;
            const msg = await vscode.window.showInputBox({ prompt: '커밋 메시지', value: `feat(${ID}): ${pageBase} 화면 소스 업로드 (${files.length} files)`, ignoreFocusOut: true }); if (!msg) return;
            const ok = await vscode.window.showWarningMessage(`${ID} 소스 ${files.length}개 → ${url.replace(/\/\/[^@]+@/, '//')} 의 ${branch.trim()} (base: ${base})\n다른 작업 파일은 포함되지 않습니다. 진행할까요?`, { modal: true }, '업로드');
            if (ok !== '업로드') return;
            wb.post({ type: 'showTab', tab: 'log' });
            wb.out('task', `▶ Source Upload(UI) ${ID}\n  repo ${cwd}\n  base ${item.remote}/${base} · branch ${branch.trim()} · files ${files.length}\n`, 'cmd');
            const step = (label, args, env) => { const r = git(args, env ? { env: Object.assign({}, process.env, env) } : undefined); wb.out('task', `$ git ${args.join(' ').slice(0, 160)}\n${r.out ? r.out.split(/\r?\n/).slice(-6).join('\n') + '\n' : ''}`, r.code === 0 ? '' : 'bad'); if (r.code !== 0) throw new Error(`${label} 실패 (exit ${r.code}): ${r.out.split(/\r?\n/).slice(-2).join(' ')}`); return r.out; };
            const idx = path.join(require('os').tmpdir(), `vibe_ui_upload_${Date.now()}.idx`); const genv = { GIT_INDEX_FILE: idx };
            // 푸시 전 게이트: nscm-fe 의 pre-push 훅은 `pnpm type-check`(이 PC 는 pnpm 금지 → 항상 실패)와 현재 작업 브랜치 이름만 보고,
            //   우리가 올리는 건 작업 트리가 아니라 'common/<base> + 선택 파일' 합성 커밋이다 → 훅 대신 하네스 게이트(check.js --final)를 페이지에 돌리고 --no-verify 로 푸시
            const checkJs = path.join(p.harnessDir || path.join(p.root, 'tools', 'Harness'), 'check.js');
            if (fs.existsSync(checkJs)) {
              const g = cp.spawnSync(p.node || 'node', [checkJs, '--page', pageAbs, '--id', ID, '--final', '--json'], { cwd: p.root, encoding: 'utf8', windowsHide: true, maxBuffer: 64 * 1024 * 1024 });
              const line = ((g.stdout || '') + '').split(/\r?\n/).find(l => l.startsWith('{')); let gate = null; try { gate = JSON.parse(line); } catch { }
              const blk = gate ? Number(gate.block || 0) : -1;
              wb.out('task', `게이트 check.js --final: ${gate ? `BLOCK ${gate.block} / WARN ${gate.warn}` : '판정 실패(출력 해석 불가)'}\n`, blk === 0 ? 'ok' : 'warn');
              if (blk !== 0) { const go = await vscode.window.showWarningMessage(`${ID} 하네스 게이트 ${gate ? `BLOCK ${gate.block}` : '판정 실패'} — 그래도 업로드할까요?`, { modal: true }, '그래도 업로드'); if (go !== '그래도 업로드') { wb.out('task', `⛔ 업로드 중단 — 게이트 미통과 (Doc/gen/${ID}/CHECK.md 확인)\n`, 'warn'); return; } }
            }
            try {
              step('fetch', ['fetch', url, `${base}:refs/remotes/${item.remote || 'common'}/${base}`]);
              step('read-tree', ['read-tree', `refs/remotes/${item.remote || 'common'}/${base}`], genv);
              for (let i = 0; i < files.length; i += 40) step('update-index', ['update-index', '--add', '--replace', '--', ...files.slice(i, i + 40)], genv);
              const tree = step('write-tree', ['write-tree'], genv).trim();
              const commit = step('commit-tree', ['commit-tree', tree, '-p', `refs/remotes/${item.remote || 'common'}/${base}`, '-m', msg.trim()]).trim();
              step('push', ['push', '--no-verify', url, `${commit}:refs/heads/${branch.trim()}`]); // pre-push(pnpm type-check·현재 브랜치명 검사)는 합성 커밋과 무관 → 위 하네스 게이트로 대체
              const web = url.replace(/\/\/[^@]+@/, '//').replace(/\.git$/, '') + `/tree/${branch.trim()}`;
              wb.out('task', `✅ 업로드 완료 — ${files.length}개 파일 · 커밋 ${commit.slice(0, 10)} · ${web}\n   (로컬 작업 브랜치·인덱스는 건드리지 않았습니다)\n`, 'ok');
              wb.post({ type: 'chat', role: 'meta', text: `✅ Source Upload(UI) ${ID} → ${branch.trim()} (${files.length} files)` });
              Promise.resolve(vscode.window.showInformationMessage(`Vibe_Manager ✅ ${ID} 소스 ${files.length}개 → ${branch.trim()} 업로드 완료`, '브라우저로 열기')).then(a => { if (a) vscode.env.openExternal(vscode.Uri.parse(web)); }, () => { });
            } catch (e) {
              wb.out('task', `✖ ${e.message}\n   (권한 거부 403 이면 eunjoo-hwang/nscm-fe 에 push 권한이 없는 계정입니다 — 저장소 소유자에게 요청)\n`, 'bad');
              vscode.window.showErrorMessage(`Vibe_Manager ✖ Source Upload(UI) 실패: ${e.message.slice(0, 160)}`);
            } finally { try { fs.rmSync(idx, { force: true }); } catch { } }
            api.record('quick', `${item.label} ${ID} ${branch ? branch.trim() : ''}`);
            break;
          }
          else if (item.kind === 'git-upload') {
            const cwd = substQ(item.cwd, { root: p.root });
            const msg = await vscode.window.showInputBox({ prompt: `커밋 메시지 (${item.remote}/${item.branch} 로 push) — 화면 작업은 MNU_ID 명시 (예: feat(DMF0052): …)`, ignoreFocusOut: true });
            if (!msg) return;
            const ok = await vscode.window.showWarningMessage(`전체 stage(.gitignore 적용) → commit → push ${item.remote} ${item.branch}${item.credUser ? ` (계정 ${item.credUser})` : ''}`, { modal: true }, 'push 실행', 'status 만');
            if (!ok) return;
            // 1.8.6: push 에만 자격증명 사용자명 1회 지정(credUser · 전역 git 설정 변경 없음) — 이 PC 전역 username 이 사내 계정이라 비대화 push 가 인증 실패하던 문제
            const cred = item.credUser ? `-c credential.https://github.com.username=${item.credUser} ` : '';
            const line = ok === 'status 만' ? 'git status -s' : `git add -A && git commit -m "${msg.replace(/"/g, "'")}" && git ${cred}push ${item.remote} ${item.branch}`;
            wb.spawnStream(p, 'cmd', ['/c', line], { spawn: { cwd }, env: { GIT_TERMINAL_PROMPT: '0' } }, 'task', item.label);
          }
          else if (item.kind === 'git-merge') {
            const cwd = substQ(item.cwd, { root: p.root });
            const br = await vscode.window.showInputBox({ prompt: `${item.remote} 의 병합할 브랜치`, value: item.branch || 'main', ignoreFocusOut: true });
            if (!br) return;
            const ok = await vscode.window.showWarningMessage(`git merge --no-ff ${item.remote}/${br} — 충돌 시 출력에 표시됩니다(공용 패키지 foundation/shared 는 Hard Boundary).`, { modal: true }, '병합');
            if (ok !== '병합') return;
            wb.spawnStream(p, 'cmd', ['/c', `git fetch ${item.remote} && git merge --no-ff ${item.remote}/${br}`], { spawn: { cwd }, env: { GIT_TERMINAL_PROMPT: '0' } }, 'task', item.label);
          }
          else if (item.kind === 'git-status' || item.kind === 'git-fetch') {
            const cwd = substQ(item.cwd, { root: p.root });
            const cmdline = item.kind === 'git-status' ? 'git status -s && git log --oneline -5' : `git fetch ${item.remote} && git branch -r --list "${item.remote}/*" && git log --oneline HEAD..${item.remote}/main -20`;
            wb.spawnStream(p, 'cmd', ['/c', cmdline], { spawn: { cwd } }, 'task', item.label);
          }
          else if (item.kind === 'browser') vscode.env.openExternal(vscode.Uri.parse(item.url));
          else if (item.kind === 'open') wb.openTab(p, substQ(item.path, { root: p.root, id: effId })); // 1.9.0: Workbench 탭(없으면 안내)
          api.record('quick', `${item.label} ${effId}`);
          break;
        }
      }
    } catch (e) { vscode.window.showErrorMessage(`워크벤치: ${e.message}`); wb.out('task', `오류: ${e.message}\n`, 'bad'); }
  };

  panel._onQuick = onMsg; panel._wb = wb;
  panel.webview.onDidReceiveMessage(onMsg);
  return wb;
}

function ask(text, harness) { if (!lastWB) return; lastWB.askClaude(lastWB.api.paths(), text, harness); }
// 1.7.7: 확장 runShell 위임 — 열린 워크벤치가 있으면 거기서 스트리밍 실행(true), 없으면 false(호출측이 VS Code 작업으로 fallback)
async function runShell(task, vars, extraArgs) {
  if (!lastWB || !lastWB.panel || !panels.has(lastWB)) return false;
  await lastWB.execShell(lastWB.api.paths(), task, vars, extraArgs || null, (vars.inputs && (vars.inputs.id || (vars.inputs.ids || '').split(/\s+/)[0]) || '').toUpperCase());
  return true;
}
async function quick(item, id, harness) {
  if (!lastWB || !lastWB.panel) return;
  try { lastWB.panel.webview.postMessage({ type: 'noop' }); } catch { }
  await lastWB.panel._onQuick({ type: 'quick', item, id, harness });
}

// 1.9.0: 확장(사이드바·steps open)에서 Workbench 탭으로 열기 — 열린 Workbench 가 없으면 false(호출 측이 에디터로)
function openTab(file, opts) { if (!lastWB) return false; return lastWB.openTab(lastWB.api.paths(), file, opts || {}); }
// 1.9.3: HTML 탭(대시보드 등 확장이 만든 화면) — render() 가 본문 HTML 을 돌려주고, 본문의 [data-action] 클릭은 onAction(action, dataset) 으로 전달. 🔄 = 다시 render
const htmlTabs = new Map();
function openHtmlTab(key, title, sub, render, onAction) {
  if (!lastWB) return false;
  htmlTabs.set(key, { title, sub, render, onAction });
  let html = ''; try { html = String(render() || ''); } catch (e) { html = `<div class="hint">렌더 실패: ${tabview.esc(e.message)}</div>`; }
  lastWB.post({ type: 'tab', key: 'html:' + key, kind: 'html', title, sub: sub || '', path: '', html, editable: false, canEditor: false, canOS: false, meta: '' });
  try { lastWB.panel.reveal(undefined, true); } catch { }
  return true;
}
function refreshHtmlTab(key) { const h = htmlTabs.get(key); if (!h || !lastWB) return false; return openHtmlTab(key, h.title, h.sub, h.render, h.onAction); }
function showTab(tab) { if (!lastWB) return false; lastWB.post({ type: 'showTab', tab }); try { lastWB.panel.reveal(undefined, true); } catch { } return true; }
function openDiff(key, title, aText, bText, aLabel, bLabel, sub) { if (!lastWB) return false; lastWB.openDiffTab(key, title, aText, bText, aLabel, bLabel, sub); return true; }
function openFlowTab() { if (!lastWB) return false; lastWB.post({ type: 'tab', key: 'flow', kind: 'flow', title: '📊 FLOW', sub: 'FLOW — 화면별 단계 진척(파싱→…→E2E 4단계)', editable: false, canEditor: false, canOS: false }); try { lastWB.panel.reveal(undefined, true); } catch { } return true; }
module.exports = { open, ask, quick, runShell, openTab, openDiff, openFlowTab, openHtmlTab, refreshHtmlTab, showTab };
