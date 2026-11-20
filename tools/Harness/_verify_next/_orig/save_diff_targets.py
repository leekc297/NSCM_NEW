# -*- coding: utf-8 -*-
"""save_diff_targets.py — EN-02 ③ 저장 SP 실행 대조의 대상·제외 목록 (2026-11-11 · 플랜 '추측 대신 실행' M1)

저장 SP 를 AS-IS·TO-BE 양쪽에서 실행해 대조하기 전에, "실행해도 되돌릴 수 있는가"를 원문으로 판정해 목록으로 남긴다.
이 도구는 아무것도 실행하지 않는다(파일·사실 읽기만). 실행은 이 목록을 사용자가 본 뒤의 일이다.

입력  tools/Harness/rules/sp_pair.csv(kind=SAVE · 짝 있는 행) · Doc/asisfacts/db/modules/dbo.<SP>.sql(원문 · 피호출 SP 재귀 깊이 4)
      사내 ALL_SOURCE(TO-BE PROC·피호출 원문의 확정 문장 COMMIT·자율 트랜잭션·DDL — 실행 시점 실측 · 2026-11-11 T237: f10_check 결과는 쓰지 않는다)
판정  EXCLUDE_SIDE_EFFECT  AS-IS 원문(피호출 포함)에 되돌릴 수 없는 부작용: sp_send_dbmail · OPENQUERY · OPENROWSET · xp_ · 연결 서버 4부 이름 · sp_OA
      EXCLUDE_IF           AS-IS 가 연계 표(XIF_ · IF_ 접두)에 쓴다 — 외부 시스템이 읽는 표라 사용자 확인 전까지 제외
      EXCLUDE_NO_SOURCE    AS-IS 원문 파일 없음 — 안전 판정 불가(미측정)
      EXCLUDE_NO_TOBE_SOURCE  TO-BE PROC 또는 피호출 원문을 읽지 못함 — 확정 문장 유무 미측정
      TARGET_SNAPSHOT      TO-BE 경로에 COMMIT 있음 → ROLLBACK 으로 못 되돌림: 저장 전 스냅샷 → 실행 → 전후 대조 → 스냅샷 복원
      TARGET_ROLLBACK      양쪽 모두 바깥 트랜잭션 ROLLBACK 으로 되돌릴 수 있음(AS-IS 안쪽 COMMIT 은 바깥 ROLLBACK 에 함께 되돌려짐)
출력  Doc/verify/_save_diff_targets.csv · _save_diff_targets.md

  python tools/Harness/verify/save_diff_targets.py [<MENU_ID> …]     (인자 없으면 sp_pair.csv 전체)
  python tools/Harness/verify/save_diff_targets.py --selftest
"""
import csv, os, re, sys, time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
MODULES = os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'modules')
try:
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
except Exception:
    pass
RX_SIDE = [('sp_send_dbmail', re.compile(r'\bsp_send_dbmail\b', re.I)), ('OPENQUERY', re.compile(r'\bOPENQUERY\s*\(', re.I)),
           ('OPENROWSET', re.compile(r'\bOPENROWSET\s*\(', re.I)), ('xp_', re.compile(r'\bxp_\w+', re.I)), ('sp_OA', re.compile(r'\bsp_OA\w+', re.I)),
           ('연결 서버(4부 이름)', re.compile(r'(?<![\w.\]])\[?[A-Za-z_]\w*\]?\.\[?[A-Za-z_]\w*\]?\.\[?[A-Za-z_]\w*\]?\.\[?[A-Za-z_]\w*\]?(?![\w.])'))]
RX_DML = re.compile(r'\b(INSERT\s+INTO|UPDATE|DELETE\s+FROM|DELETE|MERGE\s+INTO|MERGE)\s+([#@]?[\w\[\]\.]+)', re.I)
RX_EXEC = re.compile(r'\bEXEC(?:UTE)?\s+(?!\()((?:\[?dbo\]?\.)?\[?[A-Za-z_][\w]*\]?)', re.I)
RX_IF = re.compile(r'^(XIF_|IF_)', re.I)


def strip_comments(t):
    t = re.sub(r'/\*.*?\*/', ' ', t, flags=re.S)
    return re.sub(r'--[^\n]*', ' ', t)


