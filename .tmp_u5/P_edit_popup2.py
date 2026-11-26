import sys
p = sys.argv[1]
s = open(p, encoding='utf-8', newline='').read()
rep = [
 ("        # T568(2026-11-25 SCP0005 G4·B3 6행): 같은 조건으로 같은 팝업을 여는 칸 전부(trigger.columns) — 종전 칸(마지막)을 먼저 둬 호출 순서 유지\r\n        cols_ = tr.pop('columns', []) or []\r\n        for tr in [tr] + [dict(tr, column=c_) for c_ in cols_ if c_ != tr.get('column')]:\r\n",
  "        # T568(2026-11-25 SCP0005 G4·B3 6행): 같은 조건으로 같은 팝업을 여는 칸 전부(trigger.columns). 종전 칸은 그 자리, 더한 칸은 호출 목록 끝(extra)에 둔다\r\n        #   (E2E 행 ID = 호출 번호 + 트리거 · 종전 호출 번호를 바꾸지 않는다)\r\n        cols_ = tr.pop('columns', []) or []\r\n        for n_, tr in enumerate([tr] + [dict(tr, column=c_) for c_ in cols_ if c_ != tr.get('column')]):\r\n"),
 ("            calls.append({'cls': p['popup'], 'method': p['method'], 'asis_ref': f\"{p['file']}:{p['line']}\", 'trigger': tr,\r\n",
  "            (extra if n_ else calls).append({'cls': p['popup'], 'method': p['method'], 'asis_ref': f\"{p['file']}:{p['line']}\", 'trigger': tr,\r\n"),
 ("    calls = []\r\n    seen = set()\r\n", "    calls = []\r\n    extra = []  # T568\r\n    seen = set()\r\n"),
 ("    os.makedirs(OUT, exist_ok=True)\r\n    j = {'screen': aid, 'calls': calls, 'classes': classes}\r\n",
  "    calls.extend(extra)\r\n    os.makedirs(OUT, exist_ok=True)\r\n    j = {'screen': aid, 'calls': calls, 'classes': classes}\r\n"),
]
for a, b in rep:
    assert s.count(a) == 1, a[:60]
    s = s.replace(a, b)
open(p, 'w', encoding='utf-8', newline='').write(s)
print('ok')
