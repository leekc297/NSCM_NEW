# -*- coding: utf-8 -*-
"""F10 저장 트랜잭션 원자성 — 화면 저장 PROC(PROC_M SAVE/INS/UPD/DEL 배선)와 그 하위 호출 PROC 본문(사내오라클 ALL_SOURCE 새로 조회 · hook #152)에
암묵 확정 문장(COMMIT · ROLLBACK TO 외 · TRUNCATE · DDL EXECUTE IMMEDIATE · DBMS_STATS · PRAGMA AUTONOMOUS_TRANSACTION)이 있는지 (2026-10-30 WP9 · GAP-452·GAP-105)

  python tools/Harness/verify/f10_check.py <MENU_ID>     → Doc/verify/<ID>/f10_check.csv (judge 가 원장 SP F10 행에 반입)

판정: 저장 PROC 본문 + 전 깊이 하위 호출(순환 방지 · 깊이 상한 8 · 2026-11-02 EG191)(같은/다른 PKG 의 P_… 호출)에서 위 문장 0건 = PASS · 1건 이상 = FAIL(문장·줄 인용) · PROC 본문 없음 = REVIEW
한계: 동적 SQL 문자열 안 호출은 추적하지 못한다 · depth 열 = 도달한 최대 깊이
"""
import argparse, csv, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
DOC = os.path.join(ROOT, 'Doc')
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); sys.path.insert(0, HERE)
from facts_sortrules import strip_comments  # noqa: E402  # SQL 주석(--·/* */) 제거 — facts_combosrc 판은 // 만 지운다(T37)
from sort_check import proc_body  # noqa: E402


def rdcsv(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))


def tail(s):
    return (s or '').split('.')[-1].upper()

RX_BAD = [('COMMIT', re.compile(r'(?i)(?<![A-Z_])COMMIT\s*;')), ('ROLLBACK(전체)', re.compile(r'(?i)(?<![A-Z_])ROLLBACK\s*;')), ('TRUNCATE', re.compile(r'(?i)\bTRUNCATE\s+TABLE\b')),
          ('DDL EXECUTE IMMEDIATE', re.compile(r'(?i)EXECUTE\s+IMMEDIATE\s*\'\s*(ALTER(?!\s+SESSION\b)|CREATE|DROP|TRUNCATE)\b')), ('DBMS_STATS', re.compile(r'(?i)\bDBMS_STATS\.')), ('AUTONOMOUS_TRANSACTION', re.compile(r'(?i)PRAGMA\s+AUTONOMOUS_TRANSACTION'))]
RX_CALL = re.compile(r'(?i)\b((?:[A-Z0-9_]+\.)?P_[A-Z0-9_]+|PR_[A-Z0-9_]+)\s*\(')


def bad_hits(chain):
    """하위 호출 중 PRAGMA AUTONOMOUS_TRANSACTION 프로시저(로그 등)는 자기 트랜잭션만 확정하므로 저장 원자성과 무관 — 제외(2026-11-02 PR_SCM_SYS_LOG_BATCH 허위 FAIL)"""
    hits = []
    for depth, name, b in chain:
        if depth and re.search(r'(?i)PRAGMA\s+AUTONOMOUS_TRANSACTION', b):
            continue
        for lab, rx in RX_BAD:
            for mm in rx.finditer(b):
                line = b[:mm.start()].count('\n') + 1
                ctx = b[max(0, mm.start() - 40):mm.end() + 40].replace('\n', ' ')
                if lab == 'ROLLBACK(전체)' and re.search(r'(?i)EXCEPTION', b[:mm.start()][-400:]): continue  # 예외 처리의 ROLLBACK 은 원자성 보장(허용)
                if lab == 'ROLLBACK(전체)' and depth == 0 and not re.search(r'(?i)(?<![A-Z_])COMMIT\s*;', b[:mm.start()]): continue  # T71: 최상위 저장 PROC 의 ROLLBACK(앞에 COMMIT 없음) = 이번 저장 전체 취소(업무 검증 실패 분기 · SCP0037:114) — 부분 저장 없음
                if lab == 'COMMIT' and depth == 0 and benign_commit(b, mm.start()): continue  # T71 — 최상위 저장 PROC 만(하위 PROC 끝 COMMIT 은 상위 반복 안에서 중간 확정)
                hits.append(f'{name}:{line} {lab} «{ctx.strip()[:90]}»')
    return hits


RX_DML = re.compile(r'(?i)\b(INSERT\s+INTO|UPDATE\s+[A-Z0-9_.]+\s+SET|DELETE\s+FROM|MERGE\s+INTO)\b')
RX_SUBCALL = re.compile(r'(?i)\b((?:[A-Z0-9_]+\.)?P_[A-Z0-9_]+|PR_[A-Z0-9_]+)\s*\(')


