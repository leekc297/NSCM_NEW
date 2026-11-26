# -*- coding: utf-8 -*-
"""화면 소스 기준선(지문) — 수정분 재점검의 바탕 (2026-11-20 사용자 지시)
   "CHECKLIST 의 기능에 전체기능 재점검 과 수정분 재점검 으로 기능을 분리 … 수정분 재점검의 경우에는 이전 수행과 달라진 소스의 범위안에서만 테스트를 진행"

  python tools/Harness/verify/source_snap.py <ID> --save         지금 지문을 기준선으로 저장(Doc/verify/<ID>/source_baseline.json) — CheckList 정상 종료 때 run_verify 가 부름
  python tools/Harness/verify/source_snap.py <ID> --diff         기준선과 지금 비교 → 바뀐 항목(JSON 출력, Doc/verify/<ID>/source_diff.json)
  python tools/Harness/verify/source_snap.py --selftest

  지문 항목(키 = 종류:이름 → 값 = 해시)
    fe:<nscm-fe 상대경로>           화면 페이지 폴더 파일(prereq.page_dir) · git blob 해시와 같은 방식(sha1 'blob <len>\\0'+내용)
    shared:<상대경로>               화면 파일이 import 하는 @shared/<이름> 파일(lib/*.ts(x) 또는 폴더 아래 전부)
    db:<OWNER.객체[.PROC]>          syn_check.csv 의 PROC·COMBO 객체 ALL_SOURCE 본문(패키지 안 PROC 는 그 PROCEDURE/FUNCTION 구간)
    meta:<표>:<키>                  SCM_MST_SHEET_COLUMNS(PROGRAM_ID=<ID>) 행 · SCM_ADM_MNU_BTN_MPG_M(MNU_ID) 행 · SCM_ADM_MNU_M(MNU_ID) 행
    ledger:def                      원장 항목 정의(asis_fp.ledger_fp)
    test:<스펙>:<시험 제목>          검사 스펙의 시험(test 블록) 본문
    lib:<상대경로>                  tools/E2E/lib/*.ts · tools/E2E/fixtures/*.ts · tools/Harness/verify/*.py
    asis:<상대경로>                 Doc/asisfacts/screens/<ASIS ID> 파일
  DB 를 읽지 못하면 db·meta 항목은 'unknown' — 비교에서 바뀐 것으로 본다(모르는 것은 재측정 쪽)
"""
import csv, datetime, glob, hashlib, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, HERE); sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
csv.field_size_limit(10 ** 8)
SPECS = ['_verify.spec.ts', '_trace.spec.ts', '_snap.spec.ts', 'eg_popup.spec.ts', 'eg_auth.spec.ts', '_open.spec.ts']
UNKNOWN = 'unknown'


def blob(data):
    return hashlib.sha1(b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest()


def fhash(p):
    try:
        with open(p, 'rb') as f:
            return blob(f.read())
    except OSError:
        return ''


def rel(p):
    return os.path.relpath(p, ROOT).replace(os.sep, '/')


def asis_of(mid):
    try:
        with open(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'map_screen.csv'), encoding='utf-8-sig', newline='') as f:
            for r in csv.DictReader(f):
                if (r.get('tobe_id') or r.get('menu_id') or '').upper() == mid:
                    return (r.get('asis_id') or mid).upper()
    except OSError:
        pass
    return mid


def fe_items(mid):
    out = {}
    try:
        from prereq import page_dir
        pdir = page_dir(mid)
    except Exception:
        pdir = ''
    if not pdir or not os.path.isdir(pdir):
        return out, ''
    for dp, _dn, fns in os.walk(pdir):
        for fn in fns:
            if fn.endswith(('.ts', '.tsx', '.css', '.scss', '.json', '.md')):
                p = os.path.join(dp, fn); out['fe:' + rel(p)] = fhash(p)
    return out, pdir


