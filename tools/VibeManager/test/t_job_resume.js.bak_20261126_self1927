// VMW 작업 재개 시험(2026-11-20): 창 다시 로드(job-runner.dispose + abortRunningChains)로 끊긴 업무 작업 → 다시 불러오면 화면에 재개 정보 · 작업 재개 = 끊긴 단계부터
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
const docJs = W('tools/t/doc.js', "const fs=require('fs'),path=require('path');const id=process.argv[2];const has=f=>{try{return fs.readFileSync(path.join(process.cwd(),f),'utf8').split(/\\s+/).includes(id)}catch{return false}};fs.appendFileSync(path.join(process.cwd(),'order.txt'),id+'\\n');if(has('fail.txt')){console.log('[FAIL] 분석 자료 없음: '+id);process.exit(6);}const go=()=>{const d=path.join(process.cwd(),'out');fs.mkdirSync(d,{recursive:true});fs.writeFileSync(path.join(d,id+'.xlsx'),'doc');console.log('[INFO] 설계서 생성 '+id);};if(has('slow.txt'))setTimeout(go,1500);else go();");
const chain = { label: '📝 문서 생성 시험', kind: 'chain', chainId: 'docs', batch: true, steps: [{ task: 'T.doc', title: '1. 설계서', verify: { type: 'fileExists', fresh: true, file: '${root}/out/${id}.xlsx' } }, { task: 'T.doc', title: '2. 재수행', askUser: '다시?', askYes: '실행' }] };
const cntJs = W('tools/t/cnt.js', "const fs=require('fs'),path=require('path');const k=process.argv[2];const f=path.join(process.cwd(),'out','cnt_'+k+'.txt');fs.mkdirSync(path.dirname(f),{recursive:true});fs.appendFileSync(f,'x');");
const slowJs = W('tools/t/slow2.js', "const fs=require('fs'),path=require('path');if(fs.existsSync(path.join(process.cwd(),'fast.flag')))process.exit(0);setTimeout(()=>process.exit(0),8000);");
const rchain = { label: '재개 시험 업무', kind: 'chain', chainId: 'rjob', batch: true, steps: [{ task: 'T.c1', title: '1. 첫 단계' }, { task: 'T.slow2', title: '2. 오래 걸림' }, { task: 'T.c3', title: '3. 끝 단계' }] };
W('.vibe/quick.json', JSON.stringify({ groups: [{ title: 'g', items: [rchain] }] }));
const tasks = { 'T.c1': { id: 'T.c1', title: '1', kind: 'node', script: cntJs, args: ['a'], cwd: root }, 'T.slow2': { id: 'T.slow2', title: '2', kind: 'node', script: slowJs, args: [], cwd: root }, 'T.c3': { id: 'T.c3', title: '3', kind: 'node', script: cntJs, args: ['c'], cwd: root } };
const p = { root, vibeDir, extDir: dir, genDir: path.join(root, 'Doc', 'gen'), outDir: path.join(root, 'Doc', 'asisfacts'), tobeDir: path.join(root, 'nscm-fe'), promptsDir: path.join(root, 'prompts'), node: 'node', python: 'python', powershell: 'powershell', claude: 'claude', claudeModel: '', permissionMode: 'bypassPermissions', language: 'ko' };
const api = { ctx: { workspaceState: { get: () => undefined, update: () => { } }, extensionPath: dir }, paths: () => p, loadSteps: () => ({}), findTask: id => tasks[id] || null,
  collectInputs: async (task, preset) => Object.assign({}, p, { inputs: Object.assign({}, preset || {}) }),
  subst: (text, vars) => String(text == null ? '' : text).replace(/\$\{(input:)?([A-Za-z0-9_]+)\}/g, (m, isIn, n) => isIn ? (vars.inputs && vars.inputs[n] != null ? vars.inputs[n] : '') : (vars[n] != null ? String(vars[n]) : m)),
  buildArgs: (task, vars) => (task.args || []).map(a => api.subst(a, vars)).filter(x => x !== ''), openPath: () => { }, pageDirOf: () => '', menuSections: () => [], claudeEnv: () => ({}), runTaskById: async () => 0, record: () => { }, afterTask: () => { } };
