// 2026-11-25 LOOKUP 이관 업무(VMW) 시험 — quick.json 정의(그룹 5개, 입력 7칸, 단계 LK.gen · LK.verify), steps.json 단계, 그룹 묶음 1개, _inputs.json, 선택형 입력 검증,
//   생성기 입력 검사(그룹 이름, 추가 조건). DB 접속 불필요
//   사용: node test/t_lk_job.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const vs = new Proxy({}, { get: (t, k) => {
  if (k === 'window') return new Proxy({}, { get: () => () => Promise.resolve(undefined) });
  if (k === 'commands') return { executeCommand: () => Promise.resolve(), registerCommand: () => ({ dispose() { } }) };
  if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] };
  if (k === 'Uri') return { file: f => ({ fsPath: f }), parse: s => s };
  return function () { };
} });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const rd = f => JSON.parse(fs.readFileSync(path.join(dir, f), 'utf8').replace(/^﻿/, ''));
const real = rd('quick.json').groups.flatMap(g => g.items || []).find(x => x.chainId === 'lookupmig');
chk('quick.json: lookupmig 업무 있음(batch, chain, 모듈 단위, 묶음)', !!real && real.batch === true && real.kind === 'chain' && real.unit === 'module' && real.combine === true, real && real.label);
chk('그룹 = SSP, SCP, DM, COMMON, ALL', !!real && real.modules.join() === 'SSP,SCP,DM,COMMON,ALL', real && real.modules.join());
chk('입력 7칸(date, types, whereM, whereD, exclude, bkTag, verify) · 실행일 외 선택 입력', !!real && real.jobInputs.map(x => x.name).join() === 'date,types,whereM,whereD,exclude,bkTag,verify' && real.jobInputs.filter(x => x.name !== 'date' && x.optional !== true && x.type !== 'select').length === 0, real && real.jobInputs.map(x => x.name).join());
chk('단계 = LK.gen → LK.verify', !!real && real.steps.map(s => s.task).join() === 'LK.gen,LK.verify');
const tasks = rd('steps.json').steps.flatMap(g => g.tasks || []);
const tg = tasks.find(t => t.id === 'LK.gen'); const tv = tasks.find(t => t.id === 'LK.verify');
chk('steps.json: LK.gen · LK.verify = python lookup_migrate.py gen/verify --module', !!tg && !!tv && tg.kind === 'python' && /lookup_migrate\.py$/.test(tg.script) && tg.args[0] === 'gen' && tv.args[0] === 'verify' && tg.args.join(' ').includes('--module ${input:ids}'));
const py = path.resolve(dir, '..', 'Analysis', 'lookup_migrate', 'lookup_migrate.py');
chk('생성기 파일 있음', fs.existsSync(py), py);
// 생성기 입력 검사(DB 접속 전 단계에서 멈춤)
const run = args => cp.spawnSync('python', [py, ...args], { encoding: 'utf8', env: Object.assign({}, process.env, { PYTHONIOENCODING: 'utf-8' }) });
const r1 = run(['gen', '--module', 'XYZ']);
chk('틀린 그룹 이름 = 입력 오류(종료 코드 3)', r1.status === 3 && /그룹은/.test(r1.stdout), (r1.stdout || r1.stderr).slice(0, 120));
const r2 = cp.spawnSync('python', ['-c', [
  'import sys; sys.path.insert(0, r"' + path.dirname(py) + '"); import lookup_migrate as L',
  'bad = ["M.A = 1; DROP TABLE X", "ISNULL(M.VALID_YN, 1) = 1", "D.VALID_YN = 1", "M.LOOKUP_TYPE = \'A&B\'", "M.CREATION_DATE >= \'2026-01-01\'"]',
  'good = ["M.VALID_YN = \'Y\' AND M.LOOKUP_TYPE LIKE \'SSP%\'", "UPPER(M.DESCRIPTION) LIKE \'%PLAN%\'"]',
  'def t(w):\n    try:\n        L.check_where(w, "M", set(L.MASTER)); return True\n    except L.InputError:\n        return False',
  'print(sum(1 for w in bad if not t(w)), sum(1 for w in good if t(w)))'].join('\n')], { encoding: 'utf8' });