def benign_commit(b, pos):
    """2026-11-06 T71(SCP0122 F10 허위 FAIL): 원자성을 깨지 않는 COMMIT —
    ① ROLLBACK 뒤 예외 처리부의 COMMIT(오류 로그 확정 · 업무 변경은 이미 롤백) ② 최종 COMMIT = 열린 LOOP 밖이고, 뒤(예외부 전까지)에 DML·로그 외 하위 호출이 없음.
    반복 안·중간 COMMIT(뒤에 DML 이 남음)은 계속 FAIL."""
    before = b[:pos]
    if re.search(r'(?i)\bEXCEPTION\b', before[-600:]) and re.search(r'(?i)\bROLLBACK\s*;', before[-600:]):
        return True
    opens = len(re.findall(r'(?i)\bLOOP\b', before)) - 2 * len(re.findall(r'(?i)\bEND\s+LOOP\b', before))
    if opens > 0:
        return False
    after = b[pos:]
    mex = re.search(r'(?i)\bEXCEPTION\b', after)
    seg = after[:mex.start()] if mex else after
    if RX_DML.search(seg):
        return False
    calls = [c for c in RX_SUBCALL.findall(seg) if not re.search(r'(?i)LOG|(^|\.)P_OPEN_', c)]  # 로그·결과 커서 열기(P_OPEN_SUCCESS — SCP0084:78)는 업무 변경 아님
    return not calls


def walk_calls(root_name, root_pkg, root_body, resolve, limit=8):
    """호출 그래프 너비 우선 — resolve(pkg, proc) → 본문('' 이면 미발견). 반환 [(depth, 이름, 본문)] · 순환·중복 제외"""
    chain = [(0, root_name, root_body)]; seen = {tail(root_name).upper()}; queue = [(0, root_pkg, root_body)]
    while queue:
        depth, pkg, body = queue.pop(0)
        if depth >= limit:
            continue
        for m in RX_CALL.finditer(body):
            nm = m.group(1).upper(); key = tail(nm)
            if key in seen:
                continue
            seen.add(key)
            cpkg, cproc = (nm.split('.') + [''])[:2] if '.' in nm else (pkg, nm)
            cb = resolve(cpkg, cproc)
            if not cb and cpkg and '.' not in nm:
                cb = resolve('', cproc)
                cpkg = '' if cb else cpkg
            if cb:
                chain.append((depth + 1, f'{cpkg}.{cproc}' if cpkg else cproc, cb))
                queue.append((depth + 1, cpkg, cb))
    return chain


