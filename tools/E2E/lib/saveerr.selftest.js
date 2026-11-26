// saveerr 변이 입증(2026-11-25 T550~T554) — 결함 상태(자리표시자 제거 비교 · 경계값 위반 입력 · RAW 지역 변수 · 오류코드 넓힘)를 잡는지 · 실패 1건이라도 있으면 exit 1
const fs = require('fs'), path = require('path');
const ts = require(path.join(__dirname, '..', '..', '..', 'nscm-fe', 'node_modules', 'typescript'));
const load = (f) => { const src = fs.readFileSync(path.join(__dirname, f), 'utf8'); const m = { exports: {} }; const req = (q) => (q === './condeval' ? load('condeval.ts') : require(q)); new Function('module', 'exports', 'require', '__dirname', ts.transpileModule(src, { compilerOptions: { module: 'commonjs', target: 'es2020' } }).outputText)(m, m.exports, req, __dirname); return m.exports; };
const S = load('saveerr.ts'); const S_ce = load('condeval.ts');
const cases = []; const eq = (n, got, want) => cases.push([n, JSON.stringify(got), JSON.stringify(want)]);

// T550 메시지 인자·틀 비교
const ln = '                                MessageHelper.GMessageBox("MSG00209", new object[] { "Total L/T", "999" });';
const args = S.callArgs(ln, 'MSG00209'); eq('인자 식 2개', args, ['"Total L/T"', '"999"']);
const vals = args.map(a => S.evalArg(a)); eq('리터럴 인자 값', vals, ['Total L/T', '999']);
eq('채운 틀 일치(exact)', !!(S.matchTpl(['{0}은 {1} 이하 입니다.'], vals, ['Total L/T은 999 이하 입니다.']) || {}).exact, true);
eq('자리표시자 지운 문구 비교(종전 결함)는 불일치', 'Total L/T은 999 이하 입니다.'.replace(/\s+/g, '').includes('은  이하 입니다.'.replace(/\s+/g, '')), false);
eq('다른 상한 값 = 인자 불일치', (S.matchTpl(['{0}은 {1} 이하 입니다.'], vals, ['Total L/T은 99 이하 입니다.']) || {}).argsOk, false);
eq('값 미상 자리는 와일드카드', (S.matchTpl(['{0}은 {1} 이하 입니다.'], ['Total L/T', null], ['Total L/T은 5 이하 입니다.']) || {}).argsOk, true);
eq('다른 메시지 = 불일치', S.matchTpl(['{0}은 {1} 이하 입니다.'], vals, ['Priority는 양의 정수입니다.']), null);
const a43 = S.callArgs('MessageHelper.GMessageBox("MSG00043", new object[] { "( Route Id : " +dtErr.Rows[0][DefColumns.ROUTE_ID].ToString()+" )" });', 'MSG00043');
eq('응답 행 인자 식 값', S.evalArg(a43[0], { ROUTE_ID: '5942' }), '( Route Id : 5942 )');
eq('행 없으면 인자 미상', S.evalArg(a43[0]), null);
eq('인자 없는 호출', S.callArgs('MessageHelper.GMessageBox("MSG00006");', 'MSG00006'), []);
// 합계 상한 입력 계획 — 합계가 n 을 넘는 첫 입력에서만 위반
const p1 = S.sumCrossPlan([0, 0, 0, 0, 0], [999, 999, 999, 999, 999], 999);
eq('계획 마지막 합계 = n+1', p1[p1.length - 1].sumAfter, 1000); eq('앞 입력 합계 ≤ n', p1.slice(0, -1).every(s => s.sumAfter <= 999), true);
eq('경계값 999 단독 입력은 위반 아님(종전 결함)', p1.length > 1 || p1[0].sumAfter > 999, true);
eq('이미 초과면 null', S.sumCrossPlan([1000, 0], [999, 999], 999), null);
eq('상한 안에서 못 만들면 null', S.sumCrossPlan([0, 0], [10, 10], 999), null);
// 메시지 뒤 되돌림 값
eq('메시지 뒤 되돌림', S.resetAfter(['if (x > 999) {', '  Msg("MSG00209");', '  if (c == a) {', '    dt.Rows[n][DefColumns.LT_A] = "0";', '  } else if (c == b) {', '    dt.Rows[n][DefColumns.LT_B] = "0";'], 1), { LT_A: '0', LT_B: '0' });

// T552 대화창 닫힌 뒤 메시지
const up = ['        private void btnUp_Click(object sender, EventArgs e)', '        {', '            UploadForm frm = new UploadForm("X", "Y");', '            frm.ShowDialog();', '', '            if (MessageHelper.GMessageBox("MSG00265") == DialogResult.Yes)', '            {', '                Find();', '            }', '        }'];
eq('대화창 뒤 무조건 메시지', S.afterDialogMsg(up, 'btnUp_Click', 'MSG00265'), { dialogLine: 3, msgLine: 5, popup: 'UploadForm' });
const up2 = up.slice(); up2[3] = '            if (frm.ShowDialog() == DialogResult.OK) return;';
eq('대화창 결과로 갈리면 null', S.afterDialogMsg(up2, 'btnUp_Click', 'MSG00265'), null);
const up3 = up.slice(); up3.splice(4, 0, '            if (!frm.Done) return;');
eq('사이 분기 있으면 null', S.afterDialogMsg(up3, 'btnUp_Click', 'MSG00265'), null);

