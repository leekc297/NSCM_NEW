# -*- coding: utf-8 -*-
"""사내오라클 PKG_SCP0096.P_SCP0096_GET 직접 호출 — O_RC1 컬럼 목록(alias)·행수·D_ 열 NULL 비율 (FE 실전송값: divisionId='40', plantSiteId='ALL')"""
import sys, os, datetime
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..', 'tools', 'DbConn'))
from dbconn import connect
import oracledb
today = datetime.date.today(); frm = today.strftime('%Y%m%d'); to = (today + datetime.timedelta(days=13)).strftime('%Y%m%d')
with connect('tobe') as cx:
    cur = cx.cursor()
    rc1 = cur.var(oracledb.DB_TYPE_CURSOR); rc2 = cur.var(oracledb.DB_TYPE_CURSOR)
    cur.callproc('SCM_MGR.PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP', ['40', 'ALL', frm, to, rc1, rc2])
    c1 = rc1.getvalue(); cols = [d[0] for d in c1.description]; rows = c1.fetchall()
    print('period', frm, to, '| O_RC1 columns', len(cols), '| rows', len(rows))
    print('columns:', cols)
    dcols = [i for i, c in enumerate(cols) if c.startswith('D_')]
    nulls = sum(1 for r in rows for i in dcols if r[i] is None); total = len(rows) * len(dcols)
    print('D_ cells', total, 'NULL', nulls, '(%.0f%%)' % (100.0 * nulls / total if total else 0))
    if rows: print('row0:', rows[0][:6], '...', rows[0][6:12])
    c2 = rc2.getvalue(); print('O_RESULT_CURSOR', [d[0] for d in c2.description], c2.fetchall())
