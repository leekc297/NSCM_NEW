# -*- coding: utf-8 -*-
"""
DMF0082 81 계열 Monthly 경계월 임시 조치 (E20261124-DMF0082DIVCUTOFF-TEMP) · 사내 ZIOUI1 적용
- 사용자 지시 2026-11-24: 표준 = 81, 81 JV 당월부터 편집. UI 버그 수정 전까지 임시로 익월부터 편집
- 변경: 81 계열(LIKE '81%') THEN 경계 = 지난달 → 당월 (화면은 경계월 이하 월 칸을 잠금 → 당월 잠금, 익월부터 입력)
- 40, 82 = 오늘 월 + 3개월 (변경 없음)
- 기준본 = 착수 시 ALL_SOURCE 새로 조회본 (#152) · 적용 직전 FRESH-GATE 재조회
사용: python -u apply_temp_next_month.py [--apply]
"""
import sys, os, time
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0082', 'PACKAGE BODY'
TAG = 'E20261124-DMF0082DIVCUTOFF-TEMP'
OLD = "                    THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* [E20261124-DMF0082UCCUTOFF] 경계 = 지난달 → Monthly 당월부터 입력 (사용자 요청 2026-11-24) */\n"
NEW = (
    "                    THEN TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYYMMDD')                    /* [" + TAG + "] 임시 조치: 경계 = 당월 → Monthly 익월부터 입력 (사용자 지시 2026-11-24, UI 버그 수정 전까지) */\n"
    "                    -- [" + TAG + "] 표준 = 81 계열 당월부터 입력. UI 버그 수정 뒤 표준으로 되돌림. 복원 방법 = 바로 위 THEN 줄을 아래 줄로 교체\n"
    "                    --        THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* 경계 = 지난달 → Monthly 당월부터 입력 */\n"
    "                    --   표준판 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/01_PKG_DMF0082_BODY_DIV_CUTOFF.sql (LAST_DDL 2026-11-24 11:36:44)\n"
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
        t = time.time()
        meta, base = fetch(cur)
        print(f'base fetched {time.strftime("%Y-%m-%d %H:%M:%S")} LAST_DDL={meta[0]} STATUS={meta[1]} chars={len(base)} ({time.time()-t:.1f}s)')
        asis = os.path.join(HERE, '02_BACKUP_PKG_DMF0082_BODY_STANDARD.ASIS.sql')
        if not os.path.exists(asis):
            open(asis, 'w', encoding='utf-8', newline='').write(ddl(base) + '\n/\n')
        print('OLD 매칭', base.count(OLD), '· 표식', base.count(TAG))
        assert base.count(OLD) == 1, '대상 매칭 != 1 — 원문이 바뀌었거나 이미 반영됨'
        assert base.count(TAG) == 0
        tobe = base.replace(OLD, NEW)
        assert tobe.count(OLD) == 0 and tobe.count(TAG) == 2
        open(os.path.join(HERE, '03_PKG_DMF0082_BODY_DIV_CUTOFF_TEMP.sql'), 'w', encoding='utf-8', newline='').write(ddl(tobe) + '\n/\n')
        if not apply:
            print('dry: 조립만 함')
            return
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
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
        cur.execute("SELECT OWNER, OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE STATUS='INVALID' AND OWNER='SCM_MGR' AND OBJECT_NAME LIKE '%DMF0082%'")
        print('invalid DMF0082 objects', cur.fetchall())


if __name__ == '__main__':
    main()