// T553 RAW 지역 변수 → 칸
const cv = ['        private bool CheckValid()', '        {', '            int nPriorityIdx1 = siMain.GetColumnIndex(DefColumns.PRIORITY);', '            for (int i = 0; i < n; i++)', '            {', '                string strPRIORITY = siMain.GetValue(i, nPriorityIdx1).ToString();', '                if (string.IsNullOrEmpty(strPRIORITY)) strPRIORITY = "0";', '                Int64 intPRIORITY = Int64.Parse(strPRIORITY);', '                if (intPRIORITY < 1)', '                {', '                    siMain.SetBGColor(i, nPriorityIdx1, i, nPriorityIdx1, ControlColor.InvalidColor);', '                }', '            }', '            return true;', '        }'];
const b = S.bindLocalNum(cv, 'CheckValid', 'intPRIORITY'); eq('지역 변수 칸', b && b.col, 'PRIORITY'); eq('빈 값 기본', b && b.emptyAs, '0');
const at = S.rawNumAtoms('RAW(intPRIORITY < 1)'); eq('RAW 숫자 원자', at.map(a => [a.v, a.op, a.n]), [['intPRIORITY', '<', 1]]);
const binds = [{ atom: at[0].atom, col: 'PRIORITY', op: '<', n: 1, emptyAs: '0' }];
eq('0 → 조건 만족', S.bindNumCond('RAW(intPRIORITY < 1)', binds, () => '0'), 'TRUE');
eq('빈 값 → 0 → 만족', S.bindNumCond('RAW(intPRIORITY < 1)', binds, () => ''), 'TRUE');
eq('5 → 불만족', S.bindNumCond('RAW(intPRIORITY < 1)', binds, () => '5'), 'FALSE');
eq('위반 값 후보', S.violatingValues('<', 1, '0'), ['0', '']);
{ const C = S_ce.evalExpr; const c1296 = '!(COL(CRUD_TYPE)!="I" && COL(CRUD_TYPE)!="M" && COL(CRUD_TYPE)!="D") && RAW(intPRIORITY < 1)';
  const ev = (crud, pr) => { const col = (n) => (n === 'CRUD_TYPE' ? crud : pr); return C(S.bindNumCond(c1296, binds, col), { group: [], admin: false, div: '', self: '', col }); };
  eq('[11-25 사실 형식] 수정 행 · PRIORITY 0 → 참', ev('M', '0'), true); eq('[11-25 사실 형식] 조회 행 → 거짓', ev('', '0'), false); eq('[11-25 사실 형식] 수정 행 · PRIORITY 3 → 거짓', ev('M', '3'), false); }
eq('다른 변수는 바인딩 없음', S.bindLocalNum(cv, 'CheckValid', 'intOther'), null);

