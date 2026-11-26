# -*- coding: utf-8 -*-
"""
PKG_SSP0046 실행 시험 (조회만, 저장은 별도 --save 에서 ROLLBACK)
usage: python smoke_ssp0046.py <division> <sheet> <from> <to> [--asis] [--save]
 - TO-BE  : PKG_DMF0045 / PKG_SSP0046 GET_SHIPMENT_REQUEST, GET_SPREAD_TITLE
 - --asis : AS-IS MSSQL DMF0045 / SSP0046 GET_SHIPMENT_REQUEST (dev DB, 조회 SP)
결과 요약 = 행 수, MEASURE 별 행 수·수량 합, SHIP_FROZEN 분포
"""
import sys, os, collections, datetime, json
import oracledb

div, sheet, frm, to = sys.argv[1:5]
env = dict(l.strip().split('=', 1) for l in open(r'c:\Projects\NSCM\.env.asis', encoding='utf-8')
           if '=' in l and not l.startswith('#'))
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'smoke')
os.makedirs(OUT, exist_ok=True)


def summarize(cols, rows):
    cols = [c.upper() for c in cols]
    mi = cols.index('MEASURE')
    fz = cols.index('SHIP_FROZEN') if 'SHIP_FROZEN' in cols else None
    datecols = [i for i, c in enumerate(cols) if c[:2] in ('D_',) or (c.isdigit() and len(c) == 8)]
    by = collections.OrderedDict()
    for r in rows:
        m = r[mi]
        s = sum(float(r[i] or 0) for i in datecols)
        a = by.setdefault(m, [0, 0.0])
        a[0] += 1
        a[1] += s
    fzd = collections.Counter(r[fz] for r in rows) if fz is not None else {}
    return {'rows': len(rows), 'datecols': len(datecols),
            'measure': {k: [v[0], round(v[1], 3)] for k, v in by.items()},
            'ship_frozen': {str(k): v for k, v in sorted(fzd.items(), key=lambda x: str(x[0]))}}


def tobe(pkg):
    c = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                         dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
    cur = c.cursor()
    cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
    scr = pkg.split('_')[1]
    rc1, rc2 = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
    t0 = datetime.datetime.now()
    cur.callproc(f'{pkg}.P_{scr}_GET_SHIPMENT_REQUEST',
                 [sheet, div, '', '', '', '', '', '', frm, to, 'admin', rc1, rc2])
    r = rc1.getvalue()
    cols = [d[0] for d in r.description]
    rows = r.fetchall()
    res = rc2.getvalue().fetchall()
    sec = (datetime.datetime.now() - t0).total_seconds()
    t1, t2 = cur.var(oracledb.CURSOR), cur.var(oracledb.CURSOR)
    cur.callproc(f'{pkg}.P_{scr}_GET_SPREAD_TITLE', [frm, to, 'admin', sheet, div, t1, t2])
    trows = t1.getvalue().fetchall()
    dates = [x[2] for x in trows if str(x[2]).startswith('D_')]
    c.rollback()
    s = summarize(cols, rows)
    s.update({'result': res, 'sec': round(sec, 1), 'title_rows': len(trows),
              'title_first_D': dates[0] if dates else None, 'title_D_cnt': len(dates)})
    return s


def asis(scr):
    import pyodbc
    cs = (f"DRIVER={{{env.get('ASIS_DB_DRIVER', 'ODBC Driver 17 for SQL Server')}}};SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};"
          f"DATABASE={env['ASIS_DB_NAME']};UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']};TrustServerCertificate=yes")
    c = pyodbc.connect(cs, timeout=30)
    c.timeout = 1800
    cur = c.cursor()
    t0 = datetime.datetime.now()
    cur.execute(f"SET NOCOUNT ON; EXEC dbo.{scr}_GET_SHIPMENT_REQUEST @p_sheet_name=?, @p_division_id=?, @p_team_id='', @p_customer='', "
                f"@p_scm_site_id='', @p_plant_site_id='', @p_project_code='', @p_item_id='', @p_from_yyyymmdd=?, @p_to_yyyymmdd=?, "
                f"@p_created_by='admin', @debug_mode='F'", sheet, div, frm, to)
    while cur.description is None and cur.nextset():
        pass
    cols = [d[0] for d in cur.description]
    rows = cur.fetchall()
    sec = (datetime.datetime.now() - t0).total_seconds()
    c.rollback()
    s = summarize(cols, rows)
    s['sec'] = round(sec, 1)
    return s


out = {'param': [div, sheet, frm, to], 'run_at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
out['TOBE_DMF0045'] = tobe('PKG_DMF0045')
out['TOBE_SSP0046'] = tobe('PKG_SSP0046')
if '--asis' in sys.argv:
    for k in ('DMF0045', 'SSP0046'):
        try:
            out['ASIS_' + k] = asis(k)
        except Exception as e:
            out['ASIS_' + k] = {'ERROR': str(e)[:300]}
fn = os.path.join(OUT, f"smoke_{div}_{sheet.replace(' ', '')}_{frm}_{to}.json")
json.dump(out, open(fn, 'w', encoding='utf-8'), ensure_ascii=False, indent=1, default=str)
print(json.dumps(out, ensure_ascii=False, indent=1, default=str))
