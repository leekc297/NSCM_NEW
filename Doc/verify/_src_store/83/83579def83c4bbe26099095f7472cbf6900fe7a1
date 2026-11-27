# -*- coding: utf-8 -*-
"""grid_absent_guard.py — '현재 그리드에 없음' 해당없음과 같은 실행의 실측이 어긋나면 미검증(ERROR)으로 (2026-11-26 사용자 '그리드에 없음 해당없음 확인 → 넣어줘')

배경(2026-11-26 실측, Doc/verify/_na_grid_audit.csv): 22화면 '현재 그리드에 없음' 해당없음 2,418행 중 376행이 오판.
  264행 = 같은 실행의 표시 검사(A5)가 'TO-BE 표시=Y' 로 잰 컬럼 · 62행 = 같은 컬럼을 다른 E2E 검사가 PASS·FAIL 로 잼 · 50행 = 컬럼 이름 잘림(T649)
  해당없음은 원문·메타 근거가 있을 때만 쓴다(2026-11-11 지시 '재지 못한 행 = 미검증'). 컬럼이 그리드에 있다는 실측이 있으면 해당없음이 아니라 재지 못한 것.
판정: 해당없음 행의 근거에 '현재 그리드에 없음'이 있고, 같은 시트·같은 컬럼에 아래 실측이 있으면 ERROR
  ① A5 PASS·FAIL 근거에 'TO-BE 표시=Y'   ② 다른 규칙 E2E 판정 PASS·FAIL(tobe_ref 'E2E')
  시트 없는 대상(TRACE 'COL / 라벨')은 원장 COLUMN 행에서 그 컬럼이 한 시트에만 있을 때만 그 시트로 본다(다중 시트 오인 방지)
  python tools/Harness/verify/grid_absent_guard.py --selftest
  python tools/Harness/verify/grid_absent_guard.py <ID>|ALL     원장 기준 바뀔 행 수만 출력(파일 안 씀)
"""
import csv, glob, json, os, re, sys

TAG = '[측정 모순]'
# 2026-11-26 VMO 개선안 20261126115652_SELF_4(R236): judge.py ABSENT_NA 가 '칸을 찾지 못함'·'칸 없음'·'TO-BE 팝업에 없음'·'not found' FAIL 도 해당없음으로 바꾼다 —
#   같은 문구 전체를 보게 넓혀 그 행도 같은 실행의 실측과 대조한다(judge RX_ABSENT 와 같은 문구 · 실측 근거에서 빼는 기준도 같음)
RX_ABSENT = re.compile(r'(없음\(표시 자체가 없어|칸을 찾지 못함|현재 그리드에 없음|\) 칸 없음|조회조건 [^ ]+\([^)]*\) 칸 없음|TO-BE (화면|UI|그리드|팝업)에 (해당 )?(입력칸|컬럼|버튼|요소)?\s*없음|표시 자체가 없|not found)')
RX_NOT_READ = re.compile(r'입력 경로 없음|측정 경로 없음|해석 실패|미측정')   # 셀을 직접 읽지 않은 PASS·FAIL 은 근거로 안 씀
MEASURE_RULES = {'D1', 'H2', 'E1', 'E2', 'C3', 'D5', 'H8', 'H13', 'C6', 'K5', 'B1', 'B2', 'I2'}


def _nrm(s):
    return re.sub(r'[^a-z0-9]', '', (s or '').lower())


def key_of(r):
    """대상 → (시트 정규화 또는 '', 컬럼 대문자)"""
    t = (r.get('target') or '').strip()
    m = re.match(r'^([^.()]+?)\.([A-Za-z0-9_]+)', t)   # 시트 이름에 '/' 허용(W/H stock)
    if m:
        return _nrm(m.group(1)), m.group(2).upper()
    m = re.match(r'^([A-Za-z][A-Za-z0-9_]*)\s*(?:/|\(|$)', t)
    if m:
        return '', m.group(1).upper()
    return None


def ev_col(ev):
    """근거 문장 속 컬럼(대상이 AS-IS 문장·팝업 호출인 행) — '팝업 셀 X 이' · 'r0 X:' · 'X 현재 그리드에 없음'"""
    for rx in (r'팝업 셀 ([A-Za-z0-9_]+) 이', r'r\d+ ([A-Za-z][A-Za-z0-9_]+):', r'(?:^|[\s—·])([A-Za-z][A-Za-z0-9_]+):? 현재 그리드에 없음'):
        m = re.search(rx, ev or '')
        if m:
            return m.group(1).upper()
    return ''


