// 창 다시 로드로 생긴 사건 = 사용자 확인 대상에서 뺌(2026-11-20 사용자 지시) · 지난 사건 기록 재생분은 사건으로 올리지 않음
//   사용: node test/t_orch_reloadmark.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'rmark-')); const p = { root, vibeDir: path.join(root, '.vibe') }; const od = path.join(p.vibeDir, 'orch');
fs.mkdirSync(od, { recursive: true }); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} }));
const st = require(path.join(dir, 'orch-state')); const w = require(path.join(dir, 'orch-watch'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const DEAD = 999971, LIVE = process.pid, T = Date.now() - 3600000;
const ctx = { selfPid: 1, alive: pid => pid === LIVE, activations: [{ pid: 999972, ms: T + 1000 }], events: [
  { ms: T - 900000, type: 'chain.start', src: 'vm', pid: DEAD },
  { ms: T - 200, type: 'step.end', src: 'vm', pid: DEAD, status: 'FAIL' },
  { ms: T - 100, type: 'claude.end', src: 'vm', pid: DEAD, exit: 1 },
  { ms: T + 600000, type: 'step.end', src: 'vm', pid: LIVE, status: 'FAIL' },
  { ms: T + 700000, type: 'step.end', src: 'vm', pid: DEAD + 5, status: 'FAIL' }] };
chk('끊긴 실행 = cut', w.reloadCause({ rule: 'R5', sig: 'R5|gone|chain|x', ms: T + 60000, detail: `시작 x · 주인 PID ${DEAD} · 끝 사건 없음` }, ctx) === 'cut');
chk('주인이 살아 있는 실행 = 대상 아님', w.reloadCause({ rule: 'R5', sig: 'R5|gone|chain|x', ms: T + 60000, detail: `주인 PID ${LIVE}` }, ctx) === '');
chk('진행 없음(R5 무출력) = 대상 아님', w.reloadCause({ rule: 'R5', sig: 'R5|CheckList', ms: T + 60000, detail: 'PID 1 · 실행 34분째' }, ctx) === '');
chk('창이 닫히며 끝난 실패 = shutdown', w.reloadCause({ rule: 'R1', sig: 'S8.x | y', ms: T }, ctx) === 'shutdown' && w.reloadCause({ rule: 'R7', sig: 'R7|미분류', ms: T }, ctx) === 'shutdown');
chk('살아 있는 창의 실패 = 대상 아님', w.reloadCause({ rule: 'R1', sig: 'S8.x | y', ms: T + 600000 }, ctx) === '');
chk('없어진 창의 실패지만 뒤이어 켜진 창 없음 = 대상 아님', w.reloadCause({ rule: 'R1', sig: 'S8.x | y', ms: T + 700000 }, ctx) === '');
chk('원인 기록 없는 사건 = replay', w.reloadCause({ rule: 'R2', sig: 'S8.x | y', ms: T + 300000 }, ctx) === 'replay' && w.reloadCause({ rule: 'R7', sig: 'R7|미분류', ms: T + 300000 }, ctx) === 'replay');
chk('사건 기록보다 앞선 사건 = 판정 안 함', w.reloadCause({ rule: 'R1', sig: 'S8.x | y', ms: T - 9000000 }, ctx) === '');
chk('죽은 잠금 반복(R2|R9), 그 밖 규칙 = 대상 아님', w.reloadCause({ rule: 'R2', sig: 'R2|R9|a.lock', ms: T + 300000 }, ctx) === '' && w.reloadCause({ rule: 'R6', sig: 'R6|down|1', ms: T + 300000 }, ctx) === '');
chk('다시 발생한 사건 = 마지막 발생으로 판정', w.reloadCause({ rule: 'R1', sig: 'S8.x | y', ms: T, lastMs: T + 600000 }, ctx) === '');

// 실제 파일로 정리: 사건 4건(끊김 · 중복 · 실제 실패 · 사용자가 닫은 것)
w.init(p, { noReloadSweep: true }); const got = []; w.on((inc, isNew) => { if (isNew) got.push(inc); });
const now = Date.now(); const line = o => JSON.stringify(o) + '\n';
fs.writeFileSync(path.join(od, 'events.jsonl'), line({ ms: now - 900000, type: 'chain.start', src: 'vm', pid: DEAD }) + line({ ms: now - 800000, type: 'step.end', src: 'vm', pid: DEAD, status: 'FAIL' }));
const a = w.raise('R5', { screen: 'SCP0005', sig: 'R5|gone|chain|c', title: '종료 기록 없이 사라진 실행', detail: `주인 PID ${DEAD} · 끝 사건 없음` });
const b = w.raise('R7', { sig: 'R7|미분류', title: 'Claude 비정상 종료' });
const c = w.raise('R6', { sig: 'R6|down|8080', title: '서버 꺼짐' });
const d = w.raise('R5', { screen: 'SSP0014', sig: 'R5|gone|chain|d', title: '종료 기록 없이 사라진 실행', detail: `주인 PID ${DEAD}` }); w.update(d.id, { status: 'closed' }, { by: '사용자', what: '닫음' });
w.update(a.id, { status: 'need-user' }, { by: 'VMO', what: '조치 실패' });
const marked = w.reloadSweep(); const ga = w.get(a.id), gb = w.get(b.id), gc = w.get(c.id), gd = w.get(d.id);
chk('정리 = 끊김 1건 + 중복 1건', marked.length === 2 && ga.status === 'resolved' && ga.notice === true && ga.reload === 'cut' && ga.prevStatus === 'need-user' && gb.reload === 'replay', JSON.stringify(marked));
chk('실제 사건, 닫은 사건은 그대로', gc.status === 'open' && !gc.reload && gd.status === 'closed' && !gd.reload);
chk('조치 기록 문구', /창 다시 로드로 생긴 사건/.test(ga.actions.slice(-1)[0].what));
w.update(a.id, { status: 'need-user' }, { by: 'VMO', what: '다시 올림 시도' });
chk('창 로드 사건은 사용자 확인 필요로 돌아가지 않음', w.get(a.id).status === 'resolved');
chk('다시 정리해도 추가 없음', w.reloadSweep().length === 0);
// 지난 사건 기록 재생
const n0 = got.length;
w.onEvent({ ms: now - 600000, type: 'claude.end', src: 'vm', pid: DEAD, exit: 1, wb: 9 });
w.onEvent({ ms: now - 600000, type: 'step.end', src: 'vm', pid: DEAD, status: 'FAIL', name: 's', task: 'S8.z', wb: 9, screen: 'SCP0028' });
chk('2분 넘게 지난 기록 = 사건 없음', got.length === n0);
w.onEvent({ ms: now, type: 'claude.end', src: 'vm', pid: process.pid, exit: 1, wb: 9 });
chk('방금 기록 = 종전대로 R7', got.length === n0 + 1 && got[n0].rule === 'R7', JSON.stringify(got.slice(n0).map(x => x.rule)));
w.dispose(); st.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
