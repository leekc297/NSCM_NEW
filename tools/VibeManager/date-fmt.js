// 2026-11-23 사용자 지시: VM 의 모든 일자는 Windows 일자 형식(제어판 지역 설정 짧은 날짜, 지금 yyyy-MM-dd)에 맞춤.
//   pattern() = HKCU\Control Panel\International sShortDate(한 번 읽어 둠, 못 읽으면 yyyy-MM-dd)
//   fmtDate(x) = 일자만 · fmtDT(x) = 일자 + HH:mm · fmtDT(x, true) = 일자 + HH:mm:ss
//   x = Date, ms 숫자, 'YYYY-MM-DD[THH:mm[:ss]]', 'YYYY.MM.DD' 같은 문자열(시간대 변환 없이 적힌 값 그대로)
//   webviewSnippet() = 웹뷰 스크립트에 넣는 같은 함수(fmtD(x, sec), fmtDay(x), DATE_PAT)
//   저장 값(기록 파일의 at, ms)은 바꾸지 않고 화면에 보일 때만 이 함수로 바꿈
'use strict';
const cp = require('child_process');
let PAT = null;
function pattern() {
  if (PAT) return PAT;
  PAT = 'yyyy-MM-dd';
  if (process.platform === 'win32') {
    try {
      const o = cp.execFileSync('reg', ['query', 'HKCU\\Control Panel\\International', '/v', 'sShortDate'], { encoding: 'utf8', timeout: 3000, windowsHide: true });
      const m = /sShortDate\s+REG_SZ\s+(.+)/.exec(o); if (m && m[1].trim()) PAT = m[1].trim();
    } catch { /* 레지스트리를 못 읽으면 yyyy-MM-dd */ }
  }
  return PAT;
}
const z2 = n => String(n).padStart(2, '0');
/** 값 → { y, M, d, H, m, s, t(시각 있음) } · 못 읽으면 null */
function parts(x) {
  if (x == null || x === '') return null;
  if (x instanceof Date || typeof x === 'number') { const d = x instanceof Date ? x : new Date(x); if (isNaN(d.getTime())) return null; return { y: d.getFullYear(), M: d.getMonth() + 1, d: d.getDate(), H: d.getHours(), m: d.getMinutes(), s: d.getSeconds(), t: true }; }
  const s = String(x).trim(); const r = /^(\d{4})[-./](\d{1,2})[-./](\d{1,2})(?:[T ](\d{1,2}):(\d{2})(?::(\d{2}))?)?/.exec(s);
  if (r) return { y: +r[1], M: +r[2], d: +r[3], H: +(r[4] || 0), m: +(r[5] || 0), s: +(r[6] || 0), t: r[4] != null };
  const d = new Date(s); if (isNaN(d.getTime())) return null; return parts(d);
}
function applyPat(p, pat) {
  let out = ''; const P = pat || pattern();
  for (let i = 0; i < P.length;) {
    if (P[i] === "'") { const j = P.indexOf("'", i + 1); out += P.slice(i + 1, j < 0 ? P.length : j); i = j < 0 ? P.length : j + 1; continue; }
    const tok = /^(yyyy|yy|MM|M|dd|d)/.exec(P.slice(i));
    if (tok) { const t = tok[1]; out += t === 'yyyy' ? String(p.y) : t === 'yy' ? z2(p.y % 100) : t === 'MM' ? z2(p.M) : t === 'M' ? String(p.M) : t === 'dd' ? z2(p.d) : String(p.d); i += t.length; continue; }
    out += P[i]; i++;
  }
  return out;
}
function fmtDate(x) { const p = parts(x); return p ? applyPat(p) : String(x == null ? '' : x); }
function fmtDT(x, sec) { const p = parts(x); if (!p) return String(x == null ? '' : x); return applyPat(p) + (p.t ? ` ${z2(p.H)}:${z2(p.m)}${sec ? ':' + z2(p.s) : ''}` : ''); }
/** 웹뷰 스크립트용: DATE_PAT, fmtD(x, sec), fmtDay(x) (확장과 같은 규칙) */
function webviewSnippet() {
  return `const DATE_PAT=${JSON.stringify(pattern())};
function _dz(n){return String(n).padStart(2,'0');}
function _dp(x){ if(x==null||x==='') return null; if(typeof x==='number'||x instanceof Date){ const d=new Date(x); if(isNaN(d.getTime())) return null; return {y:d.getFullYear(),M:d.getMonth()+1,d:d.getDate(),H:d.getHours(),m:d.getMinutes(),s:d.getSeconds(),t:true}; } const s=String(x).trim(); const r=/^(\\d{4})[-./](\\d{1,2})[-./](\\d{1,2})(?:[T ](\\d{1,2}):(\\d{2})(?::(\\d{2}))?)?/.exec(s); if(r) return {y:+r[1],M:+r[2],d:+r[3],H:+(r[4]||0),m:+(r[5]||0),s:+(r[6]||0),t:r[4]!=null}; const d=new Date(s); return isNaN(d.getTime())?null:_dp(d); }
function _dpat(p){ let o='',P=DATE_PAT; for(let i=0;i<P.length;){ if(P[i]==="'"){ const j=P.indexOf("'",i+1); o+=P.slice(i+1,j<0?P.length:j); i=j<0?P.length:j+1; continue; } const t=(/^(yyyy|yy|MM|M|dd|d)/.exec(P.slice(i))||[])[1]; if(t){ o+=t==='yyyy'?String(p.y):t==='yy'?_dz(p.y%100):t==='MM'?_dz(p.M):t==='M'?String(p.M):t==='dd'?_dz(p.d):String(p.d); i+=t.length; continue; } o+=P[i]; i++; } return o; }
function fmtDay(x){ const p=_dp(x); return p?_dpat(p):String(x==null?'':x); }
function fmtD(x,sec){ const p=_dp(x); if(!p) return String(x==null?'':x); return _dpat(p)+(p.t?' '+_dz(p.H)+':'+_dz(p.m)+(sec?':'+_dz(p.s):''):''); }`;
}
module.exports = { pattern, parts, fmtDate, fmtDT, webviewSnippet, applyPat };
