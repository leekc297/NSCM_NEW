#!/usr/bin/env python3
"""expect_rows — 화면별 기대 행 = 손 행(Doc/verify/<name>) ∪ 자동 행(Doc/verify/<ID>/auto_expect/<name>) (W8-2, 2026-11-04)

  사용자 지시(2026-11-04): 새 화면에도 GAP 분석·단위테스트에서 나온 유형의 결함이 검출되도록 손 기대 파일 12종을 화면 사실로 자동 생성한다.
  - 손 행이 우선한다. 같은 패턴 키(key_of)의 자동 행은 버린다(중복 측정 방지).
  - 자동 행은 손 행과 같은 열 + pattern_id · basis · key 를 가진다. 소비자(ledger.py · _verify.spec.ts)는 이 모듈(또는 TS 동형 함수)로만 읽는다.
  - key_of 는 손 행·자동 행 공통 — 재현율 측정(gen_expect_recall.py)도 같은 함수를 쓴다.
"""
import csv
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
V = os.path.join(ROOT, 'Doc', 'verify')

# 손 기대 파일 12종(2026-11-04 13:5x 실측 목록) — 생성기 대상 전체
EXPECT_FILES = ['scenario_expect.csv', 'doc_ui_expect.csv', 'source_expect.csv', 'text_expect.csv', 'sum_toggle_expect.csv',
                'num_format_expect.csv', 'period_color_expect.csv', 'zero_display_expect.csv', 'removed_buttons.csv',
                'cond_equiv_expect.csv', 'display_sort_expect.csv', 'excel_form_expect.csv']
AUTO_COLS = ['pattern_id', 'basis', 'key']


def read_csv(path):
    if not os.path.exists(path):
        return [], []
    with open(path, encoding='utf-8-sig', newline='') as f:
        rd = csv.DictReader(f)
        return list(rd), list(rd.fieldnames or [])


def hand_rows(name, mid):
    rows, _ = read_csv(os.path.join(V, name))
    return [dict(r, _origin='hand') for r in rows if r.get('menu_id') == mid]


def auto_path(name, mid):
    return os.path.join(V, mid, 'auto_expect', name)


def auto_rows(name, mid, full=False):
    """full=True → 손 행 중복 제거 전 전체(_all · 재현율 측정용)"""
    p = os.path.join(V, mid, 'auto_expect', '_all', name) if full else auto_path(name, mid)
    rows, _ = read_csv(p)
    return [dict(r, _origin='auto') for r in rows if r.get('menu_id') == mid]


def load(name, mid, with_auto=True):
    """손 행 + (손 행과 키가 겹치지 않는) 자동 행"""
    h = hand_rows(name, mid)
    if not with_auto:
        return h
    hk = set()
    for r in h:
        hk |= keys_of(name, r)
    out = list(h)
    for r in auto_rows(name, mid):
        ks = {x.strip() for x in (r.get('key') or '').split(' + ') if x.strip()}
        if ks and ks <= hk:  # 자동 행의 키가 전부 손 행에 있으면 버린다
            continue
        out.append(r)
    return out


# ── 패턴 키 ───────────────────────────────────────────────────────────────
def _steps(s):
    out = []
    for x in (s or '').split(';'):
        x = x.strip()
        if not x:
            continue
        i = x.find(':')
        out.append((x if i < 0 else x[:i], '' if i < 0 else x[i + 1:]))
    return out


def _col(a):
    """단계 인자의 첫 칸 이름(=~!*@| 앞) — 대문자"""
    return re.split(r'[=~!*@|]', a, 1)[0].strip().upper()


def _norm_label(t):
    return re.sub(r'[\s*:.()（）]+', '', t or '').lower()


DEC_RE = re.compile(r'^-?\d*\.\d+$')


