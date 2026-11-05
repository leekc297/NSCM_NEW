import sys, re, os
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn"); sys.path.insert(0, '.')
import dbconn, oneq_blocks as OB, oneq_split as SP
cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor()
def prep(sql):
    sql = sql.strip().rstrip(';')
    sql = re.sub(r'/\*[^+].*?\*/', '', sql, flags=re.S); sql = re.sub(r'--[^\n]*', '', sql)
    parts = re.split(r"('(?:[^']|'')*')", sql)
    for i in range(0, len(parts), 2):
        parts[i] = re.sub(r'\bp_division_id\b', "'40'", parts[i])
        parts[i] = re.sub(r'\b(p_[a-z_]+|V_[A-Z_]+|VA_[A-Z_]+)\b', "'X'", parts[i])
    return ''.join(parts)
def xplan(tag, sql, grep=None):
    c.execute("DELETE FROM PLAN_TABLE"); c.execute('EXPLAIN PLAN FOR ' + prep(sql))
    c.execute("SELECT ID, PARENT_ID, LPAD(' ',DEPTH)||OPERATION||' '||NVL(OPTIONS,'')||' '||NVL(OBJECT_NAME,''), CARDINALITY, COST FROM PLAN_TABLE ORDER BY ID")
    rows = c.fetchall(); print('==', tag, 'rows', len(rows))
    for r in rows:
        line = f"{r[0]:4d} p{r[1] if r[1] is not None else -1:4d} {r[2][:95]:95s} card={r[3]} cost={r[4]}"
        if grep is None or re.search(grep, line): print(line)
mode = sys.argv[1] if len(sys.argv) > 1 else 'cur'
if mode == 'nohint': OB.A9_HINT = ""
loads, ins = SP.split_s2(OB.s2_fcst_n_price_current('40'))
xplan('S2-CUR-40 ' + mode, ins)
cx.rollback()
