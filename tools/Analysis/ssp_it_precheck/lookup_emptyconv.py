# -*- coding: utf-8 -*-
"""LOOKUP_GROUP = 'SSP' 범위 : AS-IS 빈 문자열 · NULL 이 TO-BE 에 어떤 값으로 들어가 있는지 열별 집계(읽기 전용)"""
import sys, collections
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
t = dbconn.connect('tobe'); tc = t.cursor(); a = dbconn.connect('asis'); a.timeout = 300; ac = a.cursor()
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('TO-BE ZIOUI1', tc.fetchone()[0])
for tb, nk in (('SCM_ADM_LOOKUP_MASTER', 1), ('SCM_ADM_LOOKUP_MASTER_DETAIL', 6)):
    tc.execute("SELECT column_name, data_type FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name=:t ORDER BY column_id", t=tb); cs = tc.fetchall()
    cn = [c for c, _ in cs]; kc = ['LOOKUP_TYPE'] + (['SEGMENT1', 'SEGMENT2', 'SEGMENT3', 'SEGMENT4', 'SEGMENT5'] if nk == 6 else [])
    w = "LOOKUP_TYPE IN (SELECT LOOKUP_TYPE FROM {m} WHERE LOOKUP_GROUP = 'SSP')"
    tc.execute(f"SELECT {', '.join(cn)} FROM {tb} WHERE " + w.format(m='SCM_ADM_LOOKUP_MASTER'))
    o = {}
    for r in tc.fetchall(): o[tuple(r[cn.index(k)] for k in kc)] = r
    ac.execute(f"SELECT {', '.join(cn)} FROM dbo.{tb} WITH (NOLOCK) WHERE " + w.format(m='dbo.SCM_ADM_LOOKUP_MASTER'))
    m = ac.fetchall()
    cnt = collections.Counter(); vy = collections.Counter(); sp = collections.Counter()
    for r in m:
        k = tuple(('-' if r[cn.index(x)] == '' else r[cn.index(x)]) for x in kc)
        for i, c in enumerate(cn):
            v = r[i]
            if isinstance(v, str):
                for ch in ("'", '&', '?', ':', '\n', '\r', '\t'):
                    if ch in v: sp[(c if not c.startswith('ATTR') else 'ATTRIBUTE*', repr(ch))] += 1
            if c == 'VALID_YN': vy[repr(v)] += 1
        if k not in o: continue
        for i, c in enumerate(cn):
            if c in kc: continue
            v = r[i]; ov = o[k][i]
            if v == '' or v is None:
                cnt[(c if not c.startswith('ATTR') else 'ATTRIBUTE*', 'AS-IS ' + repr(v), 'TO-BE ' + repr(ov)[:12])] += 1
    print(f'\n##### {tb} · AS-IS 행 {len(m)} · TO-BE 행 {len(o)}')
    for x, n in sorted(cnt.items(), key=lambda z: (z[0][0], -z[1])): print('  ', x, n)
    print('  AS-IS VALID_YN 값', dict(vy)); print('  특수 문자', dict(sp))
t.close(); a.close()
