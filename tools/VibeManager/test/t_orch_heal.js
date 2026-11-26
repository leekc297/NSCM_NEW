// VMO 자가 복구(orch-heal.js · 2026-11-20): R13 화면 진입 실패 → 원인(공용 파일 없음) → 받기 → 변환 확인 → 그 화면 다시 실행 → 사건 해결
//   풀지 못하는 경우(다른 변환 오류 · 받기 실패 · 받은 뒤에도 오류)는 에이전트로 넘김 · 같은 작업에서 2번 넘게 다시 실행하지 않음
//   사용: node test/t_orch_heal.js <VibeManager 폴더>
const path = require('path'); const Module = require('module');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (req, ...rest) { return req === 'vscode' ? stub : orig.call(this, req, ...rest); };
const heal = require(path.join(dir, 'orch-heal'));
// 2026-11-20 재수행 설정(harness.json orch.rerunAfterFix · 기본 none = 보완까지만): 아래 기존 경우는 'rerun' 에서, 끝에 'none' 경우를 따로 본다
const fs = require('fs'); const os = require('os'); const root = fs.mkdtempSync(path.join(os.tmpdir(), 'heal-')); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.mkdirSync(path.join(root, '.vibe', 'orch'), { recursive: true });
const setRerun = v => fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { rerunAfterFix: v } }));
setRerun('rerun'); heal.init({ paths: () => ({ root, vibeDir: path.join(root, '.vibe') }), watch: { on() { } } });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const FE = { file: 'nscm-fe/features/shipping/src/pages/zz/components/ZzForm.tsx', msg: '[plugin:vite:import-analysis] Failed to resolve import "@shared/paste" from "ZzForm.tsx". Does the file exist?' };
function mk(o) {
  const log = { upd: [], enq: [], rq: [], sync: 0, fe: 0 };
  const deps = {
    watch: { update: (id, patch, act) => log.upd.push({ id, patch, act }), feCompileError: async () => null },
    jobRunner: { requeueScreen: (s, why) => { log.rq.push({ s, why }); return o.rq || { job: 'J1', how: 'stop-requeue' }; } },
    agent: { enqueue: id => log.enq.push(id) },
    runSync: async () => { log.sync++; return o.sync || { code: 0, out: '[OK]' }; },
    feCheck: async () => { log.fe++; return o.after || null; },
  };
  return { deps, log };
}
(async () => {
  chk('맡는 사건 = R13(알림 아님)만', heal.claims({ rule: 'R13' }) && !heal.claims({ rule: 'R13', notice: true }) && !heal.claims({ rule: 'R5' }));
  { const { deps, log } = mk({}); const r = await heal.handle({ id: 'I1', rule: 'R13', screen: 'ZZP0001', evidence: { fe: FE } }, deps);
    const last = log.upd[log.upd.length - 1];
    chk('공용 파일 없음: 받기 1회 · 변환 확인 1회 · 화면 다시 실행 · 사건 해결 · 에이전트 안 부름', r.healed && log.sync === 1 && log.fe === 1 && log.rq.length === 1 && log.rq[0].s === 'ZZP0001' && /@shared\/paste/.test(log.rq[0].why) && last.patch.status === 'resolved' && /다시 실행/.test(last.act.what) && log.enq.length === 0, JSON.stringify([r, last])); }
  { const { deps, log } = mk({}); const r = await heal.handle({ id: 'I2', rule: 'R13', screen: 'YYP0002', evidence: { fe: null } }, deps);
    chk('FE 변환 오류 없음: 받기 안 함 · 에이전트로 넘김', !r.healed && log.sync === 0 && log.enq[0] === 'I2' && log.rq.length === 0, JSON.stringify(r)); }
  { const { deps, log } = mk({}); const r = await heal.handle({ id: 'I3', rule: 'R13', screen: 'XXP0003', evidence: { fe: { file: 'a.tsx', msg: 'Unexpected token (12:4)' } } }, deps);
    chk('다른 변환 오류(문법): 에이전트로 넘김', !r.healed && log.sync === 0 && log.enq[0] === 'I3', JSON.stringify(r)); }
  { const { deps, log } = mk({ sync: { code: 6, out: '[ERROR] @shared/paste — 공통 저장소에도 없음' } }); const r = await heal.handle({ id: 'I4', rule: 'R13', screen: 'WWP0004', evidence: { fe: FE } }, deps);
    chk('받기 실패: 다시 실행 안 함 · 에이전트로 넘김 · 사유에 오류 줄', !r.healed && log.rq.length === 0 && log.enq[0] === 'I4' && /공통 저장소에도 없음/.test(r.why), r.why); }
  { const { deps, log } = mk({ after: { file: 'b.tsx', msg: 'Failed to resolve import "@shared/other"' } }); const r = await heal.handle({ id: 'I5', rule: 'R13', screen: 'VVP0005', evidence: { fe: FE } }, deps);
    chk('받은 뒤에도 변환 오류: 다시 실행 안 함 · 에이전트로 넘김', !r.healed && log.rq.length === 0 && log.enq[0] === 'I5', r.why); }
  { const { deps, log } = mk({ rq: { none: '같은 작업에서 이미 2번 다시 실행함', job: 'J1' } }); const r = await heal.handle({ id: 'I6', rule: 'R13', screen: 'UUP0006', evidence: { fe: FE } }, deps);
    const last = log.upd[log.upd.length - 1]; chk('다시 실행 한도: 해결은 기록 · 다시 실행 안 함 사유', r.healed && /다시 실행 안 함\(같은 작업에서 이미 2번/.test(last.act.what), last.act.what); }
  { setRerun('none'); const { deps, log } = mk({}); const r = await heal.handle({ id: 'I7', rule: 'R13', screen: 'TTP0007', evidence: { fe: FE } }, deps);
    const last = log.upd[log.upd.length - 1]; chk('재수행 설정 = 수행 없음(기본): 보완·확인·해결은 하고 다시 실행은 안 함', r.healed && log.sync === 1 && log.fe === 1 && log.rq.length === 0 && /다시 실행 안 함\(재수행 설정 = 수행 없음/.test(last.act.what), last.act.what); }
  { fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} })); const { deps, log } = mk({}); await heal.handle({ id: 'I8', rule: 'R13', screen: 'SSP0008', evidence: { fe: FE } }, deps);
    chk('설정 없음 = 재수행(기본값 · 17:2x 사용자 변경)', log.rq.length === 1); }
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