def mctx_sheet(r):
    """원장 precond JSON 의 mctx.sheet(2026-11-26 이후 측정분만 있음)"""
    try:
        return ((json.loads(r.get('precond') or '{}') or {}).get('mctx') or {}).get('sheet') or ''
    except (ValueError, TypeError, AttributeError):
        return ''


def na_key(r):
    """해당없음 행의 비교 키. COLUMN·TRACE 는 대상, 그 밖(ASIS·GENERAL 등 대상이 문장)은 근거 문장 속 컬럼 (2026-11-26 DMF0005 'SOLDTO_DESCRIPTION,SOLDTO_DESCRIPTION' 등 36행)"""
    if r.get('source') in ('COLUMN', 'TRACE'):
        return key_of(r)
    c = ev_col(r.get('evidence'))
    return ('', c) if c else None


def apply(rows):
    """rows 를 고쳐 쓴다. 반환 = 바꾼 행 수"""
    col_sheets = {}
    for r in rows:
        if r.get('source') == 'COLUMN':
            k = key_of(r)
            if k and k[0]:
                col_sheets.setdefault(k[1], set()).add(k[0])

    def norm_key(k, r=None):
        if k and not k[0] and r is not None:   # 2026-11-26 측정 맥락의 시트(mctx.sheet · _trace/_verify spec 이 탭 이동·계획 첫 시트로 기록)
            sh = mctx_sheet(r)
            if sh:
                return _nrm(sh), k[1]
        if k and not k[0] and len(col_sheets.get(k[1], ())) == 1:
            return next(iter(col_sheets[k[1]])), k[1]
        return k
    seen = {}
    for r in rows:
        ev = r.get('evidence') or ''
        a5y = r.get('rule_id') == 'A5' and 'TO-BE 표시=Y' in ev and r.get('result') != 'ERROR'   # 2026-11-26 A5 가 AS-IS 정답 미확정으로 NA·판정필요여도 TO-BE 표시는 잰 값(SSP0003 T-0d6c4c80)
        if r.get('result') not in ('PASS', 'FAIL') and not a5y:
            continue
        k = norm_key(key_of(r), r)
        if not k:
            continue
        if a5y or (r.get('rule_id') in MEASURE_RULES and 'E2E' in (r.get('tobe_ref') or '') and not RX_ABSENT.search(ev) and not RX_NOT_READ.search(ev)):
            seen.setdefault(k, r['row_id'])
    n = 0
    for r in rows:
        if r.get('result') != 'NA' or not RX_ABSENT.search(r.get('evidence') or '') or (r.get('evidence') or '').startswith(TAG):
            continue
        k = norm_key(na_key(r), r)
        hit = seen.get(k) if k else None
        msh = mctx_sheet(r)
        if not hit and k and k[0] and msh and _nrm(msh) != k[0]:   # 2026-11-26 다른 시트를 연 상태에서 잰 '그리드에 없음' = 그 시트 미측정
            r['result'] = 'ERROR'
            r['evidence'] = (f"{TAG} 측정 시트 '{msh}' 에서 잼 — 대상 시트 컬럼은 그 탭에서 재지 않음(해당없음 아님, 재측정 대상) · 원래 근거: " + (r.get('evidence') or ''))[:1500]
            n += 1
            continue
        if not hit:
            continue
        r['result'] = 'ERROR'
        r['evidence'] = (f"{TAG} 같은 실행의 {hit} 가 컬럼 {k[1]} 을 그리드에서 잼 — 이 검사는 셀을 읽지 못함(해당없음 아님, 재측정 대상) · 원래 근거: " + (r.get('evidence') or ''))[:1500]
        n += 1
    return n


