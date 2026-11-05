# -*- coding: utf-8 -*-
"""AS-IS 그리드 컬럼 선언 사실(정합검증용) — Doc/asisfacts/screens/<AS-IS ID>/grid_columns_asis.csv (2026-10-27 사용자 요청: 정합검증에 필요한 AS-IS 정적 정보 추가 취합)

  python tools/Harness/verify/facts_gridcols.py <AS-IS ID>

왜 필요한가
  SCP0007 메인 그리드의 Add*Column 선언 31줄은 원문에서 /* */ 블록 주석 안(실행되지 않음)이고 실제 컬럼은 메타(SCM_MST_SHEET_COLUMNS)로 만들어진다.
  정합검증(H3 병합·C2 콤보·D5 셀 타입·H4 폭·A5 표시)이 "AS-IS 가 이 컬럼을 어떻게 선언했는가" 를 물을 때 근거가 없어 추정·우회가 생겼다.
  → 살아 있는 코드 선언(Roslyn 추출 grid_code.csv, 주석 제외)과 메타 선언을 한 표로 합치고, 메타 컬럼에 프레임워크가 주는 기본값은 원문 라인을 인용해 적는다.

원천
  CODE : grid_code.csv (tools/AsisFacts CsExtractor — 주석·#if 비활성 제외) Add*Column 호출. args '¦' 구분, arg_names 로 위치 해석. {?FPMerge.None} 식 표기.
  META : dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv (AS-IS DB 추출) — 시트/컬럼별 1행(DIVISION_ID 공통행 우선).
  프레임워크 기본값(원문 인용 — GSCM/01.Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs)
    · 메타 컬럼 병합 정책 = FPMerge.Restricted 고정(SetSheetHeaderColumn, :1909 / SetSheetHeaderColumn(…,chkAll) :2246) · 체크 컬럼만 None(:2090)
    · 그리드 병합 옵션 기본 MergeOption.SmartMerge(:12345 — 빈 값은 병합하지 않음) · SmartColMergeOld = 첫 번째 '표시+Restricted' 컬럼부터 COLMERGE 보조열로 계층 병합
    · 셀 타입 미지정 = Text(기본 TextCellType) · FPComboBox 는 CELL_COMBO_DATA_TYPE 콤보(:1444~1455)

출력 열
  sheet · column · source(CODE|META) · class · ref(파일:라인|META) · label · cell_type · combo_data_type · merge_policy · merge_src · width · visible · halign · decimals · max_length · conditions
"""
import csv
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
DOC = os.path.join(ROOT, 'Doc')
SPREADINFO = 'GSCM/01.Framework/GSCM.Windows.Forms/Class/SpreadInfo.cs'
FRAMEWORK_DEFAULTS = [
    # rule, value, ref, meaning
    ('meta_column_merge_policy', 'Restricted', f'{SPREADINFO}:1909', '메타(SCM_MST_SHEET_COLUMNS)로 만든 컬럼은 모두 FPMerge.Restricted(왼쪽 컬럼이 병합된 범위 안에서 동일 인접값 세로 병합)'),
    ('meta_check_column_merge_policy', 'None', f'{SPREADINFO}:2090', '메타 체크 컬럼(AddCheckColumn)은 병합 없음'),
    ('grid_merge_option_default', 'SmartMerge', f'{SPREADINFO}:12345', 'SmartColMerge() 기본 옵션 — 빈 값은 병합하지 않음(SmartMerge: DO NOT MERGE WHITE SPACE)'),
    ('smart_col_merge_start', 'first visible Restricted column', f'{SPREADINFO}:SmartColMergeOld', 'COLMERGE 보조열(Always)을 첫 표시+Restricted 컬럼 앞에 숨겨 넣고 그 뒤 컬럼을 계층 병합'),
    ('cell_type_default', 'Text', f'{SPREADINFO}:1387~1393', 'CELL_CONTROL_OBJECT_TYPE_CODE 가 NULL 이면 기본 텍스트 셀'),
    ('cell_type_combo', 'FPComboBox → CELL_COMBO_DATA_TYPE 콤보', f'{SPREADINFO}:1444~1455', '메타 FPComboBox 컬럼은 CELL_COMBO_DATA_TYPE(예 YesOrNo) 데이터로 콤보 셀'),
    ('checked_list_no_selection', 'ALL', 'GSCM/01.Framework/GSCM.Windows.Forms/Class/UsrCheckedList.cs:298-307', '다중 체크리스트 선택 없음 = ALL(전체)'),
    # 2026-10-30 숫자 셀 기본값(SCP0111 음수 빨강·정수만 미검출 계기) — AddColumn NumberCellType 분기 원문
    ('number_negative_red', 'true', f'{SPREADINFO}:4369', 'NumberCellType 은 NegativeRed=true — 음수는 빨간 글자(화면 코드가 아니라 프레임워크 기본)'),
    ('number_fixed_point_decimals', '0 when blFixedPoint', f'{SPREADINFO}:4366-4367', 'blFixedPoint=true 면 DecimalPlaces=0(정수만) · FixedPoint=blFixedPoint'),
    ('number_min_max', '-99999999999999 ~ 99999999999999', f'{SPREADINFO}:4372-4373', 'NumberCellType MinimumValue/MaximumValue 기본'),
    ('addnumcolumn_5arg_fixedpoint', 'true', f'{SPREADINFO}:4477-4481', 'AddNumColumn(header, field, merge, width, visible) 5-인자 오버로드 → AddColumn(…, FPDataType.FPNum, false, true) = 천단위 표시 false·blFixedPoint true(정수)'),
    ('fpnumber_scale_null_decimals', '0', f'{SPREADINFO}:1433-1439', '메타 FPNumber 의 DATA_SCALE_NUMBER 가 NULL/0 이면 소수 0자리(정수만)'),
]


