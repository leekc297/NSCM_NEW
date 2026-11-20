// orch-improve.js 시험 — 임시 폴더 + 가짜 claude 로 집계 · 분석 · 승인 반영 · 검증 실패 복원 · 반려 · 되돌리기를 본다. 실제 Claude 호출 없음
//   사용: node test/t_orch_improve.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'improve-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); };
const R = rel => fs.readFileSync(path.join(root, rel), 'utf8');
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', orch: { agentEnabled: false, reviewEveryHours: 24, reviewDays: 7, proposalMaxPerReview: 5, agentTimeoutMin: 1 } }));
W('tools/E2E/e2e.config.json', '{"verifyAdmitRampSec":120}\n'); W('.gitignore', '.vibe/\n');
cp.execSync('git init -q && git add -A && git -c user.email=t@t -c user.name=t commit -q -m init', { cwd: root, windowsHide: true, stdio: 'ignore' });
const fake = path.join(root, '.vibe', 'fake_claude.js'); fs.mkdirSync(path.dirname(fake), { recursive: true });
fs.writeFileSync(fake, `
const fs=require('fs'),path=require('path');let inp='';let done=false;process.stdin.on('data',d=>{inp+=d;if(inp.includes('\\n'))go();});
function go(){if(done)return;done=true;const mode=fs.readFileSync(path.join('.vibe','mode.txt'),'utf8').trim();const out=o=>console.log(JSON.stringify(o));
 fs.appendFileSync(path.join('.vibe','calls.txt'),mode+'|'+(process.argv.includes('default')?'readonly':'edit')+'\\n');
 let j;
 if(mode==='review') j={proposals:[{title:'입장 간격 120초 → 60초',evidence:'wait admit 3건 합계 1500초(.vibe/orch/events.jsonl)',targets:['tools/E2E/e2e.config.json'],before_after:'verifyAdmitRampSec 120 → 60',verify:'python -c 1',rollback:'값 복원',sig:'admit ramp'},{title:'근거 없는 안',evidence:'',targets:[],before_after:'',verify:'',rollback:''}],summary:'대기 합계가 큼'};
 else { fs.writeFileSync(path.join('tools','E2E','e2e.config.json'),'{"verifyAdmitRampSec":60}\\n'); j={applied:true,verified:mode==='apply-ok',changed_files:['tools/E2E/e2e.config.json'],verify_result:mode==='apply-ok'?'OK 17:40':'검증 실패: 값 불일치',note:''}; }
 out({type:'system',subtype:'init',session_id:'s'});
 out({type:'assistant',message:{content:[{type:'text',text:'결과\\n\`\`\`json\\n'+JSON.stringify(j)+'\\n\`\`\`'}]}});
 out({type:'result',is_error:false,num_turns:1,duration_ms:5,total_cost_usd:0.02,session_id:'s'});setTimeout(()=>process.exit(0),50);}
`);
const fakeCmd = path.join(root, '.vibe', 'fake_claude.cmd'); fs.writeFileSync(fakeCmd, `@node "${fake}" %*\r\n`);
const setMode = m => fs.writeFileSync(path.join(vibeDir, 'mode.txt'), m);
const calls = () => { try { return fs.readFileSync(path.join(vibeDir, 'calls.txt'), 'utf8').trim().split('\n').filter(Boolean); } catch { return []; } };
const p = { root, vibeDir, claude: fakeCmd, claudeModel: '' };
const ev = require(path.join(dir, 'orch-events')); const st = require(path.join(dir, 'orch-state')); const watch = require(path.join(dir, 'orch-watch'));
const agent = require(path.join(dir, 'orch-agent')); const im = require(path.join(dir, 'orch-improve'));
ev.init(vibeDir); watch.init(p, {}); const notes = []; agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [] }); im.init({ notify: t => notes.push(t) });
let ok = true; const chk = (name, cond, extra) => { console.log(cond ? 'PASS' : 'FAIL', name, extra || ''); if (!cond) ok = false; };
const sleep = t => new Promise(r => setTimeout(r, t));
(async () => {
  // 집계용 사건 주입
  for (let i = 0; i < 3; i++) ev.emit('wait.end', { kind: 'admit', screen: 'TST000' + i, sec_wait: 500, gave_up: false });
  ev.emit('step.end', { task: 'S8.checklistRun', name: 'CheckList', actor: 'script', status: 'OK', ms_run: 600000 });
  ev.emit('step.end', { task: 'S8.checklistRun', name: 'CheckList', actor: 'script', status: 'FAIL', ms_run: 200000 });
  ev.emit('chain.end', { chain: 'checklist', chainLabel: 'CheckList', ok: false, ms_run: 800000, claudeRan: 0, claudeSkipped: 1 });
  ev.emit('claude.end', { exit: 0, ms_run: 30000, costUsd: 0.5 });
  watch.raise('R4', { screen: 'TST0001', sig: 'R4|admit|TST0001', title: '대기 지연', evidence: {} });
  await sleep(300); watch.update(watch.list()[0].id, { status: 'closed' });
  const d = im.digest(7);
  const wa = d.waits.find(x => x.kind === 'admit'); const sp = d.steps.find(x => x.key === 'S8.checklistRun'); const ch = d.chains.find(x => x.chain === 'checklist');
  chk('집계: 대기 3건 1500초', wa && wa.n === 3 && wa.totalSec === 1500, JSON.stringify(wa));
  chk('집계: 단계 2회 · 실패 1 · 합계 800초', sp && sp.n === 2 && sp.fail === 1 && sp.totalSec === 800, JSON.stringify(sp));
  chk('집계: Claude 없이 끝난 체인 1회', ch && ch.runsWithoutClaude === 1 && ch.ok === 0);
  chk('집계: Claude 1회 0.5 USD · 사건 R4 1건', d.claude.calls === 1 && d.claude.costUsd === 0.5 && d.incidents.byRule.R4 === 1, JSON.stringify(d.claude));
  // 끝 사건 없는 대기 2건(없는 PID) · wait.gone 1건 · 끝 사건 없는 Claude 호출 1건 → 집계에 unfinished 로 나온다(개선안 20261119193539_REVIEW_4)
  ev.emit('wait.start', { kind: 'dbwin', screen: 'TST0091', pid: 999991, src: 'py' }); ev.emit('wait.start', { kind: 'dbwin', screen: 'TST0092', pid: 999992, src: 'py' });
  ev.emit('wait.start', { kind: 'dbwin', screen: 'TST0093', pid: 999993, src: 'py' }); ev.emit('wait.end', { kind: 'dbwin', screen: 'TST0093', pid: 999993, src: 'py', sec_wait: 30, gave_up: false });
  ev.emit('wait.gone', { kind: 'dbwin', screen: 'TST0091', waiter_pid: 999991, sec_wait: 1749 }); for (let i = 0; i < 3; i++) ev.emit('claude.start', { wb: 0, source: 'orch' }); ev.emit('claude.end', { exit: 0, ms_run: 1000 }); // 시작 3 · 끝 2(앞에서 넣은 끝 1건 포함) = 끝 사건 없는 호출 1
  { const d2 = im.digest(7); const wd = d2.waits.find(x => x.kind === 'dbwin'); const wa2 = d2.waits.find(x => x.kind === 'admit');
    chk('집계: 끝 사건 없는 대기 2건 · 화면 목록 · 사라진 대기 1건', wd && wd.started === 3 && wd.unfinished === 2 && wd.unfinishedLive === 0 && wd.unfinishedScreens.join(',') === 'TST0091,TST0092' && wd.gone === 1 && wd.goneSec === 1749 && wd.n === 1 && wd.totalSec === 30, JSON.stringify(wd));
    chk('집계: 기존 항목은 그대로(admit 3건 1500초)', wa2 && wa2.n === 3 && wa2.totalSec === 1500 && wa2.unfinished === 0);
    chk('집계: 끝 사건 없는 Claude 호출 1건', d2.claude.started === 3 && d2.claude.calls === 2 && d2.claude.unfinished === 1, JSON.stringify(d2.claude)); }
  chk('분석 예정 판단(이력 없음 = 예정)', im.reviewDue() === true);
  // 분석 → 개선안 등록(근거 없는 안 제외) · 읽기 전용 호출
  setMode('review'); const rv = await im.review(true);
  let ps = im.list();
  chk('분석 → 개선안 1건 등록(근거 없는 안 제외)', rv.ok && rv.added === 1 && ps.length === 1 && ps[0].status === 'pending', JSON.stringify(rv));
  chk('분석은 읽기 전용 권한으로 호출', calls().slice(-1)[0] === 'review|readonly', calls().join(','));
  chk('분석 뒤 다음 분석은 예정 아님 · 알림 1회', im.reviewDue() === false && notes.length === 1, notes.join('|'));
  const rv2 = await im.review(true); chk('같은 안 다시 올리지 않음', rv2.added === 0 && rv2.dups === 1 && im.list().length === 1);
  const id = ps[0].id;
  chk('승인 전에는 대상 파일 그대로', R('tools/E2E/e2e.config.json').includes('120'));
  // 승인 → 반영 → 검증 실패 → 대상 파일 복원
  setMode('apply-bad'); const a1 = await im.approve(id, '사용자');
  chk('검증 실패 → 반영 실패 · 대상 파일 복원', a1.ok === false && im.get(id).status === 'apply-failed' && R('tools/E2E/e2e.config.json').includes('120'), im.get(id).history.slice(-1)[0].what.slice(0, 160));
  // 다시 승인 → 반영 완료
  setMode('apply-ok'); const a2 = await im.approve(id, '사용자');
  chk('승인 → 반영 완료 · 검증 통과', a2.ok === true && im.get(id).status === 'applied' && R('tools/E2E/e2e.config.json').includes('60'), im.get(id).history.slice(-1)[0].what.slice(0, 160));
  chk('반영은 수정 권한으로 호출', calls().slice(-1)[0] === 'apply-ok|edit');
  const a3 = await im.approve(id, '사용자'); chk('반영 완료 건은 다시 승인 불가', a3.ok === false);
  // 되돌리기
  const rb = im.revert(id, '사용자'); chk('되돌리기 → 대상 파일 복원 · 승인 대기로', rb.ok && R('tools/E2E/e2e.config.json').includes('120') && im.get(id).status === 'pending', JSON.stringify(rb.done));
  // 반려 → 같은 안 재등록 불가
  im.reject(id, '간격을 줄이면 BE 풀 고갈', '사용자');
  const again = im.add({ title: '입장 간격 120초 → 60초', evidence: 'x', sig: 'admit ramp' }, 'review');
  chk('반려 사유 기록 · 같은 서명 재등록 불가', im.get(id).status === 'rejected' && im.get(id).reason.includes('BE 풀') && again.dup === id && again.status === 'rejected');
  const m = im.meta(); chk('상태 조회', m.enabled === true && m.pending === 0 && !!m.lastAt, JSON.stringify(m).slice(0, 160));
  im.dispose(); agent.dispose(); watch.dispose(); st.dispose(); await sleep(100);
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
