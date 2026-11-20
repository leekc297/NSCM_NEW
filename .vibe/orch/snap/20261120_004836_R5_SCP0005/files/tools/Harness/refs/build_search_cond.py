# -*- coding: utf-8 -*-
"""조회조건 기준표(xlsx) → 하네스 기계판독 CSV + Vibe_Manager 참고자료 MD

  python tools/Harness/refs/build_search_cond.py [--scp <SCP xlsx>] [--ssp <SCP_DM_SSP xlsx>]

  원천(2026-10-23 사용자 지시):
    SCP = 'SCP_화면별 조회조건 정리_260731_v0.5.xlsx'  — 조회조건 RULE(정렬원칙·명칭 통일·팝업 통일·To-Do) + SCP 화면별(List 의 Lv0=SCP)
    SSP = 'SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx' — SSP 화면별(List 의 Lv0=SSP 만 추출)
  산출:
    tools/Harness/rules/search_cond.csv        — gen.js(조회조건 순서·사용여부·To-Be 명칭) / check.js SC1·SC2 가 읽음
    tools/VibeManager/rules/40_SEARCH_COND.md  — 사람·Claude 가 읽는 참고자료(룰 + 화면별 표)
  xlsx 행 순서 = To-Be 조회조건 순서(‘순서 변경’ 표기 행은 이미 재배치된 위치). 원문 값은 가공 없이 보존하고,
  판정 열(usage/tobe_seq/group)만 추가한다. 판정 근거·이상 행은 MD §3 에 전부 기록(누락 0).
"""
import argparse, csv, os, re, sys, collections, datetime
import openpyxl

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
ap = argparse.ArgumentParser()
ap.add_argument('--scp', default=r'C:\TRANFILE\RECEIVE\SCP_화면별 조회조건 정리_260731_v0.5.xlsx')
ap.add_argument('--ssp', default=r'C:\TRANFILE\RECEIVE\SCP_DM_SSP 화면별 조회조건 정리_260731_(1차 완료).xlsx')
ap.add_argument('--csv', default=os.path.join(ROOT, 'tools', 'Harness', 'rules', 'search_cond.csv'))
ap.add_argument('--md', default=os.path.join(ROOT, 'tools', 'VibeManager', 'rules', '40_SEARCH_COND.md'))
a = ap.parse_args()

S = lambda v: '' if v is None else str(v).strip()
TYPE1 = {'선택', '텍스트', '버튼', '체크박스', '라디오버튼'}
# List 시트 열(헤더 2~3행): B=Lv0 … F=Lv4 · G~N As-Is 8열 · O 공백 · P~Y(Z) To-Be
AS_COLS = ['asis_name', 'asis_type1', 'asis_type2', 'asis_func', 'asis_popup_name', 'asis_popup_code', 'asis_required', 'asis_note']
TB_COLS = ['tobe_name', 'tobe_type1', 'tobe_type2', 'tobe_func', 'tobe_popup_code', 'tobe_required', 'tobe_note', 'changed', 'change', 'review', 'div_reset']
anomalies = []


def read_list(path, domain):
    wb = openpyxl.load_workbook(path, data_only=True)
    ws = wb['List']
    hdr = [S(c.value) for c in ws[3]]
    has_div_reset = any('Div 변경' in h for h in hdr)
    out = []
    for ri, row in enumerate(ws.iter_rows(min_row=4, values_only=True), start=4):
        v = [S(x) for x in row] + [''] * 30
        if v[1] != domain:
            continue
        rec = {'domain': domain, 'src_file': os.path.basename(path), 'src_row': ri, 'lv1': v[2], 'lv2': v[3], 'screen': v[4], 'scope': v[5]}
        rec.update(dict(zip(AS_COLS, v[6:14])))
        tb = v[15:26]
        # To-Be 블록 1칸 밀림(P 공란 + Q 에 명칭) — 원문 실측(SSP 'Including Past Period' 등). 값은 보존, 위치만 보정하고 기록
        if not tb[0] and tb[1] and tb[1] not in TYPE1 and tb[2] in TYPE1:
            anomalies.append(f"{domain} {os.path.basename(path)} {ri}행 [{v[4]}] '{tb[1]}' — To-Be 블록이 1칸 오른쪽에 기재 → 왼쪽으로 보정")
            tb = tb[1:] + ['']
        rec.update(dict(zip(TB_COLS, tb)))
        if not has_div_reset:
            rec['div_reset'] = ''
        if not rec['asis_name'] and not rec['tobe_name']:
            n_same = sum(1 for x in out if x['screen'] == v[4])
            anomalies.append(f"{domain} {os.path.basename(path)} {ri}행 [{v[4]}] As-Is·To-Be 명칭 모두 공란 — 제외" + ('' if n_same else ' (이 화면은 메뉴 행만 있고 조회조건 미기재 → 기준표 적용 대상 아님)'))
            continue
        for k in list(rec):
            if isinstance(rec[k], str):
                rec[k] = rec[k].replace('\r', '').replace('\n', ' ⏎ ')
        out.append(rec)
    return out, wb


