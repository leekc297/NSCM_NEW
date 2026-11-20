// R14 중지 뒤 계속 실행(2026-11-20 사용자 지적: 업무 작업 J20261120_060728 중지 09:57:05 뒤 09:57:08~12 에 4화면이 다음 단계를 띄움)
//   ① 실제 순서(events.jsonl 695~712 형태)를 넣으면 화면마다 R14 1건, 새 실행이 더 오면 횟수만 올라감
//   ② 중지 뒤 chain.start(다시 실행)가 오면 R14 없음 ③ 다른 체인(runId)의 단계는 R14 아님
//   ④ 업무 작업 기록이 stopped 인데 체인이 살아 있으면 tick 에서 R14 ⑤ 자가 복구: 프로세스 종료 + 화면 중지 요청 → 체인 없음 = 해결, 재발 = 에이전트
//   사용: node test/t_orch_stopleak.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'stopleak-')); const p = { root, vibeDir: path.join(root, '.vibe') };
fs.mkdirSync(path.join(p.vibeDir, 'orch'), { recursive: true }); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { stopLeakSec: 1 } }));
const st = require(path.join(dir, 'orch-state')); const w = require(path.join(dir, 'orch-watch')); const heal = require(path.join(dir, 'orch-heal'));
w.init(p, { noReloadSweep: true }); const got = []; w.on((inc, isNew) => { if (isNew) got.push(inc); });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const feed = ev => { st.apply(Object.assign({ src: 'vm', pid: process.pid }, ev)); }; // apply 가 감시기 onEvent 까지 부른다
(async () => {
  const J = 'J20261120_060728'; let t = Date.now() - 5000; const ms = () => (t += 300);
  const scr = ['SCP0005', 'SCP0028', 'SSP0005', 'SSP0014'];
  for (const s of scr) feed({ ms: ms(), type: 'chain.start', wb: `${J}:${s}`, screen: s, job: J, chain: 'checklist', chainLabel: 'CheckList', runId: `${s}_1`, steps: 7, plan: [] });
  for (const s of scr) feed({ ms: ms(), type: 'user.stop', wb: `${J}:${s}`, screen: s, job: J });
  chk('중지 직후 사건 0건', got.length === 0);
  feed({ ms: ms(), type: 'claude.start', wb: `${J}:SSP0014`, screen: 'SSP0014', label: '[4/4] 2-2. 검증 보완 2회차', childPid: 111 });
  feed({ ms: ms(), type: 'step.start', wb: `${J}:SCP0028`, screen: 'SCP0028', no: 5, name: '3-2. CheckList 재수행 2회차', runId: 'SCP0028_1' });
  feed({ ms: ms(), type: 'proc.start', wb: `${J}:SCP0028`, screen: 'SCP0028', label: 'CheckList 재수행', childPid: 222, procId: 'p1', stream: 'task' });
  feed({ ms: ms(), type: 'step.start', wb: `${J}:SCP0005`, screen: 'SCP0005', no: 4, name: '2-2. 검증 보완 2회차', runId: 'SCP0005_1' });
  feed({ ms: ms(), type: 'step.start', wb: `${J}:SSP0005`, screen: 'SSP0005', no: 3, name: '3. CheckList 재수행', runId: 'SSP0005_1' });
  const r14 = () => w.list(100).filter(x => x.rule === 'R14');
  chk('4화면 R14 4건', r14().length === 4, JSON.stringify(r14().map(x => [x.screen, x.count])));
  chk('SCP0028 은 1건에 횟수 2', (r14().find(x => x.screen === 'SCP0028') || {}).count === 2);
  chk('근거에 중지 시각·새 실행 목록', r14().every(x => x.evidence && x.evidence.stopMs && x.evidence.leaks.length >= 1 && x.evidence.runId));
  // ② 다시 실행
  got.length = 0;
  feed({ ms: ms(), type: 'chain.start', wb: 'J2:SCP0111', screen: 'SCP0111', job: 'J2', runId: 'SCP0111_1', plan: [] });
  feed({ ms: ms(), type: 'user.stop', wb: 'J2:SCP0111', screen: 'SCP0111', job: 'J2', by: 'VMO' });
  feed({ ms: ms(), type: 'chain.start', wb: 'J2:SCP0111', screen: 'SCP0111', job: 'J2', runId: 'SCP0111_2', plan: [] });
  feed({ ms: ms(), type: 'step.start', wb: 'J2:SCP0111', screen: 'SCP0111', no: 1, name: '1. 수행', runId: 'SCP0111_2' });
  chk('중지 뒤 다시 실행(새 체인) = R14 없음', !got.some(x => x.rule === 'R14'));
  // ③ 중지 때 체인 없던 창(단독 작업)
  feed({ ms: ms(), type: 'user.stop', wb: 7, screen: 'DMF0042' }); feed({ ms: ms(), type: 'proc.start', wb: 7, screen: 'DMF0042', label: '단독 작업', childPid: 9 });
  chk('중지 때 체인 없던 창의 새 작업 = R14 없음', !got.some(x => x.rule === 'R14'));
  // ④ 업무 작업 기록 불일치
  fs.mkdirSync(path.join(p.vibeDir, 'jobs', 'J3'), { recursive: true }); fs.writeFileSync(path.join(p.vibeDir, 'jobs', 'J3', 'job.json'), JSON.stringify({ id: 'J3', status: 'stopped', note: '사용자 중지', screens: [] }));
  feed({ ms: Date.now(), type: 'chain.start', wb: 'J3:SCP0096', screen: 'SCP0096', job: 'J3', runId: 'SCP0096_1', plan: [] });
  await new Promise(r => setTimeout(r, 1300)); w.tick();
  chk('job.json 중지 + 체인 살아 있음 = tick 에서 R14', got.some(x => x.rule === 'R14' && x.screen === 'SCP0096'), JSON.stringify(got.map(x => [x.rule, x.screen])));
  // ⑤ 자가 복구
  chk('자가 복구가 R14 를 맡음', heal.claims({ rule: 'R14' }) && !heal.claims({ rule: 'R14', notice: true }));
  const inc = r14().find(x => x.screen === 'SCP0028'); const killed = []; const stopped = []; let enq = 0;
  const deps = { watch: w, state: st, agent: { enqueue: () => { enq++; } }, kill: async pid => { killed.push(pid); return true; }, jobRunner: { stopScreen: (s, by) => { stopped.push(s); return { job: J }; } }, recheckMs: 50 };
  const endP = setTimeout(() => feed({ ms: Date.now(), type: 'chain.end', wb: `${J}:SCP0028`, screen: 'SCP0028', runId: 'SCP0028_1', ok: false, chain: 'checklist', chainLabel: 'CheckList' }), 10);
  const r = await heal.handle(inc, deps); clearTimeout(endP);
  chk('복구: 그 창 프로세스 종료(PID 222)', killed.includes(222), JSON.stringify(killed));
  chk('복구: 업무 작업 화면 중지 요청', stopped.includes('SCP0028'));
  chk('복구: 체인 끝남 = 해결', r.healed === true && (w.get(inc.id) || {}).status === 'resolved', JSON.stringify(r));
  const inc2 = r14().find(x => x.screen === 'SSP0005'); const r2 = await heal.handle(inc2, Object.assign({}, deps, { kill: async () => true }));
  chk('복구 뒤에도 체인 살아 있음 = 에이전트로 넘김', r2.healed === false && enq === 1, JSON.stringify(r2));
  w.dispose(); st.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
