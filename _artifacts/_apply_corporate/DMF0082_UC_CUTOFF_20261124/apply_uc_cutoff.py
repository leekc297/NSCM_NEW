# -*- coding: utf-8 -*-
"""
DMF0082 81_UC Monthly 입력 경계월 변경 (E20261124-DMF0082UCCUTOFF) · 사내 ZIOUI1 적용
- P_DMF0082_GET_MAIN_DATA 두 번째 결과셋 M3_CUTOFF_DATE
  변경 전: 오늘 월 + 3개월 (전 사업부)
  변경 후: 81_UC = 지난달(당월부터 입력) · 그 외 = 오늘 월 + 3개월(종전 그대로)
- 화면은 Monthly 조회에서만 이 경계월로 MKT_FCST, SCM_FCST, VMI_In_Req 월 칸을 잠근다(ForecastPriceGridUtils.ts isM4Locked)
- 기준본 = 착수 시 ALL_SOURCE 새로 조회본 (#152) · 적용 직전 FRESH-GATE 재조회
사용: python -u apply_uc_cutoff.py [--apply]   (인자 없으면 조립·검사만)
"""
import sys, os, time
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0082', 'PACKAGE BODY'
TAG = 'E20261124-DMF0082UCCUTOFF'
# 2026-11-24 10:17 재조회: POJ 변경(LAST_DDL 10:14:35)이 먼저 들어와 81_UC = NULL(경계 미전달) 로 바뀌어 있음.
#   POJ 의 CASE 구조·주석은 남기고 81_UC THEN 값만 지난달로 바꾼다(최신 원문 위 재병합, #152 §1-3).
OLD = "                    THEN CAST(NULL AS VARCHAR2(8))   /* 경계 미전달 = 월 단위 입력 제한 없음 */\n"
NEW = ("                    THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* [" + TAG + "] 경계 = 지난달 → Monthly 당월부터 입력 (사용자 요청 2026-11-24) */\n")


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
        asis = os.path.join(HERE, '00_BACKUP_PKG_DMF0082_BODY.ASIS.sql')
        if not os.path.exists(asis):
            open(asis, 'w', encoding='utf-8', newline='').write(ddl(base) + '\n/\n')
        print('OLD 매칭', base.count(OLD), '· 표식', base.count(TAG))
        assert base.count(OLD) == 1, '대상 매칭 != 1 — 원문이 바뀌었거나 이미 반영됨'
        assert base.count(TAG) == 0
        tobe = base.replace(OLD, NEW)
        assert tobe.count(OLD) == 0 and tobe.count(TAG) == 1
        open(os.path.join(HERE, '01_PKG_DMF0082_BODY_UC_CUTOFF.sql'), 'w', encoding='utf-8', newline='').write(ddl(tobe) + '\n/\n')
        if not apply:
            print('dry: 조립만 함')
            return
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
        meta2, now = fetch(cur)
        assert now == base and meta2[0] == meta[0], 'FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합'
        print('FRESH-GATE 통과', meta2)
        cx.call_timeout = 300000
        t = time.time()
        try:
            cur.execute(ddl(tobe))
        except Exception as e:
            print('compile exec warning:', e)
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