# ── 사용여부 판정 (변경내용·To-Be 명칭 원문 기준. 우선순위 = 표 순서) ──
def usage_of(r):
    ch, tn, rv = r['change'], r['tobe_name'], r['review']
    if 'Sun-Set 검토' in ch: return 'SUNSET_REVIEW', '메뉴 Sun-Set 검토'
    if 'Sun-Set' in ch: return 'SUNSET', '메뉴 Sun-Set'
    if '미전환' in ch: return 'NOT_MIGRATED', ch
    if '조회조건 삭제' in ch: return ('MERGED', f"'{tn}' 로 통합") if tn and tn != '-' and ('통합' in rv) else ('DROP', '조회조건 삭제')
    if ch in ('제거', '삭제'): return 'DROP', ch
    if '버튼영역 이동' in ch: return 'BUTTON_AREA', '조회조건 영역 → 버튼 영역'
    if '달력기능에 포함' in ch: return 'IN_CALENDAR', '기간 달력 기능으로 흡수(W26/W52 등)'
    if '컬럼 개인화' in ch: return 'COLUMN_PERSONAL', '컬럼 개인화(공통) 기능으로 대체'
    if '하단에 공통' in ch: return 'COMMON_BUTTON', '하단 공통 버튼'
    if '공통기능화 검토' in ch: return 'COMMON_REVIEW', '공통 기능화 검토 — 확정 전'
    if '용도 재확인' in ch: return 'REVIEW', '용도 재확인'
    if not tn or tn == '-': return 'REVIEW', 'To-Be 명칭 공란(판정 근거 없음)'
    if r['tobe_type1'] == '버튼': return 'BUTTON', '조회조건 영역 버튼(유지)'
    return 'USE', ''


# ── 조회조건 정렬원칙 그룹 (시트 '조회조건 정렬원칙' 예시 + 동일 성격 명칭) ──
GROUPS = [
    (1, '데이터 기준', ['Div', 'Div.', 'Plan Date', 'Plan Type', 'Plan Version', 'Ver.', 'Version', 'Seq.', 'Seq', 'Company', 'Data Type', 'Version Type', 'Plan Data']),
    (2, '조직·거점·공정', ['Plan Group', 'Operation Group', 'Operation group', 'Operation', 'SCM Site', 'Site', 'From Site', 'To Site', 'Plant Site', 'Plant', 'Plant/Vendor', 'Building', 'Line', 'Sales Site', 'Team', 'Warehouse', 'Biz. Type', 'Line Type']),
    (3, '제품·대상', ['PJT', 'Model/Nickname', 'Model', 'Nick Name', 'Material', 'Electrode', 'Cell Type', 'Cell Type Gr', 'Item Type', 'Material Type', 'Item', 'Parent Item', 'Child Item', 'Class1', 'Class2', 'Class ID', 'Class Name', 'Category', 'Model Attribute', 'Sold To Party', 'Ship to Party', 'Customer', 'Box ID', 'Lot ID', 'SO No', 'Confirm Id', '관리번호']),
    (4, '기간·집계', ['Period', 'Month', 'From/To Date', 'Bucket', 'Inventory Date', 'Cutoff Date', 'Shipment Date', 'Request Date', 'DOW', 'Day of the week', 'Sum', 'Year', 'Week']),
    (5, '상태·표시', ['Active', 'Status', 'Unit', 'UOM', 'Search Level', '조회구분', 'Type', 'Total PSI', 'Including Past Period', 'OSP', 'BOD Item Active', 'Detail', 'Inventory Type', 'Change Type']),
]
GNORM = lambda s: re.sub(r'[^0-9a-z가-힣]', '', s.lower())
GMAP = {GNORM(n): (g, gn) for g, gn, names in GROUPS for n in names}
def group_of(name):
    return GMAP.get(GNORM(name), (0, '미분류'))