chk('추가 조건 검사: 막을 것 5개 막음, 받을 것 2개 받음', String(r2.stdout).trim() === '5 2', String(r2.stdout || r2.stderr).trim().slice(0, 200));
// 업무 만들기: 임시 저장소에 같은 정의(단계는 시험용 node)로
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'job-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', llmReview: false }));
const genJs = W('tools/t/lk.js', "const fs=require('fs'),path=require('path');const id=process.argv[2];const d=path.join(process.cwd(),'Doc','LOOKUP_이관',id);const inp=JSON.parse(fs.readFileSync(path.join(d,'_inputs.json'),'utf8'));for(const n of [1,2,3,4])fs.writeFileSync(path.join(d,'LOOKUP_이관_'+id+'_20261125_1400_'+n+'.sql'),inp.types||'x');");
const item = Object.assign({}, real, { steps: [{ task: 'T.lk', title: '생성' }] });
W('.vibe/quick.json', JSON.stringify({ groups: [{ title: 'g', items: [item] }] }));
const tk = { 'T.lk': { id: 'T.lk', title: '생성', kind: 'node', script: genJs, args: ['${input:id}'], cwd: root } };
const p = { root, vibeDir, extDir: dir, genDir: path.join(root, 'Doc', 'gen'), outDir: path.join(root, 'Doc', 'asisfacts'), tobeDir: path.join(root, 'nscm-fe'), promptsDir: path.join(root, 'prompts'), node: 'node', python: 'python', powershell: 'powershell', claude: 'claude', claudeModel: '', language: 'ko', quickFile: path.join(vibeDir, 'quick.json') };
const api = { ctx: { workspaceState: { get: () => undefined, update: () => { } }, extensionPath: dir }, paths: () => p, loadSteps: () => ({}), findTask: id => tk[id] || null,
  collectInputs: async (task, preset) => Object.assign({}, p, { inputs: Object.assign({}, preset || {}) }),
  subst: (text, vars) => String(text == null ? '' : text).replace(/\$\{(input:)?([A-Za-z0-9_]+)\}/g, (m, isIn, n) => isIn ? (vars.inputs && vars.inputs[n] != null ? vars.inputs[n] : '') : (vars[n] != null ? String(vars[n]) : m)),
  buildArgs: (task, vars) => (task.args || []).map(a => api.subst(a, vars)).filter(x => x !== ''), openPath: () => { }, pageDirOf: () => '', menuSections: () => [], claudeEnv: () => ({}), runTaskById: async () => 0, record: () => { }, afterTask: () => { } };
const jr = require(path.join(dir, 'job-runner')); jr.init(api);
const sleep = t => new Promise(r => setTimeout(r, t));
const waitEnd = async (id, ms = 40000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { const j = jr.get(id); if (!/^(running|pausing)$/.test(j.status)) { await sleep(150); return j; } await sleep(100); } return jr.get(id); };
(async () => {
  const bi = jr.batchItems().find(x => x.label === item.label);
  chk('VMW 업무 목록에 보임(DB MODE 에서도 고를 수 있음)', !!bi && bi.disabled === false && bi.moduleLabels.ALL === '그룹 조건 없음', JSON.stringify(bi && { d: bi.disabled }));
  const good = { date: '2026-11-25', types: 'SSP_A, SSP_B', whereM: "M.VALID_YN = 'Y'", whereD: '', exclude: 'IF_STOCK_CHECK', bkTag: '', verify: 'Y' };
  let e1 = ''; try { jr.create({ itemLabel: item.label, screens: ['SSP'], inputs: Object.assign({}, good, { verify: 'X' }) }); } catch (e) { e1 = e.message; }
  chk('로컬 검증 값이 Y, N 외 = 만들지 않음', /고를 수 없는 값: 로컬 검증 = X/.test(e1), e1);
  const j = jr.create({ itemLabel: item.label, screens: ['DM', 'SSP'], inputs: good });
  chk('그룹 2개 = 묶음 1개 SSP_DM(정의 순서)', j.screens.map(s => s.id).join() === 'SSP_DM', j.screens.map(s => s.id).join());
  const inp = JSON.parse(fs.readFileSync(path.join(root, 'Doc', 'LOOKUP_이관', 'SSP_DM', '_inputs.json'), 'utf8'));
  chk('입력 파일 = Doc/LOOKUP_이관/<묶음>/_inputs.json', inp.module === 'SSP_DM' && inp.types === 'SSP_A, SSP_B' && inp.whereM === "M.VALID_YN = 'Y'" && inp.verify === 'Y', JSON.stringify(inp));
  jr.start(j.id); const e = await waitEnd(j.id);
  const s = e.screens[0];
  chk('실행 끝(완료) + 산출물 4개', s.status === 'done' && (s.outputs || []).length === 4, JSON.stringify(s.outputs) + ' ' + s.why);
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
