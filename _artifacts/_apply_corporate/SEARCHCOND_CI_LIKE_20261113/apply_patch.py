# -*- coding: utf-8 -*-
"""
조회조건 TEXT 입력 — 대소문자 무시 / LIKE 보완 (2026-11-13) 사내 적용기

  python apply_patch.py <PKG> --before     수정 전 시험 실행(결과 저장)
  python apply_patch.py <PKG> --apply      FRESH-GATE 통과 후 CREATE OR REPLACE (실패 시 원문 복원)
  python apply_patch.py <PKG> --after      수정 후 시험 실행 + 전/후 대조
  python apply_patch.py <PKG> --dry        치환만 검사(DB 무변경)

기준본 = 실행 시점에 ALL_SOURCE 에서 새로 조회한 원문(#152). 로컬 파일을 기준으로 쓰지 않는다.
backup\<PKG>.ASIS.sql = 착수 시 조회본(원복용), tobe\<PKG>.TOBE.sql = 적용본.
명세 = specs\<PKG>.py :  TYPE(기본 'PACKAGE BODY'), HUNKS=[(old, new), ...], TESTS=[{...}]
"""
import sys, os, json, time, pickle, importlib.util, datetime, hashlib

try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn

OWNER = 'SCM_MGR'


def now():
    return datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')


def load_spec(name):
    p = os.path.join(HERE, 'specs', name + '.py')
    sp = importlib.util.spec_from_file_location('spec_' + name, p)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def fetch(cur, name, typ):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS "
                "WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=name, t=typ)
    meta = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE",
                o=OWNER, n=name, t=typ)
    src = ''.join(r[0] for r in cur.fetchall())
    return src, meta


def ddl(src):
    return 'CREATE OR REPLACE ' + src.rstrip().rstrip('/').rstrip() + '\n'


MARK = '   /* 2026.11.13 조회조건 대소문자 무시 */'


def apply_rx(out, rx):
    """RX = [(정규식, 치환, 기대 건수)] — 줄 단위 적용. '--' 주석 줄은 건너뛴다. 따옴표 없는 줄 끝에는 표시 주석을 붙인다."""
    import re
    NL, CR = chr(10), chr(13)
    for i, (pat, repl, expect) in enumerate(rx, 1):
        lines = out.split(NL)
        n = 0
        for j, ln in enumerate(lines):
            if ln.lstrip().startswith('--'):
                continue
            new_ln, c = re.subn(pat, repl, ln)
            if c:
                n += c
                cr = CR if new_ln.endswith(CR) else ''
                body = new_ln.rstrip(CR)
                if "'" not in body and '2026.11.13 조회조건' not in body:
                    body = body.rstrip() + MARK
                lines[j] = body + cr
        assert n == expect, 'RX %d: 치환 %d건(기대 %d건) — %s' % (i, n, expect, pat)
        out = NL.join(lines)
    return out


def build(base, hunks):
    out = base
    for i, (old, new) in enumerate(hunks, 1):
        c = out.count(old)
        assert c == 1, 'hunk %d: 기준 문구 매칭 %d건(1건이어야 함) — 원문이 바뀌었거나 이미 반영됨' % (i, c)
        out = out.replace(old, new)
    return out


def errors(cur, name, typ):
    cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE",
                o=OWNER, n=name, t=typ)
    return cur.fetchall()


