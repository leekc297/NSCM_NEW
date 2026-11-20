# -*- coding: utf-8 -*-
"""스냅샷 기대 템플릿(AS-IS 유래 부분 기대) 생성 — Doc/verify/<ID>/snap/expected/<key>.json (2026-11-06 플랜 3-4)
  python tools/Harness/verify/snap_expect.py <ID>
원천(추측 없음): tools/Harness/rules/search_cond.csv(menu_id=ID usage=USE · tobe_seq·tobe_name·tobe_type1·tobe_type2) → 조회조건 라벨·순서·컨트롤 종류
                Doc/e2e/specs/<ID>.plan.json expectedCols[sheet][div] 또는 mainSheets[].labels → 헤더 컬럼 라벨 · accounts[0].expectedBtns·menuBtnCodes → 버튼 코드
                tools/Harness/rules/label_alias.csv(CR-092 Valid→Active) · 필수표시 '*' 는 뗀다(CR-077)
팝업·화면샷은 AS-IS 유래 기대가 없다(사람 확인) — expected 에 kind 만 기록.
"""
import csv, json, os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
P = lambda *a: os.path.join(ROOT, *a)
ROLE = {'선택': ['combobox', 'button', 'listbox'], '텍스트': ['textbox'], '체크박스': ['checkbox'], '라디오버튼': ['radio', 'radiogroup'], '버튼': ['button']}


def rd(p):
    if not os.path.exists(p):
        return []
    with open(p, encoding='utf-8-sig', newline='') as f:
        return list(csv.DictReader(f))


def safe_key(s):
    return re.sub(r'^_+|_+$', '', re.sub(r'[^A-Za-z0-9가-힣._-]+', '_', s))[:80]


def alias_map():
    out = {}
    for r in rd(P('tools', 'Harness', 'rules', 'label_alias.csv')):
        if r.get('asis_label') and r.get('tobe_label'):
            out[r['asis_label'].strip().lower()] = r['tobe_label'].strip()
    return out


def clean_label(s, al):
    s = re.sub(r'^\s*\*+\s*|\s*\*+\s*$', '', str(s or '')).strip()
    return al.get(s.lower(), s)


def prsl_cols(mid, sheet, user, div):
    """개인화 그리드(SHEET_PRSL_YN=Y)면 BE 와 같은 SP(PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST) 출력의 표시 컬럼(DISPLAY_FLAG=Y · VISIBLE_FLAG<>N) 라벨을 표시 순서대로 돌려준다.
    개인화 대상이 아니거나 DB 를 못 읽으면 None(→ 메타 기대로 폴백). SP 는 개인화 행이 없을 때 기본 행을 INSERT 하므로 호출 뒤 ROLLBACK(시험 계정 설정을 만들지 않는다)."""
    if not user or not sheet:
        return None
    try:
        sys.path.insert(0, P('tools', 'DbConn'))
        import dbconn, oracledb  # noqa: E402
        cx = dbconn.connect('tobe'); cur = cx.cursor()
        try:
            cur.execute("SELECT MAX(SEGMENT3) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL WHERE LOOKUP_TYPE = 'SHEET_PRSL_YN' AND SEGMENT1 = :m AND SEGMENT2 = :s", m=mid, s=sheet)
            if (cur.fetchone() or [None])[0] != 'Y':
                return None
            cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE USER_ID = :u AND PROGRAM_ID = :m AND SHEET_NAME = :s AND USER_INQUIRY_COLUMN_TYPE_CODE = 'C'", u=user, m=mid, s=sheet)
            n_user = cur.fetchone()[0]
            rc = cur.var(oracledb.CURSOR)
            cur.callproc('SCM_MGR.PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST', [user, mid, sheet, (div or None), rc])
            rs = rc.getvalue(); names = [d[0] for d in rs.description]; rows = [dict(zip(names, r)) for r in rs.fetchall()]
        finally:
            cx.rollback(); cx.close()
        if 'DISPLAY_FLAG' not in names:
            return None
        shown = [r for r in rows if (r.get('DISPLAY_FLAG') or '') == 'Y' and (r.get('VISIBLE_FLAG') or 'Y') != 'N']
        return {'labels': [str(r.get('COLUMN_LABEL_NAME') or r.get('COLUMN_NAME') or '') for r in shown], 'columns': [str(r.get('COLUMN_NAME') or '') for r in shown], 'user_rows': n_user,
                'hidden_by_user': [str(r.get('COLUMN_NAME') or '') for r in rows if (r.get('DISPLAY_FLAG') or '') != 'Y' and (r.get('VISIBLE_FLAG') or 'Y') != 'N'], 'sp': 'PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST', 'user': user, 'div': div}
    except Exception as ex:  # DB 미접속 등 — 메타 기대로 폴백(사유는 출력)
        print(f'[snap_expect] 개인화 SP 조회 실패({mid}/{sheet}/{user}): {str(ex)[:120]} → 메타 기대 사용')
        return None


