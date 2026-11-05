# -*- coding: utf-8 -*-
"""사내 적용: 최신 원문 조회 → 앵커 치환 → (--apply) FRESH-GATE → 컴파일 → 검증.
사용: python build_apply.py          (백업·적용본 생성만)
      python build_apply.py --apply  (적용)
      python build_apply.py --restore (백업으로 원복)"""
import sys, os, re, time
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
sys.stdout.reconfigure(encoding='utf-8')
import dbconn
from patch_def import PATCHES, MARK

HERE = os.path.dirname(os.path.abspath(__file__))
cx = dbconn.connect('tobe', dbconn.load_cfg()); c = cx.cursor()
HEAD = {'PROCEDURE': 'PROCEDURE', 'PACKAGE BODY': 'PACKAGE BODY'}


def fetch(n, t):
    c.execute("select text from all_source where owner='SCM_MGR' and name=:n and type=:t order by line", n=n, t=t)
    return ''.join(r[0] for r in c.fetchall())


def state(n, t):
    c.execute("select status, to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') from all_objects where owner='SCM_MGR' and object_name=:n and object_type=:t", n=n, t=t)
    return c.fetchone()


def patch(src, items):
    out = src
    for beg, end, pat, where, block in items:
        lo, hi = 0, len(out)
        if beg:
            lo = out.index(beg + '\n') if (beg + '\n') in out else out.index(beg)
            hi = out.index(end, lo)
        ms = list(re.finditer(pat, out[lo:hi]))
        assert len(ms) == 1, f'앵커 건수 {len(ms)}: {pat[:60]}'
        m = ms[0]
        if where == 'after':
            pos = lo + m.end()
        elif where == 'before_begin':
            # 바로 앞 BEGIN 앞(중복제거 블록 시작 앞)에 넣는다
            pos = out.rindex('BEGIN', lo, lo + m.start())
            pos = out.rindex('\n', 0, pos) + 1
        out = out[:pos] + block + out[pos:]
    return out


def ddl(n, t, text):
    # 머리글을 그대로 둔다(스키마를 붙이면 Oracle 이 첫 줄을 바꿔 저장). 세션 CURRENT_SCHEMA = SCM_MGR 에 생성되므로 적용 후 소유자를 확인한다.
    return 'CREATE OR REPLACE ' + text.rstrip()


def norm(text):
    """첫 줄 표기(공백·따옴표)만 무시한 비교용."""
    head, _, rest = text.partition('\n')
    return re.sub(r'[\s"]+', ' ', head).strip() + '\n' + rest.rstrip()


def compile_one(n, t, text):
    c.execute(ddl(n, t, text))  # 컴파일 오류는 ALL_ERRORS 로 판정
    c.execute("select count(*) from all_errors where owner='SCM_MGR' and name=:n and type=:t", n=n, t=t)
    return c.fetchone()[0]


mode = sys.argv[1] if len(sys.argv) > 1 else ''
c.execute("select to_char(sysdate,'YYYY-MM-DD HH24:MI:SS') from dual"); print('at', c.fetchone()[0])
if mode == '--restore':
    for n, t, _ in PATCHES:
        base = open(os.path.join(HERE, f'{n}.ASIS.txt'), encoding='utf-8', newline='').read()
        print(n, 'errors', compile_one(n, t, base), state(n, t), 'same', fetch(n, t).rstrip() == base.rstrip())
    sys.exit(0)

plans = []
for n, t, items in PATCHES:
    live = fetch(n, t)
    assert live, n
    assert MARK not in live, f'이미 적용됨: {n}'
    asis_path = os.path.join(HERE, f'{n}.ASIS.txt')
    if os.path.exists(asis_path):
        # 최초 백업을 보존한다. 원문이 그 사이 바뀌었으면(첫 줄 표기 제외) 중단한다.
        base = open(asis_path, encoding='utf-8', newline='').read()
        assert norm(live) == norm(base), f'FRESH-GATE 실패: {n} 백업 후 원문 변경'
    else:
        base = live
        open(asis_path, 'w', encoding='utf-8', newline='').write(base)
    tobe = patch(base, items)
    open(os.path.join(HERE, f'{n}.TOBE.txt'), 'w', encoding='utf-8', newline='').write(tobe)
    print(n, t, state(n, t), 'lines', base.count('\n'), '->', tobe.count('\n'), 'marks', tobe.count(MARK))
    plans.append((n, t, base, tobe))

if mode == '--apply':
    c.execute("select count(*) from all_objects where owner='SCM_MGR' and status='INVALID'"); inv0 = c.fetchone()[0]
    done = []
    try:
        for n, t, base, tobe in plans:
            assert norm(fetch(n, t)) == norm(base), f'FRESH-GATE 실패: {n} 착수 후 변경'
            errs = compile_one(n, t, tobe)
            print(n, 'compiled errors', errs, state(n, t), time.strftime('%H:%M:%S'), flush=True)
            done.append((n, t, base))
            assert errs == 0, f'컴파일 오류 {n}'
            assert fetch(n, t).rstrip() == tobe.rstrip(), f'적용본 불일치 {n}'
            c.execute("select count(*) from all_objects where owner='SYSTEM' and object_name=:n", n=n)
            assert c.fetchone()[0] == 0, f'SYSTEM 에 생성됨 {n}'
    except Exception as e:
        print('FAIL', e, '-> 적용분 원복')
        c.execute("select line, position, text from all_errors where owner='SCM_MGR' and name=:n order by sequence", n=done[-1][0] if done else '')
        for r in c.fetchall(): print(r)
        for n, t, base in reversed(done):
            print('restore', n, compile_one(n, t, base), state(n, t))
        sys.exit(1)
    c.execute("select count(*) from all_objects where owner='SCM_MGR' and status='INVALID'"); print('INVALID', inv0, '->', c.fetchone()[0])
