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
import json
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
SRC = os.path.join(ROOT, 'GSCM')
# T565(2026-11-25 SCP0005 FACT 셀 형식 4행): cell_image = 코드가 셀에 배경 이미지 붙인 TextCellType 을 대입(팝업 아이콘 셀) — 'Y' 또는 빈 값
COLS = ['sheet', 'column', 'cell_type', 'decimals', 'min', 'max', 'separator', 'max_length', 'uppercase', 'negative_red', 'fixed_point', 'source', 'ref', 'cond_cells', 'cell_image']
RX_DEFCOL = r'Def\w+\.'  # 화면마다 Def 클래스 이름이 다르다(DefColumns·DefMain …) — 2026-10-30 SCP0111


def framework_defaults():
    """Doc/asisfacts/framework/spreadinfo_defaults.csv(facts_gridcols 가 원문 인용으로 기록) — 코드에 하드코딩하지 않는다"""
    p = os.path.join(ROOT, 'Doc', 'asisfacts', 'framework', 'spreadinfo_defaults.csv')
    return {r['rule']: r for r in read_csv(p)} if os.path.exists(p) else {}
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
    D = framework_defaults()
    neg_default = 'Y' if (D.get('number_negative_red', {}).get('value') or '').lower() == 'true' else ''
    neg_ref = D.get('number_negative_red', {}).get('ref', 'SpreadInfo.cs NumberCellType')
    mm = re.findall(r'-?\d+', D.get('number_min_max', {}).get('value') or '')
    fw_min, fw_max = (mm[0], mm[1]) if len(mm) == 2 else ('', '')

    def sheet_consts(text):
        """SpdSheet* 구조체·클래스의 string 상수 {(구조체, 이름): 시트 이름}(이 파일)"""
        consts = {}
        for ms in re.finditer(r'\b(?:struct|class)\s+(SpdSheet\w*)\s*\{', text):
            depth, j = 1, ms.end()
            while j < len(text) and depth:
                depth += {'{': 1, '}': -1}.get(text[j], 0)
                j += 1
            for k, v in re.findall(r'\bstring\s+(\w+)\s*=\s*"([^"]*)"', text[ms.end():j]):
                consts.setdefault((ms.group(1), k), v)
        return consts

    def guard_sheets(text):
        """T450(2026-11-20 SCP0005 FACT-4087be3b 외 4건): 같은 컬럼이 화면 시트와 팝업 시트(POPUP) 메타에 함께 있으면 컬럼 단위 규칙의 시트가
        마지막 메타 행(POPUP)으로 남고 코드 규칙(SetReNumerCellType)은 시트를 바꾸지 않았다. 코드 줄을 감싼 `if (x.SheetName == SpdSheet.shtX) { }`
        블록의 상수를 그 파일의 SpdSheet 구조체 값으로 풀어 시트를 정한다(파일마다 따로 · 상수를 못 풀면 종전대로 빈 값)"""
        consts = sheet_consts(text)
        out = {}
        if not consts:
            return out
        for mg in re.finditer(r'\bif\s*\(\s*\w+\.SheetName\s*==\s*(SpdSheet\w*)\.(\w+)\s*\)', text):
            v = consts.get((mg.group(1), mg.group(2)))
            k = text.find('{', mg.end())
            if v is None or k < 0 or text[mg.end():k].strip():
                continue
            depth, j = 1, k + 1
            while j < len(text) and depth:
                depth += {'{': 1, '}': -1}.get(text[j], 0)
                j += 1
            for ln in range(text.count('\n', 0, k) + 1, text.count('\n', 0, j) + 2):
                out[ln] = v
        return out

    # T540(2026-11-25 SCP0005 FACT-7d9fe1ed·FACT-47266d1e): 종전 키 = 컬럼 이름뿐이라 같은 컬럼이 본 시트(Distribution Route)와 팝업 폼 시트(POPUP)
    #   메타에 함께 있으면 뒤에 읽은 POPUP 행이 본 시트 행을 덮었다(LT_SUM·ROUTE_ID·DAYS_*·LAST_UPDATE* 11칸이 POPUP 행만 남음). 키 = (시트, 컬럼)
    #   · 시트를 아는 코드 규칙(SheetName 가드)은 그 시트 행에만. 그 시트 메타에 컬럼이 없으면 기록 안 함(GetColumnIndex 없음 = -1 · SpreadInfo.cs:6439~6440)
    #   · 시트를 모르는 코드 규칙은 이 파일이 정의한 시트(SpdSheet 상수) 행 → 없으면 그 컬럼의 모든 시트 행(종전과 같은 범위)
    meta_cols = {}  # 시트(대문자) → 그 시트 메타 컬럼(대문자) 집합

    def skey(sheet):
        return (sheet or '').strip().upper()

    def keys_for(sheet, col, file_sheets=()):
        c = col.upper()
        if sheet:
            sk = skey(sheet)
            if sk in meta_cols and c not in meta_cols[sk] and any(c in v for v in meta_cols.values()):
                return []  # 다른 시트 메타 컬럼(팝업 폼 코드의 PRIORITY 등) — 이 시트에는 없는 칸. 어느 메타에도 없는 코드 칸은 그대로 기록
            return [(sk, c)]
        cands = [k for k in rules if k[1] == c]
        if not cands:
            return [('', c)]
        fs = {skey(x) for x in file_sheets}
        return [k for k in cands if k[0] in fs] or cands

    def put_key(key, sheet, col, **kw):
        r = rules.get(key, {c: '' for c in COLS})
        r.update({k: str(v) for k, v in kw.items() if v is not None})
        r['column'] = col.upper()
        if sheet:
            r['sheet'] = sheet
        rules[key] = r

    def put(sheet, col, file_sheets=(), **kw):
        for key in keys_for(sheet, col, file_sheets):
            put_key(key, sheet, col, **kw)

    for m in read_csv(os.path.join(sdir, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv')):
        if (m.get('PROGRAM_ID') or '').upper() != sid or m.get('VALID_YN', 'Y') == 'N':
            continue
        ctl = (m.get('CELL_CONTROL_OBJECT_TYPE_CODE') or '').strip()
        scale = (m.get('DATA_SCALE_NUMBER') or '').strip()
        typ = META_TYPE.get(ctl, ctl or 'TEXT')
        meta_cols.setdefault(skey(m.get('SHEET_NAME')), set()).add(m['COLUMN_NAME'].upper())
        dec = (scale if scale and scale.isdigit() and int(scale) > 0 else '0') if typ == 'NUMBER' else ''
        put(m.get('SHEET_NAME'), m['COLUMN_NAME'], cell_type=typ, decimals=dec, separator='Y' if typ == 'NUMBER' else '',
            max_length=(m.get('DATA_MAX_LENGTH') or '').strip(), uppercase=(m.get('UPPERCASE_APPLY_FLAG') or '').strip(),
            negative_red=neg_default if typ == 'NUMBER' else '', fixed_point=('Y' if dec == '0' else 'N') if typ == 'NUMBER' else '',
            min=fw_min if typ == 'NUMBER' else '', max=fw_max if typ == 'NUMBER' else '',
            source='META', ref=f"SHEET_COLUMNS {m.get('SHEET_NAME')}.{m['COLUMN_NAME']} CELL={ctl or '-'} SCALE={scale or 'NULL'} · SpreadInfo.cs:1433-1439/1497" + (f" · {neg_ref}" if typ == 'NUMBER' else ''))

    def cond_cells(text, base, rel, guard_of=None, file_sheets=()):
        """2026-11-20 T392(SSP0014 FACT-32d6dd69): 행 값 조건 셀 단위 형식 — `if (si.GetValue(i, …GetColumnIndex(Def*.C)).ToString() == "W") { si.SetCellTypeText(i, …Y); si.SetValue(i, …Y, "Warranty"); si.SetHAlign(i, …Y, …, Center); }`
        (SSP0014_ShipmentModelPIC.cs:355~360). 종전엔 컬럼 단위 규칙만 읽어 조건부 셀 형식이 빠졌다. 컬럼 행은 그대로 두고 cond_cells(JSON 목록)에 조건·셀 형식·대입 값·정렬을 덧붙인다"""
        try:
            from facts_cellclear import const_map
            cm = const_map(rel.replace(chr(92), '/'))
        except Exception:  # noqa: BLE001 — 상수 표 없으면 이름 그대로
            cm = {}
        col = lambda n: (cm.get(n) or n).upper()  # noqa: E731
        lines = text.splitlines()
        rx_if = re.compile(r'\bif\s*\(\s*\w+\.Get(?:Value|Text)\(\s*(\w+)\s*,\s*\w+\.GetColumnIndex\(\s*' + RX_DEFCOL + r'(\w+)\s*\)\s*\)(?:\.ToString\(\))?\s*(==|!=)\s*"([^"]*)"\s*\)')
        for i, line in enumerate(lines, 1):
            if line.strip().startswith('//'):
                continue
            m = rx_if.search(line)
            if not m:
                continue
            rv, ccol, op, lit = m.group(1), col(m.group(2)), m.group(3), m.group(4)
            # 조건 뒤 첫 { … } 블록(한 문장 if 는 다음 ; 까지)
            rest = '\n'.join([line[m.end():]] + lines[i:])
            k = 0
            while k < len(rest) and rest[k] in ' \t\r\n':
                k += 1
            if k < len(rest) and rest[k] == '{':
                depth, j = 1, k + 1
                while j < len(rest) and depth:
                    depth += {'{': 1, '}': -1}.get(rest[j], 0)
                    j += 1
                body = rest[k + 1:j - 1]
            else:
                body = rest[k:rest.find(';', k) + 1]
            body = '\n'.join(x for x in body.splitlines() if not x.strip().startswith('//'))
            acc = {}
            for mt in re.finditer(r'SetCellType(\w*)\(\s*' + re.escape(rv) + r'\s*,\s*\w+\.GetColumnIndex\(\s*' + RX_DEFCOL + r'(\w+)\s*\)', body):
                acc.setdefault(col(mt.group(2)), {})['cell_type'] = (mt.group(1) or 'TEXT').upper()
            for mt in re.finditer(r'SetValue\(\s*' + re.escape(rv) + r'\s*,\s*\w+\.GetColumnIndex\(\s*' + RX_DEFCOL + r'(\w+)\s*\)\s*,\s*"([^"]*)"\s*\)', body):
                acc.setdefault(col(mt.group(1)), {})['value'] = mt.group(2)
            for mt in re.finditer(r'SetHAlign\(\s*' + re.escape(rv) + r'\s*,\s*\w+\.GetColumnIndex\(\s*' + RX_DEFCOL + r'(\w+)\s*\).*?CellHorizontalAlignment\.(\w+)', body):
                acc.setdefault(col(mt.group(1)), {})['halign'] = mt.group(2)
            for tcol, a in acc.items():
                if 'cell_type' not in a:
                    continue  # 셀 형식을 바꾸는 조건 블록만(값·정렬만 바꾸는 블록은 다른 사실 파일 몫)
                g_sh = (guard_of or {}).get(i, '')
                for key in keys_for(g_sh, tcol, file_sheets):  # T540: (시트, 컬럼) 키
                    r = rules.get(key)
                    if r is None:
                        put_key(key, g_sh, tcol, source='CODE_COND')
                        r = rules[key]
                    lst = json.loads(r.get('cond_cells') or '[]')
                    lst.append({'cond': f'COL({ccol}){op}"{lit}"', **a, 'ref': f'{base}:{i}'})
                    r['cond_cells'] = json.dumps(lst, ensure_ascii=False)

    files = [f['file'] for f in read_csv(os.path.join(sdir, 'files.csv')) if f.get('variant') != 'legacy' and f['file'].endswith('.cs') and not f['file'].endswith('.Designer.cs')]
    for rel in files:
        path = os.path.join(SRC, rel.replace('\\', os.sep))
        text = read_text(path)
        base = os.path.basename(rel)
        guard_of = guard_sheets(text)  # T450: 줄 번호 → 그 줄을 감싼 'SheetName == SpdSheet.X' 블록의 시트 이름(이 파일 상수 값)
        fsheets = sorted(set(sheet_consts(text).values()))  # T540: 이 파일이 정의한 시트 이름(시트 가드 없는 코드 규칙의 대상 시트)
        # T541(2026-11-25 DMF0004 같은 유형): 코드 규칙의 칸 이름 = Def* 상수 값(DefColumns.CountryName = "COUNTRY_NAME"). 종전엔 상수 이름(COUNTRYNAME)으로 적어 메타 행과 따로 놀았다
        try:
            from facts_cellclear import const_map
            cmap = const_map(rel.replace(chr(92), '/'))
        except Exception:  # noqa: BLE001 — 상수 표 없으면 이름 그대로
            cmap = {}
        cn = lambda n: cmap.get(n) or n  # noqa: E731
        # T565(2026-11-25 SCP0005 FACT 셀 형식 4행): SetImageCell 의 for 루프 안 `Cells[iRow, si.GetColumnIndex(DefColumns.X)].CellType = cellTypeImage;`(cs:590~595)
        #   를 기록하지 않았다. 필드 변수가 TextCellType 이고 `변수.BackgroundImage = …`(cs:222) 가 있으면 팝업 아이콘 셀(cell_image=Y). 메타 행은 그대로 두고 source·ref 를 덧붙인다
        #   한계: 대입 줄을 감싼 if 조건은 평가하지 않는다(컬럼 단위 기록). TextCellType 외 형식 변수는 대상 아님
        tlines = text.splitlines()
        ct_vars = {}
        for mv in re.finditer(r'\b(?:[\w.]*\.)?TextCellType\s+(\w+)\s*[=;]', text):
            ct_vars[mv.group(1)] = ''
        for mv in re.finditer(r'\b(\w+)\s*=\s*new\s+(?:[\w.]*\.)?TextCellType\s*\(', text):
            ct_vars.setdefault(mv.group(1), '')
        ct_props = {}  # T541: 변수 → 코드가 지정한 MaxLength·CharacterCasing(값, 줄)
        for v in ct_vars:
            ln_img = next((n for n, l_ in enumerate(tlines, 1) if not l_.strip().startswith('//') and re.search(r'\b' + re.escape(v) + r'\.BackgroundImage\s*=', l_)), 0)
            ct_vars[v] = f'{base}:{ln_img}' if ln_img else ''
            pr = {}
            for n_, l_ in enumerate(tlines, 1):
                if l_.strip().startswith('//'):
                    continue
                mp = re.search(r'\b' + re.escape(v) + r'\.MaxLength\s*=\s*(\d+)\s*;', l_)
                if mp:
                    pr['max_length'] = (mp.group(1), f'{base}:{n_}')
                mp = re.search(r'\b' + re.escape(v) + r'\.CharacterCasing\s*=\s*(?:[\w.]*\.)?CharacterCasing\.(\w+)\s*;', l_)
                if mp:
                    pr['uppercase'] = ('Y' if mp.group(1) == 'Upper' else '', f'{base}:{n_}')
            ct_props[v] = pr
        for i, line in enumerate(tlines, 1):
            s = line.strip()
            if s.startswith('//'):
                continue
            m = re.search(r'\.Cells\[\s*[^,\]]+,\s*\w+\.GetColumnIndex\(\s*' + RX_DEFCOL + r'(\w+)\s*\)\s*\]\.CellType\s*=\s*(new\s+(?:[\w.]*\.)?TextCellType\s*\(\s*\)|\w+)\s*;', s)
            if m and (m.group(2).startswith('new') or m.group(2) in ct_vars):
                img = '' if m.group(2).startswith('new') else ct_vars[m.group(2)]
                # T541(2026-11-25 SCP0005 FACT-9372e5d5·FACT-42891395): 새 TextCellType 대입은 셀 형식 객체를 통째로 바꾼다. META 의 최대 길이·대문자는
                #   그 객체 속성(SpreadInfo.cs:4391 MaxLength · 4396 CharacterCasing)이라 같이 사라진다. 종전엔 META max_length(2·5)를 그대로 남겼다
                #   → 대입한 변수(또는 new TextCellType())에 코드가 지정한 값만 남기고, 없으면 빈 값 + ref 에 '미설정' 기록
                pr = {} if m.group(2).startswith('new') else ct_props.get(m.group(2), {})
                for key in keys_for(guard_of.get(i, ''), cn(m.group(1)), fsheets):
                    old_r = rules.get(key, {})
                    here = f'{base}:{i} CellType={m.group(2)}(TextCellType{" · BackgroundImage " + img if img else ""})'
                    if here in (old_r.get('ref') or ''):
                        continue
                    lost = []
                    for fld, nm in (('max_length', 'MaxLength'), ('uppercase', 'CharacterCasing')):
                        if fld in pr:
                            here += f' · {nm} {pr[fld][0] or "-"} {pr[fld][1]}'
                        elif (old_r.get(fld) or '').strip():
                            lost.append(f'{nm} 미설정(META {fld} {old_r.get(fld)} 무효)')
                    if lost:
                        here += ' · ' + ' · '.join(lost)
                    t0 = old_r.get('cell_type') or ''
                    put_key(key, '', cn(m.group(1)), cell_type=t0 if t0.upper() in ('', 'TEXT', 'FPTEXTBOX', 'FPTEXT', 'FPTEXTUPPER') else 'TEXT',
                            source=((old_r.get('source') + '+') if old_r.get('source') else '') + 'CODE_CellType',
                            ref=((old_r.get('ref') + ' · ') if old_r.get('ref') else '') + here,
                            cell_image='Y' if img else (old_r.get('cell_image') or ''),
                            max_length=pr['max_length'][0] if 'max_length' in pr else '',
                            uppercase=pr['uppercase'][0] if 'uppercase' in pr else '')
                continue
            m = re.search(r'SetReNumerCellType\(\s*\w+\s*,\s*\w+\.GetColumnIndex\(\s*' + RX_DEFCOL + r'(\w+)\s*\)\s*((?:,\s*-?\d+\s*)*)\)', s)
            if m:
                args = [x.strip() for x in m.group(2).split(',') if x.strip()]
                mn = args[0] if len(args) >= 1 else '0'
                dec = args[1] if len(args) >= 2 else '0'
                mx = args[2] if len(args) >= 3 else MAXV
                put(guard_of.get(i, ''), cn(m.group(1)), fsheets, cell_type='NUMBER', decimals=dec, min=mn, max=mx, separator='Y', negative_red=neg_default, fixed_point='Y' if dec == '0' else 'N',
                    source='CODE_SetReNumerCellType', ref=f'{base}:{i} · SpreadInfo.cs:13772-13856')
                continue
            m = re.search(r'AddNumColumn(?:Ex)?\(\s*"[^"]*"\s*,\s*' + RX_DEFCOL + r'(\w+)\s*,(.*)\)\s*;', s)
            if m:
                tail = [x.strip() for x in m.group(2).split(',')]
                ints = [x for x in tail[4:] if re.fullmatch(r'\d+', x)]  # merge,width,visible,align… 뒤의 정수 = 소수자리
                # 5-인자 AddNumColumn(header, field, merge, width, visible) = blFixedPoint true(정수) — 기본값 CSV 인용
                five = len(tail) <= 3 and (D.get('addnumcolumn_5arg_fixedpoint', {}).get('value') or '').lower() == 'true'
                dec = ints[-1] if ints else '0'
                put('', cn(m.group(1)), fsheets, cell_type='NUMBER', decimals=dec, min=fw_min, max=fw_max, separator='Y' if 'true' in tail[-1:] else '', negative_red=neg_default,
                    fixed_point='Y' if (five or dec == '0') else 'N', source='CODE_AddNumColumn', ref=f'{base}:{i}' + (f" · {D.get('addnumcolumn_5arg_fixedpoint', {}).get('ref', '')}" if five else ''))
                continue
            m = re.search(r'Add(DateTime|Date)Column\(\s*"[^"]*"\s*,\s*' + RX_DEFCOL + r'(\w+)', s)
            if m:
                put('', cn(m.group(2)), fsheets, cell_type='DATETIME' if m.group(1) == 'DateTime' else 'DATE', source=f'CODE_Add{m.group(1)}Column', ref=f'{base}:{i}')
        cond_cells(text, base, rel, guard_of, fsheets)
    # T540: 같은 컬럼이 여러 시트에 있으면 본 화면 시트(메타 행 최다) 행을 앞에(컬럼별 첫 행을 읽는 소비자 기준) → 그 밖 시트 → 팝업 폼 소속 시트(ledger.popup_owned_sheets) 행을 뒤에
    try:
        from ledger import popup_owned_sheets
        pop = {skey(x) for x in popup_owned_sheets(sdir)}
    except Exception:  # noqa: BLE001 — 판별 못 하면 시트 이름 순
        pop = set()
    main_sk = max(meta_cols, key=lambda k: len(meta_cols[k])) if meta_cols else ''  # 메타 행이 가장 많은 시트(facts_lockrules main_sheet 와 같은 기준)
    rank = lambda sk: 0 if sk == main_sk else 2 if sk in pop else 1  # noqa: E731
    out = os.path.join(sdir, 'cell_rules.csv')
    with open(out, 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        for k in sorted(rules, key=lambda k: (k[1], rank(k[0]), k[0])):
            w.writerow(rules[k])
    print(f'{sid}: {len(rules)}행({len({k[1] for k in rules})}컬럼) → {out}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
