// docui 판정 변이 입증(2026-11-02) — 결함 상태에서 FAIL, 정상에서 PASS · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'docui.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const j = m.exports.judgeDocUi; const B = { name: 'X', cond: 'c', applied: true, found: false, enabled: false };
const cases = [
  ['숨김 정상', j({ ...B, kind: 'btn_hidden' }), 'PASS'], ['숨겨야 하는데 보임', j({ ...B, kind: 'btn_hidden', found: true }), 'FAIL'], ['칸 숨김 위반', j({ ...B, kind: 'col_hidden', found: true }), 'FAIL'],
  ['보임 정상', j({ ...B, kind: 'col_shown', found: true }), 'PASS'], ['보여야 하는데 없음', j({ ...B, kind: 'btn_shown' }), 'FAIL'],
  ['비슷한 칸', j({ ...B, kind: 'col_shown', near: ['Version No'] }), 'ERROR'], ['활성 정상', j({ ...B, kind: 'btn_enabled', found: true, enabled: true }), 'PASS'], ['비활성', j({ ...B, kind: 'btn_enabled', found: true }), 'FAIL'], ['버튼 없음', j({ ...B, kind: 'btn_enabled' }), 'FAIL'],
  ['조건 못 맞춤', j({ ...B, kind: 'btn_hidden', applied: false }), 'ERROR'], ['측정 실패', j({ ...B, kind: 'btn_hidden', why: 'x' }), 'ERROR'], ['모르는 종류', j({ ...B, kind: 'zzz' }), 'ERROR'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
