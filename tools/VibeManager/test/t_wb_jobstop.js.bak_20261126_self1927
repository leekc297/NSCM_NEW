// 2026-11-25 사용자 'VMW 에서 CHECKLIST 실행 후 WORKBENCH 로 연결한 경우 중지 버튼이 보이지 않음' — VMW 작업이 이 화면을 돌리는 동안 Workbench 창 busy 에 job=true(중지 단추 표시), 끝나면 false, 중지 요청이 그 화면을 멈춤
//   사용: node test/t_job_mirror.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const vs = new Proxy({}, { get: (t, k) => {
  if (k === 'window') return new Proxy({}, { get: () => () => Promise.resolve(undefined) });
  if (k === 'commands') return { executeCommand: () => Promise.resolve(), registerCommand: () => ({ dispose() { } }) };
  if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] };
  if (k === 'Uri') return { file: f => ({ fsPath: f }), parse: s => s };
  return function () { };
} });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'job-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', llmReview: false }));
// 작업: 화면 ID 가 fail.txt 에 있으면 실패(exit 6), 아니면 산출물 생성. slow.txt 에 있으면 1.5초 걸림
const docJs = W('tools/t/doc.js', "const fs=require('fs'),path=require('path');const id=process.argv[2];const has=f=>{try{return fs.readFileSync(path.join(process.cwd(),f),'utf8').split(/\\s+/).includes(id)}catch{return false}};fs.appendFileSync(path.join(process.cwd(),'order.txt'),id+'\\n');if(has('fail.txt')){console.log('[FAIL] 분석 자료 없음: '+id);process.exit(6);}const go=()=>{const d=path.join(process.cwd(),'out');fs.mkdirSync(d,{recursive:true});fs.writeFileSync(path.join(d,id+'.xlsx'),'doc');console.log('[INFO] 설계서 생성 '+id);};if(has('slow.txt'))setTimeout(go,1500);else go();");
const chain = { label: '📝 문서 생성 시험', kind: 'chain', chainId: 'docs', batch: true, steps: [{ task: 'T.doc', title: '1. 설계서', verify: { type: 'fileExists', fresh: true, file: '${root}/out/${id}.xlsx' } }, { task: 'T.doc', title: '2. 재수행', askUser: '다시?', askYes: '실행' }] };
W('.vibe/quick.json', JSON.stringify({ groups: [{ title: 'g', items: [chain, { label: '서버', kind: 'terminal', batch: true }, { label: '배치 아님', kind: 'chain', steps: [{ task: 'T.doc' }] }] }] }));
const tasks = { 'T.doc': { id: 'T.doc', title: '설계서 만들기', kind: 'node', script: docJs, args: ['${input:id}'], cwd: root } };
const p = { root, vibeDir, extDir: dir, genDir: path.join(root, 'Doc', 'gen'), outDir: path.join(root, 'Doc', 'asisfacts'), tobeDir: path.join(root, 'nscm-fe'), promptsDir: path.join(root, 'prompts'), node: 'node', python: 'python', powershell: 'powershell', claude: 'claude', claudeModel: '', permissionMode: 'bypassPermissions', language: 'ko' };
const api = { ctx: { workspaceState: { get: () => undefined, update: () => { } }, extensionPath: dir }, paths: () => p, loadSteps: () => ({}), findTask: id => tasks[id] || null,
  collectInputs: async (task, preset) => Object.assign({}, p, { inputs: Object.assign({}, preset || {}) }),
  subst: (text, vars) => String(text == null ? '' : text).replace(/\$\{(input:)?([A-Za-z0-9_]+)\}/g, (m, isIn, n) => isIn ? (vars.inputs && vars.inputs[n] != null ? vars.inputs[n] : '') : (vars[n] != null ? String(vars[n]) : m)),
  buildArgs: (task, vars) => (task.args || []).map(a => api.subst(a, vars)).filter(x => x !== ''), openPath: () => { }, pageDirOf: () => '', menuSections: () => [], claudeEnv: () => ({}), runTaskById: async () => 0, record: () => { }, afterTask: () => { } };
