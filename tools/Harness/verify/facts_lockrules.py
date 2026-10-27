"""AS-IS 그리드 잠금 규칙 전개 + 컬럼별 편집 기대표

  python tools/Harness/verify/facts_lockrules.py <AS-IS ID> [--class <메인 클래스명>]

산출 (Doc/asisfacts/screens/<ID>/):
  lock_rules.csv   AS-IS GRID_LOCK 액션 1건 = 1행, GetColumnIndex(A)..(B) 범위를 AS-IS 컬럼 순서로 전개
  edit_expect.csv  컬럼별 기대 — 신규행 / 기존행(편집모드) 각각 Y(편집 가능) · N(잠금) · COND(조건부, 조건 기재)

AS-IS 동작 근거(프레임워크):
  · 조회 직후 LockColumn(0, Max, true) = 전체 잠금(조회 모드)
  · EditButton: SwitchLock() 로 편집 모드 전환 후 LockColumn(A,B,true) 범위만 잠금 → 기존행 기대
  · Insert(): SpreadInfo.cs:8460~ 신규행 범위 Locked=false(전체 해제) → InsertButton 의 LockRange 로 다시 잠근 셀만 잠금 → 신규행 기대
  · 행 조건 LockRange(…, i 또는 e.Row …) = guard 조건부(COND)
컬럼 순서 = AS-IS SHEET_COLUMNS SORT_ORDER_NO(메인 시트). 'ColumnCount - 1'·'GetMaxColumnIndex()' = 마지막 컬럼.
"""
import argparse
import csv
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('asis_id')
    ap.add_argument('--class', dest='cls', default='')
    a = ap.parse_args()
    sid = a.asis_id.upper()
    sdir = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid)
    # 현행(current) 파일의 액션만 — legacy 사본이 섞이면 같은 잠금이 두 번·구버전 규칙이 들어간다
    cur_files = {f['file'] for f in read_csv(os.path.join(sdir, 'files.csv')) if f.get('variant') in ('current', 'shared')}
    acts = [x for x in read_csv(os.path.join(sdir, 'actions.csv')) if not cur_files or x['file'] in cur_files]
    # 메인 클래스 = current 변형 파일(Designer 제외) 중 액션이 가장 많은 클래스 — 'ID_ 로 시작하는 첫 클래스'는 보조 폼을 잡았다(2026-10-23 DMF0005_ModelCodeChange 오인)
    main_files = {f['file'] for f in read_csv(os.path.join(sdir, 'files.csv')) if f.get('variant') == 'current' and f['file'].endswith('.cs') and not f['file'].endswith('.Designer.cs')}
    cnt = {}
    for x in acts:
        if x['file'] in main_files:
            cnt[x['class']] = cnt.get(x['class'], 0) + 1
    main_cls = a.cls or (max(cnt, key=cnt.get) if cnt else next((x['class'] for x in acts if x['class'].upper().startswith(sid + '_') and 'Popup' not in x['class']), ''))
    meta = [m for m in read_csv(os.path.join(sdir, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv')) if (m.get('PROGRAM_ID') or '').upper() == sid and m.get('VALID_YN', 'Y') != 'N']
    sheets = {}
    for m in meta:
        sheets.setdefault(m['SHEET_NAME'], []).append(m)
    main_sheet = max(sheets, key=lambda s: len(sheets[s])) if sheets else ''
    ms = sorted(sheets.get(main_sheet, []), key=lambda m: float(m.get('SORT_ORDER_NO') or 0))
    order = [m['COLUMN_NAME'].upper() for m in ms]
    sort_no = {m['COLUMN_NAME'].upper(): m.get('SORT_ORDER_NO') for m in ms}
    visible = {m['COLUMN_NAME'].upper(): m.get('VISIBLE_FLAG', 'Y') for m in ms}

    def expand(arg_text):
        cols = re.findall(r'DefColumns\.([A-Z0-9_]+)', arg_text)
        to_end = bool(re.search(r'ColumnCount\s*-\s*1|GetMaxColumnIndex\(\)', arg_text))
        from_zero = bool(re.match(r'\(\s*0\s*,', arg_text))
        if from_zero and to_end:
            return list(order), 'ALL'
        if not cols:
            return [], 'UNRESOLVED'
        start = cols[0]
        end = order[-1] if to_end else cols[-1]
        if start in order and end in order:
            i, j = order.index(start), order.index(end)
            return order[i:j + 1], 'RANGE' if i != j else 'ONE'
        return sorted(set(cols)), 'ENDPOINTS'  # 순서표에 없는 컬럼(코드 컬럼) — 양 끝만

    locks = []
    for x in acts:
        if x['kind'] != 'GRID_LOCK' or x['class'] != main_cls:
            continue
        tgt, val, m = x['target'], x['value'], x['method']
        if tgt.endswith('SwitchLock'):
            locks.append({'method': m, 'line': x['line'], 'api': 'SwitchLock', 'scope': 'MODE', 'locked': 'TOGGLE', 'columns': '', 'expand': '', 'guard': x['guard'], 'raw': tgt + val})
            continue
        locked = 'N' if re.search(r',\s*false\s*\)\s*$', val) else 'Y'
        if tgt.endswith('LockColumn'):
            cols, how = expand(val)
            scope = 'ALL_ROWS'
        else:  # LockRange(row, colA, [row,] colB, bool)
            inner = re.sub(r'^\(\s*[^,]+,', '(', val)  # 첫 인자(행) 제거
            cols, how = expand(inner)
            row_arg = val.split(',')[0].strip('( ')
            scope = 'NEW_ROW' if m == 'InsertButton' or row_arg == 'insCell' else 'ROW_COND'
        locks.append({'method': m, 'line': x['line'], 'api': tgt.split('.')[-1], 'scope': scope, 'locked': locked, 'columns': ';'.join(cols), 'expand': how, 'guard': x['guard'], 'raw': tgt + val})

    base = os.path.basename((acts[0]['file'] if acts else '')).replace('.cs', '')
    out1 = os.path.join(sdir, 'lock_rules.csv')
    with open(out1, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['method', 'line', 'api', 'scope', 'locked', 'columns', 'expand', 'guard', 'raw'])
        w.writeheader()
        w.writerows(locks)

    # 컬럼별 기대 — 기본값의 근거가 있을 때만 'Y'(편집 가능)로 둔다(2026-10-23 DMF0082 오탐: 잠금 규칙이 안 보인다고 기존행 키 컬럼을 편집 가능으로 추정)
    #   기존행 기본 Y = EditButton 이 SwitchLock 으로 편집 모드 전환(전체 해제) 후 LockColumn 으로 일부만 잠그는 모델일 때만. 아니면 UNKNOWN
    #   신규행 기본 Y = InsertButton 이 siMain.Insert() (SpreadInfo.cs:8460~ 신규행 Locked=false) 를 쓸 때만. 아니면 UNKNOWN
    # 단, EditButton 잠금 중 컬럼을 해석할 수 없는 것(LockColumn(iCol,iCol) 같은 변수·메타 루프)이 있으면 어느 컬럼이 잠기는지 모른다 → UNKNOWN
    edit_unresolved = [l for l in locks if l['method'] == 'EditButton' and l['api'] != 'SwitchLock' and l['expand'] in ('UNRESOLVED', '')]
    edit_unlocks_all = any(l['method'] == 'EditButton' and l['api'] == 'SwitchLock' for l in locks) and not edit_unresolved
    insert_unlocks_row = any(x['method'] == 'InsertButton' and re.search(r'\.Insert\s*$', x['target'] or '') for x in acts if x['class'] == main_cls)
    d_exist = 'Y' if edit_unlocks_all else 'UNKNOWN'
    d_new = 'Y' if insert_unlocks_row else 'UNKNOWN'
    exp = {c: {'column': c, 'new_row': d_new, 'existing_row': d_exist, 'new_row_cond': '', 'existing_cond': '', 'ref': ''} for c in order}

    def note(c, k, v):
        exp.setdefault(c, {'column': c, 'new_row': d_new, 'existing_row': d_exist, 'new_row_cond': '', 'existing_cond': '', 'ref': ''})
        exp[c][k] = (exp[c][k] + ' | ' if exp[c][k] else '') + v

    edit_locks = [l for l in locks if l['method'] == 'EditButton' and l['scope'] == 'ALL_ROWS']
    for l in edit_locks:
        for c in l['columns'].split(';'):
            if c:
                exp.setdefault(c, {'column': c, 'new_row': d_new, 'existing_row': d_exist, 'new_row_cond': '', 'existing_cond': '', 'ref': ''})
                exp[c]['existing_row'] = 'N' if l['locked'] == 'Y' else 'Y'
                note(c, 'ref', f"기존행 {base}:{l['line']} LockColumn")
    for l in locks:
        if l['scope'] == 'NEW_ROW':
            guard_tail = l['guard'].split('▸')[-1].strip()
            for c in l['columns'].split(';'):
                if not c:
                    continue
                exp.setdefault(c, {'column': c, 'new_row': d_new, 'existing_row': d_exist, 'new_row_cond': '', 'existing_cond': '', 'ref': ''})
                if re.search(r'strSel_|Length\s*==', guard_tail):
                    exp[c]['new_row'] = 'COND'
                    note(c, 'new_row_cond', f"{'잠금' if l['locked'] == 'Y' else '해제'} when {guard_tail}")
                else:
                    exp[c]['new_row'] = 'N' if l['locked'] == 'Y' else 'Y'
                note(c, 'ref', f"신규행 {base}:{l['line']} LockRange")
        elif l['scope'] == 'ROW_COND':
            guard_tail = l['guard'].split('▸')[-1].strip()
            for c in l['columns'].split(';'):
                if not c:
                    continue
                for k, kc in (('new_row', 'new_row_cond'), ('existing_row', 'existing_cond')):
                    exp.setdefault(c, {'column': c, 'new_row': d_new, 'existing_row': d_exist, 'new_row_cond': '', 'existing_cond': '', 'ref': ''})
                    exp[c][k] = 'COND'
                    note(c, kc, f"{'잠금' if l['locked'] == 'Y' else '해제'} when {guard_tail} ({l['method']}:{l['line']})")
    out2 = os.path.join(sdir, 'edit_expect.csv')
    # 범위 경계와 정렬번호가 같은 컬럼 = AS-IS 실제 순서가 메타만으로 확정 불가 → 판정필요 표시
    bounds = set()
    for l in locks:
        cs = [c for c in l['columns'].split(';') if c]
        if l['expand'] == 'RANGE' and cs:
            bounds.update({sort_no.get(cs[0]), sort_no.get(cs[-1])})
    with open(out2, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['column', 'asis_visible', 'new_row', 'existing_row', 'new_row_cond', 'existing_cond', 'ambiguous', 'ref'])
        w.writeheader()
        for c in order + [k for k in exp if k not in order]:
            r = dict(exp[c])
            r['asis_visible'] = visible.get(c, '')
            peers = [o for o in order if o != c and sort_no.get(o) == sort_no.get(c)]
            r['ambiguous'] = f"정렬번호 {sort_no.get(c)} 동률({','.join(peers)}) — 범위 경계 포함 여부 확정 불가" if peers and sort_no.get(c) in bounds else ''
            w.writerow(r)
    print(f'{sid}: 잠금 규칙 {len(locks)}건 → {out1}')
    print(f'  편집 기대 {len(exp)}컬럼 → {out2} (메인 시트 {main_sheet}, 클래스 {main_cls})')
    return 0


if __name__ == '__main__':
    sys.exit(main())
