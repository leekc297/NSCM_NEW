'use strict';
// Vibe_Manager 1.3.1 — 작업 이력: 화면(ID) 단위 작업 전/후 스냅샷(.vibe/history/<ID>/<ts>_<task>/{before,after}) + 화면별/일자별 목록 + 파일 diff
//   대상(FE): 페이지 폴더(nscm-fe/features/<f>/src/pages/<dir>) 전체 · 대상(DB 객체): Doc/gen/<ID>/<ID>_PKG.sql, _registration.sql, _revert.sql
//   before = 작업 시작 직전 · after = 작업 종료 시(없으면 열람 시점의 현재 상태와 비교)
const vscode = require('vscode');
const fs = require('fs');
const path = require('path');

const SNAP_TASKS = { 'S5.pipeline': 'both', 'S5.pipelinedesign': 'both', 'S5.pipelineregen': 'both', 'S5.repair': 'fe', 'S5.new': 'fe', 'S5.claude': 'fe', 'S5.pkgrepair': 'pkg', 'S5.pkg': 'pkg', 'S5.pkgdeploy': 'pkg', 'S5.regsql': 'pkg', 'S5.regcommit': 'pkg', 'S5.revertcommit': 'pkg', 'S4.one': 'both', 'S3.agent': 'docs', 'S3.docs': 'docs', 'S1.packone': 'docs' };
const ts = () => { const d = new Date(); const z = n => String(n).padStart(2, '0'); return `${d.getFullYear()}${z(d.getMonth() + 1)}${z(d.getDate())}_${z(d.getHours())}${z(d.getMinutes())}${z(d.getSeconds())}`; };
// 1.8.2: 이력 시각 = 로컬 시간 (사용자 지적 2026-10-20 — toISOString() 은 UTC 라 9시간 이르게 보였다)
//   저장: nowLocal() = 'YYYY-MM-DDTHH:mm:ss+09:00' (오프셋 포함 → 정렬·파싱 모두 가능)
//   표시: fmtLocal(s) = 어떤 저장값이든(구 UTC 'Z' 포함) Date 로 파싱해 로컬 'YYYY-MM-DD HH:mm:ss' 로
const z2 = n => String(n).padStart(2, '0');
function nowLocal(d = new Date()) {
  const off = -d.getTimezoneOffset(); const sg = off >= 0 ? '+' : '-'; const a = Math.abs(off);
  return `${d.getFullYear()}-${z2(d.getMonth() + 1)}-${z2(d.getDate())}T${z2(d.getHours())}:${z2(d.getMinutes())}:${z2(d.getSeconds())}${sg}${z2(Math.floor(a / 60))}:${z2(a % 60)}`;
}
function fmtLocal(s, len = 19) {
  if (!s) return ''; const d = new Date(s); if (isNaN(d.getTime())) return String(s).replace('T', ' ').slice(0, len);
  return `${d.getFullYear()}-${z2(d.getMonth() + 1)}-${z2(d.getDate())} ${z2(d.getHours())}:${z2(d.getMinutes())}:${z2(d.getSeconds())}`.slice(0, len);
}
const fmtTime = s => fmtLocal(s).slice(11, 19);
const fmtDate = s => fmtLocal(s).slice(0, 10);
const walk = (dir, base = dir, out = []) => { if (!fs.existsSync(dir)) return out; for (const e of fs.readdirSync(dir, { withFileTypes: true })) { const f = path.join(dir, e.name); if (e.isDirectory()) { if (!/node_modules|\.git/.test(e.name)) walk(f, base, out); } else out.push(path.relative(base, f)); } return out; };
const copyTree = (src, dst, rels) => { for (const r of rels) { const s = path.join(src, r), d = path.join(dst, r); fs.mkdirSync(path.dirname(d), { recursive: true }); try { fs.copyFileSync(s, d); } catch { } } };