def rdcsv(p):
    if not os.path.exists(p): return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def wcsv(p, rows, cols):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols); w.writeheader()
        for r in rows: w.writerow({c: r.get(c, '') for c in cols})


def arg(r, name):
    names = (r.get('arg_names') or '').split(','); args = (r.get('args') or '').split(' ¦ ')
    if name in names:
        i = names.index(name); return args[i].strip() if i < len(args) else ''
    return ''


def lit(v):
    """{?FPMerge.None} → None · {?true} → true · 60 → 60"""
    m = re.fullmatch(r'\{\?(.+)\}', (v or '').strip()); v = m.group(1) if m else (v or '').strip()
    return v.split('.')[-1] if re.match(r'^(FPMerge|FPHAlign|FPVAlign)\.', v) else v


API_TYPE = [('AddComboColumn', 'Combo'), ('AddNumTextColumn', 'Number'), ('AddNumColumn', 'Number'), ('AddDateColumn', 'Date'), ('AddDateTimeColumn', 'Date'),
            ('AddCheckColumn', 'Check'), ('AddButtonColumn', 'Button'), ('AddImageColumn', 'Image'), ('AddExTextColumn', 'Text'), ('AddTextColumn', 'Text'), ('AddActionTextBox', 'Action')]


def code_rows(asis):
    out = []
    for r in rdcsv(os.path.join(DOC, 'asisfacts', 'screens', asis, 'grid_code.csv')):
        api = r.get('api') or ''
        if not (api.startswith('Add') and 'Column' in api): continue
        col = r.get('field') or arg(r, 'sFieldName'); col = lit(col)
        if not col or col.startswith('{'): continue
        sheet = r.get('sheet_hint') or (re.search(r'SheetName\s*==\s*"([^"]+)"', r.get('conditions') or '') or [None, ''])[1]
        ctype = next((t for a, t in API_TYPE if api.startswith(a)), api)
        merge = lit(arg(r, 'merge')) or ('None' if ctype == 'Check' else '')
        combo = lit(arg(r, 'dt') or arg(r, 'dtCombo') or arg(r, 'dtData')) if ctype == 'Combo' else ''
        if ctype == 'Combo' and not combo:
            combo = next((lit(a) for a in (r.get('args') or '').split(' ¦ ') if re.match(r'\{\?dt\w+\}|^dt\w+$', a.strip())), '')
        out.append({'sheet': sheet, 'column': col, 'source': 'CODE', 'class': r.get('class', ''), 'ref': f"{os.path.basename((r.get('file') or '').replace(chr(92), '/'))}:{r.get('line', '')}",
                    'label': lit(r.get('header') or arg(r, 'sHeaderText')), 'cell_type': ctype, 'combo_data_type': combo,
                    'merge_policy': merge, 'merge_src': f"코드 선언 FPMerge.{merge}" if merge else '코드 선언(병합 인자 없음)',
                    'width': lit(arg(r, 'fWidth')), 'visible': lit(arg(r, 'bVisible')), 'halign': lit(arg(r, 'fph')),
                    'decimals': lit(arg(r, 'iDecimal') or arg(r, 'decimals')), 'max_length': '', 'conditions': r.get('conditions') or ''})
    return out


