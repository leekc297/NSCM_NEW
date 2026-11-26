import sys
p = sys.argv[1]
s = open(p, encoding='utf-8', newline='').read()
nl = '\r\n'
lines = s.split(nl)
i0 = next(i for i, l in enumerate(lines) if l.startswith("        ckey = (p['popup'], tr['kind'], tr.get('control'), tr.get('column'), p['method'])"))
i1 = next(i for i, l in enumerate(lines) if l.startswith("        if p['popup'] not in classes:"))
block = lines[i0:i1]
new = ["        # T568(2026-11-25 SCP0005 G4·B3 6행): 같은 조건으로 같은 팝업을 여는 칸 전부(trigger.columns) — 종전 칸(마지막)을 먼저 둬 호출 순서 유지",
       "        cols_ = tr.pop('columns', []) or []",
       "        for tr in [tr] + [dict(tr, column=c_) for c_ in cols_ if c_ != tr.get('column')]:"]
for l in block:
    l2 = l.replace('            continue', '                continue') if l.strip() == 'continue' else l
    new.append(('    ' + l2) if l2.strip() else l2)
lines[i0:i1] = new
open(p, 'w', encoding='utf-8', newline='').write(nl.join(lines))
print('ok', i0, i1)
