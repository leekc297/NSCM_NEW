// VMO 알림 한곳(orch-notify.js) 시험: 반영 완료 묶음, 실패·사건 바로 보냄, 같은 문구 중복 제거, events.jsonl 기록
//   개선안 20261126164445_VISION_3. 사용: node test/t_orch_notify.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const vibe = fs.mkdtempSync(path.join(os.tmpdir(), 'orchnotify-'));
const ev = require(path.join(dir, 'orch-events')); ev.init(vibe);
const nt = require(path.join(dir, 'orch-notify'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x === undefined ? '' : x); if (!c) ok = false; };
let clock = 1000000; const shown = [];
nt.init({ show: (t, o) => shown.push({ t, o }), windowMs: 600000, now: () => clock });
const events = () => { try { return fs.readFileSync(ev.file(), 'utf8').split(/\r?\n/).filter(Boolean).map(l => JSON.parse(l)); } catch { return []; } };

// 반영 완료 3건(같은 안 알림 2번 포함) + 실패 1건
const r1 = nt.send('applied', 'VMO — 개선안 반영 완료. A', { key: 'P1', button: '개선안 보기', open: 'prop' });
nt.send('applied', 'VMO 자가진단. 자가 보완 반영: A', { key: 'P1' });
nt.send('applied', 'VMO — 개선안 반영 완료. B', { key: 'P2' });
const rf = nt.send('apply-failed', 'VMO — 개선안 반영 실패. C', { key: 'P3' });
const rf2 = nt.send('apply-failed', 'VMO 자가진단. 자가 보완 반영 실패(되돌림): C', { key: 'P3' });
chk('반영 완료 = 바로 보내지 않고 묶음', r1 === 'merged' && !shown.some(s => /반영 완료/.test(s.t)), JSON.stringify(shown));
chk('반영 실패 = 바로 보냄(같은 안 두 번째 알림은 거름)', rf === 'shown' && rf2 === 'dup' && shown.filter(s => /실패/.test(s.t)).length === 1, JSON.stringify([rf, rf2]));
chk('묶음 대기 건수: 반영 2(같은 key 1건), 실패 1', JSON.stringify(nt.pending() && [nt.pending().applied, nt.pending().failed]) === '[2,1]', JSON.stringify(nt.pending()));
const ft = nt.flush();
chk('묶음 1건: "개선안 반영 2건, 실패 1건" · 버튼 유지', /개선안 반영 2건, 실패 1건/.test(ft) && shown.length === 2 && shown[1].o.button === '개선안 보기' && shown[1].o.open === 'prop', ft);
chk('묶음 뒤 대기 없음 · 빈 묶음 flush = 보내지 않음', nt.pending() === null && nt.flush() === '' && shown.length === 2);

// 사건: 바로 · 같은 문구 10분 안 1번 · 10분 지나면 다시
const i1 = nt.send('incident', 'VMO — R1 DMF0004: 확인 필요', { button: '사건 보기', open: 'inc' });
const i2 = nt.send('incident', 'VMO — R1 DMF0004: 확인 필요');
clock += 9 * 60000; const i3 = nt.send('incident', 'VMO — R1 DMF0004: 확인 필요');
clock += 2 * 60000; const i4 = nt.send('incident', 'VMO — R1 DMF0004: 확인 필요');
chk('사건 = 바로 · 10분 안 같은 문구 거름 · 10분 뒤 다시 보냄', [i1, i2, i3, i4].join() === 'shown,dup,dup,shown' && shown.filter(s => /R1 DMF0004/.test(s.t)).length === 2, [i1, i2, i3, i4].join());

// 실패만 있고 반영 완료 0건 = 묶음 알림 없음
nt.send('apply-failed', 'VMO — 개선안 반영 실패. D', { key: 'P4' }); const n0 = shown.length;
chk('실패만 있는 묶음 = 묶음 알림 없음', nt.flush() === '' && shown.length === n0);

// 종류 추정(종전 notifier(text) 모양)
chk('kindOf: 실패, 완료, 승인 대기, 그 밖', nt.kindOf('개선안 반영 실패. x') === 'apply-failed' && nt.kindOf('자가 보완 반영 실패(되돌림): x') === 'apply-failed' && nt.kindOf('개선안 반영 완료. x') === 'applied' && nt.kindOf('자가 보완 반영: x') === 'applied' && nt.kindOf('개선안 3건 승인 대기') === 'approval' && nt.kindOf('설치 폴더 동기화 2개 파일') === 'other');

// 묶음 끄기(orch.notifyMerge false) = 건마다 바로
nt.init({ show: (t, o) => shown.push({ t, o }), windowMs: 600000, now: () => clock, merge: () => false }); const n1 = shown.length;
nt.send('applied', 'VMO — 개선안 반영 완료. E', { key: 'P5' }); nt.send('applied', 'VMO — 개선안 반영 완료. E', { key: 'P5' });
chk('묶음 끄기 = 건마다 바로 보냄', shown.length === n1 + 2);

// 시간 묶음: 타이머가 windowMs 뒤 보냄
nt.init({ show: (t, o) => shown.push({ t, o }), windowMs: 50 });
nt.send('applied', 'VMO — 개선안 반영 완료. F', { key: 'P6' }); const n2 = shown.length;
setTimeout(() => {
  chk('타이머: windowMs 지나면 묶음 1건 자동 보냄', shown.length === n2 + 1 && /개선안 반영 1건, 실패 0건/.test(shown[shown.length - 1].t), shown[shown.length - 1] && shown[shown.length - 1].t);
  const evs = events(); const sh = evs.filter(e => e.type === 'notify.shown'); const mg = evs.filter(e => e.type === 'notify.merged');
  chk('events.jsonl 기록: notify.shown = 보낸 알림 수 · notify.merged 있음 · 묶음 알림의 merged 건수', sh.length === shown.length && mg.length >= 5 && sh.some(e => e.kind === 'applied' && e.merged === 2), JSON.stringify({ shown: sh.length, alerts: shown.length, merged: mg.length }));
  nt.dispose(); try { fs.rmSync(vibe, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
}, 200);
