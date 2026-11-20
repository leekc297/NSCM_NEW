// orch-watch.js 규칙 시험 — 임시 폴더에 사건을 주입해 R1·R2·R3·R4·R5·R7·R9·R10·R11 사건이 만들어지는지 본다(VS Code·Claude 불필요)
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'watch-')); const p = { root, vibeDir: path.join(root, '.vibe') };
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true });
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { waitMaxSec: 1, stallSec: 1, stepSlowMinSec: 1 } }));
fs.mkdirSync(path.join(root, 'Doc', 'e2e'), { recursive: true });
fs.mkdirSync(path.join(root, 'Doc', 'verify', 'TST0001'), { recursive: true });
const st = require(path.join(dir, 'orch-state')); const w = require(path.join(dir, 'orch-watch')); const ev = require(path.join(dir, 'orch-events'));
w.init(p, {}); const got = []; w.on((inc, isNew) => { if (isNew) got.push(inc); });
let ok = true; const chk = (name, cond, extra) => { console.log(cond ? 'PASS' : 'FAIL', name, extra || ''); if (!cond) ok = false; };
const me = process.pid; let ms = Date.now();
const E = (type, d) => st.apply(Object.assign({ at: '', ms: ms++, type, src: 'vm', pid: me }, d));
const rules = () => got.map(x => x.rule).join(',');
const sleep = t => new Promise(r => setTimeout(r, t));
(async () => {
  // R1: 체인 밖 프로세스 실패
  E('proc.start', { wb: 1, screen: 'TST0001', label: 'S8.verify', procId: 1, childPid: me, log: 'a.log' });
  E('proc.end', { wb: 1, screen: 'TST0001', label: 'S8.verify', procId: 1, exit: 6, why: '[FAIL] files.csv current 변형 없음', sig: ev.signature('S8.verify', '[FAIL] files.csv current 변형 없음') });
  chk('R1 프로세스 실패', got.length === 1 && got[0].rule === 'R1', rules());
  // R2: 같은 화면 같은 서명 2회째
  E('proc.start', { wb: 1, screen: 'TST0001', label: 'S8.verify', procId: 2, childPid: me, log: 'b.log' });
  E('proc.end', { wb: 1, screen: 'TST0001', label: 'S8.verify', procId: 2, exit: 6, why: '[FAIL] files.csv current 변형 없음', sig: ev.signature('S8.verify', '[FAIL] files.csv current 변형 없음') });
  chk('R2 같은 오류 반복', got.length === 2 && got[1].rule === 'R2' && got[1].repeat.same === 2, rules() + ' ' + (got[1] && got[1].title));
  // 사용자 중지 뒤 실패는 사건으로 만들지 않는다
  E('user.stop', { wb: 3 });
  E('proc.end', { wb: 3, screen: 'TST0002', label: 'X', procId: 9, exit: 1, why: 'killed', sig: 'x' });
  chk('사용자 중지 뒤 실패 제외', got.length === 2, rules());
  // 체인 안 실패: proc.end 는 건너뛰고 step.end FAIL 만 사건
  E('chain.start', { wb: 2, screen: 'TST0001', chain: 'docs', chainLabel: '문서 생성', runId: 'r1', shown: 2 });
  E('step.start', { wb: 2, screen: 'TST0001', runId: 'r1', no: 1, name: 'S3.prep', task: 'S3.prep', actor: 'script' });
  E('proc.end', { wb: 2, screen: 'TST0001', label: 'S3.prep', procId: 5, exit: 3, why: 'boom', sig: 's3' });
  const n0 = got.length;
  E('step.end', { wb: 2, screen: 'TST0001', runId: 'r1', chainLabel: '문서 생성', no: 1, name: 'S3.prep', task: 'S3.prep', actor: 'script', status: 'FAIL', exit: 3, ms_run: 5000, why: 'boom', sig: 'S3.prep | boom' });
  chk('체인 안 실패 = 단계 사건 1건', got.length === n0 + 1 && got[got.length - 1].rule === 'R1', rules());
  E('chain.end', { wb: 2, screen: 'TST0001', chain: 'docs', chainLabel: '문서 생성', runId: 'r1', ok: false, failNo: 1, claudeRan: 0, claudeSkipped: 0, scriptRan: 1 });
  chk('R11 Claude 없이 끝난 체인', got[got.length - 1].rule === 'R11', rules());
  // R3: 소요 통계 3회 뒤 2배 초과
  for (let i = 0; i < 3; i++) E('step.end', { screen: 'TST0001', runId: 'r2', no: 1, name: 'S1.live', task: 'S1.live', actor: 'script', status: 'OK', ms_run: 10000 });
  E('step.end', { screen: 'TST0001', runId: 'r2', no: 1, name: 'S1.live', task: 'S1.live', actor: 'script', status: 'OK', ms_run: 31000 });
  chk('R3 단계 지연', got[got.length - 1].rule === 'R3', got[got.length - 1].title);
  // R7: claude 비정상 종료
  E('claude.start', { wb: 1, screen: 'TST0001', label: '검증 보완', childPid: me });
  E('claude.end', { wb: 1, screen: 'TST0001', label: '검증 보완', exit: 1, anyOutput: false, stderrTail: 'Error: No conversation found with session ID x', log: 'c.log' });
  chk('R7 Claude 비정상 종료 · 분류', got[got.length - 1].rule === 'R7' && /세션 이어받기/.test(got[got.length - 1].title), got[got.length - 1].title);
  // R4 대기 지연 · R5 진행 없음 · R9 죽은 잠금 (tick)
  st.apply({ ms: Date.now() - 5000, type: 'wait.start', src: 'py', pid: me, kind: 'admit', screen: 'TST0003', why: 'CPU 91%' });
  fs.writeFileSync(path.join(root, 'old.log'), 'x'); const past = new Date(Date.now() - 60000); fs.utimesSync(path.join(root, 'old.log'), past, past);
  st.apply({ ms: Date.now() - 5000, type: 'proc.start', src: 'vm', pid: me, wb: 1, screen: 'TST0004', label: 'S8.checklistRun', procId: 77, childPid: me, log: 'old.log' });
  fs.writeFileSync(path.join(root, 'Doc', 'e2e', '_run.verify.TST0005.lock'), JSON.stringify({ pid: 999999, started: '2026-11-18T10:00:00', args: 'verify TST0005' }));
  w.tick();
  const rs = got.map(x => x.rule);
  chk('R4 대기 지연', rs.includes('R4')); chk('R5 진행 없음', rs.includes('R5')); chk('R9 죽은 잠금', rs.includes('R9'), JSON.stringify(got.filter(x => x.rule === 'R9').map(x => x.screen)));
  const n1 = got.length; w.tick(); chk('같은 사건 다시 만들지 않음', got.length === n1, String(got.length - n1));
  // R5: 로그 무출력 12분이어도 E2E 추적 파일이 30초 전에 바뀌었으면 사건 없음 · 추적 파일도 13분 전이면 사건 (개선안 20261119205920_INC)
  {
    const hj = path.join(root, 'tools', 'Harness', 'harness.json'); const cfg0 = fs.readFileSync(hj, 'utf8');
    fs.writeFileSync(hj, JSON.stringify({ orch: { waitMaxSec: 1, stallSec: 600, stepSlowMinSec: 1 } }));
    const at = (f, secAgo) => { const d = new Date(Date.now() - secAgo * 1000); fs.utimesSync(f, d, d); };
    fs.writeFileSync(path.join(root, 'e2e.log'), 'x'); at(path.join(root, 'e2e.log'), 720);
    const td = path.join(root, 'Doc', 'verify', 'TST0008', 'e2e', 'artifacts', '.playwright-artifacts-0', 'traces'); fs.mkdirSync(td, { recursive: true });
    const tf = path.join(td, 'recording30.trace'); fs.writeFileSync(tf, 'x'); at(tf, 30);
    st.apply({ ms: Date.now() - 900000, type: 'proc.start', src: 'vm', pid: me, wb: 1, screen: 'TST0008', label: 'S8.e2e', procId: 78, childPid: me, log: 'e2e.log' });
    const r5 = () => got.filter(x => x.rule === 'R5' && x.screen === 'TST0008');
    w.tick(); chk('R5 없음: 로그 무출력 12분 · 추적 파일 30초 전 수정', r5().length === 0, String(r5().length));
    at(tf, 780); w.tick();
    chk('R5 진행 없음: 로그 12분 · 추적 파일 13분 무변경', r5().length === 1 && r5()[0].evidence.quiet_sec >= 700 && r5()[0].evidence.quiet_sec < 760 && r5()[0].evidence.trace_quiet_sec >= 770, JSON.stringify(r5().map(x => x.evidence)));
    E('proc.end', { wb: 1, screen: 'TST0008', label: 'S8.e2e', procId: 78, exit: 0 });
    fs.writeFileSync(hj, cfg0);
  }
  // 같은 죽은 잠금이 60분 안에 3회 = R9 2건(삭제만) + 묶음 사건 R2 1건 · 4회째는 같은 사건의 횟수만 (VMO 개선안 20261119193539_REVIEW_3)
  {
    const lf = path.join(root, 'Doc', 'e2e', '_run.dbwin.TST0007.lock'); const b0 = got.length;
    const put = pid => fs.writeFileSync(lf, JSON.stringify({ pid, started: '2026-11-19 18:00:00', args: 'TST0007 --only R1', ppid: 4321, parent: 'cmd.exe', chain: 'cmd.exe:4321>Code.exe:100' }));
    for (const pid of [999991, 999992, 999993]) { put(pid); w.tick(); fs.unlinkSync(lf); const last = got[got.length - 1]; if (last.rule === 'R9') w.update(last.id, { status: 'resolved' }, { by: 'test', what: '삭제' }); }
    const add3 = got.slice(b0).map(x => `${x.rule}:${x.screen}`).join(',');
    chk('같은 죽은 잠금 3회 = R9 2건 + R2 1건', add3 === 'R9:TST0007,R9:TST0007,R2:TST0007', add3);
    const r2 = got[got.length - 1];
    chk('묶음 사건에 횟수 · 부모 프로세스 · 인자 · 시작~감지 간격', /3회/.test(r2.title) && /부모 cmd\.exe\(4321\)/.test(r2.detail) && /인자 TST0007 --only R1/.test(r2.detail) && /시작~감지 \d+초/.test(r2.detail) && r2.evidence.occurrences.length === 3 && r2.evidence.deadLock.file === 'Doc/e2e/_run.dbwin.TST0007.lock', r2.detail.split('\n')[0]);
    put(999994); w.tick(); fs.unlinkSync(lf);
    const r2b = w.get(r2.id); chk('4회째 = 새 사건 없이 같은 사건 횟수와 제목 갱신', got.length === b0 + 3 && r2b.count === 2 && /4회/.test(r2b.title) && r2b.evidence.occurrences.length === 4, `${got.length - b0}건 · count ${r2b.count} · ${r2b.title}`);
  }
  // R10: CheckList 연속 2회 같은 행 집합 · R11(checklist, Claude 0)
  const vd = path.join(root, 'Doc', 'verify', 'TST0001');
  const res = started => fs.writeFileSync(path.join(vd, 'run_verify.result.json'), JSON.stringify({ started, summary: { FAIL: 2, '판정필요': 0, '미검증': 1 }, issues: [{ id: 'V-1', class: 'D6' }, { id: 'V-2', class: 'A1' }] }));
  res('2026-11-19 10:00:00');
  E('chain.end', { wb: 1, screen: 'TST0001', chain: 'checklist', chainLabel: '🔎 CheckList', runId: 'c1', ok: true, claudeRan: 1, claudeSkipped: 0, scriptRan: 2 });
  const n2 = got.length;
  res('2026-11-19 11:00:00');
  E('chain.end', { wb: 1, screen: 'TST0001', chain: 'checklist', chainLabel: '🔎 CheckList', runId: 'c2', ok: true, claudeRan: 0, claudeSkipped: 1, scriptRan: 1 });
  const add = got.slice(n2).map(x => x.rule);
  chk('R10 CheckList 판정 정체', add.includes('R10'), add.join(','));
  chk('R11 CheckList Claude 0', add.includes('R11'));
  // 작업 목록 중지(job-runner stop) = user.stop(wb '작업ID:화면') 뒤 step.end FAIL, CheckList chain.end 는 R1, R11 사건 없음 (개선안 20261120003742_INC)
  {
    const jwb = 'J20261120_003243:TST0001'; const n3 = got.length;
    E('user.stop', { wb: jwb, screen: 'TST0001', job: 'J20261120_003243' });
    E('step.end', { wb: jwb, screen: 'TST0001', runId: 'c3', chainLabel: '🔎 CheckList', no: 1, name: 'S8.checklistRun', task: 'S8.checklistRun', actor: 'script', status: 'FAIL', exit: 1, ms_run: 5000, why: 'killed', sig: 'S8.checklistRun | killed' });
    res('2026-11-19 12:00:00');
    E('chain.end', { wb: jwb, screen: 'TST0001', chain: 'checklist', chainLabel: '🔎 CheckList', runId: 'c3', ok: false, failNo: 1, claudeRan: 0, claudeSkipped: 1, scriptRan: 1 });
    const add3 = got.slice(n3).map(x => x.rule);
    chk('작업 목록 중지 뒤 R1, R11 0건', !add3.includes('R1') && !add3.includes('R11'), add3.join(',') || '0건');
  }
  // 작업 목록 중지(user.stop) 뒤 chain.end(ms_run 포함) = R11 0건 · 체인 시작보다 앞선 결과(started)로 chain.end = R11 0건 · 체인 시작 뒤 결과 = R11 (개선안 20261120003909_INC)
  {
    const two = n => String(n).padStart(2, '0'); const loc = t => { const d = new Date(t); return `${d.getFullYear()}-${two(d.getMonth() + 1)}-${two(d.getDate())} ${two(d.getHours())}:${two(d.getMinutes())}:${two(d.getSeconds())}`; };
    const resN = (started, fail) => fs.writeFileSync(path.join(vd, 'run_verify.result.json'), JSON.stringify({ started, summary: { FAIL: fail, '판정필요': 0, '미검증': 1 }, issues: [{ id: `V-${started}`, class: 'D6' }] }));
    const r11 = from => got.slice(from).filter(x => x.rule === 'R11').length;
    const jwb4 = 'J20261120_003909:TST0001'; const n4 = got.length;
    resN(loc(Date.now() - 10000), 3);
    E('user.stop', { wb: jwb4, screen: 'TST0001', job: 'J20261120_003909', ms: Date.now() });
    E('chain.end', { wb: jwb4, screen: 'TST0001', chain: 'checklist', chainLabel: '🔎 CheckList', runId: 'c4', ok: false, failNo: 1, claudeRan: 0, claudeSkipped: 1, scriptRan: 1, ms: Date.now(), ms_run: 60000 });
    chk('user.stop 뒤 chain.end = R11 0건', r11(n4) === 0, String(r11(n4)));
    // 개선안 20261120042738_INC: 체인 시작보다 이른 결과(ts) = R11 없음 · R10 없음 · checklist_prev 그대로(1단계 실패는 R1 이 맡음)
    for (const x of got.filter(x => x.rule === 'R11')) w.update(x.id, { status: 'resolved' }, { by: 'test', what: '새 사건 확인용 종료' });
    const prevF = path.join(p.vibeDir, 'orch', 'checklist_prev', 'TST0001.json'); const prev0 = fs.readFileSync(prevF, 'utf8'); const prevJ = JSON.parse(prev0);
    fs.writeFileSync(path.join(vd, 'run_verify.result.json'), JSON.stringify({ started: '2026-11-19 16:00:00', ts: '2026-11-19T16:35:20', summary: { FAIL: 29, '판정필요': 0, '미검증': prevJ.unverified }, issues: prevJ.issues.map(s => { const [i, c] = s.split('|'); return { id: i, class: c }; }) }));
    const n5 = got.length;
    E('chain.end', { wb: 5, screen: 'TST0001', chain: 'checklist', chainLabel: '🔎 CheckList', runId: 'c5', ok: false, failNo: 1, claudeRan: 0, claudeSkipped: 1, scriptRan: 1, ms: Date.now(), ms_run: 60000 });
    const add5 = got.slice(n5);
    chk('체인 시작보다 이전 ts의 결과 파일이면 R11 없음 · R10 없음 · checklist_prev 그대로', r11(n5) === 0 && !add5.some(x => x.rule === 'R10') && fs.readFileSync(prevF, 'utf8') === prev0, add5.map(x => x.rule).join(',') || '0건');
    for (const x of got.filter(x => x.rule === 'R11')) w.update(x.id, { status: 'resolved' }, { by: 'test', what: '새 사건 확인용 종료' }); // 같은 서명 열린 사건이 있으면 새로 만들지 않으므로 닫는다
    const n6 = got.length;
    resN(loc(Date.now() - 30000), 5);
    E('chain.end', { wb: 6, screen: 'TST0001', chain: 'checklist', chainLabel: '🔎 CheckList', runId: 'c6', ok: true, claudeRan: 0, claudeSkipped: 1, scriptRan: 1, ms: Date.now(), ms_run: 60000 });
    chk('체인 시작 뒤 결과로 chain.end = R11 1건', r11(n6) === 1, String(r11(n6)));
  }
  // VS Code 종료(dispose) = 두 화면 user.stop(why vscode.dispose) 뒤 step.end FAIL([FAIL] 줄), chain.end = R1, R2, R11 0건 · 반복 이력 0건 (개선안 20261120005403_INC)
  {
    const sigH = () => { try { return JSON.parse(fs.readFileSync(path.join(p.vibeDir, 'orch', 'sig_history.json'), 'utf8')); } catch { return {}; } };
    const jid = 'J20261120_003352'; const nD = got.length;
    for (const scr of ['TST0012', 'TST0013']) E('user.stop', { wb: `${jid}:${scr}`, screen: scr, job: jid, by: 'VS Code 종료', why: 'vscode.dispose', ms: Date.now() });
    for (const scr of ['TST0012', 'TST0013']) {
      const wbD = `${jid}:${scr}`;
      E('step.end', { wb: wbD, screen: scr, runId: `d-${scr}`, chainLabel: '🔎 CheckList', no: 1, name: 'S8.checklistRun', task: 'S8.checklistRun', actor: 'script', status: 'FAIL', exit: 1, ms_run: 5000, why: '[FAIL] 중지됨', sig: 'S8.checklistRun | [FAIL] 중지됨' });
      E('chain.end', { wb: wbD, screen: scr, chain: 'checklist', chainLabel: '🔎 CheckList', runId: `d-${scr}`, ok: false, failNo: 1, claudeRan: 0, claudeSkipped: 1, scriptRan: 1, ms: Date.now(), ms_run: 60000 });
    }
    const addD = got.slice(nD).map(x => x.rule);
    chk('VS Code 종료(dispose) 뒤 두 화면 FAIL = R1, R2, R11 0건 · 반복 이력 0건', addD.length === 0 && !sigH()['S8.checklistRun | [FAIL] 중지됨'], addD.join(',') || '0건');
  }
  // 같은 runId·단계 step.end FAIL 2번 = R1 1건, R2 없음 · init 이전 ms 의 step.end FAIL = 사건 0건 · 끝난 VM pid 의 FAIL = 반복 집계 제외 (개선안 20261120005059_INC)
  {
    const sigH = () => { try { return JSON.parse(fs.readFileSync(path.join(p.vibeDir, 'orch', 'sig_history.json'), 'utf8')); } catch { return {}; } };
    const n7 = got.length; const fd = { wb: 7, screen: 'TST0009', runId: 'rd1', chainLabel: '중복', no: 2, name: 'S8.dup', task: 'S8.dup', actor: 'script', status: 'FAIL', exit: 1, ms_run: 1000, why: 'dup', sig: 'S8.dup | dup' };
    E('step.end', fd); E('step.end', fd);
    const add7 = got.slice(n7).map(x => x.rule);
    const inc7 = got.slice(n7).find(x => x.rule === 'R1');
    chk('같은 runId step.end FAIL 2번 = R1 1건 · R2 없음', add7.join(',') === 'R1' && w.get(inc7.id).count === 1 && (sigH()['S8.dup | dup'] || []).length === 1, `${add7.join(',')} · count ${inc7 && w.get(inc7.id).count} · 이력 ${(sigH()['S8.dup | dup'] || []).length}`);
    const n8 = got.length;
    st.apply({ at: '', ms: w.health().initMs - 1000, type: 'step.end', src: 'vm', pid: me, wb: 8, screen: 'TST0010', runId: 'old1', chainLabel: '이전', no: 1, name: 'S8.old', task: 'S8.old', actor: 'script', status: 'FAIL', exit: 1, ms_run: 1000, why: 'old', sig: 'S8.old | old' });
    chk('init 이전 ms 의 step.end FAIL = 사건 0건', got.length === n8 && !sigH()['S8.old | old'], String(got.length - n8));
    const n9 = got.length;
    for (const r of ['cut1', 'cut2']) E('step.end', { wb: 9, screen: 'TST0011', runId: r, chainLabel: '끊김', no: 1, name: 'S8.cut', task: 'S8.cut', actor: 'script', status: 'FAIL', exit: 1, ms_run: 1000, why: 'cut', sig: 'S8.cut | cut', pid: 999996 });
    const add9 = got.slice(n9).map(x => x.rule);
    chk('끝난 VM pid 의 FAIL 2건 = R2 없음 · 이력 0건', !add9.includes('R2') && !sigH()['S8.cut | cut'], `${add9.join(',')} · 이력 ${(sigH()['S8.cut | cut'] || []).length}`);
  }
  // 저장·조회·상태 변경
  const all = w.list(); chk('사건 파일 저장', all.length === got.length, `${all.length}/${got.length}`);
  const u = w.update(got[0].id, { status: 'resolved' }, { by: 'test', what: '확인' }); chk('사건 상태 변경·조치 기록', u && u.status === 'resolved' && u.actions.length === 1);
  console.log('사건 목록:'); for (const x of w.list().reverse()) console.log('  ', x.rule, x.screen || '-', '|', x.title);
  w.dispose(); st.dispose(); await sleep(50);
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
