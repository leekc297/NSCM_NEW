import collections, oracledb
import apply_pricedup as m
u, p, d = m.conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor(); cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
    body, _, _ = m.fetch(cur, "PACKAGE BODY"); spec, _, _ = m.fetch(cur, "PACKAGE")
    tobe = m.build(body)
    cur.execute("SELECT TO_CHAR(TRUNC(SYSDATE,'IW'),'YYYYMMDD'), TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'IW'),-2),'YYYYMMDD'), TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'IW'),12),'YYYYMMDD') FROM DUAL")
    now, frm, to = cur.fetchone()
    try:
        for nm, b in (("ZT_DMF0021_O", body), ("ZT_DMF0021_N", tobe)):
            cur.execute(m.renamed(spec, nm)); cur.execute(m.renamed(b, nm))
        for div, user, grp in (("81", "minyonglee1", "ADMIN"), ("81", "jaehun_cho", "jaehun_cho")):
            co, ro = m.run(cur, "ZT_DMF0021_O", div, user, grp, now, frm, to)
            cn, rn = m.run(cur, "ZT_DMF0021_N", div, user, grp, now, frm, to)
            mi, fi = co.index("MEASURE"), co.index("FROM_SITE_ID")
            wcols = [i for i, c in enumerate(co) if c.startswith("W_") or c[:1].isdigit()]
            kcols = [i for i in range(len(co)) if i not in wcols and i != fi]
            def idx(rows):
                g = collections.defaultdict(list)
                for r in rows:
                    if r[mi] in m.PM: g[tuple(r[i] for i in kcols)].append(r)
                return g
            O, N = idx(ro), idx(rn)
            conflict = filled = same = 0; samples = []
            for k, nrows in N.items():
                orows = O.get(k, [])
                assert len(nrows) == 1, ("N 단가 행 중복", k)
                nr = nrows[0]
                for orr in orows:
                    for i in wcols:
                        if orr[i] not in ("", "0"):
                            if orr[i] == nr[i]: same += 1
                            else:
                                conflict += 1
                                if len(samples) < 5: samples.append((co[i], orr[fi], orr[i], nr[fi], nr[i]))
            dupO = sum(1 for v in O.values() if len(v) > 1)
            print(f"div={div} user={user} 값열수={len(wcols)} | O 중복키={dupO} N 중복키=0 | 기존값 동일 셀={same} 다른 셀={conflict} {samples}")
    finally:
        for nm in ("ZT_DMF0021_O", "ZT_DMF0021_N"):
            try: cur.execute(f"DROP PACKAGE SCM_MGR.{nm}")
            except oracledb.DatabaseError as e: print("DROP", nm, e)
        cur.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME LIKE 'ZT!_DMF0021!_%' ESCAPE '!'"); print("ZT 잔존", cur.fetchone()[0])
