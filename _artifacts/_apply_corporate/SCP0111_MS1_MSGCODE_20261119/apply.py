# SCP0111 MS1: PKG_SCP0111 BODY 2줄 보완(C_MSG_DUP 등록 코드 · ADMIN 오류 결과 MSG) — FRESH-GATE(원문 재조회 일치) 후 적용, 실패 시 원문 복원
import sys, re
sys.path.insert(0, 'tools/DbConn')
from dbconn import connect
D = '_artifacts/_apply_corporate/SCP0111_MS1_MSGCODE_20261119'
before = open(f'{D}/PKG_SCP0111_BODY.ASIS.sql', 'rb').read().decode('utf-8')
after = open(f'{D}/PKG_SCP0111_BODY.TOBE.sql', 'rb').read().decode('utf-8')
mode = sys.argv[1] if len(sys.argv) > 1 else 'apply'
def ddl(src):
    return 'CREATE OR REPLACE ' + re.sub(r'^\s*PACKAGE\s+BODY\s+"?PKG_SCP0111"?', 'PACKAGE BODY SCM_MGR.PKG_SCP0111', src, count=1, flags=re.I)
with connect('tobe', write=True) as cx:
    cur = cx.cursor()
    cur.execute("select text from all_source where owner='SCM_MGR' and name='PKG_SCP0111' and type='PACKAGE BODY' order by line")
    now = ''.join(t for (t,) in cur.fetchall())
    want_now = before if mode == 'apply' else after
    hn = lambda x: re.sub(r'^\s*PACKAGE\s+BODY\s+\S*PKG_SCP0111', 'PACKAGE BODY PKG_SCP0111', x, count=1)  # 적용 뒤 첫 줄 공백만 다름
    if hn(now) != hn(want_now):
        print('FRESH-GATE 불일치 — 중단', len(now), len(want_now)); sys.exit(2)
    cur.execute("select count(*) from v$session s join all_objects o on o.object_id=s.plsql_entry_object_id where o.object_name='PKG_SCP0111'")
    if cur.fetchone()[0]:
        print('PKG 실행 세션 있음 — 중단'); sys.exit(3)
    target = after if mode == 'apply' else before
    code = 0
    try:
        cur.execute(ddl(target))
    except Exception as e:
        code = getattr(e.args[0], 'code', -1) if e.args else -1
        print('DDL 예외', str(e)[:200])
    cur.execute("select status, to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') from all_objects where owner='SCM_MGR' and object_name='PKG_SCP0111' and object_type='PACKAGE BODY'")
    st = cur.fetchone(); print('상태', st)
    cur.execute("select line, position, text from all_errors where owner='SCM_MGR' and name='PKG_SCP0111' and type='PACKAGE BODY'")
    errs = cur.fetchall(); print('오류', errs[:5])
    cur.execute("select text from all_source where owner='SCM_MGR' and name='PKG_SCP0111' and type='PACKAGE BODY' order by line")
    got = ''.join(t for (t,) in cur.fetchall())
    print('반영 원문 일치', hn(got) == hn(target))
    if st[0] != 'VALID' or errs:
        print('INVALID — 원문 복원'); cur.execute(ddl(before)); sys.exit(4)
