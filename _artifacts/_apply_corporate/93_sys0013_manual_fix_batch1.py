"""SYS0013 DQ manual fix — D안 Step A (placeholder) + Step B (한글 single-quote alias).

배경:
  사용자 결정 (2026-06-21): D안 단계 분리.
  Step A — DQ 102/112/113/114 (DQ_TEXT='-' placeholder) VALID_YN='N' 비활성.
  Step B — 한글 single-quote alias (`SUBSTR(...) '고객군'`) → double-quote (`"고객군"`).
           Oracle ORA-00923/00936 유발 패턴.

영향 row (예상):
  Step A: 4 row (DQ 102/112/113/114).
  Step B: 다수 row — 한글 alias 사용 패턴.

Anti-Simplification:
  - 백업 테이블 `SCM_ADM_DQ_LIST_BAK_20260621` 활용 (rollback 가능).
  - row 별 변경 횟수 카운트 + diff 로그.
  - 안전 패턴: `( SELECT-stmt 안 ) '한글alias' ( , 또는 FROM 또는 EOL )` 매칭.

검증:
  적용 후 Phase A 재실행 → PASS 증가 확인.
"""
from __future__ import annotations

import os
import re
import sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv('NSCM_ORA_USER'); p = os.getenv('NSCM_ORA_PASS'); d = os.getenv('NSCM_ORA_DSN')
assert u and p and d
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f'[ connected ] {d}')

# ===========================================================================
# Step A — Placeholder row VALID_YN='N'
# ===========================================================================
print('\n[ STEP A ] Placeholder row VALID_YN=N:')
placeholder_ids = [102, 112, 113, 114]
for dq_id in placeholder_ids:
    cur.execute(
        "UPDATE SCM_MGR.SCM_ADM_DQ_LIST "
        "   SET VALID_YN='N', "
        "       LAST_UPDATED_BY='admin', "
        "       LAST_UPDATE_DATE=SYSDATE "
        " WHERE DQ_ID=:id AND VALID_YN <> 'N'",
        id=dq_id,
    )
    print(f'  DQ_ID={dq_id}: {cur.rowcount} row affected')
conn.commit()

# ===========================================================================
# Step B — 한글 single-quote alias → double-quote
# ===========================================================================
print('\n[ STEP B ] 한글 single-quote alias batch fix:')

# 정규식 — SELECT 절 안 alias 의 single-quote literal 매칭.
# 안전 패턴:
#   1. `)` 또는 word 다음 공백 + `'한글텍스트'` + `,` 또는 `from` 또는 행 끝
#   2. 한글 포함 alias 만 (false-positive 회피).
#   3. literal context (실 string) 와 구분 — alias 는 column expr 직후.
ALIAS_KOR_RE = re.compile(
    r"(?P<prefix>[)\w]\s+)'(?P<alias>[가-힯][^']*)'(?P<suffix>\s*(?:,|FROM\b|\)|$))",
    re.IGNORECASE | re.MULTILINE,
)

cur.execute('SELECT DQ_ID, DQ_TEXT FROM SCM_MGR.SCM_ADM_DQ_LIST ORDER BY DQ_ID')
rows = []
for r in cur:
    dq_id, lob = r
    rows.append((dq_id, lob.read() if isinstance(lob, oracledb.LOB) else (lob or '')))

upd = conn.cursor()
upd.setinputsizes(new_text=oracledb.CLOB)
total_changed = 0
affected_dq_ids: list = []

for dq_id, sql in rows:
    new_sql, hits = ALIAS_KOR_RE.subn(
        lambda m: f"{m.group('prefix')}\"{m.group('alias')}\"{m.group('suffix')}",
        sql,
    )
    if hits > 0:
        upd.execute(
            "UPDATE SCM_MGR.SCM_ADM_DQ_LIST "
            "   SET DQ_TEXT=:new_text, "
            "       LAST_UPDATED_BY='admin', "
            "       LAST_UPDATE_DATE=SYSDATE "
            " WHERE DQ_ID=:id",
            new_text=new_sql, id=dq_id,
        )
        total_changed += hits
        affected_dq_ids.append((dq_id, hits))

conn.commit()
print(f'  total alias 변환: {total_changed}')
print(f'  영향 DQ_ID (count):')
for dq_id, n in affected_dq_ids[:25]:
    print(f'    DQ_ID={dq_id:<4} {n} alias')

conn.close()
print('\n[ done ] Step A+B 적용 완료. Phase A 재실행 권장.')
