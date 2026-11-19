# -*- coding: utf-8 -*-
"""엔진 갭 전용 검사기(팝업 eg_popup · Division·권한 eg_auth) 결과 → 원장 행 + e2e_results 반입(2026-11-01)

  run_verify 의 E2E 뒤·judge 앞에 실행한다. 원장에 자리가 없으면 측정해도 CheckList 에 안 나온다(T8).
  python tools/Harness/verify/eg_ingest.py <MENU_ID> [--popup <폴더>] [--auth <폴더>]
  기본 폴더 = Doc/verify/<ID>/eg/popup · Doc/verify/<ID>/eg/auth

  판정 규칙
    - 측정 결과만 옮긴다. 결과 없는 화면은 행을 만들지 않고 그대로 끝낸다(행 없음 = 커버리지에서 미실행으로 보임)
    - 팝업 ORDER FAIL 중 ORDER BY 가 있는 경우 = 판정필요(사용자 결정: ORDER BY 없음만 FAIL · 정렬 기준 차이는 판정필요)
    - 한 번도 잴 수 없었던 ERROR 는 ERROR 그대로. 판정필요를 FAIL 로 올리지 않는다
    - 그 밖의 판정필요는 judge 가 기존 지시(A1 외 판정필요 금지)대로 수동 검수(W7) NA 로 돌린다 — 사유는 증거에 남는다
"""
import argparse, csv, hashlib, io, json, os, re, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import safe_io  # 2026-11-13 T284: 기존 파일 'w' 재열기 Errno 22(SCP0028 15:57) 대비 — safe_io(재시도 → r+b)

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
csv.field_size_limit(10 ** 8)

POPUP_RULE = {  # E02 integration.md §2-2 check → 규칙(첫 규칙을 원장 규칙으로 쓴다)
    'OPEN': 'M3', 'DATA': 'M3', 'ORDER': 'B3', 'TITLE': 'H5', 'IDENTITY': 'D5', 'BTN_ORDER': 'H6', 'NO_COL': 'H6', 'NO_WIDTH': 'H6', 'COUNT': 'H6', 'MERGE': 'H3',
    'COND_LIST': 'G4', 'COND_ENABLED': 'G4', 'COND_MULTI': 'B6', 'DIV_FIXED': 'G5', 'PERIOD': 'G5', 'FILTER_ARG': 'G5', 'TEXT_PASS': 'G5', 'CORNERS': 'G5',
    'PERIOD_BACK': 'M4', 'PICK_OK': 'M4', 'PICK_DBL': 'M4', 'SELECT_MODE': 'M4', 'FILTER_ROWS': 'G1', 'FILTER_LIKE': 'G1', 'FILTER_ALL': 'G1', 'FILTER_CASE': 'G8', 'FILTER_COMMA': 'G9',
    'GRID_SORT': 'K1', 'GRID_FILTER': 'K1', 'GRID_KEYS': 'K3', 'GRID_LOCK': 'D3', 'TOPLINE': 'H6', 'SECTION_TITLE': 'H6', 'DYN_COLS': 'A8', 'PICK_FORMAT': 'G7', 'PICK_SEARCH': 'G1',
    'CELL_NOEDIT': 'D1', 'CELL_DELETE': 'D1', 'CELL_PASTE': 'D1', 'CELL_TYPE': 'D5', 'CELL_ICON': 'D5', 'CELL_KEYIN': 'D5', 'TEXT_INPUT': 'D5', 'CELL_BADKEY': 'E7',
    'INSERT_POPUP': 'D4', 'INSERT_DIRECT': 'D4', 'INSERT_FILL': 'D4', 'SAVE_REQ': 'F1', 'SAVE_CLOSE': 'M4',
}
POPUP_PREFIX = [('GRID_FILTER', 'K1'), ('LAYOUT_', 'H4'), ('DRAG', 'H4'), ('RESIZE_', 'H4'), ('TS_', 'A5')]
AUTH_RULE = {  # E03 integration.md §2
    'EG007': 'A1', 'EG368': 'A1', 'EG022': 'A5', 'EG402': 'A5', 'EG024': 'A5', 'EG257': 'A5', 'EG032': 'A6', 'EG061': 'B4', 'EG067': 'B4', 'EG065': 'B5', 'EG086': 'B5',
    'EG109': 'D1', 'EG113': 'D1', 'EG123': 'D1', 'EG124': 'D1', 'EG126': 'D4', 'EG140': 'D4', 'EG319': 'D4', 'EG315': 'D4', 'EG271': 'G4', 'EG275': 'G4', 'EG294': 'G4',
    'EG365': 'J1', 'EG366': 'J1', 'EG367': 'J1', 'EG369': 'J2', 'EG373': 'J2', 'EG374': 'J2', 'EG372': 'J2', 'EG376': 'J3', 'EG377': 'J3', 'EG378': 'J3', 'EG380': 'J4', 'EG382': 'J4',
    'EG395': 'K2', 'EG411': 'K4', 'EG160': 'E3', 'EG212': 'F4', 'EG231': 'F7', 'EG242': 'F8',
}


