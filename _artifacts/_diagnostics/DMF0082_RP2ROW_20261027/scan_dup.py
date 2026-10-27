"""사내 스캔: 81 조회 결과에서 '화면에 보이는 컬럼'(사용자 Column Set 'C' ∪ 메타 필수 컬럼)이 같은 줄이 2개 이상인 그룹 → 값이 다른 숨은 컬럼 (조회 전용, ROLLBACK)"""
import sys, oracledb, collections
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); from ora import conn_info
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0082_LASTUPD_20261027"); import test_before_after as T
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
div = sys.argv[1]; f, t = sys.argv[2], sys.argv[3]; sites = sys.argv[4].split("|"); users = sys.argv[5].split("|")
for usr in users:
    cur.execute("""SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0082' AND USER_ID=:u AND USER_INQUIRY_COLUMN_TYPE_CODE='C'
                   UNION SELECT COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice' AND VALID_YN='Y'
                   AND USER_SELECTABLE_FLAG='N' AND VISIBLE_FLAG='Y' AND (DIVISION_ID IS NULL OR INSTR(','||DIVISION_ID||',', ','||:d||',')>0)""", u=usr, d=div)
    vis = {r[0] for r in cur} | {"MEASURE"}
    for proc in T.PROCS:
        for site in sites:
            cols, rows, rc = T.call(cur, proc, div, f, t, usr, "ALL", site); con.rollback()
            vi = [i for i, c in enumerate(cols) if c in vis]
            g = collections.defaultdict(list)
            for r in rows: g[tuple(r[i] for i in vi)].append(r)
            dups = {k: v for k, v in g.items() if len(v) > 1}
            diffc = collections.Counter()
            for v in dups.values():
                for i, c in enumerate(cols):
                    if not T.is_measure(c) and len({repr(r[i]) for r in v}) > 1: diffc[c] += 1
            print(f"{proc[11:]:22s} {usr:12s} {site:22s} rows {len(rows):5d} 보이는키 중복그룹 {len(dups):3d} 다른 숨은컬럼 {dict(diffc)}", flush=True)
            for k, v in list(dups.items())[:2]:
                for r in v:
                    print("     ", {c: r[i] for i, c in enumerate(cols) if c in diffc or c in ("MEASURE","ITEM_ID")})
