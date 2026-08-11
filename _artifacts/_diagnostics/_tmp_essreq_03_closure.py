# -*- coding: utf-8 -*-
"""DMF0003 씨앗 -> ALL_DEPENDENCIES 재귀 폐포 BFS -> SSP_ANL_ESS_REQ 도달 판정 (읽기 전용)"""
import sys, io, os, collections
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

OWNERS = ('SCM_MGR', 'FP_MGR', 'SCMC', 'SETUP_MGR', 'SCMD_APP', 'SCMP_APP', 'PUBLIC')

print("### loading ALL_DEPENDENCIES ...")
cur.execute("""
SELECT owner, name, type, referenced_owner, referenced_name, referenced_type
  FROM ALL_DEPENDENCIES
 WHERE owner IN ('SCM_MGR','FP_MGR','SCMC','SETUP_MGR','SCMD_APP','SCMP_APP')
""")
deps = cur.fetchall()
print("  rows =", len(deps))

# 엣지: (name, type) -> [(ref_name, ref_type, ref_owner, edge_owner, edge_type)]
# PACKAGE BODY 의존성 포함 위해 name 기준으로 PACKAGE/PACKAGE BODY 를 같은 노드로 병합
def norm(t):
    return 'PACKAGE' if t == 'PACKAGE BODY' else t

edges = collections.defaultdict(list)
for (o, n, t, ro, rn, rt) in deps:
    edges[n].append((rn, rt, ro, o, t))

# 씨앗
cur.execute("""
SELECT m.SHT_NM, m.MNU_BTN_CD, m.API_ID, a.API_URL
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M m
  LEFT JOIN SCM_MGR.SCM_ADM_API_M a ON a.API_ID = m.API_ID
 WHERE m.MNU_ID = 'DMF0003' ORDER BY 1,2
""")
seeds = cur.fetchall()

TARGETS = {'SSP_ANL_ESS_REQ', 'SSP_ANL_ESS_REQ_H', 'SSP_ANL_ESS_REQ_NET',
           'PR_SSP_ANL_ESS_REQ', 'PR_SSP_ANL_ESS_REQ_NET',
           'GT_PRSSP_ANL_ESS_REQ', 'GT_PRSSP_ANL_ESS_REQ_NET'}

def root_of(api_url):
    return api_url.split('.')[0].upper() if api_url else None

roots = {}
for sht, btn, api_id, url in seeds:
    r = root_of(url)
    roots.setdefault(r, []).append((sht, btn, url))

print()
print("### ROOT 객체 목록")
for r, lst in sorted(roots.items()):
    print(" ", r, "<-", len(lst), "seeds")

# BFS from combined roots, per root
allreach = {}
for r in sorted(roots):
    seen = {r: (0, None)}   # name -> (depth, parent)
    dq = collections.deque([r])
    while dq:
        cn = dq.popleft()
        dep = seen[cn][0]
        for (rn, rt, ro, eo, et) in edges.get(cn, []):
            if rn not in seen:
                seen[rn] = (dep + 1, (cn, et, rt, ro))
                dq.append(rn)
    allreach[r] = seen
    hits = TARGETS & set(seen)
    print()
    print("=" * 100)
    print("ROOT %s : reached %d objects | TARGET hits = %s" % (r, len(seen), sorted(hits) if hits else 'NONE'))
    for h in sorted(hits):
        # 경로 복원
        path = []
        cn = h
        while cn is not None:
            info = seen[cn]
            path.append((cn, info[1]))
            cn = info[1][0] if info[1] else None
        path.reverse()
        print("  PATH to %s (depth=%d):" % (h, seen[h][0]))
        for i, (nm, par) in enumerate(path):
            if par is None:
                print("    [0] %s (ROOT)" % nm)
            else:
                print("    [%d] %s  <- via %s (edge owner-type=%s, ref_type=%s, ref_owner=%s)" % (i, nm, par[0], par[1], par[2], par[3]))

# 전역: 어떤 root 라도 도달?
union = set()
for r in allreach:
    union |= set(allreach[r])
print()
print("### UNION reached objects =", len(union))
print("### TARGET in union =", sorted(TARGETS & union) or 'NONE (폐포 미도달)')

con.close()