def rid(mid, *parts):
    return 'EG-' + hashlib.md5('|'.join([mid] + [str(x) for x in parts]).encode('utf-8')).hexdigest()[:8]


def popup_rule(check):
    if check in POPUP_RULE:
        return POPUP_RULE[check]
    for pre, rule in POPUP_PREFIX:
        if check.startswith(pre):
            return rule
    return ''


# CR-100(2026-11-10 사용자 판정 · T178): TO-BE 메타 공통 셀 팝업(SCM_MST_SHEET_COLUMNS CELL_CONTROL_OBJECT_TYPE_CODE = FPModal·FPTextModal)은
#   TO-BE 팝업 룰을 따른다 — 제목 없음 · 조회 건수 표시 없음 · ↓ 키 행 이동 없음 은 결함이 아니다(SSP0024 MATERIAL_ID · SSP0025 ITEM_ID/USER_ID/PART_LEADER/TEAM_LEADER ·
#   SCP0037 ITEM_ID). 그 밖의 팝업 표준(버튼 순서 OK→CLOSE · No. 컬럼 · '_' 폴백/코드 노출 제목)은 종전대로 검사한다. 화면 고유 팝업(조회조건 돋보기 등)은 대상 아님.
CR100_TAG = '[CR-100]'
CR100_WHAT = {'TITLE': '팝업 제목 없음', 'COUNT': '조회 건수 표시 없음', 'GRID_KEYS': '↓ 키 행 이동 없음'}


def meta_modal_cols(mid):
    """TO-BE 메타에서 셀 팝업(FPModal·FPTextModal)인 컬럼 — eg_popup 이 쓰는 같은 메타 사본(Doc/verify/_parallel/E02/facts/<ID>.meta.json)"""
    p = os.path.join(ROOT, 'Doc', 'verify', '_parallel', 'E02', 'facts', f'{mid}.meta.json')
    try:
        with open(p, encoding='utf-8') as f:
            mj = json.load(f)
        return {c.get('COLUMN_NAME', '').upper() for c in mj.get('columns') or [] if re.search(r'FP(Text)?Modal', c.get('CELL_CONTROL_OBJECT_TYPE_CODE') or '', re.I)}
    except (OSError, ValueError):
        return set()


# 2026-11-10 T194·T195: TO-BE 공통 팝업 클래스(AS-IS 클래스명) — 셀·버튼 어느 트리거든 같은 공통 컴포넌트라 CR-100 을 트리거 무관 적용
#   UserInfoPopup(공통 사용자 선택 SsoUserModal · SSP0003 11·12번) · SCM0002_ItembyDivisionPopup(공통 Item 팝업 · 사용자 '동일 항목 공통 반영')
CR100_COMMON_POPUPS = {'UserInfoPopup', 'SCM0002_ItembyDivisionPopup'}


def cr100_hit(check, x, modal_cols):
    trig = str(x.get('trig') or '')
    user_pop = str(x.get('cls') or '') in CR100_COMMON_POPUPS
    # T194(SSP0003 11·12번 사용자 판정 '오류 아님'): UserInfoPopup 은 버튼으로 열어도 TO-BE 공통 팝업 룰 — 닫기(X) 아이콘 없음도 결함 아님(뷰포트 밖 버튼이 있으면 결함 유지)
    if user_pop and check == 'LAYOUT_VIEW':
        a = str(x.get('actual') or '')
        return '닫기 아이콘 false' in a and '밖 버튼 []' in a
    if check not in CR100_WHAT:
        return False
    if not user_pop and (not trig.upper().startswith('CELL:') or trig.split(':', 1)[1].strip().upper() not in modal_cols):
        return False
    if check == 'TITLE':  # 제목이 '없음'일 때만 — '_' 폴백·코드 노출 제목은 결함으로 남긴다
        return bool(re.search(r"제목 ''|제목 없음", str(x.get('actual') or '')))
    return True


