// orch-undo.js — VMO 가 AI 실행으로 고친 파일을 되돌릴 때 AI 가 한 편집만 거꾸로 적용한다(2026-11-20 사용자 승인 "네, 고쳐 주세요")
//   사고(2026-11-20 13:34:52): 자가 보완 20261120131344_SELF 가 게이트에서 실패해 workbench.js 를 반영 전 사본(13:23:48)으로 통째로 덮음.
//   AI 실행 도중(13:31) Claude Code 세션이 같은 파일에 넣은 편집이 함께 지워짐. 종전 보호(AI 끝난 뒤 지문 비교)는 실행 도중 들어온 편집을 구분하지 못함.
//   방식: AI 실행 기록(stream-json)에서 성공한 Edit, MultiEdit 를 읽어 뒤에서부터 새 문자열 → 이전 문자열로 바꾼다. 다른 쪽 편집은 그대로 남는다.
//   거꾸로 적용할 수 없는 경우(Write 로 통째로 씀 · 셸 명령으로 그 파일을 씀 · 새 문자열 위치가 한 곳으로 정해지지 않음 · 결과 구문 오류)는
//   부른 쪽 정책대로 사본 복원으로 가고, 이때는 덮기 전 지금 파일을 <파일>.bak_prerestore_<hhmmss> 로 남긴다.
'use strict';
const fs = require('fs'); const path = require('path'); const vm = require('vm');

