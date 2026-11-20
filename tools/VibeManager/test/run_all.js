// VM 시험 전체 실행기 — test/t_*.js 를 하나씩 돌려 파일별 결과를 모은다(자가진단 S2 · 개선안 반영 게이트가 쓴다)
//   사용: node test/run_all.js [VibeManager 폴더] [--json] [--only t_orch_watch,t_orch_errlog]
//   실제 Claude 를 부르는 시험(t_orch_agent_real · t_orch_agent_diag)은 돌리지 않는다.
//   판정: 종료코드 0 이고 'FAIL ' 로 시작하는 줄 · 'SOME FAIL' · 'LOAD_FAIL' 이 없으면 통과. 마지막 줄 = RESULT <JSON>
const cp = require('child_process'); const fs = require('fs'); const path = require('path');
const args = process.argv.slice(2); const dir = path.resolve(args.find(a => !a.startsWith('--')) || path.join(__dirname, '..'));
const only = (() => { const i = args.indexOf('--only'); return i >= 0 && args[i + 1] ? args[i + 1].split(',') : null; })();
const SKIP = ['t_orch_agent_real.js', 't_orch_agent_diag.js']; const TIMEOUT = 300000;
const files = fs.readdirSync(path.join(dir, 'test')).filter(f => /^t_.*\.js$/.test(f) && !SKIP.includes(f) && (!only || only.includes(f.replace(/\.js$/, '')))).sort();
const out = { dir, at: new Date().toISOString(), files: [], pass: 0, fail: 0, skipped: SKIP };
const t00 = Date.now();
for (const f of files) {
  const t0 = Date.now(); const r = cp.spawnSync(process.execPath, [path.join(dir, 'test', f), dir], { encoding: 'utf8', timeout: TIMEOUT, windowsHide: true, maxBuffer: 32 * 1024 * 1024 });
  const text = `${r.stdout || ''}\n${r.stderr || ''}`; const lines = text.split(/\r?\n/).filter(l => l.trim());
  const pass = lines.filter(l => /^PASS /.test(l)).length; const failLines = lines.filter(l => /^FAIL |^LOAD_FAIL|^SOME FAIL|^ERROR /.test(l));
  const code = r.status == null ? (r.error ? `오류 ${r.error.code || r.error.message}` : `신호 ${r.signal}`) : r.status;
  const ok = code === 0 && !failLines.length;
  out.files.push({ file: f, ok, code, pass, fail: failLines.filter(l => /^FAIL /.test(l)).length, failLines: failLines.slice(0, 5).map(l => l.slice(0, 200)), last: (lines[lines.length - 1] || '').slice(0, 160), ms: Date.now() - t0 });
  out.pass += pass; out.fail += failLines.filter(l => /^FAIL /.test(l)).length;
  if (!args.includes('--json')) console.log(`${ok ? 'OK  ' : 'FAIL'} ${f}  PASS ${pass}${failLines.length ? `  ${failLines[0].slice(0, 120)}` : ''}  ${Math.round((Date.now() - t0) / 100) / 10}s`);
}
out.sec = Math.round((Date.now() - t00) / 100) / 10; out.ok = out.files.every(x => x.ok);
if (!args.includes('--json')) console.log(`${out.ok ? 'ALL OK' : 'SOME FAIL'}  파일 ${out.files.filter(x => x.ok).length}/${out.files.length}  PASS ${out.pass}  FAIL ${out.fail}  ${out.sec}s`);
console.log('RESULT ' + JSON.stringify(out));
process.exit(out.ok ? 0 : 1);
