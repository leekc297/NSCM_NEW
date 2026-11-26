# -*- coding: utf-8 -*-
"""SSP LOOKUP 대상 조사 1단계 — 테이블 구조 · LOOKUP 을 읽는 함수 · SSP 프로그램이 쓰는 LOOKUP_TYPE (읽기 전용)
  python -u lookup_scan.py <출력 폴더>"""
import sys, os, re, io, csv, collections
sys.stdout.reconfigure(encoding='utf-8')
sys.path.insert(0, r'c:\Projects\NSCM\tools\DbConn')
import dbconn
OUT = sys.argv[1]; os.makedirs(OUT, exist_ok=True)
t = dbconn.connect('tobe'); tc = t.cursor(); a = dbconn.connect('asis'); a.timeout = 120; ac = a.cursor()
tc.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL"); print('TO-BE ZIOUI1', tc.fetchone()[0])
ac.execute("SELECT DB_NAME(), CONVERT(VARCHAR(19), GETDATE(), 120)"); print('AS-IS', tuple(ac.fetchone()))
# 1) LOOKUP 계열 테이블
tc.execute("SELECT table_name, num_rows FROM all_tables WHERE owner='SCM_MGR' AND table_name LIKE '%LOOKUP%' AND table_name NOT LIKE '%BAK%' AND table_name NOT LIKE '%BK%' ORDER BY 1"); print('TO-BE LOOKUP 테이블', tc.fetchall())
tc.execute("SELECT synonym_name, table_owner, table_name FROM all_synonyms WHERE owner='SCM_MGR' AND synonym_name LIKE '%LOOKUP%'"); print('TO-BE LOOKUP 시노님', tc.fetchall())
ac.execute("SELECT o.name, o.type_desc, (SELECT SUM(p.rows) FROM sys.partitions p WHERE p.object_id = o.object_id AND p.index_id IN (0,1)) FROM sys.objects o WHERE o.name LIKE '%LOOKUP%' AND o.type IN ('U','V','SN') AND o.name NOT LIKE '%BAK%' AND o.name NOT LIKE '%BK%' ORDER BY 1"); print('AS-IS LOOKUP 객체', [tuple(r) for r in ac.fetchall()])
for tb in ('SCM_ADM_LOOKUP_MASTER', 'SCM_ADM_LOOKUP_MASTER_DETAIL', 'SCM_CODE_LOOKUP_VALUE', 'SCM_CODE_LOOKUP_TYPE'):
    tc.execute("SELECT column_name, data_type, char_length, nullable, data_default FROM all_tab_columns WHERE owner='SCM_MGR' AND table_name=:t ORDER BY column_id", t=tb); o = tc.fetchall()
    ac.execute("SELECT c.name, ty.name, c.max_length, c.is_nullable FROM sys.columns c JOIN sys.types ty ON ty.user_type_id = c.user_type_id WHERE c.object_id = OBJECT_ID('dbo.' + ?) ORDER BY c.column_id", tb); m = {r[0].upper(): r for r in ac.fetchall()}
    print(f'\n##### {tb} · TO-BE 열 {len(o)} · AS-IS 열 {len(m)}')
    for c, ty, ln, nl, df in o:
        x = m.get(c); print(f'  {c:22s} O:{ty}({ln}) {"NOT NULL" if nl == "N" else "null"} default={str(df).strip()[:14] if df else "-"} | M:{(x[1] + "(" + str(x[2]) + ") " + ("null" if x[3] else "NOT NULL")) if x else "없음"}')
    print('  AS-IS 에만 있는 열', sorted(set(m) - {c for c, *_ in o}))
    tc.execute("""SELECT c.constraint_type, c.constraint_name, LISTAGG(cc.column_name, ',') WITHIN GROUP (ORDER BY cc.position) FROM all_constraints c, all_cons_columns cc
                   WHERE cc.owner = c.owner AND cc.constraint_name = c.constraint_name AND c.owner='SCM_MGR' AND c.table_name=:t AND c.constraint_type IN ('P','U') GROUP BY c.constraint_type, c.constraint_name""", t=tb); print('  TO-BE PK·UK', tc.fetchall())
    tc.execute("SELECT i.index_name, i.uniqueness, LISTAGG(ic.column_name, ',') WITHIN GROUP (ORDER BY ic.column_position) FROM all_indexes i, all_ind_columns ic WHERE ic.index_owner = i.owner AND ic.index_name = i.index_name AND i.owner='SCM_MGR' AND i.table_name=:t GROUP BY i.index_name, i.uniqueness", t=tb); print('  TO-BE 인덱스', tc.fetchall())
    ac.execute("SELECT i.name, i.is_unique, i.is_primary_key, STUFF((SELECT ',' + c.name FROM sys.index_columns ic JOIN sys.columns c ON c.object_id = ic.object_id AND c.column_id = ic.column_id WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 0 ORDER BY ic.key_ordinal FOR XML PATH('')), 1, 1, '') FROM sys.indexes i WHERE i.object_id = OBJECT_ID('dbo.' + ?) AND i.index_id > 0", tb); print('  AS-IS 인덱스', [tuple(r) for r in ac.fetchall()])
    try:
        tc.execute(f'SELECT COUNT(*) FROM {tb}'); n1 = tc.fetchone()[0]; ac.execute(f'SELECT COUNT(*) FROM dbo.{tb} WITH (NOLOCK)'); print('  건수 TO-BE', n1, '· AS-IS', ac.fetchone()[0])
    except Exception as e: print('  건수 ERR', str(e)[:120])
# 2) LOOKUP 을 읽는 함수
for fn in ('FN_GET_LOOKUP_VALUE', 'FN_LIST_LOOKUP_VALUE'):
    tc.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n ORDER BY line", n=fn); s = ''.join(r[0] for r in tc.fetchall())
    print(f'\n##### {fn} ({s.count(chr(10))}줄)'); print('\n'.join(l for l in s.split('\n') if re.search(r'FROM|WHERE|AND |LOOKUP|RETURN|IN ', l, re.I) and not l.strip().startswith(('*', '--')))[:1500])
tc.execute("SELECT name, type, COUNT(*) FROM all_source WHERE owner='SCM_MGR' AND (UPPER(text) LIKE '%SCM_ADM_LOOKUP_MASTER%' OR UPPER(text) LIKE '%SCM_CODE_LOOKUP_VALUE%' OR UPPER(text) LIKE '%FN_GET_LOOKUP_VALUE%' OR UPPER(text) LIKE '%FN_LIST_LOOKUP_VALUE%') GROUP BY name, type")
refs = tc.fetchall(); print('\nLOOKUP 을 참조하는 TO-BE 객체', len(refs), '· 그중 SSP 이름', sum(1 for r in refs if 'SSP' in r[0]))
t.close(); a.close()
