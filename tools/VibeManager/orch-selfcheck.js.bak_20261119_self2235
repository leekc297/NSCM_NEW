// 2026-11-19 VMO 자가진단 Q4~Q6: VM 자신의 보완 필요 지점을 찾는다 — 점검 항목 S1~S12(코드) → 사건 R12 → Claude 진단(읽기 전용) → 개선안(승인 뒤 반영).
//   S1 구문(VM JS) · S2 시험(test/run_all.js) · S3 저장소↔설치 폴더 내용 차이 · S4 정의 파일 정합(quick.json · steps.json · package.json · require)
//   S5 실행 오류(.vibe/orch/vm_errors.jsonl) · S6 변경 기록의 미확인 항목 원장 · S7 VMO 자기 상태 · S8 반영한 개선안의 재발
//   S9 반복 수정 지점(이력 원장) · S10 용량 · S11 고정 문구(doc_style.py) · S12 설정 정합
//   주기: 가벼운 항목(S3 S5 S6 S7 S8 S9) = selfLightMin(10)분 · 무거운 항목(S1 S2 S4 S11 S12) = VM 파일이 바뀌고 selfSettleSec(120)초 조용할 때와 selfHeavyHours(24)시간마다 · S10 = 하루 1회
//   결과: .vibe/orch/selfcheck/result.json(최신) · history.jsonl(회차별) · unverified.json(미확인 원장 상태) · sync_log.jsonl(설치 폴더 동기화 기록)
//   상태 fail = 사건 R12 로 올린다(같은 항목은 풀릴 때까지 1건). warn = 자가진단 탭 표시만.
//   설치 폴더 동기화는 S1 · S2 · S4 가 지금 파일 상태로 통과했을 때만 자동으로 한다(selfAutoSync). VM 코드 수정은 개선안 승인 뒤에만 한다.
'use strict';
const fs = require('fs');
const path = require('path');
const cp = require('child_process');
const crypto = require('crypto');
const vm = require('vm');
const Module = require('module');
let errlog = { note() { return null; }, stats() { return []; } }; try { errlog = require('./orch-errlog'); } catch { }
let orchEv = null; try { orchEv = require('./orch-events'); } catch { orchEv = null; }

const DEF = { selfEnabled: true, selfLightMin: 10, selfHeavyHours: 24, selfSettleSec: 120, selfErrRepeat: 3, selfErrWindowMin: 60, selfAutoSync: true, selfDiagEveryHours: 24, selfDiagOnFail: true, selfDiagGapMin: 60, selfLogBigGB: 1, selfTestTimeoutSec: 900, selfStaleIncidentHours: 24, selfRepeatWatchHours: 24, proposalMaxPerDiag: 5, selfAutoApply: true, selfAutoApplyMaxPerDay: 6 };
const NAMES = { S1: '구문', S2: '시험', S3: '설치본 차이', S4: '정의 정합', S5: '실행 오류', S6: '미확인 추적', S7: 'VMO 자기 상태', S8: '개선안 효과', S9: '반복 수정', S10: '용량', S11: '고정 문구', S12: '설정 정합' };
const LIGHT = ['S3', 'S5', 'S6', 'S7', 'S8', 'S9']; const HEAVY = ['S1', 'S2', 'S4', 'S11', 'S12']; const DAILY = ['S10'];
const BUNDLE_FILES = ['package.json', 'quick.json', 'steps.json', 'README.md', 'CHANGELOG.md', 'CONCEPT.md'];
const READ_TOOLS = 'Read,Glob,Grep,Bash(dir *),Bash(ls *),Bash(type *),Bash(cat *),Bash(git status*),Bash(git diff*),Bash(git log*)'; // 주의: 허용 도구 문구에 '--' 로 시작하는 낱말을 넣지 않는다. 셸이 공백으로 나눠 claude CLI 가 옵션으로 읽는다(2026-11-19 21:47 실측: unknown option '--check' exit 1)

let getPaths = null; let opts = {}; let started = false; let timer = null; let running = null; let notifier = null;
let lastFp = ''; let fpChangedAt = 0; let fpChecked = ''; let lastDiagMs = 0;
const listeners = new Set();

const P = () => getPaths();
const vmDir = () => opts.vmDir || path.join(P().root, 'tools', 'VibeManager');
const extDir = () => opts.extDir || P().extDir || '';
const selfDir = () => path.join(P().vibeDir, 'orch', 'selfcheck');
const two = n => String(n).padStart(2, '0');
const nowLocal = ms => (orchEv ? orchEv.nowLocal(ms) : new Date(ms || Date.now()).toISOString());
const dayTag = () => { const d = new Date(); return `${d.getFullYear()}${two(d.getMonth() + 1)}${two(d.getDate())}`; };
const hmTag = () => { const d = new Date(); return `${two(d.getHours())}${two(d.getMinutes())}`; };
const readJson = (f, d) => { try { return JSON.parse(fs.readFileSync(f, 'utf8').replace(/^﻿/, '')); } catch { return d; } };
function replaceFile(tmp, f) { for (let i = 0; i < 3; i++) { try { fs.renameSync(tmp, f); return; } catch (e) { if (i === 2 || !/EPERM|EBUSY|EACCES/.test(e.code || '')) { fs.copyFileSync(tmp, f); try { fs.unlinkSync(tmp); } catch { } return; } const t = Date.now() + 40 * (i + 1); while (Date.now() < t) { /* 짧게 기다림 */ } } } } // Windows 에서 다른 프로세스가 대상 파일을 잠깐 쥐면 rename 이 EPERM(2026-11-19 21:27 실측) → 재시도 뒤 복사
const writeJson = (f, v) => { try { fs.mkdirSync(path.dirname(f), { recursive: true }); fs.writeFileSync(f + '.t', JSON.stringify(v, null, 1), 'utf8'); replaceFile(f + '.t', f); return true; } catch (e) { errlog.note('orch-selfcheck', 'writeJson', e); return false; } };
const readText = f => { try { return fs.readFileSync(f, 'utf8'); } catch { return ''; } };
const lsDir = d => { try { return fs.readdirSync(d, { withFileTypes: true }); } catch { return []; } };
const sha = f => { try { return crypto.createHash('sha1').update(fs.readFileSync(f)).digest('hex'); } catch { return ''; } };
const hash = s => crypto.createHash('sha1').update(String(s)).digest('hex').slice(0, 10);
const say = (kind, o) => { const m = Object.assign({ type: 'selfcheck', kind }, o || {}); for (const fn of listeners) { try { fn(m); } catch (e) { errlog.note('orch-selfcheck', 'listener', e); } } };
function cfg() { const h = readJson(path.join(P().root, 'tools', 'Harness', 'harness.json'), {}); return Object.assign({}, DEF, (h && h.orch) || {}); }
const mod = n => { try { return require(`./${n}`); } catch (e) { errlog.note('orch-selfcheck', `require ${n}`, e); return null; } };
function sh(cmd, args, o) {
  return new Promise(resolve => {
    let out = ''; let done = false; const fin = (code, extra) => { if (done) return; done = true; clearTimeout(t); resolve({ code, out: out + (extra || '') }); };
    let child; try { child = cp.spawn(cmd, args, Object.assign({ cwd: P().root, windowsHide: true, env: Object.assign({}, process.env, { PYTHONIOENCODING: 'utf-8', PYTHONUTF8: '1' }) }, (o && o.spawn) || {})); } catch (e) { return resolve({ code: -1, out: e.message }); }
    const t = setTimeout(() => { try { cp.spawn('taskkill', ['/pid', String(child.pid), '/T', '/F'], { windowsHide: true }); } catch { } fin(-2, '\n[시간 초과]'); }, ((o && o.timeoutSec) || 120) * 1000);
    child.stdout.on('data', d => { out += d.toString('utf8'); if (out.length > 4e6) out = out.slice(-2e6); }); child.stderr.on('data', d => { out += d.toString('utf8'); });
    child.on('error', e => fin(-1, e.message)); child.on('close', code => fin(code));
  });
}
const vmJsFiles = () => lsDir(vmDir()).filter(e => e.isFile() && /\.js$/.test(e.name)).map(e => e.name).sort();
const R = (id, items, info, skip) => ({ id, name: NAMES[id], status: skip ? 'skip' : items.some(x => x.level !== 'warn') ? 'fail' : items.length ? 'warn' : 'ok', count: items.length, items: items.slice(0, 60), info: info || {}, note: skip || '' });
const F = (what, detail, key, extra) => Object.assign({ level: 'fail', what, detail: String(detail || '').slice(0, 600), key: key || what }, extra || {});
const W = (what, detail, key, extra) => Object.assign(F(what, detail, key, extra), { level: 'warn' });

