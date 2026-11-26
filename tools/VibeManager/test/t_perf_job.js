// 2026-11-25 BATCHJOB · UI 속도 점검 업무(VMW) 시험 — quick.json 정의, steps.json 단계, 배치 모듈 묶음과 _inputs.json, UI 화면 단위,
//   생성기 입력 검사(모듈 이름, 빈 대상, 화면 ID 형식), 저장 프로시저 이름 걸러내기. DB 접속 불필요
//   사용: node test/t_perf_job.js <VibeManager 폴더>
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
const all = rd('quick.json').groups.flatMap(g => g.items || []);
const pb = all.find(x => x.chainId === 'perfbatch'); const pu = all.find(x => x.chainId === 'perfui');
chk('quick.json: perfbatch = 모듈 단위(SSP, SCP, DM, SCM), 묶음, 입력 targets · days', !!pb && pb.batch === true && pb.unit === 'module' && pb.combine === true && pb.modules.join() === 'SSP,SCP,DM,SCM' && pb.jobInputs.map(x => x.name).join() === 'targets,days' && pb.jobInputs[0].optional !== true);
chk('quick.json: perfui = 화면 단위(unit 없음), 입력 없음', !!pu && pu.batch === true && !pu.unit && !(pu.jobInputs || []).length);
chk('단계: PF.batch → PF.batchVerify · PF.ui → PF.uiVerify', !!pb && !!pu && pb.steps.map(s => s.task).join() === 'PF.batch,PF.batchVerify' && pu.steps.map(s => s.task).join() === 'PF.ui,PF.uiVerify');
const tasks = rd('steps.json').steps.flatMap(g => g.tasks || []); const T = id => tasks.find(t => t.id === id) || {};
chk('steps.json: perf_check.py batch / ui / verify --kind', /perf_check\.py$/.test(T('PF.batch').script || '') && T('PF.batch').args[0] === 'batch' && T('PF.ui').args[0] === 'ui' && T('PF.batchVerify').args.slice(-2).join() === '--kind,batch' && T('PF.uiVerify').args.slice(-2).join() === '--kind,ui');
chk('산출물 경로: Doc/PERF_점검/BATCH/<모듈>, Doc/PERF_점검/UI/<화면ID>', !!pb && !!pu && pb.outputs[0].startsWith('Doc/PERF_점검/BATCH/${id}/') && pu.outputs[0].startsWith('Doc/PERF_점검/UI/${id}/'));
const py = path.resolve(dir, '..', 'Analysis', 'perf_check', 'perf_check.py');
chk('생성기 파일 있음', fs.existsSync(py), py);
const run = args => cp.spawnSync('python', [py, ...args], { encoding: 'utf8', env: Object.assign({}, process.env, { PYTHONIOENCODING: 'utf-8' }) });
const r1 = run(['batch', '--module', 'XYZ']); chk('배치: 틀린 모듈 = 입력 오류(종료 코드 3)', r1.status === 3 && /모듈은/.test(r1.stdout), (r1.stdout || r1.stderr).slice(0, 120));
const r2 = run(['ui', '--module', 'ABC']); chk('UI: 화면 ID 형식 아님 = 입력 오류(종료 코드 3)', r2.status === 3 && /화면 ID 형식/.test(r2.stdout), (r2.stdout || r2.stderr).slice(0, 120));
const r3 = cp.spawnSync('python', ['-c', ['import sys, re; sys.path.insert(0, r"' + path.dirname(py) + '"); import perf_check as P',
  'w = ["P_DMF0045_SAVE_SHIPMENT_REQUEST", "P_SCP0007_SAVE_BOD", "P_X_GET_UPLOAD", "P_X_DEL_ROW", "P_X_CONFIRM_GET"]',
  'r = ["P_DMF0045_GET_SHIPMENT_REQUEST", "P_SCP0007_GET_BOD", "P_X_GET_DELIVERY", "P_X_GET_INSPECTION"]',
  'print(sum(1 for x in w if re.search(P.WRITE_NAME, x)), sum(1 for x in r if not re.search(P.WRITE_NAME, x)))',
  'print(P.split_args("\'a\', \'b\'\'c\', NULL, 1"))', 'print(P.safe_lit("\'x&y:z\'"))'].join('\n')], { encoding: 'utf8' });
