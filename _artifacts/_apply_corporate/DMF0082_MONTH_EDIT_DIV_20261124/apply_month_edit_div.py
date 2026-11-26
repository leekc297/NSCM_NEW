# -*- coding: utf-8 -*-
"""
DMF0082 Monthly 입력 경계월 사업부별 분리 (E20261124-DMF0082DIVCUTOFF) · 사내 ZIOUI1 적용
- P_DMF0082_GET_MAIN_DATA 두 번째 결과셋 M3_CUTOFF_DATE
  변경 전: 81_UC = 지난달(당월부터 입력) · 그 외 = 오늘 월 + 3개월
  변경 후: 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC (LIKE '81%') = 지난달(당월부터 입력) · 그 외(40, 82) = 오늘 월 + 3개월
- 근거: AS-IS 81 사업부 입력 화면 DMF0003 은 Monthly 에서 당주 월요일이 속한 월부터 편집, +3개월 규정 없음(DMF0003_MktFcst.cs:2957~2971)
- 화면은 Monthly 조회에서만 이 경계월 이하 월 칸을 잠근다(ForecastPriceGridUtils.ts isM4Locked)
- 기준본 = 착수 시 ALL_SOURCE 새로 조회본 (#152) · 적용 직전 FRESH-GATE 재조회
사용: python -u apply_month_edit_div.py [--apply]   (인자 없으면 조립·검사만)
"""
import sys, os, time
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0082', 'PACKAGE BODY'
TAG = 'E20261124-DMF0082DIVCUTOFF'
START = "             , CASE WHEN p_division_id = '81_UC'"
END_MARK = "00_BACKUP_PKG_DMF0082_BODY.ASIS.sql (POJ 판)\n"

NEW = (
    "             , CASE WHEN p_division_id LIKE '81%'                                    -- 2026.11.24 [" + TAG + "] 81, 81 JV(81_HD, 81_HG, 81_HM, 81_ST, 81_UC) = 당월부터 입력 (START)\n"
    "                    THEN TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1), 'YYYYMMDD')   /* [E20261124-DMF0082UCCUTOFF] 경계 = 지난달 → Monthly 당월부터 입력 (사용자 요청 2026-11-24) */\n"
    "                    -- [" + TAG + "] 사용자 요청 2026-11-24: 40 = 당월 + 3개월까지 잠금, 81 계열 = 당월부터 입력. 82 는 요청 범위 밖이라 종전(+3개월) 유지\n"
    "                    --   근거 = AS-IS 81 사업부 입력 화면 DMF0003 Monthly 는 당주 월요일이 속한 월부터 편집, +3개월 규정 없음 (DMF0003_MktFcst.cs:2957~2971)\n"
    "                    --   종전(LAST_DDL 2026-11-24 10:25:27 판) = CASE WHEN p_division_id = '81_UC' (81_UC 만 당월부터). 원문 백업 = _artifacts/_apply_corporate/DMF0082_MONTH_EDIT_DIV_20261124/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql\n"
    "                    --   POJ 판(81_UC = 경계 미전달) 백업 = _artifacts/_apply_corporate/DMF0082_UC_CUTOFF_20261124/00_BACKUP_PKG_DMF0082_BODY.ASIS.sql\n"
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
        asis = os.path.join(HERE, '00_BACKUP_PKG_DMF0082_BODY.ASIS.sql')
        if not os.path.exists(asis):
            open(asis, 'w', encoding='utf-8', newline='').write(ddl(base) + '\n/\n')
        assert base.count(START) == 1, 'START 매칭 != 1 — 원문이 바뀌었거나 이미 반영됨'
        assert base.count(END_MARK) == 1, 'END_MARK 매칭 != 1'
        assert base.count(TAG) == 0, '이미 반영됨'
        s = base.index(START)
        e = base.index(END_MARK) + len(END_MARK)
        old = base[s:e]
        print('치환 대상 줄 수', old.count('\n'))
        assert old.count('\n') == 7 and 'ELSE TO_CHAR' not in old and old.count('THEN TO_CHAR') == 1
        tobe = base[:s] + NEW + base[e:]
        assert tobe.count(TAG) == 2 and tobe.count("p_division_id = '81_UC'") == base.count("p_division_id = '81_UC'") - 1
        open(os.path.join(HERE, '01_PKG_DMF0082_BODY_DIV_CUTOFF.sql'), 'w', encoding='utf-8', newline='').write(ddl(tobe) + '\n/\n')
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