def default_reader(sp):
    p = os.path.join(MODULES, f'dbo.{sp}.sql')
    if not os.path.exists(p):
        return None
    with open(p, encoding='utf-8-sig', errors='replace') as f:
        return f.read()


def scan(sp, reader=default_reader, depth=0, seen=None):
    """AS-IS SP 원문(피호출 재귀) → {'missing': [...], 'side': {(표식, sp)}, 'dml': {표}, 'callees': [...]}"""
    seen = seen if seen is not None else set()
    out = {'missing': [], 'side': set(), 'dml': set(), 'callees': []}
    if sp.upper() in seen or depth > 4:
        return out
    seen.add(sp.upper())
    t = reader(sp)
    if t is None:
        if depth == 0 or not re.match(r'(?i)sp_|xp_', sp):
            out['missing'].append(sp)
        return out
    body = strip_comments(t)
    for name, rx in RX_SIDE:
        if rx.search(body):
            out['side'].add((name, sp))
    for m in RX_DML.finditer(body):
        n = m.group(2).strip('[]')
        if n.upper() in ('TOP', 'FROM', 'SET') or n.startswith('#') or n.startswith('@'):
            continue
        out['dml'].add(n.split('.')[-1].strip('[]').upper())
    for m in RX_EXEC.finditer(body):
        c = m.group(1).split('.')[-1].strip('[]')
        if c.upper() in ('SP_EXECUTESQL',) or c.startswith('@'):
            continue
        if re.match(r'(?i)sp_send_dbmail|xp_|sp_OA', c):
            continue
        out['callees'].append(c)
        sub = scan(c, reader, depth + 1, seen)
        out['missing'] += [x for x in sub['missing'] if x not in out['missing']]
        out['side'] |= sub['side']
        out['dml'] |= sub['dml']
    return out


RX_TOBE_COMMIT = [('COMMIT', re.compile(r'(?<![A-Z_])COMMIT\s*;', re.I)), ('AUTONOMOUS_TRANSACTION', re.compile(r'AUTONOMOUS_TRANSACTION', re.I)),
                  ('EXECUTE IMMEDIATE', re.compile(r'\bEXECUTE\s+IMMEDIATE\b', re.I)), ('TRUNCATE', re.compile(r'\bTRUNCATE\s+TABLE\b', re.I)),
                  ('DBMS_STATS', re.compile(r'\bDBMS_STATS\.', re.I))]
RX_TOBE_CALL = re.compile(r'(?:^|;|\bTHEN\b|\bELSE\b|\bBEGIN\b|\bLOOP\b)\s*((?:PKG_[A-Z0-9_$]+\.)?(?:P|PR|SP)_[A-Z0-9_$]+)\s*(?:\(|;)', re.I | re.M)  # 문장 첫머리의 호출만(2026-11-11: 대입문 오른쪽의 인자 이름 P_USER_ID; 를 호출로 잘못 읽어 '원문 미독'이 됐다)


def ora_strip(t):
    t = re.sub(r'/\*.*?\*/', ' ', t or '', flags=re.S)
    t = re.sub(r'--[^\n]*', ' ', t)
    return re.sub(r"'(?:[^']|'')*'", "''", t)   # 문자열 안의 COMMIT 은 세지 않는다


def proc_block(body, name):
    """패키지 본문에서 PROCEDURE <name> 블록(다음 PROCEDURE/FUNCTION 선언 전까지) — 못 찾으면 ''"""
    b = ora_strip(body)
    m = re.search(r'\bPROCEDURE\s+' + re.escape(name) + r'\b', b, re.I)
    if not m:
        return ''
    n = re.search(r'\n\s*(?:PROCEDURE|FUNCTION)\s+[A-Z0-9_$]+', b[m.end():], re.I)
    return b[m.start(): m.end() + n.start()] if n else b[m.start():]


def commit_marks(text):
    """[표식…] — 확정·암묵 확정을 일으키는 문장(주석·문자열 제외). 비어 있으면 그 원문에는 없음"""
    s = ora_strip(text)
    return [name for name, rx in RX_TOBE_COMMIT if rx.search(s)]


