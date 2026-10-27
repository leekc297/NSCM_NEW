'use strict';
// Vibe_Manager 1.3.1 — FLOW 진척 패널: 화면별 단계(파싱→문서→GAP→생성→게이트→수선→PKG→등록→E2E) 상태를 산출물로 판정해 표 + 진행률로 보여준다.
//   판정은 전부 파일 기반(기록 신뢰 X): Fact Pack / agent _gate.csv / Doc/documents xlsx / Doc/gap csv / Doc/gen(GEN_NOTES·CHECK·DOD·REPAIR·CHECK_PKG·_registration·_revert·PIPELINE) / 페이지 폴더 / Doc/e2e/results/_summary.csv
const vscode = require('vscode');
const fs = require('fs');
const path = require('path');

const STAGES = [
  { key: 'pack', label: '1 파싱', task: 'S1.packone' },
  { key: 'docs', label: '2 문서', task: 'S3.agent' },
  { key: 'xlsx', label: '2x Excel', task: 'S3.xlsx' },
  { key: 'gap', label: '3 GAP', task: 'S4.one' },
  { key: 'gen', label: '4 생성', task: 'S5.pipelinedry' },
  { key: 'gate', label: '5 게이트', task: 'S5.final' },
  { key: 'repair', label: '6 수선', task: 'S5.pipeline' },
  { key: 'pkg', label: '7 PKG', task: 'S5.pkgrepair' },
  { key: 'reg', label: '8 등록SQL', task: 'S5.regsql' },
  // 1.8.8: 테스트 단계 4종 — smoke · crud · auth · authcrud(계정별 권한 CRUD). 판정 = Doc/e2e/results/_summary.csv 의 kind 열
  { key: 'smoke', label: '9 Smoke', task: 'S7.smoke' },
  { key: 'crud', label: '10 CRUD', task: 'S7.crud' },
  { key: 'auth', label: '11 Auth', task: 'S7.auth' },
  { key: 'authcrud', label: '12 Auth×CRUD', task: 'S7.authcrud' },
];
const E2E_KINDS = ['smoke', 'crud', 'auth', 'authcrud'];
const parseCsv = text => { text = text.replace(/^﻿/, ''); const rows = []; let row = [], f = '', q = false; for (let i = 0; i < text.length; i++) { const ch = text[i]; if (q) { if (ch === '"') { if (text[i + 1] === '"') { f += '"'; i++; } else q = false; } else f += ch; } else if (ch === '"') q = true; else if (ch === ',') { row.push(f); f = ''; } else if (ch === '\n' || ch === '\r') { if (ch === '\r' && text[i + 1] === '\n') i++; row.push(f); f = ''; if (row.length > 1 || row[0] !== '') rows.push(row); row = []; } else f += ch; } if (f !== '' || row.length) { row.push(f); rows.push(row); } return rows; };
const csvObjs = file => { if (!fs.existsSync(file)) return []; const r = parseCsv(fs.readFileSync(file, 'utf8')); const h = r[0] || []; return r.slice(1).map(x => Object.fromEntries(h.map((k, i) => [k, x[i] || '']))); };
const has = f => fs.existsSync(f);
const rd = f => has(f) ? fs.readFileSync(f, 'utf8') : '';

