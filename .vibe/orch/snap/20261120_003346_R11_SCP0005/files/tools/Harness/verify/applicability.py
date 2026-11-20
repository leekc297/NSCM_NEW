# -*- coding: utf-8 -*-
"""GENERAL(타 화면 결함 일반화)·DEFECT·CONFIRMED·RULE_SCREEN 행의 '이 화면 적용 여부'(2026-11-06 플랜 1-4)

  python tools/Harness/verify/applicability.py <ID> [--asis <AS-IS ID>]   # dry-run: 기능 탐지 결과 + 현재 원장 행의 applicable 분포(원장은 쓰지 않음)

판정 원천 = 디스크의 화면 사실만(추측 없음 · 사실이 없으면 UNKNOWN):
  Doc/e2e/specs/<ID>.plan.json(buttons·fields·mainSheets·popupSheets·hasSave·accounts·menuBtnCodes·dynamicHeader)
  Doc/tobefacts/db/sheet_columns.csv(program_id=ID: input_tp_cd·cell_control_object_type_code) · proc_meta.csv(저장 배선) · btn_auth.csv(버튼 코드)
  Doc/asisfacts/screens/<AS-IS>/actions.csv(TitleSet|btnColumn · POPUP · Merge) · cell_clear.csv · tools/Harness/rules/search_cond.csv(menu_id=ID usage=USE)
규칙 → 기능 = tools/Harness/rules/rule_applicability.csv (feature 는 '|' 로 any-of). 표에 없는 규칙 = UNKNOWN('규칙→기능표 미등록').
결과 열: applicable ∈ {Y, N, UNKNOWN} · applicable_why(근거: 파일·값). judge.py 는 N 행을 NA '대상 없음(근거: …)' 로 두고 상속·스윕에서 제외한다.
"""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
TABLE = P('tools', 'Harness', 'rules', 'rule_applicability.csv')
SOURCES = ('GENERAL', 'DEFECT', 'CONFIRMED', 'RULE_SCREEN')
csv.field_size_limit(10 ** 8)


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def _plan(mid):
    p = P('Doc', 'e2e', 'specs', f'{mid}.plan.json')
    try:
        with open(p, encoding='utf-8') as f:
            return json.load(f), os.path.relpath(p, ROOT)
    except (OSError, ValueError):
        return None, os.path.relpath(p, ROOT)


