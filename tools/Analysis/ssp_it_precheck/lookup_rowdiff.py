# -*- coding: utf-8 -*-
"""SSP LOOKUP 대상 행 단위 비교(AS-IS 개발 MSSQL ↔ ZIOUI1 · 읽기 전용) — 키 · 값 차이 유형을 세어 이관 변환 규칙을 정한다
  python -u lookup_rowdiff.py <ssp_lookup_target.csv>"""
import sys, io, csv, collections, datetime
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
rows = list(csv.DictReader(io.open(sys.argv[1], encoding='utf-8-sig')))
A = [r['LOOKUP_TYPE'] for r in rows if r['SSP그룹'] == 'Y']
B = [r['LOOKUP_TYPE'] for r in rows if r['SSP그룹'] != 'Y' and 'ADM' in r['테이블']]
C = [r['LOOKUP_TYPE'] for r in rows if 'CODE' in r['테이블']]
print('A SSP 그룹', len(A), '· B 그룹 밖 ADM', len(B), '· C CODE', len(C))
t = dbconn.connect('tobe'); tc = t.cursor(); a = dbconn.connect('asis'); a.timeout = 300; ac = a.cursor()
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('TO-BE ZIOUI1', tc.fetchone()[0])
def cols(tb):
    tc.execute("SELECT column_name, data_type FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name=:t ORDER BY column_id", t=tb); return tc.fetchall()
def fetch(cur, sql, keys, n):
    out = {}
    for i in range(0, len(keys), 200):
        ch = keys[i:i + 200]
        if cur is tc: cur.execute(sql.format(','.join(':%d' % (j + 1) for j in range(len(ch)))), ch)
        else: cur.execute(sql.format(','.join('?' * len(ch))), ch)
        for r in cur.fetchall(): out[tuple(r[:n])] = tuple(r)
    return out
def cls(m, o):
    if m == o: return None
    if isinstance(m, datetime.datetime) or isinstance(o, datetime.datetime):
        if m is None or o is None: return '일시 한쪽 NULL'
        return '일시 같음(초 미만 차이)' if m.replace(microsecond=0) == o.replace(microsecond=0) else '일시 다름'
    ms = None if m is None else str(m)
    os_ = None if o is None else str(o)
    if ms == os_: return None
    if ms in (None, '') and os_ is None: return None
    if ms == '' and os_ in ('-', '/'): return "AS-IS '' ↔ TO-BE '%s'" % os_
    if ms is None and os_ in ('-', '/'): return "AS-IS NULL ↔ TO-BE '%s'" % os_
    if ms is not None and os_ is not None and ms.rstrip() == os_.rstrip(): return '뒤 공백 차이'
    if ms is not None and os_ is not None and ms.strip() == '' : return "AS-IS 공백 ↔ TO-BE '%s'" % os_[:3]
    try:
        if float(ms) == float(os_): return None
    except Exception: pass
    return '값 다름'
def keynorm(k, sent):
    return tuple((sent if (x is None or str(x) == '') else str(x)) for x in k)
