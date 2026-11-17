# -*- coding: utf-8 -*-
"""
SSP0024 Material 조회조건 = 앞뒤 부분일치(LIKE '%x%') + 대소문자 무시(UPPER) — 사내 ZIOUI1 PKG_SSP0024 BODY
  대상: P_SSP0024_GET_SHIP_MASTER (메인 조회) · P_SSP0024_GET_ITEM_BY_DIVISION_POPUP (Material 팝업 조회)
  방식: 같은 PKG 의 2026.10.07 Model/Nickname 검색 블록과 동일 패턴(STRING_SPLIT 토큰별 EXISTS + UPPER LIKE)
  절차(hook #152): 착수 시 ALL_SOURCE 조회본(.ASIS.txt) 기준 외과 치환 → FRESH-GATE 재조회 동일 assert → 적용 → VALID/ERRORS 0/적용본==DB 확인
  python -I apply.py [--apply]   (인자 없으면 dry-run: 치환 결과만 TOBE.txt 로 저장)
"""
import sys, os
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn
sys.stdout.reconfigure(encoding='utf-8')
HERE = os.path.dirname(os.path.abspath(__file__))
ASIS = os.path.join(HERE, 'PKG_SSP0024.PACKAGE_BODY.ASIS.txt')
TOBE = os.path.join(HERE, 'PKG_SSP0024.PACKAGE_BODY.TOBE.txt')

HIST_OLD = "     * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시\n"
HIST_NEW = HIST_OLD + "     * 2026.11.10   Claude         조회조건 Material(메인·팝업) : 앞뒤 부분일치·대소문자 무시\n"

OLD = ("            OR  A.ITEM_ID IN (SELECT COLUMN_VALUE\n"
       "                                FROM TABLE(STRING_SPLIT(V_MATERIAL_ID, ','))))\n")
NEW = ("/* 2026.11.10 Material 검색 앞뒤 부분일치·대소문자 무시 (START) */\n"
       "--            OR  A.ITEM_ID IN (SELECT COLUMN_VALUE\n"
       "--                                FROM TABLE(STRING_SPLIT(V_MATERIAL_ID, ','))))\n"
       "            OR  EXISTS (SELECT 1\n"
       "                          FROM TABLE(STRING_SPLIT(V_MATERIAL_ID, ',')) SM\n"
       "                         WHERE TRIM(SM.COLUMN_VALUE) IS NOT NULL\n"
       "                           AND UPPER(A.ITEM_ID) LIKE '%' || UPPER(TRIM(SM.COLUMN_VALUE)) || '%'))\n"
       "/* 2026.11.10 Material 검색 앞뒤 부분일치·대소문자 무시 (END) */\n")


def fetch(cur):
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SSP0024' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    return ''.join(r[0] for r in cur)


def main():
    base = open(ASIS, encoding='utf-8', newline='').read()
    assert base.count(HIST_OLD) == 1, 'HIST 매칭 != 1'
    assert base.count(OLD) == 2, 'Material 조건 매칭 != 2 (메인·팝업)'
    # 두 매칭이 각각 메인/팝업 프로시저 안에 있는지 확인
    p_main = base.index('PROCEDURE P_SSP0024_GET_SHIP_MASTER')
    p_pop = base.index('PROCEDURE P_SSP0024_GET_ITEM_BY_DIVISION_POPUP')
    p_save = base.index('PROCEDURE P_SSP0024_SAVE_SHIP_MASTER')
    i1 = base.index(OLD); i2 = base.index(OLD, i1 + 1)
    assert p_main < i1 < p_pop < i2 < p_save, '매칭 위치가 메인/팝업 프로시저 범위 밖'
    tobe = base.replace(HIST_OLD, HIST_NEW).replace(OLD, NEW)
    open(TOBE, 'w', encoding='utf-8', newline='').write(tobe)
    print('TOBE 저장', TOBE, len(base), '->', len(tobe))
    if '--apply' not in sys.argv:
        print('dry-run 종료'); return
    con = dbconn.connect('tobe', write=True)
    cur = con.cursor()
    # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본(.ASIS.txt)
    now = fetch(cur)
    assert now == base, 'FRESH-GATE 실패: 착수 후 DB 원문 변경 — 중단·재조회·재병합'
    print('FRESH-GATE OK')
    cur.execute('CREATE OR REPLACE ' + tobe)
    cur.execute("SELECT STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME='PKG_SSP0024' AND OBJECT_TYPE='PACKAGE BODY'")
    print('BODY', cur.fetchone())
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME='PKG_SSP0024' ORDER BY SEQUENCE")
    errs = cur.fetchall(); print('ERRORS', len(errs)); [print(e) for e in errs]
    after = fetch(cur)
    print('적용본==DB 원문', after == tobe)
    cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND STATUS='INVALID' AND OBJECT_NAME LIKE '%SSP0024%'")
    print('INVALID(SSP0024)', cur.fetchall())


main()
