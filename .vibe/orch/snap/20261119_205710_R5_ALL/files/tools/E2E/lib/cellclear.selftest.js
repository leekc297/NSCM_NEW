// cellclear 판정 변이 입증(2026-11-01) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'cellclear.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeCellClear: j, staleKids: sk, judgeSubClear: sc } = m.exports;
const B = { src: 'A', tgt: 'B', v1: 'a1', v2: 'a2', before: 'b1', after: '', cond: '', refilled: false, why: '' };
const cases = [
  ['비워짐', j(B), 'PASS'], ['공백으로 비워짐', j({ ...B, after: ' ' }), 'PASS'], ['값 유지', j({ ...B, after: 'b1' }), 'FAIL'], ['AS-IS 재채움 교체', j({ ...B, after: 'b2', refilled: true }), 'PASS'], ['AS-IS 없는 교체', j({ ...B, after: 'b2' }), 'ERROR'],
  ['조건부 유지', j({ ...B, after: 'b1', cond: 'if (x)' }), 'ERROR'], ['조건부 비워짐', j({ ...B, cond: 'if (x)' }), 'PASS'], ['변경 전 빈 값', j({ ...B, before: '' }), 'ERROR'], ['원천 안 바뀜', j({ ...B, v2: 'a1', after: 'b1' }), 'ERROR'], ['측정 실패', j({ ...B, why: 'x' }), 'ERROR'],
];
const K = { name: 'c', before: 'v', after: 'v', asisClears: true };
cases.push(['하위 값 유지', { result: sk([K]).length ? 'FAIL' : 'PASS', why: '' }, 'FAIL'], ['하위 비워짐', { result: sk([{ ...K, after: '' }]).length ? 'FAIL' : 'PASS', why: '' }, 'PASS'], ['AS-IS 비움 아님', { result: sk([{ ...K, asisClears: false }]).length ? 'FAIL' : 'PASS', why: '' }, 'PASS'], ['ALL 유지', { result: sk([{ ...K, before: 'ALL', after: 'ALL' }]).length ? 'FAIL' : 'PASS', why: '' }, 'PASS']);
cases.push(['하위 비워짐', sc({ before: [5], after: [0], autoLoad: 0 }), 'PASS'], ['하위 남음', sc({ before: [5], after: [5], autoLoad: 0 }), 'FAIL'], ['자동 재조회', sc({ before: [5], after: [3], autoLoad: 1 }), 'PASS'], ['전 0행', sc({ before: [0], after: [0], autoLoad: 0 }), 'ERROR'], ['측정 실패', sc({ before: [], after: [], autoLoad: 0, why: 'x' }), 'ERROR']);
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
