# -*- coding: utf-8 -*-
"""언어 전환 문구 판정(2026-11-02 엔진 갭 EG361)

  python tools/Harness/verify/i18n_lang_check.py <MENU_ID>   → Doc/verify/<ID>/i18n_lang.csv (eg_ingest 가 I2 행으로 반입)
  python tools/Harness/verify/i18n_lang_check.py --selftest   판정 변이 입증

  입력: E2E 덤프 Doc/verify/<ID>/lang_texts.json(언어별 라벨·버튼·헤더·'_' 폴백) · SCM_ADM_MSG_M(새로 조회)
  판정: '_' 폴백 = FAIL · 한글 라벨이 ENG/CHN 화면에 있음 = FAIL · 다른 언어 등록 문구가 그대로 노출(현재 언어 문구가 따로 등록됨) = FAIL
        번역 미등록(그 코드에 현재 언어 행 없음) = ERROR · 사전에 없는 문구 = 건수만
  한계: 데이터 값·콤보 후보·서버 메시지는 재지 않는다 — 화면 라벨 표면만
"""
import re, csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn'))
csv.field_size_limit(10 ** 8)
KO = re.compile(r'[가-힣]')
COLS = ['lang', 'result', 'why']


def norm(t):
    return re.sub(r'\s+', ' ', re.sub(r'\(F\d+\)$|[*.]$', '', (t or '').strip())).strip()  # 단축키·필수 표시·끝 점('Div'↔'Div.')은 같은 문구


def judge(lang, texts, untr, by_text, by_id, where=None, asis_fixed=None):
    """by_text 문구 → {(id, 언어)} · by_id (id, 언어) → 문구 · where 문구 → 위치 설명(2026-11-06 사용자 지시 SCP0084 27·28번:
    '정확하게 어떤 항목에 대한 LABEL 인지 기재' — 조회조건 라벨/그리드 헤더(시트·컬럼 ID)/버튼 · 없으면 종전 표기)
    asis_fixed: AS-IS 메타(SCM_MST_SHEET_COLUMNS 라벨 문자열)에도 같은 한글 고정 라벨이 있는 문구(2026-11-07 T138 — AS-IS 와 동일 = 화면 결함 아님 · EN 문구 등록 여부는 사용자 결정 → 판정필요)"""
    where = where or {}; asis_fixed = asis_fixed or set()
    loc = lambda t: f" · {where[t]}" if t in where else ''
    if not texts:
        return 'ERROR', '[측정 경로 없음] 수집 문구 0'
    if untr:
        return 'FAIL', f"'_' 폴백 {len(untr)}건: {untr[:5]}"
    wrong, miss, unknown, ok, fixed = [], [], [], 0, []
    for t0 in sorted(set(texts)):
        t = norm(t0)
        if not t:
            continue
        hits = by_text.get(t, set())
        if any(l == lang for _, l in hits):
            ok += 1
            continue
        if lang != 'KO' and KO.search(t):
            if t in asis_fixed:
                fixed.append(f"'{t}'(한글 · AS-IS 메타도 같은 고정 라벨{loc(t)})")
            else:
                wrong.append(f"'{t}'(한글{loc(t)})")
            continue
        if not hits:
            unknown.append(t)
            continue
        cur = {by_id.get((i, lang)) for i, _ in hits}
        cur.discard(None)
        if cur:
            wrong.append(f"'{t}'→'{sorted(cur)[0]}'{('(' + where[t].lstrip(' ·') + ')') if t in where else ''}")
        else:
            miss.append(t)
    tail = f' · 사전에 없는 문구 {len(unknown)}건' if unknown else ''
    if wrong:
        return 'FAIL', f'{lang} 화면에 다른 언어 문구 {len(wrong)}건: {", ".join(wrong[:12])}{tail}' + (f' · AS-IS 동일 고정 라벨 {len(fixed)}건: {", ".join(fixed[:6])}' if fixed else '')
    if fixed:
        return '판정필요', f'{lang} 화면 한글 고정 라벨 {len(fixed)}건 — AS-IS 메타(SCM_MST_SHEET_COLUMNS)도 같은 한글 문자열(LBL 코드 아님 · AS-IS 와 동일): {", ".join(fixed[:8])}{tail} — 사용자 결정: {lang} 문구 등록(메타 라벨→LBL 코드) 또는 설계 결정(검사 대상 제외)'
    if miss:
        return 'ERROR', f'[확인 대상] {lang} 번역 미등록 {len(miss)}건: {miss[:6]}{tail}'
    return 'PASS', f'{lang} 문구 {ok}건 일치{tail}'