const jr = require(path.join(dir, 'job-runner')); jr.init(api);
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const R = rel => fs.readFileSync(path.join(root, rel), 'utf8'); const sleep = t => new Promise(r => setTimeout(r, t));
const waitEnd = async (id, ms = 40000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { const j = jr.get(id); if (!/^(running|pausing)$/.test(j.status)) { await sleep(150); return j; } await sleep(100); } return jr.get(id); };
const st = j => j.screens.map(s => `${s.id}:${s.status}`).join(' ');
const reload = () => { for (const k of Object.keys(require.cache)) if (/job-runner\.js$/.test(k)) delete require.cache[k]; const m = require(path.join(dir, 'job-runner')); m.init(api); return m; };
const events = () => { try { return R('.vibe/orch/events.jsonl').trim().split(/\r?\n/).map(l => JSON.parse(l)); } catch { return []; } };
const cnt = k => { try { return fs.readFileSync(path.join(root, 'out', `cnt_${k}.txt`), 'utf8').length; } catch { return 0; } };
(async () => {
  const wbm = require(path.join(dir, 'workbench'));
  const j = jr.create({ itemLabel: rchain.label, screens: ['RSM0001'], onFail: 'continue' });
  jr.start(j.id); await sleep(1800);
  jr.dispose(); wbm.abortRunningChains('시험: 창 다시 로드'); await sleep(1500); // extension.deactivate 순서
  const jr2 = reload(); await sleep(3500); // 새 확장: init 3초 뒤 tidyRecent
  const a = jr2.get(j.id);
  chk('다시 불러온 작업 = 중단됨 · 화면 대기', a.status === 'interrupted' && a.screens[0].status === 'wait', `${a.status} ${st(a)}`);
  chk('화면 재개 정보 = 2/3 단계부터', a.screens[0].resume && a.screens[0].resume.from === 2 && a.screens[0].resume.of === 3 && a.resumable === 1, JSON.stringify(a.screens[0].resume));
  chk('목록 요약에도 중단 표시', (jr2.list(5).find(x => x.id === j.id) || {}).status === 'interrupted');
  // 2026-11-20 18:3x 결함 재현: 입장 대기 동안 화면 갱신이 표시(s.resume)를 지워도 재개 기록으로 이어가야 함 · 같은 작업·화면의 더 오래된 기록은 정리
  delete a.screens[0].resume;
  { const pd = path.join(vibeDir, 'orch', 'chain_progress'); const cur = fs.readdirSync(pd).filter(n => n.startsWith('RSM0001'))[0]; const r0 = JSON.parse(fs.readFileSync(path.join(pd, cur), 'utf8')); fs.writeFileSync(path.join(pd, 'RSM0001_1000.json'), JSON.stringify(Object.assign({}, r0, { runId: 'RSM0001_1000', updatedMs: r0.updatedMs - 60000 }))); }
  W('fast.flag', '1');
  chk('작업 재개 시작', jr2.start(j.id) === true);
  const t0 = Date.now(); let b; while (Date.now() - t0 < 30000) { b = jr2.get(j.id); if (!/^(running|pausing)$/.test(b.status)) break; await sleep(150); }
  chk('재개 끝 = 화면 완료', b.screens[0].status === 'done', st(b) + ' ' + b.screens[0].summary);
  chk('1단계 다시 안 돌고(1회) 3단계 실행(1회)', cnt('a') === 1 && cnt('c') === 1, `a=${cnt('a')} c=${cnt('c')}`);
  chk('로그에 재시작 줄(2단계 스크립트는 단계 안 재개 미지원 · 2026-11-20)', /작업 재시작: 2\/3단계 .*이 단계는 처음부터/.test(R(`.vibe/jobs/${j.id}/RSM0001.log`)));
  chk('재개 뒤 재개 정보 없음', !jr2.get(j.id).screens[0].resume && !jr2.get(j.id).resumable);
  chk('표시가 지워져도 재개 · 같은 작업·화면 옛 기록 정리(재개 대기 남지 않음)', wbm.resumable(p, { job: j.id }).length === 0 && !fs.existsSync(path.join(vibeDir, 'orch', 'chain_progress', 'RSM0001_1000.json')));
  // 삭제 = 중지 후 삭제 · 목록과 재개 기록에서 완전 삭제
  fs.unlinkSync(path.join(root, 'fast.flag'));
  const j2 = jr2.create({ itemLabel: rchain.label, screens: ['RSM0002'], onFail: 'continue' }); jr2.start(j2.id); await sleep(1500);
  chk('삭제 전 = 실행 중', /^(running|pausing)$/.test(jr2.get(j2.id).status));
  const rm = await jr2.remove(j2.id);
  chk('실행 중 작업 삭제 = 중지 후 삭제 성공', rm.ok === true, JSON.stringify(rm));
  chk('작업 폴더 없음 · 목록에 없음 · 불러오기 없음', !fs.existsSync(path.join(vibeDir, 'jobs', j2.id)) && !jr2.list(30).some(x => x.id === j2.id) && jr2.get(j2.id) === null);
  chk('그 작업의 재개 기록 없음', wbm.resumable(p, { job: j2.id }).length === 0 && !(fs.existsSync(path.join(vibeDir, 'orch', 'chain_progress')) && fs.readdirSync(path.join(vibeDir, 'orch', 'chain_progress')).some(n => n.startsWith('RSM0002'))));
  chk('잘못된 작업 번호 = 삭제 안 함', (await jr2.remove('../x')).ok === false);
  // 개선안 20261125000907_VISION 재개 원장 ③: 11-20 18:35 J20261120_180409 순서 재현(8단계 체인 4/8 에서 끊김 → 입장 대기 중 VMW 화면 갱신 → 재개)
  //   종전 결함 = 입장 대기(admit) 동안 get → decorate 가 '대기 아님'이라며 표시를 지우고 그 값을 job.json 에 저장. 새 개념 = 표시는 원장에서만 읽고 job.json 에 저장하지 않음
  const pd8 = path.join(vibeDir, 'orch', 'chain_progress');
  const k8 = ['k1', 'k2', 'k3', 'k4', 'k5', 'k6', 'k7', 'k8']; for (const k of k8) tasks[`T.${k}`] = k === 'k4' ? { id: 'T.k4', title: '4', kind: 'node', script: slowJs, args: [], cwd: root } : { id: `T.${k}`, title: k, kind: 'node', script: cntJs, args: [k], cwd: root };
  const ch8 = { label: '재개 시험 8단계', kind: 'chain', chainId: 'rjob8', batch: true, steps: k8.map((k, i) => ({ task: `T.${k}`, title: `${i + 1}. ${k}` })) };
  W('.vibe/quick.json', JSON.stringify({ groups: [{ title: 'g', items: [rchain, ch8] }] }));
  const j8 = jr2.create({ itemLabel: ch8.label, screens: ['SCP0028'], onFail: 'continue' }); jr2.start(j8.id);
  { const t8 = Date.now(); for (;;) { let cur = -1; try { const n = fs.readdirSync(pd8).find(x => x.startsWith('SCP0028_')); if (n) cur = JSON.parse(fs.readFileSync(path.join(pd8, n), 'utf8')).cur; } catch { } if (cur === 3 || Date.now() - t8 > 20000) break; await sleep(100); } }
  jr2.dispose(); wbm.abortRunningChains('시험: 18:35 재현 창 다시 로드'); await sleep(1500);
  const jr3 = reload(); await sleep(3500);
  const a8 = jr3.get(j8.id);
  chk('18:35 재현: 끊긴 지점 4/8 원장 기록', a8.screens[0].resume && a8.screens[0].resume.from === 4 && a8.screens[0].resume.of === 8, JSON.stringify(a8.screens[0].resume));
  a8.screens[0].status = 'admit'; a8.screens[0].summary = '부하 기준 초과 → 순차로 진행'; const g8 = jr3.get(j8.id); // 입장 대기 중 VMW 화면 갱신(get → decorate)
  const saved8 = JSON.parse(R(`.vibe/jobs/${j8.id}/job.json`));
  chk('입장 대기 중 갱신: 재개 표시 유지(원장에서 읽음) · job.json 에 재개 표시 저장 없음', g8.screens[0].resume && g8.screens[0].resume.from === 4 && saved8.screens.every(s => !('resume' in s)) && !('resumable' in saved8), JSON.stringify({ r: g8.screens[0].resume, saved: saved8.screens.map(s => Object.keys(s).includes('resume')) }));
  { const jf = path.join(vibeDir, 'jobs', j8.id, 'job.json'); const jj = JSON.parse(fs.readFileSync(jf, 'utf8')); jj.screens[0].status = 'admit'; fs.writeFileSync(jf, JSON.stringify(jj)); }
  W('fast.flag', '1');
  chk('18:35 재현: 작업 재개 시작', jr3.start(j8.id) === true);
  { const t8 = Date.now(); let b8; while (Date.now() - t8 < 40000) { b8 = jr3.get(j8.id); if (!/^(running|pausing)$/.test(b8.status)) break; await sleep(150); }
    const lg8 = R(`.vibe/jobs/${j8.id}/SCP0028.log`); const ss8 = events().filter(e => e.type === 'step.start' && e.job === j8.id && e.screen === 'SCP0028'); const rs8 = events().filter(e => e.type === 'chain.resume' && e.job === j8.id).pop(); const after = rs8 ? ss8.filter(e => e.runId === rs8.runId) : [];
    chk('18:35 재현: 재개가 4/8 단계부터 시작(1~3단계 1회씩 · 재개 실행 첫 단계 4)', b8.screens[0].status === 'done' && ['k1', 'k2', 'k3'].every(k => cnt(k) === 1) && ['k5', 'k6', 'k7', 'k8'].every(k => cnt(k) === 1) && /작업 재(개|시작): 4\/8단계/.test(lg8) && !!rs8 && rs8.resumeFrom === 4 && after.length > 0 && Math.min(...after.map(e => e.no)) === 4, JSON.stringify({ st: b8.screens[0].status, c: k8.map(k => cnt(k)), from: rs8 && rs8.resumeFrom, first: after.map(e => e.no) })); }
  // 재개 원장 ②: 원장 1개로 VMW, Workbench, VMO 조회 runId 집합이 같음
  { fs.mkdirSync(pd8, { recursive: true }); const t = Date.now(); const mk = (rid, scr, job) => fs.writeFileSync(path.join(pd8, `${rid}.json`), JSON.stringify({ runId: rid, screen: scr, job, wb: job ? `${job}:${scr}` : 1, label: '집합 시험', chainId: 'rjob', steps: 3, sig: 'x', cur: 1, res: [], interruptedAt: '2026-11-26T10:00:00+09:00', resumeFrom: 2, updatedMs: t, ownerPid: 999991 }));
    const jA = jr3.create({ itemLabel: rchain.label, screens: ['SSP0005', 'SSP0014'], onFail: 'continue' });
    mk('SSP0005_1795600000001', 'SSP0005', jA.id); mk('SSP0014_1795600000002', 'SSP0014', jA.id); mk('SCP0111_1795600000003', 'SCP0111', ''); mk('WB2_1795600000004_ai', '', '');
    const vmo = new Set(wbm.ledgerView ? wbm.ledgerView(p, 'vmo').map(r => r.runId) : []);
    const wbSet = new Set(); for (const s of ['SSP0005', 'SSP0014', 'SCP0111']) for (const r of (wbm.ledgerView ? wbm.ledgerView(p, 'wb', s) : [])) wbSet.add(r.runId);
    const gA = jr3.get(jA.id); const vmw = new Set(gA.screens.filter(s => s.resume && s.resume.runId).map(s => s.resume.runId)); const vmoJob = new Set([...vmo].filter(id => { try { return JSON.parse(fs.readFileSync(path.join(pd8, `${id}.json`), 'utf8')).job === jA.id; } catch { return false; } }));
    const eq = (a, b) => a.size === b.size && [...a].every(x => b.has(x));
    chk('원장 1개 조회 집합: VMO = Workbench(화면별 합) = 끊긴 기록 3건 · 빈 화면 기록 제외', eq(vmo, wbSet) && vmo.size === 3 && !vmo.has('WB2_1795600000004_ai'), JSON.stringify({ vmo: [...vmo], wb: [...wbSet] }));
    chk('원장 1개 조회 집합: VMW(작업 카드 재개 runId) = 같은 작업의 VMO 집합', eq(vmw, vmoJob) && vmw.size === 2, JSON.stringify({ vmw: [...vmw], vmoJob: [...vmoJob] }));
    for (const n of fs.readdirSync(pd8)) try { fs.unlinkSync(path.join(pd8, n)); } catch { } }
  jr3.dispose();
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
