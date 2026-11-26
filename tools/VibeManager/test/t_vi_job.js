// 2026-11-24 VM 소개 자료 업무(VMW) 시험 — 대상 선택(moduleLabels), 출력 형식 checks 입력 검증, 대상마다 자료 1개, _inputs.json formats 배열, 산출물 경로. 실제 Claude 불필요
//   사용: node test/t_job_runner.js <VibeManager 폴더>
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
const viJs = W('tools/t/vi.js', "const fs=require('fs'),path=require('path');const id=process.argv[2];const d=path.join(process.cwd(),'Doc','VMIntro',id);const inp=JSON.parse(fs.readFileSync(path.join(d,'_inputs.json'),'utf8'));for(const f of inp.formats){fs.writeFileSync(path.join(d,'VM_소개_'+id+'_20261124.'+(f==='gslides'?'gs.pptx':f)),'x');}");
const FMT = [{ v: 'pptx', label: 'PowerPoint' }, { v: 'gslides', label: 'Google Slides' }, { v: 'pdf', label: 'PDF' }, { v: 'html', label: 'HTML' }];
const item = { label: '🎤 VM 소개 자료 시험', kind: 'chain', chainId: 'vmintro', batch: true, unit: 'module', outputs: ['Doc/VMIntro/${id}/VM_소개_${id}_*.*'], modules: ['EXEC', 'DEV', 'SHARE'], moduleLabels: { EXEC: '경영진 보고', DEV: '개발자, 운영 교육', SHARE: '사내 공유' }, inputsFile: 'Doc/VMIntro/${id}/_inputs.json',
  jobInputs: [{ name: 'author', label: '작성자' }, { name: 'date', label: '작성일', type: 'date' }, { name: 'formats', label: '출력 형식', type: 'checks', multi: true, default: ['pptx'], options: FMT }],
  steps: [{ task: 'T.vi', title: '출력' }] };
W('.vibe/quick.json', JSON.stringify({ groups: [{ title: 'g', items: [item] }] }));
const tasks = { 'T.vi': { id: 'T.vi', title: '출력', kind: 'node', script: viJs, args: ['${input:id}'], cwd: root } };
const p = { root, vibeDir, extDir: dir, genDir: path.join(root, 'Doc', 'gen'), outDir: path.join(root, 'Doc', 'asisfacts'), tobeDir: path.join(root, 'nscm-fe'), promptsDir: path.join(root, 'prompts'), node: 'node', python: 'python', powershell: 'powershell', claude: 'claude', claudeModel: '', language: 'ko', quickFile: path.join(vibeDir, 'quick.json') };
const api = { ctx: { workspaceState: { get: () => undefined, update: () => { } }, extensionPath: dir }, paths: () => p, loadSteps: () => ({}), findTask: id => tasks[id] || null,
  collectInputs: async (task, preset) => Object.assign({}, p, { inputs: Object.assign({}, preset || {}) }),
  subst: (text, vars) => String(text == null ? '' : text).replace(/\$\{(input:)?([A-Za-z0-9_]+)\}/g, (m, isIn, n) => isIn ? (vars.inputs && vars.inputs[n] != null ? vars.inputs[n] : '') : (vars[n] != null ? String(vars[n]) : m)),
  buildArgs: (task, vars) => (task.args || []).map(a => api.subst(a, vars)).filter(x => x !== ''), openPath: () => { }, pageDirOf: () => '', menuSections: () => [], claudeEnv: () => ({}), runTaskById: async () => 0, record: () => { }, afterTask: () => { } };
const jr = require(path.join(dir, 'job-runner')); jr.init(api);
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const R = rel => fs.readFileSync(path.join(root, rel), 'utf8'); const sleep = t => new Promise(r => setTimeout(r, t));
const waitEnd = async (id, ms = 40000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { const j = jr.get(id); if (!/^(running|pausing)$/.test(j.status)) { await sleep(150); return j; } await sleep(100); } return jr.get(id); };
(async () => {
  const bi = jr.batchItems().find(x => x.label === item.label);
  chk('업무 목록: 대상 3개 + 한글 이름(moduleLabels), 입력 3칸(출력 형식 checks)', !!bi && bi.modules.join() === 'EXEC,DEV,SHARE' && bi.moduleLabels.EXEC === '경영진 보고' && bi.jobInputs.map(x => x.name).join() === 'author,date,formats' && bi.jobInputs[2].type === 'checks', JSON.stringify(bi && bi.moduleLabels));
  const good = { author: '조재훈', date: '2026-11-24', formats: ['pptx', 'gslides', 'html'] };
  let e1 = ''; try { jr.create({ itemLabel: item.label, screens: ['EXEC'], inputs: Object.assign({}, good, { formats: [] }) }); } catch (e) { e1 = e.message; }
  chk('출력 형식 0개 = 만들지 않음', /입력 빠짐: 출력 형식/.test(e1), e1);
  let e2 = ''; try { jr.create({ itemLabel: item.label, screens: ['EXEC'], inputs: Object.assign({}, good, { formats: ['pptx', 'keynote'] }) }); } catch (e) { e2 = e.message; }
  chk('목록에 없는 형식 = 만들지 않음', /고를 수 없는 값: 출력 형식 = keynote/.test(e2), e2);
  const j = jr.create({ itemLabel: item.label, screens: ['DEV', 'EXEC'], inputs: good });
  chk('대상 2개 = 자료 2개(묶지 않음)', j.screens.map(s => s.id).sort().join() === 'DEV,EXEC', j.screens.map(s => s.id).join());
  const inp = JSON.parse(R('Doc/VMIntro/EXEC/_inputs.json'));
  chk('입력 파일 = Doc/VMIntro/<대상>/_inputs.json(formats 배열)', inp.module === 'EXEC' && JSON.stringify(inp.formats) === JSON.stringify(['pptx', 'gslides', 'html']), JSON.stringify(inp));
  jr.start(j.id); const e = await waitEnd(j.id);
  const ex = e.screens.find(s => s.id === 'EXEC');
  chk('실행 끝(완료) + 산출물 = 고른 형식 3개', e.screens.every(s => s.status === 'done') && (ex.outputs || []).length === 3, JSON.stringify(ex.outputs) + ' ' + ex.why);
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
