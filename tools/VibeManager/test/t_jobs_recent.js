// jobs.js 최근 선택 저장(2026-11-20): 시작할 때마다 업무와 화면 목록을 .vibe/jobs/recent_sel.json 에 최근 10개 · 같은 조합은 맨 앞으로
//   사용: node test/t_jobs_recent.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (req, ...rest) { return req === 'vscode' ? stub : orig.call(this, req, ...rest); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'jobsrec-')); const p = { root, vibeDir: path.join(root, '.vibe') };
const jobs = require(path.join(dir, 'jobs'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
chk('처음 = 빈 목록', jobs.recentSel(p).length === 0);
jobs.addRecentSel(p, 'A', ['SCP0001', 'SCP0002']); jobs.addRecentSel(p, 'B', ['SSP0001']); jobs.addRecentSel(p, 'A', ['SCP0001', 'SCP0002']);
const r = jobs.recentSel(p);
chk('같은 조합은 맨 앞으로 · 중복 없음', r.length === 2 && r[0].itemLabel === 'A' && r[1].itemLabel === 'B' && r[0].screens.join() === 'SCP0001,SCP0002', JSON.stringify(r));
for (let i = 0; i < 12; i++) jobs.addRecentSel(p, 'X' + i, ['DMF00' + String(i).padStart(2, '0')]);
chk('최근 10개만 보관', jobs.recentSel(p).length === 10 && jobs.recentSel(p)[0].itemLabel === 'X11');
const html = jobs.html({ language: 'ko' });
chk('기본 실행 방식 = 부하가 허용하면 동시 · 최대 3(2026-11-20 사용자 지시 5 → 3)', /value="par" checked/.test(html) && /id="mp" value="3"/.test(html) && /id="rsel"/.test(html));
try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