def tobe_commit_scan(source_of, proc, depth=0, seen=None):
    """사내 원문으로 PROC(피호출 재귀 깊이 4)의 확정 문장을 찾는다.
    source_of(pkg|None, name) → 원문(패키지 본문 전체 또는 독립 프로시저) 또는 None.
    반환 (marks[(표식, 위치)], unread[이름]) — unread 가 있으면 '없음'으로 단정할 수 없다(미측정)"""
    seen = seen if seen is not None else set()
    key = proc.upper()
    if key in seen or depth > 4:
        return [], []
    seen.add(key)
    pkg, _, name = key.rpartition('.')
    src = source_of(pkg or None, name)
    if src is None:
        return [], [key]
    blk = proc_block(src, name) if pkg else ora_strip(src)
    if not blk:
        return [], [key]
    marks = [(m, key) for m in commit_marks(blk)]
    unread = []
    for c in dict.fromkeys(x.upper() for x in RX_TOBE_CALL.findall(blk)):
        if c == name or c == key:
            continue
        callee = c if '.' in c else ((f'{pkg}.{c}') if pkg and proc_block(src, c) else c)
        m2, u2 = tobe_commit_scan(source_of, callee, depth + 1, seen)
        marks += m2
        unread += u2
    return marks, unread


def live_source_reader():
    """사내 ALL_SOURCE 를 읽는 source_of — 접속은 한 번, 결과는 캐시"""
    sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
    import dbconn
    cx = dbconn.connect('tobe')
    cache = {}

    def source_of(pkg, name):
        k = (pkg or '', name)
        if k not in cache:
            cur = cx.cursor()
            if pkg:
                cur.execute("SELECT text FROM all_source WHERE owner = 'SCM_MGR' AND name = :n AND type = 'PACKAGE BODY' ORDER BY line", n=pkg)
            else:
                cur.execute("SELECT text FROM all_source WHERE owner = 'SCM_MGR' AND name = :n AND type IN ('PROCEDURE', 'FUNCTION') ORDER BY line", n=name)
            txt = ''.join(r[0] or '' for r in cur.fetchall())
            cache[k] = txt or None
        return cache[k]
    return source_of


def decide(sc, f10_rows):
    """(decision, reason). f10_rows = 그 PROC 의 f10_check 행 목록(없으면 [])"""
    if sc['missing'] and sc['missing'][0] is not None and not sc['dml'] and not sc['callees'] and not sc['side']:
        return 'EXCLUDE_NO_SOURCE', f"AS-IS 원문 없음: {sc['missing'][:3]}"
    if sc['side']:
        return 'EXCLUDE_SIDE_EFFECT', ' · '.join(sorted(f'{n}({sp})' for n, sp in sc['side']))[:300]
    xif = sorted(t for t in sc['dml'] if RX_IF.match(t))
    if xif:
        return 'EXCLUDE_IF', f"연계 표에 씀: {xif[:6]} — 사용자 확인 전 제외"
    if sc['missing']:
        return 'EXCLUDE_NO_SOURCE', f"피호출 SP 원문 없음: {sc['missing'][:4]} — 부작용 판정 불가"
    # 2026-11-11 T237: TO-BE 를 되돌릴 수 있는가 = 사내 PKG 원문의 확정 문장 실측(f10_rows 인자 = (marks, unread) 또는 None).
    #   종전엔 f10_check 의 PASS 를 'COMMIT 없음'으로 썼다 — f10 은 원자성 검사라 마지막 COMMIT 을 정상으로 본다. 그 결과 15:43 실행에서 TO-BE 가 확정됐다(복원 완료).
    if f10_rows is None:
        return 'EXCLUDE_NO_TOBE_SOURCE', 'TO-BE PKG 원문을 읽지 못함 — 확정 문장 유무 미측정'
    marks, unread = f10_rows
    if marks:
        return 'TARGET_SNAPSHOT', 'TO-BE 원문에 확정 문장: ' + ', '.join(sorted({f"{m}({w.split('.')[-1]})" for m, w in marks}))[:200] + ' — ROLLBACK 으로 못 되돌림(스냅샷·복원 방식 필요)'
    if unread:
        return 'EXCLUDE_NO_TOBE_SOURCE', f'피호출 원문을 읽지 못함: {unread[:4]} — 확정 문장 유무 미측정'
    return 'TARGET_ROLLBACK', 'AS-IS 부작용 표식 0 · 연계 표 0 · TO-BE 원문(피호출 포함) 확정 문장 0'


