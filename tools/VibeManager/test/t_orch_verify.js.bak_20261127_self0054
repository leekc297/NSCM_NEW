// orch-verify.js 시험: 개선안 검증 글을 항목으로 나누고(반영할 때 실행, 반영 뒤 확인, 게이트 판정) 항목 결과로 합격을 판정한다. 실제 Claude 호출 없음
//   사용: node test/t_orch_verify.js <VibeManager 폴더>
//   표본 = 2026-11-19~11-23 반영 실패한 개선안의 verify 원문(.vibe/orch/proposals)
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const v = require(path.join(dir, 'orch-verify'));
let ok = true; const chk = (name, cond, extra) => { console.log(cond ? 'PASS' : 'FAIL', name, extra || ''); if (!cond) ok = false; };
const whens = (t, gated) => v.items(t, { gated: !!gated }).map(x => x.when).join(',');

// 20261123000419_VISION(11-23 반영 실패 5회)
const V419 = '1) 승인 뒤 writing-plans 로 전환 계획 작성. 2) t_orch_usercheck.js 에 events.jsonl:2001 을 넣어 U2 가 1판 시각과 체인 전체를 따로 표시하는지 시험. 3) 다음 SCP0028 체인에서 1판 xlsx 생성 시각을 chain.end 에서 확인하고, 1판과 최종 원장 차이가 보완 회차 행만인지 ledger_diff.py 로 대조. 4) 동시 실행 단계는 순차, 동시 원장 ledger_diff.py 차이 0건일 때만 채택';
// 20261120183740_VISION(11-23 12:11 반영 실패)
const V183 = '1) 재현 시험: 사건 줄 20261120_145605_R12_ALL·20261120_153113_R12_ALL 을 넣고 시한 60분 경과 시 진단 호출 1회, 조치 기록 1건 · 2) U3·U5·U7 표본 시험(t_orch_usercheck.js) 통과 · 3) node tools/VibeManager/test/run_all.js 전체 통과 · 4) 실가동 24시간 동안 result.json S13|U3|idleInc 0건';
// 20261121000456_SELF(11-21 00:17 반영 실패)
const V456 = '① node tools/VibeManager/test/t_orch_usercheck.js tools/VibeManager → ALL PASS, 생산자 검사 PASS 3건. 송출 줄을 지운 사본으로 같은 검사 FAIL 확인 ② node tools/VibeManager/test/t_webview_syntax.js tools/VibeManager 통과 ③ 재현 시험: events.jsonl:1579, 1589 줄을 넣고 resumedJobShown 실행 → norep warn 0건 ④ 창 다시 로드 뒤 작업 재개 1회 → ui.json 에 jobs, wb, scr 키 생김';
// 20261120005819_INC(11-20 06:39 반영 실패)
const V819 = 'node --check tools/VibeManager/workbench.js, node tools/VibeManager/test/run_all.js 통과. 작업 목록에서 3화면 동시 CheckList 시작 뒤 events.jsonl proc.start 의 log 값 3개가 서로 다른지 확인';
// 20261120115806_VISION_2(11-20 16:21 반영 실패)
const V806 = 'tools/E2E 형식 검사(tsc --noEmit) 통과. 다음 CheckList 실행 뒤 _test_timing.jsonl 에서 wait@probe.ts:60 이 있는 시험마다 waitWhy 가 채워졌는지 건수 대조, 기대 = wait@probe.ts:60 있는 시험 수와 같음';

