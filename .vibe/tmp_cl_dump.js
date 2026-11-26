// 임시: CHANGELOG.md 에서 workbench.js 가 files 에 든 절 분류 시안
const path = require('path'); const fs = require('fs'); const root = 'C:/Projects/NSCM';
const H = require(path.join(root, 'tools/VibeManager/orch-history'));
const text = fs.readFileSync(path.join(root, 'tools/VibeManager/CHANGELOG.md'), 'utf8');
const lines = text.split(/\r?\n/);
const secs = H.parseChangelog(text).filter(s => s.files.some(f => path.basename(f) === 'workbench.js'));
const out = []; const n = {};
for (const s of secs) {
  const ln = s.sources[0].line; let end = ln; while (end < lines.length && !/^## /.test(lines[end])) end++;
  const head = lines[ln - 1]; const body = lines.slice(ln, end);
  const sig = [];
  if (/S11/.test(body.join('\n'))) sig.push('S11'); if (/고정 문구|문구/.test(head)) sig.push('H문구');
  if (body.some(l => /^\s*- 원인/.test(l))) sig.push('원인줄'); if (/원인/.test(body.join('\n'))) sig.push('원인');
  if (/결함/.test(head + body.join('\n'))) sig.push('결함'); if (/오판/.test(head + body.join('\n'))) sig.push('오판');
  if (/사건/.test(head)) sig.push('H사건'); if (/중지|종료|재개/.test(head)) sig.push('H중지');
  if (/\d{14}_(?:INC|SELF)/.test(body.join('\n'))) sig.push('INC/SELF'); if (/\d{14}_REVIEW/.test(body.join('\n'))) sig.push('REVIEW');
  if (body.some(l => /^\s*- 사용자/.test(l))) sig.push('사용자');
  const k = s.changeKind || '-'; n[k] = (n[k] || 0) + 1;
  out.push(`L${ln}\t${k}\t${sig.join(',')}\t${head.slice(3, 130)}`);
}
fs.writeFileSync(path.join(root, '.vibe/tmp_cl_dump.txt'), `절 ${secs.length} ${JSON.stringify(n)}\n` + out.join('\n'), 'utf8');
console.log('절', secs.length, JSON.stringify(n));