def selftest():
    st = {'ok': 0, 'n': 0}

    def t(name, cond):
        st['n'] += 1
        st['ok'] += bool(cond)
        print(('PASS ' if cond else 'FAIL ') + name)
    src = {'A': "UPDATE T1 SET X=1; EXEC dbo.B @p=1", 'B': "INSERT INTO T2 SELECT 1", 'MAIL': "UPDATE T1 SET X=1; EXEC msdb.dbo.sp_send_dbmail @x=1",
           'CALLMAIL': "EXEC MAIL", 'IFW': "INSERT INTO XIF_ERP_SHIP VALUES(1)", 'CMT': "-- EXEC sp_send_dbmail\nUPDATE T1 SET X=1 /* OPENQUERY(X,'') */",
           'LINK': "SELECT * FROM SRV1.DB1.dbo.T9; UPDATE T1 SET X=1", 'NOSUB': "UPDATE T1 SET X=1; EXEC GONE_SP", 'TMP': "INSERT INTO #T SELECT 1; UPDATE @V SET A=1; DELETE FROM T3"}
    rd = lambda sp: src.get(sp)
    ok10 = ([], [])
    t('부작용 없음·TO-BE COMMIT 없음 → TARGET_ROLLBACK', decide(scan('A', rd), ok10)[0] == 'TARGET_ROLLBACK')
    t('피호출 SP 의 DML 까지 모은다', scan('A', rd)['dml'] == {'T1', 'T2'})
    t('메일 발송(변이) → EXCLUDE_SIDE_EFFECT', decide(scan('MAIL', rd), ok10)[0] == 'EXCLUDE_SIDE_EFFECT')
    t('메일 발송 SP 를 부르는 SP 도 제외(재귀)', decide(scan('CALLMAIL', rd), ok10)[0] == 'EXCLUDE_SIDE_EFFECT')
    t('연계 표(XIF_) 쓰기 → EXCLUDE_IF', decide(scan('IFW', rd), ok10)[0] == 'EXCLUDE_IF')
    t('주석 안의 표식은 세지 않는다', decide(scan('CMT', rd), ok10)[0] == 'TARGET_ROLLBACK')
    t('연결 서버 4부 이름 → EXCLUDE_SIDE_EFFECT', decide(scan('LINK', rd), ok10)[0] == 'EXCLUDE_SIDE_EFFECT')
    t('피호출 원문 없음 → EXCLUDE_NO_SOURCE(안전하다고 보지 않음)', decide(scan('NOSUB', rd), ok10)[0] == 'EXCLUDE_NO_SOURCE')
    t('원문 자체가 없음 → EXCLUDE_NO_SOURCE', decide(scan('NOPE', rd), ok10)[0] == 'EXCLUDE_NO_SOURCE')
    t('TO-BE 원문 미측정 → EXCLUDE_NO_TOBE_SOURCE', decide(scan('A', rd), None)[0] == 'EXCLUDE_NO_TOBE_SOURCE')
    t('TO-BE 원문에 COMMIT → TARGET_SNAPSHOT(되돌릴 수 없음)', decide(scan('A', rd), ([('COMMIT', 'PKG_X.P_A')], []))[0] == 'TARGET_SNAPSHOT')
    t('피호출 원문 미독 → 제외(없다고 단정하지 않음)', decide(scan('A', rd), ([], ['PR_X']))[0] == 'EXCLUDE_NO_TOBE_SOURCE')
    PK = "PROCEDURE P_A IS BEGIN UPDATE T SET A=1; P_B(1); END;\n  PROCEDURE P_B(X NUMBER) IS BEGIN PR_LOG('x'); COMMIT; END;\n  PROCEDURE P_C IS BEGIN NULL; -- COMMIT;\n V := 'COMMIT;'; END;"
    so = lambda pkg, name: PK if pkg == 'PKG_X' else ('PROCEDURE PR_LOG(M VARCHAR2) IS BEGIN INSERT INTO L VALUES(M); END;' if name == 'PR_LOG' else None)
    t('피호출 PROC 의 COMMIT 까지 찾는다(2026-11-11 15:43 사고 재현)', [m for m, _ in tobe_commit_scan(so, 'PKG_X.P_A')[0]] == ['COMMIT'])
    t('주석·문자열 안 COMMIT 은 세지 않는다', tobe_commit_scan(so, 'PKG_X.P_C') == ([], []))
    t('PROC 을 원문에서 못 찾으면 미독으로 남긴다', tobe_commit_scan(so, 'PKG_X.P_NOPE')[1] == ['PKG_X.P_NOPE'])
    t('마지막 COMMIT 도 확정 문장이다(원자성 검사와 다름)', commit_marks('BEGIN UPDATE T SET A=1; COMMIT; END;') == ['COMMIT'])
    t('임시 표(#·@)는 DML 대상에서 제외', scan('TMP', rd)['dml'] == {'T3'})
    print(f"{st['ok']}/{st['n']}")
    return 0 if st['ok'] == st['n'] else 1


