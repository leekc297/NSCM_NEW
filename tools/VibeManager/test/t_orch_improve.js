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
 const tu=[];
 if(mode==='apply-out'){const t=path.join('tools','VibeManager','test','t_out.js');const o=fs.readFileSync(t,'utf8');fs.writeFileSync(t,o.replace('const n = 1;','const n = 1;\\nconst ai = 2;'));tu.push({type:'tool_use',id:'e1',name:'Edit',input:{file_path:path.resolve(t),old_string:'const n = 1;',new_string:'const n = 1;\\nconst ai = 2;'}});fs.appendFileSync(path.join('tools','VibeManager','other_s.js'),'// 다른 세션 편집\\n');}
 out({type:'system',subtype:'init',session_id:'s'});
 if(tu.length)out({type:'assistant',message:{content:tu}});
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
    chk('집계: 끝 사건 없는 대기 1건(사라진 대기 1건 제외) · 화면 목록 · 사라진 대기 1건', wd && wd.started === 3 && wd.unfinished === 1 && wd.unfinishedLive === 0 && wd.unfinishedScreens.join(',') === 'TST0092' && wd.gone === 1 && wd.goneSec === 1749 && wd.n === 1 && wd.totalSec === 30, JSON.stringify(wd));
    chk('집계: 기존 항목은 그대로(admit 3건 1500초)', wa2 && wa2.n === 3 && wa2.totalSec === 1500 && wa2.unfinished === 0);
    chk('집계: 끝 사건 없는 Claude 호출 1건', d2.claude.started === 3 && d2.claude.calls === 2 && d2.claude.unfinished === 1, JSON.stringify(d2.claude)); }
  // 개선안 20261120115806_VISION: 끊긴 체인 끝 기록에 실행 단계 수 · chain.start 뒤 chain.end 없는 체인 = 끝 기록 없음
  { const Module = require('module'); const vs = new Proxy({}, { get: (t, k) => { if (k === 'window') return new Proxy({}, { get: () => () => Promise.resolve(undefined) }); if (k === 'commands') return { executeCommand: () => Promise.resolve(), registerCommand: () => ({ dispose() { } }) }; if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] }; if (k === 'Uri') return { file: f => ({ fsPath: f }), parse: s => s }; return function () { }; } });
    const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
    const wbm = require(path.join(dir, 'workbench')); Module._load = orig;
    const t0 = Date.now() - 60000; const evA = { wb: 7, screen: 'TSTA001', chain: 'abtest', chainLabel: 'CheckList', runId: `TSTA001_${t0}`, job: '' };
    ev.emit('chain.start', Object.assign({ steps: 3, shown: 3 }, evA));
    wbm._liveChains.set(evA.runId, { p, evCh: evA, t0, prog: { runId: evA.runId, screen: 'TSTA001', res: [{ no: 1, name: 'Claude 검토', status: 'OK', code: 0, sec: 10, actor: 'claude', task: '' }], cur: 1, curActor: 'script', curTask: 'S8.checklistRun', steps: 3 } });
    wbm.abortRunningChains('시험: 창 다시 로드');
    const evB = { wb: 8, screen: 'TSTB001', chain: 'notend', chainLabel: 'CheckList', runId: `TSTB001_${t0}`, job: '' };
    ev.emit('chain.start', Object.assign({ steps: 2, shown: 2 }, evB));
    const d4 = im.digest(7); const ca = d4.chains.find(x => x.chain === 'abtest'); const cb = d4.chains.find(x => x.chain === 'notend');
    const endA = fs.readFileSync(ev.file(), 'utf8').split(/\r?\n/).filter(Boolean).map(l => JSON.parse(l)).find(e => e.type === 'chain.end' && e.runId === evA.runId);
    chk('abort 끝 기록: Claude 1단계 실행 뒤 끊김 → claudeRan 1 · scriptRan 1(돌던 단계)', endA && endA.aborted === true && endA.claudeRan === 1 && endA.scriptRan === 1 && endA.claudeSkipped === 0, JSON.stringify(endA && { claudeRan: endA.claudeRan, scriptRan: endA.scriptRan, rows: endA.rows }));
    chk('집계: Claude 1단계 실행 뒤 abort 된 체인 → claudeRan 1, 끝 기록 없음 0', ca && ca.n === 1 && ca.claudeRan === 1 && ca.runsWithoutClaude === 0 && ca.noEnd === 0, JSON.stringify(ca));
    chk('집계: chain.start 만 있는 체인 → 끝 기록 없음 1', cb && cb.n === 0 && cb.noEnd === 1 && cb.noEndScreens.join(',') === 'TSTB001' && d4.chainsNoEnd === 1, JSON.stringify(cb) + ' total ' + d4.chainsNoEnd);
    chk('abortCounts: 기록 없는 체인 = 0', JSON.stringify(wbm.abortCounts(null)) === JSON.stringify({ claudeRan: 0, claudeSkipped: 0, scriptRan: 0, rows: [] })); }
  // 중지된 실행은 실패와 따로 센다(개선안 20261120094530_REVIEW): step.end FAIL 2건 중 1건 뒤에 같은 화면 job.item.end cancel → fail 1 · stopped 1
  ev.emit('step.end', { task: 'S8.stopTest', name: 'CheckList', actor: 'script', status: 'FAIL', ms_run: 1000, screen: 'TSTS001' });
  ev.emit('chain.end', { chain: 'stoptest', chainLabel: 'CheckList', ok: false, ms_run: 1000, screen: 'TSTS001' });
  ev.emit('proc.end', { label: 'stoptest proc', exit: 1, ms_run: 1000, server: false, stopped: false, screen: 'TSTS001' });
  ev.emit('job.item.end', { screen: 'TSTS001', status: 'cancel', ms_run: 1000 });
  ev.emit('step.end', { task: 'S8.stopTest', name: 'CheckList', actor: 'script', status: 'FAIL', ms_run: 1000, screen: 'TSTS002' });
  ev.emit('chain.end', { chain: 'stoptest', chainLabel: 'CheckList', ok: false, ms_run: 1000, screen: 'TSTS002' });
  ev.emit('proc.end', { label: 'stoptest proc', exit: 1, ms_run: 1000, server: false, stopped: false, screen: 'TSTS002' });
  ev.emit('job.item.end', { screen: 'TSTS002', status: 'fail', ms_run: 1000 });
  ev.emit('proc.end', { label: 'stoptest proc', exit: 1, ms_run: 1000, server: false, stopped: true, screen: 'TSTS003' });
  // 개선안 20261125123144_REVIEW_2: 단계 끝 CANCEL · stopped true = 중지(stoppedBy) · stopped false(AI 사용 불가) = cancel · 둘 다 중앙값에서 뺌
  ev.emit('step.end', { task: 'S8.cancelTest', actor: 'script', status: 'OK', ms_run: 1000, screen: 'TSTC001' });
  ev.emit('step.end', { task: 'S8.cancelTest', actor: 'script', status: 'CANCEL', stopped: true, note: '취소 사유: 사용자 중지', ms_run: 9000000, screen: 'TSTC002' });
  ev.emit('step.end', { task: 'S8.cancelTest', actor: 'script', status: 'CANCEL', stopped: false, note: 'AI 사용 불가', ms_run: 5000000, screen: 'TSTC003' });
  { const d3 = im.digest(7); const s3 = d3.steps.find(x => x.key === 'S8.stopTest'); const c3 = d3.chains.find(x => x.chain === 'stoptest'); const p3 = d3.procFails.find(x => x.label === 'stoptest proc'); const s8 = d3.steps.find(x => x.key === 'S8.checklistRun');
    chk('집계: 중지 따로 셈(단계 fail 1 · stopped 1)', s3 && s3.n === 2 && s3.fail === 1 && s3.stopped === 1, JSON.stringify(s3));
    chk('집계: 중지 따로 셈(체인 ok 0 · stopped 1 · 프로세스 fail 1 · stopped 2)', c3 && c3.n === 2 && c3.ok === 0 && c3.stopped === 1 && p3 && p3.n === 3 && p3.fail === 1 && p3.stopped === 2 && p3.exits[1] === 1, JSON.stringify(c3) + JSON.stringify(p3));
    chk('집계: 화면 없는 기존 실패는 그대로 fail', s8 && s8.fail === 1 && s8.stopped === 0, JSON.stringify(s8));
    const sc4 = d3.steps.find(x => x.key === 'S8.cancelTest');
    chk('집계: CANCEL stopped true = stopped 1, stoppedBy 1, fail 0', sc4 && sc4.n === 3 && sc4.stopped === 1 && Object.values(sc4.stoppedBy).reduce((a, b) => a + b, 0) === 1 && sc4.fail === 0, JSON.stringify(sc4));
    chk('집계: 중지 원인 other 경로 기록(개선안 20261126214605_REVIEW) = stoppedOther 길이 = stoppedBy.other, 경로 표시만 있음', sc4 && Array.isArray(sc4.stoppedOther) && sc4.stoppedOther.length === sc4.stoppedBy.other && sc4.stoppedOther.length === 1 && sc4.stoppedOther[0].path === '표시만 있음' && sc4.stoppedOther[0].screen === 'TSTC002' && Array.isArray(sc4.stoppedNoBy), JSON.stringify(sc4 && { o: sc4.stoppedOther, b: sc4.stoppedBy }));
    chk('집계: CANCEL stopped false = cancel 1, 취소 소요는 중앙값과 p90 에서 빠짐(1초), cancelSec 14000', sc4 && sc4.cancel === 1 && sc4.medianSec === 1 && sc4.p90Sec === 1 && sc4.cancelSec === 14000, JSON.stringify(sc4)); }
  chk('분석 예정 판단(이력 없음 = 예정)', im.reviewDue() === true);
  // 개선안 20261122000421_SELF: verify 작성 규칙 공용 상수(VERIFY_RULE)가 지시문 5종에 들어가고, 반영 지시에 '편집 전에' 반영 전 값 재기가 들어감
  const prompts = []; const origRun = agent.runClaude; agent.runClaude = (pr, o) => { prompts.push({ label: (o && o.label) || '', pr: String(pr) }); return origRun(pr, o); };
  const VR = im.VERIFY_RULE;
  chk('VERIFY_RULE: 반영 전 값 → 반영 뒤 기대 · 대상 밖 절대값 금지 문구', typeof VR === 'string' && VR.includes('반영 전 N → 반영 뒤 기대 M') && VR.includes('대상 밖 파일 상태에 걸린 절대값을 적지 않는다') && VR.includes('targets 변경으로만 달라지는 값'), VR);
  { const sc = require(path.join(dir, 'orch-selfcheck')); const vi = require(path.join(dir, 'orch-vision')); const la = require(path.join(dir, 'orch-ladder'));
    // 재현: 232523_SELF(대상 tools/Docs/doc_style.py, 검증이 대상 밖 tabview.js 위반 0건에 걸려 실패)의 입력으로 자가진단 지시문을 만든다
    W('.vibe/orch/selfcheck/diag_in.json', JSON.stringify({ failed: [{ id: '20261119232523_SELF', targets: ['tools/Docs/doc_style.py'], evidence: 'tools/Docs/doc_style.py:96 _STR 정규식이 주석과 정규식 리터럴을 가리지 않음', before_after: '.js 는 // 주석, /* */ 주석, 정규식 리터럴을 건너뛴 뒤 문자열만 뽑음' }] }));
    const dp = sc.diagPrompt({ proposalMaxPerDiag: 5 }, '.vibe/orch/selfcheck/diag_in.json');
    chk('자가진단 지시문에 VERIFY_RULE(재현 232523_SELF 입력)', dp.includes(VR) && dp.includes('대상 밖 파일 상태에 걸린 절대값을 적지 않는다') && dp.includes('.vibe/orch/selfcheck/diag_in.json'));
    chk('반영 실패 진단 지시문에 VERIFY_RULE', sc.repairPrompt('.vibe/orch/selfcheck/repair_x.json').includes(VR));
    vi.init({ paths: () => p, noTimer: true, memDir: path.join(root, 'mem'), planFile: path.join(root, 'plan.md'), vmDir: path.join(root, 'tools', 'VibeManager') });
    let vp = ''; try { vp = vi.buildPrompt({ visionMaxPerRun: 3 }); } catch (e) { vp = `ERR ${e.message}`; }
    chk('Overall Review 지시문에 VERIFY_RULE', vp.includes(VR), vp.slice(0, 80));
    chk('L3 진단 지시문에 VERIFY_RULE', la.structPrompt({ key: 'L3|applyfail|doc_style.py', runs: [] }).includes(VR)); }
  // 개선안 20261122130655_REVIEW: 집계 code = 창 로드 시각 · 설치본보다 오래된 파일 · 창 로드 대기 반영 건수
  { const d0 = im.digest(7); chk('집계 code: 창 로드 기록 없음 → staleFiles 0 · waitingReload 0', d0.code && d0.code.loadedAt === '' && d0.code.staleFiles.length === 0 && d0.code.waitingReload === 0, JSON.stringify(d0.code));
    const ext = path.join(root, 'ext_vm'); const loadMs = Date.now() - 60000; W('ext_vm/old.js', 'x\n'); fs.utimesSync(path.join(ext, 'old.js'), new Date(loadMs - 60000), new Date(loadMs - 60000)); W('ext_vm/new.js', 'y\n'); W('ext_vm/note.md', 'z\n');
    W('.vibe/orch/activations.jsonl', JSON.stringify({ at: 'x', kind: 'lock.stopclean', info: true }) + '\n' + JSON.stringify({ at: 'x', ms: loadMs, pid: 424242, version: 't', extDir: ext }) + '\n');
    const pf = path.join(vibeDir, 'orch', 'proposals', 'T_RELOAD.json'); fs.mkdirSync(path.dirname(pf), { recursive: true });
    fs.writeFileSync(pf, JSON.stringify({ id: 'T_RELOAD', status: 'applied', needsReload: true, appliedMs: Date.now(), title: '창 로드 대기 시험', history: [] }));
    const d5 = im.digest(7); const dj = JSON.parse(fs.readFileSync(path.join(vibeDir, 'orch', 'digest.json'), 'utf8'));
    chk('집계 code: 수정 시각이 로드 뒤인 .js 1개 · 창 로드 대기 1건 · digest.json 에 code', d5.code.staleFiles.length === 1 && d5.code.staleFiles[0].file === 'new.js' && d5.code.waitingReload === 1 && d5.code.loadedPid === 424242 && !!d5.code.loadedAt && dj.code && dj.code.staleFiles.length === 1, JSON.stringify(d5.code));
    fs.unlinkSync(pf); } // 아래 분석 시험의 개선안 수(1건)에 섞이지 않게 지움. activations·ext_vm 은 남겨 분석 지시문 첫 줄을 본다
  // 개선안 20261123000946_VISION: 반영 완료(appliedMs)와 효력 시작(effectiveMs) 분리. 재현 = 20261122000421_SELF(needsReload, appliedMs 11-22 00:21:04) · activations 마지막 창 로드 11-21 01:59:17
  { const af = path.join(vibeDir, 'orch', 'activations.jsonl'); const keepAct = fs.readFileSync(af, 'utf8');
    const AP = Date.parse('2026-11-22T00:21:04+09:00'), LD = Date.parse('2026-11-21T01:59:17+09:00');
    fs.writeFileSync(af, JSON.stringify({ at: '2026-11-21T01:59:17+09:00', ms: LD, pid: 1 }) + '\n' + JSON.stringify({ at: 'x', ms: AP + 1000, kind: 'lock.stopclean' }) + '\n');
    const pf = path.join(vibeDir, 'orch', 'proposals', '20261122000421_SELF.json');
    fs.writeFileSync(pf, JSON.stringify({ id: '20261122000421_SELF', status: 'applied', needsReload: true, appliedMs: AP, title: 'verify 작성 규칙 공용화', history: [{ at: '2026-11-22T00:21:04+09:00', by: 'VMO', what: '반영 완료 · 검증 통과.' }] }));
    const p0 = im.get('20261122000421_SELF'); const n0 = im.markEffective(); const p1 = im.get('20261122000421_SELF'); const w0 = im.reloadWait();
    chk('효력 (1) needsReload 안, 반영 뒤 창 로드 없음(kind 줄 제외) → effectiveMs 없음 · 효력 전 null · 로드 대기 1건', im.effectiveMsOf(p0) === null && n0 === 0 && p1.effectiveMs === undefined && w0.n === 1 && w0.ids[0] === '20261122000421_SELF' && /^2026-11-22T00:21/.test(w0.oldestAt) && im.codeInfo().waitingReload === 1, JSON.stringify({ eff: im.effectiveMsOf(p0), n0, w0 }));
    chk('효력: needsReload 아닌 안 = appliedMs 가 효력 시각', im.effectiveMsOf({ status: 'applied', appliedMs: AP }) === AP);
    const L2 = AP + 3600000; fs.appendFileSync(af, JSON.stringify({ at: 'y', ms: L2, pid: 2 }) + '\n');
    const n1 = im.markEffective(); const p2 = im.get('20261122000421_SELF');
    chk('효력: 반영 뒤 창 로드가 생기면 effectiveMs = 그 로드 시각 · 기록 1줄 · 로드 대기 0건', n1 === 1 && p2.effectiveMs === L2 && im.effectiveMsOf(p2) === L2 && p2.history.some(h => /^효력 시작/.test(h.what)) && im.reloadWait().n === 0 && im.markEffective() === 0, JSON.stringify({ n1, eff: p2.effectiveMs }));
    p2.appliedMs = L2 + 1000; fs.writeFileSync(pf, JSON.stringify(p2));
    chk('효력: 다시 반영(appliedMs 가 effectiveMs 뒤) = 옛 effectiveMs 버림 → 효력 전', im.effectiveMsOf(im.get('20261122000421_SELF')) === null);
    fs.unlinkSync(pf); fs.writeFileSync(af, keepAct); }
  // 분석 → 개선안 등록(근거 없는 안 제외) · 읽기 전용 호출
  setMode('review'); const rv = await im.review(true);
  let ps = im.list();
  chk('분석 → 개선안 1건 등록(근거 없는 안 제외)', rv.ok && rv.added === 1 && ps.length === 1 && ps[0].status === 'pending', JSON.stringify(rv));
  chk('분석은 읽기 전용 권한으로 호출', calls().slice(-1)[0] === 'review|readonly', calls().join(','));
  chk('상시 분석 지시문에 VERIFY_RULE', prompts.some(x => x.label === '상시 분석' && x.pr.includes(VR)), prompts.map(x => x.label).join(','));
  { const rp = prompts.find(x => x.label === '상시 분석'); const first = rp ? rp.pr.split('\n')[0] : '';
    chk('상시 분석 지시문 첫 줄 = 집계 코드가 설치본보다 오래됨: 파일 1개, 창 로드 대기 반영 0건', first.startsWith('집계 코드가 설치본보다 오래됨: 파일 1개, 창 로드 대기 반영 0건') && first.includes('new.js'), first.slice(0, 120)); }
  chk('분석 뒤 다음 분석은 예정 아님 · 알림 1회', im.reviewDue() === false && notes.length === 1, notes.join('|'));
  chk('창 연 뒤 첫 상시 분석 확인(R254): 주기 전이면 돌지 않음 · init 이 firstReview 예약', im._firstReview() === false && /firstTimer = setTimeout\(firstReview/.test(fs.readFileSync(path.join(dir, 'orch-improve.js'), 'utf8')));
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
  chk('반영 지시문에 편집 전 verify 실행(반영 전 값)', prompts.filter(x => /^개선안 반영/.test(x.label)).length === 2 && prompts.filter(x => /^개선안 반영/.test(x.label)).every(x => x.pr.includes('편집 전에') && x.pr.includes(im.VERIFY_PRE)));
  agent.runClaude = origRun;
  const a3 = await im.approve(id, '사용자'); chk('반영 완료 건은 다시 승인 불가', a3.ok === false);
  // 되돌리기
  const rb = im.revert(id, '사용자'); chk('되돌리기 → 대상 파일 복원 · 승인 대기로', rb.ok && R('tools/E2E/e2e.config.json').includes('120') && im.get(id).status === 'pending', JSON.stringify(rb.done));
  // 2026-11-23 사용자 지적 'FIX항목을 승인해도 반영이 안 됨': 에이전트가 다른 조치 중일 때 사람 승인은 버리지 않고 대기 → 비면 자동 반영
  { let release; const hold = agent.withLock('시험 잠금', () => new Promise(r => { release = r; })); await sleep(20);
    const nCalls = calls().length;
    const auB = await im.approve(id, 'VMO 자동(게이트 통과 조건)'); chk('바쁠 때 VMO 자동 승인 = 대기 표시 없이 busy', auB.why === 'busy' && !auB.queued && !im.get(id).approvedWait && im.get(id).status === 'pending');
    const q1 = await im.approve(id, '사용자'); const q2 = await im.approve(id, '사용자'); const pq = im.get(id);
    chk('바쁠 때 사람 승인 = 승인 접수(approvedWait) · 승인 대기 상태 · 다시 승인해도 기록 1번', q1.queued === true && q2.queued === true && pq.status === 'pending' && pq.approvedWait && pq.approvedWait.by === '사용자' && pq.history.filter(h => /승인 접수/.test(h.what)).length === 1, JSON.stringify(pq.history.slice(-3)));
    chk('바쁠 때 Claude 호출 없음', calls().length === nCalls);
    chk('바쁠 때 대기 승인 반영 안 함', (await im.pumpApprovals()) === '' && im.get(id).status === 'pending');
    release(); await hold; setMode('apply-ok');
    const pid = await im.pumpApprovals(); const pa = im.get(id);
    chk('에이전트가 비면 대기 승인 자동 반영 · approvedWait 지움', pid === id && pa.status === 'applied' && !pa.approvedWait && R('tools/E2E/e2e.config.json').includes('60') && pa.history.some(h => /대기한 승인으로 반영 시작/.test(h.what)), JSON.stringify(pa.history.slice(-3).map(h => h.what.slice(0, 60))));
    im.revert(id, '사용자'); }
  // 2026-11-23 개선안 20261123145412_VISION: 반영은 에이전트 자리를 먼저 잡고 진행 · 반영 중 다른 일은 busy · 끝나면 자리를 놓음
  { const run0 = agent.runClaude; let seen = null; agent.runClaude = async (p, o) => { const other = await agent.withLock('다른 일', async () => 'ran'); seen = { busy: agent.status().busy, cur: agent.status().current, other }; return run0(p, o); };
    setMode('apply-ok'); const ra = await im.approve(id, '사용자'); agent.runClaude = run0;
    chk('반영은 자리를 잡은 채 진행: 반영 중 다른 일 = busy · 끝나면 자리 놓음', ra.ok === true && seen && seen.busy === true && seen.cur === `prop_${id}` && seen.other && seen.other.busy === true && agent.status().busy === false, JSON.stringify([ra, seen]));
    im.revert(id, '사용자'); }
  // 개선안 20261123145412_VISION_2: 반영 실패 = 실행 기록의 AI 편집을 대상 밖 파일까지 되돌림 · 같은 시각 다른 쪽이 고친 대상 밖 파일은 그대로
  //   재현 = 000419_VISION 11:31, 13:13(대상 밖 t_orch_usercheck.js 시험 편집이 '그대로 남음')
  { const outRel = 'tools/VibeManager/test/t_out.js', othRel = 'tools/VibeManager/other_s.js'; W(outRel, '// 시험\nconst n = 1;\n'); W(othRel, '// 다른 세션 파일\n'); await sleep(50);
    setMode('apply-out'); const ao = await im.approve(id, '사용자'); const po = im.get(id); const fl = po.history.filter(h => /^반영 실패/.test(h.what)).slice(-1)[0] || { what: '' };
    chk('반영 실패: 대상 밖 시험 파일에 넣은 AI Edit 되돌림 · 실패 문구 대상 밖 변경에 그 파일 없음', ao.ok === false && po.status === 'apply-failed' && R(outRel) === '// 시험\nconst n = 1;\n' && R('tools/E2E/e2e.config.json').includes('120') && !/대상 밖 변경[^·]*t_out\.js/.test(fl.what) && po.history.some(h => /대상 밖 파일 AI 편집 되돌림: .*t_out\.js/.test(h.what)), JSON.stringify([R(outRel), fl.what.slice(-200)]));
    chk('반영 실패: 같은 시각 다른 쪽이 고친 대상 밖 파일은 그대로 · 문구에 남은 파일로 표시', R(othRel) === '// 다른 세션 파일\n// 다른 세션 편집\n' && /대상 밖 변경 [^·]*other_s\.js 는 AI 가 고치지 않아 그대로 남음/.test(fl.what), fl.what.slice(-200)); }
  // 반려 → 같은 안 재등록 불가
  im.reject(id, '간격을 줄이면 BE 풀 고갈', '사용자');
  const again = im.add({ title: '입장 간격 120초 → 60초', evidence: 'x', sig: 'admit ramp' }, 'review');
  chk('반려 사유 기록 · 같은 서명 재등록 불가', im.get(id).status === 'rejected' && im.get(id).reason.includes('BE 풀') && again.dup === id && again.status === 'rejected');
  // 개선안 20261120181921_SELF_2: 반영 중 다른 작업이 바꾼 파일(Doc/verify CheckList 결과)은 CHANGELOG 파일 목록·되돌리기 줄에 없고 개수만
  { W('tools/VibeManager/CHANGELOG.md', '# CHANGELOG\n'); W('tools/VibeManager/orch-x.js', 'x\n'); W('tools/VibeManager/orch-x.js.bak_20261120_self1548', 'x\n'); W('tools/VibeManager/orch-y.js', 'y\n');
    const okCl = im.changelogSelf({ id: 'T_SELF', title: '시험', evidence: 'e', before_after: 'b' }, { verify_result: 'ALL PASS' }, ['tools/VibeManager/orch-x.js', 'tools/VibeManager/orch-y.js', 'tools/VibeManager/test/t_x.js', 'Doc/verify/SCP0028/e2e_results.json', 'Doc/verify/SCP0028/fixlist.csv'], { text: 'OK' }, { copied: [] }, '20261120_self1548', false, { kept: ['tools/VibeManager/orch-x.js', 'tools/VibeManager/orch-y.js'], ai: ['tools/vibemanager/orch-x.js', 'tools/VibeManager/test/t_x.js'] });
    const sec = R('tools/VibeManager/CHANGELOG.md').split('# CHANGELOG')[0]; const chg = (sec.match(/^- 변경:.*$/m) || [''])[0]; const back = (sec.match(/^- 되돌리기:.*$/m) || [''])[0];
    chk('CHANGELOG: 대상 밖 Doc/verify 파일 → 파일 목록·되돌리기 줄에 없음 · 개수 2개만', okCl && !/Doc\/verify/.test(sec) && /orch-x\.js, tools\/VibeManager\/orch-y\.js, tools\/VibeManager\/test\/t_x\.js\./.test(chg) && /대상 밖 변경 2개\(다른 작업\)/.test(chg), chg);
    chk('CHANGELOG: 되돌리기 줄 = .bak_ 사본 있는 대상만', back.includes('orch-x.js.bak_20261120_self1548') && !back.includes('orch-y.js.bak_') && !back.includes('t_x.js.bak_'), back); }
  // 개선안 20261127005352_SELF: CHANGELOG 쓰기 실패 주입 → 대기 파일 1줄 → 다음 호출 때 두 절 모두 쓰고 대기 파일 0줄
  { const fr = require('../fs-retry'); const orig = fr.writeFileSyncRetry; const pf = path.join(vibeDir, 'orch', 'changelog_pending.jsonl');
    const cnt = () => { try { return fs.readFileSync(pf, 'utf8').split(/\r?\n/).filter(Boolean).length; } catch { return 0; } };
    W('tools/VibeManager/CHANGELOG.md', '# CHANGELOG\n');
    fr.writeFileSyncRetry = () => { const e = new Error('EBUSY 주입'); e.code = 'EBUSY'; throw e; };
    let ok1; try { ok1 = im.changelogSelf({ id: 'T_FAIL1', title: '실패 절', evidence: 'e', before_after: 'b' }, null, ['tools/VibeManager/orch-x.js'], { text: 'OK' }, { copied: [] }, 't1', false); } finally { fr.writeFileSyncRetry = orig; }
    const n1 = cnt(); const ok2 = im.changelogSelf({ id: 'T_OK2', title: '성공 절', evidence: 'e', before_after: 'b' }, null, ['tools/VibeManager/orch-x.js'], { text: 'OK' }, { copied: [] }, 't2', false);
    const n2 = cnt(); const cl = R('tools/VibeManager/CHANGELOG.md');
    chk('CHANGELOG 쓰기 실패 → 대기 파일 1줄 → 다음 호출 뒤 0줄 · 두 절 모두 있음', ok1 === false && n1 === 1 && ok2 === true && n2 === 0 && cl.includes('개선안 T_FAIL1 승인') && cl.includes('개선안 T_OK2 승인') && cl.indexOf('# CHANGELOG') > cl.indexOf('T_FAIL1'), `ok1=${ok1} n1=${n1} ok2=${ok2} n2=${n2}`); }
  const m = im.meta(); chk('상태 조회', m.enabled === true && m.pending === 0 && !!m.lastAt, JSON.stringify(m).slice(0, 160));
  im.dispose(); agent.dispose(); watch.dispose(); st.dispose(); await sleep(100);
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
