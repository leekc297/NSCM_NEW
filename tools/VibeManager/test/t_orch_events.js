// orch-events.js: 사건 기록 · 구독 · 끝 읽기 · 화면이 달라도 같은 서명
//   사용: node test/t_orch_events.js <VibeManager 폴더>   (2026-11-19 자가진단 Q4: 판정과 종료코드 추가. 종전에는 출력만 했다)
const os = require('os'), path = require('path'), fs = require('fs');
const ev = require(path.join(path.resolve(process.argv[2] || path.join(__dirname, '..')), 'orch-events'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const d = fs.mkdtempSync(path.join(os.tmpdir(), 'orch-')); ev.init(d); let got = 0; ev.on(() => got++);
const why = '[FAIL] files.csv current 변형 없음 — C:\\Projects\\NSCM\\Doc\\x 12건 2026-11-19 13:48';
ev.emit('proc.end', { exit: 6, sig: ev.signature('S8.verify SCP0111', why) });
ev.emit('x', { a: 1 });
const lines = fs.readFileSync(ev.file(), 'utf8').trim().split(String.fromCharCode(10)).map(l => JSON.parse(l));
chk('파일에 2줄 · 공통 필드', lines.length === 2 && lines[0].type === 'proc.end' && lines[0].src === 'vm' && lines[0].pid === process.pid && typeof lines[0].ms === 'number' && /^\d{4}-\d\d-\d\dT/.test(lines[0].at), JSON.stringify(lines[0]));
chk('끝 읽기 2건 · 구독 2회', ev.tail().length === 2 && got === 2, `${ev.tail().length} ${got}`);
const a = ev.signature('S8.verify SCP0111', '[FAIL] a SCP0111 3건'), b = ev.signature('S8.verify SSP0014', '[FAIL] a SSP0014 17건');
chk('화면 · 숫자가 달라도 같은 서명', a === b, a);
chk('서명에 경로 · 시각 없음', !/C:\\|13:48/.test(lines[0].sig) && /<path>/.test(lines[0].sig), lines[0].sig);
// 2026-11-20 개선안 20261120094530_REVIEW_2: 머리 줄 · 명령 줄 건너뛰기
const t1 = ev.signature('S8.checklistRun SSP0005', '[FAIL] Playwright exit code 1 - log tail:\n[FAIL] X'), t1x = ev.signature('S8.checklistRun SSP0005', '[FAIL] X');
chk('log tail 머리 줄 건너뜀 → 다음 원인 줄 기준', t1 === t1x && !/log tail/.test(t1), t1);
const t2 = ev.signature('S8.verify SCP0005', '$ a.py\n== 제목'), t2x = ev.signature('S8.verify SCP0005', '== 제목');
chk('$ 명령 줄 건너뜀 → == 제목 기준', t2 === t2x && !/a\.py/.test(t2), t2);
const t3 = ev.signature('S8.verify SCP0005', 'log tail:'), t3x = ev.signature('S8.verify SCP0005', '[FAIL] 한 줄 3건');
chk('한 줄짜리는 종전과 같음', t3 === 'S8.verify <ID> | log tail:' && t3x === 'S8.verify <ID> | [FAIL] 한 줄 N건', `${t3} / ${t3x}`);
fs.rmSync(d, { recursive: true });
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