def meta_rows(asis):
    out, seen = [], {}
    rows = rdcsv(os.path.join(DOC, 'asisfacts', 'screens', asis, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv'))
    rows.sort(key=lambda r: (r.get('SHEET_NAME', ''), r.get('COLUMN_NAME', ''), 0 if not (r.get('DIVISION_ID') or '').strip() else 1, r.get('DIVISION_ID', '')))
    for r in rows:
        key = (r.get('SHEET_NAME', ''), r.get('COLUMN_NAME', ''))
        if key in seen: continue
        seen[key] = True
        ctl = (r.get('CELL_CONTROL_OBJECT_TYPE_CODE') or '').strip()
        ctype = ctl or 'Text'
        is_check = ctl.lower() in ('fpcheckbox', 'checkbox')
        out.append({'sheet': r.get('SHEET_NAME', ''), 'column': r.get('COLUMN_NAME', ''), 'source': 'META', 'class': '', 'ref': f"META SCM_MST_SHEET_COLUMNS({r.get('PROGRAM_ID', '')}/{r.get('SHEET_NAME', '')})",
                    'label': (r.get('COLUMN_LABEL_NAME') or '').strip(), 'cell_type': ctype + ('' if ctl else '(기본)'), 'combo_data_type': (r.get('CELL_COMBO_DATA_TYPE') or '').strip(),
                    'merge_policy': 'None' if is_check else 'Restricted',
                    'merge_src': f"프레임워크 기본 — 메타 컬럼은 FPMerge.{'None(체크 컬럼)' if is_check else 'Restricted'} ({SPREADINFO}:{'2090' if is_check else '1909'})",
                    'width': (r.get('COLUMN_WIDTH') or '').strip(), 'visible': (r.get('VISIBLE_FLAG') or '').strip(), 'halign': (r.get('HORIZONTAL_ALIGN_CODE') or '').strip(),
                    'decimals': (r.get('DATA_SCALE_NUMBER') or '').strip(), 'max_length': (r.get('DATA_MAX_LENGTH') or '').strip(), 'conditions': ''})
    return out


def main():
    asis = (sys.argv[1] if len(sys.argv) > 1 else '').upper()
    if not asis: print(__doc__); sys.exit(2)
    d = os.path.join(DOC, 'asisfacts', 'screens', asis)
    if not os.path.isdir(d): print(f'[ERROR] AS-IS facts 없음: {d}'); sys.exit(1)
    rows = code_rows(asis) + meta_rows(asis)
    cols = ['sheet', 'column', 'source', 'class', 'ref', 'label', 'cell_type', 'combo_data_type', 'merge_policy', 'merge_src', 'width', 'visible', 'halign', 'decimals', 'max_length', 'conditions']
    wcsv(os.path.join(d, 'grid_columns_asis.csv'), rows, cols)
    wcsv(os.path.join(DOC, 'asisfacts', 'framework', 'spreadinfo_defaults.csv'), [dict(zip(('rule', 'value', 'ref', 'meaning'), x)) for x in FRAMEWORK_DEFAULTS], ['rule', 'value', 'ref', 'meaning'])
    nc = sum(1 for r in rows if r['source'] == 'CODE'); nm = len(rows) - nc
    print(f"{asis}: 그리드 컬럼 선언 {len(rows)}행 (CODE {nc} · META {nm}) → {os.path.join(d, 'grid_columns_asis.csv')} · 프레임워크 기본값 {len(FRAMEWORK_DEFAULTS)}행 → Doc/asisfacts/framework/spreadinfo_defaults.csv")


if __name__ == '__main__':
    main()