def run(name, tb, keycol, keys, sent, nkey):
    cs = cols(tb); cn = [c for c, _ in cs]; kc = [c for c in cn if c == keycol or c.startswith('SEGMENT')][:nkey]
    oth = [c for c in cn if c not in kc]; sel = ', '.join(kc + oth)
    o = fetch(tc, f"SELECT {sel} FROM {tb} WHERE {keycol} IN ({{}})", keys, len(kc))
    m = fetch(ac, f"SELECT {sel} FROM dbo.{tb} WITH (NOLOCK) WHERE {keycol} IN ({{}})", keys, len(kc))
    kinds = collections.Counter()
    for k in m:
        for x in k:
            if x is None: kinds['AS-IS 키 NULL'] += 1
            elif str(x) == '': kinds["AS-IS 키 ''"] += 1
            elif str(x) != str(x).rstrip(): kinds['AS-IS 키 뒤 공백'] += 1
    mn = {keynorm(k, sent): v for k, v in m.items()}; on = {tuple(str(x) for x in k): v for k, v in o.items()}
    both = set(mn) & set(on); om_ = sorted(set(mn) - set(on)); oo = sorted(set(on) - set(mn))
    print(f'\n===== {name} · {tb} · 유형 {len(keys)} · AS-IS {len(m)}행 · TO-BE {len(o)}행 · 키 일치 {len(both)} · AS-IS 에만 {len(om_)} · TO-BE 에만 {len(oo)} · 키 정규화 뒤 AS-IS 중복 {len(m) - len(mn)}')
    print('  AS-IS 키 값 모양', dict(kinds))
    for k in om_[:8]: print('    AS-IS 에만', k)
    for k in oo[:12]: print('    TO-BE 에만', k)
    dc = collections.Counter(); ex = {}; rowdiff = 0; bytype = collections.Counter()
    for k in both:
        d = False
        for i, c in enumerate(kc + oth):
            if i < len(kc): continue
            x = cls(mn[k][i], on[k][i])
            if x:
                dc[(c if not c.startswith('ATTRIBUTE') else 'ATTRIBUTE*', x)] += 1; ex.setdefault((c if not c.startswith('ATTRIBUTE') else 'ATTRIBUTE*', x), (k, mn[k][i], on[k][i]))
                if x in ('값 다름', '일시 다름') and c not in ('CREATION_DATE', 'LAST_UPDATE_DATE', 'CREATED_BY', 'LAST_UPDATED_BY', 'CREATE_DATE', 'MODIFY_DATE', 'CREATE_USER_ID', 'MODIFY_USER_ID'): d = True
        if d: rowdiff += 1; bytype[k[0]] += 1
    print('  업무 값이 다른 행(작성자 · 일시 제외)', rowdiff, '· 유형별', dict(bytype.most_common(12)))
    for (c, x), n in sorted(dc.items(), key=lambda z: -z[1])[:24]: print(f'    {c:18s} {x:28s} {n:5d}  예 {str(ex[(c, x)])[:150]}')
    # 길이 초과 · 특수 문자
    lim = {}
    tc.execute("SELECT column_name, char_length FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name=:t AND data_type='VARCHAR2'", t=tb); lim = dict(tc.fetchall())
    over = collections.Counter(); sp = collections.Counter()
    for k, v in m.items():
        for i, c in enumerate(kc + oth):
            x = v[i]
            if isinstance(x, str):
                if c in lim and len(x.encode('utf-8')) > lim[c] and len(x) <= lim[c]: over[c + ' 바이트만 초과'] += 1
                if c in lim and len(x) > lim[c]: over[c + ' 글자 수 초과'] += 1
                for ch, nm in (("'", '작은따옴표'), ('&', '&'), ('\n', '줄바꿈'), ('\r', 'CR'), ('\t', '탭'), (';', ';'), ('?', '?')):
                    if ch in x: sp[nm] += 1
                if any(ord(z) > 127 for z in x): sp['한글 등 비ASCII'] += 1
    print('  길이 초과', dict(over), '· 특수 문자 든 값', dict(sp))
tc.execute("SELECT column_name, char_used FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name IN ('SCM_ADM_LOOKUP_MASTER_DETAIL','SCM_CODE_LOOKUP_VALUE') AND data_type='VARCHAR2' AND ROWNUM <= 3"); print('길이 단위(C = 글자 · B = 바이트)', tc.fetchall())
run('A 마스터', 'SCM_ADM_LOOKUP_MASTER', 'LOOKUP_TYPE', A, '-', 1)
run('A 상세', 'SCM_ADM_LOOKUP_MASTER_DETAIL', 'LOOKUP_TYPE', A, '-', 6)
run('B 마스터', 'SCM_ADM_LOOKUP_MASTER', 'LOOKUP_TYPE', B, '-', 1)
run('B 상세', 'SCM_ADM_LOOKUP_MASTER_DETAIL', 'LOOKUP_TYPE', B, '-', 6)
run('C CODE', 'SCM_CODE_LOOKUP_VALUE', 'LOOKUP_TYPE_CODE', C, '/', 6)
t.close(); a.close()