chk('000419_VISION: 4항목, 3번 = 반영 뒤 확인', whens(V419) === 'apply,apply,later,apply', whens(V419));
chk('183740_VISION: 3번 run_all = 게이트 판정(게이트 있는 안), 4번 실가동 24시간 = 반영 뒤 확인', whens(V183, true) === 'apply,apply,gate,later', whens(V183, true));
chk('183740_VISION: 게이트 없는 안이면 run_all 은 반영할 때 실행', whens(V183, false) === 'apply,apply,apply,later', whens(V183, false));
chk('000456_SELF: ④ 창 다시 로드 뒤 = 반영 뒤 확인', whens(V456, true) === 'apply,apply,apply,later', whens(V456, true));
chk('005819_INC: CheckList 시작 뒤 확인 = 반영 뒤 확인', whens(V819) === 'apply,later', whens(V819));
chk('115806_VISION_2: 다음 CheckList 실행 뒤 = 반영 뒤 확인', whens(V806) === 'apply,later', whens(V806));
// 한 항목에 지금 잴 것과 반영 뒤 확인이 섞임 → 나눔(지금 잴 수 있는 부분을 반영 뒤로 넘기지 않음). 20261120225006_SELF_5, 20261121100244_REVIEW
{ const a = v.items('삭제 뒤 Test-Path 3개 모두 False, 다음 S10 점검에 세 key 없음');
  chk('섞인 항목 나눔: 앞 = 반영할 때 실행, 뒤 = 반영 뒤 확인', a.length === 2 && a[0].when === 'apply' && /Test-Path/.test(a[0].text) && a[1].when === 'later' && /S10/.test(a[1].text), JSON.stringify(a));
  const b = v.items('node tools/VibeManager/test/run_all.js 통과. 지금 events.jsonl 로 집계를 다시 냈을 때 waits dbwin gone 4 대신 고유 대기 기준 값이 나오고, VM 창 다시 로드 뒤 새 wait.gone 줄이 0줄 늘어남', { gated: true });
  chk('섞인 항목 나눔: 게이트, 반영할 때 실행, 반영 뒤 확인', b.map(x => x.when).join(',') === 'gate,apply,later', JSON.stringify(b.map(x => [x.when, x.text.slice(0, 30)]))); }
chk('인용 안 마침표에서 나누지 않음', v.items("반영 뒤 7일 동안 history 에 '반영 실패. 검증 실패' 가 있는 개선안 0건").length === 1);
chk('시험 파일을 함께 적은 항목은 게이트 판정으로 빼지 않음', whens('node tools/VibeManager/test/t_orch_watch_gone.js 에 시험 2건 추가. node tools/VibeManager/test/run_all.js 통과', true) === 'apply,gate');
chk('반영 뒤, 삭제 뒤 같은 말은 반영할 때 실행', whens('반영 뒤 grep 결과 0건. 삭제 뒤 두 파일 없음') === 'apply,apply');
chk('빈 글 = 항목 없음', v.items('').length === 0 && v.items(null).length === 0);

