# SCP0030 GET_BOD_ITEM 변형 벤치 (DB 객체 무변경 — 익명 블록으로 실행)
# 기준본 = 같은 폴더 PKG_SCP0030_PACKAGE_BODY.ASIS.sql (2026-10-15 사내 ZIOUI1 ALL_SOURCE 조회본)
import sys, time, hashlib, pathlib
sys.path.insert(0, r'C:\Projects\NSCM\_artifacts\_diagnostics')
import ora, oracledb
HERE = pathlib.Path(__file__).parent
src = (HERE / 'PKG_SCP0030_PACKAGE_BODY.ASIS.sql').read_text(encoding='utf-8')
s = src.index('    PROCEDURE P_SCP0030_GET_BOD_ITEM')
body = src[src.index('    IS\n', s) + len('    IS\n'): src.index('        OPEN O_RESULT_CURSOR FOR', s)]
PARAMS = ['P_DIVISION_ID','P_FROM_SITE','P_TO_SITE','P_INCOTERMS','P_TRANS_MODE','P_ITEM_ID','P_NICK_NAME','P_VALID','P_USER_ID','P_MENU_ID']

FUNCS = src[src.index('    FUNCTION F_SPLIT_LIST'):src.index('    /* =', src.index('    FUNCTION F_USE_LIST'))]
OLD_PRED = """                   AND (V_ITEM_USE = 'N'
                        OR EXISTS (SELECT 1
                                     FROM TABLE(V_ITEM_TAB) SA
                                    WHERE UPPER(A.ITEM_ID)   LIKE '%' || SA.COLUMN_VALUE || '%'
                                       OR UPPER(XC.NICK_NAME) LIKE '%' || SA.COLUMN_VALUE || '%'))
"""
OLD_FROM = """                       ) XD                                            /* 리드타임 (사업부 + BOD 유일) — 행마다 뷰 재계산 방지(ROWNUM) */
"""
OLD_BEGIN = "    BEGIN\n"
def variant(name):
    b = body
    assert b.count(OLD_PRED) == 1 and b.count(OLD_FROM) == 1 and b.count(OLD_BEGIN) == 1
    if name == 'BASE':
        return b
    col = 'XC.ITEM_ID' if name == 'JOIN_XC' else 'A.ITEM_ID'
    b = b.replace(OLD_BEGIN, OLD_BEGIN + "        IF V_ITEM_USE = 'N' THEN V_ITEM_TAB := T_STR_TAB(NULL); END IF;\n")
    b = b.replace(OLD_FROM, OLD_FROM + "                     , TABLE(V_ITEM_TAB) SA\n")
    b = b.replace(OLD_PRED, "                   AND (UPPER(%s) LIKE '%%' || SA.COLUMN_VALUE || '%%'\n"
                            "                        OR UPPER(XC.NICK_NAME) LIKE '%%' || SA.COLUMN_VALUE || '%%')\n" % col)
    return b

def block(b):
    decl, rest = b.split(OLD_BEGIN, 1)
    outer = "".join("        %s VARCHAR2(4000) := :%s;\n" % (p, p) for p in PARAMS) + FUNCS
    rest = rest.replace('OPEN O_RC1 FOR', 'OPEN :O_RC1 FOR')
    return "DECLARE\n" + outer + "BEGIN\nDECLARE\n" + decl + "BEGIN\n" + rest + "END;\nEND;"

def run(cur, name, args, keep_rows=True):
    rc = cur.var(oracledb.CURSOR)
    binds = dict(zip(PARAMS, args)); binds['O_RC1'] = rc
    t = time.time(); cur.execute(block(variant(name)), binds); r = rc.getvalue(); r.arraysize = 5000
    h = hashlib.md5(); n = 0
    while True:
        rows = r.fetchmany()
        if not rows: break
        for row in rows: h.update(repr(row).encode()); n += 1
    return time.time() - t, n, h.hexdigest()

if __name__ == '__main__':
    u, p, d = ora.conn_info(); c = oracledb.connect(user=u, password=p, dsn=d); cur = c.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','DB_NAME') FROM DUAL"); print('DB', cur.fetchone())
    U = ['minyonglee1', 'SCP0030']
    CASES = {
      'FULL(ALL)':        ['ALL','ALL','ALL','ALL','ALL','','','ALL'] + U,
      'DIV 81,40,82':     ['81,40,82','ALL','ALL','ALL','ALL','','','ALL'] + U,
      'ITEM EM0482':      ['82','ALL','ALL','ALL','SEA','EM0482','','Y'] + U,
      'ITEM MCCH129520B1':['81_UC,40','ALL','ALL','ALL','ALL','MCCH129520B1','','ALL'] + U,
      'ITEM=NICK H26A':   ['ALL','ALL','ALL','ALL','ALL','H26A','','ALL'] + U,
      'ITEM 2tok':        ['ALL','ALL','ALL','ALL','ALL','EM0482, mcch12','','ALL'] + U,
    }
    variants = sys.argv[1:] or ['BASE', 'JOIN_A']
    for cname, args in CASES.items():
        base = None
        for v in variants:
            for rep in range(2):
                el, n, hx = run(cur, v, args)
            if v == variants[0]: base = (n, hx)
            print('%-18s %-8s %6.2fs rows=%7d %s' % (cname, v, el, n, 'SAME' if (n, hx) == base else 'DIFF'), flush=True)
