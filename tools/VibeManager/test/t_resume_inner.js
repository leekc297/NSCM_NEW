// 단계 안 작업 재개(2026-11-20 사용자 지시 '작업재개는 중단된 시점이나 그 바로 이전단계부터 … 처음부터 시작하는 것이면 재시작')
//   ① 스크립트 단계: 세부 진행(단계 i/N · 시험 n/N)을 진행 기록 sub 에 남기고, 재개 때 VM_RESUME=1 · VM_RESUME_RUN 을 그 단계에 넘김 · 스크립트가 지원하면 '작업 재개'
//   ② 단계 안 재개를 지원하지 않는 스크립트 = '작업 재시작'(restart) 표시
//   ③ AI 단계: 세션 ID 를 기록하고 재개 때 --resume <세션> + 재개 문구
//   ④ 수선 회차: 2회차에서 끊기면 첫 실행·1회차를 다시 하지 않고 2회차부터
//   사용: node test/t_resume_inner.js <VibeManager 폴더>
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
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'rin-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', llmReview: false }));
W('.vibe/quick.json', JSON.stringify({ groups: [{ title: 'g', items: [{ label: 'RQ', kind: 'claude', prompt: '수선 ${round} ${id}' }] }] }));
const cntJs = W('tools/t/cnt.js', "const fs=require('fs'),path=require('path');const k=process.argv[2];const f=path.join(process.cwd(),'out','cnt_'+k+'.txt');fs.mkdirSync(path.dirname(f),{recursive:true});fs.appendFileSync(f,'x');");
// 단계 안 재개 지원 스크립트(원문에 VM_RESUME 처리): 진행 줄을 찍고 오래 걸림. 재개 신호를 받으면 받은 값을 남기고 바로 끝
const progJs = W('tools/t/prog.js', [
  "const fs=require('fs'),path=require('path');",
  "if(process.env.VM_RESUME==='1'){fs.mkdirSync(path.join(process.cwd(),'out'),{recursive:true});fs.writeFileSync(path.join(process.cwd(),'out','resume_env.txt'),process.env.VM_RESUME_RUN||'');process.exit(0);}",
  "console.log('[단계 1/8] 사전 작업');console.log('[단계 4/8] E2E 검증엔진(@verify·@trace) — 세부 0개');console.log('Running 81 tests using 1 workers');",
  "for(let i=1;i<=50;i++)console.log('  ok '+i+' [chromium] t'+i);",
  "setTimeout(()=>process.exit(0),20000);"].join('\n'));
