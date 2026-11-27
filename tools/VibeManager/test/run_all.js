// VM 시험 전체 실행기 — test/t_*.js 를 하나씩 돌려 파일별 결과를 모은다(자가진단 S2 · 개선안 반영 게이트가 쓴다)
//   사용: node test/run_all.js [VibeManager 폴더] [--json] [--only t_orch_watch,t_orch_errlog]
//   실제 Claude 를 부르는 시험(t_orch_agent_real · t_orch_agent_diag)은 돌리지 않는다.
//   판정: 종료코드 0 이고 'FAIL ' 로 시작하는 줄 · 'SOME FAIL' · 'LOAD_FAIL' 이 없으면 통과. 마지막 줄 = RESULT <JSON>
const cp = require('child_process'); const fs = require('fs'); const path = require('path');
const args = process.argv.slice(2); const dir = path.resolve(args.find(a => !a.startsWith('--')) || path.join(__dirname, '..'));
const only = (() => { const i = args.indexOf('--only'); return i >= 0 && args[i + 1] ? args[i + 1].split(',') : null; })();
const SKIP = ['t_orch_agent_real.js', 't_orch_agent_diag.js']; const TIMEOUT = 300000;
const files = fs.readdirSync(path.join(dir, 'test')).filter(f => /^t_.*\.js$/.test(f) && !SKIP.includes(f) && (!only || only.includes(f.replace(/\.js$/, '')))).sort();
const out = { dir, at: new Date().toISOString(), files: [], pass: 0, fail: 0, skipped: SKIP, rerun: [], removed: [] };
const t00 = Date.now();
// 2026-11-26 개선안 20261126180319_VISION: 여러 세션이 같은 VM 폴더를 고치는 동안 전체 실행을 돌리면, 시험이 도는 사이 소스가 바뀌어 실패하는 일이 있음
//   (11-26 17:37 t_run_end.js · orch-agent.js 같은 분 수정, 17:45 t_om_job.js·t_lk_job.js 단독 통과). 실패한 시험 중 그 시험이 도는 동안 VM 폴더 *.js, *.json, test/*.js 가 바뀐 것만 단독 1번 다시 돌린다.
//   다시 돌려 통과하면 통과로 두고 rerun 목록에 바뀐 파일을 남긴다. 바뀐 파일이 없거나 다시 돌려도 실패하면 종전대로 실패
const runOne = f => {
  const t0 = Date.now(); const r = cp.spawnSync(process.execPath, [path.join(dir, 'test', f), dir], { encoding: 'utf8', timeout: TIMEOUT, windowsHide: true, maxBuffer: 32 * 1024 * 1024 });
  const text = `${r.stdout || ''}\n${r.stderr || ''}`; const lines = text.split(/\r?\n/).filter(l => l.trim());
  const pass = lines.filter(l => /^PASS /.test(l)).length; const failLines = lines.filter(l => /^FAIL |^LOAD_FAIL|^SOME FAIL|^ERROR /.test(l));
  const code = r.status == null ? (r.error ? `오류 ${r.error.code || r.error.message}` : `신호 ${r.signal}`) : r.status;
  return { t0, rec: { file: f, ok: code === 0 && !failLines.length, code, pass, fail: failLines.filter(l => /^FAIL /.test(l)).length, failLines: failLines.slice(0, 5).map(l => l.slice(0, 200)), last: (lines[lines.length - 1] || '').slice(0, 160), ms: Date.now() - t0 } };
};
const changedSince = ms => { const res = []; for (const [sub, re] of [['', /\.(js|json)$/], ['test', /\.js$/]]) { let names = []; try { names = fs.readdirSync(path.join(dir, sub)); } catch { continue; } for (const n of names) { if (!re.test(n)) continue; try { const st = fs.statSync(path.join(dir, sub, n)); if (st.isFile() && st.mtimeMs >= ms) res.push(sub ? `${sub}/${n}` : n); } catch { } } } return res; };
for (const f of files) {
  let { t0, rec } = runOne(f);
  // 2026-11-26 개선안 20261126190701_SELF: 실행 도중 지워진 시험(다른 세션이 만들다 지운 파일)은 실패로 세지 않고 removed 로 따로 적음(19:00 t_session_continue.js 실측)
  if (!rec.ok && !fs.existsSync(path.join(dir, 'test', f))) { rec.ok = true; rec.removed = '실행 중 삭제'; rec.fail = 0; out.removed.push(f); out.files.push(rec); if (!args.includes('--json')) console.log(`DEL  ${f}  실행 중 삭제(실패로 세지 않음)`); continue; }
  if (!rec.ok) {
    const changed = changedSince(t0); // 그 시험 시작 뒤 바뀐 파일만(앞 시험이 바꾼 파일은 넣지 않음)
    if (changed.length) {
      const again = runOne(f).rec;
      out.rerun.push({ file: f, changed: changed.slice(0, 10), first: { code: rec.code, fail: rec.fail, failLines: rec.failLines.slice(0, 2) }, ok: again.ok });
      if (again.ok) { again.rerun = `실행 중 소스 변경 뒤 단독 재실행 통과(바뀐 파일 ${changed.slice(0, 5).join(', ')}${changed.length > 5 ? ` 외 ${changed.length - 5}` : ''})`; rec = again; }
    }
  }
  out.files.push(rec);
  out.pass += rec.pass; out.fail += rec.fail;
  if (!args.includes('--json')) console.log(`${rec.ok ? 'OK  ' : 'FAIL'} ${f}  PASS ${rec.pass}${rec.failLines.length ? `  ${rec.failLines[0].slice(0, 120)}` : ''}${rec.rerun ? '  (재실행 통과)' : ''}  ${Math.round(rec.ms / 100) / 10}s`);
}
out.sec = Math.round((Date.now() - t00) / 100) / 10; out.ok = out.files.every(x => x.ok);
if (!args.includes('--json')) console.log(`${out.ok ? 'ALL OK' : 'SOME FAIL'}  파일 ${out.files.filter(x => x.ok).length}/${out.files.length}  PASS ${out.pass}  FAIL ${out.fail}  재실행 ${out.rerun.length}  삭제 ${out.removed.length}  ${out.sec}s`);
console.log('RESULT ' + JSON.stringify(out));
process.exit(out.ok ? 0 : 1);
