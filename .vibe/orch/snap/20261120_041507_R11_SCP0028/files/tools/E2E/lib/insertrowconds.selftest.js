// asisInsertRowConds(2026-11-12 Y01 · C1-01) 변이 입증 — AS-IS Insert 의 '활성 행 값 조건' 사실 추출. 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'newrow.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const f = m.exports.asisInsertRowConds;
const G = 'if (siDetail != null && siDetail.IsLock(siDetail.SheetName) == false) ▸ ';
const base = [
  { method: 'InsertButton', kind: 'CALL_LOCAL', target: 'this.InsertRow', line: '10', guard: '' },
  { method: 'InsertRow', kind: 'RETURN', target: 'return;', line: '2287', guard: G + 'if (SHIPMENT_STATUS != "C")' },
  { method: 'InsertRow', kind: 'DATA_OP', target: 'siDetail.Insert', line: '2289', guard: G },
];
const one = a => JSON.stringify(f(a).map(x => `${x.col}=${x.val}@${x.ref}`));
const cases = [
  ['상태 C 조건 추출(SSP0021 cs:2287 꼴)', one(base), '["SHIPMENT_STATUS=C@InsertRow:2287"]'],
  ['RowCount == 0 return 은 값 조건 아님', one([base[0], { method: 'InsertRow', kind: 'RETURN', target: 'return;', line: '2212', guard: G + 'if (siDetail.ActiveSheet.RowCount == 0)' }]), '[]'],
  ['빈 문자열 비교는 제외', one([base[0], { method: 'InsertRow', kind: 'RETURN', target: 'return;', line: '5', guard: 'if (X != "")' }]), '[]'],
  ['&& 로 묶인 조건은 제외', one([base[0], { method: 'InsertRow', kind: 'RETURN', target: 'return;', line: '5', guard: 'if (A != "C" && B != "D")' }]), '[]'],
  ['== 조건 return 은 제외(그 값이면 막는 것)', one([base[0], { method: 'InsertRow', kind: 'RETURN', target: 'return;', line: '5', guard: 'if (A == "C")' }]), '[]'],
  ['Insert 에서 닿지 않는 메서드는 제외', one([base[0], { method: 'SaveData', kind: 'RETURN', target: 'return;', line: '5', guard: 'if (A != "C")' }]), '[]'],
  ['RETURN 이 아닌 BRANCH 는 제외', one([base[0], { method: 'InsertRow', kind: 'BRANCH', target: 'A != "C"', line: '5', guard: 'if (A != "C")' }]), '[]'],
  ['같은 조건 중복 제거', one([...base, { method: 'InsertRow', kind: 'RETURN', target: 'return;', line: '2300', guard: 'if (SHIPMENT_STATUS != "C")' }]), '["SHIPMENT_STATUS=C@InsertRow:2287"]'],
  ['사실 없음', one([]), '[]'],
];
// 실제 사실 파일 — SSP0021·SSP0015·SSP0060 은 SHIPMENT_STATUS=C 가 나와야 하고 SSP0023(상태 조건 없음 — cs:1902)은 없어야 한다
const parse = (txt) => { const rows = []; let cur = [], cell = '', q = false; const t = txt.replace(/^﻿/, ''); for (let i = 0; i < t.length; i++) { const ch = t[i]; if (q) { if (ch === '"') { if (t[i + 1] === '"') { cell += '"'; i++; } else q = false; } else cell += ch; } else if (ch === '"') q = true; else if (ch === ',') { cur.push(cell); cell = ''; } else if (ch === '\n') { cur.push(cell); rows.push(cur); cur = []; cell = ''; } else if (ch !== '\r') cell += ch; } if (cell || cur.length) { cur.push(cell); rows.push(cur); } const h = rows.shift() || []; return rows.map(r => Object.fromEntries(h.map((k, i) => [k, r[i] || '']))); };
for (const [id, want] of [['SSP0021', true], ['SSP0015', true], ['SSP0060', true], ['SSP0023', false]]) {
  const fp = path.join(__dirname, '..', '..', '..', 'Doc', 'asisfacts', 'screens', id, 'actions.csv');
  if (!fs.existsSync(fp)) { cases.push([`${id} 사실 파일 없음 — 건너뜀`, 'skip', 'skip']); continue; }
  const got = f(parse(fs.readFileSync(fp, 'utf8'))).some(x => x.col === 'SHIPMENT_STATUS' && x.val === 'C');
  cases.push([`${id} 실제 사실: SHIPMENT_STATUS=C ${want ? '있음' : '없음'}`, String(got), String(want)]);
}
let bad = 0; for (const [n, got, want] of cases) { const ok = got === want; if (!ok) bad++; console.log(`${ok ? 'PASS' : 'FAIL'} ${n}${ok ? '' : ` → ${got} (기대 ${want})`}`); }
console.log(`selftest ${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