CHAINS = [['fromsite', 'tosite'], ['plantsite', 'building', 'line']]


def rule_sort(norm_names):
    """정렬원칙 RULE 적용 — 입력/출력 = GNORM 명칭(시트 순서). stable."""
    g_prev, keyed = 2, []
    for i, k in enumerate(norm_names):
        g = GMAP.get(k, (0, ''))[0] or g_prev
        g_prev = g
        keyed.append((g, 0 if k in ('div', 'div.') else 1, i, k))
    out = [k for *_, k in sorted(keyed)]
    for ch in CHAINS:  # 종속관계 고정: 체인 구성원이 뒤집혀 있으면 체인 순서로 자리 교환
        idx = [out.index(c) for c in ch if c in out]
        for slot, c in zip(sorted(idx), [c for c in ch if c in out]):
            out[slot] = c
    return out


def menu_index():
    """xlsx 메뉴 트리는 AS-IS 메뉴(TB_FX_MenuItemInfo) 기준 → ①AS-IS (상위메뉴, Title) → ProgramID → map_screen.csv(As-is≠To-Be ID)
    ②없으면 TO-BE menu.csv 메뉴명. 결과 ID 가 TO-BE menu.csv 에 있는지도 기록."""
    tobe = list(csv.DictReader(open(os.path.join(ROOT, 'Doc', 'tobefacts', 'db', 'menu.csv'), encoding='utf-8-sig')))
    tobe_ids = {r['mnu_id'].upper(): r for r in tobe}
    by_tobe = collections.defaultdict(list)
    for r in tobe:
        if r['mnu_tp_cd'] == 'SCREEN' and re.match(r'^(SCP|SSP|SCM)\d', r['mnu_id']):
            by_tobe[GNORM(r['mnu_desc'])].append(r)
    csv.field_size_limit(10 ** 8)
    asis = list(csv.DictReader(open(os.path.join(ROOT, 'Doc', 'asisfacts', 'db', 'meta', 'dbo.TB_FX_MenuItemInfo.csv'), encoding='utf-8-sig')))
    by_asis = collections.defaultdict(list)
    for r in asis:
        if r['ProgramID']:
            by_asis[GNORM(r['Title'])].append(r)
    ms = {r['asis_id'].upper(): r['tobe_id'].upper() for r in csv.DictReader(open(os.path.join(ROOT, 'tools', 'Harness', 'rules', 'map_screen.csv'), encoding='utf-8-sig')) if r['tobe_id']}
    return by_asis, by_tobe, tobe_ids, ms


def resolve_menu(key, idx):
    by_asis, by_tobe, tobe_ids, ms = idx
    _, lv1, lv2, name = key
    c = by_asis.get(GNORM(name), [])
    if len(c) > 1: c = [x for x in c if GNORM(x['PrntMenuID']) == GNORM(lv2)] or c
    if len(c) > 1: c = [x for x in c if x['UseYN'] == 'Y'] or c
    if len(c) == 1:
        aid = c[0]['ProgramID'].upper(); tid = ms.get(aid, aid)
        note = f"AS-IS 메뉴 {c[0]['PrntMenuID']}›{c[0]['Title']} = {aid}(UseYN={c[0]['UseYN']})" + (f" → map_screen {tid}" if tid != aid else '')
        return tid, aid, note + ('' if tid in tobe_ids else ' · TO-BE menu.csv 에 없음')
    t = by_tobe.get(GNORM(name), [])
    if len(t) == 1:
        return t[0]['mnu_id'].upper(), '', 'TO-BE menu.csv 메뉴명 일치'
    return '', '', (f"AS-IS 동명 {len(c)}건: {','.join(x['ProgramID'] for x in c)}" if c else 'AS-IS·TO-BE 메뉴에 같은 이름 없음')


