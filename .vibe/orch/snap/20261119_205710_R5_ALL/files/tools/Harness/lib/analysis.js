'use strict';
// Doc/_analysis/domain_*/screens/<ID>_*/validation.md · expressions.md 표 파서 (gen.js / check.js 공용)
const fs = require('fs'); const path = require('path');
function load(root, ID, kind) {
  const rows = []; if (!root || !fs.existsSync(root)) return rows;
  for (const dom of fs.readdirSync(root).filter(d => d.startsWith('domain_'))) {
    const sdirs = path.join(root, dom, 'screens'); if (!fs.existsSync(sdirs)) continue;
    for (const d of fs.readdirSync(sdirs).filter(d => d.startsWith(ID + '_'))) {
      const f = path.join(sdirs, d, kind === 'V' ? 'validation.md' : 'expressions.md'); if (!fs.existsSync(f)) continue;
      const popup = /_POPUP_/.test(d); let handler = '', inSummary = false;
      for (const line of fs.readFileSync(f, 'utf8').split(/\r?\n/)) {
        if (/^## /.test(line)) inSummary = /전체|요약|카테고리|Kind별/.test(line) && !/상세/.test(line);
        const h = line.match(/^###\s+`?([A-Za-z0-9_]+)`?/); if (h) { handler = h[1]; continue; }
        if (inSummary && kind === 'V') continue; // 요약표·전체목록(중복) 건너뜀 — 핸들러별 상세표만
        const m = line.match(/^\|\s*(\d+)\s*\|(.*)\|\s*$/); if (!m) continue;
        const c = m[2].split('|').map(x => x.trim().replace(/^`|`$/g, ''));
        if (kind === 'V') rows.push({ no: Number(m[1]), kind: c[0], category: c[1], msg: c[2], msgText: c[3], column: c[4], cond: c[5], action: c[6], line: c[7], handler, popup, src: d });
        else rows.push({ no: Number(m[1]), kind: c[0], category: c[1], sub: c[2], target: c[3], code: c[4], line: c[5], popup, src: d });
      }
    }
  }
  const seen = new Set(); return rows.filter(r => { const k = r.src + '#' + r.no; if (seen.has(k)) return false; seen.add(k); return true; });
}
module.exports = { load };
