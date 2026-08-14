#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 조회 — **fetch(SP 밖) 비용 프로파일**.

목적: "fetch N초" 를 튜닝 기준으로 삼기 위한 실측 근거 확보.
  · SP 시간 = 서버가 결과를 만드는 시간 (SQL 튜닝 대상)
  · fetch 시간 = 만들어진 결과를 **클라이언트로 옮기는** 시간 (SQL 튜닝으로 안 줄어듦)
    구성 = ①왕복 횟수(= 행수 / arraysize) ②행당 직렬화량(= 컬럼수 × 평균길이) ③LOB 추가 왕복

측정 축 3개:
  (1) 컬럼 인벤토리 — 개수/타입/LOB 유무/평균 바이트
  (2) arraysize 별 fetch 시간 — 왕복 횟수 효과
  (3) 컬럼 수 절감 시뮬 — 상위 N 컬럼만 받을 때의 직렬화량 비율
"""
import io, sys, time, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

A = 'ALL'
PARAMS = ['40', A, A, A, '20260801', '20270131', A, None,
          'Current', 'N', 'minyonglee1', 'ADMIN', A, A, A, A]

def run(arraysize):
    u, p, d = conn_info()
    con = oracledb.connect(user=u, password=p, dsn=d)
    cur = con.cursor()
    rcs = [con.cursor() for _ in range(5)]
    rr = con.cursor()
    t0 = time.time()
    cur.callproc("SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", PARAMS + rcs + [rr])
    t_sp = time.time() - t0
    rcs[0].arraysize = arraysize
    rcs[0].prefetchrows = arraysize
    desc = rcs[0].description
    t1 = time.time()
    rows = rcs[0].fetchall()
    t_fetch = time.time() - t1
    con.close()
    return t_sp, t_fetch, rows, desc

print("=== (2) arraysize 별 fetch 시간 ===")
base = None
for asz in (100, 1000, 5000):
    t_sp, t_fetch, rows, desc = run(asz)
    trips = -(-len(rows) // asz)
    if base is None:
        base = (rows, desc)
    print(f"   arraysize={asz:<6} SP {t_sp:6.1f}s   fetch {t_fetch:6.2f}s   "
          f"왕복 약 {trips:>5}회   ({len(rows):,}행)")

rows, desc = base
cols = [dd[0] for dd in desc]
print(f"\n=== (1) 컬럼 인벤토리 — {len(cols)}개 ===")
lob = [dd[0] for dd in desc if 'LOB' in str(dd[1]).upper() or 'CLOB' in str(dd[1]).upper()]
print(f"   LOB 컬럼: {len(lob)}개 {lob[:6]}")

tot = 0
per_col = []
for i, c in enumerate(cols):
    n = 0
    for r in rows[::17]:                       # 표본 추출 (약 1/17)
        v = r[i]
        if v is None:
            continue
        n += len(str(v))
    per_col.append((c, n))
    tot += n
tot = max(tot, 1)
per_col.sort(key=lambda x: -x[1])
print(f"   표본 직렬화량 합계 ≈ {tot:,}자  (전체 추정 ≈ {tot*17/1024/1024:.1f} MB)")
print(f"\n   [상위 10 컬럼 — 직렬화량 점유]")
for c, n in per_col[:10]:
    print(f"      {c:<34}{100*n/tot:>6.1f}%")

nz = [c for c, n in per_col if n > 0]
print(f"\n=== (3) 컬럼 절감 여지 ===")
print(f"   값이 하나라도 있는 컬럼 : {len(nz):,} / {len(cols):,}")
print(f"   전부 NULL 인 컬럼       : {len(cols)-len(nz):,}  ← 내려도 화면에서 쓸 수 없음")
top50 = sum(n for _, n in per_col[:50])
print(f"   상위 50 컬럼이 차지하는 직렬화량 : {100*top50/tot:.1f}%")
