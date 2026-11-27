// 파일 쓰기 재시도 시험(2026-11-26): UNKNOWN 등 일시 실패는 다시 쓰고, 다른 오류는 바로 던진다
//   사용: node test/t_fs_retry.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const r = require(path.join(dir, 'fs-retry'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const orig = fs.writeFileSync; const f = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'fsr-')), 'a.txt');
try {
  let n = 0; fs.writeFileSync = (...a) => { if (++n < 3) { const e = new Error('UNKNOWN: unknown error, open'); e.code = 'UNKNOWN'; throw e; } return orig(...a); };
  r.writeFileSyncRetry(f, 'x', 'utf8'); chk('UNKNOWN 2번 뒤 3번째 성공', n === 3 && orig === orig && fs.readFileSync(f, 'utf8') === 'x', `시도 ${n}`);
  n = 0; fs.writeFileSync = () => { n++; const e = new Error('ENOENT'); e.code = 'ENOENT'; throw e; };
  let thrown = ''; try { r.writeFileSyncRetry(f, 'y'); } catch (e) { thrown = e.code; } chk('ENOENT = 다시 시도 안 하고 던짐', thrown === 'ENOENT' && n === 1, `시도 ${n}`);
  n = 0; fs.writeFileSync = () => { n++; const e = new Error('EBUSY'); e.code = 'EBUSY'; throw e; };
  let errObj = null; thrown = ''; try { r.writeFileSyncRetry(f, 'z', 'utf8', 4, 10); } catch (e) { thrown = e.code; errObj = e; } chk('계속 실패 = 정한 횟수만 시도하고 던짐', thrown === 'EBUSY' && n === 4, `시도 ${n}`);
  chk('재시도 끝 실패 = e.retry 에 시도 수와 걸린 시간(개선안 20261126190705_SELF)', errObj && errObj.retry && errObj.retry.tries === 4 && errObj.retry.ms >= 25, JSON.stringify(errObj && errObj.retry));
  { const el = require(path.join(dir, 'orch-errlog')); const rec = el.note('t_fs_retry', 'write', errObj); chk('오류 기록에 retry 필드(서명은 그대로)', rec && rec.retry && rec.retry.tries === 4 && rec.code === 'EBUSY', JSON.stringify(rec && { retry: rec.retry, sig: rec.sig })); }
} finally { fs.writeFileSync = orig; }
{ const origR = fs.renameSync; let n = 0; const t1 = f + '.t'; fs.writeFileSync(t1, 'r');
  try { fs.renameSync = (...a) => { if (++n < 2) { const e = new Error('EPERM'); e.code = 'EPERM'; throw e; } return origR(...a); }; r.renameSyncRetry(t1, f); } finally { fs.renameSync = origR; }
  chk('renameSyncRetry: EPERM 1번 뒤 성공', n === 2 && fs.readFileSync(f, 'utf8') === 'r', `시도 ${n}`); }
for (const m of ['orch-improve.js', 'orch-history.js', 'orch-watch.js', 'orch-ladder.js', 'orch-usercheck.js', 'orch-userrule.js', 'orch-checkerscan.js', 'orch-consult.js', 'orch-worklist.js']) chk(`${m} 가 재시도 쓰기를 씀`, fs.readFileSync(path.join(dir, m), 'utf8').includes("require('./fs-retry').writeFileSyncRetry"));
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
