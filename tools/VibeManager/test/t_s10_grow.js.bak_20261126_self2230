// 자가진단 S10 로그 증가 속도(2026-11-26): S10 이 하루 1회라 21:01 결과 32GB, 21:27 실제 50.9GB. 가벼운 주기에 넣고 시간당 증가량이 selfLogGrowGBh 넘으면 주의
//   임시 폴더에서만 파일을 만든다. 사용: node test/t_s10_grow.js <VibeManager 폴더>
const Module = require('module'); const path = require('path'); const fs = require('fs'); const os = require('os');
const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? new Proxy({}, { get: () => function () { } }) : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 's10g-')); const vibeDir = path.join(root, '.vibe');
const BE = ['nscm', 'be'].join('-');
const W = (rel, n) => { const f = path.join(root, rel); fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f, 'x'.repeat(n)); return f; };
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { selfLogBigGB: 100, selfLogGrowGBh: 0.0001 } }));
W('.vibe/logs/be.log', 1000); W(`${BE}/logs/nscm.log`, 1000); W('.vibe/logs/still.log', 1000);
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const sc = require(path.join(dir, 'orch-selfcheck')); sc.init({ paths: () => ({ root, vibeDir }), vmDir: dir, timer: false, incidents: false });
chk('S10 = 가벼운 주기 항목', sc.LIGHT.includes('S10'));
chk('기본 selfLogGrowGBh 2', sc.DEF.selfLogGrowGBh === 2);
(async () => {
  let r = await sc.run(['S10'], '시험'); let it = (r.checks.S10 || {}).items || [];
  chk('첫 점검 = 비교 대상 없음, 증가 항목 없음', !it.some(i => /증가/.test(i.what)), JSON.stringify(it.map(i => i.what)));
  // 10분 전 크기로 되돌려 놓고 파일을 키움(증가 속도 계산)
  const P = sc._s10Prev; for (const k of Object.keys(P)) P[k].ms -= 10 * 60000;
  W('.vibe/logs/be.log', 2000000); W(`${BE}/logs/nscm.log`, 2000000);
  r = await sc.run(['S10'], '시험'); it = (r.checks.S10 || {}).items || [];
  const g = it.filter(i => /증가/.test(i.what));
  chk('커진 로그 2개 = 증가 주의', g.length === 2 && g.every(i => i.level === 'warn' && /^S10\|grow\|/.test(i.key)), JSON.stringify(g.map(i => i.key)));
  chk('그대로인 로그는 항목 아님', !g.some(i => /still\.log/.test(i.what)));
  // 5분 안 다시 재면 판정 안 함
  W('.vibe/logs/be.log', 4000000); r = await sc.run(['S10'], '시험'); it = (r.checks.S10 || {}).items || [];
  chk('5분 안 재측정 = 증가 판정 안 함', !it.some(i => /be\.log.*증가/.test(i.what)));
  try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.log('FAIL 예외', e.stack); process.exit(1); });
