"""화면 검증 항목 원장 생성 — Doc/verify/<ID>/verify_ledger.csv

  python tools/Harness/verify/ledger.py <MENU_ID> [--asis <AS-IS ID>]

한 행 = (대상 × 조건 × 정답) 1건. 정답(oracle): O1 AS-IS 동작 / O2 확정 규칙 / O3 기능 무결성.
행 원천(source):
  RULE_SCREEN  화면 단위 공통 규칙(detect_rules.csv 중 화면 전체에 걸리는 것)
  SEARCH       조회조건 기준표(tools/Harness/rules/search_cond.csv, usage=USE) × 조건 유형별 규칙
  COLUMN       그리드 컬럼 메타(Doc/tobefacts/db/sheet_columns.csv) × 컬럼 유형별 규칙
  ASIS         AS-IS 액션(Doc/asisfacts/screens/<ID>/actions.csv) — 잠금·셀콤보·연쇄·메시지·팝업·검증·색 (AS-IS 라인 근거)
  DEFECT       결함 원장 정답지(Doc/verify/defects_classified.csv, 이 화면 + COMMON) — 사람이 찾은 오류의 재현 의무
  CONFIRMED    확정 규칙(tools/Harness/rules/confirmed_requirements.csv)
result 는 생성 시 NOT_RUN(미검증). 판정은 judge.py·E2E 결과 반입이 채운다 — 미검증을 PASS 로 두지 않는다.
"""
import argparse
import csv
import hashlib
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
HERE = os.path.dirname(os.path.abspath(__file__))
P = lambda *a: os.path.join(ROOT, *a)

COLS = ['row_id', 'source', 'family', 'rule_id', 'axis', 'area', 'target', 'condition', 'oracle', 'expected', 'asis_ref', 'method',
        'tobe_ref', 'result', 'evidence', 'fix_layer', 'fix_class', 'defect_ref', 'note']

# 축: 1 디자인·다국어 / 2 AS-IS 로직 / 3 SMOKE / 4 CRUD / 5 권한별 CRUD
AXIS_BY_FAMILY = {'A': '3', 'B': '3', 'C': '2', 'D': '4', 'E': '4', 'F': '4', 'G': '3', 'H': '1', 'I': '1', 'J': '5', 'K': '3', 'L': '3', 'M': '4', 'N': '2'}
# 화면 전체 단위로 항상 확인하는 규칙(요소별 행과 별개)
SCREEN_RULES = ['A1', 'A2', 'A4', 'A5', 'F1', 'F2', 'F4', 'F5', 'F6', 'G3', 'H4', 'H7', 'I1', 'I2', 'I3', 'I4', 'J1', 'J2', 'K1', 'K2', 'K3', 'E6', 'L1']  # E6 셀 키 입력(IME·자동완성) 2026-10-28 — 입력 그리드 없으면 E2E 가 NA
# 조회조건 유형별 규칙
SEARCH_COMBO_RULES = ['B1', 'B2', 'B3', 'B4', 'B6', 'B7', 'G1', 'G2', 'G4', 'G7', 'H5']  # G7 = 표시값 형식(combo_oracle) · B7 = 후보 갱신(b7_check + E2E) 2026-10-28
SEARCH_TEXT_RULES = ['G1', 'G2', 'G4', 'G5', 'H5']
SEARCH_CASCADE_PARENT = re.compile(r'^(div|division)$', re.I)  # 상위 조건(하위 리셋 대상) — 기준표 div_reset 열이 우선