// T551·T553 저장 오류 응답 분기
const sv = ['        private void SaveData()', '        {', '            int iCount = 0;', '            for (int i = 0; i < n; i++) { iCount++; }', '            if (iCount > 0)', '            {', '                var response = client.ExecuteDataSet(request);', '                if (response.DataSet.Tables[0].Rows[0][0].ToString() == "S") { }', '                else', '                {', '                    string errCode =  dtErr.Rows[0][0].ToString();', '                    if (errCode == "99010" || errCode == "99020") {', '                        string errStr = "";', '                        errStr += dtErr.Rows[0][DefColumns.FROM_COUNTRY].ToString();', '                        errStr += dtErr.Rows[0][DefColumns.TO_CITY].ToString();', '                        for (int i = 0; i < n; i++) {', '                            string cpStr = "";', '                            cpStr += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.FROM_COUNTRY)).ToString();', '                            cpStr += siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.TO_CITY)).ToString();', '                            if (errStr == cpStr) { }', '                        }', '                    }', '                }', '            }', '        }'];
const c858 = 'RAW(iCount > 0) && !(RAW(response.DataSet.Tables[0].Rows[0][0].ToString() == "S")) && (RAW(errCode == "99010") || RAW(errCode == "99020")) && RAW(errStr == cpStr) && RAW(errCode == "99010")';
const c861 = 'RAW(iCount > 0) && !(RAW(response.DataSet.Tables[0].Rows[0][0].ToString() == "S")) && (RAW(errCode == "99010") || RAW(errCode == "99020")) && RAW(errStr == cpStr) && !(RAW(errCode == "99010")) && RAW(errCode == "99020")';
const sh = S.saveErrShape(c858, sv, 'SaveData');
eq('오류코드 변수', sh && sh.codeVar, 'errCode'); eq('오류코드 집합(넓히지 않음)', sh && sh.codes, ['99010', '99020']); eq('행 일치 칸', sh && sh.keyCols, ['FROM_COUNTRY', 'TO_CITY']); eq('남은 RAW 없음', sh && sh.other, []);
eq('99010 규칙', (S.codeForRule(c858, sh) || {}).code, '99010');
eq('99020 규칙', (S.codeForRule(c861, S.saveErrShape(c861, sv, 'SaveData')) || {}).code, '99020');
eq('불일치 행은 거짓', S.bindSaveErr(c858, sh, '99010', false).includes('RAW('), false);
eq('남은 RAW 있으면 평가 불가', S.codeForRule(c858 + ' && RAW(foo(x))', S.saveErrShape(c858 + ' && RAW(foo(x))', sv, 'SaveData')), null);
eq('가드 오류코드', S.guardCodes('if (iCount > 0) ▸ else of (x == "S") ▸ if (errCode == "99010" || errCode == "99020")'), { codeVar: 'errCode', codes: ['99010', '99020'] });
eq('else 가드는 대상 아님', S.guardCodes('else of (errCode == "99010" || errCode == "99020")'), null);
eq('오류코드 변수 출처 줄', S.codeVarFromCell00(sv, 'SaveData', 'errCode'), 11);
const smp = { code: '0', message: 'success', result: { O_RESULT_CURSOR: [{ MSG: 'SUCCESS', RESULT_CNT: 1, CODE: '0', RESULT_CODE: 'S', EVENT: 1 }], DATARESULT: [] } };
const fb = S.fakeErrBody(smp, '99010', { ROUTE_ID: '5942', FROM_COUNTRY: 'KR', CRUD_TYPE: 'U' }, '[99010] 표지');
const r0 = fb.body.result.O_RESULT_CURSOR[0];
eq('가짜 응답 CODE ≠ 0', r0.CODE, '-1'); eq('성공 리터럴 뒤집음', r0.RESULT_CODE, 'F'); eq('오류코드 열', r0.ERR_CODE, '99010'); eq('행 값 실음', [r0.ROUTE_ID, r0.FROM_COUNTRY, r0.CRUD_TYPE], ['5942', 'KR', undefined]); eq('성공 표본 = 형식 근거 없음', fb.shapeKnown, false); eq('원본 표본 안 바뀜', smp.result.O_RESULT_CURSOR[0].CODE, '0');
const fb2 = S.fakeErrBody({ result: { O_RESULT_CURSOR: [{ CODE: '-1', MSG: 'x', ERR_CODE: '99020' }] } }, '99010', {}, 'm');
eq('오류 표본 = 형식 근거 있음', [fb2.shapeKnown, fb2.body.result.O_RESULT_CURSOR[0].ERR_CODE, fb2.body.result.O_RESULT_CURSOR[0].ERROR_CODE], [true, '99010', undefined]);
eq('결과 배열 없으면 null', S.fakeErrBody({ a: 1 }, '1', {}, 'm'), null);

// 실제 AS-IS 원문(있을 때만) — SCP0005 화면 원문으로 같은 결과인지
const cs = path.join(__dirname, '..', '..', '..', 'GSCM', '06.UIL', 'GSCM.SCP.Forms.UIL', 'Master', 'SCP0005_DistributionRoute', 'SCP0005_DistributionRoute.cs');
if (fs.existsSync(cs)) {
  const L = fs.readFileSync(cs, 'utf8').split(/\r?\n/);
  const rb = S.bindLocalNum(L, 'CheckValid', 'intPRIORITY'); eq('[원문] intPRIORITY 칸', rb && [rb.col, rb.emptyAs], ['PRIORITY', '0']);
  const rs = S.saveErrShape(c858, L, 'SaveData'); eq('[원문] 오류코드', rs && rs.codes, ['99010', '99020']); eq('[원문] 남은 RAW', rs && rs.other, []);
  const ad = S.afterDialogMsg(L, 'btnEaxel_Upload_Click', 'MSG00265'); eq('[원문] 업로드 창 뒤 메시지', ad && [ad.dialogLine + 1, ad.msgLine + 1, ad.popup], [379, 381, 'ExcelUploadForm2']);
  const ml = L.findIndex(l => l.includes('"MSG00209"')); eq('[원문] MSG00209 인자', (S.callArgs(L[ml], 'MSG00209') || []).map(a => S.evalArg(a)), ['Total L/T', '999']);
  eq('[원문] MSG00209 조건 연산자 >', /Int64\.Parse\(strLtSum\)\s*>\s*999/.test(L[ml - 1] + L[ml - 2]), true);
}
let bad = 0; for (const [n, got, want] of cases) { const ok = got === want; if (!ok) bad++; console.log(`${ok ? 'OK ' : 'NG '} ${n} → ${got}${ok ? '' : ` (기대 ${want})`}`); }
console.log(`${cases.length - bad}/${cases.length}`); process.exit(bad ? 1 : 0);
