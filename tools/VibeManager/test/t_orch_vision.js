// 큰 그림 점검(Overall Review · orch-vision.js, 2026-11-20) 시험
//   주기 = 환경설정 일수(기본 1) · 적용 여부(미적용 = 주기 점검 안 함, 단추 점검은 됨) · 결과 → 개선안 source vision · 자동 반영 대상 아님(visionAutoApply false)
//   사용: node test/t_orch_vision.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'vision-')); const vibeDir = path.join(root, '.vibe'); const mem = path.join(root, 'mem');
for (const d of [path.join(vibeDir, 'orch'), path.join(root, 'tools', 'Harness'), mem]) fs.mkdirSync(d, { recursive: true });
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} }));
fs.writeFileSync(path.join(mem, 'feedback_vmo_self_heal_restart_20261120.md'), 'VMO 목적 = 화면이 안 열리면 스스로 원인·해결·다시 실행');
fs.writeFileSync(path.join(mem, 'feedback_other.md'), '관계없는 메모리');
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const added = []; let setting = { visionEnabled: true, visionEveryDays: 1 }; let prompt = '';
const agent = { withLock: async (id, fn) => fn(), say: () => { }, lastJsonBlock: t => JSON.parse(t), runClaude: async p => { prompt = p; return { ok: true, code: 0, log: 'v.log', text: JSON.stringify({ summary: '요약', purposes: [{ purpose: '스스로 복구', verdict: '맞음', evidence: 'R13' }, { purpose: 'CheckList 30분', verdict: '어긋남', evidence: '136분' }], proposals: [{ title: '안1', evidence: '근거', targets: ['tools/Harness/verify/run_verify.py'] }, { title: '근거 없는 안' }] }) }; } };
const mods = { 'orch-agent': agent, 'orch-improve': { list: () => [], add: (o, src) => { added.push({ o, src }); return { id: 'V' + added.length }; }, digest: () => ({ events: 1 }) }, 'orch-selfcheck': { result: () => ({ checks: {} }) }, 'orch-watch': { list: () => [] }, 'orch-usercheck': { pendingPrompts: () => [] } };
const v = require(path.join(dir, 'orch-vision'));
v.init({ paths: () => ({ root, vibeDir }), vmDir: dir, memDir: mem, planFile: path.join(root, 'none.md'), mods, noTimer: true, settings: () => setting });
(async () => {
  chk('이력 없음 + 적용 = 점검 대상', v.due());
  setting = { visionEnabled: false, visionEveryDays: 1 }; chk('미적용 = 주기 점검 안 함', !v.due());
  const r0 = await v.run(false); chk('미적용 + 주기 실행 = 건너뜀', r0.skipped === '꺼짐', JSON.stringify(r0));
  const r = await v.run(true); chk('미적용이어도 단추 점검은 실행', r.ok && r.added === 1, JSON.stringify(r));
  chk('근거 없는 안은 등록 안 함 · 출처 vision', added.length === 1 && added[0].src === 'vision');
  chk('프롬프트에 목적 메모리(feedback_vmo_*) 포함, 다른 메모리 제외', /스스로 원인/.test(prompt) && !/관계없는 메모리/.test(prompt));
  chk('프롬프트에 사용자 지적 원장 포함', /U9 .*중지 뒤에도/.test(prompt));
  const m = v.meta(); chk('결과 기록: 목적 2건 · 어긋남 1', m.purposes.length === 2 && /어긋남 1/.test(m.lastResult), m.lastResult);
  chk('미적용이면 다음 점검 없음', m.enabled === false && !m.nextAt);
  setting = { visionEnabled: true, visionEveryDays: 2 }; chk('적용 + 방금 점검 = 대상 아님', !v.due());
  const mf = path.join(vibeDir, 'orch', 'vision', 'meta.json'); const mj = JSON.parse(fs.readFileSync(mf, 'utf8'));
  mj.lastMs = Date.now() - 1.5 * 86400000; fs.writeFileSync(mf, JSON.stringify(mj)); chk('2일 주기 · 1.5일 지남 = 대상 아님', !v.due());
  mj.lastMs = Date.now() - 2.1 * 86400000; fs.writeFileSync(mf, JSON.stringify(mj)); chk('2일 주기 · 2.1일 지남 = 대상', v.due());
  setting = { visionEnabled: true, visionEveryDays: 0 }; chk('일수 0 이하 = 1일로 봄', v.meta().everyDays === 1);
  // 자동 반영 대상 판정(orch-selfcheck.autoEligible)
  const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => ({ root, vibeDir }), vmDir: dir, timer: false, incidents: false });
  const pr = { source: 'vision', targets: ['tools/VibeManager/orch-watch.js'], title: '안' };
  chk('vision 안 = 자동 반영 대상 아님(visionAutoApply false)', sc.autoEligible(pr).ok === false && /승인/.test(sc.autoEligible(pr).why));
  fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { visionAutoApply: true } }));
  chk('visionAutoApply true 면 VM 코드 대상 자동 반영 가능', sc.autoEligible(pr).ok === true);
  chk('같은 대상 self 안 = 종전대로 자동', sc.autoEligible(Object.assign({}, pr, { source: 'self' })).ok === true);
  try { sc.dispose(); } catch { } v.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
