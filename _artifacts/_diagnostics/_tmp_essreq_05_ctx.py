# -*- coding: utf-8 -*-
"""호출지점 컨텍스트 + 역방향: SSP_ANL_ESS_REQ 에 도달하는 모든 UI(MNU_ID) 산출 (읽기 전용)"""
import sys, io, os, collections
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print("=" * 110)
print("### PKG_DMF0003 BODY 5330~5380 (호출지점 컨텍스트)")
print("=" * 110)
cur.execute("""SELECT line, text FROM ALL_SOURCE WHERE owner='SCM_MGR' AND name='PKG_DMF0003'
               AND type='PACKAGE BODY' AND line BETWEEN 5320 AND 5385 ORDER BY line""")
for ln, tx in cur.fetchall():
    print("%5d| %s" % (ln, (tx or '').rstrip()))
print()

print("=" * 110)
print("### PR_SSP_ANL_ESS_REQ signature")
print("=" * 110)
cur.execute("""SELECT position, argument_name, data_type, in_out FROM ALL_ARGUMENTS
               WHERE owner='SCM_MGR' AND object_name='PR_SSP_ANL_ESS_REQ' AND package_name IS NULL
               ORDER BY position""")
for r in cur.fetchall():
    print(r)
print()

# 역방향 UI 귀속
cur.execute("""
SELECT owner, name, type, referenced_owner, referenced_name, referenced_type
  FROM ALL_DEPENDENCIES WHERE owner IN ('SCM_MGR','FP_MGR','SCMC','SETUP_MGR')
""")
deps = cur.fetchall()
edges = collections.defaultdict(set)
for (o, n, t, ro, rn, rt) in deps:
    edges[n].add(rn)

cur.execute("""
SELECT DISTINCT m.MNU_ID, a.API_URL FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M m
  JOIN SCM_MGR.SCM_ADM_API_M a ON a.API_ID = m.API_ID
""")
pairs = cur.fetchall()

def reach(root):
    seen = {root}
    dq = collections.deque([root])
    while dq:
        c = dq.popleft()
        for r in edges.get(c, ()):
            if r not in seen:
                seen.add(r); dq.append(r)
    return seen

cache = {}
TARGET = 'SSP_ANL_ESS_REQ'
hit = collections.defaultdict(set)
for mnu, url in pairs:
    root = url.split('.')[0].upper()
    if root not in cache:
        cache[root] = reach(root)
    if TARGET in cache[root]:
        hit[mnu].add(url)

print("=" * 110)
print("### 폐포로 SSP_ANL_ESS_REQ 에 도달하는 모든 MNU_ID (API_M 씨앗 기준)")
print("=" * 110)
for m in sorted(hit):
    print(" ", m, "->", sorted(hit[m]))
print("(%d MNU_ID)" % len(hit))
print()

print("### 참고: API_M 등록 ROOT 총 %d 개" % len(cache))
con.close()
