'use strict';
// Vibe_Manager 1.9.0 — Workbench 내부 탭 뷰어(열기 류를 새 창/에디터 대신 Workbench 탭으로)
//   md → 렌더링 · csv → 표 · json/sql/ts/js/log/txt… → 코드 보기(줄번호) · 폴더 → 목록 · 두 텍스트 → 줄 단위 diff
//   제외(외부 프로그램): xlsx/docx/pdf/zip 등 바이너리 → OS 기본 프로그램, http(s) → 브라우저
const fs = require('fs'); const path = require('path');

const esc = s => String(s == null ? '' : s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
const IMG_RE = /\.(png|jpe?g|gif|svg|webp|bmp|ico)$/i;
const BIN_RE = /\.(xlsx|xlsm|xls|docx|doc|pptx|ppt|pdf|zip|7z|rar|gz|vsix|exe|dll|jar|class|woff2?|ttf|otf|mp4|mp3|db|sqlite)$/i;
const TEXT_MAX = 2 * 1024 * 1024;
const CSV_MAX_ROWS = 3000;

function kindOf(file) {
  if (fs.existsSync(file) && fs.statSync(file).isDirectory()) return 'folder';
  if (IMG_RE.test(file)) return 'image';
  if (BIN_RE.test(file)) return 'binary';
  const ext = path.extname(file).toLowerCase();
  if (ext === '.md' || ext === '.markdown') return 'md';
  if (ext === '.csv' || ext === '.tsv') return 'csv';
  return 'code';
}

// ── Markdown(생성 문서 수준: 제목·표·목록·코드펜스·인용·구분선·강조·링크·체크) ──
function mdToHtml(md, opts = {}) {
  const baseDir = opts.baseDir || '.'; const root = opts.root || '';
  // 인라인: 코드·굵게·기울임·취소 · 링크(http → 브라우저, 그 외 → 탭) · 생문자 경로(Doc/… C:\… — 실존할 때만 클릭) · ✅/❌ 색
  const inlX = s => { let t = esc(s);
    t = t.replace(/`([^`]+)`/g, (m, c) => `<code>${c}</code>`);
    t = t.replace(/\*\*([^*]+)\*\*/g, '<b>$1</b>').replace(/(^|[^*\w])\*([^*\n]+)\*(?!\w)/g, '$1<i>$2</i>').replace(/~~([^~]+)~~/g, '<s>$1</s>');
    t = t.replace(/\[([^\]]+)\]\(([^)\s]+)\)/g, (m, txt, href) => { if (/^https?:\/\//i.test(href)) return `<a data-ext="${esc(href)}">${txt}</a>`; const abs = path.isAbsolute(href) ? href : path.resolve(baseDir, href); return `<a data-open="${esc(abs)}" title="${esc(abs)}">${txt}</a>`; });
    t = t.replace(/(?<![\w"=/\\>])((?:[A-Za-z]:[\\/]|(?:Doc|tools|nscm-fe|nscm-be|_artifacts)[\\/])[^\s<>"'`|)\]]+)/g, (m, pth) => { const abs = path.isAbsolute(pth) ? pth : path.join(root || baseDir, pth); return fs.existsSync(abs) ? `<a data-open="${esc(abs)}" class="pth">${m}</a>` : m; });
    return t.replace(/✅/g, '<span class="okk">✅</span>').replace(/❌|✖/g, m => `<span class="badd">${m}</span>`); };
  const lines = String(md || '').replace(/\r\n?/g, '\n').split('\n'); const out = []; let i = 0;
  const listStack = []; // {indent, type}
  const closeLists = (toIndent = -1) => { while (listStack.length && listStack[listStack.length - 1].indent > toIndent) out.push(listStack.pop().type === 'ol' ? '</ol>' : '</ul>'); };
  let para = [];
  const flushPara = () => { if (para.length) { out.push(`<p>${para.map(inlX).join('<br>')}</p>`); para = []; } };
  while (i < lines.length) {
    const ln = lines[i];
    // 코드펜스
    const fm = /^\s*(```|~~~)\s*(\w+)?/.exec(ln);
    if (fm) { flushPara(); closeLists(); const fence = fm[1]; const lang = fm[2] || ''; const buf = []; i++; while (i < lines.length && !lines[i].trim().startsWith(fence)) buf.push(lines[i++]); i++; out.push(`<pre class="mdcode" data-lang="${esc(lang)}"><code>${esc(buf.join('\n'))}</code></pre>`); continue; }
    if (/^\s*$/.test(ln)) { flushPara(); closeLists(); i++; continue; }
    const h = /^(#{1,6})\s+(.*)$/.exec(ln);
    if (h) { flushPara(); closeLists(); const lv = h[1].length; const txt = h[2].replace(/\s#+$/, ''); out.push(`<h${lv} id="${esc(txt.toLowerCase().replace(/[^\w가-힣]+/g, '-'))}">${inlX(txt)}</h${lv}>`); i++; continue; }
    if (/^\s*(-{3,}|\*{3,}|_{3,})\s*$/.test(ln)) { flushPara(); closeLists(); out.push('<hr>'); i++; continue; }
    // 표: | a | b | 다음 줄이 |---|---|
    if (/^\s*\|.*\|\s*$/.test(ln) && i + 1 < lines.length && /^\s*\|?\s*:?-{2,}:?\s*(\|\s*:?-{2,}:?\s*)*\|?\s*$/.test(lines[i + 1])) {
      flushPara(); closeLists();
      const cells = l => l.trim().replace(/^\|/, '').replace(/\|$/, '').split(/(?<!\\)\|/).map(c => c.trim().replace(/\\\|/g, '|'));
      const head = cells(ln); const aligns = cells(lines[i + 1]).map(a => /^:-+:$/.test(a) ? 'center' : /-+:$/.test(a) ? 'right' : 'left');
      i += 2; const rows = []; while (i < lines.length && /^\s*\|.*\|\s*$/.test(lines[i])) rows.push(cells(lines[i++]));
      out.push(`<div class="mdtw"><table class="mdt"><thead><tr>${head.map((c, k) => `<th style="text-align:${aligns[k] || 'left'}">${inlX(c)}</th>`).join('')}</tr></thead><tbody>${rows.map(r => `<tr>${head.map((_, k) => `<td style="text-align:${aligns[k] || 'left'}">${inlX(r[k] || '')}</td>`).join('')}</tr>`).join('')}</tbody></table><div class="mdtn">${rows.length}행</div></div>`);
      continue;
    }
    const q = /^\s*>\s?(.*)$/.exec(ln);
    if (q) { flushPara(); closeLists(); const buf = [q[1]]; i++; while (i < lines.length && /^\s*>/.test(lines[i])) buf.push(lines[i++].replace(/^\s*>\s?/, '')); out.push(`<blockquote>${buf.map(inlX).join('<br>')}</blockquote>`); continue; }
    const li = /^(\s*)([-*+]|\d+[.)])\s+(.*)$/.exec(ln);
    if (li) {
      flushPara(); const indent = li[1].replace(/\t/g, '  ').length; const type = /\d/.test(li[2]) ? 'ol' : 'ul'; let txt = li[3];
      const cb = /^\[( |x|X)\]\s*(.*)$/.exec(txt); if (cb) txt = `<input type="checkbox" disabled${cb[1] !== ' ' ? ' checked' : ''}> ${cb[2]}`;
      if (!listStack.length || indent > listStack[listStack.length - 1].indent) { listStack.push({ indent, type }); out.push(type === 'ol' ? '<ol>' : '<ul>'); }
      else { closeLists(indent); if (!listStack.length || listStack[listStack.length - 1].indent < indent) { listStack.push({ indent, type }); out.push(type === 'ol' ? '<ol>' : '<ul>'); } }
      out.push(`<li>${cb ? txt.replace(/^(<input[^>]*>) (.*)$/, (m, a, b) => a + ' ' + inlX(b)) : inlX(txt)}</li>`); i++; continue;
    }
    // 들여쓴 연속 줄은 직전 목록 항목에 붙인다
    if (listStack.length && /^\s{2,}\S/.test(ln)) { out[out.length - 1] = out[out.length - 1].replace(/<\/li>$/, `<br>${inlX(ln.trim())}</li>`); i++; continue; }
    closeLists(); para.push(ln); i++;
  }
  flushPara(); closeLists();
  return `<div class="mdv">${out.join('\n')}</div>`;
}

// ── CSV ──
function parseCsv(text) { text = String(text || '').replace(/^\uFEFF/, ''); const rows = []; let row = [], f = '', q = false; for (let i = 0; i < text.length; i++) { const ch = text[i]; if (q) { if (ch === '"') { if (text[i + 1] === '"') { f += '"'; i++; } else q = false; } else f += ch; } else if (ch === '"') q = true; else if (ch === ',') { row.push(f); f = ''; } else if (ch === '\n' || ch === '\r') { if (ch === '\r' && text[i + 1] === '\n') i++; row.push(f); rows.push(row); row = []; f = ''; } else f += ch; } if (f || row.length) { row.push(f); rows.push(row); } return rows.filter(r => r.length > 1 || (r[0] || '').trim()); }
function csvToTable(text) {
  const rows = parseCsv(text); if (!rows.length) return '<div class="hint">빈 CSV</div>';
  const head = rows[0]; const body = rows.slice(1); const shown = body.slice(0, CSV_MAX_ROWS);
  const st = v => /^(PASS|OK|Y|완료|ok)$/i.test(v) ? ' class="okk"' : /^(FAIL|BLOCK|ERROR|N|✗|✖)$/i.test(v) ? ' class="badd"' : /^(WARN|FLAKY|SKIP|⚠)$/i.test(v) ? ' class="warnn"' : '';
  return `<div class="csvw"><div class="csvn">${body.length}행 × ${head.length}열${body.length > CSV_MAX_ROWS ? ` · 앞 ${CSV_MAX_ROWS}행만 표시` : ''} · <input class="csvf" placeholder="필터(포함 검색)"></div><table class="csvt"><thead><tr><th>#</th>${head.map(h => `<th>${esc(h)}</th>`).join('')}</tr></thead><tbody>${shown.map((r, i) => `<tr><td class="ln">${i + 1}</td>${head.map((_, k) => `<td${st(r[k] || '')}>${esc(r[k] || '')}</td>`).join('')}</tr>`).join('')}</tbody></table></div>`;
}

// ── 코드(줄번호) ──
function codeView(text, ext, hiLine) {
  const lines = String(text || '').replace(/\r\n?/g, '\n').split('\n');
  return `<div class="codew" data-ext="${esc(ext)}"><table class="codet"><tbody>${lines.map((l, i) => `<tr id="L${i + 1}"${hiLine === i + 1 ? ' class="hl"' : ''}><td class="ln">${i + 1}</td><td class="cd">${esc(l) || ' '}</td></tr>`).join('')}</tbody></table></div>`;
}

// ── 폴더 ──
function folderView(dir) {
  let ents = []; try { ents = fs.readdirSync(dir, { withFileTypes: true }); } catch (e) { return `<div class="hint">읽기 실패: ${esc(e.message)}</div>`; }
  const rows = ents.filter(e => !e.name.startsWith('.git')).map(e => { const full = path.join(dir, e.name); let st = null; try { st = fs.statSync(full); } catch { } return { name: e.name, dir: e.isDirectory(), size: st ? st.size : 0, mtime: st ? st.mtime : null, full }; }).sort((a, b) => (a.dir === b.dir ? a.name.localeCompare(b.name) : a.dir ? -1 : 1));
  const fmtSize = n => n < 1024 ? `${n} B` : n < 1048576 ? `${(n / 1024).toFixed(1)} KB` : `${(n / 1048576).toFixed(1)} MB`;
  const fmtT = d => d ? new Date(d.getTime() - d.getTimezoneOffset() * 60000).toISOString().slice(0, 16).replace('T', ' ') : '';
  const icon = r => r.dir ? '📁' : /\.md$/i.test(r.name) ? '📝' : /\.csv$/i.test(r.name) ? '📊' : /\.(xlsx|xlsm)$/i.test(r.name) ? '📗' : /\.(sql|pks|pkb)$/i.test(r.name) ? '🗄️' : /\.(json)$/i.test(r.name) ? '🧾' : IMG_RE.test(r.name) ? '🖼️' : '📄';
  const parent = path.dirname(dir);
  return `<div class="folderw"><div class="csvn">${rows.length}개 · <a data-open="${esc(parent)}">⬆ 상위 폴더</a></div><table class="csvt folder"><thead><tr><th></th><th>이름</th><th>크기</th><th>수정</th></tr></thead><tbody>${rows.map(r => `<tr><td>${icon(r)}</td><td><a data-open="${esc(r.full)}">${esc(r.name)}</a></td><td class="num">${r.dir ? '' : fmtSize(r.size)}</td><td class="mono">${fmtT(r.mtime)}</td></tr>`).join('')}</tbody></table></div>`;
}

// ── 줄 단위 diff(LCS) — 공통 접두/접미 제거 후 DP, 너무 크면 중간을 통째로 교체 표시 ──
function lineDiff(aText, bText) {
  const A = String(aText || '').replace(/\r\n?/g, '\n').split('\n'); const B = String(bText || '').replace(/\r\n?/g, '\n').split('\n');
  let s = 0; while (s < A.length && s < B.length && A[s] === B[s]) s++;
  let ea = A.length, eb = B.length; while (ea > s && eb > s && A[ea - 1] === B[eb - 1]) { ea--; eb--; }
  const a = A.slice(s, ea), b = B.slice(s, eb); const ops = [];
  for (let i = 0; i < s; i++) ops.push({ t: ' ', a: i + 1, b: i + 1, text: A[i] });
  if (a.length * b.length > 4_000_000) { a.forEach((l, i) => ops.push({ t: '-', a: s + i + 1, b: null, text: l })); b.forEach((l, i) => ops.push({ t: '+', a: null, b: s + i + 1, text: l })); }
  else {
    const n = a.length, m = b.length; const dp = new Array(n + 1); for (let i = 0; i <= n; i++) dp[i] = new Uint32Array(m + 1);
    for (let i = n - 1; i >= 0; i--) for (let j = m - 1; j >= 0; j--) dp[i][j] = a[i] === b[j] ? dp[i + 1][j + 1] + 1 : Math.max(dp[i + 1][j], dp[i][j + 1]);
    let i = 0, j = 0; while (i < n && j < m) { if (a[i] === b[j]) { ops.push({ t: ' ', a: s + i + 1, b: s + j + 1, text: a[i] }); i++; j++; } else if (dp[i + 1][j] >= dp[i][j + 1]) { ops.push({ t: '-', a: s + i + 1, b: null, text: a[i] }); i++; } else { ops.push({ t: '+', a: null, b: s + j + 1, text: b[j] }); j++; } }
    while (i < n) { ops.push({ t: '-', a: s + i + 1, b: null, text: a[i] }); i++; } while (j < m) { ops.push({ t: '+', a: null, b: s + j + 1, text: b[j] }); j++; }
  }
  for (let k = 0; k < A.length - ea; k++) ops.push({ t: ' ', a: ea + k + 1, b: eb + k + 1, text: A[ea + k] });
  return ops;
}
function diffHtml(aText, bText, aLabel, bLabel, ctx = 3) {
  const ops = lineDiff(aText, bText); const add = ops.filter(o => o.t === '+').length, del = ops.filter(o => o.t === '-').length;
  // 변경 주변 ctx 줄만(전체 보기 토글은 웹뷰에서 .diffw.all)
  const keep = new Set(); ops.forEach((o, i) => { if (o.t !== ' ') for (let k = Math.max(0, i - ctx); k <= Math.min(ops.length - 1, i + ctx); k++) keep.add(k); });
  let rows = ''; let lastShown = -1;
  ops.forEach((o, i) => { const hidden = !keep.has(i); if (!hidden && lastShown >= 0 && i - lastShown > 1) rows += `<tr class="gap"><td colspan="3">… ${i - lastShown - 1}줄 동일 …</td></tr>`; rows += `<tr class="d${o.t === '+' ? 'add' : o.t === '-' ? 'del' : 'eq'}${hidden ? ' ctxh' : ''}"><td class="ln">${o.a || ''}</td><td class="ln">${o.b || ''}</td><td class="cd">${o.t === ' ' ? '&nbsp;' : o.t}${esc(o.text) || ' '}</td></tr>`; if (!hidden) lastShown = i; });
  return `<div class="diffw"><div class="csvn"><span class="badd">−${del}</span> <span class="okk">+${add}</span> · 왼쪽 줄번호 = ${esc(aLabel)} · 오른쪽 = ${esc(bLabel)} · <label><input type="checkbox" class="diffall"> 전체 줄 보기</label></div><table class="codet difft"><tbody>${rows || '<tr><td colspan="3" class="hint">차이 없음</td></tr>'}</tbody></table></div>`;
}

// ── 탭 페이로드 ──
function buildTab(file, opts = {}) {
  const root = opts.root || ''; const kind = kindOf(file); const rel = root && file.startsWith(root) ? path.relative(root, file) : file;
  const base = { key: file.toLowerCase(), title: path.basename(file) || file, sub: rel, path: file, kind, editable: false, isDir: kind === 'folder', canOS: true, canEditor: kind !== 'folder' && kind !== 'binary' && kind !== 'image' };
  if (kind === 'folder') return Object.assign(base, { title: '📁 ' + base.title, html: folderView(file) });
  if (kind === 'image') return Object.assign(base, { html: `<div class="imgw"><img src="${esc(opts.imgSrc || '')}" alt="${esc(base.title)}"></div>` });
  if (kind === 'binary') return Object.assign(base, { external: true });
  let st; try { st = fs.statSync(file); } catch (e) { return Object.assign(base, { html: `<div class="hint">읽기 실패: ${esc(e.message)}</div>` }); }
  if (st.size > TEXT_MAX) return Object.assign(base, { html: `<div class="hint">파일이 큽니다(${(st.size / 1048576).toFixed(1)} MB) — 에디터로 여세요</div>` });
  const text = fs.readFileSync(file, 'utf8'); const ext = path.extname(file).toLowerCase().slice(1);
  const html = kind === 'md' ? mdToHtml(text, { baseDir: path.dirname(file), root }) : kind === 'csv' ? csvToTable(text) : codeView(text, ext, opts.line);
  return Object.assign(base, { html, text, editable: true, size: st.size, mtime: st.mtime.toISOString(), line: opts.line || 0 });
}

module.exports = { kindOf, mdToHtml, csvToTable, codeView, folderView, lineDiff, diffHtml, buildTab, esc, IMG_RE, BIN_RE };
