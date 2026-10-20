# -*- coding: utf-8 -*-
"""PKG_SCP0096 적용 후 스모크 + As-is(MSSQL) 대조
  1) ZIOUI1: P_DM0003_GET_BUCKET_TYPE_CODE / P_SCP0009_GET_SHEET_CALENDAR_3SPAN / 기존 P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP(회귀) 실행
  2) AS-IS MSSQL(readOnly): DM0003_GET_BUCKET_TYPE_CODE / SCP0009_GET_SHEET_CALENDAR_3SPAN 실행 → 컬럼·행수·값 대조
"""
import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..', 'tools', 'DbConn'))
from dbconn import connect
import oracledb

S, E = '20260101', '20260131'
norm = lambda rows: [tuple('' if v is None else str(v).strip() for v in r) for r in rows]

def ora_call(cx, name, inargs):
    cur = cx.cursor()
    rc = cur.var(oracledb.DB_TYPE_CURSOR); rs = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc(name, list(inargs) + [rc, rs])
    c1 = rc.getvalue(); cols = [d[0] for d in c1.description]; rows = c1.fetchall()
    c2 = rs.getvalue(); rcols = [d[0] for d in c2.description]; rrows = c2.fetchall()
    return cols, rows, rcols, rrows

out = {}
with connect('tobe') as cx:
    for name, args in [
        ('SCM_MGR.PKG_SCP0096.P_DM0003_GET_BUCKET_TYPE_CODE', []),
        ('SCM_MGR.PKG_SCP0096.P_SCP0009_GET_SHEET_CALENDAR_3SPAN', [S, E]),
        ('SCM_MGR.PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP', ['40', '', S, '20260110']),
    ]:
        cols, rows, rcols, rrows = ora_call(cx, name, args)
        out[name.split('.')[-1]] = (cols, rows)
        print(f'[ORA] {name.split(".")[-1]}  rows={len(rows)}  cols={len(cols)}  RESULT={rrows}')
        print('      cols:', cols[:12], '...' if len(cols) > 12 else '')
        for r in rows[:4]: print('      ', r[:8])
    cx.rollback()

try:
    with connect('asis') as mx:
        mc = mx.cursor()
        asis = {}
        mc.execute("EXEC dbo.DM0003_GET_BUCKET_TYPE_CODE"); asis['BUCKET'] = ([d[0] for d in mc.description], mc.fetchall())
        mc.execute("EXEC dbo.SCP0009_GET_SHEET_CALENDAR_3SPAN @p_start_yyyymmdd=?, @p_end_yyyymmdd=?", (S, E)); asis['3SPAN'] = ([d[0] for d in mc.description], mc.fetchall())
    for key, oname in [('BUCKET', 'P_DM0003_GET_BUCKET_TYPE_CODE'), ('3SPAN', 'P_SCP0009_GET_SHEET_CALENDAR_3SPAN')]:
        acols, arows = asis[key]; ocols, orows = out[oname]
        colsame = [c.upper() for c in acols] == [c.upper() for c in ocols]
        a, o = norm(arows), norm(orows)
        print(f'[GOLDEN] {oname}: cols {"SAME" if colsame else "DIFF " + str(acols) + " vs " + str(ocols)} · rows asis={len(a)} tobe={len(o)} · '
              f'{"VALUES SAME" if a == o else "VALUES DIFF"}')
        if a != o:
            sa, so = set(a), set(o)
            for r in list(sa - so)[:5]: print('   only-asis', r)
            for r in list(so - sa)[:5]: print('   only-tobe', r)
            if sa == so: print('   (집합 동일 — 정렬 순서만 다름)')
except Exception as ex:
    print('[GOLDEN] AS-IS 접속/실행 실패 →', type(ex).__name__, str(ex)[:300])
