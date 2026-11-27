// 2026-11-20 사용자 지시 'VMW 카드에도 미검증 건수 표기' — Workbench 회차 판단 줄 → job-runner unvOf → 화면 기록 unv → jobs.js 카드 한 줄
const path = require('path'); const Module = require('module');
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (req, ...rest) { return req === 'vscode' ? stub : orig.call(this, req, ...rest); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const jr = require(path.join(dir, 'job-runner'));
let u = jr.unvOf('\n↻ 반복 1회차 진행: actionable = 13 · 미검증 30건 · 처리 대상 13건\n');
chk('진행 줄 → 건수', u && u.round === 1 && u.go === true && u.total === 30 && u.actionable === 13, JSON.stringify(u));
u = jr.unvOf('\n↻ 반복 3회차 없음(반복 끝): continue = 0 · 미검증 22건 · 처리 대상 0건\n');
chk('반복 끝 줄 → 마지막 건수', u && u.round === 3 && u.go === false && u.total === 22 && u.actionable === 0, JSON.stringify(u));
chk('건수 없는 줄 = 없음', jr.unvOf('\n↻ 반복 2회차 없음(반복 끝): 직전 회차가 분류 결과를 갱신하지 않음\n') === null && jr.unvOf('[OK] 판정 끝') === null);
const html = require(path.join(dir, 'jobs')).html({ language: 'ko' });
chk('VMW 카드 건수 줄 함수', /function unvLine\(u\)/.test(html) && html.includes('+unvLine(s.unv)'));
const wb = require('fs').readFileSync(path.join(dir, 'workbench.js'), 'utf8');
chk('workbench 회차 줄 건수 = fresh 분류 결과일 때만(진행 여부 무관)', /const ucntLog = fresh && jo && jo\.after/.test(wb) && wb.includes("${ucntLog ? ` · ${ucntLog}` : ''}"));
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
