// 2026-11-19 VMO P8: 업무 작업창 — 업무 1개(문서 생성 · CheckList 등)를 골라 화면 여러 개에 실행한다.
//   Workbench = 화면 1개의 전 기능 / 업무 작업창 = 업무 1개 × 화면 여러 개 / VMO 창 = 기능·감시.
//   실행기 = job-runner.js(창을 닫아도 작업은 계속 돈다 · 다시 열면 이어서 본다). 화면 목록 = FLOW 대상(flow-panel.js targets) + AS-IS DB 프로그램 목록(버튼).
//   받는 메시지(웹뷰→확장): ready · loadAsis · create · openJob · start · pause · stop · retry · log · openWb · openFile
//   보내는 메시지(확장→웹뷰): init · asis · job · log · jobs · note
'use strict';
const vscode = require('vscode');
const cp = require('child_process');
const fs = require('fs');
const path = require('path');
const jr = require('./job-runner');
const flow = require('./flow-panel');

const panels = new Set();

function screenList(p) {
  const has = f => { try { return fs.existsSync(f); } catch { return false; } };
  let list = []; try { list = flow.targets(p); } catch { list = []; }
  return list.map(t => ({ id: t.id, title: t.title || '', status: t.status || '', dom: (/^[A-Z]+/.exec(t.id) || [''])[0],
    pack: has(path.join(p.outDir, 'screens', t.asis || t.id)), page: has(path.join(p.genDir, t.id, 'register.json')), chk: has(path.join(p.root, 'Doc', 'verify', t.id, 'run_verify.result.json')) }));
}
function loadAsis(p) {
  return new Promise(res => {
    const script = path.join(p.root, 'tools', 'DbConn', 'list_asis_programs.py'); if (!fs.existsSync(script)) return res({ ok: false, reason: 'tools/DbConn/list_asis_programs.py 없음' });
    let buf = ''; let child; try { child = cp.spawn(p.python || 'python', [script], { cwd: p.root, shell: process.platform === 'win32' }); } catch (e) { return res({ ok: false, reason: e.message }); }
    child.stdout.on('data', d => buf += d.toString('utf8')); child.stderr.on('data', d => buf += d.toString('utf8'));
    child.on('close', () => { try { res(JSON.parse(buf)); } catch { res({ ok: false, reason: (buf || '응답 없음').slice(0, 300) }); } });
    child.on('error', e => res({ ok: false, reason: `python 실행 실패: ${e.message}` }));
  });
}