def run_tests(con, spec, tag, name):
    import oracledb
    res = {}
    cur = con.cursor()
    for t in getattr(spec, 'TESTS', []):
        proc = t['proc']
        pkg, pn = proc.split('.')
        cur.execute("SELECT ARGUMENT_NAME, DATA_TYPE, IN_OUT FROM ALL_ARGUMENTS WHERE OWNER=:o AND PACKAGE_NAME=:p "
                    "AND OBJECT_NAME=:n AND ARGUMENT_NAME IS NOT NULL ORDER BY POSITION", o=OWNER, p=pkg, n=pn)
        args = cur.fetchall()
        for label, val in t['values']:
            kw = {}
            outs = []
            for an, dt, io in args:
                if io == 'OUT':
                    # OUT 인자는 자료형에 맞춰 바인드(문자·숫자 OUT 이 있는 프로시저 대응)
                    v = cur.var(oracledb.DB_TYPE_CURSOR if dt == 'REF CURSOR' else (oracledb.DB_TYPE_NUMBER if dt == 'NUMBER' else str), 32767 if dt not in ('REF CURSOR', 'NUMBER') else 0)
                    kw[an] = v
                    outs.append((an, v))
                elif an == t['vary']:
                    kw[an] = val
                else:
                    kw[an] = t.get('base', {}).get(an)
            t0 = time.time()
            try:
                cur.callproc(proc, keyword_parameters=kw)
                rc = None
                for an, v in outs:
                    if an.upper() in (t.get('cursor', 'O_RC1').upper(),):
                        rc = v.getvalue()
                rows = [tuple(v.read() if hasattr(v, 'read') else v for v in r) for r in rc.fetchall()] if rc is not None else []   # LOB 은 내용으로 비교
                cols = [d[0] for d in rc.description] if rc is not None else []
                keyidx = [cols.index(c) for c in t.get('key', []) if c in cols] or ([i for i, c in enumerate(cols) if c not in t['ignore']] if t.get('ignore') else [])
                keys = sorted(repr(tuple(r[i] for i in keyidx)) if keyidx else repr(r) for r in rows)
                res[(proc, t['vary'], label)] = dict(n=len(rows), keys=keys, sec=round(time.time() - t0, 2), err=None)
            except Exception as e:
                res[(proc, t['vary'], label)] = dict(n=-1, keys=[], sec=round(time.time() - t0, 2), err=dbconn.mask(str(e))[:300])
            con.rollback()
            r = res[(proc, t['vary'], label)]
            print('  [%s] %s %s=%r → %s행 %.2fs %s' % (tag, pn, t['vary'], val, r['n'], r['sec'], r['err'] or ''))
    pickle.dump(res, open(os.path.join(HERE, 'logs', '%s.%s.pkl' % (name, tag)), 'wb'))
    return res


def compare(name, spec):
    b = pickle.load(open(os.path.join(HERE, 'logs', name + '.before.pkl'), 'rb'))
    a = pickle.load(open(os.path.join(HERE, 'logs', name + '.after.pkl'), 'rb'))
    fail = 0
    print('  전/후 대조')
    for k in a:
        rb, ra = b.get(k), a[k]
        sb, sa = set(rb['keys']) if rb else set(), set(ra['keys'])
        lost = len(sb - sa)
        note = ''
        if ra['err'] or (rb and rb['err']):
            note = 'ERROR'; fail += 1
        elif lost:
            note = 'FAIL 수정 전 행 %d건이 수정 후 없음' % lost; fail += 1
        elif k[2].startswith('same:') and sb != sa:
            note = 'FAIL 전후 동일해야 함'; fail += 1
        print('   %s | %s | 전 %s행 %.2fs → 후 %s행 %.2fs | 추가 %d | %s' % (
            k[0].split('.')[1], k[2], rb['n'] if rb else '-', rb['sec'] if rb else 0, ra['n'], ra['sec'], len(sa - sb), note or 'OK'))
    # 같은 그룹(eq:<그룹>:...) 은 수정 후 결과가 서로 같아야 한다(대소문자 무시 확인)
    groups = {}
    for k in a:
        if k[2].startswith('eq:'):
            groups.setdefault((k[0], k[1], k[2].split(':')[1]), []).append(k)
    for g, ks in groups.items():
        sets = [tuple(a[k]['keys']) for k in ks]
        ok = all(s == sets[0] for s in sets)
        if not ok:
            fail += 1
        print('   대소문자 동치 %s %s : %s (%s)' % (g[0].split('.')[1], g[2], 'OK' if ok else 'FAIL', ', '.join('%s=%d행' % (k[2], a[k]['n']) for k in ks)))
    print('  대조 결과: %s' % ('FAIL %d건' % fail if fail else 'FAIL 0'))
    return fail