const jr = require(path.join(dir, 'job-runner')); jr.init(api);
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const R = rel => fs.readFileSync(path.join(root, rel), 'utf8'); const sleep = t => new Promise(r => setTimeout(r, t));
const waitEnd = async (id, ms = 40000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { const j = jr.get(id); if (!/^(running|pausing)$/.test(j.status)) { await sleep(150); return j; } await sleep(100); } return jr.get(id); };
const wbm = require(path.join(dir, 'workbench')); const M = wbm._mirror; const panels = M.panels();
const fake = id => { const got = []; const w = { got, titleId: id, api, panel: { webview: { postMessage: m => { got.push(m); } } }, getState: () => ({ id }) }; panels.add(w); return w; };
const txt = w => w.got.filter(m => m.type === 'out').map(m => m.text).join('');

const fakeWb = id => { const got = []; const w = { got, titleId: id, api, headless: false, orch: false, procs: new Map(), claudeProc: null, panel: { webview: { postMessage: m => { got.push(m); } } }, getState: () => ({ id }) };
  w.post = m => { got.push(m); }; w.updateBusy = M.updateBusy; panels.add(w); return w; };
const lastBusy = w => w.got.filter(m => m.type === 'busy').pop() || null;
(async () => {
  W('slow.txt', 'TST0001');
  const A = fakeWb('TST0001'); const C = fakeWb('TST0009');
  const j = jr.create({ itemLabel: chain.label, screens: ['TST0001'], onFail: 'continue', autoAnswer: false });
  jr.start(j.id);
  let seen = false; const t0 = Date.now(); while (Date.now() - t0 < 10000) { const b = lastBusy(A); if (b && b.job) { seen = true; break; } await sleep(50); }
  chk('VMW 작업 실행 중: 같은 화면 창 busy job=true(중지 단추 표시)', seen, JSON.stringify(lastBusy(A)));
  chk('실행 중 표시 문구에 VMW 작업 번호', !!lastBusy(A) && (lastBusy(A).labels || []).some(x => x.includes(j.id)), JSON.stringify(lastBusy(A)));
  chk('다른 화면 창: job 표시 없음', !C.got.some(m => m.type === 'busy' && m.job));
  chk('창 자신의 실행이 없어도 job 으로 켜짐', !!lastBusy(A) && lastBusy(A).procs === 0 && !lastBusy(A).claude);
  chk('실행 중 화면 = runningScreen 이 작업 번호', jr.runningScreen('TST0001') === j.id && jr.runningScreen('TST0009') === '');
  const done = await waitEnd(j.id);
  chk('작업 끝', !!done && done.screens.every(s => s.status !== 'run'), done && done.screens.map(s => `${s.id}:${s.status}`).join(' '));
  chk('작업 끝 뒤: busy job=false(중지 단추 숨김)', !!lastBusy(A) && lastBusy(A).job === false, JSON.stringify(lastBusy(A)));
  // 중지: 실행 중에 창에서 중지 → 그 화면 VMW 작업이 멈춤
  const j2 = jr.create({ itemLabel: chain.label, screens: ['TST0001'], onFail: 'continue', autoAnswer: false }); jr.start(j2.id);
  const t1 = Date.now(); while (Date.now() - t1 < 10000 && !jr.runningScreen('TST0001')) await sleep(30);
  chk('실행 중 창에서 중지 = VMW 화면 중지 요청', M.mirrorStop(A) === true);
  const d2 = await waitEnd(j2.id);
  chk('중지 뒤 작업 끝 · job=false', !!d2 && !jr.runningScreen('TST0001') && lastBusy(A).job === false, d2 && d2.screens.map(s => `${s.id}:${s.status}`).join(' '));
  panels.clear(); try { jr.dispose(); } catch { } try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
