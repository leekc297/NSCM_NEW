# -*- coding: utf-8 -*-
"""AS-IS phase1_db.json 에서 PR_SSP_ANL_ESS_REQ 호출자 SP 추출 (읽기 전용)"""
import sys, io, json
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

P = r"C:\Projects\NSCM\_analysis\_scan\phase1_db.json"
data = json.load(open(P, encoding='utf-8'))
print("top-level type:", type(data).__name__)
if isinstance(data, dict):
    print("keys:", list(data.keys())[:20])

def iter_sps(d):
    if isinstance(d, dict):
        # 후보: sps / procedures / list
        for k, v in d.items():
            if isinstance(v, list) and v and isinstance(v[0], dict) and ('sps_called' in v[0] or 'name' in v[0]):
                print("  -> list key:", k, "len", len(v), "sample keys:", list(v[0].keys()))
                for it in v:
                    yield it
            elif isinstance(v, (dict, list)):
                for it in iter_sps(v):
                    yield it
    elif isinstance(d, list):
        for v in d:
            for it in iter_sps(v):
                yield it

TARGETS = ('PR_SSP_ANL_ESS_REQ', 'PR_SSP_ANL_ESS_REQ_NET')
found = []
allsp = list(iter_sps(data))
print("scanned sp entries:", len(allsp))
for sp in allsp:
    called = sp.get('sps_called') or []
    if isinstance(called, str):
        called = [called]
    up = [str(c).upper() for c in called]
    for t in TARGETS:
        if any(t == c or t in c for c in up):
            found.append((sp.get('name') or sp.get('sp_name') or sp.get('object_name'),
                          sp.get('file') or sp.get('path') or '', t, sorted(set(up))))
print()
print("=" * 100)
print("### PR_SSP_ANL_ESS_REQ* 를 sps_called 에 가진 AS-IS SP")
print("=" * 100)
seen = set()
for nm, f, t, up in found:
    key = (nm, t)
    if key in seen: continue
    seen.add(key)
    print("CALLER: %-45s  target=%s" % (nm, t))
    print("        file=%s" % f)
print("(%d unique caller-target pairs)" % len(seen))

# 자기 자신 엔트리
print()
print("=" * 100)
print("### PR_SSP_ANL_ESS_REQ 자체 엔트리")
print("=" * 100)
for sp in allsp:
    nm = str(sp.get('name') or sp.get('sp_name') or '')
    if nm.upper() in TARGETS:
        print(nm, "keys:", list(sp.keys()))
        print("  sps_called:", sp.get('sps_called'))
        print("  tables:", (sp.get('tables') or sp.get('tables_used'))if isinstance(sp.get('tables') or sp.get('tables_used'), list) else '')
