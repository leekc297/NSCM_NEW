# -*- coding: utf-8 -*-
"""측정 전 중복 정리(2026-11-25 사용자 승인 플랜 '검사 대상 중복 제거' D1) — 같은 확인은 대표 1행만 재고 구성원은 대표 측정으로 판정

  python tools/Harness/verify/dedup_pre.py <MENU_ID>      → Doc/verify/<ID>/dup_groups.csv(행 ID, 대표 행 ID, 키, 근거) · 요약 출력
  python tools/Harness/verify/dedup_pre.py --selftest

  같은 확인 키 = 규칙 · 대상 객체(SP 이름, 메시지 ID, 시트.컬럼, 코드 이름) · 근거 위치(AS-IS 코드 파일:줄 또는 결함·확정 규칙 번호) · 조건 종류(신규행, 기존행 등)
  근거 위치를 못 찾는 행은 묶지 않는다(서로 다른 확인을 합치지 않게). LLM 판단(dedup_screen.csv 같은 확인 묶음)은 같은 원장 행끼리만 더한다
  묶지 않는 경우: 지난 측정에서 묶음 안 판정이 서로 달랐던 묶음(측정 방법이 달라 갈림 → 결정 목록 대상), 대표가 될 측정 행이 없는 묶음
  대표 = 지난 측정에서 판정이 난 행 중 출처 순위(TRACE, SP, RULE_SCREEN, MSG, SEARCH, COLUMN, ASIS, CONFIRMED, DEFECT)가 앞선 행
  원장·판정은 바꾸지 않는다. 스펙(VERIFY_DUP)과 judge.py 가 이 파일을 읽는다
"""
import collections, csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)
OUT = 'dup_groups.csv'
RANK = ['TRACE', 'SP', 'RULE_SCREEN', 'MSG', 'SEARCH', 'COLUMN', 'ASIS', 'CONFIRMED', 'DEFECT']
MEASURED = {'PASS', 'FAIL'}   # 2026-11-26 개선안 20261126115652_SELF_2(R235): 대표·구성원 = PASS·FAIL 만. 해당없음·판정필요·미검증 행은 묶지 않음
NO_GROUP = {'NA', '해당없음', '판정필요', 'ERROR'}
USER_FILES = ('_user_verdicts.csv', '_user_verdicts_direct.csv')
SKIP_SRC = {'GENERAL'}   # 집계 행은 하위 행을 따라감(측정 없음)


def _read(p):
    try:
        with open(p, encoding='utf-8-sig', newline='') as fh:
            return list(csv.DictReader(fh))
    except OSError:
        return []


def obj_of(r):
    t = re.sub(r'\s+', ' ', r.get('target') or '').strip()
    t = re.sub(r'^[A-Z]{3}\d{4}\s+', '', t)   # 화면 ID 접두
    m = re.search(r'\b(MSG\d{4,})\b', t)
    if m:
        return 'MSG:' + m.group(1)
    m = re.search(r'\b(?:PKG_\w+\.)?(P_)?([A-Z][A-Z0-9]*_(?:GET|SAVE|INS|UPD|DEL|SEL|SEARCH)_[A-Z0-9_]+)\b', t)
    if m:
        return 'SP:' + re.sub(r'^P_', '', m.group(2))
    m = re.match(r'^([^.()]+)\.([A-Z][A-Z0-9_]+)\b', t)
    if m:
        return 'COL:' + m.group(2)
    m = re.search(r'\b([a-z]\w*\.[A-Z]\w+)\b', t)   # siMain.SwitchLock 같은 코드 이름
    if m:
        return 'CODE:' + m.group(1)
    return 'T:' + t.lower()


def anchor_of(r):
    a = r.get('asis_ref') or ''
    m = re.search(r'([\w.]+\.cs):(\d+)', a)
    if m:
        return f'cs:{m.group(1)}:{m.group(2)}'
    m = re.search(r'\b(DM-[A-Z0-9-]+|GAP-\d+|SCPSSP-\d+|SCP-[A-Z0-9-]+|SSP-[A-Z0-9-]+)\b', a)
    if m:
        return 'def:' + m.group(1)
    return ''


def cond_kind(r):
    c = (r.get('condition') or '').strip()
    if not c or c.startswith('{'):
        return ''
    m = re.search(r'(신규행|기존행|새 행|기존 행|빈 값|최소|최대|경계)', c)
    return m.group(1) if m else ''


