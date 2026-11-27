// orch-history.js: 원천 → 원장 수집 · 세션 기록은 늘어난 부분만 읽기 · 비밀값 가리기 · 변경 절과 세션 연결 · 정리본 생성
//   사용: node test/t_orch_history.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'hist-')); const vibeDir = path.join(root, '.vibe'); const vm = path.join(root, 'tools', 'VibeManager'); const sess = path.join(root, 'sess');
const mk = (f, s) => { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, s, 'utf8'); };
const NL = String.fromCharCode(10);
mk(path.join(vm, 'CHANGELOG.md'), [
  '## (판 번호 없음, VM 저장소 + 설치 폴더) VMO: 에이전트 탭 프롬프트 창 (2026-11-19 18:5x)',
  '- 사용자(11-19): "프롬프트 창을 하단에 배치해주세요."',
  '- orchestra.js: 탭 구성 변경. workbench.js: 메시지 처리 추가.',
  '- 확인(18:55 실행): t_orch_agent_q.js 13건. VS Code 실화면 미확인(창 다시 로드 필요).',
  '- 미확인: 실제 Claude 응답 표시 · 대기열 5건 넘을 때 동작',
  '- 되돌리기: orchestra.js.bak_20261119_agtab · workbench.js.bak_20261119_agtab',
  '',
  '## 1.9.23 (2026-10-22)',
  '- quick.json: 사이드바 메뉴 항목 추가',
].join(NL));
mk(path.join(vm, 'orchestra.js.bak_20261119_agtab'), 'x'); mk(path.join(vm, 'workbench.js.bak_20261119_agtab'), 'x'); mk(path.join(vm, 'quick.json.bak_20261030'), 'x');
mk(path.join(root, 'tools', 'E2E', 'users.json'), JSON.stringify({ adminPool: { users: ['tester01', 'kimadmin2'] } }));
const line = o => JSON.stringify(o) + NL; const sf = path.join(sess, 'abc-123.jsonl');
mk(sf, line({ type: 'session-owner', accountUuid: 'secret-owner', sessionId: 'abc-123' })
  + line({ type: 'user', isSidechain: false, message: { role: 'user', content: [{ type: 'text', text: '<system-reminder>무시</system-reminder>VMO 에이전트 탭을 고쳐주세요. tester01 계정 someone@example.com SCP0111' }] }, timestamp: '2026-11-19T09:50:00.000Z', sessionId: 'abc-123' })
  + line({ type: 'user', message: { role: 'user', content: [{ type: 'tool_result', content: 'ok' }] }, timestamp: '2026-11-19T09:51:00.000Z' })
  + line({ type: 'assistant', message: { role: 'assistant', content: [{ type: 'tool_use', name: 'Edit', input: { file_path: 'C:\\Projects\\NSCM\\tools\\VibeManager\\orchestra.js' } }, { type: 'tool_use', name: 'Bash', input: { command: 'node tools/VibeManager/test/t.js' } }] }, timestamp: '2026-11-19T09:52:00.000Z' })
  + line({ type: 'custom-title', customTitle: 'VM 고도화', sessionId: 'abc-123' }));
mk(path.join(sess, 'memory', 'feedback_x_20261119.md'), ['---', 'name: feedback-x', 'description: VMO 관련 지시', 'metadata:', '  type: feedback', '  originSessionId: abc-123', '---', '본문'].join(NL));
mk(path.join(vibeDir, 'history', 'SCP0111', '20261119_101500_claude', 'meta.json'), JSON.stringify({ id: 'SCP0111', task: 'claude', source: 'prompt', label: '프롬프트', text: '검증쿼리 제공해주세요', start: '2026-11-19T10:15:00+09:00', end: '2026-11-19T10:20:00+09:00', exit: 0, changed: [] }));
mk(path.join(vibeDir, 'logs', '2026-11-19T20-57-19_claude_orch.log'), ['$ claude.exe -p', '--- prompt ---', '사건 R5 를 확인한다', '--- output ---', '{}', '--- exit 0 ---', ''].join(NL));
mk(path.join(vibeDir, 'orch', 'incidents', '20261119_181812_R4_DMF0042.json'), JSON.stringify({ id: '20261119_181812_R4_DMF0042', ms: Date.parse('2026-11-19T18:18:12+09:00'), rule: 'R4', title: '대기 지연', screen: 'DMF0042', status: 'resolved', actions: [{ what: '확인' }] }));
mk(path.join(vibeDir, 'orch', 'proposals', '20261119193539_REVIEW.json'), JSON.stringify({ id: '20261119193539_REVIEW', at: '2026-11-19T19:35:39+09:00', status: 'applied', source: 'review', title: 'hook 제한', targets: ['.claude/settings.json'] }));
mk(path.join(root, 'Doc', 'verify', '_checker_defects.md'), ['## 1. 유형', '## T314~T319 (2026-11-18 18:1x · SCP0111 미검증 해소 라운드 1)', '내용'].join(NL));