const lines = String(r3.stdout).trim().split(/\r?\n/);
chk('저장 낱말 걸러내기: 저장 5개 걸러냄, 조회 4개 통과', lines[0] === '5 4', String(r3.stdout || r3.stderr).slice(0, 200));
chk('호출 인자 나누기(따옴표 안 쉼표, 두 번 쓴 따옴표)', lines[1] === "[\"'a'\", \"'b''c'\", 'NULL', '1']", lines[1]);
chk('리터럴 & : → CHR()', lines[2] === "'x' || CHR(38) || 'y' || CHR(58) || 'z'", lines[2]);
// 업무 만들기(임시 저장소, 단계는 시험용 node)
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'job-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', llmReview: false }));
const bJs = W('tools/t/pb.js', "const fs=require('fs'),path=require('path');const id=process.argv[2];const d=path.join(process.cwd(),'Doc','PERF_점검','BATCH',id);const inp=JSON.parse(fs.readFileSync(path.join(d,'_inputs.json'),'utf8'));fs.writeFileSync(path.join(d,'BATCH_속도점검_'+inp.targets.split(',')[0].trim()+'_20261125_1400.sql'),'x');");
const uJs = W('tools/t/pu.js', "const fs=require('fs'),path=require('path');const id=process.argv[2];const d=path.join(process.cwd(),'Doc','PERF_점검','UI',id);fs.mkdirSync(d,{recursive:true});fs.writeFileSync(path.join(d,'UI_속도점검_'+id+'_20261125_1400.sql'),'x');");
const ib = Object.assign({}, pb, { steps: [{ task: 'T.pb', title: '생성' }] }); const iu = Object.assign({}, pu, { steps: [{ task: 'T.pu', title: '생성' }] });
W('.vibe/quick.json', JSON.stringify({ groups: [{ title: 'g', items: [ib, iu] }] }));
const tk = { 'T.pb': { id: 'T.pb', title: '생성', kind: 'node', script: bJs, args: ['${input:id}'], cwd: root }, 'T.pu': { id: 'T.pu', title: '생성', kind: 'node', script: uJs, args: ['${input:id}'], cwd: root } };
const p = { root, vibeDir, extDir: dir, genDir: path.join(root, 'Doc', 'gen'), outDir: path.join(root, 'Doc', 'asisfacts'), tobeDir: path.join(root, 'nscm-fe'), promptsDir: path.join(root, 'prompts'), node: 'node', python: 'python', powershell: 'powershell', claude: 'claude', claudeModel: '', language: 'ko', quickFile: path.join(vibeDir, 'quick.json') };
const api = { ctx: { workspaceState: { get: () => undefined, update: () => { } }, extensionPath: dir }, paths: () => p, loadSteps: () => ({}), findTask: id => tk[id] || null,
  collectInputs: async (task, preset) => Object.assign({}, p, { inputs: Object.assign({}, preset || {}) }),
  subst: (text, vars) => String(text == null ? '' : text).replace(/\$\{(input:)?([A-Za-z0-9_]+)\}/g, (m, isIn, n) => isIn ? (vars.inputs && vars.inputs[n] != null ? vars.inputs[n] : '') : (vars[n] != null ? String(vars[n]) : m)),
  buildArgs: (task, vars) => (task.args || []).map(a => api.subst(a, vars)).filter(x => x !== ''), openPath: () => { }, pageDirOf: () => '', menuSections: () => [], claudeEnv: () => ({}), runTaskById: async () => 0, record: () => { }, afterTask: () => { } };
const jr = require(path.join(dir, 'job-runner')); jr.init(api);
const sleep = t => new Promise(r => setTimeout(r, t));
const waitEnd = async (id, ms = 40000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { const j = jr.get(id); if (!/^(running|pausing)$/.test(j.status)) { await sleep(150); return j; } await sleep(100); } return jr.get(id); };
(async () => {
  const items = jr.batchItems(); const bb = items.find(x => x.label === ib.label); const bu = items.find(x => x.label === iu.label);
  chk('VMW 업무 목록에 2개 보임(DB MODE 에서도 고를 수 있음)', !!bb && !!bu && !bb.disabled && !bu.disabled && bb.unit === 'module' && bu.unit === 'screen');
  let e1 = ''; try { jr.create({ itemLabel: ib.label, screens: ['SSP'], inputs: { targets: '', days: '14' } }); } catch (e) { e1 = e.message; }
  chk('배치: 대상 이름 빈 값 = 만들지 않음', /입력 빠짐/.test(e1), e1);
  const j = jr.create({ itemLabel: ib.label, screens: ['SSP'], inputs: { targets: 'PR_SSP_ANL_SHIP_PLAN_40', days: '14' } });
  const inp = JSON.parse(fs.readFileSync(path.join(root, 'Doc', 'PERF_점검', 'BATCH', 'SSP', '_inputs.json'), 'utf8'));
  chk('배치 입력 파일 = Doc/PERF_점검/BATCH/<모듈>/_inputs.json', inp.targets === 'PR_SSP_ANL_SHIP_PLAN_40' && inp.days === '14', JSON.stringify(inp));
  jr.start(j.id); const e = await waitEnd(j.id);
  chk('배치 실행 끝 + 산출물 1개', e.screens[0].status === 'done' && (e.screens[0].outputs || []).length === 1, JSON.stringify(e.screens[0].outputs) + ' ' + e.screens[0].why);
  const u = jr.create({ itemLabel: iu.label, screens: ['DMF0045', 'SCP0007'] });
  chk('UI: 화면 2개 = 단위 2개', u.screens.map(s => s.id).join() === 'DMF0045,SCP0007');
  jr.start(u.id); const ue = await waitEnd(u.id);
  chk('UI 실행 끝 + 화면마다 산출물 1개', ue.screens.every(s => s.status === 'done' && (s.outputs || []).length === 1), JSON.stringify(ue.screens.map(s => s.outputs)));
  // 2026-11-25 클라우드 적용 회신 반영(최종 적용본): 현재 스키마 고정, 원문 판 대조, 실행 중 감시, 같은 JOB 다른 단계, 계획 진행 상태
  const pc = require('fs').readFileSync(py, 'utf8');
  chk('생성기: 첫 쿼리 현재 스키마 고정([L0], [U0-0]) + 원문 판 대조([L0-1], [U0-1])', /SCHEMA_SQL = 'ALTER SESSION SET CURRENT_SCHEMA = %s'/.test(pc) && /S\['L0'\] = SCHEMA_SQL/.test(pc) && /S\['U0-0'\] = SCHEMA_SQL/.test(pc) && /S\['L0-1'\] = version_sql/.test(pc) && /S\['U0-1'\] = version_sql/.test(pc));
  chk('생성기: 재실행 감시 [U4-M1]~[U4-M4] + 같은 JOB 다른 단계 + 계획 진행 상태 [L2-1]', ['U4-M1', 'U4-M2', 'U4-M3', 'U4-M4', 'L2-1'].every(k => pc.includes(`S['${k}']`)) && /side \+= \[p for p in re\.findall/.test(pc));
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
