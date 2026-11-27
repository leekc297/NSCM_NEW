// 파일 쓰기 재시도(2026-11-26): Windows 에서 다른 프로세스(백신, 편집기, 다른 세션)가 파일을 잠깐 잡으면 writeFileSync 가 UNKNOWN, EBUSY, EPERM, EACCES 로 실패한다.
//   실측 vm_errors.jsonl 11-25 16:19 ~ 11-26 16:19: CHANGELOG.md 8건, WORKLOG.md 6건, digest.json 3건, step_stats.json 1건(모두 UNKNOWN open).
//   같은 쓰기를 250ms 간격으로 최대 6번 다시 한다(최대 1.5초 대기, 동기). 다른 오류 코드나 마지막 시도 실패는 그대로 던진다
const fs = require('fs');
const RETRY = new Set(['UNKNOWN', 'EBUSY', 'EPERM', 'EACCES']);
const sleep = ms => { try { Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, ms); } catch { const t = Date.now() + ms; while (Date.now() < t) { /* 대기 */ } } };
// 2026-11-26 개선안 20261126190705_SELF: 재시도 끝 실패는 오류에 e.retry = { tries, ms } 를 붙여 던짐. orch-errlog.note 가 retry 필드로 남김(서명, 건수는 그대로)
const mark = (e, i, t0) => { try { if (e && typeof e === 'object' && RETRY.has(e.code)) e.retry = { tries: i, ms: Date.now() - t0 }; } catch { /* 고정 객체 */ } return e; };
function writeFileSyncRetry(file, data, opts, tries = 6, gapMs = 250) {
  const t0 = Date.now();
  for (let i = 1; ; i++) {
    try { return fs.writeFileSync(file, data, opts); }
    catch (e) { if (i >= tries || !RETRY.has(e && e.code)) throw mark(e, i, t0); sleep(gapMs); }
  }
}
/** 임시 파일 바꾸기도 같은 이유(대상 파일을 다른 프로세스가 잡음)로 EPERM, EBUSY 가 남. 같은 방식으로 다시 시도 */
function renameSyncRetry(from, to, tries = 6, gapMs = 250) {
  const t0 = Date.now();
  for (let i = 1; ; i++) {
    try { return fs.renameSync(from, to); }
    catch (e) { if (i >= tries || !RETRY.has(e && e.code)) throw mark(e, i, t0); sleep(gapMs); }
  }
}
module.exports = { writeFileSyncRetry, renameSyncRetry, RETRY };
