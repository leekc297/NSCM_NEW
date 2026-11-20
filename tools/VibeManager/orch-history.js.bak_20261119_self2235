// 2026-11-19 VMO 자가진단 Q2: 작업 이력 취합 — Claude Code · Claude 로 VM 을 보완하고 작업한 기록을 원천 8종에서 모아 작업 단위 원장으로 만든다.
//   원천: H1 CHANGELOG.md 절 · H2 Claude Code 세션 기록(~/.claude/projects/<프로젝트>/*.jsonl) · H3 .vibe/history/*/*/meta.json · H4 .vibe/logs/*claude*.log 머리
//         H5 VMO 사건·개선안 · H6 백업 파일(.bak_<날짜>_<태그>) · H7 Claude 메모리 frontmatter · H8 검사기 결함 문서 · 룰 변경 이력
//   산출: .vibe/orch/history/worklog.jsonl(한 줄 1건) · stats.json(집계) · sessions.json(세션별 읽은 위치와 요약) · tools/VibeManager/WORKLOG.md(정리본)
//   세션 기록은 읽은 위치(pos)를 두고 늘어난 부분만 읽는다. 나머지 원천은 크기가 작아 매번 다시 읽는다.
//   계정 id · 토큰 · 메일 주소는 원장에 옮기지 않는다(redact). 세션의 session-owner 줄은 읽지 않는다.
//   Claude 호출은 summarize(주제별 정리)에서만 한다. 수집(collect)은 코드만 쓴다.
'use strict';
const fs = require('fs');
const path = require('path');
const os = require('os');
let errlog = { note() { return null; } }; try { errlog = require('./orch-errlog'); } catch { }
let orchEv = null; try { orchEv = require('./orch-events'); } catch { orchEv = null; }

let getPaths = null; let opts = {}; let busy = false; let prog = null;
const listeners = new Set(); // fn({type:'history', kind:'progress'|'done'|'error', ...})

const P = () => getPaths();
const histDir = () => path.join(P().vibeDir, 'orch', 'history');
const vmDir = () => path.join(P().root, 'tools', 'VibeManager');
const two = n => String(n).padStart(2, '0');
const nowLocal = ms => (orchEv ? orchEv.nowLocal(ms) : new Date(ms || Date.now()).toISOString());
const readJson = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^\uFEFF/, '')); } catch { return d; } };
function replaceFile(tmp, f) { for (let i = 0; i < 3; i++) { try { fs.renameSync(tmp, f); return; } catch (e) { if (i === 2 || !/EPERM|EBUSY|EACCES/.test(e.code || '')) { fs.copyFileSync(tmp, f); try { fs.unlinkSync(tmp); } catch { } return; } const t = Date.now() + 40 * (i + 1); while (Date.now() < t) { /* 짧게 기다림 */ } } } } // Windows 에서 다른 프로세스가 대상 파일을 잠깐 쥐면 rename 이 EPERM(2026-11-19 21:27 실측) → 재시도 뒤 복사
const writeJson = (f, v) => { try { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f + '.t', JSON.stringify(v), 'utf8'); replaceFile(f + '.t', f); return true; } catch (e) { errlog.note('orch-history', 'writeJson', e); return false; } };
const readText = f => { try { return fs.readFileSync(f, 'utf8').replace(/^\uFEFF/, ''); } catch { return ''; } };
const lsDir = d => { try { return fs.readdirSync(d, { withFileTypes: true }); } catch { return []; } };
const localDT = ms => { const d = new Date(ms); return { date: `${d.getFullYear()}-${two(d.getMonth() + 1)}-${two(d.getDate())}`, time: `${two(d.getHours())}:${two(d.getMinutes())}` }; };
const say = (kind, o) => { const m = Object.assign({ type: 'history', kind }, o || {}); for (const fn of listeners) { try { fn(m); } catch (e) { errlog.note('orch-history', 'listener', e); } } };
const hash = s => { let h = 5381; for (let i = 0; i < s.length; i++) h = ((h << 5) + h + s.charCodeAt(i)) >>> 0; return h.toString(36); };

/** 원장에 옮기기 전 비밀값 가리기: 메일 주소 · 토큰 형태 · 비밀번호 대입 */
let acctRe = null; let acctAt = 0;
function accountRe() { // 시험 계정 명부(tools/E2E/users.json)의 계정 id 를 찾는 정규식. 10분마다 다시 읽는다
  if (acctRe !== null && Date.now() - acctAt < 600000) return acctRe;
  acctAt = Date.now(); acctRe = false;
  try {
    const ids = new Set(); const walk = v => { if (typeof v === 'string') { if (/^[a-z][a-z0-9_.]{3,24}$/.test(v) && !/^(?:default|none|true|false|single|admin|planner)$/.test(v)) ids.add(v); } else if (Array.isArray(v)) v.forEach(walk); else if (v && typeof v === 'object') for (const k of Object.keys(v)) { if (k[0] !== '_' && !/note|doc|extracted|updated|appliesTo/i.test(k)) walk(v[k]); } };
    walk(readJson(path.join(P().root, 'tools', 'E2E', 'users.json'), {}));
    if (ids.size) acctRe = new RegExp(`\\b(?:${[...ids].map(x => x.replace(/[.]/g, '\\.')).join('|')})\\b`, 'g');
  } catch { }
  return acctRe;
}
function redact(s) {
  const re = getPaths ? accountRe() : null;
  return (re ? String(s || '').replace(re, '<계정>') : String(s || ''))
    .replace(/[\w.+-]+@[\w-]+\.[\w.-]+/g, '<메일>')
    .replace(/\b(?:sk|pk|ghp|gho|xox[abp])[-_][A-Za-z0-9_-]{16,}\b/g, '<토큰>')
    .replace(/\b[A-Za-z0-9+/_-]{48,}={0,2}/g, '<긴 문자열>')
    .replace(/((?:password|passwd|pwd|비밀번호|token|secret|api[_-]?key)\s*[:=]\s*)\S+/gi, '$1<가림>');
}

