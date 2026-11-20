// 체인 반복 묶음 시험(2026-11-20 CheckList 한 번 실행 구조): loops while 조건이 참인 동안 회차를 덧붙여 실행 · 거짓이면 끝 · 분류 결과가 갱신되지 않으면 끝 · late 단계는 끝에 1회 · 재개 때 회차 유지
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
// measure: 남은 수 n 을 tri.json 에 씀(continue = n>0). fix: 아무것도 안 함(횟수만). re: n 을 1 줄이고 tri.json 갱신. docs: 횟수만
const mJs = W('tools/t/m.js', "const fs=require('fs');fs.writeFileSync('n.txt',process.argv[2]);fs.writeFileSync('tri.json',JSON.stringify({continue:Number(process.argv[2])>0?1:0}));fs.appendFileSync('log.txt','M ');");
const fixJs = W('tools/t/fix.js', "const fs=require('fs');fs.appendFileSync('log.txt','F ');if(fs.existsSync('slow.flag'))setTimeout(()=>process.exit(0),8000);");
const reJs = W('tools/t/re.js', "const fs=require('fs');if(fs.existsSync('norewrite.flag')){fs.appendFileSync('log.txt','R- ');process.exit(0)}const n=Math.max(0,Number(fs.readFileSync('n.txt','utf8'))-1);fs.writeFileSync('n.txt',String(n));fs.writeFileSync('tri.json',JSON.stringify({continue:n>0?1:0}));fs.appendFileSync('log.txt','R ');");
const docJs = W('tools/t/doc.js', "require('fs').appendFileSync('log.txt','D ');");
Object.assign(tasks, { 'T.m': { id: 'T.m', title: '측정', kind: 'node', script: mJs, args: ['${input:n}'], cwd: root }, 'T.fix': { id: 'T.fix', title: '보완', kind: 'node', script: fixJs, args: [], cwd: root },
  'T.re': { id: 'T.re', title: '부분 재측정', kind: 'node', script: reJs, args: [], cwd: root }, 'T.docs': { id: 'T.docs', title: '문서', kind: 'node', script: docJs, args: [], cwd: root } });
const mk = n => ({ kind: 'chain', label: '반복 시험', chainId: 'tloop', loops: { fix: { while: { file: '${root}/tri.json', key: 'continue', gt: 0 } } }, steps: [
  { task: 'T.m', title: '1. 측정', args: [String(n)] }, { task: 'T.fix', title: '2. 보완', loop: 'fix' }, { task: 'T.re', title: '3. 부분 재측정', loop: 'fix' }, { task: 'T.docs', title: '4. 문서', late: true }] });
const log = () => { try { return R('log.txt').trim(); } catch { return ''; } };
const clear = () => { for (const f of ['log.txt', 'tri.json', 'n.txt', 'slow.flag', 'norewrite.flag']) try { fs.unlinkSync(path.join(root, f)); } catch { } };
const wbm = require(path.join(dir, 'workbench'));
const mkR = id => new ChainRunner(api, { id, jobId: '', autoAnswer: false, onLog: () => { }, onStep: () => { }, onNote: () => { } });
(async () => {
  let a = await mkR('lp0001').run(mk(2));
  chk('남은 2 → 2회차 반복 뒤 문서 1회', a.status === 'OK' && log() === 'M F R F R D', log() + ' ' + a.status);
  chk('단계 결과: 3회차는 건너뜀(반복 끝)', (a.steps || []).length === 8 && a.steps.filter(x => x.status === 'SKIP').length === 2 && /반복 끝/.test(a.steps[5].note || ''), JSON.stringify((a.steps || []).map(x => x.status)));
  clear(); a = await mkR('lp0002').run(mk(0));
  chk('남은 0 → 반복 없이 문서', log() === 'M D' && a.status === 'OK', log());
  clear(); W('norewrite.flag', '1'); a = await mkR('lp0003').run(mk(3));
  chk('분류 결과가 갱신되지 않으면 1회차 뒤 끝(무한 반복 없음)', log() === 'M F R- D', log());
  chk('끝 사유 기록', (a.steps || []).some(x => /갱신하지 않음/.test(x.note || '')));
  // first: 1회차만 다른 키(처리 대상 actionable 이 있으면 continue 0 이어도 시작)
  clear(); const m2 = W('tools/t/m2.js', "const fs=require('fs');fs.writeFileSync('n.txt','1');fs.writeFileSync('tri.json',JSON.stringify({continue:0,actionable:1}));fs.appendFileSync('log.txt','M ');");
  tasks['T.m2'] = { id: 'T.m2', title: '측정(정체 표시)', kind: 'node', script: m2, args: [], cwd: root };
  const c2 = mk(0); c2.steps[0] = { task: 'T.m2', title: '1. 측정' }; c2.loops.fix.first = { key: 'actionable' };
  a = await mkR('lp0005').run(c2);
  chk('first 키: 1회차는 처리 대상이 있으면 시작, 2회차부터 while 키', log() === 'M F R D', log());
  // 재개: 2회차 보완 단계에서 끊김 → 재개하면 2회차 보완부터, 앞 단계는 다시 안 돎
  clear(); const r1 = mkR('lp0004'); const pr = r1.run(mk(2));
  const t0 = Date.now(); while (Date.now() - t0 < 15000 && log() !== 'M F R') await new Promise(r => setTimeout(r, 50));
  W('slow.flag', '1'); while (Date.now() - t0 < 20000 && log() !== 'M F R F') await new Promise(r => setTimeout(r, 50));
  r1.stop(); wbm.abortRunningChains('시험: 창 다시 로드'); await pr;
  const rec = wbm.resumable(p, { screen: 'lp0004' })[0];
  chk('끊긴 기록에 회차 수 있음', rec && rec.loopRounds && rec.loopRounds.fix >= 2 && rec.resumeFrom === 4, JSON.stringify(rec && { lr: rec.loopRounds, from: rec.resumeFrom }));
  fs.unlinkSync(path.join(root, 'slow.flag')); fs.writeFileSync(path.join(root, 'log.txt'), '');
  const b = await mkR('lp0004').run(mk(2), { resume: rec });
  chk('재개 = 2회차 보완부터 끝까지(측정·1회차 다시 안 돎)', b.status === 'OK' && log() === 'F R D', log() + ' ' + b.status + ' ' + (b.summary || ''));
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
