# -*- coding: utf-8 -*-
"""프로그램이 값을 바꾸는 LOOKUP 유형 찾기(운영 상태 값) — TO-BE · AS-IS 소스에서 LOOKUP 테이블 변경 문장과 그 안의 유형(읽기 전용)
  python -u lookup_writers.py <ssp_lookup_target.csv>"""
import sys, re, io, csv, collections
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
tg = {r['LOOKUP_TYPE']: r for r in csv.DictReader(io.open(sys.argv[1], encoding='utf-8-sig'))}
t = dbconn.connect('tobe'); tc = t.cursor(); a = dbconn.connect('asis'); a.timeout = 300; ac = a.cursor()
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('TO-BE ZIOUI1', tc.fetchone()[0])
TB = r'(SCM_ADM_LOOKUP_MASTER_DETAIL|SCM_ADM_LOOKUP_MASTER|SCM_CODE_LOOKUP_VALUE)'
DML = re.compile(r'\b(UPDATE|INSERT\s+INTO|MERGE\s+INTO|DELETE\s+FROM|DELETE)\s+(?:\[?dbo\]?\.)?\[?' + TB + r'\]?\b(.{0,1500})', re.I | re.S)
def strip(s):
    s = re.sub(r'/\*.*?\*/', ' ', s, flags=re.S); return re.sub(r'--[^\n]*', ' ', s)
def scan(name, s, res):
    for m in DML.finditer(strip(s)):
        body = m.group(3); end = body.find(';'); body = body[:end] if 0 <= end else body[:700]
        ty = set(re.findall(r"LOOKUP_TYPE(?:_CODE)?\s*=\s*N?'([A-Z0-9_]+)'", body, re.I)) or set(re.findall(r"'([A-Z][A-Z0-9_]{5,})'", body))
        for x in (ty or {'(유형 변수)'}): res[x.upper()].add((name, m.group(1).upper().split()[0], m.group(2).upper()))
ro = collections.defaultdict(set); ra = collections.defaultdict(set)
tc.execute("SELECT DISTINCT name, type FROM all_source WHERE owner='SCM_MGR' AND type IN ('PROCEDURE','FUNCTION','PACKAGE BODY','TRIGGER') AND (UPPER(text) LIKE '%SCM_ADM_LOOKUP_MASTER%' OR UPPER(text) LIKE '%SCM_CODE_LOOKUP_VALUE%')")
objs = tc.fetchall()
for n, ty in objs:
    tc.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", n=n, t=ty); scan(n, ''.join(r[0] for r in tc.fetchall()), ro)
ac.execute("SELECT o.name, m.definition FROM sys.sql_modules m JOIN sys.objects o ON o.object_id = m.object_id WHERE m.definition LIKE '%SCM_ADM_LOOKUP_MASTER%' OR m.definition LIKE '%SCM_CODE_LOOKUP_VALUE%'")
na = 0
for n, df in ac.fetchall(): na += 1; scan(n, df or '', ra)
print('LOOKUP 테이블을 쓰는 객체 수 : TO-BE 조사', len(objs), '· AS-IS 조사', na)
print('\n[프로그램이 바꾸는 유형]  유형 | 대상 여부(SSP그룹/그룹 밖) | TO-BE 객체 | AS-IS 객체')
for k in sorted(set(ro) | set(ra)):
    r = tg.get(k); mark = ('A' if r and r['SSP그룹'] == 'Y' else ('B/C' if r else '-'))
    print(f'  {k:32s} | {mark:3s} | {sorted({(x[0], x[1]) for x in ro.get(k, ())})[:4]} | {sorted({(x[0], x[1]) for x in ra.get(k, ())})[:4]}'[:300])
t.close(); a.close()