def read_csv(path):
    if not os.path.exists(path):
        return []
    with open(path, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def rid(*parts):
    return 'V-' + hashlib.sha1('|'.join(parts).encode('utf-8')).hexdigest()[:8]


def col_from_args(value):
    """GetColumnIndex(DefColumns.X) 인자에서 컬럼명 목록"""
    return re.findall(r'DefColumns\.([A-Z0-9_]+)', value or '')


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('menu_id')
    ap.add_argument('--asis', default='')
    a = ap.parse_args()
    mid = a.menu_id.upper()
    asis_id = (a.asis or mid).upper()
    rules = {r['rule_id']: r for r in read_csv(os.path.join(HERE, 'detect_rules.csv'))}
    rows = []
    seen = set()

    def add(source, rule_id, target, condition='', expected='', asis_ref='', area='', oracle='', method='', defect_ref='', note='', family=''):
        r = rules.get(rule_id, {})
        fam = family or r.get('family', rule_id[:1])
        key = (source, rule_id, target, condition, asis_ref, defect_ref)
        if key in seen:
            return
        seen.add(key)
        rows.append({
            'row_id': rid(mid, *key), 'source': source, 'family': fam, 'rule_id': rule_id, 'axis': AXIS_BY_FAMILY.get(fam[:1], ''),
            'area': area, 'target': target, 'condition': condition, 'oracle': oracle or r.get('oracle', ''),
            'expected': expected or r.get('how', ''), 'asis_ref': asis_ref, 'method': method or r.get('method', ''),
            'tobe_ref': '', 'result': 'NOT_RUN', 'evidence': '', 'fix_layer': '', 'fix_class': '', 'defect_ref': defect_ref, 'note': note,
        })

    # 1) 화면 단위 규칙
    for rule_id in SCREEN_RULES:
        add('RULE_SCREEN', rule_id, f'{mid} 화면', area='화면')
    # F8 감사 필드 · F7 저장 연계 — 저장 SP 가 있는 화면(golden SAVE 케이스)만 1행씩 (2026-10-27 · save_audit.py 판정)
    if any(g.get('screen') == mid and g.get('kind') == 'SAVE' for g in read_csv(P('Doc', 'golden', 'golden_cases.csv'))):
        add('RULE_SCREEN', 'F8', f'{mid} 저장 감사 필드', condition='CRUD 실제 저장 1건', area='저장',
            expected='저장 행 CREATED_BY·LAST_UPDATED_BY = 저장 계정 · CREATION_DATE·LAST_UPDATE_DATE = 저장 시각', method='E2E+DB')
        add('RULE_SCREEN', 'F7', f'{mid} 저장 연계 테이블', condition='CRUD 실제 저장 1건', area='저장',
            expected='AS-IS 저장 SP 가 신규행 경로(MERGE/INSERT)로 쓰는 업무 테이블에 TO-BE 저장도 행을 남김', method='E2E+DB')

    # 1-b) 결과 정렬(A6) — AS-IS 가 정렬을 SQL(SP ORDER BY) 로 하는지 그리드/코드로 하는지(facts_sortrules.py → sort_rules.csv) · 조회 SP 마다 분기별 1행 (2026-10-26 사용자 지시)
    for s in read_csv(P('Doc', 'asisfacts', 'screens', asis_id, 'sort_rules.csv')):
        if s.get('kind') == 'SQL':
            if re.search(r'(?i)_(SAVE|SET|INS|UPD|DEL|CHK|CHECK)', s.get('sp', '')) or (s.get('depth') or '0') != '0':
                continue  # 저장류 SP · 서브쿼리(TOP) 정렬은 결과 순서 규칙이 아니다
            if s.get('keys'):
                add('SP', 'A6', s['sp'], condition=s.get('guard', ''), area='조회',
                    expected=f"결과 행 순서 = AS-IS ORDER BY [{s['keys']}]{(' (분기 ' + s['guard'][:80] + ')') if s.get('guard') else ''} — TO-BE PKG ORDER BY 동일(정적) + 조회 결과 행 순서 실측(E2E)",
                    asis_ref=f"{s['file']}:{s['line']} {s['note']}", method='STATIC+E2E')
            else:
                add('SP', 'A6', s['sp'], condition='ORDER BY 없음', area='조회', expected='AS-IS 결과 순서 미정(ORDER BY 없음) — TO-BE 도 임의 정렬을 추가하지 않았는지(추가했다면 의도 확인)',
                    asis_ref=f"{s['file']} {s['note']}", method='STATIC')
        elif s.get('kind') in ('GRID', 'CODE'):
            add('ASIS', 'A6', s['raw'][:60], condition='', area='그리드', expected=f"AS-IS 화면 코드 정렬({s['kind']}) 재현 — 키 [{s['keys']}]", asis_ref=f"{s['file']}:{s['line']}", method='E2E')

    # 1-c) 컬럼별 결과 값(A7) — golden 조회 케이스마다 1행 (2026-10-27 · tools/DbConn/golden.py 가 <sp>.cols.csv 로 컬럼 채움·같은 키 불일치 판정)
    for g in read_csv(P('Doc', 'golden', 'golden_cases.csv')):
        if g.get('screen') == mid and g.get('kind') == 'GET':
            add('SP', 'A7', g['asis_sp'], condition='컬럼별 결과 값', area='조회',
                expected='AS-IS 에 값이 있는 컬럼이 TO-BE 에서 전 행 공란이 아님(공란 컬럼 0) · 같은 키 행의 컬럼 값 일치',
                asis_ref=f"golden {g['case_id']} ↔ {g.get('tobe_proc', '')}", method='STATIC+DB')

    # 2) 조회조건 기준표 (SCP·SSP). 기준표에 화면이 없으면(DM 등) AS-IS 조회조건 패널 컨트롤로 대체 — 2-b
    sc = [r for r in read_csv(P('tools', 'Harness', 'rules', 'search_cond.csv')) if r.get('menu_id', '').upper() == mid and r.get('usage') == 'USE']
    if not sc:
        sdir0 = P('Doc', 'asisfacts', 'screens', asis_id)
        ctls = [c for c in read_csv(os.path.join(sdir0, 'controls.csv')) if c.get('variant') == 'current']
        parent = {c['name']: c['parent'] for c in ctls}
        panels = {c['name'] for c in ctls if c['type'].endswith('UsrConditionPanel')}

        def in_panel(n, depth=0):
            p_ = parent.get(n, '')
            return depth < 8 and (p_ in panels or (p_ in parent and in_panel(p_, depth + 1)))
        label = {}
        props = [x for x in read_csv(os.path.join(sdir0, 'props.csv')) if x.get('variant') == 'current']
        item_ctl = {x['target']: x['value'].replace('this.', '') for x in props if x['prop'] == 'Control'}
        for x in props:
            if x['prop'] == 'Text' and x['target'] in item_ctl:
                label[item_ctl[x['target']]] = x['value'].strip('"')
        seen_c = set()
        for c in ctls:
            t = c['type'].split('.')[-1]
            if c['name'] in seen_c or not in_panel(c['name']) or not re.match(r'Usr(Combo|CheckedList|MultiLineEditor|TextBox|DateTime|Date|Radio|CheckBox|Month|Period|Spin)', t):
                continue
            seen_c.add(c['name'])
            name = label.get(c['name']) or c['name']
            ref = f"AS-IS 조회조건 패널 {c['name']} ({t}) · {os.path.basename(c['file'])}:{c['line']} · 기준표 없음(DM) — 라벨은 AS-IS LayoutControlItem.Text"
            rules_ = SEARCH_COMBO_RULES if re.match(r'Usr(Combo|CheckedList)', t) else SEARCH_TEXT_RULES
            for rule_id in rules_:
                if rule_id == 'G4':
                    continue  # 순서·표시 기준표가 없으므로 G4 는 만들지 않는다(H5 라벨 비교만)
                add('SEARCH', rule_id, f'조회조건 {name}', expected=rules.get(rule_id, {}).get('how', ''), asis_ref=ref, area='조회조건')
            if SEARCH_CASCADE_PARENT.match(name or '') or re.search(r'division', c['name'], re.I):
                add('SEARCH', 'C1', f'조회조건 {name}', expected='값 변경 시 하위 조건 후보 재구성·선택값 ALL 초기화(AS-IS SelectedIndexChanged)', asis_ref=ref, area='조회조건')
                add('SEARCH', 'J1', f'조회조건 {name}', expected='계정 권한 Division 만 후보 · 단일 권한이면 자동 선택', asis_ref=ref, area='조회조건')
    for r in sc:
        name = r.get('tobe_name') or r.get('asis_name')
        typ = (r.get('tobe_type1') or r.get('asis_type1') or '')
        ref = f"search_cond.csv {r.get('src_file', '')}#{r.get('src_row', '')} · AS-IS '{r.get('asis_name', '')}'({r.get('asis_type1', '')}/{r.get('asis_type2', '')}) {r.get('asis_note', '')}"
        exp_base = f"순서 {r.get('tobe_order')} · {r.get('tobe_type1')}/{r.get('tobe_type2')} · 기본 {r.get('tobe_note') or r.get('asis_note')}"
        for rule_id in (SEARCH_COMBO_RULES if typ.startswith('선택') else SEARCH_TEXT_RULES):
            add('SEARCH', rule_id, f'조회조건 {name}', expected=f"{rules.get(rule_id, {}).get('how', '')} [{exp_base}]", asis_ref=ref, area='조회조건')
        if SEARCH_CASCADE_PARENT.match(name or '') or (r.get('div_reset') or '').upper() in ('Y', 'O'):
            add('SEARCH', 'C1', f'조회조건 {name}', expected='값 변경 시 하위 조건 후보 재구성·선택값 ALL 초기화(AS-IS SelectedIndexChanged)', asis_ref=ref, area='조회조건')
        if SEARCH_CASCADE_PARENT.match(name or ''):
            add('SEARCH', 'J1', f'조회조건 {name}', expected='계정 권한 Division 만 후보 · 단일 권한이면 자동 선택', asis_ref=ref, area='조회조건')

    # 3) 그리드 컬럼 — 기대값은 AS-IS 근거(facts_lockrules.py edit_expect.csv · facts_cellrules.py cell_rules.csv). TO-BE 메타는 '대상 목록'일 뿐 정답이 아니다
    sdir = P('Doc', 'asisfacts', 'screens', asis_id)
    ee = {r['column']: r for r in read_csv(os.path.join(sdir, 'edit_expect.csv'))}
    # 더블클릭 팝업으로만 입력하는 컬럼(AS-IS CellDoubleClick 의 'e.Column == GetColumnIndex(DefColumns.X)' 분기에서 팝업 호출) — 직접 편집 기대 아님
    popup_cols = {}
    for x in read_csv(os.path.join(sdir, 'actions.csv')):
        if x['kind'] == 'POPUP' and 'DoubleClick' in x['method']:
            for c in re.findall(r'e\.Column\s*==\s*\w+\.GetColumnIndex\(\s*DefColumns\.([A-Z0-9_]+)', x['guard']):
                popup_cols[c] = f"{os.path.basename(x['file'])}:{x['line']} {x['method']}"
    cr = {r['column']: r for r in read_csv(os.path.join(sdir, 'cell_rules.csv'))}
    cols = [r for r in read_csv(P('Doc', 'tobefacts', 'db', 'sheet_columns.csv')) if r.get('program_id', '').upper() == mid and r.get('valid_yn', 'Y') != 'N']
    # TO-BE 화면이 실제로 조회하는 시트만(대소문자 그대로) — 메타에는 'Production'/'production'/'production_40' 같은 잔존 변형 시트가 있다(2026-10-23 DMF0005 2,099행)
    used = set()
    for r in read_csv(P('Doc', 'tobefacts', 'screens', '_index.csv')):
        if r['menu_id'].upper() == mid and '/components/' not in r['page_key']:
            used |= set((r.get('dts_sheets') or '').split())
    if used and any(c['sheet_name'] in used for c in cols):
        cols = [c for c in cols if c['sheet_name'] in used]
    for c in cols:
        sheet, col = c['sheet_name'], c['column_name']
        t = f"{sheet}.{col} ({c.get('column_label_name', '')})"
        ctl = c.get('cell_control_object_type_code', '')
        itp = c.get('input_tp_cd', '')
        e = ee.get(col.upper(), {})
        rule = cr.get(col.upper(), {})
        tobe = f"TO-BE SHEET_COLUMNS {sheet}.{col} VISIBLE={c.get('visible_flag')} INPUT_TP_CD={itp or '-'} CELL={ctl or '-'}"
        if e.get('asis_visible') and e['asis_visible'] != c.get('visible_flag'):
            add('COLUMN', 'A5', t, expected=f"표시 여부 = AS-IS VISIBLE_FLAG '{e['asis_visible']}' (TO-BE '{c.get('visible_flag')}')", asis_ref=f"AS-IS SHEET_COLUMNS · {tobe}", area='그리드')
        if c.get('visible_flag') != 'Y':
            continue
        for cond, k, kc in (('신규행', 'new_row', 'new_row_cond'), ('기존행', 'existing_row', 'existing_cond')):
            if e and col.upper() in popup_cols and e[k] == 'Y':
                add('COLUMN', 'D1', t, condition=cond, expected=f"팝업 입력(직접 편집 차단·더블클릭 팝업) — AS-IS {popup_cols[col.upper()]}",
                    asis_ref=f"{e.get('ref', '')} · {popup_cols[col.upper()]} · {tobe}", area='그리드')
            elif e:
                want = {'Y': '편집 가능', 'N': '잠금(편집 불가)', 'COND': '조건부',
                        'UNKNOWN': '판정필요 — AS-IS 잠금 방식 미확정(변수 컬럼 잠금·Insert 방식 확인 필요)'}.get(e[k], e[k])
                exp = f"{want}{(' — ' + e[kc]) if e.get(kc) else ''}{(' ※' + e['ambiguous']) if e.get('ambiguous') else ''}"
                add('COLUMN', 'D1', t, condition=cond, expected=exp, asis_ref=f"{e.get('ref', '') or 'AS-IS 잠금 없음(편집 모드 기본 해제)'} · {tobe}", area='그리드',
                    note='판정필요: 범위 경계 동률' if e.get('ambiguous') else '')
            else:
                add('COLUMN', 'D1', t, condition=cond, expected='AS-IS 편집 기대 없음(AS-IS 컬럼 아님 또는 facts_lockrules 미실행) — TO-BE 신설 컬럼이면 확정 규칙으로 판정', asis_ref=tobe, area='그리드', note='판정필요')
        if 'Combo' in ctl or rule.get('cell_type') == 'COMBO':
            for rule_id in ('B1', 'B2', 'B3', 'B4', 'A2', 'E5'):
                add('COLUMN', rule_id, t, condition='신규행', asis_ref=tobe, area='그리드')
        # 에디터 유형(D5) — 정답 = AS-IS 셀 타입(cell_rules: SHEET_COLUMNS CELL·코드 컬럼·SetReNumerCellType). TO-BE 메타 콤보는 대상 목록일 뿐
        if rule.get('cell_type') in ('COMBO', 'NUMBER', 'DATE', 'DATETIME', 'CHECK'):
            add('COLUMN', 'D5', t, expected=f"에디터 = AS-IS {rule['cell_type']}" + (f" (소수 {rule.get('decimals') or 0}자리)" if rule['cell_type'] == 'NUMBER' else ''),
                asis_ref=f"{rule.get('ref')} · {tobe}", area='그리드')
        if rule.get('cell_type') == 'NUMBER':
            add('COLUMN', 'E1', t, expected=f"소수 {rule.get('decimals') or 0}자리 · 최소 {rule.get('min') or '-'} · 최대 {rule.get('max') or '-'} · 천단위 {rule.get('separator') or 'N'} — 규칙 밖 값 거부",
                asis_ref=f"{rule.get('ref')} · {tobe}", area='그리드')
            add('COLUMN', 'H8', t, expected=f"숫자 표시 = 천단위 {rule.get('separator') or 'N'} · 소수 {rule.get('decimals') or 0}자리", asis_ref=f"{rule.get('ref')} · {tobe}", area='그리드')
        elif re.search(r'Number|Num|Double|Int|Percent', ctl, re.I):
            add('COLUMN', 'E1', t, expected='AS-IS 숫자 규칙 없음 — TO-BE 숫자 컬럼, 확정 규칙으로 판정', asis_ref=tobe, area='그리드', note='판정필요')
        if rule.get('cell_type') in ('DATE', 'DATETIME'):
            add('COLUMN', 'E2', t, expected=f"{rule['cell_type']} 형식 · 존재하지 않는 날짜(예 2026-10-33) 거부", asis_ref=f"{rule.get('ref')} · {tobe}", area='그리드')
            # H8 날짜 표시(2026-10-28) — AS-IS DateTimeCellType.UserDefinedFormat: FPDate·FPDateText(AddDateColumn)=yyyy-MM-dd · FPDateTime(AddDateTimeColumn)=yyyy-MM-dd HH:mm:ss (SpreadInfo.cs:4105-4135)
            dfmt = 'yyyy-MM-dd HH:mm:ss' if rule['cell_type'] == 'DATETIME' else 'yyyy-MM-dd'
            add('COLUMN', 'H8', t, expected=f"날짜 표시 = {dfmt}", asis_ref=f"{rule.get('ref')} · SpreadInfo.cs:4105-4135 · {tobe}", area='그리드')
        add('COLUMN', 'H2', t, expected='편집 가능=노랑 / 입력불가=흰색 (표준 3색)', asis_ref=tobe, area='그리드')

    # 3-b) H1 가로 정렬 — AS-IS 그리드 컬럼(메타·코드 FPHAlign) 전 컬럼 (2026-10-27 · align_check.py 가 판정)
    for c in read_csv(P('Doc', 'asisfacts', 'screens', mid, 'grid_columns_asis.csv')):
        if not (c.get('halign') or '').strip():
            continue
        add('COLUMN', 'H1', f"{c['sheet']}.{c['column']} ({c.get('label', '')})", condition='',
            expected=f"가로 정렬 = AS-IS {c['halign']}", asis_ref=c.get('ref', ''), area='그리드' if c.get('source') == 'META' else '팝업')

    # 4) AS-IS 액션 — 현행(current)·공유(shared) 파일만(legacy 사본 제외)
    cur_files = {f['file'] for f in read_csv(P('Doc', 'asisfacts', 'screens', asis_id, 'files.csv')) if f.get('variant') in ('current', 'shared')}
    acts = [x for x in read_csv(P('Doc', 'asisfacts', 'screens', asis_id, 'actions.csv')) if not cur_files or x['file'] in cur_files]
    for x in acts:
        k, m, line, cls = x['kind'], x['method'], x['line'], x['class']
        loc = f"{os.path.basename(x['file'])}:{line} {cls}.{m}"
        guard = x.get('guard', '')
        val, tgt = x.get('value', ''), x.get('target', '')
        cnames = col_from_args(val)
        popup_cls = 'Popup' in cls
        area = '팝업' if popup_cls else '그리드'
        if k == 'GRID_LOCK':
            rule_id = 'D4' if m == 'InsertButton' else ('D3' if re.search(r'\bif\b|for \(', guard) else 'D1')
            add('ASIS', rule_id, ','.join(cnames) or tgt, condition=guard[:600], expected=f"{tgt}{val[:160]} 와 같은 잠금", asis_ref=loc, area=area)
        elif k == 'GRID_COMBO':
            rule_id = 'D4' if m == 'InsertButton' else 'C2'
            add('ASIS', rule_id, ','.join(cnames) or tgt, condition=guard[:600], expected=f"셀 콤보 후보 = AS-IS {val[:160]}", asis_ref=loc, area=area)
            if 'Clipboard' in m:
                add('ASIS', 'F3', ','.join(cnames) or tgt, condition=guard[:600], expected='붙여넣기 입력에도 같은 콤보·연쇄 적용', asis_ref=loc, area=area)
        elif k == 'GRID_SET' and re.search(r'ComboSel|Changed|Clipboard|SetCityCode|EditChange', m):
            add('ASIS', 'C3', ','.join(cnames) or tgt, condition=guard[:600], expected=f"연쇄 자동 채움 {tgt}{val[:160]}", asis_ref=loc, area=area)
            # 연쇄는 '값 변경' 때만 — 원천 편집기를 열었다 그냥 닫아도 대상이 초기화되면 결함(2026-10-23 SCP0007 From Site Esc → To Site 공란 실측)
            add('ASIS', 'C6', ','.join(cnames) or tgt, condition=guard[:600], expected='원천 셀을 값 변경 없이 편집 종료(Esc·Tab)하면 대상 셀 값 유지', asis_ref=loc, area=area)
        elif k == 'GRID_SET' and m == 'InsertButton':
            add('ASIS', 'D4', ','.join(cnames) or tgt, condition=guard[:600], expected=f"신규행 기본값 {val[:160]}", asis_ref=loc, area=area)
        elif k == 'MESSAGE':
            msg = (re.findall(r'MSG\d{5}', val) or ['(동적 메시지)'])[0]
            rule_id = 'D4' if m == 'InsertButton' else ('E4' if 'Save' in m else 'G1' if 'Find' in m else 'E4')
            add('ASIS', rule_id, msg, condition=guard[:600], expected=f"조건 충족 시 {msg} 와 같은 의미 메시지·처리 중단 {val[:120]}", asis_ref=loc, area='메시지')
        elif k == 'POPUP' and re.search(r'Popup|Form_Load|ShowDialog', tgt + val) and 'ProgressForm' not in tgt and 'prg.' not in tgt:
            add('ASIS', 'G5', tgt + val[:80], condition=guard[:600], expected=f"팝업 인자 = {val[:160]} (출처 셀/컨트롤 값 그대로 전달, 결과가 인자로 필터)", asis_ref=loc, area='팝업')
            add('ASIS', 'H6', tgt + val[:80], condition=guard[:600], expected='팝업 표준(확정 규칙 CR-005·C8): 버튼 순서 OK → CLOSE · 그리드 No. 컬럼 · 데이터 건수 표시', asis_ref=loc, area='팝업')
        elif k == 'VALIDATE':
            rule_id = 'E3' if 'Required' in tgt else ('J1' if 'Auth' in tgt else 'E4')
            add('ASIS', rule_id, tgt, condition=guard[:600], expected=f"{tgt}{val[:120]} 와 같은 검증", asis_ref=loc, area='검증')
        elif k == 'GRID_STYLE':
            add('ASIS', 'H2', ','.join(cnames) or tgt, condition=guard[:600], expected=f"{tgt}{val[:160]} 와 같은 색 규칙", asis_ref=loc, area=area)

    # 4-a) 저장 전 필수 검증(E3) — AS-IS checkRequiredOfSpread 가 있거나 필수 표시('*') 컬럼이 있으면, 필수 공란 저장 시도는 저장 요청 전에 막혀야 한다
    req_cols = [c['column_name'] for c in cols if c.get('visible_flag') == 'Y' and (c.get('column_label_name', '').endswith('*') or c.get('input_tp_cd') in ('M', 'IM'))]
    req_src = [x for x in acts if x['kind'] == 'VALIDATE' and 'Required' in x['target'] and 'Spread' in x['target']]
    if req_cols or req_src:
        add('RULE_SCREEN', 'E3', f'{mid} 신규행 필수 공란 저장', condition='조회 후 Insert → 필수 컬럼 공란 → Save',
            expected=f"저장 요청 전에 차단 + 필수 메시지 (필수 컬럼 {len(req_cols)}개: {','.join(req_cols[:12])})",
            asis_ref=('; '.join(f"{os.path.basename(x['file'])}:{x['line']} {x['method']} {x['target']}" for x in req_src[:3]) or 'TO-BE 필수 표시 컬럼(라벨 *·INPUT_TP_CD M/IM)'), area='저장')

    # 4-b) 진입 버튼 전제조건 — 버튼 핸들러 분기가 참조하는 화면 필드를 '조회 메서드에서만' 세팅하면 조회 전 실행 시 AS-IS 는 그 분기를 타지 않는다
    #      (예 SCP0007 InsertButton: strSel_InputStatus 는 FindData_Main:540 에서만 세팅 → 조회 전 Insert 무동작). 일반 규칙 — 화면 무관
    assign = {}
    for x in acts:
        if x['kind'] in ('FLAG', 'LOCAL') and re.fullmatch(r'[A-Za-z_]\w*', x['target'] or ''):
            assign.setdefault(x['target'], set()).add(x['method'])
    for x in acts:
        if x['kind'] != 'BRANCH' or not re.search(r'(Insert|Delete|Save|Edit)Button', x['method']) or x['guard']:
            continue  # 핸들러 최상위 분기만(중첩 분기는 상위 전제의 하위)
        for var in re.findall(r'\b([A-Za-z_]\w*)\b', x['target']):
            ms = assign.get(var)
            if ms and all(re.search(r'^Find|Search', m) for m in ms):
                add('ASIS', 'D4', f"{x['method']} 전제 {var}", condition='조회 전 실행',
                    expected=f"{var} 는 조회({','.join(sorted(ms))})에서만 세팅 → 조회 전 {x['method']} 는 분기 '{x['target']}' 불충족 = AS-IS 무동작(행 추가·처리 없음)",
                    asis_ref=f"{os.path.basename(x['file'])}:{x['line']} {x['method']} · 세팅 위치 {','.join(sorted(ms))}", area='버튼')

    # 5) 결함 원장 (이 화면 + COMMON) — 분류가 있으면 규칙별로, 없으면 미분류 1행
    cls_rows = {(r['src'], r['no']): r for r in read_csv(P('Doc', 'verify', 'defects_classified.csv'))}
    for d in read_csv(P('Doc', 'verify', 'defects_baseline.csv')):
        if d['menu_id'] not in (mid, 'COMMON'):
            continue
        c = cls_rows.get((d['src'], d['no']), {})
        ref = f"{d['src']}-{d['no']}"
        exp = c.get('expected') or d['test_result'][:300]
        rids = [x for x in (c.get('rule_ids') or '').split(';') if x.strip()] or ['UNCLASSIFIED']
        for rule_id in rids:
            rule_id = rule_id.strip()
            add('DEFECT', rule_id, c.get('target') or d['test_content'][:80], condition=c.get('condition') or d['div'], expected=exp,
                asis_ref=f"결함원장 {ref} ({d['ui_name']}) 조치={'미조치' if d['open'] == 'Y' else '완료'}", area='결함원장',
                oracle=c.get('oracle', ''), method=c.get('method', ''), defect_ref=ref, family=(c.get('family') or '')[:1] if rule_id.startswith('NEW') or rule_id == 'UNCLASSIFIED' else '')

    # 5-b) 결함 일반화 (다른 화면 결함 · 2026-10-27 사용자: "단위테스트 두 시트의 오류가 이 화면에 같은 형태로 있으면 찾아야 한다")
    #   5) 는 이 화면 + COMMON 결함만 넣어 다른 화면 결함 274건이 이 화면 검증에 대입되지 않았다(SCP0007 실측 36/310).
    #   분류에서 일반 규칙(general_rule=Y)으로 정리된 결함은 모든 화면에 'GENERAL' 행으로 넣고, 같은 규칙의 실측을 상속한다.
    #   규칙 대상 요소가 이 화면에 없으면 judge 가 NA(근거 포함)로, 검사기가 없으면 판정필요(W4)로 남긴다 — PASS 로 지나가지 않는다.
    for d in read_csv(P('Doc', 'verify', 'defects_baseline.csv')):
        if d['menu_id'] in (mid, 'COMMON'):
            continue
        c = cls_rows.get((d['src'], d['no']), {})
        # 화면 고유 결함(general_rule=N)도 오류 '유형'(규칙)은 같다 — 같은 규칙으로 이 화면의 같은 형태 오류를 찾는다(사용자 10-27: 두 시트 전 오류)
        gen = (c.get('general_rule') or '').strip().upper() == 'Y'
        ref = f"{d['src']}-{d['no']}"
        rule_txt = (c.get('general_rule_text') or '').strip() if gen else ''
        for rule_id in [x.strip() for x in (c.get('rule_ids') or '').split(';') if x.strip()]:
            add('GENERAL', rule_id, f"[{d['menu_id']} 결함 {'일반화' if gen else '유형'}] " + (c.get('target') or d['test_content'][:60]),
                condition=(c.get('condition') or '') + ('' if gen else ' (원 결함은 화면 고유 대상 — 같은 규칙의 이 화면 요소로 확인)'), expected=rule_txt or (c.get('expected') or '')[:300],
                asis_ref=f"결함원장 {ref} ({d['menu_id']} {d['ui_name']}) — 이 화면에 같은 형태의 오류가 있는지", area='결함일반화',
                oracle=c.get('oracle', ''), method=c.get('method', ''), defect_ref=ref)

    # 6) 확정 규칙 (전 화면)
    for r in read_csv(P('tools', 'Harness', 'rules', 'confirmed_requirements.csv')):
        scope = (r.get('scope') or 'ALL').upper()
        if scope not in ('ALL', mid):
            continue
        add('CONFIRMED', r.get('rule_id', 'O2'), r.get('target', ''), condition=r.get('condition', ''), expected=r.get('requirement', ''),
            asis_ref=f"확정규칙 {r.get('req_id', '')} (출처 {r.get('origin', '')})", area='확정규칙', oracle='O2', method=r.get('method', ''))

    out_dir = P('Doc', 'verify', mid)
    os.makedirs(out_dir, exist_ok=True)
    out = os.path.join(out_dir, 'verify_ledger.csv')
    # 보존 = 사람이 직접 적은 판정만(tobe_ref 가 '수동' 으로 시작) + 사람 지정 보완 계층(fix_layer·fix_class).
    #   자동 판정(E2E·META·STATIC·상속)은 매 실행 다시 계산한다 — 이전 실행 값이 남아 '낡은 PASS/FAIL' 이 되지 않게(2026-10-23 실측: 상속 판정 0건 갱신 사고)
    prev = {r['row_id']: r for r in read_csv(out)}
    for r in rows:
        p = prev.get(r['row_id'])
        if not p:
            continue
        if (p.get('tobe_ref') or '').startswith('수동'):
            for k in ('result', 'evidence', 'tobe_ref'):
                r[k] = p.get(k, '')
        for k in ('fix_layer', 'fix_class'):
            if p.get(k):
                r[k] = p[k]
    with open(out, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(rows)
    by = {}
    for r in rows:
        by[r['source']] = by.get(r['source'], 0) + 1
    print(f'{mid}: {len(rows)}행 → {out}')
    print('  ' + ' · '.join(f'{k} {v}' for k, v in by.items()))
    if not acts:
        print(f'  [WARN] AS-IS actions.csv 없음: Doc/asisfacts/screens/{asis_id}/ — ASIS 행 0 (AS-IS 파싱 선행 필요)')
    return 0


if __name__ == '__main__':
    sys.exit(main())
