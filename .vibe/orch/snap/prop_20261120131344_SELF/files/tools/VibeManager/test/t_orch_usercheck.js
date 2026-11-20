// 사용자 지적 점검(orch-usercheck.js · 자가진단 S13, 2026-11-20) 시험
//   감지기 12종 통과/실패 표본(U13 reloadResumeMissing, U14 screenNameMissing, U15 logTabShown 포함) · 원장에 없는 감지기 · VMO 화면 표시 보고(noteUi) · 사람 프롬프트 수집(sdk-cli 제외, 작업 중 끼운 메시지 포함) · 학습(가짜 Claude)
//   사용: node test/t_orch_usercheck.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'ucheck-')); const vibeDir = path.join(root, '.vibe'); const vmd = path.join(root, 'vm'); const sess = path.join(root, 'sess');
for (const d of [path.join(vibeDir, 'orch'), path.join(root, 'tools', 'Harness'), vmd, sess]) fs.mkdirSync(d, { recursive: true });
fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { checklistTargetMin: 30, selfDiagGapMin: 60, selfLightMin: 10, userLearnGapMin: 60 } }));
fs.copyFileSync(path.join(dir, 'user_checks.json'), path.join(vmd, 'user_checks.json'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const now = Date.now(); const M = 60000;
const W = (rel, v) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, typeof v === 'string' ? v : JSON.stringify(v)); return f; };
let INC = [], PROP = [], EV = [], CH = [], FT = []; let review = { enabled: true, lastMs: now - 3600000 };
const proposalsAdded = [];
const mods = {
  'orch-watch': { list: () => INC },
  'orch-improve': { list: () => PROP, meta: () => review, add: (o, src) => { proposalsAdded.push({ o, src }); return { id: 'P' + proposalsAdded.length }; } },
  'orch-state': { snapshot: () => ({ chains: CH }) },
  'orch-selfcheck': { autoEligible: p => ((p.targets || []).every(t => t.startsWith('tools/VibeManager/')) ? { ok: true, kind: 'code' } : { ok: false }) },
  'orch-history': { redact: s => String(s).replace(/[\w.]+@[\w.]+/g, '<메일>') },
  'flow-panel': { targets: () => FT },
};
const uc = require(path.join(dir, 'orch-usercheck'));
uc.init({ paths: () => ({ root, vibeDir }), vmDir: vmd, mods, events: () => EV, sessionDirs: [sess] });
const run = () => uc.check().items; const has = (items, uid, re) => items.some(i => i.uid === uid && (!re || re.test(i.what)));
(async () => {
  chk('표본 없음 = 실패 0', run().filter(i => i.level === 'fail').length === 0, JSON.stringify(run()));
  // U1 표시 멈춤: 첫 점검은 기준만, staleMin 지난 뒤 로그가 늘었으면 실패
  W('.vibe/jobs/J1/job.json', { id: 'J1', status: 'running', screens: [{ id: 'SCP0005', status: 'run', actor: 'script', step: '[1] 1. CheckList 수행', prog: '' }] }); W('.vibe/jobs/J1/SCP0005.log', 'a');
  run(); const stF = path.join(vibeDir, 'orch', 'usercheck', 'state.json'); const st = JSON.parse(fs.readFileSync(stF, 'utf8')); st.progress['J1:SCP0005'].since = now - 25 * M; fs.writeFileSync(stF, JSON.stringify(st));
  W('.vibe/jobs/J1/SCP0005.log', 'a'.repeat(5000));
  chk('U1 표시 25분 그대로 + 로그 늘어남 = 실패', has(run(), 'U1'));
  W('.vibe/jobs/J1/job.json', { id: 'J1', status: 'running', screens: [{ id: 'SCP0005', status: 'run', actor: 'claude', step: '[2] 2. 검증 보완' }] });
  chk('U1 Claude 단계 = 대상 아님', !has(run(), 'U1'));
  // U2 목표 시간
  EV = [{ type: 'chain.end', ms: now - 10 * M, ms_run: 184 * M, screen: 'SCP0028', chain: 'checklist', chainLabel: 'CheckList', ok: true }, { type: 'chain.end', ms: now - 9 * M, ms_run: 20 * M, screen: 'SSP0005', chain: 'checklist', ok: true }];
  W('Doc/verify/SCP0028/run_timing.json', [{ run_at: '2026-11-20 08:28:54', top: [{ stage: 'e2e', tool: 'playwright', min: 46.2 }] }]);
  let r = run(); chk('U2 184분 = 경고(표시만), 20분 = 없음', r.some(i => i.uid === 'U2' && i.level === 'warn' && /SCP0028/.test(i.what) && /e2e playwright 46.2분/.test(i.detail)) && !r.some(i => i.uid === 'U2' && /SSP0005/.test(i.what)));
  // U3 진단·반영 공백
  INC = [{ id: 'I1', rule: 'R1', status: 'open', ms: now - 150 * M, title: 'x', actions: [] }];
  PROP = [{ id: 'P1', status: 'pending', ms: now - 90 * M, title: 'VM 코드', targets: ['tools/VibeManager/a.js'] }, { id: 'P2', status: 'pending', ms: now - 90 * M, title: 'FE', targets: ['nscm-fe/x.tsx'] }];
  review = { enabled: true, lastMs: now - 60 * 3600000 };
  r = run(); chk('U3 조치 없는 열린 사건 150분 = 실패', has(r, 'U3', /열린 사건 1건/));
  chk('U3 자동 반영 대상 개선안 90분 미반영 = 실패(승인 대상 FE 는 제외)', r.some(i => i.uid === 'U3' && /개선안 1건/.test(i.what) && /P1/.test(i.detail) && !/P2/.test(i.detail)));
  chk('U3 상시 분석 48시간 넘게 멈춤 = 실패', has(r, 'U3', /상시 분석 멈춤/));
  chk('U3 U5 U7 같은 감지기 = 같은 key 1건', r.filter(i => /열린 사건/.test(i.what)).length === 1);
  INC = []; PROP = []; review = { enabled: true, lastMs: now };
  // U4 R13 미해결 · 재발
  INC = [{ id: 'A', rule: 'R13', screen: 'SSP0014', status: 'resolved', ms: now - 100 * M }, { id: 'B', rule: 'R13', screen: 'SSP0014', status: 'open', ms: now - 40 * M }];
  r = run(); chk('U4 R13 40분 미해결 = 실패', has(r, 'U4', /미해결 SSP0014/)); chk('U4 복구 뒤 재발 = 실패', has(r, 'U4', /재발 SSP0014/));
  INC = [];
  // U6 중지 뒤 거짓 사건
  EV = [{ type: 'user.stop', ms: now - 30 * M, screen: 'SCP0028', wb: 'J:SCP0028', by: '에이전트' }];
  INC = [{ id: 'F1', rule: 'R1', screen: 'SCP0028', status: 'open', ms: now - 30 * M + 20000, title: '실패' }, { id: 'F2', rule: 'R1', screen: 'SCP0028', status: 'open', ms: now - 20 * M, title: '나중 실패' }];
  r = run(); chk('U6 중지 20초 뒤 R1 = 실패, 10분 뒤 R1 = 아님', has(r, 'U6') && r.filter(i => i.uid === 'U6').length === 1 && /F1/.test(r.find(i => i.uid === 'U6').detail));
  INC = []; EV = [];
  // U8 화면 표시
  PROP = [{ id: 'P9', status: 'applied', ms: now - 200 * M, history: [{ at: new Date(now - 5 * M).toISOString(), what: '반영' }] }];
  chk('noteUi 받은 최신 활동이 원본보다 3시간 앞 = 기록', (uc.noteUi({ tab: 'prop', received: 1, newestMs: now - 200 * M }) || {}).gapMs > 60000);
  chk('U8 화면 표시 누락 = 실패', has(run(), 'U8'));
  fs.rmSync(path.join(vibeDir, 'orch', 'usercheck', 'ui.json')); chk('noteUi 최신까지 받음 = 기록 없음', (uc.noteUi({ tab: 'prop', received: 1, newestMs: now - 4 * M }) || {}).gapMs <= 60000 && !has(run(), 'U8'));
  PROP = [];
  // U9 R14 미해결 · 기록 불일치
  INC = [{ id: 'S1', rule: 'R14', screen: 'SCP0005', status: 'acting', ms: now - 5 * M, title: '중지 뒤 계속 실행' }];
  const jf = W('.vibe/jobs/J9/job.json', { id: 'J9', status: 'interrupted', note: 'VS Code 종료로 중단됨', screens: [{ id: 'SSP0014', status: 'run' }] }); fs.utimesSync(jf, new Date(now - 10 * M), new Date(now - 10 * M));
  r = run(); chk('U9 R14 미해결 = 실패', has(r, 'U9', /미해결 SCP0005/)); chk('U9 작업 중단인데 화면 실행 중 = 실패', has(r, 'U9', /기록 불일치 J9/));
  CH = [{ job: 'J9', runId: 'x' }]; chk('U9 체인이 살아 있으면 R14 가 맡음(기록 불일치 아님)', !has(run(), 'U9', /J9/)); CH = []; INC = [];
  fs.rmSync(path.join(vibeDir, 'jobs', 'J9'), { recursive: true });
  // U13 창 다시 로드 뒤 재개 누락
  const age = (f, mn) => fs.utimesSync(f, new Date(now - mn * M), new Date(now - mn * M));
  const j13 = W('.vibe/jobs/J13/job.json', { id: 'J13', status: 'interrupted', note: 'VS Code 종료로 중단됨', screens: [{ id: 'SSP0014', status: 'wait' }, { id: 'SCP0005', status: 'done' }] }); age(j13, 10);
  r = run(); chk('U13 중단 작업 남은 화면에 재개 기록 없음 = 실패', has(r, 'U13', /재개 표시 없음 J13/));
  W('.vibe/orch/chain_progress/SSP0014_1.json', { runId: 'SSP0014_1', screen: 'SSP0014', job: 'J13', interruptedAt: '2026-11-20T11:00:00+09:00', updatedMs: now - 10 * M, cur: 2, steps: 7 });
  r = run(); chk('U13 재개 기록 있음 + 중단 10분 = 아님', !has(r, 'U13'));
  age(j13, 40); r = run(); chk('U13 재개 기록 있음 + 중단 40분째 재시작 없음 = 실패', has(r, 'U13', /재개 안 됨 J13/));
  EV = [{ type: 'job.start', job: 'J13', ms: now - 5 * M }]; chk('U13 중단 뒤 같은 작업 job.start 있음 = 아님', !has(run(), 'U13'));
  EV = []; fs.rmSync(path.join(vibeDir, 'jobs', 'J13'), { recursive: true }); fs.rmSync(path.join(vibeDir, 'orch', 'chain_progress'), { recursive: true });
  INC = [{ id: 'R5A', rule: 'R5', notice: true, sig: 'R5|reloadcut|111', status: 'open', ms: now - 40 * M, title: '창 다시 로드로 끊긴 실행 1건(알림)', evidence: { owner: 111, runs: [{ what: 'chain', screen: 'SCP0028', label: 'CheckList' }] } }];
  chk('U13 R5 reloadcut 뒤 같은 화면 재실행 없음 = 실패', has(run(), 'U13', /재실행 없음 SCP0028/));
  EV = [{ type: 'chain.start', screen: 'SCP0028', ms: now - 10 * M }]; chk('U13 R5 뒤 같은 화면 chain.start 있음 = 아님', !has(run(), 'U13'));
  EV = []; INC = [];
  // U10 · U11
  EV = [{ type: 'chain.end', ms: now - 5 * M, ms_run: 10 * M, screen: 'SCP0005', wb: 'W1', chain: 'checklist', ok: false, claudeRan: 0, claudeSkipped: 3 }, { type: 'chain.end', ms: now - 5 * M, ms_run: 10 * M, screen: 'SSP0005', wb: 'W2', chain: 'checklist', ok: false, claudeRan: 0, claudeSkipped: 3 }, { type: 'user.stop', wb: 'W2', ms: now - 7 * M }];
  r = run(); chk('U10 Claude 건너뛰고 끝남 = 경고, 중지된 체인은 제외', r.some(i => i.uid === 'U10' && /SCP0005/.test(i.what)) && !r.some(i => i.uid === 'U10' && /SSP0005/.test(i.what)));
  EV = [];
  PROP = [{ id: 'R1', status: 'apply-failed', ms: now - 10 * 3600000, title: '실패 안', history: [{ at: new Date(now - 8 * 3600000).toISOString(), what: '반영 실패 exit 1' }] }];
  chk('U11 반영 실패 8시간 재진단 없음 = 실패', has(run(), 'U11'));
  PROP[0].repair = { at: new Date(now - 1 * 3600000).toISOString(), decision: 'retry' }; chk('U11 실패 뒤 재진단 있음 = 아님', !has(run(), 'U11')); PROP = [];
  // U14 VMW 화면 목록 명칭 빠짐: 메뉴 이름 있는데 목록 이름 빔 · ID 와 같음 · 웹뷰 보고 · 메뉴 없음
  const mnu = W('Doc/tobefacts/db/menu.csv', '﻿mnu_id,uppr_mnu_id,mnu_desc\nSCP0028,SCP,"Supply Plan, Detail"\nSSP0014,SSP,Order Plan\nSCP0005,SCP,Plan View\n');
  FT = [{ id: 'SCP0028', title: 'Supply Plan, Detail' }, { id: 'SSP0014', title: '' }, { id: 'DMF9999', title: '' }];
  r = run(); const u14 = r.find(i => i.uid === 'U14' && i.level === 'fail');
  chk('U14 메뉴 이름 있는데 목록 이름 빔(대상 SSP0014 + 업무 작업 J1 SCP0005) = 실패, 메뉴에 없는 DMF9999·이름 있는 SCP0028 제외', !!u14 && /2건/.test(u14.what) && /SSP0014 'Order Plan'/.test(u14.detail) && /SCP0005 'Plan View'/.test(u14.detail) && !/DMF9999|SCP0028/.test(u14.detail), u14 && u14.detail);
  FT[1].title = 'Order Plan'; fs.rmSync(path.join(vibeDir, 'jobs', 'J1'), { recursive: true });
  chk('U14 목록 이름 모두 채움 = 아님', !has(run(), 'U14'));
  FT[1].title = 'SSP0014'; chk('U14 목록 이름이 ID 와 같음 = 실패', has(run(), 'U14', /1건/)); FT[1].title = 'Order Plan';
  chk('noteUi scr 보고 기록', (uc.noteUi({ tab: 'scr', received: 3, blank: ['scp0028', 'x'] }) || {}).blank === 1);
  r = run(); chk('U14 웹뷰가 이름 없이 그린 SCP0028 = 실패', r.some(i => i.uid === 'U14' && i.level === 'fail' && /SCP0028 'Supply Plan, Detail'/.test(i.detail)));
  uc.noteUi({ tab: 'scr', received: 3, blank: [] }); chk('U14 웹뷰 보고 이름 빠짐 0 = 아님', !has(run(), 'U14'));
  fs.rmSync(mnu); FT[1].title = ''; r = run(); chk('U14 메뉴 파일 없음 = 경고(판정 못 함), 실패 아님', r.some(i => i.uid === 'U14' && i.level === 'warn') && !r.some(i => i.uid === 'U14' && i.level === 'fail'));
  FT = [];
  // U15 FE LOG 탭 송출 0줄: 기준 → 60초 뒤 파일 늘어남 + 송출 0 = 실패 · 송출 있음 = 아님 · 꺼짐 = 아님 · 기록 없음 = 경고 · VM 기동 로그 파일
  const ageFe = sec => { const s = JSON.parse(fs.readFileSync(stF, 'utf8')); s.logTab.fe.ms = now - sec * 1000; fs.writeFileSync(stF, JSON.stringify(s)); };
  const extLog = W('Doc/e2e/logs/_server_5173.log', 'a\n');
  EV = [{ type: 'server.state', port: 5173, state: 'up', owner: 'external', source: 'poll', ms: now - 30 * M }, { type: 'log.toggle', stream: 'fe', on: true, ms: now - 20 * M }];
  chk('U15 첫 점검 = 기준만', !has(run(), 'U15')); ageFe(120); fs.appendFileSync(extLog, 'x'.repeat(3000));
  r = run(); chk('U15 FE 켜짐 + 5173 up + 120초 동안 _server_5173.log 늘어남 + 송출 0줄 = 실패', r.some(i => i.uid === 'U15' && i.level === 'fail' && /_server_5173\.log/.test(i.detail)), JSON.stringify(r.filter(i => i.uid === 'U15')));
  ageFe(120); fs.appendFileSync(extLog, 'y'.repeat(3000)); EV.push({ type: 'log.out', stream: 'fe', lines: 12, ms: now - 30000 });
  chk('U15 같은 동안 log.out fe 12줄 = 아님', !has(run(), 'U15'));
  ageFe(30); fs.appendFileSync(extLog, 'z'.repeat(3000)); EV = EV.filter(e => e.type !== 'log.out');
  chk('U15 60초 안 = 판정 보류', !has(run(), 'U15'));
  ageFe(120); fs.appendFileSync(extLog, 'w'.repeat(10)); EV.push({ type: 'log.toggle', stream: 'fe', on: false, ms: now - 1 * M });
  chk('U15 FE LOG 꺼짐 = 아님', !has(run(), 'U15'));
  EV = [{ type: 'server.state', port: 5173, state: 'up', owner: 'external', source: 'poll', ms: now - 30 * M }]; run(); ageFe(120); fs.appendFileSync(extLog, 'v'.repeat(3000));
  r = run(); chk('U15 log.out, log.toggle 기록 없음 = 경고(판정 못 함), 실패 아님', r.some(i => i.uid === 'U15' && i.level === 'warn') && !r.some(i => i.uid === 'U15' && i.level === 'fail'));
  const vmLog = W('.vibe/logs/2026-11-20T11-00-00_NSCM_FE.log', 'a\n'); W('.vibe/logs/2026-11-20T09-00-00_NSCM_BE.log', 'b\n');
  EV = [{ type: 'server.state', port: 5173, name: 'NSCM FE', state: 'ready', source: 'start', ms: now - 10 * M }, { type: 'log.toggle', stream: 'fe', on: true, ms: now - 9 * M }];
  run(); ageFe(120); fs.appendFileSync(vmLog, 'x'.repeat(3000));
  r = run(); chk('U15 VM 이 띄운 FE = .vibe/logs/*_NSCM_FE.log 증가분으로 실패', r.some(i => i.uid === 'U15' && i.level === 'fail' && /NSCM_FE\.log/.test(i.detail)));
  EV.push({ type: 'server.state', port: 5173, state: 'down', owner: 'vm', source: 'poll', ms: now - 1000 }); chk('U15 5173 down = 아님', !has(run(), 'U15'));
  EV = [];
  // 감지기 없는 원장 항목
  const lf = path.join(vmd, 'user_checks.json'); const L = JSON.parse(fs.readFileSync(lf, 'utf8')); L.items.push({ id: 'U99', detector: 'noSuch', status: 'active' }); fs.writeFileSync(lf, JSON.stringify(L));
  chk('원장 감지기 이름이 코드에 없음 = 실패', run().some(i => i.uid === 'U99' && i.level === 'fail' && i.key === 'S13|U99|nodet'));
  // 파일에는 정의가 있고 실행 중 DETECTORS 에만 없음(반영 직후 창 다시 로드 전) = 경고
  const keepU15 = uc.DETECTORS.logTabShown; delete uc.DETECTORS.logTabShown;
  try { r = run(); chk('reload 표본: logTabShown 실행 중 없음 + 파일에 있음 = U15 경고 S13|U15|reload, 실패 아님', r.some(i => i.uid === 'U15' && i.level === 'warn' && i.key === 'S13|U15|reload') && !r.some(i => i.uid === 'U15' && i.level === 'fail'), JSON.stringify(r.filter(i => i.uid === 'U15'))); } finally { uc.DETECTORS.logTabShown = keepU15; }
  // 사람 프롬프트 수집
  const ts = k => new Date(Date.parse(L.coveredUntil) + k * M).toISOString();
  fs.writeFileSync(path.join(sess, 'a.jsonl'), [
    { type: 'user', entrypoint: 'claude-desktop', timestamp: ts(-5), message: { content: '이전 지적(원장에 있음)' } },
    { type: 'user', entrypoint: 'claude-desktop', timestamp: ts(1), message: { content: '업무 작업 중지를 눌렀는데 상황판에 그대로 보입니다 a@b.com' } },
    { type: 'user', entrypoint: 'sdk-cli', timestamp: ts(2), message: { content: '.claude/agents/vm-orchestra.md 를 먼저 읽고' } },
    { type: 'attachment', timestamp: ts(3), attachment: { type: 'queued_command', prompt: 'Fixes 탭 디자인을 바꿔주세요', origin: { kind: 'human' }, timestamp: ts(3) } },
    { type: 'user', entrypoint: 'claude-desktop', timestamp: ts(4), message: { content: 'VMO 가 로그 용량이 커져도 알려주지 않습니다' } },
    { type: 'user', entrypoint: 'claude-desktop', timestamp: ts(5), message: { content: 'This session is being continued from a previous conversation' } },
  ].map(x => JSON.stringify(x)).join('\n'));
  const pp = uc.pendingPrompts();
  chk('수집: 원장 뒤 사람 입력 3건(sdk-cli·이전·이어받기 요약 제외, 끼운 메시지 포함)', pp.length === 3, JSON.stringify(pp.map(p => p.text.slice(0, 20))));
  chk('수집: 메일 주소 가림', pp[0].text.includes('<메일>') && !pp[0].text.includes('a@b.com'));
  // 학습(가짜 Claude)
  const said = [];
  mods['orch-agent'] = { withLock: async (id, fn) => fn(), say: (k, o) => said.push(o.text), lastJsonBlock: t => JSON.parse(t), runClaude: async () => ({ ok: true, code: 0, ms: 1000, log: 'x.log', text: JSON.stringify({ items: [
    { n: 1, kind: 'issue', symptom: '중지 뒤 표시 남음', detector: 'stopLeak' },
    { n: 2, kind: 'not-issue', why: '디자인 요청' },
    { n: 3, kind: 'issue', symptom: '로그 용량 알림 없음', detector: '', newDetector: { name: 'logSize', judge: '.vibe/logs 1GB 넘음', data: '.vibe/logs' } },
  ] }) }) };
  const lr = await uc.learn(true);
  chk('학습 결과: 기존 감지기 1 · 새 감지기 개선안 1 · 지적 아님 1', lr.ok && lr.mapped === 1 && lr.added === 1 && lr.excluded === 1, JSON.stringify(lr));
  const L2 = JSON.parse(fs.readFileSync(lf, 'utf8'));
  chk('원장: stopLeak 항목에 인용 추가', (L2.items.find(u => u.detector === 'stopLeak').also || []).some(a => /상황판/.test(a)));
  chk('원장: 새 지적 pending-detector 로 추가', L2.items.some(u => u.detector === 'logSize' && u.status === 'pending-detector'));
  chk('개선안: source self · 대상 orch-usercheck.js · selfKey S13', proposalsAdded.length === 1 && proposalsAdded[0].src === 'self' && proposalsAdded[0].o.targets.includes('tools/VibeManager/orch-usercheck.js') && /^S13\|/.test(proposalsAdded[0].o.selfKey));
  chk('학습 뒤 새 프롬프트 0건(coveredUntil 이동)', uc.pendingPrompts().length === 0);
  chk('pending-detector 는 실행 대상 아님(감지기 없음 실패 안 냄)', !run().some(i => /logSize/.test(i.detail || '')));
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