function targets(p) {
  // 대상 = Recon 대조표 in_target=Y 또는 status 가 누락-ToBe/OK/재확인 + Doc/gen 에 있는 ID (검증용 포함)
  const rec = csvObjs(path.join(p.reconOutDir, '대사표_화면.csv'));
  const ids = new Map();
  for (const r of rec) { const id = (r.tobe_id || r.asis_id || '').toUpperCase(); if (!id) continue; const tgt = r.in_target === 'Y' || /누락-ToBe|^OK|재확인|검토필요/.test(r.status || ''); if (tgt) ids.set(id, { id, asis: r.asis_id, title: r.title || '', status: r.status || '', reason: r.reason || '' }); }
  if (has(p.genDir)) for (const d of fs.readdirSync(p.genDir)) if (/^[A-Z]{2,4}\d{4}/.test(d) && !ids.has(d)) ids.set(d, { id: d, asis: d, title: '', status: '(Doc/gen)', reason: '' });
  return [...ids.values()].sort((a, b) => a.id.localeCompare(b.id));
}
function pageDirOf(p, id) { try { const r = JSON.parse(rd(path.join(p.genDir, id, 'register.json'))); return path.join(p.tobeDir, 'features', r.feature, 'src', 'pages', r.pageDir); } catch { return ''; } }
function stageStatus(p, id) {
  const g = path.join(p.genDir, id); const s = {};
  const pack = path.join(p.outDir, 'screens', id); s.pack = has(path.join(pack, `${id}_summary.md`)) ? 'ok' : (has(pack) ? 'warn' : 'none');
  const gate = path.join(p.outDir, 'agent', id, '_gate.csv');
  if (has(gate)) { const rows = csvObjs(gate); const bad = rows.filter(r => /FAIL|BLOCK/i.test(r.status || r.result || '')).length; s.docs = bad ? 'warn' : 'ok'; } else s.docs = has(path.join(p.outDir, 'agent', id, 'analysis.md')) ? 'warn' : 'none';
  const xd = path.join(p.root, 'Doc', 'documents', id); s.xlsx = has(xd) && fs.readdirSync(xd).some(f => /\.xlsx$/.test(f)) ? 'ok' : 'none';
  const gapF = path.join(p.gapDir, `${id}_gap.csv`); if (has(gapF)) { const rows = csvObjs(gapF); const open = rows.filter(r => /^(open|미해결|GAP)/i.test(r.status || r.result || '') || (r.allowed === 'N')).length; s.gap = open ? 'warn' : 'ok'; s.gapN = `${rows.length - open}/${rows.length}`; } else s.gap = 'none';
  s.gen = has(path.join(g, 'GEN_NOTES.md')) ? (pageDirOf(p, id) && has(pageDirOf(p, id)) ? 'ok' : 'warn') : 'none';
  const chk = rd(path.join(g, 'CHECK.md')); const m = chk.match(/BLOCK (\d+) \/ WARN (\d+)/); s.gate = m ? (Number(m[1]) === 0 ? 'ok' : 'bad') : 'none'; s.gateN = m ? `${m[1]}/${m[2]}` : '';
  const dod = rd(path.join(g, 'DOD.md')).match(/(\d+)\/(\d+) 충족/); s.dod = dod ? `${dod[1]}/${dod[2]}` : '';
  const rep = rd(path.join(g, 'REPAIR.md')); s.repair = /\*\*PASS\*\*/.test(rep) ? 'ok' : (/NEEDS_HUMAN|사람 확인 큐/.test(rep) ? 'bad' : (rep ? 'warn' : 'none'));
  const pk = rd(path.join(g, 'CHECK_PKG.md')).match(/BLOCK (\d+) \/ WARN (\d+)/); s.pkg = pk ? (Number(pk[1]) === 0 ? 'ok' : 'bad') : (has(path.join(g, `${id}_PKG.sql`)) ? 'warn' : 'none'); s.pkgN = pk ? `${pk[1]}/${pk[2]}` : '';
  s.reg = has(path.join(g, `${id}_registration.sql`)) ? (has(path.join(g, `${id}_revert.sql`)) ? 'ok' : 'warn') : 'none';
  const e2e = csvObjs(path.join(p.e2eOutDir, 'results', '_summary.csv')).filter(r => (r.menu_id || '').toUpperCase() === id);
  // 종류별: 결과 있음 → PASS 비율로 ok/warn/bad · 결과 없고 스펙만 있음 → warn(미실행) · 스펙도 없음 → none. s.e2e = 전체 합(구 호환)
  for (const k of E2E_KINDS) {
    const rows = e2e.filter(r => (r.kind || '').toLowerCase() === k);
    if (rows.length) { const pass = rows.filter(r => /pass/i.test(r.status)).length; s[k] = pass === rows.length ? 'ok' : (pass ? 'warn' : 'bad'); s[k + 'N'] = `${pass}/${rows.length}`; }
    else s[k] = has(path.join(p.e2eOutDir, 'specs', `${id}.${k}.spec.ts`)) ? 'warn' : 'none';
  }
  if (e2e.length) { const pass = e2e.filter(r => /pass/i.test(r.status)).length; s.e2e = pass === e2e.length ? 'ok' : (pass ? 'warn' : 'bad'); s.e2eN = `${pass}/${e2e.length}`; } else s.e2e = has(path.join(p.e2eOutDir, 'specs', `${id}.smoke.spec.ts`)) ? 'warn' : 'none';
  const pl = rd(path.join(g, 'PIPELINE.md')).match(/^# PIPELINE \S+ — ([\d-]+ [\d:]+) (✅|⚠)/m); s.pipeline = pl ? `${pl[2]} ${pl[1]}` : '';
  return s;
}
const SYM = { ok: '●', warn: '◐', bad: '✖', none: '○' };
const CLS = { ok: 'ok', warn: 'warn', bad: 'bad', none: 'none' };

function html(p, rows, filter) {
  const esc = s => String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;');
  const total = rows.length; const done = rows.filter(r => STAGES.every(st => r.s[st.key] === 'ok')).length;
  const perStage = STAGES.map(st => ({ st, n: rows.filter(r => r.s[st.key] === 'ok').length }));
  const trs = rows.map(r => `<tr data-id="${esc(r.id)}"><td class="id"><b>${esc(r.id)}</b>${r.asis && r.asis !== r.id ? `<div class="sub">As-is ${esc(r.asis)}</div>` : ''}</td><td class="t">${esc(r.title)}<div class="sub">${esc(r.status)}</div></td>${STAGES.map(st => { const v = r.s[st.key] || 'none'; const n = r.s[st.key + 'N'] || (st.key === 'gate' ? r.s.dod && `DoD ${r.s.dod}` : ''); return `<td class="c ${CLS[v]}" title="${esc(st.label)} — 클릭: ${esc(st.task)} 실행" data-task="${st.task}" data-id="${esc(r.id)}">${SYM[v]}${n ? `<div class="n">${esc(n)}</div>` : ''}</td>`; }).join('')}<td class="pl">${esc(r.s.pipeline)}</td><td class="act"><button data-act="pipeline" data-id="${esc(r.id)}">★ 끝까지</button><button class="sec" data-act="open" data-id="${esc(r.id)}">Doc/gen</button></td></tr>`).join('');
  return `<!doctype html><html><head><meta charset="utf-8"><style>
body{font:12px var(--vscode-font-family);color:var(--vscode-foreground);padding:10px 14px;margin:0}
h2{margin:0 0 6px 0}.bar{height:14px;background:var(--vscode-input-background);border:1px solid var(--vscode-input-border,#555);border-radius:7px;overflow:hidden;margin:6px 0}
.bar div{height:100%;background:var(--vscode-progressBar-background,#3a7)}
table{border-collapse:collapse;width:100%;margin-top:8px}th,td{border:1px solid var(--vscode-editorWidget-border,#444);padding:3px 6px;vertical-align:top}
th{background:var(--vscode-editorWidget-background);position:sticky;top:0}
td.c{text-align:center;cursor:pointer;font-size:14px;width:62px}td.c .n{font-size:10px;opacity:.75}
.ok{color:#3fb950}.warn{color:#d29922}.bad{color:#f85149}.none{opacity:.35}
.sub{font-size:10px;opacity:.6}.id{white-space:nowrap}.t{min-width:160px}.pl{white-space:nowrap;font-size:11px}
button{background:var(--vscode-button-background);color:var(--vscode-button-foreground);border:0;padding:2px 7px;margin:1px;cursor:pointer;border-radius:2px;font-size:11px}
button.sec{background:var(--vscode-button-secondaryBackground);color:var(--vscode-button-secondaryForeground)}
input{background:var(--vscode-input-background);color:var(--vscode-input-foreground);border:1px solid var(--vscode-input-border,transparent);padding:3px 6px}
.legend span{margin-right:12px}.stages{display:flex;gap:6px;flex-wrap:wrap;margin:6px 0}.stages div{border:1px solid var(--vscode-editorWidget-border,#444);border-radius:4px;padding:3px 8px;font-size:11px}
</style></head><body>
<h2>NSCM 전환 FLOW — 화면 ${total} · 전 단계 완료 ${done} (${total ? Math.round(done * 100 / total) : 0}%)</h2>
<div class="bar"><div style="width:${total ? Math.round(done * 100 / total) : 0}%"></div></div>
<div class="stages">${perStage.map(x => `<div><b>${esc(x.st.label)}</b> ${x.n}/${total}</div>`).join('')}</div>
<div class="legend"><span class="ok">● 완료</span><span class="warn">◐ 부분/확인</span><span class="bad">✖ 실패(BLOCK/NEEDS_HUMAN)</span><span class="none">○ 없음</span> · 셀 클릭 = 그 단계 작업 실행 · <input id="f" placeholder="ID/제목 필터" value="${esc(filter || '')}"> <button class="sec" id="rf">새로고침</button> <button class="sec" id="csv">CSV 저장</button></div>
<table><thead><tr><th>화면</th><th>제목 / 대조표 상태</th>${STAGES.map(st => `<th>${esc(st.label)}</th>`).join('')}<th>파이프라인</th><th>실행</th></tr></thead><tbody>${trs}</tbody></table>
<script>const vscode=acquireVsCodeApi();
document.querySelectorAll('td.c').forEach(td=>td.onclick=()=>vscode.postMessage({type:'task',task:td.dataset.task,id:td.dataset.id}));
document.querySelectorAll('button[data-act]').forEach(b=>b.onclick=()=>vscode.postMessage({type:b.dataset.act,id:b.dataset.id}));
document.getElementById('rf').onclick=()=>vscode.postMessage({type:'refresh',filter:document.getElementById('f').value});
document.getElementById('csv').onclick=()=>vscode.postMessage({type:'csv'});
document.getElementById('f').addEventListener('keydown',e=>{if(e.key==='Enter')vscode.postMessage({type:'refresh',filter:e.target.value});});
</script></body></html>`;
}

let panel = null;
function open(api) {
  const render = (filter) => {
    const p = api.paths(); let rows = targets(p).map(t => Object.assign(t, { s: stageStatus(p, t.id) }));
    if (filter) { const f = filter.toLowerCase(); rows = rows.filter(r => r.id.toLowerCase().includes(f) || (r.title || '').toLowerCase().includes(f) || (r.status || '').includes(filter)); }
    panel.webview.html = html(p, rows, filter); panel._rows = rows;
  };
  if (panel) { panel.reveal(); render(panel._filter || ''); return; }
  panel = vscode.window.createWebviewPanel('vibeManager.flow', 'NSCM FLOW 진척 — Vibe_Manager', vscode.ViewColumn.One, { enableScripts: true, retainContextWhenHidden: true });
  panel.onDidDispose(() => { panel = null; });
  panel.webview.onDidReceiveMessage(async m => {
    const p = api.paths();
    if (m.type === 'refresh') { panel._filter = m.filter || ''; render(panel._filter); }
    else if (m.type === 'task') await api.runTaskById(m.task, { id: m.id, ids: m.id, dir: pageDirOf(p, m.id) });
    else if (m.type === 'pipeline') await api.runTaskById('S5.pipeline', { id: m.id, ids: m.id });
    else if (m.type === 'open') api.openPath(path.join(p.genDir, m.id));
    else if (m.type === 'csv') { const out = path.join(p.vibeDir, 'reports', `flow_${require('./history').nowLocal().slice(0, 10)}.csv`); fs.mkdirSync(path.dirname(out), { recursive: true }); const rows = panel._rows || []; const head = ['id', 'asis', 'title', 'status', ...STAGES.map(s => s.key), 'dod', 'pipeline']; fs.writeFileSync(out, '﻿' + [head.join(','), ...rows.map(r => [r.id, r.asis, r.title, r.status, ...STAGES.map(s => r.s[s.key]), r.s.dod, r.s.pipeline].map(v => `"${String(v == null ? '' : v).replace(/"/g, '""')}"`).join(','))].join('\n'), 'utf8'); vscode.window.showInformationMessage(`FLOW CSV → ${out}`); }
  });
  render('');
}
function refresh() { if (panel) open._api && open(open._api); }

// 워크벤치 내부 탭용: 전체 HTML 문서가 아닌 콘텐츠 영역만 반환
function innerHtml(p, filter) {
  const esc = s => String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;');
  let rows = targets(p).map(t => Object.assign(t, { s: stageStatus(p, t.id) }));
  if (filter) { const f = filter.toLowerCase(); rows = rows.filter(r => r.id.toLowerCase().includes(f) || (r.title || '').toLowerCase().includes(f) || (r.status || '').includes(filter)); }
  const total = rows.length; const done = rows.filter(r => STAGES.every(st => r.s[st.key] === 'ok')).length;
  const perStage = STAGES.map(st => ({ st, n: rows.filter(r => r.s[st.key] === 'ok').length }));
  const trs = rows.map(r => `<tr data-id="${esc(r.id)}"><td class="id"><b>${esc(r.id)}</b>${r.asis && r.asis !== r.id ? `<div class="sub">As-is ${esc(r.asis)}</div>` : ''}</td><td class="t">${esc(r.title)}<div class="sub">${esc(r.status)}</div></td>${STAGES.map(st => { const v = r.s[st.key] || 'none'; const n = r.s[st.key + 'N'] || (st.key === 'gate' ? r.s.dod && `DoD ${r.s.dod}` : ''); return `<td class="fc ${CLS[v]}" title="${esc(st.label)} — 클릭: ${esc(st.task)} 실행" data-task="${st.task}" data-id="${esc(r.id)}">${SYM[v]}${n ? `<div class="n">${esc(n)}</div>` : ''}</td>`; }).join('')}<td class="pl">${esc(r.s.pipeline)}</td><td class="fact"><button class="fbtn" data-act="pipeline" data-id="${esc(r.id)}">★ 끝까지</button><button class="fbtn sec" data-act="open" data-id="${esc(r.id)}">📁 Doc/gen</button></td></tr>`).join('');
  return `<div class="flow-root">
    <h3>📊 NSCM 전환 FLOW — 화면 ${total} · 전 단계 완료 ${done} (${total ? Math.round(done * 100 / total) : 0}%)</h3>
    <div class="bar"><div style="width:${total ? Math.round(done * 100 / total) : 0}%"></div></div>
    <div class="stages">${perStage.map(x => `<div><b>${esc(x.st.label)}</b> ${x.n}/${total}</div>`).join('')}</div>
    <div class="legend"><span class="ok">● 완료</span> <span class="warn">◐ 부분/확인</span> <span class="bad">✖ 실패(BLOCK/NEEDS_HUMAN)</span> <span class="none">○ 없음</span> · 셀 클릭 = 그 단계 작업 실행 · <input id="flow-f" placeholder="ID/제목 필터" value="${esc(filter || '')}"> <button class="sec" id="flow-rf">🔁 새로고침</button></div>
    <table class="flow-tbl"><thead><tr><th>화면</th><th>제목 / 대조표 상태</th>${STAGES.map(st => `<th>${esc(st.label)}</th>`).join('')}<th>파이프라인</th><th>실행</th></tr></thead><tbody>${trs || '<tr><td colspan="99" class="hint">대상 없음 — 대조표/Doc/gen 미생성</td></tr>'}</tbody></table>
  </div>`;
}

module.exports = { open, refresh, STAGES, stageStatus, targets, innerHtml };