def load(path):
    if not path or not os.path.exists(path):
        return []
    with open(path, encoding='utf-8') as f:
        d = json.load(f)
    return d if isinstance(d, list) else []


def main():
    ap = argparse.ArgumentParser(); ap.add_argument('menu'); ap.add_argument('--popup', default=''); ap.add_argument('--auth', default=''); a = ap.parse_args()
    mid = a.menu.upper(); vd = os.path.join(ROOT, 'Doc', 'verify', mid)
    pd = a.popup or os.path.join(vd, 'eg', 'popup'); ad = a.auth or os.path.join(vd, 'eg', 'auth')
    pop = load(os.path.join(pd, 'popup_results.json')); auth = load(os.path.join(ad, 'e2e.json'))
    sp = []
    _sp = os.path.join(vd, 'sp_branch.csv')
    if os.path.exists(_sp):
        with open(_sp, encoding='utf-8-sig', newline='') as f:
            sp = list(csv.DictReader(f))
    a1 = []
    _a1 = os.path.join(vd, 'a1_live.csv')
    if os.path.exists(_a1):
        with open(_a1, encoding='utf-8-sig', newline='') as f:
            a1 = list(csv.DictReader(f))
    dml = []
    _dml = os.path.join(vd, 'sp_dml.csv')
    if os.path.exists(_dml):
        with open(_dml, encoding='utf-8-sig', newline='') as f:
            dml = [x for x in csv.DictReader(f) if x.get('verdict') != 'FOUND']
    i18n = []
    _i18 = os.path.join(vd, 'i18n_static.csv')
    if os.path.exists(_i18):
        with open(_i18, encoding='utf-8-sig', newline='') as f:
            i18n = list(csv.DictReader(f))
    lk = []
    _lk = os.path.join(vd, 'lookup_check.csv')
    if os.path.exists(_lk):
        with open(_lk, encoding='utf-8-sig', newline='') as f:
            lk = list(csv.DictReader(f))
    sci = []
    _sc = os.path.join(vd, 'sort_ci.csv')
    if os.path.exists(_sc):
        with open(_sc, encoding='utf-8-sig', newline='') as f:
            sci = [x for x in csv.DictReader(f) if x.get('result') != 'NA']
    lg = []
    _lg = os.path.join(vd, 'i18n_lang.csv')
    if os.path.exists(_lg):
        with open(_lg, encoding='utf-8-sig', newline='') as f:
            lg = list(csv.DictReader(f))
    ms = []
    _ms = os.path.join(vd, 'measure_sweep.csv')
    if os.path.exists(_ms):
        with open(_ms, encoding='utf-8-sig', newline='') as f:
            ms = [x for x in csv.DictReader(f) if x.get('result') != 'NA']
    dsr = []
    _dsr = os.path.join(vd, 'display_sort.csv')
    if os.path.exists(_dsr):
        with open(_dsr, encoding='utf-8-sig', newline='') as f:
            dsr = list(csv.DictReader(f))
    bgs = []
    _bgs = os.path.join(vd, 'bg_style.csv')
    if os.path.exists(_bgs):
        with open(_bgs, encoding='utf-8-sig', newline='') as f:
            bgs = [x for x in csv.DictReader(f) if x.get('result') != 'NA']
    mbs = []
    _mbs = os.path.join(vd, 'measure_by_site.csv')
    if os.path.exists(_mbs):
        with open(_mbs, encoding='utf-8-sig', newline='') as f:
            mbs = list(csv.DictReader(f))
    clv = []
    _clv = os.path.join(vd, 'combo_live.csv')
    if os.path.exists(_clv):
        with open(_clv, encoding='utf-8-sig', newline='') as f:
            clv = list(csv.DictReader(f))
    sac = []
    _sac = os.path.join(vd, 'save_audit_cols.csv')
    if os.path.exists(_sac):
        with open(_sac, encoding='utf-8-sig', newline='') as f:
            sac = [x for x in csv.DictReader(f) if x.get('result') != 'NA']
    acl = []
    _acl = os.path.join(vd, 'all_cols.csv')
    if os.path.exists(_acl):
        with open(_acl, encoding='utf-8-sig', newline='') as f:
            acl = [x for x in csv.DictReader(f) if x.get('result') != 'NA']
    mks = []
    _mks = os.path.join(vd, 'master_sweep.csv')
    if os.path.exists(_mks):
        with open(_mks, encoding='utf-8-sig', newline='') as f:
            mks = [x for x in csv.DictReader(f) if x.get('result') != 'NA']
    brl = []
    _brl = os.path.join(vd, 'sp_branch_lit.csv')
    if os.path.exists(_brl):
        with open(_brl, encoding='utf-8-sig', newline='') as f:
            brl = list(csv.DictReader(f))
    dbr = []
    _dbr = os.path.join(vd, 'db_ref.csv')
    if os.path.exists(_dbr):
        with open(_dbr, encoding='utf-8-sig', newline='') as f:
            dbr = list(csv.DictReader(f))
    tsu = []
    _tsu = os.path.join(vd, 'titleset.csv')
    if os.path.exists(_tsu):
        with open(_tsu, encoding='utf-8-sig', newline='') as f:
            tsu = [x for x in csv.DictReader(f) if x.get('result') != 'NA']
    act = []; casc = []
    _co = os.path.join(vd, 'combo_oracle.json')
    if os.path.exists(_co):
        with open(_co, encoding='utf-8') as f:
            _rs = json.load(f).get('results', [])
            act = [x for x in _rs if x.get('active') and x.get('active') != 'NA']
            casc = [x for x in _rs if x.get('kind') in ('CASCADE', 'GRID_CASCADE')]
    if not pop and not auth and not sp and not a1 and not dml and not i18n and not lk and not act and not sci and not lg and not casc and not ms and not brl and not dbr and not tsu:
        print(f'[eg_ingest] {mid}: 결과 없음(팝업·권한 미실행) — 반입 생략'); return 0
    lp = os.path.join(vd, 'verify_ledger.csv')
    with open(lp, encoding='utf-8-sig', newline='') as f:
        rd = csv.DictReader(f); fields = rd.fieldnames; rows = [r for r in rd if not r['row_id'].startswith('EG-')]  # 이전 반입분은 다시 만든다
    out, unmapped = [], []
    modal_cols = meta_modal_cols(mid)  # CR-100 대상 셀 팝업 컬럼

    cur = {'mctx': None}  # P1(2026-11-06): 지금 반입 중인 검사기 결과 행의 측정 맥락
    def add(check_key, rule, target, cond, expected, asis, result, evidence, tag, defect=''):
        if '결함원장' not in (asis or '') and 'AS-IS' not in (asis or ''):  # FAIL 계약의 기대값 출처 — 이 검사기들은 3개 문서 결함 유형에서 나왔다(2026-11-02 CN 'Condition' 이 근거 없음 ERROR)
            asis = (asis + ' · ' if asis else '') + '결함원장 유형(Doc/verify/_engine_gap.csv)'
        r = {k: '' for k in fields}
        r.update({'row_id': rid(mid, check_key), 'source': 'RULE_SCREEN', 'family': rule[:1], 'rule_id': rule, 'target': target, 'condition': cond, 'expected': expected, 'asis_ref': asis, 'method': 'E2E', 'result': 'NOT_RUN', 'defect_ref': defect, 'area': tag})
        rows.append(r); out.append({'row_id': r['row_id'], 'result': result, 'evidence': evidence[:1500], 'tobe_ref': f'E2E @{tag}', 'mctx': cur.get('mctx')})

    for x in pop:
        cur['mctx'] = x.get('mctx') if isinstance(x, dict) else None
        if x.get('mut'):
            continue  # 변이 실행 결과는 공식 판정이 아니다
        check = x.get('check', ''); rule = popup_rule(check)
        if not rule:
            unmapped.append(check); continue
        res = x.get('result', 'ERROR'); ev = f"기대 {x.get('expected', '')} · 실제 {x.get('actual', '')} · 근거 {x.get('basis', '')}"
        if check == 'ORDER' and res == 'FAIL':  # 사용자 결정 — 정렬 기준 차이는 오류가 아니다(ORDER BY 자체가 없을 때만 FAIL 은 B3 행이 담당)
            res = '판정필요'; ev = '[SORT 기준 차이 → 판정필요] ' + ev  # judge SORT_REVIEW_TAG 와 같은 표시 — 판정필요로 남는다
        if res == 'FAIL' and cr100_hit(check, x, modal_cols):
            what = CR100_WHAT.get(check, '닫기(X) 아이콘 없음')
            res = 'PASS'; ev = f"{CR100_TAG} TO-BE 공통 팝업({str(x.get('cls')) if str(x.get('cls') or '') in CR100_COMMON_POPUPS else '메타 셀 팝업 FPModal·FPTextModal'}) 규칙 — {what} 는 결함 아님(사용자 판정 2026-11-10) · " + ev
        elif res == 'FAIL' and check == 'IDENTITY' and str(x.get('cls') or '') in CR100_COMMON_POPUPS and "제목 ''" in str(x.get('actual') or ''):
            res = '판정필요'; ev = f"{CR100_TAG} TO-BE 공통 사용자 팝업은 제목이 없어(CR-100) 제목 토큰으로 같은 팝업인지 식별 불가 — 결함 판정 보류 · " + ev  # T194
        add(f"P|{x.get('call')}|{x.get('trig')}|{check}", rule, f"{mid} 팝업 {x.get('cls', '')} {x.get('trig', '')} {check}", ' '.join(x.get('egs') or []), x.get('expected', ''), x.get('basis', ''), res, ev, 'eg-popup')
    for x in auth:
        cur['mctx'] = x.get('mctx') if isinstance(x, dict) else None
        eg = x.get('eg', ''); rule = AUTH_RULE.get(eg, '')
        if not rule:
            unmapped.append(eg); continue
        ev = f"기대 {x.get('expected', '')} · 실제 {x.get('actual', '')} · AS-IS {x.get('asis', '')}" + (f" · {x['note']}" if x.get('note') else '')
        add(f"A|{eg}|{x.get('target')}|{x.get('ctx')}", rule, f"{mid} {eg} {x.get('target', '')} {x.get('ctx', '')}".strip(), eg, x.get('expected', ''), x.get('asis', ''), x.get('result', 'ERROR'), ev, 'eg-auth')
    for x in sp:  # EG161 정적 대조 — 문구 다듬음·동적 SQL 을 못 가려 MISSING 은 FAIL 이 아니라 ERROR(사람이 근거로 확인) · 실제 분기 실행은 후속
        res = 'PASS' if x.get('verdict') == 'FOUND' else 'ERROR'
        ev = f"AS-IS {x.get('asis_ref')} '{x.get('asis_msg')}' · {x.get('tobe') or '[대응 문구 없음] TO-BE 저장 PROC·1단계 호출·사전·화면 코드에서 못 찾음 — 검증 분기 누락 또는 문구 변경 확인 필요'}"
        add(f"S|{x.get('asis_ref')}|{x.get('asis_msg')}", 'E4', f"{mid} SP 검증 {x.get('asis_msg', '')[:40]}", '저장 SP 검증 분기 정적 대조', 'AS-IS 검증 문구가 TO-BE 에 있음', x.get('asis_ref', ''), res, ev, 'sp-branch')
    for x in a1:  # EG006 실전송 인자 AS-IS 대조 — 차이는 판정필요(A1 · 원천 DB 시점 차이 가능)
        res = {'PASS': 'PASS', 'FAIL': 'FAIL', 'REVIEW': '판정필요', 'NA': 'NA'}.get(x.get('verdict'), 'ERROR')  # NA = 근거 있는 판정 제외(2026-11-16 asis_live_rows 계정 의존 SP)
        add(f"L|{x.get('sheet')}|{x.get('asis_sp')}", 'A7' if '행구성' in str(x.get('sheet')) else 'L1' if '조회시간' in str(x.get('sheet')) else 'A1', f"{mid} {'Measure 행 구성' if '행구성' in str(x.get('sheet')) else '실전송 건수'} {x.get('sheet', '')}", '화면 실전송 인자로 AS-IS 조회 SP 실행', '건수·키 집합 = AS-IS', x.get('asis_sp', ''), res, f"{x.get('detail', '')}{' · ' + x['note'] if x.get('note') else ''}", 'a1-live')
    for x in dml:  # EG238·EG230·EG223 정적 쓰기 대조 — 놓친 쓰기 경로가 있을 수 있어 ERROR(확인 대상) · FOUND 는 행을 만들지 않는다
        add(f"D|{x.get('table')}|{x.get('column')}", 'F8', f"{mid} SP 쓰기 {x.get('table', '')}.{x.get('column', '')}", '저장 SP 쓰기 컬럼 정적 대조', 'AS-IS 저장 SP 가 쓰는 컬럼을 TO-BE 도 씀', 'AS-IS 저장 SP', 'ERROR', f"[쓰기 대조 불일치] {x.get('verdict')} · {x.get('detail', '')}", 'sp-dml')
    for x in i18n:  # EG451·EG356·EG364 정적 — 화면 표시 여부를 재지 않아 ERROR(확인 대상)
        k = x.get('kind'); rule = 'I1' if k == 'DUP' else 'MS1'; lab = {'FE': '화면 고정 한글', 'DB': 'PROC 한글 문구', 'DUP': '같은 문구 다른 코드'}.get(k, k)
        add(f"I|{k}|{x.get('where')}|{x.get('text')}", rule, f"{mid} {lab} {x.get('text', '')[:30]}", '다국어 정적 점검', '등록 코드 사용 · 코드 재사용', x.get('where', ''), 'ERROR', f"[다국어 확인 필요] {lab} · {x.get('where')} · '{x.get('text')}'", 'i18n-static')
    for x in lk:  # EG066 Lookup 편집 후보
        add(f"L|{x.get('side')}|{x.get('target')}", 'B5', f"{mid} Lookup 후보 {x.get('target')} {x.get('side')}", f"Lookup {x.get('lookup_type')}", '편집 후보 = 활성 기준 코드 · 비활성·구코드 0', x.get('ref', ''), x.get('result', 'ERROR'), x.get('why', ''), 'lookup-check')
    for x in act:  # EG055 Active 정책
        add(f"A|{x.get('kind')}|{x.get('target')}", 'B4', f"{mid} Active 정책 {x.get('label') or x.get('target')} {x.get('kind')}", str(x.get('scenario', ''))[:200], '조회조건 = Y/N 전체 · 셀 콤보 = 사용 중만(CR-059)', str(x.get('asis_src', ''))[:200], x.get('active'), x.get('active_why', ''), 'active-policy')
    for x in sci:  # EG034 문자 정렬 키
        add(f"SCI|{x.get('proc')}", 'A6', f"{mid} 문자 정렬 {x.get('proc')}", 'TO-BE ORDER BY 문자 키', '대소문자 무시 · NULL 먼저(AS-IS 콜레이션)', x.get('order_by', '')[:200], x.get('result', 'ERROR'), x.get('why', ''), 'sort-ci')
    for x in lg:  # EG361 언어 전환
        add(f"LG|{x.get('lang')}", 'I2', f"{mid} 언어 전환 {x.get('lang')}", f"계정 언어 {x.get('lang')} 로 화면 표시", '라벨·버튼·헤더 = 그 언어 등록 문구', 'SCM_ADM_MSG_M', x.get('result', 'ERROR'), x.get('why', ''), 'i18n-lang')
    for x in casc:  # EG081 상위 값으로 좁힌 하위 후보
        add(f"CAS|{x.get('scenario')}|{x.get('target')}", 'C2' if x.get('kind') == 'GRID_CASCADE' else 'C1', f"{mid} 연쇄 후보 {x.get('target')}", str(x.get('scenario', ''))[:200], '상위 값으로 좁힌 하위 후보 = AS-IS 원천', str(x.get('asis_src', ''))[:200], x.get('b4', 'ERROR'), f"{x.get('why', '')} · TO-BE {x.get('tobe_n')}건 · AS-IS {x.get('asis_n')}건", 'cascade')
    for x in ms:  # EG453 Measure 기준 코드
        add(f"MS|{x.get('lookup_type')}", 'N1', f"{mid} Measure 기준 {x.get('lookup_type')}", 'Lookup 활성 코드 ↔ 원장 MEASURE', '오타·미사용 코드 없음', 'SCM_ADM_LOOKUP_MASTER_DETAIL', x.get('result', 'ERROR'), x.get('why', ''), 'measure-sweep')
    for x in dsr:  # EG053 콤보 후보 표시명 정렬
        add(f"DS|{x.get('label')}", 'B3', f"{mid} 후보 표시명 정렬 {x.get('label')}", '조회조건 콤보 후보 표시 순서', '숫자-영문-한글 · 대소문자 무시 오름차순', x.get('label', ''), x.get('result', 'ERROR'), x.get('why', ''), 'display-sort')
    for x in bgs:  # EG312 AS-IS 조건부 셀 색 규칙 ↔ TO-BE 스타일 코드(H2 정적)
        add(f"BGS|{x.get('method')}|{x.get('api')}|{x.get('color')}", 'H2', f"{mid} 조건부 셀 색 {x.get('method')} {x.get('api')} {x.get('color')}", f"AS-IS guard {(x.get('guard') or '')[:100]}", 'TO-BE 화면 코드에 조건부 셀 색 구현(조건·색 일치는 E2E H2)', f"{x.get('method')} {x.get('api')}", x.get('result', 'ERROR'), x.get('why', ''), 'bg-style')
    for x in mbs:  # EG068 Sales Site 유형별 입력 Measure 허용 목록(B5)
        add(f"MBS|{x.get('combo_id')}|{x.get('division')}|{x.get('site_type')}", 'B5', f"{mid} 사이트 유형별 Measure 후보 {x.get('combo_id')} {x.get('division')} {x.get('site_type')}", f"Sales Site 표본 {x.get('site')}(VMI/비축/고객향) 로 편집 Measure 콤보 SQL 실행", 'VMI→VMI_In_Req · 비축→AS_In_Req(VMI 제외) · 고객향→둘 다 제외 · MKT_FCST 계열 포함', x.get('combo_id', ''), x.get('result', 'ERROR'), x.get('why', ''), 'measure-by-site')
    for x in clv:  # EG075 콤보 응답 ↔ DB 최신 후보(B7)
        add(f"CL|{x.get('combo_id')}|{(x.get('body') or '')[:120]}", 'B7', f"{mid} 콤보 후보 최신성 {x.get('combo_id')}", f"요청 본문 그대로 DB 재실행(최신 원문 SQL) {(x.get('body') or '')[:100]}", '응답 코드 집합 = DB 실행 코드 집합(외부 변경 즉시 반영)', x.get('combo_id', ''), x.get('result', 'ERROR'), x.get('why', ''), 'combo-live')
    for x in sac:  # EG183 저장 뒤 감사 칸
        add(f"SAC|{x.get('target')}", 'F8', f"{mid} 저장 감사 칸 {x.get('target')}", '시험 저장 직전(AS OF) ↔ 저장 뒤 행', '수정 시 생성 칸 불변 · 값 변경 시 수정 칸 갱신', x.get('target', ''), x.get('result', 'ERROR'), x.get('why', ''), 'save-audit-cols')
    for x in acl:  # EG213 전 컬럼 선택 조회
        add(f"ACL|{x.get('proc')}|{x.get('sheet')}", 'F4', f"{mid} 전 컬럼 선택 조회 {x.get('sheet')}", '임시 사용자 칸 설정(선택 가능 칸 전부)으로 PROC 직접 실행', 'SQL 오류 0', x.get('proc', ''), x.get('result', 'ERROR'), x.get('why', ''), 'all-cols')
    for x in mks:  # EG455 기준정보 존재·활성 후보
        add(f"MK|{x.get('kind')}|{x.get('target')}", 'N1' if x.get('kind') == 'MASTER_KEY' else 'B4', f"{mid} {'기준정보 키 존재' if x.get('kind') == 'MASTER_KEY' else '콤보 후보 활성'} {x.get('target')}", 'AS-IS 기준표 키 ↔ TO-BE 기준표 · 콤보 후보 ↔ 활성 컬럼', 'AS-IS 키가 TO-BE 에 있음 · 비활성 코드 후보 제외', x.get('target', ''), x.get('result', 'ERROR'), x.get('why', ''), 'master_sweep')
    for x in brl:  # EG179 저장 SP 분기 리터럴 — 재작성 가능성이 있어 없음은 ERROR(확인 대상)
        add(f"BR|{x.get('sp')}", 'F1', f"{mid} 저장 분기 값 {x.get('sp')}", 'AS-IS 저장 SP 조건 리터럴 ↔ TO-BE 저장 PROC', 'AS-IS 분기 값이 TO-BE 에 있음', x.get('sp', ''), 'ERROR' if int(x.get('missing') or 0) else 'PASS', f"찾음 {x.get('found')}건 · 없음 {x.get('missing')}건" + (f" [확인 대상] {x.get('missing_list')}" if int(x.get('missing') or 0) else ''), 'sp-branch-lit')
    for x in dbr:  # EG142·EG143 DB 참조 정합
        add(f"DBR|{x.get('kind')}|{x.get('target')}", {'TEAM_SRC': 'B8', 'TEAM_VAL': 'B8', 'LABEL_AMP': 'H5', 'NULL_RULE': 'N1', 'LIKE_NULL': 'G1', 'NULL_JOIN': 'A1', 'EMPTY_EQ': 'A1', 'JSON_SHORT': 'F4', 'SELECT_INTO': 'F4', 'SRC_E4': 'E4', 'SRC_E3': 'E3', 'SRC_F4': 'F4', 'SRC_H8': 'H8'}.get(x.get('kind'), 'DB-SYN'), f"{mid} {'AS-IS 테이블 참조' if x.get('kind') == 'TB_FX' else '라벨 & 표기' if x.get('kind') == 'LABEL_AMP' else 'Team 원천' if x.get('kind') == 'TEAM_SRC' else 'Team 값 = SITE_ITEM.DEPT_ID' if x.get('kind') == 'TEAM_VAL' else '저장 NULL 규칙' if x.get('kind') == 'NULL_RULE' else 'NULL 행 탈락 LIKE' if x.get('kind') == 'LIKE_NULL' else '콤보 SQL 실존'} {x.get('target')}", '소스·메타 정적 점검', 'TB_FX_* 참조 0 · ATTRIBUTE9 = 실존 콤보 SQL_ID', 'SCM_ADM_CMBO_SQL_M · ALL_SOURCE', x.get('result', 'ERROR'), x.get('why', ''), 'db-ref')
    for x in tsu:  # EG025·EG399 사용자 칸 설정 정합
        mig = x.get('kind') == 'TITLESET_MIG'
        add(f"TSU|{x.get('kind')}|{x.get('target')}", 'K2' if mig or x.get('kind') == 'MEASURE_ORDER' else 'A5', f"{mid} {'Measure 표시 순서' if x.get('kind') == 'MEASURE_ORDER' else '사용자 칸 설정 이관 건수' if mig else '칸 설정 보유 사용자 필수 컬럼'} {x.get('target')}", 'SCM_MST_TITLESET_USER 정적 대조', '이관 대상 행 전부 존재' if mig else '보유 사용자 필수 컬럼 미보유 0', 'SCM_MST_TITLESET_USER · SCM_MST_SHEET_COLUMNS', x.get('result', 'ERROR'), x.get('why', ''), 'titleset')
    # 같은 키가 여러 번(시트·재측정) 나오면 마지막 결과를 쓴다
    seen = {}
    for r in rows:
        seen[r['row_id']] = r
    rows = list(seen.values()); last = {o['row_id']: o for o in out}
    # 적용성(applicability) — 이 단계에서 새로 생긴 EG- 행은 ledger.py 의 적용성 판정을 거치지 않아 applicable 이 비었다(2026-11-07 SCP0016 E3 14행: 저장 없는 조회 화면인데 판정필요)
    try:
        sys.path.insert(0, os.path.dirname(os.path.abspath(__file__))); import applicability as _AP
        need = [r for r in rows if not (r.get('applicable') or '').strip()]
        if need:
            cnt, _ = _AP.apply(need, mid, '')
            print(f"[eg_ingest] 적용성 보충 {len(need)}행 → {cnt}")
    except Exception as _ex:
        print(f'[eg_ingest] 적용성 보충 실패(무시): {_ex}')
    _buf = io.StringIO(newline='')
    w = csv.DictWriter(_buf, fieldnames=fields); w.writeheader(); w.writerows(rows)
    safe_io.write_text(lp, _buf.getvalue(), 'utf-8-sig', log=print)
    ej = os.path.join(vd, 'e2e_results.json'); prev = load(ej); keep = [e for e in prev if not str(e.get('row_id', '')).startswith('EG-')]
    safe_io.write_text(ej, json.dumps(keep + list(last.values()), ensure_ascii=False, indent=1).replace('\n', os.linesep), 'utf-8', log=print)
    import collections
    print(f"[eg_ingest] {mid}: 팝업 {len(pop)}건·권한 {len(auth)}건·SP 문구 {len(sp)}건 → 원장 행 {len(last)} · 결과 {dict(collections.Counter(o['result'] for o in last.values()))}" + (f" · 규칙 대응 없음 {sorted(set(unmapped))}" if unmapped else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main())
