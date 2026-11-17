# -*- coding: utf-8 -*-
"""
결과에 영향 없는 빈 문자열 비교 항 정리(2026-11-13) — 클라우드 이관 패키지(수정 구간만) 생성기

  python build_cloud.py
  → _artifacts\\_deploy_packages\\EMPTYCMP_B_CLOUD_20261113\\ (10_APPLY_PATCH.sql · 90_VERIFY.sql · 99_ROLLBACK_PATCH.sql · README.md)

기준본(수정 전) = backup\\<객체>.ASIS.sql (착수 시 사내 ALL_SOURCE 조회본) · 수정본 = 지금 사내 ALL_SOURCE 재조회 원문.
FRESH-GATE: 지금 사내 원문 == tobe\\<객체>.TOBE.sql 인지 확인. 다르면 그 객체는 패치에서 빼고 보고.
패치 블록은 같은 날 선례(SEARCHCOND_CI_LIKE_20261113/build_cloud.py)의 block() 을 그대로 쓴다.
"""
import sys, os, importlib.util
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'CloudPkg'))
import dbconn, patchgen
sp = importlib.util.spec_from_file_location('prec', os.path.join(HERE, '..', 'SEARCHCOND_CI_LIKE_20261113', 'build_cloud.py'))
prec = importlib.util.module_from_spec(sp); sp.loader.exec_module(prec)
import emptycmp

OUT = os.path.join(ROOT, '_artifacts', '_deploy_packages', 'EMPTYCMP_B_CLOUD_20261113')
TITLE = "결과에 영향 없는 빈 문자열 비교 항 삭제"


def blk(name, typ, hunks, h, l, last_ddl, what):
    prec.TYP = typ
    s = '\n'.join(prec.block(name, hunks, h, l, last_ddl))
    return s.replace('조회조건 대소문자 무시/LIKE 보완 · 수정 구간만 패치', TITLE + ' · ' + what).replace('이미 사내와 같음', '이미 목표 원문과 같음')


