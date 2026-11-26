# -*- coding: utf-8 -*-
"""DMF0082 사업부별 경계월 적용 검증 (읽기 전용) — 원문 일치 · ALL_ERRORS · GET_MAIN_DATA O_RC2 실호출(40, 81 계열 6개, 82)"""
import sys, os, time
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect
import oracledb

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0082', 'PACKAGE BODY'


def main():
    with connect('tobe') as cx:
        cx.call_timeout = 60000
        cur = cx.cursor()
        t = time.time()
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
        print('meta', cur.fetchone(), f'({time.time()-t:.1f}s)')
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=TYP)
        db = 'CREATE OR REPLACE ' + ''.join(r[0] for r in cur.fetchall()) + '\n/\n'
        fn = sys.argv[1] if len(sys.argv) > 1 else '01_PKG_DMF0082_BODY_DIV_CUTOFF.sql'
        f = open(os.path.join(HERE, fn), encoding='utf-8', newline='').read()
        # FRESH-GATE: 검증 시점 DB 원문 재조회 == 사내 적용본
        print(f'DB 원문 == {fn}:', f == db)
        cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n", o=OWNER, n=NAME)
        print('ALL_ERRORS', cur.fetchone()[0])
        cur.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID' AND OBJECT_NAME LIKE '%DMF0082%'")
        print('INVALID DMF0082', cur.fetchone()[0])
        cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
        print('DB SYSDATE', cur.fetchone()[0])
        frm, to = time.strftime('%Y%m01'), '20271231'
        for div in ('40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82'):
            t = time.time()
            rcs = [cur.var(oracledb.DB_TYPE_CURSOR) for _ in range(5)]
            res = cur.var(oracledb.DB_TYPE_CURSOR)
            try:
                cur.execute("""BEGIN SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
                    p_division_id=>:d, p_team_id=>'ALL', p_customer=>'ALL', p_biz_type=>'ALL',
                    p_from_yyyymmdd=>:f, p_to_yyyymmdd=>:t, p_scm_site_id=>'ALL', p_item_id=>'ZZ_NO_ITEM_DIVCUTOFF',
                    p_version_type=>'Current', p_qty_yn=>'N', p_created_by=>'DIVCUTOFF_CHECK', p_user_group=>'ADMIN',
                    O_RC1=>:r1, O_RC2=>:r2, O_RC3=>:r3, O_RC4=>:r4, O_RC5=>:r5, O_RESULT_CURSOR=>:rr); END;""",
                    d=div, f=frm, t=to, r1=rcs[0], r2=rcs[1], r3=rcs[2], r4=rcs[3], r5=rcs[4], rr=res)
                rows = rcs[1].getvalue().fetchall()
                cut = {r[2] for r in rows}
                print(f'{div}: O_RC2 {len(rows)}행 · M3_CUTOFF_DATE 값 {sorted(cut)} · 첫 행 {rows[0] if rows else None} ({time.time()-t:.1f}s)')
            except Exception as e:
                print(f'{div}: 호출 오류 {e} ({time.time()-t:.1f}s)')
        cx.rollback()


if __name__ == '__main__':
    main()
