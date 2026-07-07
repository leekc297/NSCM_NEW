#!/usr/bin/env python3
"""SYS0001/msgMgmt SP 인벤토리 + body 추출 — 사용 테이블 확정."""
import re, pathlib, oracledb

ROOT = pathlib.Path(__file__).resolve().parents[2]
BE_CFG = ROOT / 'nscm-be' / 'src' / 'main' / 'resources' / 'config' / 'config-local.yml'


def creds():
    t = BE_CFG.read_text(encoding='utf-8')
    url = next(re.match(r'jdbc-url:\s*(\S+)', l.strip()).group(1)
               for l in t.splitlines() if not l.strip().startswith('#') and 'jdbc-url:' in l)
    user = next(re.match(r'username:\s*"?([^"]+)"?', l.strip()).group(1)
                for l in t.splitlines() if not l.strip().startswith('#') and 'username:' in l).strip()
    pwd = next(re.match(r'password:\s*"([^"]+)"', l.strip()).group(1)
               for l in t.splitlines() if not l.strip().startswith('#') and 'password:' in l)
    m = re.search(r'@([^/]+)/(\S+)', url)
    return user, pwd, f'{m.group(1)}/{m.group(2)}'


u, p, d = creds()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

print('=== [1] SCM_ADM_MNU_BTN_MPG_M for SYS0001 ===')
cur.execute("""
    SELECT MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN
      FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
     WHERE MNU_ID='SYS0001'
     ORDER BY SHT_NM, MNU_BTN_CD
""")
api_ids = []
for r in cur.fetchall():
    print('  ', ' | '.join(str(v) for v in r))
    if r[3]:
        api_ids.append(r[3])

print()
print('=== [2] SCM_ADM_API_M ===')
if api_ids:
    placeholders = ','.join(f"'{a}'" for a in set(api_ids))
    cur.execute(f"""
        SELECT API_ID, API_TP_CD, API_URL
          FROM SCM_MGR.SCM_ADM_API_M
         WHERE API_ID IN ({placeholders})
    """)
    for r in cur.fetchall():
        print('  ', ' | '.join(str(v) for v in r))

print()
print('=== [3] SCM_ADM_PROC_M (SP 컬럼 매핑) ===')
if api_ids:
    cur.execute(f"""
        SELECT PROC_NM, COL_NM, COL_TP_CD, SORT_ORD
          FROM SCM_MGR.SCM_ADM_PROC_M
         WHERE PROC_NM IN ({placeholders})
         ORDER BY PROC_NM, SORT_ORD
    """)
    for r in cur.fetchall():
        print('  ', ' | '.join(str(v) for v in r))

print()
print('=== [4] SP body — sheet=msgMgmt 의 SEARCH/INSERT/UPDATE/DELETE SP body 의 FROM/INTO/UPDATE 테이블 ===')
for a in set(api_ids):
    print(f'\n--- SP: {a} ---')
    try:
        cur.execute("""
            SELECT TEXT FROM ALL_SOURCE
             WHERE OWNER='SCM_MGR' AND NAME=:n
             ORDER BY LINE
        """, {'n': a})
        lines = [r[0] for r in cur.fetchall()]
        if not lines:
            print('  (no source)')
            continue
        body = ''.join(lines)
        # 테이블 참조 추출
        tabs = set()
        for m in re.finditer(r'\b(?:FROM|JOIN|INTO|UPDATE|MERGE\s+INTO)\s+(SCM_[A-Z_0-9]+|GT_[A-Z_0-9]+)', body, re.IGNORECASE):
            tabs.add(m.group(1).upper())
        # WITH ... AS 안은 제외 — 일단 모두 표시
        for t in sorted(tabs):
            print(f'  TABLE: {t}')
    except Exception as e:
        print(f'  ERROR: {e}')

con.close()
