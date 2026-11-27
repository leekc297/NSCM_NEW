// 같은 죽은 잠금 반복: 감시기 + 에이전트 연동 시험 — 1~2회는 R9 로 삭제, 3회째부터는 묶음 사건(R2) 1건이고 그때도 잠금은 지워진다
//   사용: node test/t_orch_lock_repeat.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'lockrep-')); const vibeDir = path.join(root, '.vibe');
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.mkdirSync(path.join(root, 'Doc', 'e2e'), { recursive: true });
// Claude 를 부르지 않게 R2 를 자동 조치 대상에서 뺀 설정(묶음 사건의 잠금 삭제는 코드가 한다)
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { agentRules: ['R1'], agentEnabled: true } }));
const p = { root, vibeDir, claude: 'claude-not-used', claudeModel: '' };
const st = require(path.join(dir, 'orch-state')); const watch = require(path.join(dir, 'orch-watch')); const agent = require(path.join(dir, 'orch-agent'));
watch.init(p, {}); agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [] });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const sleep = t => new Promise(r => setTimeout(r, t)); const lf = path.join(root, 'Doc', 'e2e', '_run.dbwin.TST0042.lock');
const put = pid => fs.writeFileSync(lf, JSON.stringify({ pid, started: '2026-11-19 18:00:00', args: 'TST0042', ppid: 77, parent: 'python.exe', chain: 'python.exe:77>cmd.exe:70' }));
(async () => {
  for (const pid of [999981, 999982]) { put(pid); watch.tick(); await sleep(500); chk(`${pid}: R9 로 잠금 삭제`, !fs.existsSync(lf)); }
  let all = watch.list(); chk('2회까지 R9 2건 · 해결', all.filter(x => x.rule === 'R9' && x.status === 'resolved').length === 2 && !all.some(x => x.rule === 'R2'), all.map(x => x.rule + ':' + x.status).join(','));
  put(999983); watch.tick(); await sleep(500);
  all = watch.list(); const r2 = all.find(x => x.rule === 'R2');
  chk('3회째 = 묶음 사건 R2 1건', !!r2 && all.filter(x => x.rule === 'R9').length === 2, all.map(x => x.rule).join(','));
  chk('묶음 사건에서도 잠금 삭제 · 조치 기록', !fs.existsSync(lf) && (r2.actions || []).some(a => /죽은 잠금 삭제/.test(a.what)), JSON.stringify((r2 && r2.actions || []).map(a => a.what)));
  put(999984); watch.tick(); await sleep(500);
  const r2b = watch.get(r2.id); chk('4회째 = 같은 사건 횟수 2 · 잠금 삭제', r2b.count === 2 && !fs.existsSync(lf) && watch.list().filter(x => x.rule === 'R2').length === 1, `count ${r2b.count}`);
  const snapLock = (put(process.pid), st.locks().find(x => x.file === '_run.dbwin.TST0042.lock')); fs.unlinkSync(lf);
  chk('상황판 잠금 목록에 부모 프로세스 전달', snapLock && snapLock.parent === 'python.exe' && snapLock.ppid === 77 && snapLock.alive === true, JSON.stringify(snapLock));
  // 개선안 20261120094531_REVIEW: 중지 직후 남은 잠금 = 사건 없이 지우고 처리 기록만. 중지 기록 없는 잠금 = 종전대로 R9
  const ev = require(path.join(dir, 'orch-events')); ev.emit('user.stop', { wb: 'J_TEST:TST0051', screen: 'TST0051', by: 'VS Code 종료' });
  const lf51 = path.join(root, 'Doc', 'e2e', '_run.dbwin.TST0051.lock'); fs.writeFileSync(lf51, JSON.stringify({ pid: 999985, started: '2026-11-20 05:48:44', args: 'TST0051' }));
  const lfAdmit = path.join(root, 'Doc', 'e2e', '_run.admit.lock'); fs.writeFileSync(lfAdmit, JSON.stringify({ pid: 999986, started: '2026-11-20 05:48:44', args: 'TST0051' }));
  watch.tick(); await sleep(500);
  all = watch.list(); const acts = fs.readFileSync(path.join(vibeDir, 'orch', 'activations.jsonl'), 'utf8').split(/\r?\n/).filter(Boolean).map(s => JSON.parse(s)).filter(a => a.kind === 'lock.stopclean');
  chk('user.stop 뒤 죽은 잠금 = 사건 0건 · 잠금 삭제(파일 화면, 인자 화면)', !fs.existsSync(lf51) && !fs.existsSync(lfAdmit) && !all.some(x => /TST0051|_run\.admit\.lock/.test(`${x.screen}|${x.sig}`)), all.map(x => x.rule + ':' + x.sig).join(','));
  chk('처리 기록 activations 2줄 · ms, pid 없음', acts.length === 2 && acts.every(a => a.ms == null && a.pid == null && a.screen === 'TST0051' && a.stopType === 'user.stop'), JSON.stringify(acts));
  const errs = fs.readFileSync(path.join(vibeDir, 'orch', 'vm_errors.jsonl'), 'utf8'); chk('처리 기록 errlog', /중지 뒤 잠금 정리/.test(errs));
  const lf52 = path.join(root, 'Doc', 'e2e', '_run.dbwin.TST0052.lock'); fs.writeFileSync(lf52, JSON.stringify({ pid: 999987, started: '2026-11-20 05:48:44', args: 'TST0052' }));
  watch.tick(); await sleep(500);
  all = watch.list(); chk('user.stop 없는 죽은 잠금 = R9 1건', all.filter(x => x.rule === 'R9' && x.screen === 'TST0052').length === 1 && !all.some(x => x.rule === 'R2' && x.screen === 'TST0052'), all.map(x => x.rule + ':' + x.screen).join(','));
  agent.dispose(); watch.dispose(); st.dispose(); await sleep(100); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
