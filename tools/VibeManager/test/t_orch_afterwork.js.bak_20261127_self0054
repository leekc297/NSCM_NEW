// 2026-11-26 사용자 지시('작업 종료 시 개선항목 찾아서 진행을 자동으로 진행되도록') 시험 — 임시 폴더, 실제 Claude·스캔 호출 없음
//   ① 대상 사건: 정상 끝 chain.end·job.end 만(중지·창 종료 제외) ② 주제 문장에 끝난 작업 이름·결과 ③ 한 번 실행 = 스캔 → 진단 → 컨설팅(주제) → 자동 반영 차례
//   ④ 컨설팅 간격 안이면 건너뜀 · 진단 간격은 afterWorkDiagGapMin ⑤ 끄기 ⑥ 사건 묶기: 이어 끝난 체인은 지연 뒤 한 번
//   사용: node test/t_orch_afterwork.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'afterwork-')); const vibeDir = path.join(root, '.vibe');
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true });
const setCfg = o => fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: Object.assign({ afterWorkDelaySec: 10 }, o || {}) }));
setCfg();
const calls = [];
const cs = { ready: () => true, init: () => { }, check: async () => { calls.push('scan'); return { items: [{ key: 'S16|K1' }], info: { at: 'x' } }; }, maybeDiagnose: async o => { calls.push(`diag:${o.cfg.checkerDiagGapHours}`); return { added: 1 }; } };
let consultTopic = '';
const cons = { ready: () => true, init: () => { }, run: async (manual, topic) => { calls.push('consult'); consultTopic = topic; return { ok: true, added: 2 }; } };
const sc = { autoApplyNext: async () => { calls.push('apply'); return { id: 'P1', ok: true }; } };
const listeners = []; const st = { on: fn => { listeners.push(fn); return () => { }; }, snapshot: () => ({ chains: [] }) };
const notes = [];
const aw = require(path.join(dir, 'orch-afterwork'));
aw.init({ paths: () => ({ root, vibeDir }), notify: t => notes.push(t), mods: { 'orch-checkerscan': cs, 'orch-consult': cons, 'orch-selfcheck': sc, 'orch-agent': {}, 'orch-improve': {}, 'orch-state': st } });
const end = { type: 'chain.end', chainLabel: 'CheckList', screen: 'SCP0005', ok: true, ms_run: 5400000, md: 'Doc/x.md' };
chk('① 정상 끝 chain.end = 대상', aw.wants(end) === true);
chk('① 사용자 중지 chain.end = 대상 아님', aw.wants(Object.assign({}, end, { stopped: true })) === false && aw.wants(Object.assign({}, end, { aborted: true })) === false);
chk('① job.end 중지 = 대상 아님 · 완료 = 대상', aw.wants({ type: 'job.end', status: 'stopped' }) === false && aw.wants({ type: 'job.end', status: 'done' }) === true);
chk('① 다른 사건 = 대상 아님', aw.wants({ type: 'chain.start' }) === false);
const tp = aw.topicOf([end]);
chk('② 주제 = 작업 이름·화면·결과·소요', /CheckList/.test(tp) && /SCP0005/.test(tp) && /성공/.test(tp) && /90분/.test(tp) && /개선안/.test(tp), tp);
chk('⑥ 상태 구독 1건', listeners.length === 1);
(async () => {
  let r = await aw.runOnce([end], false);
  chk('③ 순서 = 스캔 → 진단(간격 30분 = 0.5시간) → 컨설팅 → 자동 반영', calls.join(',') === 'scan,diag:0.5,consult,apply', calls.join(','));
  chk('③ 컨설팅 주제 전달', consultTopic === tp);
  chk('③ 기록 last.json · 알림(진단 1 + 컨설팅 2)', fs.existsSync(path.join(vibeDir, 'orch', 'afterwork', 'last.json')) && notes.length === 1 && /3건/.test(notes[0]), notes.join('|'));
  calls.length = 0; r = await aw.runOnce([end], false);
  chk('④ 컨설팅 간격 안 = 건너뜀(스캔·진단·반영은 진행)', calls.join(',') === 'scan,diag:0.5,apply' && /간격 전/.test(r.consult && r.consult.skip || ''), JSON.stringify(r.consult));
  setCfg({ afterWorkEnabled: false }); calls.length = 0; r = await aw.runOnce([end], false);
  chk('⑤ 끄기 = 아무것도 안 함', r.skipped === '꺼짐' && calls.length === 0);
  aw.dispose();
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
