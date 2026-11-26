# -*- coding: utf-8 -*-
"""
DMF0082 버전 선택 조회 RTF[R+P] 3행 보완 (E20261123-DMF0082RTF3ROW) · 사내 ZIOUI1 적용
- 버전 실적 arm(MFR, SFR, SPR) 18곳: , A.MEASURE AS MEASURE → , B.MEASURE AS MEASURE (Current A8 arm, AS-IS MF arm 과 같은 식)
- 기준본 = 착수 시 ALL_SOURCE 새로 조회본 (#152) · 적용 직전 FRESH-GATE 재조회
사용: python -u apply_rtf3row.py [--apply]   (인자 없으면 조립·검사만)
"""
import sys, os, re, time
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
from dbconn import connect

HERE = os.path.dirname(os.path.abspath(__file__))
OWNER, NAME, TYP = 'SCM_MGR', 'PKG_DMF0082', 'PACKAGE BODY'
MARK = '--[E20261123-DMF0082RTF3ROW] 실적 측정값 → 화면 측정값(B.MEASURE). A.MEASURE 면 RESULT_MEASURE 같은 3행(MKT_FCST, SCM_FCST, RTF_SYS_RP)이 모두 RTF_SYS_RP 로 나감'
PAT = re.compile(r'(/\* ── (MFR|SFR|SPR) 실적 \(DM_PLN_SALES_PLAN_RESULT_C · A\.MEASURE\) ── \*/\n[^\n]*\n)(\s*), A\.MEASURE AS MEASURE\n')
EXPECT = 18


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
        hits = PAT.findall(base)
        kinds = {}
        for h in hits:
            kinds[h[1]] = kinds.get(h[1], 0) + 1
        print('matches', len(hits), kinds)
        assert len(hits) == EXPECT, f'대상 매칭 {len(hits)} != {EXPECT} — 원문이 바뀌었거나 이미 반영됨'
        tobe = PAT.sub(lambda m: m.group(1) + m.group(3) + ', B.MEASURE AS MEASURE  ' + MARK + '\n', base)
        assert tobe.count('E20261123-DMF0082RTF3ROW') == EXPECT
        assert len(PAT.findall(tobe)) == 0
        open(os.path.join(HERE, '01_PKG_DMF0082_BODY_RTF3ROW.sql'), 'w', encoding='utf-8', newline='').write(ddl(tobe) + '\n/\n')
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
        print('DB 원문 == 적용본:', after == tobe, 'marks', after.count('E20261123-DMF0082RTF3ROW'))
        if errs or meta3[1] != 'VALID':
            print('컴파일 실패 → 원문 복원')
            cur.execute(ddl(base))
            print('restored', fetch(cur)[0])
        cur.execute("SELECT OWNER, OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE STATUS='INVALID' AND OWNER='SCM_MGR' AND OBJECT_NAME LIKE '%DMF0082%'")
        print('invalid DMF0082 objects', cur.fetchall())


if __name__ == '__main__':
    main()