def shared_items(pdir):
    """화면 파일이 쓰는 @shared/<이름> 의 실제 파일(packages/shared/src/lib/<이름>.ts(x) · 폴더면 아래 전부)"""
    out = {}
    if not pdir:
        return out
    sh = os.path.join(ROOT, 'nscm-fe', 'packages', 'shared', 'src'); names = set()
    for dp, _dn, fns in os.walk(pdir):
        for fn in fns:
            if fn.endswith(('.ts', '.tsx')):
                try:
                    names |= set(re.findall(r"""from\s+['"]@shared/([A-Za-z0-9_-]+)['"]""", open(os.path.join(dp, fn), encoding='utf-8').read()))
                except (OSError, ValueError):
                    pass
    for n in sorted(names):
        d = os.path.join(sh, n)
        if os.path.isdir(d):
            for dp, _dn, fns in os.walk(d):
                for fn in fns:
                    if fn.endswith(('.ts', '.tsx')) and '.test.' not in fn:
                        p = os.path.join(dp, fn); out['shared:' + rel(p)] = fhash(p)
        else:
            for e in ('.ts', '.tsx'):
                p = os.path.join(sh, 'lib', n + e)
                if os.path.exists(p):
                    out['shared:' + rel(p)] = fhash(p)
    return out


def db_objects(mid):
    objs = set()
    try:
        with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'syn_check.csv'), encoding='utf-8-sig', newline='') as f:
            for r in csv.DictReader(f):
                if r.get('kind') not in ('PROC', 'COMBO'):
                    continue
                res = (r.get('resolved') or '').strip(); nm = (r.get('name') or '').strip()
                if not res:
                    continue
                proc = nm.split('.', 1)[1] if '.' in nm else ''
                objs.add((res.upper(), proc.upper()))
    except OSError:
        pass
    return sorted(objs)


def proc_body(src, proc):
    """패키지 본문에서 PROCEDURE/FUNCTION <proc> 구간(다음 PROCEDURE/FUNCTION 머리 전까지). 못 찾으면 전체"""
    if not proc:
        return src
    m = re.search(r'(?im)^\s*(PROCEDURE|FUNCTION)\s+' + re.escape(proc) + r'\b', src)
    if not m:
        return src
    n = re.search(r'(?im)^\s*(PROCEDURE|FUNCTION)\s+\w+', src[m.end():])
    return src[m.start(): m.end() + (n.start() if n else len(src) - m.end())]


def db_items(mid):
    out = {}; objs = db_objects(mid)
    metaq = [('SCM_MST_SHEET_COLUMNS', "SELECT * FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID = :m"),
             ('SCM_ADM_MNU_BTN_MPG_M', "SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = :m"),
             ('SCM_ADM_MNU_M', "SELECT * FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID = :m")]
    try:
        from dbconn import connect
        with connect('tobe') as cx:
            cur = cx.cursor()
            for full, proc in objs:
                owner, name = (full.split('.', 1) + [''])[:2] if '.' in full else ('SCM_MGR', full)
                cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER = :o AND NAME = :n AND TYPE IN ('PACKAGE BODY','PROCEDURE','FUNCTION') ORDER BY TYPE, LINE", o=owner, n=name)
                src = ''.join(r[0] or '' for r in cur.fetchall())
                out['db:' + full + (('.' + proc) if proc else '')] = blob(proc_body(src, proc).encode('utf-8')) if src else 'missing'
            for tbl, q in metaq:
                cur.execute(q, m=mid); cols = [d[0] for d in cur.description]
                skip = {c for c in cols if c in ('LAST_UPDATE_DATE', 'LAST_UPDATED_BY', 'CREATION_DATE', 'CREATED_BY', 'LAST_UPDATE_LOGIN')}
                for row in cur.fetchall():
                    d = {c: ('' if v is None else str(v)) for c, v in zip(cols, row) if c not in skip}
                    key = d.get('COLUMN_NAME') or d.get('BTN_ID') or d.get('API_ID') or d.get('MNU_ID') or hashlib.sha1(json.dumps(d, sort_keys=True).encode()).hexdigest()[:8]
                    sub = d.get('SHEET_ID') or d.get('SHEET_NAME') or ''
                    out[f'meta:{tbl}:{sub}:{key}'] = hashlib.sha1(json.dumps(d, sort_keys=True, ensure_ascii=False).encode('utf-8')).hexdigest()[:16]
        return out, ''
    except Exception as e:  # DB 를 못 읽으면 db·meta 는 unknown — 비교에서 '바뀐 것' 쪽
        for full, proc in objs:
            out['db:' + full + (('.' + proc) if proc else '')] = UNKNOWN
        out['meta:*'] = UNKNOWN
        return out, f'{type(e).__name__}: {str(e)[:160]}'