def selftest():
    ok = True

    def chk(n, c):
        nonlocal ok
        print('PASS' if c else 'FAIL', n); ok = ok and bool(c)
    rows = [
        {'row_id': 'V-a5', 'source': 'COLUMN', 'rule_id': 'A5', 'target': 'S1.COL_A (A)', 'result': 'PASS', 'evidence': "COL_A: AS-IS(Div 40) '기본' ↔ TO-BE 표시=Y", 'tobe_ref': 'E2E'},
        {'row_id': 'V-1', 'source': 'COLUMN', 'rule_id': 'H2', 'target': 'S1.COL_A (A)', 'result': 'NA', 'evidence': 'COL_A 현재 그리드에 없음', 'tobe_ref': 'E2E'},
        {'row_id': 'V-2', 'source': 'COLUMN', 'rule_id': 'H2', 'target': 'S2.COL_A (A)', 'result': 'NA', 'evidence': 'COL_A 현재 그리드에 없음', 'tobe_ref': 'E2E'},
        {'row_id': 'V-3', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'S1.COL_B (B)', 'result': 'NA', 'evidence': '기존행 r0 COL_B: 현재 그리드에 없음', 'tobe_ref': 'E2E'},
        {'row_id': 'V-4', 'source': 'COLUMN', 'rule_id': 'A5', 'target': 'S1.COL_C (C)', 'result': 'PASS', 'evidence': "COL_C: AS-IS '숨김' ↔ TO-BE 표시=N", 'tobe_ref': 'E2E'},
        {'row_id': 'V-5', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'S1.COL_C (C)', 'result': 'NA', 'evidence': 'COL_C: 현재 그리드에 없음', 'tobe_ref': 'E2E'},
        {'row_id': 'T-6', 'source': 'TRACE', 'rule_id': 'H2', 'target': 'COL_D / D', 'result': 'NA', 'evidence': 'COL_D 현재 그리드에 없음', 'tobe_ref': 'E2E'},
        {'row_id': 'V-7', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'S1.COL_D (D)', 'result': 'PASS', 'evidence': '기존행 r0 COL_D 편집=false', 'tobe_ref': 'E2E @verify'},
        {'row_id': 'V-8', 'source': 'COLUMN', 'rule_id': 'E1', 'target': 'S1.One_X (x)', 'result': 'PASS', 'evidence': 'One_X 숫자 입력 정상', 'tobe_ref': 'E2E @verify'},
        {'row_id': 'V-9', 'source': 'COLUMN', 'rule_id': 'H2', 'target': 'S1.One_X (x)', 'result': 'NA', 'evidence': 'O 현재 그리드에 없음', 'tobe_ref': 'E2E'},
        {'row_id': 'V-10', 'source': 'COLUMN', 'rule_id': 'H2', 'target': 'W/H stock.DIVISION_ID (Div)', 'result': 'PASS', 'evidence': 'DIVISION_ID: 기존행 편집=false 표시 일치', 'tobe_ref': 'E2E'},
        {'row_id': 'V-11', 'source': 'COLUMN', 'rule_id': 'H13', 'target': 'W/H stock.LONG_TERM_QTY (Long)', 'result': 'NA', 'evidence': 'LONG_TERM_QTY 현재 그리드에 없음', 'tobe_ref': 'E2E'},
        {'row_id': 'V-12', 'source': 'COLUMN', 'rule_id': 'E2', 'target': 'S1.DT_X (d)', 'result': 'PASS', 'evidence': 'DT_X 신규행·기존행 모두 편집 불가(입력 경로 없음)', 'tobe_ref': 'E2E @verify'},
        {'row_id': 'V-13', 'source': 'COLUMN', 'rule_id': 'H2', 'target': 'S1.DT_X (d)', 'result': 'NA', 'evidence': 'DT_X 현재 그리드에 없음', 'tobe_ref': 'E2E'},
    ]
    n = apply(rows); by = {r['row_id']: r for r in rows}
    chk('A5 표시=Y 같은 시트 → ERROR', by['V-1']['result'] == 'ERROR' and by['V-1']['evidence'].startswith(TAG))
    chk('다른 시트는 그대로', by['V-2']['result'] == 'NA')
    chk('근거 실측 없으면 그대로', by['V-3']['result'] == 'NA')
    chk('A5 표시=N 이면 해당없음 유지', by['V-5']['result'] == 'NA')
    chk('시트 없는 TRACE 행 = 컬럼이 한 시트에만 있으면 그 시트의 다른 E2E 실측으로 ERROR', by['T-6']['result'] == 'ERROR')
    chk('소문자 섞인 컬럼(T649) = 다른 E2E 실측으로 ERROR', by['V-9']['result'] == 'ERROR')
    chk('바꾼 행 수 3', n == 3)
    r2 = [{'row_id': 'T-a', 'source': 'TRACE', 'rule_id': 'A5', 'target': 'ERP_SO_NO / SO No', 'result': 'NA', 'evidence': "ERP_SO_NO: 정답 미확정 (TO-BE 표시=Y)", 'tobe_ref': 'E2E @trace'},
          {'row_id': 'V-b', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'S9.ERP_SO_NO (SO No)', 'result': 'NA', 'evidence': '기존행 r0 ERP_SO_NO: 현재 그리드에 없음', 'tobe_ref': 'E2E'},
          {'row_id': 'V-c', 'source': 'ASIS', 'rule_id': 'D1', 'target': 'SOLD,SOLD', 'result': 'NA', 'evidence': "AS-IS 문장 'SOLD,SOLD' … — 기존행 r0 ERP_SO_NO: 현재 그리드에 없음", 'tobe_ref': 'E2E'}]
    r3 = [{'row_id': 'T-x', 'source': 'TRACE', 'rule_id': 'A5', 'target': 'QTY / Qty', 'result': 'PASS', 'evidence': 'QTY: … TO-BE 표시=Y', 'tobe_ref': 'E2E @trace', 'precond': json.dumps({'mctx': {'sheet': 'Plan'}})},
          {'row_id': 'V-p', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'Plan.QTY (Qty)', 'result': 'NA', 'evidence': 'QTY: 현재 그리드에 없음', 'tobe_ref': 'E2E'},
          {'row_id': 'V-q', 'source': 'COLUMN', 'rule_id': 'D1', 'target': 'Result.QTY (Qty)', 'result': 'NA', 'evidence': 'QTY: 현재 그리드에 없음', 'tobe_ref': 'E2E'}]
    chk('여러 시트 컬럼 = 측정 맥락 시트(mctx.sheet)로 그 시트 행만', apply(r3) == 1 and r3[1]['result'] == 'ERROR' and r3[2]['result'] == 'NA')
    r4 = [{'row_id': 'V-s', 'source': 'COLUMN', 'rule_id': 'H2', 'target': 'Result.AMT (Amt)', 'result': 'NA', 'evidence': 'AMT 현재 그리드에 없음', 'tobe_ref': 'E2E', 'precond': json.dumps({'mctx': {'sheet': 'Plan'}})},
          {'row_id': 'V-t', 'source': 'COLUMN', 'rule_id': 'H2', 'target': 'Plan.AMT2 (Amt)', 'result': 'NA', 'evidence': 'AMT2 현재 그리드에 없음', 'tobe_ref': 'E2E', 'precond': json.dumps({'mctx': {'sheet': 'Plan'}})}]
    chk('다른 시트에서 잰 그리드에 없음 = ERROR · 같은 시트에서 잰 것은 해당없음 유지', apply(r4) == 1 and r4[0]['result'] == 'ERROR' and r4[1]['result'] == 'NA')
    chk('A5 NA(정답 미확정)라도 TO-BE 표시=Y 는 근거 · 대상이 문장인 행은 근거 속 컬럼으로', apply(r2) == 2 and all(x['result'] == 'ERROR' for x in r2[1:]))
    chk("시트 이름 '/' (W/H stock) = 다른 컬럼과 섞지 않음", by['V-11']['result'] == 'NA' and key_of(by['V-11']) == ('whstock', 'LONG_TERM_QTY'))
    chk('입력 경로 없음 PASS 는 근거 아님', by['V-13']['result'] == 'NA')
    chk('두 번 적용해도 그대로', apply(rows) == 0)
    print('ALL PASS' if ok else 'SOME FAIL'); return 0 if ok else 1


if __name__ == '__main__':
    if '--selftest' in sys.argv:
        sys.exit(selftest())
    if len(sys.argv) > 1:
        csv.field_size_limit(10 ** 9)
        root = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', '..'))
        ids = [os.path.basename(os.path.dirname(f)) for f in sorted(glob.glob(os.path.join(root, 'Doc', 'verify', '*', 'verify_ledger.csv')))] if sys.argv[1].upper() == 'ALL' else [sys.argv[1].upper()]
        tot = 0
        for m in ids:
            rows = list(csv.DictReader(open(os.path.join(root, 'Doc', 'verify', m, 'verify_ledger.csv'), encoding='utf-8-sig')))
            n = apply(rows)
            if n:
                print(f'{m}: 해당없음 → 미검증 {n}행'); tot += n
        print(f'합계 {tot}행(파일 안 씀)')