def rd_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def main():
    a = sys.argv[1:]
    if '--selftest' in a:
        return selftest()
    mids = [x.upper() for x in a if not x.startswith('--')]
    pairs = [r for r in rd_csv(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'sp_pair.csv'))
             if (r.get('kind') or '') == 'SAVE' and (not mids or (r.get('menu_id') or '').upper() in mids)]
    f10 = {}
    src_of = [None]
    rows = []
    for r in pairs:
        mid = r['menu_id'].upper()
        if mid not in f10:
            f10[mid] = rd_csv(os.path.join(ROOT, 'Doc', 'verify', mid, 'f10_check.csv'))
        tobe = r.get('tobe_proc') or ''
        if not tobe:
            rows.append({'menu_id': mid, 'asis_sp': r['asis_sp'], 'tobe_proc': '', 'pair_source': r.get('source') or '', 'decision': 'EXCLUDE_NO_PAIR',
                         'reason': 'TO-BE 짝 없음', 'asis_dml': '', 'asis_callees': ''})
            continue
        sc = scan(r['asis_sp'])
        try:
            if src_of[0] is None:
                src_of[0] = live_source_reader()
            fr = tobe_commit_scan(src_of[0], tobe)
        except Exception as ex:  # noqa: BLE001 — 접속 실패 = 미측정
            fr = None
            print(f'   ~ TO-BE 원문 조회 실패({type(ex).__name__}): {str(ex)[:120]}')
        d, why = decide(sc, fr)
        rows.append({'menu_id': mid, 'asis_sp': r['asis_sp'], 'tobe_proc': tobe, 'pair_source': r.get('source') or '', 'decision': d, 'reason': why,
                     'asis_dml': ' '.join(sorted(sc['dml']))[:400], 'asis_callees': ' '.join(dict.fromkeys(sc['callees']))[:300]})
    cols = ['menu_id', 'asis_sp', 'tobe_proc', 'pair_source', 'decision', 'reason', 'asis_dml', 'asis_callees']
    out = os.path.join(ROOT, 'Doc', 'verify', '_save_diff_targets.csv')
    with open(out, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        w.writerows(rows)
    c = {}
    for x in rows:
        c[x['decision']] = c.get(x['decision'], 0) + 1
    at = time.strftime('%Y-%m-%d %H:%M:%S')
    md = [f'# 저장 SP 실행 대조 — 대상·제외 목록 ({at})', '', '이 목록은 원문·실측 사실로 만든 것이며, 저장 SP 는 아직 실행하지 않았다.', '',
          f"- 저장 SP 짝 {len(rows)}건: " + ' · '.join(f'{k} {v}' for k, v in sorted(c.items())), '', '| 화면 | AS-IS SP | TO-BE PROC | 판정 | 근거 |', '|---|---|---|---|---|']
    for x in sorted(rows, key=lambda r: (r['decision'], r['menu_id'], r['asis_sp'])):
        md.append(f"| {x['menu_id']} | {x['asis_sp']} | {x['tobe_proc'] or '-'} | {x['decision']} | {x['reason'].replace('|', '/')[:200]} |")
    with open(os.path.join(ROOT, 'Doc', 'verify', '_save_diff_targets.md'), 'w', encoding='utf-8') as f:
        f.write('\n'.join(md) + '\n')
    print(f"[save_diff_targets] {at} · 저장 SP 짝 {len(rows)}건 · " + ' · '.join(f'{k} {v}' for k, v in sorted(c.items())) + ' → Doc/verify/_save_diff_targets.csv')
    return 0


if __name__ == '__main__':
    sys.exit(main())