// ── 영역 분류(코드 · 파일명과 키워드) ──
const AREAS = [
  ['VMO', /orch-|orchestra|VMO|오케스트라|자가진단|개선안|사건 탭/i],
  ['업무 작업창', /jobs\.js|job-runner|업무 작업/],
  ['서버', /server-service|server_guard|BE ?Log|FE ?Log|서버 기동|재기동|bootRun|vite/i],
  ['Git', /Source (?:Backup|Download|Upload|Update)|git[-_ ]|공통소스|CommonSync/i],
  ['CheckList 엔진', /CheckList|run_verify|미검증|검사기|판정|unverified|llm_/i],
  ['문서 생성', /설계서|분석서|TestResultList|문서 생성|xlsx/i],
  ['룰·hook', /hook|룰셋|rules[\\/]|CLAUDE\.md|문장 규칙/i],
  ['체인·메뉴', /quick\.json|steps\.json|체인|메뉴|사이드바|menu-view/i],
  ['Workbench', /workbench|Console|Task Log|탭|프롬프트|History|FLOW|flow-panel/i],
];
function areaOf(title, body) {
  for (const src of [title, body]) { if (!src) continue; for (const [name, re] of AREAS) if (re.test(src)) return name; }
  return 'VM 기타';
}
const SCREEN_RE = /\b(?:DMF|SCP|SSP|SCM|FP|COM)\d{4,5}[A-Z]?\b/g;
const screensOf = s => [...new Set(String(s || '').match(SCREEN_RE) || [])].slice(0, 20);