def main():
    name, mode = sys.argv[1], sys.argv[2]
    spec = load_spec(name) if mode != '--fetch' else None
    typ = getattr(spec, 'TYPE', 'PACKAGE BODY')
    for d in ('backup', 'tobe', 'logs'):
        os.makedirs(os.path.join(HERE, d), exist_ok=True)
    con = dbconn.connect('tobe', write=(mode == '--apply'))
    cur = con.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','SERVICE_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST') FROM DUAL")
    print('[%s] %s %s DB=%s' % (now(), name, mode, cur.fetchone()))
    asis_path = os.path.join(HERE, 'backup', name + '.ASIS.sql')
    if mode == '--fetch':
        base, meta = fetch(cur, name, typ)
        os.makedirs(os.path.join(HERE, 'work'), exist_ok=True)
        open(os.path.join(HERE, 'work', name + '.cur.sql'), 'w', encoding='utf-8', newline='').write(base)
        print('  현재 원문 저장: work/%s.cur.sql LAST_DDL=%s 길이=%d' % (name, meta[0], len(base)))
        return
    if mode in ('--before', '--dry'):
        base, meta = fetch(cur, name, typ)
        print('  원문 조회: LAST_DDL=%s STATUS=%s 길이=%d' % (meta[0], meta[1], len(base)))
        if mode == '--before':
            open(asis_path, 'w', encoding='utf-8', newline='').write(ddl(base))
            json.dump(dict(last_ddl=meta[0], fetched=now()), open(os.path.join(HERE, 'backup', name + '.meta.json'), 'w'))
        tobe = apply_rx(build(base, getattr(spec, 'HUNKS', [])), getattr(spec, 'RX', []))
        print('  치환 검사 OK: hunk %d개, 길이 %d → %d' % (len(getattr(spec, 'HUNKS', [])) + len(getattr(spec, 'RX', [])), len(base), len(tobe)))
        if mode == '--before':
            run_tests(con, spec, 'before', name)
    elif mode == '--apply':
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본
        base, meta = fetch(cur, name, typ)
        assert ddl(base) == open(asis_path, encoding='utf-8', newline='').read(), \
            'FRESH-GATE 실패: 착수 후 DB 원문 변경(LAST_DDL=%s) — 중단·재조회·재병합' % meta[0]
        tobe = apply_rx(build(base, getattr(spec, 'HUNKS', [])), getattr(spec, 'RX', []))
        open(os.path.join(HERE, 'tobe', name + '.TOBE.sql'), 'w', encoding='utf-8', newline='').write(
            '-- SOURCE-FRESH: %s.%s %s LAST_DDL=%s FETCHED=%s DB=ZIOUI1\n' % (OWNER, name, typ, meta[0], now()) + ddl(tobe) + '/\n')
        cur.execute(ddl(tobe))
        errs = errors(cur, name, typ)
        if errs:
            print('  컴파일 오류 %d건 → 원문 복원' % len(errs))
            for e in errs[:10]:
                print('   ', e)
            cur.execute(ddl(base))
            print('  복원 후 오류:', errors(cur, name, typ))
            sys.exit(2)
        now_src, meta2 = fetch(cur, name, typ)
        cur.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER=:o AND STATUS='INVALID' AND OBJECT_NAME IN "
                    "(SELECT NAME FROM ALL_DEPENDENCIES WHERE REFERENCED_OWNER=:o AND REFERENCED_NAME=:n)", o=OWNER, n=name)
        print('  적용 완료: LAST_DDL %s → %s STATUS=%s 적용본==DB %s 의존 INVALID %d' % (
            meta[0], meta2[0], meta2[1], ddl(now_src) == ddl(tobe), cur.fetchone()[0]))
    elif mode == '--after':
        run_tests(con, spec, 'after', name)
        sys.exit(1 if compare(name, spec) else 0)
    con.close()


if __name__ == '__main__':
    main()
