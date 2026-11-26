// 2026-11-20 사용자 지시 'VMO 에도 미검증 건수 표기' — chain.unv 사건 → orch-state 체인 스냅샷 unv → VMO 실행 카드 칩
const path = require('path'); const Module = require('module');
const stub = new Proxy(function () { }, { get: (t, k) => (k === 'then' ? undefined : stub), apply: () => stub, construct: () => stub });
const orig = Module._load; Module._load = function (req, ...rest) { return req === 'vscode' ? stub : orig.call(this, req, ...rest); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const s = require(path.join(dir, 'orch-state')); const m = Date.now(); const b = { runId: 'RUNV1', screen: 'SCP0028', wb: 1, pid: process.pid, chainLabel: 'CheckList' };
s.apply(Object.assign({ type: 'chain.start', ms: m, steps: 6 }, b));
let c = s.snapshot().chains.find(x => x.runId === 'RUNV1'); chk('측정 전 = 건수 없음', c && c.unv === null, JSON.stringify(c && c.unv));
s.apply(Object.assign({ type: 'chain.unv', ms: m + 1, round: 1, go: true, total: 30, actionable: 13, human: 0, at: '2026-11-20 22:15:05' }, b));
c = s.snapshot().chains.find(x => x.runId === 'RUNV1'); chk('chain.unv → 스냅샷 unv', c && c.unv && c.unv.total === 30 && c.unv.actionable === 13 && c.unv.round === 1 && c.unv.go === true, JSON.stringify(c && c.unv));
s.apply(Object.assign({ type: 'chain.unv', ms: m + 2, round: 2, go: false, total: 22, actionable: 0, human: 1, at: '2026-11-20 23:00:00' }, b));
c = s.snapshot().chains.find(x => x.runId === 'RUNV1'); chk('다음 회차 = 최신 값으로 바뀜', c.unv.total === 22 && c.unv.round === 2 && c.unv.go === false);
const html = require(path.join(dir, 'orchestra')).html({ root: 'C:/x', vibeDir: 'C:/x/.vibe', extDir: dir, language: 'ko' }, { tab: '' });
chk('VMO 실행 카드에 건수 칩 함수', /function aUnv\(u\)/.test(html) && /aUnv\(c\.unv\)/.test(html) && html.includes("'미검증 '+u.total+'건 · 처리 대상 '+u.actionable+'건'"));
const wb = require('fs').readFileSync(path.join(dir, 'workbench.js'), 'utf8');
chk('workbench 가 이번 측정 분류 결과(fresh)만 사건으로', /if \(fresh && jo && jo\.after[^\n]*evt\(p, 'chain\.unv'/.test(wb));
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
