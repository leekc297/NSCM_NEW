// 개선안 20261123000419_VISION 반영 확인용(임시): 새 순서 = 측정 → 문서 1판 → 반복 [보완 → 부분 재측정 → 문서 갱신]
//   ① 모형 체인을 실행기(chain-runner, workbench)로 돌려 실행 순서 확인 ② 실제 quick.json 두 체인의 단계 구조 확인
//   사용: node .vibe/tmp/orchprop_newshape.js tools/VibeManager
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const vs = new Proxy({}, { get: (t, k) => {
  if (k === 'window') return new Proxy({}, { get: () => () => Promise.resolve(undefined) });
  if (k === 'commands') return { executeCommand: () => Promise.resolve(), registerCommand: () => ({ dispose() { } }) };
  if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] };
  if (k === 'Uri') return { file: f => ({ fsPath: f }), parse: s => s };
  if (k === 'ViewColumn') return { Active: 1, Beside: 2 };
  return function () { };
} });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2]);
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'chain2-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', llmReview: false }));
W('.vibe/quick.json', JSON.stringify({ groups: [] }));
const tasks = {};
const p = { root, vibeDir, extDir: dir, genDir: path.join(root, 'Doc', 'gen'), outDir: path.join(root, 'Doc', 'asisfacts'), tobeDir: path.join(root, 'nscm-fe'), promptsDir: path.join(root, 'prompts'), node: 'node', python: 'python', powershell: 'powershell', claude: 'none', claudeModel: '', permissionMode: 'bypassPermissions', language: 'ko' };
const api = {
  ctx: { workspaceState: { get: () => { throw new Error('workspaceState 읽음'); }, update: () => { throw new Error('workspaceState 씀'); } }, extensionPath: dir },
  paths: () => p, loadSteps: () => ({}), findTask: id => tasks[id] || null,
  collectInputs: async (task, preset) => Object.assign({}, p, { inputs: Object.assign({}, preset || {}) }),
  subst: (text, vars) => String(text == null ? '' : text).replace(/\$\{(input:)?([A-Za-z0-9_]+)\}/g, (m, isIn, n) => isIn ? (vars.inputs && vars.inputs[n] != null ? vars.inputs[n] : '') : (vars[n] != null ? String(vars[n]) : m)),
  buildArgs: (task, vars) => (task.args || []).map(a => api.subst(a, vars)).filter(x => x !== ''),
  openPath: () => { }, pageDirOf: () => '', menuSections: () => [], claudeEnv: () => ({}),
  runTaskById: async () => 0, record: () => { }, afterTask: () => { },
};
const { ChainRunner } = require(path.join(dir, 'chain-runner'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const R = rel => fs.readFileSync(path.join(root, rel), 'utf8');
const events = () => { try { return R('.vibe/orch/events.jsonl').trim().split('\n').map(l => JSON.parse(l)); } catch { return []; } };
const mJs = W('tools/t/m.js', "const fs=require('fs');fs.writeFileSync('n.txt',process.argv[2]);fs.writeFileSync('tri.json',JSON.stringify({continue:Number(process.argv[2])>0?1:0,actionable:Number(process.argv[2])}));fs.appendFileSync('log.txt','M ');");
const fixJs = W('tools/t/fix.js', "require('fs').appendFileSync('log.txt','F ');");
const reJs = W('tools/t/re.js', "const fs=require('fs');const n=Math.max(0,Number(fs.readFileSync('n.txt','utf8'))-1);fs.writeFileSync('n.txt',String(n));fs.writeFileSync('tri.json',JSON.stringify({continue:n>0?1:0,actionable:n}));fs.appendFileSync('log.txt','R ');");
const docJs = W('tools/t/doc.js', "require('fs').appendFileSync('log.txt','D ');");
Object.assign(tasks, { 'T.m': { id: 'T.m', title: '측정', kind: 'node', script: mJs, args: ['${input:n}'], cwd: root }, 'T.fix': { id: 'T.fix', title: '보완', kind: 'node', script: fixJs, args: [], cwd: root },
  'T.re': { id: 'T.re', title: '부분 재측정', kind: 'node', script: reJs, args: [], cwd: root }, 'T.docs': { id: 'T.docs', title: '문서', kind: 'node', script: docJs, args: [], cwd: root } });
// 실제 quick.json 과 같은 틀: 문서 단계 args 에 --docs(stepKey 'T.docs:--docs'), 측정은 --no-docs
const mk = n => ({ kind: 'chain', label: '새 순서 시험', chainId: 'checklist', loops: { fix: { first: { key: 'actionable' }, while: { file: '${root}/tri.json', key: 'continue', gt: 0 }, max: 0 } }, steps: [
  { task: 'T.m', title: '1. 측정', args: [String(n), '--no-docs'] }, { task: 'T.docs', title: '2. 문서 1판', args: ['--docs'] },
  { task: 'T.fix', title: '3. 보완', loop: 'fix' }, { task: 'T.re', title: '4. 부분 재측정', loop: 'fix' }, { task: 'T.docs', title: '5. 문서 갱신', args: ['--docs'], loop: 'fix' }] });
const log = () => { try { return R('log.txt').trim(); } catch { return ''; } };
const clear = () => { for (const f of ['log.txt', 'tri.json', 'n.txt']) try { fs.unlinkSync(path.join(root, f)); } catch { } };
const mkR = id => new ChainRunner(api, { id, jobId: '', autoAnswer: false, onLog: () => { }, onStep: () => { }, onNote: () => { } });
(async () => {
  let a = await mkR('ns0001').run(mk(2));
  chk('남은 2 → 측정, 문서 1판, 회차마다 [보완, 부분 재측정, 문서 갱신] 2회', a.status === 'OK' && log() === 'M D F R D F R D', log() + ' ' + a.status);
  const ev = events().filter(e => e.runId && e.runId.startsWith('NS0001_'));
  const se = ev.filter(e => e.type === 'step.end' && /^(OK|WARN)$/.test(e.status)); const docs = se.filter(e => /:--docs(:|$)/.test(e.stepKey || ''));
  chk('step.end stepKey: 문서 단계 3건(:--docs), 첫 문서 단계 = 2단계, 측정 단계는 :--no-docs 라 문서 아님', docs.length === 3 && docs[0].no === 2 && !/:--docs(:|$)/.test(se[0].stepKey), JSON.stringify(se.map(e => `${e.no}:${e.stepKey}`)));
  const ce = ev.find(e => e.type === 'chain.end');
  chk('chain.end rows 에 2단계 문서 1판 소요(sec) 기록', !!ce && Array.isArray(ce.rows) && ce.rows[1] && ce.rows[1].no === 2 && ce.rows[1].status === 'OK' && typeof ce.rows[1].sec === 'number', ce && JSON.stringify((ce.rows || []).map(r => `${r.no}:${r.task}:${r.status}`)));
  clear(); a = await mkR('ns0002').run(mk(0));
  chk('남은 0 → 측정, 문서 1판으로 끝(반복 없음, 문서 1판이 최종본)', a.status === 'OK' && log() === 'M D', log() + ' ' + a.status);
  // 실제 quick.json 구조
  const q = JSON.parse(fs.readFileSync(path.join(dir, 'quick.json'), 'utf8').replace(/^﻿/, '')); const found = [];
  const walk = o => { if (Array.isArray(o)) o.forEach(walk); else if (o && typeof o === 'object') { if (o.chainId === 'checklist' || o.chainId === 'checklist-delta') found.push(o); Object.values(o).forEach(walk); } };
  walk(q);
  chk('quick.json 체인 2개(checklist, checklist-delta) 찾음', found.length === 2, String(found.length));
  for (const c of found) {
    const s = c.steps; const isDoc = x => x.task === 'S8.checklistRun' && (x.args || []).includes('--docs'); const firstLoop = s.findIndex(x => x.loop); const lp = s.filter(x => x.loop === 'fix');
    chk(`${c.chainId}: 1단계 측정(--no-docs) · 2단계 문서 1판(반복 밖) · 반복 첫 단계 3 · 반복 끝 단계 = 문서 갱신 · late 단계 0 · 단계 ${s.length}개 번호 1~${s.length}`,
      (s[0].args || []).includes('--no-docs') && isDoc(s[1]) && !s[1].loop && !s[1].late && firstLoop === 2 && isDoc(lp[lp.length - 1]) && s.slice(2).every(x => x.loop === 'fix') && !s.some(x => x.late) && s.every((x, i) => String(x.title).startsWith(`${i + 1}. `)) && /7 문서 갱신\] 반복/.test(c.hint) && c.hint === c.confirm,
      s.map(x => x.title.slice(0, 12)).join(' | '));
  }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
