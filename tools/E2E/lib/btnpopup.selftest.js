// btnpopup 판정 변이 입증(2026-11-20 T501~T505) — 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'btnpopup.ts'), 'utf8').replace(/^import \{ parseCsv \} from '\.\/probe';$/m, 'const parseCsv = () => [];');
const m = { exports: {} }; new Function('module', 'exports', 'require', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports, require);
const X = m.exports;
const ents = [
  { entry: 'this.btnA.Click', handler: 'btnA_Click', method: 'FindA', depth: '1', call_guard: 'if (ok)' },
  { entry: 'this.btnA.Click', handler: 'btnA_Click', method: 'FindData', depth: '2', call_guard: '' },
  { entry: 'SearchButton', handler: 'SearchButton', method: 'FindData', depth: '1', call_guard: '' },
  { entry: 'this.btnB.Click', handler: 'btnB_Click', method: 'FindB', depth: '1', call_guard: '' },
];
const acts = [{ method: 'FindA', endpoint: 'X.SP_SAVE', line: '10' }, { method: 'FindData', endpoint: 'X.SP_GET', line: '20' }, { method: 'FindB', endpoint: 'X.SP_IN', line: '30' }];
const props = [{ target: 'btnA', prop: 'Text', value: '"Delete"' }];
const pa = [{ asis_method: 'btnA_Click', asis_popup: 'P1' }, { asis_method: 'btnB_Click', asis_popup: 'P1' }];
const pairs = [{ asis_sp: 'SP_SAVE', tobe_proc: 'PKG.P_SAVE', kind: 'SAVE' }, { asis_sp: 'SP_GET', tobe_proc: 'PKG.P_GET', kind: 'GET' }, { asis_sp: 'SP_IN', tobe_proc: 'PKG.P_IN', kind: 'LOG' }];
const ps = X.buildPaths(ents, acts, props, pa, pairs);
const A = ps.find(b => b.btn === 'btnA'); const B = ps.find(b => b.btn === 'btnB');
const sample = { code: '0', message: 'success', result: { O_RESULT_CURSOR: [{ RESULT_CNT: 1, RESULT_CODE: 'S' }], DATARESULT: [] } };
const ev = `x · main/SAVE:200 응답=${JSON.stringify(sample)} | main/SAVE:200 응답={"code":"0","mess`;
const fb = X.branchBody(sample, 'S', true);
const cases = [
  ['버튼 2개', ps.length, 2], ['Designer Text', A.text, 'Delete'], ['메서드 2개', A.methods.length, 2],
  ['짝 PROC', A.methods[0].eps[0].tobeProc, 'PKG.P_SAVE'],
  ['SAVE = 파괴', X.isDestructive(A.methods[0]), true], ['LOG = 읽기', X.isDestructive(B.methods[0]), false],
  ['팝업 버튼에서만 닿음', (X.onlyViaPopupButtons(ents, ps, 'FindA') || {}).btn, 'btnA'],
  ['조회에서도 닿음 = 제외', X.onlyViaPopupButtons(ents, ps, 'FindData'), null],
  ['성공 분기', JSON.stringify(X.guardBranch('try ▸ if (t.Success) ▸ if (x == "S")')), JSON.stringify({ literal: 'S', elseBranch: false })],
  ['실패 분기', JSON.stringify(X.guardBranch('try ▸ if (t.Success) ▸ else of (x == \\"S\\")')), JSON.stringify({ literal: 'S', elseBranch: true })],
  ['가드 없음', X.guardBranch('try ▸ if (iCount > 0)'), null],
  ['응답 표본', JSON.stringify(X.respSample([ev], 'main', 'SAVE')), JSON.stringify(sample)],
  ['다른 버튼 표본 없음', X.respSample([ev], 'main', 'INSERT'), null],
  ['실패 본문 = 값 뒤집음', fb && fb.body.result.O_RESULT_CURSOR[0].RESULT_CODE, 'F'], ['원본 불변', sample.result.O_RESULT_CURSOR[0].RESULT_CODE, 'S'],
  ['성공 본문 칸', (X.branchBody(sample, 'S', false) || {}).field, 'RESULT_CODE'], ['리터럴 없음', X.branchBody(sample, 'Q', false), null],
  ['삭제 성공 = 같은 의미', X.judgeMsgBranch({ expect: ['삭제 하였습니다.', 'deleted it.'], seen: ['Deleted successfully.'], driven: true, why: 'w' }).result, 'PASS'],
  ['오류 기대 · 성공 표시 = FAIL', X.judgeMsgBranch({ expect: ['실행중 에러가 발생했습니다.'], seen: ['Deleted successfully.'], driven: true, why: 'w' }).result, 'FAIL'],
  ['오류 기대 · 저장 오류 표시 = PASS', X.judgeMsgBranch({ expect: ['실행중 에러가 발생했습니다.'], seen: ['An error occurred while saving.'], driven: true, why: 'w' }).result, 'PASS'],
  ['삭제 기대 · 저장 성공 = FAIL', X.judgeMsgBranch({ expect: ['삭제 하였습니다.'], seen: ['Saved successfully.'], driven: true, why: 'w' }).result, 'FAIL'],
  ['메시지 없음 = FAIL', X.judgeMsgBranch({ expect: ['삭제 하였습니다.'], seen: [], driven: true, why: 'w' }).result, 'FAIL'],
  ['구동 못함 = ERROR', X.judgeMsgBranch({ expect: ['삭제 하였습니다.'], seen: ['Deleted successfully.'], driven: false, why: 'w' }).result, 'ERROR'],
  ['기대 분류 불가 = ERROR', X.judgeMsgBranch({ expect: ['{0}'], seen: ['x'], driven: true, why: 'w' }).result, 'ERROR'],
  ['색 이름 White', X.parseControlColor('private static Color m_LockColor = Color.White; // x', 'LockColor'), 'rgb(255, 255, 255)'],
  ['색 FromArgb', X.parseControlColor('m_UnLockColor = Color.FromArgb(255, 255, 134);', 'UnLockColor'), 'rgb(255, 255, 134)'],
  ['색 모름', X.parseControlColor('m_LockColor = Color.Teal;', 'LockColor'), ''],
  ['실행 상태 원자', JSON.stringify(X.runtimeEditAtoms('RAW(action == CAppSetting.FlagM) && COL(LOT_SIZE)=="" && COL(VALID_YN)=="Y"')), JSON.stringify({ flag: 'M', cols: [{ col: 'LOT_SIZE', val: '' }, { col: 'VALID_YN', val: 'Y' }] })],
  ['다른 연산 섞임 = null', X.runtimeEditAtoms('RAW(action == CAppSetting.FlagM) || COL(A)=="1"'), null],
  ['상태 원자 없음 = null', X.runtimeEditAtoms('COL(A)=="1"'), null],
];
// T642 표본 쌓기: 1회차 원천에서 쌓고 2회차 원천이 비어도 파일에서 돌려줌 · 가짜 표지 본문은 쌓지 않음
{ const os = require('os'); const f = path.join(os.tmpdir(), `resp_samples_${process.pid}.json`); try { fs.unlinkSync(f); } catch { /* 없음 */ }
  const a = X.persistRespSamples(['x · route/SAVE:200 응답={"code":"0","result":{"O":[{"CODE":"0"}]}} | y', 'main/SAVE:200 응답={"MSG":"[9] E2E-FAKE-1"}'], f);
  const b = X.persistRespSamples([], f);
  cases.push(['표본 쌓기 1회차', a.length, 1], ['표본 2회차 파일에서', X.respSample(b, 'route', 'SAVE') ? 'Y' : 'N', 'Y'], ['가짜 본문 제외', X.respSample(b, 'main', 'SAVE'), null]);
  try { fs.unlinkSync(f); } catch { /* 없음 */ } }
let bad = 0; for (const [n, got, want] of cases) { const ok = JSON.stringify(got) === JSON.stringify(want); if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n}${ok ? '' : ` → ${JSON.stringify(got)} (기대 ${JSON.stringify(want)})`}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
