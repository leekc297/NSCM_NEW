// chain-runner.js 시험 — 임시 폴더에서 workbench.js 의 실제 체인 실행기(_runChain)를 창 없이 돌린다(가짜 vscode · 가짜 claude · node 작업).
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
(async () => {
  chk('지원 종류 판별', ChainRunner.supports({ kind: 'chain' }) && ChainRunner.supports({ kind: 'task' }) && ChainRunner.supports({ kind: 'claude', flow: [{}] }) && !ChainRunner.supports({ kind: 'claude' }) && !ChainRunner.supports({ kind: 'terminal' }));
  // 1) 체인: 스크립트 → Claude → 승인 필요 단계(답 없음 = 건너뜀) → 앞 단계가 건너뜀이면 실행 안 함
  const chain = { kind: 'chain', label: '시험 체인', chainId: 'tchain', steps: [
    { task: 'T.ok', title: '1. 산출물', verify: { type: 'fileExists', fresh: true, file: '${root}/out/${id}.txt' } },
    { claude: '화면 ${id} 보완', title: '2. Claude 보완' },
    { task: 'T.ok', title: '3. 승인 뒤 재수행', askUser: '다시 수행할까요?', askYes: '실행' },
    { task: 'T.ok', title: '4. 재분류', ifPrevRan: true },
  ] };
  const logs = [], steps = [], notes = [];
  const r1 = new ChainRunner(api, { id: 'tst0001', jobId: 'J1', autoAnswer: false, onLog: t => logs.push(t), onStep: s => steps.push(s), onNote: t => notes.push(t) });
  const a = await r1.run(chain);
  chk('체인 완료(OK)', a.ok && a.status === 'OK', JSON.stringify({ status: a.status, summary: a.summary }).slice(0, 200));
  chk('단계 결과 OK·OK·SKIP·SKIP', a.steps.map(s => s.status).join(',') === 'OK,OK,SKIP,SKIP', a.steps.map(s => s.status).join(','));
  chk('실행 주체 요약', /Script 1단계 · AI Agent 1회/.test(a.actorNote || ''), a.actorNote);
  chk('산출물 · FULLRUN.md', R('out/TST0001.txt') === 'made' && /시험 체인/.test(R('Doc/gen/TST0001/FULLRUN.md')) && a.md.replace(/\\/g, '/') === 'Doc/gen/TST0001/FULLRUN.md');
  chk('Claude 1회 호출', calls() === 1);
  chk('출력 대상으로 로그·단계 전달', logs.some(t => /made TST0001/.test(t)) && steps.some(s => s.kind === 'start' && s.steps.length === 2) && steps.filter(s => s.kind === 'step' && s.status === 'OK').length === 2 && steps.some(s => s.kind === 'end' && s.ok), `${logs.length}줄 · 단계 메시지 ${steps.length}`);
  chk('알림 창 없음(quiet)', toasts.length === 0, toasts.join(' | ').slice(0, 200));
  const ev = events();
  const cs = ev.find(e => e.type === 'chain.start'), ce = ev.find(e => e.type === 'chain.end');
  chk('사건 기록: 체인 시작·끝에 작업 번호·실행기 이름', cs && cs.job === 'J1' && /^job\d+$/.test(String(cs.wb)) && ce && ce.ok === true && ce.claudeRan === 1 && ce.scriptRan === 1, JSON.stringify(ce && { ok: ce.ok, claudeRan: ce.claudeRan, scriptRan: ce.scriptRan, job: ce.job, wb: ce.wb }));
  r1.dispose();
  // 2) 승인 답 = 예 → 3·4 단계도 실행
  const r2 = new ChainRunner(api, { id: 'TST0002', autoAnswer: true });
  const b = await r2.run(chain);
  chk('승인 답 예 = 4단계 모두 실행', b.ok && b.steps.map(s => s.status).join(',') === 'OK,OK,OK,OK', b.steps.map(s => s.status).join(','));
  r2.dispose();
  // 3) 실패 체인: 원인 줄이 결과에 남고 뒤 단계는 실행 안 함
  const r3 = new ChainRunner(api, { id: 'TST0003' });
  const c = await r3.run({ kind: 'chain', label: '실패 체인', chainId: 'tfail', steps: [{ task: 'T.bad', title: '1. 실패' }, { task: 'T.ok', title: '2. 뒤 단계' }] });
  chk('실패 체인 → FAIL · 원인 줄', !c.ok && c.status === 'FAIL' && c.fail.no === 1 && /선행 자료 없음/.test(c.fail.why) && c.steps[1].status === 'NOT_RUN' && !fs.existsSync(path.join(root, 'out', 'TST0003.txt')), JSON.stringify(c.fail).slice(0, 200));
  r3.dispose();
  // 4) 작업(task) 단독 · 5) flow 가 있는 Claude 메뉴 · 6) 지원하지 않는 종류
  const r4 = new ChainRunner(api, { id: 'TST0004' });
  const d = await r4.run({ kind: 'task', label: '작업 단독', task: 'T.ok' }); chk('작업 단독 실행', d.ok && d.status === 'OK' && d.code === 0 && fs.existsSync(path.join(root, 'out', 'TST0004.txt')));
  const e = await r4.run({ kind: 'task', label: '실패 작업', task: 'T.bad' }); chk('작업 실패 = FAIL · 원인', !e.ok && e.status === 'FAIL' && e.code === 6 && /선행 자료 없음/.test(e.summary), e.summary);
  const f = await r4.run({ kind: 'claude', label: 'flow 메뉴', flowId: 'tflow', flow: [{ task: 'T.ok', title: '분류' }] }); chk('flow 가 있는 Claude 메뉴 = 체인으로 실행', f.ok && f.steps.length === 1);
  const g = await r4.run({ kind: 'terminal', label: '서버' }); chk('지원하지 않는 종류', g.status === 'UNSUPPORTED');
  r4.dispose();
  // 7) 화면 2개 동시 실행(실행기 2개) — 서로 섞이지 않는다
  const r5 = new ChainRunner(api, { id: 'TST0005' }), r6 = new ChainRunner(api, { id: 'TST0006' });
  const [h, i] = await Promise.all([r5.run(chain), r6.run(chain)]);
  chk('실행기 2개 동시 실행', h.ok && i.ok && R('out/TST0005.txt') === 'made' && R('out/TST0006.txt') === 'made' && /TST0005/.test(R('Doc/gen/TST0005/FULLRUN.md')) && /TST0006/.test(R('Doc/gen/TST0006/FULLRUN.md')));
  r5.dispose(); r6.dispose();
  await new Promise(r => setTimeout(r, 700));
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
