// 전체 시험 실행기 재실행 시험(2026-11-26 개선안 20261126180319_VISION): 시험이 도는 동안 소스가 바뀐 실패만 단독 1번 다시 돌림
//   사용: node test/t_run_all_changed.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os'); const cp = require('child_process');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const vm = fs.mkdtempSync(path.join(os.tmpdir(), 'rac-')); fs.mkdirSync(path.join(vm, 'test'));
fs.copyFileSync(path.join(dir, 'test', 'run_all.js'), path.join(vm, 'test', 'run_all.js'));
fs.writeFileSync(path.join(vm, 'lib.js'), 'module.exports = 1;\n');
// t_a: 첫 실행은 lib.js 를 고치고 실패(다른 세션이 고친 상황), 두 번째는 통과
fs.writeFileSync(path.join(vm, 'test', 't_a.js'), [
  "const fs = require('fs'); const path = require('path'); const d = process.argv[2]; const flag = path.join(d, 'a.flag');",
  "if (!fs.existsSync(flag)) { fs.writeFileSync(flag, '1'); fs.writeFileSync(path.join(d, 'lib.js'), 'module.exports = 2;\\n'); console.log('FAIL 첫 실행'); process.exit(1); }",
  "console.log('PASS 둘째 실행'); console.log('ALL PASS');", ''].join('\n'));
// t_b: 소스 변경 없이 실패
fs.writeFileSync(path.join(vm, 'test', 't_b.js'), "console.log('FAIL 늘 실패'); process.exit(1);\n");
// t_c: 통과
fs.writeFileSync(path.join(vm, 'test', 't_c.js'), "console.log('PASS 통과'); console.log('ALL PASS');\n");
{ const past = new Date(Date.now() - 600000); for (const f of ['lib.js', 'test/run_all.js', 'test/t_a.js', 'test/t_b.js', 'test/t_c.js']) fs.utimesSync(path.join(vm, f), past, past); } // 준비 파일은 실행 전에 있던 소스로 둠
const r = cp.spawnSync(process.execPath, [path.join(vm, 'test', 'run_all.js'), vm], { encoding: 'utf8' });
const ln = String(r.stdout).split(/\r?\n/).find(l => l.startsWith('RESULT ')); const j = ln ? JSON.parse(ln.slice(7)) : null;
chk('RESULT 있음', !!j, String(r.stdout).slice(-300));
if (j) {
  const a = j.files.find(x => x.file === 't_a.js'); const b = j.files.find(x => x.file === 't_b.js');
  chk('실행 중 소스가 바뀐 실패 = 단독 재실행 통과', a && a.ok === true && /재실행 통과/.test(a.rerun || '') && /lib\.js/.test(a.rerun || ''), JSON.stringify(a));
  chk('소스 변경 없는 실패 = 재실행 안 하고 실패', b && b.ok === false && !j.rerun.some(x => x.file === 't_b.js'), JSON.stringify(j.rerun));
  chk('rerun 목록 1건 · 첫 실패 기록 남음', j.rerun.length === 1 && j.rerun[0].file === 't_a.js' && j.rerun[0].first.fail === 1, JSON.stringify(j.rerun));
  chk('전체 = 실패(t_b) · 마지막 줄에 재실행 1', j.ok === false && /재실행 1/.test(String(r.stdout)));
}
// 개선안 20261126190701_SELF: 실행 도중 지워진 시험 = 실패로 세지 않고 removed
{
  const vm2 = fs.mkdtempSync(path.join(os.tmpdir(), 'rad-')); fs.mkdirSync(path.join(vm2, 'test'));
  fs.copyFileSync(path.join(dir, 'test', 'run_all.js'), path.join(vm2, 'test', 'run_all.js'));
  fs.writeFileSync(path.join(vm2, 'test', 't_d.js'), "require('fs').unlinkSync(__filename); console.log('FAIL 지워짐'); process.exit(1);\n"); // 자기 자신을 지우고 실패(다른 세션이 지운 상황)
  fs.writeFileSync(path.join(vm2, 'test', 't_e.js'), "console.log('PASS 통과'); console.log('ALL PASS');\n");
  const r2 = cp.spawnSync(process.execPath, [path.join(vm2, 'test', 'run_all.js'), vm2], { encoding: 'utf8' });
  const ln2 = String(r2.stdout).split(/\r?\n/).find(l => l.startsWith('RESULT ')); const j2 = ln2 ? JSON.parse(ln2.slice(7)) : null;
  const d = j2 && j2.files.find(x => x.file === 't_d.js');
  chk('실행 중 지워진 시험 = 통과로 두고 removed 에 적음', j2 && d && d.ok === true && d.removed === '실행 중 삭제' && j2.removed.includes('t_d.js'), JSON.stringify(d));
  chk('전체 = 통과 · 마지막 줄에 삭제 1', j2 && j2.ok === true && /삭제 1/.test(String(r2.stdout)), String(r2.stdout).split(/\r?\n/).filter(l => /ALL OK|SOME FAIL/.test(l)).join(' '));
}
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
