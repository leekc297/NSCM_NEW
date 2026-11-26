// prompt-relate.js 판정 + orch-agent 응답 중 같은 안건 즉시 반영 시험(가짜 claude). 사용: node test/t_prompt_relate.js <VibeManager 폴더>
// 2026-11-23 사용자: 작업 중 입력 = 기본 대기열. 현재 작업과 같은 안건이면 응답 중이라도 바로 반영
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const { judge } = require(path.join(dir, 'prompt-relate'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };

// ── 1. 판정 규칙
const ctx = { screens: ['DMF0082'], texts: ['DMF0082 Batch Price 조회 조건 보완. Plan Version 콤보 기본값을 최신 버전으로'] };
const cases = [
  ['+ 이것도 해줘', true, "맨 앞 '+'"],
  ['> 지금 작업 관련이지만 나중에', false, "맨 앞 '>'"],
  ['DMF0082 저장 버튼도 확인', true, '현재 화면 ID'],
  ['dmf0082 엑셀도', true, '화면 ID 소문자'],
  ['SCP0104 CheckList 돌려줘', false, '다른 화면 ID'],
  ['이 작업 끝나면 Source Backup 해줘', false, '새 작업 표현'],
  ['별개로 서버 로그 정리', false, '새 작업 표현'],
  ['추가로 Division 40 도 같이 봐주세요', true, '이어 말하기'],
  ['방금 수정한 것 원복', true, '이어 말하기'],
  ['제 말은 기본값이 아니라 콤보 순서입니다', true, '이어 말하기'],
  ['Plan Version 콤보 기본값 정렬은 내림차순', true, '같은 낱말'],
  ['오늘 점심 메뉴 추천', false, '겹치는 것 없음'],
  ['', false, '빈 글'],
];
for (const [t, want, n] of cases) { const r = judge(t, ctx); chk(`판정 ${n}: "${t}" → ${want ? '반영' : '대기열'}`, r.related === want, r.why); }
chk("'+' 표시는 본문에서 뺌", judge('+ 이것도', ctx).text === '이것도');
chk('맥락 없으면 이어 말하기만 반영', judge('추가로 이것도', {}).related === true && judge('서버 로그 정리', {}).related === false);
chk('현재 화면 ID 가 없으면 글 속 화면 ID 만으로 반영하지 않음', judge('DMF0001 조회', { texts: ['x'] }).related === false);

// ── 2. orch-agent: 응답 중 같은 안건 = 진행 중인 응답에 넣음, 다른 안건 = 대기열
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'prel-')); const vibeDir = path.join(root, '.vibe');
const W = (rel, s) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s); return f; };
W('tools/Harness/harness.json', '{\n  "orch": {\n    "agentEnabled": true,\n    "agentMaxPerHour": 20,\n    "agentTimeoutMin": 1\n  }\n}\n');
const fake = W('.vibe/fake_claude.js', `
const fs=require('fs'),path=require('path');let buf='';let started=false;const f=path.join('.vibe','got.txt');
process.stdin.on('data',d=>{buf+=d;let i;while((i=buf.indexOf('\\n'))>=0){const ln=buf.slice(0,i);buf=buf.slice(i+1);try{const j=JSON.parse(ln);fs.appendFileSync(f,JSON.stringify(j.message.content[0].text.split('\\n').pop().slice(0,60))+'\\n');}catch(e){} if(!started){started=true;setTimeout(done,1200);}}});
function done(){const out=o=>console.log(JSON.stringify(o));out({type:'system',subtype:'init',session_id:'s'});out({type:'assistant',message:{content:[{type:'text',text:'답'}]}});out({type:'result',is_error:false,num_turns:1,duration_ms:5,total_cost_usd:0,session_id:'s'});}
`);
const fakeCmd = W('.vibe/fake_claude.cmd', `@node "${fake}" %*\r\n`);
const p = { root, vibeDir, claude: fakeCmd, claudeModel: '' };
const watch = require(path.join(dir, 'orch-watch')); const agent = require(path.join(dir, 'orch-agent'));
watch.init(p, {}); agent.init({ paths: () => p, serverSvc: null, loadQuick: () => [] });
const notes = []; agent.on(m => { if (m.type === 'agent' && m.kind === 'note') notes.push(m.text); });
const sleep = t => new Promise(r => setTimeout(r, t)); const got = () => { try { return fs.readFileSync(path.join(vibeDir, 'got.txt'), 'utf8').trim().split('\n').map(x => JSON.parse(x)); } catch { return []; } };
const idle = async (ms = 20000) => { const t0 = Date.now(); while (Date.now() - t0 < ms) { const s = agent.status(); if (!s.busy && !s.askQueued) return true; await sleep(100); } return false; };
(async () => {
  agent.ask('DMF0082 Plan Version 콤보 기본값 보완'); await sleep(400);
  agent.ask('추가로 Division 40 도 같이 봐주세요');
  agent.ask('SCP0104 CheckList 돌려줘'); await sleep(50);
  chk('같은 안건 = 대기열에 넣지 않음, 다른 안건만 대기열', JSON.stringify(agent.queueList().map(x => x.text)) === '["SCP0104 CheckList 돌려줘"]', JSON.stringify(agent.queueList()));
  chk('같은 안건 반영 알림', notes.some(t => /같은 안건으로 판단/.test(t)), notes.slice(-3).join(' / '));
  chk('다른 안건 대기열 알림에 이유', notes.some(t => /다른 안건으로 판단: 다른 화면 SCP0104/.test(t)));
  await idle();
  const g = got();
  chk('같은 안건이 첫 응답 프로세스에 전달됨(두 번째 호출 아님)', g[0] === 'DMF0082 Plan Version 콤보 기본값 보완' && g[1] === '추가로 Division 40 도 같이 봐주세요', g.join(','));
  chk('다른 안건은 끝난 뒤 새 호출로 전송', g[g.length - 1] === 'SCP0104 CheckList 돌려줘' && g.length === 3, g.join(','));
  try { agent.dispose && agent.dispose(); watch.dispose && watch.dispose(); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
