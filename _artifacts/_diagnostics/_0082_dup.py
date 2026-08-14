#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 조회 결과 **중복 원인 진단** — 클라우드 7,919행 vs 로컬 17,482행.

가설: 센티널 변형(`' '` / `'-'` / `'--'` / NULL)이 서로 다른 값으로 취급되어
      **같은 논리 행이 갈라진다**. (hook #119 §1.5 — 변형 3형은 '-' 로 통일)

검증: 결과를 그대로 받아 ① 원형 키로 그룹 ② 센티널 정규화 키로 그룹 → 두 그룹수 차이가
      곧 "센티널 때문에 갈라진 행수" 다. 추정하지 않고 **컬럼별 변형 분포**도 함께 센다.
"""
import io, sys, time, pathlib
from collections import Counter, defaultdict
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

A = 'ALL'
PARAMS = ['40', A, A, A, '20260801', '20270131', A, None,
          'Current', 'N', 'minyonglee1', 'ADMIN', A, A, A, A]
SENT = {None: 'NULL', '': "''", ' ': "' '", '-': "'-'", '--': "'--'"}

def norm(v):
    """센티널 변형 통일 — NULL/''/' '/'-'/'--' → '-'"""
    if v is None:
        return '-'
    s = str(v).strip()
    return '-' if s in ('', '-', '--') else s

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
rcs = [con.cursor() for _ in range(5)]
rr = con.cursor()
t0 = time.time()
cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", PARAMS + rcs + [rr])
cols = [c[0] for c in rcs[0].description]
rows = rcs[0].fetchall()
print(f"[SP+fetch] {time.time()-t0:.1f}s   결과 {len(rows):,}행 / 컬럼 {len(cols)}개")

# ── 센티널 변형 분포 (컬럼별) ────────────────────────────────────────────────
print("\n=== 센티널 변형 보유 컬럼 (NULL/''/' '/'-'/'--') ===")
found = False
for i, c in enumerate(cols):
    cnt = Counter()
    for r in rows:
        v = r[i]
        if isinstance(v, oracledb.LOB):
            continue
        if v is None or (isinstance(v, str) and v.strip() in ('', '-', '--')):
            cnt[SENT.get(v if v is None else v, repr(v))] += 1
    if len(cnt) > 1:
        found = True
        print(f"   ⚠ {c:<28} {dict(cnt)}")
if not found:
    print("   (변형 혼재 컬럼 없음)")

# ── 중복 판정: 원형 키 vs 정규화 키 ──────────────────────────────────────────
def keyed(fn):
    g = Counter()
    for r in rows:
        g[tuple(fn(r[i]) for i in range(len(cols))
                if not isinstance(r[i], oracledb.LOB))] += 1
    return g

raw = keyed(lambda v: v)
nrm = keyed(norm)
print(f"\n=== 전 컬럼 기준 ===")
print(f"   원형 distinct     : {len(raw):,}")
print(f"   센티널정규화 후    : {len(nrm):,}")
print(f"   완전중복(원형)     : {sum(v-1 for v in raw.values() if v>1):,}행")

# 논리키(값 컬럼 제외) 기준 — 표시 단위 중복
KEYC = [c for c in cols if c in (
    'DIVISION_ID','PROJECT_CODE','SCM_SITE_ID','ITEM_ID','PLANT_SITE_ID',
    'END_CUSTOMER','DOM_EXP','FCST_TYPE','INCOTERMS','MEASURE','CURRENCY')]
idx = [cols.index(c) for c in KEYC]
rawk = Counter(tuple(r[i] for i in idx) for r in rows)
nrmk = Counter(tuple(norm(r[i]) for i in idx) for r in rows)
print(f"\n=== 논리키 {KEYC} 기준 ===")
print(f"   원형 distinct     : {len(rawk):,}")
print(f"   센티널정규화 후    : {len(nrmk):,}   → 정규화로 합쳐지는 행 {len(rawk)-len(nrmk):,}")
print(f"   키 중복 총합       : {sum(v-1 for v in rawk.values() if v>1):,}행")

print("\n=== 중복 상위 키 5건 ===")
for k, v in rawk.most_common(5):
    print(f"   x{v:<4} {dict(zip(KEYC, [str(x)[:16] for x in k]))}")
con.close()
