// 사용자 중지 시험(2026-11-20 J20261120_060728 09:57): 중지 뒤 체인이 실패로 받아 다음 단계·보완을 띄우지 않는지. 틀은 t_chain_runner.js 와 같음
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
const slowJs = W('tools/t/slow.js', "setTimeout(()=>process.exit(0),8000);console.log('slow start');");
tasks['T.slow'] = { id: 'T.slow', title: '오래 걸리는 작업', kind: 'node', script: slowJs, args: [], cwd: root };
(async () => {
  const chain = { kind: 'chain', label: '중지 시험', chainId: 'tstop', steps: [
    { task: 'T.slow', title: '1. 오래 걸림(선택 단계)', optional: true },
    { claude: '화면 ${id} 보완', title: '2. Claude 보완' },
    { task: 'T.ok', title: '3. 산출물' },
  ] };
  const steps = [];
  const r = new ChainRunner(api, { id: 'tst0002', jobId: 'J2', autoAnswer: false, onLog: () => { }, onStep: s => steps.push(s), onNote: () => { } });
  const t0 = Date.now(); const pr = r.run(chain);
  setTimeout(() => r.stop(), 1500);
  const a = await pr; const sec = (Date.now() - t0) / 1000;
  chk('중지 → 체인 CANCEL', a.status === 'CANCEL', JSON.stringify({ status: a.status, summary: a.summary }).slice(0, 200));
  chk('중지 뒤 Claude 단계 실행 안 함', calls() === 0, `calls=${calls()}`);
  chk('중지 뒤 3단계 산출물 없음', !fs.existsSync(path.join(root, 'out', 'tst0002.txt')));
  const ends = events().filter(e => e.type === 'step.end').map(e => `${e.no}:${e.status}`);
  chk('1단계 CANCEL 로 끝남', ends.includes('1:CANCEL'), ends.join(','));
  chk('2·3단계 step.start 없음', !events().some(e => e.type === 'step.start' && e.no > 1));
  chk('중지 뒤 바로 끝남(8초 작업을 기다리지 않음)', sec < 7, `${sec.toFixed(1)}s`);
  // 같은 실행기로 다시 실행하면 중지 표시가 지워져 정상 진행
  const r2 = new ChainRunner(api, { id: 'tst0003', jobId: 'J3', autoAnswer: false, onLog: () => { }, onStep: () => { }, onNote: () => { } });
  const b = await r2.run({ kind: 'chain', label: '다시', chainId: 't2', steps: [{ task: 'T.ok', title: '1' }] });
  chk('새 실행은 정상 완료', b.status === 'OK', b.status);
  r.dispose && r.dispose(); r2.dispose && r2.dispose();
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
