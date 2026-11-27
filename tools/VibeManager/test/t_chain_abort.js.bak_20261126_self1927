// 개선안 20261120005942_INC: VM 창이 끝날 때(extension.deactivate) job 없이 띄운 Workbench 체인에 끝 기록(chain.end ok=false, aborted, why 'VM 창 종료로 중단')을 남기는지
//   사용: node test/t_chain_abort.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const vs = new Proxy({}, { get: (t, k) => {
  if (k === 'window') return new Proxy({}, { get: () => () => Promise.resolve(undefined) });
  if (k === 'commands') return { executeCommand: () => Promise.resolve(), registerCommand: () => ({ dispose() { } }) };
  if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] };
  if (k === 'Uri') return { file: f => ({ fsPath: f }), parse: s => s };
  return function () { };
} });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'chabort-')); const vibeDir = path.join(root, '.vibe'); fs.mkdirSync(vibeDir, { recursive: true });
const p = { root, vibeDir };
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const orchEv = require(path.join(dir, 'orch-events')); orchEv.init(vibeDir);
const state = require(path.join(dir, 'orch-state'));
const wbm = require(path.join(dir, 'workbench'));
const readEv = () => { try { return fs.readFileSync(orchEv.file(), 'utf8').split(/\r?\n/).filter(Boolean).map(l => JSON.parse(l)); } catch { return []; } };

// 가짜 체인: job 없이 Workbench 창 3에서 띄운 CheckList 체인
const t0 = Date.now() - 60000; const runId = `TST0001_${t0}`;
const evCh = { wb: 3, screen: 'TST0001', chain: 'checklist', chainLabel: '🔎 CheckList', runId, job: '' };
state.apply(orchEv.emit('chain.start', Object.assign({ steps: 3, shown: 3 }, evCh)));
wbm._liveChains.set(runId, { p, evCh, t0 });
chk('시작 전 상태에 체인 1건', state.snapshot().chains.some(c => c.runId === runId || c.screen === 'TST0001'));

const ext = require(path.join(dir, 'extension'));
ext.deactivate();
const ev = readEv(); for (const e of ev) if (e.type !== 'chain.start') state.apply(e);
const ends = ev.filter(e => e.type === 'chain.end' && e.runId === runId);
chk('chain.end aborted 1건', ends.length === 1 && ends[0].aborted === true && ends[0].ok === false, JSON.stringify(ends.map(e => ({ ok: e.ok, aborted: e.aborted, why: e.why }))));
chk('why = VM 창 종료로 중단', ends[0] && ends[0].why === 'VM 창 종료로 중단', ends[0] && ends[0].why);
chk('chain.end 앞에 user.stop(같은 wb)', ev.some(e => e.type === 'user.stop' && e.wb === 3 && e.why === 'vscode.dispose' && ev.indexOf(e) < ev.indexOf(ends[0])));
chk('실행 중 체인 목록 비움', wbm._liveChains.size === 0, String(wbm._liveChains.size));
chk('상태에서 체인 빠짐(R5 gone 대상 0건)', !state.snapshot().chains.some(c => c.screen === 'TST0001') && !state.sweep().some(g => g.what === 'chain' && g.screen === 'TST0001'));
// 두 번 불러도 끝 기록은 1건
wbm.abortRunningChains('VM 창 종료로 중단');
chk('다시 불러도 chain.end 1건', readEv().filter(e => e.type === 'chain.end' && e.runId === runId).length === 1);
try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
