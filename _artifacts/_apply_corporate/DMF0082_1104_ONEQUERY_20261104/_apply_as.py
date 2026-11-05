# -*- coding: utf-8 -*-
"""빌드된 02_PKG_DMF0082_1104_BODY_2B.sql 을 다른 이름의 패키지로 적용 (2026-11-05 병행 검증용)
  python -I _apply_as.py PKG_DMF0082_1104B      # SPEC = PKG_DMF0082_1104 복제 · BODY = 빌드 파일(이름 치환)
  python -I _apply_as.py PKG_DMF0082_1104B drop
등가 체인이 PKG_DMF0082_1104 를 호출 중일 때(재컴파일 시 ORA-04068) S3 변경본을 막힘 없이 올려 1104A(apply #18 스냅샷) 와 비교하기 위함.
"""
import sys, re, os
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
sys.path.insert(0, r"C:\Projects\NSCM\tools\DbConn")
import dbconn
HERE = os.path.dirname(os.path.abspath(__file__))
SRC = 'PKG_DMF0082_1104'; DST = sys.argv[1].upper(); BUILT = os.path.join(HERE, '02_PKG_DMF0082_1104_BODY_2B.sql')
assert re.fullmatch(r'PKG_DMF0082_1104[A-Z]', DST), DST
cx = dbconn.connect('tobe', dbconn.load_cfg(), write=True); c = cx.cursor()

if len(sys.argv) > 2 and sys.argv[2] == 'drop':
    for t in ('PACKAGE BODY', 'PACKAGE'):
        try: c.execute(f'DROP {t} SCM_MGR.{DST}'); print('dropped', t)
        except Exception as e: print('drop', t, str(e)[:80])
    sys.exit(0)

# FRESH-GATE (#152): 빌드 파일의 SOURCE-FRESH 스탬프(조립 원천 1104 BODY LAST_DDL) 가 지금 DB 의 1104 BODY LAST_DDL 과 같아야 한다 — 다르면 빌드가 낡은 원문 기준.
built = open(BUILT, encoding='utf-8').read()
m = re.search(r'-- SOURCE-FRESH: SCM_MGR\.PKG_DMF0082_1104 BODY LAST_DDL=(\S+ \S+) FETCHED=', built); assert m, '스탬프 없음'
c.execute("SELECT TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS'), status FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n AND object_type='PACKAGE BODY'", [SRC])
cur = c.fetchone(); print('FRESH-GATE 1104 BODY', cur, '빌드 스탬프', m.group(1))
assert cur and cur[0] == m.group(1), f"FRESH-GATE: 1104 BODY LAST_DDL {cur} ≠ 빌드 스탬프 {m.group(1)} — 재빌드 필요"

# SPEC: 1104 의 spec 을 그대로(이름만 치환)
c.execute("SELECT text FROM all_source WHERE owner='SCM_MGR' AND name=:n AND type='PACKAGE' ORDER BY line", [SRC])
spec = ''.join(r[0] for r in c.fetchall()); spec2 = re.sub(r'\b' + SRC + r'\b', DST, spec)
c.execute('CREATE OR REPLACE ' + spec2); print('SPEC created', DST)
# BODY: 빌드 파일에서 CREATE OR REPLACE 이후 본문, 끝의 '/' 제거, 이름 치환
i = built.index('CREATE OR REPLACE '); body = built[i + len('CREATE OR REPLACE '):].rstrip()
if body.endswith('/'): body = body[:-1].rstrip()
n = len(re.findall(r'\b' + SRC + r'\b', body)); body2 = re.sub(r'\b' + SRC + r'\b', DST, body)
c.execute('CREATE OR REPLACE ' + body2); print('BODY created', DST, 'chars', len(body2), '이름 치환', n)
c.execute("SELECT object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') FROM all_objects WHERE owner='SCM_MGR' AND object_name=:n", [DST]); print('OBJ', c.fetchall())
c.execute("SELECT line, position, SUBSTR(text,1,200) FROM all_errors WHERE owner='SCM_MGR' AND name=:n ORDER BY sequence", [DST]); errs = c.fetchall()
print('ERRORS', len(errs)); [print('  ', e) for e in errs[:10]]
