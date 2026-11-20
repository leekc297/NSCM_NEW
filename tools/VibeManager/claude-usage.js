// claude-usage.js — AI 사용 한도(주간 등) 최근 값 읽기(2026-11-20 사용자 지시 'VMO OVERVIEW 의 부하 보드에 클로드 주간한도 사용량 표기 추가')
//   원천: VM 이 띄운 AI 실행 기록 .vibe/logs/*claude*.log(stream-json). CLI 가 응답마다 rate_limit_event 줄을 쓴다.
//     { type: 'rate_limit_event', rate_limit_info: { status, resetsAt(초), rateLimitType('seven_day' 등), unifiedWindows: { seven_day: { utilization(0~1), resetsAt, status } } } }
//   최근 기록 파일부터 끝부분을 읽어 마지막 줄을 찾는다. 기준 시각 = 그 기록 파일의 마지막 수정 시각(VM 밖에서 쓴 양은 다음 VM 호출 때 반영)
'use strict';
const fs = require('fs'); const path = require('path');
const TAIL = 512 * 1024; const MAX_FILES = 12; const KEY = '"type":"rate_limit_event"';
let cache = null; let cacheKey = ''; let cacheMs = 0;

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

/** 최근 한도 값. 반환 { weekly: { pct, resetsAt(ms), status }, windows: [{ type, pct, resetsAt, status }], status, overage, at(기준 시각 ms), file } 또는 null(기록 없음) */
function read(vibeDir) {
  const dir = path.join(vibeDir, 'logs'); let files = [];
  try { files = fs.readdirSync(dir).filter(n => /claude/i.test(n) && /\.log$/i.test(n)).map(n => { const f = path.join(dir, n); try { const s = fs.statSync(f); return { n, f, mt: s.mtimeMs, size: s.size }; } catch { return null; } }).filter(Boolean); } catch { return null; }
  files.sort((a, b) => b.mt - a.mt); files = files.slice(0, MAX_FILES);
  const key = files.map(x => `${x.n}|${x.mt}|${x.size}`).join(',');
  if (key === cacheKey && Date.now() - cacheMs < 30000) return cache;
  let out = null;
  for (const x of files) {
    const info = lastEvent(x.f, x.size); if (!info) continue;
    const uw = info.unifiedWindows || {}; const windows = Object.keys(uw).map(k => winOf(k, uw[k]));
    if (!windows.length && info.rateLimitType) windows.push({ type: info.rateLimitType, pct: typeof info.utilization === 'number' ? Math.round(info.utilization * 100) : null, resetsAt: info.resetsAt ? info.resetsAt * 1000 : 0, status: info.status || '' });
    const weekly = windows.find(w => w.type === 'seven_day') || null;
    out = { weekly, windows, status: info.status || '', overage: info.isUsingOverage === true, at: Math.round(x.mt), file: x.n };
    break;
  }
  cache = out; cacheKey = key; cacheMs = Date.now(); return out;
}
module.exports = { read, lastEvent };