def selftest():
    for nm, by, want in (('조회 버튼 정상', {'KO': ['Search(F5)'], 'EN': ['Search(F5)']}, 'PASS'), ('기본값 폴백', {'KO': ['Search'], 'EN': ['Search(F5)']}, 'FAIL'), ('버튼 못 찾음', {'KO': ['X'], 'EN': ['Search(F5)']}, 'ERROR'), ('조회 없음 · 메타 미확인', {'KO': ['X']}, 'ERROR'),
                          ('버튼 문구 0건', {}, 'ERROR'), ('버튼 목록 모두 빈 값', {'KO': [], 'EN': []}, 'ERROR')):
        got = judge_search_btn(by)[0]
        print(f"{'OK ' if got == want else 'NG '} {nm} → {got}(기대 {want})")
        if got != want:
            return 1
    for nm, hs, want in (('조회 없음 · 메타 SEARCH 없음', False, 'NA'), ('조회 없음 · 메타 SEARCH 있음', True, 'ERROR')):
        got = judge_search_btn({'KO': ['X']}, hs)[0]
        print(f"{'OK ' if got == want else 'NG '} {nm} → {got}(기대 {want})")
        if got != want:
            return 1
    bt = {'저장': {('L1', 'KO')}, 'Save': {('L1', 'EN')}, '保存': {('L1', 'CN')}, '삭제': {('L2', 'KO')}}
    bi = {('L1', 'KO'): '저장', ('L1', 'EN'): 'Save', ('L1', 'CN'): '保存', ('L2', 'KO'): '삭제'}
    cases = [('영어 정상', judge('EN', ['Save'], [], bt, bi), 'PASS'), ('영어에 한글', judge('EN', ['Save', '조회'], [], bt, bi), 'FAIL'), ('다른 언어 문구', judge('CN', ['Save'], [], bt, bi), 'FAIL'), ('번역 미등록', judge('KO', ['Save'], [], {'Save': {('L9', 'EN')}}, {('L9', 'EN'): 'Save'}), 'ERROR'), ('폴백', judge('EN', ['Save'], ['_x'], bt, bi), 'FAIL'), ('수집 0', judge('EN', [], [], bt, bi), 'ERROR'), ('사전 밖', judge('EN', ['Save', 'XYZ'], [], bt, bi), 'PASS'), ('단축키 표기', judge('EN', ['Save(F7)'], [], bt, bi), 'PASS'), ('끝 점', judge('EN', [norm('Save.')], [], bt, bi), 'PASS')]
    # T580 자유 입력 문자 칸 제외(SCP0005 SHIPPING_COMPANY O · 컨트롤 없음 / FROM_CITY_NAME S 잠금 명칭)
    fr = free_text_cols('SCP0005', [{'column_name': 'SHIPPING_COMPANY', 'input_tp_cd': 'O', 'cell_control_object_type_code': '', 'sheet_name': 'Distribution Route'},
                                    {'column_name': 'FROM_CITY_NAME', 'input_tp_cd': 'S', 'cell_control_object_type_code': 'FPText', 'sheet_name': 'Distribution Route'},
                                    {'column_name': 'FROM_COUNTRY', 'input_tp_cd': 'O', 'cell_control_object_type_code': 'FPTextModal', 'sheet_name': 'Distribution Route'}])
    cases += [('입력 문자 칸 한글만', judge_data('EN', {'SHIPPING_COMPANY': 6}, 8076, fr), 'PASS'), ('잠금 명칭 칸 한글', judge_data('EN', {'FROM_CITY_NAME': 3, 'SHIPPING_COMPANY': 6}, 8076, fr), 'ERROR'),
              ('모달 코드 칸은 입력 문자 칸 아님', judge_data('EN', {'FROM_COUNTRY': 1}, 10, fr), 'ERROR'), ('한글 0', judge_data('EN', {}, 10, fr), 'PASS'), ('조회 0행', judge_data('EN', {'SHIPPING_COMPANY': 1}, 0, fr), 'ERROR')]
    bad = 0
    for n, got, want in cases:
        k = got[0] == want
        bad += 0 if k else 1
        print(f"{'OK ' if k else 'NG '} {n} → {got[0]}(기대 {want}) {got[1]}")
    print(f'{len(cases) - bad}/{len(cases)}')
    return 1 if bad else 0


