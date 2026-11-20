// orch-errlog.js: 오류 기록 · 같은 서명 60초 1건 · 감시기 tick 안 예외가 파일에 남는지 · 웹뷰 보고 코드 구문 확인
//   사용: node test/t_orch_errlog.js <VibeManager 폴더>
const path = require('path'); const fs = require('fs'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'errlog-')); const p = { root, vibeDir: path.join(root, '.vibe') };
fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: {} }));
const errlog = require(path.join(dir, 'orch-errlog')); const st = require(path.join(dir, 'orch-state')); const watch = require(path.join(dir, 'orch-watch'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const lines = () => { try { return fs.readFileSync(errlog.file(), 'utf8').trim().split(String.fromCharCode(10)).filter(Boolean).map(l => JSON.parse(l)); } catch { return []; } };
(async () => {
  chk('init 전 기록 = 파일 없이 객체만', errlog.file() === '' && errlog.note('t', 'a', new Error('x')) !== null);
  errlog.init(p.vibeDir);
  const r1 = errlog.note('modA', 'fnA', new Error('C:\\Projects\\NSCM\\a.js 줄 12 읽기 실패 SCP0111'));
  chk('기록 1건 · 필드', lines().length === 1 && r1.mod === 'modA' && r1.fn === 'fnA' && r1.stack.length > 0 && /<path>/.test(r1.sig) && /<ID>/.test(r1.sig), JSON.stringify(r1 && r1.sig));
  const r2 = errlog.note('modA', 'fnA', new Error('C:\\Projects\\NSCM\\b.js 줄 99 읽기 실패 DMF0042'));
  chk('같은 서명 60초 안 = 기록 안 함', r2 === null && lines().length === 1);
  errlog.note('modA', 'fnB', 'plain text error');
  chk('다른 서명 = 기록', lines().length === 2 && lines()[1].msg === 'plain text error');
  const s = errlog.stats(0); chk('서명별 집계 2종', s.length === 2 && s.every(x => x.count === 1), JSON.stringify(s.map(x => [x.sig, x.count])));
  // 감시기 tick 안 예외 → 파일에 남는다(종전 빈 catch)
  watch.init(p, {}); const sweep = st.sweep; st.sweep = () => { throw new Error('injected sweep failure'); };
  watch.tick(); st.sweep = sweep;
  const t = lines().find(x => x.mod === 'orch-watch' && x.fn === 'tick');
  chk('orch-watch.tick 예외 기록', !!t && /injected sweep failure/.test(t.msg), JSON.stringify(lines().map(x => x.mod + '.' + x.fn)));
  watch.onEvent(null);
  chk('orch-watch.onEvent 예외 기록', lines().some(x => x.mod === 'orch-watch' && x.fn === 'onEvent'));
  // 웹뷰 보고 코드: 구문 · 메시지 형태
  const sn = errlog.webviewSnippet('vscode'); let synOk = true; try { new Function('vscode', 'window', sn); } catch (e) { synOk = false; console.log(e.message); }
  chk('웹뷰 보고 코드 구문', synOk);
  const posted = []; const h = {}; const win = { addEventListener: (k, fn) => { h[k] = fn; } };
  new Function('vscode', 'window', sn)({ postMessage: m => posted.push(m) }, win);
  h.error({ message: 'x is not defined', filename: 'vscode-webview://abc/index.html', lineno: 3, colno: 7, error: { stack: 'ReferenceError: x is not defined\n at a (b:1:1)' } });
  chk('웹뷰 오류 → vmerr 메시지', posted.length === 1 && posted[0].type === 'vmerr' && posted[0].line === 3 && posted[0].src === 'index.html', JSON.stringify(posted[0]));
  const w = errlog.fromWebview('orchestra', posted[0]);
  chk('vmerr → 파일 기록', !!w && w.mod === 'webview:orchestra' && w.line === 3 && lines().some(x => x.mod === 'webview:orchestra'));
  watch.dispose(); st.dispose(); await new Promise(r => setTimeout(r, 100)); try { fs.rmSync(root, { recursive: true, force: true }); } catch { }
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})().catch(e => { console.error('ERROR', e); process.exit(2); });
