# -*- coding: utf-8 -*-
"""DMF0082 힌트 제거(2026-11-03) — 사내 ZIOUI1 SCM_MGR.PKG_DMF0082 BODY 에서 [E20261102-DMF0082HINT] 7곳만 원래 문구로 되돌린다.
치환 쌍 = 클라우드 패키지 99_ROLLBACK_HINT_PATCH.sql 의 c_new → c_anc (동일 원문). 다른 변경은 건드리지 않는다.
  python remove_hint.py check   # 조회·검증만(무변경)
  python remove_hint.py apply   # 신선도 확인 → 컴파일 → VALID·오류 0·원문 일치 확인 (실패 시 백업 복원)
"""
import sys, os, re, json, hashlib, datetime
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
R = r'C:\Projects\NSCM'; HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(R, 'tools', 'DbConn')); import dbconn
OWNER, PKG, TYP, MARK = 'SCM_MGR', 'PKG_DMF0082', 'PACKAGE BODY', 'E20261102-DMF0082HINT'
RB = os.path.join(R, r'_artifacts\_deploy_packages\DMF0082_HINT_CLOUD_20261102\A_DB\99_ROLLBACK_HINT_PATCH.sql')
ORIG = os.path.join(R, r'_artifacts\_apply_corporate\DMF0082_HINT_20261102\00_BACKUP_PKG_DMF0082_BODY.sql')
now = lambda: datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
md5 = lambda s: hashlib.md5(s.encode()).hexdigest()

def parse_pairs():
    t = open(RB, encoding='utf-8').read()
    def expr(name):
        out = {}
        for m in re.finditer(r'\b' + name + r'\((\d+)\)\s*:=', t):
            i, pos, parts = int(m.group(1)), m.end(), []
            while True:
                s = re.compile(r"\s*('(?:[^']|'')*'|CHR\(10\))\s*(\|\||;)", re.S).match(t, pos)
                assert s, f'{name}({i}) 해석 실패 @ {pos}'
                tok = s.group(1); parts.append('\n' if tok == 'CHR(10)' else tok[1:-1].replace("''", "'"))
                pos = s.end()
                if s.group(2) == ';': break
            out[i] = ''.join(parts)
        return out
    anc, new, nm = expr('c_anc'), expr('c_new'), {int(a): b for a, b in re.findall(r"c_name\((\d+)\) := '([^']*)'", t)}
    assert sorted(anc) == sorted(new) == sorted(nm) == list(range(1, 8)), (sorted(anc), sorted(new))
    return [(nm[i], new[i], anc[i]) for i in range(1, 8)]

def fetch(c):
    c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=PKG, t=TYP)
    return ''.join(r[0] or '' for r in c.fetchall())
def info(c):
    c.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=PKG, t=TYP)
    return c.fetchone()
def errors(c):
    c.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY SEQUENCE", o=OWNER, n=PKG, t=TYP)
    return c.fetchall()
def invalid(c):
    c.execute("SELECT COUNT(*) FROM ALL_OBJECTS WHERE OWNER=:o AND STATUS='INVALID'", o=OWNER); return c.fetchone()[0]
def compile_src(c, src):
    try: c.execute('CREATE OR REPLACE ' + src.rstrip() + '\n')
    except Exception as e:
        if 'ORA-24344' not in str(e): raise
    return errors(c)

def build(src, pairs):
    rep = []
    for name, new, anc in pairs:
        n = src.count(new); rep.append((name, n))
        assert n == 1, f'중단 — {name} 적용 문구 {n}건(1 기대). 원문 무변경'
    out = src
    for name, new, anc in pairs: out = out.replace(new, anc)
    assert MARK not in out and 'V_HINT82' not in out, '중단 — 제거 뒤 마커/치환자 잔존'
    return out, rep

def main():
    mode = sys.argv[1]
    cx = dbconn.connect('tobe', dbconn.load_cfg(), write=(mode == 'apply')); c = cx.cursor()
    c.execute("SELECT SYS_CONTEXT('USERENV','DB_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST'), SYS_CONTEXT('USERENV','SESSION_USER'), SYS_CONTEXT('USERENV','CURRENT_SCHEMA') FROM DUAL")
    print(now(), '접속', c.fetchone())
    pairs = parse_pairs(); src = fetch(c); st = info(c)
    print('현재 BODY', st, '줄', src.count('\n'), '마커', src.count(MARK), 'md5', md5(src))
    if src.count(MARK) == 0: print('SKIP — 마커 없음'); return
    new, rep = build(src, pairs)
    print('치환 매칭', rep); print('제거본 줄', new.count('\n'), '마커', new.count(MARK))
    orig = open(ORIG, encoding='utf-8', newline='\n').read()
    o = orig[orig.index('PACKAGE BODY'):] if 'PACKAGE BODY' in orig[:200] else orig
    import difflib
    d = [l for l in difflib.unified_diff(o.rstrip().split('\n'), new.rstrip().split('\n'), '10-27 원본(힌트 전)', '제거본', n=0, lineterm='') if not l.startswith(('---', '+++'))]
    print('힌트 전 원본(10-27)과 제거본의 차이 줄', len(d)); open(os.path.join(HERE, '_diff_vs_1027_original.txt'), 'w', encoding='utf-8').write('\n'.join(d))
    if mode == 'check': return
    bk = os.path.join(HERE, '00_BACKUP_BEFORE_REMOVE.sql')
    open(bk, 'w', encoding='utf-8', newline='\n').write('CREATE OR REPLACE ' + src.rstrip() + '\n/\n')
    open(os.path.join(HERE, '01_PKG_DMF0082_BODY_HINT_REMOVED.sql'), 'w', encoding='utf-8', newline='\n').write('CREATE OR REPLACE ' + new.rstrip() + '\n/\n')
    inv0 = invalid(c)
    again = fetch(c); assert md5(again) == md5(src), 'FRESH-GATE 실패 — 조회 후 DB 원문 변경. 중단'
    print(now(), 'FRESH-GATE PASS · INVALID', inv0)
    errs = compile_src(c, new); st2 = info(c); got = fetch(c)
    print(now(), '적용 BODY', st2, '오류', len(errs), errs[:10], 'INVALID', invalid(c), '적용본 == DB 원문', got.rstrip() == new.rstrip(), '마커', got.count(MARK))
    if errs or st2[1] != 'VALID' or got.rstrip() != new.rstrip():
        print('실패 → 백업 복원', compile_src(c, src), info(c), 'md5 일치', md5(fetch(c)).strip() == md5(src)); sys.exit(1)
    json.dump({'at': now(), 'before': {'ddl': st[0], 'md5': md5(src), 'lines': src.count('\n')}, 'after': {'ddl': st2[0], 'status': st2[1], 'md5': md5(got), 'lines': got.count('\n')}, 'pairs': rep, 'invalid': [inv0, invalid(c)]}, open(os.path.join(HERE, '_apply_result.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)

main()
