// VMO 진단용 임시 스크립트(읽기만 함): 21:42 반영 실행 기록에서 쓰기로 판정된 셸 명령과 대상 파일 차이 확인
'use strict';
const fs = require('fs'); const path = require('path');
const root = process.argv[2];
const u = require(path.join(root, 'tools/VibeManager/orch-undo.js'));
const r = u.readOps(root, '.vibe/logs/2026-11-23T21-42-29_claude_orch.log');
for (const c of r.shells) {
  if (!/orch-selfcheck\.js|orch-improve\.js|t_orch_improve\.js/i.test(c)) continue;
  const m = c.match(u.SHELL_WRITE);
  if (m) console.log('WRITE?', JSON.stringify(m[0]), '@', m.index, '|', c.slice(0, 300).replace(/\n/g, ' / '));
}
console.log('ops', [...new Set(r.ops.map(o => o.file + ':' + o.kind))].join(', '));
for (const f of ['orch-selfcheck.js', 'orch-improve.js', 'test/t_orch_improve.js']) {
  const cur = fs.readFileSync(path.join(root, 'tools/VibeManager', f), 'utf8');
  let bak = null; try { bak = fs.readFileSync(path.join(root, 'tools/VibeManager', f + '.bak_20261123_self2138'), 'utf8'); } catch { }
  if (bak === null) { console.log(f, 'bak 없음'); continue; }
  const a = bak.split('\n'), b = cur.split('\n');
  const sa = new Set(a), sb = new Set(b);
  const add = b.filter(x => !sa.has(x)), del = a.filter(x => !sb.has(x));
  console.log(`== ${f} same=${cur === bak} 추가줄 ${add.length} 삭제줄 ${del.length}`);
  for (const x of add.slice(0, 6)) console.log('  +', x.slice(0, 200));
  for (const x of del.slice(0, 6)) console.log('  -', x.slice(0, 200));
}