def screen_facts(mid, asis_id=''):
    """기능 → (판정 True/False/None, 근거 문자열). None = 사실 파일 없음(UNKNOWN)."""
    mid = mid.upper(); asis_id = (asis_id or mid).upper()
    F = {}
    plan, pp = _plan(mid)
    cols = [c for c in rd(P('Doc', 'tobefacts', 'db', 'sheet_columns.csv')) if (c.get('program_id') or '').upper() == mid]
    sc = [s for s in rd(P('tools', 'Harness', 'rules', 'search_cond.csv')) if (s.get('menu_id') or '').upper() == mid]
    sc_use = [s for s in sc if (s.get('usage') or '').upper() == 'USE']
    acts = rd(P('Doc', 'asisfacts', 'screens', asis_id, 'actions.csv'))
    clr = rd(P('Doc', 'asisfacts', 'screens', asis_id, 'cell_clear.csv'))
    pm = [r for r in rd(P('Doc', 'tobefacts', 'db', 'proc_meta.csv')) if (r.get('menu_id') or '').upper() == mid and (r.get('use_yn') or 'Y') != 'N']
    ba = {(r.get('mnu_btn_cd') or '').upper() for r in rd(P('Doc', 'tobefacts', 'db', 'btn_auth.csv')) if (r.get('mnu_id') or '').upper() == mid and (r.get('use_yn') or 'Y') != 'N'}
    btn_codes = set(ba) | {str(b).upper() for b in ((plan or {}).get('menuBtnCodes') or [])}
    btn_labels = [str(b.get('label') or b.get('key') or '') for b in ((plan or {}).get('buttons') or [])]
    main = (plan or {}).get('mainSheets') or []
    F['ALWAYS'] = (True, '항상 적용')
    F['GRID'] = ((len(cols) > 0 or len(main) > 0) if (cols or plan) else None, f"sheet_columns {len(cols)}행 · plan.mainSheets {len(main)}")
    F['MULTI_GRID'] = ((len(main) >= 2) if plan else None, f"plan.mainSheets {len(main)}개 {[m.get('name') for m in main][:3]}")
    edit = [c for c in cols if (c.get('input_tp_cd') or '').upper() in ('O', 'M', 'IO', 'IM')]
    F['EDITABLE_COLUMN'] = ((len(edit) > 0) if cols else None, f"sheet_columns input_tp_cd∈O/M/IO/IM {len(edit)}/{len(cols)}열")
    combo_cell = [c for c in cols if re.search(r'Combo', c.get('cell_control_object_type_code') or '', re.I)]
    F['COMBO_CELL'] = ((len(combo_cell) > 0) if cols else None, f"sheet_columns 셀 콤보(FPComboBox) {len(combo_cell)}열")
    popup_cell = [c for c in cols if re.search(r'Modal|Popup', c.get('cell_control_object_type_code') or '', re.I)]
    F['POPUP_CELL'] = ((len(popup_cell) > 0) if cols else None, f"sheet_columns 셀 팝업(FPTextModal) {len(popup_cell)}열")
    date_edit = [c for c in edit if re.search(r'Date', c.get('cell_control_object_type_code') or '', re.I) or re.search(r'DATE|YYYYMMDD|_DT$|_YMD', (c.get('column_name') or '').upper())]
    F['DATE_EDIT'] = ((len(date_edit) > 0) if cols else None, f"편집 가능 날짜 컬럼 {len(date_edit)}열 {[c['column_name'] for c in date_edit][:3]}")
    has_save = bool((plan or {}).get('hasSave')) or any(r.get('proc') and re.search(r'SAVE|INS|UPD|DEL', r.get('btn') or '', re.I) for r in pm)
    F['SAVE'] = (has_save if (plan or pm) else None, f"plan.hasSave={(plan or {}).get('hasSave')} · proc_meta 저장 배선 {sum(1 for r in pm if r.get('proc') and re.search(r'SAVE|INS|UPD|DEL', r.get('btn') or '', re.I))}건")
    F['INSERT'] = ((('INSERT' in btn_codes) or any(re.search(r'insert|추가', b, re.I) for b in btn_labels)) if (plan or ba) else None, f"버튼 코드 {sorted(btn_codes)[:8]} · plan.buttons {btn_labels[:5]}")
    F['EXCEL'] = ((any(re.search(r'EXCEL|UPLOAD|DOWNLOAD|FORM', b) for b in btn_codes) or any(re.search(r'excel|upload|download', b, re.I) for b in btn_labels)) if (plan or ba) else None, f"버튼 코드 {sorted(btn_codes)[:8]} · plan.buttons {btn_labels[:5]}")
    F['SEARCH_AREA'] = ((len(sc_use) > 0) if sc else None, f"search_cond USE {len(sc_use)}/{len(sc)}행")
    sel = [s for s in sc_use if (s.get('tobe_type1') or '') == '선택']
    F['COMBO_COND'] = ((len(sel) > 0) if sc else None, f"search_cond USE 선택형 {len(sel)}행 {[s.get('tobe_name') for s in sel][:5]}")
    txt = [s for s in sc_use if (s.get('tobe_type1') or '') == '텍스트']
    F['TEXT_COND'] = ((len(txt) > 0) if sc else None, f"search_cond USE 텍스트형 {len(txt)}행 {[s.get('tobe_name') for s in txt][:5]}")
    pop = [s for s in sc_use if (s.get('asis_popup_name') or '').strip() or (s.get('tobe_popup_name') or '').strip()]
    F['POPUP_COND'] = ((len(pop) > 0) if sc else None, f"search_cond 팝업 연결 조건 {len(pop)}행 {[s.get('tobe_name') for s in pop][:4]}")
    pop_acts = [a for a in acts if (a.get('kind') or '') == 'POPUP']
    popup_sheets = (plan or {}).get('popupSheets') or []
    F['POPUP'] = ((len(popup_sheets) > 0 or len(pop_acts) > 0 or len(pop) > 0 or len(popup_cell) > 0) if (plan or acts or sc) else None,
                  f"plan.popupSheets {len(popup_sheets)} · AS-IS POPUP 액션 {len(pop_acts)} · 팝업 조건 {len(pop)} · 셀 팝업 {len(popup_cell)}")
    ts = [a for a in acts if re.search(r'TitleSet|btnColumn', (a.get('raw') or '') + (a.get('target') or ''))]
    F['COLUMN_SETTING'] = ((len(ts) > 0) if acts else None, f"actions.csv TitleSet|btnColumn {len(ts)}건")
    mg = [a for a in acts if re.search(r'FPMerge|\bMerge', a.get('raw') or '')]
    F['MERGE'] = ((len(mg) > 0) if acts else None, f"actions.csv Merge/FPMerge {len(mg)}건")
    F['MULTI_ACCOUNT'] = ((len((plan or {}).get('accounts') or []) >= 2) if plan else None, f"plan.accounts {len((plan or {}).get('accounts') or [])}개")
    dh = (plan or {}).get('dynamicHeader')
    F['DYNAMIC_HEADER'] = (bool(dh) if plan else None, f"plan.dynamicHeader={str(dh)[:40]}")
    F['_src'] = (None, f"{pp}{'' if plan else '(없음)'} · sheet_columns {len(cols)} · search_cond {len(sc)} · actions {len(acts)} · cell_clear {len(clr)}")
    return F


