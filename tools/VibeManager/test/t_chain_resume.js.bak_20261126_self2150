// 작업 재개 시험(2026-11-20 사용자 지시 '창 다시 로드 뒤 작업 재개'): 다시 로드(실행기 stop + abortRunningChains)로 끊긴 체인은 진행 기록이 남고 끊긴 단계부터 재개 · 정상 종료·사용자 중지는 기록 삭제 · 체인 정의가 바뀌면 재개 거부
//   사용: node test/t_chain_runner.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const toasts = [];
const vs = new Proxy({}, { get: (t, k) => {
  if (k === 'window') return new Proxy({}, { get: (t2, k2) => (...a) => { if (/^show/.test(String(k2))) toasts.push(`${String(k2)}: ${a[0]}`); return Promise.resolve(undefined); } });
  if (k === 'commands') return { executeCommand: () => Promise.resolve(), registerCommand: () => ({ dispose() { } }) };
  if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] };
  if (k === 'Uri') return { file: f => ({ fsPath: f }), parse: s => s };
  if (k === 'ViewColumn') return { Active: 1, Beside: 2 };
  return function () { };
} });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'chain-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', llmReview: false }));
W('.vibe/quick.json', JSON.stringify({ groups: [] }));
const okJs = W('tools/t/ok.js', "const fs=require('fs'),path=require('path');const id=process.argv[2];const d=path.join(process.cwd(),'out');fs.mkdirSync(d,{recursive:true});fs.writeFileSync(path.join(d,id+'.txt'),'made');console.log('[INFO] made '+id);");
const badJs = W('tools/t/bad.js', "console.log('[FAIL] 선행 자료 없음: files.csv');process.exit(6);");
const fake = W('.vibe/fake_claude.js', `
const fs=require('fs'),path=require('path');let inp='';let done=false;process.stdin.on('data',d=>{inp+=d;if(inp.includes('\\n'))go();});
function go(){if(done)return;done=true;const out=o=>console.log(JSON.stringify(o));fs.appendFileSync(path.join('.vibe','calls.txt'),'call\\n');
 out({type:'system',subtype:'init',session_id:'s1'});out({type:'assistant',message:{content:[{type:'text',text:'보완 완료'}]}});
 out({type:'result',is_error:false,num_turns:1,duration_ms:5,total_cost_usd:0.01,session_id:'s1'});}
`);
const fakeCmd = W('.vibe/fake_claude.cmd', `@node "${fake}" %*\r\n`);
const tasks = {
  'T.ok': { id: 'T.ok', title: '산출물 만들기', kind: 'node', script: okJs, args: ['${input:id}'], cwd: root },
  'T.bad': { id: 'T.bad', title: '실패하는 작업', kind: 'node', script: badJs, args: [], cwd: root },
};
const p = { root, vibeDir, extDir: dir, genDir: path.join(root, 'Doc', 'gen'), outDir: path.join(root, 'Doc', 'asisfacts'), tobeDir: path.join(root, 'nscm-fe'), promptsDir: path.join(root, 'prompts'), node: 'node', python: 'python', powershell: 'powershell', claude: fakeCmd, claudeModel: '', permissionMode: 'bypassPermissions', language: 'ko' };
const records = [];
const api = {
  ctx: { workspaceState: { get: () => { throw new Error('창 없는 실행기가 workspaceState 를 읽음'); }, update: () => { throw new Error('창 없는 실행기가 workspaceState 를 씀'); } }, extensionPath: dir },
  paths: () => p, loadSteps: () => ({}), findTask: id => tasks[id] || null,
  collectInputs: async (task, preset) => Object.assign({}, p, { inputs: Object.assign({}, preset || {}) }),
  subst: (text, vars) => String(text == null ? '' : text).replace(/\$\{(input:)?([A-Za-z0-9_]+)\}/g, (m, isIn, n) => isIn ? (vars.inputs && vars.inputs[n] != null ? vars.inputs[n] : '') : (vars[n] != null ? String(vars[n]) : m)),
  buildArgs: (task, vars) => (task.args || []).map(a => api.subst(a, vars)).filter(x => x !== ''),
  openPath: () => { }, pageDirOf: () => '', menuSections: () => [], claudeEnv: () => ({}),
  runTaskById: async () => 0, record: (k, note) => records.push(`${k}: ${note}`), afterTask: () => { },
};
const { ChainRunner } = require(path.join(dir, 'chain-runner'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const R = rel => fs.readFileSync(path.join(root, rel), 'utf8');
const events = () => { try { return R('.vibe/orch/events.jsonl').trim().split('\n').map(l => JSON.parse(l)); } catch { return []; } };
const calls = () => { try { return R('.vibe/calls.txt').trim().split('\n').length; } catch { return 0; } };
const cntJs = W('tools/t/cnt.js', "const fs=require('fs'),path=require('path');const k=process.argv[2];const f=path.join(process.cwd(),'out','cnt_'+k+'.txt');fs.mkdirSync(path.dirname(f),{recursive:true});fs.appendFileSync(f,'x');");
const slowJs = W('tools/t/slow2.js', "const fs=require('fs'),path=require('path');if(fs.existsSync(path.join(process.cwd(),'fast.flag')))process.exit(0);setTimeout(()=>process.exit(0),8000);");
tasks['T.c1'] = { id: 'T.c1', title: '1단계', kind: 'node', script: cntJs, args: ['a'], cwd: root };
tasks['T.slow2'] = { id: 'T.slow2', title: '2단계(오래 걸림)', kind: 'node', script: slowJs, args: [], cwd: root };
tasks['T.c3'] = { id: 'T.c3', title: '3단계', kind: 'node', script: cntJs, args: ['c'], cwd: root };
const wbm = require(path.join(dir, 'workbench'));
const cnt = k => { try { return fs.readFileSync(path.join(root, 'out', `cnt_${k}.txt`), 'utf8').length; } catch { return 0; } };
const progFiles = () => { try { return fs.readdirSync(path.join(vibeDir, 'orch', 'chain_progress')); } catch { return []; } };
(async () => {
  const chain = { kind: 'chain', label: '재개 시험', chainId: 'tresume', steps: [{ task: 'T.c1', title: '1. 첫 단계' }, { task: 'T.slow2', title: '2. 오래 걸림' }, { task: 'T.c3', title: '3. 끝 단계' }] };
  const r1 = new ChainRunner(api, { id: 'res0001', jobId: 'J9', autoAnswer: false, onLog: () => { }, onStep: () => { }, onNote: () => { } });
  const pr = r1.run(chain);
  setTimeout(() => { r1.stop(); wbm.abortRunningChains('시험: 창 다시 로드'); }, 1800); // 다시 로드 순서 = job-runner.dispose(stop) → abortRunningChains
  await pr;
  chk('끊긴 체인 = 진행 기록 남음', progFiles().length === 1, progFiles().join(','));
  const list = wbm.resumable(p, { screen: 'res0001' });
  chk('재개 목록 1건 · 2단계부터 · 1단계 결과 OK 보관', list.length === 1 && list[0].resumeFrom === 2 && list[0].res[0] && list[0].res[0].status === 'OK' && !!list[0].interruptedAt, JSON.stringify(list.map(x => ({ from: x.resumeFrom, res: x.res, at: x.interruptedAt }))));
  // 개선안 20261120184524_SELF_2: 재개 기록 쓰기·지우기 사건
  const evOf = (type, runId, why) => events().filter(e => e.type === type && e.runId === runId && (why == null || e.why === why));
  { const c = evOf('progress.cut', list[0].runId); chk('다시 로드 뒤 progress.cut 1줄(runId · 화면 · job · 2단계부터)', c.length === 1 && c[0].screen === 'RES0001' && c[0].job === 'J9' && c[0].resumeFrom === 2, JSON.stringify(c)); }
  chk('재개 목록 거르기: job·화면', wbm.resumable(p, { job: 'J9' }).length === 1 && wbm.resumable(p, { screen: 'OTHER1' }).length === 0 && wbm.resumable(p, { noJob: true }).length === 0);
  W('fast.flag', '1');
  const r2 = new ChainRunner(api, { id: 'res0001', jobId: 'J9', autoAnswer: false, onLog: () => { }, onStep: () => { }, onNote: () => { } });
  const b = await r2.run(chain, { resume: list[0] });
  chk('재개 실행 완료(OK)', b.status === 'OK', JSON.stringify({ s: b.status, sum: b.summary }));
  chk('1단계 다시 실행 안 함(1회), 3단계 실행(1회)', cnt('a') === 1 && cnt('c') === 1, `a=${cnt('a')} c=${cnt('c')}`);
  chk('재개 결과에 1단계 = 이전 실행 결과 표시', (b.steps || [])[0] && /이전 실행 결과\(재개\)/.test(b.steps[0].note || ''), JSON.stringify((b.steps || [])[0]));
  chk('재개 체인 정상 종료 = 기록 모두 삭제', progFiles().length === 0, progFiles().join(','));
  // 2026-11-20 재개 표시: chain.resume 사건 = 전체 단계 수 + 앞 단계 이전 실행 결과 · VMO 상태가 앞 단계를 이전 결과로 채움
  const rsv = events().filter(e => e.type === 'chain.resume').pop();
  chk('재개 사건: 전체 3단계 · 2단계부터 · 1단계 이전 결과 OK', rsv && rsv.steps === 3 && rsv.resumeFrom === 2 && rsv.carried.length === 1 && rsv.carried[0].no === 1 && rsv.carried[0].status === 'OK' && rsv.resumedFrom === list[0].runId, JSON.stringify(rsv && { s: rsv.steps, f: rsv.resumeFrom, c: rsv.carried }));
  { const d = evOf('progress.drop', list[0].runId); chk('재개 시작 뒤 progress.drop why resume 1줄(끊긴 runId)', d.length === 1 && d[0].why === 'resume' && d[0].job === 'J9', JSON.stringify(d)); }
  { const d = evOf('progress.drop', rsv && rsv.runId); chk('재개 체인 정상 종료 뒤 progress.drop why normalEnd 1줄', d.length === 1 && d[0].why === 'normalEnd', JSON.stringify(d)); }
  { const ost = require(path.join(dir, 'orch-state')); const cs = events().filter(e => e.type === 'chain.start' && e.runId === rsv.runId).pop(); ost.apply(Object.assign({}, cs, { type: 'chain.start' })); ost.apply(rsv);
    const ch = ost.snapshot().chains.find(c => c.runId === rsv.runId);
    chk('VMO 상태: 전체 3단계 · 1단계 = 이전 실행 결과(carried) · 재개 2단계부터 · 이번 실행 끝난 단계 0', ch && ch.total === 3 && ch.done.length === 1 && ch.done[0].carried === true && ch.resumeFrom === 2 && ch.doneNew === 0, JSON.stringify(ch && { t: ch.total, d: ch.done, f: ch.resumeFrom })); }
  // 사용자 중지 = 기록 삭제
  fs.unlinkSync(path.join(root, 'fast.flag'));
  const r3 = new ChainRunner(api, { id: 'res0002', jobId: '', autoAnswer: false, onLog: () => { }, onStep: () => { }, onNote: () => { } });
  const p3 = r3.run(chain); setTimeout(() => r3.stop(), 1800); await p3;
  chk('사용자 중지 = 진행 기록 없음(재개 대상 아님)', progFiles().length === 0 && wbm.resumable(p, { screen: 'res0002' }).length === 0, progFiles().join(','));
  // 체인 정의가 바뀌면 재개 거부
  const r4 = new ChainRunner(api, { id: 'res0003', jobId: '', autoAnswer: false, onLog: () => { }, onStep: () => { }, onNote: () => { } });
  const p4 = r4.run(chain); setTimeout(() => { r4.stop(); wbm.abortRunningChains('시험'); }, 1800); await p4;
  const rec = wbm.resumable(p, { screen: 'res0003' })[0];
  const chain2 = Object.assign({}, chain, { steps: chain.steps.concat([{ task: 'T.c3', title: '4. 새 단계' }]) });
  const r5 = new ChainRunner(api, { id: 'res0003', jobId: '', autoAnswer: false, onLog: () => { }, onStep: () => { }, onNote: () => { } });
  const c5 = await r5.run(chain2, { resume: rec });
  chk('체인 정의가 바뀜 = 재개 거부(BLOCKED · 사유)', c5.status === 'BLOCKED' && /체인 정의/.test(c5.summary || ''), JSON.stringify({ s: c5.status, sum: c5.summary }));
  chk('거부되면 기록은 남음', wbm.resumable(p, { screen: 'res0003' }).length === 1);
  // 사용자 삭제(Workbench resumeDrop): 처리기가 why userDrop 으로 지움 · 지운 뒤 사건 1줄 · 없는 기록은 사건 없음
  { const src = fs.readFileSync(path.join(dir, 'workbench.js'), 'utf8'); const blk = (src.split("case 'resumeDrop'")[1] || '').split('case ')[0];
    chk("resumeDrop 처리기 = progDel(p, rec.runId, 'userDrop')", /progDel\(p, rec\.runId, 'userDrop'\)/.test(blk)); }
  const del = wbm._progDel(p, rec.runId, 'userDrop'); const again = wbm._progDel(p, rec.runId, 'userDrop');
  { const d = evOf('progress.drop', rec.runId, 'userDrop'); chk('resumeDrop 뒤 progress.drop why userDrop 1줄 · 기록 없음', del === true && again === false && d.length === 1 && wbm.resumable(p, { screen: 'res0003' }).length === 0, JSON.stringify(d)); }
  // 개선안 20261125000907_VISION 재개 원장 ①: 11-23 18:46 재현(events.jsonl progress.cut runId WB1_1795427182442_ai, screen '').
  //   화면 ID 없는 체인 밖 AI 대화가 창 다시 로드로 끊김 → 원장에 화면 ID 빈 기록이 생기지 않고, screen '' 인 progress.cut 사건도 없어야 함
  { const rid = 'WB1_1795427182442_ai'; const lc = wbm._liveChains;
    const prog = { runId: rid, screen: '', chainId: 'claude', label: 'AI 대화 · 18:46 재현', kind: 'claude', single: true, wb: 1, job: '', t0: Date.now(), steps: 1, sig: 'claude', res: [], shown: [0], cur: 0, curActor: 'claude', ownerPid: process.pid, updatedMs: Date.now(), sub: { session: '' } };
    const w0 = typeof wbm._progWrite === 'function' ? wbm._progWrite(p, Object.assign({}, prog)) : null;
    lc.set(rid, { p, evCh: { wb: 1, screen: '', job: '' }, t0: Date.now(), prog, single: true, wb: null }); wbm.abortRunningChains('시험: 18:46 재현 창 다시 로드');
    const blank = progFiles().map(n => { try { return JSON.parse(fs.readFileSync(path.join(vibeDir, 'orch', 'chain_progress', n), 'utf8')); } catch { return {}; } }).filter(r => !String(r.screen || '').trim());
    const cutBlank = events().filter(e => e.type === 'progress.cut' && !String(e.screen || '').trim());
    chk('18:46 재현: 화면 ID 빈 원장 기록 0건 · 쓰기 거부', blank.length === 0 && !fs.existsSync(path.join(vibeDir, 'orch', 'chain_progress', `${rid}.json`)) && w0 === false, `blank ${blank.length} · write ${w0}`);
    chk("18:46 재현: screen '' progress.cut 사건 0줄 · 거부 사건 progress.refuse 기록", cutBlank.length === 0 && events().some(e => e.type === 'progress.refuse' && e.runId === rid), `cut '' ${cutBlank.length}`);
    // 옛 형식 기록(화면 ID 빈 값)이 원장에 남아 있어도 세 창 조회에 나오지 않음
    fs.mkdirSync(path.join(vibeDir, 'orch', 'chain_progress'), { recursive: true }); fs.writeFileSync(path.join(vibeDir, 'orch', 'chain_progress', `${rid}.json`), JSON.stringify(Object.assign({}, prog, { interruptedAt: '2026-11-23T18:46:32+09:00', resumeFrom: 1, updatedMs: Date.now() })));
    chk('옛 빈 화면 기록 = 원장 조회 제외(VMO 에만 보이던 18:46 형태)', typeof wbm.ledgerView === 'function' && !wbm.ledgerView(p, 'vmo').some(r => r.runId === rid) && !wbm.resumable(p).some(r => r.runId === rid));
    try { fs.unlinkSync(path.join(vibeDir, 'orch', 'chain_progress', `${rid}.json`)); } catch { } }
  // 원장 상태 필드: 끊긴 기록 = state cut, 실행 중 = running
  { const r6 = new ChainRunner(api, { id: 'res0006', jobId: 'J6', autoAnswer: false, onLog: () => { }, onStep: () => { }, onNote: () => { } });
    const p6 = r6.run(chain); await new Promise(r => setTimeout(r, 1200));
    const live = progFiles().map(n => JSON.parse(fs.readFileSync(path.join(vibeDir, 'orch', 'chain_progress', n), 'utf8'))).find(r => r.screen === 'RES0006');
    setTimeout(() => { r6.stop(); wbm.abortRunningChains('시험'); }, 300); await p6;
    const cut = wbm.ledgerView ? wbm.ledgerView(p, 'vmo').find(r => r.screen === 'RES0006') : null;
    chk('원장 상태: 실행 중 running → 끊김 cut', !!live && live.state === 'running' && !!cut && cut.state === 'cut', JSON.stringify({ live: live && live.state, cut: cut && cut.state }));
    if (cut) wbm._progDel(p, cut.runId, 'userDrop'); try { r6.dispose(); } catch { } }
  [r1, r2, r3, r4, r5].forEach(r => { try { r.dispose(); } catch { } });
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
