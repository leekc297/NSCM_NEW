"""SCP0100 __asis-mapping__.md — 2026-10-20 round2 Form 삽입(+3 import / +2 selector / +20 seedCalendar)으로 밀린 'Form:N' 참조 재계산.
대상: 이번 라운드에 새로 쓴 행(D00-1-006·011 / D00-2-001·005·007·019 / D00-4-004)을 제외한 D00-* 행."""
import re, sys
p = sys.argv[1]
SKIP = {'D00-1-006', 'D00-1-011', 'D00-2-001', 'D00-2-005', 'D00-2-007', 'D00-2-019', 'D00-4-004'}

def shift(n):
    return n if n <= 22 else n + 3 if n <= 85 else n + 5 if n <= 185 else n + 25

changed = 0
lines = open(p, encoding='utf-8', newline='').read().split('\n')
out = []
for line in lines:
    m = re.match(r'^\|\s*(D00-\d-\d{3})\s*\|', line)
    if m and m.group(1) not in SKIP:
        def rep(mm):
            global changed
            changed += 1
            return 'Form:' + re.sub(r'\d+', lambda d: str(shift(int(d.group(0)))), mm.group(1))
        line = re.sub(r'Form:([0-9][0-9,\-]*)', rep, line)
    out.append(line)
open(p, 'w', encoding='utf-8', newline='').write('\n'.join(out))
print('remapped refs:', changed)
