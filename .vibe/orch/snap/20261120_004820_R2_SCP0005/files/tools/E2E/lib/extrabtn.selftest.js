// extrabtn 판정 변이 입증(2026-11-02) — 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'extrabtn.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { extraButtons: x } = m.exports;
const eq = (a, b) => JSON.stringify(a) === JSON.stringify(b);
const cases = [['AS-IS 없는 Delete', eq(x(['Search(F5)', 'Delete(F9)'], ['Search'], []), ['Delete'])], ['AS-IS 있음', eq(x(['Save(F7)'], ['Save'], []), [])], ['규칙 제외', eq(x(['Edit'], [], ['Edit']), [])], ['기능 버튼 아님', eq(x(['Sort(F3)'], [], []), [])], ['둘', eq(x(['Insert(F8)', 'Save(F7)'], [], []), ['Insert', 'Save'])]];
const BC = { name: 'X', writes: 0, dialog: '', reads: 0, dl: false };
cases.push(['확인 없이 쓰기', m.exports.judgeBtnClick({ ...BC, writes: 1 }), 'FAIL'], ['창 뜸', m.exports.judgeBtnClick({ ...BC, dialog: '실행할까요?' }), 'PASS'], ['다운로드', m.exports.judgeBtnClick({ ...BC, dl: true }), 'PASS'], ['읽기만', m.exports.judgeBtnClick({ ...BC, reads: 2 }), 'PASS'], ['무반응', m.exports.judgeBtnClick(BC), 'ERROR']);
let bad = 0; for (const [n, ok] of cases) { if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
