"""SYS0013 manual fix Round 1 — ORA-00907 (5 row).

대상:
  DQ 16/42/44/47 — STUFF((... FOR XML PATH('')), 1, 1, '') MSSQL GROUP_CONCAT 패턴
                    → Oracle LISTAGG(DISTINCT col, ',') WITHIN GROUP (ORDER BY col)
  DQ 46         — CONVERT(FLOAT, expr) MSSQL CAST
                    → Oracle CAST(expr AS NUMBER)

검증:
  적용 후 각 row 별 SP wrapper 호출 → PASS 확인.
"""
from __future__ import annotations
import os, re, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)
u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

PARAM_RE = re.compile(r'[:@]PARAM[A-Z0-9_]*', re.IGNORECASE)

# STUFF MSSQL → Oracle LISTAGG.
STUFF_RE = re.compile(
    r"STUFF\s*\(\s*\(\s*select\s+distinct\s+',\s*'\s*\|\|\s*(?P<expr>.+?)\s+(?P<from>from\s+.+?)\s+FOR\s+XML\s+PATH\s*\(\s*''\s*\)\s*\)\s*,\s*1\s*,\s*1\s*,\s*''\s*\)",
    re.IGNORECASE | re.DOTALL,
)

def fix_stuff(sql: str) -> tuple[str, int]:
    """STUFF((SELECT distinct ',' || expr from ... FOR XML PATH('')), 1, 1, '')
       → (SELECT LISTAGG(DISTINCT expr, ',') WITHIN GROUP (ORDER BY expr) from ...)
    """
    def _sub(m: re.Match) -> str:
        expr = m.group('expr').strip()
        from_clause = m.group('from').strip()
        # Oracle 19c LISTAGG(DISTINCT) 지원.
        return f"(SELECT LISTAGG(DISTINCT {expr}, ',') WITHIN GROUP (ORDER BY {expr}) {from_clause})"
    return STUFF_RE.subn(_sub, sql)

# CONVERT(FLOAT, expr) → CAST(expr AS NUMBER).
CONVERT_FLOAT_RE = re.compile(
    r'CONVERT\s*\(\s*FLOAT\s*,\s*([^()]+(?:\([^)]*\))?[^()]*)\s*\)',
    re.IGNORECASE,
)
def fix_convert_float(sql: str) -> tuple[str, int]:
    def _sub(m: re.Match) -> str:
        return f'CAST({m.group(1).strip()} AS NUMBER)'
    return CONVERT_FLOAT_RE.subn(_sub, sql)

upd = conn.cursor()
upd.setinputsizes(new_text=oracledb.CLOB)

target_ids = [16, 42, 44, 46, 47]
print(f'\n[ ROUND 1 ] {len(target_ids)} row STUFF + CONVERT(FLOAT) fix:')
for dq_id in target_ids:
    cur.execute('SELECT DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST WHERE DQ_ID=:id', id=dq_id)
    sql = cur.fetchone()[0].read()
    new_sql, n_stuff = fix_stuff(sql)
    new_sql, n_conv = fix_convert_float(new_sql)
    if new_sql == sql:
        print(f'  DQ_ID={dq_id} NO_CHANGE — pattern 매칭 안 됨')
        continue
    upd.execute(
        "UPDATE SCM_MGR.SCM_ADM_DQ_LIST SET DQ_TEXT=:new_text, "
        "LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE DQ_ID=:id",
        new_text=new_sql, id=dq_id,
    )
    print(f'  DQ_ID={dq_id} STUFF={n_stuff} CONVERT_FLOAT={n_conv} length: {len(sql)} → {len(new_sql)}')
conn.commit()

# Verify
print(f'\n[ VERIFY ] SP wrapper 호출:')
for dq_id in target_ids:
    cur.execute('SELECT DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST WHERE DQ_ID=:id', id=dq_id)
    sql = cur.fetchone()[0].read()
    sql_repl = PARAM_RE.sub("''", sql)
    rc1 = conn.cursor(); rs = conn.cursor()
    try:
        cur.callproc('SCM_MGR.PKG_SYS0013.P_SYS0013_EXECUTE_QUERY', [sql_repl, rc1, rs])
        cols = [c[0] for c in (rc1.description or [])]
        print(f'  ✅ DQ_ID={dq_id} PASS cols={len(cols)}')
    except Exception as e:
        msg = str(e)
        m = re.search(r'ORA-(\d{5})', msg)
        codes = [f'ORA-{c}' for c in re.findall(r'ORA-(\d{5})', msg) if c != '20001']
        code = codes[0] if codes else 'ORA-?????'
        m2 = re.search(r'SQLERRM=([^/]+)', msg)
        errmsg = m2.group(1).strip()[:80] if m2 else msg[:80]
        print(f'  ❌ DQ_ID={dq_id} {code}: {errmsg}')
    finally:
        rc1.close(); rs.close()

conn.close()
print('\n[ done ] Round 1.')