function sources(p, id, scope) {
  const g = path.join(p.genDir, id); const out = [];
  if (scope === 'fe' || scope === 'both') { const pd = p.pageDirOf(id); if (pd && fs.existsSync(pd)) out.push({ name: 'fe', dir: pd, rels: walk(pd) }); }
  if (scope === 'pkg' || scope === 'both') { const rels = [`${id}_PKG.sql`, `${id}_registration.sql`, `${id}_revert.sql`, `${id}_PKG_NOTES.md`].filter(f => fs.existsSync(path.join(g, f))); out.push({ name: 'db', dir: g, rels }); }
  if (scope === 'docs' || scope === 'both') { const ad = path.join(p.outDir, 'agent', id); if (fs.existsSync(ad)) out.push({ name: 'docs', dir: ad, rels: walk(ad).filter(f => /\.md$/.test(f) && !/^_/.test(f)) }); const gp = path.join(p.gapDir, `${id}_gap.csv`); if (fs.existsSync(gp)) out.push({ name: 'gap', dir: p.gapDir, rels: [`${id}_gap.csv`] }); }
  return out;
}
// 1.8.0: scopeOverride — SNAP_TASKS 에 없는 작업(Claude 프롬프트·🛠️/🧯 보완 등)도 'both' 로 스냅샷을 남긴다
function begin(p, id, taskId, note, scopeOverride) {
  const scope = scopeOverride || SNAP_TASKS[taskId]; if (!scope || !id) return null;
  const dir = path.join(p.vibeDir, 'history', id, `${ts()}_${taskId.replace(/[^\w.]/g, '_')}`);
  const before = path.join(dir, 'before'); fs.mkdirSync(before, { recursive: true });
  const srcs = sources(p, id, scope); for (const s of srcs) copyTree(s.dir, path.join(before, s.name), s.rels);
  const meta = { id, task: taskId, scope, note: note || '', start: nowLocal(), end: null, exit: null, sources: srcs.map(s => ({ name: s.name, dir: s.dir, files: s.rels.length })) };
  fs.writeFileSync(path.join(dir, 'meta.json'), JSON.stringify(meta, null, 2), 'utf8'); return dir;
}
// 1.8.0: afterMode — 'end'(작업 종료 시점 = 진짜 수정후) / 'view'(작업후 미기록이라 열람 시점의 현재 상태로 대체).
//   사용자 지적(2026-10-20): 열람 시점 스냅샷을 '작업후'처럼 보여주면 수정후가 아니라 '현재'와 비교하게 된다 → 모드를 기록하고 UI/diff 제목에 구분 표시.
//   'view' 로 기록된 뒤 실제 종료(finish 'end')가 오면 덮어쓴다. 이미 'end' 인 이력은 'view' 로 덮어쓰지 않는다.
function finish(p, dir, exit, afterMode) {
  if (!dir || !fs.existsSync(path.join(dir, 'meta.json'))) return;
  const meta = JSON.parse(fs.readFileSync(path.join(dir, 'meta.json'), 'utf8'));
  const mode = afterMode || 'end';
  if (mode === 'view' && meta.afterMode === 'end') return;
  const after = path.join(dir, 'after'); fs.rmSync(after, { recursive: true, force: true }); fs.mkdirSync(after, { recursive: true });
  for (const s of sources(p, meta.id, meta.scope)) copyTree(s.dir, path.join(after, s.name), s.rels);
  if (mode === 'end') { meta.end = nowLocal(); meta.exit = exit; }
  meta.afterMode = mode; meta.afterAt = nowLocal(); meta.changed = changedFiles(dir);
  fs.writeFileSync(path.join(dir, 'meta.json'), JSON.stringify(meta, null, 2), 'utf8');
}
const afterLabel = meta => meta && meta.afterMode === 'view' ? `열람시점 현재(${fmtLocal(meta.afterAt, 16).slice(5)}) · 작업후 미기록` : '작업후';
function changedFiles(dir) {
  const b = path.join(dir, 'before'), a = path.join(dir, 'after'); const all = new Set([...walk(b), ...walk(a)]); const out = [];
  for (const r of all) { const fb = path.join(b, r), fa = path.join(a, r); const eb = fs.existsSync(fb), ea = fs.existsSync(fa); if (!eb) out.push({ file: r, kind: 'added' }); else if (!ea) out.push({ file: r, kind: 'deleted' }); else if (fs.readFileSync(fb).compare(fs.readFileSync(fa)) !== 0) out.push({ file: r, kind: 'modified' }); }
  return out;
}
function list(p) {
  const root = path.join(p.vibeDir, 'history'); if (!fs.existsSync(root)) return [];
  const out = [];
  for (const id of fs.readdirSync(root)) { const d = path.join(root, id); if (!fs.statSync(d).isDirectory()) continue; for (const e of fs.readdirSync(d)) { const m = path.join(d, e, 'meta.json'); if (!fs.existsSync(m)) continue; try { const meta = JSON.parse(fs.readFileSync(m, 'utf8')); meta.dir = path.join(d, e); meta.date = fmtDate(meta.start); meta.startKey = isNaN(new Date(meta.start || '').getTime()) ? String(meta.start || '') : new Date(meta.start).toISOString(); if (!meta.afterMode && meta.end && meta.exit !== 'live') meta.afterMode = 'end'; if (meta.exit === 'live' && !meta.afterMode) meta.afterMode = 'view'; if (!meta.afterMode) meta.changed = null; out.push(meta); } catch { } } }
  return out.sort((a, b) => (b.startKey || '').localeCompare(a.startKey || '')); // 구(UTC Z)·신(로컬+오프셋) 혼재 정렬은 UTC 환산 키로
}
function currentSnapshot(p, meta) {
  // after 가 없으면(비동기 Claude 작업 등) 열람 시점 현재 상태로 비교하되 'view' 로 표시 — '작업후' 로 가장하지 않는다
  finish(p, meta.dir, meta.exit, 'view');
}

