// claude-usage.js — AI 사용 한도(주간 등) 최근 값 읽기(2026-11-20 사용자 지시 'VMO OVERVIEW 의 부하 보드에 클로드 주간한도 사용량 표기 추가')
//   원천: VM 이 띄운 AI 실행 기록 .vibe/logs/*claude*.log(stream-json). CLI 가 응답마다 rate_limit_event 줄을 쓴다.
//     { type: 'rate_limit_event', rate_limit_info: { status, resetsAt(초), rateLimitType('seven_day' 등), unifiedWindows: { seven_day: { utilization(0~1), resetsAt, status } } } }
//   최근 기록 파일부터 끝부분을 읽어 마지막 줄을 찾는다. 기준 시각 = 그 기록 파일의 마지막 수정 시각(VM 밖에서 쓴 양은 다음 VM 호출 때 반영)
//   2026-11-24 사용자 결정(B): 원천 = Claude 사용량 조회(Claude Code /usage 와 같은 주소, 토큰 소모 없음). 10분마다 조회(1분 주기는 HTTP 429 로 거절됨, 17:50 실측). 실패하면 10분 뒤 다시, 그동안 마지막 정상 조회 값을 계속 씀
//     인증 = Claude Code 로그인 정보(~/.claude/.credentials.json claudeAiOauth.accessToken). 토큰은 기록, 로그에 남기지 않음. 만료되면 조회하지 않음(Claude Code 가 쓸 때 갱신함)
//     조회 결과 = .vibe/orch/ai_usage.json(창 여러 개가 같이 씀, 55초 안이면 다시 조회하지 않음)
'use strict';
const fs = require('fs'); const path = require('path'); const os = require('os');
const API = { host: 'api.anthropic.com', path: '/api/oauth/usage' }; const OK_MS = 600000; const BACKOFF_MS = 600000; const FRESH_MS = 900000; // 2026-11-24 17:50 실측: 1분 주기 = HTTP 429(4번 중 3번) → 사용자 기준대로 10분 주기, 실패해도 10분 뒤. 15분 넘은 값 = stale 표시
let apiTimer = null; let apiNextMs = 0; let apiVibe = ''; let apiLast = null; let apiErr = '';
const TAIL = 512 * 1024; const MAX_FILES = 12; const KEY = '"type":"rate_limit_event"';
let cache = null; let cacheKey = ''; let cacheMs = 0;
const RELOAD_MS = 60000; // 2026-11-24 사용자: AI 주간 한도 1분 주기 다시 읽기(파일 12개 끝 512KB 읽기라 1분 주기 부담 작음)

/** 한 파일 끝부분에서 마지막 rate_limit_event 줄을 읽는다. 없으면 null */
function lastEvent(f, size) {
  let fd = null;
  try {
    fd = fs.openSync(f, 'r'); const n = Math.min(size, TAIL); const buf = Buffer.alloc(n); fs.readSync(fd, buf, 0, n, size - n);
    const t = buf.toString('utf8'); let i = t.lastIndexOf(KEY);
    while (i >= 0) {
      const a = t.lastIndexOf('\n', i) + 1; let b = t.indexOf('\n', i); if (b < 0) b = t.length;
      try { const j = JSON.parse(t.slice(a, b)); if (j && j.rate_limit_info) return j.rate_limit_info; } catch { /* 잘린 줄 = 앞 줄 */ }
      i = t.lastIndexOf(KEY, a - 1);
    }
  } catch { /* 읽기 실패 = 다음 파일 */ } finally { if (fd != null) try { fs.closeSync(fd); } catch { } }
  return null;
}
const winOf = (k, w) => ({ type: k, pct: w && typeof w.utilization === 'number' ? Math.round(w.utilization * 100) : null, resetsAt: w && w.resetsAt ? w.resetsAt * 1000 : 0, status: (w && w.status) || '' });

