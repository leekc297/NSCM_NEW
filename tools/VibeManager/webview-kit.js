// 2026-11-26 개선안 20261126164322_SELF (L3, 묶음 S-W): VM 웹뷰 공용 모듈
//   jobs.js, orchestra.js, workbench.js, history.js 가 파일마다 복사해 쓰던 같은 동작을 한 곳에 둠
//   ① 마크다운 렌더(mdEsc, mdInline, mdHtml): 종전 jobs.js:483~531, orchestra.js:993~1041, workbench.js:2445~2493 와 같은 코드
//   ② Ctrl+A 범위(kitSelVisible, kitSelRange, kitSelScope, kitSelAll): 마지막으로 누른 로그 창, 파일 탭 글만 선택.
//      VS Code 본체가 보내는 selectAll 명령(document.execCommand)도 같은 대상으로 처리
//   ③ 경계 막대 끌기(kitDrag): pointer capture, .drag 표시, 끝낼 때 처리기 해제
//   ④ 글래스 CSS(glassCss): :root 변수, body 배경, .glass 규칙(종전 orchestra.js:73~75, history.js:185~188)
//   사용: 웹뷰 HTML 템플릿 안에서 ${require('./webview-kit').script()} , ${require('./webview-kit').glassCss()}
//   함수는 Node 에서도 부를 수 있음(test/t_webview_kit.js). 브라우저 코드는 함수 원문(toString)을 그대로 끼워 넣음
//   여러 웹뷰에 같은 원인의 문제가 있으면 이 파일 1곳을 고친다(orch-userrule.js 규칙 점검 지시문)
'use strict';

