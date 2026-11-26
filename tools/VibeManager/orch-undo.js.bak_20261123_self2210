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
  const base = path.basename(rel).toLowerCase();
  const sh = (info.shells || []).find(c => c.toLowerCase().includes(base) && SHELL_WRITE.test(c));
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

module.exports = { readOps, planUndo, restoreFile, undoOne, syntaxOk, SHELL_WRITE };