def user_rows(mid, root=None):
    """사용자판정 행 ID(Doc/verify/_user_verdicts.csv · _user_verdicts_direct.csv 의 그 화면 행)"""
    return {(r.get('row_id') or '').strip() for f in USER_FILES for r in _read(os.path.join(root or ROOT, 'Doc', 'verify', f)) if (r.get('menu_id') or '').upper() == mid}


def check_key(r, protected=frozenset()):
    """같은 확인 키. 근거 위치가 없거나 사용자판정 행·해당없음·판정필요·미검증 행이면 '' (묶지 않음)"""
    if (r.get('source') or '') in SKIP_SRC or not r.get('rule_id'):
        return ''
    if r.get('row_id') in protected or (r.get('result') or '') in NO_GROUP:
        return ''
    anc = anchor_of(r)
    if not anc:
        return ''
    return '|'.join([(r.get('rule_id') or '').upper(), obj_of(r), anc, cond_kind(r)])


def rank_of(r):
    s = r.get('source') or ''
    return RANK.index(s) if s in RANK else len(RANK)


def build(rows, ai_pairs=None, protected=frozenset()):
    """→ (그룹 목록 [(대표, [구성원], 키, 근거)], 합치지 않은 묶음 [(키, 행들, 사유)])"""
    by = collections.defaultdict(list)
    for r in rows:
        k = check_key(r, protected)
        if k:
            by[k].append(r)
    groups, held = [], []
    for k, v in by.items():
        if len(v) < 2:
            continue
        res = {x.get('result') for x in v if x.get('result') in MEASURED}
        if len(res) > 1:
            held.append((k, v, f"지난 측정 판정이 서로 다름({', '.join(sorted(res))}) — 측정 방법 차이 확인 필요(결정 목록)")); continue
        meas = [x for x in v if x.get('result') in MEASURED]
        if not meas:
            held.append((k, v, '대표가 될 측정 행 없음(모두 미검증) — 묶지 않고 모두 잼')); continue
        rep = sorted(meas, key=lambda x: (rank_of(x), x['row_id']))[0]
        groups.append((rep, [x for x in v if x is not rep], k, '같은 확인 키(규칙·대상·근거 위치·조건 종류)'))
    if ai_pairs:   # LLM 판단(dedup_screen) — 같은 원장 행, 아직 묶이지 않은 행만
        inn = {x['row_id'] for g in groups for x in [g[0]] + g[1]}
        idx = {r['row_id']: r for r in rows}
        for rep_id, mem_ids, why in ai_pairs:
            rep = idx.get(rep_id); mems = [idx[m] for m in mem_ids if m in idx and m not in inn and m != rep_id and m not in protected and (idx[m].get('result') or '') not in NO_GROUP]
            if not rep or rep_id in inn or rep_id in protected or not mems or rep.get('result') not in MEASURED:
                continue
            if any(m.get('result') in MEASURED and m.get('result') != rep.get('result') for m in mems):
                continue
            groups.append((rep, mems, 'AI:' + rep_id, 'LLM 같은 확인 판단(dedup_screen): ' + why[:200])); inn |= {rep_id} | {m['row_id'] for m in mems}
    return groups, held


def ai_pairs_of(vd):
    rows = _read(os.path.join(vd, 'dedup_screen.csv'))
    g = collections.defaultdict(list)
    for x in rows:
        g[x.get('group_id')].append(x)
    out = []
    for v in g.values():
        rep = next((x.get('rep_row_id') for x in v if x.get('rep_row_id')), '')
        mems = [x['row_id'] for x in v if x['row_id'] != rep]
        if rep and mems:
            out.append((rep, mems, v[0].get('why') or ''))
    return out


def load(mid):
    """{구성원 행 ID: 대표 행 ID} — 스펙·judge·row_run 이 읽음"""
    return {r['row_id']: r['rep_row_id'] for r in _read(os.path.join(ROOT, 'Doc', 'verify', mid, OUT)) if r.get('row_id') and r.get('rep_row_id') and r['row_id'] != r['rep_row_id']}


