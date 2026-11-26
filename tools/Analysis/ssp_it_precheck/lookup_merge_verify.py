# -*- coding: utf-8 -*-
"""SSP LOOKUP 이관 로컬 검증 — 생성 쿼리 파일을 AS-IS 개발 MSSQL 에서 실행 → MERGE 문장을 ZIOUI1 에서 한 트랜잭션으로 실행
  → 실행 뒤 상태를 AS-IS(변환 규칙 적용)와 행 · 열 단위 대조 → ROLLBACK(사내 DB 변경 없음)
  python -u lookup_merge_verify.py <생성 쿼리 .sql> <MERGE 문장 저장 .sql>"""
import sys, io, re, datetime, collections
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
src = io.open(sys.argv[1], encoding='utf-8').read().replace('\r\n', '\n')
gen = src[src.index('-- [M2]'):]; gen = gen[gen.index('SELECT X.SQL_TEXT'):].rstrip().rstrip(';')
m1 = src[src.index('-- [M1]'):src.index('-- [M3]')]; m1 = m1[m1.index('SELECT'):m1.rindex(';')]
lint = [x for x in ('?', '&') if x in src]; print('생성 파일 금지 문자', lint, '· 빈 줄 든 문장', '\n\n' in gen)
a = dbconn.connect('asis'); a.timeout = 300; ac = a.cursor()
ac.execute("SELECT DB_NAME(), CONVERT(VARCHAR(19), GETDATE(), 120), CONVERT(VARCHAR(100), DATABASEPROPERTYEX(DB_NAME(), 'Collation'))"); print('AS-IS', tuple(ac.fetchone()))
ac.execute(m1); mc, dc = ac.fetchone(); print('[M1] MASTER_CNT', mc, '· DETAIL_CNT', dc)
t0 = datetime.datetime.now(); ac.execute(gen); rows = [r[0] for r in ac.fetchall()]; print('[M2] 결과 행', len(rows), '· NULL 행', sum(1 for r in rows if r is None), '· 걸린 시간', (datetime.datetime.now() - t0).total_seconds(), '초 · 최대 길이', max(len(r) for r in rows))
bad = [r for r in rows if r and re.search(r"[?&:\r\n\t]", r)]; print('  문장 안 ? & : 줄바꿈 탭 남은 행', len(bad))
io.open(sys.argv[2], 'w', encoding='utf-8', newline='\n').write('\n'.join(rows) + '\n')
t = dbconn.connect('tobe'); t.autocommit = False; tc = t.cursor()
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('TO-BE ZIOUI1', tc.fetchone()[0])
cnt = "SELECT (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_GROUP = 'SSP'), (SELECT COUNT(*) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE IN (SELECT LOOKUP_TYPE FROM SCM_ADM_LOOKUP_MASTER WHERE LOOKUP_GROUP = 'SSP'))"
tc.execute(cnt); print('실행 전 TO-BE 마스터 · 상세', tc.fetchone())
err = collections.Counter(); ex = {}; ok = 0; t0 = datetime.datetime.now()
try:
    for r in rows:
        try: tc.execute(r.rstrip().rstrip(';')); ok += tc.rowcount
        except Exception as e:
            k = str(e).split('\n')[0][:90]; err[k] += 1; ex.setdefault(k, r[:300])
    print('MERGE 실행', len(rows), '문장 · 반영 행', ok, '· 오류', sum(err.values()), '· 걸린 시간', (datetime.datetime.now() - t0).total_seconds(), '초')
    for k, n in err.items(): print('  ERR', n, k, '\n     ', ex[k])
    tc.execute(cnt); print('실행 뒤 TO-BE 마스터 · 상세 (트랜잭션 안)', tc.fetchone())
    # 대조 : AS-IS 원본에 변환 규칙 적용한 값 ↔ 실행 뒤 TO-BE
    def norm(c, v, detail, iskey):
        if isinstance(v, datetime.datetime): return v.replace(microsecond=0)
        if v is None: return '/' if (detail and c == 'VALID_YN') else None
        if not isinstance(v, str): return int(v)
        if c.startswith('SEGMENT') and v == '': return '-'
        if c.startswith('ATTRIBUTE') and v == '': return ' '
        if c == 'VALID_YN': return (v.upper() or ('/' if detail else None))
        return None if v == '' else v
    for tb, nk, detail in (('SCM_ADM_LOOKUP_MASTER', 1, False), ('SCM_ADM_LOOKUP_MASTER_DETAIL', 6, True)):
        tc.execute("SELECT column_name FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name=:t ORDER BY column_id", t=tb); cn = [r[0] for r in tc.fetchall()]
        kc = ['LOOKUP_TYPE'] + (['SEGMENT%d' % i for i in range(1, 6)] if detail else [])
        w = " WHERE LOOKUP_TYPE IN (SELECT LOOKUP_TYPE FROM {p}SCM_ADM_LOOKUP_MASTER{h} WHERE LOOKUP_GROUP = 'SSP')"
        ac.execute(f"SELECT {', '.join(cn)} FROM dbo.{tb} WITH (NOLOCK)" + w.format(p='dbo.', h=' WITH (NOLOCK)'))
        exp = {}
        for r in ac.fetchall():
            if detail and r[0] == 'IF_STOCK_CHECK': continue   # 생성 쿼리에서 제외한 유형
            v = [norm(c, r[i], detail, c in kc) for i, c in enumerate(cn)]; exp[tuple(v[cn.index(k)] for k in kc)] = v
        tc.execute(f"SELECT {', '.join(cn)} FROM {tb}" + w.format(p='', h=''))
        got = {}
        for r in tc.fetchall():
            if detail and r[0] == 'IF_STOCK_CHECK': continue
            v = [(x.replace(microsecond=0) if isinstance(x, datetime.datetime) else (int(x) if isinstance(x, (int, float)) else x)) for x in r]; got[tuple(v[cn.index(k)] for k in kc)] = v
        miss = [k for k in exp if k not in got]; extra = [k for k in got if k not in exp]
        diff = collections.Counter(); dx = {}
        for k in exp:
            if k in got:
                for i, c in enumerate(cn):
                    if exp[k][i] != got[k][i]: diff[c] += 1; dx.setdefault(c, (k, exp[k][i], got[k][i]))
        print(f'  대조 {tb} : AS-IS {len(exp)} · TO-BE {len(got)} · AS-IS 에 있는데 TO-BE 에 없음 {len(miss)} · TO-BE 에만 {len(extra)} · 값 다른 칸 {sum(diff.values())}')
        for k in extra[:10]: print('     TO-BE 에만', k)
        for c, n in diff.items(): print('     값 다름', c, n, str(dx[c])[:200])
finally:
    t.rollback(); tc.execute(cnt); print('ROLLBACK 뒤 TO-BE 마스터 · 상세', tc.fetchone())
    t.close(); a.close()
