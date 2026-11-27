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
  // 4) orch.hotReload false = 종전 동작
  const root = path.join(tmp, 'root'); fs.mkdirSync(path.join(root, 'tools', 'Harness'), { recursive: true }); fs.mkdirSync(path.join(root, '.vibe'), { recursive: true });
  fs.writeFileSync(path.join(root, 'tools', 'Harness', 'harness.json'), JSON.stringify({ orch: { hotReload: false } }), 'utf8');
  const vmd = path.join(tmp, 'vm'); fs.mkdirSync(vmd, { recursive: true });
  const offNotes = [];
  sc.init({ paths: () => ({ root, vibeDir: path.join(root, '.vibe'), extDir: tmp }), vmDir: vmd, extDir: tmp, timer: false, notify: t => offNotes.push(t), notifyReload: t => offNotes.push(t) });
  const r4 = sc.applySynced([name, 'workbench.js', 'README.md']);
  ok(r4.off === true && r4.hot.length === 0 && r4.reload.length === 2, `hotReload false = 다시 읽지 않음, 창 로드 대상 .js 2개 (${JSON.stringify(r4)})`);
  ok(offNotes.length === 0, 'hotReload false = 알림 없음');
  sc.dispose();
} catch (e) { fail++; console.log(`FAIL 예외 ${e && e.stack ? e.stack.split('\n').slice(0, 3).join(' | ') : e}`); }
finally { try { fs.rmSync(tmp, { recursive: true, force: true }); } catch { } }
console.log(fail ? `SOME FAIL PASS ${pass} FAIL ${fail}` : `ALL PASS ${pass}`);
process.exit(fail ? 1 : 0);
