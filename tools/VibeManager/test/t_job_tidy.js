// 업무 작업 기록 정리(job-runner.tidyRecent, 2026-11-20 S13 U9): 켜질 때 끝난 작업(중단, 중지)의 '실행 중' 화면을 맞춤 · 실행 중 작업은 건드리지 않음
//   사용: node test/t_job_tidy.js <VibeManager 폴더>
const fs = require('fs'), path = require('path'), os = require('os'); const Module = require('module');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const o = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? new Proxy({}, { get: () => function () { } }) : o.call(this, r, ...a); };
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'tidy-'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const mk = (id, st, sc) => { const d = path.join(root, '.vibe', 'jobs', id); fs.mkdirSync(d, { recursive: true }); fs.writeFileSync(path.join(d, 'job.json'), JSON.stringify({ id, status: st, screens: sc })); };
mk('J20261120_000001', 'interrupted', [{ id: 'A', status: 'run', step: '[1] x' }, { id: 'B', status: 'done' }]); mk('J20261120_000002', 'stopped', [{ id: 'C', status: 'run' }]); mk('J20261120_000003', 'running', [{ id: 'D', status: 'run' }]);
const jr = require(path.join(dir, 'job-runner')); jr.init({ paths: () => ({ root, vibeDir: path.join(root, '.vibe'), extDir: dir }) });
const r = id => JSON.parse(fs.readFileSync(path.join(root, '.vibe', 'jobs', id, 'job.json'), 'utf8'));
setTimeout(() => {
  chk('중단 작업의 실행 중 화면 = 대기(다시 실행 대상), 끝난 화면은 그대로', r('J20261120_000001').screens.map(s => s.id + ':' + s.status).join(',') === 'A:wait,B:done' && r('J20261120_000001').screens[0].step === '');
  chk('중지 작업의 실행 중 화면 = 취소', r('J20261120_000002').screens[0].status === 'cancel');
  chk('실행 중으로 적힌 작업 = 건드리지 않음(다른 창이 돌리는 중일 수 있음)', r('J20261120_000003').status === 'running' && r('J20261120_000003').screens[0].status === 'run');
  jr.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
}, 3500);