# 2026-11-25 T580(SCP0005 I2 EG-2037a747·EG-60363cec EN·CN 데이터 '[확인 대상] 그리드 칸 한글 SHIPPING_COMPANY 6행'): 메타상 사용자가 직접 입력해 그대로 저장하는
#   문자 칸(TO-BE SCM_MST_SHEET_COLUMNS INPUT_TP_CD O/M/IO/IM · 셀 컨트롤 없음/FPText/FPTextBox)의 한글은 입력 데이터라 명칭 언어 미반영 근거가 아니다.
#   그런 칸은 대상에서 빼고 사유를 증거에 남긴다. 코드로 찾아 채우는 명칭 칸(INPUT_TP_CD S 잠금 · FPTextModal 등)은 그대로 대상
FREE_INPUT = {'O', 'M', 'IO', 'IM'}
FREE_CTRL = {'', 'FPTEXT', 'FPTEXTBOX'}


def free_text_cols(mid, rows=None):
    """mid 화면 메타에서 편집 가능한 자유 입력 문자 칸 → {컬럼: '시트 INPUT_TP_CD 컨트롤'} · rows = 시험용 메타 행(없으면 Doc/tobefacts/db/sheet_columns.csv)"""
    if rows is None:
        rows = []
        fp = os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'sheet_columns.csv')
        if os.path.exists(fp):
            with open(fp, encoding='utf-8-sig', newline='') as f:
                rows = [r for r in csv.DictReader(f) if (r.get('program_id') or '').upper() == mid]
    out = {}
    for r in rows:
        ctl = (r.get('cell_control_object_type_code') or '').strip()
        if (r.get('input_tp_cd') or '').strip().upper() in FREE_INPUT and ctl.upper().replace('-', '') in FREE_CTRL:
            out.setdefault((r.get('column_name') or '').upper(), f"{r.get('sheet_name', '')} {r.get('input_tp_cd', '')} {ctl or '컨트롤 없음(문자)'}")
    return out


def judge_data(lang, ko_cells, grid_rows, free):
    """언어 전환 뒤 그리드 칸 한글 — free(자유 입력 문자 칸)는 빼고 본다(T580)"""
    ko_cells = ko_cells or {}
    skip = {k: v for k, v in ko_cells.items() if k.upper() in free}
    rest = {k: v for k, v in ko_cells.items() if k.upper() not in free}
    note = (' · 제외(사용자 입력 문자 칸 · 메타 ' + ', '.join(f'{k} {v}행 = {free[k.upper()]}' for k, v in list(skip.items())[:6]) + ' · T580)') if skip else ''
    if rest:
        return 'ERROR', '[확인 대상] 그리드 칸 한글 ' + ', '.join(f'{k} {v}행' for k, v in list(rest.items())[:8]) + ' — 명칭 칸이면 언어 미반영' + note
    if grid_rows and grid_rows > 0:
        return 'PASS', f'그리드 {grid_rows}행 · 명칭 대상 칸 한글 0(앞 200행){note}'
    return 'ERROR', f'[측정 경로 없음] 언어 전환 뒤 조회 {grid_rows or 0}행 — 언어 조회 실패 여부 확인 필요{note}'


