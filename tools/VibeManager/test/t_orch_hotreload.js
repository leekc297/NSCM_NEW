// 개선안 20261122130655_REVIEW_2 시험: 반영한 VM 코드 적용 시점
//   1) 분석 모듈(HOT_MODULES) 내용 변경 → hotReload 뒤 먼저 불러 둔 참조와 새 require 모두 새 함수 결과
//   2) 실행을 쥔 파일(workbench.js 등) = 다시 읽지 않고 창 로드 대상 · 문법 오류 분석 모듈 = 기존 모듈 유지, 창 로드 대상
//   3) 창 로드 알림 게이트: 실행 중 체인 1개 = 알림 0회(요청 2번) → 0개가 된 뒤 1회 · 그 뒤 체인 끝 이벤트가 더 와도 1회
//   4) orch.hotReload false = 종전 동작(다시 읽지 않고 .js 전부 창 로드 대상, 알림 없음)
'use strict';
const fs = require('fs'); const path = require('path'); const os = require('os');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let pass = 0, fail = 0; const ok = (c, m) => { if (c) { pass++; console.log(`PASS ${m}`); } else { fail++; console.log(`FAIL ${m}`); } };
const sc = require(path.join(dir, 'orch-selfcheck.js'));
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'vm_hot_'));
try {
  // 1) 분석 모듈 다시 읽기
  const name = sc.HOT_MODULES[0]; const f = path.join(tmp, name);
  fs.writeFileSync(f, "'use strict';\nmodule.exports = { val: () => 1 };\n", 'utf8');
  const held = require(f); ok(held.val() === 1, `처음 읽음 ${name} val()=1`);
  fs.writeFileSync(f, "'use strict';\nmodule.exports = { val: () => 2, extra: () => 'x' };\n", 'utf8');
  ok(require(f).val() === 1, '다시 읽기 전 require 결과는 종전 함수(캐시)');
  const r1 = sc.hotReload([name, 'workbench.js', 'README.md'], { dir: tmp });
  ok(r1.hot.length === 1 && r1.hot[0] === name, `다시 읽음 목록 = ${name} (${JSON.stringify(r1.hot)})`);
  ok(held.val() === 2 && held.extra() === 'x', '먼저 불러 둔 참조가 새 함수 결과 반환 val()=2');
  ok(require(f).val() === 2 && require(f) === held, '새 require 도 같은 exports 객체, val()=2');
  ok(r1.reload.length === 1 && r1.reload[0] === 'workbench.js', `실행을 쥔 파일은 창 로드 대상 (${JSON.stringify(r1.reload)})`);
  ok(!r1.reload.includes('README.md') && !r1.hot.includes('README.md'), '.js 아닌 파일은 대상 아님');
  ok(sc.hotLoaded()[name] > 0, 'hotLoaded 에 다시 읽은 시각 기록');
  // 2) 문법 오류 = 기존 유지
  fs.writeFileSync(f, "module.exports = { val: () => 3 ", 'utf8');
  const r2 = sc.hotReload([name], { dir: tmp });
  ok(r2.hot.length === 0 && r2.reload.includes(name) && r2.fail.length === 1, '문법 오류 = 다시 읽기 실패, 창 로드 대상');
  ok(held.val() === 2 && require(f).val() === 2, '문법 오류 뒤에도 기존 함수 유지 val()=2');
  // 3) 창 로드 알림 게이트
  let busy = true; let subs = []; const notes = [];
  const g = sc.makeReloadGate({ busy: () => busy, subscribe: fn => { subs.push(fn); return () => { subs = subs.filter(x => x !== fn); }; }, notify: (t, files) => notes.push(files) });
  g.request(['workbench.js']); g.request(['chain-runner.js']);
  ok(notes.length === 0 && g.notified() === 0, `실행 중 체인 1개 표본: 알림 ${notes.length}회`);
  ok(subs.length === 1, `체인 끝 구독 1개 (${subs.length})`);
  subs.slice().forEach(fn => fn()); ok(notes.length === 0, '체인이 아직 남은 동안 끝 이벤트가 와도 알림 0회');
  busy = false; subs.slice().forEach(fn => fn());
  ok(notes.length === 1 && g.notified() === 1, `체인 0개가 된 뒤 알림 ${notes.length}회`);
  ok(notes[0] && notes[0].length === 2 && notes[0].includes('workbench.js') && notes[0].includes('chain-runner.js'), `알림 1회에 대기 파일 2개 묶음 (${JSON.stringify(notes[0])})`);
  ok(subs.length === 0, '알림 뒤 구독 해제');
  subs.slice().forEach(fn => fn()); ok(notes.length === 1, '그 뒤 이벤트에 알림 추가 없음');
  const g2 = sc.makeReloadGate({ busy: () => false, subscribe: () => () => { }, notify: (t, files) => notes.push(files) });
  g2.request(['job-runner.js']); ok(g2.notified() === 1 && notes.length === 2, '체인 0개일 때 요청 = 바로 알림 1회');
  // 3-2) 개선안 20261126162524_SELF: init 인자가 상태인 점검 모듈(HOT_REINIT) = 다시 읽은 뒤 같은 인자로 다시 init · 작업 중이면 다시 읽지 않음 · codeInfo staleFiles 에서 빠짐
  { const d5 = path.join(tmp, 'reinit'); fs.mkdirSync(d5, { recursive: true });
    ok(sc.HOT_REINIT.includes('orch-usercheck.js') && sc.HOT_REINIT.includes('orch-worklist.js'), `HOT_REINIT = ${JSON.stringify(sc.HOT_REINIT)}`);
    const uf = path.join(d5, 'orch-usercheck.js'); const mk = v => `'use strict';\nlet getPaths = null, opts = {};\nfunction init(o) { getPaths = o.paths; opts = o || {}; }\nmodule.exports = { _initOpts: () => (getPaths ? opts : null), busy: () => !!global.__ucBusy, ready: () => !!getPaths, init, val: () => getPaths().root + ':${v}', extra: () => opts.extra };\n`;
    fs.writeFileSync(uf, mk(1), 'utf8'); const uc = require(uf); uc.init({ paths: () => ({ root: 'R' }), extra: 7 });
    ok(uc.val() === 'R:1', `처음 읽음 val()=${uc.val()}`);
    fs.writeFileSync(uf, mk(2), 'utf8'); const r5 = sc.hotReload(['orch-usercheck.js'], { dir: d5 });
    ok(r5.hot.includes('orch-usercheck.js') && !r5.reload.length && !r5.fail.length, `다시 읽음 (${JSON.stringify(r5)})`);
    ok(uc.ready() === true && uc.val() === 'R:2' && uc.extra() === 7, `다시 init: 같은 인자(paths, extra) 유지 · 새 함수 val()=${uc.val()} extra=${uc.extra()}`);
    global.__ucBusy = true; fs.writeFileSync(uf, mk(3), 'utf8'); const r6 = sc.hotReload(['orch-usercheck.js'], { dir: d5 });
    ok(!r6.hot.length && r6.reload.includes('orch-usercheck.js') && uc.val() === 'R:2', `작업 중(busy) = 다시 읽지 않고 창 로드 대상 · 종전 함수 유지 (${JSON.stringify(r6)})`);
    global.__ucBusy = false; const r7 = sc.hotReload(['orch-usercheck.js'], { dir: d5 });
    ok(r7.hot.length === 1 && uc.val() === 'R:3', `작업이 끝난 뒤 다시 읽음 val()=${uc.val()}`);
    const wf = path.join(d5, 'orch-worklist.js'); const mw = v => `'use strict';\nlet getPaths = null;\nfunction init(o) { getPaths = o.paths; }\nmodule.exports = { ready: () => !!getPaths, init, val: () => (getPaths ? getPaths().root : 'none') + ':${v}' };\n`;
    fs.writeFileSync(wf, mw(1), 'utf8'); const wl = require(wf); wl.init({ paths: () => ({ root: 'W' }) });
    fs.writeFileSync(wf, mw(2), 'utf8'); const r8 = sc.hotReload(['orch-worklist.js'], { dir: d5, paths: () => ({ root: 'W2' }) });
    ok(r8.hot.length === 1 && wl.ready() && wl.val() === 'W2:2', `_initOpts 없는 옛 모듈 = ready 면 { paths } 로 다시 init (val()=${wl.val()})`);
    const nf = path.join(d5, 'sub'); fs.mkdirSync(nf, { recursive: true }); const nwf = path.join(nf, 'orch-worklist.js'); fs.writeFileSync(nwf, mw(1), 'utf8'); const nw = require(nwf);
    fs.writeFileSync(nwf, mw(2), 'utf8'); sc.hotReload(['orch-worklist.js'], { dir: nf, paths: () => ({ root: 'X' }) });
    ok(nw.ready() === false && nw.val() === 'none:2', `init 전 모듈 = 다시 읽기만, init 안 함 (val()=${nw.val()})`);
    // codeInfo: 설치본 수정 뒤 다시 읽은 모듈은 staleFiles 에서 빠짐
    const r5root = path.join(tmp, 'r5'); const vib = path.join(r5root, '.vibe'); fs.mkdirSync(path.join(vib, 'orch'), { recursive: true }); fs.mkdirSync(path.join(r5root, 'tools', 'Harness'), { recursive: true }); fs.writeFileSync(path.join(r5root, 'tools', 'Harness', 'harness.json'), '{}');
    const ext5 = path.join(tmp, 'ext5'); fs.mkdirSync(ext5, { recursive: true }); const loadMs = Date.now() - 60000;
    fs.writeFileSync(path.join(vib, 'orch', 'activations.jsonl'), JSON.stringify({ ms: loadMs, pid: process.pid, extDir: ext5 }) + '\n');
    fs.writeFileSync(path.join(ext5, 'orch-usercheck.js'), mk(4), 'utf8'); fs.writeFileSync(path.join(ext5, 'workbench.js'), '// x\n', 'utf8');
    const agent = require(path.join(dir, 'orch-agent')); agent.init({ paths: () => ({ root: r5root, vibeDir: vib, extDir: ext5 }), serverSvc: null, loadQuick: () => [] });
    const im = require(path.join(dir, 'orch-improve')); const st0 = im.codeInfo().staleFiles.map(x => x.file).sort();
    const ucx = require(path.join(ext5, 'orch-usercheck.js')); ucx.init({ paths: () => ({ root: 'E' }) }); fs.writeFileSync(path.join(ext5, 'orch-usercheck.js'), mk(5), 'utf8');
    { const past = new Date(Date.now() - 1000); fs.utimesSync(path.join(ext5, 'orch-usercheck.js'), past, past); } // 2026-11-26: 수정 시각을 다시 읽기 전으로 고정(전체 실행 부하에서 mtime 이 다시 읽은 시각보다 늦게 찍혀 19:15 1회 실패, 단독 통과)
    sc.hotReload(['orch-usercheck.js'], { dir: ext5 }); const st1 = im.codeInfo().staleFiles.map(x => x.file).sort();
    ok(JSON.stringify(st0) === '["orch-usercheck.js","workbench.js"]' && JSON.stringify(st1) === '["workbench.js"]', `codeInfo staleFiles 다시 읽기 전 ${JSON.stringify(st0)} → 뒤 ${JSON.stringify(st1)}`);
    try { agent.dispose(); } catch { } }
  // 4) orch.hotReload false = 종전 동작
  const root = path.join(tmp, 'root'); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.mkdirSync(path.join(root, '.vibe'), { recursive: true });
  fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { hotReload: false } }), 'utf8');
  const vmd = path.join(tmp, 'vm'); fs.mkdirSync(vmd, { recursive: true });
  const offNotes = [];
  sc.init({ paths: () => ({ root, vibeDir: path.join(root, '.vibe'), extDir: tmp }), vmDir: vmd, extDir: tmp, timer: false, notify: t => offNotes.push(t), notifyReload: t => offNotes.push(t) });
  const r4 = sc.applySynced([name, 'workbench.js', 'README.md']);
  ok(r4.off === true && r4.hot.length === 0 && r4.reload.length === 2, `hotReload false = 다시 읽지 않음, 창 로드 대상 .js 2개 (${JSON.stringify(r4)})`);
  ok(offNotes.length === 0, 'hotReload false = 알림 없음');
  // 5) S-Z 10차: 설치 폴더에 직접 복사한 분석 모듈 = 정기 점검 때 다시 읽음(staleHot)
  {
    const d6 = fs.mkdtempSync(path.join(tmp, 'stale_')); const n1 = sc.HOT_MODULES[1]; const n2 = sc.HOT_MODULES[2];
    const f1 = path.join(d6, n1); fs.writeFileSync(f1, "'use strict';\nmodule.exports = { v: () => 1 };\n", 'utf8'); const h1 = require(f1);
    fs.writeFileSync(path.join(d6, n2), "'use strict';\nmodule.exports = { v: () => 1 };\n", 'utf8');
    const old = Date.now() - 60000; fs.utimesSync(f1, old / 1000, old / 1000);
    ok(sc.staleHot({ dir: d6, since: Date.now() - 1000 }).length === 0, '불러 둔 뒤 파일 안 바뀜 = 대상 0');
    fs.writeFileSync(f1, "'use strict';\nmodule.exports = { v: () => 2 };\n", 'utf8'); const fut = Date.now() + 5000; fs.utimesSync(f1, fut / 1000, fut / 1000);
    const st = sc.staleHot({ dir: d6, since: Date.now() - 1000 });
    ok(st.length === 1 && st[0] === n1, `바뀐 파일만 대상, 안 불러 둔 ${n2} 제외 (${JSON.stringify(st)})`);
    const r = sc.hotReload(st, { dir: d6 }); ok(r.hot.includes(n1) && h1.v() === 2, `다시 읽은 뒤 먼저 불러 둔 참조도 새 함수 (${h1.v()})`);
    const after = sc.staleHot({ dir: d6, since: Date.now() - 1000 });
    ok(after.length === 1, `수정 시각이 다시 읽은 시각보다 뒤(미래 시각)면 다시 대상 (${JSON.stringify(after)})`);
    fs.utimesSync(f1, old / 1000, old / 1000); ok(sc.staleHot({ dir: d6, since: Date.now() - 1000 }).length === 0, '다시 읽은 뒤 = 대상 0');
  }
  sc.dispose();
} catch (e) { fail++; console.log(`FAIL 예외 ${e && e.stack ? e.stack.split('\n').slice(0, 3).join(' | ') : e}`); }
finally { try { fs.rmSync(tmp, { recursive: true, force: true }); } catch { } }
console.log(fail ? `SOME FAIL PASS ${pass} FAIL ${fail}` : `ALL PASS ${pass}`);
process.exit(fail ? 1 : 0);
