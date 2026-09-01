# -*- coding: utf-8 -*-
"""DMF0035 MKT 표시 3축 교집합 실측: spreadTitle 컬럼 × main o_rc1 키 × 기간 접두 (사내 SCM_MGR 직접 호출)"""
import io, sys, re; sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics"); sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
import oracledb; from ora import conn_info
u,p,d = conn_info(); con = oracledb.connect(user=u,password=p,dsn=d); cur = con.cursor()
USER, DIV, FR, TO, BUCKET = 'minyonglee1', '40', '20260801', '20270228', 'W'
t1 = cur.var(oracledb.CURSOR); t2 = cur.var(oracledb.CURSOR)
cur.callproc("SCM_MGR.PKG_DMF0035.P_DMF0035_GET_SPREAD_TITLE", [FR, TO, USER, DIV, BUCKET, t1, t2])
tc = t1.getvalue(); tcols = [c[0] for c in tc.description]; trows = tc.fetchall(); print("spreadTitle cols", tcols, "rows", len(trows))
ti = {c:i for i,c in enumerate(tcols)}
title_names = [(r[ti['COLUMN_NAME']], r[ti.get('VISIBLE_FLAG', 0)] if 'VISIBLE_FLAG' in ti else None) for r in trows]
print("title COLUMN_NAME:", [n for n,_ in title_names][:80])
r1=cur.var(oracledb.CURSOR); r2=cur.var(oracledb.CURSOR); r3=cur.var(oracledb.CURSOR); r4=cur.var(oracledb.CURSOR)
cur.execute("SELECT ARGUMENT_NAME FROM ALL_ARGUMENTS WHERE OWNER='SCM_MGR' AND PACKAGE_NAME='PKG_DMF0035' AND OBJECT_NAME='P_DMF0035_GET_MKT_FCST_WATERFALL' AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION"); args=[r[0] for r in cur.fetchall()]; print("main args", args)
cur.callproc("SCM_MGR.PKG_DMF0035.P_DMF0035_GET_MKT_FCST_WATERFALL", [DIV,'ALL','ALL','ALL','ALL','ALL','ALL',FR,TO,USER,'ALL','ALL','ALL','Current',BUCKET,'','', 'N','ALL',USER,'DMF0035', r1,r2,r3,r4])
mc = r1.getvalue(); mcols=[c[0] for c in mc.description]; mrows=mc.fetchall(); print("main o_rc1 rows", len(mrows), "cols", len(mcols)); print("main cols:", mcols[:60])
tn = [n for n,_ in title_names]
row_axis = [n for n in tn if not re.match(r'^(D_|W_|M_|Q_|Y_)\d', n) and not n.startswith('B_') and n in mcols]
print("행축(교집합):", row_axis, "| VERSION_NO in main:", 'VERSION_NO' in mcols, "MEASURE in main:", 'MEASURE' in mcols)
per = [c for c in mcols if re.match(r'^(W_|M_)\d', c)]; print("main 기간컬럼", len(per), per[:5])
print("sample MEASURE 값:", sorted({r[mcols.index('MEASURE')] for r in mrows})[:20] if 'MEASURE' in mcols else None)
rc = r4.getvalue(); print("result cursor:", [c[0] for c in rc.description], rc.fetchall()[:3])
