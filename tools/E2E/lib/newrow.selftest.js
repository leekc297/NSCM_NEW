// newrow 판정 변이 입증(2026-10-31) — 결함 상태에서 FAIL, 정상에서 PASS 를 내는지 확인 · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'newrow.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeRequired: r, judgeDup: d, asisInsertNoop: nz } = m.exports; const yn = (o) => ({ result: o.noop ? 'NA' : 'FAIL', why: o.ref });
const base = { calls: 0, msg: '', label: 'Item', col: 'ITEM_ID', fillFails: [], control: 'sent' };
const dup = { calls: 0, msg: '', fillFails: [], asisDup: '' };
const cases = [
  ['Insert 빈 구현', yn(nz([{ method: 'InsertRow', kind: 'RETURN', line: '1' }], [{ entry: 'InsertButton', method: 'InsertRow' }])), 'NA'], ['Insert 실제 동작', yn(nz([{ method: 'InsertRow', kind: 'GRID_SET', line: '2' }], [{ entry: 'InsertButton', method: 'InsertRow' }])), 'FAIL'], ['Insert 진입점 없음', yn(nz([], [])), 'NA'], ['공란인데 요청 나감', r({ ...base, calls: 1 }), 'FAIL'], ['공란인데 무메시지', r(base), 'FAIL'], ['컬럼명 포함 차단', r({ ...base, msg: '[Item] 값은 필수 입력 항목입니다.' }), 'PASS'], ['컬럼명 없는 차단', r({ ...base, msg: '필수 항목을 입력하세요' }), 'PASS'],
  ['다른 컬럼이 차단', r({ ...base, msg: '[Country] 값은 필수', otherCol: 'COUNTRY_NAME' }), 'ERROR'], ['다른 칸 입력 실패·문구 불일치', r({ ...base, msg: 'x', fillFails: ['A'] }), 'ERROR'], ['다른 칸 입력 실패·컬럼명 일치', r({ ...base, msg: '[Item] 필수', fillFails: ['A'] }), 'PASS'], ['대조군 차단·문구 불일치', r({ ...base, msg: 'x', control: 'blocked' }), 'ERROR'],
  ['중복인데 요청·AS-IS 검증 있음', d({ ...dup, calls: 1, asisDup: 'SaveData:1' }), 'FAIL'], ['중복인데 요청·AS-IS 없음', d({ ...dup, calls: 1 }), 'ERROR'], ['중복 문구 차단', d({ ...dup, msg: '중복된 데이터입니다' }), 'PASS'], ['무메시지', d(dup), 'FAIL'], ['다른 사유 차단', d({ ...dup, msg: '필수입니다' }), 'ERROR'], ['입력 실패', d({ ...dup, fillFails: ['A'] }), 'ERROR'], ['입력 실패·요청', d({ ...dup, calls: 1, fillFails: ['A'], asisDup: 'x' }), 'ERROR'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
