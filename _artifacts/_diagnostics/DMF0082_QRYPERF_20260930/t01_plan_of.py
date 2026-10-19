# -*- coding: utf-8 -*-
"""10046 트레이스(p03_div*.trc.txt)에서 지정 sqlid 의 실제 실행계획(STAT 행) + 대기 합계를 출력.
사용: python t01_plan_of.py <trace.txt> <sqlid> [sqlid ...]
"""
import io, re, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
L = open(sys.argv[1], encoding="utf-8").read().split("\n")
for sid in sys.argv[2:]:
    curs = set()
    for ln in L:
        m = re.match(r"PARSING IN CURSOR #(\d+) .*sqlid='" + sid + "'", ln)
        if m:
            curs.add(m.group(1))
    print(f"===== {sid} cursors={len(curs)}")
    last_cur = None
    for ln in L:
        m = re.match(r"STAT #(\d+) id=(\d+) cnt=(\d+) pid=(\d+) pos=\d+ obj=\d+ op='(.*)'", ln)
        if m and m.group(1) in curs:
            print(f"{m.group(2):>3} p{m.group(4):>3} rows={m.group(3):>10} {m.group(5)[:170]}")
    w = {}
    for ln in L:
        m = re.match(r"WAIT #(\d+): nam='([^']+)' ela=\s*(\d+)", ln)
        if m and m.group(1) in curs:
            w[m.group(2)] = w.get(m.group(2), 0) + int(m.group(3))
    print({k: round(v / 1e6, 3) for k, v in w.items()})
