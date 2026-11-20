// orch-agent.js 프롬프트 대기열 · 지금 보내기 · VMO 켜고 끄기 시험(가짜 claude). 사용: node test/t_orch_agent_q.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'agq-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
const HJ = path.join(root, 'tools', 'Harness', 'harness.json');
W('tools/Harness/harness.json', '{\n  "repairScope": "DB_ONLY",\n  "llmReview": true,\n  "orch": {\n    "agentEnabled": true,\n    "agentMaxPerHour": 20,\n    "agentTimeoutMin": 1\n  },\n  "orchNote": "x"\n}\n');
fs.mkdirSync(path.join(root, 'Doc', 'e2e'), { recursive: true });
// 가짜 claude: 받은 사용자 메시지를 받는 대로 기록하고 900ms 뒤 결과를 낸다
const fake = W('.vibe/fake_claude.js', `
const fs=require('fs'),path=require('path');let buf='';let started=false;const f=path.join('.vibe','got.txt');
process.stdin.on('data',d=>{buf+=d;let i;while((i=buf.indexOf('\\n'))>=0){const ln=buf.slice(0,i);buf=buf.slice(i+1);try{const j=JSON.parse(ln);fs.appendFileSync(f,JSON.stringify(j.message.content[0].text.split('\\n').pop().slice(0,60))+'\\n');}catch(e){} if(!started){started=true;setTimeout(done,900);}}});
function done(){const out=o=>console.log(JSON.stringify(o));out({type:'system',subtype:'init',session_id:'s'});out({type:'assistant',message:{content:[{type:'text',text:'답'}]}});out({type:'result',is_error:false,num_turns:1,duration_ms:5,total_cost_usd:0.01,session_id:'s'});}
`);
const fakeCmd = W('.vibe/fake_claude.cmd', `@node "${fake}" %*\r\n`);
const p = { root, vibeDir, claude: fakeCmd, claudeModel: '' };
const st = require(path.join(dir, 'orch-state')); const watch = require(path.join(dir, 'orch-watch')); const agent = require(path.join(dir, 'orch-agent'));
watch.init(p, {}); agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [] });
const qmsgs = []; agent.on(m => { if (m.type === 'agentQueue') qmsgs.push(m.items.map(x => x.text)); });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const sleep = t => new Promise(r => setTimeout(r, t)); const got = () => { try { return fs.readFileSync(path.join(vibeDir, 'got.txt'), 'utf8').trim().split('\n').map(x => JSON.parse(x)); } catch { return []; } };
const idle = async (ms = 15000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { const s = agent.status(); if (!s.busy && !s.askQueued) return true; await sleep(100); } return false; };
(async () => {
  // 1) 바쁠 때 보낸 프롬프트 = 대기열 → 끝나면 순서대로 자동 전송
  agent.ask('첫째'); await sleep(250);
  agent.ask('둘째'); agent.ask('셋째'); await sleep(50);
  chk('바쁠 때 2건 대기열', JSON.stringify(agent.queueList().map(x => x.text)) === '["둘째","셋째"]' && agent.status().askQueued === 2, JSON.stringify(agent.queueList()));
  chk('대기열 변경 알림', qmsgs.length >= 2 && qmsgs[qmsgs.length - 1].join(',') === '둘째,셋째');
  await idle();
  chk('끝나면 순서대로 자동 전송', got().join(',') === '첫째,둘째,셋째', got().join(','));
  // 2) 대기열에서 지우기
  fs.unlinkSync(path.join(vibeDir, 'got.txt'));
  agent.ask('A'); await sleep(200); agent.ask('B'); agent.ask('C'); await sleep(50);
  agent.removeQueued(agent.queueList().find(x => x.text === 'B').qid);
  chk('대기열에서 지우기', agent.queueList().map(x => x.text).join(',') === 'C');
  // 3) 지금 보내기 = 진행 중인 응답에 추가 지시로 넣기(대기열에서 빠짐 · 새 호출 없음)
  const r = agent.sendQueuedNow(agent.queueList()[0].qid);
  chk('지금 보내기 = 진행 중인 응답에 넣음', r === true && agent.queueList().length === 0);
  await idle(); await sleep(200);
  chk('추가 지시가 같은 호출에 전달됨(B 는 전송 안 됨)', got().join(',') === 'A,C', got().join(','));
  // 4) VMO 끄기: harness.json orch.enabled false · 다른 키 유지 · 사건을 만들지 않음 · 자동 조치 없음
  const off = agent.setEnabled(false); const hj = JSON.parse(fs.readFileSync(HJ, 'utf8'));
  chk('끄기 = orch.enabled false · 다른 설정 유지', off.ok && hj.orch.enabled === false && hj.orch.agentMaxPerHour === 20 && hj.repairScope === 'DB_ONLY' && hj.orchNote === 'x' && agent.status().on === false, JSON.stringify(hj.orch));
  watch.tick(); const n0 = watch.list().length;
  st.apply({ ms: Date.now(), type: 'proc.end', src: 'vm', pid: process.pid, wb: 1, screen: 'TST0001', label: 'S8.verify', procId: 1, exit: 6, why: '[FAIL] x', sig: 's' });
  fs.writeFileSync(path.join(root, 'Doc', 'e2e', '_run.verify.TST0009.lock'), JSON.stringify({ pid: 999999 })); watch.tick();
  chk('꺼져 있으면 사건 0건', watch.list().length === n0, String(watch.list().length - n0));
  chk('꺼져 있어도 직접 지시는 실행', (fs.unlinkSync(path.join(vibeDir, 'got.txt')), agent.ask('직접'), true)); await idle(); chk('직접 지시 전달', got().join(',') === '직접', got().join(','));
  // 5) 켜기: 다시 사건 생성 + 자동 조치(R9 = 잠금 삭제)
  const on = agent.setEnabled(true); chk('켜기 = orch.enabled true', on.ok && JSON.parse(fs.readFileSync(HJ, 'utf8')).orch.enabled === true && agent.status().on === true);
  watch.tick(); await sleep(600);
  const r9 = watch.list().find(x => x.rule === 'R9');
  chk('켜면 사건 생성 · 자동 조치', !!r9 && r9.status === 'resolved' && !fs.existsSync(path.join(root, 'Doc', 'e2e', '_run.verify.TST0009.lock')), r9 && r9.status);
  agent.dispose(); watch.dispose(); st.dispose(); await sleep(150); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