/** 사용량 조회 응답 → read() 와 같은 모양 */
function fromApi(d, at) {
  if (!d || typeof d !== 'object') return null;
  const ms = v => { const t = Date.parse(v || ''); return isNaN(t) ? 0 : t; };
  const windows = []; const sd = d.seven_day;
  if (sd && typeof sd.utilization === 'number') windows.push({ type: 'seven_day', pct: Math.round(sd.utilization), resetsAt: ms(sd.resets_at), status: 'allowed' });
  const fh = d.five_hour; if (fh && typeof fh.utilization === 'number') windows.push({ type: 'five_hour', pct: Math.round(fh.utilization), resetsAt: ms(fh.resets_at), status: 'allowed' });
  for (const l of Array.isArray(d.limits) ? d.limits : []) {
    if (l.kind === 'weekly_all' && windows[0] && windows[0].type === 'seven_day') { windows[0].status = l.severity === 'critical' && l.percent >= 100 ? 'rejected' : 'allowed'; continue; }
    const nm = l.scope && l.scope.model && l.scope.model.display_name; if (nm && typeof l.percent === 'number') windows.push({ type: `${nm} 주간`, pct: Math.round(l.percent), resetsAt: ms(l.resets_at), status: 'allowed' });
  }
  const weekly = windows.find(w => w.type === 'seven_day') || null; if (!weekly) return null;
  return { weekly, windows, status: weekly.status, overage: false, at, file: 'Claude 사용량 조회', source: 'api', checkedAt: at };
}
function cacheFile() { return path.join(apiVibe, 'orch', 'ai_usage.json'); }
// 2026-11-24 사용자: 조회 실패 원인 확인용 상태 기록(시도, 성공, 실패 사유, 다음 조회). 토큰은 남기지 않음
function stateFile() { return path.join(apiVibe, 'orch', 'ai_usage_state.json'); }
function noteState(o) { try { let st = {}; try { st = JSON.parse(fs.readFileSync(stateFile(), 'utf8')) || {}; } catch { } Object.assign(st, o, { pid: process.pid }); if (o.err) { st.fails = (st.fails || []).concat([{ at: o.lastTry || Date.now(), err: o.err }]).slice(-20); } fs.mkdirSync(path.dirname(stateFile()), { recursive: true }); fs.writeFileSync(stateFile(), JSON.stringify(st)); } catch { } }
function token() {
  try { const c = JSON.parse(fs.readFileSync(path.join(os.homedir(), '.claude', '.credentials.json'), 'utf8')); const o = c && c.claudeAiOauth; if (!o || !o.accessToken) return { why: '로그인 정보 없음' }; if (o.expiresAt && o.expiresAt < Date.now()) return { why: '로그인 토큰 만료(Claude Code 를 쓰면 갱신)' }; return { t: o.accessToken }; } catch { return { why: '로그인 정보 읽기 실패' }; }
}
/** 1번 조회. 결과 = { ok, why }. 성공하면 ai_usage.json 과 메모리에 둠 */
function fetchOnce(done) {
  const t0 = Date.now(); const tk = token(); if (!tk.t) { apiErr = tk.why; noteState({ lastTry: t0, err: tk.why }); return done({ ok: false, why: tk.why }); }
  let fin = false; const end = r => { if (!fin) { fin = true; noteState(r.ok ? { lastTry: t0, lastOk: Date.now(), err: '' } : { lastTry: t0, err: r.why }); done(r); } };
  try {
    const req = require('https').request({ host: API.host, path: API.path, method: 'GET', timeout: 15000, headers: { Authorization: 'Bearer ' + tk.t, 'anthropic-beta': 'oauth-2025-04-20', 'Content-Type': 'application/json', 'User-Agent': 'vibe-manager' } }, res => {
      let b = ''; res.setEncoding('utf8'); res.on('data', c => { b += c; if (b.length > 2e6) req.destroy(); });
      res.on('end', () => {
        if (res.statusCode !== 200) { apiErr = `사용량 조회 HTTP ${res.statusCode}` + (res.headers['retry-after'] ? ` (retry-after ${res.headers['retry-after']}초)` : ''); return end({ ok: false, why: apiErr, retryAfter: Number(res.headers['retry-after']) || 0 }); }
        let d = null; try { d = JSON.parse(b); } catch { apiErr = '사용량 조회 응답 해석 실패'; return end({ ok: false, why: apiErr }); }
        const v = fromApi(d, Date.now()); if (!v) { apiErr = '사용량 조회 응답에 주간 값 없음'; return end({ ok: false, why: apiErr }); }
        apiLast = v; apiErr = ''; try { fs.mkdirSync(path.dirname(cacheFile()), { recursive: true }); fs.writeFileSync(cacheFile(), JSON.stringify(v)); } catch { }
        end({ ok: true });
      });
    });
    req.on('timeout', () => { apiErr = '사용량 조회 시간 초과(15초)'; req.destroy(); end({ ok: false, why: apiErr }); }); req.on('error', e => { apiErr = '사용량 조회 실패: ' + String(e && e.code || e && e.message || e).slice(0, 80); end({ ok: false, why: apiErr }); });
    req.end();
  } catch (e) { apiErr = '사용량 조회 실패: ' + String(e && e.message || e).slice(0, 80); end({ ok: false, why: apiErr }); }
}
/** 10분 주기 조회 시작(VMO 상태 모듈이 부름). 다른 창이 10분 안에 조회했으면 그 값을 씀. 실패하면 다음 조회 = 10분 뒤 */
function tick() {
  try { tick0(); } catch (e) { apiErr = '사용량 조회 타이머 오류: ' + String(e && e.message || e).slice(0, 80); noteState({ lastTry: Date.now(), err: apiErr }); apiNextMs = Date.now() + BACKOFF_MS; }
}
function tick0() {
  if (Date.now() < apiNextMs) return;
  try { const v = JSON.parse(fs.readFileSync(cacheFile(), 'utf8')); if (v && v.checkedAt && Date.now() - v.checkedAt < OK_MS - 5000) { apiLast = v; apiNextMs = v.checkedAt + OK_MS; return; } } catch { }
  apiNextMs = Date.now() + OK_MS; fetchOnce(r => { if (!r.ok) apiNextMs = Date.now() + Math.max(BACKOFF_MS, (r.retryAfter || 0) * 1000); noteState({ nextMs: apiNextMs }); });
}
function start(vibeDir, opts) { apiVibe = vibeDir; if (apiTimer) return; if (opts && opts.timer === false) return;
  if (process.env.VM_NO_USAGE_API === '1' || path.resolve(vibeDir || '').toLowerCase().startsWith(path.resolve(os.tmpdir()).toLowerCase())) return;
  /* 시험(임시 폴더)에서는 실제 조회 안 함 */
  tick(); apiTimer = setInterval(tick, 10000); if (apiTimer.unref) apiTimer.unref(); }
