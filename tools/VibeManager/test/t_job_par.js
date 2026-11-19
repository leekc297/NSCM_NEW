// job-runner.js 동시 실행 시험(P9·P10) — 최대 동시 수 · 부하 기준 초과 시 순차 · 입장 간격 · Claude 세션 상한 · VMO 일시 중지/재개 · DB MODE 의 생성 업무 차단
//   사용: node test/t_job_par.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const vs = new Proxy({}, { get: (t, k) => {
  if (k === 'window') return new Proxy({}, { get: () => () => Promise.resolve(undefined) });
  if (k === 'commands') return { executeCommand: () => Promise.resolve(), registerCommand: () => ({ dispose() { } }) };
  if (k === 'workspace') return { getConfiguration: () => ({ get: () => undefined }), workspaceFolders: [] };
  if (k === 'Uri') return { file: f => ({ fsPath: f }), parse: s => s };
  return function () { };
} });
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? vs : orig.call(this, r, ...a); };
const dir = process.argv[2] || path.join(__dirname, '..');
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'jobpar-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
const setCfg = (scope, orch) => W('tools/Harness/harness.json', JSON.stringify({ repairScope: scope, llmReview: false, orch: Object.assign({ jobPollMs: 200, jobBusyPollMs: 300, jobMaxPar: 3 }, orch) }));
W('tools/E2E/e2e.config.json', JSON.stringify({ verifyLoadCpuMax: 80, verifyLoadMemFreeMinMB: 3072, verifyAdmitRampSec: 120 }));
// 작업: 시작·끝 시각을 times.txt 에 남기고 1.2초 걸린다
const slowJs = W('tools/t/slow.js', "const fs=require('fs'),path=require('path');const id=process.argv[2];const f=path.join(process.cwd(),'times.txt');fs.appendFileSync(f,'S '+id+' '+Date.now()+'\\n');setTimeout(()=>{fs.appendFileSync(f,'E '+id+' '+Date.now()+'\\n');console.log('[INFO] done '+id);},1200);");
const fake = W('.vibe/fake_claude.js', `
const fs=require('fs'),path=require('path');let inp='';let done=false;process.stdin.on('data',d=>{inp+=d;if(inp.includes('\\n'))go();});
function go(){if(done)return;done=true;const out=o=>console.log(JSON.stringify(o));const f=path.join('.vibe','ctimes.txt');fs.appendFileSync(f,'S '+Date.now()+'\\n');
 setTimeout(()=>{fs.appendFileSync(f,'E '+Date.now()+'\\n');out({type:'system',subtype:'init',session_id:'s'});out({type:'assistant',message:{content:[{type:'text',text:'ok'}]}});out({type:'result',is_error:false,num_turns:1,duration_ms:5,total_cost_usd:0.01,session_id:'s'});},900);}
`);
const fakeCmd = W('.vibe/fake_claude.cmd', `@node "${fake}" %*\r\n`);
const items = [
  { label: '느린 업무', kind: 'chain', chainId: 'slow', batch: true, steps: [{ task: 'T.slow', title: '1. 실행' }] },
  { label: 'Claude 업무', kind: 'chain', chainId: 'cl', batch: true, steps: [{ claude: '화면 ${id}', title: '1. Claude' }] },
  { label: 'CheckList 형태', kind: 'chain', chainId: 'checklist', batch: true, steps: [{ task: 'S8.checklistRun', title: '1. CheckList' }] },
  { label: '새 화면 생성', kind: 'chain', chainId: 'full', batch: true, newScreen: true, steps: [{ task: 'T.slow', title: '1. 생성' }] },
];
W('.vibe/quick.json', JSON.stringify({ groups: [{ title: 'g', items }] }));
const tasks = { 'T.slow': { id: 'T.slow', title: '느린 작업', kind: 'node', script: slowJs, args: ['${input:id}'], cwd: root }, 'S8.checklistRun': { id: 'S8.checklistRun', title: 'CheckList', kind: 'node', script: slowJs, args: ['${input:id}'], cwd: root } };
const p = { root, vibeDir, extDir: dir, genDir: path.join(root, 'Doc', 'gen'), outDir: path.join(root, 'Doc', 'asisfacts'), tobeDir: path.join(root, 'nscm-fe'), promptsDir: path.join(root, 'prompts'), node: 'node', python: 'python', powershell: 'powershell', claude: fakeCmd, claudeModel: '', permissionMode: 'bypassPermissions', language: 'ko' };
const api = { ctx: { workspaceState: { get: () => undefined, update: () => { } }, extensionPath: dir }, paths: () => p, loadSteps: () => ({}), findTask: id => tasks[id] || null,
  collectInputs: async (task, preset) => Object.assign({}, p, { inputs: Object.assign({}, preset || {}) }),
  subst: (text, vars) => String(text == null ? '' : text).replace(/\$\{(input:)?([A-Za-z0-9_]+)\}/g, (m, isIn, n) => isIn ? (vars.inputs && vars.inputs[n] != null ? vars.inputs[n] : '') : (vars[n] != null ? String(vars[n]) : m)),
  buildArgs: (task, vars) => (task.args || []).map(a => api.subst(a, vars)).filter(x => x !== ''), openPath: () => { }, pageDirOf: () => '', menuSections: () => [], claudeEnv: () => ({}), runTaskById: async () => 0, record: () => { }, afterTask: () => { } };
