// 2026-11-23 사용자: ID 입력칸은 한글 입력 상태에서도 영문 대문자로. VS Code 입력창은 한/영 상태를 바꿀 수 없어
//   입력하는 즉시 값 변환: 한글 자모 → 두벌식 자판의 같은 키 영문 → 대문자. 예) 한글 상태로 'ㅇㅡㄹ0082' 입력 → 'DMF0082'
//   toId(s)          : 변환 함수(확장, 웹뷰 공용. webviewSnippet 이 같은 표를 웹뷰에 넣음)
//   askId(vscode, o) : showInputBox 대신 쓰는 ID 입력창(createInputBox + 입력 즉시 변환). 반환 = 입력값(취소 undefined)
//   bindQuickPick(qp): QuickPick 입력칸에 같은 변환을 붙임
'use strict';

// 두벌식 자모 → 키(대문자로 바꾸므로 Shift 여부는 쌍자음 키 하나로 둠)
const JAMO = { 'ㅂ': 'q', 'ㅈ': 'w', 'ㄷ': 'e', 'ㄱ': 'r', 'ㅅ': 't', 'ㅛ': 'y', 'ㅕ': 'u', 'ㅑ': 'i', 'ㅐ': 'o', 'ㅔ': 'p', 'ㅁ': 'a', 'ㄴ': 's', 'ㅇ': 'd', 'ㄹ': 'f', 'ㅎ': 'g', 'ㅗ': 'h', 'ㅓ': 'j', 'ㅏ': 'k', 'ㅣ': 'l', 'ㅋ': 'z', 'ㅌ': 'x', 'ㅊ': 'c', 'ㅍ': 'v', 'ㅠ': 'b', 'ㅜ': 'n', 'ㅡ': 'm',
  'ㅃ': 'q', 'ㅉ': 'w', 'ㄸ': 'e', 'ㄲ': 'r', 'ㅆ': 't', 'ㅒ': 'o', 'ㅖ': 'p',
  'ㅘ': 'hk', 'ㅙ': 'ho', 'ㅚ': 'hl', 'ㅝ': 'nj', 'ㅞ': 'np', 'ㅟ': 'nl', 'ㅢ': 'ml',
  'ㄳ': 'rt', 'ㄵ': 'sw', 'ㄶ': 'sg', 'ㄺ': 'fr', 'ㄻ': 'fa', 'ㄼ': 'fq', 'ㄽ': 'ft', 'ㄾ': 'fx', 'ㄿ': 'fv', 'ㅀ': 'fg', 'ㅄ': 'qt' };
const CHO = 'ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ';
const JUNG = 'ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ';
const JONG = ['', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'];

function toId(s) {
  let out = '';
  for (const ch of String(s == null ? '' : s)) {
    const c = ch.codePointAt(0);
    if (c >= 0xAC00 && c <= 0xD7A3) { const n = c - 0xAC00; out += JAMO[CHO[Math.floor(n / 588)]] + JAMO[JUNG[Math.floor((n % 588) / 28)]] + (JONG[n % 28] ? JAMO[JONG[n % 28]] : ''); }
    else out += JAMO[ch] || ch;
  }
  return out.toUpperCase();
}

// 2026-11-23 사용자: Workbench UI_ID 에 한글 자판으로 DMF 를 치면 'DDMDMF'. VS Code 입력창은 한글 조합 중에 값을 바꾸면 조합 중인 글자를 다시 붙임
//   (ㅇ → D, 으 → D + DM, 을 → DDM + DMF). 확장은 조합 중인지 알 수 없으므로 값 끝이 한글(조합 중)이면 건드리지 않고,
//   숫자, 영문을 이어 쳐서 조합이 끝난 때 전체를 바꿈. Enter 와 목록의 '로 지정' 항목은 toId 값을 씀
const HANGUL_END = /[ㄱ-ㆎ가-힣]$/;
function settled(v) { return HANGUL_END.test(String(v || '')) ? null : toId(v); }
function bindQuickPick(qp) {
  return qp.onDidChangeValue(v => { const t = settled(v); if (t !== null && t !== v) qp.value = t; });
}

/** showInputBox 와 같은 옵션(prompt, value, placeHolder, ignoreFocusOut, validateInput, title)을 받는 ID 입력창 */
function askId(vscode, o = {}) {
  return new Promise(resolve => {
    const ib = vscode.window.createInputBox(); let done = false;
    const end = v => { if (done) return; done = true; resolve(v); ib.hide(); };
    ib.title = o.title || ''; ib.prompt = o.prompt || ''; ib.placeholder = o.placeHolder || ''; ib.ignoreFocusOut = !!o.ignoreFocusOut;
    ib.value = toId(o.value || '');
    const check = v => { const m = o.validateInput ? o.validateInput(v) : null; ib.validationMessage = m || ''; return !m; };
    ib.onDidChangeValue(v => { const t = settled(v); if (t === null) { ib.validationMessage = ''; ib.prompt = `${o.prompt || ''} → ${toId(v)}`.trim(); return; } ib.prompt = o.prompt || ''; if (t !== v) { ib.value = t; return; } check(t); });
    ib.onDidAccept(() => { const t = toId(ib.value); if (check(t)) end(t); });
    ib.onDidHide(() => { end(undefined); ib.dispose(); });
    ib.show();
  });
}

/** 웹뷰 스크립트에 넣을 코드: idInput(el) = 그 입력칸을 ID 입력칸으로(한글 → 영문 대문자, 커서 위치 유지) */
function webviewSnippet() {
  return `const ID_J=${JSON.stringify(JAMO)},ID_C=${JSON.stringify(CHO)},ID_U=${JSON.stringify(JUNG)},ID_T=${JSON.stringify(JONG)};
function toId(s){let o='';for(const ch of String(s==null?'':s)){const c=ch.codePointAt(0);if(c>=0xAC00&&c<=0xD7A3){const n=c-0xAC00;o+=ID_J[ID_C[Math.floor(n/588)]]+ID_J[ID_U[Math.floor((n%588)/28)]]+(ID_T[n%28]?ID_J[ID_T[n%28]]:'');}else o+=ID_J[ch]||ch;}return o.toUpperCase();}
function idInput(el){if(!el||el._idIn)return;el._idIn=1;el.setAttribute('autocapitalize','characters');el.setAttribute('spellcheck','false');
const fix=()=>{const v=el.value,t=toId(v);if(t===v)return;const p=el.selectionStart==null?t.length:toId(v.slice(0,el.selectionStart)).length;el.value=t;try{el.setSelectionRange(p,p);}catch(e){}};
el.addEventListener('compositionstart',()=>{setTimeout(()=>{el.blur();el.focus();fix();},0);});
el.addEventListener('compositionend',fix);el.addEventListener('input',e=>{if(!e.isComposing)fix();});}`;
}

module.exports = { toId, settled, askId, bindQuickPick, webviewSnippet, JAMO };
