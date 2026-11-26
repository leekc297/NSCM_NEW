# -*- coding: utf-8 -*-
"""SSP LOOKUP 대상 구분 — (1) LOOKUP_GROUP = 'SSP' (2) SSP 프로그램 소스가 읽는 유형(양쪽 DB) · 유형별 양쪽 비교(읽기 전용)
  python -u lookup_ssp_target.py <출력 폴더>"""
import sys, os, re, io, csv, collections
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
OUT = sys.argv[1]; os.makedirs(OUT, exist_ok=True)
t = dbconn.connect('tobe'); tc = t.cursor(); a = dbconn.connect('asis'); a.timeout = 300; ac = a.cursor()
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('TO-BE ZIOUI1', tc.fetchone()[0])
Q = chr(39)
PAT = [re.compile(r"LOOKUP_TYPE(?:_CODE)?\s*=\s*N?'([A-Z0-9_]+)'", re.I),
       re.compile(r"'([A-Z0-9_]+)'\s*=\s*\w*\.?LOOKUP_TYPE(?:_CODE)?", re.I),
       re.compile(r"FN_(?:GET|LIST)_LOOKUP\w*\s*\(\s*N?'([A-Z0-9_]+)'", re.I)]
PIN = re.compile(r"LOOKUP_TYPE(?:_CODE)?\s+IN\s*\(([^)]*)\)", re.I)
def strip(s):
    s = re.sub(r'/\*.*?\*/', ' ', s, flags=re.S)
    return re.sub(r'--[^\n]*', ' ', s)
def types(s):
    s = strip(s); r = set()
    for p in PAT: r |= {x.upper() for x in p.findall(s)}
    for g in PIN.findall(s): r |= {x.upper() for x in re.findall(r"'([A-Z0-9_]+)'", g, re.I)}
    return r
# TO-BE 소스
tc.execute("SELECT name, type, text FROM all_source WHERE owner='SCM_MGR' AND name LIKE '%SSP%' AND type IN ('PROCEDURE','FUNCTION','PACKAGE BODY','TRIGGER') ORDER BY name, type, line")
src = collections.defaultdict(list)
for n, ty, tx in tc: src[n].append(tx)
tu = collections.defaultdict(set)
for n, ls in src.items():
    for x in types(''.join(ls)): tu[x].add(n)
tc.execute("SELECT view_name, text FROM all_views WHERE owner='SCM_MGR' AND view_name LIKE '%SSP%'")
for n, tx in tc.fetchall():
    for x in types(tx or ''): tu[x].add(n)
print('TO-BE SSP 이름 객체', len(src), '· 읽는 유형', len(tu))
# AS-IS 소스
ac.execute("SELECT o.name, m.definition FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id WHERE o.name LIKE '%SSP%'")
au = collections.defaultdict(set); na = 0
for n, df in ac.fetchall():
    na += 1
    for x in types(df or ''): au[x].add(n)
print('AS-IS SSP 이름 객체', na, '· 읽는 유형', len(au))
# 마스터 · 상세 · CODE 현황
def load(cur, sql): cur.execute(sql); return {r[0]: tuple(r[1:]) for r in cur.fetchall()}
om = load(tc, "SELECT LOOKUP_TYPE, LOOKUP_GROUP, VALID_YN FROM SCM_ADM_LOOKUP_MASTER")
mm = load(ac, "SELECT LOOKUP_TYPE, LOOKUP_GROUP, VALID_YN FROM dbo.SCM_ADM_LOOKUP_MASTER WITH (NOLOCK)")
od = load(tc, "SELECT LOOKUP_TYPE, COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL GROUP BY LOOKUP_TYPE")
md = load(ac, "SELECT LOOKUP_TYPE, COUNT(*) FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) GROUP BY LOOKUP_TYPE")
oc = load(tc, "SELECT LOOKUP_TYPE_CODE, COUNT(*) FROM SCM_CODE_LOOKUP_VALUE GROUP BY LOOKUP_TYPE_CODE")
mc = load(ac, "SELECT LOOKUP_TYPE_CODE, COUNT(*) FROM dbo.SCM_CODE_LOOKUP_VALUE WITH (NOLOCK) GROUP BY LOOKUP_TYPE_CODE")
grp = {k for k, v in om.items() if v[0] == 'SSP'} | {k for k, v in mm.items() if v[0] == 'SSP'}
used = set(tu) | set(au)
allk = grp | used
rows = []
for k in sorted(allk):
    where = [x for x, d in (('ADM', k in om or k in mm or k in od or k in md), ('CODE', k in oc or k in mc)) if d]
    rows.append([k, 'Y' if k in grp else '', (om.get(k) or ('',))[0], (mm.get(k) or ('',))[0], '/'.join(where) or '어느 테이블에도 없음',
                 len(tu.get(k, ())), len(au.get(k, ())), od.get(k, (0,))[0], md.get(k, (0,))[0], oc.get(k, (0,))[0], mc.get(k, (0,))[0],
                 ' '.join(sorted(tu.get(k, ()))[:4]), ' '.join(sorted(au.get(k, ()))[:4])])
with io.open(os.path.join(OUT, 'ssp_lookup_target.csv'), 'w', encoding='utf-8-sig', newline='') as f:
    w = csv.writer(f); w.writerow(['LOOKUP_TYPE', 'SSP그룹', 'TOBE그룹', 'ASIS그룹', '테이블', 'TOBE참조객체수', 'ASIS참조객체수', 'TOBE상세', 'ASIS상세', 'TOBE_CODE', 'ASIS_CODE', 'TOBE객체예', 'ASIS객체예']); w.writerows(rows)
print('대상 후보', len(allk), '· SSP 그룹', len(grp), '· 소스 참조', len(used), '· 그룹이면서 소스 참조', len(grp & used), '· 그룹인데 소스 참조 없음', len(grp - used), '· 소스 참조인데 그룹 아님', len(used - grp))
print('\n[소스 참조인데 SSP 그룹 아님]  유형 | TO-BE 그룹 | AS-IS 그룹 | 테이블 | 참조 TO-BE/AS-IS | 상세 TO-BE/AS-IS | CODE TO-BE/AS-IS')
for r in rows:
    if not r[1]: print(f'  {r[0]:34s} | {r[2]:7s} | {r[3]:7s} | {r[4]:10s} | {r[5]}/{r[6]} | {r[7]}/{r[8]} | {r[9]}/{r[10]}')
print('\n[SSP 그룹 · 상세 건수 다름]')
for r in rows:
    if r[1] and r[7] != r[8]: print(f'  {r[0]:34s} 상세 TO-BE {r[7]} · AS-IS {r[8]} · 그룹 {r[2]}/{r[3]}')
t.close(); a.close()
