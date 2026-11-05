# -*- coding: utf-8 -*-
"""PKG_DMF0082_1104 → PKG_DMF0082_1104A 복제 (2026-11-05 apply #18 스냅샷)
등가 검증 사다리: 1104A(= #18, 원본과 등가 실증) 를 기준(A) 으로 두고 이후 S3 변경본(1104) 을 전수 비교하면 원본 MF_W 460~590s 대기 없이 검증.
사용: python -I _clone_1104a.py          (SPEC+BODY 재생성 · VALID 확인)
      python -I _clone_1104a.py drop     (정리)
"""
import sys, re
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn
SRC, DST = 'PKG_DMF0082_1104', 'PKG_DMF0082_1104A'
cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor()

if len(sys.argv) > 1 and sys.argv[1] == 'drop':
    for t in ('PACKAGE BODY', 'PACKAGE'):
        try: c.execute(f'DROP {t} SCM_MGR.{DST}'); print('dropped', t)
        except Exception as e: print('drop', t, str(e)[:80])
    sys.exit(0)

def src(typ):
    c.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type=:t ORDER BY line", [SRC, typ])
    return ''.join(r[0] for r in c.fetchall())

# FRESH-GATE (#152): 복제 원천은 '지금' ALL_SOURCE 에서 읽는 live 원문이며, 기준본 = apply #18 (BODY LAST_DDL 2026-11-05 11:29:46).
#   실행 직전 LAST_DDL 을 다시 조회해 기준본과 같은지 assert — 다르면(다른 apply 가 끼어듦) 중단.
EXPECT_BODY_DDL = '2026-11-05 11:29:46'
c.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n", [SRC])
objs = c.fetchall(); print('원천', SRC, objs)
body = next((o for o in objs if o[0] == 'PACKAGE BODY'), None)
assert body and body[1] == 'VALID' and body[2] == EXPECT_BODY_DDL, f"FRESH-GATE: {SRC} BODY {body} ≠ 기준본 {EXPECT_BODY_DDL}"
for typ, kw in (('PACKAGE', 'PACKAGE'), ('PACKAGE BODY', 'PACKAGE BODY')):
    s = src(typ)
    n = len(re.findall(r'\b' + SRC + r'\b', s))
    s2 = re.sub(r'\b' + SRC + r'\b', DST, s)
    assert s2.count(DST) == n and n >= 1, (typ, n)
    head = re.match(r'\s*' + kw + r'\s+("?SCM_MGR"?\.)?"?' + DST + r'"?', s2, re.I)
    assert head, (typ, s2[:120])
    c.execute('CREATE OR REPLACE ' + s2)
    print('created', typ, 'chars', len(s2), '이름 치환', n)
c.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n", [DST])
print('결과', DST, c.fetchall())
c.execute("SELECT COUNT(*) FROM all_errors WHERE owner='SCM_MGR' AND name=:n", [DST]); print('ERRORS', c.fetchone()[0])
c.execute("SELECT COUNT(*) FROM all_procedures WHERE owner='SCM_MGR' AND object_name=:n AND procedure_name='P_DMF0082_GET_MAIN_DATA'", [DST]); print('GET_MAIN_DATA 존재', c.fetchone()[0])