// ── S1 구문 ──
function s1() {
  const items = []; const files = vmJsFiles();
  for (const f of files) { const src = readText(path.join(vmDir(), f)); try { new vm.Script(Module.wrap(src.replace(/^#!.*/, '')), { filename: f }); } catch (e) { items.push(F(`${f} 구문 오류`, `${e.message} (${String(e.stack || '').split('\n')[0]})`, `S1|${f}`, { file: f })); } }
  for (const f of ['package.json', 'quick.json', 'steps.json']) { const t = readText(path.join(vmDir(), f)); if (!t) continue; try { JSON.parse(t.replace(/^﻿/, '')); } catch (e) { items.push(F(`${f} JSON 오류`, e.message, `S1|${f}`, { file: f })); } }
  return R('S1', items, { files: files.length });
}
// ── S2 시험 ──
async function s2() {
  const runner = path.join(vmDir(), 'test', 'run_all.js'); if (!fs.existsSync(runner)) return R('S2', [], {}, 'test/run_all.js 없음');
  const r = await sh(process.env.VIBE_NODE || 'node', [runner, vmDir(), '--json'], { timeoutSec: cfg().selfTestTimeoutSec });
  const ln = r.out.split(/\r?\n/).reverse().find(l => l.startsWith('RESULT ')); let j = null; try { j = ln ? JSON.parse(ln.slice(7)) : null; } catch { }
  if (!j) return R('S2', [F('시험 실행기 결과 없음', `exit ${r.code} · ${r.out.slice(-400)}`, 'S2|runner')], {});
  const items = j.files.filter(x => !x.ok).map(x => F(`${x.file} 실패`, `exit ${x.code} · PASS ${x.pass} · FAIL ${x.fail} · ${x.failLines.join(' / ') || x.last}`, `S2|${x.file}`, { file: x.file }));
  return R('S2', items, { files: j.files.length, ok: j.files.filter(x => x.ok).length, pass: j.pass, fail: j.fail, sec: j.sec, skipped: j.skipped });
}
// ── S3 저장소 ↔ 설치 폴더 ──
function bundleList() { const out = [...vmJsFiles(), ...BUNDLE_FILES.filter(f => fs.existsSync(path.join(vmDir(), f)))]; for (const e of lsDir(path.join(vmDir(), 'media'))) if (e.isFile() && !/\.bak_/.test(e.name)) out.push(`media/${e.name}`); return out; }
function diffInstalled() {
  const ed = extDir(); if (!ed || !fs.existsSync(ed)) return { skip: '설치 폴더 없음' }; if (path.resolve(ed).toLowerCase() === path.resolve(vmDir()).toLowerCase()) return { skip: '저장소 폴더에서 실행 중(개발 모드)' };
  const diff = [], missing = []; const list = bundleList();
  for (const f of list) { const a = sha(path.join(vmDir(), f)); const b = sha(path.join(ed, f)); if (!b) missing.push(f); else if (a !== b) diff.push(f); }
  return { diff, missing, total: list.length };
}
function s3() {
  const d = diffInstalled(); if (d.skip) return R('S3', [], {}, d.skip);
  const st = f => { try { const s = fs.statSync(f); return `${s.size}바이트 ${nowLocal(s.mtimeMs).slice(0, 16)}`; } catch { return '없음'; } };
  const items = [...d.diff.map(f => F(`${f} 내용 다름`, `저장소 ${st(path.join(vmDir(), f))} / 설치본 ${st(path.join(extDir(), f))}`, `S3|${f}`, { file: f })), ...d.missing.map(f => F(`${f} 설치본에 없음`, `저장소 ${st(path.join(vmDir(), f))}`, `S3|${f}`, { file: f }))];
  return R('S3', items, { compared: d.total, diff: d.diff.length, missing: d.missing.length });
}
/** 저장소 → 설치 폴더 복사. 설치본의 종전 파일은 <파일>.bak_<yyyymmdd>_<tag> 로 남긴다. files 를 주면 그 파일만 */
function syncInstalled(by, tag, files) {
  const d = diffInstalled(); if (d.skip) return { ok: false, why: d.skip };
  const want = [...d.diff, ...d.missing].filter(f => !files || files.includes(f)); const copied = [], fail = []; const t = tag || `sync${hmTag()}`;
  for (const f of want) { const from = path.join(vmDir(), f); const to = path.join(extDir(), f);
    try { fs.mkdirSync(path.dirname(to), { recursive: true }); if (fs.existsSync(to)) fs.copyFileSync(to, `${to}.bak_${dayTag()}_${t}`); fs.copyFileSync(from, to); copied.push(f); } catch (e) { fail.push(`${f}: ${e.message}`); errlog.note('orch-selfcheck', 'syncInstalled', e); } }
  const rec = { at: nowLocal(), by: by || 'VMO', tag: `${dayTag()}_${t}`, copied, fail };
  try { fs.mkdirSync(selfDir(), { recursive: true }); fs.appendFileSync(path.join(selfDir(), 'sync_log.jsonl'), JSON.stringify(rec) + '\n', 'utf8'); } catch { }
  if (orchEv && copied.length) { try { orchEv.emit('selfcheck.sync', { copied: copied.length, files: copied.slice(0, 20), by: rec.by }); } catch { } }
  return Object.assign({ ok: !fail.length }, rec);
}
// ── S4 정의 파일 정합 ──
async function s4() {
  const items = []; const d = vmDir(); const quick = readJson(path.join(d, 'quick.json'), null); const steps = readJson(path.join(d, 'steps.json'), null); const pkg = readJson(path.join(d, 'package.json'), null);
  const info = {};
  if (quick && steps) {
    const tasks = new Set((steps.steps || []).flatMap(s => (s.tasks || []).map(t => t.id))); const its = (quick.groups || []).flatMap(g => g.items || []); const labels = its.map(i => String(i.label || ''));
    info.tasks = tasks.size; info.menuItems = its.length;
    const need = (id, where) => { if (id && typeof id === 'string' && !tasks.has(id)) items.push(F(`없는 작업 id 참조: ${id}`, where, `S4|task|${id}`)); };
    const lab = (pre, where) => { if (pre && !labels.some(l => l.startsWith(pre))) items.push(F(`없는 메뉴 참조: ${pre}`, where, `S4|label|${pre}`)); };
    for (const it of its) {
      const w = `quick.json 메뉴 '${it.label}'`;
      need(it.task, `${w} task`); for (const k of ['preTask', 'postTask']) for (const x of [].concat(it[k] || [])) need(typeof x === 'string' ? x : x && x.task, `${w} ${k}`);
      for (const x of it.proofTasks || []) need(typeof x === 'string' ? x : x && x.task, `${w} proofTasks`);
      (it.steps || []).forEach((s, n) => { need(s.task, `${w} ${n + 1}단계`); lab(s.claudeOf, `${w} ${n + 1}단계 claudeOf`); if (s.repair) { need(s.repair.rerunTask, `${w} ${n + 1}단계 repair.rerunTask`); lab(s.repair.claudeOf, `${w} ${n + 1}단계 repair.claudeOf`); }
        if (s.verify && s.verify.type === 'fileExists' && !s.verify.file) items.push(F('verify fileExists 에 file 없음', `${w} ${n + 1}단계`, `S4|verify|${it.label}|${n}`)); });
    }
    const ext = readText(path.join(d, 'extension.js'));
    for (const m of ext.matchAll(/\['vibeManager\.q\w+',\s*'([^']+)'\]/g)) lab(m[1], 'extension.js 상단 아이콘 명령');
  } else items.push(F('quick.json 또는 steps.json 을 읽지 못함', d, 'S4|load'));
  if (pkg) {
    const ext = readText(path.join(d, 'extension.js')); const reg = new Set([...ext.matchAll(/registerCommand\(\s*'([^']+)'/g)].map(m => m[1])); for (const m of ext.matchAll(/\['(vibeManager\.\w+)',\s*'/g)) reg.add(m[1]);
    const dec = new Set(((pkg.contributes && pkg.contributes.commands) || []).map(c => c.command)); info.commands = dec.size;
    for (const c of dec) if (!reg.has(c)) items.push(F(`package.json 명령이 등록되지 않음: ${c}`, 'extension.js 에 registerCommand 없음', `S4|cmd|${c}`));
    for (const c of reg) if (!dec.has(c)) items.push(W(`등록한 명령이 package.json 에 없음: ${c}`, '명령 팔레트·메뉴에서 쓸 수 없음', `S4|cmdx|${c}`));
  }
  for (const f of vmJsFiles()) for (const m of readText(path.join(d, f)).matchAll(/require\(\s*'(\.\/[\w./-]+)'\s*\)/g)) { const t = path.join(d, m[1]); if (!fs.existsSync(t) && !fs.existsSync(`${t}.js`) && !fs.existsSync(`${t}.json`)) items.push(F(`없는 모듈 require: ${m[1]}`, f, `S4|req|${f}|${m[1]}`, { file: f })); }
  const inv = path.join(P().root, 'scripts', 'rules', 'inventory_check.py');
  if (fs.existsSync(inv) && opts.inventory !== false) { const r = await sh('python', [inv], { timeoutSec: 180 }); info.inventoryExit = r.code;
    // 줄 형식 '[OK] 이름: 내용' · 통과가 아니면 대괄호 안이 OK 가 아니다. VM 정의 파일 절(VM_JSON · CHAIN_FILES)만 fail, 나머지 절은 VM 밖이라 warn
    const lines = r.out.split(/\r?\n/); let hit = 0;
    lines.forEach((l, i) => { const m = /^\[(?!OK\])[^\]]*\]\s*(\w+):\s*(.*)$/.exec(l); if (!m) return; hit++; const more = lines.slice(i + 1, i + 4).filter(x => /^\s+-/.test(x)).map(x => x.trim()).join(' '); (/^(VM_JSON|CHAIN_FILES)$/.test(m[1]) ? items.push(F(`inventory_check ${m[1]}`, `${m[2]} ${more}`, `S4|inv|${m[1]}`)) : items.push(W(`inventory_check ${m[1]}`, `${m[2]} ${more}`, `S4|inv|${m[1]}`))); });
    if (r.code !== 0 && !hit) items.push(F(`inventory_check.py exit ${r.code}`, r.out.slice(-300), 'S4|inventory')); }
  return R('S4', items, info);
}
// ── S5 실행 오류 ──
function s5() {
  const c = cfg(); const seenF = path.join(selfDir(), 'err_seen.json'); const seen = readJson(seenF, {}); const since = Date.now() - c.selfErrWindowMin * 60000; const items = [];
  const all = errlog.stats(Date.now() - 7 * 86400000); const recent = errlog.stats(since);
  for (const g of recent) { const isNew = !seen[g.sig]; if (g.count >= c.selfErrRepeat || isNew) items.push(F(`${g.mod}.${g.fn} 오류 ${g.count}회${isNew ? '(새 서명)' : ''}`, `${g.msg} · ${(g.stack || []).slice(0, 2).join(' < ')} · 마지막 ${g.lastAt}`, `S5|${g.sig}`, { sig: g.sig })); }
  for (const g of all) if (!seen[g.sig]) seen[g.sig] = g.firstAt; writeJson(seenF, seen);
  return R('S5', items, { windowMin: c.selfErrWindowMin, recentSigs: recent.length, recent: recent.reduce((n, g) => n + g.count, 0), week: all.reduce((n, g) => n + g.count, 0), top: all.slice(0, 15).map(g => ({ sig: g.sig, count: g.count, lastAt: g.lastAt, msg: g.msg.slice(0, 200) })) });
}
// ── S6 미확인 추적 ──
function activations() { const out = []; for (const ln of readText(path.join(P().vibeDir, 'orch', 'activations.jsonl')).split('\n')) { if (!ln.trim()) continue; try { out.push(JSON.parse(ln)); } catch { } } return out; }
function ledger() {
  const hist = mod('orch-history'); if (!hist || !hist.stats()) return null;
  const stF = path.join(selfDir(), 'unverified.json'); const st = readJson(stF, {}); const acts = activations().map(a => a.ms).sort((a, b) => a - b); const rows = [];
  for (const e of hist.list({ kind: 'change', limit: 100000 }).items) for (const text of e.unverified || []) {
    const key = `${e.id}#${hash(text)}`; const s = st[key] || {}; const t = Date.parse(`${e.date}T${/^\d{1,2}:\d{2}$/.test(e.time || '') ? e.time.padStart(5, '0') : '23:59'}:00`);
    const reload = /창 다시 로드|실화면|재시작|Reload/i.test(text); const loadedAt = Number.isFinite(t) ? acts.find(a => a > t) : null;
    rows.push({ key, id: e.id, date: e.date, time: e.timeRaw || e.time || '', title: e.title, text, status: s.status || 'open', by: s.by || '', at: s.at || '', note: s.note || '', reload, loaded: reload && loadedAt ? nowLocal(loadedAt) : '' });
  }
  return rows;
}
/** 미확인 항목 상태 변경. status = confirmed(확인함) | dropped(대상 아님) | open */
function markUnverified(key, status, by, note) { const f = path.join(selfDir(), 'unverified.json'); const st = readJson(f, {}); st[key] = { status, by: by || '사용자', at: nowLocal(), note: String(note || '').slice(0, 300) }; writeJson(f, st); say('ledger', {}); return true; }
function s6() {
  const rows = ledger(); if (!rows) return R('S6', [], {}, '이력 수집 전(이력 탭의 지금 수집 실행 필요)');
  const open = rows.filter(r => r.status === 'open'); const items = open.slice(0, 60).map(r => W(`${r.date} ${r.title.slice(0, 60)}`, `${r.text}${r.loaded ? ` · 창 로드 기록 ${r.loaded.slice(0, 16)} 있음(화면 확인은 사용자)` : r.reload ? ' · 그 뒤 창 로드 기록 없음' : ''}`, `S6|${r.key}`));
  const r = R('S6', items, { total: rows.length, open: open.length, confirmed: rows.filter(x => x.status === 'confirmed').length, dropped: rows.filter(x => x.status === 'dropped').length, reloadOpen: open.filter(x => x.reload).length, reloadLoaded: open.filter(x => x.reload && x.loaded).length });
  r.count = open.length; return r;
}
// 사건 · 개선안은 파일에서 직접 읽는다 — 감시기 · 에이전트를 시작하지 않은 곳(명령줄 점검)에서도 같은 값이 나온다(2026-11-19 21:46 실측: 시작 전에는 watch.list() 가 0건이었다)
function dirJson(sub, limit) { const d = path.join(P().vibeDir, 'orch', sub); return lsDir(d).filter(e => e.isFile() && e.name.endsWith('.json')).map(e => e.name).sort().reverse().slice(0, limit || 1000).map(n => readJson(path.join(d, n), null)).filter(Boolean); }
function incList() { return dirJson('incidents', 1000); }
function propList() { return dirJson('proposals', 500); }
// ── S7 VMO 자기 상태 ──
function s7() {
  const watch = mod('orch-watch'); const agent = mod('orch-agent'); const c = cfg(); const items = []; const info = {};
  if (watch) {
    const h = watch.health ? watch.health() : null;
    if (h) { info.lastTickAt = h.lastTickMs ? nowLocal(h.lastTickMs) : ''; info.started = h.started; if (h.started && h.lastTickMs && Date.now() - h.lastTickMs > Math.max(120, 4 * (h.tickSec || 30)) * 1000) items.push(F('감시기 tick 멈춤', `마지막 ${info.lastTickAt} · 주기 ${h.tickSec}초`, 'S7|tick')); }
    const all = incList(); const cut = Date.now() - 7 * 86400000; const incs = all.filter(x => (x.ms || 0) >= cut); const byRule = {}; for (const k of Object.keys(watch.TITLE)) byRule[k] = 0; for (const x of incs) byRule[x.rule] = (byRule[x.rule] || 0) + (x.count || 1);
    info.incidents7d = incs.length; info.byRule = byRule; info.zeroRules = Object.keys(byRule).filter(k => !byRule[k]);
    const acted = incs.filter(x => (x.actions || []).length); info.acted = acted.length; info.resolved = acted.filter(x => x.status === 'resolved' || x.status === 'closed').length; info.needUser = incs.filter(x => x.status === 'need-user').length;
    const stale = all.filter(x => /^(open|acting|need-user)$/.test(x.status) && Date.now() - (x.ms || 0) > c.selfStaleIncidentHours * 3600000);
    info.stale = stale.length; for (const x of stale.slice(0, 10)) items.push(W(`미해결 사건 ${Math.round((Date.now() - x.ms) / 3600000)}시간째: ${x.id}`, `${x.rule} ${String(x.title).slice(0, 120)} · 상태 ${x.status}`, `S7|stale|${x.id}`));
  }
  if (agent && agent.status) { try { const s = agent.status(); info.agent = { on: s.on, enabled: s.enabled, busy: s.busy, queued: s.queued, askQueued: s.askQueued, perHour: s.perHour, maxPerHour: s.maxPerHour }; } catch { info.agent = null; /* 에이전트를 시작하지 않은 곳에서 돌린 점검 */ } }
  const evF = orchEv && orchEv.file(); if (evF) { try { info.eventsBytes = fs.statSync(evF).size; } catch { } }
  return R('S7', items, info);
}
// ── S8 반영한 개선안의 재발 ──
function s8() {
  const c = cfg(); const items = []; const applied = propList().filter(p => p.status === 'applied'); const incs = incList(); const watch = { get: id => incs.find(x => x.id === id) || null }; const cur = readJson(path.join(selfDir(), 'result.json'), { checks: {} });
  for (const p of applied) {
    const h = (p.history || []).filter(x => /반영 완료/.test(x.what || '')).pop(); const t = h ? Date.parse(h.at) : NaN; if (!Number.isFinite(t)) continue; const win = t + c.selfRepeatWatchHours * 3600000;
    if (p.incident) { const src = watch.get(p.incident); if (src) { const again = incs.filter(x => x.id !== src.id && x.rule === src.rule && x.sig === src.sig && (x.ms || 0) > t && (x.ms || 0) < win); if (again.length) items.push(F(`개선안 반영 뒤 같은 사건 ${again.length}건: ${p.title.slice(0, 60)}`, `개선안 ${p.id} 반영 ${h.at.slice(0, 16)} · 재발 ${again.map(x => x.id).slice(0, 4).join(', ')}`, `S8|${p.id}`, { proposal: p.id })); } }
    if (p.selfKey) { const [sid] = String(p.selfKey).split('|'); const chk = cur.checks && cur.checks[sid]; const still = chk && Date.parse(chk.at) > t && (chk.items || []).some(x => x.key === p.selfKey); if (still) items.push(F(`자가 보완 뒤에도 남음: ${p.title.slice(0, 60)}`, `개선안 ${p.id} 반영 ${h.at.slice(0, 16)} · 점검 항목 ${p.selfKey} 가 ${chk.at.slice(0, 16)} 점검에 다시 나옴`, `S8|${p.id}`, { proposal: p.id })); }
  }
  return R('S8', items, { applied: applied.length, waitingReload: applied.filter(p => p.needsReload && !activations().some(a => a.ms > (p.appliedMs || 0))).length });
}
// ── S9 반복 수정 지점 ──
function s9() {
  const hist = mod('orch-history'); const st = hist && hist.stats(); if (!st) return R('S9', [], {}, '이력 수집 전');
  const items = [...(st.repeatFiles || []).slice(0, 12).map(r => W(`${r.file} 7일 안 변경 기록 ${r.count}건`, `${r.from} 부터 · 전체 ${r.total}건 · 세션 수정 ${r.edits}건`, `S9|file|${r.file}`, { file: r.file })), ...(st.repeatAsks || []).slice(0, 12).map(r => W(`같은 지시 ${r.count}건`, r.text, `S9|ask|${hash(r.text)}`))];
  return R('S9', items, { collectedAt: st.at, repeatFiles: (st.repeatFiles || []).length, repeatAsks: (st.repeatAsks || []).length });
}
// ── S10 용량 ──
function s10() {
  const c = cfg(); const items = []; const logs = path.join(P().vibeDir, 'logs'); let total = 0, n = 0; const big = [];
  for (const e of lsDir(logs)) { if (!e.isFile()) continue; try { const s = fs.statSync(path.join(logs, e.name)); total += s.size; n++; if (s.size >= c.selfLogBigGB * 1073741824) big.push({ file: e.name, gb: Math.round(s.size / 1073741824 * 10) / 10, mtime: nowLocal(s.mtimeMs).slice(0, 16) }); } catch { } }
  for (const b of big.sort((x, y) => y.gb - x.gb)) items.push(W(`.vibe/logs/${b.file} ${b.gb}GB`, `마지막 수정 ${b.mtime}`, `S10|log|${b.file}`, { file: `.vibe/logs/${b.file}`, gb: b.gb }));
  const cnt = (d, re, depth) => { let k = 0; for (const e of lsDir(d)) { if (e.isDirectory()) { if (depth > 0 && e.name !== 'node_modules') k += cnt(path.join(d, e.name), re, depth - 1); } else if (re.test(e.name)) k++; } return k; };
  const bakRepo = cnt(vmDir(), /\.bak_\d{8}/, 2); const bakInst = extDir() && fs.existsSync(extDir()) && path.resolve(extDir()) !== path.resolve(vmDir()) ? cnt(extDir(), /\.bak_\d{8}/, 2) : 0; const snaps = lsDir(path.join(P().vibeDir, 'orch', 'snap')).filter(e => e.isDirectory()).length;
  return R('S10', items, { logsGB: Math.round(total / 1073741824 * 10) / 10, logFiles: n, bigFiles: big.length, bakRepo, bakInstalled: bakInst, snapDirs: snaps });
}
// ── S11 고정 문구 ──
async function s11() {
  const tool = path.join(P().root, 'tools', 'Docs', 'doc_style.py'); if (!fs.existsSync(tool) || opts.docStyle === false) return R('S11', [], {}, 'doc_style.py 없음');
  const out = path.join(selfDir(), 'doc_style'); const files = vmJsFiles().map(f => path.join(vmDir(), f));
  const r = await sh('python', [tool, ...files, '--out', out, '--quiet'], { timeoutSec: 300 });
  if (r.code === 0) return R('S11', [], { files: files.length });
  if (r.code !== 1) return R('S11', [W(`doc_style.py exit ${r.code}`, r.out.slice(-300), 'S11|run')], { files: files.length });
  // 줄 형식 '<파일> | 문장 n | 위반 m | 종류…'
  const per = []; for (const l of r.out.split(/\r?\n/)) { const m = /^\s*(\S+\.js)\s*\|\s*문장\s*(\d+)\s*\|\s*위반\s*(\d+)\s*\|?\s*(.*)$/.exec(l); if (m && Number(m[3])) per.push({ file: m[1], n: Number(m[3]), kinds: m[4].trim() }); }
  per.sort((a, b) => b.n - a.n); const total = per.reduce((n, x) => n + x.n, 0);
  if (!per.length) return R('S11', [W('doc_style.py 위반 보고(줄 형식 미해석)', r.out.slice(-300), 'S11|style')], { files: files.length });
  const x = R('S11', per.map(v => W(`${v.file} 문장 규칙 위반 ${v.n}건`, v.kinds, `S11|${v.file}`, { file: v.file })), { files: files.length, violations: total, report: path.relative(P().root, out).replace(/\\/g, '/') }); x.count = total; return x;
}
// ── S12 설정 정합 ──
function s12() {
  const items = []; const h = readJson(path.join(P().root, 'tools', 'Harness', 'harness.json'), {}); const orch = (h && h.orch) || {}; const src = vmJsFiles().map(f => readText(path.join(vmDir(), f))).join('\n');
  for (const k of Object.keys(orch)) if (!new RegExp(`\\b${k}\\b`).test(src)) items.push(W(`harness.json orch.${k} 를 읽는 코드 없음`, 'tools/VibeManager/*.js 에서 이름을 찾지 못함', `S12|orch|${k}`));
  const pkg = readJson(path.join(vmDir(), 'package.json'), {}); const props = Object.keys((((pkg.contributes || {}).configuration || {}).properties) || {});
  const pkgText = readText(path.join(vmDir(), 'package.json'));
  for (const k of props) { const short = k.replace(/^vibeManager\./, ''); if (pkgText.includes(`config.${k}`)) continue; /* package.json when 절이 쓰는 설정 */ if (!src.includes(`'${short}'`) && !src.includes(`"${short}"`) && !src.includes(`\`${short}\``)) items.push(W(`설정 ${k} 를 읽는 코드 없음`, "get('…') 호출을 찾지 못함", `S12|cfg|${k}`)); }
  return R('S12', items, { orchKeys: Object.keys(orch).length, settings: props.length });
}
const RUN = { S1: s1, S2: s2, S3: s3, S4: s4, S5: s5, S6: s6, S7: s7, S8: s8, S9: s9, S10: s10, S11: s11, S12: s12 };

// ── 실행 · 사건 연결 ──
function fingerprint() { const parts = []; for (const f of [...vmJsFiles(), 'package.json', 'quick.json', 'steps.json']) { try { const s = fs.statSync(path.join(vmDir(), f)); parts.push(`${f}:${s.size}:${Math.round(s.mtimeMs)}`); } catch { } } return hash(parts.join('|')); }
function result() { return readJson(path.join(selfDir(), 'result.json'), { checks: {} }); }
function syncIncidents(res, ran) {
  const watch = mod('orch-watch'); if (!watch || opts.incidents === false) return [];
  const f = path.join(selfDir(), 'raised.json'); const raised = readJson(f, {}); const now = new Set(); const fresh = [];
  for (const id of ran) for (const it of (res.checks[id] && res.checks[id].items) || []) {
    if (it.level === 'warn') continue; now.add(it.key);
    if (raised[it.key] && watch.get(raised[it.key]) && !/^(resolved|closed)$/.test(watch.get(raised[it.key]).status)) continue;
    const inc = watch.raise('R12', { screen: '', sig: `R12|${it.key}`, key: id, title: `VM 자가진단 ${id} ${NAMES[id]}: ${it.what}`.slice(0, 200), detail: it.detail, evidence: { check: id, key: it.key, file: it.file || '', result: '.vibe/orch/selfcheck/result.json' } });
    if (inc) { raised[it.key] = inc.id; fresh.push(inc.id); }
  }
  for (const [key, incId] of Object.entries(raised)) { const sid = key.split('|')[0]; if (!ran.includes(sid) || now.has(key)) continue; const inc = watch.get(incId); if (inc && !/^(resolved|closed)$/.test(inc.status)) watch.update(incId, { status: 'resolved' }, { by: 'VMO', what: `다시 점검한 결과 ${sid} 항목에서 사라짐`, grade: 'A' }); delete raised[key]; }
  writeJson(f, raised); return fresh;
}
/** which = ['S1',…] | 'light' | 'heavy' | 'all'. why = 실행 이유(기록용) */
async function run(which, why) {
  if (running) return running;
  const ids = which === 'light' ? LIGHT : which === 'heavy' ? [...HEAVY, ...LIGHT] : which === 'all' || !which ? Object.keys(RUN) : [].concat(which).filter(x => RUN[x]);
  running = (async () => {
    const t0 = Date.now(); const res = result(); res.checks = res.checks || {}; const fp = fingerprint();
    for (const id of ids) {
      say('progress', { id, name: NAMES[id] }); const t1 = Date.now(); let r;
      try { r = await RUN[id](); } catch (e) { errlog.note('orch-selfcheck', id, e); r = R(id, [F(`${id} 점검 중 오류`, e.message, `${id}|error`)], {}); }
      r.at = nowLocal(); r.ms = Date.now() - t1; r.fp = fp; res.checks[id] = r;
    }
    res.at = nowLocal(); res.ms = Date.now(); res.why = why || ''; res.ran = ids; res.fp = fp;
    res.summary = { fail: Object.values(res.checks).filter(c => c.status === 'fail').length, warn: Object.values(res.checks).filter(c => c.status === 'warn').length, ok: Object.values(res.checks).filter(c => c.status === 'ok').length, skip: Object.values(res.checks).filter(c => c.status === 'skip').length, failItems: Object.values(res.checks).reduce((n, c) => n + (c.status === 'fail' ? c.items.filter(i => i.level !== 'warn').length : 0), 0) };
    writeJson(path.join(selfDir(), 'result.json'), res);
    try { fs.appendFileSync(path.join(selfDir(), 'history.jsonl'), JSON.stringify({ at: res.at, why: res.why, ran: ids, sec: Math.round((Date.now() - t0) / 100) / 10, status: Object.fromEntries(ids.map(i => [i, `${res.checks[i].status}:${res.checks[i].count}`])) }) + '\n', 'utf8'); } catch { }
    const fresh = syncIncidents(res, ids); res.newIncidents = fresh;
    if (orchEv) { try { orchEv.init(P().vibeDir); orchEv.emit('selfcheck', { why: res.why, ran: ids, sec: Math.round((Date.now() - t0) / 1000), fail: res.summary.fail, warn: res.summary.warn, newIncidents: fresh.length }); } catch { } }
    // 설치 폴더 자동 동기화: 구문 · 시험 · 정합이 지금 파일 상태로 통과했을 때만
    const c = cfg(); const okNow = id => res.checks[id] && res.checks[id].status === 'ok' && res.checks[id].fp === fp;
    if (c.selfAutoSync && opts.autoSync !== false && ids.includes('S3') && res.checks.S3.status === 'fail' && okNow('S1') && okNow('S2') && (okNow('S4') || (res.checks.S4 && res.checks.S4.status === 'warn' && res.checks.S4.fp === fp))) {
      const s = syncInstalled('VMO 자동', null); res.autoSync = s; if (s.copied && s.copied.length) { res.checks.S3 = Object.assign(s3(), { at: nowLocal(), ms: 0, fp }); writeJson(path.join(selfDir(), 'result.json'), res); syncIncidents(res, ['S3']); if (notifier) notifier(`설치 폴더 동기화 ${s.copied.length}개 파일. 적용은 VS Code 창 다시 로드 뒤`); }
    }
    say('done', { summary: res.summary }); return res;
  })();
  try { return await running; } finally { running = null; }
}
/** 개선안 반영 게이트: 구문 → 시험 → 정합. 반환 { ok, checks: {S1,S2,S4}, text } */
async function gate() {
  const res = await run(['S1', 'S2', 'S4'], '개선안 반영 게이트'); const c = res.checks; const bad = ['S1', 'S2', 'S4'].filter(i => c[i].status === 'fail');
  const text = `구문 검사 ${c.S1.info.files}개 파일 ${c.S1.status === 'fail' ? `실패 ${c.S1.count}` : '통과'}, 시험 ${c.S2.info.ok != null ? `${c.S2.info.ok}/${c.S2.info.files}개 파일 통과(PASS ${c.S2.info.pass}, FAIL ${c.S2.info.fail})` : c.S2.note || '결과 없음'}, 정의 정합 ${c.S4.status === 'fail' ? `실패 ${c.S4.items.filter(i => i.level !== 'warn').length}` : '통과'}`;
  return { ok: !bad.length && c.S2.status !== 'skip', bad, text, detail: bad.flatMap(i => c[i].items.filter(x => x.level !== 'warn').slice(0, 5).map(x => `${i} ${x.what}: ${x.detail}`.slice(0, 300))) };
}

// ── Claude 진단(읽기 전용) → 개선안 ──
async function diagnose(manual) {
  const agent = mod('orch-agent'); const imp = mod('orch-improve'); if (!agent || !imp) return { ok: false, why: '에이전트 모듈 없음' };
  const c = cfg(); if (!manual && (c.enabled === false || !c.selfEnabled)) return { skipped: true };
  const res = result(); const hist = mod('orch-history'); const hs = hist && hist.stats(); const rows = ledger() || [];
  const input = { at: nowLocal(), checks: Object.values(res.checks || {}).filter(x => x.status === 'fail' || x.status === 'warn').map(x => ({ id: x.id, name: x.name, status: x.status, count: x.count, at: x.at, info: x.info, items: x.items.slice(0, 20) })), errors: errlog.stats(Date.now() - 7 * 86400000).slice(0, 15), repeatFiles: hs ? (hs.repeatFiles || []).slice(0, 15) : [], repeatAsks: hs ? (hs.repeatAsks || []).slice(0, 15) : [], unverifiedOpen: rows.filter(r => r.status === 'open').slice(0, 40).map(r => ({ id: r.id, date: r.date, title: r.title, text: r.text, loaded: r.loaded })), known: propList().slice(0, 40).map(x => ({ title: x.title, status: x.status, reason: x.reason || '' })) };
  if (!input.checks.length && !input.errors.length) { say('diag', { text: '진단 생략: 어긋난 점검 항목과 오류 기록 0건' }); return { skipped: true, why: '어긋난 항목 0건' }; }
  const inF = path.join(selfDir(), 'diag_in.json'); writeJson(inF, input); const rel = path.relative(P().root, inF).replace(/\\/g, '/');
  const prompt = [
    '.claude/agents/vm-orchestra.md 의 지킬 것과 "VM 자가진단" 절을 따른다. 이번 일은 Vibe_Manager(tools/VibeManager) 자가진단이다. 파일을 고치지 않는다(읽기만).',
    `입력 파일 ${rel} 을 읽는다. checks = 코드 점검에서 어긋난 항목(S1~S12), errors = 최근 7일 VM 실행 오류(서명별), repeatFiles · repeatAsks = 작업 이력에서 여러 번 고친 파일과 되풀이된 지시, unverifiedOpen = 변경 기록에 남은 미확인 항목, known = 이미 올라온 개선안.`,
    `할 일: 항목마다 해당 소스(tools/VibeManager/*.js · quick.json · steps.json · .vibe/orch/vm_errors.jsonl · tools/VibeManager/CHANGELOG.md)를 읽어 원인을 확인하고, 고칠 가치가 있는 것만 개선안으로 최대 ${c.proposalMaxPerDiag}건 올린다.`,
    '규칙',
    '- 개선안마다 근거(입력 파일의 어느 항목 key, 소스 파일:줄, 오류 기록 서명)를 적는다. 근거를 소스에서 확인하지 못한 것은 올리지 않는다.',
    '- 여러 번 고친 파일(repeatFiles)은 변경 기록(CHANGELOG.md)에서 그 파일이 나온 절을 from 일자부터 전부 읽고(하루치만 보지 않는다) 같은 원인인지 확인한다. 같은 원인이면 원인을 없애는 개선안 1건으로 올리고, 대조한 절 수와 묶지 못한 이유를 summary 에 적는다.',
    '- S11(고정 문구)은 위반이 있는 파일 전부가 대상이다. 파일을 몇 개씩 묶어 개선안을 나누고, 이번에 못 올린 파일은 summary 에 파일명과 건수로 적는다. 사용자 인용 원문과 코드 식별자는 고치지 않는다.',
    '- 대상이 tools/VibeManager · tools/Harness · tools/E2E · tools/Docs 의 코드뿐인 개선안은 승인 없이 VMO 가 바로 반영한다(반영 전후 게이트, 새로 어긋나면 되돌림). 그러니 한 개선안은 게이트 한 번으로 확인되는 크기로 잡고, 동작이 바뀌면 targets 에 시험 파일(tools/VibeManager/test/t_*.js)을 넣어 시험도 함께 고치게 한다.',
    '- 파일 삭제 · 설정 파일 · 룰 · hook · FE · BE · DB 객체가 대상인 개선안은 코드 수정 개선안과 섞지 말고 따로 올린다(사용자 승인 대상).',
    '- targets 는 저장소 경로(tools/VibeManager/… 등)만 적는다. 설치 폴더 복사와 CHANGELOG 기록은 VMO 가 한다.',
    '- verify 는 반영 뒤 VMO 가 돌리는 게이트(구문 검사, test/run_all.js, 정의 정합) 말고 이 개선안에만 필요한 확인 명령과 기대 결과를 적는다. 없으면 빈 문자열.',
    '- known 과 같은 내용, 반려된 내용은 올리지 않는다. 올릴 것이 없으면 proposals 를 빈 배열로 낸다.',
    '- 마지막 출력은 아래 형식의 JSON 코드 블록 1개다.',
    '```json',
    '{ "proposals": [ { "title": "", "check": "S5", "key": "입력 항목의 key", "evidence": "근거", "targets": ["tools/VibeManager/…"], "before_after": "변경 전 → 변경 후", "verify": "", "rollback": "", "sig": "같은 안을 가리는 짧은 열쇠말" } ], "summary": "진단 요약 2~3문장" }',
    '```',
  ].join('\n');
  lastDiagMs = Date.now();
  const r = await agent.withLock('selfdiag', async () => { agent.say('start', { id: 'selfdiag', text: `VM 자가진단: 어긋난 점검 ${input.checks.length}종, 오류 서명 ${input.errors.length}종` }); return agent.runClaude(prompt, { label: 'VM 자가진단', permissionMode: 'default', allowedTools: READ_TOOLS }); });
  if (r && r.busy) { say('diag', { text: '진단 보류: 에이전트가 다른 일 처리 중' }); return { busy: true }; }
  const out = agent.lastJsonBlock(r.text); const meta = { lastMs: Date.now(), lastAt: nowLocal(), manual: !!manual, log: r.log, sec: Math.round((r.ms || 0) / 1000), costUsd: r.costUsd };
  if (!r.ok && !out) { meta.lastResult = `진단 실패 exit ${r.code}${r.timedOut ? ' (시간 초과)' : ''}`; writeJson(path.join(selfDir(), 'diag_meta.json'), meta); agent.say('end', { id: 'selfdiag', ok: false, text: meta.lastResult }); say('diag', { text: meta.lastResult }); return { ok: false }; }
  if (!out || !Array.isArray(out.proposals)) { meta.lastResult = '결과 JSON 없음'; writeJson(path.join(selfDir(), 'diag_meta.json'), meta); agent.say('end', { id: 'selfdiag', ok: false, text: meta.lastResult }); say('diag', { text: meta.lastResult }); return { ok: false }; }
  let added = 0, dups = 0;
  for (const o of out.proposals.slice(0, c.proposalMaxPerDiag)) { if (!o || !o.title || !o.evidence) continue; const a = imp.add(Object.assign({}, o, { selfKey: o.key || '', check: o.check || '' }), 'self'); if (a.id) added++; else dups++; }
  meta.lastResult = `개선안 ${added}건 등록${dups ? `, 중복 ${dups}건 제외` : ''}`; meta.summary = String(out.summary || '').slice(0, 600); writeJson(path.join(selfDir(), 'diag_meta.json'), meta);
  agent.say('end', { id: 'selfdiag', ok: true, text: `VM 자가진단 완료: ${meta.lastResult}. ${meta.summary}` }); say('diag', { text: meta.lastResult });
  if (added && notifier) notifier(`VM 자가진단 개선안 ${added}건 승인 대기`);
  return { ok: true, added, dups };
}
// ── 자가 보완 자동 반영(2026-11-19 사용자 지시: "자가 진단은 … 보완이 필요하면 보완을 진행해야 합니다" · 권장안 승인) ──
//   자동 = 대상이 전부 VM 코드 · 점검 도구(AUTO_ROOTS)인 자가진단 개선안. 반영 전후 게이트(구문 · 시험 · 정합)를 통과해야 남고, 새로 어긋나면 되돌린다.
//   승인 유지 = 파일 삭제 · 룰 · hook · 설정 파일 · FE · BE · DB 객체 · 대상 없는 안. 한 번 실패한 안은 자동으로 다시 하지 않는다(승인 버튼으로만).
const AUTO_ROOTS = ['tools/VibeManager/', 'tools/Harness/', 'tools/E2E/', 'tools/Docs/'];
const AUTO_DENY = [[/^tools\/VibeManager\/rules\//, '룰 문서'], [/(^|\/)hooks\//, 'hook'], [/harness\.json$|e2e\.config\.json$|users\.json$|settings\.json$/, '설정 파일'], [/\.(?:sql|pks|pkb)$/i, 'DB 객체'], [/\.bak_/, '백업 파일']];
function autoEligible(pr) {
  if (!pr || !pr.self) return { ok: false, why: '자가진단 개선안 아님' };
  const ts = (pr.targets || []).map(t => String(t).replace(/\\/g, '/').replace(/^\.\//, '')); if (!ts.length) return { ok: false, why: '대상 파일 없음' };
  if (/삭제|지움|delete|remove file/i.test(`${pr.title} `) && /파일|로그|폴더|file|log/i.test(`${pr.title}`)) return { ok: false, why: '파일 삭제' };
  for (const t of ts) { if (t.includes('..') || /^[A-Za-z]:|^\//.test(t)) return { ok: false, why: `저장소 밖 경로 ${t}` }; if (!AUTO_ROOTS.some(r => t.startsWith(r))) return { ok: false, why: `자동 범위 밖 ${t}` }; for (const [re, name] of AUTO_DENY) if (re.test(t)) return { ok: false, why: `${name} ${t}` }; }
  return { ok: true, why: '' };
}
let applying = false;
/** 승인 대기 중인 자가진단 개선안 가운데 자동 대상 1건을 반영한다. 반환 { id, ok } | { none } | { skipped } */
async function autoApplyNext(manual) {
  const imp = mod('orch-improve'); const agent = mod('orch-agent'); if (!imp || !agent) return { skipped: '모듈 없음' };
  const c = cfg(); if (!manual && (c.enabled === false || !c.selfEnabled || !c.selfAutoApply)) return { skipped: '자동 반영 꺼짐' };
  if (applying) return { skipped: '반영 중' };
  const all = propList(); const dayAgo = Date.now() - 24 * 3600000; const done = all.filter(p => p.auto && (p.autoMs || 0) > dayAgo).length;
  if (!manual && done >= c.selfAutoApplyMaxPerDay) return { skipped: `하루 상한 ${c.selfAutoApplyMaxPerDay}건` };
  const pend = all.filter(p => p.self && p.status === 'pending' && !p.autoTried).sort((a, b) => (a.ms || 0) - (b.ms || 0));
  let pick = null;
  for (const p of pend) { const e = autoEligible(p); if (e.ok) { if (!pick) pick = p; continue; } if (p.needsApproval !== e.why) { const cur = imp.get(p.id); if (cur) { cur.needsApproval = e.why; imp.save(cur); } } } // 승인 대상에는 사유를 적어 개선안 탭에 보이게 한다
  if (!pick) return { none: true };
  applying = true;
  try {
    const cur = imp.get(pick.id); cur.auto = true; cur.autoTried = true; cur.autoMs = Date.now(); imp.save(cur);
    say('auto', { text: `자가 보완 자동 반영 시작: ${pick.title}`, id: pick.id });
    const r = await imp.approve(pick.id, 'VMO 자동(게이트 통과 조건)');
    if (r && r.why === 'busy') { const b = imp.get(pick.id); if (b) { b.autoTried = false; imp.save(b); } return { id: pick.id, ok: false, busy: true }; }
    const after = imp.get(pick.id) || {};
    if (orchEv) { try { orchEv.emit('selfcheck.autoapply', { id: pick.id, ok: !!(r && r.ok), status: after.status, title: String(pick.title).slice(0, 140) }); } catch { } }
    if (notifier) notifier(r && r.ok ? `자가 보완 반영: ${pick.title}. ${after.needsReload ? '적용은 VS Code 창 다시 로드 뒤. ' : ''}개선안 탭에서 되돌릴 수 있음` : `자가 보완 반영 실패(되돌림): ${pick.title}`);
    say('auto', { text: `자가 보완 자동 반영 ${r && r.ok ? '완료' : '실패'}: ${pick.title}`, id: pick.id, ok: !!(r && r.ok) });
    return { id: pick.id, ok: !!(r && r.ok), status: after.status };
  } catch (e) { errlog.note('orch-selfcheck', 'autoApplyNext', e); return { id: pick.id, ok: false, error: e.message }; }
  finally { applying = false; }
}
/** 창 로드 기록이 있는 '다시 로드 필요' 미확인 항목을 한 번에 확인함으로 바꾼다(사용자가 누른 때만) */
function markLoadedAll(by) { const rows = (ledger() || []).filter(r => r.status === 'open' && r.reload && r.loaded); const f = path.join(selfDir(), 'unverified.json'); const st = readJson(f, {}); for (const r of rows) st[r.key] = { status: 'confirmed', by: by || '사용자', at: nowLocal(), note: `창 로드 기록 ${r.loaded.slice(0, 16)} 뒤 일괄 확인` }; writeJson(f, st); say('ledger', {}); return rows.length; }
function diagMeta() { return readJson(path.join(selfDir(), 'diag_meta.json'), {}); }

// ── 주기 ──
let lastLight = 0, lastHeavy = 0, lastDaily = 0;
async function tick() {
  try {
    const c = cfg(); if (c.enabled === false || !c.selfEnabled || running || applying) return;
    const now = Date.now(); const fp = fingerprint(); if (fp !== lastFp) { lastFp = fp; fpChangedAt = now; }
    const st = mod('orch-state'); if (st) { try { if (st.snapshot().chains.length) return; } catch { } } // 체인 실행 중에는 점검으로 부하를 더하지 않는다
    let res = null;
    if ((fp !== fpChecked && now - fpChangedAt >= c.selfSettleSec * 1000) || now - lastHeavy >= c.selfHeavyHours * 3600000) { fpChecked = fp; lastHeavy = lastLight = now; res = await run('heavy', fp !== (result().fp || '') ? 'VM 파일 변경' : '정기'); }
    else if (now - lastLight >= c.selfLightMin * 60000) { lastLight = now; res = await run(fp !== fpChecked ? LIGHT.filter(x => x !== 'S3') : 'light', '정기'); } // 2026-11-19 VM 파일이 바뀌고 무거운 점검 전이면 S3 를 뺀다. 수정 중인 파일을 설치본 차이로 판정하면 파일마다 사건 R12 와 진단 호출이 생긴다(22:05:27 실측 4건). S3 는 selfSettleSec 뒤 무거운 점검에서 S1, S2, S4 와 같은 지문으로 판정한다
    if (now - lastDaily >= 24 * 3600000) { lastDaily = now; const hist = mod('orch-history'); if (hist && c.historyEnabled !== false) { try { await hist.collect(); } catch (e) { errlog.note('orch-selfcheck', 'history.collect', e); } } await run(['S10', 'S6', 'S9'], '하루 1회'); }
    const m = diagMeta(); const dueDaily = now - (m.lastMs || 0) >= c.selfDiagEveryHours * 3600000;
    if (c.selfAutoApply && !applying) { const ag = mod('orch-agent'); let idle = true; try { idle = !ag.status().busy; } catch { } if (idle) { const a = await autoApplyNext(false); if (a && a.id) return; } }
    if (res && ((c.selfDiagOnFail && res.newIncidents && res.newIncidents.length && now - lastDiagMs >= c.selfDiagGapMin * 60000) || (dueDaily && (res.summary.fail || res.summary.warn)))) await diagnose(false);
  } catch (e) { errlog.note('orch-selfcheck', 'tick', e); }
}

function on(fn) { listeners.add(fn); return () => listeners.delete(fn); }
function status() { const r = result(); return { running: !!running, applying, result: r, diag: diagMeta(), names: NAMES, cfg: (() => { const c = cfg(); return { selfEnabled: c.selfEnabled, selfAutoSync: c.selfAutoSync, selfLightMin: c.selfLightMin, selfAutoApply: c.selfAutoApply, selfAutoApplyMaxPerDay: c.selfAutoApplyMaxPerDay }; })() }; }
/** o = { paths: () => p, notify?: fn(text), vmDir?, extDir?, incidents?: false, autoSync?: false, inventory?: false, docStyle?: false, timer?: false } */
function init(o) {
  getPaths = o.paths; opts = o || {}; notifier = o.notify || null; if (started) return; started = true;
  try { fs.mkdirSync(selfDir(), { recursive: true }); } catch { }
  const r = result(); fpChecked = r.fp || ''; lastFp = fingerprint(); fpChangedAt = Date.now() - 3600000; lastHeavy = r.ms && r.ran && r.ran.includes('S2') ? r.ms : 0; lastDaily = (readJson(path.join(selfDir(), 'daily.json'), {}).ms) || 0;
  if (o.timer !== false) { timer = setInterval(() => { tick().then(() => { if (lastDaily) writeJson(path.join(selfDir(), 'daily.json'), { ms: lastDaily }); }); }, 60000); setTimeout(() => tick(), 45000); }
}
function dispose() { if (timer) { clearInterval(timer); timer = null; } started = false; }

module.exports = { init, dispose, on, run, gate, result, status, tick, diagnose, diagMeta, ledger, markUnverified, markLoadedAll, autoEligible, autoApplyNext, syncInstalled, diffInstalled, fingerprint, NAMES, DEF, LIGHT, HEAVY };