def selftest():
    B = {('', 'A'): 'begin P_B(1); end;', ('', 'P_B'): 'begin PR_C(1); end;', ('', 'PR_C'): 'begin COMMIT; P_B(1); end;'}
    ch = walk_calls('A', '', B[('', 'A')], lambda p, q: B.get((p, q), ''))
    cases = [('2단계 아래까지 도달', [d for d, _, _ in ch] == [0, 1, 2], True), ('순환 멈춤', len(ch) == 3, True), ('깊은 COMMIT 검출', any(RX_BAD[0][1].search(b) for _, _, b in ch), True), ('상한', len(walk_calls('A', '', B[('', 'A')], lambda p, q: B.get((p, q), ''), limit=1)) == 2, True), ('자율 트랜잭션 하위 제외', bad_hits([(0, 'A', 'begin null; end;'), (1, 'LOG', 'pragma autonomous_transaction; begin commit; end;')]) == [], True), ('일반 하위 COMMIT 검출', len(bad_hits([(0, 'A', 'x'), (1, 'B', 'begin commit; end;')])) == 1, True), ('미발견 호출 무시', len(walk_calls('A', '', 'begin P_X(1); end;', lambda p, q: '')) == 1, True)]
    # T71 — 최종 COMMIT·예외부 COMMIT 은 허용, 반복 안·중간 COMMIT 은 검출
    fin = 'BEGIN FOR I IN 1..N LOOP UPDATE T SET A=1; END LOOP; PR_SCM_SYS_LOG_BATCH(1); COMMIT; OPEN O_RC1 FOR SELECT 1 FROM DUAL; EXCEPTION WHEN OTHERS THEN ROLLBACK; PR_SCM_SYS_LOG_BATCH(2); COMMIT; END;'
    inloop = 'BEGIN FOR I IN 1..N LOOP UPDATE T SET A=1; COMMIT; END LOOP; END;'
    mid_ = 'BEGIN UPDATE T SET A=1; COMMIT; DELETE FROM T2; END;'
    cases += [('최종 COMMIT 허용', bad_hits([(0, 'X', fin)]) == [], True), ('반복 안 COMMIT 검출', len(bad_hits([(0, 'X', inloop)])) == 1, True), ('중간 COMMIT(뒤 DML) 검출', len(bad_hits([(0, 'X', mid_)])) == 1, True)]
    # T287 — 세션 설정문은 암묵 확정이 아니다 · 다른 ALTER 는 그대로 검출
    ddl_ = dict(RX_BAD)['DDL EXECUTE IMMEDIATE']
    cases += [('ALTER SESSION 은 DDL 검출 아님', bool(ddl_.search("EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 0'")), False),
              ('ALTER TABLE 은 검출(변이)', bool(ddl_.search("EXECUTE IMMEDIATE 'ALTER TABLE T ADD (A NUMBER)'")), True),
              ('TRUNCATE 동적 실행 검출', bool(ddl_.search("execute immediate 'truncate table T'")), True)]
    bad = 0
    for nm, got, want in cases:
        k = got == want
        bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {nm}")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menu'); a = ap.parse_args(); mid = a.menu.upper()
    pm = [r for r in rdcsv(os.path.join(DOC, 'tobefacts', 'db', 'proc_meta.csv')) if r.get('menu_id', '').upper() == mid and r.get('proc') and re.search(r'SAVE|INS|UPD|DEL', r.get('btn') or '', re.I)]
    out = []
    if not pm:
        print(f'{mid}: 저장 PROC 배선 없음 — F10 대상 없음'); return 0
    from dbconn import connect
    cache = {}
    with connect('tobe') as cx:
        cur = cx.cursor()

        def body_of(pkg):
            if pkg in cache: return cache[pkg]
            cur.execute("SELECT OWNER FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'", n=pkg); m = cur.fetchone()
            if not m: cache[pkg] = ''; return ''
            cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", o=m[0], n=pkg)
            cache[pkg] = strip_comments(''.join(r[0] for r in cur.fetchall())); return cache[pkg]

        def standalone(name):
            cur.execute("SELECT OWNER FROM ALL_OBJECTS WHERE OBJECT_NAME=:n AND OBJECT_TYPE IN ('PROCEDURE','FUNCTION')", n=name); m = cur.fetchone()
            if not m: return ''
            cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE IN ('PROCEDURE','FUNCTION') ORDER BY LINE", o=m[0], n=name)
            return strip_comments(''.join(r[0] for r in cur.fetchall()))
        for r in pm:
            tp = r['proc']; pkg, proc = (tp.split('.') + [''])[:2] if '.' in tp else ('', tp)
            src = body_of(pkg) if pkg else ''
            body = proc_body(src, proc) if src else standalone(proc)
            if not body:
                out.append({'menu_id': mid, 'sheet': r.get('sheet'), 'btn': r.get('btn'), 'proc': tp, 'depth': 0, 'callee': '', 'verdict': 'REVIEW', 'hits': '', 'note': f'본문 없음(ALL_SOURCE {tp} 미발견 · 시노님/권한 확인)'}); continue
            # 본문 + 전 깊이 하위 호출
            def _resolve(cp, q):
                b0 = proc_body(body_of(cp), q) if cp else ''
                return b0 or (standalone(q) if not cp else '')
            chain = walk_calls(tp, pkg, body, _resolve)
            hits = bad_hits(chain)
            out.append({'menu_id': mid, 'sheet': r.get('sheet'), 'btn': r.get('btn'), 'proc': tp, 'depth': max(d for d, _, _ in chain), 'callee': ';'.join(n for d, n, _ in chain if d), 'verdict': 'FAIL' if hits else 'PASS', 'hits': ' | '.join(hits[:6]),
                        'note': ('저장 경로에 암묵 확정/파괴 문장 — 다건 저장 중 오류 시 부분 저장 가능(GAP-452·GAP-105)' if hits else f'본문+하위 {len(chain) - 1}개 호출에 COMMIT/TRUNCATE/DDL/DBMS_STATS/자율 트랜잭션 0건')})
    p = os.path.join(DOC, 'verify', mid, 'f10_check.csv'); os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['menu_id', 'sheet', 'btn', 'proc', 'depth', 'callee', 'verdict', 'hits', 'note']); w.writeheader(); w.writerows(out)
    print(f"{mid}: 저장 PROC {len(out)}건 — " + ' · '.join(f"{o['proc']}={o['verdict']}" for o in out) + f" → {os.path.relpath(p, ROOT)}")
    return 0


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--selftest':
        sys.exit(selftest())
    sys.exit(main())
