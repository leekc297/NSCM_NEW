# -*- coding: utf-8 -*-
"""facts_auth_db — E03 정적 DB 대조(화면 없이 측정). 읽기 전용. 결과 = Doc/verify/_parallel/E03/static/<검사>.json + stdout 요약.

  python -I tools/Harness/verify/facts_auth_db.py measure <ID...>   # EG022·EG402: Div 별 Measure 항목 집합 AS-IS↔TO-BE (SCM_MST_SHEET_MEASURE)
  python -I tools/Harness/verify/facts_auth_db.py column  <ID...>   # EG160: Div 별 필수(USER_SELECTABLE_FLAG=N) 컬럼 집합 AS-IS↔TO-BE
  python -I tools/Harness/verify/facts_auth_db.py groups  [<ID...>] # EG372: 그룹×메뉴 권한 AS-IS 운영 DB ↔ TO-BE (TB_FX_GroupMenuAuth ↔ SCM_ADM_USER_GR_MNU_MPG_M)
  python -I tools/Harness/verify/facts_auth_db.py literal <ID...>   # EG395: 화면 PKG 안 계정 리터럴 분기(사용자 ID = SCM_ADM_USER_M 실재값과 일치하는 문자열 리터럴)
  python -I tools/Harness/verify/facts_auth_db.py reqgroup <ID...>  # EG065: REQ_NO_DISPLAY 룩업 제외 그룹 ∩ 신청 목록 SQL 결과

  판정: FAIL 은 기대·실제·근거 원천이 있을 때만. 접속 실패·원천 없음 = ERROR.
"""
import csv
import datetime
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
OUT = os.path.join(ROOT, 'Doc', 'verify', '_parallel', 'E03', 'static')
SCR = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens')
csv.field_size_limit(10_000_000)


