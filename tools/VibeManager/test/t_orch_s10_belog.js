// 자가진단 S10 용량에 BE 파일 로그(BE logs 폴더) 추가(2026-11-20 사용자 지시): 기준 selfLogBigGB 넘는 파일 = 주의 항목 · 합계·파일 수·디스크 남은 용량 집계
//   임시 폴더에서만 파일을 만든다(실제 BE 폴더는 건드리지 않음)
//   사용: node test/t_orch_s10_belog.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? new Proxy({}, { get: () => function () { } }) : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 's10-')); const vibeDir = path.join(root, '.vibe');
const BE = ['nscm', 'be'].join('-'); // 임시 폴더 안 BE 로그 폴더 이름
const W = (rel, n) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, 'x'.repeat(n)); return f; };
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { selfLogBigGB: 0.000001 } })); // 약 1KB
W(`${BE}/logs/nscm.log`, 5000); W(`${BE}/logs/nscm.20261119.log`, 3000); W(`${BE}/logs/small.log`, 100); W('.vibe/logs/a.log', 10);
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => ({ root, vibeDir }), vmDir: dir, timer: false, incidents: false });
sc.run(['S10'], '시험').then(r => {
  const k = (r.checks || {}).S10 || {}; const it = k.items || []; const be = it.filter(i => i.what.startsWith(`${BE}/logs/`));
  chk('기준 넘는 BE 로그 2개 = 주의(실패 아님)', be.length === 2 && it.every(i => i.level === 'warn'), JSON.stringify(it.map(i => i.what)));
  chk('작은 BE 로그는 항목 아님', !it.some(i => /small\.log/.test(i.what)));
  chk('큰 파일 먼저', /nscm\.log/.test((be[0] || {}).what || ''));
  chk('집계: BE 로그 파일 3 · 큰 파일 2', k.info && k.info.beLogFiles === 3 && k.info.beBigFiles === 2, JSON.stringify(k.info));
  chk('디스크 남은 용량 값(숫자 또는 측정 불가 null)', k.info && (k.info.diskFreeGB === null || typeof k.info.diskFreeGB === 'number'));
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
}).catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
