import sys, re
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn"); sys.path.insert(0, '.')
import dbconn, oneq_blocks as B, oneq_2b as B2
sql = {'s2': B.s2_fcst_n_price_current, 's1': B.s1_site_item, '2b': B2.s2_fcst_n_price_all}[sys.argv[1]]()
sql = sql.strip().rstrip(';')
sql = re.sub(r'/\*.*?\*/', '', sql, flags=re.S)
sql = re.sub(r'--[^\n]*', '', sql)
# 따옴표 문자열 밖에서만 PL/SQL 변수 → 리터럴 치환
parts = re.split(r"('(?:[^']|'')*')", sql)
for i in range(0, len(parts), 2):
    parts[i] = re.sub(r'\b(p_[a-z_]+|V_[A-Z_]+|VA_[A-Z_]+)\b', "'X'", parts[i])
sql = ''.join(parts)
cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor()
try:
    c.execute('EXPLAIN PLAN FOR ' + sql); print('PARSE OK')
except Exception as e:
    msg = str(e); print(msg[:200])
    off = getattr(e.args[0], 'offset', None) if e.args else None
    print('offset', off)
    if off:
        print('...', sql[max(0, off - 400):off], '<<<HERE>>>', sql[off:off + 160])
cx.rollback()
