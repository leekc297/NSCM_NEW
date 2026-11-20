// 중단된 작업 자동 삭제(2026-11-20 사용자 지시 '중단된 프로세스는 특정시간(DEFAULT:24시간)이 지나면 자동삭제')
//   · VMW 작업: 상태 interrupted + 중단 시각(interruptedAt, 없으면 job.json 수정 시각)에서 설정 시간이 지나면 remove(작업 폴더 + 재개 기록)
//   · 끝난 작업·실행 중 작업·설정 시간 안의 중단 작업은 그대로 · 0 = 자동 삭제 안 함
//   · Workbench 재개 기록(chain_progress): 끊긴 기록이 설정 시간을 넘으면 파일 삭제
//   사용: node test/t_job_autodel.js <VibeManager 폴더>
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
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'jdel-')); const vibeDir = path.join(root, '.vibe');
const p = { root, vibeDir, extDir: dir, language: 'ko' };
const api = { ctx: { workspaceState: { get: () => undefined, update: () => { } }, extensionPath: dir }, paths: () => p, loadSteps: () => ({}), findTask: () => null };
const jr = require(path.join(dir, 'job-runner')); const wb = require(path.join(dir, 'workbench')); const ev = require(path.join(dir, 'orch-events'));
jr.init(api);
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const H = 3600000; const now = Date.now();
const mkJob = (id, status, interruptedAt, mtimeAgoH) => {
  const d = path.join(vibeDir, 'jobs', id); fs.mkdirSync(d, { recursive: true });
  const j = { id, itemLabel: '시험', status, createdAt: ev.nowLocal(now - 40 * H), screens: [{ id: 'SCP0028', status: status === 'done' ? 'ok' : 'wait' }] };
  if (interruptedAt != null) j.interruptedAt = ev.nowLocal(interruptedAt);
  const f = path.join(d, 'job.json'); fs.writeFileSync(f, JSON.stringify(j)); fs.writeFileSync(path.join(d, 'SCP0028.log'), 'log');
  if (mtimeAgoH != null) { const t = (now - mtimeAgoH * H) / 1000; fs.utimesSync(f, t, t); }
};
const progF = n => path.join(vibeDir, 'orch', 'chain_progress', n);
const mkProg = (runId, rec) => { fs.mkdirSync(path.dirname(progF('x')), { recursive: true }); fs.writeFileSync(progF(`${runId}.json`), JSON.stringify(Object.assign({ runId, screen: 'SCP0028', label: '시험', steps: 3, cur: 1, interruptedAt: ev.nowLocal(rec.updatedMs) }, rec))); };
const has = id => fs.existsSync(path.join(vibeDir, 'jobs', id));
(async () => {
  mkJob('J20261101_000000', 'interrupted', now - 25 * H);          // 25시간 전 중단 → 삭제
  mkProg('SCP0028_A', { job: 'J20261101_000000', updatedMs: now - 25 * H });
  mkJob('J20261101_000001', 'interrupted', now - 2 * H);           // 2시간 전 → 남김
  mkJob('J20261101_000002', 'interrupted', null, 30);              // 중단 시각 없음 · 수정 30시간 전 → 삭제
  mkJob('J20261101_000003', 'done', null, 30);                     // 끝난 작업 → 남김
  mkJob('J20261101_000004', 'interrupted', null, 0);               // 중단 시각 없음 · 방금 → 중단 시각 기록 후 남김
  mkProg('SCP0028_W1', { updatedMs: now - 25 * H });               // Workbench 끊긴 기록 25시간 → 삭제
  mkProg('SCP0028_W2', { updatedMs: now - 2 * H });                // 2시간 → 남김
  chk('기본 보관 시간 = 24', jr.keepHours() === 24, jr.keepHours());
  let r = await jr.sweepInterrupted(0);
  chk('0 = 자동 삭제 안 함', r.length === 0 && has('J20261101_000000') && has('J20261101_000002'));
  r = await jr.sweepInterrupted();
  const ids = r.map(x => x.id).sort();
  chk('24시간 지난 중단 작업 삭제(2건)', ids.join(',') === 'J20261101_000000,J20261101_000002', ids.join(','));
  chk('작업 폴더 삭제', !has('J20261101_000000') && !has('J20261101_000002'));
  chk('그 작업 재개 기록도 삭제', !fs.existsSync(progF('SCP0028_A.json')));
  chk('24시간 안의 중단 작업 남김', has('J20261101_000001'));
  chk('끝난 작업 남김', has('J20261101_000003'));
  const j4 = JSON.parse(fs.readFileSync(path.join(vibeDir, 'jobs', 'J20261101_000004', 'job.json'), 'utf8'));
  chk('중단 시각 없는 작업 = 수정 시각을 중단 시각으로 기록 후 남김', has('J20261101_000004') && !!j4.interruptedAt, j4.interruptedAt);
  chk('목록에서도 빠짐', !jr.list(30).some(x => x.id === 'J20261101_000000'));
  const rs = wb.resumable(p);
  chk('Workbench 끊긴 기록 24시간 지남 = 파일 삭제', !fs.existsSync(progF('SCP0028_W1.json')) && !rs.some(x => x.runId === 'SCP0028_W1'));
  chk('Workbench 끊긴 기록 2시간 = 남김 · 재개 목록에 있음', fs.existsSync(progF('SCP0028_W2.json')) && rs.some(x => x.runId === 'SCP0028_W2'));
  try { jr.dispose(); } catch { }
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
