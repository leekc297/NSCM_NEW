// AS-IS facts variant 판정 — tools/Harness/verify/asis_variant.py 와 같은 규칙(2026-11-09 SSP0024·SSP0025 CheckList exit 6 · 검사기 결함 T172)
//   only = 화면 전용 csproj 가 없는 화면의 현행 소스(445 중 180 · SSP 전 화면). 'current' 정확 일치로 읽으면 파일 0건.
//   화면 본체(mainFiles) = current 가 있으면 current · 없으면 팝업 아닌 only · 그것도 없으면(화면 자체가 팝업) only 전부
const fs = require('fs');
const path = require('path');
const POPUP_RX = /(^|[\\/])popups?[\\/]|popup[^\\/]*$/i;
const cache = new Map();
const v = r => String((r && r.variant) || 'current').trim() || 'current';
const readFiles = sdir => {
  const p = path.join(sdir, 'files.csv'); if (!fs.existsSync(p)) return null;
  const lines = fs.readFileSync(p, 'utf8').replace(/^﻿/, '').split(/\r?\n/).filter(Boolean);
  const cells = l => (l.match(/("([^"]|"")*"|[^,]*)(,|$)/g) || []).map(x => x.replace(/,$/, '').replace(/^"|"$/g, '').replace(/""/g, '"'));
  const h = cells(lines[0]); return lines.slice(1).map(l => { const c = cells(l); const o = {}; h.forEach((k, i) => { o[k] = c[i] || ''; }); return o; });
};
function mainFiles(sdir) {
  const k = path.resolve(sdir).toLowerCase(); if (cache.has(k)) return cache.get(k);
  const rows = readFiles(sdir); let out = null;
  if (rows) { out = new Set(rows.filter(r => v(r) === 'current').map(r => r.file)); if (!out.size) { const only = rows.filter(r => v(r) === 'only').map(r => r.file); const np = only.filter(f => !POPUP_RX.test(f)); out = new Set(np.length ? np : only); } }
  cache.set(k, out); return out;
}
const isCur = r => v(r) !== 'legacy';
function isMain(r, sdir) {
  const x = v(r); if (x === 'legacy' || x === 'shared') return false;
  if (sdir) { const mf = mainFiles(sdir); if (mf) return x === 'current' || mf.has(String((r && r.file) || '')); }
  return x === 'current' || (x === 'only' && !POPUP_RX.test(String((r && r.file) || '')));
}
module.exports = { isCur, isMain, mainFiles, POPUP_RX };
