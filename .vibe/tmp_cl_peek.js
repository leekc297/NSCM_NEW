// 임시: 지정 절의 원인 줄, INC/SELF 언급 줄, 사용자 줄 앞부분
const fs = require('fs'); const lines = fs.readFileSync('C:/Projects/NSCM/tools/VibeManager/CHANGELOG.md', 'utf8').split(/\r?\n/);
const want = process.argv.slice(2).map(Number); const out = [];
for (const s of want) {
  let e = s; while (e < lines.length && !/^## /.test(lines[e])) e++;
  const body = lines.slice(s, e);
  const u = body.find(l => /^\s*- 사용자/.test(l)) || ''; const c = body.find(l => /원인/.test(l)) || ''; const p = body.find(l => /\d{14}_(?:INC|SELF)/.test(l)) || ''; const d = body.find(l => /결함|오판/.test(l)) || '';
  out.push(`L${s}\n U ${u.slice(0, 170)}\n C ${c.slice(0, 170)}\n P ${p.slice(0, 170)}\n D ${d.slice(0, 170)}`);
}
fs.writeFileSync('C:/Projects/NSCM/.vibe/tmp_cl_peek.txt', out.join('\n'), 'utf8');
