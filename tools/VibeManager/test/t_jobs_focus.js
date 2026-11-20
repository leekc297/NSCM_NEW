// VMW 창이 재개·시작된 작업을 보이게(2026-11-20 사용자 지적 '다시 로드 후 작업 재개 시 WORKBENCH 에서는 재개 되는데 VMW 에 재개된 작업이 보이지 않습니다')
//   · 창을 열 때: 실행 중 작업 → 없으면 재개 가능 중단 작업
//   · job-runner 'start' 알림: 목록 갱신 · 보던 작업이 실행 중이 아니면 시작된 작업으로 바꿈
//   · open(api, 작업 ID): 열린 VMW 창이 있으면 새 창 없이 그 창을 그 작업으로
//   사용: node test/t_jobs_focus.js <VibeManager 폴더>
const Module = require('module'); const path = require('path');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let created = 0; const panelsMade = [];
const mkPanel = () => { const pn = { posts: [], revealed: 0, recv: null, disp: null, webview: { html: '', asWebviewUri: u => u, cspSource: '', postMessage: m => { pn.posts.push(m); return Promise.resolve(true); }, onDidReceiveMessage: fn => { pn.recv = fn; return { dispose() { } }; } }, reveal: () => { pn.revealed++; }, onDidDispose: fn => { pn.disp = fn; return { dispose() { } }; } }; return pn; };
const vs = new Proxy({}, { get: (t, k) => {
  if (k === 'window') return new Proxy({}, { get: (t2, k2) => k2 === 'createWebviewPanel' ? () => { created++; const pn = mkPanel(); panelsMade.push(pn); return pn; } : () => Promise.resolve(undefined) });
  if (k === 'commands') return { executeCommand: () => Promise.resolve() };
  if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] };
  if (k === 'ViewColumn') return { Active: 1, Beside: 2 };
  if (k === 'Uri') return { file: f => ({ fsPath: f }), parse: s => s };
  return function () { };
} });
// 가짜 job-runner: 작업 목록과 알림만
const JOBS = { J3: { id: 'J3', status: 'idle' }, J2: { id: 'J2', status: 'running' }, J1: { id: 'J1', status: 'interrupted', resumable: true } };
const listeners = new Set();
const fakeJr = { init() { }, list: () => ['J3', 'J2', 'J1'].map(id => ({ id, status: JOBS[id].status })), get: id => (JOBS[id] ? Object.assign({ screens: [] }, JOBS[id]) : null),
  on: fn => { listeners.add(fn); return () => listeners.delete(fn); }, batchItems: () => [], loadCfg: () => ({}), start: () => true };
const emit = (id, kind, data) => { for (const fn of listeners) fn(id, kind, data); };
const orig = Module._load; Module._load = function (r, parent, ...a) { if (r === 'vscode') return vs; if (/job-runner$/.test(r) && parent && /jobs\.js$/.test(parent.filename || '')) return fakeJr; return orig.call(this, r, parent, ...a); };
const J = require(path.join(dir, 'jobs'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const api = { paths: () => ({ root: 'C:/x', vibeDir: 'C:/x/.vibe', extDir: dir, language: 'ko' }), ctx: { workspaceState: { get: () => '', update: () => { } }, extensionPath: dir } };
const lastJob = pn => { const m = pn.posts.filter(x => x.type === 'job').pop(); return m && m.job ? m.job.id : null; };
(async () => {
  J.open(api); const A = panelsMade[0];
  try { await A.recv({ type: 'ready' }); } catch (e) { /* init 의 화면 목록 등은 가짜 경로라 실패해도 됨 */ }
  chk('열 때 실행 중 작업(J2)을 고름', lastJob(A) === 'J2', lastJob(A));
  A.posts.length = 0; JOBS.J3.status = 'running'; emit('J3', 'start', { id: 'J3' });
  chk('start 알림 = 목록 갱신', A.posts.some(m => m.type === 'jobs'));
  chk('보던 작업이 실행 중이면 그대로(J2)', !A.posts.some(m => m.type === 'job'));
  JOBS.J2.status = 'interrupted'; A.posts.length = 0; emit('J3', 'start', { id: 'J3' });
  chk('보던 작업이 실행 중이 아니면 시작된 작업(J3)으로', lastJob(A) === 'J3', lastJob(A));
  A.posts.length = 0; emit('J3', 'log', { screen: 'SCP0028', text: 'x' });
  chk('바꾼 뒤 그 작업 로그를 받음', A.posts.some(m => m.type === 'log'));
  const n0 = created; J.open(api, 'J1');
  chk('작업 ID 로 열기 = 열린 창 재사용(새 창 없음)', created === n0 && A.revealed === 1 && lastJob(A) === 'J1', `created ${created - n0} revealed ${A.revealed}`);
  A.disp && A.disp();
  JOBS.J2.status = 'interrupted'; JOBS.J3.status = 'idle'; J.open(api, 'J3'); const B = panelsMade[panelsMade.length - 1];
  try { await B.recv({ type: 'ready' }); } catch (e) { }
  chk('열린 창이 없으면 새 창 + 그 작업 표시', created === n0 + 1 && lastJob(B) === 'J3', lastJob(B));
  B.disp && B.disp(); JOBS.J3.status = 'done'; J.open(api); const C = panelsMade[panelsMade.length - 1];
  try { await C.recv({ type: 'ready' }); } catch (e) { }
  chk('실행 중 작업 없으면 재개 가능 중단 작업(J1)', lastJob(C) === 'J1', lastJob(C));
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
