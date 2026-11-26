// m1upload 판정 변이 입증(2026-11-25 T584 SCP0005 M1 V-219edc76) · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const src = fs.readFileSync(path.join(__dirname, 'm1upload.ts'), 'utf8');
const m = { exports: {} }; new Function('module', 'exports', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports);
const { parseUploadKinds, buildM1Rows, statusesOf, judgeM1, mapFormToGrid, uploadStatuses, overwriteChain } = m.exports;
const cs = fs.readFileSync(path.join(__dirname, '..', '..', '..', 'GSCM', '01.Framework', 'GSCM.Windows.Forms', 'UI', 'ExcelUploadForm2.cs'), 'utf8');
const ps = parseUploadKinds(cs, 'SCP0005');
const st = ps.kinds.map(k => `${k.status}:${k.kind}`);
const base = Array.from({ length: 35 }, (_, i) => `v${i}`);
const b = buildM1Rows(base, ps);
const exp = b.rows.map(r => r.status);
const okJ = judgeM1(b.rows, exp, b.notBuilt, ps.skipped);
const badJ = judgeM1(b.rows, exp.map((s, i) => (i === 2 ? 'Error-Required' : s)), b.notBuilt, ps.skipped);
const ctlJ = judgeM1(b.rows, ['Error-Required', ...exp.slice(1)], b.notBuilt, ps.skipped);
const resp = { result: { O_CUR_CNT: [{ ERROR_COUNT: 1 }], O_CUR_LIST: [{ A: 'x', STATUS: 'Success' }, { A: 'y', STATUS: 'Error-L/T Type' }] } };
const mp = mapFormToGrid(['Route Id', 'From Country*', 'Valid*'], [{ b: 'ROUTE_ID', header: 'Route Id' }, { b: 'FROM_COUNTRY', header: 'Country*' }, { b: 'VALID_YN', header: 'Active*' }, { b: 'X', header: 'X' }]);
const cases = [
  ['상태 8종 해석', st.join(','), 'Error-Required:required,Error-Departure days:allEmpty,Error-L/T Type:lookup,Error-TransMode:lookup,Error-From Site:lookup,Error-To Site:lookup,Error-Unique Duplicate:dbdup,Error-Duplicate:filedup'],
  ['주석 Priority Error 제외', ps.skipped.join(','), 'Priority Error'], ['식별 변수', ps.idVar, 'strRouteId'], ['From Site 칸', String(ps.varIdx.strFromCountry), '3'],
  ['행 수(대조군+8종+중복 2행)', String(b.rows.length), '10'], ['못 만든 종류', b.notBuilt.join('|'), ''],
  ['중복 칸 = 자유 칸', b.rows[b.rows.length - 1].how.split(' ')[0], 'strShippingCompany'],
  ['일치 PASS', okJ.result, 'PASS'], ['다름 FAIL', badJ.result, 'FAIL'], ['대조군 오류 ERROR', ctlJ.result, 'ERROR'], ['행 수 다름 ERROR', judgeM1(b.rows, ['Success'], [], []).result, 'ERROR'],
  ['응답 상태 배열', (statusesOf(resp) || []).join(','), 'Success,Error-L/T Type'], ['머리글 대응 2/3 = 80% 미만', String(mp.ok), 'false'],
];
// 2026-11-25 T600: 공용 업로드 결과(오류 행만 · 상태 = MESSAGE_TEXT · 키 이름 고정 없음) → 올린 행 순서 상태
const up3 = [['1', 'A', 'x'], ['2', '', 'y'], ['3', 'C', 'ZZ']];
const errOnly = { code: '0', result: { O_CUR_CNT: [{ TOTAL_TITLE: 'Total', TOTAL_COUNT: 3, SUCCESS_COUNT: 1, ERROR_COUNT: 2 }], O_CUR_LIST: [{ EXCEL_ROW: 3, UPLOAD_STATUS_CODE: 'ERROR', ATTRIBUTE1: '2', ATTRIBUTE2: null, ATTRIBUTE3: 'y', MESSAGE_TEXT: 'Error-Required' }, { EXCEL_ROW: 4, UPLOAD_STATUS_CODE: 'ERROR', ATTRIBUTE1: '3', ATTRIBUTE2: 'C', ATTRIBUTE3: 'ZZ', ATTRIBUTE9: 'Error-From Site' }] } };
const u1 = uploadStatuses(errOnly, up3); const u2 = uploadStatuses({ result: { O_CUR_CNT: [{ TOTAL_COUNT: 3, SUCCESS_COUNT: 2, ERROR_COUNT: 1 }], O_CUR_LIST: errOnly.result.O_CUR_LIST } }, up3);
const u3 = uploadStatuses({ result: { O_CUR_CNT: [{ TOTAL_COUNT: 1, SUCCESS_COUNT: 0, ERROR_COUNT: 1 }], O_CUR_LIST: [{ UPLOAD_STATUS_CODE: 'ERROR', ATTRIBUTE10: null, ATTRIBUTE32: 'E2E', MESSAGE_TEXT: 'Error-Number' }] } });
const u4 = uploadStatuses({ result: { O_CUR_CNT: [{ TOTAL_COUNT: 3, SUCCESS_COUNT: 1, ERROR_COUNT: 2 }], O_CUR_LIST: [{ ATTRIBUTE1: 'q', ATTRIBUTE2: 'q', ATTRIBUTE3: 'q', MESSAGE_TEXT: 'Error-Required' }, errOnly.result.O_CUR_LIST[1]] } }, up3);
const oc = overwriteChain(cs, 'SCP0005', 'Error-Required');
cases.push(['오류 행만 → 상태 3행', (u1.statuses || []).join(','), 'Success,Error-Required,Error-From Site'], ['건수 안 맞으면 null', String(u2.statuses), 'null'], ['UPLOAD_STATUS_CODE ERROR 는 상태 문구 아님', u3.errRows.map(z => z.status).join(','), 'Error-Number'],
  ['상태 키 이름 무관(ATTRIBUTE9)', u1.errRows[1].status, 'Error-From Site'], ['값 짝 못 지으면 null', String(u4.statuses), 'null'], ['건수 읽기', `${u3.total}/${u3.ok}/${u3.err}`, '1/0/1'],
  ['AS-IS 필수 뒤 덮어쓰기 문구', oc.list.join(','), 'Error-Required,Error-Departure days,Error-Number'],
  ['오류 행만 응답 판정 PASS', judgeM1([{ status: 'Success', kind: 'control' }, { status: 'Error-Required', kind: 'required' }, { status: 'Error-From Site', kind: 'lookup' }], u1.statuses, [], []).result, 'PASS'],
  ['못 찾음 사유 표시', /ERROR_COUNT 1/.test(judgeM1(b.rows, null, [], [], u2.why).why) ? 'Y' : 'N', 'Y']);
