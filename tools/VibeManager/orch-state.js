// 2026-11-19 VMO P2·P3: 실행 상태 모음 — 사건(.vibe/orch/events.jsonl)을 받아 '지금 돌고 있는 것'을 유지한다.
//   VM 안 사건은 orch-events.js 구독으로, VM 밖 사건(run_verify.py · runlock.js · 다른 VS Code 창)은 파일을 이어 읽어 받는다.
//   상황판(VMO 창)과 감시기(orch-watch.js)가 이 모듈의 snapshot()·on() 을 쓴다. Claude 를 부르지 않는다.
'use strict';
const fs = require('fs');
const path = require('path');
const os = require('os');
const cp = require('child_process');
let orchEv = null; try { orchEv = require('./orch-events'); } catch { orchEv = null; }

const procs = new Map();    // key → { label, screen, wb, stream, pid, t0, log, server }
const chains = new Map();   // runId → { screen, chain, label, wb, t0, shown, step:{no,name,actor,t0}|null, done:[{no,status,actor}] }
const claudes = new Map();  // key → { screen, wb, label, source, pid, t0 }
const waits = new Map();    // key → { kind, screen, why, pid, t0, max_sec, blocker_pid }
const jobs = new Map();     // jobId → { label, total, done, running, t0 }
const recent = [];          // 최근 사건(상황판 하단 · 최대 200)
const listeners = new Set();
let root = '', vibeDir = '', started = false, tailTimer = null, tailPos = 0, tailBuf = '';
let cpuPrev = null, cpuPct = null, tcpN = null, tcpAt = 0, tcpBusy = false;

function pidAlive(pid) { if (!pid) return false; try { process.kill(pid, 0); return true; } catch (e) { return !!(e && e.code === 'EPERM'); } }
const kProc = ev => `${ev.src}:${ev.pid}:${ev.procId != null ? ev.procId : (ev.childPid || ev.label)}`;
const kWait = ev => `${ev.src}:${ev.pid}:${ev.kind}:${ev.screen || ''}`;
const kClaude = ev => `${ev.pid}:${ev.wb != null ? ev.wb : ''}:${ev.job || ''}:${ev.screen || ''}`;

function apply(ev) {
  if (!ev || !ev.type) return;
  const t = ev.type;
  if (t === 'proc.start') procs.set(kProc(ev), { label: ev.label, screen: ev.screen || '', wb: ev.wb, stream: ev.stream, pid: ev.childPid, owner: ev.pid, t0: ev.ms, log: ev.log || '', server: !!ev.server });
  else if (t === 'proc.end') procs.delete(kProc(ev));
  else if (t === 'chain.start') chains.set(ev.runId, { screen: ev.screen, chain: ev.chain, label: ev.chainLabel, wb: ev.wb, job: ev.job || '', owner: ev.pid, t0: ev.ms, shown: ev.shown, step: null, done: [] });
  else if (t === 'step.start') { const c = chains.get(ev.runId); if (c) c.step = { no: ev.no, name: ev.name, actor: ev.actor, task: ev.task, t0: ev.ms }; }
  else if (t === 'step.end') { const c = chains.get(ev.runId); if (c) { c.step = null; c.done.push({ no: ev.no, status: ev.status, actor: ev.actor }); } }
  else if (t === 'chain.end') chains.delete(ev.runId);
  else if (t === 'claude.start') claudes.set(kClaude(ev), { screen: ev.screen || '', wb: ev.wb, label: ev.label || '', source: ev.source || '', pid: ev.childPid, owner: ev.pid, t0: ev.ms });
  else if (t === 'claude.end') claudes.delete(kClaude(ev));
  else if (t === 'wait.start') waits.set(kWait(ev), { kind: ev.kind, screen: ev.screen || '', why: ev.why || '', pid: ev.pid, t0: ev.ms, max_sec: ev.max_sec || null, blocker_pid: ev.blocker_pid || null });
  else if (t === 'wait.end') waits.delete(kWait(ev));
  else if (t === 'job.start') jobs.set(ev.job, { label: ev.label || '', total: ev.total || 0, done: 0, running: 0, t0: ev.ms, owner: ev.pid });
  else if (t === 'job.item.start') { const j = jobs.get(ev.job); if (j) j.running++; }
  else if (t === 'job.item.end') { const j = jobs.get(ev.job); if (j) { j.running = Math.max(0, j.running - 1); j.done++; } }
  else if (t === 'job.end') jobs.delete(ev.job);
  recent.push(ev); if (recent.length > 200) recent.shift();
  for (const fn of listeners) { try { fn(ev); } catch { } }
}

// 주인 프로세스가 없어진 항목 정리(중지·창 다시 로드·스크립트 강제 종료로 끝 사건이 안 남은 경우). 반환 = 정리한 항목(감시기가 '종료 기록 없음' 사건으로 쓴다)
function sweep() {
  const gone = [];
  for (const [k, v] of procs) if (!pidAlive(v.owner) || (v.pid && !pidAlive(v.pid) && Date.now() - v.t0 > 15000)) { procs.delete(k); gone.push(Object.assign({ what: 'proc' }, v)); }
  for (const [k, v] of chains) if (!pidAlive(v.owner)) { chains.delete(k); gone.push(Object.assign({ what: 'chain' }, v)); }
  for (const [k, v] of claudes) if (!pidAlive(v.owner)) { claudes.delete(k); gone.push(Object.assign({ what: 'claude' }, v)); }
  for (const [k, v] of waits) if (!pidAlive(v.pid)) { waits.delete(k); gone.push(Object.assign({ what: 'wait' }, v)); }
  for (const [k, v] of jobs) if (!pidAlive(v.owner)) { jobs.delete(k); }
  return gone;
}