def scenario_keys(r):
    st = _steps(r.get('steps', ''))
    kinds = [k for k, _ in st]
    ks = set()
    langs = [a.upper() for k, a in st if k == 'lang']
    if 'KO' in langs and 'save' in kinds:
        ks.add('I1|lang-ko-save')
    if 'CN' in langs and 'pagetext' in kinds:
        ks.add('I1|lang-cn-count')
    if 'noload' in kinds:
        ks.add('H10|noload')
    if 'formdl' in kinds:
        ks.add('M1|formdl')
    if 'insertat' in kinds:
        ks.add('D6|insertat')
    if 'delrow' in kinds and any(k == 'savehas' and 'D' in a for k, a in st):
        ks.add('F1|delete-D')
    for k, a in st:
        if k == 'gridcands':
            ks.add(f'C1|gridcands|{_col(a)}')
        elif k == 'paste':
            v = a.split('=', 1)[1] if '=' in a else ''
            ks.add(f"F3|{'paste-reject' if v.startswith('ZZ_') else 'paste'}|{_col(a)}")
        elif k == 'iscombo':
            ks.add(f'B1|iscombo|{_norm_label(a)}')
        elif k == 'rail':
            ks.add('H2|rail')
        elif k == 'nomsgre' and re.search(r'필수|required|mandatory', a, re.I):
            ks.add('E4|req-fp')
    types = [(k, a) for k, a in st if k == 'type']
    if any(k == 'savehas' for k, _ in st):
        for _, a in types:
            v = a.split('=', 1)[1].split('@', 1)[0] if '=' in a else ''
            if DEC_RE.match(v):
                ks.add(f'F6|decimal|{_col(a)}')
    cells_blank = [_col(a.split(',', 1)[1]) for k, a in st if k == 'cell' and ',' in a and re.search(r'=$', a)]
    if types and cells_blank and r.get('msg_re'):
        for t in cells_blank:
            ks.add(f'C3|clear|{_col(types[0][1])}>{t}')
    if 'insert' in kinds and 'save' in kinds and not types and (r.get('no_save') == 'Y') and r.get('msg_re') and not any(k == 'cond' and '@pop' in a for k, a in st[kinds.index('insert'):]):
        ks.add('E3|blank-save')
    if 'insert' in kinds and r.get('msg_re'):
        after = st[kinds.index('insert') + 1:]
        if after and after[-1][0] == 'cond':
            ks.add(f"C4|dirty|{_norm_label(after[-1][1].split('=', 1)[0])}")
        elif after and after[-1][0] == 'btn':
            ks.add(f'H10|dirty|{_norm_label(after[-1][1])}')
    # 2026-11-04 W8-2 추가 패턴 키
    for _, a in types:
        v = a.split('=', 1)[1].split('@', 1)[0] if '=' in a else ''
        if v == '20241399':
            ks.add(f'E2|baddate|{_col(a)}')
        if v == '@cand:1' and any(k == 'cell' and a2.split(',', 1)[-1].upper().startswith(_col(a) + '=~') for k, a2 in st) and 'paste' not in kinds:
            ks.add(f'F3|type-cand|{_col(a)}')
    sh = [a for k, a in st if k == 'savehas']
    if any(re.search(r'\bM$', a) for a in sh) and any(re.search(r'\bI$', a) for a in sh):
        ks.add('F2|mod-ins')
    if any(k == 'type' and a.startswith('@DYNVAL=') for k, a in st) and any(k == 'cell' and '@LAST' in a for k, a in st):
        ks.add('D2|dynval-edit')
    cells_tilde = [a for k, a in st if k == 'cell' and '=~' in a]
    if (r.get('rule') == 'C3') and types and cells_tilde and not r.get('msg_re') and '@' in types[0][1]:
        ks.add(f'C3|clear-ok|{_col(types[0][1])}')
    for k, a in st:
        if k == 'popcell' and any(k2 == 'cell' and '=~' in a2 for k2, a2 in st):
            ks.add(f'C3|popfill|{_col(a)}')
        if k == 'samekey':
            ks.add(f'F3|samekey|{_col(a)}')
    conds = [a.split('=', 1)[0] for k, a in st if k == 'cond']
    srch = kinds.count('search') + kinds.count('search0')  # 0행 허용 조회도 조회(2026-11-04 P30)
    if srch >= 2:
        # 라벨 별칭: 'Div'(손 행 관례) = 'Division'(화면 라벨) — 같은 조회조건(2026-11-04 DMF0021 K2 키 불일치)
        alias = lambda s: 'div' if _norm_label(s) in ('div', 'division') else _norm_label(s)
        labs = [alias(x) for x in conds]
        for lab in set(labs):
            if labs.count(lab) >= 2:
                # 전환 뒤 칸 노출(colvis) 확인까지 하는 행은 SQL 오류만 보는 전환 행보다 넓다 → 다른 키(재현으로 세지 않음)
                ks.add(f"F4|toggle|{lab}{'|colvis' if 'colvis' in kinds else ''}")
    return ks


def keys_of(name, r):
    if r.get('key'):
        return {x.strip() for x in r['key'].split(' + ') if x.strip()}
    if name == 'scenario_expect.csv':
        return scenario_keys(r)
    if name == 'num_format_expect.csv':
        return {f"A2|numfmt|{(r.get('column_re') or '').upper()}"}
    if name == 'zero_display_expect.csv':
        return {f"H8|zero|{(r.get('column_re') or '').upper()}"}
    if name == 'period_color_expect.csv':
        return {f"H2|period|{r.get('mode', '')}"}
    if name == 'sum_toggle_expect.csv':
        return {f"G7|sum|{_norm_label(r.get('label', ''))}"}
    if name == 'doc_ui_expect.csv':
        return {f"K4|docui|{r.get('kind', '')}|{_norm_label(r.get('name', ''))}"}
    if name == 'text_expect.csv':
        return {f"A6|text|{_norm_label(r.get('name', ''))}"}
    if name == 'removed_buttons.csv':
        return {f"K4|removed|{_norm_label(r.get('button', ''))}"}
    if name == 'cond_equiv_expect.csv':
        return {f"G1|condequiv|{_norm_label(r.get('label', ''))}"}
    if name == 'display_sort_expect.csv':
        return {f"G3|dispsort|{_norm_label(r.get('label', ''))}"}
    if name == 'excel_form_expect.csv':
        return {'M1|form2row'}
    if name == 'source_expect.csv':
        return {f"SRC|{r.get('pkg', '')}|{r.get('mode', '')}|{r.get('regex', '')[:40]}"}
    return set()
