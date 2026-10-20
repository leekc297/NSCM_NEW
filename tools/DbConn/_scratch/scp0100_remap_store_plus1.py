"""SCP0100 __asis-mapping__.md — Store import 1행 추가(L18)로 Store:N(N>=19) 전부 +1. D00-2-019 는 별도 재기입."""
import re, sys
p = sys.argv[1]
changed = 0
lines = open(p, encoding='utf-8', newline='').read().split('\n')
out = []
for line in lines:
    m = re.match(r'^\|\s*(D00-\d-\d{3})\s*\|', line)
    if m and m.group(1) != 'D00-2-019':
        def rep(mm):
            global changed
            changed += 1
            return 'Store:' + re.sub(r'\d+', lambda d: str(int(d.group(0)) + (1 if int(d.group(0)) >= 19 else 0)), mm.group(1))
        line = re.sub(r'Store:([0-9][0-9,\-]*)', rep, line)
    out.append(line)
open(p, 'w', encoding='utf-8', newline='').write('\n'.join(out))
print('remapped refs:', changed)
