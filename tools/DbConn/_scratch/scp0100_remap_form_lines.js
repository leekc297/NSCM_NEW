// SCP0100 __asis-mapping__.md — 2026-10-20 round2 Form 삽입(+3 import / +2 selector / +20 seedCalendar)으로 밀린 'Form:N' 참조 재계산.
// 대상: 이번 라운드에 새로 쓴 행(D00-1-006·011 / D00-2-001·005·007·019 / D00-4-004)을 제외한 D00-* 행.
const fs = require('fs');
const p = process.argv[2];
const SKIP = new Set(['D00-1-006', 'D00-1-011', 'D00-2-001', 'D00-2-005', 'D00-2-007', 'D00-2-019', 'D00-4-004']);
const shift = n => (n <= 22 ? n : n <= 85 ? n + 3 : n <= 185 ? n + 5 : n + 25);
let changed = 0;
const out = fs.readFileSync(p, 'utf8').split(/\r?\n/).map(line => {
  const m = line.match(/^\|\s*(D00-\d-\d{3})\s*\|/);
  if (!m || SKIP.has(m[1])) return line;
  // 'Form:a-b,c' 또는 'Form:a' — 쉼표 뒤 숫자 목록까지 같은 파일 참조로 본다.
  return line.replace(/Form:([0-9][0-9,\-]*)/g, (_, nums) => {
    changed++;
    return 'Form:' + nums.replace(/\d+/g, d => String(shift(Number(d))));
  });
});
fs.writeFileSync(p, out.join('\n'));
console.log('remapped refs:', changed);
