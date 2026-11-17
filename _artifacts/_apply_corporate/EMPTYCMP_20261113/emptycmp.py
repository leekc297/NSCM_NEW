# -*- coding: utf-8 -*-
"""
빈 문자열 비교 구문 보완(2026-11-13) — 사내 적용기 · 조사 기록 Doc/_rules_consolidation/2026-11-13_EMPTY_STRING_COMPARE_조사.md (a) 14줄

  python emptycmp.py prep      6개 객체 원문 새로 조회 → backup\\<객체>.ASIS.sql 저장 + 치환 검사(DB 무변경)
  python emptycmp.py apply     FRESH-GATE(지금 원문 == 착수 원문) 통과 후 CREATE OR REPLACE · 컴파일 오류면 원문 복원
  python emptycmp.py verify    적용본 == DB 원문 · STATUS · 오류 · 의존 INVALID 확인

기준본 = 실행 시점에 ALL_SOURCE 에서 새로 조회한 원문(hook #152). 로컬 파일을 기준으로 쓰지 않는다.
치환은 주석 줄(--)을 건너뛰고, 기대 건수와 다르면 중단한다. 바뀐 줄 끝에 표시 주석을 붙인다.
"""
import sys, os, json, datetime
try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn

OWNER = 'SCM_MGR'
MARK = "   -- [E20261113-EMPTYCMP] 빈 문자열 비교 보완(Oracle 은 '' 가 NULL)"
# (객체, 유형, [(수정 전 문구, 수정 후 문구, 기대 줄 수, 방식)])  방식 sub = 문구 치환 · comment = 그 줄을 주석으로
SPECS = [
    ('PKG_DMF0035', 'PACKAGE BODY', [("AND NVL(C.ATTRIBUTE8, '''') <> '''' '", "AND C.ATTRIBUTE8 IS NOT NULL '", 2, 'sub')]),
    ('PKG_DMF0045', 'PACKAGE BODY', [("AND A.STORAGE_ID     <> ''", None, 1, 'comment')]),
    ('PKG_DMF0003', 'PACKAGE BODY', [("IF S_FUTURE_VALID IS NOT NULL AND S_FUTURE_VALID <> '' THEN", "IF S_FUTURE_VALID IS NOT NULL THEN", 1, 'sub')]),
    ('PKG_DMF0003_01', 'PACKAGE BODY', [("IF S_FUTURE_VALID IS NOT NULL AND S_FUTURE_VALID <> '' THEN", "IF S_FUTURE_VALID IS NOT NULL THEN", 1, 'sub')]),
    ('PR_SCM_DNM_DELIVERY_TRACKING', 'PROCEDURE', [("= XIF_ERP_DELIVERY_TRACKING_R_SN.ATTRIBUTE1) <> ''", "= XIF_ERP_DELIVERY_TRACKING_R_SN.ATTRIBUTE1) IS NOT NULL", 1, 'sub')]),
    ('DMF0072_GET_ITEM_POPUP_LIST', 'PROCEDURE', [("CASE WHEN NVL(P_MDM_ACTIVE_SW, '') = '' THEN ''", "CASE WHEN P_MDM_ACTIVE_SW IS NULL THEN '@#@#@#'", 8, 'sub')]),
]


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def fetch(cur, name, typ):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=name, t=typ)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=name, t=typ)
    return ''.join(r[0] for r in cur.fetchall()), meta


def ddl(src):
    return 'CREATE OR REPLACE ' + src.rstrip().rstrip('/').rstrip() + '\n'


def build(base, rules):
    NL, CR = chr(10), chr(13)
    lines = base.split(NL)
    changed = []
    for old, new, expect, how in rules:
        n = 0
        for j, ln in enumerate(lines):
            if ln.lstrip().startswith('--') or old not in ln:
                continue
            assert ln.count(old) == 1, '한 줄에 기준 문구 %d건: L%d' % (ln.count(old), j + 1)
            assert '--' not in ln.split(old)[0], '기준 문구가 줄 주석 뒤에 있음: L%d' % (j + 1)
            cr = CR if ln.endswith(CR) else ''
            body = ln.rstrip(CR)
            if how == 'comment':
                ind = body[:len(body) - len(body.lstrip())]
                body = ind + '-- ' + body.strip()
            else:
                body = body.replace(old, new)
            lines[j] = body.rstrip() + MARK + cr
            changed.append(j + 1)
            n += 1
        assert n == expect, '%r 치환 %d줄(기대 %d줄) — 원문이 바뀌었거나 이미 반영됨' % (old, n, expect)
    return NL.join(lines), changed