def test_blocks(path):
    """스펙 파일 → {시험 제목: 본문 해시}. test('제목' 부터 다음 test( 머리 전까지"""
    out = {}
    try:
        src = open(path, encoding='utf-8').read()
    except OSError:
        return out
    heads = list(re.finditer(r"""(?m)^\s*test\(\s*(['"`])((?:\\.|(?!\1).)*)\1""", src))
    for i, m in enumerate(heads):
        end = heads[i + 1].start() if i + 1 < len(heads) else len(src)
        out[m.group(2)] = blob(src[m.start():end].encode('utf-8'))
    head = src[:heads[0].start()] if heads else src
    out['(머리말)'] = blob(head.encode('utf-8'))
    return out


def engine_items():
    out = {}
    sd = os.path.join(ROOT, 'Doc', 'e2e', 'specs')
    for s in SPECS:
        for t, h in test_blocks(os.path.join(sd, s)).items():
            out[f'test:{s}:{t}'] = h
    for pat in (os.path.join(ROOT, 'tools', 'E2E', 'lib', '*.ts'), os.path.join(ROOT, 'tools', 'E2E', 'fixtures', '*.ts'), os.path.join(ROOT, 'tools', 'Harness', 'verify', '*.py')):
        for p in glob.glob(pat):
            out['lib:' + rel(p)] = fhash(p)
    return out


def asis_items(mid):
    out = {}; d = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', asis_of(mid))
    for dp, _dn, fns in os.walk(d):
        for fn in fns:
            p = os.path.join(dp, fn); out['asis:' + rel(p)] = fhash(p)
    return out