let panel = null;
function open(api) {
  const render = () => { const p = api.paths(); panel.webview.html = html(list(p), panel._mode || 'screen', panel._sel || ''); };
  if (panel) { panel.reveal(); render(); return; }
  panel = vscode.window.createWebviewPanel('vibeManager.history', '작업 이력 — Vibe_Manager', vscode.ViewColumn.One, { enableScripts: true, retainContextWhenHidden: true });
  panel.onDidDispose(() => { panel = null; });
  panel.webview.onDidReceiveMessage(async m => {
    const p = api.paths();
    if (m.type === 'mode') { panel._mode = m.mode; render(); }
    else if (m.type === 'select') { panel._sel = m.dir; const meta = list(p).find(x => x.dir === m.dir); if (meta && !meta.end) currentSnapshot(p, meta); render(); }
    else if (m.type === 'diff') { const b = path.join(m.dir, 'before', m.file), a = path.join(m.dir, 'after', m.file); const L = fs.existsSync(b) ? vscode.Uri.file(b) : vscode.Uri.parse('untitled:(없음)'); const R = fs.existsSync(a) ? vscode.Uri.file(a) : vscode.Uri.parse('untitled:(삭제됨)'); vscode.commands.executeCommand('vscode.diff', L, R, `${path.basename(m.dir)} — ${m.file} (작업전 ↔ 작업후)`); }
    else if (m.type === 'diffLive') { const b = path.join(m.dir, 'after', m.file); const meta = JSON.parse(fs.readFileSync(path.join(m.dir, 'meta.json'), 'utf8')); const src = (meta.sources || []).find(s => m.file.startsWith(s.name + path.sep) || m.file.startsWith(s.name + '/')); const live = src ? path.join(src.dir, m.file.slice(src.name.length + 1)) : ''; if (live && fs.existsSync(live)) vscode.commands.executeCommand('vscode.diff', vscode.Uri.file(b), vscode.Uri.file(live), `${m.file} (작업후 ↔ 현재)`); else vscode.window.showWarningMessage('현재 파일 없음'); }
    else if (m.type === 'openDir') api.openPath(m.dir);
    else if (m.type === 'refresh') render();
    else if (m.type === 'delete') { const ok = await vscode.window.showWarningMessage(`이력 삭제: ${path.basename(m.dir)}`, { modal: true }, '삭제'); if (ok === '삭제') { fs.rmSync(m.dir, { recursive: true, force: true }); panel._sel = ''; render(); } }
  });
  render();
}
function html(items, mode, sel) {
  const esc = s => String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;');
  const groups = {}; for (const it of items) { const k = mode === 'date' ? it.date : it.id; (groups[k] = groups[k] || []).push(it); }
  const keys = Object.keys(groups).sort((a, b) => mode === 'date' ? b.localeCompare(a) : a.localeCompare(b));
  const row = it => `<div class="it${it.dir === sel ? ' sel' : ''}" data-dir="${esc(it.dir)}"><b>${esc(it.id)}</b> <span class="task">${esc(it.task)}</span> <span class="when">${esc(fmtLocal(it.start))}</span> <span class="st ${it.exit === 0 ? 'ok' : it.end ? 'bad' : 'run'}">${it.exit === 0 ? '✓' : it.end ? `exit ${esc(it.exit)}` : '진행중/미종료'}</span> <span class="n">${it.changed ? `변경 ${it.changed.length}` : ''}</span>${it.note ? `<div class="note">${esc(it.note)}</div>` : ''}</div>`;
  const left = keys.map(k => `<details open><summary>${esc(k)} <span class="n">(${groups[k].length})</span></summary>${groups[k].map(row).join('')}</details>`).join('');
  const cur = items.find(i => i.dir === sel); let right = '<div class="hint">왼쪽에서 이력을 선택하면 변경 파일 목록이 나옵니다. 파일 클릭 = 작업전 ↔ 작업후 diff.</div>';
  if (cur) {
    const ch = cur.changed || []; const by = { fe: [], db: [], docs: [], gap: [] }; for (const c of ch) (by[c.file.split(/[\\/]/)[0]] = by[c.file.split(/[\\/]/)[0]] || []).push(c);
    const sect = (name, label) => (by[name] || []).length ? `<h4>${label} (${by[name].length})</h4>${by[name].map(c => `<div class="f ${c.kind}" data-file="${esc(c.file)}"><span class="k">${c.kind === 'added' ? '＋' : c.kind === 'deleted' ? '－' : '±'}</span> ${esc(c.file.split(/[\\/]/).slice(1).join('/'))} <button class="sec live" data-file="${esc(c.file)}">현재와</button></div>`).join('')}` : '';
    right = `<h3>${esc(cur.id)} · ${esc(cur.task)} · ${esc(fmtLocal(cur.start))}${cur.end ? ` → ${esc(fmtTime(cur.end))}` : ''}</h3><div class="row"><button class="sec" id="od">폴더 열기</button><button class="sec" id="del">이력 삭제</button></div>${ch.length ? sect('fe', 'FE 페이지') + sect('db', 'DB 객체 (PKG · 등록 · 되돌리기 SQL)') + sect('docs', '문서') + sect('gap', 'GAP') : '<div class="hint">변경 없음</div>'}`;
  }
  return `<!doctype html><html><head><meta charset="utf-8"><style>
body{font:12px var(--vscode-font-family);color:var(--vscode-foreground);margin:0;display:flex;height:100vh}
#l{width:46%;overflow:auto;padding:8px 10px;border-right:1px solid var(--vscode-editorWidget-border,#444)}#r{flex:1;overflow:auto;padding:8px 12px}
.it{padding:4px 6px;border-radius:3px;cursor:pointer;margin:2px 0}.it:hover{background:var(--vscode-list-hoverBackground)}.it.sel{background:var(--vscode-list-activeSelectionBackground);color:var(--vscode-list-activeSelectionForeground)}
.task{opacity:.8}.when{opacity:.6;font-size:11px}.n{opacity:.6;font-size:11px}.note{font-size:11px;opacity:.7}
.st.ok{color:#3fb950}.st.bad{color:#f85149}.st.run{color:#d29922}
.f{padding:2px 4px;cursor:pointer}.f:hover{background:var(--vscode-list-hoverBackground)}.f .k{display:inline-block;width:14px}.f.added .k{color:#3fb950}.f.deleted .k{color:#f85149}.f.modified .k{color:#d29922}
button{background:var(--vscode-button-background);color:var(--vscode-button-foreground);border:0;padding:2px 7px;margin:1px;cursor:pointer;border-radius:2px;font-size:11px}button.sec{background:var(--vscode-button-secondaryBackground);color:var(--vscode-button-secondaryForeground)}
.tabs button.on{outline:1px solid var(--vscode-focusBorder)}summary{cursor:pointer;font-weight:600;margin-top:6px}.hint{opacity:.6}h3{margin:4px 0}h4{margin:10px 0 4px 0}
</style></head><body><div id="l"><div class="tabs"><button class="sec${mode === 'screen' ? ' on' : ''}" data-m="screen">화면별</button><button class="sec${mode === 'date' ? ' on' : ''}" data-m="date">일자별</button><button class="sec" id="rf">새로고침</button> <span class="n">${items.length}건 · .vibe/history</span></div>${left || '<div class="hint">이력 없음 — 파이프라인/수선/PKG/등록 작업을 실행하면 작업 전·후 스냅샷이 쌓입니다.</div>'}</div><div id="r">${right}</div>
<script>const vscode=acquireVsCodeApi();const SEL=${JSON.stringify(sel)};
document.querySelectorAll('.tabs button[data-m]').forEach(b=>b.onclick=()=>vscode.postMessage({type:'mode',mode:b.dataset.m}));
document.getElementById('rf').onclick=()=>vscode.postMessage({type:'refresh'});
document.querySelectorAll('.it').forEach(e=>e.onclick=()=>vscode.postMessage({type:'select',dir:e.dataset.dir}));
document.querySelectorAll('.f').forEach(e=>e.onclick=ev=>{if(ev.target.classList.contains('live'))return;vscode.postMessage({type:'diff',dir:SEL,file:e.dataset.file});});
document.querySelectorAll('.live').forEach(b=>b.onclick=ev=>{ev.stopPropagation();vscode.postMessage({type:'diffLive',dir:SEL,file:b.dataset.file});});
const od=document.getElementById('od');if(od)od.onclick=()=>vscode.postMessage({type:'openDir',dir:SEL});
const del=document.getElementById('del');if(del)del.onclick=()=>vscode.postMessage({type:'delete',dir:SEL});
</script></body></html>`;
}
// 워크벤치 내부 탭용: 콘텐츠 영역만 반환 (events 는 workbench.js 에서 history:* 로 처리)
function innerHtml(p, mode, sel) {
  const esc = s => String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/"/g, '&quot;');
  const items = list(p);
  const groups = {}; for (const it of items) { const k = mode === 'date' ? it.date : it.id; (groups[k] = groups[k] || []).push(it); }
  const keys = Object.keys(groups).sort((a, b) => mode === 'date' ? b.localeCompare(a) : a.localeCompare(b));
  const row = it => `<div class="hit${it.dir === sel ? ' hsel' : ''}" data-dir="${esc(it.dir)}"><b>${esc(it.id)}</b> <span class="task">${esc(it.task)}</span> <span class="when">${esc(fmtLocal(it.start))}</span> <span class="st ${it.exit === 0 ? 'ok' : it.end ? 'bad' : 'run'}">${it.exit === 0 ? '✓' : it.end ? `exit ${esc(it.exit)}` : '진행중'}</span> <span class="n">${it.changed ? `변경 ${it.changed.length}` : ''}${it.afterMode === 'view' ? ' · ⚠ 작업후 미기록(열람시점 비교)' : ''}</span>${it.note ? `<div class="note">${esc(it.note)}</div>` : ''}</div>`;
  const left = keys.map(k => `<details open><summary>${mode === 'date' ? '📅' : '🎯'} ${esc(k)} <span class="n">(${groups[k].length})</span></summary>${groups[k].map(row).join('')}</details>`).join('');
  const cur = items.find(i => i.dir === sel);
  let right = '<div class="hint">왼쪽에서 이력을 선택하면 변경 파일 목록이 나옵니다. 파일 클릭 = 수정전(작업 시작 직전) ↔ 수정후(작업 종료 시점) diff · "현재와" = 수정후 ↔ 지금 파일.</div>';
  if (cur) {
    const ch = cur.changed || []; const by = { fe: [], db: [], docs: [], gap: [] };
    for (const c of ch) { const k = c.file.split(/[\\/]/)[0]; (by[k] = by[k] || []).push(c); }
    const sect = (name, label) => (by[name] || []).length ? `<h4>${label} (${by[name].length})</h4>${by[name].map(c => `<div class="hf ${c.kind}" data-file="${esc(c.file)}" data-dir="${esc(cur.dir)}" title="클릭 = 수정전 ↔ 수정후"><span class="k">${c.kind === 'added' ? '＋' : c.kind === 'deleted' ? '－' : '±'}</span> ${esc(c.file.split(/[\\/]/).slice(1).join('/'))} <button class="sec hlive" data-file="${esc(c.file)}" data-dir="${esc(cur.dir)}" title="수정후 ↔ 현재 파일">현재와</button></div>`).join('')}` : '';
    const afterInfo = cur.afterMode === 'view'
      ? `<div class="hint" style="color:#d29922">⚠ 이 이력은 작업 종료 시점의 '수정후' 가 기록되지 않아 <b>열람 시점(${esc(fmtLocal(cur.afterAt, 16))}) 의 현재 상태</b>와 비교 중입니다 — 그 사이 다른 작업의 변경이 섞일 수 있습니다.</div>`
      : `<div class="hint">수정전 = ${esc(fmtLocal(cur.start))} 작업 시작 직전 · 수정후 = ${esc(fmtLocal(cur.end))} 작업 종료 시점 (로컬 시간)</div>`;
    right = `<h3>🕒 ${esc(cur.id)} · ${esc(cur.task)} · ${esc(fmtLocal(cur.start))}${cur.end ? ` → ${esc(fmtTime(cur.end))}` : ''}</h3>${afterInfo}<div class="row"><button class="sec" id="hist-od" data-dir="${esc(cur.dir)}">📁 폴더 열기</button><button class="sec" id="hist-del" data-dir="${esc(cur.dir)}">🗑️ 이력 삭제</button></div>${ch.length ? sect('fe', '🎨 FE 페이지') + sect('db', '🗄️ DB 객체 (PKG · 등록 · 되돌리기 SQL)') + sect('docs', '📚 문서') + sect('gap', '🔍 GAP') : '<div class="hint">변경 없음</div>'}`;
  }
  return `<div class="hist-root">
    <div class="hist-top"><button class="sec${mode === 'screen' ? ' on' : ''}" data-hmode="screen">🎯 화면별</button><button class="sec${mode === 'date' ? ' on' : ''}" data-hmode="date">📅 일자별</button><button class="sec" id="hist-rf">🔁 새로고침</button> <span class="n">${items.length}건 · .vibe/history</span></div>
    <div class="hist-cols"><div class="hist-l">${left || '<div class="hint">이력 없음 — 파이프라인/수선/PKG/등록 작업을 실행하면 작업 전·후 스냅샷이 쌓입니다.</div>'}</div><div class="hist-r">${right}</div></div>
  </div>`;
}

module.exports = { begin, finish, list, open, SNAP_TASKS, innerHtml, afterLabel, nowLocal, fmtLocal };
