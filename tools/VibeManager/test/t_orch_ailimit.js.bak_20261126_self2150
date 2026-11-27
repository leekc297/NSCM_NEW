// 2026-11-24 사용자 지시 'AI 주간 한도 90% 이상이면 VMO 자가진단, 보완 멈춤. 작업 모니터링은 계속' 시험 — 임시 폴더, 실제 Claude 호출 없음
//   ① 한도 94%(기준 90) = 멈춤: withLock(자동 AI 작업) 실행 안 함(busy, limit), 자동 반영 자리(reserve) 못 잡음, 사람 승인(manual) 자리는 잡음
//   ② 한도 50% 또는 재설정 시각 지남 = 진행 · ③ 기준 0 = 끔 · ④ 자가진단 정기 실행(tick) = 멈춤 알림 1번 · 사건 감시(orch-watch)는 이 기준을 보지 않음
//   사용: node test/t_orch_ailimit.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'ailimit-')); const vibeDir = path.join(root, '.vibe'); const logs = path.join(vibeDir, 'logs'); fs.mkdirSync(logs, { recursive: true });
const hj = path.join(root, 'tools', 'Harness', 'harness.json'); fs.mkdirSync(path.dirname(hj), { recursive: true });
const setH = o => fs.writeFileSync(hj, JSON.stringify({ repairScope: 'DB_FE', orch: Object.assign({ agentEnabled: false }, o) }));
let seq = 0;
const setUse = (u, resetMs) => { seq++; fs.writeFileSync(path.join(logs, `2026-11-24T00-00-0${seq}_claude_orch.log`), JSON.stringify({ type: 'rate_limit_event', rate_limit_info: { status: 'allowed_warning', unifiedWindows: { seven_day: { utilization: u, resetsAt: Math.round(resetMs / 1000), status: 'allowed_warning' } } } }) + '\n'); };
const p = { root, vibeDir, extDir: dir, claude: 'none' };
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
require(path.join(dir, 'orch-events')).init(vibeDir);
const agent = require(path.join(dir, 'orch-agent')); agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [] });
const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => p, timer: false, autoSync: false, inventory: false, docStyle: false, incidents: false });
const msgs = []; sc.on(m => msgs.push(m));
const wait = ms => new Promise(r => setTimeout(r, ms));
(async () => {
  setH({ aiWeeklyStopPct: 90 }); setUse(0.94, Date.now() + 86400000); await wait(30);
  const L = agent.aiLimit();
  chk('① 94% ≥ 기준 90 = 멈춤', L.stop === true && L.pct === 94 && L.lim === 90 && /AI 주간 한도 94%/.test(L.why), JSON.stringify(L));
  let ran = false; const r = await agent.withLock('review', async () => { ran = true; return { ok: true }; });
  chk('① 자동 AI 작업(withLock) 실행 안 함 = busy, limit', !ran && r.busy === true && r.limit === true, JSON.stringify(r));
  chk('① 자동 반영 자리(reserve) 못 잡음', agent.reserve('prop_a') === null);
  const tok = agent.reserve('prop_b', { manual: true }); let ran2 = false;
  if (tok) { await agent.withLock('prop_b', async () => { ran2 = true; }); agent.release(tok); }
  chk('① 사람 승인(manual) = 자리 잡고 그 자리 안 작업 진행', !!tok && ran2);
  chk('① 멈춤 알림 = 에이전트 기록 1줄', agent.feedList().filter(m => /AI 주간 한도 94%/.test(m.text || '')).length >= 1);
  msgs.length = 0; await sc.tick(); await sc.tick();
  chk('④ 자가진단 정기 실행 멈춤 알림 1번(두 번 돌아도)', msgs.filter(m => /자가진단, 자동 보완 멈춤/.test(m.text || '')).length === 1, JSON.stringify(msgs.map(m => m.text)).slice(0, 300));
  setUse(0.5, Date.now() + 86400000); await wait(1100);
  chk('② 50% = 진행', agent.aiLimit().stop === false);
  let ran3 = false; await agent.withLock('review', async () => { ran3 = true; }); chk('② withLock 실행', ran3);
  setUse(0.97, Date.now() - 60000); await wait(1100);
  chk('② 재설정 시각 지남 = 진행', agent.aiLimit().stop === false);
  // 2026-11-26 개선안 20261126182418_SELF(R253): 키가 없으면 기준 100 = 다 쓴 때만 멈춤
  setH({}); setUse(0.99, Date.now() + 86400000); await wait(1100);
  { const A = agent.aiLimit(); chk('⑤ 키 없음 + 99% = 진행(기준 100)', A.stop === false && A.lim === 100, JSON.stringify(A)); }
  setUse(1, Date.now() + 86400000); await wait(1100);
  { const A = agent.aiLimit(); chk('⑤ 키 없음 + 100% = 멈춤', A.stop === true && A.lim === 100, JSON.stringify(A)); }
  setUse(0.99, Date.now() + 86400000); setH({ aiWeeklyStopPct: 0 }); await wait(1100);
  chk('③ 기준 0 = 끔', agent.aiLimit().stop === false);
  const watchSrc = fs.readFileSync(path.join(dir, 'orch-watch.js'), 'utf8');
  chk('④ 사건 감시(orch-watch) 는 한도 기준을 보지 않음(모니터링 계속)', !/aiLimit/.test(watchSrc));
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e && e.stack); process.exit(1); });
