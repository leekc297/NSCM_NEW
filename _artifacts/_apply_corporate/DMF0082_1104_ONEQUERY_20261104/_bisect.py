import sys, re
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn"); sys.path.insert(0, '.')
import dbconn, oneq_blocks as B
sql = B.s2_fcst_n_price_current().strip().rstrip(';')
sql = re.sub(r'/\*.*?\*/', '', sql, flags=re.S); sql = re.sub(r'--[^\n]*', '', sql)
parts = re.split(r"('(?:[^']|'')*')", sql)
for i in range(0, len(parts), 2):
    parts[i] = re.sub(r'\b(p_[a-z_]+|V_[A-Z_]+|VA_[A-Z_]+)\b', "'X'", parts[i])
sql = ''.join(parts)
w = sql.index('WITH ')
body = sql[w + 5:]
# 4칸 들여쓰기 CTE 경계: "\n    ), NAME AS (" / 첫 "NAME AS ("
bounds = [(m.start(), m.group(1)) for m in re.finditer(r'(?:^|\n    \), )(\w+) AS \(', body)]
names = [n for _, n in bounds]
print('CTEs', names)
cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor()
for k in range(1, len(bounds) + 1):
    end = bounds[k][0] if k < len(bounds) else body.rindex('\n    )') + 6
    seg = body[:end]
    if k < len(bounds): seg = seg + '\n    )'
    test = 'EXPLAIN PLAN FOR WITH ' + seg + f' SELECT * FROM {names[k-1]}'
    try:
        c.execute(test); print('OK ', names[k - 1])
    except Exception as e:
        print('ERR', names[k - 1], str(e)[:120]); break
cx.rollback()