def snapshot(mid):
    import asis_fp
    fe, pdir = fe_items(mid); items = dict(fe); items.update(shared_items(pdir))
    dbi, dberr = db_items(mid); items.update(dbi)
    items['ledger:def'] = asis_fp.ledger_fp(mid) or UNKNOWN
    items.update(engine_items()); items.update(asis_items(mid))
    return {'menu_id': mid, 'at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'db_error': dberr, 'items': items}


def diff(base, cur):
    """(바뀜 [키], 새로 생김 [키], 없어짐 [키]) — unknown 은 양쪽 어디든 바뀐 것으로"""
    b = base.get('items') or {}; c = cur.get('items') or {}
    changed = sorted(k for k in c if k in b and (c[k] != b[k] or c[k] == UNKNOWN))
    added = sorted(k for k in c if k not in b); removed = sorted(k for k in b if k not in c)
    return changed, added, removed


def path_of(mid, name):
    return os.path.join(ROOT, 'Doc', 'verify', mid, name)


def save(mid, mode='', snap=None):
    s = snap or snapshot(mid); s['mode'] = mode
    p = path_of(mid, 'source_baseline.json'); os.makedirs(os.path.dirname(p), exist_ok=True)
    if mode == 'full':
        s['last_full'] = s['at']
    else:
        try:
            s['last_full'] = json.load(open(p, encoding='utf-8')).get('last_full', '')
        except (OSError, ValueError):
            s['last_full'] = ''
    tmp = p + '.tmp'; json.dump(s, open(tmp, 'w', encoding='utf-8'), ensure_ascii=False, indent=0); os.replace(tmp, p)
    try:  # 다음 수정분 재점검에서 차이 본문을 보이려고 텍스트 항목 내용을 내용 저장소에(같은 해시는 한 번만 · delta_scope.remember)
        import delta_scope; delta_scope.remember(s)
    except Exception as e:
        print(f'[WARN] 내용 저장소 기록 실패({e}) — 다음 비교에서 차이 대신 지금 내용만 보임', flush=True)
    return s


def load(mid):
    try:
        return json.load(open(path_of(mid, 'source_baseline.json'), encoding='utf-8'))
    except (OSError, ValueError):
        return None


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    b = {'items': {'fe:a.tsx': '1', 'fe:b.tsx': '2', 'db:X.P': '3', 'meta:*': '4'}}
    c = {'items': {'fe:a.tsx': '1', 'fe:b.tsx': '9', 'db:X.P': UNKNOWN, 'test:_verify.spec.ts:t': '5', 'meta:*': '4'}}
    ch, ad, rm = diff(b, c)
    chk('바뀜 = 내용 다름 + DB 모름', ch == ['db:X.P', 'fe:b.tsx'])
    chk('새로 생김 · 없어짐', ad == ['test:_verify.spec.ts:t'] and rm == [])
    chk('같으면 차이 0', diff(b, b) == ([], [], []))
    src = "PACKAGE BODY P AS\n  PROCEDURE A IS BEGIN x; END;\n  PROCEDURE B IS BEGIN y; END;\nEND;"
    chk('패키지 안 PROC 구간', 'y;' not in proc_body(src, 'A') and 'x;' in proc_body(src, 'A') and 'y;' in proc_body(src, 'B'))
    import tempfile
    d = tempfile.mkdtemp(); p = os.path.join(d, 's.spec.ts')
    open(p, 'w', encoding='utf-8').write("import x;\ntest.describe('d', () => {\n  test('가 시험', async () => { a(); });\n  test(`나 시험`, async () => { b(); });\n});\n")
    tb = test_blocks(p)
    chk('시험 블록 분리', set(tb) == {'가 시험', '나 시험', '(머리말)'})
    open(p, 'w', encoding='utf-8').write("import x;\ntest.describe('d', () => {\n  test('가 시험', async () => { a(); });\n  test(`나 시험`, async () => { b2(); });\n});\n")
    tb2 = test_blocks(p)
    chk('한 시험만 바뀌면 그 블록만 다름', tb['가 시험'] == tb2['가 시험'] and tb['나 시험'] != tb2['나 시험'])
    chk('blob 해시 = git 방식', blob(b'hello\n') == 'ce013625030ba8dba906f756967f9e9ca394464a')
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    if not a:
        print(__doc__); return 2
    mid = a[0].upper()
    if '--save' in a:
        mode = 'full' if '--full' in a else 'delta'
        s = save(mid, mode)
        print(f"[기준선] {mid} 저장 · 항목 {len(s['items'])}개 · {('DB 읽기 실패 ' + s['db_error']) if s['db_error'] else 'DB 읽음'} · {mode} → Doc/verify/{mid}/source_baseline.json", flush=True); return 0
    if '--diff' in a:
        base = load(mid)
        if not base:
            print(json.dumps({'menu_id': mid, 'baseline': None}, ensure_ascii=False)); return 3
        cur = snapshot(mid); ch, ad, rm = diff(base, cur)
        out = {'menu_id': mid, 'baseline_at': base.get('at'), 'last_full': base.get('last_full', ''), 'now': cur['at'], 'db_error': cur['db_error'],
               'changed': ch, 'added': ad, 'removed': rm, 'n_base': len(base.get('items') or {})}
        json.dump(out, open(path_of(mid, 'source_diff.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
        print(json.dumps({k: (v if not isinstance(v, list) else len(v)) for k, v in out.items()}, ensure_ascii=False)); return 0
    print(__doc__); return 2


if __name__ == '__main__':
    sys.exit(main())
