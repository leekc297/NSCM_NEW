"""SCP0100 단위테스트 픽스처 — 사내 PKG_SCP0100.P_SCP0100_GET_SHEET_CALENDAR_3SPAN('20260928','20261018') o_rc1 (읽기 전용)"""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
import dbconn
import oracledb

t = dbconn.connect('tobe'); c = t.cursor()
rc1 = c.var(oracledb.CURSOR); rs = c.var(oracledb.CURSOR)
c.callproc('PKG_SCP0100.P_SCP0100_GET_SHEET_CALENDAR_3SPAN', ['20260928', '20261018', rc1, rs])
for r in rc1.getvalue().fetchall():
    print(r)
print('RESULT', rs.getvalue().fetchall())
