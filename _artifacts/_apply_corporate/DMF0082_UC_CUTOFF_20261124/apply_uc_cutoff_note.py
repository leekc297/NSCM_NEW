# -*- coding: utf-8 -*-
"""
DMF0082 81_UC 경계월 변경 2단계 (E20261124-DMF0082UCCUTOFF) · 복원용 주석 추가 · 사내 ZIOUI1 적용
- 사용자 지시 2026-11-24 10:2x: 임시 작업이므로 다시 복원할 수 있게 주석으로 기재
- 1단계 적용본(LAST_DDL 10:17:58) 위에 주석 줄만 더한다. 실행 식은 바꾸지 않는다.
- 기준본 = 착수 시 ALL_SOURCE 새로 조회본 (#152) · 적용 직전 FRESH-GATE 재조회
사용: python -u apply_uc_cutoff_note.py [--apply]
"""
import sys, os, time
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0082', 'PACKAGE BODY'
TAG = 'E20261124-DMF0082UCCUTOFF'
NOTE = 'E20261124-DMF0082UCCUTOFF-RESTORE'
OLD = ("                    THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* [" + TAG + "] 경계 = 지난달 → Monthly 당월부터 입력 (사용자 요청 2026-11-24) */\n")
NEW = (OLD +
       "                    -- [" + NOTE + "] 임시 작업(2026-11-24). 복원 방법:\n"
       "                    --   ① POJ 판(2026-11-24 10:14:35)으로 되돌림 = 바로 위 THEN 줄을 아래 줄로 교체\n"
       "                    --        THEN CAST(NULL AS VARCHAR2(8))   /* 경계 미전달 = 월 단위 입력 제한 없음 */\n"
       "                    --   ② 전 사업부 M+3 경계로 되돌림 = CASE WHEN p_division_id = '81_UC' 줄부터 END AS M3_CUTOFF_DATE 줄까지 지우고 위 '--' 로 막힌 TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), 3), ...) 줄 주석을 푼다\n"
       "                    --   원문 백업 = _artifacts/_apply_corporate/DMF0082_UC_CUTOFF_20261124/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql (POJ 판)\n")


def fetch(cur):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=TYP)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=TYP)
    return meta, ''.join(r[0] for r in cur.fetchall())


def ddl(src):
    return 'CREATE OR REPLACE ' + src


def step(msg, t):
    print(f'[{time.strftime("%H:%M:%S")}] {msg} ({time.time()-t:.1f}s)', flush=True)


def main():
    apply = '--apply' in sys.argv
    with connect('tobe') as cx:
        cx.call_timeout = 60000
        cur = cx.cursor()
        t = time.time()
        meta, base = fetch(cur)
        step(f'base fetched LAST_DDL={meta[0]} STATUS={meta[1]} chars={len(base)}', t)
        bk = os.path.join(HERE, '02_BACKUP_PKG_DMF0082_BODY_STEP1.ASIS.sql')
        if not os.path.exists(bk):
            open(bk, 'w', encoding='utf-8', newline='').write(ddl(base) + '\n/\n')
        print('OLD 매칭', base.count(OLD), '· 복원 주석', base.count(NOTE))
        assert base.count(OLD) == 1, '대상 매칭 != 1 — 원문이 바뀌었거나 1단계 미반영'
        assert base.count(NOTE) == 0, '복원 주석 이미 있음'
        tobe = base.replace(OLD, NEW)
        assert tobe.count(NOTE) == 1
        open(os.path.join(HERE, '03_PKG_DMF0082_BODY_UC_CUTOFF_FINAL.sql'), 'w', encoding='utf-8', newline='').write(ddl(tobe) + '\n/\n')
        if not apply:
            print('dry: 조립만 함')
            return
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
        t = time.time()
        meta2, now = fetch(cur)
        assert now == base and meta2[0] == meta[0], 'FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합'
        step(f'FRESH-GATE 통과 {meta2}', t)
        cx.call_timeout = 120000
        t = time.time()
        cur.execute(ddl(tobe))
        step('compiled', t)
        cx.call_timeout = 60000
        t = time.time()
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n ORDER BY SEQUENCE", o=OWNER, n=NAME)
        errs = cur.fetchall()
        step(f'errors {len(errs)} {errs[:5]}', t)
        t = time.time()
        meta3, after = fetch(cur)
        step(f'after LAST_DDL={meta3[0]} STATUS={meta3[1]} DB 원문 == 적용본: {after == tobe} marks {after.count(TAG)}', t)
        if errs or meta3[1] != 'VALID':
            print('컴파일 실패 → 1단계본 복원')
            cur.execute(ddl(base))
            print('restored', fetch(cur)[0])


if __name__ == '__main__':
    main()