def judge_search_btn(by_lang, has_search=None):
    """언어별 버튼 문구 — 조회 버튼이 미등록 코드 기본값 'Search' 로 나오면 FAIL (EG333)
       2026-11-26 개선안 20261126115652_SELF_5(R236): 버튼 문구를 하나도 읽지 못하면 ERROR [측정 경로 없음].
       해당없음은 메뉴 버튼 메타(SCM_ADM_MNU_BTN_MPG_M)에 SEARCH 가 없다고 확인한 때만(has_search False). None = 메타 미확인"""
    if not by_lang or not any(bs for bs in by_lang.values()):
        return 'ERROR', f"[측정 경로 없음] 언어별 버튼 문구 0건(언어 {len(by_lang or {})}개) — 조회 버튼 여부를 잴 수 없음"
    found = {l: [b for b in bs if re.match(r'^(search|조회|查询)', b.strip(), re.I)] for l, bs in by_lang.items()}
    if not any(found.values()):
        if has_search is False:
            return 'NA', '조회 버튼 없음(메뉴 버튼 메타 SCM_ADM_MNU_BTN_MPG_M 에 SEARCH 없음)'
        return 'ERROR', ('[확인 대상] 메뉴 버튼 메타에 SEARCH 가 있는데 화면 버튼에서 조회 문구를 못 찾음' if has_search else '[측정 경로 없음] 화면 버튼에서 조회 문구를 못 찾았고 메뉴 버튼 메타 SEARCH 여부 미확인') + f' — 읽은 버튼 {sum(len(v) for v in by_lang.values())}건'
    miss = [l for l, v in found.items() if not v]
    if miss:
        return 'ERROR', f'[확인 대상] {miss} 에서 조회 버튼 문구를 못 찾음 — {found}'
    bad = [l for l, v in found.items() if any(b.strip().lower() == 'search' for b in v)]
    if bad:
        return 'FAIL', f"{bad} 조회 버튼이 기본값 'Search' — 라벨 코드 미등록 폴백"
    return 'PASS', '조회 버튼 ' + ' · '.join(f'{l} {v[0]}' for l, v in found.items())


