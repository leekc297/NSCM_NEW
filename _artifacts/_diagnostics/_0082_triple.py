#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 — "동일 정적항목 + 동일 메저가 3번" 원인 규명.

방법: 결과에서 **정적 컬럼 전체 + MEASURE** 로 그룹 지어 3중복 그룹을 찾고,
      그 그룹의 행들을 **컬럼 단위로 diff** 해 무엇이 다른지 실측한다.
      (추정 금지 — 어느 컬럼이 갈라지게 만드는지 값으로 확인)
"""
import io, sys, pathlib
from collections import Counter, defaultdict
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

A = 'ALL'
PARAMS = ['40', A, A, A, '20260801', '20270131', A, None,
          'Current', 'N', 'minyonglee1', 'ADMIN', A, A, A, A]

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
rcs = [con.cursor() for _ in range(5)]
rr = con.cursor()
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", PARAMS + rcs + [rr])
rcs[0].arraysize = 1000
cols = [c[0] for c in rcs[0].description]
rows = rcs[0].fetchall()
print(f"결과 {len(rows):,}행 / {len(cols)} 컬럼")

# 값(버킷) 컬럼 제외 = 정적 컬럼만
import re
STATIC = [c for c in cols if not re.match(r'^[DWM]_\d+$', c or '')]
sidx = [cols.index(c) for c in STATIC]
print(f"정적 컬럼 {len(STATIC)}개 (버킷 제외)")

# 정적 전체 + MEASURE 로 그룹
g = defaultdict(list)
for ri, r in enumerate(rows):
    g[tuple(r[i] for i in sidx)].append(ri)
dup = {k: v for k, v in g.items() if len(v) > 1}
print(f"\n정적 컬럼 **전체** 동일 그룹 중 중복: {len(dup):,}개 그룹")
print(f"   분포: {dict(Counter(len(v) for v in dup.values()))}")

if dup:
    print("\n⇒ 정적 컬럼이 전부 같은데 행이 갈라진다 = 버킷 값만 다른 행")
    k, idxs = next(iter(dup.items()))
    print(f"\n[표본 그룹 {len(idxs)}행] 버킷 컬럼 중 값이 있는 것만 비교")
    B = [c for c in cols if re.match(r'^[DWM]_\d+$', c or '')]
    for ri in idxs:
        vals = {c: rows[ri][cols.index(c)] for c in B if rows[ri][cols.index(c)] is not None}
        print(f"   row#{ri}: 버킷값 {len(vals)}개  {dict(list(vals.items())[:6])}")

# 정적 - MEASURE 조합으로 다시 (어느 정적 컬럼이 다른지)
KEY = [c for c in STATIC if c not in ('MEASURE',)]
kidx = [cols.index(c) for c in KEY]
g2 = defaultdict(list)
for ri, r in enumerate(rows):
    g2[(tuple(r[i] for i in kidx), r[cols.index('MEASURE')] if 'MEASURE' in cols else None)].append(ri)
d2 = {k: v for k, v in g2.items() if len(v) > 1}
print(f"\n정적(MEASURE 제외) + MEASURE 동일 중복: {len(d2):,}개 그룹  분포 {dict(Counter(len(v) for v in d2.values()))}")

# 어느 컬럼이 3분할을 만드나 — 정적 컬럼을 하나씩 빼며 그룹수 변화 측정
print("\n=== 컬럼별 '분할 기여도' (그 컬럼을 키에서 빼면 그룹이 얼마나 합쳐지나) ===")
base = len(set(tuple(r[i] for i in sidx) for r in rows))
eff = []
for c in STATIC:
    ii = [cols.index(x) for x in STATIC if x != c]
    n = len(set(tuple(r[i] for i in ii) for r in rows))
    if base - n > 0:
        eff.append((c, base - n))
eff.sort(key=lambda x: -x[1])
for c, n in eff[:10]:
    print(f"   {c:<30} 제외 시 그룹 {n:,}개 감소")
if not eff:
    print("   (단일 컬럼 제외로 합쳐지는 그룹 없음)")
con.close()
