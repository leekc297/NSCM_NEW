# -*- coding: utf-8 -*-
"""클라우드 패치 PL/SQL 리허설(DRY · DB 무변경): 20_PKG 블록의 USER_SOURCE 읽기만 바인드 CLOB 로 바꿔 A(GAP440)·B(POJ)·현재 사내본 3가지로 실행"""
import sys, os, glob, time
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
pkg = sorted(glob.glob(os.path.join(ROOT, '_artifacts', '_deploy_packages', 'DMF0082_UC_CUTOFF_CLOUD_*')))[-1]
sql = open(os.path.join(pkg, 'A_DB', '20_PKG_BODY_PKG_DMF0082_UC_CUTOFF.sql'), encoding='utf-8').read()
s = sql.index('DECLARE'); e = sql.index('END;\n/', s) + len('END;')
blk = sql[s:e]
LOOP = """    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
"""
assert blk.count(LOOP) == 1 and blk.count('c_dry   CONSTANT BOOLEAN := FALSE;') == 1
blk = blk.replace(LOOP, '    v_raw := :src;\n').replace('c_dry   CONSTANT BOOLEAN := FALSE;', 'c_dry   CONSTANT BOOLEAN := TRUE;')
assert 'EXECUTE IMMEDIATE' in blk  # DRY 분기에서 RETURN 하므로 실행 안 됨


def body(path):
    t = open(path, encoding='utf-8', newline='').read()
    return t[len('CREATE OR REPLACE '):-len('\n/\n')]


cases = {
    'A GAP440(11-23 적용본)': body(os.path.join(ROOT, '_artifacts', '_apply_corporate', 'DMF0082_RTF3ROW_20261123', '03_PKG_DMF0082_BODY_RTF3ROW_FINAL.sql')),
    'B POJ 판': body(os.path.join(HERE, '00_BACKUP_PKG_DMF0082_BODY.ASIS.sql')),
    'C 현재 사내본': body(os.path.join(HERE, '03_PKG_DMF0082_BODY_UC_CUTOFF_FINAL.sql')),
}
with connect('tobe') as cx:
    cx.call_timeout = 60000
    cur = cx.cursor()
    # FRESH-GATE: 리허설 직전 사내 DB 원문 재조회 == C(사내 적용본)
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    assert ''.join(r[0] for r in cur.fetchall()) == cases['C 현재 사내본'], 'FRESH-GATE 실패: 사내 원문 변경됨'
    print('FRESH-GATE 통과')
    cur.callproc('DBMS_OUTPUT.ENABLE', [None])
    for k, src in cases.items():
        t = time.time()
        v = cur.var(oracledb.DB_TYPE_CLOB); v.setvalue(0, src)
        try:
            cur.execute(blk, src=v)
            line, st = cur.var(str), cur.var(int)
            out = []
            while True:
                cur.callproc('DBMS_OUTPUT.GET_LINE', (line, st))
                if st.getvalue() != 0: break
                out.append(line.getvalue())
            print(f'{k}: {out} ({time.time()-t:.1f}s)')
        except Exception as ex:
            print(f'{k}: 오류 {ex} ({time.time()-t:.1f}s)')
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    print('사내 LAST_DDL(무변경 확인)', cur.fetchone())