def main():
    if len(sys.argv) < 2:
        print(__doc__); return 2
    mid = sys.argv[1].upper()
    od = P('Doc', 'verify', mid, 'snap', 'expected'); os.makedirs(od, exist_ok=True)
    for f in os.listdir(od):
        try: os.remove(os.path.join(od, f))
        except OSError: pass
    al = alias_map()
    try:
        plan = json.load(open(P('Doc', 'e2e', 'specs', f'{mid}.plan.json'), encoding='utf-8'))
    except (OSError, ValueError):
        print(f'[snap_expect] {mid}: plan.json 없음 — gen-e2e.js 먼저'); return 2
    sc = sorted([s for s in rd(P('tools', 'Harness', 'rules', 'search_cond.csv')) if (s.get('menu_id') or '').upper() == mid and (s.get('usage') or '').upper() == 'USE'], key=lambda s: int(s.get('tobe_seq') or 0))
    conds = [{'seq': int(s.get('tobe_seq') or 0), 'label': clean_label(s.get('tobe_name'), al), 'type1': s.get('tobe_type1') or '', 'type2': s.get('tobe_type2') or '', 'roles': ROLE.get(s.get('tobe_type1') or '', []),
              'popup': bool((s.get('tobe_popup_code') or s.get('asis_popup_name') or '').strip()), 'src': f"search_cond.csv {mid} tobe_seq={s.get('tobe_seq')}"} for s in sc]
    if not conds:  # 기준표 없는 화면 — plan.condOrder(기준표 유래가 아니면 AS-IS 라벨)
        conds = [{'seq': i + 1, 'label': clean_label(l, al), 'type1': '', 'type2': '', 'roles': [], 'popup': False, 'src': 'plan.json condOrder'} for i, l in enumerate(plan.get('condOrder') or [])]
    divs = []
    s0 = plan.get('sample', {}).get('div')
    if s0: divs.append(str(s0))
    for a in plan.get('accounts') or []:
        for d in a.get('divisions') or []:
            if str(d) not in divs: divs.append(str(d))
    divs = divs[:3] or ['']
    n = 0
    for d in divs:
        scope = f'Div {d}' if d else 'Div'
        json.dump({'kind': '조회조건', 'scope': scope, 'items': conds, 'order_rule': 'CR-071(기준표 tobe_seq 순서)', 'note': 'Div 별 표시 차이(G4 Div 분기)는 사람 확인'}, open(os.path.join(od, safe_key(f'조회조건_{scope}') + '.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1); n += 1
        btns = [str(b).upper() for b in ((plan.get('accounts') or [{}])[0].get('expectedBtns') or plan.get('menuBtnCodes') or [])]
        json.dump({'kind': '버튼', 'scope': scope, 'codes': btns, 'asis_buttons': [b for b in (plan.get('buttons') or []) if (b.get('kind') or '') != 'n/a'], 'src': 'plan.json accounts[0].expectedBtns / menuBtnCodes(btn_auth) · buttons(AS-IS 메서드)',
                   'note': '코드 ↔ 표시명은 접두 일치(SEARCH~Search(F5)) · MEASURE_SELECT~Measure'}, open(os.path.join(od, safe_key(f'버튼_{scope}') + '.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1); n += 1
    ec = plan.get('expectedCols') or {}
    # 개인화 그리드(SHEET_PRSL_YN=Y · SCM_MST_TITLESET_USER 'C' 행)는 시험 계정의 개인화가 헤더를 결정한다 — BE 와 같은 SP(PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST)로 기대를 만든다
    #   (2026-11-06 SCP0016 헤더 'Team' 누락 = minyonglee1 개인화 11-02 17:57 행(Team 제외·To Site 순서) — 메타 기준 기대와 어긋나던 원인)
    try:
        sev = json.load(open(P('Doc', 'verify', mid, 'scenario_env.json'), encoding='utf-8'))
        snap_user = ((sev.get('default_account') or {}).get('user') or sev.get('user') or '').strip()
    except Exception:
        snap_user = ''
    # TO-BE 메타가 숨긴 컬럼(SHEET_COLUMNS VISIBLE_FLAG=N) — AS-IS 라벨 기대에 있어도 '메타 숨김(설계 결정 확인)' 으로 분류(smoke A5 와 같은 기준 · judge R37_NA)
    meta_hidden = sorted({clean_label(c.get('column_label_name'), al) for c in rd(P('Doc', 'tobefacts', 'db', 'sheet_columns.csv')) if (c.get('program_id') or '').upper() == mid and (c.get('visible_flag') or 'Y').upper() == 'N'})
    sheets = plan.get('mainSheets') or [{'name': 'main', 'labels': []}]
    for sh in sheets:
        name = sh.get('name') or 'main'
        cols = []
        src = ''
        prsl = None
        for d in divs:
            prsl = prsl_cols(mid, name, snap_user, d)
            if prsl is not None:
                cols = [clean_label(x, al) for x in prsl['labels']]; src = f"PR_GET_SHEET_COLUMN_LIST(user={snap_user} · div={d} · 개인화 {prsl['user_rows']}행 · SHEET_PRSL_YN=Y) — TO-BE BE 와 같은 SP 출력(DISPLAY_FLAG=Y 순)"; break
            lst = (ec.get(name) or {}).get(d) or []
            if lst:
                cols = [clean_label(x, al) for x in lst]; src = f'plan.json expectedCols[{name}][{d}](SHEET_COLUMNS)'; break
        if not cols:
            cols = [clean_label(x, al) for x in (sh.get('labels') or [])]; src = f'plan.json mainSheets[{name}].labels(AS-IS 헤더)'
        json.dump({'kind': '헤더', 'scope': name, 'columns': cols, 'meta_hidden': meta_hidden, 'headerSpec': plan.get('headerSpec'), 'dynamicHeader': bool(plan.get('dynamicHeader')), 'src': src, 'personalized': prsl,
                   'note': '동적 기간 컬럼은 {YM}/{YMD}/{W} 토큰 · TO-BE 추가 컬럼(이름 컬럼 등)은 extra 로 보고(결함 아님 · 사람 확인)'}, open(os.path.join(od, safe_key(f'헤더_{name}') + '.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1); n += 1
    print(f"[snap_expect] {mid}: 기대 {n}건 → Doc/verify/{mid}/snap/expected/ (조회조건 {len(conds)}개 · Div {divs} · 시트 {[s.get('name') for s in sheets]})")
    return 0


if __name__ == '__main__':
    sys.exit(main())