const MD_BT = String.fromCharCode(96);
function mdEsc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');}
function mdInline(s){
  const parts=String(s).split(MD_BT);let out='';
  for(let i=0;i<parts.length;i++){
    if(i%2===1&&i<parts.length-1){out+='<code class="mdc">'+mdEsc(parts[i])+'</code>';continue;}
    let t=mdEsc(i%2===1?MD_BT+parts[i]:parts[i]);
    t=t.replace(/[*][*]([^*]+)[*][*]/g,'<b>$1</b>');
    t=t.replace(/\[([^\]]+)\]\(([^)\s]+)\)/g,(m0,a,h)=>'<a class="mdl" href="#" data-href="'+h+'">'+a+'</a>');
    out+=t;
  }
  return out;
}
function mdHtml(src){
  const L=String(src||'').replace(/\r/g,'').split('\n');const fence=MD_BT+MD_BT+MD_BT;const stack=[];let h='';let i=0;
  const close=lvl=>{while(stack.length>lvl)h+='</li></'+stack.pop()+'>';};
  const isList=s=>/^( *)([-*+]|[0-9]+[.)]) +/.test(s);
  while(i<L.length){
    const ln=L[i];const tr=ln.trim();
    if(tr.startsWith(fence)){close(0);const buf=[];i++;while(i<L.length&&!L[i].trim().startsWith(fence)){buf.push(L[i]);i++;}i++;h+='<pre class="mdpre"><code>'+mdEsc(buf.join('\n'))+'</code></pre>';continue;}
    if(!tr){if(!(stack.length&&i+1<L.length&&isList(L[i+1])))close(0);i++;continue;}
    let m=/^(#{1,6}) +(.*)$/.exec(ln);
    if(m){close(0);h+='<div class="mdh mdh'+Math.min(m[1].length,4)+'">'+mdInline(m[2])+'</div>';i++;continue;}
    if(/^ *([-*_])( *[-*_]){2,} *$/.test(ln)&&!/[^-*_ ]/.test(ln)){close(0);h+='<hr class="mdhr">';i++;continue;}
    if(tr.startsWith('|')&&i+1<L.length&&/^ *[|]?[ :|-]+[|]? *$/.test(L[i+1])&&L[i+1].includes('-')){
      close(0);const row=s=>s.trim().replace(/^[|]/,'').replace(/[|]$/,'').split('|').map(c=>c.trim());
      let t='<div class="mdtw"><table class="mdt"><thead><tr>'+row(ln).map(c=>'<th>'+mdInline(c)+'</th>').join('')+'</tr></thead><tbody>';i+=2;
      while(i<L.length&&L[i].trim().startsWith('|')){t+='<tr>'+row(L[i]).map(c=>'<td>'+mdInline(c)+'</td>').join('')+'</tr>';i++;}
      h+=t+'</tbody></table></div>';continue;}
    m=/^( *)([-*+]|[0-9]+[.)]) +(.*)$/.exec(ln);
    if(m){
      const lvl=Math.floor(m[1].length/2)+1;const ty=/[0-9]/.test(m[2])?'ol':'ul';const stt=ty==='ol'?' start="'+parseInt(m[2],10)+'"':'';
      if(stack.length<lvl){while(stack.length<lvl){h+='<'+ty+(stack.length===lvl-1?stt:'')+' class="mdlist">';stack.push(ty);}}
      else{close(lvl);if(stack[lvl-1]!==ty){h+='</li></'+stack.pop()+'><'+ty+stt+' class="mdlist">';stack.push(ty);}else h+='</li>';}
      h+='<li>'+mdInline(m[3]);i++;continue;}
    if(/^> ?/.test(ln)){close(0);const buf=[];while(i<L.length&&/^> ?/.test(L[i])){buf.push(L[i].replace(/^> ?/,''));i++;}h+='<blockquote class="mdq">'+buf.map(mdInline).join('<br>')+'</blockquote>';continue;}
    if(stack.length&&/^ {2,}/.test(ln)){h+='<br>'+mdInline(tr);i++;continue;}
    close(0);const buf=[ln];i++;
    while(i<L.length&&L[i].trim()&&!/^(#{1,6} |> ?)/.test(L[i])&&!isList(L[i])&&!L[i].trim().startsWith('|')&&!L[i].trim().startsWith(fence)){buf.push(L[i]);i++;}
    h+='<p class="mdp">'+buf.map(mdInline).join('<br>')+'</p>';
  }
  close(0);return h;
}

// Ctrl+A 범위. 대상 창이 화면에 보일 때만 그 창 글을 선택하고 true. 입력칸(INPUT, TEXTAREA, SELECT, 편집 가능 영역)은 브라우저 기본 동작
function kitSelVisible(L){return !!(L&&L.isConnected&&L.getClientRects().length>0);}
function kitSelRange(c){const a=document.activeElement;if(a&&a!==document.body&&a.blur)a.blur();
  const r=document.createRange();r.selectNodeContents(c);const s=window.getSelection();s.removeAllRanges();s.addRange(r);return s;}
// selector 에 맞는 창을 마지막으로 눌렀는지 기억하고, 그 창 글을 선택하는 함수를 돌려줌
function kitSelScope(selector){let cur=null;
  document.addEventListener('pointerdown',e=>{const t=e.target;cur=(t&&t.closest)?t.closest(selector):null;},true);
  return function(){if(!kitSelVisible(cur))return false;kitSelRange(cur);return true;};}
// pick() 이 true 면 Ctrl+A 기본 동작(창 전체 선택)을 막음. 본체가 포커스를 입력칸으로 되돌린 뒤 보내는 selectAll 명령도 pick() 으로 처리
function kitSelAll(pick){
  document.addEventListener('keydown',e=>{
    if(!(e.ctrlKey||e.metaKey)||e.shiftKey||e.altKey||String(e.key).toLowerCase()!=='a')return;
    const a=document.activeElement;if(a&&(a.tagName==='INPUT'||a.tagName==='TEXTAREA'||a.tagName==='SELECT'||a.isContentEditable))return;
    if(pick())e.preventDefault();
  },true);
  if(typeof document.execCommand!=='function')return;const ex=document.execCommand.bind(document);
  document.execCommand=function(cmd,ui,val){if(String(cmd).toLowerCase()==='selectall'&&pick())return true;return ex(cmd,ui,val);};
}

// 경계 막대 끌기. pointerdown 처리기 안에서 부름. move(ev) = 끄는 동안, end(ev) = 놓을 때(처리기 해제, .drag 제거 뒤)
function kitDrag(sp,e,move,end){e.preventDefault();try{sp.setPointerCapture(e.pointerId);}catch(x){}sp.classList.add('drag');
  sp.onpointermove=move;
  sp.onpointerup=sp.onpointercancel=function(ev){sp.onpointermove=null;sp.onpointerup=sp.onpointercancel=null;sp.classList.remove('drag');if(end)end(ev);};}

const PARTS = {
  md: [mdEsc, mdInline, mdHtml],
  sel: [kitSelVisible, kitSelRange, kitSelScope, kitSelAll],
  drag: [kitDrag],
};
/** 웹뷰 <script> 안에 끼워 넣을 코드. only = ['md','sel','drag'] 중 필요한 것만(기본 전부) */
function script(only) {
  const keys = Array.isArray(only) && only.length ? only : Object.keys(PARTS);
  const out = ['/* webview-kit.js */'];
  if (keys.includes('md')) out.push('const MD_BT=String.fromCharCode(96);');
  for (const k of keys) for (const f of PARTS[k] || []) out.push(f.toString());
  return out.join('\n');
}

const GLASS_VARS = `:root{--fg:var(--vscode-editor-foreground,#ccc);--g1:color-mix(in srgb,var(--fg) 5%,transparent);--g2:color-mix(in srgb,var(--fg) 9%,transparent);--gb:color-mix(in srgb,var(--fg) 14%,transparent);--acc:var(--vscode-charts-blue,#3794ff);--acc2:var(--vscode-charts-purple,#a371f7)}
body{background:radial-gradient(1100px 460px at 8% -12%,color-mix(in srgb,var(--acc) 15%,transparent),transparent 62%),radial-gradient(900px 440px at 104% -6%,color-mix(in srgb,var(--acc2) 12%,transparent),transparent 58%),var(--vscode-editor-background);background-attachment:fixed}
.glass{background:var(--g1);border:1px solid var(--gb);border-radius:12px;-webkit-backdrop-filter:blur(14px) saturate(140%);backdrop-filter:blur(14px) saturate(140%);box-shadow:0 6px 22px rgba(0,0,0,.16)}`;
const GLASS_REDUCE = '@media (prefers-reduced-transparency:reduce){.glass{-webkit-backdrop-filter:none;backdrop-filter:none;background:var(--vscode-editor-background)}}';
/** 글래스 CSS. reduce = false 면 투명도 줄이기 규칙을 빼고 줌(호출한 쪽에 더 넓은 규칙이 있을 때) */
function glassCss(reduce) { return reduce === false ? GLASS_VARS : `${GLASS_VARS}\n${GLASS_REDUCE}`; }

module.exports = { script, glassCss, mdEsc, mdInline, mdHtml, MD_BT };