def apply(mid, rows):
    """judge 끝: 구성원 행 판정 = 대표 판정(제자리 수정). 반환 = 바꾼 행 수"""
    mp = load(mid)
    if not mp:
        return 0
    by = {r['row_id']: r for r in rows}; n = 0
    for r in rows:
        rep = by.get(mp.get(r['row_id'], ''))
        if not rep or rep.get('result') not in MEASURED or (r.get('result') or '') in ('NA', '해당없음', '판정필요'):
            continue
        if r.get('result') == rep['result'] and (r.get('evidence') or '').startswith('[대표 측정]'):
            continue
        r['result'] = rep['result']; n += 1
        r['evidence'] = (f"[대표 측정] 같은 확인 대표 {rep['row_id']} 측정 결과(Doc/verify/{mid}/{OUT}): " + (rep.get('evidence') or ''))[:1500]
        r['tobe_ref'] = f"대표 측정({rep['row_id']})"
    return n


def main(argv):
    mid = argv[0].upper(); vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    rows = _read(os.path.join(vd, 'verify_ledger.csv'))
    if not rows:
        print(f'[ERROR] 원장 없음: Doc/verify/{mid}/verify_ledger.csv', flush=True); return 3
    groups, held = build(rows, ai_pairs_of(vd), user_rows(mid))
    with open(os.path.join(vd, OUT), 'w', encoding='utf-8-sig', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=['row_id', 'rep_row_id', 'source', 'rule_id', 'key', 'why']); w.writeheader()
        for rep, mems, k, why in groups:
            for x in [rep] + mems:
                w.writerow({'row_id': x['row_id'], 'rep_row_id': rep['row_id'], 'source': x.get('source', ''), 'rule_id': x.get('rule_id', ''), 'key': k, 'why': why})
    with open(os.path.join(vd, 'dup_held.csv'), 'w', encoding='utf-8-sig', newline='') as fh:
        w = csv.DictWriter(fh, fieldnames=['key', 'row_id', 'source', 'result', 'why']); w.writeheader()
        for k, v, why in held:
            for x in v:
                w.writerow({'key': k, 'row_id': x['row_id'], 'source': x.get('source', ''), 'result': x.get('result', ''), 'why': why})
    mem = sum(len(g[1]) for g in groups)
    mix = collections.Counter(' + '.join(sorted({g[0].get('source', '')} | {m.get('source', '') for m in g[1]})) for g in groups)
    print(f"[중복 정리] {mid}: 같은 확인 묶음 {len(groups)}개 · 대표만 재고 구성원 {mem}행은 대표 측정으로 판정 · 합치지 않은 묶음 {len(held)}개(dup_held.csv) · 출처 조합 "
          + ', '.join(f'{k} {v}' for k, v in mix.most_common(8)), flush=True)
    return 0


