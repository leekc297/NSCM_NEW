"""SYS0016 CLOB 전환 실행 확인. 저장 결과는 마지막에 ROLLBACK 해서 사내 DB 에 남기지 않는다.

1. GET 호출: 기존 45행 조회, 본문 값 = 백업 테이블 값
2. SAVE 'I' 호출: 한글과 <img data-notice-image> 를 섞은 약 100KB 본문 저장
3. GET 재호출: 방금 저장한 공지 본문 길이·값 일치
4. SAVE 'M' 호출: 본문을 다른 큰 값으로 수정 후 값 일치
5. PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST 호출: 큰 본문으로 이력 1행 기록 후 값 일치
6. SAVE 'D' 호출: 공지·본문 삭제 확인
7. ROLLBACK 후 공지·이력 행 수 = 시작 행 수
"""
import json
import os
import sys
import time

sys.stdout.reconfigure(encoding='utf-8')
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
import oracledb  # noqa: E402
from dbconn import connect  # noqa: E402

FAIL = 0


def chk(ok, msg):
    global FAIL
    print(('PASS ' if ok else 'FAIL ') + msg)
    if not ok:
        FAIL += 1


def lob(v):
    return v.read() if hasattr(v, 'read') else v


TITLE = 'ZZ_CLOB_SMOKE_20261124'
unit = '공지 본문 CLOB 전환 확인 문장입니다. <img data-notice-image="SMOKE_FILE_ID" alt="smoke.png"> '
BIG1 = '<p>' + unit * 1100 + '</p>'
BIG2 = '<p>' + ('수정본 ' + unit) * 1300 + '</p>'

with connect('tobe') as cx:
    cx.call_timeout = 120000
    cur = cx.cursor()

    def count(tab):
        cur.execute(f'select count(*) from SCM_MGR.{tab}')
        return cur.fetchone()[0]

    def get_rows():
        rc1, rc2 = cx.cursor(), cx.cursor()
        t = time.time()
        cur.callproc('SCM_MGR.PKG_SYS0016.P_SYS0016_GET_NOTICE_CONTENT_MASTER', ['ALL', 'ALL', 'ALL', rc1, rc2])
        cols = [d[0] for d in rc1.description]
        rows = [dict(zip(cols, [lob(x) for x in r])) for r in rc1.fetchall()]
        print(f'   GET {len(rows)} rows ({time.time() - t:.2f}s)')
        return rows

    def save(payload):
        rc1, rc2 = cx.cursor(), cx.cursor()
        data = cur.var(oracledb.DB_TYPE_CLOB)
        data.setvalue(0, json.dumps(payload, ensure_ascii=False))
        t = time.time()
        cur.callproc('SCM_MGR.PKG_SYS0016.P_SYS0016_SAVE_NOTICE_CONTENT_MASTER', [data, 'CLOB_SMOKE', rc1, rc2])
        res = rc2.fetchall()
        print(f'   SAVE {payload[0]["CRUD_TYPE"]} -> {res} ({time.time() - t:.2f}s)')
        return res

    n_m, n_h, n_nm = count('SCM_ADM_NOTICE_CONTENT_MASTER'), count('SCM_ADM_NOTICE_CONTENT_MASTER_H'), count('SCM_ADM_NOTICE_MASTER')
    print(f'start rows CONTENT={n_m} HIST={n_h} NOTICE_MASTER={n_nm}')
    print(f'BIG1 chars={len(BIG1)} bytes={len(BIG1.encode("utf-8"))} / BIG2 chars={len(BIG2)} bytes={len(BIG2.encode("utf-8"))}')

    # 1
    rows = get_rows()
    cur.execute("select to_char(notice_id), notice_content from SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER_BAK20261124 where language_code = 'EN'")
    bak = {r[0]: r[1] for r in cur.fetchall()}
    got = {r['NOTICE_ID']: r['NOTICE_CONTENT'] for r in rows if r['NOTICE_ID'] in bak}
    diff = [k for k in bak if got.get(k) != bak[k]]
    chk(len(got) == len(bak) and not diff, f'GET content = backup (EN rows {len(bak)}, matched {len(got)}, diff {len(diff)})')

    try:
        # 2
        base = dict(MODULE='DM', SUB_MODULE='DM', NOTICE=TITLE, ACTIVE='N', START_DATE='', END_DATE='', POPUP_YN='N',
                    LANGUAGE_CODE='EN', NOTICE_TITLE=TITLE, NOTICE_IMAGE='')
        res = save([dict(base, CRUD_TYPE='I', NOTICE_ID=None, NOTICE_CONTENT=BIG1)])
        chk(res and res[0][0] == '0', 'SAVE I result code 0')
        # 3
        rows = get_rows()
        mine = [r for r in rows if r['NOTICE'] == TITLE]
        chk(len(mine) == 1, f'inserted notice found ({len(mine)})')
        nid = mine[0]['NOTICE_ID'] if mine else None
        chk(bool(mine) and mine[0]['NOTICE_CONTENT'] == BIG1, f'GET content = BIG1 (len {len(mine[0]["NOTICE_CONTENT"] or "") if mine else 0})')
        # 4
        res = save([dict(base, CRUD_TYPE='M', NOTICE_ID=int(nid), NOTICE_CONTENT=BIG2)])
        chk(res and res[0][0] == '0', 'SAVE M result code 0')
        cur.execute("select notice_content from SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER where notice_id = :n and language_code = 'EN'", n=int(nid))
        v = lob(cur.fetchone()[0])
        chk(v == BIG2, f'table content = BIG2 (len {len(v or "")})')
        # 5
        c = cur.var(oracledb.DB_TYPE_CLOB)
        c.setvalue(0, BIG2)
        t = time.time()
        cur.callproc('SCM_MGR.PR_SCM_ADM_NOTICE_CONTENT_MASTER_HIST', [str(nid), 'EN', TITLE, c, 'CLOB_SMOKE', '20261124', 'CLOB_SMOKE'])
        print(f'   HIST call ({time.time() - t:.2f}s)')
        cur.execute("select notice_content from SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER_H where notice_id = :n order by history_seq desc", n=int(nid))
        r = cur.fetchone()
        chk(r is not None and lob(r[0]) == BIG2, 'HIST content = BIG2')
        # 6
        res = save([dict(base, CRUD_TYPE='D', NOTICE_ID=int(nid), NOTICE_CONTENT='')])
        chk(res and res[0][0] == '0', 'SAVE D result code 0')
        cur.execute('select count(*) from SCM_MGR.SCM_ADM_NOTICE_CONTENT_MASTER where notice_id = :n', n=int(nid))
        chk(cur.fetchone()[0] == 0, 'content row deleted')
    finally:
        # 7
        cx.rollback()
    a, b, c2 = count('SCM_ADM_NOTICE_CONTENT_MASTER'), count('SCM_ADM_NOTICE_CONTENT_MASTER_H'), count('SCM_ADM_NOTICE_MASTER')
    chk((a, b, c2) == (n_m, n_h, n_nm), f'after rollback rows CONTENT={a} HIST={b} NOTICE_MASTER={c2}')
    cur.execute('select count(*) from SCM_MGR.SCM_ADM_NOTICE_MASTER where notice_title = :t', t=TITLE)
    chk(cur.fetchone()[0] == 0, 'no smoke notice left')

print('SMOKE', 'OK' if FAIL == 0 else f'FAIL {FAIL}', time.strftime('%Y-%m-%d %H:%M:%S'))
sys.exit(1 if FAIL else 0)
