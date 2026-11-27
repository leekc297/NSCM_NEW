// 웹뷰 공용 모듈 시험(2026-11-26 개선안 20261126164322_SELF): webview-kit.js 마크다운 렌더, Ctrl+A 범위, 경계 막대, 글래스 CSS
//   웹뷰 4개 파일(jobs, orchestra, workbench, history)이 복사본 없이 공용 모듈을 쓰는지, 규칙 점검 지시문에 공용 모듈이 있는지도 봄
//   사용: node test/t_webview_kit.js <VibeManager 폴더>
'use strict';
const path = require('path'); const fs = require('fs'); const vm = require('vm');
const Module = require('module'); const orig = Module._load; Module._load = function (r, ...a) { return r === 'vscode' ? new Proxy({}, { get: () => () => { } }) : orig.call(this, r, ...a); };
const dir = path.resolve(process.argv[2] || path.join(__dirname, '..'));
let ok = true; const chk = (n, c, x) => { console.log(c ? 'PASS' : 'FAIL', n, x || ''); if (!c) ok = false; };
const NL = String.fromCharCode(10), BT = String.fromCharCode(96);
const kit = require(path.join(dir, 'webview-kit.js'));

// 1. 마크다운 렌더 표본
const md = kit.mdHtml;
chk('md 표', md(['| A | B |', '|---|---|', '| 1 | **2** |'].join(NL)) === '<div class="mdtw"><table class="mdt"><thead><tr><th>A</th><th>B</th></tr></thead><tbody><tr><td>1</td><td><b>2</b></td></tr></tbody></table></div>');
chk('md 목록 중첩', md(['- a', '  - b', '- c'].join(NL)) === '<ul class="mdlist"><li>a<ul class="mdlist"><li>b</li></ul></li><li>c</li></ul>', md(['- a', '  - b', '- c'].join(NL)));
chk('md 번호 목록 시작 번호', md('3. x') === '<ol start="3" class="mdlist"><li>x</li></ol>', md('3. x'));
chk('md 제목, 구분선', md(['## 제목', '---'].join(NL)) === '<div class="mdh mdh2">제목</div><hr class="mdhr">');
chk('md 코드 블록 글자 그대로', md([BT + BT + BT, '<b>x</b>', BT + BT + BT].join(NL)) === '<pre class="mdpre"><code>&lt;b&gt;x&lt;/b&gt;</code></pre>');
chk('md 글 안 HTML 은 글자', md('<script>a</script>') === '<p class="mdp">&lt;script&gt;a&lt;/script&gt;</p>');
chk('md 링크, 인라인 코드', md('[f](a.js#L3) ' + BT + 'x<y' + BT) === '<p class="mdp"><a class="mdl" href="#" data-href="a.js#L3">f</a> <code class="mdc">x&lt;y</code></p>', md('[f](a.js#L3) ' + BT + 'x<y' + BT));
chk('md 인용, CR 제거', md('> q' + String.fromCharCode(13) + NL + '> r') === '<blockquote class="mdq">q<br>r</blockquote>');

