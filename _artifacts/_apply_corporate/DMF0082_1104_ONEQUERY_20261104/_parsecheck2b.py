import sys, re
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn"); sys.path.insert(0, '.')
import dbconn, oneq_2b as B2, oneq_split as SP
cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor()
def prep(sql):
    sql = sql.strip().rstrip(';')
    sql = re.sub(r'/\*.*?\*/', '', sql, flags=re.S); sql = re.sub(r'--[^\n]*', '', sql)
    parts = re.split(r"('(?:[^']|'')*')", sql)
    for i in range(0, len(parts), 2):
        parts[i] = re.sub(r'\bVL\.VERSION_NO\b', "'X'", parts[i])
        parts[i] = re.sub(r'\b(p_[a-z_]+|V_[A-Z_]+|VA_[A-Z_]+)\b', "'X'", parts[i])
    return ''.join(parts)
def check(tag, sql):
    try:
        c.execute('EXPLAIN PLAN FOR ' + prep(sql)); print(tag, 'PARSE OK')
    except Exception as e:
        msg = str(e); off = getattr(e.args[0], 'offset', None) if e.args else None
        s = prep(sql); print(tag, msg[:160], 'offset', off)
        if off: print('...', s[max(0, off - 300):off], '<<<HERE>>>', s[off:off + 120])
for d in ('81', '82', '40'):
    loads, ins = SP.split_s2(B2.s2_fcst_n_price_all(d))
    check(f'S2-ALL-{d}', ins)
    if d == '81':
        for stmt in [x for x in loads.split(';\n') if 'INSERT INTO' in x]:
            g = re.search(r'INSERT INTO (\S+)', stmt).group(1)
            check('load ' + g, stmt[stmt.index('INSERT INTO'):])
cx.rollback()
