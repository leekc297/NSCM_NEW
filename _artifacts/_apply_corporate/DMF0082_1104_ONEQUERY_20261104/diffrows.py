"""O_RC1 행 차이 — A(원본) vs B(1104) 같은 호출, 키 12열+SORT_ORDER_NO 로 정렬해 열별 차이 집계
  python diffrows.py <user> <div> [site=..] [item=..] [ver=Current] [pkgB=PKG_DMF0082_1104]"""
import sys, datetime, collections
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn, oracledb
user, div = sys.argv[1], sys.argv[2]
kw = dict(a.split('=', 1) for a in sys.argv[3:])
today = datetime.date.today(); frm = today.replace(day=1); m = frm.month - 1 + 6
to = datetime.date(frm.year + m // 12, m % 12 + 1, 1) - datetime.timedelta(days=1)
args = [div, kw.get('team', 'ALL'), kw.get('cust', 'ALL'), kw.get('biz', 'ALL'), frm.strftime("%Y%m%d"), to.strftime("%Y%m%d"), kw.get('site', 'ALL'), kw.get('item'),
        kw.get('ver', 'Current'), kw.get('qty', 'N'), user, 'ADMIN', kw.get('plant', 'ALL'), kw.get('project', 'ALL'), kw.get('owner', 'ALL'), kw.get('sender', 'ALL')]
cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor(); cx.call_timeout = 1800000
KEYS = ['DIVISION_ID', 'PROJECT_CODE', 'END_CUSTOMER', 'SCM_SITE_ID', 'ITEM_ID', 'DOM_EXP', 'FCST_TYPE', 'INCOTERMS', 'MEASURE', 'PLANT_SITE_ID', 'CELL_PROD_SITE_ID', 'CURRENCY', 'SORT_ORDER_NO']


def run(pkg):
    outs = [c.var(oracledb.DB_TYPE_CURSOR) for _ in range(6)]
    c.callproc(f"SCM_MGR.{pkg}.P_DMF0082_GET_MAIN_DATA", args + outs)
    k = outs[0].getvalue(); cols = [d[0] for d in k.description]; rows = k.fetchall(); cx.rollback()
    return cols, rows


ca, ra = run('PKG_DMF0082'); cb, rb = run(kw.get('pkgB', 'PKG_DMF0082_1104'))
assert ca == cb, 'columns differ'
ki = [ca.index(k) for k in KEYS if k in ca]
print('rows', len(ra), len(rb), 'cols', len(ca), 'key cols', [ca[i] for i in ki])
print('order equal:', ra == rb, '| sorted equal:', sorted(map(repr, ra)) == sorted(map(repr, rb)))
A = collections.defaultdict(list); B = collections.defaultdict(list)
for r in ra: A[tuple(r[i] for i in ki)].append(r)
for r in rb: B[tuple(r[i] for i in ki)].append(r)
onlyA = [k for k in A if k not in B]; onlyB = [k for k in B if k not in A]
print('keys onlyA', len(onlyA), 'onlyB', len(onlyB), 'dup keys A', sum(1 for v in A.values() if len(v) > 1))
for k in onlyA[:3]: print('  onlyA', k)
for k in onlyB[:3]: print('  onlyB', k)
coldiff = collections.Counter(); ex = {}
for k in A:
    if k in B and len(A[k]) == 1 and len(B[k]) == 1:
        x, y = A[k][0], B[k][0]
        for i, (p, q) in enumerate(zip(x, y)):
            if p != q:
                coldiff[ca[i]] += 1
                ex.setdefault(ca[i], (k, p, q))
print('differing columns (count of keys):')
for col, n in coldiff.most_common(30):
    k, p, q = ex[col]; print(f'  {col}: {n}  e.g. key={k[:5]}.. A={p!r} B={q!r}')

# ── 추가 진단: 열별 repr(타입) 차이 · ORDER BY 키 순서 비교 ──
import re
rd = collections.Counter(); rex = {}
for x, y in zip(ra, rb):
    if x == y:
        for i, (p, q) in enumerate(zip(x, y)):
            if repr(p) != repr(q):
                rd[ca[i]] += 1; rex.setdefault(ca[i], (p, q, type(p).__name__, type(q).__name__))
print('repr-only diffs (value equal, repr differs):')
for col, n in rd.most_common(12):
    p, q, tp, tq = rex[col]; print(f'  {col}: {n}  A={p!r}({tp}) B={q!r}({tq})')
ORD = [c for c in ['SORT_KEY', 'DIVISION_ID', 'TEAM_ID', 'END_CUSTOMER', 'SCM_SITE_ID', 'ITEM_ID', 'NICK_NAME', 'INCOTERMS', 'FCST_TYPE', 'DOM_EXP', 'CURRENCY', 'VERSION_NO', 'SOLDTO_CUSTOMER', 'COUNTRY_NAME', 'CITY_NAME', 'ITEM_NAME', 'ITEM_TYPE', 'OWNER', 'VMI_YN', 'SENDER_NAME', 'PROJECT_CODE', 'PLANT_SITE_ID', 'AS_FROM_SITE', 'PROJECT_S_OP_REPORT', 'BIZ_TYPE', 'PROJECT_NAME', 'PROJECT_STATUS', 'PROJECT_OWNER', 'CELL_PER_CAR', 'CELL_PER_MODULE', 'MODULE_PER_CAR', 'SORT_ORDER_NO'] if c in ca]
oi = [ca.index(c) for c in ORD]
ka = [tuple(repr(r[i]) for i in oi) for r in ra]; kb = [tuple(repr(r[i]) for i in oi) for r in rb]
print('ORDER-key sequence equal:', ka == kb, '| first mismatch idx:', next((i for i, (p, q) in enumerate(zip(ka, kb)) if p != q), None))
# 동률 행 내부 열 차이 (위치별)
if ra != rb:
    cd = collections.Counter()
    for x, y in zip(ra, rb):
        if x != y:
            for i, (p, q) in enumerate(zip(x, y)):
                if p != q: cd[ca[i]] += 1
    print('positional diffs (within ORDER ties):', sum(1 for x, y in zip(ra, rb) if x != y), 'rows; columns:', cd.most_common(15))
