// VM 자가 보완 반영 절차 시험 — 임시 폴더 + 가짜 claude. 실제 Claude 호출 없음
//   승인 → 반영 전 게이트 · 백업 → (가짜 claude 가 저장소 파일 수정) → 반영 뒤 게이트 → 설치 폴더 복사 · CHANGELOG 절 → 되돌리기
//   게이트에서 새로 어긋나면 대상 파일 복원 · 설치 폴더는 그대로 · 반영 실패 기록
//   사용: node test/t_orch_selfapply.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'selfapply-')); const vibeDir = path.join(root, '.vibe'); const inst = path.join(root, 'installed');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); };
const R = rel => fs.readFileSync(path.join(root, rel), 'utf8'); const NL = String.fromCharCode(10);
const A0 = "module.exports = { value: 1 };\n";
W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', orch: { agentEnabled: false, agentTimeoutMin: 1, selfTestTimeoutSec: 60, selfRepairEnabled: false } })); // ①~⑦ = 진단 고리 없이 종전 재시도 경로 · ⑧ 에서 켬
W('tools/VibeManager/a.js', A0); W('tools/VibeManager/package.json', '{"name":"x"}'); W('tools/VibeManager/quick.json', '{"groups":[]}'); W('tools/VibeManager/steps.json', '{"steps":[]}');
W('tools/VibeManager/CHANGELOG.md', '## (판 번호 없음, VM 저장소) 종전 절 (2026-11-19 10:00)\n- 내용\n');
fs.mkdirSync(path.join(root, 'tools', 'VibeManager', 'test'), { recursive: true }); fs.copyFileSync(path.join(dir, 'test', 'run_all.js'), path.join(root, 'tools', 'VibeManager', 'test', 'run_all.js'));
W('tools/VibeManager/test/t_a.js', "const a = require(require('path').join(process.argv[2], 'a.js')); const ok = typeof a.value === 'number' && a.value > 0; console.log(ok ? 'PASS' : 'FAIL', 'value 양수'); console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);\n");
for (const f of ['a.js', 'package.json', 'quick.json', 'steps.json', 'CHANGELOG.md']) { fs.mkdirSync(inst, { recursive: true }); fs.copyFileSync(path.join(root, 'tools', 'VibeManager', f), path.join(inst, f)); }
W('.gitignore', '.vibe/\ninstalled/\n');
cp.execSync('git init -q && git add -A && git -c user.email=t@t -c user.name=t commit -q -m init', { cwd: root, windowsHide: true, stdio: 'ignore' });
const fake = path.join(vibeDir, 'fake_claude.js'); fs.mkdirSync(vibeDir, { recursive: true });
fs.writeFileSync(fake, `
const fs=require('fs'),path=require('path');let inp='';let done=false;process.stdin.on('data',d=>{inp+=d;if(inp.includes('\\n'))go();});
function go(){if(done)return;done=true;const mode=fs.readFileSync(path.join('.vibe','mode.txt'),'utf8').trim();const out=o=>console.log(JSON.stringify(o));
 if(inp.includes('반영 실패한 개선안의 실패 원인 진단')){ const dec=fs.readFileSync(path.join('.vibe','repair.txt'),'utf8').trim(); fs.appendFileSync(path.join('.vibe','calls.txt'),'repair|'+dec+'\\n'); const j={decision:dec,cause:'tools/VibeManager/test/t_a.js:1 value 양수 기대',reason:dec==='stop'?'사람 판단 필요':'',proposal:dec==='revise'?{title:'a.js 값 7 로(고친 안)',evidence:'t_a.js 기대 양수',targets:['tools/VibeManager/a.js'],before_after:'value -5 -> 7',verify:'',rollback:'',sig:'a-neg-fix'}:{}}; out({type:'system',subtype:'init',session_id:'s'}); out({type:'assistant',message:{content:[{type:'text',text:'\`\`\`json\\n'+JSON.stringify(j)+'\\n\`\`\`'}]}}); out({type:'result',is_error:false,num_turns:1,duration_ms:5,total_cost_usd:0.01,session_id:'s'}); setTimeout(()=>process.exit(0),50); return; }
 fs.appendFileSync(path.join('.vibe','calls.txt'),mode+'|'+(/백업\\(\\.bak\\)은 VMO 가 이미/.test(inp)?'selfprompt':'plain')+'\\n');
 fs.writeFileSync(path.join('tools','VibeManager','a.js'), mode==='good7' ? 'module.exports = { value: 7 };\\n' : mode==='good' ? 'module.exports = { value: 2 };\\n' : 'module.exports = { value: -5 };\\n');
 const j={applied:true,verified:true,changed_files:['tools/VibeManager/a.js'],verify_result:'확인 명령 없음',note:''};
 out({type:'system',subtype:'init',session_id:'s'});
 out({type:'assistant',message:{content:[{type:'tool_use',name:'Edit',input:{file_path:'tools/VibeManager/a.js'}},{type:'text',text:'결과\\n\`\`\`json\\n'+JSON.stringify(j)+'\\n\`\`\`'}]}});
 out({type:'result',is_error:false,num_turns:1,duration_ms:5,total_cost_usd:0.01,session_id:'s'});setTimeout(()=>process.exit(0),50);}
`);
const fakeCmd = path.join(vibeDir, 'fake_claude.cmd'); fs.writeFileSync(fakeCmd, `@node "${fake}" %*\r\n`);
const setMode = m => fs.writeFileSync(path.join(vibeDir, 'mode.txt'), m);
const p = { root, vibeDir, extDir: inst, claude: fakeCmd, claudeModel: '' };
const ev = require(path.join(dir, 'orch-events')); const st = require(path.join(dir, 'orch-state')); const watch = require(path.join(dir, 'orch-watch'));
const agent = require(path.join(dir, 'orch-agent')); const im = require(path.join(dir, 'orch-improve')); const sc = require(path.join(dir, 'orch-selfcheck'));
ev.init(vibeDir); watch.init(p, {}); const notes = []; agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [] }); im.init({ notify: t => notes.push(t) });
sc.init({ paths: () => p, timer: false, autoSync: false, inventory: false, docStyle: false, incidents: false });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const baks = (d, re) => fs.readdirSync(d).filter(f => re.test(f));
(async () => {
  const a = im.add({ title: 'a.js 값 2 로 변경', evidence: 'S5|a 오류 3회', targets: ['tools/VibeManager/a.js'], before_after: 'value 1 → 2', verify: '', rollback: '', sig: 'a-value', check: 'S5', selfKey: 'S5|a' }, 'self');
  let pr = im.get(a.id);
  chk('자가진단 개선안 등록: id 끝 SELF · self 표시', /_SELF$/.test(a.id) && pr.self === true && pr.check === 'S5' && pr.selfKey === 'S5|a' && pr.status === 'pending', a.id);
  // ① 게이트 실패: 시험이 실패하는 수정 → 복원 · 설치 폴더 그대로
  setMode('bad'); let r = await im.approve(a.id, '사용자'); pr = im.get(a.id);
  chk('게이트 실패 = 반영 실패 · 저장소 복원 · 설치 폴더 그대로', r.ok === false && pr.status === 'apply-failed' && R('tools/VibeManager/a.js') === A0 && fs.readFileSync(path.join(inst, 'a.js'), 'utf8') === A0, pr.status);
  chk('실패 기록에 새로 어긋난 항목(S2 t_a.js)', pr.gate && pr.gate.ok === false && pr.gate.newBad.some(x => /S2 t_a\.js/.test(x)) && pr.history.some(h => /게이트에서 새로 어긋난 항목 1건/.test(h.what)), JSON.stringify(pr.gate));
  chk('실패 때 CHANGELOG 그대로', !/VMO 자가 보완/.test(R('tools/VibeManager/CHANGELOG.md')));
  chk('프롬프트 = 자가 보완용(백업 · 설치 폴더 · CHANGELOG 는 VMO)', fs.readFileSync(path.join(vibeDir, 'calls.txt'), 'utf8').trim().split(NL).pop() === 'bad|selfprompt');
  // ② 통과: 설치 폴더 복사 · 백업 · CHANGELOG 절
  setMode('good'); r = await im.approve(a.id, '사용자'); pr = im.get(a.id);
  chk('게이트 통과 = 반영 완료 · 저장소 변경', r.ok === true && pr.status === 'applied' && /value: 2/.test(R('tools/VibeManager/a.js')) && pr.gate.ok === true, JSON.stringify(pr.history.slice(-2).map(h => h.what)));
  chk('설치 폴더 복사 1개 · 다시 로드 대기 표시', /value: 2/.test(fs.readFileSync(path.join(inst, 'a.js'), 'utf8')) && pr.synced.join() === 'a.js' && pr.needsReload === true && pr.appliedMs > 0);
  chk('백업: 저장소 .bak_<날짜>_self<시각> · 설치본 같은 태그', baks(path.join(root, 'tools', 'VibeManager'), /^a\.js\.bak_\d{8}_self\d{4}$/).length >= 1 && baks(inst, /^a\.js\.bak_\d{8}_self\d{4}$/).length === 1, baks(inst, /bak/).join(','));
  const cl = R('tools/VibeManager/CHANGELOG.md'); const head = cl.split(NL)[0];
  chk('CHANGELOG 맨 위 절: 제목 · 개선안 id · 확인 · 미확인 · 되돌리기', /^## \(판 번호 없음, VM 저장소 \+ 설치 폴더\) VMO 자가 보완: a\.js 값 2 로 변경 \(\d{4}-\d\d-\d\d \d\d:\d\d\)$/.test(head) && cl.includes(`개선안 ${a.id} 승인`) && /- 확인\(\d\d:\d\d 실행\): 구문 검사 1개 파일 통과, 시험 1\/1개 파일 통과/.test(cl) && /- 미확인: VS Code 실화면/.test(cl) && /- 되돌리기: .*a\.js\.bak_\d{8}_self\d{4}/.test(cl) && cl.includes('종전 절'), head);
  // ③ 되돌리기: 저장소 · 설치 폴더 복원 · 되돌림 절
  const rv = im.revert(a.id, '사용자'); pr = im.get(a.id);
  chk('되돌리기: 저장소 · 설치 폴더 반영 전 내용 · 상태 승인 대기', rv.ok && R('tools/VibeManager/a.js') === A0 && fs.readFileSync(path.join(inst, 'a.js'), 'utf8') === A0 && pr.status === 'pending', JSON.stringify(rv));
  chk('되돌림 절 추가', /^## \(판 번호 없음, VM 저장소 \+ 설치 폴더\) VMO 자가 보완 되돌림: /.test(R('tools/VibeManager/CHANGELOG.md')));
  // ④ 사건에서 나온 종전 개선안은 종전 절차 그대로(게이트 · 복사 없음)
  const b = im.add({ title: '다른 안', evidence: '근거', targets: ['tools/VibeManager/a.js'], sig: 'other' }, 'incident'); setMode('good'); await im.approve(b.id, '사용자'); const pb = im.get(b.id);
  chk('종전 개선안: 게이트 · 설치 폴더 복사 없음', pb.status === 'applied' && !pb.gate && fs.readFileSync(path.join(inst, 'a.js'), 'utf8') === A0 && fs.readFileSync(path.join(vibeDir, 'calls.txt'), 'utf8').trim().split(NL).pop() === 'good|plain');
  // ⑤ 자동 반영(2026-11-19): 기준 = 출처가 아닌 대상 · 생성물 삭제는 7일 지난 것만 · 실패한 안은 VM 파일이 바뀐 뒤 1회 다시
  const E = (title, targets, self) => sc.autoEligible({ self: self !== false, title, targets });
  chk('자동 대상 판정: VM 코드 = 자동(출처 무관)', E('a 값 변경', ['tools/VibeManager/a.js', 'tools/VibeManager/test/t_a.js']).kind === 'code' && E('검사기 수정', ['tools/Harness/verify/x.py']).ok === true && E('사건에서 나온 안', ['tools/VibeManager/a.js'], false).kind === 'code');
  chk('자동 대상 판정: 생성물 삭제 = 자동(delete)', E('서버 로그 2개 삭제', ['.vibe/logs/x.log']).kind === 'delete' && E('옛 백업 파일 삭제', ['tools/VibeManager/a.js.bak_20261030']).kind === 'delete' && E('스냅샷 폴더 삭제', ['.vibe/orch/snap/prop_1/']).kind === 'delete');
  chk('자동 대상 판정: 코드 파일 삭제 · 설정 · 실행 hook · 범위 밖 · 대상 없음 = 승인 필요, 룰 문서 = 자동(2026-11-23 21:4x)', E('a.js 파일 삭제', ['tools/VibeManager/a.js']).ok === true && /설정 파일/.test(E('상한 변경', ['tools/Harness/harness.json']).why) && E('룰', ['tools/VibeManager/rules/10.md']).ok === true && /hook/.test(E('h', ['tools/Harness/hooks/x.ps1']).why) && E('fe', ['nscm-fe/a.ts']).ok === true /* 2026-11-26 사용자 지시(승인 가이드 완화): FE·BE 는 작업 모드를 따름 — 이 시험 설정 repairScope DB_FE = 자동(DB_ONLY 승인은 t_checkerscan.js) */ && E('x', []).ok === false, JSON.stringify([E('a.js 파일 삭제', ['tools/VibeManager/a.js']), E('fe', ['nscm-fe/a.ts'])]));
  const oldLog = path.join(vibeDir, 'logs', 'old.log'); const newLog = path.join(vibeDir, 'logs', 'new.log'); fs.mkdirSync(path.dirname(oldLog), { recursive: true }); fs.writeFileSync(oldLog, 'x'.repeat(1000)); fs.writeFileSync(newLog, 'y'.repeat(500));
  const days = n => new Date(Date.now() - n * 86400000); fs.utimesSync(oldLog, days(8), days(8));
  const c1 = im.add({ title: '서버 로그 2개 삭제', evidence: 'S10', targets: ['.vibe/logs/old.log', '.vibe/logs/new.log'], sig: 'del-logs' }, 'self');
  const c2 = im.add({ title: '상한 값 변경', evidence: 'S12', targets: ['tools/Harness/harness.json'], sig: 'cfg-x', plain: { what: '동시에 도는 화면 수가 3개에서 2개로 줄어듦', risk: '여러 화면 작업이 늦게 끝남', undo: '값을 3으로 되돌림' } }, 'self');
  await new Promise(x => setTimeout(x, 5));
  const c3 = im.add({ title: 'a.js 값 음수로', evidence: '사건 근거', targets: ['tools/VibeManager/a.js'], sig: 'a-neg' }, 'incident');
  setMode('good'); let au = await sc.autoApplyNext(false); let pa = im.get(a.id); let p1 = im.get(c1.id);
  chk('자동 반영 1건째 = 가장 먼저 올라온 코드 안 · 반영 완료 · 승인자 VMO 자동', au.id === a.id && au.ok === true && pa.status === 'applied' && pa.auto === true && pa.history.some(h => /^VMO 자동/.test(h.by) && h.what === '승인') && /value: 2/.test(fs.readFileSync(path.join(inst, 'a.js'), 'utf8')), JSON.stringify(au));
  chk('생성물 삭제: 8일 된 로그만 삭제 · 새 로그는 남김 · 대기 기록', !fs.existsSync(oldLog) && fs.existsSync(newLog) && p1.status === 'pending' && /7일 기준 대기 1개/.test(p1.waitNote) && p1.autoWaitMs > Date.now() && p1.history.some(h => /삭제 1개 1,000바이트/.test(h.what)), JSON.stringify([p1.waitNote, p1.history.map(h => h.what)]));
  const dl = fs.readFileSync(path.join(vibeDir, 'orch', 'selfcheck', 'delete_log.jsonl'), 'utf8').trim().split(NL).map(x => JSON.parse(x));
  chk('삭제 기록: 목록 · 크기 · 남긴 이유', dl.length === 1 && dl[0].deleted[0].file === '.vibe/logs/old.log' && dl[0].deleted[0].bytes === 1000 && dl[0].bytes === 1000 && /7일 미만/.test(dl[0].kept[0].why), JSON.stringify(dl[0]));
  chk('승인 대상(설정 파일) = 승인 대기 · 사유 · 업무 말 설명 보관', im.get(c2.id).status === 'pending' && /설정 파일/.test(im.get(c2.id).needsApproval) && im.get(c2.id).plain.risk === '여러 화면 작업이 늦게 끝남');
  setMode('bad'); au = await sc.autoApplyNext(false); let p3 = im.get(c3.id);
  chk('사건에서 나온 코드 안도 자동 · 게이트 실패 → 되돌림', au.id === c3.id && au.ok === false && p3.status === 'apply-failed' && p3.gated === true && p3.gate && p3.gate.ok === false && p3.autoTries === 1 && /value: 2/.test(R('tools/VibeManager/a.js')), JSON.stringify([au, p3.autoTries]));
  const callsN = () => fs.readFileSync(path.join(vibeDir, 'calls.txt'), 'utf8').trim().split(NL).length; let n0 = callsN(); au = await sc.autoApplyNext(false);
  chk('실패 직후(VM 파일 그대로) = 다시 하지 않음 · Claude 호출 없음', au.none === true && callsN() === n0, JSON.stringify(au));
  W('tools/VibeManager/extra.js', 'module.exports = 1;\n'); fs.copyFileSync(path.join(root, 'tools', 'VibeManager', 'extra.js'), path.join(inst, 'extra.js'));
  au = await sc.autoApplyNext(false); p3 = im.get(c3.id);
  chk('VM 파일이 바뀐 뒤 = 1회 다시 시도(2회째도 실패)', au.id === c3.id && au.ok === false && p3.autoTries === 2 && callsN() === n0 + 1, JSON.stringify([au, p3.autoTries]));
  W('tools/VibeManager/extra.js', 'module.exports = 2;\n'); fs.copyFileSync(path.join(root, 'tools', 'VibeManager', 'extra.js'), path.join(inst, 'extra.js')); n0 = callsN(); au = await sc.autoApplyNext(false);
  chk('2회 실패한 안 = 파일이 또 바뀌어도 멈춤', au.none === true && callsN() === n0);
  fs.utimesSync(newLog, days(9), days(9)); { const x = im.get(c1.id); x.autoWaitMs = 0; im.save(x); } au = await sc.autoApplyNext(false); p1 = im.get(c1.id);
  chk('7일이 지나면 남은 로그도 삭제 · 반영 완료', !fs.existsSync(newLog) && p1.status === 'applied' && p1.history.some(h => /반영 완료, 생성물 삭제/.test(h.what)), JSON.stringify(p1.history.map(h => h.what)));
  // ⑥ 하루 상한: Claude 로 반영을 시도한 건만 센다(삭제는 제외) · 건너뛴 사유는 상태에 남는다 · 0 = 상한 없음
  const gatedN = im.list().filter(x => x.gated).length; const cfgW = n => W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', orch: { agentEnabled: false, agentTimeoutMin: 1, selfTestTimeoutSec: 60, selfAutoApplyMaxPerDay: n } }));
  cfgW(gatedN); const c4 = im.add({ title: 'a.js 값 3 으로', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'a-3' }, 'self');
  n0 = callsN(); au = await sc.autoApplyNext(false); const sk = sc.status().autoSkip;
  chk('상한 = 시도 건수 = 건너뜀 · Claude 호출 없음 · 사유와 대기 건수 · 삭제 건 세지 않음', gatedN >= 2 && au.skipped && new RegExp(`하루 상한 ${gatedN}건 도달`).test(au.skipped) && au.waiting === 1 && !!au.nextAt && callsN() === n0 && sk && sk.skipped === au.skipped && im.get(c4.id).status === 'pending' && im.list().filter(x => x.gated).length === gatedN, JSON.stringify([gatedN, au, sk && sk.skipped]));
  cfgW(0); setMode('good'); au = await sc.autoApplyNext(false);
  chk('상한 0 = 상한 없음 · 반영 · 건너뜀 사유 지움', au.id === c4.id && au.ok === true && sc.status().autoSkip === null, JSON.stringify(au));
  // ⑦ 되돌릴 때 Claude 가 끝난 뒤 다른 쪽이 고친 파일은 덮지 않는다(2026-11-20 실제 사고: 문구 개선안 되돌림이 같은 시각 다른 세션의 orchestra.js 수정을 지움)
  { const c5 = im.add({ title: 'a.js 값 음수 2', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'a-neg-2' }, 'self');
    const af = path.join(root, 'tools', 'VibeManager', 'a.js'); let other = false;
    const afterF = path.join(vibeDir, 'orch', 'snap', `prop_${c5.id}`, 'after.json'); // Claude 종료 기록이 생긴 뒤에 다른 쪽이 고친다
    const w = { t: setInterval(() => { if (!other && fs.existsSync(afterF)) { other = true; fs.appendFileSync(af, '// other session line' + NL); } }, 20), close() { clearInterval(this.t); } };
    setMode('bad'); const r5 = await im.approve(c5.id, '사용자'); w.close(); const p5 = im.get(c5.id); const txt = fs.readFileSync(af, 'utf8');
    chk('게이트 실패 되돌림: Claude 뒤 다른 쪽이 고친 파일은 덮지 않음 · 확인 필요 기록', other && r5.ok === false && p5.status === 'apply-failed' && /other session line/.test(txt) && p5.history.some(h => /반영 뒤 다른 쪽이 고친 파일 tools.VibeManager.a\.js 는 되돌리지 않음/.test(h.what)), JSON.stringify([other, txt.slice(0, 80), p5.history.slice(-1)[0].what.slice(-160)]));
    fs.writeFileSync(af, 'module.exports = { value: 2 };' + NL); }
  // ⑧ 반영 실패 자동 해결(2026-11-20): 실패한 안 → 원인 진단(Claude 읽기 전용) → revise = 고친 안을 새로 올려 자동 반영 · retry = 같은 안 다시 · stop = 사람 확인
  { const rp = t => fs.writeFileSync(path.join(vibeDir, 'repair.txt'), t);
    W('tools/Harness/harness.json', JSON.stringify({ repairScope: 'DB_FE', orch: { agentEnabled: false, agentTimeoutMin: 1, selfTestTimeoutSec: 60, selfAutoApplyMaxPerDay: 0, selfRepairEnabled: true } }));
    for (const x of im.list()) if (x.status === 'apply-failed') { x.reason = '시험 정리'; im.save(x); } // 앞 시험의 실패 안은 대상에서 뺀다
    const f1 = im.add({ title: 'a.js 값 음수 3', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'a-neg-x' }, 'self');
    setMode('bad'); let au = await sc.autoApplyNext(false); chk('준비: 반영 실패', au.id === f1.id && im.get(f1.id).status === 'apply-failed');
    rp('revise'); const n0 = fs.readFileSync(path.join(vibeDir, 'calls.txt'), 'utf8'); let rr = await sc.repairFailedNext(false); const p1 = im.get(f1.id); const nx = rr.next ? im.get(rr.next) : null;
    chk('revise: 원래 안 = 고친 안으로 대체 · 고친 안 등록(깊이 1 · 원래 안 연결) · 진단은 읽기 전용 호출', rr.decision === 'revise' && p1.status === 'superseded' && nx && nx.status === 'pending' && nx.repairOf === f1.id && nx.repairDepth === 1 && nx.repairRoot === f1.id && /repair\|revise/.test(fs.readFileSync(path.join(vibeDir, 'calls.txt'), 'utf8').slice(n0.length)), JSON.stringify([rr, p1.status, nx && nx.sig]));
    setMode('good7'); au = await sc.autoApplyNext(false);
    chk('고친 안 자동 반영 · 게이트 통과', au.id === rr.next && au.ok === true && im.get(rr.next).status === 'applied' && /value: 7/.test(R('tools/VibeManager/a.js')), JSON.stringify(au));
    rr = await sc.repairFailedNext(false); chk('고칠 실패 안 없음 = 진단 호출 없음', rr.none === true);
    const f2 = im.add({ title: 'a.js 값 음수 4', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'a-neg-y' }, 'self'); setMode('bad'); await sc.autoApplyNext(false);
    rp('retry'); rr = await sc.repairFailedNext(false); const p2 = im.get(f2.id);
    chk('retry: 같은 안이 다시 대기로 · 시도 횟수 초기화', rr.decision === 'retry' && p2.status === 'pending' && p2.autoTried === false && p2.autoTries === 0, JSON.stringify([rr, p2.status]));
    setMode('good'); au = await sc.autoApplyNext(false); chk('retry 뒤 자동 반영', au.id === f2.id && au.ok === true);
    // 2026-11-20 정정: 다시 시도한 안이 또 실패하면 다시 진단(종전엔 repair 기록이 남아 영영 빠짐 · 20261120005059_INC)
    { const f5 = im.add({ title: 'a.js 값 음수 7', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'a-neg-v' }, 'self'); setMode('bad'); await sc.autoApplyNext(false);
      rp('retry'); await sc.repairFailedNext(false); await new Promise(x => setTimeout(x, 1100)); setMode('bad'); await sc.autoApplyNext(false);
      chk('다시 시도 뒤 또 실패 = 반영 실패 상태', im.get(f5.id).status === 'apply-failed', im.get(f5.id).status);
      rp('stop'); const r5 = await sc.repairFailedNext(false); const p5 = im.get(f5.id);
      chk('다시 시도 뒤 또 실패한 안 = 다시 진단(이번 판단 stop · 사람 확인 필요)', r5.id === f5.id && r5.decision === 'stop' && p5.needsUser === true && p5.retryN === 1, JSON.stringify([r5, p5.retryN])); }
    const f3 = im.add({ title: 'a.js 값 음수 5', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'a-neg-z' }, 'self'); setMode('bad'); await sc.autoApplyNext(false);
    rp('stop'); rr = await sc.repairFailedNext(false); const p3 = im.get(f3.id);
    chk('stop: 사람 확인 필요 표시 · 업무 말 설명 · 다시 진단하지 않음', rr.decision === 'stop' && p3.needsUser === true && !!p3.plain && (await sc.repairFailedNext(false)).none === true, JSON.stringify([rr, p3.needsUser]));
    const f4 = im.add({ title: 'a.js 값 음수 6', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'a-neg-w' }, 'self'); { const x = im.get(f4.id); x.repairDepth = 3; x.repairRoot = 'ROOT'; im.save(x); } setMode('bad'); await sc.autoApplyNext(false);
    const nc = fs.readFileSync(path.join(vibeDir, 'calls.txt'), 'utf8').length; rr = await sc.repairFailedNext(false); const p4 = im.get(f4.id);
    chk('같은 원래 안에서 3번 고친 뒤 = Claude 부르지 않고 멈춤 · 사람 확인 필요', rr.decision === 'stop' && p4.needsUser === true && fs.readFileSync(path.join(vibeDir, 'calls.txt'), 'utf8').length === nc && /3번 고쳐도/.test(p4.repair.reason), JSON.stringify([rr, p4.repair]));
  }
  // ⑨ 창 다시 로드로 끊긴 반영 정리(2026-11-20): 반영 시작 전 = 다시 대기 · 반영 도중 = 반영 실패(중단됨, 진단 대상)
  { const g1 = im.add({ title: '끊긴 안 시작 전', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'stale-before' }, 'self'); { const x = im.get(g1.id); x.status = 'approved'; x.autoTried = true; x.history.push({ at: '2026-11-20T00:30:17+09:00', by: 'VMO 자동', what: '승인' }); im.save(x); }
    const g2 = im.add({ title: '끊긴 안 반영 중', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'stale-during' }, 'self'); { const x = im.get(g2.id); x.status = 'applying'; x.history.push({ at: '2026-11-20T00:30:17+09:00', by: 'VMO 자동', what: '승인' }, { at: '2026-11-20T00:31:00+09:00', by: 'VMO', what: '반영 시작' }); im.save(x); }
    const n = sc.recoverStale(); const a1 = im.get(g1.id), a2 = im.get(g2.id);
    chk('끊긴 반영 정리: 시작 전 = 다시 대기 · 반영 중 = 되돌리고 다시 대기(2026-11-20 실패로 세지 않음)', n === 2 && a1.status === 'pending' && a1.autoTried === false && a2.status === 'pending' && a2.interrupted === true && /다시 시작됨/.test(a2.history.slice(-1)[0].what) && /실패로 세지 않음/.test(a2.history.slice(-1)[0].what), JSON.stringify([n, a1.status, a2.status]));
    for (const x of [a1, a2]) { x.reason = '시험 정리'; x.status = 'rejected'; im.save(x); } }
  // ⑩ 체인 실행 중(2026-11-20): VM 코드 안은 계속 반영 · 실행 중인 작업이 읽는 검증 도구 대상 안은 보류하고 사유를 남김 · 체인이 끝나면 보류 표시를 지움
  { const snap0 = st.snapshot; st.snapshot = () => Object.assign(snap0(), { chains: [{ id: 'fake' }] });
    const h1 = im.add({ title: '검증 도구 수정 보류 시험', evidence: 'S5', targets: ['tools/Harness/verify/x.py'], sig: 'hold-harness' }, 'self');
    const h2 = im.add({ title: 'a.js 체인 중 반영 시험', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'hold-vm' }, 'self');
    setMode('good'); const au = await sc.autoApplyNext(false); const x1 = im.get(h1.id);
    chk('체인 실행 중: VM 코드 안은 반영 · 검증 도구 안은 보류 사유 기록', au.id === h2.id && au.ok === true && x1.status === 'pending' && x1.waitNote === sc.HOLD_NOTE && !x1.autoTried, JSON.stringify([au, x1.status, x1.waitNote]));
    const au2 = await sc.autoApplyNext(false); chk('체인 실행 중: 보류 안만 남으면 건너뜀 사유 반환', au2.skipped === sc.HOLD_NOTE && au2.waiting === 1, JSON.stringify(au2));
    chk('대상 판정: Harness, E2E, Docs, CommonSync = 보류 대상 · VibeManager = 아님', sc.touchesRunTools({ targets: ['tools\\E2E\\lib\\nscm.ts'] }) && sc.touchesRunTools({ targets: ['./tools/Docs/doc_style.py'] }) && !sc.touchesRunTools({ targets: ['tools/VibeManager/a.js'] }));
    st.snapshot = snap0; { const x = im.get(h1.id); x.reason = '시험 정리'; x.status = 'rejected'; im.save(x); } }
  // ⑪ 반영 차례 장부(2026-11-23 개선안 20261123145412_VISION): 자리를 잡은 뒤에만 게이트 · 막힌 맨 앞 안은 줄 뒤로 · repairOf 안이 같은 원인 실패 안보다 앞
  { for (const x of im.list()) if (x.status === 'pending' || x.status === 'apply-failed') { x.reason = '시험 정리'; x.status = 'rejected'; im.save(x); }
    const g0 = sc.gate; let gateN = 0; sc.gate = async o => { gateN++; return g0(o); };
    const q1 = im.add({ title: 'a.js 차례 시험 1', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'order-first' }, 'self'); await new Promise(x => setTimeout(x, 5));
    const q2 = im.add({ title: 'a.js 차례 시험 2', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'order-second' }, 'self');
    const tok = agent.reserve('다른 조치'); setMode('good'); const n0 = callsN(); const b1 = await sc.autoApplyNext(false); const x1 = im.get(q1.id);
    chk('에이전트가 바쁠 때 = 게이트 호출 0회 · Claude 호출 0회 · 시도로 세지 않음', !!tok && b1.busy === true && b1.id === q1.id && gateN === 0 && callsN() === n0 && x1.status === 'pending' && !x1.autoTried && !x1.gated && !x1.autoTries, JSON.stringify([b1, gateN, x1.autoTries]));
    agent.release(tok); const a2 = await sc.autoApplyNext(false);
    chk('맨 앞 안이 보류되면 다음 주기에 다음 안을 고름', a2.id === q2.id && a2.ok === true && im.get(q2.id).status === 'applied' && gateN === 2, JSON.stringify([a2, gateN]));
    { const x = im.get(q1.id); x.reason = '시험 정리'; x.status = 'rejected'; im.save(x); }
    const of = im.add({ title: 'a.js 원래 안(실패)', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'order-orig' }, 'self'); { const x = im.get(of.id); x.status = 'superseded'; x.gate = { ok: false, newBad: ['S2 t_a.js'] }; im.save(x); }
    const sf = im.add({ title: 'a.js 같은 원인 실패 안', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'order-same' }, 'self'); { const x = im.get(sf.id); x.gate = { ok: false, newBad: ['S2 t_a.js'] }; im.save(x); } // 장부에 뒤로 보낸 기록 없이도(등록이 더 이른데도) repairOf 안이 앞
    await new Promise(x => setTimeout(x, 5)); const rf = im.add({ title: 'a.js 원인 고친 안', evidence: 'S5', targets: ['tools/VibeManager/a.js'], sig: 'order-fix' }, 'self'); { const x = im.get(rf.id); x.repairOf = of.id; im.save(x); }
    const ord = sc.applyOrder([im.get(sf.id), im.get(rf.id)]).map(x => x.id); setMode('good7'); const a3 = await sc.autoApplyNext(false);
    chk('repairOf 안이 원래 안과 같은 원인으로 실패한 안보다 먼저 나옴(등록은 늦어도)', ord[0] === rf.id && ord[1] === sf.id && a3.id === rf.id && a3.ok === true, JSON.stringify([ord, a3]));
    sc.gate = g0; { const x = im.get(sf.id); x.reason = '시험 정리'; x.status = 'rejected'; im.save(x); } }
  sc.dispose(); im.dispose(); agent.dispose(); watch.dispose(); st.dispose(); await new Promise(x => setTimeout(x, 150)); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
