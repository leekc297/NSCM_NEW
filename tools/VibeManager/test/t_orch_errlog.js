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
  // info: true 기록(중지 뒤 잠금 정리 등) = 파일에는 남고 stats 집계에서 빠진다
  const ri = errlog.note('orch-watch', 'lockStopClean', '중지 뒤 잠금 정리: Doc/e2e/x.lock', { kind: 'lock.stopclean', info: true });
  const si = errlog.stats(0);
  chk('info 기록 = 파일 기록 · stats 제외', !!ri && lines().length === 3 && lines()[2].info === true && si.length === 2 && !si.some(x => x.fn === 'lockStopClean'), JSON.stringify(si.map(x => x.sig)));
  // 개선안 20261120181921_SELF_3: AI 편집만 되돌린 정상 처리(orch-improve.restore, info) = stats 제외 · 실패 있는 되돌림 = 집계
  const rr = errlog.note('orch-improve', 'restore', '20261120115806_VISION_3 probe.ts AI 편집 2건만 되돌림(반영 전과 같음)', { info: true });
  const sr = errlog.stats(0);
  chk('되돌림 정상 처리 info = stats 제외', !!rr && lines().length === 4 && lines()[3].info === true && sr.length === 2 && !sr.some(x => x.fn === 'restore'), JSON.stringify(sr.map(x => x.sig)));
  errlog.note('orch-improve', 'restore', '20261120143327_SELF orch-usercheck.js 되돌리기 실패: 사본 없음');
  const sf = errlog.stats(0);
  chk('되돌림 실패 = stats 집계', lines().length === 5 && sf.length === 3 && sf.some(x => x.fn === 'restore'), JSON.stringify(sf.map(x => x.sig)));
  // 개선안 20261121225944_SELF: info 필드 생기기 전 기록(info 없음)도 정상 처리면 stats 제외 · 실패 조각 섞이면 집계
  errlog.note('orch-watch', 'lockStopClean', '중지 뒤 잠금 정리: Doc/e2e/_run.admit.lock (PID 39556 없음 · 화면 SCP0028)');
  const sl = errlog.stats(0);
  chk('info 없는 lockStopClean = stats 제외', lines().length === 6 && lines()[5].info === undefined && sl.length === 3 && !sl.some(x => x.fn === 'lockStopClean'), JSON.stringify(sl.map(x => x.sig)));
  errlog.note('orch-improve2', 'restore', '20261120162317_SELF orch-usercheck.js AI 편집 1건만 되돌림(반영 전과 같음) / user_checks.json AI 편집 1건만 되돌림(반영 전과 같음)');
  const so = errlog.stats(0);
  chk('info 없는 정상 restore = stats 제외', lines().length === 7 && lines()[6].info === undefined && so.length === 3 && !so.some(x => x.mod === 'orch-improve2'), JSON.stringify(so.map(x => x.sig)));
  errlog.note('orch-improve3', 'restore', '20261120181921_SELF orch-history.js AI 편집 1건만 되돌림(반영 전과 같음) / t_orch_history.js 되돌림 실패: 사본 없음');
  const sm = errlog.stats(0);
  chk('실패 조각 섞인 restore = stats 집계', lines().length === 8 && sm.length === 4 && sm.some(x => x.mod === 'orch-improve3'), JSON.stringify(sm.map(x => x.sig)));
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
