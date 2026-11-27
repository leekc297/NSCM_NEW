// VMO Events 탭 사건 시각(2026-11-20): 조치 없는 새 사건도 발생 시각(at)으로 7일 보기에 남음 · 웹뷰 전달 항목에 ms · lastMs 있음
//   사용: node test/t_orch_inc_time.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const orch = fs.readFileSync(path.join(dir, 'orchestra.js'), 'utf8').split(/\r?\n/);
const line = re => orch.find(l => re.test(l)) || '';
const fTs = line(/^\s*function tsOf\(/); const fLast = line(/^\s*function incLast\(/);
chk('orchestra.js 에 function tsOf 줄 있음', !!fTs); chk('orchestra.js 에 function incLast 줄 있음', !!fLast);
let incLast = null; try { incLast = new Function(fTs + '\n' + fLast + '\nreturn incLast;')(); } catch (e) { chk('tsOf · incLast 실행', false, e.message); }
if (incLast) {
  const v = incLast({ at: '2026-11-20T10:55:54+09:00', actions: [] });
  chk('조치 없는 사건 incLast = 발생 시각(>= 1795139754000)', v >= 1795139754000, String(v));
  chk('ms 만 있는 사건 = ms', incLast({ ms: 1795139754664, actions: [] }) === 1795139754664);
  chk('조치 시각이 더 늦으면 조치 시각', incLast({ ms: 1795139754664, actions: [{ at: '2026-11-20T11:30:00+09:00' }] }) === Date.parse('2026-11-20T11:30:00+09:00'));
}
const wb = fs.readFileSync(path.join(dir, 'workbench.js'), 'utf8').split(/\r?\n/).find(l => /wb\.postIncidents\s*=/.test(l)) || '';
chk('workbench.js postIncidents 줄 있음', !!wb);
chk("postIncidents 항목에 'ms:' 있음", /[\s{,]ms:/.test(wb)); chk("postIncidents 항목에 'lastMs:' 있음", /lastMs:/.test(wb));
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