// 판정
const L419 = v.items(V419);
{ const j = v.judge(L419, { applied: true, verified: false, verify_items: [{ n: 1, result: 'pass' }, { n: 2, result: 'pass' }, { n: 4, result: 'blocked', note: 'CheckList 실행(사용자 실행)이 필요' }] }, { gated: false });
  chk('판정: 실행한 2건 통과, 3번 반영 뒤 확인, 4번 실행 못 함 → 합격(AI 가 verified false 를 냈어도)', j.verified === true && j.pass === 2 && j.post.length === 2 && j.post.some(x => x.n === 3) && j.post.some(x => x.n === 4 && /CheckList/.test(x.why)), JSON.stringify({ v: j.verified, pass: j.pass, post: j.post.map(x => x.n), why: j.why })); }
{ const j = v.judge(L419, { applied: true, verified: true, verify_items: [{ n: 1, result: 'pass' }, { n: 2, result: 'fail', note: 'U2 FAIL 5' }, { n: 4, result: 'blocked' }] }, {});
  chk('판정: 실행한 항목 실패 1건 → 불합격(AI 가 verified true 를 냈어도)', j.verified === false && j.fails.length === 1 && /v2/.test(j.why), j.why); }
{ const j = v.judge(L419, { applied: true, verified: false, verify_items: [{ n: 1, result: 'pass' }] }, {});
  chk('판정: 결과가 빠진 항목이 있고 verified false → 불합격', j.verified === false && /v2, v4/.test(j.why), j.why); }
{ const j = v.judge(L419, { applied: true, verified: false, verify_items: [{ n: 1, result: 'blocked' }, { n: 2, result: 'blocked' }, { n: 4, result: 'blocked' }] }, { gated: false });
  const j2 = v.judge(L419, { applied: true, verified: false, verify_items: [{ n: 1, result: 'blocked' }, { n: 2, result: 'blocked' }, { n: 4, result: 'blocked' }] }, { gated: true });
  chk('판정: 전부 실행 못 함 → 게이트 없는 안은 불합격, 게이트 있는 안은 게이트에 맡김', j.verified === false && /0건/.test(j.why) && j2.verified === true && j2.post.length === 4, `${j.why} / ${j2.post.length}`); }
{ const j = v.judge(L419, { applied: true, verified: false }, {}); const j2 = v.judge(L419, { applied: true, verified: true }, {});
  chk('판정: 항목 결과 없음 = 종전처럼 verified 값', j.legacy === true && j.verified === false && j2.verified === true); }
{ const j = v.judge([], { applied: true, verified: true }, {}); chk('판정: verify 빈 글 = verified 값', j.legacy === true && j.verified === true); }
{ const L = v.items('다음 S10 점검에서 S10|belog 항목 0건'); const j = v.judge(L, { applied: true, verified: false }, {});
  chk('판정: 반영 뒤 확인 항목뿐 = 합격, 확인 목록 1건', j.verified === true && j.post.length === 1, JSON.stringify(j.post)); }
{ const pl = v.promptLines(L419).join('\n'); chk('지시문: 항목 4줄과 시점, verify_items 형식', /v3 \(반영 뒤 확인/.test(pl) && /v1 \(반영할 때 실행\)/.test(pl) && pl.includes('verify_items') && pl.includes('blocked'), pl.slice(0, 200)); chk('지시문: 항목 없으면 빈 배열', v.promptLines([]).length === 0); }

// 승인 → 반영 → 판정(가짜 claude). 000419_VISION 과 같은 verify 로 종전에는 되돌려지던 결과가 반영 완료가 되는지 본다
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'verify-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); };
const R = rel => fs.readFileSync(path.join(root, rel), 'utf8');
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', orch: { agentEnabled: false, agentTimeoutMin: 1 } }));
W('Doc/a.txt', 'value: 1\n'); W('.gitignore', '.vibe/\n');
cp.execSync('git init -q && git add -A && git -c user.email=t@t -c user.name=t commit -q -m init', { cwd: root, windowsHide: true, stdio: 'ignore' });
const fake = path.join(vibeDir, 'fake_claude.js'); fs.mkdirSync(vibeDir, { recursive: true });
fs.writeFileSync(fake, `
const fs=require('fs'),path=require('path');let inp='';let done=false;process.stdin.on('data',d=>{inp+=d;if(inp.includes('\\n'))go();});
function go(){if(done)return;done=true;const mode=fs.readFileSync(path.join('.vibe','mode.txt'),'utf8').trim();const out=o=>console.log(JSON.stringify(o));
 fs.writeFileSync(path.join('Doc','a.txt'),'value: 2\\n');
 const items=mode==='items-ok'?[{n:1,result:'pass',note:'계획 있음'},{n:2,result:'pass',note:'U2 PASS 6'},{n:4,result:'blocked',note:'CheckList 실행이 필요'}]:[{n:1,result:'pass'},{n:2,result:'fail',note:'U2 FAIL 5'},{n:4,result:'blocked'}];
 const j={applied:true,already_applied:false,verified:false,verify_items:items,changed_files:['Doc/a.txt'],verify_result:'1) 통과 2) '+(mode==='items-ok'?'통과':'실패')+' 3) 4) 미실행',note:''};
 out({type:'system',subtype:'init',session_id:'s'});
 out({type:'assistant',message:{content:[{type:'text',text:'결과\\n\`\`\`json\\n'+JSON.stringify(j)+'\\n\`\`\`'}]}});
 out({type:'result',is_error:false,num_turns:1,duration_ms:5,total_cost_usd:0.02,session_id:'s'});setTimeout(()=>process.exit(0),50);}
`);
const fakeCmd = path.join(vibeDir, 'fake_claude.cmd'); fs.writeFileSync(fakeCmd, `@node "${fake}" %*\r\n`);
const setMode = m => fs.writeFileSync(path.join(vibeDir, 'mode.txt'), m);
const p = { root, vibeDir, claude: fakeCmd, claudeModel: '' };
const ev = require(path.join(dir, 'orch-events')); const st = require(path.join(dir, 'orch-state')); const watch = require(path.join(dir, 'orch-watch'));
const agent = require(path.join(dir, 'orch-agent')); const im = require(path.join(dir, 'orch-improve'));
ev.init(vibeDir); watch.init(p, {}); agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [] }); im.init({ notify: () => { }, pumpMs: 3600000 });
const sleep = t => new Promise(r => setTimeout(r, t));
(async () => {
  const prompts = []; const origRun = agent.runClaude; agent.runClaude = (pr, o) => { prompts.push(String(pr)); return origRun(pr, o); };
  const mk = sig => im.add({ title: `개념 재정립 시험 ${sig}`, evidence: 'events.jsonl:2001', targets: ['Doc/a.txt'], before_after: 'value 1 → 2', verify: V419, rollback: '값 복원', impact: 'core', sig }, 'vision').id;
  setMode('items-ok'); const id1 = mk('verify items ok'); const r1 = await im.approve(id1, '사용자'); const p1 = im.get(id1);
  chk('반영: 3번 반영 뒤 확인, 4번 실행 못 함이어도 반영 완료(파일 유지)', r1.ok === true && p1.status === 'applied' && /value: 2/.test(R('Doc/a.txt')), JSON.stringify(p1.history.slice(-2).map(h => h.what.slice(0, 120))));
  chk('반영: 확인 목록 2건(v3, v4)과 이력 줄', Array.isArray(p1.postChecks) && p1.postChecks.map(x => x.n).join(',') === '3,4' && p1.postChecks.every(x => x.status === 'open') && p1.history.some(h => /^반영 뒤 확인 2건/.test(h.what)) && p1.history.some(h => /^반영 완료 · 검증 통과\. 검증 항목 실행 통과 2건/.test(h.what)), JSON.stringify(p1.postChecks));
  chk('반영 지시문에 검증 항목과 verify_items 형식', prompts[0].includes('[검증 항목]') && /v3 \(반영 뒤 확인/.test(prompts[0]) && prompts[0].includes('"verify_items"'));
  W('Doc/a.txt', 'value: 1\n'); cp.execSync('git add -A && git -c user.email=t@t -c user.name=t commit -q -m reset --allow-empty', { cwd: root, windowsHide: true, stdio: 'ignore' });
  setMode('items-fail'); const id2 = mk('verify items fail'); const r2 = await im.approve(id2, '사용자'); const p2 = im.get(id2);
  chk('반영: 실행한 항목 실패 1건 → 반영 실패, 파일 되돌림, 확인 목록 없음', r2.ok === false && p2.status === 'apply-failed' && /value: 1/.test(R('Doc/a.txt')) && !p2.postChecks && p2.history.some(h => /^반영 실패\. 검증 실패: 실행한 항목 실패 1건\(v2\)/.test(h.what)), JSON.stringify(p2.history.slice(-1).map(h => h.what.slice(0, 160))));
  im.dispose(); agent.dispose(); watch.dispose(); st.dispose(); await sleep(100);
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
