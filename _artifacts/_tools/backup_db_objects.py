import sys, os, io, re
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_tools')
from make_cloud_package_full import conn_info, lit
import oracledb

OUT = r'C:\Projects\NSCM\_artifacts\_backup\DMF0020_PRE_CLOUD_UPDATE_20260824'
# ⛔ 기존 백업 폴더 덮어쓰기 금지 (2026-08-24 실사고: 이관 전 백업이 이관 후 내용으로 덮여 복구 불가)
if os.path.isdir(OUT) and os.listdir(OUT):
    raise SystemExit('중단: 백업 폴더가 이미 있고 비어있지 않다 -> ' + OUT)
for d in ('A_PKG', 'B_SP', 'C_WIRING', '_meta'):
    os.makedirs(os.path.join(OUT, d), exist_ok=True)

u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn); cur = con.cursor()
cur.execute("BEGIN DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',FALSE); END;")

def src(kind, name):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE""",
                {"n": name, "t": kind})
    rows = cur.fetchall()
    return ''.join(r[0] for r in rows) if rows else None

# 1) 대상 객체 목록
cur.execute("""SELECT OBJECT_TYPE, OBJECT_NAME, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
               FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME LIKE 'DMF0020%'
                 AND OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY')
               UNION ALL
               SELECT OBJECT_TYPE, OBJECT_NAME, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
               FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                 AND OBJECT_NAME IN ('PKG_DMF0020','P_DMF0020_GET_OWNER_DATA')
                 AND OBJECT_TYPE IN ('PROCEDURE','FUNCTION','PACKAGE','PACKAGE BODY')
               ORDER BY 1,2""")
objs = cur.fetchall()
seen, inv = set(), []
lines = ['| 유형 | 객체 | 상태 | LAST_DDL | 줄수 | 백업 파일 |', '|---|---|---|---|---:|---|']
for otype, name, status, ddl in objs:
    if (otype, name) in seen: continue
    seen.add((otype, name))
    body = src('PACKAGE BODY' if otype == 'PACKAGE BODY' else ('PACKAGE' if otype == 'PACKAGE' else otype), name)
    if body is None:
        lines.append('| %s | %s | %s | %s | - | (소스 없음) |' % (otype, name, status, ddl)); continue
    if otype == 'PACKAGE':      fn = os.path.join('A_PKG', name + '_SPEC.sql')
    elif otype == 'PACKAGE BODY': fn = os.path.join('A_PKG', name + '_BODY.sql')
    else:                        fn = os.path.join('B_SP', name + '.sql')
    hdr = '-- [BACKUP 2026-08-24] SCM_MGR.%s (%s, %s)\n-- 원본 LAST_DDL = %s\n\nCREATE OR REPLACE ' % (name, otype, status, ddl)
    io.open(os.path.join(OUT, fn), 'w', encoding='utf-8').write(hdr + body.rstrip() + '\n/\n')
    lines.append('| %s | `%s` | %s | %s | %d | `%s` |' % (otype, name, status, ddl, body.count('\n') + 1, fn.replace(os.sep, '/')))
    if status == 'INVALID': inv.append((otype, name))

# 2) INVALID 컴파일 오류
err = []
for otype, name in inv:
    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n
                   AND TYPE=:t ORDER BY SEQUENCE""", {"n": name, "t": otype})
    rows = cur.fetchall()
    err.append('==== %s %s (%d건)' % (otype, name, len(rows)))
    for l, pos, t in rows[:15]:
        err.append('   L%-6s C%-4s %s' % (l, pos, t.strip()))
io.open(os.path.join(OUT, '_meta', 'ALL_ERRORS.txt'), 'w', encoding='utf-8').write('\n'.join(err) + '\n')

# 3) 배선 스냅샷 (원복용 MERGE)
def dump(table, keys, where, fname):
    cur.execute("SELECT * FROM SCM_MGR.%s WHERE %s" % (table, where))
    cols = [c[0] for c in cur.description]; rows = cur.fetchall()
    out = ['-- [BACKUP 2026-08-24] SCM_MGR.%s — DMF0020 배선 원복용 (%d행)' % (table, len(rows)), '']
    for r in rows:
        v = dict(zip(cols, r))
        on = ' AND '.join("T.%s = %s" % (k, lit(v[k])) for k in keys)
        upd = ', '.join("T.%s = %s" % (c, lit(v[c])) for c in cols if c not in keys)
        out.append("MERGE INTO SCM_MGR.%s T\nUSING DUAL ON (%s)\nWHEN MATCHED THEN UPDATE SET %s\n"
                   "WHEN NOT MATCHED THEN INSERT (%s)\nVALUES (%s);" %
                   (table, on, upd, ', '.join(cols), ', '.join(lit(v[c]) for c in cols)))
    out.append('COMMIT;')
    io.open(os.path.join(OUT, 'C_WIRING', fname), 'w', encoding='utf-8').write('\n\n'.join(out) + '\n')
    return len(rows)

n1 = dump('SCM_ADM_API_M', ['API_ID'], "API_ID LIKE '%DMF0020%'", '01_API_M.sql')
n2 = dump('SCM_ADM_MNU_BTN_MPG_M', ['MNU_ID','SHT_NM','MNU_BTN_CD'], "MNU_ID LIKE 'DMF0020%'", '02_MNU_BTN_MPG_M.sql')
n3 = dump('SCM_ADM_PROC_M', ['PROC_NM','COL_NM','COL_TP_CD'], "PROC_NM LIKE '%DMF0020%'", '03_PROC_M.sql')

io.open(os.path.join(OUT, '_meta', 'OBJECT_LIST.md'), 'w', encoding='utf-8').write('\n'.join(lines) + '\n')
print('객체 %d본 백업 / INVALID %d본 / 배선 API %d · BTN %d · PROC %d' % (len(seen), len(inv), n1, n2, n3))
print('INVALID:', ', '.join('%s %s' % (t, n) for t, n in inv))
