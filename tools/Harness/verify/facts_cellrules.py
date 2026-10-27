"""AS-IS 셀 입력 규칙 추출 — Doc/asisfacts/screens/<AS-IS ID>/cell_rules.csv

  python tools/Harness/verify/facts_cellrules.py <AS-IS ID>

원천(우선순위 낮음 → 높음, 뒤가 덮어쓴다 = AS-IS 실행 순서):
  1) SCM_MST_SHEET_COLUMNS(AS-IS) — dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv
     프레임워크 SpreadInfo.cs:1433-1439 — DATA_SCALE_NUMBER 가 NULL/0 이면 소수 0자리, >0 이면 그 자리수
     SpreadInfo.cs:1497-1500 — FPNumber = AddNumColumn(…, decimalPlaces, 천단위 구분 true)
  2) 화면 .cs 의 AddNumColumn / AddNumColumnEx / AddDateTimeColumn / AddDateColumn (코드 컬럼)
  3) 화면 .cs 의 SetReNumerCellType(si, col[, min[, decimals[, max]]]) — SpreadInfo.cs:13772-13856
     인자 2개: 소수0·min0·max9999999999 / 3개: 소수0·min=인자 / 4개: 소수=인자 / 5개: max=인자 (천단위·음수 빨강 공통)
산출 열: column, cell_type(NUMBER|DATE|DATETIME|TEXT|COMBO|CHECK|…), decimals, min, max, separator, max_length, uppercase, source, ref
"""
import csv
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
SRC = os.path.join(ROOT, 'GSCM')
COLS = ['sheet', 'column', 'cell_type', 'decimals', 'min', 'max', 'separator', 'max_length', 'uppercase', 'source', 'ref']
META_TYPE = {'FPNumber': 'NUMBER', 'FPNumberText': 'NUMBER_TEXT', 'FPDate': 'DATE', 'FPDateTime': 'DATETIME', 'FPComboBox': 'COMBO',
             'FPCheckBox': 'CHECK', 'FPText': 'TEXT', 'FPTextUpper': 'TEXT', 'FPButton': 'BUTTON'}
MAXV = '9999999999'


def read_csv(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def read_text(p):
    for enc in ('utf-8-sig', 'cp949', 'utf-8'):
        try:
            with open(p, encoding=enc) as f:
                return f.read()
        except UnicodeDecodeError:
            continue
    return ''


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    sid = sys.argv[1].upper()
    sdir = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', sid)
    rules = {}

    def put(sheet, col, **kw):
        key = col.upper()
        r = rules.get(key, {c: '' for c in COLS})
        r.update({k: str(v) for k, v in kw.items() if v is not None})
        r['column'] = key
        if sheet:
            r['sheet'] = sheet
        rules[key] = r

    for m in read_csv(os.path.join(sdir, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv')):
        if (m.get('PROGRAM_ID') or '').upper() != sid or m.get('VALID_YN', 'Y') == 'N':
            continue
        ctl = (m.get('CELL_CONTROL_OBJECT_TYPE_CODE') or '').strip()
        scale = (m.get('DATA_SCALE_NUMBER') or '').strip()
        typ = META_TYPE.get(ctl, ctl or 'TEXT')
        dec = (scale if scale and scale.isdigit() and int(scale) > 0 else '0') if typ == 'NUMBER' else ''
        put(m.get('SHEET_NAME'), m['COLUMN_NAME'], cell_type=typ, decimals=dec, separator='Y' if typ == 'NUMBER' else '',
            max_length=(m.get('DATA_MAX_LENGTH') or '').strip(), uppercase=(m.get('UPPERCASE_APPLY_FLAG') or '').strip(),
            source='META', ref=f"SHEET_COLUMNS {m.get('SHEET_NAME')}.{m['COLUMN_NAME']} CELL={ctl or '-'} SCALE={scale or 'NULL'} · SpreadInfo.cs:1433-1439/1497")

    files = [f['file'] for f in read_csv(os.path.join(sdir, 'files.csv')) if f.get('variant') != 'legacy' and f['file'].endswith('.cs') and not f['file'].endswith('.Designer.cs')]
    for rel in files:
        path = os.path.join(SRC, rel.replace('\\', os.sep))
        text = read_text(path)
        base = os.path.basename(rel)
        for i, line in enumerate(text.splitlines(), 1):
            s = line.strip()
            if s.startswith('//'):
                continue
            m = re.search(r'SetReNumerCellType\(\s*\w+\s*,\s*\w+\.GetColumnIndex\(\s*DefColumns\.(\w+)\s*\)\s*((?:,\s*-?\d+\s*)*)\)', s)
            if m:
                args = [x.strip() for x in m.group(2).split(',') if x.strip()]
                mn = args[0] if len(args) >= 1 else '0'
                dec = args[1] if len(args) >= 2 else '0'
                mx = args[2] if len(args) >= 3 else MAXV
                put('', m.group(1), cell_type='NUMBER', decimals=dec, min=mn, max=mx, separator='Y', source='CODE_SetReNumerCellType',
                    ref=f'{base}:{i} · SpreadInfo.cs:13772-13856')
                continue
            m = re.search(r'AddNumColumn(?:Ex)?\(\s*"[^"]*"\s*,\s*DefColumns\.(\w+)\s*,(.*)\)\s*;', s)
            if m:
                tail = [x.strip() for x in m.group(2).split(',')]
                ints = [x for x in tail[4:] if re.fullmatch(r'\d+', x)]  # merge,width,visible,align… 뒤의 정수 = 소수자리
                put('', m.group(1), cell_type='NUMBER', decimals=ints[-1] if ints else '0', separator='Y' if 'true' in tail[-1:] else '',
                    source='CODE_AddNumColumn', ref=f'{base}:{i}')
                continue
            m = re.search(r'Add(DateTime|Date)Column\(\s*"[^"]*"\s*,\s*DefColumns\.(\w+)', s)
            if m:
                put('', m.group(2), cell_type='DATETIME' if m.group(1) == 'DateTime' else 'DATE', source=f'CODE_Add{m.group(1)}Column', ref=f'{base}:{i}')
    out = os.path.join(sdir, 'cell_rules.csv')
    with open(out, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        for k in sorted(rules):
            w.writerow(rules[k])
    print(f'{sid}: {len(rules)}컬럼 → {out}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