const slowJs = W('tools/t/slow.js', "console.log('[단계 2/8] 지원 안 함');setTimeout(()=>process.exit(0),20000);");
const badJs = W('tools/t/bad.js', "const fs=require('fs'),path=require('path');const f=path.join(process.cwd(),'out','bad_cnt.txt');fs.mkdirSync(path.dirname(f),{recursive:true});fs.appendFileSync(f,'x');console.log('[FAIL] 판정 남음');process.exit(6);");
const fake = W('.vibe/fake_claude.js', `
const fs=require('fs'),path=require('path');let inp='';let done=false;process.stdin.on('data',d=>{inp+=d;if(inp.includes('\\n'))go();});
function go(){if(done)return;done=true;let txt='';try{txt=JSON.parse(inp.split('\\n')[0]).message.content[0].text;}catch(e){}
 const args=process.argv.slice(2).join(' ');fs.appendFileSync(path.join('.vibe','calls.txt'),JSON.stringify({args,txt:txt.slice(0,2000)})+'\\n');
 const m=/--resume (\\S+)/.exec(args);const sid=m?m[1]:'sess-'+(/수선/.test(txt)?'rq':'ai');const out=o=>console.log(JSON.stringify(o));
 out({type:'system',subtype:'init',session_id:sid});
 const hang=(/HANG/.test(txt)||/수선 2 /.test(txt))&&!/창 다시 로드로/.test(txt);
 const fin=()=>{out({type:'assistant',message:{content:[{type:'text',text:'완료'}]}});out({type:'result',is_error:false,num_turns:1,duration_ms:5,total_cost_usd:0,session_id:sid});};
 if(hang)setTimeout(fin,60000);else fin();}
`);
const fakeCmd = W('.vibe/fake_claude.cmd', `@node "${fake}" %*\r\n`);
const tasks = {
  'T.c1': { id: 'T.c1', title: '1단계', kind: 'node', script: cntJs, args: ['a'], cwd: root },
  'T.c3': { id: 'T.c3', title: '3단계', kind: 'node', script: cntJs, args: ['c'], cwd: root },
  'T.prog': { id: 'T.prog', title: '측정(단계 안 재개 지원)', kind: 'node', script: progJs, args: [], cwd: root },
  'T.slow': { id: 'T.slow', title: '오래 걸림(지원 안 함)', kind: 'node', script: slowJs, args: [], cwd: root },
  'T.bad': { id: 'T.bad', title: '판정 남음', kind: 'node', script: badJs, args: [], cwd: root },
};
const p = { root, vibeDir, extDir: dir, genDir: path.join(root, 'Doc', 'gen'), outDir: path.join(root, 'Doc', 'asisfacts'), tobeDir: path.join(root, 'nscm-fe'), promptsDir: path.join(root, 'prompts'), node: 'node', python: 'python', powershell: 'powershell', claude: fakeCmd, claudeModel: '', permissionMode: 'bypassPermissions', language: 'ko' };
const api = {
  ctx: { workspaceState: { get: () => undefined, update: () => { } }, extensionPath: dir },
  paths: () => p, loadSteps: () => ({}), findTask: id => tasks[id] || null,
  collectInputs: async (task, preset) => Object.assign({}, p, { inputs: Object.assign({}, preset || {}) }),
  subst: (text, vars) => String(text == null ? '' : text).replace(/\$\{(input:)?([A-Za-z0-9_]+)\}/g, (m, isIn, n) => isIn ? (vars.inputs && vars.inputs[n] != null ? vars.inputs[n] : '') : (vars[n] != null ? String(vars[n]) : m)),
  buildArgs: (task, vars) => (task.args || []).map(a => api.subst(a, vars)).filter(x => x !== ''),
  openPath: () => { }, pageDirOf: () => '', menuSections: () => [], claudeEnv: () => ({}),
  runTaskById: async () => 0, record: () => { }, afterTask: () => { },
};
const { ChainRunner } = require(path.join(dir, 'chain-runner')); const wbm = require(path.join(dir, 'workbench'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const cnt = k => { try { return fs.readFileSync(path.join(root, 'out', `${k}.txt`), 'utf8').length; } catch { return 0; } };
const calls = () => { try { return fs.readFileSync(path.join(vibeDir, 'calls.txt'), 'utf8').trim().split('\n').filter(Boolean).map(l => JSON.parse(l)); } catch { return []; } };
const mk = (id, job) => new ChainRunner(api, { id, jobId: job || '', autoAnswer: false, onLog: () => { }, onStep: () => { }, onNote: () => { } });
// 2026-11-26: 고정 시각에 끊으면 전체 시험 부하(다른 세션과 겹침)에서 목표 지점 전에 끊겨 흔들림(16:34, 18:25 전체 실행에서 ④ 실패, 단독 통과).
//   until 이 있으면 ms 뒤부터 until() 이 참이 될 때까지(최대 40초) 기다렸다 끊는다
const liveProg = id => { try { const d = path.join(vibeDir, 'orch', 'chain_progress'); for (const n of fs.readdirSync(d)) { if (!n.toUpperCase().startsWith(String(id).toUpperCase() + '_')) continue; const j = JSON.parse(fs.readFileSync(path.join(d, n), 'utf8')); if (!j.interruptedAt) return j; } } catch { } return null; };
const cut = async (r, pr, ms, until) => { await new Promise(res => setTimeout(res, ms)); if (until) { const t0 = Date.now(); while (!until() && Date.now() - t0 < 40000) await new Promise(res => setTimeout(res, 100)); } r.stop(); wbm.abortRunningChains('시험: 창 다시 로드'); await pr; };
(async () => {
  // ① 단계 안 재개 지원 스크립트
  const chA = { kind: 'chain', label: '측정 체인', chainId: 'tA', steps: [{ task: 'T.c1', title: '1. 첫 단계' }, { task: 'T.prog', title: '2. 측정' }, { task: 'T.c3', title: '3. 끝 단계' }] };
  const a1 = mk('rin0001'); await cut(a1, a1.run(chA), 3500);
  const recA = wbm.resumable(p, { screen: 'rin0001' })[0];
  chk('끊긴 단계 세부 진행 기록(단계 4/8 · 시험 50/81)', recA && recA.sub && /단계 4\/8/.test(recA.sub.prog || '') && /시험 50\/81/.test(recA.sub.prog || ''), JSON.stringify(recA && recA.sub));
  chk('끊긴 단계 이름 기록', recA && recA.curName === '2. 측정', recA && recA.curName);
  const plA = wbm.resumePlan(p, api, recA);
  chk('지원 스크립트 = 작업 재개(단계 안 끊긴 지점부터 · 끊길 때 지점 표시)', !plA.restart && /2\/3단계 '2\. 측정' · 단계 안 끊긴 지점부터/.test(plA.text) && /시험 50\/81/.test(plA.text), plA.text);
  const a2 = mk('rin0001'); const bA = await a2.run(chA, { resume: recA });
  chk('재개 완료 OK · 1단계 다시 안 함 · 3단계 실행', bA.status === 'OK' && cnt('cnt_a') === 1 && cnt('cnt_c') === 1, JSON.stringify({ s: bA.status, a: cnt('cnt_a'), c: cnt('cnt_c') }));
  let envRun = ''; try { envRun = fs.readFileSync(path.join(root, 'out', 'resume_env.txt'), 'utf8'); } catch { }
  chk('끊긴 단계에 VM_RESUME=1 · VM_RESUME_RUN 전달', envRun === recA.runId, `${envRun} vs ${recA.runId}`);
  // ② 지원하지 않는 스크립트 = 재시작 표시
  const chB = { kind: 'chain', label: '재시작 체인', chainId: 'tB', steps: [{ task: 'T.c1', title: '1. 첫 단계' }, { task: 'T.slow', title: '2. 오래 걸림' }] };
  const b1 = mk('rin0002'); await cut(b1, b1.run(chB), 2500);
  const recB = wbm.resumable(p, { screen: 'rin0002' })[0]; const plB = wbm.resumePlan(p, api, recB);
  chk('지원 안 하는 스크립트 = 작업 재시작(restart) · 처음부터 · 끊길 때 지점', plB.restart && /이 단계는 처음부터/.test(plB.text) && /단계 2\/8/.test(plB.text), plB.text);
  wbm._progDel(p, recB.runId);
  // ③ AI 단계 세션 이어받기
  const chC = { kind: 'chain', label: 'AI 체인', chainId: 'tC', steps: [{ task: 'T.c1', title: '1. 첫 단계' }, { claude: 'HANG 보완 ${id}', title: '2. AI 보완' }] };
  const c1 = mk('rin0003'); await cut(c1, c1.run(chC), 4000);
  const recC = wbm.resumable(p, { screen: 'rin0003' })[0];
  chk('AI 단계 세션 ID 기록', recC && recC.sub && recC.sub.session === 'sess-ai', JSON.stringify(recC && recC.sub));
  const plC = wbm.resumePlan(p, api, recC);
  chk('AI 단계 표시 = 세션 이어받기', !plC.restart && /AI 세션 이어받기/.test(plC.text), plC.text);
  const c2 = mk('rin0003'); const n0 = calls().length; const bC = await c2.run(chC, { resume: recC });
  const cc = calls().slice(n0);
  chk('재개 = --resume sess-ai + 재개 문구 + 원래 지시', cc.length === 1 && /--resume sess-ai/.test(cc[0].args) && /창 다시 로드로/.test(cc[0].txt) && /HANG 보완 RIN0003/i.test(cc[0].txt), JSON.stringify(cc));
  chk('AI 단계 재개 완료 OK', bC.status === 'OK', bC.status);
  // ④ 수선 2회차에서 끊김 → 2회차부터
  const chD = { kind: 'chain', label: '수선 체인', chainId: 'tD', steps: [{ task: 'T.bad', title: '1. 판정', repair: { claudeOf: 'RQ', rounds: 3 } }] };
  const d1 = mk('rin0004'); await cut(d1, d1.run(chD), 1500, () => { const j = liveProg('rin0004'); return !!(j && j.sub && j.sub.round === 2 && j.sub.stage === 'ai'); });
  const recD = wbm.resumable(p, { screen: 'rin0004' })[0];
  chk('끊기기 전: 첫 실행 + 1회차 뒤 재실행 = 2회 실행', cnt('bad_cnt') === 2, cnt('bad_cnt'));
  chk('수선 회차 기록(2회차 · AI 단계 · 첫 실행 종료코드)', recD && recD.sub && recD.sub.round === 2 && recD.sub.stage === 'ai' && recD.sub.code === 6, JSON.stringify(recD && recD.sub));
  const plD = wbm.resumePlan(p, api, recD);
  chk('수선 표시 = 수선 2회차부터', !plD.restart && /수선 2회차부터/.test(plD.text), plD.text);
  const d2 = mk('rin0004'); const n1 = calls().length; const bD = await d2.run(chD, { resume: recD });
  const cd = calls().slice(n1);
  chk('재개: 첫 실행 생략 · 2회차 AI(재개 문구) → 재실행 → 3회차 AI → 재실행', cnt('bad_cnt') === 4 && cd.length === 2 && /창 다시 로드로/.test(cd[0].txt) && /수선 2 /.test(cd[0].txt) && /수선 3 /.test(cd[1].txt) && !/창 다시 로드로/.test(cd[1].txt), JSON.stringify({ n: cnt('bad_cnt'), cd }));
  let fr = ''; try { fr = fs.readFileSync(path.join(root, 'Doc', 'gen', 'RIN0004', 'FULLRUN.md'), 'utf8'); } catch { }
  chk('수선 횟수 = 3회(끊기기 전 회차 포함 · FULLRUN.md)', /수선 3회/.test(fr), fr.split(String.fromCharCode(10)).filter(l => /판정/.test(l)).join(' | '));
  // 인자에 따라 단계 안 재개 여부가 다른 작업(steps.json resumeArg · pipeline.js --phase 4·5 만, 2026-11-20 R4 세션 요청)
  tasks['T.pipe'] = { id: 'T.pipe', title: 'pipeline', kind: 'node', script: progJs, args: [], cwd: root, resumeArg: { flag: '--phase', inner: ['4', '5'] } };
  const pipeRec = ph => ({ resumeFrom: 9, steps: 26, cur: 8, curActor: 'script', curTask: 'T.pipe', curName: `pipeline ${ph}`, curArgs: ph ? ['${input:id}', '--max', '3', '--phase', ph] : ['${input:id}'], sub: { prog: '세부 1/3' } });
  const pl4 = wbm.resumePlan(p, api, pipeRec('4')); const pl2 = wbm.resumePlan(p, api, pipeRec('2')); const pl0 = wbm.resumePlan(p, api, pipeRec(''));
  chk('phase 4 = 작업 재개(단계 안 끊긴 지점부터)', !pl4.restart && /단계 안 끊긴 지점부터/.test(pl4.text), pl4.text);
  chk('phase 2 = 작업 재시작(phase 2: 단계 안 재개 없음) · 스크립트 원문에 VM_RESUME 있어도', pl2.restart && /이 단계는 처음부터\(phase 2: 단계 안 재개 없음\)/.test(pl2.text), pl2.text);
  chk('phase 인자 없음 = 작업 재시작(phase 4·5 만 단계 안 재개)', pl0.restart && /phase 4·5 만 단계 안 재개/.test(pl0.text), pl0.text);
  chk('진행 기록에 단계 인자(curArgs) 기록', Array.isArray(recA.curArgs), JSON.stringify(recA.curArgs));
  // 체인 밖 AI 호출(메뉴 · 채팅) 기록의 표시
  const plS = wbm.resumePlan(p, api, { single: true, label: '🧯 자동 보완', sub: { session: 's9' } });
  chk('체인 밖 AI 호출 표시 = 세션 이어받기', !plS.restart && /🧯 자동 보완 · AI 세션 이어받기/.test(plS.text), plS.text);
  chk('재개 문구 = 원래 지시 포함', /창 다시 로드로/.test(wbm._resumePrompt('X')) && /\[원래 지시\]\nX$/.test(wbm._resumePrompt('X')));
  [a1, a2, b1, c1, c2, d1, d2].forEach(r => { try { r.dispose(); } catch { } });
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
