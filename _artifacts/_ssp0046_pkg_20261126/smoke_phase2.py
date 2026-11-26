# -*- coding: utf-8 -*-
"""PKG_SSP0046 2단계 프로시저 실행 시험 + PROC_M 대조 + AS-IS 같은 인자 실행 건수(참고)"""
import oracledb, pyodbc, json, datetime, sys
PKG = sys.argv[1] if len(sys.argv) > 1 else 'PKG_SSP0046'
env = dict(l.strip().split('=', 1) for l in open(r'c:\Projects\NSCM\.env.asis', encoding='utf-8')
           if '=' in l and not l.startswith('#'))
c = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                     dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
c.call_timeout = 180000
cur = c.cursor()
cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
a = pyodbc.connect(f"DRIVER={{{env.get('ASIS_DB_DRIVER', 'ODBC Driver 17 for SQL Server')}}};SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};"
                   f"DATABASE={env['ASIS_DB_NAME']};UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};TrustServerCertificate=yes", timeout=30)
a.timeout = 180
acur = a.cursor()

out = {'run_at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

# PROC_M 대조
cur.execute("""SELECT A.OBJECT_NAME, COUNT(*) FROM ALL_ARGUMENTS A WHERE A.OWNER='SCM_MGR' AND A.PACKAGE_NAME='PKG_SSP0046' AND A.DATA_LEVEL=0
               GROUP BY A.OBJECT_NAME ORDER BY 1""")
args = dict(cur.fetchall())
cur.execute("SELECT SUBSTR(PROC_NM, 13), COUNT(*) FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'PKG_SSP0046.%' GROUP BY PROC_NM")
pm = dict(cur.fetchall())
out['proc_m_vs_args'] = {k: [args.get(k), pm.get(k)] for k in sorted(set(args) | set(pm))}

CASES = [
    ('GET_BUCKET_TYPE_CODE', []),
    ('GET_TEAM_BY_DIVISION', ['81']),
    ('GET_CUSTOMER_BY_DIVISION', ['81', 'ALL']),
    ('GET_SITE_BY_DIVISION', ['81', 'ALL', 'ALL']),
    ('GET_BODITEM_FOR_PRJROUTE_POPUP', ['81', 'AMCOME782-A1-0K0', '']),
    ('GET_ITEM_BY_DIVISION_POPUPEX', ['81', 'ALL', 'ALL', '', 'ALL', 'AMC', 'P']),
    ('GET_ITEM_BY_DIVISION_POPUPEX', ['82', 'ALL', 'ALL', '', 'ALL', '', 'P']),
    ('GET_PROJECT_BY_DIVISION_POPUPEX', ['81', 'ALL', 'ALL', 'ALL', '', 'N']),
    ('GET_PROJECT_BY_DIVISION_POPUPEX', ['81', 'ALL', 'ALL', 'ALL', '', 'Y']),
    ('GET_COMMON_SPREAD_TITLE', ['', '', 'admin', 'SSP0046', 'ItemPopup', '81']),
    ('GET_COMMON_SPREAD_TITLE_EX', ['', '', 'admin', 'SSP0046', 'ProjectPopup']),
]
res = []
for n, p in CASES:
    r1, r2 = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
    t0 = datetime.datetime.now()
    print('START', n, p, t0.strftime('%H:%M:%S'), flush=True)
    try:
        cur.callproc(f'{PKG}.P_SSP0046_{n}', [x if x != '' else None for x in p] + [r1, r2])
        rc = r1.getvalue()
        cols = [d[0] for d in rc.description]
        rows = rc.fetchall()
        tobe = {'rows': len(rows), 'cols': len(cols), 'result': r2.getvalue().fetchall(),
                'sec': round((datetime.datetime.now() - t0).total_seconds(), 1), 'first': [str(v) for v in rows[0]][:6] if rows else None}
    except Exception as e:
        tobe = {'ERROR': str(e)[:300]}
    asn = 'GET_ITEM_BY_DIVISION_POPUPEx' if n == 'GET_ITEM_BY_DIVISION_POPUPEX' else n
    try:
        q = f"SET NOCOUNT ON; EXEC dbo.SSP0046_{asn} " + ', '.join(['?'] * len(p))
        acur.execute(q, *p)
        while acur.description is None and acur.nextset():
            pass
        arows = acur.fetchall()
        asis = {'rows': len(arows), 'cols': len(acur.description)}
    except Exception as e:
        asis = {'ERROR': str(e)[:200]}
    res.append({'proc': n, 'param': p, 'TOBE': tobe, 'ASIS(dev DB)': asis})
    print('CASE', n, p, 'TOBE', {k: v for k, v in tobe.items() if k != 'first'}, 'ASIS', asis, datetime.datetime.now().strftime('%H:%M:%S'), flush=True)
out['cases'] = res
json.dump(out, open(f'smoke/smoke_phase2_{PKG}.json', 'w', encoding='utf-8'), ensure_ascii=False, indent=1, default=str)
print('PROC_M vs ARGS', out['proc_m_vs_args'])
