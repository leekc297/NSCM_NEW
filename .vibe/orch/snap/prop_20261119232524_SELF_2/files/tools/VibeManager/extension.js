// Vibe_Manager v1.0 — NSCM 전환 6단계 작업 관리 (의존성 없음, VS Code API 만 사용)
'use strict';
const vscode = require('vscode');
const promptPanel = require('./prompt-panel');
const menuView = require('./menu-view');
const flowPanel = require('./flow-panel');
const { pendingRecheck } = require('./recheck'); // 2026-11-19 미검증 해소 뒤 보완 전 CheckList 건수 숨김
const history = require('./history');
const workbench = require('./workbench');
const fs = require('fs');
const path = require('path');
const cp = require('child_process');

let ctx, tree, harnessTree, envTree, dodTree, menuTree, out, statusBar, dashboard;
const RUNS_KEY = 'vibeManager.runs';

// ───────────────────────── 1.7.5: Claude CLI 자동 선택 ─────────────────────────
//   원인(2026-10-19): PATH 의 claude(~/.local/bin, 2.1.123 — 자동 업데이트 정지)가 하네스에서 실행되어
//   계정 기본 모델 요청이 "Claude Code 2.1.123 does not support this model; 2.1.251+ required"(400)로 중지.
//   → vibeManager.claudeCommand 가 기본값('claude')이면 PATH + VS Code Claude Code 확장 내장 CLI 중 **최신 버전**을 쓴다.
//     선택 경로는 하위 프로세스에 CLAUDE_BIN(하네스) · ASISFACTS_CLAUDE(AsisFacts agent) 로 전달.
const CLAUDE_MIN = '2.1.280'; // Fable 5.1 = 2.1.251+, Opus 5.5 = 2.1.280+ (2026-10-19 실측)
let claudeBin = null; // { file, ver }
function cmpVer(a, b) { const x = String(a).split('.').map(Number), y = String(b).split('.').map(Number); for (let i = 0; i < 3; i++) { const d = (x[i] || 0) - (y[i] || 0); if (d) return d; } return 0; }
function claudeVersionOf(file) {
  let st; try { st = fs.statSync(file); } catch { return null; }
  const key = `${file}|${st.mtimeMs}|${st.size}`; const cache = (ctx && ctx.globalState.get('vibeManager.claudeVer')) || {};
  if (cache[key]) return cache[key];
  try {
    const outp = cp.execFileSync(file, ['--version'], { encoding: 'utf8', timeout: 20000, windowsHide: true, shell: /\.(cmd|bat)$/i.test(file) });
    const m = /(\d+\.\d+\.\d+)/.exec(outp || ''); if (!m) return null;
    cache[key] = m[1]; if (ctx) ctx.globalState.update('vibeManager.claudeVer', cache); return m[1];
  } catch { return null; }
}
function claudeCandidates() {
  const os = require('os'); const home = os.homedir(); const exe = process.platform === 'win32' ? 'claude.exe' : 'claude'; const out = [];
  for (const dir of (process.env.PATH || '').split(path.delimiter)) for (const n of process.platform === 'win32' ? ['claude.exe', 'claude.cmd'] : ['claude']) { const f = path.join(dir.replace(/"/g, ''), n); if (fs.existsSync(f)) out.push(f); }
  for (const f of [path.join(home, '.local', 'bin', exe)]) if (fs.existsSync(f)) out.push(f);
  for (const base of ['.vscode', '.vscode-insiders', '.cursor', '.windsurf'].map(d => path.join(home, d, 'extensions'))) {
    let ds = []; try { ds = fs.readdirSync(base); } catch { continue; }
    for (const d of ds) if (/^anthropic\.claude-code-/i.test(d)) { const f = path.join(base, d, 'resources', 'native-binary', exe); if (fs.existsSync(f)) out.push(f); }
  }
  return [...new Set(out.map(f => path.normalize(f)))];
}
function resolveClaude(force) {
  if (claudeBin && !force) return claudeBin;
  let best = null; const seen = [];
  for (const f of claudeCandidates()) { const v = claudeVersionOf(f); seen.push(`${f} = ${v || '?'}`); if (v && (!best || cmpVer(v, best.ver) > 0)) best = { file: f, ver: v }; }
  claudeBin = best || { file: 'claude', ver: '' }; claudeBin.seen = seen;
  log(`Claude CLI 선택: ${claudeBin.file} (${claudeBin.ver || '버전 미확인'}) — 후보 ${seen.join(' · ') || '없음'}`);
  if (claudeBin.ver && cmpVer(claudeBin.ver, CLAUDE_MIN) < 0) vscode.window.showWarningMessage(`Vibe_Manager: 찾은 Claude CLI 최신이 ${claudeBin.ver} 입니다 — 최신 모델은 ${CLAUDE_MIN} 이상 필요. 터미널에서 'claude update' 또는 VS Code Claude Code 확장을 업데이트하세요.`);
  return claudeBin;
}

// ───────────────────────── 설정 · 경로 ─────────────────────────
function cfg() { return vscode.workspace.getConfiguration('vibeManager'); }
function findRoot() {
  const c = cfg(); let root = (c.get('projectRoot') || '').trim();
  if (root && fs.existsSync(root)) return root;
  const ws = vscode.workspace.workspaceFolders || [];
  const hit = ws.find(f => fs.existsSync(path.join(f.uri.fsPath, c.get('toolsDir') || 'tools/AsisFacts')));
  if (hit) return hit.uri.fsPath;
  for (const f of ws) { let d = f.uri.fsPath; for (let i = 0; i < 3; i++) { if (fs.existsSync(path.join(d, 'tools', 'AsisFacts'))) return d; d = path.dirname(d); } }
  const def = process.platform === 'win32' ? 'C:\\Projects\\NSCM' : path.join(process.env.HOME || '', 'Projects', 'NSCM');
  return fs.existsSync(def) ? def : (ws[0] ? ws[0].uri.fsPath : '');
}
function paths() {
  const c = cfg(); const root = normDrive(findRoot());
  const abs = p => (!p ? '' : path.isAbsolute(p) ? p : path.join(root, p));
  return {
    root, toolsDir: abs(c.get('toolsDir') || 'tools/AsisFacts'), harnessDir: abs(c.get('harnessDir') || 'tools/Harness'),
    outDir: abs(c.get('outDir') || 'Doc/asisfacts'), tobeDir: abs(c.get('tobeDir') || 'nscm-fe'), tobeOutDir: abs(c.get('tobeOutDir') || 'Doc/tobefacts'),
    rulesDir: abs(c.get('rulesDir') || 'tools/Harness/rules'), gapDir: abs(c.get('gapDir') || 'Doc/gap'), genDir: abs(c.get('genDir') || 'Doc/gen'),
    vibeDir: path.join(root, '.vibe'), extDir: ctx.extensionPath, promptsDir: path.join(abs(c.get('harnessDir') || 'tools/Harness'), 'prompts'),
    dbconnDir: abs(c.get('dbconnDir') || 'tools/DbConn'), reconDir: abs(c.get('reconDir') || 'tools/Recon'), e2eDir: abs(c.get('e2eDir') || 'tools/E2E'), dbOutDir: abs('Doc/db'), reconOutDir: abs('Doc/recon'), e2eOutDir: abs('Doc/e2e'), goldenDir: abs('Doc/golden'),
    python: c.get('pythonCommand') || 'python', powershell: c.get('powershell') || 'powershell', node: c.get('nodeCommand') || 'node', claude: (() => { const s = (c.get('claudeCommand') || '').trim(); return s && s !== 'claude' ? s : resolveClaude().file; })(), claudeModel: c.get('claudeModel') || '', modelList: Array.isArray(c.get('modelList')) ? c.get('modelList') : [], permissionMode: c.get('defaultPermissionMode') || 'bypassPermissions',
    language: (c.get('language') === 'ko' ? 'ko' : 'en'), // 1.8.3: 메뉴·라벨 언어 (기본 en)
    claudeDelay: Number(c.get('claudeStartupDelayMs') || 6000), agentDriver: c.get('agentDriver') || 'claude-cli', agentModel: c.get('agentModel') || 'claude-opus-5-5', // 1.8.5: 기본 Opus 5.5 (이전 sonnet-4-5)
    excludeScreens: (c.get('excludeScreenPatterns') || []).map(s => new RegExp(s)), envFiles: c.get('envFiles') || []
  };
}
function subst(text, vars) {
  if (text == null) return '';
  return String(text).replace(/\$\{(input:)?([A-Za-z0-9_]+)\}/g, (m, isInput, name) => isInput ? (vars.inputs && vars.inputs[name] != null ? vars.inputs[name] : '') : (vars[name] != null ? String(vars[name]) : m));
}
function stepsFile() { const p = paths(); const o = path.join(p.vibeDir, 'steps.json'); return fs.existsSync(o) ? o : path.join(p.extDir, 'steps.json'); }
function loadSteps() {
  try { const d = JSON.parse(fs.readFileSync(stepsFile(), 'utf8').replace(/^\uFEFF/, '')); return Array.isArray(d.steps) ? d.steps : []; }
  catch (e) { log(`steps.json 읽기 실패: ${e.message}`); return []; }
}
function allTasks() { const r = []; for (const s of loadSteps()) for (const t of s.tasks || []) r.push({ step: s, task: t }); return r; }
function findTask(id) { const h = allTasks().find(x => x.task.id === id); return h ? h.task : null; }

// ───────────────────────── CSV ─────────────────────────
function parseCsv(text) {
  text = text.replace(/^\uFEFF/, ''); const rows = []; let row = [], f = '', q = false;
  for (let i = 0; i < text.length; i++) {
    const ch = text[i];
    if (q) { if (ch === '"') { if (text[i + 1] === '"') { f += '"'; i++; } else q = false; } else f += ch; }
    else if (ch === '"') q = true; else if (ch === ',') { row.push(f); f = ''; }
    else if (ch === '\n' || ch === '\r') { if (ch === '\r' && text[i + 1] === '\n') i++; row.push(f); f = ''; if (row.length > 1 || row[0] !== '') rows.push(row); row = []; }
    else f += ch;
  }
  if (f !== '' || row.length) { row.push(f); rows.push(row); }
  return rows;
}
function readCsv(file) { const rows = parseCsv(fs.readFileSync(file, 'utf8')); if (!rows.length) return []; const h = rows[0]; return rows.slice(1).map(r => { const o = {}; h.forEach((k, i) => o[k] = r[i] == null ? '' : r[i]); return o; }); }
function csvRowCount(file) { return Math.max(0, parseCsv(fs.readFileSync(file, 'utf8')).length - 1); }

// ───────────────────────── 게이트 ─────────────────────────
function evalGate(g, vars) {
  if (!g) return null; const f = subst(g.file, vars); const label = g.label || '';
  if (/\$\{input:/.test(g.file)) return { ok: false, detail: `${label} (입력 후 판정)`, ran: false };
  try {
    switch (g.type) {
      case 'fileExists': { const ok = fs.existsSync(f); return { ok, detail: `${label} ${ok ? '있음' : '없음'}`, ran: ok }; }
      case 'csvRows': { if (!fs.existsSync(f)) return { ok: false, detail: `${label} 파일 없음`, ran: false }; const n = csvRowCount(f); let ok = true; if (g.min != null && n < g.min) ok = false; if (g.max != null && n > g.max) ok = false; return { ok, detail: `${label} ${n.toLocaleString()}행${g.max === 0 ? (ok ? ' (0=통과)' : ' (0 이어야)') : ''}`, ran: true }; }
      case 'csvAll': { if (!fs.existsSync(f)) return { ok: false, detail: `${label} 파일 없음`, ran: false }; const rows = readCsv(f); const bad = rows.filter(r => r[g.column] !== g.equals).length; return { ok: rows.length > 0 && bad === 0, detail: `${label} ${rows.length.toLocaleString()}건, ${g.column}≠${g.equals} ${bad}건`, ran: true }; }
      case 'agentGates': { if (!fs.existsSync(f)) return { ok: false, detail: 'Agent 미실행', ran: false }; const r = agentGateSummary(f); if (!r.total) return { ok: false, detail: 'Agent 미실행', ran: false }; return { ok: r.fail === 0, detail: `PASS ${r.pass} / FAIL ${r.fail} (${r.total}화면)`, ran: true }; }
      default: return { ok: false, detail: `알 수 없는 게이트 ${g.type}`, ran: false };
    }
  } catch (e) { return { ok: false, detail: `판정 오류: ${e.message}`, ran: false }; }
}
function agentGateSummary(agentDir) {
  const res = { pass: 0, fail: 0, total: 0, items: [] };
  for (const id of fs.readdirSync(agentDir)) {
    const gf = path.join(agentDir, id, '_gate.csv'); if (!fs.existsSync(gf)) continue;
    let status = 'FAIL', detail = '', docs = 0, checks = [];
    try { const rows = readCsv(gf); const s = rows.find(r => r.check === 'total') || rows.find(r => r.check === 'summary'); if (s) { status = s.status; detail = s.detail; } docs = rows.filter(r => /^doc2?:/.test(r.check) && r.status === 'OK').length; checks = rows.filter(r => !/^(summary|summary2|total)$/.test(r.check) && r.status !== 'OK').map(r => `${r.check}: ${r.detail || r.status}`); } catch (e) { detail = e.message; }
    res.items.push({ id, status, detail, docs, checks, mtime: fs.statSync(gf).mtime }); res.total++; if (status === 'PASS') res.pass++; else res.fail++;
  }
  res.items.sort((a, b) => a.id.localeCompare(b.id)); return res;
}
function stepStatus(step, vars) {
  let ok = 0, fail = 0, gated = 0;
  for (const t of step.tasks || []) { if (!t.gate || /\$\{input:/.test(t.gate.file)) continue; gated++; const r = evalGate(t.gate, vars); if (r.ok) ok++; else if (r.ran) fail++; }
  if (!gated) return { state: 'none', text: '' };
  if (ok === gated) return { state: 'pass', text: `완료 ${ok}/${gated}` };
  if (fail > 0) return { state: 'fail', text: `통과 ${ok}/${gated}, 실패 ${fail}` };
  if (ok > 0) return { state: 'partial', text: `진행 중 ${ok}/${gated}` };
  return { state: 'idle', text: `미착수 0/${gated}` };
}

// ───────────────────────── 실행 기록 ─────────────────────────
function runs() { return ctx.workspaceState.get(RUNS_KEY, {}); }
function recordRun(id, info) {
  const r = runs(); r[id] = Object.assign({}, r[id] || {}, info); ctx.workspaceState.update(RUNS_KEY, r);
  try { const p = paths(); if (!p.root) return; fs.mkdirSync(p.vibeDir, { recursive: true }); fs.appendFileSync(path.join(p.vibeDir, 'runs.log'), `${history.nowLocal()}\t${id}\t${info.event || ''}\t${info.exitCode == null ? '' : info.exitCode}\t${info.note || ''}\n`, 'utf8'); } catch (_) { }
}
function fmtTime(ms) { if (!ms) return ''; const d = new Date(ms); const z = n => String(n).padStart(2, '0'); return `${d.getMonth() + 1}/${z(d.getDate())} ${z(d.getHours())}:${z(d.getMinutes())}`; }

// ───────────────────────── 입력 수집 ─────────────────────────
async function collectInputs(task, preset) {
  const p = paths(); const vars = Object.assign({}, p, { inputs: Object.assign({}, preset || {}) });
  for (const inp of task.inputs || []) {
    if (vars.inputs[inp.name] != null) continue;
    // 1.9.1: 선택지 입력(options) — QuickPick (예: E2E 테스트 모드 auto/admin/division)
    if (Array.isArray(inp.options) && inp.options.length) {
      const pick = await vscode.window.showQuickPick(inp.options.map(o => typeof o === 'string' ? { label: o } : { label: o.value || o.label, description: o.description || '' }), { placeHolder: inp.prompt || inp.name, ignoreFocusOut: true });
      if (!pick) return null; vars.inputs[inp.name] = pick.label; continue;
    }
    const v = await vscode.window.showInputBox({ prompt: inp.prompt || inp.name, value: inp.default || workbench.currentId() || ctx.workspaceState.get('vibeManager.lastId', ''), ignoreFocusOut: true, validateInput: s => (inp.required !== false && !s.trim()) ? '값을 입력하세요' : null });
    if (v == null) return null; vars.inputs[inp.name] = v.trim();
    if (/^ids?$/.test(inp.name)) ctx.workspaceState.update('vibeManager.lastId', v.trim().split(/\s+/)[0]);
  }
  if (task.confirm) { const a = await vscode.window.showWarningMessage(task.confirm, { modal: true }, '실행'); if (a !== '실행') return null; }
  return vars;
}

// ───────────────────────── 작업 실행 ─────────────────────────
// 1.9.42(2026-11-06): 'E2E 결과 열기'·'HTML 리포트' 같은 Doc/e2e/results/<파일> 경로 — 현재 화면 ID 폴더(Doc/e2e/results/<ID>/<파일>)에 있으면 그것을 연다
function e2eForId(target, p) { try { const id = String(workbench.currentId() || '').toUpperCase(); const base = path.join(p.e2eOutDir, 'results'); const t = path.normalize(String(target || '')); if (!id || !t.toLowerCase().startsWith(base.toLowerCase() + path.sep)) return target; const alt = path.join(base, id, t.slice(base.length + 1)); return fs.existsSync(alt) ? alt : target; } catch { return target; } }
function pageDirOfId(id) { try { const p = paths(); const r = JSON.parse(fs.readFileSync(path.join(p.genDir, id, 'register.json'), 'utf8')); return path.join(p.tobeDir, 'features', r.feature, 'src', 'pages', r.pageDir); } catch { return ''; } }
async function runTask(task, preset) {
  if (!task) { const items = allTasks().map(x => ({ label: x.task.title, description: x.step.title, task: x.task })); const pick = await vscode.window.showQuickPick(items, { placeHolder: '실행할 작업' }); if (!pick) return; task = pick.task; }
  const p = paths(); if (!p.root) { vscode.window.showErrorMessage('Vibe_Manager: 프로젝트 루트를 찾지 못했습니다. 설정 vibeManager.projectRoot 를 지정하세요.'); return; }
  if (workbench.GEN_TASK.test(task.id || '') && workbench.dbModeBlock(p, `${task.id} ${task.title || ''}`.trim(), t => log(t.trim()))) return; // 2026-11-12: DB MODE = 일괄 생성 작업 차단(트리·FLOW 칸·명령 팔레트 공통)
  const vars = await collectInputs(task, preset); if (!vars) return;
  log(`▶ ${task.id} ${task.title}`);
  switch (task.kind) {
    case 'powershell': return runShell(task, vars);
    case 'node': return runShell(task, vars);
    case 'python': return runShell(task, vars);
    case 'cmd': return runShell(task, vars);
    case 'claude': return runClaude(task, vars);
    case 'open': return openPath(e2eForId(subst(task.path, vars), p));
    case 'browser': return openBrowser(e2eForId(subst(task.path, vars), p));
    case 'gateReport': return gateReport();
    case 'agentBatch': return agentBatch(task, vars);
    case 'diff': return showDiff(vars.inputs.dir);
    default: vscode.window.showErrorMessage(`알 수 없는 작업 종류: ${task.kind}`);
  }
}
function buildArgs(task, vars) {
  const args = [];
  for (const a of task.args || []) { const v = subst(a, vars); if (!v) continue; if (task.splitArgs && /\$\{input:/.test(a)) args.push(...v.split(/\s+/).filter(Boolean)); else args.push(v); }
  return args;
}
async function runShell(task, vars, extraArgs) {
  const p = paths(); const script = subst(task.script, vars);
  if (!fs.existsSync(script)) { const a = await vscode.window.showErrorMessage(`스크립트가 없습니다: ${script}`, '폴더 열기'); if (a) openPath(path.dirname(script)); return; }
  const args = extraArgs || buildArgs(task, vars); const cwd = subst(task.cwd || path.dirname(script), vars);
  // 1.7.7: 워크벤치가 열려 있으면 그쪽 스트리밍 실행(실제 exit code·작업 출력 탭). VS Code 작업 터미널은 워크스페이스
  //        프로파일(-NoExit · shellIntegration off) 때문에 종료를 못 잡아 exit undefined 경고·'실행 중' 고착 → fallback 으로만.
  if (await workbench.runShell(task, vars, args)) return;
  // 1.9.14: 새 화면 생성 작업은 기존 생성분 확인(중지/삭제 후 신규)이 워크벤치에 있다 — 워크벤치 없이 터미널로 바로 돌리지 않는다
  if (task.newScreen) { vscode.window.showWarningMessage(`Vibe_Manager: '${task.title}' 는 Workbench 에서 실행하세요 (기존 생성분 확인 후 진행)`); return; }
  const so = { cwd, env: claudeEnv(p) }; // 1.7.5: 하네스·agent 가 같은 (최신) Claude CLI 를 쓰도록
  const exec = task.kind === 'node' ? new vscode.ShellExecution(p.node, [script, ...args], so) : task.kind === 'python' ? new vscode.ShellExecution(p.python || 'python', [script, ...args], so) : task.kind === 'cmd' ? new vscode.ShellExecution('cmd', ['/c', script, ...args], so) : new vscode.ShellExecution(p.powershell, ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', script, ...args], so);
  const histId = (vars.inputs && (vars.inputs.id || (vars.inputs.ids || '').split(/\s+/)[0]) || '').toUpperCase();
  let histDir = null; try { histDir = history.begin(Object.assign({}, p, { pageDirOf: pageDirOfId }), histId, task.id, `${path.basename(script)} ${args.join(' ')}`.trim()); } catch (e) { log(`이력 스냅샷 실패: ${e.message}`); }
  const t = new vscode.Task({ type: 'vibeManager', task: task.id, histDir: histDir || '' }, vscode.TaskScope.Workspace, task.title, 'Vibe_Manager', exec);
  t.presentationOptions = { reveal: vscode.TaskRevealKind.Always, panel: vscode.TaskPanelKind.Dedicated, clear: true, showReuseMessage: false, echo: true, focus: false };
  recordRun(task.id, { event: 'start', time: Date.now(), exitCode: null, note: `${path.basename(script)} ${args.join(' ')}`.trim() }); tree.refresh();
  try { await vscode.tasks.executeTask(t); } catch (e) { recordRun(task.id, { event: 'error', exitCode: -1, note: e.message }); vscode.window.showErrorMessage(`실행 실패: ${e.message}`); }
}
function claudeEnv(p, model) {
  const e = { CLAUDE_BIN: p.claude, ASISFACTS_CLAUDE: p.claude };
  const m = model != null ? model : p.claudeModel; if (m) e.CLAUDE_MODEL = m;
  return e;
}
function onTaskEnd(e) {
  const def = e.execution && e.execution.task && e.execution.task.definition; if (!def || def.type !== 'vibeManager') return;
  const id = def.task, code = e.exitCode; recordRun(id, { event: 'end', endTime: Date.now(), exitCode: code });
  if (def.histDir) { try { history.finish(Object.assign({}, paths(), { pageDirOf: pageDirOfId }), def.histDir, code); } catch (err) { log(`이력 after 실패: ${err.message}`); } }
  const task = findTask(id); const title = task ? task.title : id;
  if (code == null) { vscode.window.showWarningMessage(`Vibe_Manager ? ${title} — 터미널이 종료 코드를 돌려주지 않았습니다(터미널 프로파일 -NoExit/shellIntegration off). 워크벤치를 열어 두고 실행하면 작업 출력 탭에서 실제 결과를 볼 수 있습니다.`); tree.refresh(); refreshDashboard(); updateStatusBar(); return; }
  if (code === 0) vscode.window.showInformationMessage(`Vibe_Manager ✓ ${title}`);
  else if (code === 1 && task && task.kind === 'node' && /check\.js|gap\.js|recon\.js|repair-loop\.js|probe\.py|golden\.py/.test(task.script || '')) vscode.window.showWarningMessage(`Vibe_Manager ! ${title} — 경고 있음 (터미널 확인)`);
  else vscode.window.showWarningMessage(`Vibe_Manager ✗ ${title} (exit ${code}) — 터미널 출력을 확인하세요`);
  tree.refresh(); refreshDashboard(); updateStatusBar();
}
async function runClaude(task, vars) {
  const p = paths(); const promptFile = path.join(p.promptsDir, task.prompt);
  if (!fs.existsSync(promptFile)) { vscode.window.showErrorMessage(`프롬프트 파일이 없습니다: ${promptFile}`); return; }
  const id = vars.inputs.id || vars.inputs.ids || '';
  const rel = path.relative(p.root, promptFile).split(path.sep).join('/');
  const term = vscode.window.createTerminal({ name: `Vibe: ${task.id}${id ? ' ' + id : ''}`, cwd: p.root }); term.show(true);
  const model = (p.claudeModel ? ` --model ${p.claudeModel}` : '') + ` --permission-mode ${p.permissionMode}`;
  const genNotes = id ? `Doc/gen/${id}/GEN_NOTES.md` : '';
  const instruction = `${rel} 를 읽고 그 지시대로 화면 ${id} 작업을 해주세요.${genNotes ? ` 메모: ${genNotes}.` : ''} TODO(이식) 지점만 채우고 끝나면 __asis-mapping__.md 상태를 갱신하세요.`;
  const cl = /\s/.test(p.claude) ? `& "${p.claude}"` : p.claude; // PowerShell 터미널 — 공백 경로는 호출 연산자
  if (task.headless) term.sendText(`${cl} -p${model} "${instruction.replace(/"/g, '\\"')}"`);
  else { term.sendText(`${cl}${model}`); setTimeout(() => term.sendText(instruction), p.claudeDelay); }
  recordRun(task.id, { event: 'claude', time: Date.now(), exitCode: null, note: `${rel} ${id}` }); tree.refresh();
}
// 1.9.5: 드라이브 문자 대문자 통일 — VS Code 가 주는 'c:\…' 와 설정 파일의 'C:\…' 가 섞이면 Node 가 같은 모듈을 두 번 로드한다(Playwright "second time", SCP0100 체인 E2E 무실행 원인)
function normDrive(p) { return typeof p === 'string' ? p.replace(/^([a-z]):/, (m, d) => d.toUpperCase() + ':') : p; }
async function openPath(target, line) {
  if (!target) return;
  if (!fs.existsSync(target)) { vscode.window.showWarningMessage(`아직 없습니다: ${target}`); return; }
  // 1.9.0: 새 창/외부 프로그램이 아닌 모든 '열기' 는 Workbench 탭으로(Workbench 가 없으면 먼저 연다). 바이너리는 workbench.openTab 안에서 OS 프로그램으로
  try { await vscode.commands.executeCommand('vibeManager.openWorkbench'); if (workbench.openTab(target, { line: line || 0 })) return; } catch { }
  if (fs.statSync(target).isDirectory()) {
    const entries = fs.readdirSync(target).filter(n => !n.startsWith('.')).sort();
    const pick = await vscode.window.showQuickPick(entries.map(n => ({ label: n, description: fs.statSync(path.join(target, n)).isDirectory() ? '폴더' : '' })), { placeHolder: target });
    if (pick) return openPath(path.join(target, pick.label)); return;
  }
  const doc = await vscode.workspace.openTextDocument(vscode.Uri.file(target)); await vscode.window.showTextDocument(doc, { preview: false });
}
async function openBrowser(target) { if (!fs.existsSync(target)) { vscode.window.showWarningMessage(`아직 없습니다: ${target} — 4단계 GAP 실행 먼저`); return; } await vscode.env.openExternal(vscode.Uri.file(target)); }

// 작업 전/후 소스 비교 — git 작업트리 vs HEAD (페이지 폴더의 변경 파일 목록 → 선택 → diff 에디터)
async function showDiff(dir) {
  if (!dir || !fs.existsSync(dir)) { vscode.window.showWarningMessage(`폴더 없음: ${dir}`); return; }
  let repo = dir; while (repo && !fs.existsSync(path.join(repo, '.git')) && repo !== path.dirname(repo)) repo = path.dirname(repo);
  if (!fs.existsSync(path.join(repo, '.git'))) { vscode.window.showWarningMessage('git 저장소를 찾지 못했습니다'); return; }
  const relDir = path.relative(repo, dir).split(path.sep).join('/');
  let status; try { status = cp.execSync(`git status --porcelain -- "${relDir}"`, { cwd: repo, encoding: 'utf8' }); } catch (e) { vscode.window.showErrorMessage('git status 실패: ' + e.message); return; }
  const files = status.split(/\r?\n/).filter(Boolean).map(l => ({ st: l.slice(0, 2).trim(), file: l.slice(3).replace(/"/g, '').trim() }));
  if (!files.length) { vscode.window.showInformationMessage('변경 파일이 없습니다 (HEAD 와 동일)'); return; }
  const pick = await vscode.window.showQuickPick(files.map(f => ({ label: path.basename(f.file), description: `${f.st === '??' ? '신규' : f.st} ${f.file}`, f })), { placeHolder: `변경 ${files.length}개 — 비교할 파일` });
  if (!pick) return;
  const full = path.join(repo, pick.f.file);
  if (pick.f.st === '??') { await vscode.window.showTextDocument(vscode.Uri.file(full)); return; }
  const tmpDir = path.join(paths().vibeDir, 'diff'); fs.mkdirSync(tmpDir, { recursive: true });
  const before = path.join(tmpDir, 'HEAD__' + path.basename(pick.f.file));
  try { fs.writeFileSync(before, cp.execSync(`git show HEAD:"${pick.f.file}"`, { cwd: repo, encoding: 'utf8' }), 'utf8'); } catch (e) { vscode.window.showErrorMessage('HEAD 버전 추출 실패: ' + e.message); return; }
  // 1.9.0: Workbench diff 탭(HEAD ↔ 작업본) — Workbench 가 없을 때만 VS Code diff
  try { await vscode.commands.executeCommand('vibeManager.openWorkbench'); if (workbench.openDiff(`git|${full}`, `${path.basename(pick.f.file)} (HEAD ↔ 작업본)`, fs.readFileSync(before, 'utf8'), fs.readFileSync(full, 'utf8'), 'HEAD', '작업본', full)) return; } catch { }
  await vscode.commands.executeCommand('vscode.diff', vscode.Uri.file(before), vscode.Uri.file(full), `${path.basename(pick.f.file)} — HEAD ↔ 작업본`);
}

// ───────────────────────── Agent 배치 · 게이트 리포트 ─────────────────────────
async function agentBatch(task, vars) {
  const p = paths(); const indexFile = path.join(p.outDir, 'screens', '_index.csv');
  if (!fs.existsSync(indexFile)) { vscode.window.showErrorMessage(`화면 인덱스가 없습니다: ${indexFile} (1단계 파서 먼저)`); return; }
  let ids = readCsv(indexFile).map(r => r.screen_id).filter(Boolean).filter(id => !p.excludeScreens.some(re => re.test(id)));
  const groups = {}; for (const id of ids) { const g = (id.match(/^[A-Za-z]+/) || ['기타'])[0]; (groups[g] = groups[g] || []).push(id); }
  const items = Object.keys(groups).sort().map(g => ({ label: g, description: `${groups[g].length}화면`, ids: groups[g] })); items.unshift({ label: '전체', description: `${ids.length}화면`, ids });
  const pick = await vscode.window.showQuickPick(items, { placeHolder: 'Agent 를 돌릴 도메인' }); if (!pick) return;
  let targets = pick.ids.slice(); const agentDir = path.join(p.outDir, 'agent');
  const passed = new Set(fs.existsSync(agentDir) ? agentGateSummary(agentDir).items.filter(i => i.status === 'PASS').map(i => i.id) : []);
  const skip = await vscode.window.showQuickPick([{ label: '이미 PASS 인 화면 제외', description: `${targets.filter(i => passed.has(i)).length}화면 제외`, v: true }, { label: '전부 다시 실행', v: false }], { placeHolder: '재실행 범위' }); if (!skip) return;
  if (skip.v) targets = targets.filter(i => !passed.has(i));
  if (!targets.length) { vscode.window.showInformationMessage('실행할 화면이 없습니다 (모두 PASS).'); return; }
  const a = await vscode.window.showWarningMessage(`${pick.label} ${targets.length}화면에 Agent 실행 (드라이버 ${p.agentDriver}, 모델 ${p.agentModel}). 화면당 수십 초~수 분.`, { modal: true }, '실행'); if (a !== '실행') return;
  await runShell(Object.assign({}, task, { kind: 'powershell' }), vars, [...targets, '-Driver', p.agentDriver, '-Model', p.agentModel]);
}
async function gateReport() {
  const p = paths(); const agentDir = path.join(p.outDir, 'agent');
  if (!fs.existsSync(agentDir)) { vscode.window.showWarningMessage('Agent 결과가 없습니다.'); return; }
  const s = agentGateSummary(agentDir); const indexFile = path.join(p.outDir, 'screens', '_index.csv');
  const all = fs.existsSync(indexFile) ? readCsv(indexFile).map(r => r.screen_id).filter(id => id && !p.excludeScreens.some(re => re.test(id))) : null;
  const lines = [`# Agent 게이트 집계 — ${new Date().toLocaleString()}`, '', `- 실행 화면 ${s.total}${all ? ` / 대상 ${all.length} (미실행 ${all.length - s.total})` : ''}`, `- PASS ${s.pass} · FAIL ${s.fail}`, '', '| 화면ID | 상태 | 문서 | 상세 | 실패 항목 | 시각 |', '|---|---|---:|---|---|---|'];
  for (const i of s.items) lines.push(`| ${i.id} | ${i.status === 'PASS' ? '✅ PASS' : '❌ ' + i.status} | ${i.docs}/8 | ${i.detail} | ${i.checks.join('<br>')} | ${fmtTime(i.mtime.getTime())} |`);
  if (all && all.length > s.total) { const done = new Set(s.items.map(i => i.id)); lines.push('', `## 미실행 화면 (${all.filter(id => !done.has(id)).length})`, '', all.filter(id => !done.has(id)).join(', ')); }
  const dir = path.join(p.vibeDir, 'reports'); fs.mkdirSync(dir, { recursive: true }); const file = path.join(dir, `agent_gates_${history.nowLocal().slice(0, 10)}.md`);
  fs.writeFileSync(file, lines.join('\n'), 'utf8'); await openPath(file);
}

// ───────────────────────── 프로그램 ID 로 단계 작업 ─────────────────────────
async function quickScreen() {
  const id = await vscode.window.showInputBox({ prompt: '화면(프로그램) ID', value: ctx.workspaceState.get('vibeManager.lastId', 'DMF0052'), ignoreFocusOut: true });
  if (!id) return; const ID = id.trim().toUpperCase(); ctx.workspaceState.update('vibeManager.lastId', ID); if (dodTree) dodTree.refresh();
  const p = paths(); const has = f => fs.existsSync(f);
  const st = { pack: has(path.join(p.outDir, 'screens', ID)), agent: has(path.join(p.outDir, 'agent', ID, '_gate.csv')), gen: has(path.join(p.genDir, ID, 'GEN_NOTES.md')), };
  const pageDir = (() => { if (!st.gen) return ''; try { const r = JSON.parse(fs.readFileSync(path.join(p.genDir, ID, 'register.json'), 'utf8')); return path.join(p.tobeDir, 'features', ...r.routePath.split('/').flatMap((s, i) => i === 0 ? [s, 'src', 'pages'] : [s])); } catch (_) { return ''; } })();
  const mark = b => b ? '$(pass-filled)' : '$(circle-large-outline)';
  const items = [
    { label: `${mark(st.pack)} 1 As-is Fact Pack 열기`, description: st.pack ? 'Doc/asisfacts/screens/' + ID : '없음 — pack 먼저', run: () => openPath(path.join(p.outDir, 'screens', ID)) },
    { label: `${mark(st.agent)} 3 Agent 문서 생성/열기`, description: st.agent ? '게이트 결과 있음 → 열기' : '실행 (분석서 5종 + 문서 3종)', run: () => st.agent ? openPath(path.join(p.outDir, 'agent', ID)) : runTask(findTask('S3.agent'), { ids: ID }) },
    { label: `${mark(st.gen)} 5 신규 화면 골격 생성 (new-screen.ps1)`, description: st.gen ? 'GEN_NOTES 있음 → 열기' : '골격 생성 + nscm-fe 적용 + 1차 게이트', run: () => st.gen ? openPath(path.join(p.genDir, ID, 'GEN_NOTES.md')) : runTask(findTask('S5.new'), { id: ID }) },
    { label: `$(sparkle) 5 Claude Code 로 TODO 이식`, description: st.gen ? '프롬프트 자동 전달' : 'GEN_NOTES 없음 — 골격 먼저', run: () => runTask(findTask('S5.claude'), { id: ID }) },
    { label: `$(checklist) 5 게이트 판정 / 최종(--final)`, description: pageDir || '페이지 폴더 미확인', run: async () => { const f = await vscode.window.showQuickPick(['게이트 판정', '최종 게이트 (--final)'], {}); if (!f) return; runTask(findTask(f.startsWith('최종') ? 'S5.final' : 'S5.check'), { dir: pageDir }); } },
    { label: `$(diff) 5 작업 전/후 소스 비교`, description: pageDir || '페이지 폴더 미확인', run: () => showDiff(pageDir) },
    { label: `$(book) 6 문서 3종 확정 (Agent -Phase docs)`, description: '분석서는 유지, 3종만 재생성', run: () => runTask(findTask('S6.docs'), { ids: ID }) },
    { label: `$(rocket) ★ ID 하나로 끝까지 (FE 골격→등록 SQL→PKG→수선→이식→E2E 스펙→대조표)`, description: 'pipeline.js — 끝나면 DoD 패널에서 ❌ 만 확인', run: () => runTask(findTask('S5.pipeline'), { id: ID }) },
    { label: `$(sync) 5 자동 수선 루프 (gen→Claude→게이트 ×3)`, description: has(path.join(p.genDir, ID, 'REPAIR.md')) ? 'REPAIR.md 있음 → 재실행' : '사람 개입 없이 PASS 까지', run: () => runTask(findTask('S5.repair'), { ids: ID }) },
    { label: `$(beaker) 4 골든 테스트 (As-is SP ↔ To-Be PROC 결과 대조)`, description: has(path.join(p.goldenDir, ID)) ? 'Doc/golden/' + ID : '케이스 생성 후 실행', run: () => runTask(findTask('S4.golden'), { ids: ID }) },
    { label: `$(rocket) ★ ID 하나로 전체 (파싱→분석→생성→보완→테스트→문서)`, description: '순차 체인 — 실패 단계에서 멈추고 Doc/gen/<ID>/FULLRUN.md', run: async () => { const it = (promptPanel.loadQuick(p.extDir, p.root).groups || []).flatMap(g => g.items).find(x => x.chainId === 'full'); if (!it) return vscode.window.showWarningMessage('quick.json 에 chainId=full 항목이 없습니다'); await vscode.commands.executeCommand('vibeManager.openWorkbench'); await workbench.quick(it, ID, false); } },
  ];
  const pick = await vscode.window.showQuickPick(items, { placeHolder: `${ID} — 어느 단계 작업?`, matchOnDescription: true }); if (pick) await pick.run();
}

// ───────────────────────── 트리: 단계 ─────────────────────────
class StepsProvider {
  constructor() { this._em = new vscode.EventEmitter(); this.onDidChangeTreeData = this._em.event; }
  refresh() { this._em.fire(); updateStatusBar(); if (harnessTree) harnessTree.refresh(); if (envTree) envTree.refresh(); if (dodTree) dodTree.refresh(); }
  getTreeItem(el) { return el; }
  getChildren(el) {
    const p = paths(); vscode.commands.executeCommand('setContext', 'vibeManager.noRoot', !p.root); if (!p.root) return [];
    const vars = Object.assign({}, p, { inputs: {} });
    if (!el) return loadSteps().map(s => { const st = stepStatus(s, vars); const it = new vscode.TreeItem(L(s, 'title'), st.state === 'pass' ? vscode.TreeItemCollapsibleState.Collapsed : vscode.TreeItemCollapsibleState.Expanded); it.description = st.text; it.tooltip = s.detail || ''; it.iconPath = stateIcon(st.state); it.contextValue = 'step'; it.step = s; return it; });
    if (el.step) { const r = runs(); return (el.step.tasks || []).map(t => {
      const it = new vscode.TreeItem(L(t, 'title'), vscode.TreeItemCollapsibleState.None); const g = t.gate ? evalGate(t.gate, vars) : null; const run = r[t.id]; const parts = [];
      if (g) parts.push(g.detail); if (run && run.time) parts.push(`최근 ${fmtTime(run.time)}${run.exitCode != null ? (run.exitCode === 0 ? ' ✓' : ` ✗${run.exitCode}`) : ''}`);
      it.description = parts.join(' · '); it.tooltip = new vscode.MarkdownString(`**${t.title}**\n\n종류: ${kindName(t.kind)}${t.script ? `\n\n스크립트: \`${subst(t.script, vars)}\`` : ''}${t.prompt ? `\n\n프롬프트: \`${t.prompt}\`` : ''}${g ? `\n\n게이트: ${g.detail}` : ''}`);
      it.iconPath = g ? stateIcon(g.ran || g.ok ? (g.ok ? 'pass' : 'fail') : 'idle') : kindIcon(t.kind); it.contextValue = 'task'; it.task = t; it.command = { command: 'vibeManager.runTask', title: '실행', arguments: [it] }; return it; }); }
    return [];
  }
}
function stateIcon(state) { switch (state) { case 'pass': return new vscode.ThemeIcon('pass-filled', new vscode.ThemeColor('testing.iconPassed')); case 'fail': return new vscode.ThemeIcon('error', new vscode.ThemeColor('testing.iconFailed')); case 'partial': return new vscode.ThemeIcon('circle-large-filled', new vscode.ThemeColor('testing.iconQueued')); case 'none': return new vscode.ThemeIcon('circle-outline'); default: return new vscode.ThemeIcon('circle-large-outline'); } }
function kindIcon(kind) { return new vscode.ThemeIcon({ claude: 'sparkle', powershell: 'terminal-powershell', node: 'terminal', open: 'go-to-file', browser: 'globe', gateReport: 'checklist', agentBatch: 'run-all', diff: 'diff' }[kind] || 'play'); }
function kindName(kind) { return { claude: 'Claude Code 지시', powershell: 'PowerShell 스크립트', node: 'Node 스크립트', open: '파일/폴더 열기', browser: '브라우저로 열기', gateReport: '게이트 집계', agentBatch: 'Agent 배치', diff: '전/후 비교(git)' }[kind] || kind; }

// ───────────────────────── 트리: 룰 · Hook · 하네스 ─────────────────────────
class HarnessProvider {
  constructor() { this._em = new vscode.EventEmitter(); this.onDidChangeTreeData = this._em.event; }
  refresh() { this._em.fire(); }
  getTreeItem(el) { return el; }
  getChildren(el) {
    const p = paths(); if (!p.root) return [];
    // 2026-11-18 사용자: 최신 기준으로 — 룰 진입(CLAUDE.md 4단계 라우팅) · hook 문서 · 하네스 실행 hook · CheckList 검사 규칙 추가. 큰 목록(hook 문서)은 접어 둔다
    const fileLeaf = (label, full, icon, desc) => { const it = leaf(label, icon || 'markdown', desc); it.contextValue = 'doc'; it.target = full; it.tooltip = full; it.command = { command: 'vibeManager.openItem', title: '열기', arguments: [it] }; return it; };
    const rowsOf = f => { try { return f.endsWith('.csv') ? `${csvRowCount(f)}행` : ''; } catch { return ''; } };
    if (!el) { const hd = path.join(p.root, 'Doc', '_rules_v2', 'hooks'); const nh = fs.existsSync(hd) ? fs.readdirSync(hd).filter(f => /\.md$/.test(f) && !/\.bak/.test(f)).length : 0;
      const groups = { entry: ['룰 진입점 (CLAUDE.md 4단계 라우팅)', 'compass'], vibe: ['이관 룰셋 (VibeManager/rules — ENV·KEEP·SKIP·문장 규칙·처분표)', 'law'], rules: ['룰 사전 (tools/Harness/rules/*.csv · TO-BE 룰 원장 포함)', 'book'], verify: ['CheckList 검사 규칙 · 판정 입력', 'checklist'], hookdocs: [`Hook 문서 (Doc/_rules_v2/hooks · ${nh}개)`, 'note'], hooks: ['Claude Code 실행 Hook (.claude/settings.json)', 'plug'], hhooks: ['하네스 실행 Hook (tools/Harness/hooks)', 'shield'], husky: ['Git Hook (nscm-fe/.husky)', 'git-commit'], docs: ['룰 문서 · 색인 · 참고자료', 'library'] };
      return Object.entries(groups).map(([k, [label, icon]]) => { const it = new vscode.TreeItem(label, k === 'hookdocs' || k === 'rules' ? vscode.TreeItemCollapsibleState.Collapsed : vscode.TreeItemCollapsibleState.Expanded); it.group = k; it.iconPath = new vscode.ThemeIcon(icon); return it; }); }
    if (el.group === 'entry') { const r = p.root; const home = process.env.USERPROFILE || process.env.HOME || '';
      const cands = [['CLAUDE.md (프로젝트 진입)', path.join(r, 'CLAUDE.md')], ['Step 1 anti-simplification.md (최우선)', path.join(r, 'Doc', '_rules_v2', 'anti-simplification.md')], ['Step 2 TRIGGER_ROUTER.md (T00~T21 → 필독 룰·Hook)', path.join(r, 'Doc', '_rules_consolidation', 'TRIGGER_ROUTER.md')], ['Step 4 UI_MANDATORY_CHECKLIST.md (T01·T01M)', path.join(r, 'Doc', '_rules_consolidation', 'UI_MANDATORY_CHECKLIST.md')], ['RULESET_MASTER.md (hook 카탈로그·카운트 단일 소스)', path.join(r, 'Doc', '_rules_consolidation', 'RULESET_MASTER.md')], ['Doc/_rules_v2/00_INDEX.md', path.join(r, 'Doc', '_rules_v2', '00_INDEX.md')], ['TOBE_RULES_DEV.md (TO-BE 룰 개발 기준)', path.join(r, 'Doc', '_rules_consolidation', 'TOBE_RULES_DEV.md')], ['문장 규칙 18개 (사용자 전역 ~/.claude/CLAUDE.md)', path.join(home, '.claude', 'CLAUDE.md')]];
      const rd = path.join(r, '.claude', 'rules'); if (fs.existsSync(rd)) for (const f of fs.readdirSync(rd).filter(f => /\.md$/.test(f)).sort()) cands.push([`.claude/rules/${f} (경로별 자동 로드)`, path.join(rd, f)]);
      return cands.filter(([, f]) => fs.existsSync(f)).map(([l, f]) => fileLeaf(l, f)); }
    if (el.group === 'verify') { const r = p.root; const vdir = path.join(p.harnessDir, 'verify');
      const cands = [['detect_rules.csv (검출 규칙 · CheckList 검출 규칙 시트)', path.join(vdir, 'detect_rules.csv')], ['mapping_checkdefs.csv (대조표 검사 정의)', path.join(vdir, 'mapping_checkdefs.csv')], ['expected_source_rank.csv (기대값 출처 순위)', path.join(p.rulesDir, 'expected_source_rank.csv')], ['diff_rule_map.csv (차등 검증 규칙)', path.join(p.rulesDir, 'diff_rule_map.csv')], ['tobe_rule_registry.csv (TO-BE 룰 원장 CR-xxx)', path.join(p.rulesDir, 'tobe_rule_registry.csv')], ['design_decisions.csv (설계 결정)', path.join(p.rulesDir, 'design_decisions.csv')], ['label_alias.csv (라벨 별칭)', path.join(p.rulesDir, 'label_alias.csv')], ['_user_verdicts_direct.csv (사용자 판정 · CheckList 의견보다 우선)', path.join(r, 'Doc', 'verify', '_user_verdicts_direct.csv')], ['_checker_defects.md (검사기 결함 유형)', path.join(r, 'Doc', 'verify', '_checker_defects.md')], ['doc_style_rules.csv (문장 규칙 검사)', path.join(r, 'tools', 'Docs', 'doc_style_rules.csv')]];
      return cands.filter(([, f]) => fs.existsSync(f)).map(([l, f]) => fileLeaf(l, f, f.endsWith('.csv') ? 'table' : 'markdown', rowsOf(f))); }
    if (el.group === 'hookdocs') { const hd = path.join(p.root, 'Doc', '_rules_v2', 'hooks'); if (!fs.existsSync(hd)) return [leaf('Doc/_rules_v2/hooks 없음', 'warning')]; return fs.readdirSync(hd).filter(f => /\.md$/.test(f) && !/\.bak/.test(f)).sort().map(f => fileLeaf(f, path.join(hd, f))); }
    if (el.group === 'hhooks') { const hd = path.join(p.harnessDir, 'hooks'); if (!fs.existsSync(hd)) return [leaf('tools/Harness/hooks 없음', 'warning')]; const items = fs.readdirSync(hd).filter(f => /\.(ps1|js|py|cmd)$/.test(f)).sort().map(f => fileLeaf(f, path.join(hd, f), 'shield')); const rm = path.join(p.root, '.claude', 'hooks', 'README.md'); if (fs.existsSync(rm)) items.push(fileLeaf('.claude/hooks/README.md (실행 hook 상세)', rm)); return items; }
    if (el.group === 'vibe') { const d = path.join(p.root, 'tools', 'VibeManager', 'rules'); if (!fs.existsSync(d)) return [leaf('tools/VibeManager/rules 없음', 'warning')]; return fs.readdirSync(d).filter(f => /\.(md|csv|json)$/.test(f)).sort().map(f => { const it = leaf(f, 'book'); it.command = { command: 'vscode.open', title: '열기', arguments: [vscode.Uri.file(path.join(d, f))] }; it.tooltip = path.join(d, f); return it; }); }
    if (el.group === 'rules') { if (!fs.existsSync(p.rulesDir)) return [leaf('rules/ 없음 — tools/Harness 확인', 'warning')]; return fs.readdirSync(p.rulesDir).filter(f => /\.(csv|md)$/.test(f)).sort().map(f => { const full = path.join(p.rulesDir, f); let n = ''; try { if (f.endsWith('.csv')) n = `${csvRowCount(full)}행`; } catch (_) { } const it = leaf(f, f.startsWith('_') ? 'lightbulb' : f.endsWith('.csv') ? 'table' : 'markdown', n); it.contextValue = 'rule'; it.target = full; it.command = { command: 'vibeManager.openItem', title: '열기', arguments: [it] }; return it; }); }
    if (el.group === 'hooks') { const sf = path.join(p.root, '.claude', 'settings.json'); if (!fs.existsSync(sf)) return [leaf('.claude/settings.json 없음', 'warning')]; let j; try { j = JSON.parse(fs.readFileSync(sf, 'utf8')); } catch (e) { return [leaf('settings.json 파싱 실패: ' + e.message, 'error')]; } const items = [];
      for (const [ev, groups] of Object.entries(j.hooks || {})) for (const g of groups) for (const h of g.hooks || []) { const file = (h.command.match(/([^\s\\/]+\.(ps1|sh|js|cmd))/) || [, h.command])[1]; const disabled = /^(REM|::|#|rem\s)\s*DISABLED\s*/.test(h.command) || h._disabled === true; const it = leaf(`${ev}${g.matcher ? ' [' + g.matcher + ']' : ''} · ${file}`, disabled ? 'circle-slash' : 'check', disabled ? '꺼짐' : `timeout ${h.timeout || '-'}s`); it.contextValue = 'hook'; it.hook = { ev, matcher: g.matcher || '', command: h.command, disabled }; it.tooltip = h.command; const hf = (h.command.match(/[A-Za-z]:[\\/][^\s"]+\.(ps1|sh|js|cmd)/) || [])[0]; if (hf) { it.target = hf; it.command = { command: 'vibeManager.openItem', title: '열기', arguments: [it] }; } items.push(it); }
      return items.length ? items : [leaf('등록된 hook 없음', 'info')]; }
    if (el.group === 'husky') { const d = path.join(p.tobeDir, '.husky'); if (!fs.existsSync(d)) return [leaf('.husky 없음', 'warning')]; return fs.readdirSync(d).filter(f => !f.startsWith('_') && !f.startsWith('.')).map(f => { const full = path.join(d, f); const body = fs.readFileSync(full, 'utf8'); const it = leaf(f, 'git-commit', /Harness/.test(body) ? '하네스 게이트 포함' : ''); it.contextValue = 'hookfile'; it.target = full; it.command = { command: 'vibeManager.openItem', title: '열기', arguments: [it] }; return it; }); }
    if (el.group === 'docs') { const cands = [['rules/tobe_rules.md (룰 ↔ 판정 색인)', path.join(p.rulesDir, 'tobe_rules.md')], ['Harness README (도구 등록부 · scripts/rules/inventory_check.py --write-registry 로 갱신)', path.join(p.harnessDir, 'README.md')], ['prompts/new_screen.md (Claude 지시)', path.join(p.promptsDir, 'new_screen.md')], ['Doc/verify/_ENGINE_MASTER.md (검증엔진 작업 표)', path.join(p.root, 'Doc', 'verify', '_ENGINE_MASTER.md')], ['Doc/verify/_proof_backlog.md (기능 구현 증명 남은 일)', path.join(p.root, 'Doc', 'verify', '_proof_backlog.md')], ['VibeManager CHANGELOG.md', path.join(p.root, 'tools', 'VibeManager', 'CHANGELOG.md')]];
      // 참고자료(2026-10-23 사용자 지시): SCP·SSP 화면 VALIDATION 취합 — 최신 STAMP 자동(엑셀 텍스트본 + 화면별 인덱스)
      const vd = path.join(p.root, 'Doc', '화면분석서');
      for (const dom of ['SCP', 'SSP']) { const re = new RegExp(`^${dom}_화면_VALIDATION_취합_(\\d{8})\\.md$`); const hit = fs.existsSync(vd) ? fs.readdirSync(vd).filter(n => re.test(n)).sort().pop() : ''; if (hit) { cands.push([`참고: ${hit} (VALIDATION 취합 전체본)`, path.join(vd, hit)]); cands.push([`참고: ${hit.replace(/\.md$/, '')}/_INDEX.md (화면별)`, path.join(vd, hit.replace(/\.md$/, ''), '_INDEX.md')]); } }
      return cands.filter(([, f]) => fs.existsSync(f)).map(([l, f]) => { const it = leaf(l, 'markdown'); it.contextValue = 'doc'; it.target = f; it.command = { command: 'vibeManager.openItem', title: '열기', arguments: [it] }; return it; }); }
    return [];
  }
}
function leaf(label, icon, desc) { const it = new vscode.TreeItem(label, vscode.TreeItemCollapsibleState.None); it.iconPath = new vscode.ThemeIcon(icon); if (desc) it.description = desc; return it; }
async function toggleHook(node) {
  if (!node || !node.hook) return; const p = paths(); const sf = path.join(p.root, '.claude', 'settings.json');
  const j = JSON.parse(fs.readFileSync(sf, 'utf8')); let changed = false;
  for (const g of j.hooks[node.hook.ev] || []) for (const h of g.hooks || []) if (h.command === node.hook.command) { h._disabled = !node.hook.disabled; changed = true; }
  // Claude Code 는 _disabled 를 모른다 → 꺼진 hook 은 command 를 무해한 echo 로 바꾸고 원본을 _origCommand 에 보관
  for (const g of j.hooks[node.hook.ev] || []) for (const h of g.hooks || []) { if (h._disabled && !h._origCommand) { h._origCommand = h.command; h.command = process.platform === 'win32' ? 'cmd /c exit 0' : 'true'; } if (h._disabled === false && h._origCommand) { h.command = h._origCommand; delete h._origCommand; delete h._disabled; } }
  if (!changed) return; fs.copyFileSync(sf, sf + '.bak_vibe'); fs.writeFileSync(sf, JSON.stringify(j, null, 2) + '\n', 'utf8');
  vscode.window.showInformationMessage(`Hook ${node.hook.disabled ? '켬' : '끔'}: ${node.label} (백업 settings.json.bak_vibe)`); harnessTree.refresh();
}

// ───────────────────────── 트리: 환경설정 ─────────────────────────
const SECRET = /(PASS|PWD|PASSWORD|SECRET|TOKEN|KEY)/i;
class EnvProvider {
  constructor() { this._em = new vscode.EventEmitter(); this.onDidChangeTreeData = this._em.event; }
  refresh() { this._em.fire(); }
  getTreeItem(el) { return el; }
  getChildren(el) {
    const p = paths(); if (!p.root) return [];
    if (!el) { const items = [leaf(`루트 ${p.root}`, 'root-folder')]; items[0].command = { command: 'vibeManager.openSettings', title: '설정' };
      for (const f of p.envFiles) { const full = path.isAbsolute(f) ? f : path.join(p.root, f); const it = new vscode.TreeItem(f, fs.existsSync(full) ? vscode.TreeItemCollapsibleState.Collapsed : vscode.TreeItemCollapsibleState.None); it.iconPath = new vscode.ThemeIcon(fs.existsSync(full) ? 'settings-gear' : 'warning'); it.description = fs.existsSync(full) ? '' : '없음'; it.file = full; it.contextValue = 'doc'; it.target = full; items.push(it); }
      const cv = claudeBin && claudeBin.file === p.claude ? claudeBin.ver : '';
      const ci = leaf(`Claude CLI: ${p.claude}${cv ? ` (v${cv})` : ''}${p.claudeModel ? ' --model ' + p.claudeModel : ''} · Agent ${p.agentDriver}/${p.agentModel}`, cv && cmpVer(cv, CLAUDE_MIN) < 0 ? 'warning' : 'sparkle');
      ci.tooltip = (claudeBin && claudeBin.seen ? '후보:\n' + claudeBin.seen.join('\n') : '') + `\n최신 모델 요구: ${CLAUDE_MIN}+`; items.push(ci); return items; }
    if (el.file) { try { const txt = fs.readFileSync(el.file, 'utf8').replace(/^﻿/, '');
      if (/\.json$/.test(el.file)) { const j = JSON.parse(txt); return flat(j).slice(0, 60).map(([k, v]) => leaf(k, 'symbol-property', SECRET.test(k) ? '••••••' : String(v).slice(0, 80))); }
      return txt.split(/\r?\n/).filter(l => l.trim() && !l.trim().startsWith('#')).slice(0, 60).map(l => { const m = l.match(/^\s*([A-Za-z0-9_.-]+)\s*=\s*(.*)$/); return m ? leaf(m[1], 'symbol-variable', SECRET.test(m[1]) ? '••••••' : m[2].slice(0, 80)) : leaf(l.slice(0, 80), 'dash'); }); } catch (e) { return [leaf('읽기 실패: ' + e.message, 'error')]; } }
    return [];
  }
}

// ───────────────────────── 트리: 완료 정의(DoD) — 화면 하나의 "끝났는가" ─────────────────────────
class DodProvider {
  constructor() { this._em = new vscode.EventEmitter(); this.onDidChangeTreeData = this._em.event; }
  refresh() { this._em.fire(); }
  getTreeItem(el) { return el; }
  id() { return workbench.currentId() || ctx.workspaceState.get('vibeManager.lastId', ''); }  // 1.9.28+: 현재 창 ID 우선
  getChildren(el) {
    const p = paths(); if (!p.root) return []; const ID = this.id();
    if (!el) {
      const head = leaf(ID ? `화면 ${ID}` : '화면 ID 를 선택하세요 (클릭)', 'symbol-class'); head.command = { command: 'vibeManager.quickScreen', title: '화면 선택' };
      if (!ID) return [head];
      const g = path.join(p.genDir, ID); const rd = f => fs.existsSync(path.join(g, f)) ? fs.readFileSync(path.join(g, f), 'utf8') : '';
      const dod = rd('DOD.md'), chk = rd('CHECK.md'), pkg = rd('CHECK_PKG.md'), pipe = rd('PIPELINE.md');
      const m = /(\d+)\/(\d+) 충족/.exec(dod); const b = /BLOCK (\d+) \/ WARN (\d+)/.exec(chk); const pb = /BLOCK (\d+) \/ WARN (\d+)/.exec(pkg);
      const conf = (() => { try { const csv = fs.readFileSync(path.join(p.reconOutDir, '대사표_화면.csv'), 'utf8').replace(/^﻿/, '').split(/\r?\n/); const h = csv[0].split(','); const ci = h.indexOf('confidence'), si = h.indexOf('status'), ii = h.indexOf('asis_id'), ti = h.indexOf('tobe_id'); const row = csv.slice(1).map(l => l.split(',')).find(c => c[ii] === ID || c[ti] === ID); return row ? `${row[ci] || '-'} (${row[si]})` : '-'; } catch { return '-'; } })();
      const items = [head];
      const grp = (label, icon, key, desc, ok, folded) => { const it = new vscode.TreeItem(label, folded ? vscode.TreeItemCollapsibleState.Collapsed : vscode.TreeItemCollapsibleState.Expanded); it.iconPath = new vscode.ThemeIcon(icon, ok === false ? new vscode.ThemeColor('errorForeground') : undefined); it.description = desc; it.group = key; return it; };
      // 2026-11-18 사용자: 완료 정의를 최신 기준으로 — 판정 기준 = CheckList(원장 결과 + '미검증' 시트) · AS-IS 실측 · 화면·PKG·메타 게이트 · 테스트 산출물
      const vd = path.join(p.root, 'Doc', 'verify', ID); const js = f => { try { return JSON.parse(fs.readFileSync(path.join(vd, f), 'utf8').replace(/^﻿/, '')); } catch { return null; } };
      const env = js('run_verify.result.json'); const sm = env && env.summary; const cc = js('checklist_counts.json');
      const unv = cc ? cc.unverified_sheet : null;
      const prc = pendingRecheck(vd); // 2026-11-19 사용자: 미검증 해소 보완 뒤에는 보완 전 CheckList 건수를 보여 주지 않는다
      const clDesc = prc ? `보완 ${prc.fixedAt} · CheckList 재수행 전(건수는 재수행 뒤 표시)` : sm ? `FAIL ${sm.FAIL} · 판정필요 ${sm['판정필요']} · 미검증 ${sm['미검증']}${unv != null ? ` · 미검증 시트 ${unv}` : ' · 미검증 시트 미집계'} · ${env.started || ''}${env.state !== 'completed' ? ` · ${env.state}` : ''}` : 'CheckList 미실행';
      items.push(grp('CheckList (완료 기준)', 'checklist', 'cl', clDesc, prc ? undefined : sm ? (sm.FAIL === 0 && sm['판정필요'] === 0 && sm['미검증'] === 0 && unv === 0 && env.state === 'completed') : undefined));
      const bd = (() => { try { return JSON.parse(fs.readFileSync(path.join(p.root, 'Doc', 'asislive', ID, 'screen_bundle.json'), 'utf8').replace(/^﻿/, '')); } catch { return null; } })();
      items.push(grp('AS-IS 실측', 'device-desktop', 'live', bd ? `${bd.status} · ${bd.at || ''}${bd.reused ? ' · 재사용' : ''}` : '미실측', bd ? (bd.status === 'OK' || bd.status === 'NA') : undefined));
      const fg = js('fe_gate.json'), pg = js('pkg_gate.json'); const mlc = (() => { try { return readCsv(path.join(vd, 'meta_live_check.csv')); } catch { return null; } })();
      const gcnt = arr => { const g = (arr || []).filter(x => x && x.result); const f = g.filter(x => x.result === 'FAIL').length; return `${g.length - f}/${g.length}${f ? ` FAIL ${f}` : ''}`; };
      const gok = [fg && fg.gates, pg && pg.gates, mlc].filter(Boolean);
      items.push(grp('화면·PKG·메타 게이트', 'shield', 'gate', [fg ? `FE ${gcnt(fg.gates)}` : 'FE 미실행', pg ? `PKG ${gcnt(pg.gates)}` : 'PKG 미실행', mlc ? `메타 ${gcnt(mlc)}` : '메타 미실행'].join(' · '), gok.length ? gok.every(a => !a.some(x => x.result === 'FAIL')) : undefined));
      items.push(grp('테스트 결과·문서', 'beaker', 'out', '', undefined));
      items.push(grp('완료 정의(DoD · 하네스 게이트)', 'checklist', 'dod', m ? `${m[1]}/${m[2]}` : '미판정 — 게이트 실행', m ? m[1] === m[2] : undefined, true));
      items.push(grp('FE 게이트(check.js --final)', 'shield', 'chk', b ? `BLOCK ${b[1]} / WARN ${b[2]}` : '미실행', b ? b[1] === '0' : undefined, true));
      items.push(grp('PKG 게이트(check-pkg.js)', 'database', 'pkg', pb ? `BLOCK ${pb[1]} / WARN ${pb[2]}` : '미실행', pb ? pb[1] === '0' : undefined, true));
      items.push(grp('파이프라인·테스트·신뢰도', 'rocket', 'pipe', pipe ? (/✅/.test(pipe.split('\n')[0]) ? 'PASS' : '사람 확인 필요') + ` · 신뢰도 ${conf}` : `신뢰도 ${conf}`, pipe ? /✅/.test(pipe.split('\n')[0]) : undefined, true));
      return items;
    }
    const g2 = path.join(paths().genDir, ID); const rd2 = f => fs.existsSync(path.join(g2, f)) ? fs.readFileSync(path.join(g2, f), 'utf8') : '';
    const openLine = (where) => { const mm = /^(.*?):(\d+)$/.exec(where || ''); return mm ? { command: 'vibeManager.openItem', title: '열기', arguments: [{ target: mm[1], line: Number(mm[2]), relTo: 'page', id: ID }] } : undefined; };
    const vd2 = path.join(paths().root, 'Doc', 'verify', ID); const js2 = f => { try { return JSON.parse(fs.readFileSync(path.join(vd2, f), 'utf8').replace(/^﻿/, '')); } catch { return null; } };
    const openFile = (it, f) => { if (f && fs.existsSync(f)) { it.command = { command: 'vibeManager.openItem', title: '열기', arguments: [{ target: f }] }; it.tooltip = f; } return it; };
    const latestOf = (dir, re) => { try { const vn = n => Number((/_v(\d+)\./.exec(n) || [])[1] || 0); const hit = fs.readdirSync(dir).filter(n => re.test(n) && !n.startsWith('~$')).sort((a, b) => vn(a) - vn(b) || fs.statSync(path.join(dir, a)).mtimeMs - fs.statSync(path.join(dir, b)).mtimeMs).pop(); return hit ? path.join(dir, hit) : ''; } catch { return ''; } };
    if (el.group === 'cl') { const env = js2('run_verify.result.json'); if (!env) return [Object.assign(leaf('CheckList 결과 없음 — 🔎 CheckList 실행', 'info'), { command: { command: 'vibeManager.qCheckList', title: '실행' } })];
      const sm = env.summary || {}; const cc = js2('checklist_counts.json'); const items = [];
      // 2026-11-19 사용자: 미검증 해소 보완 뒤 재수행 전이면 보완 전 건수(전체·FAIL·판정필요·미검증·미검증 시트·처리 대상·문제 목록)를 숨기고 안내·기록·문서만
      { const prc = pendingRecheck(vd2); if (prc) {
        items.push(Object.assign(leaf('미검증 해소 보완 완료 · CheckList 재수행 전', 'info', `보완 ${prc.fixedAt} · 건수는 CheckList 재수행 뒤 표시`), { command: { command: 'vibeManager.qCheckList', title: '실행' } }));
        items.push(openFile(leaf('미검증 해소 기록', 'file', '_unverified_work.md'), path.join(vd2, '_unverified_work.md')));
        items.push(openFile(leaf('미검증 결정 목록', 'file', '_unverified_decisions.md'), path.join(vd2, '_unverified_decisions.md')));
        const fe0 = latestOf(vd2, /^FE_GUIDE_.*\.md$/); if (fe0) items.push(openFile(leaf('FE 가이드(DB MODE)', 'book', path.basename(fe0)), fe0));
        return items; } }
      items.push(leaf(`전체 ${sm.rows} · PASS ${sm.PASS} · 해당없음 ${sm['해당없음']}`, 'list-flat', `${env.started || ''}${env.skip_e2e ? ' · E2E 미실행' : ''}`));
      for (const [k, icon] of [['FAIL', 'error'], ['판정필요', 'question'], ['미검증', 'circle-slash']]) items.push(leaf(`${k} ${sm[k]}`, sm[k] ? icon : 'pass-filled'));
      if (cc) { const it = leaf(`미검증 시트 ${cc.unverified_sheet}`, cc.unverified_sheet ? 'circle-slash' : 'pass-filled', Object.entries(cc.unverified_by_reason || {}).map(([k, v]) => `${k} ${v}`).join(' · ') + (cc.direct_unmeasured ? ` · 직접 실측 없음 ${cc.direct_unmeasured}` : '')); items.push(it); }
      else items.push(leaf('미검증 시트 미집계', 'info', '다음 CheckList 실행부터 집계'));
      { const ut = js2('unverified_triage.json'); if (ut) items.push(openFile(leaf(`미검증 해소: 처리 대상 ${ut.actionable} · 사람 확인 ${ut.human}`, ut.actionable ? 'tools' : 'pass-filled', `원장 미검증 ${(ut.before || {}).total} → ${(ut.after || {}).total} · 라운드 ${ut.round} · ${ut.at}`), path.join(paths().root, 'Doc', 'verify', ID, 'unverified_triage.md'))); } // 2026-11-18 CheckList 뒤 미검증 해소
      const docs = env.docs || {}; for (const [k, v] of Object.entries(docs)) items.push(openFile(leaf(k, 'file', path.basename(v)), path.join(paths().root, v)));
      const fe = latestOf(vd2, /^FE_GUIDE_.*\.md$/); if (fe) items.push(openFile(leaf('FE 가이드(DB MODE)', 'book', path.basename(fe)), fe));
      for (const x of (env.issues || []).slice(0, 40)) items.push(leaf(`${x.id} ${x.msg || ''}`.slice(0, 120), 'error', x.class || ''));
      return items; }
    if (el.group === 'live') { const bd = (() => { try { return JSON.parse(fs.readFileSync(path.join(paths().root, 'Doc', 'asislive', ID, 'screen_bundle.json'), 'utf8').replace(/^﻿/, '')); } catch { return null; } })();
      if (!bd) return [Object.assign(leaf('실측 없음 — 🎥 AS-IS 실측 실행', 'info'), { command: { command: 'vibeManager.runTask', title: '실행', arguments: ['S1.liveScreen', { id: ID }] } })];
      const items = (bd.steps || []).map(s => leaf(s.step, s.rc === 0 || s.rc == null ? 'pass-filled' : s.rc === 3 ? 'circle-slash' : 'error', `${s.rc == null ? '재사용' : 'rc ' + s.rc} · ${s.sec}s${s.note ? ' · ' + String(s.note).slice(0, 60) : ''}`));
      items.push(openFile(leaf('실측 폴더', 'folder', `Doc/asislive/${ID}`), path.join(paths().root, 'Doc', 'asislive', ID))); return items; }
    if (el.group === 'gate') { const items = [];
      for (const [f, lb] of [['fe_gate.json', 'FE'], ['pkg_gate.json', 'PKG']]) { const g = js2(f); if (!g) { items.push(leaf(`${lb} 게이트 미실행`, 'info')); continue; } for (const x of g.gates || []) items.push(openFile(leaf(`${lb} ${x.gate}`, x.result === 'PASS' ? 'pass-filled' : x.result === 'FAIL' ? 'error' : 'circle-outline', `${x.result} · ${String(x.detail || '').slice(0, 80)}`), path.join(vd2, f))); }
      try { const rows = readCsv(path.join(vd2, 'meta_live_check.csv')); for (const r of rows) items.push(leaf(`메타 ${r.check} ${r.target}`.slice(0, 100), r.result === 'PASS' ? 'pass-filled' : r.result === 'FAIL' ? 'error' : 'circle-outline', `${r.result} · ${String(r.detail || '').slice(0, 80)}`)); } catch { items.push(leaf('메타 게이트 미실행', 'info')); }
      return items; }
    if (el.group === 'out') { const r = paths().root; const items = [];
      for (const [lb, dir, re] of [['TestResultList', path.join(r, 'Doc', '테스트결과서'), new RegExp(`^${ID}_.*\\.xlsx$`)], ['UI 테스트 Excel', path.join(r, 'Doc', 'UI_TEST(SCP&SSP)'), new RegExp(`_${ID}\\(.*\\.xlsx$`)], ['화면설계서', path.join(r, 'Doc', '화면설계서'), new RegExp(`${ID}.*\\.xlsx$`)], ['화면분석서', path.join(r, 'Doc', '화면분석서'), new RegExp(`${ID}.*\\.xlsx$`)], ['단위테스트', path.join(r, 'Doc', '단위테스트'), new RegExp(`${ID}.*\\.xlsx$`)]]) {
        const f = latestOf(dir, re); items.push(f ? openFile(leaf(lb, 'file', path.basename(f)), f) : leaf(lb, 'circle-outline', '없음')); }
      items.push(Object.assign(leaf('🚀 ID 하나로 전체 (파싱 → 실측 → 생성 → CheckList → 보완 → TestResultList → 문서)', 'play'), { command: { command: 'vibeManager.qFullChain', title: '실행' } }));
      return items; }
    if (el.group === 'dod') return rd2('DOD.md').split(/\r?\n/).map(l => /^\|\s*(B\d\d)\s*\|\s*(✅|❌)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|$/.exec(l)).filter(Boolean).sort((x, y) => (x[2] === '❌' ? 0 : 1) - (y[2] === '❌' ? 0 : 1)).map(x => { const it = leaf(`${x[1]} ${x[3]}`, x[2] === '✅' ? 'pass-filled' : 'error', x[2] === '❌' ? x[4] : ''); it.tooltip = x[4]; return it; });
    if (el.group === 'chk' || el.group === 'pkg') { const txt = rd2(el.group === 'chk' ? 'CHECK.md' : 'CHECK_PKG.md'); const rows = txt.split(/\r?\n/).map(l => /^- (BLOCK|WARN) (\w+) (.*?)(?: @(\S+))?$/.exec(l)).filter(Boolean); const out = rows.filter(r => r[1] === 'BLOCK').concat(rows.filter(r => r[1] === 'WARN').slice(0, 40)).map(r => { const it = leaf(`${r[2]} ${r[3]}`, r[1] === 'BLOCK' ? 'error' : 'warning', r[4] || ''); it.command = openLine(r[4]); return it; }); return out.length ? out : [leaf(txt ? '지적 없음' : '게이트 미실행 — 5단계 게이트 판정', 'info')]; }
    if (el.group === 'pipe') { const items = []; for (const [f, label, icon] of [['PIPELINE.md', '파이프라인 결과', 'rocket'], ['REPAIR.md', 'FE 수선 기록', 'sync'], ['REPAIR_PKG.md', 'PKG 이식 기록', 'sync'], ['GEN_NOTES.md', '생성 메모(채울 것)', 'note'], [`${ID}_registration.sql`, '메타 등록 SQL', 'database'], [`${ID}_PKG.sql`, 'PKG 골격', 'database'], ['e2e_plan.json', 'E2E 플랜', 'beaker']]) { const full = path.join(g2, f); const it = leaf(label, icon, fs.existsSync(full) ? f : '없음'); if (fs.existsSync(full)) it.command = { command: 'vibeManager.openItem', title: '열기', arguments: [{ target: full }] }; items.push(it); }
      // 1.9.42(2026-11-06): 화면 폴더 Doc/e2e/results/<ID>/ 요약 우선 · 없으면(전환 전) 공용 색인
      const e2eDirId = path.join(paths().e2eOutDir, 'results', String(ID).toUpperCase()); const e2eMd = fs.existsSync(path.join(e2eDirId, '_summary.md')) ? path.join(e2eDirId, '_summary.md') : path.join(paths().e2eOutDir, 'results', '_summary.md');
      const e2e = fs.existsSync(path.join(e2eDirId, '_summary.csv')) ? path.join(e2eDirId, '_summary.csv') : path.join(paths().e2eOutDir, 'results', '_summary.csv'); if (fs.existsSync(e2e)) { const rows = fs.readFileSync(e2e, 'utf8').split(/\r?\n/).filter(l => l.includes(`"${ID}"`)); const pass = rows.filter(l => l.includes('"PASS"')).length;
        // 1.8.8: 종류별(smoke/crud/auth/authcrud) 합계 표기
        const per = ['smoke', 'crud', 'auth', 'authcrud'].map(k => { const r = rows.filter(l => l.includes(`"${k}"`)); return r.length ? `${k} ${r.filter(l => l.includes('"PASS"')).length}/${r.length}` : null; }).filter(Boolean).join(' · ');
        const it = leaf(`E2E 결과 ${pass}/${rows.length}${per ? ` (${per})` : ''}`, rows.length && pass === rows.length ? 'pass-filled' : 'beaker'); it.command = { command: 'vibeManager.openItem', title: '열기', arguments: [{ target: e2eMd }] }; items.push(it); }
      // 1.9.42(2026-11-06): 화면 폴더 골든 요약 Doc/golden/<ID>/_summary.csv 우선 · 없으면 공용 색인. PASS 는 verdict 열로 센다(종전 '줄 끝 ,PASS' 는 마지막 열 order(정렬 대조)를 세고 있었다)
      const goldId = path.join(paths().goldenDir, String(ID).toUpperCase(), '_summary.csv'); const gold = fs.existsSync(goldId) ? goldId : path.join(paths().goldenDir, '_summary.csv'); if (fs.existsSync(gold)) { const gl = fs.readFileSync(gold, 'utf8').replace(/^﻿/, '').split(/\r?\n/); const vIx = (gl[0] || '').split(',').indexOf('verdict'); const rows = gl.filter(l => l.startsWith(ID + ',')); const pass = rows.filter(l => vIx >= 0 ? (l.split(',')[vIx] || '').trim() === 'PASS' : /,PASS\s*$/.test(l)).length; items.push(leaf(`골든 테스트 ${pass}/${rows.length}`, rows.length && pass === rows.length ? 'pass-filled' : 'beaker')); }
      items.push(Object.assign(leaf('pipeline.js 단독 실행 (생성 8단계만 · 전체 흐름은 🚀 ID 하나로 전체)', 'play'), { command: { command: 'vibeManager.runTask', title: '실행', arguments: ['S5.pipeline', { id: ID }] } }));
      return items; }
    return [];
  }
}
// ───────────────────────── 1.7.3: 전체 메뉴 (워크벤치 아코디언 = 사이드바 트리, 단일 정의) ─────────────────────────
//   quick.json 그룹 + 구 사이드바 4개 카테고리(NSCM 전환 단계 · DoD · 룰/Hook/하네스 · 환경설정).
//   카테고리 내용은 기존 트리 제공자(StepsProvider·DodProvider·HarnessProvider·EnvProvider)를 그대로 위임 → 항목 누락 없음.
//   quick.json 의 '환경설정' 그룹은 환경설정 카테고리로 합친다(같은 이름 메뉴 2개 방지).
// 1.8.3: 언어 선택 — quick.json/steps.json 의 *_en 필드를 쓰고(없으면 원문), 카테고리·액션 문구는 아래 사전
let menuEn = false; // 영문 강제 스위치 — 2026-11-11 저녁부터 메뉴도 언어 설정을 따르므로 menu-view 는 쓰지 않는다(남겨 둠)
const isEn = () => menuEn || paths().language === 'en';
const L = (o, k = 'label') => (isEn() && o && o[k + '_en']) ? o[k + '_en'] : (o ? o[k] : '');
const CAT = { steps: ['NSCM Migration Steps', 'NSCM 전환 단계'], dod: ['Definition of Done — Current Screen', '완료 정의(DoD) — 현재 화면'], harness: ['Rules · Hooks · Harness', '룰 · Hook · 하네스'], env: ['Settings', '환경설정'],
  recheck: ['🔄 Re-check gates', '🔄 게이트 다시 판정'], pick: ['📍 Pick screen · step tasks', '📍 화면 선택 · 단계 작업'], current: ['📋 Current settings', '📋 현재 설정값'] };
const T = k => CAT[k][isEn() ? 0 : 1];
function menuSections() {
  const p = paths(); const groups = (promptPanel.loadQuick(p.extDir, p.root).groups || []);
  const envG = groups.find(g => /환경|settings/i.test(g.title)) || null;
  // 1.7.4: 그룹 이모지 — 메뉴 전체에서 이모지 중복 없음 (quick.json 항목 이모지와도 겹치지 않게 배정)
  const groupIcon = title => /서버|server/i.test(title) ? '🖥️' : /소스|git/i.test(title) ? '📦' : /^UI/.test(title) ? '🪟' : /분석/.test(title) ? '📑' : /^화면/.test(title) ? '🖼️' : /전체|overview/i.test(title) ? '🧭' : /Claude/.test(title) ? '✴️' : '📁';
  const out = groups.filter(g => g !== envG).map(g => ({ key: 'q:' + g.title, kind: 'quick', title: L(g, 'title'), icon: groupIcon(g.title), group: g }));
  out.push({ key: 'steps', kind: 'cat', title: T('steps'), icon: '🌲', actions: [{ label: T('recheck'), command: 'vibeManager.refresh' }] });
  out.push({ key: 'dod', kind: 'cat', title: T('dod'), icon: '✔️', actions: [{ label: T('pick'), command: 'vibeManager.quickScreen' }] });
  out.push({ key: 'harness', kind: 'cat', title: T('harness'), icon: '🧩' });
  out.push({ key: 'env', kind: 'cat', title: T('env'), icon: '⚙️', group: envG });
  return out;
}
// 1.7.4: 한 행에 아이콘 1개 — 라벨이 이모지/기호로 시작하면 codicon 을 붙이지 않고,
//        codicon(게이트 상태 등)이 있는 위임 항목은 라벨 앞 기호(★ 등)를 떼어 하나만 보이게 한다.
const LEAD_SYM = /^\s*(?:\p{Extended_Pictographic}|[★☆✎✱])️?\s*/u;
function oneIcon(it) {
  const l = typeof it.label === 'string' ? it.label : (it.label && it.label.label) || '';
  if (!LEAD_SYM.test(l)) return it;
  if (it.iconPath) { const s = l.replace(LEAD_SYM, ''); if (typeof it.label === 'string') it.label = s; else it.label = Object.assign({}, it.label, { label: s }); }
  return it;
}
function catProvider(k) { return { steps: tree, dod: dodTree, harness: harnessTree, env: envTree }[k]; }
class MenuProvider {
  constructor() { this._em = new vscode.EventEmitter(); this.onDidChangeTreeData = this._em.event; }
  refresh() { this._em.fire(); }
  getTreeItem(el) { return el; }
  getChildren(el) {
    const p = paths(); vscode.commands.executeCommand('setContext', 'vibeManager.noRoot', !p.root); if (!p.root) return [];
    // 1.7.4: 그룹·카테고리 = 이모지 1개(codicon 없음) · quick 항목 = 라벨 이모지 1개(codicon 없음)
    if (!el) return menuSections().map((s, i) => {
      const it = new vscode.TreeItem(`${s.icon} ${s.title}`, i === 0 ? vscode.TreeItemCollapsibleState.Expanded : vscode.TreeItemCollapsibleState.Collapsed);
      it.section = s; if (s.kind === 'quick') it.description = `${(s.group.items || []).length}`; return it;
    });
    const plain = (label, desc) => { const it = new vscode.TreeItem(label, vscode.TreeItemCollapsibleState.None); if (desc) it.description = desc; if (!LEAD_SYM.test(label)) it.iconPath = new vscode.ThemeIcon('play'); return it; };
    const quickLeaf = q => { const it = plain(L(q), q.needsId ? 'ID' : ''); it.tooltip = q.hint || q.task || q.command || q.kind; it.contextValue = 'quick'; it.command = { command: 'vibeManager.runQuick', title: '실행', arguments: [q] }; return it; };
    // 1.8.8: 서브그룹 — 항목에 sub(분석 / 생성·보완 / 테스트 / 문서)가 있으면 그룹 아래 한 단계 더 묶는다(첫 등장 순서 · 펼침)
    if (el._subItems) return el._subItems.map(quickLeaf);
    if (el.section) {
      const s = el.section; const items = [];
      const qs = (s.group && s.group.items) || [];
      if (qs.some(q => q.sub)) {
        const order = []; const bucket = new Map();
        for (const q of qs) { const k = q.sub || '기타'; if (!bucket.has(k)) { bucket.set(k, []); order.push(k); } bucket.get(k).push(q); }
        for (const k of order) { const first = bucket.get(k)[0]; const title = (isEn() ? (first.sub_en || k) : k); const hd = new vscode.TreeItem(`${first.sub_icon || '📂'} ${title}`, vscode.TreeItemCollapsibleState.Expanded); hd.description = String(bucket.get(k).length); hd._subItems = bucket.get(k); items.push(hd); }
      } else for (const q of qs) items.push(quickLeaf(q));
      for (const a of s.actions || []) { const it = plain(a.label); it.command = { command: a.command, title: a.label }; items.push(it); }
      if (s.kind === 'cat') {
        const prov = catProvider(s.key); const kids = prov ? prov.getChildren(undefined) : [];
        if (s.group && kids.length) { const hd = new vscode.TreeItem(T('current'), vscode.TreeItemCollapsibleState.Expanded); hd._prov = s.key; hd._root = true; items.push(hd); }
        else for (const k of kids) { k._prov = s.key; items.push(oneIcon(k)); }
      }
      return items;
    }
    if (el._prov) { const prov = catProvider(el._prov); const kids = (prov ? prov.getChildren(el._root ? undefined : el) : []) || []; for (const k of kids) { k._prov = el._prov; oneIcon(k); } return kids; }
    return [];
  }
}
function flat(o, pre = '', out = []) { for (const [k, v] of Object.entries(o || {})) { const key = pre ? pre + '.' + k : k; if (v && typeof v === 'object' && !Array.isArray(v) && Object.keys(v).length && out.length < 200) flat(v, key, out); else out.push([key, Array.isArray(v) ? `[${v.length}]` : v]); } return out; }
async function checkEnv() {
  const p = paths(); const lines = [`# 환경 점검 — ${new Date().toLocaleString()}`, ''];
  const tryCmd = (cmd, args) => { try { return cp.execFileSync(cmd, args, { encoding: 'utf8', timeout: 15000, shell: process.platform === 'win32' }).trim().split(/\r?\n/)[0]; } catch (e) { return `✗ ${e.message.split('\n')[0]}`; } };
  lines.push(`- node: ${tryCmd(p.node, ['--version'])}`, `- dotnet: ${tryCmd('dotnet', ['--version'])}`, `- python: ${tryCmd('python', ['--version'])}`, `- git: ${tryCmd('git', ['--version'])}`, `- claude: ${tryCmd(p.claude, ['--version'])}`, '');
  for (const [l, f] of [['As-is 파서', path.join(p.toolsDir, 'run.ps1')], ['To-Be 파서', path.join(p.root, 'tools', 'TobeFacts', 'run.ps1')], ['하네스', path.join(p.harnessDir, 'gen.js')], ['typescript(nscm-fe)', path.join(p.tobeDir, 'node_modules', 'typescript', 'lib', 'typescript.js')], ['As-is Fact Pack', path.join(p.outDir, 'screens', '_index.csv')], ['To-Be Fact', path.join(p.tobeOutDir, 'screens', '_index.csv')], ['클라우드 메타 CSV', path.join(p.tobeOutDir, 'db', 'proc_meta.csv')]]) lines.push(`- ${l}: ${fs.existsSync(f) ? '✓' : '✗ 없음'} \`${f}\``);
  const dir = path.join(p.vibeDir, 'reports'); fs.mkdirSync(dir, { recursive: true }); const file = path.join(dir, 'env_check.md'); fs.writeFileSync(file, lines.join('\n') + '\n', 'utf8');
  await openPath(file);
}

// ───────────────────────── 상태 표시줄 · 대시보드 ─────────────────────────
function updateStatusBar() {
  if (!statusBar) return; const p = paths(); if (!p.root) { statusBar.text = '$(warning) Vibe_Manager: 루트 없음'; statusBar.show(); return; }
  const vars = Object.assign({}, p, { inputs: {} }); const steps = loadSteps(); const done = steps.filter(s => stepStatus(s, vars).state === 'pass').length;
  statusBar.text = `$(rocket) Vibe_Manager ${done}/${steps.length}`; statusBar.tooltip = 'NSCM 전환 단계 — 클릭하면 대시보드'; statusBar.show();
}
// 1.9.3: 대시보드 = Workbench HTML 탭(별도 웹뷰 창 대신). 본문은 dashboardHtml() 에서 style+body 만 떼고 버튼을 data-action 으로 바꿔 쓴다. Workbench 가 없을 때만 구 패널
function dashboardBody() {
  const full = dashboardHtml();
  const style = (full.match(/<style>[\s\S]*?<\/style>/) || [''])[0].replace(/body\{[^}]*\}/, '.dashw{');
  let body = (full.match(/<body[^>]*>([\s\S]*)<\/body>/) || ['', ''])[1].replace(/<script>[\s\S]*?<\/script>/g, '');
  body = body.replace(/id="refresh"/g, 'id="refresh" data-action="refresh"').replace(/id="quick"/g, 'id="quick" data-action="quick"').replace(/<button data-id=/g, '<button data-action="run" data-id=');
  return `${style}<div class="dashw">${body}</div>`;
}
async function openDashboard() {
  try {
    await vscode.commands.executeCommand('vibeManager.openWorkbench');
    const ok = workbench.openHtmlTab('dashboard', '🛰️ 전환 흐름 대시보드', 'steps.json 단계 × 게이트 판정 · 🔄 로 갱신', dashboardBody, async (action, data) => {
      if (action === 'run') { const t = findTask(data.id); if (t) await runTask(t); }
      else if (action === 'quick') await quickScreen();
      else if (action === 'refresh') refreshDashboard();
    });
    if (ok) return;
  } catch { /* 구 패널로 */ }
  if (dashboard) { dashboard.reveal(); refreshDashboard(); return; }
  dashboard = vscode.window.createWebviewPanel('vibeManager.dashboard', 'NSCM 전환 흐름 — Vibe_Manager', vscode.ViewColumn.One, { enableScripts: true, retainContextWhenHidden: true });
  dashboard.onDidDispose(() => { dashboard = null; });
  dashboard.webview.onDidReceiveMessage(m => { if (m.type === 'run') { const t = findTask(m.id); if (t) runTask(t); } if (m.type === 'refresh') refreshDashboard(); if (m.type === 'quick') quickScreen(); });
  refreshDashboard();
}
function refreshDashboard() { if (dashboard) dashboard.webview.html = dashboardHtml(); try { workbench.refreshHtmlTab && workbench.refreshHtmlTab('dashboard'); } catch { } }
function esc(s) { return String(s == null ? '' : s).replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c])); }
function dashboardHtml() {
  const p = paths(); const vars = Object.assign({}, p, { inputs: {} }); const r = runs(); const steps = loadSteps();
  const stepHtml = steps.map((s, i) => { const st = stepStatus(s, vars); const tasks = (s.tasks || []).map(t => { const g = t.gate && !/\$\{input:/.test(t.gate.file) ? evalGate(t.gate, vars) : null; const run = r[t.id]; const cls = g ? (g.ok ? 'ok' : (g.ran ? 'fail' : 'idle')) : 'plain';
    return `<li class="task ${cls}"><span class="dot"></span><span class="title">${esc(t.title)}</span><span class="meta">${g ? esc(g.detail) : esc(kindName(t.kind))}${run && run.time ? ' · ' + esc(fmtTime(run.time)) : ''}</span><button data-id="${esc(t.id)}" title="실행">▶</button></li>`; }).join('');
    return `<section class="step ${st.state}"><header><span class="num">${i + 1}</span><h2>${esc(s.title.replace(/^\d+\.\s*/, ''))}</h2><span class="badge">${esc(st.text || '게이트 없음')}</span></header><p class="detail">${esc(s.detail || '')}</p><ul>${tasks}</ul></section>`; }).join('');
  return `<!DOCTYPE html><html lang="ko"><head><meta charset="utf-8"><meta http-equiv="Content-Security-Policy" content="default-src 'none'; style-src 'unsafe-inline'; script-src 'unsafe-inline';">
<style>:root{--ok:var(--vscode-testing-iconPassed,#3fb950);--fail:var(--vscode-testing-iconFailed,#f85149);--idle:var(--vscode-descriptionForeground,#888);--line:var(--vscode-widget-border,#444);--card:var(--vscode-editorWidget-background,#222)}
body{font-family:var(--vscode-font-family);color:var(--vscode-foreground);background:var(--vscode-editor-background);margin:0;padding:20px 24px 48px;max-width:980px}h1{font-size:20px;margin:0 0 4px}.sub{color:var(--idle);margin:0 0 20px;font-size:12px}
.spine{border:1px dashed var(--line);border-radius:8px;padding:10px 14px;margin-bottom:20px;font-size:12px;color:var(--idle)}.spine b{color:var(--vscode-foreground)}
.step{border:1px solid var(--line);border-left:4px solid var(--idle);border-radius:8px;background:var(--card);padding:12px 16px 8px;margin:0 0 14px}.step.pass{border-left-color:var(--ok)}.step.fail{border-left-color:var(--fail)}.step.partial{border-left-color:var(--vscode-testing-iconQueued,#d29922)}
.step header{display:flex;align-items:center;gap:10px}.num{display:inline-flex;width:24px;height:24px;border-radius:50%;background:var(--line);align-items:center;justify-content:center;font-size:12px;font-weight:600}.step h2{font-size:15px;margin:0;flex:1}
.badge{font-size:11px;padding:2px 8px;border-radius:10px;border:1px solid var(--line);color:var(--idle)}.step.pass .badge{border-color:var(--ok);color:var(--ok)}.step.fail .badge{border-color:var(--fail);color:var(--fail)}
.detail{font-size:12px;color:var(--idle);margin:6px 0 8px 34px}ul{list-style:none;margin:0;padding:0 0 0 34px}.task{display:flex;align-items:center;gap:8px;padding:5px 0;border-top:1px solid var(--line);font-size:13px}
.dot{width:8px;height:8px;border-radius:50%;background:var(--idle);flex:none}.task.ok .dot{background:var(--ok)}.task.fail .dot{background:var(--fail)}.task.plain .dot{background:transparent;border:1px solid var(--idle)}.title{flex:1}.meta{font-size:11px;color:var(--idle);white-space:nowrap}
button{background:var(--vscode-button-secondaryBackground);color:var(--vscode-button-secondaryForeground);border:0;border-radius:4px;padding:2px 8px;cursor:pointer;font-size:11px}button:hover{background:var(--vscode-button-background);color:var(--vscode-button-foreground)}.top{display:flex;gap:8px;align-items:center;margin-bottom:16px}.top .sp{flex:1}</style></head><body>
<div class="top"><div><h1>NSCM 전환 작업 흐름</h1><p class="sub">Vibe_Manager v1.0 · 루트 <code>${esc(p.root)}</code> · 단계 정의 <code>${esc(stepsFile())}</code></p></div><div class="sp"></div><button id="quick">⚡ 프로그램 ID 로 작업</button><button id="refresh">↻ 다시 판정</button></div>
<div class="spine"><b>공통 Fact 스키마(척추)</b> — As-is 파서(1)와 To-Be 파서(2)가 같은 CSV 스키마로 출력하고, 문서(3)·GAP(4)·하네스(5)·룰 보완(6)이 모두 이 스키마와 rules/*.csv 만 읽는다. 단계마다 완료 기준은 건수·0건으로 기계 판정.</div>
${stepHtml}
<script>const vscode=acquireVsCodeApi();document.querySelectorAll('button[data-id]').forEach(b=>b.addEventListener('click',()=>vscode.postMessage({type:'run',id:b.dataset.id})));document.getElementById('refresh').addEventListener('click',()=>vscode.postMessage({type:'refresh'}));document.getElementById('quick').addEventListener('click',()=>vscode.postMessage({type:'quick'}));</script></body></html>`;
}

// ───────────────────────── 기타 명령 · 활성화 ─────────────────────────
async function editSteps() { const p = paths(); if (!p.root) return; const target = path.join(p.vibeDir, 'steps.json'); if (!fs.existsSync(target)) { fs.mkdirSync(p.vibeDir, { recursive: true }); fs.copyFileSync(path.join(p.extDir, 'steps.json'), target); vscode.window.showInformationMessage('기본 steps.json 을 .vibe/steps.json 으로 복사했습니다. 이 파일이 있으면 내장본 대신 사용됩니다.'); } await vscode.window.showTextDocument(await vscode.workspace.openTextDocument(vscode.Uri.file(target))); }
async function openTaskLog() { const f = path.join(paths().vibeDir, 'runs.log'); if (!fs.existsSync(f)) { vscode.window.showInformationMessage('실행 기록이 아직 없습니다.'); return; } await openPath(f); }
function log(msg) { if (out) out.appendLine(`[${new Date().toLocaleTimeString()}] ${msg}`);
  // 2026-11-19 자가진단 Q1: 실패·오류 문구는 파일(.vibe/orch/vm_errors.jsonl)에도 남긴다. 종전에는 Output 채널에만 남았다
  if (/실패|오류|error|fail|cannot|없음\b/i.test(String(msg))) { try { require('./orch-errlog').note('extension', 'log', String(msg)); } catch { } } }

function activate(context) {
  ctx = context; out = vscode.window.createOutputChannel('Vibe_Manager');
  // 1.7.5: 최신 Claude CLI 를 확정해 확장 호스트 env 에 심는다 → 워크벤치 spawn 자식(하네스 node·agent)도 상속
  try { const p0 = paths(); process.env.CLAUDE_BIN = p0.claude; process.env.ASISFACTS_CLAUDE = p0.claude; } catch (e) { log(`Claude CLI 확인 실패: ${e.message}`); }
  tree = new StepsProvider(); harnessTree = new HarnessProvider(); envTree = new EnvProvider(); dodTree = new DodProvider(); menuTree = new MenuProvider();
  // 1.7.3: 카테고리 제공자가 갱신되면 사이드바 전체 메뉴도 갱신
  for (const t of [tree, harnessTree, envTree, dodTree]) { const r = t.refresh.bind(t); t.refresh = () => { r(); if (menuTree) menuTree.refresh(); }; }
  const wbApi = () => ({
    ctx: context, paths, loadSteps, findTask, collectInputs, subst, buildArgs, openPath, pageDirOf: pageDirOfId,
    menuSections, claudeEnv,
    runTaskById: (tid, preset) => runTask(findTask(tid), preset),
    record: (k, note) => recordRun(typeof k === 'string' && findTask(k) ? k : 'workbench', { event: 'start', time: Date.now(), exitCode: null, note: `${k}: ${note}` }),
    afterTask: (tid, code) => { recordRun(tid, { event: 'end', endTime: Date.now(), exitCode: code }); tree.refresh(); refreshDashboard(); updateStatusBar(); }
  });
  statusBar = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 50); statusBar.command = 'vibeManager.openWorkbench';
  const pageDirOf = id => { try { const r = JSON.parse(fs.readFileSync(path.join(paths().genDir, id, 'register.json'), 'utf8')); return path.join(paths().tobeDir, 'features', r.feature, 'src', 'pages', r.pageDir); } catch { return ''; } };
  // 1.6: 사이드바 PromptViewProvider 제거 — 활성화 시 워크벤치가 바로 열린다.
  context.subscriptions.push(out, statusBar,
    vscode.commands.registerCommand('vibeManager.startBE', () => { const q = promptPanel.loadQuick(paths().extDir, paths().root); const it = q.groups.flatMap(g => g.items).find(x => /(^|\s)(BE 기동|Start BE|BE Start)$/.test(x.label)); if (it) promptPanel.startServer(paths(), it); }),
    vscode.commands.registerCommand('vibeManager.startFE', () => { const q = promptPanel.loadQuick(paths().extDir, paths().root); const it = q.groups.flatMap(g => g.items).find(x => /(^|\s)(FE 기동|Start FE|FE Start)$/.test(x.label)); if (it) promptPanel.startServer(paths(), it); }),
    vscode.commands.registerCommand('vibeManager.claudeNew', () => promptPanel.ensureClaude(paths(), { fresh: true })),
    vscode.commands.registerCommand('vibeManager.refreshPrompt', () => vscode.commands.executeCommand('vibeManager.openWorkbench')),
    // 1.7.3: 사이드바 = 워크벤치와 동일한 전체 메뉴 1개 (구 4개 뷰 내용은 카테고리로 포함)
    // 2.0.0: 사이드바 = 모바일 홈 화면형 웹뷰(menu-view.js · 항목 원천은 menuTree 그대로). 구 트리는 설정 vibeManager.menuStyle='tree' 일 때 vibeManager.menuTree 로 보인다
    vscode.window.registerWebviewViewProvider('vibeManager.menu', new menuView.MenuViewProvider({ menuTree, paths, english: fn => { menuEn = true; try { return fn(); } finally { menuEn = false; } } }), { webviewOptions: { retainContextWhenHidden: true } }),
    vscode.window.registerTreeDataProvider('vibeManager.menuTree', menuTree),
    vscode.commands.registerCommand('vibeManager.runQuick', async item => { if (!item) return; await vscode.commands.executeCommand('vibeManager.openWorkbench'); await workbench.quick(item, workbench.currentId() || ctx.workspaceState.get('vibeManager.lastId', ''), false); }),
    // 2026-10-28 상단 아이콘(사용자 지정): quick.json 메뉴를 label 접두로 찾아 runQuick 으로 실행 — view/title 메뉴는 인자를 못 넘겨 아이콘마다 명령 1개
    ...[['vibeManager.qRestart', '🔄 BE & FE Finish & Start'], ['vibeManager.qSourceSync', '⬇️🔀 Source Download & Merge'], ['vibeManager.qFullChain', '🚀 ID 하나로 전체'], ['vibeManager.qCheckList', '🔎 CheckList']]
      .map(([cmd, pre]) => vscode.commands.registerCommand(cmd, () => {
        const it = promptPanel.loadQuick(paths().extDir, paths().root).groups.flatMap(g => g.items || []).find(x => String(x.label || '').startsWith(pre));
        if (!it) { vscode.window.showWarningMessage(`Vibe_Manager: quick.json 에 '${pre}' 메뉴가 없습니다`); return; }
        return vscode.commands.executeCommand('vibeManager.runQuick', it);
      })),
    vscode.commands.registerCommand('vibeManager.refresh', () => { tree.refresh(); refreshDashboard(); }),
    vscode.commands.registerCommand('vibeManager.runTask', (node, preset) => runTask(typeof node === 'string' ? findTask(node) : (node && node.task ? node.task : null), preset)),
    vscode.commands.registerCommand('vibeManager.quickScreen', quickScreen),
    vscode.commands.registerCommand('vibeManager.openDashboard', openDashboard),
    vscode.commands.registerCommand('vibeManager.openWorkbench', () => { workbench.open(wbApi()); }),
    vscode.commands.registerCommand('vibeManager.openWorkbenchNew', () => { workbench.open(wbApi(), { fresh: true }); }),
    // 2026-11-19 VMO P2: VMO 창(기능 · BE/FE Log · 상황판). tab = board | belog | felog | task
    // 2026-11-19 VMO P8: 업무 작업창(업무 1개 × 화면 여러 개 일괄 실행). 여러 개 열 수 있다
    vscode.commands.registerCommand('vibeManager.openJobs', () => { try { require('./jobs').open(wbApi()); } catch (e) { vscode.window.showErrorMessage(`Vibe_Manager 업무 작업창을 열 수 없음: ${e.message}`); } }),
    vscode.commands.registerCommand('vibeManager.openOrchestra', tab => { workbench.openOrchestra(wbApi(), { tab: typeof tab === 'string' ? tab : '' }); }),
    vscode.commands.registerCommand('vibeManager.openFlow', async () => { await vscode.commands.executeCommand('vibeManager.openWorkbench'); if (workbench.openFlowTab()) return; return flowPanel.open({ paths, runTaskById: (tid, preset) => runTask(findTask(tid), preset), openPath }); }),
    vscode.commands.registerCommand('vibeManager.openTaskHistory', async () => { await vscode.commands.executeCommand('vibeManager.openWorkbench'); workbench.showTab('thist'); }),
    vscode.commands.registerCommand('vibeManager.openHistory', async () => { await vscode.commands.executeCommand('vibeManager.openWorkbench'); if (workbench.showTab('hist')) return; return history.open({ paths, openPath }); }),
    vscode.commands.registerCommand('vibeManager.gateReport', gateReport),
    vscode.commands.registerCommand('vibeManager.openOutputFolder', () => openPath(paths().outDir)),
    vscode.commands.registerCommand('vibeManager.editSteps', editSteps),
    vscode.commands.registerCommand('vibeManager.openTaskLog', openTaskLog),
    vscode.commands.registerCommand('vibeManager.openSettings', () => vscode.commands.executeCommand('workbench.action.openSettings', 'vibeManager')),
    vscode.commands.registerCommand('vibeManager.toggleHook', toggleHook),
    vscode.commands.registerCommand('vibeManager.openItem', async node => { if (!node || !node.target) return; let t = node.target;
      if (node.relTo === 'page' && !path.isAbsolute(t)) { try { const r = JSON.parse(fs.readFileSync(path.join(paths().genDir, node.id, 'register.json'), 'utf8')); t = path.join(paths().tobeDir, 'features', r.feature, 'src', 'pages', r.pageDir, t); } catch { } }
      if (node.line && fs.existsSync(t)) { // 1.9.0: 파일:라인 도 Workbench 탭(해당 줄 강조) — Workbench 가 없을 때만 에디터
        try { await vscode.commands.executeCommand('vibeManager.openWorkbench'); if (workbench.openTab(t, { line: node.line })) return; } catch { }
        const doc = await vscode.workspace.openTextDocument(vscode.Uri.file(t)); const ed = await vscode.window.showTextDocument(doc, { preview: false }); const pos = new vscode.Position(Math.max(0, node.line - 1), 0); ed.selection = new vscode.Selection(pos, pos); ed.revealRange(new vscode.Range(pos, pos), vscode.TextEditorRevealType.InCenter); return; }
      openPath(t); }),
    vscode.commands.registerCommand('vibeManager.checkEnv', checkEnv),
    vscode.tasks.onDidEndTaskProcess(onTaskEnd),
    vscode.workspace.onDidChangeConfiguration(e => { if (e.affectsConfiguration('vibeManager')) { if (e.affectsConfiguration('vibeManager.claudeCommand')) { const p1 = paths(); process.env.CLAUDE_BIN = p1.claude; process.env.ASISFACTS_CLAUDE = p1.claude; }
      if (e.affectsConfiguration('vibeManager.language')) { const ko = paths().language === 'ko'; vscode.window.showInformationMessage(ko ? 'Vibe_Manager 언어: 한국어 — 사이드바 메뉴는 즉시, Workbench 는 새 창부터 적용됩니다.' : 'Vibe_Manager language: English — sidebar menu updates now; Workbench applies to newly opened windows.'); }
      tree.refresh(); refreshDashboard(); } }));
  // 1.8.3: 새 VSIX 가 설치됐는데 아직 이전 버전이 실행 중이면(Reload 전) 메뉴(quick.json 실시간)와 코드가 어긋난다 → 활성화 시 안내
  try {
    const mine = String((context.extension && context.extension.packageJSON && context.extension.packageJSON.version) || '');
    const extRoot = path.dirname(context.extensionPath); const vers = fs.readdirSync(extRoot).filter(d => /^marisoft\.vibe-manager-\d/.test(d)).map(d => d.replace(/^marisoft\.vibe-manager-/, ''));
    const newest = vers.sort((a, b) => cmpVer(a, b)).pop();
    if (mine && newest && cmpVer(newest, mine) > 0) vscode.window.showWarningMessage(`Vibe_Manager ${newest} 이 설치되어 있지만 지금은 ${mine} 이 실행 중입니다 — 메뉴와 기능이 어긋날 수 있으니 창을 새로고침하세요.`, 'Reload Window').then(a => { if (a) vscode.commands.executeCommand('workbench.action.reloadWindow'); });
  } catch { }
  const p = paths();
  // 2026-11-19 자가진단 Q1: 오류 기록 시작 · 활성화 시각 기록(.vibe/orch/activations.jsonl — CHANGELOG 의 '창 다시 로드 필요' 항목이 로드됐는지 판정하는 근거)
  //   처리되지 않은 Promise 거부는 스택에 이 확장 경로가 있을 때만 기록한다(다른 확장의 오류 제외)
  try {
    if (p.root) {
      const errlog = require('./orch-errlog'); errlog.init(p.vibeDir);
      const ver = String((context.extension && context.extension.packageJSON && context.extension.packageJSON.version) || '');
      fs.appendFileSync(path.join(p.vibeDir, 'orch', 'activations.jsonl'), JSON.stringify({ at: require('./orch-events').nowLocal(), ms: Date.now(), pid: process.pid, version: ver, extDir: context.extensionPath }) + '\n', 'utf8');
      const mine = e => { const st = String((e && e.stack) || ''); return st.includes(context.extensionPath) || /vibe-?manager/i.test(st); };
      const onRej = e => { if (mine(e)) errlog.note('extension', 'unhandledRejection', e); };
      const onExc = e => { if (mine(e)) errlog.note('extension', 'uncaughtException', e); };
      process.on('unhandledRejection', onRej); process.on('uncaughtExceptionMonitor', onExc);
      context.subscriptions.push({ dispose: () => { process.removeListener('unhandledRejection', onRej); process.removeListener('uncaughtExceptionMonitor', onExc); } });
    }
  } catch (e) { log(`오류 기록 시작 실패: ${e.message}`); }
  if (p.root) for (const glob of ['**/_gate.csv', '**/_index.csv', '**/crosscheck_report.csv', '**/grid_runs.csv', '**/_summary.csv', '**/GEN_NOTES.md', '**/rules/*.csv', '**/.claude/settings.json']) { const w = vscode.workspace.createFileSystemWatcher(new vscode.RelativePattern(vscode.Uri.file(p.root), glob)); const h = () => { tree.refresh(); refreshDashboard(); }; w.onDidChange(h); w.onDidCreate(h); w.onDidDelete(h); context.subscriptions.push(w); }
  updateStatusBar(); log(`활성화. 루트=${p.root || '(없음)'} 단계정의=${stepsFile()}`);
  // 1.6: 활성화 시 워크벤치를 첫 화면으로 자동 기동 (사이드바 뷰가 사라졌으므로 즉시 접근 보장).
  // 사용자가 설정으로 끄려면 vibeManager.autoOpenWorkbench=false 로 지정하면 skip.
  try {
    const auto = cfg().get('autoOpenWorkbench');
    if (auto !== false) setTimeout(() => { vscode.commands.executeCommand('vibeManager.openWorkbench'); }, 300);
  } catch { }
  // 2026-11-19 VMO P2: 서버 서비스(상태 표시줄 BE·FE 상시 표시 · 서버 소유)와 실행 상태 모음을 창과 무관하게 시작한다.
  //   VMO 창은 Workbench 뒤에 배경 탭으로 연다(설정 vibeManager.orch.autoOpen=false 로 끔). 실패해도 Workbench 는 그대로 동작한다
  try {
    if (p.root) {
      require('./server-service').init(p, context);
      require('./orch-state').init(p);
      // P3 감시기: 오류·지연·반복을 사건으로 만든다(Claude 호출 없음). 새 사건 알림은 60초에 1회까지 — 나머지는 VMO 창 사건 탭 표시만
      const watch = require('./orch-watch'); watch.init(p, { serverSvc: require('./server-service') });
      let lastNote = 0;
      watch.on((inc, isNew) => {
        if (!isNew || Date.now() - lastNote < 60000) return; lastNote = Date.now();
        Promise.resolve(vscode.window.showWarningMessage(`Vibe_Manager 사건 ${inc.rule} ${inc.ruleName}${inc.screen ? ` · ${inc.screen}` : ''} — ${String(inc.title).slice(0, 160)}`, '사건 보기')).then(a => { if (a) vscode.commands.executeCommand('vibeManager.openOrchestra', 'inc'); }, () => { });
      });
      // P4 에이전트: 새 사건을 받아 조치(코드 조치 → Claude 조치). 파일을 고쳤거나 사용자 확인이 필요하면 알림
      require('./orch-agent').init({
        paths, serverSvc: require('./server-service'),
        loadQuick: () => promptPanel.loadQuick(paths().extDir, paths().root).groups.flatMap(g => g.items || []),
        notify: (inc, what) => { Promise.resolve(vscode.window.showInformationMessage(`Vibe_Manager VMO — ${inc.rule}${inc.screen ? ` ${inc.screen}` : ''}: ${String(what).slice(0, 200)}`, '사건 보기')).then(a => { if (a) vscode.commands.executeCommand('vibeManager.openOrchestra', 'inc'); }, () => { }); },
      });
      // P8·P9 업무 작업 실행기. 서버 이상(R6)·TCP 연결 수(R8) 사건이 생기면 실행 중 작업을 일시 중지하고 사건이 해결되면 다시 진행한다
      try { const jr = require('./job-runner'); jr.init(wbApi()); jr.attachWatch(watch); } catch (e) { log(`업무 작업 실행기 시작 실패: ${e.message}`); }
      // P5 상시 개선안: 체인이 끝났을 때와 1시간마다 확인해 마지막 분석에서 reviewEveryHours 지났으면 분석 1회. 반영은 사용자 승인 뒤에만
      require('./orch-improve').init({ notify: text => { Promise.resolve(vscode.window.showInformationMessage(`Vibe_Manager VMO — ${String(text).slice(0, 200)}`, '개선안 보기')).then(a => { if (a) vscode.commands.executeCommand('vibeManager.openOrchestra', 'prop'); }, () => { }); } });
      // 2026-11-19 자가진단 Q2~Q6: 작업 이력 취합과 VM 자가진단. 수집 · 점검은 코드만 쓰고 Claude 는 진단과 주제별 정리에서만 부른다
      try {
        require('./orch-history').init({ paths });
        require('./orch-selfcheck').init({ paths, notify: text => { Promise.resolve(vscode.window.showInformationMessage(`Vibe_Manager VMO 자가진단 — ${String(text).slice(0, 200)}`, '자가진단 보기')).then(a => { if (a) vscode.commands.executeCommand('vibeManager.openOrchestra', 'self'); }, () => { }); } });
      } catch (e) { log(`자가진단 시작 실패: ${e.message}`); }
      if (cfg().get('orch.autoOpen') !== false) setTimeout(() => { try { workbench.openOrchestra(wbApi(), { background: true }); } catch (e) { log(`VMO 창 열기 실패: ${e.message}`); } }, 1500);
    }
  } catch (e) { log(`VMO 시작 실패: ${e.message}`); }
}
function deactivate() {
  // 서버는 기본으로 남긴다(다시 로드하면 server-service 가 .vibe/orch/servers.json 으로 다시 붙는다). 설정 vibeManager.orch.stopServersOnExit=true 면 종료
  try { require('./server-service').dispose(cfg().get('orch.stopServersOnExit') === true); } catch { }
  try { require('./job-runner').dispose(); } catch { } // 실행 중이던 업무 작업은 '중단됨'으로 남긴다(다시 열어 이어서 실행)
  try { require('./orch-selfcheck').dispose(); } catch { }
  try { require('./orch-improve').dispose(); } catch { }
  try { require('./orch-agent').dispose(); } catch { }
  try { require('./orch-watch').dispose(); } catch { }
  try { require('./orch-state').dispose(); } catch { }
}
module.exports = { activate, deactivate };