def errors(cur, name, typ):
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", o=OWNER, n=name, t=typ)
    return cur.fetchall()


def main():
    mode = sys.argv[1]
    only = sys.argv[2:]   # 객체명을 주면 그 객체만
    for d in ('backup', 'tobe', 'logs'):
        os.makedirs(os.path.join(HERE, d), exist_ok=True)
    con = dbconn.connect('tobe', write=(mode == 'apply'))
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVICE_NAME') FROM DUAL")
    print('[%s] %s DB=%s' % (now(), mode, cur.fetchone()[0]))
    rc = 0
    for name, typ, rules in SPECS:
        if only and name not in only:
            continue
        asis = os.path.join(HERE, 'backup', name + '.ASIS.sql')
        tobe_p = os.path.join(HERE, 'tobe', name + '.TOBE.sql')
        base, meta = fetch(cur, name, typ)
        if mode == 'prep':
            open(asis, 'w', encoding='utf-8', newline='').write(ddl(base))
            json.dump(dict(last_ddl=meta[0], status=meta[1], fetched=now()), open(os.path.join(HERE, 'backup', name + '.meta.json'), 'w'))
            tobe, changed = build(base, rules)
            print('  PREP  %-30s LAST_DDL=%s %s 길이=%d → %d · 바뀌는 줄 %s' % (name, meta[0], meta[1], len(base), len(tobe), changed))
        elif mode == 'apply':
            assert ddl(base) == open(asis, encoding='utf-8', newline='').read(), 'FRESH-GATE 실패: %s 착수 후 DB 원문 변경(LAST_DDL=%s) — 중단·재조회·재병합' % (name, meta[0])
            tobe, changed = build(base, rules)
            open(tobe_p, 'w', encoding='utf-8', newline='').write('-- SOURCE-FRESH: %s.%s %s LAST_DDL=%s FETCHED=%s DB=ZIOUI1\n' % (OWNER, name, typ, meta[0], now()) + ddl(tobe) + '/\n')
            try:
                cur.execute(ddl(tobe))
            except Exception as e:
                print('  실행 예외:', dbconn.mask(str(e))[:200])
            errs = errors(cur, name, typ)
            now_src, meta2 = fetch(cur, name, typ)
            if errs or meta2[1] != 'VALID':
                print('  FAIL  %s 컴파일 오류 %d건 STATUS=%s → 원문 복원' % (name, len(errs), meta2[1]))
                for e in errs[:10]:
                    print('     ', e)
                cur.execute(ddl(base))
                print('     복원 후 오류:', errors(cur, name, typ), fetch(cur, name, typ)[1])
                rc = 2
                continue
            cur.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER=:o AND STATUS='INVALID' AND OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES WHERE REFERENCED_OWNER=:o AND REFERENCED_NAME=:n)", o=OWNER, n=name)
            print('  APPLY %-30s LAST_DDL %s → %s STATUS=%s 적용본==DB %s 의존 INVALID %d · 줄 %s' % (
                name, meta[0], meta2[0], meta2[1], ddl(now_src) == ddl(tobe), cur.fetchone()[0], changed))
        elif mode == 'verify':
            t = open(tobe_p, encoding='utf-8', newline='').read()
            t = t[t.index('\n') + 1:]
            same = ddl(base) + '/\n' == t
            cur.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER=:o AND STATUS='INVALID' AND OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES WHERE REFERENCED_OWNER=:o AND REFERENCED_NAME=:n)", o=OWNER, n=name)
            inv = cur.fetchone()[0]
            marks = sum(1 for l in base.split('\n') if 'E20261113-EMPTYCMP' in l)
            ok = same and meta[1] == 'VALID' and not errors(cur, name, typ) and inv == 0
            print('  %s %-30s LAST_DDL=%s STATUS=%s 적용본==DB %s 오류 %d 의존 INVALID %d 표시 줄 %d' % (
                'OK   ' if ok else 'FAIL ', name, meta[0], meta[1], same, len(errors(cur, name, typ)), inv, marks))
            rc = rc or (0 if ok else 1)
    con.rollback()
    con.close()
    sys.exit(rc)


if __name__ == '__main__':
    main()