def main():
    os.makedirs(OUT, exist_ok=True)
    con = dbconn.connect('tobe'); cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVICE_NAME'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
    svc, fetched = cur.fetchone()
    head = ("/* %s : 클라우드 이관(수정 구간만) — %%s\n"
            " * 생성 %s · 사내 DB=%s 기준 · 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)\n"
            " * 객체마다 독립 블록 — 한 객체가 중단돼도 그 객체 원문은 무변경이고 나머지는 계속 진행된다.\n */\n"
            "SET DEFINE OFF\nSET SERVEROUTPUT ON SIZE UNLIMITED\n\n") % (TITLE, fetched, svc.upper())
    A, R, rows, skipped = [head % '적용'], [head % '되돌리기(수정 전 구문으로)'], [], []
    for name, typ, rules in emptycmp.SPECS:
        cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", n=name, t=typ)
        last_ddl, st = cur.fetchone()
        cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t ORDER BY LINE", n=name, t=typ)
        now_src = ''.join(r[0] for r in cur.fetchall()).rstrip()
        base = prec.body_of(os.path.join(HERE, 'backup', name + '.ASIS.sql'))
        tobe = prec.body_of(os.path.join(HERE, 'tobe', name + '.TOBE.sql'))
        if patchgen.norm(now_src) != patchgen.norm(tobe):
            skipped.append((name, last_ddl, '사내 원문이 적용본과 다름(적용 후 다른 변경) — 패치에서 제외')); continue
        hunks, why = patchgen.make_hunks(base, now_src)
        rh, why2 = patchgen.make_hunks(now_src, base)
        if not hunks or not rh:
            skipped.append((name, last_ddl, '구간 패치 생성 실패: %s / %s' % (why, why2))); continue
        h, l = patchgen.expect_hash(cur, patchgen.norm(now_src))
        hb, lb = patchgen.expect_hash(cur, patchgen.norm(base))
        stamp = '-- SOURCE-FRESH: SCM_MGR.%s %s LAST_DDL=%s FETCHED=%s DB=ZIOUI1' % (name, typ, last_ddl, fetched)
        A += [stamp, blk(name, typ, hunks, h, l, last_ddl, '수정 구간만 패치')]
        R += [stamp, blk(name, typ, rh, hb, lb, last_ddl, '되돌리기 패치')]
        rows.append((name, typ, len(hunks), sum(r[2] for r in rules), last_ddl, st))
    open(os.path.join(OUT, '10_APPLY_PATCH.sql'), 'w', encoding='utf-8', newline='\n').write('\n'.join(A) + '\n')
    open(os.path.join(OUT, '99_ROLLBACK_PATCH.sql'), 'w', encoding='utf-8', newline='\n').write('\n'.join(R) + '\n')
    inl = ', '.join("'%s'" % r[0] for r in rows)
    ver = ("SET LINESIZE 200\nSET PAGESIZE 100\n"
           "SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_TYPE IN ('PACKAGE BODY','PROCEDURE') AND OBJECT_NAME IN (%s) ORDER BY 1;\n"
           "SELECT NAME, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME IN (%s) ORDER BY 1, 2;\n"
           "SELECT NAME, COUNT(*) MARK_LINES FROM USER_SOURCE WHERE NAME IN (%s) AND TEXT LIKE '%%E20261113-EMPTYCMP-B%%' GROUP BY NAME ORDER BY 1;\n") % (inl, inl, inl)
    open(os.path.join(OUT, '90_VERIFY.sql'), 'w', encoding='utf-8', newline='\n').write(ver)
    md = ['# 결과에 영향 없는 빈 문자열 비교 항 정리 · 클라우드 이관 패키지 (수정 구간만)', '',
          '- 생성: %s · 기준 = 사내 Oracle ZIOUI1 (SCM_MGR)' % fetched,
          '- 실행 계정: SCM_MGR · 순서: `10_APPLY_PATCH.sql` → `90_VERIFY.sql` (각각 전체 실행 · 반복 실행 안전)',
          '- 가능 여부만 보려면 `10_APPLY_PATCH.sql` 의 `c_dry CONSTANT BOOLEAN := FALSE` 를 TRUE 로 일괄 바꿔 실행한다(적용 안 함).',
          '- 되돌리기: `99_ROLLBACK_PATCH.sql` (같은 구간을 수정 전 구문으로 되돌린다).',
          '', '## 내용',
          "- `X IS NOT NULL OR X <> ''` 꼴에서 `<> ''` 항은 Oracle 에서 항상 거짓이라 결과에 영향이 없다. 28줄에서 그 항만 지웠다. 조회·저장 결과는 수정 전과 같다.",
          '- 조사 기록: `Doc/_rules_consolidation/2026-11-13_EMPTY_STRING_COMPARE_조사.md` §6 · §10',
          '', '## 동작',
          '- 객체마다 클라우드 자신의 원문을 읽어 **이번 수정 구간만** 치환한다. 그 밖의 클라우드↔사내 차이는 건드리지 않는다.',
          '- 출력: `> APPLY`(적용) / `> SKIP`(이미 반영) / `ORA-20011 중단`(그 구간이 사내 수정 전과 달라 자동 반영 불가 — 그 객체 원문은 무변경, 나머지는 계속 진행).',
          '- 컴파일 오류가 나면 그 객체는 실행 전 원문으로 자동 복원된다.',
          '- `90_VERIFY.sql` 기대값: MARK_LINES 합 28. 사내에서 수정 전부터 INVALID 인 객체는 README 표의 상태 열 참고.',
          '', '## 대상 객체 (%d개)' % len(rows), '', '| 객체 | 유형 | 변경 구간 | 바뀐 줄 | 사내 적용 시각 | 상태 |', '|---|---|---:|---:|---|---|']
    md += ['| %s | %s | %d | %d | %s | %s |' % r for r in rows]
    if skipped:
        md += ['', '## 패치에서 제외된 객체', ''] + ['- %s (LAST_DDL %s): %s' % s for s in skipped]
    md += ['', '## 수정 전 원문', '- 사내: `_artifacts/_apply_corporate/EMPTYCMP_B_20261113/backup/<객체>.ASIS.sql`', '']
    open(os.path.join(OUT, 'README.md'), 'w', encoding='utf-8', newline='\n').write('\n'.join(md))
    print('객체', len(rows), '구간 합', sum(r[2] for r in rows), '제외', skipped)
    print(OUT)
    con.close()


if __name__ == '__main__':
    main()