const h = require(path.join(dir, 'orch-history')); h.init({ paths: () => ({ root, vibeDir, extDir: vm }), sessionDirs: [sess] });
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
(async () => {
  const st = await h.collect();
  chk('원천별 건수', st.sources.changelog === 2 && st.sources.sessions === 1 && st.sources.runs === 1 && st.sources.claudeLogs === 1 && st.sources.vmo === 2 && st.sources.baks === 3 && st.sources.memories === 1 && st.sources.docs === 1, JSON.stringify(st.sources));
  const cl = h.list({ kind: 'change' }).items; const c0 = cl.find(x => /에이전트 탭/.test(x.title));
  chk('변경 절: 일자 · 영역 · 지시 · 파일 · 되돌리기 태그', c0 && c0.date === '2026-11-19' && c0.area === 'VMO' && c0.ask[0] === '프롬프트 창을 하단에 배치해주세요.' && c0.files.includes('orchestra.js') && c0.files.includes('workbench.js') && c0.baks.join() === '20261119_agtab' && c0.bakFiles === 2 && c0.needsReload, JSON.stringify(c0));
  chk('변경 절: 미확인 3건(확인 줄 1 + 미확인 줄 2)', c0.unverified.length === 3 && c0.unverified.some(u => /대기열 5건/.test(u)), JSON.stringify(c0.unverified));
  chk('판 번호 절', cl.some(x => x.ver === '1.9.23' && x.date === '2026-10-22' && x.area === '체인·메뉴'), JSON.stringify(cl.map(x => [x.ver, x.area])));
  const s = h.get('S:abc-123');
  chk('세션: 제목 · 지시 1건(도구 결과 · 주입 문구 제외) · VM 파일 수정 1 · 명령 1', s && s.title === 'VM 고도화' && s.askCount === 1 && s.vmEditCount === 1 && s.vmCmds === 1 && s.fileEdits['orchestra.js'] === 1 && s.vm === true, JSON.stringify(s));
  chk('세션: 계정 · 메일 가림 · 화면 ID · 메모리 연결', /<계정>/.test(s.ask[0]) && /<메일>/.test(s.ask[0]) && !/tester01|someone@|무시/.test(s.ask[0]) && s.screens.includes('SCP0111') && s.memories.includes('feedback-x'), s.ask[0]);
  chk('변경 절과 세션 연결(같은 날 같은 파일)', c0.sessions.length === 1 && c0.sessions[0] === 'abc-123');
  const raw = fs.readFileSync(path.join(vibeDir, 'orch', 'history', 'worklog.jsonl'), 'utf8');
  chk('원장에 소유자 줄 · 계정 · 메일 없음', !/secret-owner|tester01|someone@example/.test(raw));
  chk('1회째 = 세션 파일 전체 읽음', st.sessionBytesRead === fs.statSync(sf).size, String(st.sessionBytesRead));
  const st2 = await h.collect(); chk('2회째 = 읽은 바이트 0', st2.sessionBytesRead === 0 && st2.total === st.total);
  const add = line({ type: 'user', message: { role: 'user', content: 'Log 탭을 맨 뒤로 보내주세요' }, timestamp: '2026-11-19T10:30:00.000Z' }); fs.appendFileSync(sf, add);
  const st3 = await h.collect(); chk('3회째 = 늘어난 줄만 읽음 · 지시 2건', st3.sessionBytesRead === Buffer.byteLength(add) && h.get('S:abc-123').askCount === 2, String(st3.sessionBytesRead));
  chk('거르기: 영역 · 화면 · 검색어', h.list({ area: 'VMO', kind: 'change' }).total === 1 && h.list({ screen: 'scp0111', kind: 'run' }).total === 1 && h.list({ q: '검증쿼리' }).total === 1);
  const md = fs.readFileSync(path.join(vm, 'WORKLOG.md'), 'utf8');
  chk('정리본: 건수 표 · 일자 절 · 굵은 글씨와 줄표 없음', /\| 변경 \| 2 \|/.test(md) && /^## 2026-11-19$/m.test(md) && !/\*\*|—/.test(md), md.slice(0, 80));
  chk('주 목록', h.weeks().some(w => w.week === '2026-11-16' && w.count >= 2), JSON.stringify(h.weeks()));
  // 미확인 판별(2026-11-19 SELF_2): 기능 설명 줄 제외 · '미확인:' 줄 문장 단위 분리. 원문 = CHANGELOG.md 의 Q3, Q4, Q5 줄과 개선안 반영 절차 줄, 21:1x~21:5x 절의 미확인 줄
  const unv = body => h.parseChangelog(['## (판 번호 없음, VM 저장소) 시험 (2026-11-19 21:00)'].concat(body).join(NL))[0].unverified;
  const DESC = [
    `- Q3 VMO 창 '이력' 탭: 건수 카드, 기간·영역·종류·화면·검색어 조회, 행을 누르면 지시 원문·파일·확인·미확인·되돌리기 태그·세션·원천. 주제별 정리 = 주 단위 Claude 호출 1회(읽기 전용), 끝난 주는 보관한 결과를 씀.`,
    `- Q4 신규 orch-selfcheck.js: 점검 S1 구문, S2 시험, S3 저장소와 설치 폴더 내용 차이, S4 정의 정합(없는 작업 id, 없는 메뉴, package.json 명령과 registerCommand, 없는 모듈 require, inventory_check.py), S5 실행 오류, S6 변경 기록의 미확인 원장, S7 VMO 자기 상태, S8 반영한 개선안의 재발, S9 반복 수정 지점, S10 용량, S11 고정 문구(doc_style.py), S12 설정 정합. 어긋남(fail) = 사건 R12 1건(풀리면 해결 처리), 주의(warn) = 탭 표시만. 주기 = 가벼운 항목 10분, 무거운 항목은 VM 파일이 바뀌고 120초 지난 뒤와 24시간마다, 체인 실행 중에는 쉼.`,
    `- Q5 VMO 창 '자가진단' 탭: 항목 카드 12개, 어긋난 항목 표, 미확인 원장(확인함, 대상 아님, 다시 열기), 실행 오류 상위 서명. 버튼 = 지금 점검, 지금 진단, 설치 폴더 동기화, 결과 파일. Claude 진단(읽기 전용)은 개선안을 source 'self'(id 끝 SELF)로 올림. .claude/agents/vm-orchestra.md 에 'VM 자가진단' 절 추가.`,
    `  - 승인(확인 창) → 대상 파일 사본 저장(.vibe/orch/snap/prop_<id>/) → Claude 반영(승인 범위 안에서 C 등급 대상 수정 허용 · D 등급 금지 유지) → 검증. 반영 안 됨·검증 실패·검증 미실행이면 대상 파일을 복원하고 '반영 실패'. 통과면 '반영 완료'.`,
  ];
  const u0 = unv(DESC); chk('기능 설명 4개 문장 = 미확인 0건', u0.length === 0, JSON.stringify(u0));
  const u5 = unv(['- 미확인: VS Code 실화면(창 다시 로드 필요). 가동 중 주기 점검(시작 45초 뒤 첫 실행, 10분 주기)과 첫 이력 수집 자동 실행. 실제 Claude 로 자가 보완 반영(가짜 claude 로만 확인). 주제별 정리 실제 Claude 호출. 사건 R12 가 실제 VMO 사건 탭에 올라오는 모습.']);
  chk("'미확인:' 줄 문장 5개 = 5건", u5.length === 5 && u5[0] === 'VS Code 실화면(창 다시 로드 필요).' && /^사건 R12/.test(u5[4]), JSON.stringify(u5));
  const u1 = unv(['- 확인: node --check. VS Code 실화면 미확인(창 다시 로드 필요).']); chk('확인 줄의 미확인 문장 = 1건', u1.length === 1 && u1[0] === 'VS Code 실화면 미확인(창 다시 로드 필요).', JSON.stringify(u1));
  chk('제외 자리와 미확인이 함께 있는 문장 = 미확인', h.isUnverifiedSentence('미확인 원장 표시는 VS Code 화면 미확인.') && !h.isUnverifiedSentence('미확인 원장 표시') && h.isUnverifiedSentence('실행 시간 증가 미측정.') && h.isUnverifiedSentence('플랜 7절 검증 13·14 미실행'));
  // 따옴표 인용 제외(2026-11-21 20261121225944_SELF_3): 원문 = CHANGELOG.md 의 workbench.js 고정 문구 정리 3차 절 '- 변경:' 줄, 변경 파일 집계 절 '- 변경:' 줄, U25 절 '- 변경:' 줄
  const q1 = unv([`- 변경: 예: :106 '── 증명 단계: \${pt} (\${effId}) — 보완 결과를 사내 DB 실측으로 확인' → '── 증명 단계: \${pt} (\${effId}). 보완 결과를 사내 DB 실측으로 확인' / :108 '⚠ 증명 단계 \${pt} 종료코드 \${pcp} — 2 = FAIL 있음 · 3 = 미측정 있음.' → '증명 단계 \${pt} 종료코드 \${pcp}. 2 = FAIL 있음, 3 = 미측정 있음.' / :109 '✔ 증명 단계 \${pt} 통과' → '증명 단계 \${pt} 통과'. 파일 tools/VibeManager/workbench.js. 대상 밖 변경 9개(다른 작업).`]);
  chk('변경 줄 따옴표 안 미측정 = 0건', q1.length === 0, JSON.stringify(q1));
  const q2 = unv([`- 변경: orch-history.js:109 files = 본문 전체의 파일 이름 → files = 본문에서 '- 확인', '- 사용자', '- 되돌리기', '- 미확인', '- 시험', '- node ' 로 시작하는 줄을 빼고, 남은 줄의 '· 확인:' 뒤 부분을 잘라낸 본문의 파일 이름. 파일 tools/VibeManager/orch-history.js, tools/VibeManager/test/t_orch_history.js. 대상 밖 변경 14개(다른 작업).`]);
  chk("변경 줄 따옴표 안 '- 미확인' = 0건", q2.length === 0, JSON.stringify(q2));
  const q3 = unv([`- 변경: DETECTORS 에 partialRemeasureSlow 없음 → 추가. 판정: 같은 화면, 같은 체인에서 부분 재측정 단계 소요(종료-시작)가 1차 checklistRun 측정 단계 소요 이상이면 issue · 읽을 기록: .vibe/history/<ID>/*_S8.checklistRun/meta.json (시작, 종료 시각), 같은 체인의 부분 재측정 단계 meta.json (시작, 종료 시각, 대상 행 수. 파일명과 필드명 미확인), Doc/verify/<ID>/run_verify.result.json (started, ts). user_checks.json U25 status pending-detector → active.`]);
  chk('따옴표 없는 미확인 = 1건', q3.length === 1 && /파일명과 필드명 미확인/.test(q3[0]), JSON.stringify(q3));
  // 변경 파일 집계 제외 줄(2026-11-20 20261120182700_SELF): 원문 = CHANGELOG.md :27 '- 시험:', :79·:104 '- node test/run_all.js', :458 '· 확인: node test/run_all.js'
  const fl = body => h.parseChangelog(['## (판 번호 없음, VM 저장소) 시험 (2026-11-20 18:30)'].concat(body).join(NL))[0].files;
  const f1 = fl(['- 변경 없음', '- 확인: node test/run_all.js FAIL 0']); chk('확인 줄에만 run_all.js = files 에 없음', !f1.includes('test/run_all.js') && !f1.some(x => /run_all\.js/.test(x)), JSON.stringify(f1));
  const f2 = fl(['- node test/run_all.js → FAIL 0']); chk('- node 명령 줄에만 run_all.js = files 에 없음', !f2.some(x => /run_all\.js/.test(x)), JSON.stringify(f2));
  const f3 = fl(['- 엔진 쪽 변경 X.md · 확인: node test/run_all.js']); chk("줄 가운데 '· 확인:' 뒤 = 제외, 앞 X.md = 있음", f3.includes('X.md') && !f3.some(x => /run_all\.js/.test(x)), JSON.stringify(f3));
  const f4 = fl(['- 변경: test/run_all.js 에 t_x.js 추가']); chk('변경 줄의 파일 = files 에 있음', f4.includes('test/run_all.js') && f4.includes('t_x.js'), JSON.stringify(f4));
  // 변경 절 종류(개선안 20261122000646_SELF_2): 결함(defect) · 요청(request) · 문구(style)
  const fk = (title, body) => h.fixKindOf(title, body);
  chk('종류: S11 근거 키 = 문구 · 제목 결함 = 결함 · 원인 줄 = 결함 · 승인한 SELF 개선안 = 결함 · 지나가며 적힌 INC id = 요청 · 제목 원인 = 요청 · 인용만 = 요청',
    fk('VMO 자가 보완: x.js 고정 문구 정리', ['- 사용자(11-22): 개선안 20261122230716_SELF 승인(VM 자가진단 S11 S11|x.js)']) === 'style'
    && fk('Y 결함 정정', ['- 사용자: "a"']) === 'defect' && fk('Z 보이게', ['- 사용자: "a"', '- 원인: b']) === 'defect'
    && fk('VMO 자가 보완: 로그 이름', ['- 사용자(11-20): 개선안 20261120064043_SELF 승인(VM 자가진단  ). 근거 = x']) === 'defect'
    && fk('자동 반영 기준', ['- 사용자(11-19): "권장대로"', '- 확인: 20261119205920_INC(R5 판정) 반영 271초']) === 'request'
    && fk('자동 보완 = 같은 원인 묶음', ['- 사용자(11-18): "추천안으로"']) === 'request' && fk('탭 순서 변경', ['- 사용자(11-18): "순서 변경"']) === 'request');
  // 실 CHANGELOG.md 의 workbench.js 절 직접 분류(2026-11-23 17:0x, 절 제목 · 사용자 줄 · 원인 줄을 읽고 판정) d 결함, r 요청, s 문구. 키 = 절 제목 앞부분
  const MAN = { d: ["파일 탭 Ctrl+A 보완: VS Code 본체", "프롬프트 붙여넣기 가로 스크롤 제거", "VMO 자가 보완: 단계 소요 통계 키에", "VMO 자가 보완: 실행 끝 기록 단일화", "VMO 자가 보완: 창 종료로 멈춘 실행이", "VMO 자가 보완: 감지기 판정 자료의", "VMO 자가 보완: 재개 기록(chain_pro", "창 다시 로드 뒤 남은 실행 정리 ·", "작업창 체인 보드 — 단계 카드 밖으", "VMO R14 오판으로 재개된 CheckL", "VMO 자가 보완: 중지되거나 끊긴 체인", "VMO 자가 보완: 잠금 파일 시각(at)", "Workbench 에서 재개한 VMW 작업이", "VMO 되돌림 = AI 가 한 편집만 거꾸", "VMO 자가 보완: 체인 끝 기록(step.", "VMO 자가 보완: VMO Events 탭에", "VMO BE · FE Log 켜고 끄기(기본", "VMO 자가 보완: 사용자 지적 감지기 추", "VMO 자가 보완: 하위 프로세스 소멸 뒤", "업무 작업 중지 뒤 체인이 다음 단계를", "VMO 자가 보완: VM 창이 끝날 때 jo", "VMO 자가 보완: VM 작업 로그 이름에", "VMO 자가 보완: R11·R10 사건이 지난", "서버 상태 측정: 측정 중 재호출 때 옛", "VMO 자가 보완: workbench.js 웹뷰", "단계 안 작업 = 하위 단계 표시 · 🧪", "숫자 답 현황판을 턴마다 표시", "단계 수선(🧪 미검증 해소 등) Clau", "Console 탭 HTML 틀 = VS Code", "건수 현황 질문 = VM 이 현황판 HTM", "Source Backup — 폴더 묶음별 add", "Source Backup 실패 보완, 남은 in"],
    s: ["VMO 자가 보완: workbench.js L3222", "VMO 자가 보완: workbench.js L715", "VMO 자가 보완: doc_style.py JS", "VMO 자가 보완: workbench.js L106", "VMO 자가 보완: workbench.js 592", "VMO 자가 보완: workbench.js 83~"],
    r: ["ID 입력칸 = 한글 입력 상태에서도", "파일 탭 보기 모드 Ctrl+A = 그", "실행 룰 A-13(누락 0 안에서", "룰 A-12 검증 쿼리: DB 조회", "작업 중 입력한 프롬프트: 같은 안건", "VMO 창 제목 줄에 VM 사이드바", "프롬프트 여러 줄 입력 자동 줄바꿈", "최종보고 전 쓰지 않는 백그라운드", "VMW 화면 카드에 미검증 건수 표기", "VMO 실행 카드에 미검증 건수 표기", "CheckList 검사기 보완 회차에 미검", "FLOW 글래스모피즘 화면", "Workbench 글래스모피즘 화면", "작업 재개 때 VMO 실행 카드에 전체", "재개 표시: 인자에 따라 단계 안 재개", "작업 재개 = 끊긴 지점부터(R1 VM", "중단된 작업 자동 삭제(설정 vibeMa", "실행 주체 표시 'Claude' → 'AI", "CheckList 한 번 실행으로 미검증 해", "VMO · VMW 에서 화면을 누르면 같은", "창 다시 로드 뒤 작업 재개(VMW · W", "Health 탭 C 안(점검표 + 상세) ·", "VMO 사용자 지적 자가진단(S13) · 중", "VMO 자가 보완: 측정 추가: 에이전트", "VMO 자가 보완: 측정 추가: 7일 집계", "VMO 상황판 '지금 실행 중' 카드에", "업무 작업 내용을 같은 화면 ID 의 W", "VMO 사건: 창 다시 로드로 생긴 사건을", "상황판 A 관제실 · 하단 시간별 흐름", "VMO 자동 반영 하루 상한 해제 · 건너", "VMO 자동 반영 기준을 출처에서 대상으", "VMO 자가 보완 자동 반영 전환 · Cla", "VMO 작업 이력 취합 · VM 자가진단 S", "VMO 창: 명칭 VMO · 반투명 대시보드", "오케스트라 P9·P10: 업무 작업 동시", "오케스트라 P7: 창 없는 체인 실행기", "오케스트라 P4: 에이전트 조치", "오케스트라 P0~P3: 사건 기록 · 서버", "체인 조건부 단계 = 실행이 정해질 때", "실행 중 프롬프트 = 중지 없이 진행 중", "🔎 CheckList 체인 = 1. CheckL", "미검증 해소 = 전체 목록 → 일괄 보완", "Console 탭 HTML 표시, 화면 건수", "CheckList 뒤 미검증 자동 해소", "Status E2E 4종 타일 삭제", "Status · Flow 단계를 파싱부터 완료", "Workbench 상단 탭 순서 Console", "자동 보완 = CheckList 기준으로만:", "DB MODE FE 가이드 = 문장 규칙 19", "Workbench Revision · Task Hi", "Workbench Log·Task Log 탭 통합", "Workbench 탭 이름 Revision His", "Console 보드 반투명", "CheckList 폴더 Doc/CheckList", "AS-IS 실측 메뉴 26개 → 1개", "문장 규칙 3개 — 수식어 금지 · 아는", "사이드바 메뉴 = 모바일 홈 화면형 · 프", "+ 생성·보완 ↔ 정합검증 연결 · 메뉴"] };
  const KN = { d: 'defect', r: 'request', s: 'style' }; const manOf = t => { for (const [k, arr] of Object.entries(MAN)) if (arr.some(p => t.startsWith(p))) return KN[k]; return ''; };
  const realCl = fs.existsSync(path.join(dir, 'CHANGELOG.md')) ? h.parseChangelog(fs.readFileSync(path.join(dir, 'CHANGELOG.md'), 'utf8')).filter(c => c.files.some(f => path.basename(f) === 'workbench.js')) : [];
  const cmp = { man: { defect: 0, request: 0, style: 0 }, auto: { defect: 0, request: 0, style: 0 }, labeled: 0, unlabeled: 0, miss: [] };
  for (const c of realCl) { const m = manOf(c.title); if (!m) { cmp.unlabeled++; continue; } cmp.labeled++; cmp.man[m]++; cmp.auto[c.fix]++; if (m !== c.fix) cmp.miss.push(`CHANGELOG.md:${c.sources[0].line} 직접 ${m} / 분류 ${c.fix} ${c.title.slice(0, 50)}`); }
  console.log(`  workbench.js 절 ${realCl.length}개 · 직접 분류 표본 ${cmp.labeled}개(표본 밖 ${cmp.unlabeled}) · 직접 ${JSON.stringify(cmp.man)} · 분류 ${JSON.stringify(cmp.auto)} · 어긋남 ${cmp.miss.length}절`);
  for (const m of cmp.miss) console.log(`    어긋난 절: ${m}`);
  // 2026-11-23 17:1x 실측 어긋남 7절(직접 결함 → 분류 요청 3, 직접 요청 → 분류 결함 4). 문구 6절은 일치해야 함
  /* 2026-11-26 개선안 20261126164033_SELF: '- 변경: … 파일 <목록>.' 표시 절은 그 목록만 세어 설명 속 workbench.js 언급 절 5개가 빠짐(96 → 91) */
  chk('실 CHANGELOG workbench.js 표본 90절 이상: 문구 일치 · 어긋남 7절 이하 · 결함 수 차이 3 이하', cmp.labeled >= 90 && cmp.man.style === cmp.auto.style && !cmp.miss.some(m => /style/.test(m)) && cmp.miss.length <= 7 && Math.abs(cmp.man.defect - cmp.auto.defect) <= 3, JSON.stringify({ labeled: cmp.labeled, man: cmp.man, auto: cmp.auto, miss: cmp.miss.length }));
  // 집계: 결함 절만 7일 5회 기준 · 요청, 문구 건수는 따로 · 한 절에 같은 파일 이름 경로만 달리 2번 = 1건
  { const r2 = fs.mkdtempSync(path.join(os.tmpdir(), 'hist2-')); const vm2 = path.join(r2, 'tools', 'VibeManager'); const sec = (i, t, b) => [`## (판 번호 없음, VM 저장소) ${t} (2026-11-2${i % 3} 10:0${i})`].concat(b).join(NL);
    const secs = []; for (let i = 0; i < 5; i++) secs.push(sec(i, `결함 ${i} 정정`, ['- 원인: x', '- 변경: w.js, tools/VibeManager/w.js']));
    for (let i = 0; i < 6; i++) secs.push(sec(i, `요청 ${i}`, ['- 사용자(11-20): "추가"', '- 변경: w.js, r.js']));
    secs.push(sec(1, 'w.js 고정 문구 정리', ['- 사용자: 개선안 20261122230716_SELF 승인(VM 자가진단 S11 S11|w.js)', '- 변경: w.js']));
    for (let i = 0; i < 4; i++) secs.push(sec(i, `결함 ${i} 정정 q`, ['- 원인: y', '- 변경: q.js']));
    mk(path.join(vm2, 'CHANGELOG.md'), secs.join(NL + NL));
    h.init({ paths: () => ({ root: r2, vibeDir: path.join(r2, '.vibe'), extDir: vm2 }), sessionDirs: [], timer: false }); const s2 = await h.collect();
    const rw = s2.repeatFiles.find(r => r.file === 'w.js');
    chk('집계: w.js 결함 5(경로 중복 1건) · 요청 6 · 문구 1 · count = 결함 · 요청만 6건인 r.js, 결함 4건 q.js 는 없음', rw && rw.count === 5 && rw.defect === 5 && rw.request === 6 && rw.style === 1 && rw.total === 12 && !s2.repeatFiles.some(r => r.file === 'r.js' || r.file === 'q.js'), JSON.stringify(s2.repeatFiles));
    const md2 = fs.readFileSync(path.join(vm2, 'WORKLOG.md'), 'utf8'); chk('정리본: 결함, 요청, 문구 열', /\| w\.js \| 5 \| 6 \| 1 \|/.test(md2), (md2.match(/^\| w\.js.*$/m) || [''])[0]);
    try { fs.rmSync(r2, { recursive: true, force: true }); } catch { } }
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
