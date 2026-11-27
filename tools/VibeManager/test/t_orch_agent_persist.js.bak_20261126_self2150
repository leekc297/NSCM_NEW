// 에이전트 진단 대기열 저장·되살리기(2026-11-20): 자가 복구가 넘긴 사건(R14 20261120_160650)이 창 다시 로드 때 메모리 대기열과 함께 사라져 '조치 중'으로 멈춘 결함
//   · enqueue = .vibe/orch/agent_queue.json 에 기록 · restoreQueue = 해결 안 된 사건만 다시 넣고 '조치 중'은 '열림'으로 · 해결된 사건·없는 사건은 건너뜀
//   사용: node test/t_orch_agent_persist.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'agp-')); const vibeDir = path.join(root, '.vibe');
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true });
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { agentEnabled: false } })); // 진단 실행은 하지 않음(대기열만 시험)
fs.mkdirSync(path.join(vibeDir, 'orch'), { recursive: true });
const p = { root, vibeDir, claude: 'none', claudeModel: '' };
const watch = require(path.join(dir, 'orch-watch')); const agent = require(path.join(dir, 'orch-agent'));
watch.init(p, { noReloadSweep: true }); agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [], restoreDelayMs: 600000 });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const qf = path.join(vibeDir, 'orch', 'agent_queue.json'); const rq = () => { try { return JSON.parse(fs.readFileSync(qf, 'utf8')); } catch { return null; } };
(async () => {
  const a = watch.raise('R14', { screen: 'SCP0028', sig: 'R14|t|1', title: '시험 사건 A', evidence: {} });
  const b = watch.raise('R1', { screen: 'SCP0005', sig: 'R1|t|2', title: '시험 사건 B', evidence: {} });
  const c = watch.raise('R1', { screen: 'SSP0005', sig: 'R1|t|3', title: '시험 사건 C', evidence: {} });
  const ia = (a && a.id) || a; const ib = (b && b.id) || b; const ic = (c && c.id) || c;
  chk('시험 사건 3건 생성', !!(ia && ib && ic), JSON.stringify([ia, ib, ic]));
  agent.enqueue(ia, false);
  const q1 = rq(); chk('enqueue = 파일에 기록', Array.isArray(q1) && q1.some(x => x.id === ia), JSON.stringify(q1));
  // 창 다시 로드 모의: 파일에 3건(조치 중 · 해결 · 없는 사건)을 두고 되살림
  watch.update(ia, { status: 'acting' }, { by: '시험', what: '자가 복구 중' });
  watch.update(ib, { status: 'resolved' }, { by: '시험', what: '해결' });
  await new Promise(r => setTimeout(r, 200)); // 앞 drain 이 끝나게(agentEnabled false = 건너뜀)
  fs.writeFileSync(qf, JSON.stringify([{ id: ia, manual: false }, { id: ib, manual: false }, { id: 'NO_SUCH', manual: false }]));
  const n = agent.restoreQueue();
  chk('해결 안 된 사건만 되살림(1건)', n === 1, n);
  chk('조치 중이던 사건 = 열림으로 되돌림', (watch.get(ia) || {}).status === 'open', (watch.get(ia) || {}).status);
  chk('해결된 사건은 그대로', (watch.get(ib) || {}).status === 'resolved');
  const q2 = rq(); chk('되살린 뒤 파일에 그 사건만', Array.isArray(q2) && q2.length >= 1 && q2.every(x => x.id === ia), JSON.stringify(q2));
  try { agent.dispose(); } catch { } try { watch.dispose(); } catch { } try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