def main():
    scp, wb_scp = read_list(a.scp, 'SCP')
    ssp, _ = read_list(a.ssp, 'SSP')
    allr = scp + ssp
    idx = menu_index()
    # 화면 → MENU_ID (resolve_menu). 미매핑은 MD §3 에 전부 기록
    screens = collections.OrderedDict()
    for r in allr:
        screens.setdefault((r['domain'], r['lv1'], r['lv2'], r['screen']), []).append(r)
    unmapped = []
    for key, rows in screens.items():
        mid, aid, how = resolve_menu(key, idx)
        if not mid:
            unmapped.append((key, how))
        # 조회 영역(area): SCP Lv4 = 같은 조회영역 안의 시트/탭 한정 표시(예 'Plant, Packer' · 'Excluded Item') → 화면 하나의 MAIN 영역.
        #   SSP Lv4 = 'Main' 과 상세 팝업/하위 화면(예 'Shipment Plan Detail' · 'Stock Detail') → Main/'-' 만 MAIN, 그 외는 별도 영역(순번 따로)
        seq = collections.Counter(); seen = collections.defaultdict(dict)
        for r in rows:
            r['menu_id'] = mid; r['asis_id'] = aid; r['menu_how'] = how
            r['area'] = 'MAIN' if key[0] == 'SCP' or r['scope'] in ('', '-', 'Main') else r['scope']
            r['usage'], r['usage_reason'] = usage_of(r)
            g, gn = group_of(r['tobe_name'] if r['usage'] in ('USE', 'MERGED', 'BUTTON') else r['asis_name'])
            r['order_group'] = str(g); r['order_group_name'] = gn
            # To-Be 순서: 영역 내 USE 행의 첫 등장 순서. 통합(MERGED)은 대상 명칭의 순서를 따른다
            if r['usage'] == 'USE':
                k = GNORM(r['tobe_name'])
                if k not in seen[r['area']]:
                    seq[r['area']] += 1; seen[r['area']][k] = seq[r['area']]
            r['tobe_seq'] = ''; r['tobe_order'] = ''
        for r in rows:
            if r['usage'] in ('USE', 'MERGED'):
                r['tobe_seq'] = str(seen[r['area']].get(GNORM(r['tobe_name']), ''))
        # 최종 순서(tobe_order) — 하네스가 쓰는 값
        #   SCP = 정렬원칙 RULE(§2.1): 그룹 1→5, Div. 맨 앞, 같은 그룹 안은 시트 순서 유지, 종속 체인 고정. 미분류(0)는 바로 앞 조건의 그룹에 붙음
        #   SSP = 시트 확정 순서(tobe_seq) 그대로
        for ar in seen:
            names = sorted(seen[ar], key=lambda k: seen[ar][k])
            if key[0] == 'SCP':
                names = rule_sort(names)
            pos = {k: i + 1 for i, k in enumerate(names)}
            for r in rows:
                r['tobe_order'] = str(pos[GNORM(r['tobe_name'])]) if r['area'] == ar and r['tobe_seq'] else r.get('tobe_order', '')
    # 같은 MENU_ID 가 SCP·SSP 양쪽 List 에 있으면(예: SSP0045 Shipment Request SEMI) ID 접두어와 같은 도메인 파일이 정본(primary=Y)
    dom_by_id = collections.defaultdict(set)
    for (d, *_), rows in screens.items():
        dom_by_id[rows[0]['menu_id']].add(d)
    dup_ids = []
    for (d, *_), rows in screens.items():
        mid = rows[0]['menu_id']
        prim = 'Y' if len(dom_by_id[mid]) == 1 or mid.startswith(d) or (not any(mid.startswith(x) for x in dom_by_id[mid]) and d == 'SCP') else 'N'
        if len(dom_by_id[mid]) > 1 and prim == 'Y': dup_ids.append(f"{mid} — {'·'.join(sorted(dom_by_id[mid]))} 양쪽 기재 → {d} 파일 행을 정본(primary=Y)으로 사용")
        for r in rows: r['primary'] = prim
    global DUP_IDS; DUP_IDS = dup_ids
    cols = ['domain', 'menu_id', 'primary', 'asis_id', 'lv1', 'lv2', 'screen', 'scope', 'area', 'tobe_order', 'tobe_seq', 'usage', 'usage_reason', 'order_group', 'order_group_name'] + AS_COLS + TB_COLS + ['menu_how', 'src_file', 'src_row']
    os.makedirs(os.path.dirname(a.csv), exist_ok=True)
    with open(a.csv, 'w', encoding='utf-8-sig', newline='') as fp:
        w = csv.DictWriter(fp, fieldnames=cols); w.writeheader()
        for r in allr: w.writerow({k: r.get(k, '') for k in cols})
    write_md(wb_scp, screens, unmapped, allr)
    cnt = collections.Counter(r['usage'] for r in allr)
    print(f"CSV {a.csv} — {len(allr)}행 (SCP {len(scp)} / SSP {len(ssp)}) · 화면 {len(screens)} · MENU_ID 미매핑 {len(unmapped)} · 이상행 {len(anomalies)}")
    print('usage', dict(cnt))
    for u in unmapped: print('  미매핑', u)


