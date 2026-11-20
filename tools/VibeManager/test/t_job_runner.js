// job-runner.js 시험 — 임시 폴더에서 업무 1개를 화면 여러 개에 순차 실행(가짜 vscode · node 작업). 실제 Claude·서버 불필요
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
const st = j => j.screens.map(s => `${s.id}:${s.status}`).join(' ');
const reload = () => { for (const k of Object.keys(require.cache)) if (/job-runner\.js$/.test(k)) delete require.cache[k]; const m = require(path.join(dir, 'job-runner')); m.init(api); return m; };
(async () => {
  const bi = jr.batchItems(); chk('고를 수 있는 업무 = batch 표시 + 창 없이 실행 가능한 것만', bi.length === 1 && bi[0].label === chain.label && bi[0].hasAsk === true && bi[0].steps === 2, JSON.stringify(bi.map(x => x.label)));
  chk('화면 ID 뽑기', JSON.stringify(jr.parseIds('scp0111, SSP0014\nSCP0111 x DMF0042A')) === '["SCP0111","SSP0014","DMF0042A"]');
  // 1) 순차 실행 · 실패 화면 표시 후 계속 · 승인 단계 답 없음
  W('fail.txt', 'TST0002');
  const j1 = jr.create({ itemLabel: chain.label, screens: ['tst0001', 'TST0002', 'TST0003', 'TST0001', 'bad id'], onFail: 'continue', autoAnswer: false });
  chk('작업 생성(중복·잘못된 ID 제외)', j1.screens.length === 3 && j1.status === 'idle' && fs.existsSync(path.join(vibeDir, 'jobs', j1.id, 'job.json')));
  const evs = []; jr.on((id, kind, d) => { if (kind === 'end') evs.push(d); });
  jr.start(j1.id); let a = await waitEnd(j1.id);
  chk('순차 실행 · 실패 뒤 계속', a.status === 'done' && st(a) === 'TST0001:done TST0002:fail TST0003:done', st(a));
  chk('실행 순서 = 선택 순서', R('order.txt').trim().split('\n').join(',') === 'TST0001,TST0002,TST0003', R('order.txt').trim().split('\n').join(','));
  chk('실패 원인 1줄 · 실행 주체 · 실행 기록 경로', /분석 자료 없음/.test(a.screens[1].why) && /스크립트 1단계/.test(a.screens[0].actorNote) && /FULLRUN\.md$/.test(a.screens[0].md), a.screens[1].why);
  const sm = R(`.vibe/jobs/${j1.id}/SUMMARY.md`); chk('SUMMARY.md 3행 · 결과 집계', (sm.match(/^\| \d+ \|/gm) || []).length === 3 && /완료 2 · 실패 1/.test(sm) && /분석 자료 없음/.test(sm));
  chk('화면별 로그 파일', /설계서 생성 TST0001/.test(R(`.vibe/jobs/${j1.id}/TST0001.log`)) && /설계서 생성 TST0001/.test(jr.logOf(j1.id, 'TST0001')));
  chk('끝 알림 1회', evs.length === 1 && evs[0].counts.done === 2 && evs[0].counts.fail === 1);
  // 2) 실패분만 다시(원인 해소 뒤) — 그 화면만 실행
  W('fail.txt', ''); fs.writeFileSync(path.join(root, 'order.txt'), '');
  chk('실패분만 다시 시작', jr.retryFailed(j1.id) === true); a = await waitEnd(j1.id);
  chk('실패분만 다시 = 그 화면만 실행 · 전부 완료', st(a) === 'TST0001:done TST0002:done TST0003:done' && R('order.txt').trim() === 'TST0002' && a.screens[1].tries === 2, R('order.txt').trim());
  chk('끝난 작업은 다시 시작 안 됨', jr.start(j1.id) === false && jr.retryFailed(j1.id) === false);
  // 3) 첫 실패에서 중단 · 승인 답 예
  W('fail.txt', 'TST0012'); fs.writeFileSync(path.join(root, 'order.txt'), '');
  const j2 = jr.create({ itemLabel: chain.label, screens: ['TST0011', 'TST0012', 'TST0013'], onFail: 'stop', autoAnswer: true });
  jr.start(j2.id); let b = await waitEnd(j2.id);
  chk('첫 실패에서 중단 · 뒤 화면 대기', b.status === 'stopped' && st(b) === 'TST0011:done TST0012:fail TST0013:wait' && /첫 실패에서 중단/.test(b.note), st(b) + ' ' + b.note);
  chk('승인 답 예 = 2단계도 실행(화면 1개에 작업 2회)', R('order.txt').trim().split('\n').filter(x => x === 'TST0011').length === 2);
  // 4) 일시 중지 → 이어서 실행
  W('fail.txt', ''); W('slow.txt', 'TST0021 TST0022 TST0023'); fs.writeFileSync(path.join(root, 'order.txt'), '');
  const j3 = jr.create({ itemLabel: chain.label, screens: ['TST0021', 'TST0022', 'TST0023'], onFail: 'continue' });
  jr.start(j3.id); await sleep(500); chk('일시 중지 요청', jr.pause(j3.id) === true && jr.get(j3.id).status === 'pausing');
  let c = await waitEnd(j3.id);
  chk('일시 중지 = 실행 중 화면은 끝까지 · 새 화면 시작 안 함', c.status === 'paused' && st(c) === 'TST0021:done TST0022:wait TST0023:wait', st(c));
  // 5) 창 다시 로드 흉내: 실행 중 상태로 남은 job.json 을 새로 읽으면 '중단됨' → 이어서 실행
  const jf = path.join(vibeDir, 'jobs', j3.id, 'job.json'); const raw = JSON.parse(fs.readFileSync(jf, 'utf8')); raw.status = 'running'; raw.screens[1].status = 'run'; fs.writeFileSync(jf, JSON.stringify(raw));
  const jr2 = reload(); const d0 = jr2.get(j3.id);
  chk('다시 읽으면 중단됨 · 실행 중이던 화면은 대기로', d0.status === 'interrupted' && st(d0) === 'TST0021:done TST0022:wait TST0023:wait', d0.status + ' ' + st(d0));
  chk('최근 작업 목록', jr2.list().length === 3 && jr2.list()[0].id === j3.id && jr2.list()[0].total === 3);
  fs.writeFileSync(path.join(root, 'order.txt'), ''); jr2.start(j3.id); await sleep(300);
  // 6) 중지: 실행 중 화면도 중지
  chk('중지 요청', jr2.stop(j3.id) === true);
  const t0 = Date.now(); let d; while (Date.now() - t0 < 20000) { d = jr2.get(j3.id); if (!jr2.running().length) break; await sleep(100); } await sleep(200); d = jr2.get(j3.id);
  chk('중지 = 실행 중 화면 중지 · 남은 화면 대기', d.status === 'stopped' && d.screens[0].status === 'done' && /^(cancel|fail)$/.test(d.screens[1].status) && d.screens[2].status === 'wait', d.status + ' ' + st(d));
  // 7) 이어서 실행 = 끝나지 않은 화면만
  W('slow.txt', ''); fs.writeFileSync(path.join(root, 'order.txt'), ''); jr2.start(j3.id);
  { const t1 = Date.now(); while (Date.now() - t1 < 20000 && jr2.running().length) await sleep(100); await sleep(200); }
  const e = jr2.get(j3.id); chk('이어서 실행 = 대기 화면만', e.status === 'done' && e.screens[2].status === 'done' && R('order.txt').trim() === 'TST0023', e.status + ' ' + st(e) + ' / ' + R('order.txt').trim());
  const ev = R('.vibe/orch/events.jsonl').trim().split('\n').map(l => JSON.parse(l));
  chk('사건 기록 job.start·item·end', ev.filter(x => x.type === 'job.start').length >= 5 && ev.some(x => x.type === 'job.item.end' && x.status === 'fail' && x.screen === 'TST0002') && ev.filter(x => x.type === 'job.end').length >= 5 && ev.some(x => x.type === 'chain.start' && x.job === j1.id));
  let threw = false; try { jr2.create({ itemLabel: '없는 업무', screens: ['TST0001'] }); } catch { threw = true; } chk('없는 업무 = 오류', threw);
  // 8) VMO 자가 복구 뒤 다시 실행(2026-11-20 requeueScreen): 실행 중 화면 = 멈추고 같은 작업에서 다시 · 실패로 끝난 화면 = 대기로 돌려 작업 재시작 · 2번 넘으면 안 함
  { const waitEnd = async (id, ms = 40000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { const j = jr2.get(id); if (!/^(running|pausing)$/.test(j.status)) { await sleep(150); return jr2.get(id); } await sleep(100); } return jr2.get(id); }; /* 여기서는 jr2 기준(위 waitEnd 는 jr 를 읽어 파일에서 다시 읽으면 '중단됨'으로 바꾼다) */
    W('slow.txt', 'TST0031'); W('fail.txt', ''); const j8 = jr2.create({ itemLabel: chain.label, screens: ['TST0031'], onFail: 'continue', autoAnswer: true }); jr2.start(j8.id);
    const t1 = Date.now(); while (Date.now() - t1 < 10000 && jr2.get(j8.id).screens[0].status !== 'run') await sleep(50); await sleep(300);
    W('slow.txt', ''); const rq = jr2.requeueScreen('TST0031', '시험 원인 해결'); const r8 = await waitEnd(j8.id);
    const ev8 = R('.vibe/orch/events.jsonl').trim().split('\n').map(l => JSON.parse(l));
    chk('실행 중 화면 다시 실행: 멈춤 → 같은 작업에서 다시 → 완료 · user.stop 기록(실패 사건 방지) · 다시 실행 1회', rq.how === 'stop-requeue' && r8.status === 'done' && r8.screens[0].status === 'done' && r8.screens[0].healed === 1 && ev8.some(x => x.type === 'user.stop' && x.wb === `${j8.id}:TST0031` && x.by === 'VMO') && ev8.some(x => x.type === 'job.item.requeue' && x.screen === 'TST0031'), JSON.stringify([rq, r8.status, r8.screens[0]]));
    W('fail.txt', 'TST0032'); const j9 = jr2.create({ itemLabel: chain.label, screens: ['TST0032'], onFail: 'continue', autoAnswer: true }); jr2.start(j9.id); await waitEnd(j9.id);
    W('fail.txt', ''); const rq2 = jr2.requeueScreen('TST0032', '시험 원인 해결'); const r9 = await waitEnd(j9.id);
    chk('실패로 끝난 화면 다시 실행: 대기로 돌려 작업 재시작 → 완료', /^(restart|requeue)$/.test(rq2.how) && r9.status === 'done' && r9.screens[0].status === 'done', JSON.stringify([rq2, r9.status, st(r9)]));
    { const x = jr2.get(j9.id); x.screens[0].healed = 2; } const rq3 = jr2.requeueScreen('TST0032', '세 번째');
    chk('같은 작업에서 2번 넘게 다시 실행 안 함', !!rq3.none && /2번/.test(rq3.none), JSON.stringify(rq3));
    // 9) 요청 파일로 화면 하나 중지(2026-11-20): 다른 화면은 계속 · 중지 화면 = cancel · user.stop 기록 · 결과 .done.json
    W('slow.txt', 'TST0041 TST0042'); const j10 = jr2.create({ itemLabel: chain.label, screens: ['TST0041', 'TST0042'], onFail: 'continue', autoAnswer: true }); jr2.start(j10.id);
    { const t1 = Date.now(); while (Date.now() - t1 < 10000 && jr2.get(j10.id).screens[0].status !== 'run') await sleep(30); } await sleep(150);
    W('.vibe/orch/stop_requests/a1.json', JSON.stringify({ screen: 'tst0041', action: 'stop', by: '에이전트 대화', why: '사용자 지시' })); W('slow.txt', '');
    chk('요청 파일 처리 1건', jr2.pollRequests() === 1 && !fs.existsSync(path.join(vibeDir, 'orch', 'stop_requests', 'a1.json')));
    const r10 = await waitEnd(j10.id); const done = JSON.parse(R('.vibe/orch/stop_requests/a1.done.json')); const ev10 = R('.vibe/orch/events.jsonl').trim().split('\n').map(l => JSON.parse(l));
    chk('요청 화면만 중지(cancel · 사유) · 다른 화면 완료 · user.stop · 결과 파일', r10.screens[0].status === 'cancel' && /에이전트 대화/.test(r10.screens[0].summary) && r10.screens[1].status === 'done' && done.job === j10.id && ev10.some(x => x.type === 'user.stop' && x.wb === `${j10.id}:TST0041`), JSON.stringify([st(r10), r10.screens[0].summary, done]));
    W('.vibe/orch/stop_requests/a2.json', JSON.stringify({ screen: 'TST0099' })); jr2.pollRequests(); chk('실행 중 아닌 화면 = 안 함 사유', /실행 중인 VMW 작업 없음/.test(JSON.parse(R('.vibe/orch/stop_requests/a2.done.json')).none)); }
  await sleep(600); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