// ── VM 밖 사건: 파일 이어 읽기(이 프로세스가 쓴 줄은 구독으로 이미 받았으므로 건너뛴다) ──
function tailTick() {
  const f = orchEv ? orchEv.file() : ''; if (!f) return;
  fs.stat(f, (e, st) => {
    if (e) return;
    if (st.size < tailPos) { tailPos = 0; tailBuf = ''; }
    if (st.size === tailPos) return;
    const len = Math.min(st.size - tailPos, 1024 * 1024); const b = Buffer.alloc(len);
    fs.open(f, 'r', (e2, fd) => {
      if (e2) return;
      fs.read(fd, b, 0, len, tailPos, (e3, n) => {
        fs.close(fd, () => { });
        if (e3 || n <= 0) return;
        tailPos += n; tailBuf += b.slice(0, n).toString('utf8');
        const lines = tailBuf.split(/\r?\n/); tailBuf = lines.pop();
        for (const ln of lines) { if (!ln.trim()) continue; let ev; try { ev = JSON.parse(ln); } catch { continue; } if (ev.src === 'vm' && ev.pid === process.pid) continue; apply(ev); }
      });
    });
  });
}

// ── 잠금 파일 · 부하 ──
function locks() {
  const out = []; const d = path.join(root, 'Doc', 'e2e');
  let names = []; try { names = fs.readdirSync(d).filter(f => /^_run(\.[\w.-]+)?\.lock$/.test(f) || /^_server_\d+\.lock$/.test(f)); } catch { }
  for (const n of names) {
    let j = null; try { j = JSON.parse(fs.readFileSync(path.join(d, n), 'utf8')); } catch { j = null; }
    const pid = j && Number(j.pid) || 0;
    out.push({ file: n, pid, started: (j && (j.started || (j.at ? new Date(j.at * 1000).toISOString() : ''))) || '', args: (j && (j.args || j.tag || j.id)) || '', alive: pid ? pidAlive(pid) : null, ppid: (j && j.ppid) || null, parent: (j && j.parent) || '', chain: (j && j.chain) || '' });
  }
  return out;
}
function sampleCpu() {
  const cs = os.cpus(); let idle = 0, total = 0;
  for (const c of cs) { for (const k of Object.keys(c.times)) total += c.times[k]; idle += c.times.idle; }
  if (cpuPrev && total > cpuPrev.total) cpuPct = Math.round(100 * (1 - (idle - cpuPrev.idle) / (total - cpuPrev.total)));
  cpuPrev = { idle, total };
}
function sampleTcp() {
  if (process.platform !== 'win32' || tcpBusy || Date.now() - tcpAt < 30000) return;
  tcpBusy = true;
  cp.exec('netstat -ano -p tcp | find /c "TCP"', { windowsHide: true, timeout: 15000 }, (e, so) => { tcpBusy = false; tcpAt = Date.now(); const n = parseInt(String(so || '').trim(), 10); tcpN = Number.isFinite(n) ? n : null; });
}
function load() { return { cpu: cpuPct, memFreeMB: Math.round(os.freemem() / 1048576), memTotalMB: Math.round(os.totalmem() / 1048576), tcp: tcpN, tcpAt, at: Date.now() }; }

/** 상황판용 현재 상태 */
function snapshot() {
  const now = Date.now(); const age = t0 => Math.max(0, Math.round((now - t0) / 1000));
  return {
    at: now,
    chains: [...chains.entries()].map(([id, c]) => ({ runId: id, screen: c.screen, label: c.label, wb: c.wb, job: c.job, sec: age(c.t0), shown: c.shown, doneN: c.done.length, step: c.step ? { no: c.step.no, name: c.step.name, actor: c.step.actor, sec: age(c.step.t0) } : null })),
    procs: [...procs.values()].filter(v => !v.server).map(v => ({ label: v.label, screen: v.screen, wb: v.wb, pid: v.pid, sec: age(v.t0), log: v.log })),
    claudes: [...claudes.values()].map(v => ({ screen: v.screen, wb: v.wb, label: v.label, source: v.source, pid: v.pid, sec: age(v.t0) })),
    waits: [...waits.values()].filter(v => pidAlive(v.pid)).map(v => ({ kind: v.kind, screen: v.screen, why: v.why, sec: age(v.t0), max_sec: v.max_sec, blocker_pid: v.blocker_pid })),
    jobs: [...jobs.entries()].map(([id, j]) => ({ job: id, label: j.label, total: j.total, done: j.done, running: j.running, sec: age(j.t0) })),
    locks: root ? locks() : [],
    load: load(),
  };
}

/** 사건 구독(VM 안팎 전부). 반환 = 해제 함수 */
function on(fn) { listeners.add(fn); return () => listeners.delete(fn); }
function recentEvents(n) { return recent.slice(-(n || 50)); }

function init(p) {
  if (started || !p || !p.root) return;
  started = true; root = p.root; vibeDir = p.vibeDir || path.join(p.root, '.vibe');
  if (orchEv) { orchEv.init(vibeDir); orchEv.on(apply); try { tailPos = fs.statSync(orchEv.file()).size; } catch { tailPos = 0; } }
  sampleCpu();
  tailTimer = setInterval(() => { tailTick(); sampleCpu(); sampleTcp(); }, 2000);
}
function dispose() { if (tailTimer) { clearInterval(tailTimer); tailTimer = null; } started = false; }

module.exports = { init, dispose, snapshot, on, sweep, recentEvents, locks, load, apply, pidAlive };
