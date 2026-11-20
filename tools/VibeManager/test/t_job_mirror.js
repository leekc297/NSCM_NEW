// 업무 작업 ↔ Workbench 공유(2026-11-20 사용자 지시) — 업무 작업창이 돌리는 화면의 출력, 단계 보드, 이력이 같은 화면 ID 의 Workbench 창에 보이는지
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
(async () => {
  const A = fake('TST0001');            // 작업 시작 전에 화면 ID 를 지정해 둔 창
  const C = fake('TST0009');            // 다른 화면 창
  const j = jr.create({ itemLabel: chain.label, screens: ['TST0001', 'TST0002'], onFail: 'continue', autoAnswer: false });
  jr.start(j.id); const done = await waitEnd(j.id);
  chk('작업 끝', done.screens.every(s => s.status === 'done' || s.status === 'warn' || s.status === 'hold'), done.screens.map(s => `${s.id}:${s.status}`).join(' '));
  chk('같은 화면 창: 머리 줄 + 작업 출력', txt(A).includes(`VMW ${j.id} · TST0001`) && A.got.filter(m => m.type === 'out').length > 1, txt(A).slice(0, 300));
  chk('같은 화면 창: 단계 보드 시작, 단계, 끝', ['start', 'step', 'end'].every(s => A.got.some(m => m.type === 'fb' && m.state === s)), JSON.stringify(A.got.filter(m => m.type === 'fb').map(m => m.state)));
  chk('같은 화면 창: 다른 화면(TST0002) 머리 줄 없음', !A.got.some(m => m.type === 'out' && /업무 작업 \S+ · TST0002/.test(m.text)));
  chk('다른 화면 창: 업무 작업 내용 없음', C.got.filter(m => m.type !== 'history').length === 0, JSON.stringify(C.got.map(m => m.type)));
  await sleep(3500);
  chk('열린 창 전부: 이력 갱신 2종', ['rev', 'task'].every(v => A.got.some(m => m.type === 'history' && m.view === v)) && C.got.some(m => m.type === 'history'));
  // 나중에 화면 ID 를 지정한 창 = 처음부터 다시 받음(1번만)
  const B = fake('TST0002'); const r1 = M.mirrorAttach(B); const n1 = B.got.length; const r2 = M.mirrorAttach(B);
  chk('나중에 연 창: 쌓아 둔 내용 전달', r1 === true && txt(B).includes(`VMW ${j.id} · TST0002`) && B.got.some(m => m.type === 'fb' && m.state === 'end'), `${n1}건`);
  chk('나중에 연 창: 두 번 보내지 않음', r2 === false && B.got.length === n1);
  // 이력 파일에 업무 작업 번호
  const hd = path.join(vibeDir, 'history', 'TST0001'); const metas = fs.readdirSync(hd).map(n => JSON.parse(fs.readFileSync(path.join(hd, n, 'meta.json'), 'utf8')));
  chk('이력 기록에 업무 작업 번호', metas.length > 0 && metas.every(m => m.job === j.id), JSON.stringify(metas.map(m => [m.task, m.job])));
  const th = require(path.join(dir, 'history')).innerHtml(p, 'date', '', 'all', 'task');
  chk('Task History 행에 업무 작업 표시', th.includes(`업무 작업 ${j.id} 에서 실행`));
  // VS Code 다시 로드 뒤(메모리 없음) = 기록 파일로 보임
  M.jobMirror.clear(); const D = fake('TST0001'); const r3 = M.mirrorAttach(D);
  chk('메모리에 없으면 기록 파일 끝을 보임', r3 === true && /기록 파일 \.vibe\/jobs\//.test(txt(D)) && txt(D).includes('===== 끝'), txt(D).slice(0, 200));
  chk('기록 파일도 창마다 1번', M.mirrorAttach(D) === false);
  const E = fake('TST0777'); chk('업무 작업 기록이 없는 화면 = 아무것도 보내지 않음', M.mirrorAttach(E) === false && E.got.length === 0);
  chk('실행 중인 업무 작업이 없으면 중지 요청 없음', M.mirrorStop(A) === false);
  panels.clear(); try { jr.dispose(); } catch { } try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