const EDIT_TOOLS = new Set(['Edit', 'MultiEdit', 'Write', 'NotebookEdit']);
const SHELL_TOOLS = new Set(['Bash', 'PowerShell']);
// 셸 명령이 파일을 쓰는 형태. 읽기·시험 실행(node test/…, grep, cat, Select-String, git diff)은 해당 안 됨
const SHELL_WRITE = /(\bsed\b[^|;&]*\s-i\b|\bperl\b[^|;&]*\s-p?i\b|(^|[^>&0-9])>>?\s*[^&\s]|\bSet-Content\b|\bAdd-Content\b|\bOut-File\b|\bCopy-Item\b|\bMove-Item\b|\bRemove-Item\b|\bcp\b|\bmv\b|\brm\b|writeFile|\.write\(|open\([^)]*['"][wa]|\btee\b|\bgit\s+(checkout|restore|apply|stash)\b)/i;

// 2026-11-24 개선안 20261123215513_INC(사용자 승인): 셸 쓰기 판정을 그 파일을 쓰는 명령으로 좁힘.
//   사고: 명령 전체에 파일 이름이 있고 SHELL_WRITE 가 어디든 맞으면 쓰기로 봄. grep 정규식 안 'cp'(21:42), node 시험 출력 '> ../../.vibe/…'(21:42),
//   awk 조건 'NR>=1291'(13:13)이 쓰기로 판정돼 AI 편집만 되돌리지 못함.
//   방식: 명령을 ;, &&, ||, |, & , 줄바꿈으로 나누고(따옴표 안은 나누지 않고 연산자로 보지 않음) 조각마다 쓰기 대상을 뽑아 파일 이름과 비교.
//   쓰기 대상 = > 와 >> 뒤 경로 · sed -i, perl -i 대상 · cp, mv, Copy-Item, Move-Item 의 마지막 경로(-Destination) · Set-Content, Out-File, Add-Content, tee 의 -Path 또는 첫 경로
//   · rm, Remove-Item 대상 · git checkout/restore 대상. 대상을 정할 수 없는 쓰기(node -e 안 writeFile, git apply/stash, xargs rm, find -delete)는 종전처럼 명령에 파일 이름이 있으면 쓰기.
//   SHELL_WRITE 는 orch-usercheck.js 가 쓰므로 그대로 둔다.
const PS_VALUE_PARAMS = new Set(['path', 'literalpath', 'lp', 'pspath', 'filepath', 'destination', 'dest', 'value', 'encoding', 'filter', 'include', 'exclude', 'inputobject', 'width', 'delimiter', 'stream', 'credential', 'itemtype', 'name', 'newname', 'target', 'erroraction', 'ea']);
const PATH_PARAM = /^(path|literalpath|lp|pspath|filepath)$/;
const INLINE_WRITE = /writeFile|appendFile|copyFile|\brename(Sync)?\s*\(|\bunlink(Sync)?\s*\(|\brmSync\s*\(|\.write\(|open\([^)]*['"][wax+]|WriteAll(Text|Lines|Bytes)|AppendAll(Text|Lines)|shutil\.(copy|move)|os\.(remove|replace|rename)|\bSet-Content\b|\bAdd-Content\b|\bOut-File\b/i;

/** 셸 명령을 조각으로 나눈다. 조각 = { words:[문자열], redirs:[경로] }. 따옴표 안 글자는 낱말 값으로만 남고 연산자·명령으로 보지 않음 */
function shellSegments(cmd) {
  const s = String(cmd || ''); const segs = []; let seg = { words: [], redirs: [] }; let cur = null; let want = null; const heredocs = [];
  const endWord = () => { if (!cur) return; if (want === 'redir') seg.redirs.push(cur.v); else if (want !== 'skip') seg.words.push(cur.v); want = null; cur = null; };
  const endSeg = () => { endWord(); if (seg.words.length || seg.redirs.length) segs.push(seg); seg = { words: [], redirs: [] }; want = null; };
  const word = () => cur || (cur = { v: '' });
  let i = 0;
  while (i < s.length) {
    const ch = s[i];
    if ((ch === '@') && (s[i + 1] === "'" || s[i + 1] === '"') && /^\r?\n/.test(s.slice(i + 2, i + 4))) { // PowerShell here-string
      const q = s[i + 1]; const end = s.indexOf(`\n${q}@`, i + 2); const e = end < 0 ? s.length : end; word().v += s.slice(i + 2, e); i = end < 0 ? s.length : end + 3; continue;
    }
    if (ch === "'") { const j = s.indexOf("'", i + 1); const e = j < 0 ? s.length : j; word().v += s.slice(i + 1, e); i = e + 1; continue; }
    if (ch === '"') {
      let j = i + 1, v = '';
      while (j < s.length && s[j] !== '"') { if ((s[j] === '\\' || s[j] === '`') && j + 1 < s.length && /["\\$`]/.test(s[j + 1])) { v += s[j + 1]; j += 2; } else { v += s[j]; j++; } }
      word().v += v; i = j + 1; continue;
    }
    if (ch === '\\' && s[i + 1] === '\n') { i += 2; continue; }
    if (ch === '\\' && i + 1 < s.length && /[\s"'\\;|&<>]/.test(s[i + 1])) { word().v += s[i + 1]; i += 2; continue; }
    if (ch === '\n' || ch === '\r') {
      endSeg(); i++;
      if (ch === '\n' && heredocs.length) { // heredoc 본문은 명령이 아님
        while (heredocs.length && i < s.length) { const d = heredocs.shift(); const body = []; for (;;) { const nl = s.indexOf('\n', i); const line = s.slice(i, nl < 0 ? s.length : nl).replace(/\r$/, ''); i = nl < 0 ? s.length : nl + 1; if ((d.strip ? line.trim() : line) === d.tag) break; body.push(line); if (nl < 0) break; } d.seg.stdin = (d.seg.stdin ? d.seg.stdin + '\n' : '') + body.join('\n'); }
      }
      continue;
    }
    if (/\s/.test(ch)) { endWord(); i++; continue; }
    if (ch === ';') { endSeg(); i++; continue; }
    if (ch === '|') { endSeg(); i += (s[i + 1] === '|' || s[i + 1] === '&') ? 2 : 1; continue; }
    if (ch === '&' && s[i + 1] === '&') { endSeg(); i += 2; continue; }
    if (ch === '>' || (ch === '&' && s[i + 1] === '>')) {
      if (cur && /^(\d+|\*)$/.test(cur.v) && want !== 'redir') cur = null; else endWord();
      let j = i; if (s[j] === '&') j++; j++; if (s[j] === '>') j++; if (s[j] === '|') j++;
      if (s[j] === '&') { j++; while (j < s.length && /[\d-]/.test(s[j])) j++; i = j; continue; } // 2>&1 = 파일 아님
      want = 'redir'; i = j; continue;
    }
    if (ch === '&') { endSeg(); i++; continue; }
    if (ch === '<') {
      endWord();
      if (s[i + 1] === '<' && s[i + 2] !== '<') { // heredoc 구분자
        let j = i + 2; const strip = s[j] === '-'; if (strip) j++; while (s[j] === ' ') j++;
        const m = /^(['"]?)([A-Za-z0-9_]+)\1/.exec(s.slice(j)); if (m) { heredocs.push({ tag: m[2], strip, seg }); i = j + m[0].length; continue; }
        i += 2; continue;
      }
      want = 'skip'; i += s[i + 1] === '<' ? 3 : 1; continue;
    }
    word().v += ch; i++;
  }
  endSeg(); return segs;
}

/** 경로 낱말이 파일 이름(base)을 가리키는지. 와일드카드(*, ?)는 이름 부분만 맞춰 봄 */
function pathHits(tok, base) {
  const t = String(tok || '').replace(/\\/g, '/').toLowerCase(); const b = t.split('/').filter(Boolean).pop() || '';
  if (!b) return false; if (b === base) return true;
  if (/[*?]/.test(b)) { try { return new RegExp('^' + b.replace(/[.+^${}()|[\]]/g, '\\$&').replace(/\*/g, '.*').replace(/\?/g, '.') + '$').test(base); } catch { return false; } }
  return false;
}
/** 디렉터리 대상(rm -r, git checkout .)이 그 파일을 품는지. 실행 위치를 모르므로 '.'·'*'·경로 끝 일부가 맞으면 품는 것으로 봄 */
function dirHits(tok, rel) {
  const t = String(tok || '').replace(/\\/g, '/').toLowerCase().replace(/^\.\//, '').replace(/\/+$/, '');
  if (!t || t === '.' || t === '*' || t === ':/' || t === '..') return true;
  const r = '/' + String(rel || '').replace(/\\/g, '/').toLowerCase();
  return r.includes('/' + t + '/') || r.endsWith('/' + t);
}

/** 조각 낱말을 PowerShell 식 이름 인자·위치 인자로 나눔 */
function splitArgs(args, ps) {
  const named = {}; const pos = [];
  for (let k = 0; k < args.length; k++) {
    const a = args[k];
    if (a === '--') { pos.push(...args.slice(k + 1)); break; }
    if (/^-{1,2}[A-Za-z]/.test(a) && !/^-\d/.test(a)) {
      const m = /^-{1,2}([A-Za-z][\w-]*)(?::|=)?(.*)$/.exec(a); const name = m[1].toLowerCase();
      if (m[2]) { (named[name] = named[name] || []).push(m[2]); continue; }
      if (ps && PS_VALUE_PARAMS.has(name) && k + 1 < args.length) { (named[name] = named[name] || []).push(args[++k]); continue; }
      (named[name] = named[name] || []).push(true); continue;
    }
    pos.push(a);
  }
  return { named, pos };
}
const listVals = v => (v || []).filter(x => x !== true).flatMap(x => String(x).split(','));

/** 셸 명령 cmd 가 rel(저장소 기준 경로) 파일을 쓰는지. 쓰기 대상을 정할 수 없는 형태는 명령에 파일 이름이 있으면 쓰기 */
function shellWritesFile(cmd, rel, depth = 0) {
  const whole = String(cmd || ''); const base = path.basename(String(rel || '')).toLowerCase(); if (!base) return false;
  const named = whole.toLowerCase().includes(base);
  for (const seg of shellSegments(whole)) {
    if (seg.redirs.some(t => pathHits(t, base))) return true;
    let w = seg.words.slice();
    for (;;) { // 앞붙이 명령·환경 변수 건너뜀
      if (!w.length) break; const h = w[0].toLowerCase();
      if (/^[A-Za-z_][A-Za-z0-9_]*=/.test(w[0])) { w.shift(); continue; }
      if (['sudo', 'nohup', 'time', 'command', 'exec', 'env', 'builtin', 'nice'].includes(h)) { w.shift(); continue; }
      if (h === 'timeout') { w.shift(); while (w.length && /^-/.test(w[0])) w.shift(); w.shift(); continue; }
      break;
    }
    if (!w.length) continue;
    const c = path.basename(w[0].replace(/\\/g, '/')).toLowerCase().replace(/\.(exe|cmd|bat)$/, ''); const args = w.slice(1);
    // 감싼 셸: bash -c "…", powershell -Command "…", cmd /c …
    if (['bash', 'sh', 'zsh', 'dash', 'powershell', 'pwsh', 'cmd'].includes(c) && depth < 3) {
      const k = c === 'cmd' ? args.findIndex(a => /^\/[ck]$/i.test(a)) : ['powershell', 'pwsh'].includes(c) ? args.findIndex(a => /^-(c|command)$/i.test(a)) : args.findIndex(a => /^-[a-z]*c$/.test(a));
      const inner = k >= 0 ? (['bash', 'sh', 'zsh', 'dash'].includes(c) ? (args[k + 1] || '') : args.slice(k + 1).join(' ')) : (seg.stdin || '');
      if (inner && shellWritesFile(inner, rel, depth + 1)) return true; if (k >= 0 || seg.stdin) continue;
    }
    // 대상을 정할 수 없는 쓰기: 인터프리터 인라인 코드(-e, -c, heredoc 입력), [IO.File]::Write…
    if (['node', 'python', 'python3', 'py', 'ruby', 'deno', 'bun'].includes(c) || (c === 'perl' && !args.some(a => /^-[a-z]*i/.test(a)))) {
      const k = args.findIndex(a => /^(-e|-p|-c|--eval|--print|-pe|-ne|-le)$/.test(a)); const code = (k >= 0 ? (args[k + 1] || '') : '') + '\n' + (seg.stdin || '');
      if (INLINE_WRITE.test(code) && named) return true; continue;
    }
    if (/^\[(system\.)?io\.file\]::(write|append|copy|move|delete|replace)/i.test(w[0]) && named) return true;
    if (c === 'xargs') { const k = args.findIndex(a => !/^-/.test(a)); const x = k >= 0 ? args[k].toLowerCase() : ''; if (/^(rm|del|unlink|cp|mv|sed|perl|tee|remove-item|copy-item|move-item|set-content|out-file|truncate|touch)$/.test(x) && named) return true; continue; }
    if (c === 'find') { if (args.some(a => /^-(delete|exec|execdir|ok|fprint)/.test(a)) && named) return true; continue; }
    const ps = /-/.test(c) || ['sc', 'ac', 'ri', 'del', 'erase', 'rd', 'cpi', 'mi', 'copy', 'move', 'ren', 'rni'].includes(c);
    const { named: nm, pos } = splitArgs(args, ps);
    const paths = PATH_PARAM_VALS(nm);
    if (c === 'sed') { if (args.some(a => /^-[a-zA-Z]*i/.test(a) || /^--in-place/.test(a))) { if (pos.some(t => pathHits(t, base))) return true; } continue; }
    if (c === 'perl') { if (pos.some(t => pathHits(t, base))) return true; continue; } // 여기 오면 -i 있음
    if (['cp', 'mv', 'copy', 'move', 'copy-item', 'move-item', 'cpi', 'mi', 'xcopy', 'robocopy', 'install'].includes(c)) {
      const dest = listVals(nm.destination || nm.dest); const td = listVals(nm.t || nm['target-directory']);
      if (dest.length) { if (dest.some(t => pathHits(t, base) || dirHits(t, rel) && [...pos, ...paths].some(x => pathHits(x, base)))) return true; continue; }
      if (td.length) { if ([...pos, ...paths].some(t => pathHits(t, base))) return true; continue; }
      if (c === 'robocopy') { if (pos.length >= 2 && pos.slice(2).some(t => pathHits(t, base))) return true; continue; }
      const all = [...paths, ...pos]; const last = all[all.length - 1];
      if (['mv', 'move', 'move-item', 'mi'].includes(c) && all.slice(0, -1).some(x => pathHits(x, base))) return true; // 옮기면 원래 파일이 없어짐
      if (last != null && (pathHits(last, base) || (all.length > 1 && all.slice(0, -1).some(x => pathHits(x, base)) && dirHits(last, rel)))) return true;
      continue;
    }
    if (['set-content', 'add-content', 'out-file', 'sc', 'ac', 'new-item', 'ni', 'clear-content', 'clc'].includes(c)) { const t = paths.length ? paths : pos.slice(0, 1); if (t.some(x => pathHits(x, base))) return true; continue; }
    if (['tee', 'tee-object'].includes(c)) { const t = [...paths, ...pos]; if (t.some(x => pathHits(x, base))) return true; continue; }
    if (['rm', 'del', 'erase', 'unlink', 'remove-item', 'ri', 'rmdir', 'rd', 'shred', 'truncate', 'rename-item', 'ren', 'rni'].includes(c)) {
      const t = [...paths, ...(['rename-item', 'ren', 'rni'].includes(c) ? pos.slice(0, 1) : pos)]; const rec = Object.keys(nm).some(n => /^(recurse|recursive)$/.test(n) || (/^[a-z]{1,3}$/.test(n) && n.includes('r'))) || ['rmdir', 'rd'].includes(c);
      if (t.some(x => pathHits(x, base) || (rec && dirHits(x, rel)))) return true; continue;
    }
    if (c === 'git') {
      let k = 0; while (k < args.length && /^-/.test(args[k])) k += /^-(C|c)$/.test(args[k]) ? 2 : 1;
      const sub = (args[k] || '').toLowerCase(); const rest = splitArgs(args.slice(k + 1), false);
      if (sub === 'checkout' || sub === 'restore') { if (rest.pos.some(x => pathHits(x, base) || dirHits(x, rel))) return true; continue; }
      if (['apply', 'stash', 'am'].includes(sub) && named) return true;
      continue;
    }
  }
  return false;
}
function PATH_PARAM_VALS(nm) { return Object.keys(nm).filter(n => PATH_PARAM.test(n)).flatMap(n => listVals(nm[n])); }

const norm = (root, f) => { const r = path.relative(root, path.resolve(root, String(f || ''))).replace(/\\/g, '/'); return process.platform === 'win32' ? r.toLowerCase() : r; };

/** AI 실행 기록(.vibe/logs/*_claude_orch.log, stream-json)에서 편집 도구 호출과 셸 명령을 읽는다. 실패한 도구 호출(is_error)은 뺀다 */
function readOps(root, logRel) {
  const res = { ok: false, ops: [], shells: [], why: '' };
  if (!logRel) { res.why = '실행 기록 경로 없음'; return res; }
  let txt = ''; try { txt = fs.readFileSync(path.resolve(root, logRel), 'utf8'); } catch (e) { res.why = `실행 기록 읽기 실패: ${e.message}`; return res; }
  const uses = []; const failed = new Set();
  for (const ln of txt.split(/\r?\n/)) {
    if (!ln || ln[0] !== '{') continue; let j; try { j = JSON.parse(ln); } catch { continue; } if (!j || typeof j !== 'object') continue;
    const content = j.message && Array.isArray(j.message.content) ? j.message.content : [];
    if (j.type === 'assistant') { for (const c of content) if (c && c.type === 'tool_use') uses.push(c); }
    else if (j.type === 'user') { for (const c of content) if (c && c.type === 'tool_result' && c.is_error) failed.add(c.tool_use_id); }
  }
  for (const u of uses) {
    if (failed.has(u.id)) continue; const inp = u.input || {};
    if (EDIT_TOOLS.has(u.name)) {
      const file = norm(root, inp.file_path || inp.notebook_path);
      if (u.name === 'Edit') res.ops.push({ file, kind: 'edit', edits: [{ old: String(inp.old_string || ''), neu: String(inp.new_string || ''), all: inp.replace_all === true || inp.replace_all === 'true' }] });
      else if (u.name === 'MultiEdit') res.ops.push({ file, kind: 'edit', edits: (inp.edits || []).map(e => ({ old: String(e.old_string || ''), neu: String(e.new_string || ''), all: e.replace_all === true })) });
      else res.ops.push({ file, kind: 'write' });
    } else if (SHELL_TOOLS.has(u.name)) res.shells.push(String(inp.command || ''));
  }
  res.ok = true; return res;
}

/** 한 편집을 거꾸로 적용. 새 문자열이 한 곳(모두 바꾸기면 1곳 이상)에 있어야 한다. 줄 끝이 CRLF 인 파일은 CRLF 로 맞춰 한 번 더 찾는다 */
function undoOne(text, e) {
  if (!e.neu) return { ok: false, why: '새 문자열이 비어 위치를 정할 수 없음' };
  const tries = [[e.neu, e.old]]; if (text.includes('\r\n') && e.neu.includes('\n') && !e.neu.includes('\r\n')) tries.push([e.neu.replace(/\n/g, '\r\n'), e.old.replace(/\n/g, '\r\n')]);
  for (const [n, o] of tries) {
    const cnt = text.split(n).length - 1; if (!cnt) continue;
    if (e.all) return { ok: true, text: text.split(n).join(o) };
    if (cnt !== 1) return { ok: false, why: `새 문자열이 ${cnt}곳에 있어 위치를 정할 수 없음` };
    const i = text.indexOf(n); return { ok: true, text: text.slice(0, i) + o + text.slice(i + n.length) };
  }
  return { ok: false, why: '새 문자열이 지금 파일에 없음(그 뒤 다른 쪽이 같은 곳을 고침)' };
}

/** 구문 확인: .js = 함수 본문으로 컴파일만(실행 안 함) · .json = JSON.parse · 그 밖 = 확인 안 함 */
function syntaxOk(rel, text) {
  try {
    if (/\.(c|m)?js$/i.test(rel)) { new vm.Script(`(function (exports, require, module, __filename, __dirname) {${text.replace(/^#!.*/, '')}\n})`, { filename: rel }); }
    else if (/\.json$/i.test(rel)) JSON.parse(text.replace(/^﻿/, ''));
    return { ok: true };
  } catch (e) { return { ok: false, why: `구문 오류: ${String(e.message || e).slice(0, 160)}` }; }
}

/** rel 파일에서 AI 편집만 거꾸로 적용한 내용을 만든다(쓰지 않음). { ok, text, n, why } */
function planUndo(root, rel, info) {
  const key = norm(root, rel); const ops = (info.ops || []).filter(o => o.file === key);
  if (!ops.length) return { ok: false, why: 'AI 실행 기록에 이 파일 편집 없음' };
  if (ops.some(o => o.kind === 'write')) return { ok: false, why: 'AI 가 파일 전체를 씀(Write)' };
  const sh = (info.shells || []).find(c => shellWritesFile(c, rel)); // 2026-11-24 그 파일을 쓰는 조각만 쓰기로 봄(20261123215513_INC)
  if (sh) return { ok: false, why: `셸 명령으로 이 파일을 쓴 흔적: ${sh.slice(0, 120)}` };
  let text; try { text = fs.readFileSync(path.resolve(root, rel), 'utf8'); } catch (e) { return { ok: false, why: `읽기 실패: ${e.message}` }; }
  let n = 0;
  for (let i = ops.length - 1; i >= 0; i--) for (let k = ops[i].edits.length - 1; k >= 0; k--) {
    const r = undoOne(text, ops[i].edits[k]); if (!r.ok) return { ok: false, why: r.why }; text = r.text; n++;
  }
  const sx = syntaxOk(rel, text); if (!sx.ok) return { ok: false, why: sx.why };
  return { ok: true, text, n };
}

const hms = () => { const d = new Date(); const t = x => String(x).padStart(2, '0'); return `${d.getFullYear()}${t(d.getMonth() + 1)}${t(d.getDate())}_${t(d.getHours())}${t(d.getMinutes())}${t(d.getSeconds())}`; };
function writeText(f, text) { const tmp = `${f}.tmp_undo`; fs.writeFileSync(tmp, text, 'utf8'); try { fs.renameSync(tmp, f); } catch { fs.copyFileSync(tmp, f); try { fs.unlinkSync(tmp); } catch { } } }

/**
 * 파일 하나를 되돌린다.
 *   opt.root, opt.rel, opt.snapFile(반영 전 사본), opt.info(readOps 결과)
 *   opt.wholeOk(): 거꾸로 적용이 안 될 때 사본으로 덮어도 되는지(부른 쪽 정책). false 면 건너뜀
 * 반환 { rel, how: 'undo'|'whole'|'skip'|'same'|'fail', n, why, keep }
 */
function restoreFile(opt) {
  const { root, rel, snapFile } = opt; const f = path.resolve(root, rel);
  let cur = null; try { cur = fs.readFileSync(f); } catch { }
  let before = null; try { before = fs.readFileSync(snapFile); } catch { }
  if (cur && before && cur.equals(before)) return { rel, how: 'same', why: '반영 전과 같음' };
  const plan = opt.info && opt.info.ok ? planUndo(root, rel, opt.info) : { ok: false, why: (opt.info && opt.info.why) || '실행 기록 없음' };
  if (plan.ok) {
    try { writeText(f, plan.text); return { rel, how: 'undo', n: plan.n, why: `AI 편집 ${plan.n}건만 되돌림${before && Buffer.from(plan.text, 'utf8').equals(before) ? '(반영 전과 같음)' : '(다른 쪽 편집 유지)'}` }; }
    catch (e) { return { rel, how: 'fail', why: `쓰기 실패: ${e.message}` }; }
  }
  if (opt.wholeOk && !opt.wholeOk()) return { rel, how: 'skip', why: `AI 편집만 되돌리지 못함(${plan.why}). 반영 뒤 다른 쪽이 고쳐 사본으로 덮지 않음` };
  if (!before) return { rel, how: 'fail', why: `사본 없음 · ${plan.why}` };
  let keep = '';
  try { if (cur) { keep = `${rel}.bak_prerestore_${hms()}`; fs.writeFileSync(path.resolve(root, keep), cur); } }
  catch (e) { return { rel, how: 'fail', why: `덮기 전 보관 실패: ${e.message}` }; }
  try { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.copyFileSync(snapFile, f); }
  catch (e) { return { rel, how: 'fail', why: `복원 실패: ${e.message}`, keep }; }
  return { rel, how: 'whole', why: `사본으로 복원(${plan.why})${keep ? `. 덮기 전 파일 ${keep}` : ''}`, keep };
}

module.exports = { readOps, planUndo, restoreFile, undoOne, syntaxOk, SHELL_WRITE, shellWritesFile, shellSegments };
