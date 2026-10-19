# -*- coding: utf-8 -*-
"""_corp_R04_out.txt(사내 R04 실행 결과) 의 division 별 2회차 → R04 load_corp 블록 재생성."""
import re, pathlib
out = pathlib.Path("_corp_R04_out.txt").read_text(encoding="utf-8").splitlines()
div = run = None; lines = []; heads = []; seen = set()
for ln in out:
    m = re.match(r"### div=(\d+) run(\d+)\s+\(A\) SP ([\d.]+)s\s+\+ 커서 fetch ([\d.]+)s\s+= DB 합 ([\d.]+)s\s+rows\[RC1..5,RESULT\]=(\S+)", ln)
    if m:
        div, run = m.group(1), int(m.group(2))
        if run == 2:
            heads.append(f"        ca('{div}') := 'SP {m.group(3)}s + fetch {m.group(4)}s = {m.group(5)}s  rows={m.group(6)}';")
        continue
    if run != 2:
        continue
    m = re.match(r"\s+(\d+|-)\s+\S+\s+([\d.]+)\s+[\d.]+\s+\d+\s+(\d+)\s+\d+\s+\d+\s+\d+\s+(\w{13})/\d+\s+(\d+)", ln)
    if m and (div, m.group(4)) not in seen:
        seen.add((div, m.group(4)))
        lines.append(f"        c('{div}:{m.group(4)}', {m.group(2)}, {m.group(3)}, {m.group(5)});")
p = pathlib.Path("R04_SP_STAGE_PROFILE.sql"); s = p.read_text(encoding="utf-8")
a = s.index("-- <<CORP_BASELINE>>"); a = s.index("\n", a) + 1
b = s.index("        -- <</CORP_BASELINE>>")
s = s[:a] + "\n".join(heads + lines) + "\n" + s[b:]
p.write_text(s, encoding="utf-8")
print(len(heads), "div heads,", len(lines), "sql baselines")