// 2. 브라우저 코드(script())를 가짜 DOM 에서 실행: 마크다운 결과가 Node 와 같고, Ctrl+A 가 마지막으로 누른 창만 고름
function fakeDom() {
  const h = {}; const sel = { ranges: [], removeAllRanges() { this.ranges = []; }, addRange(r) { this.ranges.push(r); }, toString() { return this.ranges.map(r => r.node.text).join(''); } };
  const mkEl = (cls, text, shown) => ({ cls, text, isConnected: true, getClientRects: () => (shown === false ? [] : [1]), closest(s) { return s === cls ? this : null; }, classList: { set: new Set(), add(c) { this.set.add(c); }, remove(c) { this.set.delete(c); } } });
  const document = {
    body: { tagName: 'BODY' }, activeElement: null, execCalls: [],
    addEventListener(t, f) { (h[t] = h[t] || []).push(f); },
    createRange: () => ({ selectNodeContents(n) { this.node = n; } }),
    execCommand(cmd) { document.execCalls.push(cmd); return 'native'; },
  };
  document.activeElement = document.body;
  const window = { getSelection: () => sel };
  const fire = (t, e) => (h[t] || []).forEach(f => f(e));
  return { document, window, sel, mkEl, fire };
}
{
  const d = fakeDom(); const ctx = vm.createContext({ document: d.document, window: d.window, String, Math, parseInt });
  vm.runInContext(kit.script() + NL + "var pick=kitSelScope('.log');kitSelAll(pick);", ctx);
  chk('script(): 마크다운 결과가 Node 함수와 같음', vm.runInContext('mdHtml(' + JSON.stringify(['# t', '| a |', '|-|', '| 1 |', '- x'].join(NL)) + ')', ctx) === md(['# t', '| a |', '|-|', '| 1 |', '- x'].join(NL)));
  const log = d.mkEl('.log', 'LOGTEXT'); const other = d.mkEl('.etc', 'OTHER');
  let prevented = 0; const key = (target) => ({ ctrlKey: true, metaKey: false, shiftKey: false, altKey: false, key: 'a', target, preventDefault() { prevented++; } });
  d.fire('pointerdown', { target: other }); d.fire('keydown', key(other));
  chk('Ctrl+A: 로그 창 밖을 눌렀으면 기본 동작', prevented === 0 && d.sel.ranges.length === 0);
  d.fire('pointerdown', { target: log }); d.fire('keydown', key(log));
  chk('Ctrl+A: 마지막으로 누른 로그 창 글만 선택', prevented === 1 && d.sel.toString() === 'LOGTEXT');
  d.document.activeElement = { tagName: 'INPUT' }; d.sel.removeAllRanges(); d.fire('keydown', key(log));
  chk('Ctrl+A: 입력칸 포커스면 기본 동작', prevented === 1 && d.sel.ranges.length === 0);
  d.document.activeElement = d.document.body;
  chk('본체 selectAll 명령: 로그 창이 대상이면 가로챔', vm.runInContext("document.execCommand('selectAll')", ctx) === true && d.document.execCalls.length === 0 && d.sel.toString() === 'LOGTEXT');
  chk('본체 copy 명령은 그대로 넘김', vm.runInContext("document.execCommand('copy')", ctx) === 'native' && d.document.execCalls.join() === 'copy');
  d.fire('pointerdown', { target: other });
  chk('본체 selectAll 명령: 로그 창 밖이면 그대로 넘김', vm.runInContext("document.execCommand('selectAll')", ctx) === 'native');
  // 경계 막대 끌기
  const sp = d.mkEl('.sp', ''); let cap = 0, moved = 0, ended = 0; sp.setPointerCapture = () => { cap++; }; let pd = 0;
  ctx.sp = sp; ctx.ev = { pointerId: 1, preventDefault() { pd++; } }; ctx.mv = () => { moved++; }; ctx.en = () => { ended++; };
  vm.runInContext('kitDrag(sp,ev,mv,en)', ctx);
  chk('kitDrag: 시작 = 기본 동작 막음, 캡처, .drag', pd === 1 && cap === 1 && sp.classList.set.has('drag') && typeof sp.onpointermove === 'function');
  sp.onpointermove({}); sp.onpointerup({});
  chk('kitDrag: 놓으면 처리기 해제, .drag 제거, end 호출', moved === 1 && ended === 1 && sp.onpointermove === null && sp.onpointerup === null && !sp.classList.set.has('drag'));
}
chk('script(): 백틱, ${ 없음(웹뷰 템플릿 문자열 안에 넣어도 안전)', !kit.script().includes(BT) && !kit.script().includes('${'));
chk("script(['drag']): kitDrag 만", kit.script(['drag']).includes('function kitDrag') && !kit.script(['drag']).includes('function mdHtml'));
chk('glassCss: :root, body, .glass, 투명도 줄이기', /^:root\{--fg:/.test(kit.glassCss()) && kit.glassCss().includes('.glass{background:var(--g1)') && kit.glassCss().includes('prefers-reduced-transparency') && !kit.glassCss(false).includes('prefers-reduced-transparency'));

// 3. 웹뷰 파일에 복사본이 없고 공용 모듈을 씀
const src = f => fs.readFileSync(path.join(dir, f), 'utf8');
const files = ['jobs.js', 'orchestra.js', 'workbench.js', 'history.js'];
const cnt = (re) => files.map(f => (src(f).match(re) || []).length).reduce((a, b) => a + b, 0);
chk('function mdHtml 복사본 0', cnt(/function mdHtml\(/g) === 0, String(cnt(/function mdHtml\(/g)));
chk('selectAll 가로채기 복사본 0', cnt(/document\.execCommand=function/g) === 0, String(cnt(/document\.execCommand=function/g)));
chk('setPointerCapture 복사본 0', cnt(/setPointerCapture/g) === 0, String(cnt(/setPointerCapture/g)));
chk('.glass 기본 규칙 복사본 0', cnt(/\.glass\{background:var\(--g1\);border:1px solid var\(--gb\);border-radius:12px/g) === 0);
for (const f of files) chk(`${f}: webview-kit.js 사용`, src(f).includes("require('./webview-kit')"));
// 4. 규칙 점검이 공용 모듈을 먼저 봄
try { const u = require(path.join(dir, 'orch-userrule.js')); u.init({ paths: () => ({ root: dir, vibeDir: path.join(dir, '.vibe') }) });
  chk('orch-userrule SCOPE_FILES 맨 앞 = webview-kit.js', u.SCOPE_FILES[0] === 'webview-kit.js');
  chk('orch-userrule 지시문에 공용 모듈 묶음 지시', /webview-kit\.js 로 한 1건으로 묶는다/.test(u.buildPrompt([])));
} catch (e) { chk('orch-userrule 불러오기', false, e.message); }
console.log(ok ? 'ALL PASS' : 'SOME FAIL'); process.exit(ok ? 0 : 1);