function stop() { if (apiTimer) { clearInterval(apiTimer); apiTimer = null; } }
function apiState() { return { last: apiLast, err: apiErr, nextMs: apiNextMs }; }

/** 최근 한도 값. 반환 { weekly: { pct, resetsAt(ms), status }, windows: [{ type, pct, resetsAt, status }], status, overage, at(기준 시각 ms), file } 또는 null(기록 없음) */
function read(vibeDir) {
  if (!apiVibe && vibeDir) apiVibe = vibeDir;
  // 2026-11-24 사용자: 최신 조회를 못 하면 가장 최근의 정상 조회 값을 계속 보여 줌(3분 지나도 실행 기록으로 돌아가지 않음). 실행 기록이 더 새로우면 그 값
  let api = null; if (vibeDir) { try { api = JSON.parse(fs.readFileSync(path.join(vibeDir, 'orch', 'ai_usage.json'), 'utf8')); } catch { api = null; } }
  if (apiLast && (!api || (apiLast.checkedAt || 0) > (api.checkedAt || 0))) api = apiLast;
  const logs = readLogs(vibeDir);
  if (api && api.checkedAt && (Date.now() - api.checkedAt < FRESH_MS || !(logs && logs.at > api.checkedAt))) return Object.assign({}, api, { apiErr: apiErr || '', stale: Date.now() - api.checkedAt >= FRESH_MS });
  return logs;
}
function readLogs(vibeDir) {
  const dir = path.join(vibeDir, 'logs'); let files = [];
  try { files = fs.readdirSync(dir).filter(n => /claude/i.test(n) && /\.log$/i.test(n)).map(n => { const f = path.join(dir, n); try { const s = fs.statSync(f); return { n, f, mt: s.mtimeMs, size: s.size }; } catch { return null; } }).filter(Boolean); } catch { return null; }
  files.sort((a, b) => b.mt - a.mt); files = files.slice(0, MAX_FILES);
  const key = files.map(x => `${x.n}|${x.mt}|${x.size}`).join(',');
  if (key === cacheKey && Date.now() - cacheMs < RELOAD_MS) return cache;
  let out = null;
  for (const x of files) {
    const info = lastEvent(x.f, x.size); if (!info) continue;
    const uw = info.unifiedWindows || {}; const windows = Object.keys(uw).map(k => winOf(k, uw[k]));
    if (!windows.length && info.rateLimitType) windows.push({ type: info.rateLimitType, pct: typeof info.utilization === 'number' ? Math.round(info.utilization * 100) : null, resetsAt: info.resetsAt ? info.resetsAt * 1000 : 0, status: info.status || '' });
    const weekly = windows.find(w => w.type === 'seven_day') || null;
    out = { weekly, windows, status: info.status || '', overage: info.isUsingOverage === true, at: Math.round(x.mt), file: x.n, checkedAt: Date.now() };
    break;
  }
  if (out && apiErr) out.apiErr = apiErr; // 사용량 조회 실패 사유(화면 표시)
  cache = out; cacheKey = key; cacheMs = Date.now(); return out;
}
module.exports = { read, lastEvent, RELOAD_MS, fromApi, start, stop, tick, fetchOnce, apiState, OK_MS, BACKOFF_MS, FRESH_MS };