def md_cell(s):
    return (s or '').replace('|', '\\|')


def sheet_text(wb, name):
    out = []
    for row in wb[name].iter_rows(values_only=True):
        vals = [S(x) for x in row]
        if any(vals): out.append([x for x in vals])
    return out


def write_md(wb, screens, unmapped, allr):
    L = []
    P = L.append
    today = datetime.date.today().isoformat()
    P('# 조회조건 기준 — SCP·SSP (FE 생성 시 조회조건 순서·사용여부·명칭)')
    P('')
    P(f'> 생성: {today} · `python tools/Harness/refs/build_search_cond.py` 로 재생성(손편집 금지 — 원천 xlsx 를 고친 뒤 재실행).')
    P(f'> 원천: SCP = `{os.path.basename(a.scp)}` (RULE 시트 + List Lv0=SCP) · SSP = `{os.path.basename(a.ssp)}` (List Lv0=SSP 만 추출).')
    P('> 관계: 기존 카탈로그 `Doc/_rules_v2/_mapping/search_conditions_scp_dm.md`(v0.4 · SCP·DM · hook #112) 대비 **SCP·SSP 의 순서·사용여부·명칭은 본 문서가 우선**(룰 10_RULES_KEEP E11). DM 은 기존 카탈로그.')
    P('> 기계판독본: `tools/Harness/rules/search_cond.csv` — 하네스 gen.js 가 조회조건 **순서·사용여부·To-Be 명칭**에 적용하고, check.js SC1(순서)·SC2(제외 조건 잔존)가 검사한다.')
    P('')
    P('## 1. 하네스 적용 규칙 (요약)')
    P('')
    P('| 항목 | 규칙 |')
    P('|---|---|')
    P('| 대상 | 아래 §4 표에 MENU_ID 가 매핑된 SCP·SSP 화면. 표에 없는 화면/조건은 §2.1 정렬원칙 그룹 순서를 적용 |')
    P('| 순서 | 화면별 **하네스 적용 순서(tobe_order)**. **SCP = §2.1 정렬원칙 RULE**(그룹 1→5 · Div. 맨 앞 · 같은 그룹 안은 시트 행 순서 · From→To Site / Plant Site→Building→Line 고정 · 미분류는 앞 조건 그룹에 붙음). **SSP = 시트 행 순서(1차 완료 확정본)**. 같은 To-Be 명칭 여러 행(통합)은 첫 행 위치. 시트 원래 순서는 tobe_seq 로 보존 |')
    P('| 사용 | `USE` 만 조회조건으로 생성. `MERGED` 는 대상 조건 하나로 합침(예: Model + NickName → Model/Nickname) |')
    P('| 제외 | `DROP`·`SUNSET`·`NOT_MIGRATED` = 생성하지 않음(__asis-mapping__ 에 사유와 함께 기록 — AS-IS 근거는 남긴다) |')
    P('| 이동 | `BUTTON_AREA` = 조회조건 영역에서 빼고 버튼 영역(공통/화면 버튼)으로 · `IN_CALENDAR` = 기간 달력 기능에 포함 · `COLUMN_PERSONAL` = 컬럼 개인화 공통 기능 · `COMMON_BUTTON` = 하단 공통 버튼 |')
    P('| 보류 | `COMMON_REVIEW`·`REVIEW`·`SUNSET_REVIEW` = 확정 전 — AS-IS 그대로 생성하고 GEN_NOTES 에 “기준표 검토중” TODO |')
    P('| 명칭 | 라벨은 To-Be 명칭(§2.2 통일 규칙 반영본). LBL 코드는 기존 재사용·없으면 신규 채번(E5/i18n 규칙) |')
    P('| 유형 | To-Be 유형1(선택/텍스트/버튼/체크박스/라디오버튼)·유형2(단일/다중) · 기능(검색/팝업/달력) · 팝업구분 코드(§2.3) · 비고 `ALL버튼`(다중+ALL) / `ALL없음` |')
    P('| 필수 | To-Be 필수값 표기 우선, 없으면 As-Is 필수값(O) |')
    P('| Div 초기화 | `N` = Div. 변경 시 값 유지(초기화 안 함). 공란 = 기본 동작 |')
    P('')
    P('## 2. 조회조건 RULE (SCP 파일 원문)')
    P('')
    P('### 2.1 조회조건 정렬원칙 (시트 `조회조건 정렬원칙`)')
    P('')
    rows = sheet_text(wb, '조회조건 정렬원칙')
    tbl = [r for r in rows if r[1:2] and re.match(r'^\d\.', r[1] or '')]
    P('| 그룹 | 검색조건 성격 | 예시 |'); P('|---|---|---|')
    for r in tbl: P(f'| {md_cell(r[1])} | {md_cell(r[2])} | {md_cell(r[3])} |')
    P('')
    P('**규칙**')
    started = False
    for r in rows:
        t = ' '.join(x for x in r if x)
        if t.strip() == '규칙': started = True; continue
        if started: P(f'- {t}')
    P('')
    P('> 하네스 그룹 사전(표에 없는 조건 배치용): ' + ' · '.join(f"{g}.{gn}=[{', '.join(n)}]" for g, gn, n in GROUPS))
    P('')
    P('### 2.2 명칭 통일 (시트 `Group, Type`)')
    P('')
    P('| 사용 | As-Is 명칭 | 개수 | 예시 | To-Be 규칙 |'); P('|---|---|---|---|---|')
    gt = sheet_text(wb, 'Group, Type')
    right = []
    for r in gt[1:]:
        r = r + [''] * 12
        if r[1] and r[1] != 'As-Is 명칭': P(f'| {md_cell(r[0])} | {md_cell(r[1])} | {md_cell(r[2])} | {md_cell(r[3])} | {md_cell(r[4])} |')
        if r[6] and r[6] != 'As-Is 명칭': right.append(r[5:10])
    P('')
    P('| 사용 | As-Is 명칭(Group 계열) | 개수 | 예시 | To-Be 규칙 |'); P('|---|---|---|---|---|')
    for r in right: P(f'| {md_cell(r[0])} | {md_cell(r[1])} | {md_cell(r[2])} | {md_cell(r[3])} | {md_cell(r[4])} |')
    P('')
    P('> 시트 `Sheet2` 는 As-Is(133)·To-Be(96) 명칭을 **각각 중복 제거한 독립 목록**(행끼리 짝이 아님 — 예: As-Is `Model` 옆이 To-Be `Period`). 대응 관계는 §4 화면별 표(행 단위)가 정본.')
    P('')
    P('### 2.3 팝업 통일 (시트 `팝업 비교`)')
    P('')
    for r in sheet_text(wb, '팝업 비교'):
        for x in r:
            if x and x.startswith('- '): P(f'  {x}')
            elif x and ('통일' in x or x.startswith('<용어>') or x.startswith('<팝업>')): P(f'- {x}')
    P('')
    P('| 팝업구분 코드 | 의미(시트 배치 기준) |'); P('|---|---|')
    for code, mean in [('모1·모2·모3', 'Model by DivisionPopup 양식 변형 (모3 = DM 통일 양식)'), ('메1', 'Material by Division Popup — **SCP Model/Material 통일 양식**'), ('프1·프2', 'Project by Division (프2 로 통일)'), ('오1', 'Owner by DivisionPopup'), ('아1·아2', 'Item by DivisionPopup (유지)'), ('버1·버2', 'Version Popup (유지)'), ('버세1', 'VersionBySalesPrice Popup'), ('세1', 'Sales Report Popup')]:
        P(f'| {code} | {mean} |')
    P('')
    P('### 2.4 To-Do (SCP 파일 원문 — 확정 전 검토 과제)')
    P('')
    for r in sheet_text(wb, 'To-Do'):
        t = ' '.join(x for x in r if x)
        s = t.strip()
        if re.match(r'^\d+\)', s): P(f'    - {s}')
        elif t.startswith((' ', '-', '(')): P(f'  {t}')
        else: P(f'- {t}')
    P('')
    P('## 3. 판정·매핑 근거와 이상 행 (누락 0 확인용)')
    P('')
    cnt = collections.Counter((r['domain'], r['usage']) for r in allr)
    P('| 구분 | ' + ' | '.join(u for u in ['USE', 'MERGED', 'BUTTON', 'BUTTON_AREA', 'IN_CALENDAR', 'COLUMN_PERSONAL', 'COMMON_BUTTON', 'DROP', 'SUNSET', 'SUNSET_REVIEW', 'NOT_MIGRATED', 'COMMON_REVIEW', 'REVIEW']) + ' | 계 |')
    P('|---' * 15 + '|')
    for d in ('SCP', 'SSP'):
        vals = [cnt[(d, u)] for u in ['USE', 'MERGED', 'BUTTON', 'BUTTON_AREA', 'IN_CALENDAR', 'COLUMN_PERSONAL', 'COMMON_BUTTON', 'DROP', 'SUNSET', 'SUNSET_REVIEW', 'NOT_MIGRATED', 'COMMON_REVIEW', 'REVIEW']]
        P(f'| {d} | ' + ' | '.join(str(v) for v in vals) + f' | {sum(vals)} |')
    P('')
    P('사용여부 판정식(변경내용 원문 → usage): `Sun-Set 검토`→SUNSET_REVIEW · `Sun-Set`→SUNSET · `미전환`→NOT_MIGRATED · `조회조건 삭제`→MERGED(추가검토에 ‘통합’)/DROP · `제거`·`삭제`→DROP · `버튼영역 이동`→BUTTON_AREA · `달력기능에 포함`→IN_CALENDAR · `컬럼 개인화`→COLUMN_PERSONAL · `하단에 공통`→COMMON_BUTTON · `공통기능화 검토`→COMMON_REVIEW · `용도 재확인`→REVIEW · To-Be 명칭 공란→REVIEW · To-Be 유형1=버튼→BUTTON · 그 외 USE.')
    P('')
    P(f'**MENU_ID 미매핑 {len(unmapped)} 화면** (하네스 자동 적용 제외 — menu.csv 에 메뉴가 생기거나 이름이 맞으면 재생성 시 자동 연결):')
    P('')
    for key, how in unmapped: P(f'- {key[0]} / {key[1]} / {key[2]} / **{key[3]}** — {how}')
    P('')
    P(f'**양쪽 파일 중복 화면 {len(DUP_IDS)}건**:')
    P('')
    for x in DUP_IDS: P(f'- {x}')
    P('')
    P(f'**원문 이상 행 {len(anomalies)}건** (값 보존 · 위치만 보정 또는 제외):')
    P('')
    for x in anomalies: P(f'- {x}')
    P('')
    P('## 4. 화면별 조회조건 (To-Be 순번 순 · 원문 행 순서)')
    P('')
    P('열: **#**=하네스 적용 순서(tobe_order) · **시트#**=시트 행 순서(tobe_seq) · **사용**=usage · **범위**=Lv4(시트/탭 한정, `-`=화면 전체) · As-Is(명칭/유형/기능/팝업/필수/비고) → To-Be(명칭/유형/기능/팝업구분/필수·ALL/비고) · 변경내용 · 추가검토 · Div초기화')
    for d in ('SCP', 'SSP'):
        P('')
        P(f'### 4.{1 if d == "SCP" else 2} {d} ({sum(1 for k in screens if k[0] == d)} 화면)')
        for key, rows in screens.items():
            if key[0] != d: continue
            mid = rows[0]['menu_id'] or '(MENU_ID 미매핑)'
            P('')
            P(f'#### {mid} · {key[3]}  <sub>{key[1]} › {key[2]}{"" if rows[0]["primary"] == "Y" else " · 참고본(정본은 다른 파일)"}</sub>')
            P('')
            P(f'매핑: {rows[0]["menu_how"]} · 원천 {rows[0]["src_file"]} {rows[0]["src_row"]}~{rows[-1]["src_row"]}행')
            areas = list(collections.OrderedDict.fromkeys(r['area'] for r in rows))
            for ar in areas:
                uses = sorted({(int(r['tobe_seq']), r['tobe_name']) for r in rows if r['tobe_seq'] and r['area'] == ar})
                final = sorted({(int(r['tobe_order']), r['tobe_name']) for r in rows if r['tobe_order'] and r['area'] == ar})
                grp = [group_of(n)[0] for _, n in uses]
                viol = [f"{uses[i][1]}(그룹{grp[i]}) 가 {uses[i - 1][1]}(그룹{grp[i - 1]}) 뒤" for i in range(1, len(grp)) if grp[i] and grp[i - 1] and grp[i] < grp[i - 1]]
                tag = '' if ar == 'MAIN' else f' [영역: {ar}]'
                P('')
                P(f'**하네스 적용 순서{tag}**: ' + (' → '.join(f'{s}.{n}' for s, n in final) or '(없음)') + (' — 정렬원칙 RULE 적용' if d == 'SCP' else ' — 시트 확정 순서'))
                if d == 'SCP':
                    P('')
                    P('시트 행 순서: ' + (' → '.join(f'{s}.{n}' for s, n in uses) or '(없음)') + ' · 원칙 대비: ' + ('일치' if not viol else '차이 — ' + ' · '.join(viol)))
                else:
                    P('')
                    P('정렬원칙 대비(참고): ' + ('일치' if not viol else '차이 — ' + ' · '.join(viol) + ' (SSP 는 시트 순서가 확정본)'))
            P('')
            P('| # | 시트# | 사용 | 범위 | As-Is 명칭 | As-Is 유형 | As-Is 기능·팝업 | As-Is 필수 | As-Is 비고 | To-Be 명칭 | To-Be 유형 | To-Be 기능·팝업 | 필수·ALL | To-Be 비고 | 변경내용 | 추가검토 | Div초기화 |')
            P('|---' * 17 + '|')
            for r in rows:
                P('| ' + ' | '.join(md_cell(x) for x in [
                    r['tobe_order'], r['tobe_seq'], r['usage'], r['scope'], r['asis_name'], '/'.join(x for x in [r['asis_type1'], r['asis_type2']] if x),
                    ' '.join(x for x in [r['asis_func'], r['asis_popup_name'], r['asis_popup_code']] if x), r['asis_required'], r['asis_note'],
                    r['tobe_name'], '/'.join(x for x in [r['tobe_type1'], r['tobe_type2']] if x), ' '.join(x for x in [r['tobe_func'], r['tobe_popup_code']] if x),
                    ' '.join(x for x in [r['tobe_required'], r['tobe_note'] if r['tobe_note'] in ('ALL버튼', 'ALL없음') else ''] if x), r['tobe_note'] if r['tobe_note'] not in ('ALL버튼', 'ALL없음') else '',
                    r['change'], r['review'], r['div_reset']]) + ' |')
    os.makedirs(os.path.dirname(a.md), exist_ok=True)
    open(a.md, 'w', encoding='utf-8').write('\n'.join(L) + '\n')
    print(f'MD {a.md} — {len(L)}줄')


if __name__ == '__main__':
    main()
