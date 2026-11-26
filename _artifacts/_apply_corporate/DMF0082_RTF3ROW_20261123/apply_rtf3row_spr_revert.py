# -*- coding: utf-8 -*-
"""
E20261123-DMF0082RTF3ROW 2단계: SPR(SP 버전 실적) 6곳만 원래 A.MEASURE 로 되돌림
- 이유: 운영 AS-IS(DMF0082_GET_MAIN_DATA modify 2026-11-17) SP 버전 구간에는 RESULT_MEASURE 매핑 실적 arm 이 없음.
        B.MEASURE 로 바꾸면 SP 버전 조회에 MKT_FCST, SCM_FCST 실적 행이 새로 생김(사내 737행씩 실측). RTF 3행은 SP 버전에서 안 생김.
- 최종 = MFR 6곳, SFR 6곳만 B.MEASURE (AS-IS MF arm 과 같은 식)
- 기준본 = 착수 시 ALL_SOURCE 새로 조회본 (#152) · 적용 직전 FRESH-GATE 재조회
사용: python -u apply_rtf3row_spr_revert.py [--apply]
"""
import sys, os, re, time
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0082', 'PACKAGE BODY'
PAT = re.compile(r'(/\* ── SPR 실적 \(DM_PLN_SALES_PLAN_RESULT_C · A\.MEASURE\) ── \*/\n[^\n]*\n)(\s*), B\.MEASURE AS MEASURE  --\[E20261123-DMF0082RTF3ROW\][^\n]*\n')
EXPECT = 6


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
        meta, base = fetch(cur)
        print(f'base fetched {time.strftime("%Y-%m-%d %H:%M:%S")} LAST_DDL={meta[0]} STATUS={meta[1]} marks={base.count("E20261123-DMF0082RTF3ROW")}')
        bk = os.path.join(HERE, '02_BACKUP_PKG_DMF0082_BODY_STEP1.ASIS.sql')
        if not os.path.exists(bk):
            open(bk, 'w', encoding='utf-8', newline='').write(ddl(base) + '\n/\n')
        n = len(PAT.findall(base))
        print('SPR matches', n)
        assert n == EXPECT, f'대상 매칭 {n} != {EXPECT}'
        tobe = PAT.sub(lambda m: m.group(1) + m.group(2) + ', A.MEASURE AS MEASURE\n', base)
        assert tobe.count('E20261123-DMF0082RTF3ROW') == 12
        # 원래 원문(00_BACKUP) 과 비교: 차이는 MFR, SFR 12줄만
        orig = open(os.path.join(HERE, '00_BACKUP_PKG_DMF0082_BODY.ASIS.sql'), encoding='utf-8').read()
        orig = orig[len('CREATE OR REPLACE '):-len('\n/\n')]
        a, b = orig.split('\n'), tobe.split('\n')
        assert len(a) == len(b)
        diff = [i for i in range(len(a)) if a[i] != b[i]]
        print('원문 대비 바뀐 줄', len(diff))
        assert len(diff) == 12
        open(os.path.join(HERE, '03_PKG_DMF0082_BODY_RTF3ROW_FINAL.sql'), 'w', encoding='utf-8', newline='').write(ddl(tobe) + '\n/\n')
        if not apply:
            print('dry: 조립만 함')
            return
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
        meta2, now = fetch(cur)
        assert now == base and meta2[0] == meta[0], 'FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합'
        print('FRESH-GATE 통과', meta2)
        cx.call_timeout = 300000
        try:
            cur.execute(ddl(tobe))
        except Exception as e:
            print('compile exec warning:', e)
        cx.call_timeout = 60000
        cur.execute("SELECT OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n ORDER BY 1", o=OWNER, n=NAME)
        print('objects', cur.fetchall())
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n ORDER BY SEQUENCE", o=OWNER, n=NAME)
        errs = cur.fetchall()
        print('errors', len(errs), errs[:10])
        meta3, after = fetch(cur)
        print('DB 원문 == 적용본:', after == tobe, 'marks', after.count('E20261123-DMF0082RTF3ROW'))
        if errs or meta3[1] != 'VALID':
            print('컴파일 실패 → 1단계 원문 복원')
            cur.execute(ddl(base))
        cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE STATUS='INVALID' AND OWNER='SCM_MGR' AND OBJECT_NAME LIKE '%DMF0082%'")
        print('invalid DMF0082 objects', cur.fetchall())


if __name__ == '__main__':
    main()
