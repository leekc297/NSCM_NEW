"""SCP0122 이식본(PKG_SCP0122_PORTCHK) vs 사내 현행(PKG_SCP0121/PKG_SCP0122) 결과셋 동등성 비교 + 저장 빈 배열 스모크."""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).parent))
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def call(name, inputs, n_rc):
    rcs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(n_rc)]
    cur.callproc(name, list(inputs) + rcs)
    out = []
    for v in rcs:
        c = v.getvalue()
        cols = [x[0] for x in c.description]
        out.append((cols, c.fetchall()))
    return out


def cmp(label, a, b):
    ok = True
    for i, ((ca, ra), (cb, rb)) in enumerate(zip(a, b), 1):
        same = ca == cb and ra == rb
        if not same and ca == cb and sorted(ra, key=str) == sorted(rb, key=str):
            print(f"  {label} RC{i}: 행 집합 동일 · 순서만 다름(ORDER BY 없음)")
            same = True
        ok &= same
        print(f"  {label} RC{i}: new {len(ra)} rows / live {len(rb)} rows · cols {'=' if ca == cb else '≠ ' + str(ca) + ' vs ' + str(cb)} · rows+order {'=' if ra == rb else '≠'}")
    return ok


allok = True
for uid in ('minyonglee1', None):
    new = call('PKG_SCP0122_PORTCHK.P_SCP0121_GET_SEARCH_INFO', [uid], 7)
    live = call('PKG_SCP0121.P_SCP0121_GET_SEARCH_INFO', [uid], 6)
    print(f"SEARCH_INFO user={uid} result={new[6][1]}")
    allok &= cmp('SEARCH_INFO', new[:6], live)

cur.execute("""SELECT B.DIVISION_ID, A.OPMZ_PLAN_GR_ID, A.OPMZ_PRS_CD, COUNT(*) CNT
                 FROM SCP_OPMZ_PLAN_GR_ACTV_M A JOIN SCP_OPMZ_PLAN_GR_M B ON B.OPMZ_PLAN_GR_ID = A.OPMZ_PLAN_GR_ID
                GROUP BY B.DIVISION_ID, A.OPMZ_PLAN_GR_ID, A.OPMZ_PRS_CD ORDER BY CNT DESC FETCH FIRST 3 ROWS ONLY""")
for div, gr, prs, cnt in cur.fetchall():
    for args in ([div, gr, prs], [div.lower() + ' ', gr.lower(), prs], [None, gr, prs]):
        new = call('PKG_SCP0122_PORTCHK.P_SCP0122_GET_PLAN_ACTIVITY_MGMT', args, 2)
        live = call('PKG_SCP0122.P_SCP0122_GET_PLAN_ACTIVITY_MGMT', args, 2)
        print(f"PLAN_ACTIVITY args={args} ledger={cnt} result={new[1][1]}")
        allok &= cmp('PLAN_ACTIVITY', new[:1], live[:1])

new = call('PKG_SCP0122_PORTCHK.P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT', ['[]', 'minyonglee1'], 1)
print(f"SAVE [] -> {new[0]}")
new = call('PKG_SCP0122_PORTCHK.P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT', [None, 'minyonglee1'], 1)
print(f"SAVE NULL -> {new[0]}")
print('ALL EQUAL' if allok else 'DIFF FOUND')