def load_table():
    return {r['rule_id']: r for r in rd(TABLE)}


def decide(rule_id, F, table):
    """→ (applicable, why)"""
    t = table.get(rule_id)
    if not t:
        return 'UNKNOWN', f"규칙→기능표 미등록({rule_id}) — tools/Harness/rules/rule_applicability.csv 에 행 추가 필요"
    feats = [x.strip() for x in (t.get('feature') or '').split('|') if x.strip()]
    whys, unknown = [], False
    for f in feats:
        ok, why = F.get(f, (None, f'기능 {f} 탐지기 없음'))
        if ok is True:
            return 'Y', f"{f}: {why}"
        if ok is None:
            unknown = True
        whys.append(f"{f}: {why}")
    if unknown:
        return 'UNKNOWN', '사실 파일 없음 — ' + ' · '.join(whys)
    return 'N', '대상 없음(근거: ' + ' · '.join(whys) + ')'


def apply(rows, mid, asis_id=''):
    """원장 행 리스트에 applicable/applicable_why 를 채운다(SOURCES 만 · 그 외 행은 공란 유지). 반환 분포 dict"""
    F = screen_facts(mid, asis_id)
    table = load_table()
    cnt = {}
    for r in rows:
        if r.get('source') not in SOURCES:
            r.setdefault('applicable', ''); r.setdefault('applicable_why', '')
            continue
        a, why = decide(r.get('rule_id') or '', F, table)
        r['applicable'], r['applicable_why'] = a, why[:300]
        cnt[a] = cnt.get(a, 0) + 1
    return cnt, F


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if not args:
        print(__doc__); return 2
    mid = args[0].upper()
    asis = sys.argv[sys.argv.index('--asis') + 1].upper() if '--asis' in sys.argv else next((m['asis_id'].upper() for m in rd(P('tools', 'Harness', 'rules', 'map_screen.csv')) if (m.get('tobe_id') or '').upper() == mid), mid)
    rows = rd(P('Doc', 'verify', mid, 'verify_ledger.csv'))
    cnt, F = apply(rows, mid, asis)
    print(f"[applicability] {mid} (AS-IS {asis}) 사실: {F['_src'][1]}")
    for k, (ok, why) in F.items():
        if k.startswith('_'): continue
        print(f"   {k:<16} {'Y' if ok else ('N' if ok is False else '?'):<2} {why[:110]}")
    print(f"  원장 {len(rows)}행 중 대상 source {sum(1 for r in rows if r.get('source') in SOURCES)}행 → " + ' · '.join(f'{k} {v}' for k, v in sorted(cnt.items())))
    unk = {}
    for r in rows:
        if r.get('applicable') == 'UNKNOWN':
            unk[r['rule_id']] = unk.get(r['rule_id'], 0) + 1
    if unk:
        print('  UNKNOWN 규칙: ' + ', '.join(f'{k}({v})' for k, v in sorted(unk.items())))
    byn = {}
    for r in rows:
        if r.get('applicable') == 'N':
            byn[r['rule_id']] = byn.get(r['rule_id'], 0) + 1
    if byn:
        print('  N 규칙: ' + ', '.join(f'{k}({v})' for k, v in sorted(byn.items())))
    return 0


if __name__ == '__main__':
    sys.exit(main())
