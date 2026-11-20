// 업무 작업창 세부 진행 표시(2026-11-20): 로그 줄 → 단계 · 세부 · 시험 · AI 묶음 · 대기
//   사용: node test/t_job_prog.js <VibeManager 폴더>
const path = require('path'); const Module = require('module');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (req, ...rest) { return req === 'vscode' ? stub : orig.call(this, req, ...rest); };
const jr = require(path.join(dir, 'job-runner'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const pg = {};
jr.parseProg(pg, '[단계 4/8] E2E 검증엔진(@verify·@trace) · tier all\nRunning 80 tests using 1 worker\n');
chk('단계와 시험 수', jr.progText(pg) === '단계 4/8 E2E 검증엔진(@verify·@trace) · tier all · 시험 0/80', jr.progText(pg));
jr.parseProg(pg, '  ok 1 [chromium] › a\n  ok 2 [chromium] › b\n  x 3 [chromium] › c\n');
chk('시험 진행 3/80', pg.test === '3/80', pg.test);
jr.parseProg(pg, '[단계 7/8] 사후 검사·판정·추적 — 세부 41개\n[세부 38/41] llm_review.py\n  · AI 판정 검토 묶음 22/224 — 6행 · 규칙 A6\n');
chk('새 단계에서 시험 지움 · 세부 · AI 묶음', jr.progText(pg) === '단계 7/8 사후 검사·판정·추적 · 세부 38/41 llm_review.py · AI 묶음 22/224', jr.progText(pg));
jr.parseProg(pg, '[WAIT] SSP0005 부하 기준 초과·입장 대기 — 다른 화면이 방금 시작\n');
chk('대기 사유', /대기: SSP0005 부하 기준 초과/.test(jr.progText(pg)), jr.progText(pg));
chk('관계없는 줄 = 바뀜 없음', jr.parseProg(pg, '[시간] judge.py · 시작 03:38:39\n') === false);
{ const q = {}; jr.parseProg(q, '[수정분 범위] partial · 직전 미해결 행의 규칙 3개 · 재측정 규칙 5개\n[단계 4/8] E2E\n'); chk('수정분 범위 표시가 단계와 함께 남음', /^수정분: 직전 미해결 행의 규칙 3개/.test(jr.progText(q)) && /단계 4\/8/.test(jr.progText(q)), jr.progText(q));
  const r = {}; jr.parseProg(r, '[수정분 범위] full · 기준선 없음\n'); chk('전체 전환 표시', /^수정분 → 전체: 기준선 없음/.test(jr.progText(r)), jr.progText(r)); }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