def selftest():
    ok = True
    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok &= bool(c)
    rows = [{'row_id': 'V-a', 'source': 'ASIS', 'rule_id': 'E4', 'target': 'MSG00167', 'asis_ref': 'X.cs:1306 SCP', 'condition': 'if', 'result': 'PASS'},
            {'row_id': 'T-a', 'source': 'TRACE', 'rule_id': 'E4', 'target': 'MSG00167', 'asis_ref': 'X.cs:1306', 'condition': '{"et":"MSG"}', 'result': 'PASS'},
            {'row_id': 'V-b', 'source': 'ASIS', 'rule_id': 'E4', 'target': 'MSG00167', 'asis_ref': 'X.cs:1314', 'condition': 'if', 'result': 'PASS'},
            {'row_id': 'V-c', 'source': 'DEFECT', 'rule_id': 'H4', 'target': 'Main Grid 컬럼 폭', 'asis_ref': '결함원장 DM-C4 (x)', 'condition': '', 'result': 'PASS'},
            {'row_id': 'V-d', 'source': 'CONFIRMED', 'rule_id': 'H4', 'target': 'Main Grid 컬럼 폭', 'asis_ref': '확정규칙 CR-003 (출처 DM-C4 x)', 'condition': '', 'result': 'PASS'},
            {'row_id': 'V-e', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'S.ROUTE_ID (R)', 'asis_ref': 'X.cs:950', 'condition': '신규행', 'result': 'PASS'},
            {'row_id': 'V-f', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'S.ROUTE_ID (R)', 'asis_ref': 'X.cs:950', 'condition': '기존행', 'result': 'PASS'},
            {'row_id': 'V-g', 'source': 'SP', 'rule_id': 'A6', 'target': 'SCP_GET_X', 'asis_ref': '', 'condition': '', 'result': 'PASS'},
            {'row_id': 'T-g', 'source': 'TRACE', 'rule_id': 'A6', 'target': 'SCP_GET_X', 'asis_ref': '', 'condition': '', 'result': 'PASS'},
            {'row_id': 'V-h', 'source': 'ASIS', 'rule_id': 'D3', 'target': 'siMain.SwitchLock', 'asis_ref': 'X.cs:319', 'condition': '', 'result': 'PASS'},
            {'row_id': 'T-h', 'source': 'TRACE', 'rule_id': 'D3', 'target': 'siMain.SwitchLock', 'asis_ref': 'X.cs:319', 'condition': '', 'result': 'FAIL'}]   # 2026-11-26 NA 는 묶음 대상 아님 → 판정 다른 묶음 시험은 PASS·FAIL 로
    g, h = build(rows)
    na = [{'row_id': 'N-1', 'source': 'ASIS', 'rule_id': 'E9', 'target': 'MSG00999', 'asis_ref': 'Y.cs:10', 'condition': '', 'result': 'NA'},
          {'row_id': 'N-2', 'source': 'TRACE', 'rule_id': 'E9', 'target': 'MSG00999', 'asis_ref': 'Y.cs:10', 'condition': '', 'result': 'NA'}]
    chk('해당없음 행끼리 = 묶지 않음', build(na)[0] == [])
    uv = [{'row_id': 'U-1', 'source': 'ASIS', 'rule_id': 'E8', 'target': 'MSG00888', 'asis_ref': 'Z.cs:5', 'condition': '', 'result': 'PASS'},
          {'row_id': 'U-2', 'source': 'TRACE', 'rule_id': 'E8', 'target': 'MSG00888', 'asis_ref': 'Z.cs:5', 'condition': '', 'result': 'PASS'}]
    chk('사용자판정 행 = 묶지 않고 남김', build(uv, protected={'U-1'})[0] == [] and len(build(uv)[0]) == 1)
    reps = {x[0]['row_id']: sorted(m['row_id'] for m in x[1]) for x in g}
    chk('같은 코드 줄 ASIS + TRACE = 1묶음, 대표 TRACE', reps.get('T-a') == ['V-a'])
    chk('다른 코드 줄(1314) = 따로', 'V-b' not in sum(reps.values(), []) and 'V-b' not in reps)
    chk('같은 결함 번호 DEFECT + CONFIRMED = 1묶음', any(set([k] + v) == {'V-c', 'V-d'} for k, v in reps.items()))
    chk('신규행·기존행 = 다른 확인', not any({'V-e', 'V-f'} <= set([k] + v) for k, v in reps.items()))
    chk('근거 위치 없는 행 = 묶지 않음', not any('V-g' in [k] + v for k, v in reps.items()))
    chk('지난 판정이 다른 묶음 = 합치지 않고 보류', any('siMain' in k for k, _v, _w in h))
    led = [dict(r) for r in rows]
    for r in led:
        if r['row_id'] == 'V-a': r['result'] = 'ERROR'
    import tempfile
    global ROOT
    r0 = ROOT; ROOT = tempfile.mkdtemp(); os.makedirs(os.path.join(ROOT, 'Doc', 'verify', 'ZZ'))
    try:
        with open(os.path.join(ROOT, 'Doc', 'verify', 'ZZ', OUT), 'w', encoding='utf-8-sig', newline='') as fh:
            w = csv.DictWriter(fh, fieldnames=['row_id', 'rep_row_id']); w.writeheader(); w.writerow({'row_id': 'V-a', 'rep_row_id': 'T-a'}); w.writerow({'row_id': 'T-a', 'rep_row_id': 'T-a'})
        n = apply('ZZ', led)
        chk('judge 끝: 구성원 판정 = 대표 판정 + 근거', n == 1 and [r for r in led if r['row_id'] == 'V-a'][0]['result'] == 'PASS' and [r for r in led if r['row_id'] == 'V-a'][0]['evidence'].startswith('[대표 측정]'))
    finally:
        ROOT = r0
    print('selftest', 'OK' if ok else 'FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    sys.exit(selftest() if sys.argv[1:2] == ['--selftest'] else main(sys.argv[1:]))