// T638 동점 짝짓기: 대조군(행 ID 9917)·DB 중복 행(행 ID 빈 값)은 나머지 값이 같다 → EXCEL_ROW 로 고름 · 없으면 짝짓지 않음 · 값이 똑같은 쌍은 아무 쪽
{ const cs6 = [['9917', 'A', 'B', 'C', 'D'], ['1', 'ZZ', 'B', 'C', 'D'], ['', 'A', 'B', 'C', 'D'], ['9917', 'A', 'B', 'C', 'X'], ['9917', 'A', 'B', 'C', 'X']];
  const at = (r, er, st) => ({ EXCEL_ROW: er, ATTRIBUTE1: r[0] === '' ? '0' : r[0], ATTRIBUTE2: r[1], ATTRIBUTE3: r[2], ATTRIBUTE4: r[3], ATTRIBUTE5: r[4], MESSAGE_TEXT: st });
  const L6 = [at(cs6[1], 3, 'Error-L/T Type'), at(cs6[2], 4, 'Error-Unique Duplicate'), at(cs6[3], 5, 'Error-Duplicate'), at(cs6[4], 6, 'Error-Duplicate')];
  const r6 = uploadStatuses({ result: { O_CUR_CNT: [{ TOTAL_COUNT: 5, SUCCESS_COUNT: 1, ERROR_COUNT: 4 }], O_CUR_LIST: L6 } }, cs6);
  const r7 = uploadStatuses({ result: { O_CUR_CNT: [{ TOTAL_COUNT: 5, SUCCESS_COUNT: 1, ERROR_COUNT: 4 }], O_CUR_LIST: L6.map(({ EXCEL_ROW, ...z }) => z) } }, cs6);
  cases.push(['T638 EXCEL_ROW 로 동점 해소', (r6.statuses || []).join(','), 'Success,Error-L/T Type,Error-Unique Duplicate,Error-Duplicate,Error-Duplicate'],
    ['T638 변이: EXCEL_ROW 없으면 대조군에 짝짓지 않음', String(r7.statuses), 'null'], ['T638 같은 값 쌍은 짝지음', r7.errRows.filter(z => z.status === 'Error-Duplicate' && z.row != null).length + '', '2']); }
// T637 파일 안 중복 검사 비교 칸이 모두 같은 행 쌍 = 파일 중복 쌍 1개뿐(대조군과 겹치는 행 없음)
{ const dk = ps.kinds.find(k => k.kind === 'filedup'); const key = r => dk.vars.map(v => r.cells[ps.varIdx[v]]).join('|'); const pairs = []; b.rows.forEach((r, i) => b.rows.forEach((q, j) => { if (i < j && key(r) === key(q)) pairs.push(`${r.kind}-${q.kind}`); }));
  cases.push(['T637 겹치는 행 쌍 = 파일 중복 쌍만', pairs.join(','), 'filedup-filedup'], ['T637 대조군 그대로', b.rows[0].cells.join('|'), base.join('|')]); }
let bad = 0; for (const [n, got, want] of cases) { const ok = got === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got}${ok ? '' : `(기대 ${want})`}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
