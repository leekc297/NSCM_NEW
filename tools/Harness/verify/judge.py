"""검증 항목 원장 판정 — Doc/verify/<ID>/verify_ledger.csv 의 result·evidence·tobe_ref 를 채운다.

  python tools/Harness/verify/judge.py <MENU_ID> [--no-db]

판정 원천:
  E2E     Doc/verify/<ID>/e2e_results.json (Doc/e2e/specs/_verify.spec.ts @verify 산출) — row_id 단위 반입
  META    I1 — FE 화면 소스의 t('코드', …) 전부가 사내 SCM_ADM_MSG_M 에 KO/EN/CN 으로 등록됐는지 (DB 실조회, --no-db 면 건너뜀)
  STATIC  H5·G4 — 조회조건 Form 의 라벨 문구·순서 ↔ 조회조건 기준표(search_cond.csv)
  DEFECT  결함 원장 행 — 같은 규칙의 실측 판정을 근거와 함께 이어받는다(대상 일치 행 우선). 근거 없으면 NOT_RUN 유지
미검증은 PASS 로 두지 않는다(정직 보고) — NOT_RUN / ERROR 는 '미검증' 시트로 간다.
"""
import argparse
import csv
import json
import os
HERE = os.path.dirname(os.path.abspath(__file__))
import re, collections
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
sys.path.insert(0, P('tools', 'DbConn'))


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def page_dir(mid):
    for r in read_csv(P('Doc', 'tobefacts', 'screens', '_index.csv')):
        if r['menu_id'].upper() == mid and '/components/' not in r['page_key']:
            feat, *rest = r['page_key'].split('/')
            return P('nscm-fe', 'features', feat, 'src', 'pages', *rest)
    return ''


def fe_sources(pdir):
    out = {}
    for dp, _, fs in os.walk(pdir):
        if 'node_modules' in dp:
            continue
        for f in fs:
            if f.endswith(('.ts', '.tsx')) and not f.endswith(('.test.ts', '.spec.ts')):
                p = os.path.join(dp, f)
                with open(p, encoding='utf-8') as h:
                    out[p] = h.read()
    return out


T_CALL = re.compile(r"""\bt\(\s*['"]([A-Za-z][A-Za-z0-9_]*)['"]\s*(?:,\s*['"]([^'"]*)['"])?""")


def meta_i1(srcs, use_db):
    """FE t() 코드 → SCM_ADM_MSG_M 언어별 등록 여부"""
    codes = {}
    for p, s in srcs.items():
        for i, line in enumerate(s.splitlines(), 1):
            for m in T_CALL.finditer(line):
                codes.setdefault(m.group(1), (os.path.relpath(p, ROOT).replace('\\', '/') + f':{i}', m.group(2) or ''))
    if not codes:
        return None, '화면 소스에 t() 호출 없음'
    if not use_db:
        return None, f'DB 미조회(--no-db) — 코드 {len(codes)}개'
    from dbconn import connect  # noqa: E402
    have = {}
    with connect('tobe') as cx:
        cur = cx.cursor()
        keys = list(codes)
        for i in range(0, len(keys), 500):
            chunk = keys[i:i + 500]
            binds = ','.join(f':b{j}' for j in range(len(chunk)))
            cur.execute(f"SELECT MSG_ID, LANG_CD FROM SCM_ADM_MSG_M WHERE USE_YN = 'Y' AND MSG_ID IN ({binds})", {f'b{j}': c for j, c in enumerate(chunk)})
            for mid_, lang in cur:
                have.setdefault(mid_, set()).add((lang or '').upper())
    miss = []
    for c, (loc, fb) in sorted(codes.items()):
        lacking = [l for l in ('KO', 'EN', 'CN') if l not in have.get(c, set())]
        if lacking:
            miss.append(f"{c}({'/'.join(lacking)} 없음, fallback '{fb}', {loc})")
    return (not miss), (f"t() 코드 {len(codes)}개 중 미등록 {len(miss)}: " + '; '.join(miss)) if miss else f't() 코드 {len(codes)}개 KO/EN/CN 전부 등록'


def meta_i4(srcs, use_db):
    """I4 중복 채번(2026-10-28) — 화면 t() 코드마다 같은 유형(MSG_TP_CD)·KO·EN 문구(TRIM, 대소문자 구분)가 모두 같은 다른 MSG_ID(USE_YN=Y)가 있는가.
    단위테스트 결함 DM-96(동일 문구는 하나의 ID 만 채번·재사용). 이 화면 코드보다 앞선 ID 가 있으면 재사용 대신 새로 채번한 것 → FAIL,
    이 화면이 가장 앞선 ID 를 쓰면 다른 곳의 중복이라 PASS(근거에 함께 적음). 한계: 메뉴명(MNU)은 화면 t() 에 나오는 코드만 본다"""
    codes = sorted({m.group(1) for s in srcs.values() for m in T_CALL.finditer(s)})
    if not codes:
        return None, '화면 소스에 t() 호출 없음'
    if not use_db:
        return None, f'DB 미조회(--no-db) — 코드 {len(codes)}개'
    from dbconn import connect  # noqa: E402
    with connect('tobe') as cx:
        cur = cx.cursor()
        cur.execute("""WITH T AS (SELECT MSG_ID, MSG_TP_CD, MAX(CASE WHEN LANG_CD = 'KO' THEN TRIM(MSG_NM) END) KO, MAX(CASE WHEN LANG_CD = 'EN' THEN TRIM(MSG_NM) END) EN
                       FROM SCM_ADM_MSG_M WHERE USE_YN = 'Y' GROUP BY MSG_ID, MSG_TP_CD)
                       SELECT MSG_ID, MSG_TP_CD, KO, EN FROM T WHERE KO IS NOT NULL AND EN IS NOT NULL""")
        grp = {}
        for mid_, tp, ko, en in cur:
            grp.setdefault((tp, ko, en), []).append(mid_)
    twin = {i: sorted(v) for v in grp.values() if len(v) > 1 for i in v}
    bad, other = [], []
    for c in codes:
        if c in twin:
            ids = twin[c]
            (bad if ids[0] != c else other).append(f"{c}↔{'/'.join(x for x in ids if x != c)}")
    if bad:
        return False, f"t() 코드 {len(codes)}개 중 같은 문구의 앞선 코드가 있는데 새로 채번 {len(bad)}: {'; '.join(bad)}" + (f" · (이 화면이 앞선 코드 사용 {len(other)}: {'; '.join(other)})" if other else '')
    return True, f"t() 코드 {len(codes)}개 — 같은 문구 다른 코드 중복 없음" + (f" · 이 화면이 앞선 코드를 쓰는 다른 곳 중복 {len(other)}: {'; '.join(other)}" if other else '')


def form_labels(srcs):
    """Form 파일의 FormItem/label t('LBL…','_문구') 순서 → [(code, fallback, loc)]"""
    out = []
    for p, s in srcs.items():
        if not re.search(r'Form\.tsx$', p):
            continue
        for i, line in enumerate(s.splitlines(), 1):
            if 'label' not in line:
                continue
            for m in T_CALL.finditer(line):
                out.append((m.group(1), (m.group(2) or '').lstrip('_'), os.path.relpath(p, ROOT).replace('\\', '/') + f':{i}'))
    return out


def norm(s):
    return re.sub(r'[\s.*_]+', '', (s or '').lower())