// ── H1: CHANGELOG.md ──
function parseChangelog(text) {
  const out = []; const lines = String(text || '').split(/\r?\n/); let cur = null;
  const flush = () => { if (cur) out.push(finishSection(cur)); cur = null; };
  lines.forEach((ln, i) => { if (/^## /.test(ln)) { flush(); cur = { head: ln.slice(3).trim(), line: i + 1, body: [] }; } else if (cur) cur.body.push(ln); });
  flush(); return out;
}
function finishSection(c) {
  const head = c.head; const body = c.body.join('\n');
  const dm = /(\d{4}-\d{2}-\d{2})(?:[ T](\d{1,2}:[\dx]{2}))?/.exec(head) || /(\d{4}-\d{2}-\d{2})(?:[ T](\d{1,2}:[\dx]{2}))?/.exec(body) || [];
  const ver = (/^(\d+\.\d+\.\d+)/.exec(head) || [])[1] || '';
  let scope = ''; let title = head;
  const pm = /^\(판 번호 없음\s*[,·]?\s*([^)]*)\)\s*/.exec(head); if (pm) { scope = pm[1].trim(); title = head.slice(pm[0].length); }
  title = title.replace(/\s*\((?:\d{4}-\d{2}-\d{2})[^)]*\)\s*$/, '').replace(/^\d+\.\d+\.\d+\s*(?:—|-)?\s*/, '').replace(/^\(\d{4}-\d{2}-\d{2}\)\s*/, '').trim() || (ver ? `판 ${ver}` : head);
  const bullets = c.body.filter(l => /^\s*- /.test(l)).map(l => l.replace(/^\s*- /, ''));
  if (/^판 \d/.test(title) && bullets.length) title = bullets[0].replace(/\s+/g, ' ').slice(0, 90); // 판 번호만 있는 절 = 첫 항목을 제목으로
  const asks = []; for (const b of bullets) if (/^사용자/.test(b)) { const q = b.match(/"([^"]{2,})"/g) || b.match(/“([^”]{2,})”/g); if (q) for (const x of q) asks.push(x.slice(1, -1)); else asks.push(b.replace(/^사용자[^:]*:\s*/, '').slice(0, 300)); }
  const confirmed = bullets.filter(b => /^확인/.test(b)).map(b => b.slice(0, 400));
  const unverified = [];
  for (const b of bullets) {
    if (!/미확인|미실행|미측정/.test(b)) continue;
    if (/^미확인\s*:/.test(b)) { for (const seg of b.replace(/^미확인\s*:\s*/, '').split(/\s+·\s+/)) if (seg.trim()) unverified.push(seg.trim().slice(0, 240)); continue; }
    for (const seg of b.split(/(?<=[.。])\s+|\s+·\s+/)) if (/미확인|미실행|미측정/.test(seg)) unverified.push(seg.trim().slice(0, 240));
  }
  const baks = [...new Set((body.match(/\.bak_\d{8}(?:_[A-Za-z0-9]+)?/g) || []).map(x => x.slice(5)))];
  const files = [...new Set((body.replace(/\S*\.bak_\S*/g, ' ').match(/[A-Za-z0-9_./\\-]+\.(?:js|json|py|ps1|md|svg|cmd|ts|tsx|csv|sql)\b/g) || []).map(x => x.replace(/\\/g, '/').replace(/^\.\//, '')))].slice(0, 40);
  const proposal = (/(\d{14}_(?:REVIEW|INC|SELF)(?:_\d+)?)/.exec(body) || [])[1] || '';
  const needsReload = /창 다시 로드|재시작 필요|Reload/i.test(head + body);
  return { id: `CL:${dm[1] || 'nodate'}:${hash(head)}`, kind: 'change', date: dm[1] || '', time: (dm[2] || '').replace(/x/g, '0'), timeRaw: dm[2] || '', area: areaOf(title, scope + ' ' + body.slice(0, 1500)), title, ver, scope, ask: asks.map(redact), files, screens: screensOf(head + ' ' + body), confirmed, unverified, baks, proposal, needsReload, sources: [{ src: 'CHANGELOG.md', line: c.line }] };
}

// ── H2: Claude Code 세션 기록(늘어난 부분만) ──
function encodeProject(root) { return String(root).replace(/[^A-Za-z0-9]/g, '-'); }
function sessionDirs() {
  if (opts.sessionDirs) return opts.sessionDirs;
  const base = path.join(os.homedir(), '.claude', 'projects'); const enc = encodeProject(P().root).toLowerCase();
  return lsDir(base).filter(e => e.isDirectory() && e.name.toLowerCase().startsWith(enc)).map(e => path.join(base, e.name));
}
const SKIP_USER = /^(?:This session is being continued|\[Request interrupted|Caveat:|\[SYSTEM NOTIFICATION|Base directory for this skill)/;
const VM_PATH = /vibe-?manager/i;
function userText(content) {
  let t = ''; if (typeof content === 'string') t = content; else if (Array.isArray(content)) t = content.filter(b => b && b.type === 'text').map(b => b.text || '').join('\n');
  t = t.replace(/<system-reminder>[\s\S]*?<\/system-reminder>/g, '').replace(/<pasted_content[\s\S]*?<\/pasted_content[^>]*>/g, '<붙여넣은 내용>').trim();
  if (!t || t[0] === '<' || SKIP_USER.test(t)) return '';
  return t;
}
function newSessionRec(file) { return { id: path.basename(file, '.jsonl'), custom: '', ai: '', start: '', end: '', askCount: 0, asks: [], vmEdits: {}, vmEditCount: 0, vmCmds: 0, screens: {} }; }
function sessionLine(rec, s) {
  const ti = s.lastIndexOf('"timestamp":"'); if (ti >= 0) { const ts = s.substr(ti + 13, 24); if (/^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d/.test(ts)) { if (!rec.start || ts < rec.start) rec.start = ts; if (ts > rec.end) rec.end = ts; } }
  if (s.includes('"type":"session-owner"')) return;
  if (s.includes('"type":"custom-title"') || s.includes('"type":"ai-title"')) { try { const j = JSON.parse(s); if (j.customTitle) rec.custom = String(j.customTitle).slice(0, 120); if (j.aiTitle) rec.ai = String(j.aiTitle).slice(0, 120); } catch { } return; }
  if (s.includes('"type":"user"')) {
    if (s.includes('"isSidechain":true')) return;
    let j; try { j = JSON.parse(s); } catch { return; }
    if (j.type !== 'user' || j.isMeta || !j.message) return;
    const t = userText(j.message.content); if (!t) return;
    rec.askCount++; const at = j.timestamp || '';
    for (const id of screensOf(t)) rec.screens[id] = (rec.screens[id] || 0) + 1;
    if (rec.asks.length < 120) rec.asks.push({ at, text: redact(t.replace(/\s+/g, ' ').slice(0, 400)) });
    return;
  }
  if (s.includes('"type":"assistant"') && s.includes('"tool_use"') && VM_PATH.test(s)) {
    if (s.includes('"isSidechain":true')) return;
    let j; try { j = JSON.parse(s); } catch { return; }
    const blocks = (j.message && Array.isArray(j.message.content)) ? j.message.content : []; const day = j.timestamp ? localDT(Date.parse(j.timestamp)).date : '';
    for (const b of blocks) {
      if (!b || b.type !== 'tool_use' || !b.input) continue;
      const fp = b.input.file_path || b.input.notebook_path || '';
      if (/^(?:Edit|Write|MultiEdit|NotebookEdit)$/.test(b.name) && VM_PATH.test(fp) && !/\.bak_/.test(fp)) { const k = `${day}|${path.basename(String(fp).replace(/\\/g, '/'))}`; rec.vmEdits[k] = (rec.vmEdits[k] || 0) + 1; rec.vmEditCount++; }
      else if (/^(?:Bash|PowerShell)$/.test(b.name) && VM_PATH.test(String(b.input.command || ''))) rec.vmCmds++;
    }
  }
}
function readGrowth(file, from, onLine) { // from 바이트부터 끝까지 읽어 줄마다 onLine. 반환 = 온전한 줄까지 읽은 위치
  return new Promise(resolve => {
    let pos = from; let rest = null;
    const rs = fs.createReadStream(file, { start: from, highWaterMark: 1 << 20 });
    rs.on('data', chunk => {
      let buf = rest ? Buffer.concat([rest, chunk]) : chunk; let i;
      while ((i = buf.indexOf(10)) >= 0) { const line = buf.slice(0, i); pos += i + 1; buf = buf.slice(i + 1); if (line.length > 2) { try { onLine(line.toString('utf8')); } catch (e) { errlog.note('orch-history', 'sessionLine', e); } } }
      rest = buf.length ? buf : null;
    });
    rs.on('error', e => { errlog.note('orch-history', 'readGrowth', e); resolve(pos); });
    rs.on('end', () => resolve(pos));
  });
}
async function collectSessions(st) {
  const cacheF = path.join(histDir(), 'sessions.json'); const cache = readJson(cacheF, {}); const files = [];
  for (const d of sessionDirs()) for (const e of lsDir(d)) if (e.isFile() && e.name.endsWith('.jsonl')) files.push(path.join(d, e.name));
  let n = 0; st.sessionFiles = files.length; st.sessionBytesRead = 0; st.sessionBytesTotal = 0;
  const seen = new Set();
  for (const f of files) {
    n++; seen.add(f); let s; try { s = fs.statSync(f); } catch { continue; }
    st.sessionBytesTotal += s.size;
    let c = cache[f]; if (!c || c.pos > s.size) c = cache[f] = { pos: 0, rec: newSessionRec(f) };
    if (c.pos < s.size) {
      prog = { step: '세션 기록', n, total: files.length, file: path.basename(f) }; say('progress', prog);
      const before = c.pos; c.pos = await readGrowth(f, c.pos, line => sessionLine(c.rec, line)); st.sessionBytesRead += c.pos - before;
      c.size = s.size; c.mtimeMs = s.mtimeMs;
      if (n % 5 === 0) writeJson(cacheF, cache);
    }
  }
  for (const k of Object.keys(cache)) if (!seen.has(k)) delete cache[k];
  writeJson(cacheF, cache);
  return Object.values(cache).map(c => c.rec);
}
function sessionEntry(rec, memBySession) {
  if (!rec.start) return null;
  const a = localDT(Date.parse(rec.start)); const b = localDT(Date.parse(rec.end || rec.start)); const title = rec.custom || rec.ai || (rec.asks[0] ? rec.asks[0].text.slice(0, 60) : '(제목 없음)');
  const files = {}; const pairs = [];
  for (const [k, v] of Object.entries(rec.vmEdits)) { const [day, name] = k.split('|'); files[name] = (files[name] || 0) + v; pairs.push({ d: day, f: name, n: v }); }
  const vm = rec.vmEditCount > 0 || rec.vmCmds > 0 || /\bVM\b|Vibe|VMO|오케스트라/i.test(title);
  const screens = Object.entries(rec.screens).sort((x, y) => y[1] - x[1]).slice(0, 12).map(x => x[0]);
  return { id: `S:${rec.id}`, kind: 'session', date: a.date, time: a.time, endDate: b.date, endTime: b.time, area: vm ? areaOf(title, Object.keys(files).join(' ')) : '화면 작업', vm, title, session: rec.id,
    askCount: rec.askCount, ask: vm ? rec.asks.map(x => x.text).slice(0, 60) : rec.asks.slice(0, 3).map(x => x.text.slice(0, 160)), files: Object.keys(files), fileEdits: files, editPairs: pairs, vmEditCount: rec.vmEditCount, vmCmds: rec.vmCmds, screens,
    memories: (memBySession[rec.id] || []).slice(0, 30), sources: [{ src: 'session', id: rec.id }] };
}

// ── H3: VM 실행 이력 ──
function collectRuns() {
  const out = []; const base = path.join(P().vibeDir, 'history');
  for (const s of lsDir(base)) { if (!s.isDirectory()) continue;
    for (const r of lsDir(path.join(base, s.name))) { if (!r.isDirectory()) continue;
      const m = readJson(path.join(base, s.name, r.name, 'meta.json'), null); if (!m) continue;
      const t = Date.parse(m.start || ''); const dt = Number.isFinite(t) ? localDT(t) : { date: (/^(\d{4})(\d\d)(\d\d)/.exec(r.name) || []).slice(1, 4).join('-'), time: '' };
      const label = String(m.label || m.note || m.task || '').slice(0, 120);
      out.push({ id: `RUN:${s.name}/${r.name}`, kind: 'run', date: dt.date, time: dt.time, area: /^_|공통/.test(s.name) ? areaOf(label, m.task || '') : '화면 작업', title: label, task: m.task || '', source: m.source || '', screens: /^_/.test(s.name) ? [] : [s.name], ask: m.text ? [redact(String(m.text).replace(/\s+/g, ' ').slice(0, 400))] : [], exit: m.exit, files: (m.changed || []).slice(0, 30).map(x => (typeof x === 'string' ? x : (x && (x.rel || x.file || x.path)) || '')).filter(Boolean), sources: [{ src: '.vibe/history', id: `${s.name}/${r.name}` }] });
    } }
  return out;
}
// ── H4: Claude 호출 로그 머리 ──
function collectClaudeLogs() {
  const out = []; const d = path.join(P().vibeDir, 'logs');
  for (const e of lsDir(d)) {
    if (!e.isFile() || !/claude.*\.log$/i.test(e.name)) continue; const f = path.join(d, e.name);
    try {
      const st = fs.statSync(f); const fd = fs.openSync(f, 'r'); const n = Math.min(st.size, 8192); const hb = Buffer.alloc(n); const tn = Math.min(st.size, 400); const tb = Buffer.alloc(tn);
      try { fs.readSync(fd, hb, 0, n, 0); fs.readSync(fd, tb, 0, tn, st.size - tn); } finally { fs.closeSync(fd); }
      const head = hb.toString('utf8'); const pi = head.indexOf('--- prompt ---'); const oi = head.indexOf('--- output ---');
      const prompt = pi >= 0 ? head.slice(pi + 14, oi > pi ? oi : undefined).trim() : ''; const exit = (/--- exit (-?\d+) ---/.exec(tb.toString('utf8')) || [])[1];
      const m = /^(\d{4}-\d\d-\d\d)T(\d\d)-(\d\d)-(\d\d)_claude_(\w+)\.log$/.exec(e.name) || []; const who = m[5] || '';
      out.push({ id: `CLG:${e.name}`, kind: 'claude', date: m[1] || localDT(st.mtimeMs).date, time: m[2] ? `${m[2]}:${m[3]}` : localDT(st.mtimeMs).time, area: who === 'orch' ? 'VMO' : areaOf(prompt.slice(0, 300), ''), title: (who === 'orch' ? 'VMO 에이전트 호출' : `Workbench Claude 호출(${who})`), who, ask: prompt ? [redact(prompt.replace(/\s+/g, ' ').slice(0, 500))] : [], screens: screensOf(prompt.slice(0, 2000)), exit: exit == null ? null : Number(exit), bytes: st.size, files: [], sources: [{ src: '.vibe/logs', id: e.name }] });
    } catch (ex) { errlog.note('orch-history', 'claudeLog', ex); }
  }
  return out;
}
// ── H5: VMO 사건 · 개선안 ──
function collectVmo() {
  const out = []; const od = path.join(P().vibeDir, 'orch');
  for (const e of lsDir(path.join(od, 'incidents'))) { if (!e.name.endsWith('.json')) continue; const j = readJson(path.join(od, 'incidents', e.name), null); if (!j) continue;
    const dt = localDT(j.ms || Date.parse(j.at) || 0);
    out.push({ id: `INC:${j.id}`, kind: 'incident', date: dt.date, time: dt.time, area: 'VMO', title: `사건 ${j.rule} ${j.title || ''}`.slice(0, 200), rule: j.rule, status: j.status, count: j.count || 1, screens: j.screen ? [j.screen] : [], actions: (j.actions || []).map(a => String(a.what || '').slice(0, 200)).slice(0, 10), proposal: j.proposal || '', files: [], ask: [], sources: [{ src: '.vibe/orch/incidents', id: e.name }] }); }
  for (const e of lsDir(path.join(od, 'proposals'))) { if (!e.name.endsWith('.json')) continue; const j = readJson(path.join(od, 'proposals', e.name), null); if (!j) continue;
    const t = Date.parse(j.at); const dt = Number.isFinite(t) ? localDT(t) : { date: '', time: '' };
    out.push({ id: `PROP:${j.id}`, kind: 'proposal', date: dt.date, time: dt.time, area: 'VMO', title: `개선안 ${j.title || ''}`.slice(0, 200), status: j.status, source: j.source, files: (j.targets || []).slice(0, 20), screens: j.screen ? [j.screen] : [], ask: [], history: (j.history || []).map(h => `${h.at || ''} ${h.what || h.status || ''}`.trim().slice(0, 160)).slice(0, 12), sources: [{ src: '.vibe/orch/proposals', id: e.name }] }); }
  return out;
}
// ── H6: 백업 파일 ──
function collectBaks() {
  const out = []; const dirs = [[vmDir(), 'repo']]; const p = P(); if (p.extDir && path.resolve(p.extDir) !== path.resolve(vmDir())) dirs.push([p.extDir, 'installed']);
  const walk = (d, where, rel, depth) => { for (const e of lsDir(d)) { if (e.isDirectory()) { if (depth < 2 && e.name !== 'node_modules' && e.name[0] !== '.') walk(path.join(d, e.name), where, rel ? `${rel}/${e.name}` : e.name, depth + 1); continue; }
    const m = /^(.+)\.bak_(\d{8})(?:_([A-Za-z0-9]+))?$/.exec(e.name); if (m) out.push({ where, file: rel ? `${rel}/${m[1]}` : m[1], day: m[2], tag: m[3] ? `${m[2]}_${m[3]}` : m[2] }); } };
  for (const [d, where] of dirs) walk(d, where, '', 0);
  return out;
}
// ── H7: Claude 메모리 frontmatter ──
function collectMemories() {
  const out = [];
  for (const d of sessionDirs()) { const md = path.join(d, 'memory');
    for (const e of lsDir(md)) { if (!e.isFile() || !e.name.endsWith('.md') || /^MEMORY\.md$|^_index/.test(e.name)) continue;
      let head = ''; try { const fd = fs.openSync(path.join(md, e.name), 'r'); const b = Buffer.alloc(1500); try { const n = fs.readSync(fd, b, 0, 1500, 0); head = b.slice(0, n).toString('utf8'); } finally { fs.closeSync(fd); } } catch { continue; }
      const fm = (/^---\r?\n([\s\S]*?)\r?\n---/.exec(head) || [])[1] || ''; const g = k => ((new RegExp(`^\\s*${k}:\\s*(.+)$`, 'm').exec(fm) || [])[1] || '').trim();
      out.push({ file: e.name, name: g('name'), type: g('type'), description: redact(g('description')).slice(0, 240), session: g('originSessionId'), day: (/(\d{4})(\d{2})(\d{2})/.exec(e.name) || []).slice(1, 4).join('-') }); } }
  return out;
}
// ── H8: 검사기 결함 문서 · 룰 변경 이력 ──
function collectDocs() {
  const out = []; const root = P().root;
  const f1 = path.join(root, 'Doc', 'verify', '_checker_defects.md'); const t1 = readText(f1);
  if (t1) { let yr = '2026'; try { yr = String(new Date(fs.statSync(f1).mtimeMs).getFullYear()); } catch { }
    t1.split(/\r?\n/).forEach((ln, i) => { const m = /^## (T\d+(?:~T\d+)?)\s*\(([^)]*)\)\s*(.*)$/.exec(ln); if (!m) return; const d = /(?:(\d{4})-)?(\d{2})-(\d{2})(?:\s+(\d{1,2}:[\dx]{2}))?/.exec(m[2]) || [];
      out.push({ id: `DEF:${m[1]}`, kind: 'defect', date: d[2] ? `${d[1] || yr}-${d[2]}-${d[3]}` : '', time: (d[4] || '').replace(/x/g, '0'), area: 'CheckList 엔진', title: `검사기 결함 ${m[1]} ${m[3] || m[2]}`.slice(0, 200), screens: screensOf(ln), files: [], ask: [], sources: [{ src: 'Doc/verify/_checker_defects.md', line: i + 1 }] }); }); }
  for (const e of lsDir(path.join(root, 'Doc', '_archive'))) { if (!/^CLAUDE_changelog_.*\.md$/.test(e.name)) continue;
    readText(path.join(root, 'Doc', '_archive', e.name)).split(/\r?\n/).forEach((ln, i) => { const m = /^(?:- |### )(\d{4}-\d{2}-\d{2})\s*(.*)$/.exec(ln); if (!m || !m[2]) return;
      out.push({ id: `RULE:${e.name}:${i + 1}`, kind: 'rule', date: m[1], time: '', area: '룰·hook', title: redact(m[2]).slice(0, 200), screens: [], files: [], ask: [], sources: [{ src: `Doc/_archive/${e.name}`, line: i + 1 }] }); }); }
  return out;
}
function runsLogByDay() { const by = {}; for (const ln of readText(path.join(P().vibeDir, 'runs.log')).split(/\r?\n/)) { const c = ln.split('\t'); if (c.length < 3 || !/^\d{4}-\d\d-\d\d/.test(c[0]) || c[2] !== 'start') continue; const d = c[0].slice(0, 10); by[d] = (by[d] || 0) + 1; } return by; }

// ── 묶기 · 집계 ──
function link(entries, baks) {
  const sessions = entries.filter(e => e.kind === 'session'); const bakByTag = {}; for (const b of baks) (bakByTag[b.tag] = bakByTag[b.tag] || []).push(b);
  for (const e of entries) {
    if (e.kind !== 'change') continue;
    const names = new Set(e.files.map(f => path.basename(f)));
    e.sessions = sessions.filter(s => (s.editPairs || []).some(p => p.d === e.date && names.has(p.f))).map(s => s.session);
    e.bakFiles = e.baks.reduce((n, t) => n + ((bakByTag[t] || []).length), 0);
    if (!e.sessions.length) e.sessionNote = e.date && e.date < (sessions.reduce((m, s) => (s.date < m ? s.date : m), '9999')) ? '세션 기록 없음(보관 기간 이전)' : '';
  }
}
function buildStats(entries, baks, mems, st) {
  const cnt = (arr, key) => { const o = {}; for (const e of arr) { const k = typeof key === 'function' ? key(e) : e[key]; if (k) o[k] = (o[k] || 0) + 1; } return o; };
  const changes = entries.filter(e => e.kind === 'change'); const sessions = entries.filter(e => e.kind === 'session');
  const byDate = {}; for (const e of entries) { if (!e.date) continue; const d = byDate[e.date] = byDate[e.date] || {}; d[e.kind] = (d[e.kind] || 0) + 1; }
  const byFile = {}; for (const c of changes) for (const f of c.files) { const n = path.basename(f); (byFile[n] = byFile[n] || { changes: 0, edits: 0, days: {} }); byFile[n].changes++; byFile[n].days[c.date] = (byFile[n].days[c.date] || 0) + 1; }
  for (const s of sessions) for (const [f, n] of Object.entries(s.fileEdits || {})) { (byFile[f] = byFile[f] || { changes: 0, edits: 0, days: {} }); byFile[f].edits += n; }
  // S9 재료: 같은 파일이 7일 안 5회 이상 변경 절에 나온 지점 · 같은 지시가 2회 이상 나온 지점
  const repeatFiles = [];
  for (const [f, v] of Object.entries(byFile)) { const days = Object.keys(v.days).sort(); let best = 0, from = '';
    for (const d0 of days) { const t0 = Date.parse(d0); let n = 0; for (const d1 of days) { const t1 = Date.parse(d1); if (t1 >= t0 && t1 - t0 < 7 * 86400000) n += v.days[d1]; } if (n > best) { best = n; from = d0; } }
    if (best >= 5) repeatFiles.push({ file: f, count: best, from, total: v.changes, edits: v.edits }); }
  repeatFiles.sort((a, b) => b.count - a.count);
  const askMap = {}; for (const c of changes) for (const a of c.ask) { const k = a.replace(/[\s.,·…"'~!?]/g, '').slice(0, 40); if (k.length < 8) continue; (askMap[k] = askMap[k] || { text: a.slice(0, 160), ids: [] }).ids.push(c.id); }
  const repeatAsks = Object.values(askMap).filter(x => new Set(x.ids).size >= 2).map(x => ({ text: x.text, count: new Set(x.ids).size, ids: [...new Set(x.ids)].slice(0, 10) })).sort((a, b) => b.count - a.count);
  const unverified = changes.reduce((n, c) => n + c.unverified.length, 0);
  return Object.assign(st, { at: nowLocal(), ms: Date.now(), total: entries.length, byKind: cnt(entries, 'kind'), byArea: cnt(entries.filter(e => e.kind === 'change' || (e.kind === 'session' && e.vm)), 'area'), byDate, byFile, repeatFiles: repeatFiles.slice(0, 40), repeatAsks: repeatAsks.slice(0, 40),
    changes: changes.length, sessions: sessions.length, vmSessions: sessions.filter(s => s.vm).length, vmEdits: sessions.reduce((n, s) => n + (s.vmEditCount || 0), 0), unverified, baks: baks.length, bakRepo: baks.filter(b => b.where === 'repo').length, bakInstalled: baks.filter(b => b.where === 'installed').length,
    memories: mems.length, vmMemories: mems.filter(m => /VM|Vibe|VMO|vibe|오케스트라|Workbench/i.test(`${m.name} ${m.description}`)).length, runsLog: runsLogByDay(),
    firstDate: entries.reduce((m, e) => (e.date && e.date < m ? e.date : m), '9999-99-99'), lastDate: entries.reduce((m, e) => (e.date > m ? e.date : m), '') });
}

// ── 정리본(WORKLOG.md) ──
const KIND_KO = { change: '변경', session: '세션', run: 'VM 실행', claude: 'Claude 호출', incident: '사건', proposal: '개선안', defect: '검사기 결함', rule: '룰 변경' };
function renderMd(entries, st) {
  const L = []; const q = s => String(s || '').replace(/\s+/g, ' ').replace(/\|/g, '/');
  L.push('# Vibe_Manager 작업 이력', '', `생성 ${st.at} (orch-history.js 가 만든 파일. 직접 고치지 않음)`, '');
  L.push('## 건수', '', '| 구분 | 건수 |', '|---|---|');
  for (const k of Object.keys(KIND_KO)) L.push(`| ${KIND_KO[k]} | ${st.byKind[k] || 0} |`);
  L.push(`| 세션 중 VM 관련 | ${st.vmSessions} |`, `| 세션의 VM 파일 수정(Edit, Write) | ${st.vmEdits} |`, `| 변경 기록의 미확인 항목 | ${st.unverified} |`, `| 백업 파일(저장소 / 설치 폴더) | ${st.bakRepo} / ${st.bakInstalled} |`, `| 기간 | ${st.firstDate} ~ ${st.lastDate} |`, '');
  L.push('## 영역별(변경, VM 세션)', '', '| 영역 | 건수 |', '|---|---|'); for (const [a, n] of Object.entries(st.byArea).sort((x, y) => y[1] - x[1])) L.push(`| ${a} | ${n} |`); L.push('');
  if (st.repeatFiles.length) { L.push('## 7일 안 5회 이상 변경 기록에 나온 파일', '', '| 파일 | 7일 안 횟수 | 시작일 | 전체 횟수 | 세션 수정 수 |', '|---|---|---|---|---|'); for (const r of st.repeatFiles.slice(0, 20)) L.push(`| ${r.file} | ${r.count} | ${r.from} | ${r.total} | ${r.edits} |`); L.push(''); }
  if (st.repeatAsks.length) { L.push('## 변경 기록 2건 이상에 나온 같은 지시', '', '| 지시 | 건수 |', '|---|---|'); for (const r of st.repeatAsks.slice(0, 20)) L.push(`| "${q(r.text)}" | ${r.count} |`); L.push(''); }
  const days = [...new Set(entries.map(e => e.date).filter(Boolean))].sort().reverse();
  for (const d of days) {
    const es = entries.filter(e => e.date === d); const by = k => es.filter(e => e.kind === k);
    L.push(`## ${d}`, '', Object.keys(KIND_KO).filter(k => by(k).length).map(k => `${KIND_KO[k]} ${by(k).length}`).join(', '), '');
    for (const c of by('change').sort((a, b) => (b.time || '').localeCompare(a.time || ''))) {
      L.push(`- ${c.timeRaw || '시각 없음'} [${c.area}] ${q(c.title)}${c.ver ? ` (판 ${c.ver})` : ''}`);
      if (c.ask.length) L.push(`  - 지시: ${c.ask.slice(0, 3).map(a => `"${q(a).slice(0, 200)}"`).join(' / ')}`);
      if (c.files.length) L.push(`  - 파일 ${c.files.length}개: ${c.files.slice(0, 8).join(', ')}${c.files.length > 8 ? ' 외' : ''}`);
      if (c.unverified.length) L.push(`  - 미확인 ${c.unverified.length}건: ${c.unverified.slice(0, 3).map(q).join(' / ')}`);
      if (c.baks.length) L.push(`  - 되돌리기 태그: ${c.baks.join(', ')}`);
      if (c.sessions && c.sessions.length) L.push(`  - 세션: ${c.sessions.map(s => s.slice(0, 8)).join(', ')}`);
    }
    for (const s of by('session').sort((a, b) => a.time.localeCompare(b.time))) L.push(`- 세션 ${s.session.slice(0, 8)} "${q(s.title)}" ${s.time}~${s.endDate !== s.date ? `${s.endDate} ` : ''}${s.endTime}, 지시 ${s.askCount}건${s.vmEditCount ? `, VM 파일 수정 ${s.vmEditCount}건(${Object.entries(s.fileEdits).sort((x, y) => y[1] - x[1]).slice(0, 5).map(x => `${x[0]} ${x[1]}`).join(', ')})` : ''}${s.screens.length ? `, 화면 ${s.screens.slice(0, 6).join(', ')}` : ''}`);
    const runs = by('run'); if (runs.length) { const t = {}; for (const r of runs) { const k = `${r.screens[0] || '공통'} ${r.task}`; t[k] = (t[k] || 0) + 1; } L.push(`- VM 실행 ${runs.length}건: ${Object.entries(t).sort((x, y) => y[1] - x[1]).slice(0, 10).map(x => `${x[0]} ${x[1]}`).join(', ')}`); }
    for (const k of ['incident', 'proposal', 'defect', 'rule']) for (const e of by(k)) L.push(`- ${KIND_KO[k]}: ${q(e.title)}${e.status ? ` (${e.status})` : ''}`);
    L.push('');
  }
  return L.join('\n');
}

// ── 수집 실행 ──
async function collect() {
  if (busy) return { busy: true };
  busy = true; const t0 = Date.now(); const st = { sources: {} };
  try {
    fs.mkdirSync(histDir(), { recursive: true });
    say('progress', prog = { step: '변경 기록', n: 0, total: 0 });
    const cl = parseChangelog(readText(path.join(vmDir(), 'CHANGELOG.md')));
    const mems = collectMemories(); const memBySession = {}; for (const m of mems) if (m.session) (memBySession[m.session] = memBySession[m.session] || []).push(m.name || m.file);
    const sessions = (await collectSessions(st)).map(r => sessionEntry(r, memBySession)).filter(Boolean);
    say('progress', prog = { step: 'VM 실행 이력', n: 0, total: 0 });
    const runs = collectRuns(); const clogs = collectClaudeLogs(); const vmo = collectVmo(); const baks = collectBaks(); const docs = collectDocs();
    const entries = [...cl, ...sessions, ...runs, ...clogs, ...vmo, ...docs];
    link(entries, baks);
    entries.sort((a, b) => `${b.date} ${b.time || ''}`.localeCompare(`${a.date} ${a.time || ''}`));
    st.sources = { changelog: cl.length, sessions: sessions.length, runs: runs.length, claudeLogs: clogs.length, vmo: vmo.length, baks: baks.length, memories: mems.length, docs: docs.length };
    buildStats(entries, baks, mems, st); st.sec = Math.round((Date.now() - t0) / 100) / 10;
    const f = path.join(histDir(), 'worklog.jsonl'); fs.writeFileSync(f + '.t', entries.map(e => JSON.stringify(e)).join('\n') + '\n', 'utf8'); replaceFile(f + '.t', f);
    writeJson(path.join(histDir(), 'stats.json'), st);
    if (opts.writeMd !== false && fs.existsSync(vmDir())) { try { fs.writeFileSync(path.join(vmDir(), 'WORKLOG.md'), renderMd(entries, st), 'utf8'); st.md = 'tools/VibeManager/WORKLOG.md'; } catch (e) { errlog.note('orch-history', 'writeMd', e); } }
    cacheEntries = entries; cacheMs = Date.now();
    if (orchEv) { try { orchEv.init(P().vibeDir); orchEv.emit('history.collect', { total: entries.length, sec: st.sec, bytesRead: st.sessionBytesRead, sources: st.sources }); } catch { } }
    say('done', { stats: st }); return st;
  } catch (e) { errlog.note('orch-history', 'collect', e); say('error', { text: e.message }); return { error: e.message }; }
  finally { busy = false; prog = null; }
}

// ── 조회 ──
let cacheEntries = null; let cacheMs = 0;
function load() {
  const f = path.join(histDir(), 'worklog.jsonl'); let m = 0; try { m = fs.statSync(f).mtimeMs; } catch { return []; }
  if (cacheEntries && cacheMs >= m) return cacheEntries;
  const out = []; for (const ln of readText(f).split('\n')) { if (!ln.trim()) continue; try { out.push(JSON.parse(ln)); } catch { } }
  cacheEntries = out; cacheMs = Date.now(); return out;
}
/** f = { from, to, area, kind, screen, q, vmOnly, limit } */
function list(f) {
  f = f || {}; const q = String(f.q || '').toLowerCase(); const kinds = f.kind ? String(f.kind).split(',') : null;
  const out = load().filter(e => (!f.from || e.date >= f.from) && (!f.to || e.date <= f.to) && (!f.area || e.area === f.area) && (!kinds || kinds.includes(e.kind)) && (!f.screen || (e.screens || []).includes(String(f.screen).toUpperCase()))
    && (!f.vmOnly || e.kind !== 'session' || e.vm) && (!q || `${e.title} ${(e.ask || []).join(' ')} ${(e.files || []).join(' ')}`.toLowerCase().includes(q)));
  return { total: out.length, items: out.slice(0, f.limit || 400) };
}
function get(id) { return load().find(e => e.id === id) || null; }
function stats() { return readJson(path.join(histDir(), 'stats.json'), null); }
function status() { return { busy, progress: prog, stats: stats() }; }

// ── 주제별 정리(Claude · 읽기 전용) — 주(월요일 시작) 단위. 끝난 주는 결과 파일이 있으면 다시 부르지 않는다 ──
function weekOf(date) { const d = new Date(`${date}T00:00:00`); const wd = (d.getDay() + 6) % 7; d.setDate(d.getDate() - wd); return `${d.getFullYear()}-${two(d.getMonth() + 1)}-${two(d.getDate())}`; }
function weeks() {
  const by = {}; for (const e of load()) { if (!e.date || !(e.kind === 'change' || (e.kind === 'session' && e.vm) || e.kind === 'proposal')) continue; const w = weekOf(e.date); by[w] = (by[w] || 0) + 1; }
  const thisWeek = weekOf(localDT(Date.now()).date);
  return Object.keys(by).sort().reverse().map(w => { const s = readJson(path.join(histDir(), `summary_${w}.json`), null); return { week: w, count: by[w], done: !!s, at: s ? s.at : '', closed: w < thisWeek }; });
}
function summary(week) { return readJson(path.join(histDir(), `summary_${week}.json`), null); }
async function summarize(week, force) {
  const agent = require('./orch-agent'); const thisWeek = weekOf(localDT(Date.now()).date);
  const prev = summary(week); if (prev && !force && week < thisWeek) return { cached: true, summary: prev };
  const to = (() => { const d = new Date(`${week}T00:00:00`); d.setDate(d.getDate() + 6); return localDT(d.getTime()).date; })();
  const items = load().filter(e => e.date >= week && e.date <= to && (e.kind === 'change' || (e.kind === 'session' && e.vm) || e.kind === 'proposal' || e.kind === 'incident'));
  if (!items.length) return { empty: true };
  const brief = items.map(e => ({ id: e.id, kind: e.kind, date: e.date, time: e.time, area: e.area, title: e.title, ask: (e.ask || []).slice(0, e.kind === 'session' ? 25 : 3).map(a => a.slice(0, 220)), files: (e.files || []).slice(0, 10), unverified: (e.unverified || []).slice(0, 4), status: e.status }));
  const inF = path.join(histDir(), `summary_${week}.in.json`); writeJson(inF, brief);
  const rel = path.relative(P().root, inF).replace(/\\/g, '/');
  const prompt = [
    `Vibe_Manager(VM) 작업 이력 ${week} ~ ${to} 주간 ${items.length}건을 주제별로 정리한다. 파일을 고치지 않는다(읽기 전용).`,
    `입력 파일: ${rel} (항목 = id, kind, date, area, title, ask(사용자 지시 원문), files, unverified).`,
    '할 일: ① 같은 목적의 항목을 주제로 묶는다 ② 주제마다 무엇을 왜 바꿨는지 2~3문장 ③ 같은 지시가 되풀이된 지점과 같은 곳을 여러 번 고친 지점을 찾는다 ④ 확인이 안 끝난 항목을 모은다.',
    '근거는 입력 파일의 id 만 쓴다. 입력에 없는 사실, 추측, 평가 문구를 쓰지 않는다. 문장은 개조식(~함, ~임)으로 쓰고 수식어를 넣지 않는다.',
    '마지막에 아래 JSON 1개만 ```json 블록으로 낸다.',
    '{"week":"<주 시작일>","topics":[{"title":"","summary":"","ids":["CL:..."],"files":[""]}],"repeats":[{"what":"","count":0,"ids":[""]}],"open":[{"what":"","id":""}]}',
  ].join('\n');
  const r = await agent.withLock(`history:${week}`, () => agent.runClaude(prompt, { permissionMode: 'default', allowedTools: 'Read,Glob,Grep', label: `이력 주제별 정리 ${week}` }));
  if (!r || r.busy) return { busy: true };
  const j = agent.lastJsonBlock(r.text || (r.result && r.result.result) || '');
  if (!j || !Array.isArray(j.topics)) { errlog.note('orch-history', 'summarize', `결과 JSON 없음 (exit ${r.code})`); return { error: `결과 JSON 없음 (exit ${r.code})`, log: r.log }; }
  const known = new Set(items.map(e => e.id)); for (const t of j.topics) t.ids = (t.ids || []).filter(id => known.has(id)); // 입력에 없는 id 는 버린다
  const out = { week, to, at: nowLocal(), items: items.length, costUsd: r.costUsd, sec: Math.round((r.ms || 0) / 1000), log: r.log, topics: j.topics.filter(t => t.ids.length), repeats: (j.repeats || []).slice(0, 30), open: (j.open || []).slice(0, 60) };
  writeJson(path.join(histDir(), `summary_${week}.json`), out); say('done', { summary: week }); return { summary: out };
}

function on(fn) { listeners.add(fn); return () => listeners.delete(fn); }
/** o = { paths: () => p, sessionDirs?: [폴더], writeMd?: false } */
function init(o) { getPaths = o.paths; opts = o || {}; cacheEntries = null; return true; }

module.exports = { init, collect, list, get, stats, status, weeks, summary, summarize, on, parseChangelog, redact, areaOf, weekOf, renderMd, KIND_KO };
