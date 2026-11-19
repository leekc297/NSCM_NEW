// orch-agent.js 시험 — 임시 폴더 + 가짜 claude(스트림 JSON 을 흉내 내는 node 스크립트)로 조치 흐름을 본다. 실제 Claude 호출 없음
//   사용: node test/t_orch_agent.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const dir = process.argv[2] || path.join(__dirname, '..');
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'agent-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); };
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_ONLY', orch: { agentMaxAttempts: 2, agentMaxPerHour: 10, agentTimeoutMin: 1 } }));
W('tools/Harness/verify/sort_check.py', 'ORIGINAL\n'); W('nscm-fe/src/x.ts', 'FE ORIGINAL\n'); W('.gitignore', '.vibe/\n');
fs.mkdirSync(path.join(root, 'Doc', 'e2e'), { recursive: true });
cp.execSync('git init -q && git add -A && git -c user.email=t@t -c user.name=t commit -q -m init', { cwd: root, windowsHide: true });
// 가짜 claude: 입력 1줄을 읽고 FAKE_MODE 에 따라 파일을 고친 뒤 결과 JSON 을 낸다
const fake = path.join(root, 'fake_claude.js');
fs.writeFileSync(fake, `
const fs=require('fs'),path=require('path');let inp='';process.stdin.on('data',d=>{inp+=d;if(inp.includes('\\n'))go();});let done=false;
function go(){if(done)return;done=true;const mode=fs.existsSync(path.join('.vibe','mode.txt'))?fs.readFileSync(path.join('.vibe','mode.txt'),'utf8').trim():'ok';
 const out=o=>console.log(JSON.stringify(o));out({type:'system',subtype:'init',session_id:'sess-1'});
 fs.mkdirSync('.vibe',{recursive:true});fs.appendFileSync(path.join('.vibe','calls.txt'),mode+'\\n');
 if(mode==='edit'||mode==='outside'){fs.writeFileSync(path.join('tools','Harness','verify','sort_check.py'),'FIXED\\n');fs.writeFileSync(path.join('tools','Harness','verify','new_helper.py'),'NEW\\n');}
 if(mode==='outside')fs.writeFileSync(path.join('nscm-fe','src','x.ts'),'FE CHANGED\\n');
 out({type:'assistant',message:{content:[{type:'tool_use',name:(mode==='edit'||mode==='outside')?'Edit':'Read',input:{file_path:'a.log'}},{type:'text',text:'원인 확인.\\n\`\`\`json\\n'+JSON.stringify({cause_class:'engine',cause:'sort_check.py:1 정렬 키 비교 결함',actions:[{grade:'B',what:'수정',result:'ok'}],changed_files:['tools/Harness/verify/sort_check.py'],verify:'selftest OK',status:mode==='prop'?'proposal':'resolved',next_for_user:'',proposal:mode==='prop'?{title:'FE 정렬 기준 변경',evidence:'e',targets:['nscm-fe/src/x.ts'],before_after:'a→b',verify:'v',rollback:'r'}:null})+'\\n\`\`\`'}]}});
 if(mode==='noresult'){setTimeout(()=>process.exit(1),50);return;} // 결과 JSON 은 냈지만 result 줄 없이 exit 1(종료 단계에서 끊긴 경우)
 out({type:'result',is_error:false,num_turns:2,duration_ms:10,total_cost_usd:0.01,session_id:'sess-1'});setTimeout(()=>process.exit(0),50);}
`);
const fakeCmd = path.join(root, 'fake_claude.cmd'); fs.writeFileSync(fakeCmd, `@node "${fake}" %*\r\n`);
const setMode = m => (fs.mkdirSync(path.join(root, '.vibe'), { recursive: true }), fs.writeFileSync(path.join(root, '.vibe', 'mode.txt'), m));
const calls = () => { try { return fs.readFileSync(path.join(root, '.vibe', 'calls.txt'), 'utf8').trim().split('\n').filter(Boolean).length; } catch { return 0; } };
const p = { root, vibeDir, claude: fakeCmd, claudeModel: '' };
const st = require(path.join(dir, 'orch-state')); const watch = require(path.join(dir, 'orch-watch')); const agent = require(path.join(dir, 'orch-agent'));
watch.init(p, {}); const notes = []; agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [], notify: (inc, what) => notes.push(what) });
let ok = true; const chk = (name, cond, extra) => { console.log(cond ? 'PASS' : 'FAIL', name, extra || ''); if (!cond) ok = false; };
const sleep = t => new Promise(r => setTimeout(r, t));
const waitFor = async (fn, ms = 20000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { if (fn()) return true; await sleep(150); } return false; };
const R = f => fs.readFileSync(path.join(root, f), 'utf8');
(async () => {
  chk('결과 JSON 추출', agent.lastJsonBlock('x\n```json\n{"cause_class":"env","status":"resolved"}\n```').cause_class === 'env');
  // 1) R9 죽은 잠금 = 코드 조치(Claude 호출 없음)
  W('Doc/e2e/_run.verify.TST0001.lock', JSON.stringify({ pid: 999999, started: 'x', args: 'verify TST0001' }));
  const i9 = watch.raise('R9', { screen: 'TST0001', sig: 'R9|_run.verify.TST0001.lock', title: '죽은 잠금', evidence: { file: 'Doc/e2e/_run.verify.TST0001.lock', pid: 999999 } });
  await waitFor(() => watch.get(i9.id).status === 'resolved');
  chk('R9 잠금 삭제 · 해결 · Claude 호출 0', watch.get(i9.id).status === 'resolved' && !fs.existsSync(path.join(root, 'Doc/e2e/_run.verify.TST0001.lock')) && calls() === 0, watch.get(i9.id).actions.map(a => a.what).join(' | '));
  // 2) R1 → Claude 조치(B 등급 수정) → 해결 · 스냅샷 · 되돌리기
  setMode('edit');
  const i1 = watch.raise('R1', { screen: 'TST0001', sig: 'S8.verify | sort FAIL', title: 'S8.verify 실패 (exit 6)', detail: '[FAIL] sort', evidence: { log: 'a.log' } });
  await waitFor(() => /resolved|need-user/.test(watch.get(i1.id).status) && watch.get(i1.id).agent);
  const g1 = watch.get(i1.id);
  chk('Claude 조치 → 해결', g1.status === 'resolved' && g1.agent.cause_class === 'engine', g1.status + ' ' + g1.actions.map(a => a.what).join(' | ').slice(0, 200));
  chk('수정 파일 감지(변경 1 · 신규 1)', g1.snap === i1.id && JSON.stringify(g1.actions[g1.actions.length - 1].files) === JSON.stringify(['tools/Harness/verify/sort_check.py', 'tools/Harness/verify/new_helper.py(신규)']), JSON.stringify(g1.actions[g1.actions.length - 1].files));
  chk('파일을 고쳤으면 알림', notes.length === 1);
  const rv = agent.revert(i1.id);
  chk('되돌리기', rv.ok && R('tools/Harness/verify/sort_check.py') === 'ORIGINAL\n' && !fs.existsSync(path.join(root, 'tools/Harness/verify/new_helper.py')), JSON.stringify(rv));
  // 3) 허용 범위 밖(nscm-fe) 변경 → 사용자 확인 필요
  setMode('outside');
  const i2 = watch.raise('R1', { screen: 'TST0002', sig: 'S8.verify | other FAIL', title: 'S8.verify 실패', evidence: {} });
  await waitFor(() => watch.get(i2.id).agent);
  const g2 = watch.get(i2.id);
  chk('범위 밖 변경 → 사용자 확인 필요', g2.status === 'need-user' && /허용 범위 밖 파일 변경 1개: nscm-fe\/src\/x\.ts/.test(g2.actions[g2.actions.length - 1].what), g2.actions[g2.actions.length - 1].what.slice(0, 260));
  // 4) 개선안(C 등급) → proposals 파일
  setMode('prop');
  const i3 = watch.raise('R10', { screen: 'TST0003', sig: 'R10|TST0003', title: 'CheckList 판정 정체', evidence: {} });
  await waitFor(() => watch.get(i3.id).agent);
  const g3 = watch.get(i3.id); const pf = g3.proposal ? path.join(vibeDir, 'orch', 'proposals', g3.proposal + '.json') : '';
  chk('개선안 등록', g3.status === 'need-user' && pf && fs.existsSync(pf) && JSON.parse(fs.readFileSync(pf, 'utf8')).status === 'pending', g3.proposal);
  // 5) 같은 서명 3번째 = 자동 조치 중단(Claude 호출 없음)
  setMode('ok'); const c0 = calls();
  watch.update(i1.id, { status: 'closed' });
  const i4 = watch.raise('R1', { screen: 'TST0001', sig: 'S8.verify | sort FAIL', title: 'S8.verify 실패 (exit 6)', evidence: {} });
  await waitFor(() => watch.get(i4.id).agent); const c1 = calls();
  watch.update(i4.id, { status: 'closed' });
  const i5 = watch.raise('R1', { screen: 'TST0001', sig: 'S8.verify | sort FAIL', title: 'S8.verify 실패 (exit 6)', evidence: {} });
  await waitFor(() => watch.get(i5.id).status === 'need-user');
  chk('같은 서명 2회 조치 뒤 3번째 = 사용자 확인 필요', c1 === c0 + 1 && calls() === c1 && watch.get(i5.id).status === 'need-user', `${c0}→${c1}→${calls()} ${watch.get(i5.id).actions.map(a => a.what).join('|')}`);
  // 5-2) 결과 JSON 뒤 result 줄 없이 exit 1 = 결과대로 처리 · 비정상 종료는 기록만 (개선안 20261119193539_REVIEW_2)
  setMode('noresult'); const iN = watch.raise('R1', { screen: 'TST0005', sig: 'noresult|x', title: '결과 뒤 비정상 종료 시험', evidence: {} });
  await waitFor(() => watch.get(iN.id).agent); const gN = watch.get(iN.id); const lastN = gN.actions[gN.actions.length - 1].what;
  chk('결과 JSON 뒤 exit 1 = 결과대로 해결 · 종료 상태 기록', gN.status === 'resolved' && /결과 JSON 뒤 비정상 종료\(exit 1 · result 줄 없음\)/.test(lastN), gN.status + ' ' + lastN.slice(0, 200));
  // 6) 자동 대상이 아닌 규칙(R7)은 코드 분류만
  const c7 = calls();
  const i7 = watch.raise('R7', { screen: 'TST0001', sig: 'R7|로그인 만료', title: 'Claude 비정상 종료', evidence: { cls: '로그인 만료' } });
  await waitFor(() => watch.get(i7.id).status === 'need-user');
  chk('R7 분류 안내 · Claude 호출 없음', watch.get(i7.id).status === 'need-user' && calls() === c7);
  const s = agent.status(); chk('상태 조회', s.enabled === true && s.busy === false, JSON.stringify(s));
  agent.dispose(); watch.dispose(); st.dispose(); await sleep(100);
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
