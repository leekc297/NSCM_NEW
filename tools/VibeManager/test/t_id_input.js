// id-input.js 시험: 한글 자모 → 영문 대문자 ID 변환, VS Code 입력창(askId, QuickPick) 입력 즉시 변환. 사용: node test/t_id_input.js <VibeManager 폴더>
// 2026-11-23 사용자: ID 신규입력은 한글 입력 상태에서도 영문 대문자로
const path = require('path'); const vm = require('vm');
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
const ii = require(path.join(dir, 'id-input'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };

// 1. 변환 표: 한글 상태에서 친 키 → 같은 자리 영문 대문자
for (const [a, b] of [['을0082', 'DMF0082'], ['ㄴ체0104', 'SCP0104'], ['ㄴ네0020', 'SSP0020'], ['ㅇ', 'D'], ['으', 'DM'], ['dmf0082', 'DMF0082'], ['DMF0082', 'DMF0082'], ['ㄴ체0111 ㄴ네0014, 을0042', 'SCP0111 SSP0014, DMF0042'], ['', '']])
  chk(`toId ${JSON.stringify(a)} → ${b}`, ii.toId(a) === b, ii.toId(a));

// 2. VS Code 입력창 흉내: value 를 바꾸면 onDidChangeValue 가 다시 불림
function fakeBox() {
  const ev = { change: [], accept: [], hide: [] }; let val = '';
  const box = { title: '', prompt: '', placeholder: '', ignoreFocusOut: false, validationMessage: '', shown: false,
    get value() { return val; }, set value(v) { val = v; for (const f of ev.change) f(v); },
    onDidChangeValue: f => { ev.change.push(f); return { dispose() { } }; }, onDidAccept: f => ev.accept.push(f), onDidHide: f => ev.hide.push(f),
    show() { this.shown = true; }, hide() { for (const f of ev.hide) f(); }, dispose() { },
    type(v) { this.value = v; }, accept() { for (const f of ev.accept) f(); } };
  return box;
}
(async () => {
  let box; const vscode = { window: { createInputBox: () => (box = fakeBox()) } };
  const pr = ii.askId(vscode, { prompt: '화면 ID 입력', value: '', validateInput: v => v && !/^[A-Z]{2,4}[0-9]{2,6}$/.test(v) ? '형식' : null });
  box.type('을'); chk('askId: 한글 조합 중(끝 한글) = 값 그대로, 안내에 변환 값', box.value === '을' && /→ DMF/.test(box.prompt), box.value + ' ' + box.prompt);
  box.type('을0082'); chk('askId: 숫자를 이어 치면(조합 끝) 영문 대문자', box.value === 'DMF0082', box.value);
  box.type('DMF0'); chk('askId: 형식 미달이면 안내 문구', box.validationMessage === '형식', box.validationMessage);
  box.type('dmf0082'); chk('askId: 소문자도 대문자로', box.value === 'DMF0082' && box.validationMessage === '', box.value);
  box.accept(); chk('askId: Enter = 입력값 반환', (await pr) === 'DMF0082');
  const pr2 = ii.askId(vscode, { value: 'scp0104' }); chk('askId: 시작 값도 변환', box.value === 'SCP0104'); box.hide(); chk('askId: 취소 = undefined', (await pr2) === undefined);
  const qp = fakeBox(); ii.bindQuickPick(qp); qp.type('ㄴ체'); chk('QuickPick: 조합 중 = 그대로', qp.value === 'ㄴ체', qp.value); qp.type('ㄴ체0104'); chk('QuickPick: 조합 끝 = 변환', qp.value === 'SCP0104', qp.value);
  const pr3 = ii.askId(vscode, {}); box.type('을'); box.accept(); chk('askId: 한글로 끝난 채 Enter = 변환 값 반환', (await pr3) === 'DMF');
  // 3. 웹뷰 코드 구문 + 같은 변환
  const js = ii.webviewSnippet(); let fn = null;
  try { const ctx = {}; vm.createContext(ctx); vm.runInContext(js + ';this.f=toId;', ctx); fn = ctx.f; } catch (e) { chk('웹뷰 코드 구문', false, e.message); }
  chk('웹뷰 toId = 확장 toId', !!fn && fn('을0082') === 'DMF0082' && fn('ㄴ체0104 ㄴ네0020') === 'SCP0104 SSP0020');
  console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
})();