setCfg('DB_FE', {});
const st = require(path.join(dir, 'orch-state')); const watch = require(path.join(dir, 'orch-watch')); const jr = require(path.join(dir, 'job-runner')); jr.init(api);
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const sleep = t => new Promise(r => setTimeout(r, t));
const waitEnd = async (id, ms = 60000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { const j = jr.get(id); if (!/^(running|pausing)$/.test(j.status) && !jr.running().some(x => x.id === id)) { await sleep(150); return jr.get(id); } await sleep(100); } return jr.get(id); };
const maxOverlap = f => { let cur = 0, mx = 0; let lines = []; try { lines = fs.readFileSync(path.join(root, f), 'utf8').trim().split('\n').map(l => l.split(' ')).map(a => ({ k: a[0], t: Number(a[a.length - 1]) })).sort((a, b) => a.t - b.t || (a.k === 'E' ? -1 : 1)); } catch { } for (const l of lines) { cur += l.k === 'S' ? 1 : -1; mx = Math.max(mx, cur); } return mx; };
const reset = f => { try { fs.unlinkSync(path.join(root, f)); } catch { } };
const stt = j => j.screens.map(s => `${s.id}:${s.status}`).join(' ');
(async () => {
  st.init(p); await sleep(4600);                                  // CPU 측정값이 생길 때까지(2초 간격 표본 2개)
  chk('부하 측정값 준비', st.load().cpu != null, JSON.stringify(st.load()));
  // 1) 동시 2 · 부하 기준 통과 · 입장 간격 0
  setCfg('DB_FE', { jobLoadCpuMax: 101, jobLoadMemFreeMinMB: 0, jobRampSec: 0 });
  let t0 = Date.now(); let j = jr.create({ itemLabel: '느린 업무', screens: ['TST0001', 'TST0002', 'TST0003', 'TST0004'], mode: 'par', maxPar: 2 }); jr.start(j.id); let a = await waitEnd(j.id); const parMs = Date.now() - t0;
  chk('동시 실행 최대 2 · 전부 완료', a.status === 'done' && a.screens.every(s => s.status === 'done') && maxOverlap('times.txt') === 2, `겹침 ${maxOverlap('times.txt')} · ${parMs}ms · ${stt(a)}`);
  // 2) 부하 기준 초과 → 순차로 내려감
  reset('times.txt'); setCfg('DB_FE', { jobLoadCpuMax: 0, jobLoadMemFreeMinMB: 0, jobRampSec: 0 });
  let sawAdmit = ''; const un = jr.on((id, kind, d) => { if (kind === 'job') { const s = d.screens.find(x => x.status === 'admit'); if (s) sawAdmit = s.summary; } });
  t0 = Date.now(); j = jr.create({ itemLabel: '느린 업무', screens: ['TST0011', 'TST0012', 'TST0013'], mode: 'par', maxPar: 3 }); jr.start(j.id); a = await waitEnd(j.id); const seqMs = Date.now() - t0; un();
  chk('부하 기준 초과 = 순차(겹침 1) · 입장 대기 사유 표시', a.status === 'done' && maxOverlap('times.txt') === 1 && /부하 기준 초과 — CPU/.test(sawAdmit), `겹침 ${maxOverlap('times.txt')} · ${seqMs}ms · ${sawAdmit}`);
  // 3) 입장 간격: 방금 시작한 화면이 있으면 그 간격 동안 다음 화면을 들이지 않는다
  reset('times.txt'); setCfg('DB_FE', { jobLoadCpuMax: 101, jobLoadMemFreeMinMB: 0, jobRampSec: 60 });
  let sawRamp = ''; const un2 = jr.on((id, kind, d) => { if (kind === 'job') { const s = d.screens.find(x => x.status === 'admit'); if (s) sawRamp = s.summary; } });
  j = jr.create({ itemLabel: '느린 업무', screens: ['TST0021', 'TST0022'], mode: 'par', maxPar: 2 }); jr.start(j.id); a = await waitEnd(j.id); un2();
  chk('입장 간격 안에는 동시 시작 안 함', a.status === 'done' && maxOverlap('times.txt') === 1 && /입장 간격 60초/.test(sawRamp), sawRamp);
  // 4) CheckList 형태(스스로 부하 입장) = 부하 기준과 무관하게 최대 동시 수만 적용
  reset('times.txt'); setCfg('DB_FE', { jobLoadCpuMax: 0, jobRampSec: 60 });
  chk('CheckList 형태 판별', jr.batchItems().find(x => x.label === 'CheckList 형태').selfAdmit === true && jr.batchItems().find(x => x.label === '느린 업무').selfAdmit === false);
  j = jr.create({ itemLabel: 'CheckList 형태', screens: ['TST0031', 'TST0032', 'TST0033'], mode: 'par', maxPar: 2 }); jr.start(j.id); a = await waitEnd(j.id);
  chk('CheckList 형태 = 부하 판정을 겹쳐 하지 않음(겹침 2)', a.status === 'done' && maxOverlap('times.txt') === 2, `겹침 ${maxOverlap('times.txt')}`);
  // 5) 동시 Claude 세션 상한 1 — 화면 3개가 동시에 돌아도 Claude 는 1개씩
  setCfg('DB_FE', { jobLoadCpuMax: 101, jobLoadMemFreeMinMB: 0, jobRampSec: 0, jobMaxClaude: 1 });
  j = jr.create({ itemLabel: 'Claude 업무', screens: ['TST0041', 'TST0042', 'TST0043'], mode: 'par', maxPar: 3 }); jr.start(j.id); a = await waitEnd(j.id);
  chk('Claude 세션 상한 1 = Claude 겹침 1 · 전부 완료', a.status === 'done' && a.screens.every(s => s.status === 'done') && maxOverlap('.vibe/ctimes.txt') === 1, `Claude 겹침 ${maxOverlap('.vibe/ctimes.txt')}`);
  reset('.vibe/ctimes.txt'); setCfg('DB_FE', { jobLoadCpuMax: 101, jobLoadMemFreeMinMB: 0, jobRampSec: 0, jobMaxClaude: 2 });
  j = jr.create({ itemLabel: 'Claude 업무', screens: ['TST0051', 'TST0052', 'TST0053'], mode: 'par', maxPar: 3 }); jr.start(j.id); a = await waitEnd(j.id);
  chk('Claude 세션 상한 2 = Claude 겹침 2', a.status === 'done' && maxOverlap('.vibe/ctimes.txt') === 2, `Claude 겹침 ${maxOverlap('.vibe/ctimes.txt')}`);
  const ev = fs.readFileSync(path.join(vibeDir, 'orch', 'events.jsonl'), 'utf8').trim().split('\n').map(l => JSON.parse(l));
  chk('세션 자리 대기 사건 기록', ev.some(e => e.type === 'claude.wait' && e.reason === 'gate' && e.ms_wait > 500));
  // 6) VMO 일시 중지(서버 이상 사건) → 사건 해결 → 다시 진행
  reset('times.txt'); watch.init(p, {}); jr.attachWatch(watch);
  j = jr.create({ itemLabel: '느린 업무', screens: ['TST0061', 'TST0062', 'TST0063'], mode: 'seq' }); jr.start(j.id); await sleep(400);
  const inc = watch.raise('R6', { sig: 'R6|listen|8080', title: '서버 응답 없음 — BE 포트 8080', evidence: { port: 8080 } });
  await sleep(200); const mid = jr.get(j.id);
  chk('서버 이상 사건 → 작업 일시 중지 요청', mid.status === 'pausing' && mid.pausedBy === 'orch' && /VMO 일시 중지/.test(mid.note) && (watch.get(inc.id).actions || []).some(x => /업무 작업 1건 일시 중지/.test(x.what)), mid.status + ' ' + mid.note);
  a = await waitEnd(j.id); chk('실행 중 화면은 끝까지 · 새 화면 시작 안 함', a.status === 'paused' && stt(a) === 'TST0061:done TST0062:wait TST0063:wait', stt(a));
  watch.update(inc.id, { status: 'resolved' }, { by: 'VMO', what: '서버 재기동 완료' });
  await sleep(300); chk('사건 해결 → 작업 다시 진행', jr.get(j.id).status === 'running', jr.get(j.id).status);
  a = await waitEnd(j.id); chk('다시 진행 뒤 전부 완료', a.status === 'done' && a.screens.every(s => s.status === 'done'), stt(a));
  // 7) 화면을 만들거나 고치는 업무 = UI/DB MODE 에서만
  let bi = jr.batchItems().find(x => x.label === '새 화면 생성'); chk('UI/DB MODE = 생성 업무 고를 수 있음', bi.gen === true && bi.disabled === false);
  setCfg('DB_ONLY', {}); bi = jr.batchItems().find(x => x.label === '새 화면 생성');
  chk('DB MODE = 생성 업무 비활성 + 사유', bi.disabled === true && /UI\/DB MODE 에서만/.test(bi.why) && jr.batchItems().find(x => x.label === '느린 업무').disabled === false);
  let threw = ''; try { jr.create({ itemLabel: '새 화면 생성', screens: ['TST0071'] }); } catch (e) { threw = e.message; } chk('DB MODE 에서 생성 업무 작업 만들기 = 거부', /DB MODE/.test(threw), threw);
  watch.dispose(); st.dispose(); await sleep(600); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
