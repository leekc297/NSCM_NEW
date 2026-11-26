const fs = require('fs');
const lines = fs.readFileSync('GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs', 'utf8').split(/\r?\n/);
function writes(col) {
  const ws = []; const idxRe = new RegExp(`\\b(\\w+)\\s*=\\s*[\\w.]*GetColumnIndex\\(\\s*DefColumns\\.${col}\\s*\\)`); const vars = new Set();
  for (const l of lines) { const m = idxRe.exec(l); if (m) vars.add(m[1]); }
  const ref = `(?:DefColumns\\.${col}\\b${[...vars].map(v => `|\\b${v}\\b`).join('')})`;
  const wr = [new RegExp(`\\[\\s*DefColumns\\.${col}\\s*\\]\\s*=(?!=)`), new RegExp(`\\b(?:SetValue|SetText|SetCellTypeCombo\\w*|SetComboBox\\w*)\\s*\\([^;]*${ref}`), new RegExp(`Cells\\s*\\[[^\\]]*${ref}[^\\]]*\\]\\s*\\.\\s*(?:Value|Text)\\s*=(?!=)`)];
  lines.forEach((l, i) => { if (l.trim().startsWith('//')) return; if (wr.some(r => r.test(l))) ws.push(i + 1); });
  return [[...vars], ws];
}
for (const c of ['PRIORITY', 'VALID_YN', 'FROM_COUNTRY', 'LT_SUM', 'DAYS_MON']) console.log(c, JSON.stringify(writes(c)));
function sumGuard(meth, msg) {
  const ms = lines.findIndex(l => new RegExp(`^\\s*(?:(?:private|public|protected|internal|static|override|virtual|async)\\s+)*[\\w<>\\[\\],.]+\\s+${meth}\\s*\\(`).test(l) && !/;\s*$/.test(l)); if (ms < 0) return 'nometh';
  const ml = lines.findIndex((l, i) => i > ms && l.includes(`"${msg}"`)); if (ml < 0) return 'nomsg';
  let gv = '', n = 0, gl = -1;
  for (let i = ml; i >= Math.max(ms, ml - 12); i--) { const m = /if\s*\(\s*(?:(?:Int64|Int32|Decimal|Double|long|int)\.Parse|Convert\.To\w+)\(\s*(\w+)\s*\)\s*>\s*(\d+)\s*\)/.exec(lines[i]); if (m) { gv = m[1]; n = Number(m[2]); gl = i; break; } }
  if (!gv) return 'noguard';
  let terms = [];
  for (let i = gl - 1; i > ms; i--) { const m = new RegExp(`\\b${gv}\\s*=\\s*([^;]*)`).exec(lines[i]); if (m && /Parse\(|Convert\.To/.test(m[1])) { terms = [...m[1].matchAll(/(?:Parse|Convert\.To\w+)\(\s*(\w+)\s*\)/g)].map(z => z[1]); break; } }
  if (!terms.length) terms = [gv];
  const cols = [];
  for (const t of terms) for (let i = ms; i < gl; i++) { const m = new RegExp(`\\b${t}\\s*=\\s*[^;=]*DefColumns\\.(\\w+)`).exec(lines[i]); if (m) { if (!cols.includes(m[1])) cols.push(m[1]); break; } }
  return { cols, n, ref: ml + 1 };
}
console.log(JSON.stringify(sumGuard('spdMainDataModel_Changed', 'MSG00209')));
