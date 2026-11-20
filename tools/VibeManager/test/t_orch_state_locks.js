// orch-state.js locks(): 잠금 파일 at 형식(글자 · 초 · 밀리초 · 깨진 값)마다 started 를 예외 없이 만드는지 확인(개선안 20261120143326_SELF)
//   사용: node test/t_orch_state_locks.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'stlock-')); const p = { root, vibeDir: path.join(root, '.vibe') };
fs.mkdirSync(path.join(p.vibeDir, 'orch'), { recursive: true });
const d = path.join(root, 'Doc', 'e2e'); fs.mkdirSync(d, { recursive: true });
const sec = 1795000000, ms = 1795000000123; // 2026-11-18T11:06:40Z 초 · 밀리초
const w = (n, o) => fs.writeFileSync(path.join(d, n), JSON.stringify(o));
w('_server_8081.lock', { pid: 999991, at: '2026-11-20 13:55:00' }); // server_guard.py:92 형식
w('_run.sec.lock', { pid: 999992, at: sec });
w('_run.ms.lock', { pid: 999993, at: ms }); // langlock.ts:22 · langacct.ts:42 형식
w('_run.bad.lock', { pid: 999994, at: 'not-a-date' });
const st = require(path.join(dir, 'orch-state'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
let snap = null;
try { st.init(p); snap = st.snapshot(); } catch (e) { chk('snapshot 예외 없음', false, e && e.stack); }
const by = f => ((snap && snap.locks) || []).find(x => x.file === f) || {};
if (snap) {
  chk('at 글자 = 그대로', by('_server_8081.lock').started === '2026-11-20 13:55:00', by('_server_8081.lock').started);
  chk('at 초 = ISO 날짜', by('_run.sec.lock').started === new Date(sec * 1000).toISOString(), by('_run.sec.lock').started);
  chk('at 밀리초 = ISO 날짜', by('_run.ms.lock').started === new Date(ms).toISOString(), by('_run.ms.lock').started);
  chk('at 깨진 값 = 빈 값', by('_run.bad.lock').started === '', JSON.stringify(by('_run.bad.lock').started));
}
st.dispose(); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