def rd(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as f: return list(csv.DictReader(f))


def has(lst, d):
    v = (lst or '').strip()
    return not v or d in [x.strip() for x in v.split(',')]


def save(name, rows):
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, f'{name}.json'), 'w', encoding='utf-8') as fp: json.dump({'at': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'), 'rows': rows}, fp, ensure_ascii=False, indent=0)
    c = {}
    for r in rows: c[r['result']] = c.get(r['result'], 0) + 1
    print(name, c)
    for r in rows:
        if r['result'] in ('FAIL', 'ERROR', '판정필요'): print(' ', r['result'], r.get('id', ''), r.get('ctx', ''), '|', str(r.get('actual', ''))[:230])


def divisions(cur):
    cur.execute("SELECT DIVISION_ID FROM SCM_MGR.SCM_MST_DIVISION WHERE VALID_YN='Y'")
    return sorted(r[0] for r in cur.fetchall())


def meta_compare(kind, ids, eg):
    """AS-IS dbmeta 스냅샷(화면 facts) ↔ TO-BE 최신. 항목 집합 = 시트·Div 별 COLUMN_NAME.
    차이 = 판정필요(FAIL 아님): 문서가 'AS-IS 미필터 대비 UI Category 확정'(DM-P38)·'19개면 결함'(GAP-16)처럼 AS-IS 메타와 다른 값을 정답으로 적은 경우가 있다 — 실화면 FAIL 은 eg_auth 의 TO-BE 메타 대조가 낸다"""
    from dbconn import connect
    tbl = 'SCM_MST_SHEET_MEASURE' if kind == 'measure' else 'SCM_MST_SHEET_COLUMNS'
    rows = []
    with connect('tobe') as cx:
        c = cx.cursor(); divs = divisions(c)
        for sid in ids:
            a = rd(os.path.join(SCR, sid, f'dbmeta_dbo_{tbl}.csv'))
            if not a:
                rows.append({'id': sid, 'ctx': '-', 'result': 'ERROR', 'eg': eg, 'expected': 'AS-IS dbmeta', 'actual': f'{tbl} 스냅샷 없음(facts 미추출)'}); continue
            a = [x for x in a if x.get('PROGRAM_ID', '').upper() == sid]
            c.execute(f"SELECT SHEET_NAME, COLUMN_NAME, DIVISION_ID, VALID_YN, USER_SELECTABLE_FLAG, COLUMN_LABEL_NAME FROM SCM_MGR.{tbl} WHERE PROGRAM_ID=:m", m=sid)
            b = [dict(zip(['SHEET_NAME', 'COLUMN_NAME', 'DIVISION_ID', 'VALID_YN', 'USER_SELECTABLE_FLAG', 'COLUMN_LABEL_NAME'], ['' if v is None else str(v) for v in r])) for r in c.fetchall()]
            sheets = sorted({x['SHEET_NAME'] for x in a} | {x['SHEET_NAME'] for x in b})
            if not sheets:
                rows.append({'id': sid, 'ctx': '-', 'result': 'NA', 'eg': eg, 'expected': f'{tbl} 행', 'actual': 'AS-IS·TO-BE 모두 0행'}); continue
            for sh in sheets:
                for d in divs:
                    def pick(lst):
                        return {x['COLUMN_NAME'].upper() for x in lst if x['SHEET_NAME'] == sh and x.get('VALID_YN', 'Y') == 'Y' and has(x.get('DIVISION_ID'), d) and (kind == 'measure' or x.get('USER_SELECTABLE_FLAG') == 'N')}
                    sa, sb = pick(a), pick(b)
                    if not sa and not sb: continue
                    ex, ms = sorted(sb - sa), sorted(sa - sb)
                    rows.append({'id': sid, 'ctx': f'{sh} / Div {d}', 'eg': eg, 'result': '판정필요' if ex or ms else 'PASS', 'expected': f'AS-IS {len(sa)}', 'actual': f'TO-BE {len(sb)} · TO-BE 만 {ex[:8]} · AS-IS 만 {ms[:8]}', 'asis': f'Doc/asisfacts/screens/{sid}/dbmeta_dbo_{tbl}.csv'})
    save(f'{kind}_{"_".join(ids)[:60]}', rows)


def groups(ids):
    from dbconn import connect
    rows = []
    with connect('tobe') as cx, connect('asis') as ax:
        c, a = cx.cursor(), ax.cursor()
        a.execute("SELECT TOP 1 * FROM dbo.TB_FX_GroupMenuAuth"); names = [d[0] for d in a.description]
        print('AS-IS 컬럼', names)
        gcol = next(n for n in names if re.search(r'(?i)group', n)); mcol = next(n for n in names if re.search(r'(?i)menu|program', n))
        a.execute(f"SELECT {gcol}, {mcol} FROM dbo.TB_FX_GroupMenuAuth WHERE UseYN='Y'"); asis = {(str(g), str(m)) for g, m in a.fetchall()}
        c.execute("SELECT USER_GR_ID, MNU_ID FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE USE_YN='Y'"); tobe = {(g, m) for g, m in c.fetchall()}
        c.execute("SELECT MNU_ID FROM SCM_MGR.SCM_ADM_MNU_M WHERE USE_YN='Y'"); menus = {r[0] for r in c.fetchall()}
    if os.environ.get('EG_MUT') == 'groups_equal':  # 대조군: AS-IS 를 TO-BE 와 같게 → PASS / 그 위에 1건 차이 → FAIL 은 아래 mut 행
        asis = set(tobe)
    if os.environ.get('EG_MUT') == 'groups_diff':
        asis = set(tobe); g0, m0 = sorted(tobe)[0]; asis.discard((g0, m0)); ids = [m0]
    gs = sorted({g for g, _ in tobe})
    ams = {m for _, m in asis}
    target = ids or sorted(menus & ams)
    for m in target:
        sa, sb = {g for g, x in asis if x == m}, {g for g, x in tobe if x == m}
        if m not in ams: rows.append({'id': m, 'ctx': '메뉴', 'eg': 'EG372', 'result': 'NA', 'expected': 'AS-IS 메뉴', 'actual': f'AS-IS 권한표에 메뉴 없음(TO-BE 그룹 {len(sb)})'}); continue
        ex, ms = sorted(sb - sa), sorted(sa - sb)
        rows.append({'id': m, 'ctx': '그룹×메뉴', 'eg': 'EG372', 'result': 'FAIL' if ms or ex else 'PASS', 'expected': f'AS-IS 그룹 {len(sa)}', 'actual': f'TO-BE {len(sb)} · TO-BE 만 {ex[:8]} · AS-IS 만 {ms[:8]}', 'asis': 'dbo.TB_FX_GroupMenuAuth(운영 AS-IS DB)'})
    print('TO-BE 그룹', gs[:30])
    save(('m_' + os.environ['EG_MUT']) if os.environ.get('EG_MUT') else 'groups', rows)


def literal(ids):
    from dbconn import connect
    rows = []
    with connect('tobe') as cx:
        c = cx.cursor()
        c.execute("SELECT LOWER(USER_ID) FROM SCM_MGR.SCM_ADM_USER_M"); users = {r[0] for r in c.fetchall()}
        c.execute("SELECT LOWER(USER_GR_ID) FROM SCM_MGR.SCM_ADM_USER_GR_M"); users -= {r[0] for r in c.fetchall()}  # 그룹 ID 와 같은 문자열('ADMIN' 등)은 계정 분기가 아니다
        users -= {'system', 'sysadmin', 'guest', 'batch', 'all', 'test'}  # 감사 컬럼 기본값·예약어
        for sid in ids:
            pkg = f'PKG_{sid}'
            c.execute("SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE='PACKAGE BODY' ORDER BY LINE", n=pkg); src = c.fetchall()
            if not src:
                rows.append({'id': sid, 'ctx': pkg, 'eg': 'EG395', 'result': 'ERROR', 'expected': 'PKG 원문', 'actual': 'ALL_SOURCE 0행 — 화면 PKG 이름 규약 밖(PROC_M 해석 필요)'}); continue
            hits = []
            full = ''.join(t or '' for _, t in src)
            nocom = re.sub(r'/\*.*?\*/', lambda m: re.sub(r'[^\n]', ' ', m[0]), full, flags=re.S)  # 블록 주석 제거(줄 번호 유지) — 주석은 근거가 아니다
            for ln, t in zip([x[0] for x in src], nocom.split('\n')):
                if os.environ.get('EG_MUT') == 'literal_user' and ln == src[len(src) // 2][0]: t = f"IF p_created_by = '{sorted(users)[0]}' THEN"
                code = re.sub(r'--.*$', '', t or '')
                for m in re.finditer(r"'([^']{3,30})'", code):
                    if m[1].lower() in users and re.search(r'(?i)(user|created_by|p_id|authority|=|in\s*\()', code): hits.append((ln, code.strip()[:110]))
            rows.append({'id': sid, 'ctx': pkg, 'eg': 'EG395', 'result': 'FAIL' if hits else 'PASS', 'expected': '계정 리터럴 분기 0 — GAP-349', 'actual': f'{len(src)}줄 중 {len(hits)}건 ' + ' ; '.join(f'L{a}' for a, _ in hits[:8]), 'asis': pkg, 'note': [h[1] for h in hits[:3]]})
    save(('m_' if os.environ.get('EG_MUT') else '') + f'literal_{"_".join(ids)[:60]}', rows)


def reqgroup(ids):
    from dbconn import connect
    rows = []
    with connect('tobe') as cx:
        c = cx.cursor()
        c.execute("SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE='REQ_NO_DISPLAY' AND VALID_YN='Y'"); ex = {r[0] for r in c.fetchall()}
        c.execute("SELECT NAME, LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND UPPER(TEXT) LIKE '%REQ_NO_DISPLAY%' ORDER BY NAME, LINE"); refs = c.fetchall()
        rows.append({'id': ','.join(ids) or '-', 'ctx': '룩업·참조', 'eg': 'EG065', 'result': 'PASS' if refs else 'FAIL', 'expected': 'REQ_NO_DISPLAY 를 참조하는 DB 객체 존재', 'actual': f'제외 그룹 {len(ex)} · 참조 {sorted({r[0] for r in refs})} {[r[1] for r in refs][:8]}'})
        for name, ln, t in refs[:6]: print(name, ln, (t or '').strip()[:140])
        # 실제 신청 목록 실행 — 룩업 참조가 있는 조회 프로시저(P_SYSTEM_CD, O_CURSOR, O_RESULT_CURSOR)를 시스템 코드별로 불러 제외 그룹 ∩ 목록 = 0
        c.execute("SELECT DISTINCT SYSTEM_CD FROM SCM_MGR.SCM_ADM_USER_GR_M WHERE SYSTEM_CD IS NOT NULL"); syscds = [r[0] for r in c.fetchall()]
        for sc in syscds:
            # 프로시저 호출 불가(본체 INVALID 등) = ERROR 로 남기고, 본문 커서 SQL 을 직접 실행해 제외 규칙만 잰다(주석 제거 후 'OPEN O_CURSOR FOR … ;')
            try:
                c1, c2 = cx.cursor(), cx.cursor()
                c.callproc('SCM_MGR.PKG_SYS0011.P_SYS0011_GET_AUTH_DATA', [sc, c1, c2])
                got = [r[0] for r in c1.fetchall()]
            except Exception as e:
                rows.append({'id': 'SYS0012', 'ctx': f'SYSTEM_CD {sc} 프로시저 호출', 'eg': 'EG065', 'result': 'ERROR', 'expected': '신청 목록 프로시저 실행', 'actual': str(e).split('\n')[0][:150], 'asis': 'PKG_SYS0011'})
                c.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_SYS0011' AND TYPE='PACKAGE BODY' ORDER BY LINE")
                body = re.sub(r'--[^\n]*', '', ''.join(r[0] or '' for r in c.fetchall()))
                m = re.search(r'P_SYS0011_GET_AUTH_DATA.*?OPEN\s+O_CURSOR\s+FOR(.*?);', body, re.S | re.I)
                c.execute(re.sub(r'\bP_SYSTEM_CD\b', ':sc', m[1]), sc=sc); got = [r[0] for r in c.fetchall()]
            if os.environ.get('EG_MUT') == 'reqgroup_leak' and ex: got.append(sorted(ex)[0])
            leak = sorted(set(got) & ex)
            rows.append({'id': 'SYS0012', 'ctx': f'SYSTEM_CD {sc}', 'eg': 'EG065', 'result': 'FAIL' if leak else 'PASS', 'expected': f'REQ_NO_DISPLAY {len(ex)}개 비표시 — DM-227', 'actual': f'목록 {len(got)}개 · 제외 그룹 잔존 {leak}', 'asis': 'AS-IS UP_FX_GetReqAuthGroupInfo · PKG_SYS0011.P_SYS0011_GET_AUTH_DATA'})
    save(('m_' if os.environ.get('EG_MUT') else '') + 'reqgroup', rows)


def main():
    cmd, ids = sys.argv[1], [a.upper() for a in sys.argv[2:]]
    if cmd == 'measure': meta_compare('measure', ids, 'EG022')
    elif cmd == 'column': meta_compare('column', ids, 'EG160')
    elif cmd == 'groups': groups(ids)
    elif cmd == 'literal': literal(ids)
    elif cmd == 'reqgroup': reqgroup(ids)
    else: print(__doc__)


if __name__ == '__main__':
    main()
