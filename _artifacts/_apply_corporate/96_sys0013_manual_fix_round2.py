"""SYS0013 manual fix Round 2/3 — CONVERT(DATETIME) 자동 + DQ 110 CHANGE_REASON 제거 + 잔존 row.

대상:
  - CONVERT(DATETIME, expr, 112) MSSQL → Oracle TO_DATE(expr, 'YYYYMMDD') — DQ 99 등
  - DQ 110 SCM_MST_SITE_ITEM_H 에 CHANGE_REASON 컬럼 부재 → 'N/A' 리터럴로 대체
  - 잔존 DQ 16/46 분석 + 가능 시 fix

검증: 각 row 별 SP wrapper 호출 → PASS 확인.
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

# fmt 코드 → Oracle TO_CHAR/TO_DATE format
FMT_MAP = {
    '101': 'MM/DD/YYYY', '102': 'YYYY.MM.DD', '103': 'DD/MM/YYYY',
    '104': 'DD.MM.YYYY', '105': 'DD-MM-YYYY', '111': 'YYYY/MM/DD',
    '112': 'YYYYMMDD',
    '120': 'YYYY-MM-DD HH24:MI:SS', '121': 'YYYY-MM-DD HH24:MI:SS',
    '23': 'YYYY-MM-DD',
}

# CONVERT(DATETIME, expr[, fmt]) → TO_DATE(expr, '<fmt>')
CONVERT_DATETIME_RE = re.compile(
    r'CONVERT\s*\(\s*DATETIME\s*,\s*([^,()]+(?:\([^)]*\))?[^,()]*)\s*(?:,\s*(\d+))?\s*\)',
    re.IGNORECASE,
)

def fix_convert_datetime(sql: str) -> tuple[str, int]:
    def _sub(m: re.Match) -> str:
        expr = m.group(1).strip()
        code = m.group(2)
        if code and code in FMT_MAP:
            return f"TO_DATE({expr}, '{FMT_MAP[code]}')"
        return f"TO_DATE({expr})"
    return CONVERT_DATETIME_RE.subn(_sub, sql)

# DQ 110 CHANGE_REASON 컬럼 부재 → 'N/A' AS CHANGE_REASON 리터럴 대체.
def fix_dq110_change_reason(sql: str) -> tuple[str, int]:
    # 정확 패턴: "\n, CHANGE_REASON\n" 또는 ", CHANGE_REASON," (column list 안).
    new = re.sub(
        r"(,\s*)CHANGE_REASON(\s*[,\n])",
        lambda m: f"{m.group(1)}'N/A' AS CHANGE_REASON{m.group(2)}",
        sql,
        flags=re.IGNORECASE,
    )
    return new, 1 if new != sql else 0

upd = conn.cursor()
upd.setinputsizes(new_text=oracledb.CLOB)

# --- Round 2: CONVERT(DATETIME) 전수 적용 (영향 row 자동 검출) ---
print('\n[ ROUND 2 ] CONVERT(DATETIME) 룰 전수 적용:')
cur.execute('SELECT DQ_ID, DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST ORDER BY DQ_ID')
all_rows = [(r[0], r[1].read() if isinstance(r[1], oracledb.LOB) else r[1]) for r in cur]
affected = 0
for dq_id, sql in all_rows:
    if not sql:
        continue
    new_sql, n = fix_convert_datetime(sql)
    if n > 0:
        upd.execute(
            "UPDATE SCM_MGR.SCM_ADM_DQ_LIST SET DQ_TEXT=:new_text, "
            "LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE DQ_ID=:id",
            new_text=new_sql, id=dq_id,
        )
        affected += 1
        print(f'  DQ_ID={dq_id} CONVERT(DATETIME)={n}')
conn.commit()
print(f'  총 affected row: {affected}')

# --- Round 3: DQ 110 CHANGE_REASON 리터럴 대체 ---
print('\n[ ROUND 3 ] DQ 110 CHANGE_REASON 리터럴 대체:')
cur.execute('SELECT DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST WHERE DQ_ID=110')
sql = cur.fetchone()[0].read()
new_sql, n = fix_dq110_change_reason(sql)
if n > 0:
    upd.execute(
        "UPDATE SCM_MGR.SCM_ADM_DQ_LIST SET DQ_TEXT=:new_text, "
        "LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE WHERE DQ_ID=110",
        new_text=new_sql,
    )
    conn.commit()
    print(f'  DQ_ID=110 CHANGE_REASON → \'N/A\' 리터럴 ({n})')
else:
    print(f'  DQ_ID=110 NO_CHANGE')

# --- VERIFY 직전 fix 영향 row + 잔존 분석 row ---
verify_ids = [99, 110, 16, 46]
print(f'\n[ VERIFY ] SP wrapper 호출 ({len(verify_ids)} row):')
for dq_id in verify_ids:
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
        codes = [f'ORA-{c}' for c in re.findall(r'ORA-(\d{5})', msg) if c != '20001']
        code = codes[0] if codes else 'ORA-?????'
        m2 = re.search(r'SQLERRM=([^/]+)', msg)
        errmsg = m2.group(1).strip()[:80] if m2 else msg[:80]
        print(f'  ❌ DQ_ID={dq_id} {code}: {errmsg}')
    finally:
        rc1.close(); rs.close()

conn.close()
print('\n[ done ] Round 2/3.')
