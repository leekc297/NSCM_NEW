// savepath 판정 변이 입증(2026-10-31) — 결함 상태에서 FAIL, 정상에서 PASS 를 내는지 확인 · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'savepath.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { judgeSaveFail: f, judgeCancel: c, judgeSpinner: s, judgePaste: p } = m.exports;
const cases = [
  ['실패인데 성공 문구', f(1, '성공적으로 저장되었습니다.'), 'FAIL'], ['실패인데 무메시지', f(1, ''), 'FAIL'], ['실패 문구 정상', f(1, 'Sql Error'), 'PASS'], ['요청 전 차단', f(0, 'x'), 'ERROR'],
  ['취소인데 요청 나감', c({ dialogHasCancel: true, otherAlert: '', delta: 1, asisConfirm: '' }), 'FAIL'], ['취소 정상', c({ dialogHasCancel: true, otherAlert: '', delta: 0, asisConfirm: '' }), 'PASS'],
  ['확인창 없음·AS-IS 있음', c({ dialogHasCancel: false, otherAlert: '', delta: 1, asisConfirm: 'SaveData:1' }), 'FAIL'], ['확인창 없음·AS-IS 없음', c({ dialogHasCancel: false, otherAlert: '', delta: 1, asisConfirm: '' }), 'NA'], ['다른 알림', c({ dialogHasCancel: false, otherAlert: 'x', delta: 0, asisConfirm: '' }), 'ERROR'], ['저장 요청 뒤 알림', c({ dialogHasCancel: false, otherAlert: 'x', delta: 1, asisConfirm: '' }), 'NA'], ['무반응', c({ dialogHasCancel: false, otherAlert: '', delta: 0, asisConfirm: '' }), 'ERROR'],
  ['로딩 없음', s({ baseline: false, calls: 1, seen: 0, stillAfter: false }), 'FAIL'], ['대조군 실패', s({ baseline: false, calls: 1, seen: 0, stillAfter: false, control: 0 }), 'ERROR'], ['대조군 관측·저장 0', s({ baseline: false, calls: 1, seen: 0, stillAfter: false, control: 5 }), 'FAIL'], ['로딩 잔존', s({ baseline: false, calls: 1, seen: 3, stillAfter: true }), 'FAIL'], ['로딩 정상', s({ baseline: false, calls: 1, seen: 3, stillAfter: false }), 'PASS'], ['기준선 오염', s({ baseline: true, calls: 1, seen: 3, stillAfter: false }), 'ERROR'], ['요청 없음', s({ baseline: false, calls: 0, seen: 0, stillAfter: false }), 'ERROR'],
  ['붙여넣기 미인식', p({ pasted: true, calls: 0, kind: 'NOCHANGE', msg: '수정한 내용이 없습니다', want: '1', bodyHas: null }), 'FAIL'], ['본문에 값 없음', p({ pasted: true, calls: 1, kind: '', msg: '', want: '1', bodyHas: false }), 'FAIL'], ['붙여넣기 정상', p({ pasted: true, calls: 1, kind: '', msg: '', want: '1', bodyHas: true }), 'PASS'], ['입력 실패', p({ pasted: false, calls: 0, kind: '', msg: '', want: '1', bodyHas: null }), 'ERROR'], ['검증 차단', p({ pasted: true, calls: 0, kind: 'VALIDATION', msg: 'x', want: '1', bodyHas: null }), 'ERROR'],
];
let bad = 0; for (const [n, got, want] of cases) { const ok = got.result === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got.result}(기대 ${want}) ${got.why}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