def main(mid):
    p = os.path.join(ROOT, 'Doc', 'verify', mid, 'lang_texts.json')
    if not os.path.exists(p):
        print(f'[i18n_lang] {mid}: lang_texts.json 없음 — 생략')
        return 0
    d = json.load(open(p, encoding='utf-8'))
    from dbconn import connect
    by_text, by_id = {}, {}
    with connect('tobe') as cx:
        cur = cx.cursor()
        cur.execute('select msg_id, lang_cd, msg_nm from SCM_ADM_MSG_M')
        for i, l, t in cur.fetchall():
            if t:
                n = norm(t)
                by_text.setdefault(n, set()).add((i, l))
                by_id[(i, l)] = n
        # 위치 설명용 — 이 화면 메타(SCM_MST_SHEET_COLUMNS)의 컬럼 라벨·다단 헤더 라벨 → 시트·컬럼 ID (라벨이 LBL 코드가 아니라 문자열로 들어간 칸을 짚기 위해)
        has_search = None   # 메뉴 버튼 메타 SEARCH 여부(조회 실패 = None 미확인)
        try:
            cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = :m AND MNU_BTN_CD = 'SEARCH'", m=mid)
            has_search = cur.fetchone()[0] > 0
        except Exception as e:
            print(f'[i18n_lang] {mid}: 메뉴 버튼 메타 조회 실패({str(e)[:80]}) — 조회 버튼 해당없음 판정 안 함')
        col_of = {}
        try:
            cur.execute("select sheet_name, column_name, column_label_name, small_class_label_name, large_class_label_name from SCM_MST_SHEET_COLUMNS where program_id = :p", p=mid)
            for sh, cn, lb, sm, lg in cur.fetchall():
                for v, kind in ((lb, '컬럼 라벨'), (sm, '헤더 소분류'), (lg, '헤더 대분류')):
                    if v:
                        col_of.setdefault(norm(v), []).append(f'{sh}.{cn} {kind}')
        except Exception as e:
            print(f'[i18n_lang] {mid}: 컬럼 메타 조회 실패({str(e)[:80]}) — 위치 설명 생략')
    # 2026-11-07 T138(SCP0084 I2 EN): AS-IS 메타(Doc/asisfacts/screens/<ID>/dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv)에도 같은 한글 문자열 라벨이면 AS-IS 와 동일 → FAIL 이 아니라 판정필요
    asis_fixed = set()
    _am = os.path.join(ROOT, 'Doc', 'asisfacts', 'screens', mid, 'dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv')
    if os.path.exists(_am):
        try:
            with open(_am, encoding='utf-8-sig', newline='') as f:
                for r in csv.DictReader(f):
                    for k in ('COLUMN_LABEL_NAME', 'SMALL_CLASS_LABEL_NAME', 'LARGE_CLASS_LABEL_NAME'):
                        v = norm(r.get(k) or '')
                        if v and KO.search(v) and v in col_of:
                            asis_fixed.add(v)
        except Exception as e:
            print(f'[i18n_lang] {mid}: AS-IS 메타 라벨 읽기 실패({str(e)[:80]}) — 고정 라벨 판정 생략')
    res = []
    free_cols = free_text_cols(mid)  # T580
    for lang, x in d.items():
        if x.get('why'):
            res.append({'lang': lang, 'result': 'ERROR', 'why': f"[측정 경로 없음] {x['why']}"})
            continue
        where = {}
        for kind, arr in (('조회조건·화면 라벨', x.get('labels') or []), ('그리드 헤더', x.get('headers') or []), ('버튼', x.get('buttons') or [])):
            for t in arr:
                n = norm(t)
                if n and n not in where:
                    cols = col_of.get(n) or []
                    where[n] = kind + (f" = 메타 {', '.join(sorted(set(cols))[:3])}(SCM_MST_SHEET_COLUMNS 라벨이 문자열 — LBL 코드 아님)" if cols and KO.search(n) else (f" = 메타 {', '.join(sorted(set(cols))[:3])}" if cols else ''))
        r, why = judge(lang, (x.get('labels') or []) + (x.get('headers') or []) + (x.get('buttons') or []), x.get('untr') or [], by_text, by_id, where, asis_fixed)
        res.append({'lang': lang, 'result': r, 'why': why})
        if lang != 'KO':  # EG363 데이터 자체가 한글일 수 있어 확인 대상 · 행이 없으면 한글 0 은 근거가 아니다(2026-11-02 DMF0005 CN 의심) · T580 자유 입력 문자 칸 제외
            r2, why2 = judge_data(lang, x.get('koCells'), x.get('gridRows') or 0, free_cols)
            res.append({'lang': lang + ' 데이터', 'result': r2, 'why': why2})
    _bl = {l: x.get('buttons') or [] for l, x in d.items() if not x.get('why')}
    if d:
        r, why = judge_search_btn(_bl, has_search)
        res.append({'lang': '조회 버튼', 'result': r, 'why': why})
    with open(os.path.join(ROOT, 'Doc', 'verify', mid, 'i18n_lang.csv'), 'w', encoding='utf-8-sig', newline='') as f:
        w = csv.DictWriter(f, fieldnames=COLS)
        w.writeheader()
        w.writerows(res)
    print(f'[i18n_lang] {mid}: ' + ' / '.join(f"{x['lang']} {x['result']} {x['why'][:160]}" for x in res))
    return 0


if __name__ == '__main__':
    sys.exit(selftest() if sys.argv[1] == '--selftest' else main(sys.argv[1].upper()))