def rules_how(rid):
    return next((r.get('how', '') for r in read_csv(os.path.join(HERE, 'detect_rules.csv')) if r.get('rule_id') == rid), '')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--no-db', action='store_true')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    asis_id = next((m['asis_id'].upper() for m in read_csv(P('tools', 'Harness', 'rules', 'map_screen.csv')) if m.get('tobe_id', '').upper() == mid), mid)
    led_p = P('Doc', 'verify', mid, 'verify_ledger.csv')
    rows = read_csv(led_p)
    if not rows:
        print(f'[ERROR] 원장 없음: {led_p} — ledger.py 먼저')
        return 2
    by_id = {r['row_id']: r for r in rows}
    stat = {'E2E': 0, 'META': 0, 'STATIC': 0, 'DEFECT': 0}

    # E2E 반입
    e2e_ids = set()  # 이번 실행에 E2E 결과가 들어온 행 — 뒤 단계(상속·스윕)가 덮지 않는다(2026-10-26)
    e2e_p = P('Doc', 'verify', mid, 'e2e_results.json')
    if os.path.exists(e2e_p):
        import datetime  # noqa: E402
        at = datetime.datetime.fromtimestamp(os.path.getmtime(e2e_p)).strftime('%m-%d %H:%M')  # 어느 실행 결과인지(--skip-e2e 재판정 시 이전 실행값임을 드러냄)
        with open(e2e_p, encoding='utf-8') as f:
            for e in json.load(f):
                r = by_id.get(e['row_id'])
                if r and (r.get('tobe_ref') or '').startswith('수동'):
                    continue  # 사람·전용 프로브로 확정한 판정이 우선(자동 재실행이 덮어쓰지 않음 — 2026-10-24)
                if r and r.get('result') == 'NA' and (r.get('evidence') or '').startswith('기준표 제외'):
                    continue  # 조회조건 기준표가 제외한 AS-IS 조건(TO-BE 룰 CR-071) — 엔진의 '칸 없음' FAIL 로 덮지 않는다
                if r:
                    r['result'], r['evidence'], r['tobe_ref'] = e['result'], e['evidence'], f"{e.get('tobe_ref', 'E2E')} @{at}"
                    stat['E2E'] += 1; e2e_ids.add(r['row_id'])

    pdir = page_dir(mid)
    srcs = fe_sources(pdir) if pdir and os.path.isdir(pdir) else {}

    # META I1
    try:
        ok, ev = meta_i1(srcs, not a.no_db)
    except Exception as ex:  # 접속 실패 = ERROR (PASS 금지)
        ok, ev = None, f'DB 조회 실패: {ex}'
    for r in rows:
        if r['source'] == 'RULE_SCREEN' and r['rule_id'] == 'I1':
            r['result'] = 'ERROR' if ok is None else ('PASS' if ok else 'FAIL')
            r['evidence'], r['tobe_ref'] = ev[:1500], f'META SCM_ADM_MSG_M · {os.path.relpath(pdir, ROOT) if pdir else "-"}'
            stat['META'] += 1
    # META I4 중복 채번(2026-10-28)
    try:
        ok4, ev4 = meta_i4(srcs, not a.no_db)
    except Exception as ex:
        ok4, ev4 = None, f'DB 조회 실패: {ex}'
    for r in rows:
        if r['source'] == 'RULE_SCREEN' and r['rule_id'] == 'I4':
            r['result'] = 'ERROR' if ok4 is None else ('PASS' if ok4 else 'FAIL')
            r['evidence'], r['tobe_ref'] = ev4[:1500], f'META SCM_ADM_MSG_M 중복 문구 · {os.path.relpath(pdir, ROOT) if pdir else "-"}'
            stat['META'] += 1

    # STATIC H5·G4 (조회조건 라벨·순서)
    labels = form_labels(srcs)
    msg_en = {}
    for m in read_csv(P('Doc', 'tobefacts', 'db', 'msg_master.csv')):
        if (m.get('lang_cd') or '').upper() == 'EN':
            msg_en[m['msg_id']] = m['msg_nm']
    shown = [(code, msg_en.get(code) or fb, loc) for code, fb, loc in labels]
    sc = sorted([r for r in read_csv(P('tools', 'Harness', 'rules', 'search_cond.csv')) if r['menu_id'].upper() == mid and r['usage'] == 'USE'],
                key=lambda r: float(r.get('tobe_order') or 0))
    names = [norm(s[1]) for s in shown]
    for idx, c in enumerate(sc):
        want = c.get('tobe_name') or c.get('asis_name')
        hit = next((i for i, n in enumerate(names) if n == norm(want)), None)
        for r in rows:
            if r['source'] != 'SEARCH' or r['target'] != f'조회조건 {want}' or r['rule_id'] not in ('H5', 'G4'):
                continue
            asis_nm = c.get('asis_name') or ''
            tag = f" · AS-IS '{asis_nm}' → 기준표 명칭(TO-BE 룰 CR-071: 기준표 라벨이 정답, AS-IS 와 달라도 PASS)" if asis_nm and norm(asis_nm) != norm(want) else ' · 기준표 라벨(CR-071)'
            if r['rule_id'] == 'H5':
                r['result'] = 'PASS' if hit is not None else 'FAIL'
                r['evidence'] = f"기준 명칭 '{want}' — 화면 라벨 {'일치 ' + shown[hit][2] if hit is not None else '없음 (화면 라벨: ' + ', '.join(s[1] for s in shown) + ') — 기준표 조건 누락 또는 라벨이 기준표와 다름'}{tag}"
            else:
                r['result'] = 'PASS' if hit == idx else 'FAIL'
                r['evidence'] = f"기준 순서 {idx + 1}번째 '{want}' — 화면 {('없음' if hit is None else str(hit + 1) + '번째')} (화면 순서: {' → '.join(s[1] for s in shown)}) · 기준표 순서(CR-071)"
            r['tobe_ref'] = 'STATIC Form 라벨 ↔ search_cond.csv'
            stat['STATIC'] += 1

    # A6 결과 정렬 — sort_check.csv(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY 정적 대조, 2026-10-26). 원장 SP 행(source=SP, target=SP 이름, condition=가드)에 연결
    sc_p = P('Doc', 'verify', mid, 'sort_check.csv')
    if os.path.exists(sc_p):
        stat.setdefault('SORT', 0)
        scs = read_csv(sc_p)
        for r in rows:
            if r['rule_id'] != 'A6' or r['source'] != 'SP' or (r.get('tobe_ref') or '').startswith('수동'):
                continue
            x = next((s for s in scs if s['sp'] == r['target'] and (s.get('guard') or '') == (r.get('condition') or '')), None) or next((s for s in scs if s['sp'] == r['target']), None)
            if not x:
                continue
            r['result'] = {'PASS': 'PASS', 'FAIL': 'FAIL', 'NA': 'NA', 'REVIEW': '판정필요'}.get(x['verdict'], '판정필요')
            r['evidence'] = (f"AS-IS ORDER BY [{x['asis_keys']}]{(' 가드 ' + x['guard'][:80]) if x.get('guard') else ''} ↔ TO-BE {x['tobe_proc']} [{x['tobe_keys']}] — {x['note']}")[:1500]
            r['tobe_ref'] = f"STATIC sort_check (ZIOUI1 ALL_SOURCE LAST_DDL {x.get('tobe_last_ddl', '')})"
            stat['SORT'] += 1

    # A7 컬럼별 결과 값 — Doc/golden/<ID>/<sp>.cols.csv(golden.py: AS-IS SP ↔ TO-BE PROC 같은 인자 · 공란 컬럼·같은 키 불일치, 2026-10-27). 원장 SP A7 행(target = AS-IS SP)
    stat.setdefault('A7', 0)
    for r in rows:
        if r['rule_id'] != 'A7' or r['source'] != 'SP' or (r.get('tobe_ref') or '').startswith('수동'):
            continue
        cp = P('Doc', 'golden', mid, f"{r['target']}.cols.csv")
        if not os.path.exists(cp):
            continue
        prof = read_csv(cp)
        fails = [x for x in prof if x['verdict'] == 'FAIL']
        rev = [x for x in prof if x['verdict'] == 'REVIEW']
        r['result'] = 'FAIL' if fails else ('판정필요' if rev else 'PASS')
        pick = fails or rev
        r['evidence'] = (f"공통 컬럼 {len(prof)} 중 공란 컬럼 {len(fails)} · 확인 필요 {len(rev)}"
                         + (' — ' + ' | '.join(f"{x['column']}: {x['note']}" for x in pick[:6]) if pick else ' — 전 컬럼 채움 이상 없음'))[:1500]
        r['tobe_ref'] = f"STATIC golden 컬럼 프로파일 ({os.path.basename(cp)})"
        stat['A7'] += 1

    # F8 감사 필드 · F7 저장 연계 — save_audit.json(실제 저장 정리 백업 ↔ AS-IS 저장 SP DML 대상, 2026-10-27). 원장 RULE_SCREEN F8/F7 행
    sa_p = P('Doc', 'verify', mid, 'save_audit.json')
    if os.path.exists(sa_p):
        with open(sa_p, encoding='utf-8') as f:
            sa = json.load(f)
        stat.setdefault('SAVE_AUDIT', 0)
        run_ = sa.get('run') or {}
        for r in rows:
            if r['rule_id'] not in ('F7', 'F8') or r['source'] != 'RULE_SCREEN' or (r.get('tobe_ref') or '').startswith('수동'):
                continue
            x = sa.get(r['rule_id']) or {}
            if not x or x.get('verdict') == 'NOT_RUN':
                continue
            r['result'] = x['verdict']
            r['evidence'] = (f"{x['note']} · 저장 {run_.get('saved_at', '')} 계정 {run_.get('account', '')} · 기록 테이블 {run_.get('tables', {})} · {run_.get('cleanup_sql', '')}")[:1500]
            r['tobe_ref'] = 'STATIC save_audit (CRUD 실제 저장 정리 백업)'
            stat['SAVE_AUDIT'] += 1

    # H1 가로 정렬 — align_check.csv(AS-IS 정렬 ↔ TO-BE 메타 HORIZONTAL_ALIGN_CODE·화면 FE 지정, 2026-10-27). 원장 COLUMN H1 행(target = '시트.컬럼 (라벨)')
    al_p = P('Doc', 'verify', mid, 'align_check.csv')
    if os.path.exists(al_p):
        stat.setdefault('ALIGN', 0)
        als = {(a['sheet'], a['column']): a for a in read_csv(al_p)}
        for r in rows:
            if r['rule_id'] != 'H1' or r['source'] != 'COLUMN' or (r.get('tobe_ref') or '').startswith('수동'):
                continue
            sh, _, rest = r['target'].partition('.')
            x = als.get((sh, rest.split(' (')[0]))
            if not x:
                continue
            r['result'] = x['verdict']
            r['evidence'] = f"{x['note']} · AS-IS {x['asis_ref']} · TO-BE {x['tobe_source']}"[:1500]
            r['tobe_ref'] = 'STATIC align_check (ZIOUI1 SHEET_COLUMNS)'
            stat['ALIGN'] += 1

    # W1 콤보 AS-IS 원천 비교(B4 집합·B3 순서·G7 표시 형식 10-28) — combo_oracle.json(2026-10-24). 조회조건 = 라벨, 그리드 = 바인딩으로 원장 행에 연결
    co_p = P('Doc', 'verify', mid, 'combo_oracle.json')
    if os.path.exists(co_p):
        with open(co_p, encoding='utf-8') as f:
            co = json.load(f)
        by_s = {norm(x['target']): x for x in co.get('results', []) if x['kind'] == 'SEARCH'}
        by_g = {norm(x['target']): x for x in co.get('results', []) if x['kind'] == 'GRID'}
        stat.setdefault('W1', 0)
        for r in rows:
            if r['rule_id'] not in ('B4', 'B3', 'G7') or r['source'] not in ('SEARCH', 'COLUMN') or (r.get('tobe_ref') or '').startswith('수동'):
                continue
            if r['rule_id'] == 'G7' and r['source'] != 'SEARCH':
                continue
            if r['source'] == 'SEARCH':
                x = by_s.get(norm(r['target'].replace('조회조건', '', 1)))
            else:
                x = by_g.get(norm((re.search(r'\.([A-Za-z0-9_]+)', r['target']) or [None, ''])[1]))
            if not x:
                continue
            res, why = {'B4': (x.get('b4'), x.get('why', '')), 'B3': (x.get('b3'), x.get('b3_why', '')), 'G7': (x.get('g7'), x.get('g7_why', ''))}[r['rule_id']]
            if not res:
                continue
            extra = '' if r['rule_id'] in ('B3', 'G7') else (f" · AS-IS만 {x.get('asis_only_n', 0)} {x.get('asis_only', [])[:8]} · TO-BE만 {x.get('tobe_only_n', 0)} {x.get('tobe_only', [])[:8]}" if x.get('asis_only_n') or x.get('tobe_only_n') else '')
            r['result'] = res
            r['evidence'] = (f"[{x.get('scenario', '')}] {why}{extra} · 원천 {x.get('asis_src', '-')} · 표현 {x.get('rep', '-')}")[:1500]
            r['tobe_ref'] = f"W1 combo_oracle (AS-IS {co.get('asis_id')} DB 동시 실행 · 계정 {co.get('account')}/{co.get('group')})"
            stat['W1'] += 1

    # A5(표시 여부) FAIL 중 그 컬럼이 확정 규칙·결함 원장에 언급되면 AS-IS 와 달라도 확정 요구일 수 있다 → 판정필요
    #   (2026-10-23 DMF0082: MEASURE·VERSION 표시 = DM-47 확정 요구 'Measure 컬럼 항상 표시'와 겹침)
    o2_text = ' '.join(x.get('requirement', '') + ' ' + x.get('target', '') for x in read_csv(P('tools', 'Harness', 'rules', 'confirmed_requirements.csv')))
    o2_text += ' ' + ' '.join(x.get('expected', '') + ' ' + x.get('target', '') for x in read_csv(P('Doc', 'verify', 'defects_classified.csv')) if x.get('menu_id') in (mid, 'COMMON'))
    o2_up = o2_text.upper()
    for r in rows:
        if r['rule_id'] == 'A5' and r['result'] == 'FAIL':
            col = (re.search(r'\.([A-Z0-9_]+)', r['target']) or [None, ''])[1]
            label = (re.search(r'\(([^)]*)\)', r['target']) or [None, ''])[1].replace('*', '').strip()
            if col and (col in o2_up or (label and label.upper() in o2_up)):
                r['result'] = '판정필요'
                r['evidence'] += f" — 이 컬럼({col}/{label})이 확정 규칙·결함 원장에 언급됨: AS-IS 와 다른 확정 요구인지 확인"

    # 화면 단위 규칙(RULE_SCREEN)·조회조건(SEARCH) ← E2E smoke/auth 요약(Doc/e2e/results/_summary.csv) 반입 (2026-10-26: 원장 화면 규칙 12행이 smoke 를 돌려도 NOT_RUN 으로 남던 구멍)
    stat.setdefault('SMOKE', 0)
    summ = [x for x in read_csv(P('Doc', 'e2e', 'results', '_summary.csv')) if x.get('menu_id', '').upper() == mid]
    ev_screen = {}  # rule → (result, evidence)
    ev_cond = {}    # (rule, norm(label)) → (result, evidence)
    V = {'OK': 'PASS', 'FAIL': 'FAIL', 'WARN': '판정필요', 'NA': 'NA', 'ERROR': 'ERROR'}
    for x in summ:
        kind, st = x.get('kind', ''), x.get('status', '')
        for part in (x.get('annotations') or '').split(' || '):
            t, _, desc = part.partition(': '); t = t.strip()
            m = re.match(r'\[(\w+)\]\s*(.+?)\((\w+)\)\s*—\s*(.*)', desc) if t in ('cond', 'common') else None
            if t == 'common' and m:
                v, name, _k2, note = m.groups()
                rule = 'K1' if re.search(r'sort|filter', name, re.I) else 'K2' if re.search(r'column|measure', name, re.I) else 'H7' if re.search(r'excel', name, re.I) else 'G3' if re.search(r'condition|reset', name, re.I) else 'K3' if re.search(r'manual', name, re.I) else ''
                if rule:
                    prev = ev_screen.get(rule)
                    res = V.get(v, '판정필요'); worse = prev and ({'FAIL': 0, 'ERROR': 1, '판정필요': 2, 'PASS': 3, 'NA': 4}.get(prev[0], 2) < {'FAIL': 0, 'ERROR': 1, '판정필요': 2, 'PASS': 3, 'NA': 4}.get(res, 2))
                    ev_screen[rule] = prev if worse else (res, f"E2E smoke 공통 '{name}' [{v}] {note[:100]}" + (f" | {prev[1][:80]}" if prev else ''))
            elif t == 'cond' and m:
                v, name, k2, note = m.groups()
                if k2 in ('combo', 'checkbox', 'radio', 'text', 'period', 'search'): ev_cond[('G1', norm(name))] = (V.get(v, '판정필요'), f"E2E smoke 조회조건 '{name}' [{v}] {note[:100]}")
            elif t == 'columns': ev_screen.setdefault('A5', ('PASS' if re.search(r'누락 0', desc) else 'FAIL', f'E2E smoke columns {desc[:120]}'))
            elif t in ('access', 'buttons', 'authcrud') and kind.startswith('auth'):
                # 메뉴 접근 권한이 없는 그룹(menuAccess=N)의 기대값 없는 기록은 이 화면의 J2 판정 근거가 아니다(DM Admin 은 SCP 화면 접근 대상 아님) — 2026-10-27 v57 허위 FAIL
                if re.search(r'menuAccess=N', desc) and re.search(r'expected=(\s|$)', desc):
                    ev_screen.setdefault('J2', ('NA', f'E2E {kind} {desc[:100]} — 메뉴 접근 권한이 없는 그룹(menuAccess=N)의 기록은 이 화면 J2 판정 근거가 아님(접근 대상 아님 · 버튼 권한 실측은 J1/authcrud 다른 기록)')); continue
                if re.search(r'예외: ?(TimeoutError|Error)|Timeout \d+ms exceeded', desc):  # E2E 실행 예외(클릭 타임아웃 등)는 판정이 아니라 측정 실패 — FAIL 근거로 쓰지 않음(2026-10-28 jaeuk.shin authcrud)
                    ev_screen.setdefault('J2', ('NA', f'E2E {kind} 측정 실패(실행 예외) — {desc[:120]}')); continue
                prev = ev_screen.get('J2'); res = 'PASS' if st == 'PASS' else 'FAIL' if st == 'FAIL' else '판정필요'
                ev_screen['J2'] = (('FAIL', f'E2E {kind} {desc[:100]}') if (prev and prev[0] == 'FAIL') or res == 'FAIL' else (res, f'E2E {kind} {desc[:100]}'))
            elif t == 'cascade' and kind.startswith('auth'):
                # 2026-10-27: 권한·Division CASCADE(authcrud) — J1 = Division 후보 ⊆ 계정 권한·대표 Division 포함 / C1 = Division 연동 조회조건 후보 1건 이상
                leak = (re.search(r'권한밖=(\S+)', desc) or [None, '?'])[1]; listed = (re.search(r'대표포함=(\w+)', desc) or [None, 'null'])[1]
                j1 = ('판정필요' if '후보=[]' in desc else 'PASS' if leak == '0' and listed in ('true', 'null') else
                      'FAIL' if leak not in ('0', '?') or listed == 'false' else '판정필요')   # 후보를 못 읽음 = 미확인(PASS 아님)
                dep_txt = (re.search(r'연동=(.*?)(?: 비고=|$)', desc) or [None, ''])[1]
                deps = [tuple(x.rsplit(':', 1)) for x in dep_txt.split(',') if re.search(r':\d+$', x)]
                c1 = ('PASS' if all(int(n) > 0 for _, n in deps) else 'FAIL') if deps else None
                for rule, res in (('J1', j1), ('C1', c1)):
                    if res is None: continue
                    prev = ev_screen.get(rule)
                    if prev and prev[0] == 'FAIL': continue
                    ev_screen[rule] = (res, f'E2E {kind} cascade {desc[:140]}' + (f' | {prev[1][:80]}' if prev else ''))
            elif t == 'i18n': ev_screen.setdefault('I2', ('PASS' if desc.startswith("'_' 노출 0") else 'FAIL', f'E2E smoke i18n {desc[:100]}'))
    for r in rows:
        if r['result'] != 'NOT_RUN' or (r.get('tobe_ref') or '').startswith('수동'):
            continue
        if r['source'] == 'RULE_SCREEN' and r['rule_id'] in ev_screen:
            r['result'], r['evidence'], r['tobe_ref'] = ev_screen[r['rule_id']][0], ev_screen[r['rule_id']][1][:1500], 'E2E smoke/auth 요약'; stat['SMOKE'] += 1
        elif r['source'] == 'SEARCH' and r['rule_id'] in ('G1', 'G2'):
            k = ('G1', norm(r['target'].replace('조회조건', '', 1)))
            if k in ev_cond:
                res, ev = ev_cond[k]
                if r['rule_id'] == 'G2': res = 'PASS' if res == 'PASS' else '판정필요'; ev = ev + ' — ALL/다중 사양은 @verify G2 미실행(6개 초과 조건) · smoke 동작 결과로 대체'
                r['result'], r['evidence'], r['tobe_ref'] = res, ev[:1500], 'E2E smoke 조회조건 동작'; stat['SMOKE'] += 1
        elif r['source'] == 'SEARCH' and r['rule_id'] == 'C1':
            t = [j for j in rows if j['source'] == 'TRACE' and j['rule_id'] == 'C1' and j['result'] not in ('NOT_RUN', '') and norm(r['target'].replace('조회조건', '', 1)) in norm(j['target'])]
            if t: r['result'], r['evidence'], r['tobe_ref'] = t[0]['result'], f"상속(TRACE {t[0]['row_id']}): {t[0]['evidence'][:300]}", '상속(검증엔진 @trace)'; stat['SMOKE'] += 1
    # 사용자판정·사용자의견 반입(2026-10-26 · 10-27 확장) — 정합검증서 xlsx 의 '사용자판정'(이전 라운드) 과 '사용자의견'(최신 라운드) 열.
    #   같은 행에 둘 다 있으면 판정 문구가 되는 '사용자의견' 이 이기고, 의견이 메모형(상세 설명/이해 불가/중복) 이면 '사용자판정' 의 판정을 유지한 채 메모만 붙인다.
    #   집계·상속(SCREEN_AGG·DEFECT/CONFIRMED) 보다 앞에 두어 사용자가 바로잡은 요소 판정이 상위 집계에도 반영되게 한다(10-27: B2 요소 PASS 인데 결함원장 B2 가 FAIL 로 남던 문제).
    MAP = [(r'^pass', 'PASS'), (r'^fail', 'FAIL'), (r'to-?be\s*기준\s*준수', 'PASS'), (r'^구현\s*필요', 'FAIL'), (r'^(na|해당\s*없음)$', 'NA'),  # '구현대상인데 미구현이면 fail' 은 조건부 지시 — W9 실측이 판정하므로 메모로만(2026-10-27)
           (r'판정\s*오류|판단\s*오류|오류\s*아님|이상\s*없음|^정상|정상\s*확인|오류\s*재현\s*안\s*됨', 'PASS'), (r'대상\s*아님|대상이\s*아니', 'NA')]
    RX_NOTE = re.compile(r'상세\s*설명|이해\s*불가|중복|정확하게|정확한|어디서')
    EXPLAIN = {('H2', 'SetFGColor'): "AS-IS Set_ValidTextColor: Route Valid='N' 인 행은 Trans Mode~Distribution Total 셀 글자색을 '유효하지 않음' 색으로, Route Check 가 'Y' 가 아닌 행은 Route Id 글자색을 표시색으로 바꿔 보여준다 — TO-BE 그리드는 이 글자색 구분이 없음"}
    uv, un = {}, {}
    try:
        import glob, openpyxl
        files = sorted(glob.glob(P('Doc', '화면분석서', f'{mid}_*_정합검증서_v*.xlsx')), key=os.path.getmtime)
        for f in files:  # 오래된 → 최신 순으로 덮어써 최신 기입이 남는다
            try: wb = openpyxl.load_workbook(f, read_only=True, data_only=True)
            except Exception: continue
            for ws in wb.worksheets:
                rws = list(ws.iter_rows(values_only=True))
                hi = next((i for i, rr in enumerate(rws[:5]) if any(c and ('사용자판정' in str(c) or '사용자의견' in str(c)) for c in rr)), None)
                if hi is None: continue
                c_j = [k for k, c in enumerate(rws[hi]) if c and '사용자판정' in str(c)]
                c_o = [k for k, c in enumerate(rws[hi]) if c and '사용자의견' in str(c)]
                for rr in rws[hi + 1:]:
                    rid = str(rr[1]) if len(rr) > 1 and rr[1] else ''
                    if not rid: continue
                    for ci in c_j:
                        if ci < len(rr) and rr[ci] and str(rr[ci]).strip(): uv[rid] = str(rr[ci]).strip()
                    for ci in c_o:
                        if ci < len(rr) and rr[ci] and str(rr[ci]).strip():
                            o = str(rr[ci]).strip()
                            if any(re.search(rx, o, re.I) for rx, _ in MAP): uv[rid] = o
                            else: un[rid] = o
    except Exception as ex:
        print(f'[WARN] 사용자판정 반입 실패: {ex}')
    stat.setdefault('USER', 0)
    for r in rows:
        u = uv.get(r['row_id']); n = un.get(r['row_id'])
        if not u and not n: continue
        r['note'] = (r.get('note') or '')[:200] + (f' | 사용자판정: {u[:160]}' if u else '') + (f' | 사용자의견: {n[:160]}' if n else '')
        base_ev = re.sub(r'^(\[사용자(판정|의견)[^\]]*\].*?(— 실측: |\] ))+', '', r.get('evidence') or '', flags=re.S)  # 판정 문구에 줄바꿈이 있어도 접두를 전부 벗긴다(2026-10-27 11중 중첩 실측)
        for (rid_, tg), txt in EXPLAIN.items():
            if r['source'] == 'ASIS' and r['rule_id'] == rid_ and tg in (r.get('target') or ''): base_ev = txt + ' · 실측: ' + base_ev[:300]
        res = next((val for rx, val in MAP if re.search(rx, u or '', re.I)), None) if u else None
        if res:
            u1 = re.sub(r'\s+', ' ', u).strip()
            r['result'] = res; r['evidence'] = (f"[사용자판정] {u1} — 실측: {base_ev[:700]}")[:1500]; r['tobe_ref'] = '수동 사용자판정(정합검증서)'; stat['USER'] += 1
            e2e_ids.add(r['row_id'])  # 사용자 판정 행은 뒤 단계(상속·스윕)가 덮지 않는다
        elif n:
            r['evidence'] = base_ev[:1500]  # 메모형 의견(상세 설명·이해 불가·중복 등)은 note 와 정합검증서 '사용자의견' 열에만 — 증거 문장을 오염시키지 않는다(2026-10-27)
    # 그리드 컬럼 헤더 라벨 = 조회조건 기준표 라벨(CR-071 확장, 2026-10-27 사용자: SSP Incoterms 는 조회조건 라벨을 그리드에도 같이 쓰는 것이 TO-BE 룰)
    sc_names = {norm(x.get('tobe_name') or '') for x in read_csv(P('tools', 'Harness', 'rules', 'search_cond.csv')) if x['menu_id'].upper() == mid and (x.get('tobe_name') or '').strip()}
    stat.setdefault('H5_CR071', 0)
    for r in rows:
        if r['source'] != 'TRACE' or r['rule_id'] != 'H5' or r['result'] != 'FAIL' or r['row_id'] in e2e_ids and r.get('tobe_ref') == '수동 사용자판정(정합검증서)': continue
        m = re.search(r"TO-BE 헤더 '([^']+)'", r.get('evidence') or '')
        if m and norm(m.group(1)) in sc_names:
            r['result'] = 'PASS'; r['evidence'] = (f"{r['evidence'].split(' — ')[0]} = 조회조건 기준표 라벨 '{m.group(1)}' — TO-BE 룰(CR-071 확장: 조회조건으로 쓰는 컬럼은 그리드 헤더도 기준표 라벨) → AS-IS 명칭과 달라도 PASS")[:1500]; r['tobe_ref'] = 'TO-BE 룰 CR-071(그리드 헤더 = 기준표 라벨)'; stat['H5_CR071'] += 1
    # J2 — 이전 실행이 남긴 'E2E smoke/auth 요약' 중 메뉴 접근 권한 없는 그룹 기록(menuAccess=N · expected 없음)은 판정 근거가 아님 → NA (2026-10-28, v57~v60 허위 FAIL)
    stat.setdefault('J2_NOACCESS', 0)
    try: summ_rows_cache = read_csv(P('Doc', 'e2e', 'results', '_summary.csv'))
    except Exception: summ_rows_cache = []
    for r in rows:
        ev0 = r.get('evidence') or ''
        if r['rule_id'] == 'J2' and r['result'] == 'FAIL' and (r.get('tobe_ref') or '').startswith('E2E smoke/auth'):
            key0 = re.sub(r'^E2E authcrud\s*', '', ev0)[:40]
            full = next(((x.get('annotations') or '') + ' ' + (x.get('errors') or '') for x in summ_rows_cache if (x.get('menu_id') or '').upper() == mid and (x.get('kind') or '') == 'authcrud' and key0 and re.sub(r'^authcrud:\s*', '', x.get('annotations') or '').startswith(key0)), ev0)
            if re.search(r'menuAccess=N', ev0) and re.search(r'expected=(\s|$)', ev0):
                r['result'] = 'NA'; r['evidence'] = (ev0 + ' — 메뉴 접근 권한이 없는 그룹(menuAccess=N)의 기록은 이 화면 J2 판정 근거가 아님(접근 대상 아님)')[:1500]; r['tobe_ref'] = 'E2E smoke/auth 요약(접근 대상 아님 · NA)'; stat['J2_NOACCESS'] += 1
            elif re.search(r'예외: ?(TimeoutError|Error)|Timeout \d+ms exceeded|허용 계정 마커 행 저장', full + ' ' + ev0):
                r['result'] = 'NA'; r['evidence'] = (f'E2E authcrud 측정 실패(실행 예외 — 클릭 타임아웃·마커 행 저장 실패, saveCalls=0) — 권한별 CRUD 는 재실행으로 판정: {full[:300]}')[:1500]; r['tobe_ref'] = 'E2E smoke/auth 요약(측정 실패 · 재실행)'; stat['J2_NOACCESS'] += 1
    # Insert 위치 TO-BE 룰 CR-074(2026-10-27 사용자 판정 "정상"): 목록 그리드의 Insert 는 맨 위 — AS-IS 활성 행 위치와 달라도 PASS
    stat.setdefault('D6_CR074', 0)
    for r in rows:
        if r['rule_id'] == 'D6' and r['result'] == 'FAIL' and '신규행 맨 위' in (r.get('evidence') or ''):
            r['result'] = 'PASS'; r['evidence'] = ((r.get('evidence') or '').split(' — AS-IS')[0] + ' — TO-BE 룰 CR-074(사용자 판정 2026-10-27): 세트(그룹) 구조 없는 목록 그리드의 Insert 는 맨 위(공용 DataGrid 기본) → AS-IS 활성 행 위치와 달라도 PASS')[:1500]; r['tobe_ref'] = 'TO-BE 룰 CR-074(Insert 맨 위)'; stat['D6_CR074'] += 1
    # 셀 병합 TO-BE 룰 CR-073(2026-10-27 사용자 판정 "셀병합 적용되어 있음 — 오류 아님"): 화면이 병합 대상에서 뺀 컬럼 · 왼쪽 비병합 컬럼 때문에 병합되지 않는 컬럼 = PASS
    stat.setdefault('H3_CR073', 0)
    for r in rows:
        if r['source'] != 'TRACE' or r['rule_id'] != 'H3' or r['result'] != 'FAIL': continue
        ev = r.get('evidence') or ''
        if 'TO-BE 가 이 컬럼을 병합 대상에서 뺌' in ev or 'column.allowMerging=false' in ev:
            r['result'] = 'PASS'; r['evidence'] = (ev.split(' ↔ ')[0] + ' ↔ TO-BE 는 이 컬럼을 병합 대상에서 제외(BodGrid MERGE_COLUMNS) — TO-BE 룰 CR-073: 셀 병합은 키(그룹) 컬럼만, 값 컬럼은 병합하지 않음 → AS-IS 와 달라도 PASS')[:1500]; r['tobe_ref'] = 'TO-BE 룰 CR-073(키 컬럼만 병합)'; stat['H3_CR073'] += 1
        elif '병합 대상인데 안 됨' in ev:
            r['result'] = 'PASS'; r['evidence'] = (ev.split(' — 병합 대상인데')[0] + ' — 병합 대상 컬럼이지만 왼쪽에 비병합 컬럼(SSP Incoterms·Priority·Route Count 등)이 있어 공용 CustomMergeManager 의 계층 병합 구조상 병합되지 않음 — TO-BE 룰 CR-073: 오류 아님(MERGE_COLUMNS 위치 설계 확인 권고)')[:1500]; r['tobe_ref'] = 'TO-BE 룰 CR-073(키 컬럼만 병합)'; stat['H3_CR073'] += 1
    # TO-BE UI 에 없는 항목 = 정합 대상 아님 → NA (2026-10-27 사용자: "정합검증 대상 UI 에 존재하지 않고 정합 대상도 아닌 항목을 표기하고 FAIL 로 분류할 필요 없다")
    #   검사기가 '칸/컬럼/버튼 없음' 을 FAIL 로 적은 요소 행을 NA 로 바꾼다. 단 대조표 상태 '미구현'(구현해야 할 항목 · X-NOTIMPL · '구현 후 검증') 과 사용자판정 행은 그대로 FAIL.
    #   집계(SCREEN_AGG·DEFECT/CONFIRMED 상속) 보다 앞에 두어 분모에서도 빠지게 한다.
    RX_ABSENT = re.compile(r'(없음\(표시 자체가 없어|칸을 찾지 못함|현재 그리드에 없음|\) 칸 없음|조회조건 [^ ]+\([^)]*\) 칸 없음|TO-BE (화면|UI|그리드|팝업)에 (해당 )?(입력칸|컬럼|버튼|요소)?\s*없음|표시 자체가 없|not found)')
    stat.setdefault('ABSENT_NA', 0)
    for r in rows:
        if r['result'] != 'FAIL' or r['source'] in ('DEFECT', 'CONFIRMED', 'GENERAL'):
            continue
        ev = r.get('evidence') or ''
        if re.match(r'^(대조표 상태 미구현|\[사용자판정\])', ev) or '미구현' in ev[:120] or '구현 후 검증' in ev or (r.get('tobe_ref') or '').startswith('W8'):
            continue
        if RX_ABSENT.search(ev):
            r['result'] = 'NA'; r['evidence'] = ('TO-BE UI 에 없는 항목(정합 대상 아님 · 대조표 미구현 아님) — ' + ev)[:1500]; r['tobe_ref'] = '대상 없음(TO-BE UI 미존재 · NA)'; stat['ABSENT_NA'] += 1
    # 화면 단위 규칙(RULE_SCREEN) 이 아직 NOT_RUN 이면 같은 규칙의 요소 실측(TRACE·COLUMN·SEARCH·ASIS, 이번 실행 판정)을 집계해 이어받는다 — 2026-10-26
    #   FAIL 1건이라도 → FAIL · 판정필요 있으면 → 판정필요 · 전부 PASS/NA → PASS(NA 만이면 NA). 증거에 분포와 대표 행을 적는다.
    stat.setdefault('SCREEN_AGG', 0)
    for r in rows:
        stale = ((r.get('tobe_ref') or '') in ('W7 시나리오', 'W4 검사기 구현 대상', '요소 판정 집계(검증엔진)'))  # 이전 실행의 스윕·집계 결과 — 매 실행 요소 실측으로 다시 집계(2026-10-27: A5 집계 FAIL 이 분모 보정 뒤에도 남던 결함)
        if r['source'] != 'RULE_SCREEN' or (r['result'] != 'NOT_RUN' and not stale) or (r.get('tobe_ref') or '').startswith('수동'):
            continue
        # 화면 규칙 집계의 분모 = 요소 실측(COL/COND/SP 등)만 — 행·진입점 집계·'대조표 미구현(BLOCKED)' 종속 FAIL 은 제 행에서 세고 화면 규칙에는 올리지 않는다(2026-10-27: A5 가 무관한 미구현 행 1건으로 FAIL)
        same = [j for j in rows if j['source'] in ('TRACE', 'COLUMN', 'SEARCH', 'ASIS') and j['rule_id'] == r['rule_id'] and j['result'] not in ('NOT_RUN', '')
                and not re.search(r'"et": "(ROW|ENTRY|LEDGER)"', (j.get('condition') or '')[:40]) and not re.match(r'^(대조표 상태 미구현|행 집계|진입점 집계)', j.get('evidence') or '')]
        if not same:
            continue
        cnt = collections.Counter(j['result'] for j in same)
        res = 'FAIL' if cnt.get('FAIL') else '판정필요' if (cnt.get('판정필요') or cnt.get('ERROR')) else 'PASS' if cnt.get('PASS') else 'NA'
        pick = [j for j in same if j['result'] == res][:3]
        r['result'] = res; r['tobe_ref'] = '요소 판정 집계(검증엔진)'
        r['evidence'] = f"규칙 {r['rule_id']} 요소 {len(same)}행 집계 — " + ' · '.join(f'{k} {v}' for k, v in cnt.most_common()) + ' | ' + ' | '.join(f"[{j['row_id']}] {j['target'][:40]}: {(j['evidence'] or '')[:120]}" for j in pick)
        stat['SCREEN_AGG'] += 1
    # 대조표가 '제외/해당없음' 으로 결정한 AS-IS 메서드의 ASIS 문장 행 → NA(대조표 사유 인용) — 2026-10-26 (EditButton 토글 어포던스 미이식 등)
    excl = [x for x in read_csv(P('Doc', 'verify', mid, 'mapping_trace.csv')) if x.get('source') == 'FE 대조표' and re.match(r'^(제외|해당없음|N/A)', x.get('status', ''))]
    for r in rows:
        if r['source'] != 'ASIS' or r['result'] != 'NOT_RUN':
            continue
        meth = (re.search(r'\.(\w+)\s*$', r.get('asis_ref', '').split('·')[0].strip()) or [None, ''])[1]
        if not meth:
            continue
        hit = next((x for x in excl if re.search(r'(?<![A-Za-z0-9_])' + re.escape(meth) + r'(?![A-Za-z0-9_])', x.get('summary', ''))), None)
        if hit:
            r['result'], r['evidence'], r['tobe_ref'] = 'NA', f"검사 대상 아님 — 대조표 {hit['row_id']} 가 {meth} 를 '{hit['status']}' 로 결정: {hit['summary'][:160]}", '대조표 제외 결정'
    # ASIS 예외 처리 메시지(GMessageBoxForException — catch 블록) = 프레임워크 공통 오류 표시, 화면 고유 동작 아님 → NA(검사 대상 아님) 2026-10-26
    for r in rows:
        if r['source'] == 'ASIS' and r['result'] == 'NOT_RUN' and r['target'] == '(동적 메시지)' and re.search(r'catch\s*\(', r.get('condition', '')):
            r['result'], r['evidence'], r['tobe_ref'] = 'NA', '검사 대상 아님 — catch 블록의 예외 메시지(프레임워크 공통 오류 표시). 화면 고유 검증 메시지가 아니다', 'STATIC judge'
    # ASIS 행(문장 단위) 상속 — 같은 규칙·같은 컬럼의 COLUMN/TRACE 실측이 있으면 이어받는다(2026-10-26: EditButton LockColumn D1 7행·InsertButton SetValue D4 19행이 영원히 NOT_RUN).
    #   AS-IS 문장과 TO-BE 컬럼 검사는 같은 사실(그 컬럼의 편집 가능·기본값·색·셀타입)을 두 각도로 본 것 — 가장 나쁜 결과를 취한다
    stat.setdefault('INHERIT', 0)
    worst = lambda rs: 'FAIL' if 'FAIL' in rs else 'ERROR' if 'ERROR' in rs else '판정필요' if '판정필요' in rs else 'PASS' if 'PASS' in rs else 'NA' if rs and all(x == 'NA' for x in rs) else ''
    for r in rows:
        stale_inh = (r.get('tobe_ref') or '') == '상속(COLUMN/TRACE 실측)'  # 이전 실행의 상속 결과 — 원천(COLUMN/TRACE)이 바뀌면 다시 상속(2026-10-26: INCOTERMS COLUMN PASS 인데 ASIS 행이 옛 판정필요로 남던 구멍)
        if r['source'] != 'ASIS' or (r['result'] != 'NOT_RUN' and not stale_inh) or r['rule_id'] not in ('D1', 'D4', 'H2', 'D5', 'E1', 'E2', 'E5', 'B1', 'B2'):
            continue
        cols = [c for c in re.split(r'[,\s]+', r['target']) if re.fullmatch(r'[A-Z][A-Z0-9_]+', c)]
        if not cols:
            # 대상에 컬럼이 없는 잠금 문장(siMain.LockColumn 범위형) — lock_rules.csv 의 같은 줄(line) 컬럼 목록을 쓴다
            m = re.search(r'\.cs:(\d+)', r.get('asis_ref', ''))
            if m:
                lr = next((l for l in read_csv(P('Doc', 'asisfacts', 'screens', asis_id, 'lock_rules.csv')) if l.get('line') == m.group(1) and l.get('columns')), None)
                if lr: cols = [c for c in lr['columns'].split(';') if c]
        if not cols and r['rule_id'] == 'H2' and re.search(r'SetFGColor', r['target'] + r['expected']) and 'Set_ValidTextColor' in (r.get('asis_ref') or ''):
            cols = ['ROUTE_ID', 'TRANSPORT_MODE', 'DIS_TOTAL_LEAD_TIME']  # Set_ValidTextColor: ROUTE_VALID='N' 행의 Trans Mode~Distribution Total 글자색 · ROUTE_CHK 에 따른 Route Id 글자색
        if not cols:
            continue
        got = []
        for c in cols:
            same = [j for j in rows if j['rule_id'] == r['rule_id'] and j['source'] in ('COLUMN', 'TRACE') and j['result'] not in ('NOT_RUN', '')
                    and (re.match(r'^[^.\s]+\.' + re.escape(c) + r'\b', j['target']) or re.match(r'^' + re.escape(c) + r'(\s|/|$)', j['target']))]
            # D1: 조건에 '기존행/신규행' 이 있으면 AS-IS 문장 위치로 고른다(EditButton·FindData = 기존행, InsertButton = 신규행)
            if r['rule_id'] == 'D1':
                want = '신규행' if 'InsertButton' in r['asis_ref'] else '기존행'
                same = [j for j in same if j['source'] != 'COLUMN' or j['condition'] in ('', want)]
            got += [(c, j) for j in same]
        if not got:
            continue
        res = worst([j['result'] for _, j in got])
        if not res:
            continue
        r['result'] = res
        meaning = {'D1': '컬럼 잠금/편집 가능', 'D4': '신규행 기본값·자동세팅', 'H2': '셀 색(편집 가능 노랑 · 글자색)', 'D5': '셀 에디터 유형', 'E1': '숫자 입력 규칙', 'E2': '날짜 입력 규칙', 'E5': '입력 규칙', 'B1': '콤보 후보', 'B2': '콤보 후보 중복'}.get(r['rule_id'], r['rule_id'])
        r['evidence'] = (f"AS-IS 문장 '{r['target'][:40]}' 의 {meaning} 기대를 TO-BE 컬럼 실측으로 판정 — " + ' | '.join(f"{c}: {j['result']} — {j['evidence'][:110]}" for c, j in got[:4]))[:1500]
        r['tobe_ref'] = '상속(COLUMN/TRACE 실측)'
        stat['INHERIT'] += 1

    rule_defs = {d['check']: d for d in read_csv(os.path.join(HERE, 'mapping_checkdefs.csv'))}  # 검사기 구현 여부(impl) — 허위 PASS 차단용
    # DEFECT·CONFIRMED 행 — 같은 규칙의 실측 판정 이어받기(대상 일치 우선). CONFIRMED(확정 규칙)도 같은 방식(2026-10-26: 67행이 영원히 NOT_RUN)
    # 결함원장·확정규칙의 상속 분모 = 요소 실측만 — 행·진입점 집계와 '대조표 미구현' 종속 FAIL 은 제외(2026-10-27 사용자: 무관한 미구현 행 때문에 A5/G4/G1 결함이 FAIL 로 보임)
    judged = [r for r in rows if r['source'] not in ('DEFECT', 'CONFIRMED', 'GENERAL') and r['result'] not in ('NOT_RUN', '')
              and not re.search(r'"et": "(ROW|ENTRY|LEDGER)"', (r.get('condition') or '')[:40]) and not re.match(r'^(대조표 상태 미구현|행 집계|진입점 집계)', r.get('evidence') or '')]
    for r in rows:
        if r['source'] not in ('DEFECT', 'CONFIRMED', 'GENERAL') or (r.get('tobe_ref') or '').startswith('수동'):
            continue
        if r['row_id'] in e2e_ids:
            continue  # 검증 엔진이 이 행을 직접 판정(예: H9 컬럼 폭·M1 업로드 유무) — 규칙 상속으로 덮지 않는다
        r['result'], r['evidence'], r['tobe_ref'] = 'NOT_RUN', '', ''  # 매 실행 다시 상속(낡은 상속 판정 방지)
        same = [j for j in judged if j['rule_id'] == r['rule_id']]
        if not same:
            continue
        toks = {t for t in re.findall(r'[A-Za-z][A-Za-z_]{2,}', r['target'] + ' ' + r['expected']) if len(t) > 3}
        matched = [j for j in same if any(t.upper() in j['target'].upper() for t in toks)]
        focus = matched or same
        fails = [j for j in focus if j['result'] == 'FAIL']
        undecided = [j for j in focus if j['result'] in ('판정필요', 'ERROR')]
        measured = [j for j in focus if j['result'] in ('PASS', 'FAIL', '판정필요', 'ERROR')]
        impl_y = (rule_defs.get(r['rule_id'], {}).get('impl') == 'Y')
        # 허위 PASS 차단(2026-10-27 사용자: 사람이 찾은 오류를 같은 형태로 찾을 수 있는가)
        #   ① 같은 규칙 판정이 전부 NA 인데 대상이 직접 일치하지 않으면(예: K3 'Ctrl+클릭 다중선택' ← 'Manual(F1) 버튼 없음' NA) 실측 근거가 없다
        #   ② 검사기 미구현 규칙은 다른 대상의 PASS 를 빌려 PASS 로 두지 않는다(대상 직접 일치 실측이 있을 때만 상속)
        if not fails and not undecided and (not measured or (not impl_y and not matched)):
            if measured == [] and matched:
                r['result'] = 'NA'
                r['evidence'] = f"규칙 {r['rule_id']} 대상 일치 {len(matched)}행이 모두 NA — " + ' | '.join(f"[{j['row_id']}] {j['target']}: {j['evidence'][:140]}" for j in matched[:3])
                r['tobe_ref'] = '규칙 판정 상속(대상 없음)'
            else:
                r['result'] = 'NA'  # 기계 실측이 없는 결함원장·확정규칙 항목 = 수동 검수 대상(사용자 지시: 판정필요는 A1 건수 차이 외 남기지 않음, 2026-10-27)
                r['evidence'] = (f"자동 검사기 없음 — 수동 검수 대상(작업 원장 W4): {rule_defs.get(r['rule_id'], {}).get('how', '')}" if not impl_y else
                                 f"자동 실측 없음 — 수동 검수 대상(작업 원장 W5): 규칙 {r['rule_id']} 판정 {len(focus)}행이 모두 NA · 이 결함 대상과 직접 일치하는 실측 없음")
                r['tobe_ref'] = 'W4 검사기 구현 대상' if not impl_y else 'W5 검사기 연결'
            stat['DEFECT'] += 1
            continue
        r['result'] = 'FAIL' if fails else ('판정필요' if undecided else 'PASS')
        pick = fails or undecided or focus
        r['evidence'] = f"규칙 {r['rule_id']} 판정 {len(focus)}행 중 FAIL {len(fails)} · 판정필요 {len(undecided)}{'' if matched else ' (대상 직접 일치 없음 · 규칙 전반 상속)'} — " + ' | '.join(f"[{j['row_id']}] {j['target']}: {j['evidence'][:140]}" for j in pick[:4])
        r['tobe_ref'] = '규칙 판정 상속'
        stat['DEFECT'] += 1

    # 최종 스윕(2026-10-26 사용자: PASS/FAIL 아닌 항목이 '사유 없이' 남지 않게) — 여기까지 NOT_RUN 인 행은 이유를 적어 분류한다
    #   검사기 미구현 규칙 → 판정필요(검증 엔진 확장 대상) · 확정규칙/결함원장 행인데 같은 규칙 판정 행이 없음 → NA(이 화면에 대상 기능 없음) · 그 외 → 판정필요(시나리오 필요)
    defs = {d['check']: d for d in read_csv(os.path.join(HERE, 'mapping_checkdefs.csv'))}
    for r in rows:
        if r['result'] == '판정필요' and (r.get('tobe_ref') or '') in ('W7 시나리오',) and not (r.get('evidence') or '').startswith('[사용자판정]'):
            r['result'] = 'NOT_RUN'  # 이전 실행의 스윕 결과(시나리오 수동)는 매번 다시 분류한다 — 분류 규칙이 바뀌면 따라가게(2026-10-27)
        if r['result'] != 'NOT_RUN':
            continue
        d = defs.get(r['rule_id'], {})
        if r['source'] == 'TRACE' and '구현 후 검증' in (r.get('evidence') or ''):
            r['result'] = 'FAIL'; r['tobe_ref'] = r.get('tobe_ref') or 'W8 선행 미구현(FAIL)'
        elif d.get('impl') not in ('Y',):
            # 자동 검사기가 없는 규칙 = 기계 판정 불가 → 사람 검수 항목(작업 원장 W4). 사용자 지시(2026-10-26/27): 판정필요는 A1 건수 차이 외 남기지 않음 → NA 로 분류하고 사유를 적는다
            r['result'] = 'NA'; r['evidence'] = f"자동 검사기 없음 — 수동 검수 대상(작업 원장 W4): {d.get('how', rules_how(r['rule_id']))}"; r['tobe_ref'] = 'W4 검사기 구현 대상(수동 검수)'
        elif r['source'] in ('CONFIRMED', 'DEFECT', 'GENERAL'):
            r['result'] = 'NA'; r['evidence'] = f"이 화면에 규칙 {r['rule_id']} 의 대상 요소·기능이 없음(같은 규칙의 판정 행 0) — 확정규칙·결함원장 공통 항목"; r['tobe_ref'] = '규칙 판정 상속(대상 없음)'
        elif r['rule_id'] == 'E2' and r['source'] == 'TRACE' and not re.search(r'DATE|YYYYMMDD|_DT|_YMD', (r.get('target') or '').upper()) and not re.search(r'"cell_control_object_type_code": "[^"]*(Date|Calendar)', r.get('condition') or ''):
            r['result'] = 'NA'; r['evidence'] = f"{(r.get('target') or '').split(' / ')[0]} 는 날짜 컬럼이 아님(AS-IS 문장의 컬럼 범위에 끼어 들어온 대상) — 날짜 입력 규칙 E2 대상 아님"; r['tobe_ref'] = '대상 없음(비날짜 컬럼 · NA)'
        else:
            r['result'] = '판정필요'; r['evidence'] = (r.get('evidence') or '') + f" | 검사기({d.get('checker', '')[:60]})가 이 대상을 실행하지 못함 — 시나리오 수동 확인"; r['tobe_ref'] = r.get('tobe_ref') or 'W7 시나리오'

    with open(led_p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    cnt = {}
    for r in rows:
        cnt[r['result']] = cnt.get(r['result'], 0) + 1
    print(f'{mid}: 판정 반영 ' + ' · '.join(f'{k} {v}' for k, v in stat.items()))
    print('  결과 분포: ' + ' · '.join(f'{k} {v}' for k, v in sorted(cnt.items())))
    return 0


if __name__ == '__main__':
    sys.exit(main())
