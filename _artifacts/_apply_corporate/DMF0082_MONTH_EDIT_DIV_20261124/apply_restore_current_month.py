# -*- coding: utf-8 -*-
"""
DMF0082 81 계열 Monthly 당월 편집 허용 (E20261124-DMF0082DIVCUTOFF-CURMON) · 사내 ZIOUI1 적용
- 사용자 지시 2026-11-24 13:35: 81, 81 JV 당월도 수정 가능하도록 PKG 변경
- 변경: 81 계열(LIKE '81%') THEN 경계 = 당월(임시, 익월부터 입력) → 지난달(당월부터 입력)
- 40, 82 = 오늘 월 + 3개월 (변경 없음)
- 기준본 = 착수 시 ALL_SOURCE 새로 조회본 (#152) · 적용 직전 FRESH-GATE 재조회
사용: python -u apply_restore_current_month.py [--apply]
"""
import sys, os, time
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0082', 'PACKAGE BODY'
OLDTAG = 'E20261124-DMF0082DIVCUTOFF-TEMP'
TAG = 'E20261124-DMF0082DIVCUTOFF-CURMON'
OLD = (
    "                    THEN TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD')                    /* [" + OLDTAG + "] 임시 조치: 경계 = 당월 → Monthly 익월부터 입력 (사용자 지시 2026-11-24, UI 버그 수정 전까지) */\n"
    "                    -- [" + OLDTAG + "] 표준 = 81 계열 당월부터 입력. UI 버그 수정 뒤 표준으로 되돌림. 복원 방법 = 바로 위 THEN 줄을 아래 줄로 교체\n"
    "                    --        THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* 경계 = 지난달 → Monthly 당월부터 입력 */\n"
    "                    --   표준판 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/01_PKG_DMF0082_BODY_DIV_CUTOFF.sql (LAST_DDL 2026-11-24 11:36:44)\n"
)
NEW = (
    "                    THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* [" + TAG + "] 경계 = 지난달 → Monthly 당월부터 입력 (사용자 지시 2026-11-24 13:35) */\n"
    "                    -- [" + TAG + "] 종전(LAST_DDL 2026-11-24 11:40:00, 임시 조치) = THEN TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD') (경계 = 당월 → 익월부터 입력)\n"
    "                    --   임시판 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/04_BACKUP_PKG_DMF0082_BODY_TEMP.ASIS.sql\n"
)


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=TYP)
    return meta, ''.join(r[0] for r in cur.fetchall())


def ddl(src):
    return 'CREATE OR REPLACE ' + src


def main():
    apply = '--apply' in sys.argv
    with connect('tobe') as cx:
        cx.call_timeout = 60000
        cur = cx.cursor()
        cur.execute("SELECT SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','SERVICE_NAME') FROM DUAL")
        print('DB', cur.fetchone())
        t = time.time()
        meta, base = fetch(cur)
        print(f'base fetched {time.strftime("%Y-%m-%d %H:%M:%S")} LAST_DDL={meta[0]} STATUS={meta[1]} chars={len(base)} ({time.time()-t:.1f}s)')
        asis = os.path.join(HERE, '04_BACKUP_PKG_DMF0082_BODY_TEMP.ASIS.sql')
        if not os.path.exists(asis):
            open(asis, 'w', encoding='utf-8', newline='').write(ddl(base) + '\n/\n')
        print('OLD 매칭', base.count(OLD), '· 표식', base.count(TAG))
        assert base.count(OLD) == 1, '대상 매칭 != 1 — 원문이 바뀌었거나 이미 반영됨'
        assert base.count(TAG) == 0
        tobe = base.replace(OLD, NEW)
        assert tobe.count(OLD) == 0 and tobe.count(TAG) == 2 and tobe.count(OLDTAG) == 0
        open(os.path.join(HERE, '05_PKG_DMF0082_BODY_DIV_CUTOFF_CURMON.sql'), 'w', encoding='utf-8', newline='').write(ddl(tobe) + '\n/\n')
        if not apply:
            print('dry: 조립만 함')
            return
        meta2, now = fetch(cur)
        assert now == base and meta2[0] == meta[0], 'FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합'
        print('FRESH-GATE 통과', meta2, time.strftime('%H:%M:%S'))
        cx.call_timeout = 600000
        t = time.time()
        try:
            cur.execute(ddl(tobe))
        except Exception as ex:
            print('compile exec warning:', ex)
        print(f'compiled ({time.time()-t:.1f}s)')
        cx.call_timeout = 60000
        cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n ORDER BY 1", o=OWNER, n=NAME)
        print('objects', cur.fetchall())
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n ORDER BY SEQUENCE", o=OWNER, n=NAME)
        errs = cur.fetchall()
        print('errors', len(errs), errs[:10])
        meta3, after = fetch(cur)
        print('DB 원문 == 적용본:', after == tobe, 'marks', after.count(TAG))
        if errs or meta3[1] != 'VALID':
            print('컴파일 실패 → 원문 복원')
            cur.execute(ddl(base))
            print('restored', fetch(cur)[0])


if __name__ == '__main__':
    main()