function open(api) {
  jr.init(api);
  const p0 = api.paths(); const ko = p0.language === 'ko';
  const panel = vscode.window.createWebviewPanel('vibeManager.jobs', ko ? 'VM 업무 작업' : 'VM Jobs', vscode.ViewColumn.Active, { enableScripts: true, retainContextWhenHidden: true });
  try { panel.iconPath = { light: vscode.Uri.file(path.join(api.ctx.extensionPath, 'media', 'vibe.svg')), dark: vscode.Uri.file(path.join(api.ctx.extensionPath, 'media', 'vibe-color.svg')) }; } catch { }
  const st = { panel, cur: '' }; panels.add(st);
  const post = m => { try { panel.webview.postMessage(m); } catch { } };
  const un = jr.on((jobId, kind, data) => {
    if (kind === 'end') post({ type: 'jobs', items: jr.list(30) });
    if (jobId !== st.cur) return;
    if (kind === 'job') post({ type: 'job', job: data }); else if (kind === 'log') post({ type: 'log', screen: data.screen, text: data.text, append: true });
  });
  panel.onDidDispose(() => { try { un(); } catch { } panels.delete(st); });
  panel.webview.html = html(p0);
  panel.webview.onDidReceiveMessage(async m => {
    const p = api.paths();
    try {
      switch (m.type) {
        case 'ready': {
          let mode = ''; try { mode = require('./workbench').workMode(p).db ? 'DB Mode' : 'UI&DB Mode'; } catch { }
          const jc = jr.loadCfg();
          post({ type: 'init', items: jr.batchItems(), screens: screenList(p), jobs: jr.list(30), mode, cfg: { maxPar: jc.jobMaxPar, maxClaude: jc.jobMaxClaude, cpuMax: jc.cpuMax, memMin: jc.memMin, rampSec: jc.rampSec } });
          if (st.cur) { const j = jr.get(st.cur); if (j) post({ type: 'job', job: j }); }
          break;
        }
        case 'loadAsis': { const d = await loadAsis(p); post({ type: 'asis', ok: !!d.ok, reason: d.reason || '', items: (d.items || []).map(x => ({ id: String(x.id || '').toUpperCase(), title: x.name || '' })) }); break; }
        case 'create': {
          let job; try { job = jr.create({ itemLabel: m.itemLabel, screens: m.screens, onFail: m.onFail, autoAnswer: !!m.autoAnswer, mode: m.mode === 'par' ? 'par' : 'seq', maxPar: m.maxPar }); } catch (e) { post({ type: 'note', text: `작업을 만들 수 없음: ${e.message}`, bad: true }); break; }
          st.cur = job.id; jr.start(job.id); post({ type: 'job', job: jr.get(job.id) }); post({ type: 'jobs', items: jr.list(30) });
          break;
        }
        case 'openJob': { const j = jr.get(m.id); if (j) { st.cur = j.id; post({ type: 'job', job: j }); } break; }
        case 'start': if (!jr.start(m.id)) post({ type: 'note', text: '실행할 화면이 없거나 이미 실행 중입니다' }); break;
        case 'retry': if (!jr.retryFailed(m.id)) post({ type: 'note', text: '실패·중지한 화면이 없거나 실행 중입니다' }); break;
        case 'pause': jr.pause(m.id); break;
        case 'stop': { const a = await vscode.window.showWarningMessage(ko ? '실행 중인 화면도 중지합니다. 그 화면의 진행분은 없어집니다.' : 'Stop running screens too?', { modal: true }, ko ? '중지' : 'Stop'); if (a) jr.stop(m.id); break; }
        case 'log': post({ type: 'log', screen: m.screen, text: jr.logOf(m.id, m.screen) || readLogFile(p, m.id, m.screen), append: false }); break;
        case 'openWb': {
          const wbm = require('./workbench'); const wb = wbm.open(api, { fresh: true }); const id = String(m.screen || '').toUpperCase();
          if (wb) { try { wb.setState(Object.assign({}, wb.getState(), { id })); } catch { } setTimeout(() => { try { wb.post({ type: 'setId', id }); } catch { } }, 900); }
          break;
        }
        case 'openFile': { const f = path.resolve(p.root, String(m.path || '')); if (!path.relative(p.root, f).startsWith('..') && fs.existsSync(f)) api.openPath(f); else post({ type: 'note', text: `파일 없음: ${m.path}` }); break; }
      }
    } catch (e) { post({ type: 'note', text: `오류: ${e.message}`, bad: true }); }
  });
  return st;
}
function readLogFile(p, jobId, screen) { try { const f = path.join(p.vibeDir, 'jobs', jobId, `${screen}.log`); const s = fs.readFileSync(f, 'utf8'); return s.length > 200000 ? s.slice(-200000) : s; } catch { return ''; } }

function html(p) {
  const ko = !p || p.language !== 'en'; const T = (k, e) => (ko ? k : e);
  return `<!DOCTYPE html><html lang="${ko ? 'ko' : 'en'}"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<style>
:root{--b:var(--vscode-panel-border,rgba(128,128,128,.35));--mut:var(--vscode-descriptionForeground);--ok:var(--vscode-testing-iconPassed,#3fb950);--warn:var(--vscode-editorWarning-foreground,#d29922);--bad:var(--vscode-errorForeground,#f85149)}
*{box-sizing:border-box}
body{margin:0;font-family:var(--vscode-font-family);font-size:12px;color:var(--vscode-foreground);background:var(--vscode-editor-background);height:100vh;display:flex;flex-direction:column}
.top{display:flex;align-items:center;gap:8px;padding:6px 10px;border-bottom:1px solid var(--b);flex-wrap:wrap}
.top h1{font-size:13px;margin:0 6px 0 0}
.sp{flex:1}
.chip{display:inline-flex;align-items:center;gap:5px;border:1px solid var(--b);border-radius:10px;padding:1px 8px;font-size:11px;white-space:nowrap}
.main{flex:1;min-height:0;display:flex}
.left{width:42%;min-width:300px;max-width:560px;border-right:1px solid var(--b);display:flex;flex-direction:column;min-height:0}
.right{flex:1;min-width:0;display:flex;flex-direction:column;min-height:0}
.sec{padding:8px 10px;border-bottom:1px solid var(--b);display:flex;flex-direction:column;gap:6px}
.sec h2{font-size:12px;margin:0;display:flex;gap:8px;align-items:baseline}
.sec h2 small{font-weight:400;color:var(--mut)}
select,input[type=text],textarea{background:var(--vscode-input-background);color:var(--vscode-input-foreground);border:1px solid var(--vscode-input-border,var(--b));border-radius:4px;padding:4px 6px;font-family:inherit;font-size:12px;min-width:0}
button{background:var(--vscode-button-secondaryBackground);color:var(--vscode-button-secondaryForeground);border:none;border-radius:4px;padding:4px 10px;cursor:pointer;font-size:12px}
button:hover{background:var(--vscode-button-secondaryHoverBackground)}
button.pri{background:var(--vscode-button-background);color:var(--vscode-button-foreground)}
button.pri:hover{background:var(--vscode-button-hoverBackground)}
button:disabled{opacity:.45;cursor:default}
.row{display:flex;gap:6px;align-items:center;flex-wrap:wrap}
.doms{display:flex;gap:4px;flex-wrap:wrap}
.doms button{padding:1px 8px;border-radius:10px;border:1px solid var(--b);background:transparent;color:inherit}
.doms button.on{background:var(--vscode-list-activeSelectionBackground,rgba(128,128,128,.25));color:var(--vscode-list-activeSelectionForeground,inherit);font-weight:700}
.list{flex:1;min-height:80px;overflow:auto}
.it{display:flex;gap:6px;align-items:center;padding:2px 10px;cursor:pointer}
.it:hover{background:var(--vscode-list-hoverBackground)}
.it b{font-weight:600;min-width:74px}
.it .t{flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:var(--mut)}
.it .f{font-size:10px;border:1px solid var(--b);border-radius:6px;padding:0 4px;color:var(--mut);white-space:nowrap}
.it .f.y{color:var(--ok);border-color:var(--ok)}
.tblw{flex:1;min-height:60px;overflow:auto}
table{border-collapse:collapse;width:100%}
th,td{text-align:left;padding:4px 8px;border-bottom:1px solid var(--b);font-size:11.5px;vertical-align:top}
th{color:var(--mut);font-weight:600;white-space:nowrap;position:sticky;top:0;background:var(--vscode-editor-background)}
td.n{text-align:right;font-variant-numeric:tabular-nums;white-space:nowrap}
tr.sel{background:var(--vscode-list-inactiveSelectionBackground,rgba(128,128,128,.15))}
tr.r{cursor:pointer}
.s-done{color:var(--ok)}.s-fail{color:var(--bad)}.s-warn,.s-hold,.s-cancel,.s-busy{color:var(--warn)}.s-run{font-weight:700}
.actor{border:1px solid var(--b);border-radius:8px;padding:0 6px;font-size:10.5px;white-space:nowrap}
.actor.claude{border-color:var(--vscode-charts-purple,#a371f7);color:var(--vscode-charts-purple,#a371f7)}
.log{height:34%;min-height:90px;overflow:auto;border-top:1px solid var(--b);font-family:var(--vscode-editor-font-family,monospace);font-size:11.5px;white-space:pre-wrap;word-break:break-all;padding:6px 10px;line-height:1.4}
.empty{color:var(--mut);padding:8px 10px}
.note{color:var(--warn)}.note.bad{color:var(--bad)}
a.lk{color:var(--vscode-textLink-foreground);cursor:pointer;text-decoration:none}
@media (max-width:760px){.main{flex-direction:column}.left{width:auto;max-width:none;border-right:none;border-bottom:1px solid var(--b);max-height:55%}}
</style></head><body>
<div class="top"><h1>${T('VM 업무 작업', 'VM Jobs')}</h1><span style="color:var(--mut)">${T('업무 1개를 화면 여러 개에 실행', 'Run one job on many screens')}</span><span class="sp"></span><span class="note" id="note"></span><span class="chip" id="mode"></span>
  <select id="recent" title="${T('최근 작업 열기', 'Open a recent job')}"><option value="">${T('최근 작업', 'Recent jobs')}</option></select></div>
<div class="main">
 <div class="left">
  <div class="sec"><h2>${T('1. 업무', '1. Job')}</h2>
    <select id="item"></select>
    <div class="row" style="color:var(--mut)" id="itemInfo"></div>
    <div class="row"><span>${T('실패한 화면', 'On failure')}</span><label><input type="radio" name="of" value="continue" checked> ${T('표시하고 다음 화면 계속', 'continue')}</label><label><input type="radio" name="of" value="stop"> ${T('첫 실패에서 중단', 'stop')}</label></div>
    <div class="row" id="askRow" style="display:none"><label><input type="checkbox" id="ask"> <span id="askTxt"></span></label></div>
    <div class="row"><span>${T('실행 방식', 'Mode')}</span><label><input type="radio" name="md" value="seq" checked> ${T('순차(화면 1개씩)', 'sequential')}</label><label><input type="radio" name="md" value="par"> ${T('부하가 허용하면 동시', 'parallel if load allows')}</label><label>${T('최대', 'max')} <input type="text" id="mp" value="2" style="width:34px;text-align:center"> ${T('화면', 'screens')}</label></div>
    <div class="row" style="color:var(--mut)" id="parInfo"></div>
    <div class="row" id="itemWarn" style="color:var(--warn);display:none"></div>
  </div>
  <div class="sec"><h2>${T('2. 화면', '2. Screens')}<small id="cnt"></small></h2>
    <div class="row"><input type="text" id="q" placeholder="${T('화면 ID · 이름 검색', 'Search id or name')}" style="flex:1"><select id="flt"><option value="">${T('전체', 'All')}</option><option value="pack">${T('분석 자료 있음', 'Has fact pack')}</option><option value="nopack">${T('분석 자료 없음', 'No fact pack')}</option><option value="page">${T('화면 생성됨', 'Page generated')}</option><option value="nopage">${T('화면 미생성', 'No page')}</option><option value="chk">${T('CheckList 결과 있음', 'Has CheckList')}</option><option value="nochk">${T('CheckList 결과 없음', 'No CheckList')}</option><option value="sel">${T('선택한 것만', 'Selected only')}</option></select></div>
    <div class="doms" id="doms"></div>
    <div class="row"><button id="all">${T('보이는 것 전체 선택', 'Select shown')}</button><button id="none">${T('보이는 것 해제', 'Clear shown')}</button><button id="clr">${T('전체 해제', 'Clear all')}</button><span class="sp"></span><button id="asis" title="${T('AS-IS DB(.env.asis)의 사용 중 프로그램 목록을 더함', 'Add programs from the AS-IS DB')}">${T('AS-IS DB 목록 더하기', 'Add AS-IS list')}</button></div>
  </div>
  <div class="list" id="list"><div class="empty">${T('화면 목록을 읽는 중', 'Loading')}</div></div>
  <div class="sec" style="border-top:1px solid var(--b);border-bottom:none">
    <div class="row"><input type="text" id="paste" placeholder="${T('화면 ID 붙여넣기 (예: SCP0111 SSP0014, DMF0042)', 'Paste screen ids')}" style="flex:1"><button id="add">${T('더하기', 'Add')}</button></div>
    <div class="row"><span id="selTxt" style="flex:1;color:var(--mut);overflow:hidden;text-overflow:ellipsis;white-space:nowrap"></span><button class="pri" id="go" disabled>${T('시작', 'Start')}</button></div>
  </div>
 </div>
 <div class="right">
  <div class="sec"><h2 id="jt">${T('진행', 'Progress')}<small id="jm"></small></h2>
    <div class="row"><span class="chip" id="jst">${T('작업 없음', 'No job')}</span><span id="jc" style="color:var(--mut)"></span><span class="sp"></span>
      <button id="bResume" disabled>${T('이어서 실행', 'Resume')}</button><button id="bRetry" disabled>${T('실패분만 다시', 'Retry failed')}</button><button id="bPause" disabled>${T('일시 중지', 'Pause')}</button><button id="bStop" disabled>${T('중지', 'Stop')}</button><button id="bSum" disabled>${T('요약 열기', 'Summary')}</button></div>
    <div id="jn" style="color:var(--warn)"></div>
  </div>
  <div class="tblw"><table id="tbl"><tr><th>#</th><th>${T('화면', 'Screen')}</th><th>${T('상태', 'Status')}</th><th>${T('현재 단계', 'Step')}</th><th>${T('주체', 'Actor')}</th><th>${T('소요', 'Time')}</th><th>${T('요약 · 실패 원인', 'Summary')}</th><th></th></tr></table><div class="empty" id="noJob">${T('왼쪽에서 업무와 화면을 고르고 시작을 누릅니다. 창을 닫아도 작업은 계속 돕니다.', 'Pick a job and screens, then Start. Jobs keep running if this window is closed.')}</div></div>
  <div class="log" id="log"></div>
 </div>
</div>
<script>
const vscode = acquireVsCodeApi(); const $ = id => document.getElementById(id); const KO = ${ko ? 'true' : 'false'};
const esc = s => String(s == null ? '' : s).replace(/[&<>"]/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c]));
let items=[], screens=[], sel=new Set(), dom='', job=null, logScreen='';
const SK = {wait:'대기',busy:'다른 곳에서 실행 중',admit:'입장 대기',run:'실행',done:'완료',warn:'완료(경고)',hold:'사람 확인 필요',fail:'실패',cancel:'중지',skip:'건너뜀'};
const JK = {idle:'시작 전',running:'실행 중',pausing:'일시 중지 중',paused:'일시 중지',stopped:'중지',interrupted:'중단됨',done:'끝남'};
function sec(n){ n=Math.max(0,Math.round(n||0)); if(n<60) return n+(KO?'초':'s'); const m=Math.floor(n/60); if(m<60) return m+(KO?'분 ':'m ')+(n%60)+(KO?'초':'s'); return Math.floor(m/60)+(KO?'시간 ':'h ')+(m%60)+(KO?'분':'m'); }
function note(t,bad){ const n=$('note'); n.textContent=t||''; n.className='note'+(bad?' bad':''); if(t) setTimeout(()=>{ if(n.textContent===t) n.textContent=''; }, 8000); }
function shown(){ const q=$('q').value.trim().toUpperCase(); const f=$('flt').value;
  return screens.filter(s=>(!dom||s.dom===dom)&&(!q||s.id.includes(q)||String(s.title).toUpperCase().includes(q))&&(f===''||(f==='pack'&&s.pack)||(f==='nopack'&&!s.pack)||(f==='page'&&s.page)||(f==='nopage'&&!s.page)||(f==='chk'&&s.chk)||(f==='nochk'&&!s.chk)||(f==='sel'&&sel.has(s.id)))); }
function paintList(){ const rows=shown(); $('cnt').textContent=(KO?'보이는 ':'shown ')+rows.length+' / '+screens.length+(KO?' · 선택 ':' · selected ')+sel.size;
  $('list').innerHTML = rows.length ? rows.slice(0,600).map(s=>'<label class="it"><input type="checkbox" data-id="'+s.id+'"'+(sel.has(s.id)?' checked':'')+'><b>'+esc(s.id)+'</b><span class="t" title="'+esc(s.title)+'">'+esc(s.title)+'</span><span class="f'+(s.pack?' y':'')+'" title="'+(KO?'AS-IS 분석 자료':'fact pack')+'">'+(KO?'분석':'pack')+'</span><span class="f'+(s.page?' y':'')+'" title="'+(KO?'TO-BE 화면 생성':'page')+'">'+(KO?'화면':'page')+'</span><span class="f'+(s.chk?' y':'')+'" title="CheckList">'+(KO?'점검':'chk')+'</span></label>').join('')+(rows.length>600?'<div class="empty">'+(KO?'600개까지 표시 — 검색으로 좁히세요':'Showing 600')+'</div>':'') : '<div class="empty">'+(KO?'없음':'None')+'</div>';
  $('list').querySelectorAll('input[data-id]').forEach(c=>c.onchange=()=>{ if(c.checked) sel.add(c.dataset.id); else sel.delete(c.dataset.id); paintSel(); });
  paintSel(); }
function paintSel(){ const a=[...sel]; $('selTxt').textContent=a.length?(KO?'선택 '+a.length+'개: ':'Selected '+a.length+': ')+a.join(', '):(KO?'선택한 화면 없음':'No screens selected'); { const itx=items.find(x=>x.label===$('item').value); $('go').disabled=!a.length||!$('item').value||!!(itx&&itx.disabled); } $('cnt').textContent=(KO?'보이는 ':'shown ')+shown().length+' / '+screens.length+(KO?' · 선택 ':' · selected ')+sel.size; }
function paintDoms(){ const ds=[...new Set(screens.map(s=>s.dom))].sort(); $('doms').innerHTML='<button data-d=""'+(dom===''?' class="on"':'')+'>'+(KO?'전체':'All')+'</button>'+ds.map(d=>'<button data-d="'+d+'"'+(dom===d?' class="on"':'')+'>'+d+' '+screens.filter(s=>s.dom===d).length+'</button>').join(''); $('doms').querySelectorAll('button').forEach(b=>b.onclick=()=>{dom=b.dataset.d;paintDoms();paintList();}); }
let CFG={maxPar:3,maxClaude:2,cpuMax:80,memMin:3072,rampSec:120};
function paintPar(){ const it=items.find(x=>x.label===$('item').value); const par=document.querySelector('input[name=md]:checked').value==='par'; let n=Math.max(1,Math.min(CFG.maxPar,parseInt($('mp').value,10)||2)); $('mp').disabled=!par;
  $('parInfo').textContent=par?((KO?'동시 '+n+'화면까지(상한 '+CFG.maxPar+'). ':'Up to '+n+'. ')+(it&&it.selfAdmit?(KO?'CheckList 는 실행 스크립트가 부하를 재서 스스로 입장을 기다림. ':'CheckList admits itself. '):(KO?'두 번째 화면부터 CPU < '+CFG.cpuMax+'% · 여유 메모리 ≥ '+CFG.memMin+'MB · 입장 간격 '+CFG.rampSec+'초일 때만 시작, 아니면 순차. ':'2nd+ screen only when load allows. '))+(it&&it.claudeSteps?(KO?'Claude 는 동시에 '+CFG.maxClaude+'개까지.':'Claude sessions up to '+CFG.maxClaude+'.'):'')):(KO?'같은 화면이 다른 창에서 실행 중이면 뒤로 미룸':'Screens busy elsewhere are deferred'); }
function paintItem(){ { const it0=items.find(x=>x.label===$('item').value); const w=$('itemWarn'); const msg=it0&&it0.disabled?it0.why:(it0&&it0.newScreen?(KO?'이미 생성된 화면은 건너뜁니다(일괄 작업은 기존 화면을 지우지 않음)':'Screens that already exist are skipped'):''); w.style.display=msg?'':'none'; w.textContent=msg; paintPar(); }
  const it=items.find(x=>x.label===$('item').value); $('itemInfo').textContent=it?((KO?'단계 ':'steps ')+(it.steps||1)+(it.claudeSteps?(KO?' · Claude 단계 ':' · Claude steps ')+it.claudeSteps:(KO?' · 스크립트만':' · script only'))+(it.hint?' · '+it.hint:'')):''; $('askRow').style.display=it&&it.hasAsk?'':'none'; if(it&&it.hasAsk) $('askTxt').textContent=(KO?'승인이 필요한 단계도 전 화면에 실행: ':'Also run steps that need approval: ')+String(it.askText||'').replace(/\\$\\{id\\}/g,KO?'화면':'screen').slice(0,120); paintSel(); }
function paintJob(){ const j=job; const has=!!j; $('noJob').style.display=has?'none':''; const tb=$('tbl'); while(tb.rows.length>1) tb.deleteRow(1);
  if(!has){ $('jst').textContent=KO?'작업 없음':'No job'; $('jc').textContent=''; $('jn').textContent=''; $('jm').textContent=''; for(const b of ['bResume','bRetry','bPause','bStop','bSum']) $(b).disabled=true; return; }
  const c={}; for(const s of j.screens) c[s.status]=(c[s.status]||0)+1; const fin=j.screens.filter(s=>['done','warn','hold','fail','cancel','skip'].includes(s.status)).length;
  $('jm').textContent=j.id+' · '+j.itemLabel; $('jst').textContent=KO?(JK[j.status]||j.status):j.status; $('jc').textContent=fin+'/'+j.screens.length+' · '+Object.entries(c).map(([k,v])=>(KO?(SK[k]||k):k)+' '+v).join(' · '); $('jn').textContent=j.note||'';
  const run=j.status==='running'||j.status==='pausing'; const left=j.screens.some(s=>s.status==='wait'||s.status==='busy'); const failed=j.screens.some(s=>s.status==='fail'||s.status==='cancel');
  $('bResume').disabled=run||!left; $('bRetry').disabled=run||!failed; $('bPause').disabled=j.status!=='running'; $('bStop').disabled=!run; $('bSum').disabled=false;
  j.screens.forEach((s,i)=>{ const r=tb.insertRow(-1); r.className='r'+(s.id===logScreen?' sel':''); r.dataset.s=s.id;
    r.innerHTML='<td class="n">'+(i+1)+'</td><td><b>'+esc(s.id)+'</b></td><td class="s-'+s.status+'">'+esc(KO?(SK[s.status]||s.status):s.status)+'</td><td>'+esc(s.step||'')+'</td><td>'+(s.actor?'<span class="actor '+(s.actor==='claude'?'claude':'')+'">'+(s.actor==='claude'?'Claude':(KO?'스크립트':'script'))+'</span>':'')+'</td><td class="n">'+(s.sec?sec(s.sec):'')+'</td><td>'+esc(s.why||s.summary||'')+(s.actorNote?'<div style="color:var(--mut)">'+esc(s.actorNote)+'</div>':'')+'</td><td style="white-space:nowrap"><a class="lk" data-wb="'+s.id+'" title="'+(KO?'이 화면의 Workbench 열기':'Open Workbench')+'">Workbench</a>'+(s.md?' · <a class="lk" data-f="'+esc(s.md)+'">'+(KO?'실행 기록':'run')+'</a>':'')+(s.log?' · <a class="lk" data-f="'+esc(s.log)+'">'+(KO?'로그':'log')+'</a>':'')+'</td>';
    r.onclick=e=>{ const a=e.target.closest('a.lk'); if(a){ if(a.dataset.wb) vscode.postMessage({type:'openWb',screen:a.dataset.wb}); else vscode.postMessage({type:'openFile',path:a.dataset.f}); return; } logScreen=s.id; $('log').textContent=''; vscode.postMessage({type:'log',id:j.id,screen:s.id}); paintJob(); }; });
  const runS=j.screens.find(s=>s.status==='run'); if(runS&&(!logScreen||!j.screens.some(s=>s.id===logScreen&&s.status==='run'))&&logScreen!==runS.id&&j.status==='running'&&!window._pin){ logScreen=runS.id; $('log').textContent=''; vscode.postMessage({type:'log',id:j.id,screen:runS.id}); } }
function addLog(text, append){ const b=$('log'); const stick=b.scrollHeight-b.scrollTop-b.clientHeight<60; if(!append) b.textContent=''; b.appendChild(document.createTextNode(text)); if(b.childNodes.length>3000) b.removeChild(b.firstChild); if(stick||!append) b.scrollTop=b.scrollHeight; }
function paintRecent(list){ $('recent').innerHTML='<option value="">'+(KO?'최근 작업':'Recent jobs')+'</option>'+list.map(j=>{ const c=j.counts||{}; return '<option value="'+j.id+'">'+esc(String(j.createdAt||'').replace('T',' ').slice(5,16)+' · '+(KO?(JK[j.status]||j.status):j.status)+' · '+j.total+(KO?'화면 · ':' screens · ')+j.itemLabel.slice(0,40))+'</option>'; }).join(''); }
window.addEventListener('message', e=>{ const m=e.data||{};
  if(m.type==='init'){ items=m.items||[]; screens=m.screens||[]; if(m.cfg) CFG=m.cfg; $('mode').textContent=m.mode||''; $('item').innerHTML=items.length?items.map(it=>'<option value="'+esc(it.label)+'">'+esc((KO?it.label:(it.label_en||it.label))+(it.disabled?(KO?'  (DB MODE 에서 실행 안 함)':'  (not in DB mode)'):''))+'</option>').join(''):'<option value="">'+(KO?'일괄 실행할 업무 없음(quick.json batch)':'No batch items')+'</option>'; paintItem(); paintDoms(); paintList(); paintRecent(m.jobs||[]); }
  else if(m.type==='asis'){ if(!m.ok){ note((KO?'AS-IS DB 목록 실패: ':'AS-IS list failed: ')+m.reason,true); return; } let n=0; const have=new Set(screens.map(s=>s.id)); for(const x of m.items){ if(!x.id) continue; if(have.has(x.id)){ const s=screens.find(y=>y.id===x.id); if(s&&!s.title) s.title=x.title; } else { screens.push({id:x.id,title:x.title,status:'AS-IS',dom:(/^[A-Z]+/.exec(x.id)||[''])[0],pack:false,page:false,chk:false}); n++; } } screens.sort((a,b)=>a.id.localeCompare(b.id)); paintDoms(); paintList(); note((KO?'AS-IS DB 목록 ':'AS-IS list ')+m.items.length+(KO?'건 · 새로 더한 화면 ':' · added ')+n); }
  else if(m.type==='job'){ job=m.job; paintJob(); }
  else if(m.type==='log'){ if(m.screen===logScreen) addLog(m.text||'', !!m.append); }
  else if(m.type==='jobs'){ paintRecent(m.items||[]); }
  else if(m.type==='note'){ note(m.text, m.bad); }
});
document.querySelectorAll('input[name=md]').forEach(r=>r.onchange=paintPar); $('mp').oninput=paintPar;
$('item').onchange=paintItem; $('q').oninput=paintList; $('flt').onchange=paintList;
$('all').onclick=()=>{ for(const s of shown()) sel.add(s.id); paintList(); }; $('none').onclick=()=>{ for(const s of shown()) sel.delete(s.id); paintList(); }; $('clr').onclick=()=>{ sel.clear(); paintList(); };
$('asis').onclick=()=>{ note(KO?'AS-IS DB 목록 조회 중':'Loading AS-IS list'); vscode.postMessage({type:'loadAsis'}); };
function addPaste(){ const ids=[...new Set((String($('paste').value).toUpperCase().match(/\\b[A-Z]{2,4}\\d{4}[A-Z]?\\b/g)||[]))]; if(!ids.length){ note(KO?'화면 ID 형식이 아님':'No screen ids',true); return; } const have=new Set(screens.map(s=>s.id)); for(const id of ids){ if(!have.has(id)) screens.push({id,title:'',status:KO?'직접 입력':'manual',dom:(/^[A-Z]+/.exec(id)||[''])[0],pack:false,page:false,chk:false}); sel.add(id); } screens.sort((a,b)=>a.id.localeCompare(b.id)); $('paste').value=''; paintDoms(); paintList(); }
$('add').onclick=addPaste; $('paste').addEventListener('keydown',e=>{ if(e.key==='Enter'){ e.preventDefault(); addPaste(); } });
$('go').onclick=()=>{ const order=screens.filter(s=>sel.has(s.id)).map(s=>s.id); logScreen=''; $('log').textContent=''; vscode.postMessage({type:'create',itemLabel:$('item').value,screens:order,onFail:document.querySelector('input[name=of]:checked').value,mode:document.querySelector('input[name=md]:checked').value,maxPar:Math.max(1,Math.min(CFG.maxPar,parseInt($('mp').value,10)||2)),autoAnswer:$('ask').checked&&$('askRow').style.display!=='none'}); };
$('bResume').onclick=()=>job&&vscode.postMessage({type:'start',id:job.id}); $('bRetry').onclick=()=>job&&vscode.postMessage({type:'retry',id:job.id}); $('bPause').onclick=()=>job&&vscode.postMessage({type:'pause',id:job.id}); $('bStop').onclick=()=>job&&vscode.postMessage({type:'stop',id:job.id});
$('bSum').onclick=()=>job&&vscode.postMessage({type:'openFile',path:'.vibe/jobs/'+job.id+'/SUMMARY.md'});
$('recent').onchange=()=>{ const v=$('recent').value; if(v){ logScreen=''; $('log').textContent=''; vscode.postMessage({type:'openJob',id:v}); $('recent').value=''; } };
vscode.postMessage({type:'ready'});
</script></body></html>`;
}

module.exports = { open, html, screenList };
